package org.reprap.artofillusion;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import org.reprap.artofillusion.objects.MetaCADObject;
import org.reprap.artofillusion.objects.ObjFactory;
import org.reprap.artofillusion.objects.ObjFactoryException;

import artofillusion.math.CoordinateSystem;
import artofillusion.object.ObjectInfo;
import artofillusion.texture.Texture;
import artofillusion.texture.TextureMapping;

public class ParsedTree {
  public String name;
  public MetaCADObject cadobj;
  public List<String> parameters;
  public List<ParsedTree> children;
  ObjectInfo aoiobj;
  
  public ParsedTree() {
    this.parameters =  new ArrayList<String>();
    this.children = new ArrayList<ParsedTree>();
  }

  public List<ObjectInfo> evaluate(MetaCADContext ctx) throws Exception {

    try {
      this.cadobj = ObjFactory.create(ctx, this.name);
    }
    catch (ObjFactoryException e) {
      if (this.aoiobj.isLocked()) { // This object has previously been evaluated successfully
        throw e; // Rethrow exception        
      }
      else {
        this.name = "native";
        this.cadobj = ObjFactory.create(ctx, this.name);
      }
    }

    // FIXME: If we're native, we can probably skip the evaluation
    
    List<ObjectInfo> result = this.cadobj.evaluateObject(ctx, this.parameters, this.children);
    if (result == null) {
      result = new LinkedList<ObjectInfo>();
      // duplicate native object to prevent accumulating cs
      result.add(this.aoiobj.duplicate());
    }
    else if (result.size() == 0) {
      updateAOI(ObjectHelper.getErrorObject());
    }
    else if (result.size() == 1) {
      updateAOI(result.get(0));
    }
    else {
      ObjectInfo collection = new ObjectInfo(new MetaCADObjectCollection(result), new CoordinateSystem(), "dummy");
      updateAOI(collection);
    }
    return result;
  }

  public static List<ObjectInfo> evaluate(MetaCADContext ctx, List<ParsedTree> children) throws Exception {
    if (children.size() == 0) return null;
    List<ObjectInfo> resultchildren = new LinkedList<ObjectInfo>();
    Iterator<ParsedTree> iter = children.iterator();
    while (iter.hasNext()) {
      ParsedTree treeobject = iter.next();
      resultchildren.addAll(treeobject.evaluate(ctx));
      if (treeobject.aoiobj != null) {
        treeobject.aoiobj.setVisible(false);
      }
    }
    
    return resultchildren;
  }

  void updateAOI(ObjectInfo newinfo) {
    if (this.aoiobj != null) {
      Texture tex = this.aoiobj.object.getTexture();
      TextureMapping map = this.aoiobj.object.getTextureMapping();

      this.aoiobj.setObject(newinfo.object);
      this.aoiobj.setCoords(newinfo.coords);
      if (tex != null && map != null) {
        this.aoiobj.object.setTexture(tex, map);
      }
      this.aoiobj.setVisible(true);
      this.aoiobj.setLocked(true); // Indicate that this object is a MetaCAD evaluated object
      this.aoiobj.clearCachedMeshes();
    }
  }

}
