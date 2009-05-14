package org.reprap.artofillusion.metacad.objects;

import java.util.Iterator;
import java.util.List;

import org.reprap.artofillusion.metacad.MetaCADContext;
import org.reprap.artofillusion.metacad.ParsedTree;

import artofillusion.math.CoordinateSystem;
import artofillusion.math.Mat4;
import artofillusion.math.Vec3;
import artofillusion.object.ObjectInfo;

public class CSObj extends MetaCADObject {

  public List<ObjectInfo> evaluateObject(MetaCADContext ctx, 
                                         List<String> parameters, 
                                         List<ParsedTree> children) throws Exception {

    assert(children.size() == 1);
    List<ObjectInfo> chlist = ParsedTree.evaluate(ctx, children);
    
    CoordinateSystem coordsys = new CoordinateSystem();
    if (parameters.size() >= 3) {
      coordsys.setOrigin(new Vec3(ctx.evaluateExpression(parameters.get(0)),
                                  ctx.evaluateExpression(parameters.get(1)),
                                  ctx.evaluateExpression(parameters.get(2))));
    }
    if (parameters.size() >= 6) {
      coordsys.setOrientation(ctx.evaluateExpression(parameters.get(3)),
                              ctx.evaluateExpression(parameters.get(4)),
                              ctx.evaluateExpression(parameters.get(5)));
    }
    if  (parameters.size() >= 9) {
      double scaleX = ctx.evaluateExpression(parameters.get(6));
      double scaleY = ctx.evaluateExpression(parameters.get(7));
      double scaleZ = ctx.evaluateExpression(parameters.get(8));
      
      coordsys.transformCoordinates(new Mat4(scaleX,0,0,0,  0,scaleY,0,0, 0,0,scaleZ,0, 0,0,0,1));
    }
    
    Iterator<ObjectInfo> iter = chlist.iterator();
    while (iter.hasNext()) {
      ObjectInfo info = iter.next();
      info.coords.transformCoordinates(coordsys.fromLocal());
    }
    return chlist;
  }

}
