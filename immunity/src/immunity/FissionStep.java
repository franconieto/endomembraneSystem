package immunity;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.concurrent.TimeUnit;

import repast.simphony.context.Context;
import repast.simphony.random.RandomHelper;
import repast.simphony.space.continuous.ContinuousSpace;
import repast.simphony.space.continuous.NdPoint;
import repast.simphony.space.grid.Grid;
import repast.simphony.util.ContextUtils;
import repast.simphony.util.collections.Contains;

public class FissionStep {
	/*
	 * This class Split the endosome in two
	 * A tubule/vesicle is formed from the endosome carrying a single membrane domain (rab).
	 * The rab in-tubule is selected from the rab content of the endosome at random.  However, some rabs
	 * are selected preferentially (tubuleTropism from inputIntrTransp3.csv)
	 *  The rab-in-tubule is substracted from the rest of the organelle, which is a round-larger structure, with 
	 *  the remaining rab content. For fission to occur, the tubule must have a minimum size and the organelle left, 
	 *  enough membrane to contain the internal vesicles and particulated cargoes  
	 *  Golgi forms mostly vesicles.
	 *  Golgi vesicles are formed from Golgi organelles with a probability
	 *  proportional to the area of the Golgi organelle.
	 *  The more complex process is to distribute the content of the endosome
	 *  between the two organelles.
	 *  
	 * 
	 */
	private static ContinuousSpace<Object> space;
	private static Grid<Object> grid;
	static double cellLimit = 3 * Cell.orgScale;
	static final double PI = Math.PI;
    static double rcyl = Cell.rcyl;
    static double aminCyl = Cell.mincyl;
    static double vminCyl = 2 * PI * rcyl * rcyl * rcyl;
    
	
	public static void split(Endosome endosome) {	
		space = endosome.getSpace();
		grid = endosome.getGrid();

		
		String rabInTube = null;
		double vo = endosome.volume;
		double so = endosome.area;
		double minV = 0d;//		minimal volume
		if (endosome.getSolubleContent().containsKey("mvb")) {
//			Modifiqué 4/3 a 3/3 porque de otro modo no corta los lisosomas con muchas IV
			minV = endosome.getSolubleContent().get("mvb")* 3/3 * PI * Cell.rIV * Cell.rIV * Cell.rIV;
		}
		if (endosome.getSolubleContent().containsKey("solubleMarker")
				&& endosome.getSolubleContent().get("solubleMarker")>0.9) {
			minV = minV + ModelProperties.getInstance().getCellK().get("beadVolume"); // 5E8 bead volume. Need to be introduced in Model Properties
		}
		
		for (String key : endosome.getSolubleContent().keySet()) {
		    if (key.startsWith("bead") && endosome.getSolubleContent().get(key) > 0.9) {
		    	minV = minV + ModelProperties.getInstance().getCellK().get("beadVolume");
		        break;
		    }
		}
		if (vo - minV < 2 * vminCyl) {
			if (endosome.c>1500)	//System.out.print*ln(minV + " 1 NO CORTA endosome RabInTubeSelected " + vo );

			return; // if available volume too small to form two mincyl do not split. Volume of a cylinder of 2
		}		// cylinder radius long (almost a sphere)
		if (so < 2 * aminCyl) {
//			if (endosome.c>1500)	//System.out.print*ln("2 NO CORTA endosome RabInTubeSelected " + rabInTube);

			return; // if the surface is less than two minimus tubules, abort
					// splitting
		}
		double vv = vo - vminCyl;
		double ss = so - aminCyl;
		if (ss * ss * ss / (vv * vv) <= 36.01 * PI){ 
//			//System.out.print*ln("NO ALCANZA" + endosome.getRabContent());
//			if (endosome.c>1500)	//System.out.print*ln("3 NO CORTA endosome RabInTubeSelected " + rabInTube);

			return;
		} // organelle is an sphere
// if s^3 / v^2 is equal to 36*PI then it is an sphere and cannot form a tubule
// if the area and volume after budding a minimal tubule is	less than 36*PI, then cannot form a tubule	
//		if (vo / (so - 2 * Math.PI * Cell.rcyl * Cell.rcyl) == Cell.rcyl / 2) {
//			//System.out.print*ln("tubuleTubule" + vo + " " + so);
//		}

		double rsphere = Math.pow((vo * 3) / (4 * PI), (1 / 3d));// calculate
		// the radius of the sphere with a given volume

		double ssphere = (4 * PI * rsphere * rsphere);// area of a sphere
															// containing the
															// volume
		if ((so - ssphere) < aminCyl){
// if not enough surface to contain the volume plus a
// minimum tubule, no split
//			//System.out.print*ln("small tubule left " +so + "  " + ssphere + "  " + (so-ssphere));			if (endosome.c>1500)	//System.out.print*ln(" NO CORTA endosome RabInTubeSelected " + rabInTube);
			if (endosome.c > 150/Cell.orgScale)	//System.out.print*ln(" NO CORTA endosome RabInTubeSelected " + rabInTube);

			return; 
		}

		rabInTube = rabInTube(endosome); // select a rab for the tubule
		//if (endosome.c>1500)	//System.out.print*ln(" NO CORTA endosome RabInTubeSelected " + rabInTube);

		boolean isGolgi = isGolgi(endosome);
		if (rabInTube == null) return; // if non is selected, no fission
		if (endosome.rabContent.get(rabInTube)<= aminCyl) return; // the rab area is too small		
		double scylinder = aminCyl; // surface minimum cylinder 2*radius
		// cylinder high
		double vcylinder = vminCyl; // volume	
		// minimum cylinder
		if (ModelProperties.getInstance().getRabOrganelle().get(rabInTube).contains("Golgi") && isGolgi)
		{ // Golgi domain from a Golgi organelle
			double probFission = (endosome.area - Cell.minCistern)/(2*Cell.maxCistern-Cell.minCistern);// (endosome.area - Cell.minCistern)/(2*Cell.maxCistern-Cell.minCistern);hacer constante
			if ( Math.random() > probFission){
//		Small cisterns has lower probability of forming vesicles
				return;
			} 
			else
			{
				double[] areaVolume = areaVolumeCistern(endosome, rabInTube);
				scylinder = areaVolume[0];
				vcylinder = areaVolume[1];

			}
		}
		else //non Golgi domain or Golgi domain budding from a non Golgi organelle
		{
			double[] areaVolume = areaVolumeTubule(endosome, rabInTube);
			scylinder = areaVolume[0];
			vcylinder = areaVolume[1];		
		}
	

		/*
		 * the volume of the vesicle is formed subtracting the volume of the
		 * formed cylinder from the total volume. Same for the area
		 * 
		 * From the information of vcylinder and scylinder, the organelle is
		 * splitted in two, a sphere and tubule (case 2) or in two almost
		 * tubules (a pice of the lateral surface must be used to close the
		 * tubules
		 */
		double vVesicle = vo - vcylinder;
		if(vVesicle < 0 || vcylinder < 0){
			//System.out.print*ln(vVesicle +"surface and volume"+ vcylinder);	
		}
		double sVesicle = so - scylinder;
		/*
		 * FORMATION 1ST ORGANELLE (referred as sphere) the rab-in-tubule of the
		 * tubule is substracted from the original rab-in-tube content of the
		 * organelle the final proportion of the rab-in-tubule in the vesicular
		 * organelle is obtained dividein by the total surface of the vesicle
		 */
		endosome.area = sVesicle;
		endosome.volume = vVesicle;
		
		Endosome.endosomeShape(endosome);

		/*
		 * CONTENT DISTRIBUTION Rab in the tubule is sustracted
		 */
		double rabLeft = endosome.rabContent.get(rabInTube) - scylinder;
		if (rabLeft < 0) {
			//System.out.println(rabInTube + endosome.rabContent.get(rabInTube)
			//		+ "surfaceCy" + scylinder);
//			//System.out.println(endosome.rabContent);
		}
		endosome.rabContent.put(rabInTube, rabLeft);
		
		HashMap<String, Double> copyMembrane = new HashMap<String, Double>(
				endosome.membraneContent);
		membraneContentSplit(endosome, rabInTube, so, sVesicle);
		
		HashMap<String, Double> copySoluble = new HashMap<String, Double>(
				endosome.solubleContent);
		solubleContentSplit(endosome, rabInTube, vo, vVesicle);

		
		endosome.size = Math.pow(endosome.volume * 3d / 4d / PI, (1d / 3d));

		endosome.speed = 1d / endosome.size;
//		Time series are re calculated in the next tick
		endosome.getRabTimeSeries().clear();
		endosome.getEndosomeTimeSeries().clear();

		HashMap<String, Double> newRabContent = new HashMap<String, Double>();
		newRabContent.put(rabInTube, scylinder);
		HashMap<String, Double> newInitOrgProp = new HashMap<String, Double>();
		newInitOrgProp.put("area", scylinder);
		newInitOrgProp.put("volume", vcylinder);
		HashMap<String, Double> newMembraneContent = new HashMap<String, Double>();
		for (String content : copyMembrane.keySet()) {
			newMembraneContent.put(content, copyMembrane.get(content)
					- endosome.membraneContent.get(content));
		}
		HashMap<String, Double> newSolubleContent = new HashMap<String, Double>();
		for (String content : copySoluble.keySet()) {
			newSolubleContent.put(content, copySoluble.get(content)
					- endosome.solubleContent.get(content));
		}
		Endosome b = new Endosome(endosome.getSpace(), endosome.getGrid(), newRabContent,
				newMembraneContent, newSolubleContent, newInitOrgProp);
		Context<Object> context = ContextUtils.getContext(endosome);
		context.add(b);
		b.area = scylinder;
		b.volume = vcylinder;
		Endosome.endosomeShape(b);
		b.size = Math.pow(b.volume * 3d / 4d / PI, (1d / 3d));
		b.speed = 1d / b.size;
		Random rd = new Random();
//		Time series will be recalculated in the next tick
		b.getEndosomeTimeSeries().clear();
		b.getRabTimeSeries().clear();
		b.heading = endosome.heading + rd.nextGaussian() * 30d;
//		Better keep the same tickCount
		b.tickCount = endosome.tickCount;//1 + (int) (endosome.tickCount * b.area/(endosome.area + b.area));
		double deltax = Math.cos(endosome.heading * 2d * PI / 360d)
				* (endosome.size + b.size) * Cell.orgScale/30;
		double deltay = Math.sin(endosome.heading * 2d * PI / 360d)
				* (endosome.size+ b.size)* Cell.orgScale/30;
		
		NdPoint myPoint = space.getLocation(endosome);
		double x = myPoint.getX()+ deltax;

		double y = myPoint.getY()+ deltay;

		if (y < cellLimit)y= cellLimit;		
		if (y > 50 - cellLimit)y = 50-cellLimit;
		if (x < cellLimit) x = cellLimit;
		else if (x > 50 -cellLimit) x = 50 - cellLimit;
		space.moveTo(b, x, y);
		grid.moveTo(b, (int) x, (int) y);

//		if (b.c>100/Cell.orgScale) {
//			//System.out.print*ln(b.c+"  bbbbbbbbbbbbbbccccccccccccccccccccorta de nuevo  " );
//			split(b);
//		}
//		To avoid too long tubules, the split is repeated
		if (endosome.c > 150/Cell.orgScale) {
//			//System.out.print*ln(endosome.c+"  ccccccccccccccccccccccccccccccccccorta de nuevo  " );
			split(endosome);
		}
	}
	
