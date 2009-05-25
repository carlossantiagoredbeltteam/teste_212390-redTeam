package org.reprap.artofillusion.metacad;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import org.reprap.artofillusion.metacad.objects.MetaCADObject;
import org.reprap.artofillusion.metacad.objects.ObjFactory;

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

    this.cadobj = ObjFactory.create(ctx, this.name);

    // FIXME: If we're native, we can probably skip the evaluation
    
    List<ObjectInfo> result = this.cadobj.evaluateObject(ctx, this.parameters, this.children);

    // Make sure all evaluated objects have a texture. This is necessary for objects which don't have
    // an associated aoiobj and where we need access to the texture (e.g. CSGObject inside macros which
    // use the CSGObject.centerObject()).
    for (ObjectInfo chinfo : result) {
      Texture tex = chinfo.object.getTexture();
      if (tex == null) tex = ctx.scene.getDefaultTexture();
      TextureMapping map = chinfo.object.getTextureMapping();
      if (map == null) map = ctx.scene.getDefaultTexture().getDefaultMapping(chinfo.object);
      chinfo.object.setTexture(tex, map);
    }
    
    //must have been a  native object
    if (result == null) {
      result = new LinkedList<ObjectInfo>();
      // duplicate native object to prevent accumulating cs
      ObjectInfo objInfo = this.aoiobj.duplicate();
      objInfo.setVisible(true);
      result.add(objInfo);
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
      this.aoiobj.clearCachedMeshes();
    }
  }

}
