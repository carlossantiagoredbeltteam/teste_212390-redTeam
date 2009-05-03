package org.reprap.artofillusion;

import java.util.LinkedList;
import java.util.List;

import artofillusion.math.CoordinateSystem;
import artofillusion.math.Vec3;
import artofillusion.object.ObjectInfo;

public class ForObj extends ParsedTree {
  
  public List<ObjectInfo> evaluate(MetaCADContext ctx) throws Exception {
    List<ObjectInfo> result = new LinkedList<ObjectInfo>();
    
    // evaluate first part of for loop i.e. i=0
    ctx.evaluateAssignment(this.parameters.get(0));

    // security count to exit loop even if we fuck up exit condition
    int count = 0;
    // condition loop evaluate the condition i.e. i < 10
    while (ctx.evaluateExpression(this.parameters.get(1)) != 0 && count < 100) {
      result.addAll(evaluateChildren(ctx));
      // "increment" evaluate 3rd for parameter i.e. i=i+1
      ctx.evaluateAssignment(this.parameters.get(2));
      count++;
    }
    updateAOI(result.get(0));
    return result;
  }
  
  public ObjectInfo evaluateObject(MetaCADContext ctx) throws Exception {
    return null;
  }

}