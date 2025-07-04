package immunity;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import repast.simphony.context.Context;
import repast.simphony.query.space.grid.GridCell;
import repast.simphony.query.space.grid.GridCellNgh;
import repast.simphony.space.continuous.ContinuousSpace;
import repast.simphony.space.grid.Grid;
import repast.simphony.space.grid.GridPoint;
import repast.simphony.util.ContextUtils;

public class FusionStep {
	/*
	This class is used to fuse compatible organelles
	Fusion implies that the resulting organelle will have the sum of 
	the volume, area and the soluble and membrane content of the fused organelles
	*/
	
    private static ContinuousSpace<Object> space;
    private static Grid<Object> grid;
    static double rendo = ModelProperties.getInstance().getCellK().get("rendo");
    private static double minEn = 4 * Math.PI * Math.pow(rendo, 2);
 // Select an organelle and decide is is large enough to recruit other proximal organelles that
 // will fuse and be deleted. 
 // Notice then that two small vesicles will not fuse.  They only fuse with larger organelles.
 // Then it assess if the organelle is a Golgi structure.
 // GOLGI
 // Golgi cisternae do not fuse among them unless they have the same maximal Rab domain (homotypic fusion)
 // Golgi cisternae fuse with Golgi vesicles if compatible. Golgi fuse with other small or large 
 // non Golgi structures. 
 // NON GOLGI
 // Non Gogli organelles will fuse with other Golgi or nonGolgi structures depending only in 
 // membrane compatibility.		
 // The organelle selected must be larger than a vesicles
 // rendo is the radius of a new endosome from PM and also of a new ERGIC from ER 

    public static void fusion(Endosome endosome) {
        if (endosome.area <= minEn) return;

        space = endosome.getSpace();
        grid = endosome.getGrid();
        
     // assesses if the organelle selected is a Golgi structure.  For this it sum all the Golgi domains			
     // different fusion rules if it is a Golgi organelle

        if (isGolgi(endosome)) {
            fusionGolgi(endosome);
        } else {
            fusionNoGolgi(endosome);
        }
    }

    private static void fusionNoGolgi(Endosome endosome) {
        GridPoint pt = grid.getLocation(endosome);
		// The 50 x 50 grid is equivalent to a 750 x 750 space units
		// Hence, size/15 is in grid units
        int gridSize = (int) Math.round(endosome.size * Cell.orgScale / 15d);
        GridCellNgh<Endosome> nghCreator = new GridCellNgh<>(grid, pt, Endosome.class, gridSize, gridSize);

        List<GridCell<Endosome>> cellList = nghCreator.getNeighborhood(true);
        List<Endosome> endosomesToDelete = new ArrayList<>();

        for (GridCell<Endosome> gr : cellList) {
            for (Endosome end : gr.items()) {
                if (end != endosome && end.volume <= endosome.volume && EndosomeAssessCompatibility.compatibles(endosome, end)) {
                    endosomesToDelete.add(end);
                }
            }
        }

        mergeEndosomes(endosome, endosomesToDelete);
    }

    private static void fusionGolgi(Endosome endosome) {
        GridPoint pt = grid.getLocation(endosome);
        int gridSize = (int) Math.round(endosome.size * Cell.orgScale / 15d);
        GridCellNgh<Endosome> nghCreator = new GridCellNgh<>(grid, pt, Endosome.class, gridSize, gridSize);

        List<GridCell<Endosome>> cellList = nghCreator.getNeighborhood(true);
        List<Endosome> endosomesToDelete = new ArrayList<>();

        for (GridCell<Endosome> gr : cellList) {
            for (Endosome end : gr.items()) {
                if (end.equals(endosome)) continue;

                boolean isGolgi2 = isGolgi(end);
                if (isGolgi2 && end.area > minEn && !Collections.max(endosome.rabContent.entrySet(), Map.Entry.comparingByValue()).getKey().equals(Collections.max(end.rabContent.entrySet(), Map.Entry.comparingByValue()).getKey())) {
                    continue;
                }
                if (!EndosomeAssessCompatibility.compatibles(endosome, end)) {
                    continue;
                }
                endosomesToDelete.add(end);
            }
        }

        mergeEndosomes(endosome, endosomesToDelete);
    }

    private static void mergeEndosomes(Endosome endosome, List<Endosome> endosomesToDelete) {
        for (Endosome endosome2 : endosomesToDelete) {
            endosome.volume += endosome2.volume;
            endosome.area += endosome2.area;
            endosome.rabContent = sumRabContent(endosome, endosome2);
            endosome.membraneContent = sumMembraneContent(endosome, endosome2);
            endosome.solubleContent = sumSolubleContent(endosome, endosome2);
            Context<Object> context = ContextUtils.getContext(endosome);
            context.remove(endosome2);
        }

        double rsphere = Math.pow(endosome.volume * 3d / 4d / Math.PI, 1d / 3d);
        endosome.speed = 1d / rsphere;
        Endosome.endosomeShape(endosome);
        endosome.getEndosomeTimeSeries().clear();
        endosome.getRabTimeSeries().clear();
    }

    private static HashMap<String, Double> sumRabContent(Endosome endosome1, Endosome endosome2) {
        HashMap<String, Double> rabSum = new HashMap<>(endosome1.rabContent);
        endosome2.rabContent.forEach((key, value) -> rabSum.merge(key, value, Double::sum));
        return rabSum;
    }

    private static HashMap<String, Double> sumMembraneContent(Endosome endosome1, Endosome endosome2) {
        HashMap<String, Double> memSum = new HashMap<>(endosome1.membraneContent);
        endosome2.membraneContent.forEach((key, value) -> memSum.merge(key, value, Double::sum));
        return memSum;
    }

    private static HashMap<String, Double> sumSolubleContent(Endosome endosome1, Endosome endosome2) {
        HashMap<String, Double> solSum = new HashMap<>(endosome1.solubleContent);
        endosome2.solubleContent.forEach((key, value) -> solSum.merge(key, value, Double::sum));
        return solSum;
    }

    private static boolean isGolgi(Endosome endosome) {
        double areaGolgi = endosome.getRabContent().entrySet().stream()
                .filter(entry -> ModelProperties.getInstance().rabOrganelle.get(entry.getKey()).contains("Golgi"))
                .mapToDouble(Map.Entry::getValue)
                .sum();
        return areaGolgi / endosome.area >= 0.5;
    }
}
