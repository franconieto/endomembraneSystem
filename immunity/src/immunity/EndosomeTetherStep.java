package immunity;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import repast.simphony.query.space.grid.GridCell;
import repast.simphony.query.space.grid.GridCellNgh;
import repast.simphony.space.continuous.ContinuousSpace;
import repast.simphony.space.grid.Grid;
import repast.simphony.space.grid.GridPoint;

public class EndosomeTetherStep {
    /*
        This class is responsible for the tethering of endosomes.  
        It is a process that occurs when two endosomes are close to each other.
        Like fusion, only compatible endosomes can tether.
        When they tether, they move together following the largest endosome.
    */

    private static ContinuousSpace<Object> space;
    private static Grid<Object> grid;

    /**
     * Tethers compatible endosomes that are within a certain proximity.
     * The largest endosome in the group determines the movement direction.
     */
    public static void tether(Endosome endosome) {
        // Initialize space and grid references
        space = endosome.getSpace();
        grid = endosome.getGrid();

        // Get the grid location of the current endosome
        GridPoint pt = grid.getLocation(endosome);

        // Calculate the neighborhood size based on the endosome's size
        int gridSize = (int) Math.round(endosome.getSize() * Cell.orgScale / 15d);

        // Create a neighborhood of grid cells around the endosome
        GridCellNgh<Endosome> nghCreator = new GridCellNgh<>(grid, pt, Endosome.class, gridSize, gridSize);
        List<GridCell<Endosome>> cellList = nghCreator.getNeighborhood(true);

        // If there is only one cell in the neighborhood, return (no tethering possible)
        if (cellList.size() < 2) return;

        // Collect compatible endosomes from the neighborhood
        List<Endosome> endosomesToTether = findCompatibleEndosomes(cellList, endosome);

        // If there are fewer than two compatible endosomes, return
        if (endosomesToTether.size() < 2) return;

        // Find the largest endosome in the group
        Endosome largest = findLargestEndosome(endosome, endosomesToTether);

        // Assign the speed and heading of the largest endosome to the group
        updateEndosomeMovement(endosomesToTether, largest);
    }

    /**
     * Finds compatible endosomes in the neighborhood based on Rab compatibility.
     */
    private static List<Endosome> findCompatibleEndosomes(List<GridCell<Endosome>> cellList, Endosome endosome) {
        List<Endosome> compatibleEndosomes = new ArrayList<>();
        for (GridCell<Endosome> cell : cellList) {
            for (Endosome neighbor : cell.items()) {
                if (EndosomeAssessCompatibility.compatibles(endosome, neighbor)) {
                    compatibleEndosomes.add(neighbor);
                }
            }
        }
        return compatibleEndosomes;
    }

    /**
     * Identifies the largest endosome in a group of endosomes.
     */
    private static Endosome findLargestEndosome(Endosome reference, List<Endosome> endosomes) {
        Endosome largest = reference;
        for (Endosome end : endosomes) {
            if (end.getSize() > largest.getSize()) {
                largest = end;
            }
        }
        return largest;
    }

    /**
     * Updates the movement properties (heading) of the tethered endosomes
     * to follow the largest endosome in the group.
     */
    private static void updateEndosomeMovement(List<Endosome> endosomes, Endosome largest) {
        Random random = new Random();
        for (Endosome end : endosomes) {
            double randomHeadingAdjustment = random.nextGaussian() * 30d;
            end.setHeading(randomHeadingAdjustment + largest.getHeading());
        }
    }
}
