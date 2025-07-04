package immunity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.TreeMap;

import repast.simphony.context.Context;
import repast.simphony.engine.schedule.ISchedulableAction;
import repast.simphony.engine.schedule.ScheduledMethod;
import repast.simphony.space.continuous.ContinuousSpace;
import repast.simphony.space.grid.Grid;
import repast.simphony.util.ContextUtils;

public class EndoplasmicReticulum {
	private static ContinuousSpace<Object> space;
	private static Grid<Object> grid;
	private static EndoplasmicReticulum instance;
	static {
		instance = new EndoplasmicReticulum(space, grid);
	}
	public static EndoplasmicReticulum getInstance() {
		return instance;
	}
	public static HashMap<String, Double> initialERProperties = new HashMap<String, Double>();
	public HashMap<String, Double> membraneRecycle = new HashMap<String, Double>(ModelProperties.getInstance().getInitERmembraneRecycle()); // contains membrane recycled 
	public HashMap<String, Double> solubleRecycle = new HashMap<String, Double>();// contains soluble recycled
	public static int ercolor = 0;
	public static int red = 0;
	public static int green = 0;	
	public static int blue = 0;	
	public double endoplasmicReticulumArea = 0;
	public double endoplasmicReticulumVolume = 0;
	TreeMap<Integer, HashMap<String, Double>> endoplasmicReticulumTimeSeries = new TreeMap<Integer, HashMap<String, Double>>();
	public String endoplasmicReticulumCopasi = ModelProperties.getInstance().getCopasiFiles().get("endoplasmicReticulumCopasi");


	// Constructor
	public EndoplasmicReticulum(ContinuousSpace<Object> sp, Grid<Object> gr){
// Contains the cargoes that are in the ER.  It is modified by Endosome that uses and changes the ER
// contents.	
//		The ER growth at some specific rate to mantain a flux of membrane through the Golgi
//		Initial values from the InputIntrTransport3
//		These values changes with data from frozenEndosomes.csv and by fusion of ERGIC vesicles and budding of ERGIC vesicles.
		ModelProperties modelProperties = ModelProperties.getInstance();
		double orgScale = modelProperties.getCellK().get("orgScale");
		
		initialERProperties = modelProperties.getInitERProperties();
		endoplasmicReticulumArea = initialERProperties.get("endoplasmicReticulumArea");// 
//		System.out.println("IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII "+ endoplasmicReticulumArea);

		endoplasmicReticulumVolume = initialERProperties.get("endoplasmicReticulumVolume");//

		for (String met : modelProperties.getInitERmembraneRecycle().keySet()){
		membraneRecycle.put(met, modelProperties.initERmembraneRecycle.get(met));
		}
//		System.out.println("ER membraneRecycle "+ membraneRecycle + endoplasmicReticulumArea);
		for (String met : modelProperties.initERsolubleRecycle.keySet() ){
		solubleRecycle.put(met, modelProperties.initERsolubleRecycle.get(met));
		}
//		System.out.println("ER solubleRecycle "+ solubleRecycle);		
//		for (String met : modelProperties.solubleMet ){
//		solubleRecycle.put(met,  0.0);
//		}
//		System.out.println("solubleRecycle "+solubleRecycle);		
	}

	@ScheduledMethod(start = 1, interval = 1)
	public void step() {
//		changeColor(); The color may change with the presence of some cargoes
		growth();
		
//		Eventually, reactions may occurr within the ER.
//		this.membraneRecycle = endoplasmicReticulum.getInstance().getMembraneRecycle();
//		this.solubleRecycle = endoplasmicReticulum.getInstance().getSolubleRecycle();
//		this.endoplasmicReticulumTimeSeries=endoplasmicReticulum.getInstance().getendoplasmicReticulumTimeSeries();
//		if (Math.random() < 0 && endoplasmicReticulumCopasi.endsWith(".cps"))endoplasmicReticulumCopasiStep.antPresTimeSeriesLoad(this);
//		this.changeColor();

		}
	public void growth() {
		double growth = ModelProperties.getInstance().getCellK().get("growthER");//1.0005; // Bajo 1.001
		EndoplasmicReticulum.getInstance().setEndoplasmicReticulumArea(endoplasmicReticulumArea * growth);
	}

	public void changeColor() {
		double c1 = 0d;
		{
		c1 = 20*c1/endoplasmicReticulumArea;
		if (c1>1) c1=1;
		ercolor = (int) (c1*255);
		}
	}
	

	// GETTERS AND SETTERS (to get and set Cell contents)
//	public static EndoplasmicReticulum getInstance() {
//		return instance;
//	}
		public HashMap<String, Double> getMembraneRecycle() {
		return this.membraneRecycle;
	}

	public HashMap<String, Double> getSolubleRecycle() {
		return this.solubleRecycle;
	}

	public int getErcolor() {
		return ercolor;
	}

	public double getEndoplasmicReticulumArea() {
		return endoplasmicReticulumArea;
	}


	public double getEndoplasmicReticulumVolume() {
		return endoplasmicReticulumVolume;
	}
	
	public final TreeMap<Integer, HashMap<String, Double>> getendoplasmicReticulumTimeSeries() {
		return endoplasmicReticulumTimeSeries;
	}
	

	public final double getInitialendoplasmicReticulumVolume() {
		return initialERProperties.get("endoplasmicReticulumVolume");
	}

	public final double getInitialendoplasmicReticulumArea() {
		return initialERProperties.get("endoplasmicReticulumArea");
	}
	public void setEndoplasmicReticulumArea(double endoplasmicReticulumArea) {
		this.endoplasmicReticulumArea = endoplasmicReticulumArea;
	}

	public void setEndoplasmicReticulumVolume(double endoplasmicReticulumVolume) {
		this.endoplasmicReticulumVolume = endoplasmicReticulumVolume;
		
	}



}