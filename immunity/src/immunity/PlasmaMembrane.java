package immunity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.TreeMap;

import repast.simphony.context.Context;
import repast.simphony.engine.environment.RunEnvironment;
import repast.simphony.engine.schedule.ISchedulableAction;
import repast.simphony.engine.schedule.ScheduledMethod;
import repast.simphony.space.continuous.ContinuousSpace;
import repast.simphony.space.grid.Grid;
import repast.simphony.util.ContextUtils;

public class PlasmaMembrane {
	private static ContinuousSpace<Object> space;
	private static Grid<Object> grid;

	// a single Cell is created
	private static PlasmaMembrane instance;
	static {
		instance = new PlasmaMembrane(space, grid);
	}
	

	public HashMap<String, Double> membraneRecycle = new HashMap<String, Double>(ModelProperties.getInstance().getInitPMmembraneRecycle()); // contains membrane recycled 
	public HashMap<String, Double> solubleRecycle = new HashMap<String, Double>();// contains soluble recycled
	public int pmcolor = 0;
	public int red = 0;
	public int green = 0;	
	public int blue = 0;
	private static double plasmaMembraneVolume;
	private static double plasmaMembraneArea;
	private static double initialPlasmaMembraneVolume;
	private static double initialPlasmaMembraneArea;
//	public int area = (int) (1500*400*(1/Cell.orgScale)*(1/Cell.orgScale)); //ModelProperties.getInstance().getPlasmaMembraneProperties().get("plasmaMembraneArea");// 
//	public int volume = (int) (1500*400*1000*(1/Cell.orgScale)*(1/Cell.orgScale)*(1/Cell.orgScale)); //ModelProperties.getInstance().getPlasmaMembraneProperties().get("plasmaMembraneVolume");//
	TreeMap<Integer, HashMap<String, Double>> plasmaMembraneTimeSeries = new TreeMap<Integer, HashMap<String, Double>>();
	public String plasmaMembraneCopasi = ModelProperties.getInstance().getCopasiFiles().get("plasmaMembraneCopasi");
// nm2 1500nm x 400nm. Space in repast at scale =1 and arbitrary height of the space projected
//	in 2D




	// Constructor
	public PlasmaMembrane(ContinuousSpace<Object> space, Grid<Object> grid) {
// Contains the contents that are in the plasma membrane.  It is modified by Endosome that uses and changes the PM
// contents.
//		initial area and volume correspond to the world size (1500*400) and (1500*400*1000) corrected by the orgScale


		ModelProperties modelProperties = ModelProperties.getInstance();
		double orgScale = modelProperties.getCellK().get("orgScale");
		plasmaMembraneArea = ModelProperties.getInstance().getPlasmaMembraneProperties().get("plasmaMembraneArea");// 
		initialPlasmaMembraneArea = 1500*400/orgScale/orgScale;//ModelProperties.getInstance().getPlasmaMembraneProperties().get("plasmaMembraneArea");// 	
		plasmaMembraneVolume = ModelProperties.getInstance().getPlasmaMembraneProperties().get("plasmaMembraneVolume");//
		initialPlasmaMembraneVolume = 1500*400*1000/orgScale/orgScale/orgScale;//ModelProperties.getInstance().getPlasmaMembraneProperties().get("plasmaMembraneVolume");//

//		plasmaMembraneTimeSeries = null;
//		
//		membraneRecycle.putAll(modelProperties.initPMmembraneRecycle);
// PM now are in the csv file as proportions of the PM area and need to be multiplied by the area	
// 3 april 2023.  Now PM are in number of molecules		
		for (String met : modelProperties.initPMmembraneRecycle.keySet() ){
		membraneRecycle.put(met, modelProperties.initPMmembraneRecycle.get(met));
		}
//		System.out.println("PM membraneRecycle "+ membraneRecycle);
		for (String met : modelProperties.initPMsolubleRecycle.keySet() ){
		solubleRecycle.put(met, modelProperties.initPMsolubleRecycle.get(met));
		}
//		System.out.println("PM solubleRecycle "+ solubleRecycle);		
//		for (String met : modelProperties.solubleMet ){
//		solubleRecycle.put(met,  0.0);
//		}
//		System.out.println("solubleRecycle "+solubleRecycle);		
	}