	private static double[] areaVolumeCistern(Endosome endosome, String rabInTube)
	{

		if (Math.random()<0.9){// standard 0.9
			// high probability of forming a single vesicle.  SET TO 0.9
			return new double[] {aminCyl, vminCyl};
		}
		else
		{
			double vo = endosome.volume;
			double so = endosome.area;
			double rsphere = Math.pow((vo * 3) / (4 * PI), (1 / 3d));// calculate
			// the radius of the sphere with a given volume
			double ssphere = (4 * PI * rsphere * rsphere);// area of a sphere
			// containing the volume
			double scylinder = 0; 
			double vcylinder = 0;	
			do{
				vcylinder = vcylinder + vminCyl;// volume of minimal cylinder PI*rcyl^2*2*rcyl
				// add a minimal volume
				double aradius =Math.sqrt(vcylinder /(2*PI*rcyl)); // from vcylinder = PI*aradius^2 * cistern height (2 rcyl)
				scylinder = 2*PI*aradius*aradius + 4*PI*aradius*rcyl;//from Scyl = 2*PI*aradius^2+4*PI*aradius*rcyl
				////System.out.print*ln("SPLIT CISTERN vo"+vo+"  so  "+so+"  vcylinder "+vcylinder+"  scylinder "+ scylinder);

				// //System.out.print*ln(scylinder +"surface and volume"+ vcylinder);
			}
			while (
					(so - ssphere - scylinder > 4 * PI * Math.pow(rcyl, 2))
					// organelle area should be enough to cover the volume (ssphere)
					// plus the cylinder already formed (scylinder) and to
					// elongate a two r cylinder (without caps)
					&&(endosome.rabContent.get(rabInTube) - scylinder > 4 * PI * Math.pow(rcyl, 2))// the Rab area should b enough
					// to cover the minimum cylinder and to elongate a two r cylinder
					&& ((vo - vcylinder - 2 * PI * Math.pow(rcyl, 3))>4 * PI * Math.pow(rcyl, 3))
					&& ((vo - vcylinder)/((so-scylinder)-2*PI*rcyl*rcyl)>rcyl/2)
					); 
			return new double[] {scylinder, vcylinder};		
		}
	}

