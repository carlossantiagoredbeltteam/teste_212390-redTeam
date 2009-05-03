package org.reprap.artofillusion;

import java.util.List;

import artofillusion.object.ObjectInfo;


public class BooleanObj extends ParsedTree {
  int type;

  public BooleanObj(int type) {
    this.type = type;
  }
  
  public ObjectInfo evaluateObject(MetaCADContext ctx) throws Exception {
    
    CSGHelper helper = new CSGHelper(this.type);
    List<ObjectInfo> children = evaluateChildren(ctx);
    helper.addAll(children.iterator());
    
    return helper.GetObjectInfo();
  }

}
