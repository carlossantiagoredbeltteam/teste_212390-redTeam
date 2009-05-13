package org.reprap.artofillusion;

import java.awt.FileDialog;
import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import org.cheffo.jeplite.JEP;
import org.reprap.artofillusion.language.ParsedStatement;
import org.reprap.artofillusion.parser.ParseException;

import artofillusion.ArtOfIllusion;
import artofillusion.LayoutWindow;
import artofillusion.ModellingApp;
import artofillusion.Scene;
import artofillusion.UndoRecord;
import artofillusion.animation.Keyframe;
import artofillusion.math.CoordinateSystem;
import artofillusion.math.Vec2;
import artofillusion.math.Vec3;
import artofillusion.object.Cube;
import artofillusion.object.Cylinder;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectCollection;
import artofillusion.object.ObjectInfo;
import artofillusion.object.Sphere;
import artofillusion.texture.Texture;
import artofillusion.texture.TextureMapping;
import artofillusion.ui.MessageDialog;
import artofillusion.ui.Translate;
import buoy.widget.BFileChooser;
import buoy.widget.BStandardDialog;

public class MetaCADEvaluatorEngine extends CSGEvaluatorEngine
{
  MetaCADContext context;

  public MetaCADEvaluatorEngine(LayoutWindow window) {
    super(window);
    this.context = new MetaCADContext(window.getScene());
  }
 
  public void setParameters(String text) {
    this.window.getScene().setMetadata(
        MetaCADEvaluatorEngine.class.getName() + "Parameters", text);
    Iterator<TextChangedListener> iter = this.parameterListeners.iterator();
   
    while (iter.hasNext())
    {
      iter.next().textChanged(this);
    }
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
    if (text == null) text = "null";
    
    new MessageDialog(this.window, text);
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
 
  public void lathe()
  {
    createParentObject("lathe()", 1);
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
    createParentObject("joincurves()", 1);
  }

  public void extractmacro() throws Exception
  {
    UndoRecord undo = new UndoRecord(this.window, false);
    ObjectInfo[] objects = getSelection();
    if (objects == null || objects.length < 1) {
      showMessage("Minimum " + 1 + " object" + ((1 > 1) ? "s" : "") + " must be selected.");
      return;
    }

    // Selection undo
    int[] oldSelection = this.window.getSelectedIndices();
    undo.addCommand(UndoRecord.SET_SCENE_SELECTION,
                    new Object[] { oldSelection });

    
    BStandardDialog dlg = new BStandardDialog("", Translate.text("enterMacroName"), BStandardDialog.PLAIN);
    String macroname = dlg.showInputDialog(this.window, null, "mymacro(param1, param2)");
    if (macroname == null) return;
    
    createMacro(macroname, Arrays.asList(objects));
    
    Scene theScene = this.window.getScene();
    // delete selected objects
    for (int i=0;i<objects.length;i++) {
      int index = this.window.getScene().indexOf(objects[i]);
      theScene.removeObject(index, undo);
      undo.addCommandAtBeginning(UndoRecord.ADD_OBJECT, new Object[] {objects[i], index});
    }

    
    // Must rebuild before updating the selection to rebuild indices.
    this.window.rebuildItemList();

    ObjectInfo result = createObjectFromString(macroname);
    
    this.window.setSelection(this.window.getScene().indexOf(result));

    this.window.setUndoRecord(undo);

    evaluate();
    this.window.updateImage();
    this.window.setModified();
  }


  public void file() throws Exception
  {
    String dir = "";
    if (ArtOfIllusion.getCurrentDirectory() != null) dir= ArtOfIllusion.getCurrentDirectory();
    BFileChooser fc = new BFileChooser(BFileChooser.OPEN_FILE, Translate.text("importFile"), new File(dir));
    if (!fc.showDialog(null)) return;

    File f = fc.getSelectedFile();
    String filename = f.getPath();
    
    createObjectFromString("file(\""+filename+"\")");
  }

  public void test()  
  {
    showMessage("test function not implemented");
  }

  public void execute(int operation, int minimum_children) {
    // only evaluate selected objects if the parameters could be evaluated
    if (readParameters()) super.execute(operation, minimum_children);
  }
  
  private void createMacro(String macroname, List<ObjectInfo> asList) {
    StringBuilder sb = new StringBuilder();
    
    sb.append(getParameters());
    sb.append("\n");
    
    sb.append(macroname);
    sb.append(" {\n");
    Iterator<ObjectInfo> iter = asList.iterator();
    while (iter.hasNext())
    {
      ObjectInfo objInfo = iter.next();
      objectInfoToString(objInfo, sb, 1);
    }
    sb.append("}");
    
    this.setParameters(sb.toString());
  }
  
  private void objectInfoToString(ObjectInfo objInfo, StringBuilder sb, int indent)
  {
    int i;
    
    for (i = 0; i < indent; i++)
      sb.append(' ');
    
    sb.append(objInfo.name);
    
    if (objInfo.children.length > 0)
    {
      sb.append(" {\n");
      for (i = 0; i < objInfo.children.length; i++)
        objectInfoToString(objInfo.children[i], sb, indent+1);
      
      for (i = 0; i < indent; i++)
        sb.append(' ');
      sb.append("}\n");
    }
    else
    {
      sb.append(";\n");
    }
  }
  
  protected List<TextChangedListener> parameterListeners=new LinkedList<TextChangedListener>();
  public void addParameterChangedListener(TextChangedListener listener)
  {
    this.parameterListeners.add(listener);
  }
}
