package immunity;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Random;

import repast.simphony.space.continuous.ContinuousSpace;
import repast.simphony.space.continuous.NdPoint;
import repast.simphony.space.grid.Grid;

public class OrganelleMove {

    /*
        This class is used to move the organelles in the cell.
        Large Golgi cisternae are static and small Golgi vesicles move
        Two types of movement are considered: On MT and without MT
        On MT, the organelle moves to the direction of the MT at a fixed speed
        They may move to the plus end (to PM) or to the minus end (to nucleus)
        The direction depends on the membrane domains present in the organelle and
        it may be different for tubules and non-tubules. This is defined in the
        inputIntrTransp3.csv file.
        Far from MT, near the plasma membrane or the nucleus, the organelle moves
        with a speed inversely proportional to the size of the organelle and changing
        direction randomly and sporadically. They move more of the time in a straight line
    */
    private static ContinuousSpace<Object> space;
    private static Grid<Object> grid;
    private static List<MT> mts;
    public static double cellLimit = 3 * Cell.orgScale;

    // Method to move the endosome towards a target
    public static void moveTowards(Endosome endosome) {
        if (endosome.area >= Cell.minCistern / 20 && isGolgi(endosome)) {
            // If it is a large Golgi cisternae, move it to a fixed position
            moveCistern(endosome);
        } else {
            // Otherwise, move it normally
            moveNormal(endosome);
        }
        updateCoordinates(endosome);
    }

    // Method to check if the endosome is a Golgi
    private static boolean isGolgi(Endosome endosome) {
        double areaGolgi = 0d;
        for (String rab : endosome.rabContent.keySet()) {
            String name = ModelProperties.getInstance().rabOrganelle.get(rab);
            if (name.contains("Golgi")) {
                areaGolgi += endosome.rabContent.get(rab);
            }
        }
        return areaGolgi / endosome.area >= 0.5;
    }

    // Method to move a large Golgi cisternae to a fixed position
    private static void moveCistern(Endosome endosome) {
        double scale = Cell.orgScale;
        space = endosome.getSpace();
        grid = endosome.getGrid();
        String maxRab = Collections.max(endosome.rabContent.entrySet(), Map.Entry.comparingByValue()).getKey();
        String organelleName = ModelProperties.getInstance().rabOrganelle.get(maxRab);
        double between = 4 * scale; // Distance between cisternae
        double high = 29; // Distance from the bottom

        if (organelleName.contains("cisGolgi")) {
            moveToPosition(endosome, 25, between * 1 + high);
        } else if (organelleName.contains("medialGolgi")) {
            moveToPosition(endosome, 25, between * 2 + high);
        } else if (organelleName.contains("transGolgi")) {
            moveToPosition(endosome, 25, between * 3 + high);
        }
    }

    // Helper method to move the endosome to a specific position
    private static void moveToPosition(Endosome endosome, double x, double y) {
        space.moveTo(endosome, x, y);
        grid.moveTo(endosome, (int) x, (int) y);
    }

    // Method to move the endosome normally
    public static void moveNormal(Endosome endosome) {
        space = endosome.getSpace();
        grid = endosome.getGrid();
        NdPoint myPoint = space.getLocation(endosome);
        double x = myPoint.getX();
        double y = myPoint.getY();
        double cellSize = 50;
        double cellCenterX = 25;
        double cellCenterY = 25;
        double nucleusSize = 5;
        double nucleusCenterX = 25;
        double nucleusCenterY = 21;

        // If near the border, change heading randomly and stop move with 10% probability
        if (!isPointInSquare(x, y, cellCenterX, cellCenterY, cellSize - 5 * cellLimit)) {
            endosome.heading = Math.random() * 360;
            changeDirectionRnd(endosome);
        } else if (isPointInCircle(x, y, nucleusCenterX, nucleusCenterY, nucleusSize)) {
            // If near the nucleus, change heading randomly and stop move with 10% probability
            if (Math.random() < 0.05) endosome.heading = Math.random() * 360;
            changeDirectionRnd(endosome);
        } else {
            // If not near the borders, change direction based on MT
            changeDirectionMt(endosome);
        }

        // Move the endosome based on the heading and speed
        moveEndosome(endosome, x, y, cellCenterX, cellCenterY, cellSize);
    }

