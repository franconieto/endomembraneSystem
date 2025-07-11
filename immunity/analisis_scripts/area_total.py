import os
import re
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Configuración
base_output_dir = r"C:\Users\fniet\OneDrive\Documentos\GitHub\endomembraneSystem\immunity\output\output_jobID_90453_2025-07-09"
output_dir = os.path.join(base_output_dir, "analisis_output_totalRabs")
os.makedirs(output_dir, exist_ok=True)
rab_columns = ['RabA', 'RabB', 'RabC', 'RabD', 'RabE', 'RabF', 'RabG', 'RabH', 'RabI', 'xER', 'xPM']

def identificar_grupo(sim_path):
    for f in os.listdir(sim_path):
        if f.startswith('InputIntrTransport3.csv'):
            return 'control'
        m = re.match(r'InputIntrTransp.*?([a-zA-Z0-9\-\._]+)\.csv', f)
        if m and 'maduration-0.1' in f:
            return 'maduration-0.1'
        elif m:
            sufijo = m.group(1)
            if sufijo != '3':
                return sufijo
    return None

def recolectar_simulaciones(base_output_dir):
    grupos = {}
    for sim_dir in os.listdir(base_output_dir):
        sim_path = os.path.join(base_output_dir, sim_dir)
        if not os.path.isdir(sim_path):
            continue
        grupo = identificar_grupo(sim_path)
        if grupo:
            rabs_path = os.path.join(sim_path, 'totalRabs.csv')
            if os.path.exists(rabs_path):
                if grupo not in grupos:
                    grupos[grupo] = []
                grupos[grupo].append((sim_dir, rabs_path))
    return grupos

def calcular_porcentajes(df, rab_columns):
    rab_cols = [col for col in rab_columns if col in df.columns]
    df_rabs = df[rab_cols]
    total = df_rabs.sum(axis=1)
    porcentajes = df_rabs.divide(total, axis=0) * 100
    porcentajes['tick'] = df['tick']
    return porcentajes

