package immunity;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EndosomeMaturationStep {
	
	public static void matureCheck (Endosome endosome) {
//		if too young return
//		if (Math.random() > endosome.tickCount / 3000) {return;}
		String maxRab = Collections.max(endosome.rabContent.entrySet(), Map.Entry.comparingByValue()).getKey();
//		if the maxRab is not prevalent, return
		if (endosome.rabContent.get(maxRab)/endosome.area < 0.5) return; //LUIS ERA 0.9
//		Maturation according to the maxRab. First argument (oldRab) is the Rab that matures to the second argument (newRab)
//		The third argument is the proportion of the total domain that matures.  Most for Rab5-Rab7 and the Golgi domains.  Only
//		10% for Rab5-Rab22).5% for RabB-RabC
		findingMaturationsKeys(endosome, ModelProperties.getInstance().getRabMaturation(), maxRab);
		
//		switch (maxRab)
//		{
//		case "RabA":
//			if (Math.random()<0.85) {//0.9 change 13/8/24 to 0.80
////				if too young return
//				if (Math.random() > endosome.tickCount / 3000) {return;}
//				double m = ModelProperties.getInstance().getRabMaturation().get("RabARabB");
//				mature(endosome, "RabA", "RabB", m);// EE to SE era 0.1// 12/7/24 vuelvo a 0.1
//			}
//			else
//			{
////				if too young return
//				if (Math.random() > endosome.tickCount / 3000) {return;}
//			double m = ModelProperties.getInstance().getRabMaturation().get("RabARabD");
//			mature(endosome, "RabA", "RabD", m);// EE to LE era 0.9
//			}
//			break;
//		case "RabI":
////			if too young return
//			if (Math.random() > endosome.tickCount / 3000) {return;}
//			double m = ModelProperties.getInstance().getRabMaturation().get("RabIRabH");
//			mature(endosome, "RabI", "RabH", m);//ERGIC to cisG was 0.9 for all Golgi
//			break;
//		case "RabH":
////			if too young return
//			if (Math.random() > endosome.tickCount / 3000) {return;}
//			m = ModelProperties.getInstance().getRabMaturation().get("RabHRabG");
//			mature(endosome, "RabH", "RabG", m);//cisG to medialG
//			break;
//		case "RabG":
////			if too young return
//			if (Math.random() > endosome.tickCount / 3000) {return;}
//			m = ModelProperties.getInstance().getRabMaturation().get("RabGRabF");
//			mature(endosome, "RabG", "RabF", m);//medialG to transG
//			break;
//		case "RabF":
////			if too young return
//			if (Math.random() > endosome.tickCount / 3000) {return;}
//			m = ModelProperties.getInstance().getRabMaturation().get("RabFRabE");
//			mature(endosome, "RabF", "RabE", m);//transG to TGN
//			break;
//		case "RabB":
////			if too young return
//			if (Math.random() > endosome.tickCount / 3000) {return;}
//			m = ModelProperties.getInstance().getRabMaturation().get("RabBRabC");
//			mature(endosome, "RabB", "RabC", m);//SE to RE era 0.04//12/8/24 0.08
//			break;			
//			
//		 default: return;
//		}
		
//		double relativeRabA=endosome.rabContent.get("RabA")/endosome.area;
//		if(relativeRabA>0.9
//				&& Math.random()< endosome.tickCount / 5000) mature(endosome);
////			endosome.tickCount+=1;
//			//System.out.println("NOMBRE "+this.getName()+" Relative RabA  "+relativeRabA+" Cuenta  "+this.getTickCount());
		}

    public static void findingMaturationsKeys(Endosome endosome, HashMap<String, Double> map, String prefix) {
		if (Math.random() > endosome.tickCount / 3000) {return;}
        List<Map.Entry<String, Double>> entries = new ArrayList<>(map.entrySet());
        Collections.shuffle(entries); 
		System.out.println("Maturation map " + entries);
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
	//	System.out.println("MADUROOOOO");
	//	System.out.println("NOMBRE "+ rabOldName+rabNewName+" Cuenta  "+endosome.getTickCount()+" Area  "+endosome.getArea());
		System.out.println(rabOldName+ rabNewName + "  Madura inicial "+endosome.getRabContent());
		
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
		System.out.println("  MADURA "+endosome.getRabContent());
	}
	
}
