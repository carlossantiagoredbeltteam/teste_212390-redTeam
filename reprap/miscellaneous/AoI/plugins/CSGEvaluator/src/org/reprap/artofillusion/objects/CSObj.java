package org.reprap.artofillusion.objects;

import java.util.Iterator;
import java.util.List;

import org.reprap.artofillusion.MetaCADContext;
import org.reprap.artofillusion.ParsedTree;

import artofillusion.math.CoordinateSystem;
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
    
    Iterator<ObjectInfo> iter = chlist.iterator();
    while (iter.hasNext()) {
      ObjectInfo info = iter.next();
      info.coords.transformCoordinates(coordsys.fromLocal());
    }
    return chlist;
  }

}