def plot_stacked_area(df, rab_columns, sim_name, grupo, out_path):
    rab_cols = [col for col in rab_columns if col in df.columns]
    ticks = df['tick']
    data = [df[col] for col in rab_cols]
    plt.figure(figsize=(10, 5))
    plt.stackplot(ticks, data, labels=rab_cols, alpha=0.8)
    plt.ylim(0, 100)
    plt.title(f"{grupo} - Proporción de Rabs - {sim_name}")
    plt.xlabel("Tick")
    plt.ylabel("Porcentaje (%)")
    handles, labels = plt.gca().get_legend_handles_labels()
    order = [rab_cols.index(col) for col in rab_cols]
    plt.legend([handles[i] for i in order], [labels[i] for i in order], loc='upper left')
    # Etiquetas en el centro de cada área, desfasadas en X
    n = len(rab_cols)
    tick_positions = np.linspace(ticks.iloc[len(ticks)//4], ticks.iloc[3*len(ticks)//4], n)
    bottom = np.zeros(len(ticks))
    for i, (col, x_pos) in enumerate(zip(rab_cols, tick_positions)):
        area = np.array(df[col])
        idx = (np.abs(ticks - x_pos)).argmin()
        mid_val = (bottom[idx] + area[idx]/2)
        plt.text(x_pos, mid_val, col, ha='center', va='center', fontsize=10, bbox=dict(facecolor='none', edgecolor='none'))
        bottom += area
    plt.tight_layout()
    plt.savefig(out_path)
    plt.close()

def plot_stacked_area_promedio(df_list, rab_columns, grupo, out_path):
    # Solo ticks comunes a todas las simulaciones
    ticks_comunes = sorted(set.intersection(*(set(df['tick']) for df in df_list)))
    if not ticks_comunes:
        return
    ticks_comunes = np.array(ticks_comunes)
    rab_cols = [col for col in rab_columns if col in df_list[0].columns]
    promedios = {col: [] for col in rab_cols}
    for tick in ticks_comunes:
        vals = [df[df['tick'] == tick][rab_cols].values[0] for df in df_list]
        vals = np.array(vals)
        promedios_tick = np.nanmean(vals, axis=0)
        for i, col in enumerate(rab_cols):
            promedios[col].append(promedios_tick[i])
    plt.figure(figsize=(10, 5))
    plt.stackplot(ticks_comunes, [promedios[col] for col in rab_cols], labels=rab_cols, alpha=0.8)
    plt.ylim(0, 100)
    plt.title(f"{grupo} - Proporción promedio de Rabs")
    plt.xlabel("Tick")
    plt.ylabel("Porcentaje (%)")
    handles, labels = plt.gca().get_legend_handles_labels()
    order = [rab_cols.index(col) for col in rab_cols]
    plt.legend([handles[i] for i in order], [labels[i] for i in order], loc='upper left')
    # Etiquetas en el centro de cada área, desfasadas en X
    n = len(rab_cols)
    tick_positions = np.linspace(ticks_comunes[len(ticks_comunes)//4], ticks_comunes[3*len(ticks_comunes)//4], n)
    bottom = np.zeros(len(ticks_comunes))
    for i, (col, x_pos) in enumerate(zip(rab_cols, tick_positions)):
        idx = (np.abs(ticks_comunes - x_pos)).argmin()
        mid_val = (bottom[idx] + np.array(promedios[col])[idx]/2)
        plt.text(x_pos, mid_val, col, ha='center', va='center', fontsize=10, bbox=dict(facecolor='none', edgecolor='none'))
        bottom += np.array(promedios[col])
    plt.tight_layout()
    plt.savefig(out_path)
    plt.close()

def plot_barras_final(df, rab_columns, sim_name, grupo, out_path):
    rab_cols = [col for col in rab_columns if col in df.columns]
    valores = [df[col].iloc[-1] for col in rab_cols]
    ymax = max(valores) * 1.1 if max(valores) > 0 else 10
    plt.figure(figsize=(10, 5))
    bars = plt.bar(rab_cols, valores)
    plt.ylim(0, ymax)
    plt.title(f"{grupo} - Porcentaje final de Rabs - {sim_name}")
    plt.ylabel("Porcentaje (%)")
    plt.xlabel("Rab")
    for bar, val in zip(bars, valores):
        plt.text(bar.get_x() + bar.get_width()/2, val + 3, f"{val:.1f}%", ha='center', va='bottom', fontsize=10)
    plt.tight_layout()
    plt.savefig(out_path)
    plt.close()

def plot_barras_promedio(df_list, rab_columns, grupo, out_path):
    rab_cols = [col for col in rab_columns if col in df_list[0].columns]
    valores = np.array([[df[col].iloc[-1] for col in rab_cols] for df in df_list])
    medias = np.nanmean(valores, axis=0)
    stds = np.nanstd(valores, axis=0)
    ymax = np.max(medias + stds) * 1.1 if np.max(medias + stds) > 0 else 10
    plt.figure(figsize=(10, 5))
    bars = plt.bar(rab_cols, medias, yerr=stds, capsize=5)
    plt.ylim(0, ymax)
    plt.title(f"{grupo} - Porcentaje final promedio de Rabs")
    plt.ylabel("Porcentaje (%)")
    plt.xlabel("Rab")
    for bar, val, std in zip(bars, medias, stds):
        plt.text(bar.get_x() + bar.get_width()/2, val + std + 3, f"{val:.1f}%", ha='center', va='bottom', fontsize=10)
    plt.tight_layout()
    plt.savefig(out_path)
    plt.close()

def agrupar_graficos_individuales(fig_paths, output_dir, figs_per_page=6):
    n = len(fig_paths)
    pages = int(np.ceil(n / figs_per_page))
    for page in range(pages):
        fig, axs = plt.subplots(3, 2, figsize=(14, 15))
        axs = axs.flatten()
        for i in range(figs_per_page):
            idx = page * figs_per_page + i
            ax = axs[i]
            if idx < n:
                img = plt.imread(fig_paths[idx])
                ax.imshow(img)
                ax.set_title(os.path.basename(fig_paths[idx]).replace('.png', ''))
                ax.axis('off')
            else:
                ax.axis('off')
        plt.tight_layout()
        out_path = os.path.join(output_dir, f"simulaciones_individuales_pagina_{page+1}.png")
        plt.savefig(out_path, dpi=200)
        plt.close()

def agrupar_barras_individuales(fig_paths, output_dir, figs_per_page=6):
    n = len(fig_paths)
    pages = int(np.ceil(n / figs_per_page))
    for page in range(pages):
        fig, axs = plt.subplots(3, 2, figsize=(14, 15))
        axs = axs.flatten()
        for i in range(figs_per_page):
            idx = page * figs_per_page + i
            ax = axs[i]
            if idx < n:
                img = plt.imread(fig_paths[idx])
                ax.imshow(img)
                ax.set_title(os.path.basename(fig_paths[idx]).replace('.png', ''))
                ax.axis('off')
            else:
                ax.axis('off')
        plt.tight_layout()
        out_path = os.path.join(output_dir, f"barras_individuales_pagina_{page+1}.png")
        plt.savefig(out_path, dpi=200)
        plt.close()

def agrupar_graficos_promedios(fig_paths, output_dir):
    n = len(fig_paths)
    fig, axs = plt.subplots(n, 1, figsize=(12, 5*n))
    if n == 1:
        axs = [axs]
    for i, path in enumerate(fig_paths):
        img = plt.imread(path)
        axs[i].imshow(img)
        axs[i].set_title(os.path.basename(path).replace('.png', ''))
        axs[i].axis('off')
    plt.tight_layout()
    out_path = os.path.join(output_dir, "promedios_por_grupo.png")
    plt.savefig(out_path, dpi=200)
    plt.close()

def agrupar_barras_promedios(fig_paths, output_dir):
    n = len(fig_paths)
    fig, axs = plt.subplots(n, 1, figsize=(12, 5*n))
    if n == 1:
        axs = [axs]
    for i, path in enumerate(fig_paths):
        img = plt.imread(path)
        axs[i].imshow(img)
        axs[i].set_title(os.path.basename(path).replace('.png', ''))
        axs[i].axis('off')
    plt.tight_layout()
    out_path = os.path.join(output_dir, "barras_promedios_por_grupo.png")
    plt.savefig(out_path, dpi=200)
    plt.close()

def plot_barras_comparativas_grupos(sim_por_grupo, rab_columns, output_path):
    grupos = list(sim_por_grupo.keys())
    rab_cols = [col for col in rab_columns if any(col in df.columns for dfs in sim_por_grupo.values() for df in dfs)]
    n_grupos = len(grupos)
    n_rabs = len(rab_cols)
    medias = []
    stds = []
    for grupo in grupos:
        valores = np.array([[df[col].iloc[-1] for col in rab_cols] for df in sim_por_grupo[grupo]])
        medias.append(np.nanmean(valores, axis=0))
        stds.append(np.nanstd(valores, axis=0))
    medias = np.array(medias)  # shape: (n_grupos, n_rabs)
    stds = np.array(stds)
    x = np.arange(n_rabs)
    width = 0.8 / n_grupos  # ancho de cada barra
    plt.figure(figsize=(max(10, n_rabs*1.2), 6))
    colors = plt.cm.tab10.colors if n_grupos <= 10 else None
    ymax = np.max(medias + stds) * 1.1 if np.max(medias + stds) > 0 else 10
    for i, grupo in enumerate(grupos):
        offset = (i - (n_grupos-1)/2) * width
        bars = plt.bar(x + offset, medias[i], width, yerr=stds[i], capsize=5, label=grupo, color=colors[i] if colors else None)
        for bar, val in zip(bars, medias[i]):
            plt.text(bar.get_x() + bar.get_width()/2, val + 3, f"{val:.1f}%", ha='center', va='bottom', fontsize=10)
    plt.xticks(x, rab_cols)
    plt.ylim(0, ymax)
    plt.xlabel("Rab")
    plt.ylabel("Porcentaje (%)")
    plt.title("Porcentaje final promedio de Rabs por grupo")
    plt.legend(title="Grupo")
    plt.tight_layout()
    plt.savefig(output_path, dpi=200)
    plt.close()

# --- PROCESAMIENTO PRINCIPAL ---

grupos_archivos = recolectar_simulaciones(base_output_dir)
sim_por_grupo = {}
prom_paths_stacked = []
prom_paths_barras = []

for grupo, sims in grupos_archivos.items():
    grupo_dir = os.path.join(output_dir, grupo)
    os.makedirs(grupo_dir, exist_ok=True)
    fig_paths_stacked = []
    fig_paths_barras = []
    sim_por_grupo[grupo] = []
    # Procesar cada simulación solo una vez
    for sim_name, csv_path in sims:
        df = pd.read_csv(csv_path)
        df = df.reset_index(drop=True)
        df['tick'] = df.index * 100  # Genera la columna tick correctamente
        porcentajes = calcular_porcentajes(df, rab_columns)
        # Stacked individual
        out_path_stacked = os.path.join(grupo_dir, f"{sim_name}_stacked.png")
        plot_stacked_area(porcentajes, rab_columns, sim_name, grupo, out_path_stacked)
        fig_paths_stacked.append(out_path_stacked)
        # Barras individual
        out_path_barras = os.path.join(grupo_dir, f"{sim_name}_barras.png")
        plot_barras_final(porcentajes, rab_columns, sim_name, grupo, out_path_barras)
        fig_paths_barras.append(out_path_barras)
        # Guardar para promedios
        sim_por_grupo[grupo].append(porcentajes)
    # Agrupar individuales en páginas de 6, solo para este grupo
    agrupar_graficos_individuales(fig_paths_stacked, grupo_dir, figs_per_page=6)
    agrupar_barras_individuales(fig_paths_barras, grupo_dir, figs_per_page=6)
    # Graficar promedios por grupo
    prom_out_path_stacked = os.path.join(output_dir, f"{grupo}_promedio_stacked.png")
    plot_stacked_area_promedio(sim_por_grupo[grupo], rab_columns, grupo, prom_out_path_stacked)
    prom_paths_stacked.append(prom_out_path_stacked)
    prom_out_path_barras = os.path.join(output_dir, f"{grupo}_barras_promedio.png")
    plot_barras_promedio(sim_por_grupo[grupo], rab_columns, grupo, prom_out_path_barras)
    prom_paths_barras.append(prom_out_path_barras)

# Agrupar promedios en una sola figura
agrupar_graficos_promedios(prom_paths_stacked, output_dir)
agrupar_barras_promedios(prom_paths_barras, output_dir)

# Graficar barras promedio para todos los grupos juntos (opcional)
# Junta todos los dataframes de todas las simulaciones de todos los grupos
todos_los_df = []
for grupo in sim_por_grupo:
    todos_los_df.extend(sim_por_grupo[grupo])
plot_barras_promedio(
    todos_los_df,
    rab_columns,
    "todos_los_grupos",
    os.path.join(output_dir, "barras_promedio_todos_los_grupos.png")
)
# Gráfico comparativo de barras de promedios de todos los grupos
plot_barras_comparativas_grupos(
    sim_por_grupo,
    rab_columns,
    os.path.join(output_dir, "barras_promedio_comparativo_grupos.png")
)