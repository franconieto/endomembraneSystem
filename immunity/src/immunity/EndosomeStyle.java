package immunity;

import java.awt.Color;
import java.awt.Font;
import java.awt.Rectangle;
import java.awt.Shape;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Line2D;
import java.awt.geom.RoundRectangle2D;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;

//import javax.media.opengl.GL2;

import org.apache.commons.math3.geometry.euclidean.twod.Line;

import repast.simphony.space.continuous.ContinuousSpace;
import repast.simphony.space.grid.Grid;
import repast.simphony.visualizationOGL2D.StyleOGL2D;
import saf.v3d.ShapeFactory2D;
import saf.v3d.scene.Position;
import saf.v3d.scene.VSpatial;

//import smodel.Bacteria.State;

public class EndosomeStyle implements StyleOGL2D<Endosome> {

	ShapeFactory2D factory;
	private double String;

	@Override
	public void init(ShapeFactory2D factory) {
		this.factory = factory;

	}

	@Override
	public VSpatial getVSpatial(Endosome object, VSpatial spatial) {
		/*
		 * shape is generated as a relationship between area and volume. For a
		 * sphere the s^3/v^2 is 113. For a cylinder is larger than this. For
		 * the minimum cylinder is 169.6
		 */
//		PLOT as ellipses with a length/wide ratio depending on the area/volume
//		ratio of the endosome.  It is 1 (sphere) when the area is what you need to
//		cover a sphere with the volume of the endosome
//		double svr = ((s * s * s) / (v * v) / (113.0973355d)); 
//		 svr should be 1 for a sphere
//		SCALE: I MEASURE THAT THE 50 GRID CORRESPOND TO A RECTANGLE OF 750 OF LENGTH
//		IF THE ORGANELLES ARE IN nm, HENCE THE AREA REPRESENT A 750 nm X 750 nm
        VSpatial shape = null;
// World is a 50 X 50 space.  Each unit of space has a size of 15 
// hence the world is 750 X 750 size in repast units, that correspond to 
// a 1500nm x 1500nm cellular space at orgScale = 1.  
// To convert from cell units (in nm) to repast space = nm/2
// the orgScale is taking into account in the scale of the shape (see below);
        Endosome.endosomeShape(object);
        double a=object.getA();
        double c=object.getC();
        if (Double.isNaN(a)) {
//        	volume too large for the area.  Calculate a new volume that fit in a sphere of this area
        object.volume = Math.pow(object.area,3/2)/6/Math.pow(Math.PI, 1/2);
        Endosome.endosomeShape(object);
		//System.out.print*ln("area "+ object.area +" volume "+object.volume);
        }
        if (a<=c){
        Shape ellypse = new Ellipse2D.Double(-c/2, -a/2, c, a);
        shape = this.factory.createShape(ellypse);
        }
        else{
//        	object.heading = -90;
//  		//System.out.print*ln(object.toString()+ "a  "+a+"  c  "+ c);
         Shape rec = new RoundRectangle2D.Double(-c/2, -a/2, c, a,  0, 0);
//        arguments x, y, ancho, largo, corner angle (small sharp), side curvature (small, straight)
        shape = this.factory.createShape(rec);
		}

		return shape;//createRectangle;
	}

	@Override
	public Color getColor(Endosome object) {
		// color code for contents
		double red = object.getMembraneContent().getOrDefault("R-TfEn",0.0);
		if (red>1) {
	//		//System.out.print*ln("RED FUERA ESCALA "+red);
			red=1; 
		}
		double green = object.getMembraneContent().getOrDefault("R-TfaEn",0.0)/5;
				//object.getGreen()*0.068*1E9/3;
//		//System.out.print*ln("GREEN FUERA ESCALA "+green);
		if (green>1) {
		//System.out.print*ln("GREEN FUERA ESCALA "+green);
			green=1; 
		}
		double blue = object.getSolubleContent().getOrDefault("FeEn",0.0)*5;
		if (blue>1) {
		//	//System.out.print*ln("BLUE FUERA ESCALA "+blue);
			blue=1; 
		}
		ArrayList<Double> colors = new ArrayList<Double>();
		colors.add(red);
		colors.add(green);
		colors.add(blue);
		// (1 - max (list g r b)) ;
		Double corr = 1 - Collections.max(colors);
//		if (Collections.max(colors)>1.1) 			//System.out.print*ln("COLOR FUERA ESCALA "+red+"  "+green+"  "+blue);
//		if the content in the organelle is not represented, then light gray
		if (corr > 0.95) corr = 0.95;
		return new Color((int) ((red + corr) * 255),
				(int) ((green + corr) * 255), (int) ((blue + corr) * 255));

	}

