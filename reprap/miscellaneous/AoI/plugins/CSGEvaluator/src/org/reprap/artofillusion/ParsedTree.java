package org.reprap.artofillusion;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

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
    
    this.cadobj = ObjFactory.create(this.name);
    
    List<ObjectInfo> result = this.cadobj.evaluateObject(ctx, this.parameters, this.children);
    if (result == null) {
      result = new LinkedList<ObjectInfo>();
      result.add(this.aoiobj);
    }
    else if (result.size() == 0) {
      updateAOI(ObjectHelper.getErrorObject());
    }
    else if (result.size() == 1) {
      updateAOI(result.get(0));
    }
    else {
      updateAOI(ObjectHelper.join(result, 0.1));
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
