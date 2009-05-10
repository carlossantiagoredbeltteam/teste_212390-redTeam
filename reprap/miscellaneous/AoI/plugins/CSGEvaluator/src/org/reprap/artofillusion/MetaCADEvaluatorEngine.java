package org.reprap.artofillusion;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import org.cheffo.jeplite.JEP;
import org.reprap.artofillusion.language.ParsedStatement;
import org.reprap.artofillusion.parser.ParseException;

import artofillusion.LayoutWindow;
import artofillusion.Scene;
import artofillusion.UndoRecord;
import artofillusion.math.CoordinateSystem;
import artofillusion.math.Vec2;
import artofillusion.math.Vec3;
import artofillusion.object.CSGObject;
import artofillusion.object.Cube;
import artofillusion.object.Cylinder;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;
import artofillusion.object.Sphere;
import artofillusion.texture.Texture;
import artofillusion.texture.TextureMapping;
import artofillusion.ui.MessageDialog;

public class MetaCADEvaluatorEngine extends CSGEvaluatorEngine
{
  public static final int EXTRUSION = 10;
  public static final int POLYGON   = 11;
  public static final int SPHERE    = 12;
  public static final int CUBE      = 13;
  public static final int CYLINDER  = 14;
  
  MetaCADContext context;

  public MetaCADEvaluatorEngine(LayoutWindow window) {
    super(window);
    this.context = new MetaCADContext(window.getScene());
  }

  /**
   * Converts from operation to String
   */
  public String opToString(int operation) {
    switch (operation) {
    case EXTRUSION:
      return "extrude()";
    case POLYGON:
      return "polygon()";
    case CUBE:
      return "cube()";
    case SPHERE:
      return "sphere()";
    case CYLINDER:
      return "cylinder()";
    default:
      return super.opToString(operation);
    }
  }

  /**
   * Converts from string to operation.
   */
  public int stringToOp(String opstr) {
    String lower = opstr.toLowerCase();
    if (lower.startsWith("extrude")) {
      return EXTRUSION;
    }
    else if (lower.startsWith("poly")) {
      return POLYGON;
    }
    else if (lower.startsWith("cube")) {
      return CUBE;
    }
    else if (lower.startsWith("sphere")) {
      return SPHERE;
    }
    else if (lower.startsWith("cylinder")) {
      return CYLINDER;
    }
    else return super.stringToOp(opstr);
  }
  
  public void setParameters(String text) {
    this.window.getScene().setMetadata(
        MetaCADEvaluatorEngine.class.getName() + "Parameters", text);
  }

  public String getParameters() {
    Object o = this.window.getScene().getMetadata(
        MetaCADEvaluatorEngine.class.getName() + "Parameters");

    if (o != null)
      return o.toString();

    return "";
  }

  public boolean readParameters() {
    this.context.jep = new JEP();
    this.context.jep.addStandardConstants();
    this.context.jep.addStandardFunctions();
 
    try {
      List<ParsedStatement> statements = 
        org.reprap.artofillusion.parser.MetaCADParser.parseParameters(getParameters());
      for (int i = 0; i < statements.size(); i++)
      {
        boolean success = statements.get(i).execute(this.context);
        if (!success)
        {
          showMessage("Error in statement: " + statements.get(i).toString());
          return false;
        }
      }
    } catch (ParseException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
      showMessage(e.getMessage());
      return false;
    }
    return true;
  }

  
  /**
   * 
   * Recursively extracts an AoI object tree and creates our own ParsedTree representation.
   * 
   */
  public ParsedTree extractTree(ObjectInfo parent) throws ParseException {

    // Try converting the object before parsing
    convertObject(parent);

    // Parse this ObjectInfo
    ParsedTree root = null;
    try {
      root = org.reprap.artofillusion.parser.MetaCADParser.parseTree(parent.name + ";");
      root.aoiobj = parent;
    }
    catch (ParseException e) {
      if (parent.isLocked()) { // This object has previously been evaluated successfully
        throw e; // Rethrow exception        
      }
      else { // This is probably a native object
        root = new ParsedTree();
        root.name = "native";
        root.aoiobj = parent;
      }
    }
    
    // If the parser returned a subtree, find the leaf node
    // (we guarantee that there are at most one child of each intermediate node)
    ParsedTree parenttree = root;
    while (!parenttree.children.isEmpty()) parenttree = (ParsedTree)parenttree.children.get(0);

    // Build hierarchy recursively
    ObjectInfo[] objects = parent.children;
    for (int i=0;i<objects.length;i++) {
      parenttree.children.add(extractTree(objects[i]));
    }
    return root;
  }

