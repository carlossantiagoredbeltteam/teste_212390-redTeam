package org.reprap.artofillusion.metacad.objects;

import java.util.LinkedList;
import java.util.List;

import org.reprap.artofillusion.metacad.MetaCADContext;
import org.reprap.artofillusion.metacad.ParsedTree;

import artofillusion.math.CoordinateSystem;
import artofillusion.math.Vec3;
import artofillusion.object.Cube;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;

public class CubeObj extends MetaCADObject {

  public List<ObjectInfo> evaluateObject(MetaCADContext ctx, 
                                         List<String> parameters, 
                                         List<ParsedTree> children) throws Exception {
    
    List<ObjectInfo> result = new LinkedList<ObjectInfo>();

    double mainparam = 1.0f;
    if (parameters.size() >= 1) {
      mainparam = ctx.evaluateExpression(parameters.get(0));
    }
    Vec3 dims = new Vec3(mainparam, mainparam, mainparam);
    if (parameters.size() >= 3) {
      dims.set(mainparam,
               ctx.evaluateExpression(parameters.get(1)),
               ctx.evaluateExpression(parameters.get(2)));
    }
    Object3D obj3D = new artofillusion.object.Sphere(dims.x, dims.y, dims.z);
    obj3D = new Cube(dims.x, dims.y, dims.z);
    result.add(new ObjectInfo(obj3D, new CoordinateSystem(), "dummy"));
    return result;
  }
}
