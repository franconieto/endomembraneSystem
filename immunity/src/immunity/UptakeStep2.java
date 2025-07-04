package immunity;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

import repast.simphony.context.Context;
import repast.simphony.engine.environment.RunEnvironment;
import repast.simphony.random.RandomHelper;
import repast.simphony.space.continuous.ContinuousSpace;
import repast.simphony.space.grid.Grid;
import repast.simphony.util.ContextUtils;

public class UptakeStep2 {
    public static double uptakeArea = 0d;
    private static final double PI = Math.PI;
	/*  
	 *  EE and ERGIC organelles are created according to the PM membrane and ER disponibility
	 * PM is maintained by recycling of tubular EE, SE and RE, and the secretion of TGN
	 *  ER is continuously created (parameter growthER in inputIntrTransp3.csv)
	 */

    public static void uptake(Cell cell) {
        handlePlasmaMembraneUptake(cell);
        handleEndoplasmicReticulumSecretion(cell);
    }

    private static void handlePlasmaMembraneUptake(Cell cell) {
        double areaPM = PlasmaMembrane.getInstance().getPlasmaMembraneArea();
        double initialAreaPM = PlasmaMembrane.getInstance().getInitialPlasmaMembraneArea();

        while (areaPM > initialAreaPM) {
            System.out.println("NEW UPTAKE PM " + areaPM + " " + initialAreaPM);
            newUptake(cell, "RabA");
            if (Math.random() < 0) {
                break; // to prevent too many continuous uptakes
            }
            areaPM = PlasmaMembrane.getInstance().getPlasmaMembraneArea();
        }
    }

    private static void handleEndoplasmicReticulumSecretion(Cell cell) {
        double areaER = EndoplasmicReticulum.getInstance().getEndoplasmicReticulumArea();
        double initialAreaER = EndoplasmicReticulum.getInstance().getInitialendoplasmicReticulumArea();

        while (areaER > initialAreaER) {
            System.out.println("NEW UPTAKE ER " + areaER + " " + initialAreaER);
            newSecretion(cell, "RabI");
            if (Math.random() < 0.5) {
                break; // to prevent too many continuous new ERGICs
            }
            areaER = EndoplasmicReticulum.getInstance().getEndoplasmicReticulumArea();
        }
    }

    private static void newSecretion(Cell cell, String selectedRab) {
    	//		Secretion generate a new RabI organelle.  The size is the radius in the csv file for maxRadius in kind9
    	//		initial organelles.  The content is specified in concentration. One (1) is approx 1 mM.
    	//		This units are converted to membrane or volume units by multiplying by the area (rabs and
    	//		membrane content) or volume (soluble content).  For secretion it is controlled that there is enough
    	//		membrane and there is RabI in the cell
		/* 
		 * Soluble and membrane content of the kind9
		 * To model molecules that cycle between ER and endosomes, such as cMHCI and mHCI
		 * the new endosome incorporates metabolites that are present in the ER.
		 * Each species has its own rate for internalization (secretion rate).
		 * Also, the new ERGIC cannot incorporate more than a given amount of ER metabolites
		 * In area units, no more than its surface (about 1 mM)
		 *  RabI is the Rab that is used for secretion
		 */
        double cellLimit = 3d * Cell.orgScale;
        HashMap<String, Double> initOrgProp = new HashMap<>(InitialOrganelles.getInstance().getInitOrgProp().get("kind9"));
        HashMap<String, Double> rabCell = cell.getRabCell();

        if (!rabCell.containsKey("RabI") || Math.random() > rabCell.get("RabI")) {
            return;
        }

        double maxRadius = initOrgProp.get("maxRadius");
        double minRadius = maxRadius / 2;
        double a = RandomHelper.nextDoubleFromTo(minRadius, maxRadius);
        double c = a + a * Math.random() * initOrgProp.get("maxAsym");

        double area = calculateArea(a, c);
        double volume = calculateVolume(a, c);

        updateEndoplasmicReticulumArea(area);
        updateResultsRabI(area);

        initOrgProp.put("area", area);
        initOrgProp.put("volume", volume);

        HashMap<String, Double> rabContent = new HashMap<>();
        rabContent.put("RabI", area);

        HashMap<String, Double> membraneContent = calculateMembraneContent(area);
        HashMap<String, Double> solubleContent = calculateSolubleContent(volume);

        createNewEndosome(cell, rabContent, membraneContent, solubleContent, initOrgProp, cellLimit);
    }