	private static double[] areaVolumeTubule(Endosome endosome, String rabInTube)
	{
		//		the organelles is assessed to be a tubule for the vo/so relationship. If it is a 
		//		tubule, the rules for splitting are different
		double vo = endosome.volume;
		double so = endosome.area;
		double rsphere = Math.pow((vo * 3) / (4 * PI), (1 / 3d));// calculate
		// the radius of the sphere with a given volume

		double ssphere = (4 * PI * rsphere * rsphere);// area of a sphere
		// containing the
		// volume
		double scylinder = aminCyl; // surface minimum cylinder 2*radius
		// cylinder high
		double vcylinder = vminCyl; // volume	


		if (vo / (so - 2 * PI * rcyl * rcyl) <= rcyl / 2) {// should be 2
			//			if it is a tubule
			if (endosome.rabContent.get(rabInTube)>= endosome.area/2){
				//				if it is a tubule and the rab selected has enough area, divide in two
				vcylinder = endosome.volume/2;
				scylinder = endosome.area/2;

//				//System.out.print*ln("tubule cut in two");
				return new double[] {scylinder, vcylinder};
			}
			else {
				//				if it is a tubule and the Rab selected is not enough, generate a tubule with the 
				//				available Rab area
				scylinder = endosome.rabContent.get(rabInTube);
				vcylinder = vo* endosome.rabContent.get(rabInTube)/endosome.area;
//				//System.out.print*ln("tubule cut assymetric" + scylinder +" "+ vcylinder
//						+" "+ vo);
				return new double[] {scylinder, vcylinder};
			}
		}
		else // following rules are for an organelle that is not a tubule
		{
			double minV = 0d;
			if (endosome.getSolubleContent().containsKey("mvb")) {
				minV = endosome.getSolubleContent().get("mvb")* 4/3 * PI * Cell.rIV * Cell.rIV * Cell.rIV;
			}
			if (endosome.getSolubleContent().containsKey("bead")
					&& endosome.getSolubleContent().get("bead")>0.9) {
				minV = minV + ModelProperties.getInstance().getCellK().get("beadVolume"); // 5E8 bead volume. Need to be introduced in Model Properties
			}
			if (endosome.getSolubleContent().containsKey("solubleMarker")
					&& endosome.getSolubleContent().get("solubleMarker")>0.9) {
				minV = minV + ModelProperties.getInstance().getCellK().get("beadVolume"); // 5E8 bead volume. Need to be introduced in Model Properties
			}
			while ((so - ssphere - scylinder > 4 * PI * Math.pow(rcyl, 2))
					// organelle area should be enough to cover the volume (ssphere)
					// to cover the cylinder already formed (scylinder) and to
					// elongate a two r cylinder (without caps)
					&& (endosome.rabContent.get(rabInTube) - scylinder > 4 * PI
							* Math.pow(rcyl, 2))// the Rab area should b enough
					// to cover the minimum cylinder and to elongate a two r cylider
					&& (scylinder < 0.5 * so) // the area of the cylinder must not
					// be larger than 50% of the total
					// area
					&& ((vo - minV - vcylinder - 2 * PI * Math.pow(rcyl, 3))>4 * PI * Math.pow(rcyl, 3))
//					The volume left (vo - volume of the formed cylinder - volume of an additional cylinder unit) must be larger
//					than 2 x minimal cylinders
					&& Math.random()< 0.9 //cut the tubule with a 10% probability in each step.  Prevent too long tubules
					) {
				/*
				 * while there is enough membrane and enough rab surface, the tubule
				 * grows
				 */

				scylinder = scylinder + 4 * PI * Math.pow(rcyl, 2);
				// add a cylinder without caps (the caps were considered in
				// the mincyl
				vcylinder = vcylinder + vminCyl;
				// add a volume
				// //System.out.print*ln(scylinder +"surface and volume"+ vcylinder);
			}
			return new double[] {scylinder, vcylinder};	
		}
	}

