package org.reprap.artofillusion;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import artofillusion.math.CoordinateSystem;
import artofillusion.object.Curve;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;
import artofillusion.object.TriangleMesh;

public class MeshObj extends ParsedTree
{
  
  public List<ObjectInfo> evaluateObject(MetaCADContext ctx) throws Exception {
    
    double tolerance = 0.2;
    if (this.parameters.size() > 0) {
      tolerance = ctx.evaluateExpression(this.parameters.get(0));
    }

    List<ObjectInfo> results = new LinkedList<ObjectInfo>();

    List<ObjectInfo> children = evaluateChildren(ctx);

    Iterator<ObjectInfo> iter = children.iterator();
    while(iter.hasNext()) {
      ObjectInfo chinfo = iter.next();
      Object3D obj3D = chinfo.getObject();
      if (obj3D instanceof Curve) {
        TriangleMesh mesh = obj3D.convertToTriangleMesh(tolerance);
        ObjectInfo newinfo = new ObjectInfo(mesh, new CoordinateSystem(), "dummy");
        newinfo.setTexture(ctx.scene.getDefaultTexture(), ctx.scene.getDefaultTexture().getDefaultMapping(mesh));
        results.add(newinfo);
      }
    }
    return results;
  }
}
