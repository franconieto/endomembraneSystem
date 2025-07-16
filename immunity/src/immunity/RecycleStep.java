package immunity;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import repast.simphony.context.Context;
import repast.simphony.space.continuous.ContinuousSpace;
import repast.simphony.space.continuous.NdPoint;
import repast.simphony.space.grid.Grid;
import repast.simphony.util.ContextUtils;

public class RecycleStep {
    private static ContinuousSpace<Object> space;
    private static Grid<Object> grid;

    /**
     * Recycles the given endosome based on its location and dominant Rab content.
     * Handles recycling near the plasma membrane (PM) or endoplasmic reticulum (ER).
     */
    public static void recycle(Endosome endosome) {
        HashMap<String, Double> rabContent = new HashMap<>(endosome.getRabContent());
        double cellLimit = 3 * Cell.orgScale;
        NdPoint myPoint = endosome.getSpace().getLocation(endosome);
        double x = myPoint.getX();
        double y = myPoint.getY();
        boolean hasBead = false;
        
        for (String key : endosome.getSolubleContent().keySet()) {
            if (key.startsWith("bead") && endosome.getSolubleContent().get(key) > 0.9) {
                hasBead = true;
                break;
            }
        }
        if (hasBead) {
        	
        }else {
        // Check if the endosome is near the PM
        if (!isPointInSquare(x, y, 25, 25, 50 - 5 * cellLimit)) {
            handleRecyclingNearPM(endosome);
        } else {
            handleRecyclingNearER(endosome);
        }}
    }

    /**
     * Handles recycling when the endosome is near the plasma membrane (PM).
     */
    private static void handleRecyclingNearPM(Endosome endosome) {
        String maxRab = getMaxRab(endosome);
        String organelle = ModelProperties.getInstance().getRabOrganelle().get(maxRab);

        switch (organelle) {
            case "EE":
                recycleEE(endosome, maxRab);
                break;
            case "RE":
            case "SE":
            case "TGN":
                recycleRE(endosome, maxRab);
                break;
            default:
                // No recycling for other organelles near the PM
                break;
        }
    }

    /**
     * Handles recycling when the endosome is near the endoplasmic reticulum (ER).
     */
    private static void handleRecyclingNearER(Endosome endosome) {
        String maxRab = getMaxRab(endosome);
        String organelle = ModelProperties.getInstance().getRabOrganelle().get(maxRab);

        if ("ERGIC".equals(organelle)) {
            recycleERGIC(endosome, maxRab);
        }
    }

    /**
     * Recycles an ERGIC endosome back to the ER if it meets the conditions.
     */
    private static void recycleERGIC(Endosome endosome, String maxRab) {
        boolean isTubule = (endosome.volume / (endosome.area - 2 * Math.PI * Cell.rcyl * Cell.rcyl) <= Cell.rcyl / 2);
        if (!isTubule) return;

        double recyProb = calculateRecyclingProbability(endosome, maxRab);
        if (Math.random() >= recyProb || endosome.tickCount < 3000) return;

        EndoplasmicReticulum ER = EndoplasmicReticulum.getInstance();
        recycleContent(endosome, ER.getMembraneRecycle(), ER.getSolubleRecycle());
        ER.setEndoplasmicReticulumArea(endosome.area + ER.getEndoplasmicReticulumArea());

        removeEndosome(endosome);
    }

    /**
     * Recycles a Recycling Endosome (RE) or TGN endosome near the PM.
     */
    private static void recycleRE(Endosome endosome, String maxRab) {
        double recyProb = calculateRecyclingProbability(endosome, maxRab);
        if (Math.random() >= recyProb) return;

        PlasmaMembrane pm = PlasmaMembrane.getInstance();
        recycleContent(endosome, pm.getMembraneRecycle(), pm.getSolubleRecycle());

        double prob = ModelProperties.getInstance().getCellK().get("fullFusionREprob");
        if ("RabE".equals(maxRab) || ("RabC".equals(maxRab) && Math.random() < prob)) {
            pm.setPlasmaMembraneArea(endosome.area + pm.getPlasmaMembraneArea());
            removeEndosome(endosome);
        } else {
            convertToTubule(endosome);
        }
    }

    /**
     * Recycles an Early Endosome (EE) near the PM.
     */
    private static void recycleEE(Endosome endosome, String maxRab) {
        double recyProb = calculateRecyclingProbability(endosome, maxRab);
        if (Math.random() >= recyProb || endosome.tickCount < 1000) return;

        PlasmaMembrane pm = PlasmaMembrane.getInstance();
        recycleContent(endosome, pm.getMembraneRecycle(), pm.getSolubleRecycle());
        pm.setPlasmaMembraneArea(endosome.area + pm.getPlasmaMembraneArea());

        removeEndosome(endosome);
    }

    /**
     * Checks if a point is within a square defined by its center and side length.
     */
    public static boolean isPointInSquare(double x, double y, double x0, double y0, double ll) {
        double halfSide = ll / 2.0;
        return (x >= x0 - halfSide && x <= x0 + halfSide && y >= y0 - halfSide && y <= y0 + halfSide);
    }

    /**
     * Calculates the recycling probability for the given endosome and Rab content.
     */
    private static double calculateRecyclingProbability(Endosome endosome, String maxRab) {
        return ModelProperties.getInstance().getRabRecyProb().get(maxRab) * endosome.rabContent.get(maxRab) / endosome.area;
    }

    /**
     * Recycles the membrane and soluble content of the endosome into the target organelle.
     */
    private static void recycleContent(Endosome endosome, HashMap<String, Double> membraneRecycle, HashMap<String, Double> solubleRecycle) {
        for (String key : endosome.membraneContent.keySet()) {
            membraneRecycle.merge(key, endosome.membraneContent.get(key), Double::sum);
        }
        endosome.membraneContent.clear();

        for (String key : endosome.solubleContent.keySet()) {
            solubleRecycle.merge(key, endosome.solubleContent.get(key), Double::sum);
        }
        endosome.solubleContent.clear();
    }

    /**
     * Converts the endosome into a tubule with updated properties.
     */
    private static void convertToTubule(Endosome endosome) {
        double rcyl = ModelProperties.getInstance().getCellK().get("rcyl");
        double h = (endosome.area - 2 * Math.PI * rcyl * rcyl) / (2 * Math.PI * rcyl);
        endosome.volume = Math.PI * rcyl * rcyl * h;
        endosome.solubleContent.put("protonEn", 3.98e-5 * endosome.volume);
        endosome.heading = -90;
    }

    /**
     * Removes the endosome from the simulation context.
     */
    private static void removeEndosome(Endosome endosome) {
        Context<Object> context = ContextUtils.getContext(endosome);
        context.remove(endosome);
    }

    /**
     * Retrieves the Rab with the highest content in the endosome.
     */
    private static String getMaxRab(Endosome endosome) {
        return Collections.max(endosome.rabContent.entrySet(), Map.Entry.comparingByValue()).getKey();
    }
}
