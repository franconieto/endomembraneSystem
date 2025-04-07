package immunity;

import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.TreeMap;
import java.util.concurrent.TimeUnit;

import repast.simphony.context.Context;
import repast.simphony.engine.environment.RunEnvironment;
import repast.simphony.random.RandomHelper;
import repast.simphony.space.continuous.ContinuousSpace;
import repast.simphony.space.continuous.NdPoint;
import repast.simphony.space.grid.Grid;
import repast.simphony.util.ContextUtils;

public class UptakeStep2 {
	public static 	double uptakeArea = 0d;
	private static double PI = Math.PI;
	public static void uptake(Cell cell) {

		/*  
		 *  EE and ERGIC organelles are created according to the PM membrane and ER disponibility
		 * PM is maintained by recycling of tubular EE, SE and RE, and the secretion of TGN
		 *  ER is continuously created (parameter growthER in inputIntrTransp3.csv)
		 */

		HashMap<String, Double> totalRabs = new HashMap<String, Double>(Results.getInstance().getTotalRabs());
		HashMap<String, Double> initialTotalRabs = new HashMap<String, Double>(Results.getInstance().getInitialTotalRabs());

		double areaPM = PlasmaMembrane.getInstance().getPlasmaMembraneArea();
		double initialAreaPM = PlasmaMembrane.getInstance().getInitialPlasmaMembraneArea();

		while(areaPM > initialAreaPM) {
			System.out.println(" 	NEW UPTAKE PM   " + areaPM + "    "+initialAreaPM);
			newUptake(cell,"RabA");
			if (Math.random()< 0) {
				break; // to prevent too many continuous uptakes
			}
			//	System.out.println(" 	NEW NEW UPTAKE    " + PlasmaMembrane.getInstance().getPlasmaMembraneArea() + "    "+initialAreaPM);}
			areaPM = PlasmaMembrane.getInstance().getPlasmaMembraneArea();
		}
		//		NEW SECRETORY EVENT
		double areaER = EndoplasmicReticulum.getInstance().getEndoplasmicReticulumArea();
		double initialAreaER = EndoplasmicReticulum.getInstance().getInitialendoplasmicReticulumArea();
		while (areaER > initialAreaER) {
			System.out.println(" 	NEW UPTAKE ER   " + areaER + "    "+initialAreaER);

			newSecretion(cell,"RabI");
			if (Math.random()< 0.5) {
				break; // to prevent too many continuous new ERGICs
			}
			areaER = EndoplasmicReticulum.getInstance().getEndoplasmicReticulumArea();	
		}
	}

	
		
