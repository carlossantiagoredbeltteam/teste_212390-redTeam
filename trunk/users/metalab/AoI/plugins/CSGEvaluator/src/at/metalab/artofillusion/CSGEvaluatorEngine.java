package at.metalab.artofillusion;

import java.util.Collection;
import java.util.Iterator;

import artofillusion.LayoutWindow;
import artofillusion.UndoRecord;
import artofillusion.math.CoordinateSystem;
import artofillusion.object.CSGObject;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;
import artofillusion.texture.Texture;
import artofillusion.ui.MessageDialog;

class CSGEvaluatorEngine
{
  LayoutWindow window;

  public CSGEvaluatorEngine(LayoutWindow window)
  {
    this.window = window;
  }

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
   * Evaluates the currently selected subtree
   */
  public void evaluate()
  {
    try {
      UndoRecord undo = new UndoRecord(this.window, false);
      ObjectInfo[] objects = getSelection();
      if (objects != null) {
        for (int i=0;i<objects.length;i++) {
          this.evaluateNode(objects[i], undo);
        }

        this.window.setUndoRecord(undo);
        this.window.rebuildItemList();
        this.window.updateImage();
        this.window.setModified();
      }
    }
    catch (Exception ex) {
      //            this.debug("exception in evaluate: " + ex.toString());
    }
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
   * Performs the given operation on the currently selected objects
   */
  public void execute(int operation)
  {
    UndoRecord undo = new UndoRecord(this.window, false);
    ObjectInfo[] objects = getSelection();
    if (objects == null || objects.length < 2) {
      new MessageDialog(this.window, "Minimum two objects must be selected.");
      return;
    }

    // Selection undo
    int[] oldSelection = this.window.getSelectedIndices();
    undo.addCommand(UndoRecord.SET_SCENE_SELECTION, new Object[] {oldSelection});

    ObjectInfo newobjinfo = this.createNewObject(objects, operation, undo);
    // Must rebuild before updating the selection to rebuild indices.
    this.window.rebuildItemList();
    this.window.setSelection(this.window.getScene().indexOf(newobjinfo));

    this.window.setUndoRecord(undo);

    // FIXME: Not sure if these are needed..
    this.window.updateImage();
    this.window.setModified();
  }

  /**
   * Performs the union operation on the currently selected objects
   */
  public void union()
  {
    execute(CSGObject.UNION);
  }

  /**
   * Performs the intersect operation on the currently selected objects
   */
  public void intersect()
  {
    execute(CSGObject.INTERSECTION);
  }

  /**
   * Performs the subtract operation on the currently selected objects
   */
  public void subtract()
  {
    execute(CSGObject.DIFFERENCE12);
  }

  /**
   * Converts from operation to String (CSGObject.op)
   */
  public String opToString(int operation) {
    switch (operation) {
    case CSGObject.UNION:
      return "union";
    case CSGObject.INTERSECTION:
      return "intersection";
    case CSGObject.DIFFERENCE12:
      return "difference";
    default:
      return null;
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
    else if (lower.startsWith("intersection") || lower.startsWith("/")) {
      return CSGObject.INTERSECTION;
    }
    else if (lower.startsWith("difference") || lower.startsWith("-")) {
      return CSGObject.DIFFERENCE12;
    }
    else return -1;
  }




  /*
      Recursively (Re-)evaluates the object tree rooted at the given root object
      based on the operation encoded into the object name.

      The result should be one CSG object where the entire child tree is disabled.
      If the operation is none or unknown, the parent will be returned unchanged.
   */
  public ObjectInfo evaluateNode(ObjectInfo parent, UndoRecord undo)
  {
    int op = stringToOp(parent.name);
    if (op == -1) return parent;
    else {
      // compute combined object
      ObjectInfo csgobjinfo = combine(parent.getChildren(), op, undo);
      Object3D csgobj = csgobjinfo.object;

      // This is necessary since we're not adding the object to the scene, just replacing an existing
      // object.
      if (csgobj.getTexture() == null) {
        Texture tex = this.window.getScene().getDefaultTexture();
        csgobj.setTexture(tex, tex.getDefaultMapping(csgobj));
      }
      
      undo.addCommandAtBeginning(UndoRecord.COPY_OBJECT, new Object[] { parent.object, parent.object.duplicate() });
      parent.setObject(csgobj);
      parent.clearCachedMeshes();
      this.window.updateImage();
      this.window.updateMenus();

      parent.setVisible(true);
      
      return parent;
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
      for (int i=0;i<children.length;i++) {
        devaluateNode(children[i], undo);
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

  /**
      Performs the given operation on the list of objects (of size >= 2),
      and returns the resulting ObjectInfo containing a CSGObject.

      Calls evaluateNode() on each child before performing the operation.
      Hides the children.
   */
  public ObjectInfo combine(ObjectInfo[] objects, int operation, UndoRecord undo)
  {
    if (objects.length < 1) return null;    
    if (objects.length < 2) return objects[0];

    ObjectInfo a = evaluateNode(objects[0], undo);
    ObjectInfo b = evaluateNode(objects[1], undo);

    Object3D csgobj = new CSGObject(a, b, operation);
    ObjectInfo csgobjinfo = new ObjectInfo(csgobj, new CoordinateSystem(), "tmp");

    for (int i=2;i<objects.length;i++) {
      csgobj = new CSGObject(csgobjinfo, evaluateNode(objects[i], undo), operation);
      csgobjinfo = new ObjectInfo(csgobj, new CoordinateSystem(), "tmp");
    }

    for (int i=0;i<objects.length;i++) {
      undo.addCommandAtBeginning(UndoRecord.COPY_OBJECT_INFO, new Object[] {objects[i], objects[i].duplicate()});

      objects[i].setVisible(false);

      //FIXME: is this needed? comments in AOI source say no...
      this.window.getScene().objectModified(objects[i].getObject());
    }

    return csgobjinfo;
  }

  /**
      Creates a new object consisting of the result of performing the given
      operation on the given list of objects (of length >= 2).

      Inserts the new object into the scene and makes the original objects
      children of the new object. Also hides the children.
   */
  public ObjectInfo createNewObject(ObjectInfo[] objects, int operation, UndoRecord undo)
  {
    // create ObjectInfo for combined object
    ObjectInfo resultinfo = combine(objects, operation, undo);
    resultinfo.setName(opToString(operation));

    // add the object info to the window (which adds it to the scene and the item tree
    // and creates the proper undo record commands)
    this.window.getScene().addObject(resultinfo, undo);

    // reparent children
    for (int i=0;i<objects.length;i++) {
      resultinfo.addChild(objects[i], i);
      undo.addCommandAtBeginning(UndoRecord.REMOVE_FROM_GROUP, new Object[] {resultinfo, objects[i]});
    }

    return resultinfo;
  }
}
