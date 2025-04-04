package immunity;
import java.util.HashMap;
import java.util.TreeMap;

import repast.simphony.engine.environment.RunEnvironment;
import repast.simphony.engine.schedule.ScheduledMethod;
import repast.simphony.space.continuous.ContinuousSpace;
import repast.simphony.space.grid.Grid;

public class Cell {
	// a single Cell is created and used by all the agents in the simulation.  The cell will perform actions like
	// the formation of new organelles using the class UptakeStep2. 
	//	At present, that cytosol is a single compartment, metabolic transformation of metabolites is handdle
	//	by COPASI in Cell. 
	
	private static Cell instance;
	public static Cell getInstance() {
		if (instance == null) {
			instance = new Cell(space, grid);
		}
		return instance;
	}
	

//	Cell characteristics
	private static ContinuousSpace<Object> space;
	private static Grid<Object> grid;
	public static double rcyl = ModelProperties.getInstance().getCellK().get("rcyl");//20.0; // radius tubule scale
	public static double rendo = ModelProperties.getInstance().getCellK().get("rendo");//20.0; // radius tubule scale
	public static double mincyl = 6 * Math.PI * rcyl * rcyl; // surface minimum cylinder: two radius large (almost a sphere)
	public static double minCistern = ModelProperties.getInstance().getCellK().get("minCistern");//4E5;// scale
	public static double maxCistern = ModelProperties.getInstance().getCellK().get("maxCistern");//1.6E6;//scale
	public static double rIV = rcyl; //Internal vesicle radius similar to tubule radius 
	public static double orgScale = ModelProperties.getInstance().getCellK().get("orgScale");
	public static double timeScale = ModelProperties.getInstance().getCellK().get("timeScale");
	public double tMembrane = 0;// membrane that is not used in endosomes
	public HashMap<String, Double> rabCell = new HashMap<String, Double>();// contains rabs free in cytosol
	public HashMap<String, Double> membraneCell = new HashMap<String, Double>(); // contains membrane factors within the cell 
	public HashMap<String, Double> solubleCell = new HashMap<String, Double>();// contains soluble factors within the cell
	TreeMap<Integer, HashMap<String, Double>> cellTimeSeries = new TreeMap<Integer, HashMap<String, Double>>();
	private double cellVolume;//from inputIntrTransp3.csv
	private double cellArea;//from inputIntrTransp3.csv

	// Constructor
	public Cell(ContinuousSpace<Object> space, Grid<Object> grid) {
// Contains factors that are in the cell without specifying organelle or position.
// It is modified by Endosome that release soluble cargoes into the cytososl. Rab content may be modified to simulate Knock down protocols	
//				Initial values from the InputIntrTransport3
//				These values changes with data from frozenEndosomes.csv 

		this.space = space;
		this.grid = grid;
		cellArea = ModelProperties.getInstance().getCellAgentProperties().get("cellArea");// 
		cellVolume = ModelProperties.getInstance().getCellAgentProperties().get("cellVolume");//

		solubleCell.putAll(ModelProperties.getInstance().getSolubleCell());
		rabCell.putAll(ModelProperties.getInstance().getInitRabCell());
		tMembrane = 10000000;//ModelProperties.getInstance().cellK.get("tMembrane");
//		cellTimeSeries = null;
	}
	@ScheduledMethod(start = 1, interval = 100)
	public void step() {
//		this.changeColor();
		cellDigestion(this);
		String name = ModelProperties.getInstance().getCopasiFiles().get("cellCopasi");
		if (Math.random() < 0.0 && name.endsWith(".cps")){// not used yet
			CellCopasiStep.antPresTimeSeriesLoad(this);
		}		
// eventual use for cell metabolism

		
	}
	@ScheduledMethod(start = 1, interval = 1)
	public void uptake() {
//		Two uptakes are triggered by calling UptakeStep2:  new EE and new ERGIC. The use of p_ERUptake is arbitrary. 
		if (Math.random() <ModelProperties.getInstance().getActionProbabilities().get("p_ERUptake"))
		{
			UptakeStep2.uptake(this);
			}
			
// eventual use for cell metabolism
	}
	// GETTERS AND SETTERS (to get and set Cell contents)

	private void cellDigestion(Cell cell) {
		//	Cytosol digestion of metabolites.  Now is a single parameter from inputIntrTransp3.csv.
		//	Arbitrary:only soluble factors are digested.  Rab and membrane factors are not digested.
		HashMap<String, Double> soluble = Cell.getInstance().getSolubleCell(); 
		for (String s : soluble.keySet()){
			double cyto = soluble.get(s)*ModelProperties.getInstance().getCellK().get("digCell");//0.9995;
			Cell.getInstance().getSolubleCell().put(s, cyto);
		}
	}

	
	public double gettMembrane() {
		return tMembrane;
	}
	public double getCellVolume() {
		return cellVolume;
	}
	public void setcellVolume(double cellVolume) {
		this.cellVolume = cellVolume;
	}
	public double getCellArea() {
		return cellArea;	
	}
	public void setcellArea(double cellArea) {
		this.cellArea = cellArea;
	}
	public void settMembrane(double tMembrane) {
		this.tMembrane = tMembrane;
	}
	public HashMap<String, Double> getRabCell() {
		return rabCell;
	}
	public HashMap<String, Double> getMembraneCell() {
		return membraneCell;
	}
	public HashMap<String, Double> getSolubleCell() {
		return solubleCell;
	}
	public final TreeMap<Integer, HashMap<String, Double>> getCellTimeSeries() {
		return cellTimeSeries;
	}

	public ContinuousSpace<Object> getSpace() {
		return space;
	}
	public Grid<Object> getGrid() {
		return grid;
	}


}