	private static void newSecretion(Cell cell, String selectedRab) {
		double cellLimit = 3d * Cell.orgScale;
//		System.out.println("NEW ERGIC FORMED  " +	InitialOrganelles.getInstance().getInitOrgProp().get("kind9"));
		HashMap<String, Double> initOrgProp = new HashMap<String, Double>(
				InitialOrganelles.getInstance().getInitOrgProp().get("kind9"));
		HashMap<String, Double> rabCell = cell.getRabCell();

		if (!rabCell.containsKey("RabI") || Math.random()>rabCell.get("RabI")){
			return;}
	//		Secretion generate a new RabI organelle.  The size is the radius in the csv file for maxRadius in kind9
	//		initial organelles.  The content is specified in concentration. One (1) is approx 1 mM.
	//		This units are converted to membrane or volume units by multiplying by the area (rabs and
	//		membrane content) or volume (soluble content).  For secretion it is controlled that there is enough
	//		membrane and there is RabI in the cell

		double maxRadius = initOrgProp.get("maxRadius");
		double minRadius = maxRadius/2;
		double a = RandomHelper.nextDoubleFromTo(minRadius,maxRadius);				
		double c = a + a  * Math.random() * initOrgProp.get("maxAsym");

		double f = 1.6075;
		double af= Math.pow(a, f);
		double cf= Math.pow(c, f);
		double area = 4d* PI*Math.pow((af*af+af*cf+af*cf)/3, 1/f);
		double areaER = EndoplasmicReticulum.getInstance().getEndoplasmicReticulumArea();
//		System.out.println("LUEGO DE UPTAKE  "+ endoplasmicReticulum);
		EndoplasmicReticulum.getInstance().setEndoplasmicReticulumArea(areaER-area);
		double volume = 4d/3d*PI*a*a*c;
		initOrgProp.put("area", area);
		double value = Results.instance.getTotalRabs().get("RabI");
		value = value + area;
		Results.instance.getTotalRabs().put("RabI", value);
		initOrgProp.put("volume", volume);
		HashMap<String, Double> rabContent = new HashMap<String, Double>();
	//			NEW ERGIC JUST RABI
		rabContent.put("RabI", area);
		
		/* Soluble and membrane content of the kind9
		 * To model molecules that cycle between ER and endosomes, such as cMHCI and mHCI
		 * the new endosome incorporates metabolites that are present in the ER.
		 * Each species has its own rate for internalization (secretion rate).
		 * Also, the new ERGIC cannot incorporate more than a given amount of ER metabolites
		 * In area units, no more than its surface (about 1 mM)
		 * 
		 * 
		 * */
		
		HashMap<String, Double> membraneContent = new HashMap<String,Double>();
		Set<String> membraneMet = new HashSet<String>(ModelProperties.getInstance().getMembraneMet());
//		System.out.println(EndoplasmicReticulum.getInstance().getMembraneRecycle() + "   secretion 1111  ");

		for (String mem : membraneMet){
//			double valueInER =0d;
			if (EndoplasmicReticulum.getInstance().getMembraneRecycle().containsKey(mem))
			{
				double valueER = EndoplasmicReticulum.getInstance().getMembraneRecycle().get(mem);
				double secreted = valueER * ModelProperties.getInstance().getSecretionRate().get(mem) * area/ EndoplasmicReticulum.getInstance().getEndoplasmicReticulumArea();	

				if (secreted >= area) secreted = area; // cannot incorporate more metabolite than its area
				membraneContent.put(mem, secreted);
				//	System.out.println(mem + valueER + "   UPTAKE DECREASE 1111  " + valueInER);
				// decrease ER content
				EndoplasmicReticulum.getInstance().getMembraneRecycle().put(mem, valueER - secreted);
			}

		}
		HashMap<String, Double> solubleContent = new HashMap<String,Double>();
		Set<String> solubleMet = new HashSet<String>(ModelProperties.getInstance().getSolubleMet());
		for (String sol : solubleMet){
			
			if (EndoplasmicReticulum.getInstance().getSolubleRecycle().containsKey(sol))
			{
				double valueER = EndoplasmicReticulum.getInstance().getSolubleRecycle().get(sol);
				double secreted = valueER * volume/ EndoplasmicReticulum.getInstance().getEndoplasmicReticulumVolume();	

				if (secreted >= volume) secreted = volume; // cannot incorporate more metabolite than its area
				solubleContent.put(sol, secreted);
				//	System.out.println(mem + valueER + "   UPTAKE DECREASE 1111  " + valueInER);
				// decrease ER content
				EndoplasmicReticulum.getInstance().getSolubleRecycle().put(sol, valueER - secreted);
			}

		}

		solubleContent.put("protonEn", 3.98E-5*volume); //pH 7.4
	/*		
	 new ERGIC incorporate ER components in a proportion area new/area ER
	 */		
		Context<Object> context = ContextUtils.getContext(cell);
		ContinuousSpace<Object> space = cell.getSpace();
		Grid<Object> grid = cell.getGrid();
		Endosome bud = new Endosome(space, grid, rabContent, membraneContent,
				solubleContent, initOrgProp);
		context.add(bud);
		bud.speed = 1d / bud.size;
		bud.heading = Math.random()*360;// heading random
		bud.tickCount = 1;
//		Endosome.endosomeShape(bud);
//		The new ERGIC can be anywhere in the cell
		double x = Math.random()* (50 - 8 * cellLimit);
		double y = Math.random()* (50 - 8 * cellLimit);

		space.moveTo(bud, x,y);
		grid.moveTo(bud, (int) x, (int) y);

	}