    private static double calculateArea(double a, double c) {
        double f = 1.6075;
        double af = Math.pow(a, f);
        double cf = Math.pow(c, f);
        return 4d * PI * Math.pow((af * af + af * cf + af * cf) / 3, 1 / f);
    }

    private static double calculateVolume(double a, double c) {
        return 4d / 3d * PI * a * a * c;
    }

    private static void updateEndoplasmicReticulumArea(double area) {
        double areaER = EndoplasmicReticulum.getInstance().getEndoplasmicReticulumArea();
        EndoplasmicReticulum.getInstance().setEndoplasmicReticulumArea(areaER - area);
    }

    private static void updateResultsRabI(double area) {
        double value = Results.instance.getTotalRabs().get("RabI");
        Results.instance.getTotalRabs().put("RabI", value + area);
    }

    private static HashMap<String, Double> calculateMembraneContent(double area) {
        HashMap<String, Double> membraneContent = new HashMap<>();
        Set<String> membraneMet = new HashSet<>(ModelProperties.getInstance().getMembraneMet());

        for (String mem : membraneMet) {
            if (EndoplasmicReticulum.getInstance().getMembraneRecycle().containsKey(mem)) {
                double valueER = EndoplasmicReticulum.getInstance().getMembraneRecycle().get(mem);
                double secreted = valueER * ModelProperties.getInstance().getSecretionRate().get(mem) * area / EndoplasmicReticulum.getInstance().getEndoplasmicReticulumArea();
                secreted = Math.min(secreted, area);
                membraneContent.put(mem, secreted);
                EndoplasmicReticulum.getInstance().getMembraneRecycle().put(mem, valueER - secreted);
            }
        }
        return membraneContent;
    }

    private static HashMap<String, Double> calculateSolubleContent(double volume) {
        HashMap<String, Double> solubleContent = new HashMap<>();
        Set<String> solubleMet = new HashSet<>(ModelProperties.getInstance().getSolubleMet());

        for (String sol : solubleMet) {
            if (EndoplasmicReticulum.getInstance().getSolubleRecycle().containsKey(sol)) {
                double valueER = EndoplasmicReticulum.getInstance().getSolubleRecycle().get(sol);
                double secreted = valueER * volume / EndoplasmicReticulum.getInstance().getEndoplasmicReticulumVolume();
                secreted = Math.min(secreted, volume);
                solubleContent.put(sol, secreted);
                EndoplasmicReticulum.getInstance().getSolubleRecycle().put(sol, valueER - secreted);
            }
        }
        solubleContent.put("protonEn", 3.98E-5 * volume);
        return solubleContent;
    }

    private static void createNewEndosome(Cell cell, HashMap<String, Double> rabContent, HashMap<String, Double> membraneContent, HashMap<String, Double> solubleContent, HashMap<String, Double> initOrgProp, double cellLimit) {
        Context<Object> context = ContextUtils.getContext(cell);
        ContinuousSpace<Object> space = cell.getSpace();
        Grid<Object> grid = cell.getGrid();
        Endosome bud = new Endosome(space, grid, rabContent, membraneContent, solubleContent, initOrgProp);
        context.add(bud);
        bud.speed = 1d / bud.size;
        bud.heading = Math.random() * 360;
        bud.tickCount = 1;
//		The new ERGIC can be anywhere in the cell
        double x = Math.random() * (50 - 8 * cellLimit);
        double y = Math.random() * (50 - 8 * cellLimit);

        space.moveTo(bud, x, y);
        grid.moveTo(bud, (int) x, (int) y);
    }

