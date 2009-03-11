package org.reprap.artofillusion;

import java.util.Enumeration;

import org.cheffo.jeplite.JEP;

import artofillusion.LayoutWindow;
import artofillusion.UndoRecord;
import artofillusion.math.CoordinateSystem;
import artofillusion.math.Vec3;
import artofillusion.object.Cube;
import artofillusion.object.Curve;
import artofillusion.object.Cylinder;
import artofillusion.object.Mesh;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;
import artofillusion.object.Sphere;
import artofillusion.object.TriangleMesh;
import artofillusion.texture.Texture;
import artofillusion.texture.TextureMapping;
import artofillusion.tools.ExtrudeTool;
import artofillusion.ui.MessageDialog;

public class MetaCADEvaluatorEngine extends CSGEvaluatorEngine {
  JEP jep = new JEP();

  public MetaCADEvaluatorEngine(LayoutWindow window) {
    super(window);
  }

  public void setParameters(String text) {
    window.getScene().setMetadata(
        MetaCADEvaluatorEngine.class.getName() + "Parameters", text);
  }

  public String getParameters() {
    Object o = window.getScene().getMetadata(
        MetaCADEvaluatorEngine.class.getName() + "Parameters");

    if (o != null)
      return o.toString();

    return "";
  }

  public boolean readParameters() {
    jep = new JEP();
    jep.addStandardConstants();
    jep.addStandardFunctions();
    return evaluateLines(getParameters());
  }


  public void evaluate() {
    // only evaluate selected objects if the parameters could be evaluated
    if (readParameters())
      super.evaluate();
  }

  public ObjectInfo evaluateNode(ObjectInfo parent, UndoRecord undo) throws Exception {
    if (evaluateLoop(parent, undo))
      return parent;

    if (evaluateObject(parent, undo))
      return parent;

    return super.evaluateNode(parent, undo);
  }

  public Boolean evaluateLoop(ObjectInfo parent, UndoRecord undo)
      throws Exception {
    String line = parent.name;
    int booleanOp = this.stringToOp(line);

    if (booleanOp == -1)
      return false;

    String[] parameters = null;
    CoordinateSystem coordsys=null;
    MetaCADParser coordExpr = new MetaCADParser(line);

    if (!coordExpr.parse()) return false;

    Enumeration<String> iter = coordExpr.getNames();
    while (iter.hasMoreElements()) {
      String name = iter.nextElement();
      parameters = coordExpr.getParameters(name);
      
      if (name.equals("cs")) {
        coordsys = evaluateCoordSys(parameters);
      }
      else if (name.startsWith(this.opToString(booleanOp)))
      {
        parameters=coordExpr.getParameters(name);
      }
    }
      
    if (parameters == null || parameters.length != 3) {
      // no loop but a simple boolean operation let base class do that
      coordExpr = new MetaCADParser("dummyDummy(dummyDummy=0; dummyDummy<1; dummyDummy=dummyDummy+1)");
      coordExpr.parse();
      parameters = coordExpr.getParameters("dummyDummy");
    }

    CSGHelper helper = new CSGHelper(booleanOp);

    // evaluate first part of for loop i.e. i=0
    evaluateAssignment(parameters[0]);

    // security count to exit loop even if we fuck up exit condition
    int count = 0;

    // condition loop evaluate the condition i.e. i < 10
    while (evaluateExpression(parameters[1]) != 0 && count < 100) {
      ObjectInfo[] objects = parent.children;

      for (int i = 0; i < objects.length; i++) {
        helper.Add(evaluateNode(objects[i], undo).duplicate());
      }

      // "increment" evaluate 3rd for parameter i.e. i=i+1
      evaluateAssignment(parameters[2]);
      count++;
    }

    if (helper.GetObject() != null) {
      Texture tex = parent.object.getTexture();
      TextureMapping map = parent.object.getTextureMapping();

      if (coordsys != null) parent.setCoords(coordsys);

      Object3D test = sanitizeObject3D(helper.GetObject());

      parent.setObject(test);

      parent.object.setTexture(tex, map);

      parent.clearCachedMeshes();
      this.window.updateImage();
      this.window.updateMenus();

    }

    return true;
  }

