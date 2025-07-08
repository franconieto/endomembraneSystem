
	//CAMBIO
	package immunity;

	import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;
import repast.simphony.engine.environment.RunEnvironment;

	public class LocalPath {
		
	private String mypath;
	private String mypath1;
	private String mypath2;
	private String mypath3;
	private String mypath4;
	private String mypath5;
	private String mypath6;
	private String mypathOut;
	private static LocalPath instance;
	public static LocalPath getInstance() {
		if( instance == null ) {
			instance = new  LocalPath();
		}
		return instance;
	}
	
	// Local paths to save the results and the input files	
	
	File myDir = new File (".");
	
	{
    try {
    	String folderName = new SimpleDateFormat("yyyy-MM-dd-HH-mm-SSS").format(new Date());
    	String os = System.getProperty("os.name").toLowerCase();
		if (RunEnvironment.getInstance().isBatch()) {
	        if (os.contains("win")) {
	        	// for input
//	          FOR BATCH, THE PATH MUST BE ABSOLUTE BECAUSE THE BATCH RUNS FROM A
//	          TEMPORARY FOLDER THAT IS DELETED. SO IF RELATIVE, THE OUTPUT IS LOST
//	          SAME FOR INPUT, THE FILE MUST BE IN THE "data" FOLDER
	            mypath = "C:/Users/fniet/OneDrive/Documentos/GitHub/endomembraneSystem/immunity/";
	            mypathOut=mypath+"/output/"+folderName+"-" + UUID.randomUUID().toString().substring(0, 3)+"/";   
	            System.out.println("1 " + mypathOut);
	        } else {
	            mypath = myDir.getCanonicalPath().replace('\\','/');
	            mypathOut=mypath+"/";
	            System.out.println("2 " + mypathOut);
	        }
	        }else {
	        	mypath=myDir.getCanonicalPath().replace('\\','/');
	        	if (os.contains("win")) {
	        	
	        	mypathOut=mypath+"/output/"+folderName+"/";
	        	System.out.println("3 " + mypathOut);
	        	}else{
		            mypathOut=mypath+"/";
		            System.out.println("4 " + mypathOut);
		        }
	        }
		
//      to get the results from the batch in different folders, the directory must be created
//      Cannot stores de files in a non existing directory
      
      System.out.println("mypath = " + mypath);
      //System.out.println("mypath out= " + mypathOut);
      
      //Path path = Paths.get(mypathOut);
      //Files.createDirectory(path);
      
      File outputDir = new File(mypathOut);
      if (!outputDir.exists()) {
          outputDir.mkdirs();
      }
      }
    
    catch(Exception e) {
      e.printStackTrace();
     }

	}
//	NOT USED BATCH
	public String getPath(){ 
		return this.mypath; 
		} 
	public String getMyPathOut(){ 
		return mypathOut; 
		} 
	
	public String getPathResultsIT(){ 
		
		mypath1=mypathOut+"/ResultsIntrTransp3.csv";
		return this.mypath1; 
		} 

	public String getPathResultsMarkers(){ 
		
		mypath2=mypathOut+"/ResultsMarker.csv";
		return this.mypath2; 
		} 
//	not used in BATCH

	public String getPathInputIT(){ 
		
		mypath3=mypath+"/data/";
		return this.mypath3; 
		}
		
		public String getPathOutputFE(){ 
//			mypath4=mypath+"/outputFrozenEndosomes.csv";		
			mypath4=mypathOut+"/outputFrozenEndosomes.csv";//batch
			return this.mypath4; 
			} 
			
		public String getPathTotalRabs(){ 
			
//			mypath5=mypath+"/totalRabs.csv";
			mypath5=mypathOut+"/totalRabs.csv";//batch
			return this.mypath5; 
			}

		public String getPathCisternsArea() {
			
//			mypath6 = mypath+"/cisternsArea.csv";			
			mypath6 = mypathOut+"/cisternsArea.csv";//batch
			return this.mypath6; 
		}
	}
