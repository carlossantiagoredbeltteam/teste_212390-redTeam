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
import artofillusion.texture.Texture;
import artofillusion.texture.TextureMapping;

public class MetaCADEvaluatorEngine extends CSGEvaluatorEngine {
	JEP jep = new JEP();

	public MetaCADEvaluatorEngine(LayoutWindow window) {
		super(window);
		// TODO Auto-generated constructor stub

		readParameters();
	}

	public void readParameters() {
		jep = new JEP();
		jep.addStandardConstants();
		jep.addStandardFunctions();
		EvaluateFile("cad_parameters.txt");
	}

	public ObjectInfo evaluateNode(ObjectInfo parent, UndoRecord undo) {
		if (evaluateLoop(parent, undo))
			return parent;
		
		if (evaluateObject(parent, undo))
			return parent;
			
		return super.evaluateNode(parent, undo);
	}
	
	public Boolean evaluateLoop(ObjectInfo parent, UndoRecord undo) {
		String line = parent.name;
		int booleanOp=this.stringToOp(line);
		
		if (booleanOp==-1)
			return false;
		
		MetaCADParser forExpr = new MetaCADParser(line, ";");
		
		// no loop but a limple boolean op let base class do that
		if (forExpr.parseError && forExpr.parameters.length != 3)
		{
			return false;
		}
		else
		{
			CSGHelper helper = new CSGHelper(booleanOp);
			
			// evaluate first part of for loop i.e. i=0
			EvaluateLine(forExpr.parameters[0]);
			
			// security count to exit loop even if wee fuck up exit condition
			int count = 0;
			
			// condition loop evaluate the condition i.e. i < 10
			while (Evaluate(forExpr.parameters[1]) != 0 && count < 100) {
				ObjectInfo[] objects = parent.children;
				
				for (int i = 0; i < objects.length; i++)
				{
					helper.Add(evaluateNode(objects[i], undo).duplicate());
				}
				
				// "increment" evaluate 3rd for parameter i.e. i=i+1
				EvaluateLine(forExpr.parameters[2]);
				count++;
			}
			
			if (helper.sum != null)
			{
				Texture tex = parent.object.getTexture();
				TextureMapping map = parent.object.getTextureMapping();
				//parent.setCoords(new CoordinateSystem(new Vec3(x, y, z), rotx, roty, rotz));
				parent.setObject(helper.sum);
				parent.object.setTexture(tex, map);	
				
				parent.clearCachedMeshes();
				this.window.updateImage();
				this.window.updateMenus();
			}
		}
		
		return true;
	}
	