	private static void membraneContentSplit(Endosome endosome, String rabInTube, Double so, Double sVesicle) {
		// MEMBRANE CONTENT IS DISTRIBUTED according rabTropism
		// new with a copy of endosome.membraneContent;
		// copy rabTropism from ModelProperties
		HashMap<String, Double> copyMembrane = new HashMap<String, Double>(
				endosome.membraneContent);
		HashMap<String, Set<String>> rabTropism = new HashMap<String, Set<String>>(
				ModelProperties.getInstance().getRabTropism());
		for (String content : copyMembrane.keySet()) {
// if no specification, even distribution proportional to the area
			if (!rabTropism.containsKey(content)){
				splitPropSurface(endosome, content, so, sVesicle);	
			}
// if tropism to tubule, the content goes to tubule			
			else if (rabTropism.get(content).contains("tub")){
				splitToTubule(endosome, content, so, sVesicle);
			}
// if tropism to sphere, the content goes to the vesicle		
			else if (rabTropism.get(content).contains("sph")){
				splitToSphere(endosome, content, so, sVesicle);
			}
			else 
// finally, if tropism it to a Rab membrane domain, the decision about where to go
// requires to calculate the tropism to the vesicle (SUM of the content tropism to all the
//	membrane domains in the vesicle(notice that at this point the rabContent of the endosome is the one
//	left after the tubule budding).  The tropism is indicated by a string (e.g. RabA10) where
//	the last two digits indicate the affinity for the Rab domain in a scale of 00 to 10.			
			{
			double sphereTrop = 0;
			for (String rabTrop : rabTropism.get(content)){
				if (rabTrop.equals("mvb")) continue;
					String rab = rabTrop.substring(0, 4);
					if (endosome.rabContent.containsKey(rab)){
						sphereTrop = sphereTrop + endosome.rabContent.get(rab)/endosome.area*
								Integer.parseInt(rabTrop.substring(4, 6));
//						//System.out.print*ln("Trop Number " + Integer.parseInt(rabTrop.substring(4, 6)));
					}
			}
// the tropism to the tubule is directly the two digits of the Rab selected for the tubule 
			double tubuleTrop = 0;
			for (String rabTrop : rabTropism.get(content)){
				if (rabTrop.equals("mvb")) continue;
				String rab = rabTrop.substring(0, 4);
				if (rab.equals(rabInTube)){
					tubuleTrop = Integer.parseInt(rabTrop.substring(4, 6));
				}
			}
//			//System.out.print*ln("sphere tubule " + sphereTrop +" "+ tubuleTrop+ " " +(tubuleTrop-sphereTrop));

// NEW 23/7/2021 if no tropism, (totaltrop = 0) proportional to surface
// NEW 15/9/2021			Or if shereTrop = tubuleTrop proportional to surface

			double totalTrop = sVesicle * sphereTrop + (so-sVesicle)* tubuleTrop;
			if (totalTrop == 0
					|| sphereTrop == tubuleTrop) {
				splitPropSurface(endosome, content, so, sVesicle);
			}
			else {
// NEW 23/7/2021  else, proportional to the surface and to the tropism to sphere and tubule	
// NEW 15/9/2021.  To make the value of the tropism important when the cargo has no tropism for one
//	of the compartments, a small amount is added to avoid zero tropisms. 
// Hence, a new totalTropism needs to be calculated	
			totalTrop = sVesicle * (sphereTrop + 0.01) + (so-sVesicle)* (tubuleTrop + 0.01);
			double proportionVesicle = sVesicle * (sphereTrop + 0.01)/ totalTrop;
//			//System.out.print*ln(content + " FISSION " + sphereTrop +" FISSION " + tubuleTrop +" FISSION " + totalTrop +" FISSION " + proportionVesicle);
	//		if (proportionVesicle * content >= sVesicle) {}
			splitPropSurfaceAndTropism(endosome, content, so, sVesicle, proportionVesicle);
			}			
			}
		}
	}				
					

		
	