	@Override
	public int getBorderSize(Endosome object) {
			return 10;
	}

	@Override
	public Color getBorderColor(Endosome object) {
		int colorCode = 1;
//		As a routine, border color represents the rab content.  It may be a mix (colorCode = 0) or just to select the more
//		aboundant Rab (colorCode = 1)
		if (colorCode ==0)
		{
			// color code for rab contents
			double red = object.getEdgeRed();
			double green = object.getEdgeGreen();
			double blue = object.getEdgeBlue();
			ArrayList<Double> colors = new ArrayList<Double>();
			colors.add(red);
			colors.add(green);
			colors.add(blue);

			// 		(1 - max (list g r b)) ;
			Double corr = 1d - Collections.max(colors);
			if (corr <0) {
				//System.out.print*ln("BORDER COLOR" + colors);
			}

			//		if the rab in the organelle is not represented, then dark gray
			if (corr > 0.95){
				return new Color(255, 255, 255);
			}

			return new Color((int) ((red + corr) * 255d),
					(int) ((green + corr) * 255d), (int) ((blue + corr) * 255d));
		}
		
//		color code = 1.  Select the more aboundant Rab
		else {
			HashMap<String, Double> rabContent = new HashMap<String, Double>(object.getRabContent());
			Double rabMax = 0d;
			String rabColor = null;
			for (String rab : rabContent.keySet())
			{
				if (rabContent.get(rab)> rabMax) {
					rabMax = rabContent.get(rab);
					rabColor = rab;

				}
			}
//			//System.out.print*ln(rabColor+rabContent);
			if (rabColor.equals("RabA"))	return new Color (0,0,255);//EE
			else if (rabColor.equals("RabB"))	return new Color (0,255,255);//SE
			else if (rabColor.equals("RabC"))	return new Color (0,255,0);//RE
			else if (rabColor.equals("RabD"))	return new Color (255,0,0);//LE
			else if (rabColor.equals("RabE"))	return new Color (255,255,0);//TGN
			else if (rabColor.equals("RabF"))	return new Color (225,128,0);//transG
			else if (rabColor.equals("RabG"))	return new Color (191,96,0);//medialG
			else if (rabColor.equals("RabH"))	return new Color (128,64,0);//cisG
			else if (rabColor.equals("RabI"))	return new Color (255,0,255);//ERGIC
			else	return new Color (0,0,0);
		}

	}

	@Override
	public float getRotation(Endosome endosome) {
		// set in a way that object move along its large axis
		if(endosome.area >= Cell.minCistern/20 && endosome.a > endosome.c) return (float) 90;
		else return (float) -(endosome.getHeading());

	}
	

	@Override
	public float getScale(Endosome object) {
		// the size is the radius of a sphere with the volume of the object
		// hence, the newly form endosome with a size 30, has a scale of 3
		return (float) Cell.orgScale;// (float) object.size() / 10f;
	}

	@Override
	public String getLabel(Endosome object) {
		// the label is the number of internal vesicles (Multi Vesicular Body)
		// in the endosome

		if(2<3) {
			return null;		// to eliminate the labels. Not enough resolution to see the numbers
		}
		else {
		String label = "";
		if (object.getSolubleContent().containsKey("solubleMarker")
				&& object.getSolubleContent().get("solubleMarker")> 0.9){
		//String marker = object.getSolubleContent().get("solubleMarker").toString();
		label = label + "S ";
		}
		
		for (String key : object.getSolubleContent().keySet()) {
		    if (key.startsWith("bead") && object.getSolubleContent().get(key) > 0.9) {
		    	label = label + "B ";
		        break;
		    }
		}
		if (object.getMembraneContent().containsKey("membraneMarker")
				&& object.getMembraneContent().get("membraneMarker")> 0.9){
		//String marker = object.getSolubleContent().get("solubleMarker").toString();
		label = label + "M ";
		}
		if (object.getMvb()== null){
			return label;
		}
		else return label + object.getMvb();
		}
	}

	@Override
	public Font getLabelFont(Endosome object) {
		return new Font("arialblack", Font.BOLD, (int) (28 * Cell.orgScale));
	}

	@Override
	public float getLabelXOffset(Endosome object) {
		return 0;
	}

	@Override
	public float getLabelYOffset(Endosome object) {
		return 0;
	}

	@Override
	public Position getLabelPosition(Endosome object) {
		return Position.CENTER;
	}

	@Override
	public Color getLabelColor(Endosome object) {
		return new Color(100);
	}

}