  protected Object3D sanitizeObject3D(Object3D obj) throws Exception {
    try {
      obj.getBounds();
    } catch (Exception ex) {
      showMessage("Exception in Object3D.getBounds()? Bad CSG Object? Check for coinciding surfaces.");
      throw ex;
      // return new Cube(10,10,10);
    }
    return obj;
  }

  
  /**
   * 
   * Evaluates the given object.
   * 
   * @return true if object was successfully evaluated, 
   * false if either an error occurred or if the object was not recognized by MetaCADEvaluator
   * 
   */
  public Boolean evaluateObject(ObjectInfo parent, UndoRecord undo) throws Exception {
    
    String line = parent.name;

    MetaCADParser objExpr = new MetaCADParser(line);
    if (!objExpr.parse()) {
      // FIXME: Notify user? 
      return false;
    }

    Object3D obj3D = null;
    CoordinateSystem coordsys = null;

    Enumeration<String> iter = objExpr.getNames();
    while (iter.hasMoreElements()) {
      String name = iter.nextElement();
      String[] parameters = objExpr.getParameters(name);

      if (name.equals("cs")) {
        coordsys = evaluateCoordSys(parameters);
      }
      else if (name.startsWith("poly")) {
        if (parameters.length == 4 && parameters[0].startsWith("star")) {
          double inner  = evaluateExpression(parameters[2]); //innerValueField.getValue();
          double outer = evaluateExpression(parameters[3]); //outerValueField.getValue();
          int n = (int)evaluateExpression(parameters[1]); //(int) Math.round( nValueField.getValue() );

          Vec3[] v = new Vec3[2*n];
          float[] smoothness = new float[2*n];
          int index = 0;
          for (int i = 0; i < n; i++)
          {
            v[index] = new Vec3( Math.cos( Math.PI * index / (double) n ),
                Math.sin( Math.PI * index / (double) n ), 0 );
            v[index].scale( inner );
            v[index+1] = new Vec3( Math.cos( Math.PI * (index + 1) / (double) n ),
                Math.sin( Math.PI * (index + 1) / (double) n ), 0 );
            v[index+1].scale( outer );
            smoothness[index]=0;
            smoothness[index+1]=0;
            index += 2;
          }

          obj3D = new Curve(v, smoothness, Mesh.NO_SMOOTHING, true).convertToTriangleMesh(0);
        }
      }
      else if (name.startsWith("extrude")) {
        // Three first parameters define the extrusion vector
        Vec3 dir = Vec3.vz();
        if (parameters.length >= 3) {
          dir = new Vec3(evaluateExpression(parameters[0]),
              evaluateExpression(parameters[1]),
              evaluateExpression(parameters[2]));
        }
        // 4. parameter is num segments
        int numsegments = 1;
        if (parameters.length >= 4) {
          numsegments = (int)evaluateExpression(parameters[3]);
          if (numsegments < 2) numsegments = 1;
        }
        // 5. parameter is twist degrees
        double twist = 0.0;
        if (parameters.length >= 5) {
          twist = evaluateExpression(parameters[4]);
        }

        // First child is the base mesh
        // FIXME: Find all extrudable child objects instead
        // FIXME: Recursively evaluate children
        ObjectInfo[] children = parent.getChildren();
        for (int i=0;i<children.length;i++) {
          evaluateNode(children[i], undo);
        }
        ObjectInfo profile = parent.getChildren()[0];
        Object3D profileobj = profile.getObject();
        if (profileobj.canConvertToTriangleMesh() != Object3D.CANT_CONVERT) {
          profileobj = profileobj.convertToTriangleMesh(0.1);
        }

        if (profileobj instanceof TriangleMesh) {
          // Build extrusion curve from vector and segments
          Vec3 v[] = new Vec3[numsegments+1];
          float smooth[] = new float[v.length];
          for (int i = 0; i < v.length; i++) {
            v[i] = new Vec3(dir);
            v[i].scale(1.0*i/numsegments);
            smooth[i] = 1.0f;
          }
          Curve path = new Curve(v, smooth, Mesh.NO_SMOOTHING, false);
          CoordinateSystem pathCoords = new CoordinateSystem();

          obj3D = ExtrudeTool.extrudeMesh((TriangleMesh)profileobj, path, profile.getCoords(), pathCoords, twist*Math.PI/180.0, true);
        }
        for (int i=0;i<children.length;i++) children[i].setVisible(false);
      }
      else {
        // Typically, the three next parameters are common object properties
        if (parameters.length >= 3) {
          double a, b, c;

          a = evaluateExpression(parameters[0]);
          b = evaluateExpression(parameters[1]);
          c = evaluateExpression(parameters[2]);

          if (name.startsWith("cube")) {
            obj3D = new Cube(a, b, c);
          }
          if (name.startsWith("sphere")) {
            obj3D = new Sphere(a, b, c);
          }
          if (name.startsWith("cylinder")) {
            double ratio = 1;
            // Cylinder takes an optional fourth parameter
            if (parameters.length >= 4) {
              ratio = evaluateExpression(parameters[3]);
              if (ratio > 1) ratio = 1;
              if (ratio < 0) ratio = 0;
            }
            obj3D = new Cylinder(a, b, c, ratio);
          }
        }
      }
    }

    if (obj3D != null) {
      Texture tex = parent.object.getTexture();
      TextureMapping map = parent.object.getTextureMapping();

      if (coordsys != null) parent.setCoords(coordsys);
      else parent.setCoords(new CoordinateSystem());
      parent.setObject(obj3D);
      parent.object.setTexture(tex, map);

      parent.clearCachedMeshes();
      this.window.updateImage();
      this.window.updateMenus();
    } else {
      return false;
    }
    return true;
  }
  