    // Method to move the endosome based on the heading and speed
    private static void moveEndosome(Endosome endosome, double x, double y, double cellCenterX, double cellCenterY, double cellSize) {
        if (endosome.speed == 0) return;

        double xx = x + Math.cos(endosome.heading * Math.PI / 180d) * endosome.speed * Cell.orgScale / Cell.timeScale;
        double yy = y + Math.sin(endosome.heading * Math.PI / 180d) * endosome.speed * Cell.orgScale / Cell.timeScale;

        // If move out of the cell, move towards the center and change heading randomly
        if (!isPointInSquare(xx, yy, cellCenterX, cellCenterY, cellSize - 2 * cellLimit)) {
            double[] newPoint = movePointToward(xx, yy, cellCenterX, cellCenterY, 2 * cellLimit);
            xx = newPoint[0];
            yy = newPoint[1];
            endosome.heading = Math.random() * 360;
        }

        space.moveTo(endosome, xx, yy);
        grid.moveTo(endosome, (int) xx, (int) yy);
    }

    // Method to change the direction randomly
    public static void changeDirectionRnd(Endosome endosome) {
        // 90% of the time, the speed is 0 and the endosome does not move
        if (Math.random() < 0.9) {
            endosome.speed = 0;
            return;
        }
        // The speed is random between 0 and a value inversely proportional to the endosome size
        endosome.speed = 20d / endosome.size * Math.random() * Cell.orgScale / Cell.timeScale;
    }

    // Method to change the direction based on the closest MT
    public static void changeDirectionMt(Endosome endosome) {
        if (mts == null) {
            mts = associateMt();
        }
        double dist = 1000;
        MT mt = null;

        // Find the closest MT
        for (MT mmt : mts) {
            double ndist = distance(endosome, mmt);
            if (Math.abs(ndist) <= Math.abs(dist)) {
                dist = ndist;
                mt = mmt;
            }
        }

        if (Math.abs(dist * 30d / Cell.orgScale) < endosome.size) {
            if (endosome.a > endosome.c) {
                moveGolgiVesicles(endosome);
            }
            boolean isTubule = (endosome.volume / (endosome.area - 2 * Math.PI * Cell.rcyl * Cell.rcyl) <= Cell.rcyl / 2);
            String rabDir = mtDirection(endosome);
            double mtDir = isTubule ? ModelProperties.getInstance().mtTropismTubule.get(rabDir) : ModelProperties.getInstance().mtTropismRest.get(rabDir);

            if (Math.random() < Math.abs(mtDir)) {
                mtDir = Math.signum(mtDir) >= 0 ? 0 : 1;
            } else {
                changeDirectionRnd(endosome);
                return;
            }

            double mth = mt.getMtheading();
            double yy = dist * Math.sin((mth + 90) * Math.PI / 180);
            double xx = dist * Math.cos((mth + 90) * Math.PI / 180);
            NdPoint pt = space.getLocation(endosome);
            double xpt = pt.getX() - xx;
            double ypt = pt.getY() - yy;
            if (ypt >= 50 - cellLimit) ypt = 50 - cellLimit;
            if (ypt <= 0 + cellLimit) ypt = cellLimit;
            space.moveTo(endosome, xpt, ypt);
            grid.moveTo(endosome, (int) xpt, (int) ypt);
            endosome.speed = 1d * Cell.orgScale / Cell.timeScale;
            endosome.heading = -(mtDir * 180f + mt.getMtheading() + 270f);
        } else {
            changeDirectionRnd(endosome);
        }
    }

