package immunity;

//import immunity.EndosomeStyle.MemCont;
//import immunity.EndosomeStyle.RabCont;
//import immunity.EndosomeStyle.SolCont;
import java.util.Random;
import java.awt.Graphics;
import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import javax.swing.JPanel;
import javax.swing.table.TableModel;

import org.apache.commons.logging.impl.Log4JLogger;
import org.apache.log4j.Logger;
import org.opengis.filter.identity.ObjectId;

//import com.thoughtworks.xstream.annotations.XStreamOmitField;

import gov.nasa.worldwind.formats.json.JSONDoc;
import repast.simphony.context.Context;
import repast.simphony.engine.environment.RunEnvironment;
import repast.simphony.engine.environment.RunState;
import repast.simphony.engine.schedule.ScheduledMethod;
import repast.simphony.essentials.RepastEssentials;
import repast.simphony.parameter.Parameters;
import repast.simphony.query.space.grid.GridCell;
import repast.simphony.query.space.grid.GridCellNgh;
import repast.simphony.space.continuous.ContinuousSpace;
import repast.simphony.space.continuous.NdPoint;
import repast.simphony.space.grid.Grid;
import repast.simphony.space.grid.GridPoint;
import repast.simphony.ui.table.AgentTableFactory;
import repast.simphony.ui.table.SpreadsheetUtils;
import repast.simphony.ui.table.TablePanel;
import repast.simphony.util.ContextUtils;

import java.util.Random;

import repast.simphony.valueLayer.GridValueLayer;
//import repast.simphony.ui.probe.ProbeID;
//import repast.simphony.ui.probe.ProbeInfo;


/**
 * This class defines the most important agents for intracellular transport
 * Initially they were only endosomes, but now is any organelle
 * This agents have volume and area.  The area is covered by membrane domains
 * Initially the membrane domains were named as Rabs, but now are better defined by short names
 * Ej RabA are EE (early endosomes)
 *
 */
public class Endosome {
	final static Logger logger = Logger.getLogger(Endosome.class);
	// space

	private ContinuousSpace<Object> space;
	private Grid<Object> grid;
	
	public double xcoor = 0d;
	public double ycoor = 0d;
	
	// Endosomal
	ModelProperties cellProperties = ModelProperties.getInstance();
	HashMap<String, Double> cellK = cellProperties.getCellK();

	double area; //= 4d * Math.PI * 30d * 30d; // initial value, but should change
	double volume; //= 4d / 3d * Math.PI * 30d * 30d * 30d; // initial value, but													// should change
	double a = 0; // width of the ellipsoid representing the endosome
	double c = 0; // length;
	double size;// = Math.pow(volume * 3d / 4d / Math.PI, (1d / 3d));
	double speed;// = 5d / size; // initial value, but should change
	double heading = 0;// = Math.random() * 360d; // initial value, but should change
	double mvb;// = 0; // number of internal vesices
	double pH ;// = 11;
	HashMap<String, Double> rabContent = new HashMap<String, Double>();
	HashMap<String, Double> membraneContent = new HashMap<String, Double>();
	HashMap<String, Double> solubleContent = new HashMap<String, Double>();
	HashMap<String, Double> initOrgProp = new HashMap<String, Double>();
	TreeMap<Integer, HashMap<String, Double>> endosomeTimeSeries = new TreeMap<Integer, HashMap<String, Double>>();
	TreeMap<Integer, HashMap<String, Double>> rabTimeSeries = new TreeMap<Integer, HashMap<String, Double>>();
//	Probabilities of events per tick.  Calculated from the t1/2 of each process
//	 as the inverse of time1/2(in seconds) / 0.03 * timeScale
//	0.03 is the fastest event (movement on MT, 1 uM/sec) that I use to calibrate
//	the tick duration. At time scale 1, I move the endosome 30 nm in a tick (50 ticks to travel 1500 nm). Hence
//	one tick is equivalent to 0.03 seconds
//	At time scale 0.5, I move the endosome 60 nm (30/timeScale)
	public int tickCount;										   //FRANCO