	private static void solubleContentSplit(Endosome endosome, String rabInTube, double vo, double vVesicle){
		// SOLUBLE CONTENT IS DISTRIBUTED according rabTropism
		HashMap<String, Double> copySoluble = new HashMap<String, Double>(
						endosome.solubleContent);
		HashMap<String, Set<String>> rabTropism = new HashMap<String, Set<String>>(
						ModelProperties.getInstance().getRabTropism());
				
		for (String content : copySoluble.keySet()) {
			if (!rabTropism.containsKey(content)) 
			{// not a
				// specified tropism or no tropism for the rabInTube,
				// hence, distribute according to
				// the volume ratio
				SolSplitPropVolume(endosome, content, vo, vVesicle);
			}

			else if (rabTropism.get(content).contains("tub")) 
			{
				SolSplitToTubule(endosome, content, vo, vVesicle);

			}
			else if (rabTropism.get(content).contains("sph")) { // if the tropism
				// is "0" goes
				// to the sphere

				SolSplitToSphere(endosome, content, vo, vVesicle);	

			}
			else{// rabtropism for the content is not "tub" or "sph", then distribute according to volume 
				SolSplitPropVolume(endosome, content, vo, vVesicle);
			}
		}


	}

	private static void SolSplitPropVolume(Endosome endosome, String content, double vo, double vVesicle){
		HashMap<String, Double> copySoluble = new HashMap<String, Double>(
				endosome.solubleContent);
//		HashMap<String, Set<String>> rabTropism = new HashMap<String, Set<String>>(
//				ModelProperties.getInstance().getRabTropism());
		if (content.equals("solubleMarker") && (endosome.solubleContent.get("solubleMarker") > 0.9)) {
			if (Math.random() < vVesicle / vo) endosome.solubleContent.put(content, 1d);
			} 
		else 
		{
			endosome.solubleContent.put(content, copySoluble.get(content)
					* (vVesicle) / vo);
		}

	}
	private static void SolSplitToSphere(Endosome endosome, String content, double vo, double vVesicle){
		HashMap<String, Double> copySoluble = new HashMap<String, Double>(
				endosome.solubleContent);
			endosome.solubleContent.put(content,
					copySoluble.get(content));
	}
	
