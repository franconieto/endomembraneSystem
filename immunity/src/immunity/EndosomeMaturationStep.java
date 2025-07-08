package immunity;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*
 * this class is responsible for the maturation of endosomes.
 * 
*/
public class EndosomeMaturationStep {
	
	public static void matureCheck (Endosome endosome) {
		String maxRab = Collections.max(endosome.rabContent.entrySet(), Map.Entry.comparingByValue()).getKey();
//		if the maxRab is not prevalent, return
		if (endosome.rabContent.get(maxRab)/endosome.area < 0.5) return; //LUIS ERA 0.9
//		Maturation according to the maxRab. First argument (oldRab) is the Rab that matures to the second argument (newRab)
//		The third argument is the proportion of the total domain that matures.  Most for Rab5-Rab7 and the Golgi domains.  Only
//		10% for Rab5-Rab22).5% for RabB-RabC
		findingMaturationsKeys(endosome, ModelProperties.getInstance().getRabMaturation(), maxRab);
			////System.out.print*ln("NOMBRE "+this.getName()+" Relative RabA  "+relativeRabA+" Cuenta  "+this.getTickCount());
		}

    public static void findingMaturationsKeys(Endosome endosome, HashMap<String, Double> map, String prefix) {
		if (Math.random() > endosome.tickCount / 3000) {return;}
        List<Map.Entry<String, Double>> entries = new ArrayList<>(map.entrySet());
     // Only a maturation is allowed if more than one is possible, the first is selected.  
     // Shuffling prevents that the always the same maturation is selected
        Collections.shuffle(entries); 
//		//System.out.print*ln("Maturation map " + entries);
    	for (Map.Entry<String, Double> entry : entries) {
            String key = entry.getKey();
            if (key.startsWith(prefix)) {
                String secondPart = key.substring(prefix.length()); // Extract second part
                double value = entry.getValue();
                mature( endosome, prefix, secondPart, value);
                return;// only one maturation is allowed
            }
        }
    }
	public static void mature (Endosome endosome, String rabOldName, String rabNewName, double propMature) {
//		//System.out.print*ln(rabOldName+ rabNewName + "  Madura inicial "+endosome.getRabContent());		
//		The logic is that a percentage (propMature) of the major domain matures
//		the rest is preserved. The remaining domain can prevent miss targeting of membrane cargoes
//		The tickCount is reset but not to zero.
		double rabOld=endosome.getRabContent().get(rabOldName);
		double rabNew = 0;
		if (!endosome.rabContent.containsKey(rabNewName)) rabNew = 0d;// checks if the organelle already has the new domain
		else rabNew=endosome.getRabContent().get(rabNewName);
		endosome.getRabContent().put(rabNewName, rabOld*propMature+rabNew);
		endosome.getRabContent().put(rabOldName, rabOld*(1-propMature));
//		The tickCount is reset to a certain value considering the the proportion of the 
//		maturation of the major domain.  This prevent that a small area maturation will reset the
//		tickCount to zero
		endosome.setTickCount((int) (endosome.tickCount*(1-propMature)));
//		//System.out.print*ln("  MADURA "+endosome.getRabContent());
	}
	
}
