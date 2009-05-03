package org.reprap.artofillusion;

import java.util.Iterator;
import java.util.List;

import artofillusion.math.CoordinateSystem;
import artofillusion.math.Vec3;
import artofillusion.object.ObjectInfo;

public class CSObj extends ParsedTree {

  public List<ObjectInfo> evaluateObject(MetaCADContext ctx) throws Exception {

    assert(this.children.size() == 1);
    List<ObjectInfo> chlist = evaluateChildren(ctx);
    
    CoordinateSystem coordsys = new CoordinateSystem();
    if (this.parameters.size() >= 3) {
      coordsys.setOrigin(new Vec3(ctx.evaluateExpression(this.parameters.get(0)),
                                  ctx.evaluateExpression(this.parameters.get(1)),
                                  ctx.evaluateExpression(this.parameters.get(2))));
    }
    if (this.parameters.size() >= 6) {
      coordsys.setOrientation(ctx.evaluateExpression(this.parameters.get(3)),
                              ctx.evaluateExpression(this.parameters.get(4)),
                              ctx.evaluateExpression(this.parameters.get(5)));
    }
    
    Iterator<ObjectInfo> iter = chlist.iterator();
    while (iter.hasNext()) {
      ObjectInfo info = iter.next();
      info.coords.transformCoordinates(coordsys.fromLocal());
    }
    return chlist;
  }

}