	public Boolean evaluateObject(ObjectInfo parent, UndoRecord undo) {
		String line = parent.name;
		
		MetaCADParser objExpr = new MetaCADParser(line, ",");
		
		if (objExpr.parseError)
			return false;
		
		if (objExpr.parameters.length >= 9)
		{
			double x, y, z, rotx, roty, rotz, a, b, c;
			
			x = Evaluate(objExpr.parameters[0]);
			y = Evaluate(objExpr.parameters[1]);
			z = Evaluate(objExpr.parameters[2]);

			rotx = Evaluate(objExpr.parameters[3]);
			roty = Evaluate(objExpr.parameters[4]);
			rotz = Evaluate(objExpr.parameters[5]);

			a = Evaluate(objExpr.parameters[6]);
			b = Evaluate(objExpr.parameters[7]);
			c = Evaluate(objExpr.parameters[8]);
			

			Object3D obj3D=null;
			
			if (objExpr.name.startsWith("cube")) {
				obj3D = new Cube(a, b, c);
			}
			if (objExpr.name.startsWith("sphere")) {
				obj3D = new Sphere(a/2.0, b/2.0, c/2.0);
			}
			if (objExpr.name.startsWith("cylinder")) {
				double ratio = 1;
				
				if (objExpr.parameters.length >= 10)
				{
					ratio = Evaluate(objExpr.parameters[9]);
					if (ratio > 1) ratio = 1;
					if (ratio < 0) ratio = 0;
				}	
				obj3D = new Cylinder(a, b/2.0, c/2.0, ratio);
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
	
	public ObjectInfo evaluateNodeOld(ObjectInfo parent, UndoRecord undo) {
		readParameters();
		ParseFunction(parent, undo);

		return super.evaluateNode(parent, undo);
	}

	void ParseFunction(ObjectInfo parent, UndoRecord undo) {
		String line = parent.name;
		String functionName;
		String parameters;
		String[] splitParameters;

		String lineParts[];
		String forPart;
		MetaCADParser forExpr = null;

		lineParts = line.split(":");
		if (lineParts.length == 2) {
			forExpr = new MetaCADParser(lineParts[0], ";");
			line = lineParts[1];
		}

		MetaCADParser myExpr = new MetaCADParser(line, ",");
		if (!myExpr.parseError) {
			functionName = myExpr.name;
			splitParameters = myExpr.parameters;

			if (parent.object.getClass().equals(Sphere.class)
					&& splitParameters.length >= 9) {
				try {
					double x, y, z, rotx, roty, rotz, dx, dy, dz;

					Sphere obj = (Sphere) parent.object;

					x = Evaluate(splitParameters[0]);
					y = Evaluate(splitParameters[1]);
					z = Evaluate(splitParameters[2]);

					rotx = Evaluate(splitParameters[3]);
					roty = Evaluate(splitParameters[4]);
					rotz = Evaluate(splitParameters[5]);

					dx = Evaluate(splitParameters[6]) * 2;
					dy = Evaluate(splitParameters[7]) * 2;
					dz = Evaluate(splitParameters[8]) * 2;

					obj.setSize(dx, dy, dz);
					parent.setCoords(new CoordinateSystem(new Vec3(x, y, z),
							rotx, roty, rotz));

					parent.clearCachedMeshes();
					this.window.updateImage();
					this.window.updateMenus();
				} catch (Exception ex) {
					System.out.println(ex);
				}
			}

			if (parent.object.getClass().equals(Cylinder.class)
					&& splitParameters.length >= 9) {
				try {
					double x, y, z, rotx, roty, rotz, dx, height, dz;

					Cylinder obj = (Cylinder) parent.object;

					x = Evaluate(splitParameters[0]);
					y = Evaluate(splitParameters[1]);
					z = Evaluate(splitParameters[2]);

					rotx = Evaluate(splitParameters[3]);
					roty = Evaluate(splitParameters[4]);
					rotz = Evaluate(splitParameters[5]);

					dx = Evaluate(splitParameters[6]) * 2;
					dz = Evaluate(splitParameters[7]) * 2;
					height = Evaluate(splitParameters[8]);

					obj.setSize(dx, height, dz);
					parent.setCoords(new CoordinateSystem(new Vec3(x, y, z),
							rotx, roty, rotz));

					parent.clearCachedMeshes();
					this.window.updateImage();
					this.window.updateMenus();
				} catch (Exception ex) {
					System.out.println(ex);
				}
			}

			if (functionName.toLowerCase().startsWith("cube") && splitParameters.length >= 9) {
				double x, y, z, rotx, roty, rotz, dx, dy, dz;

				CSGHelper helper = new CSGHelper(CSGObject.UNION);

				if (forExpr != null && !forExpr.parseError) {
					// evaluate frst part of for loop i.e. i=0
					EvaluateLine(forExpr.parameters[0]);

					int count = 0;
					// condition loop evaluate the condition i.e. i < 10
					while (Evaluate(forExpr.parameters[1]) != 0 && count < 10) {
						x = Evaluate(splitParameters[0]);
						y = Evaluate(splitParameters[1]);
						z = Evaluate(splitParameters[2]);

						rotx = Evaluate(splitParameters[3]);
						roty = Evaluate(splitParameters[4]);
						rotz = Evaluate(splitParameters[5]);

						dx = Evaluate(splitParameters[6]);
						dy = Evaluate(splitParameters[7]);
						dz = Evaluate(splitParameters[8]);

						//
						// newCube.setTexture(parent.object.getTexture(),
						// parent.object.getTextureMapping());

						Cube newCube = new Cube(dx, dy, dz);
						ObjectInfo objInfo = new ObjectInfo(newCube,
								new CoordinateSystem(new Vec3(x, y, z), rotx,
										roty, rotz), "dummy");
						helper.Add(objInfo);

						// "increment" evaluate 3rd for parameter i.e. i=i+1
						EvaluateLine(forExpr.parameters[2]);
					}
					if (helper.GetObject() != null) {
						Texture tex = parent.object.getTexture();
						TextureMapping map = parent.object.getTextureMapping();

						parent.setObject(helper.GetObject());
						parent.object.setTexture(tex, map);
					}

					parent.clearCachedMeshes();
					this.window.updateImage();
					this.window.updateMenus();
				}
			}
		}
	}

	double Evaluate(String expr) {
		try {
			jep.parseExpression(expr);
			return jep.getValue();
		} catch (Exception ex) {
			System.out.println(ex);
			return 0;
		}
	}

	// Evaluates Expressions like x=2*radius and assigns the value to the given
	// variable
	void EvaluateLine(String curLine) {
		int mark = curLine.indexOf("=");

		if (mark > 0) {
			String name = curLine.substring(0, mark).trim();
			String formula = curLine.substring(mark + 1);

			jep.parseExpression(formula);
			try {
				double value;

				System.out.println(value = jep.getValue());
				jep.addVariable(name, value);
			} catch (Exception ex) {
				System.out.println(ex);
			}

		} else {
			System.out.println("! Invalid Line Expression: " + curLine);
		}
	}

	void EvaluateFile(String fileName) {
		try {
			File inFile = new File(fileName);
			BufferedReader fr = new BufferedReader(new FileReader(inFile));
			String curLine;

			while (null != (curLine = fr.readLine())) {
				curLine = curLine.trim();
				if (curLine.length() == 0 || curLine.startsWith("#"))
					continue;
				EvaluateLine(curLine);
			}
		} catch (Exception ex) {
			System.out.println(System.getProperty("user.dir"));
			System.out.println(ex);
		}
	}
}
