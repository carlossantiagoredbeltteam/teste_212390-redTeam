package org.reprap.artofillusion.metacad;

import java.io.File;
import java.util.Arrays;
import java.util.Collection;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import org.reprap.artofillusion.metacad.language.MacroPrototype;
import org.reprap.artofillusion.metacad.parser.MetaCADParser;
import org.reprap.artofillusion.metacad.parser.ParseException;

import artofillusion.ArtOfIllusion;
import artofillusion.LayoutWindow;
import artofillusion.Scene;
import artofillusion.UndoRecord;
import artofillusion.math.CoordinateSystem;
import artofillusion.math.Vec3;
import artofillusion.object.CSGObject;
import artofillusion.object.Cube;
import artofillusion.object.Cylinder;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;
import artofillusion.object.Sphere;
import artofillusion.ui.MessageDialog;
import artofillusion.ui.Translate;
import buoy.widget.BFileChooser;
import buoy.widget.BStandardDialog;

public class MetaCADEngine
{
  protected LayoutWindow window;
  MetaCADContext context;
  static final String evaluateMePrefix = "=";
  static final String parametersKey =  "org.reprap.artofillusion.MetaCADEvaluatorEngineParameters";

  public MetaCADEngine(LayoutWindow window) {
    this.window = window;
    this.context = new MetaCADContext(window.getScene());
  }
  
  public void setParameters(String text) {
    this.window.getScene().setMetadata(parametersKey, text);
    
    Iterator<TextChangedListener> iter = this.parameterListeners.iterator();
   
    while (iter.hasNext())
    {
      iter.next().textChanged(this);
    }
  }

  public String getParameters() {
    Object o = this.window.getScene().getMetadata(parametersKey);

    
    if (o != null)
      return o.toString();

    return "";
  }

