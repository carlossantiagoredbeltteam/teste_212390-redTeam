package org.reprap.artofillusion;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.Date;
import java.util.List;

import javax.print.DocFlavor.STRING;

import org.cheffo.jeplite.JEP;

import bsh.EvalError;
import bsh.Interpreter;

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
import artofillusion.texture.Texture;
import artofillusion.texture.TextureMapping;

public class MetaCADEvaluatorEngine extends CSGEvaluatorEngine {
	JEP jep = new JEP();

	public MetaCADEvaluatorEngine(LayoutWindow window) {
		super(window);
	}
	
	public void setParameters(String text)
	{
		window.getScene().setMetadata(MetaCADEvaluatorEngine.class.getName()+"Parameters", text);
	}
	
	public String getParameters()
	{
		Object o = window.getScene().getMetadata(MetaCADEvaluatorEngine.class.getName()+"Parameters");
		
		if (o!=null)
			return o.toString();
		
		return "";
	}
	
	public void readParameters() {
		jep = new JEP();
		jep.addStandardConstants();
		jep.addStandardFunctions();
		evaluateLines(getParameters());
	}
	
	public void evaluate()
	{
	  readParameters();
	  super.evaluate();
	}

	public ObjectInfo evaluateNode(ObjectInfo parent, UndoRecord undo) throws Exception {
		if (evaluateLoop(parent, undo))
			return parent;
		
		if (evaluateObject(parent, undo))
			return parent;
			
		return super.evaluateNode(parent, undo);
	}
	
	public Boolean evaluateLoop(ObjectInfo parent, UndoRecord undo) throws Exception {
		String line = parent.name;
		int booleanOp=this.stringToOp(line);
		
		if (booleanOp==-1)
			return false;
		
		MetaCADParser coordExpr = null;
		
		String []subParam = line.split("\\)\\s*\\(");
		if (subParam.length==2)
		{
			coordExpr=new MetaCADParser("dummy(" + subParam[1], ",");
			line=subParam[0] + ")";
		}
		
		MetaCADParser forExpr = new MetaCADParser(line, ";");
		
		// no loop but a limple boolean op let base class do that
		if (forExpr.parseError || forExpr.parameters.length != 3)
		{
			return false;
		}
		else
		{
			CSGHelper helper = new CSGHelper(booleanOp);
			
			// evaluate first part of for loop i.e. i=0
			evaluateAssignment(forExpr.parameters[0]);
			
			// security count to exit loop even if wee fuck up exit condition
			int count = 0;
			
			// condition loop evaluate the condition i.e. i < 10
			while (evaluateExpresion(forExpr.parameters[1]) != 0 && count < 100) {
				ObjectInfo[] objects = parent.children;
				
				for (int i = 0; i < objects.length; i++)
				{
					helper.Add(evaluateNode(objects[i], undo).duplicate());
				}
				
				// "increment" evaluate 3rd for parameter i.e. i=i+1
				evaluateAssignment(forExpr.parameters[2]);
				count++;
			}
			
			if (helper.sum != null)
			{
				Texture tex = parent.object.getTexture();
				TextureMapping map = parent.object.getTextureMapping();
				
				// use coordinate system paramaters from loop if user gave one
				if (coordExpr != null && !coordExpr.parseError)
				{
					double x, y, z, rotx, roty, rotz;
					
					x = evaluateExpresion(coordExpr.parameters[0]);
					y = evaluateExpresion(coordExpr.parameters[1]);
					z = evaluateExpresion(coordExpr.parameters[2]);

					rotx = evaluateExpresion(coordExpr.parameters[3]);
					roty = evaluateExpresion(coordExpr.parameters[4]);
					rotz = evaluateExpresion(coordExpr.parameters[5]);
					
					parent.setCoords(new CoordinateSystem(new Vec3(x, y, z), rotx, roty, rotz));
				}
				
				
				parent.setObject(helper.sum);
				parent.object.setTexture(tex, map);	
				
				parent.clearCachedMeshes();
				this.window.updateImage();
				this.window.updateMenus();
			}
		}
		
		return true;
	}
	