    private static void newUptake(Cell cell, String selectedRab) {
        double cellLimit = 3d * Cell.orgScale;
        HashMap<String, Double> initOrgProp = new HashMap<>(InitialOrganelles.getInstance().getInitOrgProp().get("kind1"));
        HashMap<String, Double> rabCell = cell.getRabCell();

        if (!rabCell.containsKey("RabA") || Math.random() > rabCell.get("RabA")) {
            return;
        }

        double maxRadius = initOrgProp.get("maxRadius");
        double minRadius = maxRadius / 2;
        double a = RandomHelper.nextDoubleFromTo(minRadius, maxRadius);
        double c = a + a * Math.random() * initOrgProp.get("maxAsym");

        double area = calculateArea(a, c);
        double volume = calculateVolume(a, c);

        updatePlasmaMembraneArea(area);
        updateResultsRabA(area);

        initOrgProp.put("area", area);
        initOrgProp.put("volume", volume);

        HashMap<String, Double> rabContent = new HashMap<>();
        rabContent.put("RabA", area);

        HashMap<String, Double> membraneContent = calculateMembraneContentForUptake(area);
        HashMap<String, Double> solubleContent = calculateSolubleContentForUptake(volume);

        createNewEndosome(cell, rabContent, membraneContent, solubleContent, initOrgProp, cellLimit);
    }

    private static void updatePlasmaMembraneArea(double area) {
        double plasmaMembrane = PlasmaMembrane.getInstance().getPlasmaMembraneArea() - area;
        PlasmaMembrane.getInstance().setPlasmaMembraneArea(plasmaMembrane);
    }

    private static void updateResultsRabA(double area) {
        double value = Results.instance.getTotalRabs().get("RabA");
        Results.instance.getTotalRabs().put("RabA", value + area);
    }

    private static HashMap<String, Double> calculateMembraneContentForUptake(double area) {
        HashMap<String, Double> membraneContent = new HashMap<>();
        Set<String> membraneMet = new HashSet<>(ModelProperties.getInstance().getMembraneMet());

        for (String mem : membraneMet) {
            double valueInTotal = 0d;

            if (PlasmaMembrane.getInstance().getMembraneRecycle().containsKey(mem)) {
                double valuePM = PlasmaMembrane.getInstance().getMembraneRecycle().get(mem);
                double valueInPM = valuePM * ModelProperties.getInstance().getUptakeRate().get(mem) * area / PlasmaMembrane.getInstance().getPlasmaMembraneArea();
                PlasmaMembrane.getInstance().getMembraneRecycle().put(mem, valuePM - valueInPM);
                valueInTotal += valueInPM;
            }

            if (InitialOrganelles.getInstance().getInitMembraneContent().get("kind1").containsKey(mem)) {
                double valueInEn = InitialOrganelles.getInstance().getInitMembraneContent().get("kind1").get(mem) * area;
                valueInTotal += valueInEn;
            }

            valueInTotal = Math.min(valueInTotal, area);
            membraneContent.put(mem, valueInTotal);
        }

        if (PlasmaMembrane.getInstance().getMembraneRecycle().containsKey("membraneMarker") && PlasmaMembrane.getInstance().getMembraneRecycle().get("membraneMarker") > 0) {
            membraneContent.put("membraneMarker", 1.0);
            PlasmaMembrane.getInstance().getMembraneRecycle().remove("membraneMarker");
        }

        return membraneContent;
    }

    private static HashMap<String, Double> calculateSolubleContentForUptake(double volume) {
        HashMap<String, Double> solubleContent = new HashMap<>();
        Set<String> solubleMet = new HashSet<>(ModelProperties.getInstance().getSolubleMet());

        for (String sol : solubleMet) {
            double valueInTotal = 0d;

            if (PlasmaMembrane.getInstance().getSolubleRecycle().containsKey(sol)) {
                double valuePM = PlasmaMembrane.getInstance().getSolubleRecycle().get(sol);
                double valueInPM = valuePM * volume / PlasmaMembrane.getInstance().getPlasmaMembraneVolume();
                PlasmaMembrane.getInstance().getSolubleRecycle().put(sol, valuePM - valueInPM);
                valueInTotal += valueInPM;
            }

            if (InitialOrganelles.getInstance().getInitSolubleContent().get("kind1").containsKey(sol)) {
                double valueInEn = InitialOrganelles.getInstance().getInitSolubleContent().get("kind1").get(sol) * volume;
                valueInTotal += valueInEn;
            }

            valueInTotal = Math.min(valueInTotal, volume);
            solubleContent.put(sol, valueInTotal);
        }

        solubleContent.put("protonEn", 3.98E-5 * volume);
        return solubleContent;
    }
}
