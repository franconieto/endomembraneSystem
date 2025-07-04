package immunity;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Scanner;
import java.util.Set;
import java.util.TreeMap;

import repast.simphony.engine.environment.RunEnvironment;
import repast.simphony.engine.schedule.ScheduledMethod;
import repast.simphony.parameter.Parameters;
import repast.simphony.space.continuous.ContinuousSpace;
import repast.simphony.space.grid.Grid;

public class UpdateParameters {
//	This class is used to update the parameters of the model.  It is used to read the input file and the events file
//	It allows to change the parameters of the model during the simulation and to set different events, such as 
//	make an uptake and a chase, etc.
	

	private static UpdateParameters instance;
	//CAMBIO
	LocalPath mainpath= LocalPath.getInstance(); 
	String InputPath = mainpath.getPathInputIT();
	
	public static UpdateParameters getInstance() {
		if( instance == null ) {
			instance = new  UpdateParameters();
		}
		return instance;
	}

	private String oldFile = "";

	
	public String getOldFile() {
		return oldFile;
	}
	public void setOldFile(String oldFile) {
		this.oldFile = oldFile;
	}

	public UpdateParameters() {
//		this.space = sp;
//		this.grid = gr;				
	}

	@ScheduledMethod(start = 1, interval = 100)
	public void step(){
			try {
		testNewFile();
		testEvent();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
}

	public void testNewFile() throws IOException {
		//CAMBIO
		File file = new File(InputPath);
//		File file = new File("C:/Users/lmayo/workspace/immunity/inputIntrTransp3.csv");
		Path filePath = file.toPath();		
		BasicFileAttributes attr = Files.readAttributes(filePath, BasicFileAttributes.class);
		String newFile = attr.lastModifiedTime().toString();
		if (newFile.equals(oldFile)){return;}
		else{

			
//			PARA BATCH USAR ESTO.  DE ESTE MODO SE PUEDEN BARRER VARIOS INPUTFILE CON DIFERENTES PROPIEDADES
			Parameters parm = RunEnvironment.getInstance().getParameters();
			String inputFile =(String) parm.getValue("inputFile");
			File scannerfile = new File (".//data//"+inputFile);

			//		"inputIntrTransp3.csv"));
			// PARA BATCH MODE.  LEE DE UN FOLDER DATA RELATIVO QUE SE GENERA AL CORRER EN BATCH 
//					el folder se llama data y allí hay que meter todo lo que se lea, como el inputIntrTransp3.csv y los copasi que
//					se necesiten
			
			try {
				ModelProperties modelProperties = ModelProperties.getInstance();
				ModelProperties.getInstance().loadFromCsv(modelProperties, scannerfile);
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			oldFile = newFile;
		}

		
		
	}
	private void testEvent() {
		double tick = RunEnvironment.getInstance().getCurrentSchedule().getTickCount() - 1.0;
// the schedule goes from 1 to 101, 201.  To fit the event tick, I subtract "1"
//		System.out.println(tick + " EVENTOS " + ModelProperties.getInstance().getEvents());
		if (ModelProperties.getInstance().getEvents().containsKey(tick)) {
		File inputFile = new File(ModelProperties.getInstance().getEvents().get(tick));
			File scannerfile = new File (".//data//"+inputFile);
			try {
				ModelProperties modelProperties = ModelProperties.getInstance();
				ModelProperties.getInstance().loadFromCsv(modelProperties, scannerfile);
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			
		}
		else return;
	}
		
}