	public Boolean evaluateObject(ObjectInfo parent, UndoRecord undo) throws Exception {
		String line = parent.name;
		
		MetaCADParser objExpr = new MetaCADParser(line, ",");
		
		if (objExpr.parseError)
			return false;
		
		if (objExpr.parameters.length >= 9)
		{
			double x, y, z, rotx, roty, rotz, a, b, c;
			
			x = evaluateExpresion(objExpr.parameters[0]);
			y = evaluateExpresion(objExpr.parameters[1]);
			z = evaluateExpresion(objExpr.parameters[2]);

			rotx = evaluateExpresion(objExpr.parameters[3]);
			roty = evaluateExpresion(objExpr.parameters[4]);
			rotz = evaluateExpresion(objExpr.parameters[5]);

			a = evaluateExpresion(objExpr.parameters[6]);
			b = evaluateExpresion(objExpr.parameters[7]);
			c = evaluateExpresion(objExpr.parameters[8]);
			

			Object3D obj3D=null;
			
			if (objExpr.name.startsWith("cube")) {
				obj3D = new Cube(a, b, c);
			}
			if (objExpr.name.startsWith("sphere")) {
				obj3D = new Sphere(a, b, c);
			}
			if (objExpr.name.startsWith("cylinder")) {
				double ratio = 1;
				
				if (objExpr.parameters.length >= 10)
				{
					ratio = evaluateExpresion(objExpr.parameters[9]);
					if (ratio > 1) ratio = 1;
					if (ratio < 0) ratio = 0;
				}	
				obj3D = new Cylinder(a, b, c, ratio);
			}
			
			if (obj3D!=null)
			{
				Texture tex = parent.object.getTexture();
				TextureMapping map = parent.object.getTextureMapping();
				
				parent.setCoords(new CoordinateSystem(new Vec3(x, y, z), rotx, roty, rotz));
				parent.setObject(obj3D);
				parent.object.setTexture(tex, map);	
				
				parent.clearCachedMeshes();
				this.window.updateImage();
				this.window.updateMenus();
			}
			else
			{
				return false;
			}
		}
		
		return true;
	}

	// Evaluates an Expression like 3*x+sin(a) and returns the value of it or 0 if any error occured
	double evaluateExpresion(String expr) throws Exception {
		try {
			jep.parseExpression(expr);
			return jep.getValue();
		} catch (Exception ex) {
			System.out.println("Error while evaluating Expression: \"" + expr + "\" Syntax Error or unknown variable?");
			throw(ex);
			//return 0;
		}
	}

	// Evaluates Expressions like x=2*radius and assigns the value to the given
	// variable
	void evaluateAssignment(String curLine) throws Exception {
		try
		{		
			int mark = curLine.indexOf("=");
	
			String name = curLine.substring(0, mark).trim();
			String formula = curLine.substring(mark + 1);
			jep.parseExpression(formula);
			double value = jep.getValue();
			//System.out.println(value);
			jep.addVariable(name, value);
		}
		catch (Exception ex)
		{
			System.out.println("Invalid Assignment: \"" + curLine +"\" syntax error?");
			throw(ex);
		}
	}
	
	void evaluateLines(String text)
	{
		try {
			String lines[] = text.split("\n");
			for (String curLine : lines)
			{
				curLine = curLine.trim();
				if (curLine.length() == 0 || curLine.startsWith("#"))
					continue;
				evaluateAssignment(curLine);
			}
		} catch (Exception ex) {
			System.out.println(ex);
		}
	}

	void evaluateParametersFile(String fileName) {
		try {
			File inFile = new File(fileName);
			BufferedReader fr = new BufferedReader(new FileReader(inFile));
			String curLine;

			while (null != (curLine = fr.readLine())) {
				curLine = curLine.trim();
				if (curLine.length() == 0 || curLine.startsWith("#"))
					continue;
				evaluateAssignment(curLine);
			}
		} catch (Exception ex) {
			System.out.println(ex);
		}
	}
}