	@ScheduledMethod(start = 1, interval = 1)
	public void step() {
		changeColor();
		this.membraneRecycle = PlasmaMembrane.getInstance().getMembraneRecycle();
		this.solubleRecycle = PlasmaMembrane.getInstance().getSolubleRecycle();
		this.plasmaMembraneTimeSeries=PlasmaMembrane.getInstance().getPlasmaMembraneTimeSeries();
		if (Math.random() < 1 && plasmaMembraneCopasi.endsWith(".cps"))PlasmaMembraneCopasiStep.antPresTimeSeriesLoad(PlasmaMembrane.getInstance());
//		this.changeColor();
		int tick = (int) RunEnvironment.getInstance().getCurrentSchedule().getTickCount();
		
//		//to generate a 30 min pulse of Ab anti cMHCI with acid wash
//		if (tick == 30000) {
//		double MHCIPM= PlasmaMembrane.getInstance().getMembraneRecycle().get("pepMHCIEn");
//		PlasmaMembrane.getInstance().getMembraneRecycle().put("pepMHCIEn", 0.0);
//		PlasmaMembrane.getInstance().getMembraneRecycle().put("oMHCIEn", MHCIPM);
//		PlasmaMembrane.getInstance().getMembraneRecycle().put("cMHCIEn", 0.0);
//		PlasmaMembrane.getInstance().getMembraneRecycle().put("pepEn", 0.0);ERROR DEBER�A SER SOLUBLERECYCLING
//		};//to generate a 30 min pulse with acid wash
		
//		//to generate a 5 min pulse	
//		if (tick == 5000) {
//			PlasmaMembrane.getInstance().getMembraneRecycle().clear();
//			PlasmaMembrane.getInstance().getSolubleRecycle().clear();
//			EndoplasmicReticulum.getInstance().getMembraneRecycle().clear();
//			EndoplasmicReticulum.getInstance().getSolubleRecycle().clear();

//		}
		
//		to generate a 30 min pulse of OVA with wash		
//		if (tick > 30000 && tick < 30200 ) {
//		PlasmaMembrane.getInstance().getSolubleRecycle().put("pepEn", 0.0);
//		PlasmaMembrane.getInstance().getSolubleRecycle().put("ovaEn", 0.0);
//		};

	}
	
	public void changeColor() {
		double c1 = 0d;
		
		if (membraneRecycle.containsKey("pepMHCIEn")) c1 = membraneRecycle.get("pepMHCIEn");
		c1 = c1/plasmaMembraneArea;
//		System.out.println(PlasmaMembrane.getInstance().getMembraneRecycle()+"\n COLOR PLASMA  " + c1+" " + pmcolor);
		if (c1>1) c1=1;
		pmcolor = (int) (c1*255);
		

//		System.out.println(PlasmaMembrane.getInstance().getMembraneRecycle()+"\n COLOR PLASMA  " + pmcolor+" " + pmcolor);
	}
	

	// GETTERS AND SETTERS (to get and set Cell contents)
	public static PlasmaMembrane getInstance() {
		return instance;
	}
		public HashMap<String, Double> getMembraneRecycle() {
		return membraneRecycle;
	}

	public HashMap<String, Double> getSolubleRecycle() {
		return solubleRecycle;
	}

	public int getPmcolor() {
		return pmcolor;
	}

	public double getPlasmaMembraneArea() {
		return plasmaMembraneArea;
	}

	public double getPlasmaMembraneVolume() {
		return plasmaMembraneVolume;
	}
	
	public final TreeMap<Integer, HashMap<String, Double>> getPlasmaMembraneTimeSeries() {
		return plasmaMembraneTimeSeries;
	}
	
	public final void setPlasmaMembraneArea(double plasmaMembraneArea) {
		this.plasmaMembraneArea = plasmaMembraneArea;
	}
	public final void setPlasmaMembraneVolume(double plasmaMembraneVolume) {
		this.plasmaMembraneVolume = plasmaMembraneVolume;
	}
	public final double getInitialPlasmaMembraneVolume() {
		return initialPlasmaMembraneVolume;
	}

	public final double getInitialPlasmaMembraneArea() {
		return initialPlasmaMembraneArea;
	}



}