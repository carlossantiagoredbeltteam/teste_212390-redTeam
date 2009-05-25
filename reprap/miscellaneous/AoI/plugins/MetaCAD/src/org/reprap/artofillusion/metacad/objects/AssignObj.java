package org.reprap.artofillusion.metacad.objects;

import java.util.LinkedList;
import java.util.List;

import org.reprap.artofillusion.metacad.MetaCADContext;
import org.reprap.artofillusion.metacad.ParsedTree;

import artofillusion.math.CoordinateSystem;
import artofillusion.math.Vec3;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;

public class AssignObj extends MetaCADObject {

  public List<ObjectInfo> evaluateObject(MetaCADContext ctx, 
                                         List<String> parameters, 
                                         List<ParsedTree> children) throws Exception {
    ctx.pushScope();
    
    int assignments = parameters.size()/2;
    double[] values = new double[assignments];
    
    // evaluate expressions
    for (int i = 0; i < assignments; i++) {
      values[i] =  ctx.evaluateExpression(parameters.get(i*2+1));
    }
    
    // assign values to variables
    for (int i = 0;  i < assignments; i++) {
      ctx.assignValue(parameters.get(i*2), values[i]);
    }
    
    List<ObjectInfo> chlist = ParsedTree.evaluate(ctx, children);
    
    ctx.popScope();
    return chlist;
  }
}