	private static void SolSplitToTubule(Endosome endosome, String content, double vo, double vVesicle){
		HashMap<String, Double> copySoluble = new HashMap<String, Double>(
				endosome.solubleContent);

		double vcylinder = vo - vVesicle;
		if (copySoluble.get(content) > vcylinder) {
			endosome.solubleContent.put(content,
					copySoluble.get(content) - vcylinder);
		} else
			endosome.solubleContent.put(content, 0.0d);
	}
	
	
	private static void splitToTubule(Endosome endosome, String content, double so, double sVesicle) {
		HashMap<String, Double> copyMembrane = new HashMap<String, Double>(
				endosome.membraneContent);

		double scylinder = so - sVesicle;
		if (copyMembrane.get(content) > scylinder) {
			endosome.membraneContent.put(content,
					copyMembrane.get(content) - scylinder);
		} else
			endosome.membraneContent.put(content, 0.0d);
		
	}

	private static void splitToSphere(Endosome endosome, String content, double so, double sVesicle) {
		HashMap<String, Double> copyMembrane = new HashMap<String, Double>(
				endosome.membraneContent);

		if (copyMembrane.get(content) > sVesicle) {
			endosome.membraneContent.put(content, sVesicle);
		} else
			endosome.membraneContent.put(content,
					copyMembrane.get(content));
		
	}