  // Evaluates an Expression like 3*x+sin(a) and returns the value of it or 0 if
  // any error occurred
  double evaluateExpression(String expr) throws Exception {
    try {
      jep.parseExpression(expr);
      return jep.getValue();
    } catch (Exception ex) {
      showMessage("Error while evaluating Expression: \"" + expr
          + "\" Syntax Error or unknown variable?");
      throw (ex);
      // return 0;
    }
  }

  // Evaluates Expressions like x=2*radius and assigns the value to the given
  // variable
  void evaluateAssignment(String curLine) throws Exception {
    try {
      int mark = curLine.indexOf("=");

      String name = curLine.substring(0, mark).trim();
      String formula = curLine.substring(mark + 1);
      jep.parseExpression(formula);
      double value = jep.getValue();
      // System.out.println(value);
      jep.addVariable(name, value);
    } catch (Exception ex) {
      showMessage("Invalid Assignment: \"" + curLine + "\" syntax error?");
      throw (ex);
    }
  }

  boolean evaluateLines(String text) {
    try {
      String lines[] = text.split("\n");
      for (String curLine : lines) {
        curLine = curLine.trim();
        if (curLine.length() == 0 || curLine.startsWith("#"))
          continue;
        evaluateAssignment(curLine);
      }
      return true;
    } catch (Exception ex) {
      //System.out.println(ex);
      return false;
    }
  }

  CoordinateSystem evaluateCoordSys(String[] parameters) throws Exception {
    CoordinateSystem coordsys = null;
    if (parameters != null) {
      coordsys = new CoordinateSystem();
      if (parameters.length >= 3) {
        coordsys.setOrigin(new Vec3(evaluateExpression(parameters[0]),
            evaluateExpression(parameters[1]),
            evaluateExpression(parameters[2])));
      }
      if (parameters.length >= 6) {
        coordsys.setOrientation(evaluateExpression(parameters[3]),
             evaluateExpression(parameters[4]),
             evaluateExpression(parameters[5]));
      }
    }
    return coordsys;
  }
  
  void showMessage(String text)  {
    new MessageDialog(this.window, text);
  }
}
