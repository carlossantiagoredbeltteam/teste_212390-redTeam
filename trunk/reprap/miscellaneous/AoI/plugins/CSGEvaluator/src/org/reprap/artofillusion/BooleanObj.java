package org.reprap.artofillusion;

import java.util.LinkedList;
import java.util.List;

import artofillusion.object.ObjectInfo;


public class BooleanObj extends ParsedTree {
  int type;

  public BooleanObj(int type) {
    this.type = type;
  }
  
  public List<ObjectInfo> evaluateObject(MetaCADContext ctx) throws Exception {
    
    List<ObjectInfo> result = new LinkedList<ObjectInfo>();
    
    CSGHelper helper = new CSGHelper(this.type);
    List<ObjectInfo> children = evaluateChildren(ctx);
    helper.addAll(children.iterator());
    
    if (helper.GetObjectInfo() !=  null)
      result.add(helper.GetObjectInfo());
    return result;
    
  }

}