	private static void splitPropSurface(Endosome endosome, String content, Double so, Double sVesicle) {
			
		HashMap<String, Double> copyMembrane = new HashMap<String, Double>(
				endosome.membraneContent);

		if (content.equals("membraneMarker")
				&& (endosome.membraneContent.get("membraneMarker") > 0.9)) {
			if (Math.random() < sVesicle / so)
				endosome.membraneContent.put("membraneMarker", 1d);
			else {endosome.membraneContent.put("membraneMarker", 0d);}
			} 
		else {
			endosome.membraneContent.put(content, copyMembrane.get(content)
						* (sVesicle) / so);	
		}
			
	
	}
	
	private static void splitPropSurfaceAndTropism(Endosome endosome, String content, Double so, Double sVesicle, Double proportionVesicle) {
		
		HashMap<String, Double> copyMembrane = new HashMap<String, Double>(
				endosome.membraneContent);

		if (content.equals("membraneMarker")
				&& (endosome.membraneContent.get("membraneMarker") > 0.9)) {
			if (Math.random() < proportionVesicle)
				endosome.membraneContent.put("membraneMarker", 1d);
			else {endosome.membraneContent.put("membraneMarker", 0d);}
		} 
//		if too much content to fit in the sphere, include only the surface of the sphere
		else {
			if (copyMembrane.get(content)* proportionVesicle > sVesicle) {
				endosome.membraneContent.put(content, sVesicle);
			} 
//			if too much content to fit into the tubule, include only the surface of the tubule
			else if (copyMembrane.get(content)* (1-proportionVesicle) > (so-sVesicle)) { 
				endosome.membraneContent.put(content, copyMembrane.get(content)-(so-sVesicle));
			}
			else
			{
				endosome.membraneContent.put(content, copyMembrane.get(content)
						* proportionVesicle);
			}

		}

	
	}

	public static String rabInTube(Endosome endosome) {
		HashMap<String, Double> copyMap = new HashMap<String, Double>(
				endosome.rabContent);
		// copyMap.putAll(endosome.rabContent);
		String rab = null;
		// //System.out.print*ln("CopyMap "+copyMap);
		for (String rab1 : endosome.rabContent.keySet()) {
			if (copyMap.get(rab1) < aminCyl) {
				copyMap.remove(rab1);
			}
		}
		if (copyMap.isEmpty()) {
//		//System.out.print*ln(aminCyl + "NINGUN RAB " + endosome.rabContent);
			return null;
		}

		if (copyMap.size() < 2) {

			for (String rab1 : copyMap.keySet()) {
//				//System.out.print*ln("UNICO RAB " + copyMap);
				return rab1;
			}
		}

		else {
			
			List<String> keys = new ArrayList(copyMap.keySet());
			Collections.shuffle(keys);			

//				Picks a Rab domain according to the relative "tubule tropism" of the Rab domains present
//				Rabs with larger tubule tropism have more probability of being selected


				double totalTubuleTropism = 0d;
//				add all the tubule tropisms of the rab domains
				for (String rab1 : keys) {
					totalTubuleTropism = totalTubuleTropism + ModelProperties.getInstance().getTubuleTropism().get(rab1);
				}

// 				select a random number between 0 and total tubule tropism.  Notice that it can be zero
				double rnd = Math.random() * totalTubuleTropism;
				double tubuleTropism = 0d;
//				select a rab domain with a probability proportional to its tubule tropism
				for (String rab1 : keys){
				tubuleTropism = tubuleTropism + ModelProperties.getInstance().getTubuleTropism().get(rab1);
					if (rnd <= tubuleTropism){
	//				if (endosome.c>1500)	//System.out.print*ln(copyMap + " Large endosome RabInTubeSelected " + rab1);
						return rab1;
					}
				}

			}
			
		return null;// never used
	}
	private static boolean isGolgi(Endosome endosome) {
	    double areaGolgi = 0.0;
	    Map<String, Double> rabContent = endosome.getRabContent();
	    Map<String, String> modelProperties = ModelProperties.getInstance().getRabOrganelle();
	    for (String rab : rabContent.keySet()) {
	        String name = modelProperties.get(rab);
	        if (name.contains("Golgi")) {
	            areaGolgi += rabContent.get(rab);
	        } 
	    }
	    return areaGolgi / endosome.area >= 0.5;
	}


}
