package immunity;

import java.io.FileWriter;
import java.io.IOException;

//import com.thoughtworks.xstream.XStream;

import repast.simphony.engine.schedule.ScheduledMethod;
import repast.simphony.random.RandomHelper;
import repast.simphony.space.continuous.ContinuousSpace;
import repast.simphony.space.grid.Grid;

public class MT {
//	This class define the origin and end of the MT.  It is used to
	//		1. define the direction of the MT
	//		2. define the length of the MT
	//		3. define the position of the MT
	//		4. define the position of the MT in the grid
	//		5. define the position of the MT in the space
//	In a square cell, the origin is at (25,25) and the end at the PM on the four sides of the cell
//	this should be changed for other shapes of cells
	
	private ContinuousSpace<Object> space;
	private Grid<Object> grid;
	double xorigin = 40d;
	double xend = 40d;
	double yorigin = 0d;
	double yend = 50d;
	double mth = Math.atan((yend - yorigin) / (xend - xorigin));
	public double mtheading = -mth * 180 / Math.PI;
	public double length = 0.0;

	// constructor
	public MT(ContinuousSpace<Object> sp, Grid<Object> gr) {
		this.space = sp;
		this.grid = gr;
	}

	@ScheduledMethod(start = 1, interval = 100)
	public void step() {
		if (Math.random() <0.01)
			changePosition(this);
	}

	public void changePosition(MT mt) {


		xorigin= 25;
		yorigin = 25;
		int randomSide = (int) Math.floor(Math.random()*4);
		switch (randomSide) {
		case 0 : {
			xend = 0;
			yend = Math.random()*50;
			break;
		}
		case 1 : {
			xend = 50;
			yend = Math.random()*50;
			break;
		}
		case 2 : {
			xend = Math.random()*50;
			yend = 0;
			break;
		}
		case 3 : {
			xend = Math.random()*50;
			yend = 50;
			break;
		}
		}
		
		mtheading = Math.atan2(xend-25, yend-25)*180/Math.PI; //-mth;
		double x = (xend + xorigin)/2 ;//25 * Math.cos(mtheading*Math.PI / 180);
		double y = (yend + yorigin)/2 ;//25 * Math.sin(mtheading*Math.PI / 180);

		space.moveTo(mt, x, y);
		grid.moveTo(mt, (int) x, (int) y);
		length = Math.sqrt((xend-xorigin)*(xend-xorigin)+(yend-yorigin)*(yend-yorigin));

		
	}
	// GETTERS AND SETTERS
	public double getXorigin() {
		return xorigin;
	}

	public double getXend() {
		return xend;
	}

	public double getYorigin() {
		return yorigin;
	}

	public double getYend() {
		return yend;
	}

	public double getMtheading() {
		return mtheading;
	}

	public double getLength() {
		return length;
	}

}
