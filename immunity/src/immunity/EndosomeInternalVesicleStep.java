package immunity;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.TimeUnit;

import repast.simphony.space.continuous.ContinuousSpace;
import repast.simphony.space.grid.Grid;

public class EndosomeInternalVesicleStep {
	/*	
		This class is responsible for the formation of internal vesicles in endosomes.
		Some domains can form internal vesicles, decreasing the area and increasing the volume.
		Several conditions are required. Tubules cannot form IV. The area should be enough to contain the existing IV plus
		the new one.  It also should consider the presence of a bead (soluble marker with a volume).
		
			*/
	static double PI = Math.PI;
	static double rcyl = ModelProperties.getInstance().cellK.get("rcyl");
	static double beadVolume = ModelProperties.getInstance().getCellK().get("beadVolume");

	public static void internalVesicle(Endosome endosome) {
		// if it is a sphere do not for  internal vesicles. Not enough membrane
		double so = endosome.area;
		double vo = endosome.volume;
		boolean isSphere = (so * so * so / (vo * vo) <= 36.001 * PI); 
		if (isSphere) return;
		// if it is a tubule do not for  internal vesicles
		boolean isTubule = (endosome.volume/(endosome.area - 2*PI*rcyl*rcyl) <=rcyl/2);
		if (isTubule) return;
		double rIV = rcyl; // Internal vesicle radius
		double vIV = 4 / 3 * PI * Math.pow(rIV, 3); // volume 33510
		double sIV = 4 * PI * Math.pow(rIV, 2);// surface 5026
		if (vo < 2 * vIV) // too small
			return;
		if (so < 2 * sIV)// too small
			return;
		//	Organelles with Rabs corresponding to EE, SE and LE can form internal vesicles
		String maxRab = Collections.max(endosome.rabContent.entrySet(), Map.Entry.comparingByValue()).getKey();
		String organelle = ModelProperties.getInstance().getRabOrganelle().get(maxRab);
		//		System.out.println("ORGANELLE  " + organelle);
		if (!organelle.equals("EE")
				&& !organelle.equals("SE")
				&& !organelle.equals("LE"))
		{
			return;
		}
		double vp = vo + vIV;
		double sp = so - sIV;
//		if after the formation of a new vesicles it is a sphere (no extra membrane for the volume) stop
			if (sp * sp * sp / (vp * vp) <= 36 * PI) return;
//		Control if there is enough membrane to contain the already present internal vesicles 
//		plus the new one. Control if there is a bead (soluble marker with a volume)
		double minV = 0d;//		minimal volume = volume bead + volume mvb
		double mvbVolume = 0d; // volume of the mvb
		if (endosome.getSolubleContent().containsKey("solubleMarker")
				&& endosome.getSolubleContent().get("solubleMarker")>0.9) {
			minV = beadVolume; // 5E8 bead volume. Need to be introduced in Model Properties
		}
		if (endosome.solubleContent.containsKey("mvb")) {
			mvbVolume = endosome.solubleContent.get("mvb")*vIV + vIV;
		}
		minV = minV + mvbVolume;
		if (sp * sp * sp / (minV * minV) <= 36 * PI) return;

		//		System.out.println("INTERNAL VESICLE ORGANELLE" + organelle);
//	After all this control, a single vesicle is formed.

		int nroVesicles = 1;
		HashMap<String, Set<String>> rabTropism = new HashMap<String, Set<String>>(
				ModelProperties.getInstance().getRabTropism());
		endosome.area = endosome.area - nroVesicles * sIV;
		endosome.volume = endosome.volume + nroVesicles * vIV;
//		System.out.println("Nro Vesicles " + nroVesicles +"  "+ endosome.area +"  "+ endosome.volume);
		//Endosome.endosomeShape(endosome);
		if (endosome.solubleContent.containsKey("mvb")) {
			double content = endosome.solubleContent.get("mvb") + nroVesicles;
			endosome.solubleContent.put("mvb", content);
		} else {
			endosome.solubleContent.put("mvb", (double) nroVesicles);
		}
		for (String rab : endosome.rabContent.keySet()) {
			double content1 = endosome.rabContent.get(rab) * (so - nroVesicles * sIV) / so;
			endosome.rabContent.put(rab, content1);
		}

		// Membrane content with mvb tropism is degraded (e.g. EGF)
		//this can be established in RabTropism adding in the EGF tropisms "mvb",
		for (String content : endosome.membraneContent.keySet()) {
//			System.out.println(endosome.membraneContent+"\n"+ content + "\n" + " CHOLESTEROL RAB TROPISM " + rabTropism.get(content)+ "  \n"+rabTropism);
			if(content.equals("membraneMarker")) {
				if (endosome.membraneContent.get("membraneMarker")>0.9){
					endosome.membraneContent.put("membraneMarker", 1d);
				}
				else{
					endosome.membraneContent.put("membraneMarker", 0d);
				}

			}
			else if (rabTropism.get(content).contains("mvb")){				
// if "mvb" tropism, the cargo is incorporated into internal vesicles and digested
				double mem = endosome.membraneContent.get(content) - nroVesicles * sIV;

				if (mem <= 0) mem = 0d;
				endosome.membraneContent.put(content, mem);
			} 
			else if (rabTropism.get(content).contains("noMvb")){				
// if "noMvb" tropism, the cargo is excluded from the internal vesicles
				double mem = endosome.membraneContent.get(content);

		//		if (mem > endosome.area) mem = endosome.area;
				endosome.membraneContent.put(content, mem);
//If not special tropism, the membrane content is incorporated 
//into the internal vesicle proportional to the surface and degraded
			} 
			else 
			{

				double mem = endosome.membraneContent.get(content) * (so - nroVesicles * sIV)
						/ so;
				endosome.membraneContent.put(content, mem);
			}
		}

	}
}


