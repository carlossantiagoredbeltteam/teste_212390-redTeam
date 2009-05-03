package org.reprap.artofillusion;

import java.util.LinkedList;
import java.util.List;

import artofillusion.math.CoordinateSystem;
import artofillusion.math.Vec3;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;

public class SphereObj extends ParsedTree {

  public List<ObjectInfo> evaluateObject(MetaCADContext ctx) throws Exception {
 
    List<ObjectInfo> result = new LinkedList<ObjectInfo>();

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

    result.add(new ObjectInfo(obj3D, new CoordinateSystem(), "dummy"));
    
    return result;
  }
}
