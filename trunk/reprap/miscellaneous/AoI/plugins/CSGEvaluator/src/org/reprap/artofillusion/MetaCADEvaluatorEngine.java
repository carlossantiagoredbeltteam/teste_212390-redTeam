package org.reprap.artofillusion;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import org.cheffo.jeplite.JEP;

import artofillusion.LayoutWindow;
import artofillusion.UndoRecord;
import artofillusion.math.CoordinateSystem;
import artofillusion.math.Vec2;
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
        Vec3[] v=null;
        float[] smoothness=null;
        
        if (parameters.length == 4 && parameters[0].startsWith("star")) {
          double inner  = evaluateExpression(parameters[2]); //innerValueField.getValue();
          double outer = evaluateExpression(parameters[3]); //outerValueField.getValue();
          int n = (int)evaluateExpression(parameters[1]); //(int) Math.round( nValueField.getValue() );

          v = new Vec3[2*n];
          smoothness = new float[2*n];
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
        if (parameters.length >= 3 && parameters[0].startsWith("reg")) {
          double radiusy;
          double radiusx  = evaluateExpression(parameters[2]);
          
          if (parameters.length >= 4)
            radiusy  = evaluateExpression(parameters[3]); 
          else
            radiusy  = radiusx;
          
          int n = (int)evaluateExpression(parameters[1]); 

          v = new Vec3[n];
          smoothness = new float[n];
          int index = 0;
          for (int i = 0; i < n; i++)
          {
            v[index] = new Vec3( radiusx*Math.cos( 2*Math.PI * index / (double) n ),
                radiusy*Math.sin(2*Math.PI * index / (double) n ), 0 );
            smoothness[index]=0;
            index++;
          }

          obj3D = new Curve(v, smoothness, Mesh.NO_SMOOTHING, true).convertToTriangleMesh(0);
        }
        
        if (parameters.length >= 4 && parameters[0].startsWith("roll")) {
          double big  = evaluateExpression(parameters[2]); //innerValueField.getValue();
          double small = evaluateExpression(parameters[3]); //outerValueField.getValue();
          int n = (int)evaluateExpression(parameters[1]); //(int) Math.round( nValueField.getValue() );
          double small2 = small;
          if (parameters.length == 5)
            small2=evaluateExpression(parameters[4]);
            
          
          v = new Vec3[n];
          smoothness = new float[n];
          int index = 0;
          for (int i = 0; i < n; i++)
          {
            double biga=(2*Math.PI*i)/n;
            double len = big*biga;
            double smalla=len/small;
            double x,y;
            
            x = (big+small)*Math.cos(biga) + (small2)*Math.cos(smalla);
            y = (big+small)*Math.sin(biga) + (small2)*Math.sin(smalla);
            
            v[index] = new Vec3(x, y, 0 );
            
            smoothness[index]=0;
            index++;
          }
        }
        if (v != null && smoothness!= null)
        {
          String[] inset = objExpr.getParameters("inset");
          
          if (inset != null && inset.length == 1)
          {
            v = insetPoly(v, evaluateExpression(inset[0]));
            
  //          double s=evaluateExpression(shrink[0]);
  //          for (int i = 0; i < v.length; i++)
  //          {
  //            int iprev = (i+v.length-1)%v.length;
  //            int inext = (i+1)%v.length;
  //            
  //            double yn = -(v[inext].x - v[iprev].x);
  //            double xn = v[inext].y - v[iprev].y;
  //            
  //            double l=Math.sqrt(xn*xn+yn*yn);
  //            xn /= l;
  //            yn /= l;
  //            
  //            v[i].x += s*xn;
  //            v[i].y += s*yn; 
  //          }
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
        if (!(profileobj instanceof TriangleMesh) &&
            profileobj.canConvertToTriangleMesh() != Object3D.CANT_CONVERT) {
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

          // Since the result is centered in the origin, offset the extruded object to 
          // move it back to its original position
          // FIXME: Combine this with the user-specified coordinate system
          coordsys = new CoordinateSystem(new Vec3(), Vec3.vz(), Vec3.vy());
          Vec3 offset = profile.getCoords().fromLocal().times(((Mesh)profileobj).getVertices()[0].r).
          minus(coordsys.fromLocal().times(((Mesh)obj3D).getVertices()[0].r));
          coordsys.setOrigin(coordsys.getOrigin().plus(offset));
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

///////////////////////////////////////////
//math helpers
 
  // solves system of 2 linear equations in 2 unknown 
  class LinearSolve2
  {
    public boolean error;
    public double x1, x2;
  
    // matrix looks like this 
    // a b
    // c d
    public double det(double a,double b, double c, double d)
    {
      return a*d-b*c;  
    }
    // the equations look like thsi looks like this
    // x1*a + x2*b = r1
    // x1*c + x2*d = r2
    public LinearSolve2(double a,double b, double c, double d, double r1, double r2)
    {
      double q;
      
      q=det(a,b,c,d);
      if (Math.abs(q) < 0.00000001)
      {
        error = true;
      }
      else
      {
        error = false;
        x1=det(r1,b,r2,d)/q;
        x2=det(a,r1,c,r2)/q;
      }
    }
  }
  
  class MetaCADLine {
    protected Vec2 start,end, dir;
    protected Vec2 normal;
    
    public MetaCADLine(Vec3 s,Vec3 e)
    {
      start = new Vec2(s.x,s.y);
      end = new Vec2(e.x, e.y);
      dir = end.minus(start);
      normal = new Vec2(dir);
      normal.normalize();
      normal.set(-normal.y, normal.x);
    }
    
    public void parallelMove(double d)
    {
      start.add(normal.times(d));
    }
    
    public Vec3 intersect3(MetaCADLine l)
    {
      LinearSolve2 solve = new LinearSolve2(l.dir.x, -dir.x, l.dir.y, -dir.y, start.x-l.start.x, start.y-l.start.y);
      if (solve.error)
      {
        return null;
      }
      else
      {
        Vec2 point = start.plus(dir.times(solve.x2)); 
        return new Vec3(point.x,point.y, 0);
      }
    }
  }
  
  Vec3[] insetPoly(Vec3[] poly,double inset)
  {
    //List<MetaCADLine> lines = new ArrayList<MetaCADLine>();
    List<Vec3> points = new ArrayList<Vec3>();
    
    for (int i = 0; i < poly.length; i++)
    {
        int iprev = (i+poly.length-1)%poly.length;
        int inext = (i+1)%poly.length;
        
        MetaCADLine prev = new MetaCADLine(poly[iprev], poly[i]);
        MetaCADLine next = new MetaCADLine(poly[i], poly[inext]);
        
        prev.parallelMove(inset);
        next.parallelMove(inset);
        
        Vec3 intersect=prev.intersect3(next);
        if (intersect ==  null)
        {
          intersect = new Vec3(0,0,0);
        }
        points.add(intersect);
    }
     
    return points.toArray(new Vec3[1]);
  }
}