  /**
   * Evaluates selected objects
   */
  public void evaluate() {
    // Only evaluate selected objects if the parameters could be evaluated
    if (readParameters()) {
      // Extract object tree from AoI into our ParsedTree data structure,
      // one tree per selected node in AoI
      try {
        List<ParsedTree> trees = new LinkedList<ParsedTree>();
        ObjectInfo[] objects = getSelection();
        if (objects != null) {
          for (int i=0;i<objects.length;i++) {
            ParsedTree tree = extractTree(objects[i]);
            if (tree != null) trees.add(tree);
          }
        }

        // Evaluate the parsed trees
        Iterator<ParsedTree> iter = trees.iterator();
        while (iter.hasNext()) {
          ParsedTree tree = iter.next();
          tree.evaluate(this.context);
        }
        
        this.window.rebuildItemList();
        this.window.updateImage();
        this.window.setModified();
      }
      catch (Exception e) {
        e.printStackTrace();
        showMessage(e.toString());
      }
    }
  }

  /*
  public ObjectInfo evaluateNode(ObjectInfo parent, UndoRecord undo) throws Exception
  {
    if (evaluateLoop(parent, undo)) return parent;
    if (convertObject(parent)) return parent;
    if (evaluateObject(parent, undo)) return parent;

    return super.evaluateNode(parent, undo);
  }
  */

  Boolean convertObject(ObjectInfo parent) {
    if (parent.name.startsWith("Cube ") && parent.object instanceof Cube) {
      Vec3 size = ((Cube)parent.object).getBounds().getSize();
      
      String name = coordSysToString(parent.getCoords());
      name += "cube(" + 
              String.format("%.2f", size.x) + "," +
              String.format("%.2f", size.y) + "," +
              String.format("%.2f", size.z) + ")";
      parent.setName(name);
      return true;
    }
    else if (parent.name.startsWith("Cylinder ") && parent.object instanceof Cylinder) {
      Cylinder c = (Cylinder)parent.object;
      Vec3 size = c.getBounds().getSize();
      
      String name = coordSysToString(parent.getCoords());
      name += "cylinder("+
              String.format("%.2f", size.y)+","+
              String.format("%.2f", size.x/2)+","+
              String.format("%.2f", size.z/2)+","+
              String.format("%.2f", c.getRatio())+")";
      parent.setName(name);
      return true;
    }
    else if (parent.name.startsWith("Sphere ") && parent.object instanceof Sphere) {
      Vec3 size = ((Sphere)parent.object).getRadii();
      
      String name = coordSysToString(parent.getCoords());
      name += "sphere("+
              String.format("%.2f", size.x)+","+
              String.format("%.2f", size.y)+","+
              String.format("%.2f", size.z)+")";
      parent.setName(name);
      return true;
    }
    return false;
  }

