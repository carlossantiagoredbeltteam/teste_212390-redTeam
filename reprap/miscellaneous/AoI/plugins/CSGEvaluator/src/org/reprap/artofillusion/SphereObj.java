package org.reprap.artofillusion;

import artofillusion.math.CoordinateSystem;
import artofillusion.math.Vec3;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;

public class SphereObj extends ParsedTree {

  public ObjectInfo evaluate(MetaCADContext ctx) throws Exception {
    double mainparam = 1.0f;
    if (this.parameters.size() >= 1) {
      mainparam = ctx.evaluateExpression(this.parameters.get(0));
    }
    Vec3 dims = new Vec3(mainparam, mainparam, mainparam);
    if (this.parameters.size() >= 3) {
      dims.set(mainparam,
               ctx.evaluateExpression(this.parameters.get(1)),
               ctx.evaluateExpression(this.parameters.get(2)));
    }
    Object3D obj3D = new artofillusion.object.Sphere(dims.x, dims.y, dims.z);
    return new ObjectInfo(obj3D, new CoordinateSystem(), this.aoiobj.name);
  }
}
