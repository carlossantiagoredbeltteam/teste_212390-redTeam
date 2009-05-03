package org.reprap.artofillusion;

import artofillusion.math.CoordinateSystem;
import artofillusion.math.Vec3;
import artofillusion.object.Cube;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;

public class CubeObj extends ParsedTree {

  public ObjectInfo evaluateObject(MetaCADContext ctx) throws Exception {
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
    obj3D = new Cube(dims.x, dims.y, dims.z);
    ObjectInfo result = new ObjectInfo(obj3D, new CoordinateSystem(), "dummy");
    return result;
  }
}