  /**
   * 
   * Evaluates a boolean expression as a loop.
   * 
   * @param parent
   * @param undo
   * @return
   * @throws Exception
   */
  /*
  public Boolean evaluateLoop(ObjectInfo parent, UndoRecord undo) throws Exception {
    String line = parent.name;
    int operation = this.stringToOp(line);

    if (!isBooleanOp(operation)) return false;

    String[] parameters = null;
    CoordinateSystem coordsys=null;
    MetaCADParser loopExpr = new MetaCADParser(line);

    // The parsing will fail if we don't find parentheses.
    if (!loopExpr.parse()) return false;

    Enumeration<String> iter = loopExpr.getNames();
    while (iter.hasMoreElements()) {
      String name = iter.nextElement();
      parameters = loopExpr.getParameters(name);
      
      if (name.startsWith(this.opToString(operation)))
      {
        parameters=loopExpr.getParameters(name);
      }
    }
      
    if (parameters == null || parameters.length != 3) {
      // no loop but a simple boolean operation let base class do that
      loopExpr = new MetaCADParser("dummyDummy(dummyDummy=0; dummyDummy<1; dummyDummy=dummyDummy+1)");
      loopExpr.parse();
      parameters = loopExpr.getParameters("dummyDummy");
    }

    CSGHelper helper = new CSGHelper(operation);

    // evaluate first part of for loop i.e. i=0
    this.context.evaluateAssignment(parameters[0]);

    // security count to exit loop even if we fuck up exit condition
    int count = 0;

    // condition loop evaluate the condition i.e. i < 10
    while (evaluateExpression(parameters[1]) != 0 && count < 100) {
      ObjectInfo[] objects = parent.children;

      for (int i = 0; i < objects.length; i++) {
        helper.Add(evaluateNode(objects[i], undo).duplicate());
        objects[i].setVisible(false);
      }

      // "increment" evaluate 3rd for parameter i.e. i=i+1
      this.context.evaluateAssignment(parameters[2]);
      count++;
    }

    if (helper.GetObject() != null) {
      Texture tex = parent.object.getTexture();
      TextureMapping map = parent.object.getTextureMapping();

      if (coordsys != null) parent.setCoords(coordsys);
      else parent.setCoords(new CoordinateSystem());

      Object3D test = sanitizeObject3D(helper.GetObject());

      parent.setObject(test);
      parent.object.setTexture(tex, map);
      parent.setVisible(true);

      parent.clearCachedMeshes();
      this.window.updateImage();
      this.window.updateMenus();

    }

    return true;
  }
*/
  Object3D sanitizeObject3D(Object3D obj) throws Exception {
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

    // Don't try to evaluate operations belonging to CSGEvaluator.
    // FIXME: This is getting a little hackish
    int op = stringToOp(parent.name);
    if (op == -1 || isBooleanOp(op)) return false;

    MetaCADParser objExpr = new MetaCADParser(line);
    if (!objExpr.parse()) {
      showMessage("evaluateObject: Unable to parse \"" + line + "\"");
      return false;
    }

    Object3D obj3D = null;
    CoordinateSystem coordsys = null;
    CoordinateSystem objcoordsys = null;
    
    // FIXME: Verify that combining these coordsys'es is done correctly.
    if (coordsys == null) {
      if(objcoordsys != null) coordsys = objcoordsys;
    }
    else if (objcoordsys != null){
      coordsys.transformCoordinates(objcoordsys.fromLocal());
    }
    
    if (obj3D != null) {
      Texture tex = parent.object.getTexture();
      TextureMapping map = parent.object.getTextureMapping();

      if (coordsys != null) parent.setCoords(coordsys);
      else parent.setCoords(new CoordinateSystem());
      parent.setObject(obj3D);
      parent.object.setTexture(tex, map);
      parent.setVisible(true);

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
      this.context.jep.parseExpression(expr);
      return this.context.jep.getValue();
    } catch (Exception ex) {
      showMessage("Error while evaluating Expression: \"" + expr
          + "\" Syntax Error or unknown variable?");
      throw (ex);
      // return 0;
    }
  }

String coordSysToString(CoordinateSystem cs) {
    Vec3 t = cs.getOrigin();
    double r[] = cs.getRotationAngles();
    String str = "cs(" +
        String.format("%.2f", t.x) + "," +
        String.format("%.2f", t.y) + "," +
        String.format("%.2f", t.z);
    
    if (r[0] != 0.0 || r[1] != 0.0 || r[2] != 0.0) {
      str += "," + String.format("%.2f", r[0]) +
      "," + String.format("%.2f", r[1]) +
      "," + String.format("%.2f", r[2]);
    }
    str += ")";
    return str;
  }
  
