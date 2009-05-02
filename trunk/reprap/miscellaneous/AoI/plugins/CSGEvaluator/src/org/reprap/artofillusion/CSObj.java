package org.reprap.artofillusion;

import artofillusion.math.CoordinateSystem;
import artofillusion.math.Vec3;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;

public class CSObj extends ParsedTree {

  public ObjectInfo evaluate(MetaCADContext ctx) throws Exception {

    assert(this.children.size() == 1);
    ObjectInfo chinfo = this.children.get(0).evaluate(ctx);
    
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
    
    coordsys.transformCoordinates(chinfo.coords.fromLocal());
    return new ObjectInfo(chinfo.getObject(), coordsys, this.aoiobj.name);
  }

}
