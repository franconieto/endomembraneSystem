

package immunity;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;
import java.util.Set;
import java.util.TreeMap;

import javax.swing.JPanel;
import javax.swing.table.TableModel;

import repast.simphony.context.Context;
import repast.simphony.engine.environment.RunEnvironment;
import repast.simphony.engine.environment.RunState;
import repast.simphony.engine.schedule.ScheduledMethod;
import repast.simphony.parameter.Parameters;
import repast.simphony.space.continuous.ContinuousSpace;
import repast.simphony.space.grid.Grid;
import repast.simphony.ui.table.AgentTableFactory;
import repast.simphony.ui.table.SpreadsheetUtils;
import repast.simphony.ui.table.TablePanel;
import repast.simphony.util.ContextUtils;
import repast.simphony.util.FileUtils;

import java.util.HashSet;

public class Results {
	/*	
	 * This class is used to generate the results of the simulation.  It generates
	 * a file with the content distribution of all the organelles in the system
	 * and the total amount of each membrane domain in the system every 100 ticks
	 * It also generates a file with the content of each endosome
	 * that contains a marker (soluble or membrane).
	 * Every 1000 ticks it store the organelles, PM, ER, and cytosol content to be used for future simulation
	 *  (freeze and dry
	 * 
	 * 
		
	*/
	private static ContinuousSpace<Object> space;
	private static Grid<Object> grid;
	static Set<String> digestedKeys = new HashSet<>();

	ModelProperties cellProperties = ModelProperties.getInstance();

	public HashMap<String, Double> cellK = cellProperties.getCellK();
	public Set<String> solubleMet = cellProperties.getSolubleMet();
	public Set<String> membraneMet = cellProperties.getMembraneMet();
	public Set<String> rabSet = cellProperties.getRabSet();
	static TreeMap<String, Double> contentDist = new TreeMap<String, Double>((String.CASE_INSENSITIVE_ORDER));

	static HashMap<String, Double> totalRabs = new HashMap<String, Double>();	
	static HashMap<String, Double> totalVolumeRabs = new HashMap<String, Double>();
	static HashMap<String, Double> initialTotalRabs = new HashMap<String, Double>();
	static HashMap<String, Double> initialTotalSolubleCargo = new HashMap<String, Double>();
	static HashMap<String, Double> initialTotalMembraneCargo = new HashMap<String, Double>();

	static HashMap<String, Double> cisternsArea = new HashMap<String, Double>();
	public HashMap<String, Double> singleEndosomeContent = new HashMap<String, Double>();
	
	
	static Results	instance;
	LocalPath mainpath=LocalPath.getInstance(); 
	String ITResultsPath = mainpath.getPathResultsIT(); 	
	String MarkerResultsPath =mainpath.getPathResultsMarkers();
	String TotalRabs = mainpath.getPathTotalRabs();
	String cisternsAreaPath = mainpath.getPathCisternsArea();
	String mypathTable = mainpath.getMyPathOut();// agregado para que el output del excel no creara nuevos folders
	String digestedPath = mainpath.getPathDigested();
	
	public static Results getInstance() {
		if (instance == null) {
			throw new IllegalStateException("Results is not initialized yet. Build context first.");
		}
		return instance;
	}
	