  void showMessage(String text)  {
    if (text==null)
      text ="null";
    
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
        this.error = true;
      }
      else
      {
        this.error = false;
        this.x1=det(r1,b,r2,d)/q;
        this.x2=det(a,r1,c,r2)/q;
      }
    }
  }
  
  class MetaCADLine {
    protected Vec2 start,end, dir;
    protected Vec2 normal;
    
    public MetaCADLine(Vec3 s,Vec3 e)
    {
      this.start = new Vec2(s.x,s.y);
      this.end = new Vec2(e.x, e.y);
      this.dir = this.end.minus(this.start);
      this.normal = new Vec2(this.dir);
      this.normal.normalize();
      this.normal.set(-this.normal.y, this.normal.x);
    }
    
    public void parallelMove(double d)
    {
      this.start.add(this.normal.times(d));
    }
    
    public Vec3 intersect3(MetaCADLine l)
    {
      LinearSolve2 solve = new LinearSolve2(l.dir.x, -this.dir.x, l.dir.y, -this.dir.y, this.start.x-l.start.x, this.start.y-l.start.y);
      if (solve.error)
      {
        return null;
      }
      else
      {
        Vec2 point = this.start.plus(this.dir.times(solve.x2)); 
        return new Vec3(point.x,point.y, 0);
      }
    }
  }
  
  Vec3[] insetPoly(Vec3[] poly, double inset)
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
        if (intersect == null)
        {
          intersect = new Vec3(0,0,0);
        }
        points.add(intersect);
    }
     
    return points.toArray(new Vec3[1]);
  }

  public void cube() throws Exception
  {
    createObjectFromString("cube(1, 2, 3)");
  }

  public void sphere() throws Exception
  {
    createObjectFromString("sphere(1)");
  }

  public void cylinder() throws Exception
  {
    createObjectFromString("cylinder(2, 1)");
  }

  public ObjectInfo createObjectFromString(String defstr) throws Exception
  {
    Scene theScene = this.window.getScene();
    ObjectInfo objInfo = new ObjectInfo(new Sphere(1,1,1), new CoordinateSystem(), defstr);
    this.window.addObject(objInfo, null);
    this.window.setSelection(theScene.getNumObjects()-1);
    evaluate();
    return objInfo;
  }

  public void createParentObject(String defstr, int minchildren) {
    UndoRecord undo = new UndoRecord(this.window, false);
    ObjectInfo[] objects = getSelection();
    if (objects == null || objects.length < minchildren) {
      showMessage("Minimum " + minchildren + " object" + ((minchildren > 1) ? "s" : "") + " must be selected.");
      return;
    }

    // Selection undo
    int[] oldSelection = this.window.getSelectedIndices();
    undo.addCommand(UndoRecord.SET_SCENE_SELECTION,
                    new Object[] { oldSelection });

    ObjectInfo resultinfo;
    try {
      Scene theScene = this.window.getScene();
      resultinfo = new ObjectInfo(new Sphere(1,1,1), new CoordinateSystem(), defstr);
      
      // Inherit texture color from the first source object
      Object3D inheritfrom = objects[0].getObject();
      if (inheritfrom.canSetTexture()) {
        resultinfo.getObject().setTexture(inheritfrom.getTexture(), inheritfrom.getTextureMapping());
      }
      // add the object info to the window (which adds it to the scene and the item tree
      // and creates the proper undo record commands)
      // FIXME: The index is sometimes wrong since moving objects with the mouse confuses AoI's index system.
      // Don't know how to get around this, so keep it like this for now.
      this.window.getScene().addObject(resultinfo, this.window.getScene().indexOf(objects[0]), undo);

      // reparent children
      for (int i=0;i<objects.length;i++) {
        resultinfo.addChild(objects[i], i);
        undo.addCommandAtBeginning(UndoRecord.REMOVE_FROM_GROUP, new Object[] {resultinfo, objects[i]});
      }

      // Must rebuild before updating the selection to rebuild indices.
      this.window.rebuildItemList();
      this.window.setSelection(this.window.getScene().indexOf(resultinfo));

      this.window.setUndoRecord(undo);

      evaluate();

      // FIXME: Not sure if these are needed..
      this.window.updateImage();
      this.window.setModified();
    } catch (Exception e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
  }

  /**
   * Performs the union operation on the currently selected objects
   * @throws Exception 
   */
  public void union() throws Exception
  {
    createParentObject("union()", 2);
  }

  /**
   * Performs the intersect operation on the currently selected objects
   */
  public void intersection()
  {
    createParentObject("intersection()", 2);
  }

  /**
   * Performs the subtract operation on the currently selected objects
   */
  public void difference()
  {
    createParentObject("difference()", 2);
  }

  public void regular() throws Exception
  {
    createObjectFromString("reg(6, 4, 4)");
  }
  
  public void star() throws Exception
  {
    createObjectFromString("star(6, 3, 5)");
  }
  
  public void roll() throws Exception
  {
    createObjectFromString("roll(30, 5, 1, 0.8)");
  }
  
  public void extrude()
  {
    createParentObject("extrude()", 1);
  }
 
  public void mesh()
  {
    createParentObject("mesh()", 1);
  }

  public void group()
  {
    createParentObject("cs()", 1);
  }

  public void joincurves()
  {
    createParentObject("joincurves()", 2);
  }

  public void test()
  
  {
    showMessage("test function not implemented");
  }

  public void execute(int operation, int minimum_children) {
    // only evaluate selected objects if the parameters could be evaluated
    if (readParameters()) super.execute(operation, minimum_children);
  }

}