	// constructor of endosomes with grid, space and a set of Rabs, membrane
	// contents,
	// and volume contents.
	public Endosome(ContinuousSpace<Object> sp, Grid<Object> gr,
			HashMap<String, Double> rabContent,
			HashMap<String, Double> membraneContent,
			HashMap<String, Double> solubleContent,
			HashMap<String, Double> initOrgProp) 
	{

		this.tickCount=0; //FRANCO
		this.space = sp;
		this.grid = gr;
		this.rabContent = rabContent;
//		Rab conversion was a more molecular mechanism for maturation and was handled with reactions in COPASI
//		Now maturation is set as rules within Repast
//		EndosomeRabConversionStep.rabConversion(this);
		this.membraneContent = membraneContent;
		this.solubleContent = solubleContent;
		this.initOrgProp = initOrgProp;
		this.pH = this.getpH();
		area = initOrgProp.get("area");
//		System.out.println("area" + area + " "+initOrgProp);
		volume = initOrgProp.get("volume");
		size = Math.pow(volume * 3d / 4d / Math.PI, (1d / 3d));
		speed = Cell.orgScale / size; // initial value, but should change
		heading = Math.random() * 360d - 180; // initial value, but should change
		double mvb = 0; // number of internal vesicles
	}
//    @ProbeID
	public final double getXcoor() {
		return xcoor;
	}

	public final void setXcoor(double xcoor) {
		this.xcoor = xcoor;
	}
	
	public final double getYcoor() {
		return ycoor;
	}
	public void setYcoor(double ycoor) {
		this.ycoor = ycoor;	
	}
	public ContinuousSpace<Object> getSpace() {
		return space;
	}
	public void setSpace(ContinuousSpace<Object> value) {
		space = value;
	}

	public final double getpH() {
		if (this.solubleContent.containsKey("protonEn"))
		{
			return (-Math.log10((this.solubleContent.get("protonEn")+1)/this.volume * 1E-3));// concentration in mM
// entiendo que el +1 es solo para evitar división por cero		
		}
		else return 10;
	}

	@ScheduledMethod(start = 1, interval = 1)
	public void step() {
		this.tickCount=this.tickCount + 1;
//		ACTIONS PERFORMED BY EACH ORGANELLE
		OrganelleMove.moveTowards(this);
		ModelProperties modelProperties = ModelProperties.getInstance();
		if (Math.random()<modelProperties .getActionProbabilities().get("p_EndosomeTetherStep"))EndosomeTetherStep.tether(this);
		if (Math.random()<modelProperties .getActionProbabilities().get("p_EndosomeInternalVesicleStep"))EndosomeInternalVesicleStep.internalVesicle(this);
		if (Math.random()<modelProperties .getActionProbabilities().get("p_FusionStep"))FusionStep.fusion(this);
		if (Math.random()<modelProperties .getActionProbabilities().get("p_FissionStep"))FissionStep.split(this);
		if (Math.random()<modelProperties .getActionProbabilities().get("p_EndosomeLysosomalDigestionStep"))EndosomeLysosomalDigestionStep.lysosomalDigestion(this);
		String name =  modelProperties .getCopasiFiles().get("endosomeCopasi");
		if (Math.random() < 1 && name.endsWith(".cps"))EndosomeCopasiStep.antPresTimeSeriesLoad(this);
		if (Math.random()<modelProperties .getActionProbabilities().get("p_EndosomeRecycleStep"))RecycleStep.recycle(this);
		if (Math.random()<modelProperties .getActionProbabilities().get("p_EndosomeMaturationStep"))EndosomeMaturationStep.matureCheck(this); //	
	}

