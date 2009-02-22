package org.reprap.artofillusion;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

import org.cheffo.jeplite.JEP;

import artofillusion.LayoutWindow;
import artofillusion.UndoRecord;
import artofillusion.math.CoordinateSystem;
import artofillusion.math.Vec3;
import artofillusion.object.CSGObject;
import artofillusion.object.Cube;
import artofillusion.object.Cylinder;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;
import artofillusion.object.Sphere;

public class MetaCADEvaluatorEngine extends CSGEvaluatorEngine 
{
	JEP jep = new JEP();
	
	public MetaCADEvaluatorEngine(LayoutWindow window) 
	{
		super(window);
		// TODO Auto-generated constructor stub

		readParameters();
	}
	
	public void readParameters()
	{
		jep = new JEP();
		jep.addStandardConstants();
		jep.addStandardFunctions();
		EvaluateFile("cad_parameters.txt");
	}
	
	 public ObjectInfo evaluateNode(ObjectInfo parent, UndoRecord undo)
	 {
	   readParameters();
		 ParseFunction(parent, undo);
		 
		 return super.evaluateNode(parent, undo);
	 }
	 
	 void ParseFunction(ObjectInfo parent, UndoRecord undo)
	  {
		String line = parent.name;
	    String functionName;
	    String parameters;
	    String []splitParameters;
	    
	    int posOpenBracket = line.indexOf("(");
	    int posCloseBracket = line.lastIndexOf(")");
	    
	    if (posOpenBracket > 0 && posCloseBracket >= 0)
	    {
	      functionName = line.substring(0, posOpenBracket);
	      parameters = line.substring(posOpenBracket+1, posCloseBracket);
	      splitParameters = parameters.split(",");
	      
	      
	      if (parent.object.getClass().equals(Sphere.class) && splitParameters.length >= 9)
	      {
	    	  try
	    	  {
		    	  double x, y, z, rotx, roty, rotz, dx, dy, dz;
		    	  
		    	  Sphere obj = (Sphere)parent.object;
		    	  
		    	  x = Evaluate(splitParameters[0]);
		    	  y = Evaluate(splitParameters[1]);
		    	  z = Evaluate(splitParameters[2]);
		    	  
		    	  rotx = Evaluate(splitParameters[3]);
		    	  roty = Evaluate(splitParameters[4]);
		    	  rotz = Evaluate(splitParameters[5]);
		    	  
		    	  dx = Evaluate(splitParameters[6])*2;
		    	  dy = Evaluate(splitParameters[7])*2;
		    	  dz = Evaluate(splitParameters[8])*2;
		    	
		    	  obj.setSize(dx, dy, dz);
		    	  parent.setCoords(new CoordinateSystem(new Vec3(x, y, z), rotx, roty, rotz));
		    	  
		          parent.clearCachedMeshes();
		          this.window.updateImage();
		          this.window.updateMenus();
	    	  }
	    	  catch (Exception ex)
	    	  {
	    		  System.out.println(ex);
	    	  }
	      }
	      
	      if (parent.object.getClass().equals(Cylinder.class) && splitParameters.length >= 9)
	      {
	    	  try
	    	  {
		    	  double x, y, z, rotx, roty, rotz, dx, height, dz;
		    	  
		    	  Cylinder obj = (Cylinder)parent.object;
		    	  
		    	  x = Evaluate(splitParameters[0]);
		    	  y = Evaluate(splitParameters[1]);
		    	  z = Evaluate(splitParameters[2]);
		    	  
		    	  rotx = Evaluate(splitParameters[3]);
		    	  roty = Evaluate(splitParameters[4]);
		    	  rotz = Evaluate(splitParameters[5]);
		    	  
		    	  dx = Evaluate(splitParameters[6])*2;
		    	  dz = Evaluate(splitParameters[7])*2;
		    	  height = Evaluate(splitParameters[8]);
		    	
		    	  obj.setSize(dx, height, dz);
		    	  parent.setCoords(new CoordinateSystem(new Vec3(x, y, z), rotx, roty, rotz));
		    	  
		          parent.clearCachedMeshes();
		          this.window.updateImage();
		          this.window.updateMenus();
	    	  }
	    	  catch (Exception ex)
	    	  {
	    		  System.out.println(ex);
	    	  }
	      }
	      
	      if (parent.object.getClass().equals(Cube.class) && splitParameters.length >= 9)
	      {
	    	  try
	    	  {
		    	  double x, y, z, rotx, roty, rotz, dx, dy, dz;
		    	  
		    	  Cube obj = (Cube)parent.object;
		    	  
		    	  x = Evaluate(splitParameters[0]);
		    	  y = Evaluate(splitParameters[1]);
		    	  z = Evaluate(splitParameters[2]);
		    	  
		    	  rotx = Evaluate(splitParameters[3]);
		    	  roty = Evaluate(splitParameters[4]);
		    	  rotz = Evaluate(splitParameters[5]);
		    	  
		    	  dx = Evaluate(splitParameters[6]);
		    	  dy = Evaluate(splitParameters[7]);
		    	  dz = Evaluate(splitParameters[8]);
		    	
		    	  Cube newCube =new Cube(1,2,3);
		    	  
		    	  parent.setObject(newCube);
		    	  
		    	  obj.setSize(dx, dy, dz);
		    	  parent.setCoords(new CoordinateSystem(new Vec3(x, y, z), rotx, roty, rotz));
		    	  
		          parent.clearCachedMeshes();
		          this.window.updateImage();
		          this.window.updateMenus();
	    	  }
	    	  catch (Exception ex)
	    	  {
	    		  System.out.println(ex);
	    	  }
	      }
	    }
	  }
	 
	  double Evaluate(String expr)
	  {
		  try
    	  {
			  jep.parseExpression(expr);
			  return jep.getValue();
    	  }
    	  catch (Exception ex)
    	  {
    		  System.out.println(ex);
    		  return 0;
    	  }
	  }
	    
	  void EvaluateFile(String fileName)
	  {
	    try
	    {
	      File inFile = new File(fileName);
	      BufferedReader fr = new BufferedReader(new FileReader(inFile));
	      String curLine;
	      
	      while(null!=(curLine=fr.readLine())) 
	      {
	        if(curLine.startsWith("#"))
	          continue;
	        int mark = curLine.indexOf("=");
	        
	        if (mark > 0)
	        {
	          String name = curLine.substring(0, mark).trim();
	          String formula = curLine.substring(mark+1);
	        
	          jep.parseExpression(formula);
	          try
	          {
	            double value;
	          
	            System.out.println(value = jep.getValue());
	            jep.addVariable(name, value);
	          }
	          catch (Exception ex)
	          {
	            System.out.println(ex);
	          }
	        }
	        else
	        {
	          System.out.println("! Invalid expression: " + curLine);
	        }
	      }
	    }
	    catch (Exception ex)
	    {
	      System.out.println(System.getProperty("user.dir"));
	      System.out.println(ex);
	    }
	  }
}