	private static void newUptake(Cell cell, String selectedRab) {
		double cellLimit = 3d * Cell.orgScale;
//		System.out.println("UPTAKE INITIAL ORGANELLES " +	InitialOrganelles.getInstance().getInitOrgProp().get("kind1"));
		HashMap<String, Double> initOrgProp = new HashMap<String, Double>(
				InitialOrganelles.getInstance().getInitOrgProp().get("kind1"));
		HashMap<String, Double> rabCell = cell.getRabCell();
//		System.out.println("RabA PM  " + rabCell.get("RabA"));

		if (!rabCell.containsKey("RabA") || Math.random()>rabCell.get("RabA")){
			return;}	
	//		Uptake generate a new RabA organelle.  The size is the radius in the csv file for RabA
	//		initial organelles.  The content is specified in concentration. One (1) is approx 1 mM.
	//		This units are converted to membrane or volume units by multiplying by the area (rabs and
	//		membrane content) or volume (soluble content).  For uptake it is controlled that there is enough
	//		membrane and there is RabA in the cell

		double maxRadius = initOrgProp.get("maxRadius");
		double minRadius = maxRadius/2;
		double a = RandomHelper.nextDoubleFromTo(minRadius,maxRadius);				
		double c = a + a  * Math.random() * initOrgProp.get("maxAsym");

		double f = 1.6075;
		double af= Math.pow(a, f);
		double cf= Math.pow(c, f);
		double area = 4d* PI*Math.pow((af*af+af*cf+af*cf)/3, 1/f);
		double plasmaMembrane = PlasmaMembrane.getInstance().getPlasmaMembraneArea() - area;
		int tick = (int) RunEnvironment.getInstance().getCurrentSchedule().getTickCount();
		uptakeArea = uptakeArea + 4d/3d*PI*a*a*c;// should area
		System.out.println(uptakeArea + " TOTAL UPTAKE UPTAKE "+ plasmaMembrane + "  "+ area + " " + tick);
		PlasmaMembrane.getInstance().setPlasmaMembraneArea(plasmaMembrane);
		
		double volume = 4d/3d*PI*a*a*c;
		initOrgProp.put("area", area);
		double value = Results.instance.getTotalRabs().get("RabA");
		value = value + area;
		Results.instance.getTotalRabs().put("RabA", value);
		initOrgProp.put("volume", volume);
		HashMap<String, Double> rabContent = new HashMap<String, Double>();
	//			UPTAKE ENDOSOME JUST RABA
		rabContent.put("RabA", area);
		
		/* Soluble and membrane content of the kind1
		 * To model molecules that cycle between PM and endosomes, such as cMHCI and mHCI
		 * the new endosome incorporates metabolites that are present in the PM.
		 * Each species has its own rate for internalization (uptake rate).
		 * Also, the new endosome cannot incorporate more than a given amount of PM metabolites
		 * In area units, no more than its surface (about 1 mM)
		 * 
		 * 
		 * */
		
		HashMap<String, Double> membraneContent = new HashMap<String,Double>();
		Set<String> membraneMet = new HashSet<String>(ModelProperties.getInstance().getMembraneMet());
		for (String mem : membraneMet){
			double valueInEn = 0d;
			double valueInPM =0d;
			double valueInTotal = 0d;

			if (PlasmaMembrane.getInstance().getMembraneRecycle().containsKey(mem))
			{
				double valuePM = PlasmaMembrane.getInstance().getMembraneRecycle().get(mem);
				valueInPM = valuePM * ModelProperties.getInstance().getUptakeRate().get(mem) * area/ PlasmaMembrane.getInstance().getPlasmaMembraneArea();	
				//				System.out.println(mem + valuePM + "   UPTAKE FROM PM 1111  " + valueInPM+membraneContent);
				// decrease PM content
				PlasmaMembrane.getInstance().getMembraneRecycle().put(mem, valuePM-valueInPM);
			}
			//			 FOR UPTAKE LOADING IN NEW ENDOSOMES
			if (InitialOrganelles.getInstance().getInitMembraneContent().get("kind1").
					containsKey(mem)) 
			{ 
				valueInEn =InitialOrganelles.getInstance().getInitMembraneContent().get("kind1").get(mem)*area; 
			} 
			valueInTotal = valueInEn + valueInPM; 
			if (valueInTotal >= area) valueInTotal= area;// cannot incorporate more metabolite than its area
			membraneContent.put(mem, valueInTotal);
//			System.out.println(mem + valueInTotal + "   UPTAKE FROM PM 1111  " + valueInPM+membraneContent);
		}
		if (PlasmaMembrane.getInstance().getMembraneRecycle().containsKey("membraneMarker")
				&& PlasmaMembrane.getInstance().getMembraneRecycle().get("membraneMarker") > 0) 
		{
			membraneContent.put("membraneMarker", 1.0);
			PlasmaMembrane.getInstance().getMembraneRecycle().remove("membraneMarker"); 			
		}

		
		HashMap<String, Double> solubleContent = new HashMap<String,Double>();
		Set<String> solubleMet = new HashSet<String>(ModelProperties.getInstance().getSolubleMet());
		for (String sol : solubleMet){
			double valueInEn = 0d;
			double valueInPM =0d;
			double valueInTotal;

			if (PlasmaMembrane.getInstance().getSolubleRecycle().containsKey(sol))
			{
				double valuePM = PlasmaMembrane.getInstance().getSolubleRecycle().get(sol);
				valueInPM = valuePM * volume/ PlasmaMembrane.getInstance().getPlasmaMembraneVolume();	
				// decrease PM content
				PlasmaMembrane.getInstance().getSolubleRecycle().put(sol, valuePM - valueInPM);
			}
			// FOR UPTAKE LOADING IN NEW ENDOSOMES
			if (InitialOrganelles.getInstance().getInitSolubleContent().get("kind1").containsKey(sol)) 
			{ 
				valueInEn =InitialOrganelles.getInstance().getInitSolubleContent().get("kind1").get(sol)*volume; 
			}
			valueInTotal = valueInEn + valueInPM; 

			if (valueInTotal >= volume) valueInTotal= volume;// cannot incorporate more metabolite than its volume
			solubleContent.put(sol, valueInTotal);
			}

		solubleContent.put("protonEn", 3.98E-5*volume); //pH 7.4
		Context<Object> context = ContextUtils.getContext(cell);
		ContinuousSpace<Object> space = cell.getSpace();
		Grid<Object> grid = cell.getGrid();
		Endosome bud = new Endosome(space, grid, rabContent, membraneContent,
				solubleContent, initOrgProp);
		context.add(bud);
		bud.speed = 0;//1d / bud.size;
		bud.heading = Math.random()*360;// heading random
		bud.tickCount =1;
//		Position random in a circle around the center of the cell
//		Should change when the shape of the cell changes
		double xend =0;
		double yend =0;
		int randomSide = (int) Math.floor(Math.random()*4);
		switch (randomSide) {
		case 0 : {
			xend = 2*cellLimit;
			yend = Math.random()*(50-2*cellLimit);
			break;
		}
		case 1 : {
			xend = 50-2*cellLimit;
			yend = Math.random()*(50-2*cellLimit);
			break;
		}
		case 2 : {
			xend = Math.random()*(50-2*cellLimit);
			yend = 2*cellLimit;
			break;
		}
		case 3 : {
			xend = Math.random()*(50-2*cellLimit);
			yend = 50-2*cellLimit;
			break;
		}
		}		
		bud.heading = Math.atan2(xend-25, yend-25)*180/Math.PI; //;
//		System.out.println(xend + " donde lo pongo " + yend);
		bud.getSpace().moveTo(bud, xend, yend);
		bud.getGrid().moveTo(bud, (int) xend, (int) yend);

	PlasmaMembrane.getInstance().getPlasmaMembraneTimeSeries().clear();
	
		
	}

		
}