	public static void endosomeShape(Endosome end) {
		/*Organelles have a shape according to their volume and area.  Not Golgi organelles are represented
		 * by an prolate spheroid with axes calculated from area and volume.  In 2D they are displaied
		 * as ellypses.  Golgi are oblate spheroids and are represented by rectangles	
		 * https://en.wikipedia.org/wiki/Ellipsoid approximate formula		
				*/
		double s = end.area;
		double v = end.volume;
		double rsphere = Math.pow((v * 3d) / (4d * Math.PI), (1d / 3d));
		double p =  1.6075;
		double aa = rsphere; // initial a from the radius of a sphere of volume v
		double cc = aa;// initially, c=a

//		USED
//		Surface ellipsoid (tubule or disk) = 4*PI*(  ((a^2p + 2 a^p * c^p)/3)^(1/p)  )
//		where p =  1.6075
		double golgiArea = 0;
		ModelProperties modelProperties = ModelProperties.getInstance();
		for (String rab : end.rabContent.keySet())
		{
			if (modelProperties.getRabOrganelle().get(rab).contains("Golgi"))
			{
				golgiArea = golgiArea + end.rabContent.get(rab);
			}
		}
		if (golgiArea/end.area > 0.5){
			if (end.area >= Cell.minCistern/20) end.heading = -90d; // is a cistern
			double[] radiusHeight = radiusHeightCistern(end.area, end.volume);
			end.a = radiusHeight[0];
			end.c = radiusHeight[1];
//		if (end.a <=0) System.out.println("FLAT FLAT  a    " + end.a +" c " + end.c);
		}
		else 	
		{
			double[] radiusHeight = radiusHeightTubule(end.area, end.volume);
			end.a = radiusHeight[0];
			end.c = radiusHeight[1];

//			System.out.println("LONG LONG  c  a  " + cc +" " + aa);
			if (end.a <1) {
				end.a = 1;
				System.out.println("PROBLEMA FORMA " + s +" "+v+"");
			}
//			end.a = aa;
//			end.c = cc;
		}
	}
	
	public int getTickCount() {       //FRANCO
		return tickCount;			//FRANCO	
	}
	public void setTickCount(int tickCount) {	//FRANCO
		this.tickCount = tickCount;				//FRANCO
	}
	public void setHeading(double heading) {
		this.heading = heading;				
	}
	public double getArea() {
		return area;
	}

	public double getVolume() {
		if (volume < 1.0) {
			return volume;
		}
		return volume;
	}

	public double getSpeed() {
		return speed;
	}

	public double getHeading() {
		return heading;
	}

	public HashMap<String, Double> getRabContent() {
		return rabContent;
	}

	public HashMap<String, Double> getMembraneContent() {
		return membraneContent;
	}

	public HashMap<String, Double> getSolubleContent() {
		return solubleContent;
	}

	public Endosome getEndosome() {
		return this;
	}


	public String getMvb() {
		if (solubleContent.containsKey("mvb")) {
			if (solubleContent.get("mvb") > 0.9) {
				int i = solubleContent.get("mvb").intValue();
				return String.valueOf(i);
			} else
				return null;
		} else
			return null;

	}
// To plot different color according to the content
	public double getRed() {
		// double red = 0.0;
		String contentPlot = ModelProperties.getInstance().getColorContent()
				.get("red");

		if (membraneContent.containsKey(contentPlot)) {
			double red = membraneContent.get(contentPlot) / area;
//			if (red > 1)
//				System.out.println("RED FUERA ESCALA " + " " + red + " "
//						+ membraneContent.get(contentPlot) + "  " + area);
//			if (red > 1)
//				System.out.println("RED FUERA ESCALA " + " " + contentPlot);
//			// System.out.println("mHCI content" + red);
			return red;
		}
		if (solubleContent.containsKey(contentPlot)) {
			double red = solubleContent.get(contentPlot) / volume;
			// System.out.println("mHCI content" + red);
			return red;
		} else
			return 0;
	}

	public double getGreen() {
		// double red = 0.0;
		String contentPlot = ModelProperties.getInstance().getColorContent()
				.get("green");

		if (membraneContent.containsKey(contentPlot)) {
			double green = membraneContent.get(contentPlot) / area;
			// System.out.println("mHCI content" + red);
			return green;
		}
		if (solubleContent.containsKey(contentPlot)) {
			double green = solubleContent.get(contentPlot) / volume;
			// System.out.println("mHCI content" + red);
			return green;
		} else
			return 0;
	}

