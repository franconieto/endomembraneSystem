package immunity;
import java.awt.Color;
import java.awt.Font;

//import javax.media.opengl.GL2;

import repast.simphony.visualizationOGL2D.StyleOGL2D;
import saf.v3d.ShapeFactory2D;
import saf.v3d.render.RenderState;
import saf.v3d.scene.Position;
import saf.v3d.scene.VShape;
import saf.v3d.scene.VSpatial;
public class EndoplasmicReticulumStyle implements StyleOGL2D<EndoplasmicReticulum> {

	ShapeFactory2D factory;
	private double String;
	
	@Override
	public void init(ShapeFactory2D factory) {
		this.factory = factory;

	}

	@Override
	public VSpatial getVSpatial(EndoplasmicReticulum object, VSpatial spatial) {
// 15 measure the size of the grid.  The world is 50*15 X 50*15 or 750 X 750
		double initialAreaER = object.getInitialendoplasmicReticulumArea();
		double areaER = object.getendoplasmicReticulumArea();
//		System.out.println(areaER + "areas ER  " + initialAreaER);
		VSpatial createRectangle = this.factory.createRectangle((int) (areaER/initialAreaER*750), (int) (20d*Cell.orgScale));
		return createRectangle;
	}

	@Override
	public Color getColor(EndoplasmicReticulum object) {
		// eventually the color will reflect some local EndoplasmicReticulum characteristics
		int red = (int)object.getErcolor();
		return new Color(255, 255-red, 255-red);
	}

	@Override
	public int getBorderSize(EndoplasmicReticulum object) {
		//if larger than 0, form a nice grid
		return 10;
	}

	@Override
	public Color getBorderColor(EndoplasmicReticulum object) {
		return new Color(159,0,159);
	}

	@Override
	public float getRotation(EndoplasmicReticulum object) {
		return 0;
	}

	@Override
	public float getScale(EndoplasmicReticulum object) {	
		return (float) 1;
	}

	@Override
	public String getLabel(EndoplasmicReticulum object) {
		return ""; 
	}
	@Override
	public Font getLabelFont(EndoplasmicReticulum object) {
		return new Font("sansserif", Font.PLAIN, 14);
	}

	@Override
	public float getLabelXOffset(EndoplasmicReticulum object) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public float getLabelYOffset(EndoplasmicReticulum object) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public Position getLabelPosition(EndoplasmicReticulum object) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Color getLabelColor(EndoplasmicReticulum object) {
		// TODO Auto-generated method stub
		return null;
	}
}

	
