package org.reprap.artofillusion;

import java.util.LinkedList;
import java.util.List;

import artofillusion.object.ObjectInfo;


public class NativeObj extends ParsedTree {

  public NativeObj(ObjectInfo aoiobj) {
    this.aoiobj = aoiobj;
  }
  
  public List<ObjectInfo> evaluateObject(MetaCADContext ctx) throws Exception {
    List<ObjectInfo> result = new LinkedList<ObjectInfo>();
    result.add(this.aoiobj); 
    return result;
  }

}