	//Constructor.  It is called once from CellBuilder
	public Results(ContinuousSpace<Object> sp, Grid<Object> gr, HashMap<String, Double> totalRabs, HashMap<String, Double> initialTotalRabs)
	{
		this.space = sp;
		this.grid = gr;
		instance = this;
		// Generate a file with the header of the variables that are going to be followed
		//along the simulation.  Up to now= content distribution according to rabs contents.
		Parameters parm = RunEnvironment.getInstance().getParameters();
		String inputFile =(String) parm.getValue("inputFile");

//		Copy the input file from data to folder with the Results
	{
	File source = new File(LocalPath.getInstance().getPathInputIT()+inputFile);
	File dest = new File(LocalPath.getInstance().getMyPathOut()+inputFile);
	//System.out.print*ln(source.toString() + dest.toString());
	    try {
			FileUtils.copyFile(source, dest);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    }
//	Copy the inputFrozenEndosomes file from data to folder with the Results
	{
	File source = new File(LocalPath.getInstance().getPathInputIT()+"inputFrozenEndosomes.csv");
	File dest = new File(LocalPath.getInstance().getMyPathOut()+"inputFrozenEndosomes.csv");
	//System.out.print*ln(source.toString() + dest.toString());
	    try {
			FileUtils.copyFile(source, dest);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    }
	
	{
	
    try
    {
    	String modelFileName = ModelProperties.getInstance().getCopasiFiles().get("endosomeCopasi");
    	File source = new File(modelFileName);
    	File dest = new File(LocalPath.getInstance().getMyPathOut(),
                source.getName());
    	System.out.println(source.toString()+"\n" + dest.toString());
    	FileUtils.copyFile(source, dest);
    	
    }
    catch (java.lang.Exception ex)
    {
        System.err.println("No endosomeCopasi found "+ex);
    }}
	
	{
		
	    try
	    {
	    	saveParametersToFile();
	    }
	    catch (java.lang.Exception ex)
	    {
	        System.err.println("Error creating local param file "+ex);
	    }}
    
	}
	
	
	
	@ScheduledMethod(start = 1)
	public void header(){
//		TreeMap<String, Double> header = new TreeMap<String, Double>(String.CASE_INSENSITIVE_ORDER);
//		header.putAll(content());
//		try {
//			writeToCsvHeader(header);
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
		TreeMap<String, Double> singleEndosomeHeader = new TreeMap<String, Double>(endosomeContent());
		try {
			writeToCsvHeadSingleEndosomeHeader(singleEndosomeHeader);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	@ScheduledMethod(start = 1, interval = 10000)
	public void stepTable() {
//	log();
//		freeze endosome set
		FreezeDryEndosomes.getInstance();
		try {
			FreezeDryEndosomes.getInstance().writeToCsv();
			FreezeDryEndosomes.getInstance().writeToCsvPM();
			FreezeDryEndosomes.getInstance().writeToCsvER();
			FreezeDryEndosomes.getInstance().writeToCsvCy();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	

	public void log(){
	    double tick = RunEnvironment.getInstance().getCurrentSchedule().getTickCount();
	    Context<Object> context = RunState.getInstance().getMasterContext();

	    Map<String,TableModel> models = new HashMap<String,TableModel>();
	    // Create a tab panel for each agent layer
	    for (Object agentType : context.getAgentTypes()){
	        Class agentClass = (Class)agentType;

	        JPanel agentPanel = AgentTableFactory.createAgentTablePanel(context.getAgentLayer(agentClass), agentClass.getSimpleName());

	        if (agentPanel instanceof TablePanel){
	            TableModel model = ((TablePanel)agentPanel).getTable().getModel();
	            models.put(agentClass.getSimpleName(), model);

	        }
	    }

	    SpreadsheetUtils.saveTablesAsExcel(models, new File(mypathTable + "out-"+tick+".xlsx"));
	}

	@ScheduledMethod(start = 1, interval = 100)
	public void step() {

	    double tick = RunEnvironment.getInstance().getCurrentSchedule().getTickCount();

	    contentDistribution(totalRabs, initialTotalRabs, cisternsArea); 

	    TreeMap<String, Double> orderContDist = new TreeMap<>(contentDist);
	    TreeMap<String, Double> orderTotalRabs = new TreeMap<>(String.CASE_INSENSITIVE_ORDER);
	    orderTotalRabs.putAll(totalRabs);
	    TreeMap<String, Double> orderCisternsArea = new TreeMap<>(String.CASE_INSENSITIVE_ORDER);
	    orderCisternsArea.putAll(cisternsArea);

	    // DIGESTED GLOBAL: prefijo indica el mapa de origen
	    // mvb_ -> EndosomeInternalVesicleStep.digestedMvb
	    // sol_ -> EndosomeLysosomalDigestionStep.digestedSol
	    // mem_ -> EndosomeLysosomalDigestionStep.digestedMem
	    for (String k : EndosomeInternalVesicleStep.digestedMvb.keySet())        digestedKeys.add("mvb_" + k);
	    for (String k : EndosomeLysosomalDigestionStep.digestedSol.keySet())     digestedKeys.add("sol_" + k);
	    for (String k : EndosomeLysosomalDigestionStep.digestedMem.keySet())     digestedKeys.add("mem_" + k);

	    TreeMap<String, Double> orderDigested = new TreeMap<>();
	    for (String key : digestedKeys) {
	        if (key.startsWith("mvb_")) {
	            orderDigested.put(key, EndosomeInternalVesicleStep.digestedMvb.getOrDefault(key.substring(4), 0.0));
	        } else if (key.startsWith("sol_")) {
	            orderDigested.put(key, EndosomeLysosomalDigestionStep.digestedSol.getOrDefault(key.substring(4), 0.0));
	        } else if (key.startsWith("mem_")) {
	            orderDigested.put(key, EndosomeLysosomalDigestionStep.digestedMem.getOrDefault(key.substring(4), 0.0));
	        }
	    }

	    try {
	        writeGenericCsv(orderContDist, ITResultsPath, true, tick);
	        writeGenericCsv(orderTotalRabs, TotalRabs, true, tick);
	        writeGenericCsv(orderCisternsArea, cisternsAreaPath, true, tick);
	        writeGenericCsv(orderDigested, digestedPath, true, tick); //  NUEVO CSV
	    } catch (IOException e) {
	        e.printStackTrace();
	    }
	}
	
	private void writeGenericCsv(TreeMap<String, Double> data, String path, boolean writeHeader, double tick) throws IOException {
	    if (data.isEmpty()) return; // nada que escribir; evita crear header vacío
	    File file = new File(path);
	    boolean shouldWriteHeader = writeHeader && (!file.exists() || file.length() == 0);

	    // HEADER
	    if (shouldWriteHeader) {
	        StringBuilder line = new StringBuilder("tick,");
	        for (String key : data.keySet()) {
	            line.append(key).append(",");
	        }
	        line.append("\n");

	        Writer output = new BufferedWriter(new FileWriter(path, false));
	        output.append(line.toString());
	        output.close();
	    }

	    // DATA
	    StringBuilder line = new StringBuilder();
	    line.append(tick).append(",");
	    for (String key : data.keySet()) {
	        line.append(sigFigs(data.get(key), 4)).append(",");
	    }
	    line.append("\n");

	    Writer output = new BufferedWriter(new FileWriter(path, true));
	    output.append(line.toString());
	    output.close();
	}
	
	

	private void writeToCsvHeadSingleEndosomeHeader (TreeMap<String, Double> orderSingleEndHead) throws IOException {
		
		String line = "";
		for (String key : orderSingleEndHead.keySet()) {
            line = line+ key + ",";
		}
		line = line + "\n";
		Writer output;
		output = new BufferedWriter(new FileWriter(MarkerResultsPath, false));
		output.append(line);
		output.close();	
		
	}
	
	
	
	// sum the content in all endosomes weighted by the rab content of each endosome
	public void contentDistribution(HashMap<String, Double> totalRabs, HashMap<String, Double> initialTotalRabs, HashMap<String, Double> cisternsArea) {
		List<Endosome> allEndosomes = new ArrayList<Endosome>();
		int tick = (int) RunEnvironment.getInstance().getCurrentSchedule().getTickCount();
		if (tick == 1) {

		}
		content();// initialize all contents to zero
// include in the contentDistribution all the recycled components, soluble and membrane
		HashMap<String, Double> solubleRecycle = PlasmaMembrane.getInstance().getSolubleRecycle();
		HashMap<String, Double> membraneRecycle = PlasmaMembrane.getInstance().getMembraneRecycle();
// include in the contentDistribution all the recycled components, soluble and membrane		
		HashMap<String, Double> solubleSecretion = EndoplasmicReticulum.getInstance().getSolubleRecycle();
		HashMap<String, Double> membraneSecretion = EndoplasmicReticulum.getInstance().getMembraneRecycle();
		HashMap<String, Double> solubleCell = Cell.getInstance().getSolubleCell();
		//System.out.print*ln(solubleCell + " VEAMOS ANTES Y DESPUES" + Cell.getInstance().getSolubleCell());
		for (String sol : solubleRecycle.keySet()) {
//			//System.out.print*ln(" soluble "+ sol);
			double value = solubleRecycle.get(sol);
			contentDist.put(sol+"Pm", value);
//			//System.out.print*ln("SOLUBLE  PM"+ sol + value );
		}
		for (String mem : membraneRecycle.keySet()) {
			////System.out.print*ln(" soluble "+ sol + " Rab " +rab);
			double value = membraneRecycle.get(mem);
			contentDist.put(mem+"Pm" , value);
//			//System.out.print*ln("MEMBRANE PM  "+ mem + value);
		}			
		for (String sol : solubleSecretion.keySet()) {
//			//System.out.print*ln(" soluble "+ sol);
			double value = solubleSecretion.get(sol);
			contentDist.put(sol+"Er", value);
//			//System.out.print*ln("SOLUBLE  ER "+ sol + value );
		}
		for (String mem : membraneSecretion.keySet()) {
			////System.out.print*ln(" soluble "+ sol + " Rab " +rab);
			double value = membraneSecretion.get(mem);
			contentDist.put(mem+"Er" , value);
	//		//System.out.print*ln("MEMBRANE ER  "+ mem + value);
		}
		for (String sol : solubleCell.keySet()) {
//			//System.out.print*ln(" soluble "+ sol);
			double value = solubleCell.get(sol);
			contentDist.put(sol+"Cy", value);
//			//System.out.print*ln("SOLUBLE CELL  "+ sol + value +Cell.getInstance().getSolubleCell() );
		}
		
//		for the set of all endosomes, calculate the content distribution among the different
//		rab-containing compartments.  This is calculated as the sum of all the soluble and
//		membrane components multiplied by the area ratio corresponding to the endosome
//		this is: content*RabX/(area of the endosome).
//		In addition, the total amount of each Rab present in all organelles
//		in the system is calculated.  And the total volume that correspond to the Rab domain adding
//		all volumes proportional to the rab area of each organelle
		allEndosomes.clear();
		for (Object obj : grid.getObjects()) {
			if (obj instanceof Endosome) {
				allEndosomes.add((Endosome) obj);
			}
		}

		for (String rab: rabSet){
			totalRabs.put(rab,  0.0);
			totalVolumeRabs.put(rab, 0.0);
			cisternsArea.put(rab, 0.0);
		}
		double totalIndividualEntropy = 0d;
		double totalArea = 0d;
		for (Endosome endosome : allEndosomes) {
			Double area = endosome.area;
			Double volume = endosome.volume;
			if (area == null || area <= 1E-12) {
				continue;
			}
			double safeVolume = volume == null ? 0d : volume;
			HashMap<String, Double> rabContent = endosome.getRabContent();
			HashMap<String, Double> membraneContent = endosome
					.getMembraneContent();
			HashMap<String, Double> solubleContent = endosome
					.getSolubleContent();
			

			for (String rab : rabContent.keySet()) {
				for (String sol : solubleContent.keySet()) {
//					//System.out.print*ln(" soluble "+ sol + " Rab " +rab);
//					//System.out.print*ln(" FALTA " + contentDist.get(sol + rab));
					double value = contentDist.getOrDefault(sol + rab, 0d)
							+ solubleContent.get(sol) * rabContent.get(rab)
							/ area;
					contentDist.put(sol + rab, value);
					////System.out.print*ln("SOLUBLE"+sol + "Rab" +rab);
				}
				for (String mem : membraneContent.keySet()) {
//				//System.out.print*ln(" membrane "+mem + " Rab " +rab);
					double value = contentDist.getOrDefault(mem + rab, 0d)
							+ membraneContent.get(mem) * rabContent.get(rab)
							/ area;
					contentDist.put(mem + rab, value);
				}

			}
// CONTROL OF RAB LOST
// sum Rabs in all endosomes
			// for all endosomes calculate a individual entropy for the rab distribution
			double individualEntropy = 0d;
			for (String rab : rabContent.keySet()){
				double sum = totalRabs.get(rab)+ rabContent.get(rab);
				totalRabs.put(rab, sum);
				individualEntropy = individualEntropy - rabContent.get(rab)/area * Math.log(rabContent.get(rab)/area + 1E-30);
			}
			
			totalArea = totalArea + area;
			totalIndividualEntropy = totalIndividualEntropy + individualEntropy* area;
//			//System.out.print*ln("INDIVIDUAL ENTROPY " + totalIndividualEntropy);
// Sum all the organelle volume surrounded by a rab domain
		for (String rab : rabContent.keySet()){
			double sum = totalVolumeRabs.get(rab)+ safeVolume*rabContent.get(rab)/area;
			totalVolumeRabs.put(rab, sum);
		}
//
// If the endosome contains a MARKER, print info in a Results file		
//		int tick = (int) RunEnvironment.getInstance().getCurrentSchedule().getTickCount();
		if (tick == 1) initialTotalRabs.putAll(totalRabs);
		
		List<String> markers = new ArrayList<>();

		if (endosome.getMembraneContent().containsKey("membraneMarker") && endosome.getMembraneContent().get("membraneMarker") > 0.9) {
		    markers.add("membraneMarker");
		}
		if (endosome.getSolubleContent().containsKey("solubleMarker") && endosome.getSolubleContent().get("solubleMarker") > 0.9) {
		    markers.add("solubleMarker");
		}
		// Para beadX
		for (String key : endosome.getSolubleContent().keySet()) {
		    if (key.startsWith("bead") && endosome.getSolubleContent().get(key) > 0.9) {
		        markers.add(key + "marker");
		    }
		}

		for (String marker : markers) {
		    try {
		        printEndosome(endosome, marker);
		    } catch (IOException e) {
		        e.printStackTrace();
		    }
		}//
		
		}
		totalRabs.put("xPM", PlasmaMembrane.getInstance().getPlasmaMembraneArea());
		totalRabs.put("xER", EndoplasmicReticulum.getInstance().getEndoplasmicReticulumArea());
		cisternsArea.putAll(totalRabs);
		double totalCisternsArea = 0d;
		for (String rab : cisternsArea.keySet()) {
			totalCisternsArea = totalCisternsArea + cisternsArea.get(rab);
		}
		HashMap<String, Double> relativeCisternsArea = new HashMap<String, Double>();
//		//System.out.print*ln(" CISTERNA AREA      " + cisternsArea);


		double entropy = 0d;
		for (String rab : cisternsArea.keySet()) {
			double value = cisternsArea.get(rab)/totalCisternsArea;
			relativeCisternsArea.put(rab, value);
			entropy = entropy - value * Math.log(value + 1E-30);
		}
		cisternsArea.clear();
		cisternsArea.putAll(relativeCisternsArea);
		cisternsArea.put("entropy", entropy);
		cisternsArea.put("entropyInd", totalIndividualEntropy/totalArea);
		int endosomeNumber = allEndosomes.size();	
//		int tick = (int) RunEnvironment.getInstance().getCurrentSchedule().getTickCount();
		if (tick == 1) initialTotalRabs.putAll(totalRabs);
		
		
//		sum in cytosol
//		//System.out.print*ln(" TOTAL INDIVIDUAL ENTROPY      " + cisternsArea.get("entropyInd"));


	}
// Send information about the endosome that contains a membrane or a soluble MARKER
	
	private void writeHeaderIfNeeded(String markerFilePath, TreeMap<String, Double> headerMap) throws IOException {
	    File file = new File(markerFilePath);
	    if (!file.exists() || file.length() == 0) {
	        String line = "";
	        for (String key : headerMap.keySet()) {
	            line = line + key + ",";
	        }
	        line = line + "\n";
	        Writer output = new BufferedWriter(new FileWriter(markerFilePath, true));
	        output.append(line);
	        output.close();
	    }
	}
	
	private void printEndosome(Endosome endosome, String markerType) throws IOException {
		singleEndosomeContent.put("area", endosome.getArea());
		singleEndosomeContent.put("volume", endosome.getVolume());
		int tick = (int) RunEnvironment.getInstance().getCurrentSchedule().getTickCount();
		singleEndosomeContent.put("tick", (double) tick);
		singleEndosomeContent.put("pH", endosome.getpH());
//		String hexPart = endosome.toString();
//		hexPart= hexPart.substring(hexPart.length() - 7);
//		double decimalNumber = (double) (Integer.parseInt(hexPart, 16));
////		//System.out.print*ln(hexPart + "        "+ endosome.toString() +"  "+ decimalNumber);
//		singleEndosomeContent.put("endosome", decimalNumber);
		for (String rab : rabSet) 
		{
			singleEndosomeContent.put(rab, 0d);
			if (endosome.getRabContent().containsKey(rab)){
				singleEndosomeContent.put(rab, endosome.getRabContent().get(rab));
			}
		}
		for (String sol : solubleMet)
		{
			singleEndosomeContent.put(sol,0d); 
			if (endosome.getSolubleContent().containsKey(sol)){
				singleEndosomeContent.put(sol, endosome.getSolubleContent().get(sol));
			}
		}
		for (String mem : membraneMet)
		{
			singleEndosomeContent.put(mem,0d); 
		
			if (endosome.getMembraneContent().containsKey(mem)){
				singleEndosomeContent.put(mem, endosome.getMembraneContent().get(mem));
			}
		}
		TreeMap<String, Double> orderSingleEndosome = new TreeMap<String, Double>(singleEndosomeContent);
		String markerFilePath = mainpath.getMyPathOut() + "Results_" + markerType + ".csv";
		// Escribe el header si es necesario
	    writeHeaderIfNeeded(markerFilePath, orderSingleEndosome);
		String line = "";
		for (String key : orderSingleEndosome.keySet()) {
            line = line+ sigFigs(orderSingleEndosome.get(key),6) + ",";
		}
		line = line + "\n";
		Writer output;
		//CAMBIO
		
	    output = new BufferedWriter(new FileWriter(markerFilePath, true));
		output.append(line);
		output.close();
	}
	
	// generate the set of all combinations between contents 
	//(soluble or membrane) with all Rabs and sets the initial values to zero
	public TreeMap<String, Double> content() {
		for (String sol : solubleMet) {
			contentDist.put(sol+"Pm", 0d);
		} 
		for (String mem : membraneMet) {
			contentDist.put(mem+"Pm", 0d);
			
		}
		for (String sol : solubleMet) {
			contentDist.put(sol+"Er", 0d);
		} 
		for (String mem : membraneMet) {
			contentDist.put(mem+"Er", 0d);
			
		}
		for (String sol : Cell.getInstance().getSolubleCell().keySet()) {
			contentDist.put(sol+"Cy", 0d);
		}
		for (String rab : rabSet) {
			for (String sol : solubleMet) {
				contentDist.put(sol + rab, 0d);
			}
			for (String mem : membraneMet) {
				contentDist.put(mem + rab, 0d);
			}
		}
		return contentDist;
	}
	public HashMap<String, Double> endosomeContent() {
		singleEndosomeContent.put("area", 0d);
		singleEndosomeContent.put("volume", 0d);
		singleEndosomeContent.put("tick", 0d);
		singleEndosomeContent.put("pH", 0d);

		
		for (String sol : rabSet) {
			singleEndosomeContent.put(sol, 0d);
		}
		for (String sol : solubleMet) {
			singleEndosomeContent.put(sol, 0d);
		}
		for (String mem : membraneMet) {
			singleEndosomeContent.put(mem, 0d);
		}	
		return singleEndosomeContent;
	}
	
	public HashMap<String, Double> getCellK() {
		return cellK;
	}
	
	public HashMap<String, Double> getTotalRabs() {
		return totalRabs;
	}
	public HashMap<String, Double> getInitialTotalRabs() {
		return initialTotalRabs;
	}

	public final TreeMap<String, Double> getContentDist() {
		return contentDist;
	}

	public final HashMap<String, Double> getTotalVolumeRabs() {
		return totalVolumeRabs;
	}
	public static double sigFigs(double n, int sig) {
		if (Double.isNaN(n) || Double.isInfinite(n)) {
			return n;
		}
		if (n == 0d) {
			return 0d;
		}
		double abs = Math.abs(n);
		double mult = Math.pow(10, sig - Math.floor(Math.log10(abs)) - 1);
		return Math.round(n * mult) / mult;
	}
	
	public void saveParametersToFile() {

        Parameters params = RunEnvironment.getInstance().getParameters();
        // Nombre del archivo
        
        // Número de corrida
        int runNumber = 0;
        
        String filename = mainpath.getPathLocalParamFile();

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filename, true))) {

           StringBuilder line = new StringBuilder();

           line.append(runNumber);
           
           boolean first = true;

           for (String paramName : params.getSchema().parameterNames()) {
        	   
        	   if (paramName.equals("randomSeed") ||
                       paramName.contains("BatchConstants")) {

                       continue;
                   }
        	   
        	   if (!first) {
                   line.append(",");
               }
        	   
               Object value = params.getValue(paramName);

               line
                   .append(paramName)
                   .append("\t")
                   .append(value);
               
               first = false;
           }
           

           writer.write(line.toString());
           writer.newLine();

           System.out.println(
                   "Saved parameters for run " + runNumber);

       } catch (IOException e) {

           e.printStackTrace();
       }
    }
}
