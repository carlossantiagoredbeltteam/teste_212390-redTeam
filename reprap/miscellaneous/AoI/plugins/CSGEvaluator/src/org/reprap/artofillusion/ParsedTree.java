package org.reprap.artofillusion;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import artofillusion.object.ObjectInfo;
import artofillusion.texture.Texture;
import artofillusion.texture.TextureMapping;

public abstract class ParsedTree {
  public String name;
  public List<String> parameters;
  public List<ParsedTree> children;
  ObjectInfo aoiobj;
  
  public ParsedTree() {
    this.parameters =  new ArrayList<String>();
    this.children = new ArrayList<ParsedTree>();
  }

  public List<ObjectInfo> evaluate(MetaCADContext ctx) throws Exception {
    List<ObjectInfo> result = new LinkedList<ObjectInfo>();
    result.addAll(evaluateObject(ctx));
    updateAOI(ObjectHelper.join(result, 0.1));
    return result;
  }

  public abstract List<ObjectInfo> evaluateObject(MetaCADContext ctx) throws Exception;

  public List<ObjectInfo> evaluateChildren(MetaCADContext ctx) throws Exception {
    List<ObjectInfo> resultchildren = new LinkedList<ObjectInfo>();
    Iterator<ParsedTree> iter = this.children.iterator();
    while (iter.hasNext()) {
      ParsedTree treeobject = iter.next();
      resultchildren.addAll(treeobject.evaluate(ctx));
      if (treeobject.aoiobj != null) {
        treeobject.aoiobj.setVisible(false);
      }
    }
    
    return resultchildren;
  }

  public void updateAOI(ObjectInfo newinfo) {
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
