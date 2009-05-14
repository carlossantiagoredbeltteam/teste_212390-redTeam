package org.reprap.artofillusion.metacad.objects;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import org.reprap.artofillusion.metacad.MetaCADContext;
import org.reprap.artofillusion.metacad.ParsedTree;

import artofillusion.object.Curve;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;
import artofillusion.object.TriangleMesh;

public class MeshObj extends MetaCADObject
{
  
  public List<ObjectInfo> evaluateObject(MetaCADContext ctx, 
                                         List<String> parameters, 
                                         List<ParsedTree> children) throws Exception {
    
    double tolerance = 0.2;
    if (parameters.size() > 0) {
      tolerance = ctx.evaluateExpression(parameters.get(0));
    }

    List<ObjectInfo> results = new LinkedList<ObjectInfo>();

    Iterator<ObjectInfo> iter = ParsedTree.evaluate(ctx, children).iterator();
    while(iter.hasNext()) {
      ObjectInfo chinfo = iter.next();
      Object3D obj3D = chinfo.getObject();
      if (obj3D instanceof Curve) {
        TriangleMesh mesh = obj3D.convertToTriangleMesh(tolerance);
        if (mesh != null) {
          ObjectInfo newinfo = new ObjectInfo(mesh, chinfo.getCoords(), "dummy");
          newinfo.setTexture(ctx.scene.getDefaultTexture(), ctx.scene.getDefaultTexture().getDefaultMapping(mesh));
          results.add(newinfo);
        }
      }
    }
    return results;
  }
}