    // Method to move Golgi vesicles to a random position near the Golgi
    private static void moveGolgiVesicles(Endosome endosome) {
        space = endosome.getSpace();
        grid = endosome.getGrid();
        double deltaX = Math.random() * 10 - 5;
        double deltaY = Math.random() * 6 - 3;
        moveToPosition(endosome, 25 + deltaX, 14 + deltaY);
        updateCoordinates(endosome);
    }

    // Method to determine the direction of the MT based on the rab content
    public static String mtDirection(Endosome endosome) {
        double rnd = Math.random();
        double mtd = 0d;
        for (String rab : endosome.rabContent.keySet()) {
            mtd += endosome.rabContent.get(rab) / endosome.area;
            if (rnd <= mtd) {
                return rab;
            }
        }
        return Collections.max(endosome.rabContent.entrySet(), Map.Entry.comparingByValue()).getKey();
    }

    // Method to associate MTs with the grid
    public static List<MT> associateMt() {
        List<MT> mts = new ArrayList<>();
        for (Object obj : grid.getObjects()) {
            if (obj instanceof MT) {
                mts.add((MT) obj);
            }
        }
        return mts;
    }

    // Method to calculate the distance between the endosome and the MT
    private static double distance(Endosome endosome, MT obj) {
        NdPoint pt = space.getLocation(endosome);
        double xpt = pt.getX();
        double ypt = pt.getY();
        double ymax = obj.getYend();
        double ymin = obj.getYorigin();
        double xmax = obj.getXend();
        double xmin = obj.getXorigin();

        Point A = new Point(xmin, ymin);
        Point B = new Point(xmax, ymax);
        Point C = new Point(xpt, ypt);
        LineSegment segment = new LineSegment(A, B);
        double ACx = C.x - segment.A.x;
        double ACy = C.y - segment.A.y;
        double ABx = segment.B.x - segment.A.x;
        double ABy = segment.B.y - segment.A.y;
        double dotProduct = ACx * ABx + ACy * ABy;
        double t = dotProduct / (ABx * ABx + ABy * ABy);

        if (!(t >= 0 && t <= 1)) return 2000;

        double a = (xmax - xmin) * (ymin - ypt) - (ymax - ymin) * (xmin - xpt);
        double b = Math.sqrt((ymax - ymin) * (ymax - ymin) + (xmax - xmin) * (xmax - xmin));
        return a / b;
    }

    // Method to check if a point is inside a circle
    public static boolean isPointInCircle(double x, double y, double x0, double y0, double r) {
        double distanceSquared = Math.pow(x - x0, 2) + Math.pow(y - y0, 2);
        double radiusSquared = Math.pow(r, 2);
        return distanceSquared <= radiusSquared;
    }

    // Method to check if a point is inside a square
    public static boolean isPointInSquare(double x, double y, double x0, double y0, double ll) {
        double halfSide = ll / 2.0;
        double left = x0 - halfSide;
        double right = x0 + halfSide;
        double top = y0 + halfSide;
        double bottom = y0 - halfSide;
        return (x >= left && x <= right && y >= bottom && y <= top);
    }

    // Method to move a point towards a target point by a certain distance
    public static double[] movePointToward(double x, double y, double x0, double y0, double d) {
        double dx = x0 - x;
        double dy = y0 - y;
        double distance = Math.sqrt(dx * dx + dy * dy);

        if (distance == 0) {
            return new double[]{x, y};
        }

        double ratio = d / distance;
        double newX = x + ratio * dx;
        double newY = y + ratio * dy;

        return new double[]{newX, newY};
    }

    // Method to update the coordinates of the endosome
    private static void updateCoordinates(Endosome endosome) {
        NdPoint myPoint = space.getLocation(endosome);
        endosome.setXcoor(myPoint.getX());
        endosome.setYcoor(myPoint.getY());
    }
}