  public boolean readParameters() {
    try {
      this.context.evaluateParameters(getParameters());
      return true;
    } catch (Exception e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
      showMessage(e.getMessage());
      return false;
    }
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
    
    String name =  removeEvaluationPrefix(parent.name);
    if (name != null)
    {
      root = MetaCADParser.parseTree(name + ";");
      root.aoiobj = parent;
    }
    // not preceded by a = so it must be a native object
    else
    {
      root = new ParsedTree();
      root.name = "native";
      root.aoiobj = parent;
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
   * 
   * Recursively extracts an AoI object tree and creates our own ParsedTree representation.
   * 
   */
  // is locked  version
  /*
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
  */

  /**
  Returns a normalized selection, meaning children of a selected parent
  are removed.
   */
  public ObjectInfo[] getSelection()
  {
    Collection<ObjectInfo> sel = this.window.getSelectedObjects();
    ObjectInfo[] objects = new ObjectInfo[sel.size()];
    Iterator<ObjectInfo> it = sel.iterator();
    int i = 0;
    while (it.hasNext()) {
      ObjectInfo objinfo = it.next();
      ObjectInfo p = objinfo.getParent();
      while (p != null) { // Check if any parent is selected
        if (this.window.isObjectSelected(p)) break;
        p = p.getParent();
      }
      if (p == null) objects[i++] = objinfo;
    }
    ObjectInfo[] cleanedobjects = new ObjectInfo[i];
    System.arraycopy(objects, 0, cleanedobjects, 0, i);
    return cleanedobjects;
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

  /**
   * Converts from string to operation (CSGObject.op).
   */
  public int stringToOp(String opstr) {
    String lower = opstr.toLowerCase();
    if (lower.startsWith("union") || lower.startsWith("+")) {
      return CSGObject.UNION;
    }
    else if (lower.startsWith("intersection") || lower.startsWith("/") || lower.startsWith("&")) {
      return CSGObject.INTERSECTION;
    }
    else if (lower.startsWith("difference") || lower.startsWith("-")) {
      return CSGObject.DIFFERENCE12;
    }
    else return -1;
  }

  /**
   * Devaluates the currently selected subtree
   */
  public void devaluate()
  {
    UndoRecord undo = new UndoRecord(this.window, false);
    ObjectInfo[] objects = getSelection();
    if (objects != null) {
      for (int i=0;i<objects.length;i++) {
        this.devaluateNode(objects[i], undo);
      }

      this.window.setUndoRecord(undo);
      this.window.rebuildItemList();
      this.window.updateImage();
      this.window.setModified();
    }
  }

  
  /**
  Recursively (Re-)deevaluates the object tree rooted at the given root object
  based on the object name.

  This disables all implicit (parent) objects and enabled the leaf nodes.
   */
  public void devaluateNode(ObjectInfo parent, UndoRecord undo)
  {
    int op = stringToOp(parent.name);
    if (op != -1) {
      if (undo != null)
        undo.addCommand(UndoRecord.COPY_OBJECT_INFO, new Object [] {parent, parent.duplicate()});
      parent.setVisible(false);

      //TODO: should not be necessary since we don't modify the object (only the object info)
      this.window.getScene().objectModified(parent.getObject());

      ObjectInfo[] children = parent.getChildren();
      if (children.length > 0) {
        for (int i=0;i<children.length;i++) {
          devaluateNode(children[i], undo);
        }
      }
      else {
        parent.setVisible(true);
      }
    }
    else {
      if (undo != null)
        undo.addCommand(UndoRecord.COPY_OBJECT_INFO, new Object [] {parent, parent.duplicate()});
      parent.setVisible(true);

      //TODO: should not be necessary since we don't modify the object (only the object info)
      this.window.getScene().objectModified(parent.getObject());
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
      parent.setName(evaluateMePrefix + name);
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
      parent.setName(evaluateMePrefix + name);
      return true;
    }
    else if (parent.name.startsWith("Sphere ") && parent.object instanceof Sphere) {
      Vec3 size = ((Sphere)parent.object).getRadii();
      
      String name = coordSysToString(parent.getCoords());
      name += "sphere("+
              String.format("%.2f", size.x)+","+
              String.format("%.2f", size.y)+","+
              String.format("%.2f", size.z)+")";
      parent.setName(evaluateMePrefix + name);
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
    String str = "trans(" +
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
    ObjectInfo objInfo = new ObjectInfo(new Sphere(1,1,1), new CoordinateSystem(), addEvaluationPrefix(defstr));
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
      resultinfo = new ObjectInfo(new Sphere(1,1,1), new CoordinateSystem(), addEvaluationPrefix(defstr));
      
      // Inherit texture color from the first source object
      Object3D inheritfrom = objects[0].getObject();
      if (inheritfrom.canSetTexture()) {
        resultinfo.getObject().setTexture(inheritfrom.getTexture(), inheritfrom.getTextureMapping());
      }
      
      // add the object info to the window (which adds it to the scene and the item tree
      // and creates the proper undo record commands)
      // FIXME: The index is sometimes wrong since moving objects with the mouse confuses AoI's index system.
      // Don't know how to get around this, so keep it like this for now.
      // this.window.getScene().addObject(resultinfo, this.window.getScene().indexOf(objects[0]), undo); // oldversion with hierachical bug 
      this.window.getScene().addObject(resultinfo, undo);
      
      // this is the node we are going to use as the parent for our new node
      ObjectInfo firstParent = null;
      int insertPosition = -1;
      if (objects.length > 0)
      {
        firstParent = objects[0].getParent();
        if (firstParent != null)
        {
          ObjectInfo children[] = firstParent.getChildren();
          for (int i = 0; i < children.length; i++)
          {
            if (children[i] == objects[0])
            {
              insertPosition = i;
              break;
            }
          }
        }
      }   
      
      // reparent children
      for (int i=0;i<objects.length;i++) {
        ObjectInfo oldParent = objects[i].getParent();

        if (oldParent != null)
        {
          oldParent.removeChild(objects[i]);
          undo.addCommandAtBeginning(UndoRecord.ADD_TO_GROUP, new Object[] {oldParent, objects[i]});
        }
        resultinfo.addChild(objects[i], i);
        undo.addCommandAtBeginning(UndoRecord.REMOVE_FROM_GROUP, new Object[] {resultinfo, objects[i]});
      }
      
      if (firstParent != null)
      {
        if (insertPosition < 0 || insertPosition > firstParent.children.length)
          insertPosition = firstParent.children.length;
        firstParent.addChild(resultinfo, insertPosition);
        // resultinfo.setParent(firstParent); // taken care of in addChild
        undo.addCommandAtBeginning(UndoRecord.REMOVE_FROM_GROUP, new Object[] {firstParent, resultinfo});
      }
      
      // Must rebuild before updating the selection to rebuild indices.
      this.window.rebuildItemList();
      int selectionIndex = this.window.getScene().indexOf(resultinfo);
      if (selectionIndex >= 0)
        this.window.setSelection(selectionIndex);

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
    createParentObject("union()", 1);
  }

  /**
   * Performs the intersect operation on the currently selected objects
   */
  public void intersection()
  {
    createParentObject("intersection()", 1);
  }

  /**
   * Performs the subtract operation on the currently selected objects
   */
  public void difference()
  {
    createParentObject("difference()", 1);
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
    createParentObject("group()", 1);
  }

  public void move()
  {
    createParentObject("move()", 1);
  }

  public void rotate()
  {
    createParentObject("rotate()", 1);
  }

  public void scale()
  {
    createParentObject("scale()", 1);
  }

  public void trans()
  {
    createParentObject("trans()", 1);
  }

  public void inset()
  {
    createParentObject("inset(1)", 1);
  }

  public void joincurves()
  {
    createParentObject("joincurves()", 1);
  }

  public void loop()
  {
    createParentObject("for(i=0,i<1,i=i+1)", 1);
  }
  
  public void inlinemacro()
  {
    try {
      if (!this.readParameters())
      {
        showMessage("Get rid of any errors in the parameters before inlining a macro!");
        return;
      }
      
      ObjectInfo[] objects = getSelection();
      if (objects.length != 1)
      {
        showMessage("Exactly one macro must be selected that is to be inlined.");
        return;
      }
      
      ParsedTree tree = extractTree(objects[0]);
      MacroPrototype macro = this.context.macros.get(tree.name.toLowerCase());
      
      if (macro == null)
      {
        showMessage("Macro with the name: " + tree.name + " was not found");
        return;
      }
      
      if (tree.parameters.size() < macro.variables.size())
      {
        showMessage("The macro call does not have enough paramaters: " + tree.parameters.size() + " given but expected " + macro.variables.size());
        return;
      }
      
      
      String assignStatement = this.evaluateMePrefix + "assign(";
      for (int i = 0; i < macro.variables.size(); i++)
      {
        if (i != 0)
          assignStatement += ", ";
        assignStatement +=macro.variables.get(i);
        assignStatement += ",";
        assignStatement += tree.parameters.get(i);
      }
      assignStatement += ")";
      if (macro !=  null)
      {
        for (ParsedTree c : macro.children)
        {
          ObjectInfo cInfo = fromParsedTree(c, objects[0].object);
          
          objects[0].addChild(cInfo, objects[0].children.length);
        }
        objects[0].setName(assignStatement);
      }
      this.window.rebuildItemList();
    }
    catch (Exception ex)
    {
      ex.printStackTrace();
      showMessage(ex.toString());
    }
  }
  
  public ObjectInfo fromParsedTree(ParsedTree tree, Object3D inheritfrom)
  {    
    String s= evaluateMePrefix + tree.name + "(";
    boolean first = true;
    for (String p : tree.parameters)
    {
      if (!first)
        s += ",";
      s += p;
      first = false;
    }
    s+=")";
    
    ObjectInfo info = new ObjectInfo(new Cube(0.1,0.1,0.1), new CoordinateSystem(), s);
   
    
    if (inheritfrom.canSetTexture()) {
      //this.window.getScene().getDefaultTexture();
      info.getObject().setTexture(inheritfrom.getTexture(), inheritfrom.getTextureMapping());
    }
   
    this.window.getScene().addObject(info, null);
    
    for (ParsedTree c : tree.children)
    {
      info.addChild(fromParsedTree(c, inheritfrom), info.children.length);
    }
    
    
    return info;
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
    
    ParsedTree tree = extractTree(objects[0]);
    
    String macroname = null;
    String macrocall = null;
    
    // see if this is an assign node 
    if (objects.length==1 && tree.name.toLowerCase().startsWith("assign"))
    {  
       
      int assignments = tree.parameters.size()/2;
      macroname="mymacro(";
      macrocall="(";
      
      for (int i = 0; i < assignments; i++) {
        if (i!=0)
        {
          macroname+=',';
          macrocall += ',';
        }
        macroname+=tree.parameters.get(i*2);
        macrocall+=tree.parameters.get(i*2+1);
      }
      macroname+=')';
      macrocall += ')';
      
      BStandardDialog dlg = new BStandardDialog("", Translate.text("enterMacroName"), BStandardDialog.PLAIN);
      macroname = dlg.showInputDialog(this.window, null, macroname);
      if (macroname == null) return;
      
      // create a macrocall suggestion
      int bracketIndex = macroname.indexOf("(");
      if (bracketIndex < 0)
        bracketIndex = macroname.length();
      macrocall = macroname.substring(0,bracketIndex) + macrocall;
      
      dlg = new BStandardDialog("", Translate.text("enterMacroCall"), BStandardDialog.PLAIN);
      macrocall = dlg.showInputDialog(this.window, null, macrocall);
      if (macrocall == null) return;
      
      createMacro(macroname, Arrays.asList(objects[0].getChildren()));
    }
    else
    {
      BStandardDialog dlg = new BStandardDialog("", Translate.text("enterMacroName"), BStandardDialog.PLAIN);
      macroname = dlg.showInputDialog(this.window, null, "mymacro(param1, param2)");
      if (macroname == null) return;
      
      dlg = new BStandardDialog("", Translate.text("enterMacroCall"), BStandardDialog.PLAIN);
      macrocall = dlg.showInputDialog(this.window, null, macroname);
      if (macrocall == null) return;
      
      createMacro(macroname, Arrays.asList(objects));
    }
    
    Scene theScene = this.window.getScene();
    // delete selected objects
    for (int i=0;i<objects.length;i++) {
      int index = this.window.getScene().indexOf(objects[i]);
      theScene.removeObject(index, undo);
      undo.addCommandAtBeginning(UndoRecord.ADD_OBJECT, new Object[] {objects[i], index});
    }

    
    // Must rebuild before updating the selection to rebuild indices.
    this.window.rebuildItemList();

    ObjectInfo result = createObjectFromString(macrocall);
    
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
    
    String name = removeEvaluationPrefix(objInfo.name);
    
    if (name != null)
      sb.append(name);
    else
      sb.append("/* unconvertable native object object */");
    
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
  
  protected String removeEvaluationPrefix(String objInfoName)
  {
    objInfoName = objInfoName.trim();
    int index = objInfoName.indexOf(evaluateMePrefix);
    
    if (index >= 0)
    {
      return objInfoName.substring(index +evaluateMePrefix.length());
    }
    return null;
  }
  
  protected String addEvaluationPrefix(String objInfoName)
  {
    return evaluateMePrefix + objInfoName;
  }
}