	public double getBlue() {
		// double red = 0.0;
		String contentPlot = ModelProperties.getInstance().getColorContent()
				.get("blue");

		if (membraneContent.containsKey(contentPlot)) {
			double blue = membraneContent.get(contentPlot) / area;
			return blue;
		}
		if (solubleContent.containsKey(contentPlot)) {
			double blue = solubleContent.get(contentPlot) / volume;
			return blue;
		} else
			return 0;
	}
// Not used, the color of the edge is decided by the EndosomeStyle

	public double getEdgeRed() {
		String edgePlot = ModelProperties.getInstance().getColorRab().get("red");

		if (rabContent.containsKey(edgePlot)) {
			double red = rabContent.get(edgePlot)/area;
			return red;
		} else
			return 0;
	}

	public double getEdgeGreen() {
		String edgePlot = ModelProperties.getInstance().getColorRab()
			.get("green");
		if (rabContent.containsKey(edgePlot)) {
			double green = rabContent.get(edgePlot)/ area;
			return green;
		} else
			return 0;
	}

	public double getEdgeBlue() {
		String edgePlot = ModelProperties.getInstance().getColorRab()
			.get("blue");
		if (rabContent.containsKey(edgePlot)) {
			double blue = rabContent.get(edgePlot)/area;
			return blue;
		} else
			return 0;
	}

	
	public double getMemContRab(String memCont, String rab) {
		double memContRab = membraneContent.get(memCont) * rabContent.get(rab)
				/ this.area;
		return memContRab;
	}

	public double getA() {
		return a;
	}

	public double getC() {
		return c;
	}

	public Grid<Object> getGrid() {
		return grid;
	}

	public TreeMap<Integer, HashMap<String, Double>> getEndosomeTimeSeries() {
		return endosomeTimeSeries;
	}



	public TreeMap<Integer, HashMap<String, Double>> getRabTimeSeries() {
		return rabTimeSeries;
	}

	public HashMap<String, Double> getInitOrgProp() {
		// TODO Auto-generated method stub
		return initOrgProp;
	}
// To get the axis of the organelle according to the area and volume for Golgi (oblates)
	public static double[] radiusHeightCistern (double area, double volume) {
		double s = area;
		double v = volume;
		double p = 1.6075;
		double PI = Math.PI;
		double aa = Math.pow(s/PI/4d, (1d/2d));
		double cc = aa;
		for (int i = 0; i < 4; i++) {
//			System.out.println("initial  " + aa +" c " + cc);
			cc = v*3/4/PI/aa/aa;	
//			form ellipsoid area s = 4*PI*[(ap*bp+ap*cp+bp*cp)/3]^1/p where ap = a^p ....
//			Since in the spheroid a = b
//			s = 4*PI*[(ap^2+2ap*cp)/3]^1/p where ap = a^p ....
//			I can get the cuadratic function 
//			ap^2 + 2ap*cp - (s/4/PI)^p*3 = 0

			double aq = 1;
			double bq = 2*Math.pow(cc, 1/p);
			double cq = -Math.pow(s/4/PI, p)*3d;
			double dq =  bq * bq - 4 * aq * cq;
			double root1 = (- bq + Math.sqrt(dq))/(2*aq);
			//			    root2 = (-b - Math.sqrt(d))/(2*a);			
			aa = Math.pow(root1, 1/p);

		}

//		if (aa<=0)System.out.println("PROBLEMA FORMA cistern" + s +" "+v+"");
		return new double[] {aa, cc};	
	}
	// To get the axis of the organelle according to the area and volume for not-Golgi (prolates)
	public static double[] radiusHeightTubule(double area, double volume) {
		double s = area;
		double v = volume;
		double p = 1.6075;
		double PI = Math.PI;
		double aa = Math.pow(s/PI/4d, (1d/2d));
		double cc = aa;
		for (int i = 0; i < 4; i++) {
			cc=Math.pow((Math.pow((s/4/PI),p)*3 - Math.pow(aa, 2*p))/(2*Math.pow(aa, p)),(1/p));
			aa = Math.sqrt(v*3d/(4d*PI*cc));			
		}
//		System.out.println("LONG LONG  c  a  " + cc +" " + aa);
//		if (aa<=0)System.out.println("PROBLEMA FORMA tube " + s +" "+v+"");
		return new double[] {aa, cc};
	}
	
}
	


