package org.reprap.artofillusion.objects;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import org.reprap.artofillusion.MetaCADContext;
import org.reprap.artofillusion.ParsedTree;

import artofillusion.math.CoordinateSystem;
import artofillusion.object.Curve;
import artofillusion.object.Mesh;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;
import artofillusion.tools.LatheTool;

public class LatheObj extends MetaCADObject
{
  
  public List<ObjectInfo> evaluateObject(MetaCADContext ctx, 
                                         List<String> parameters, 
                                         List<ParsedTree> children) throws Exception {
  
    List<ObjectInfo> result = new LinkedList<ObjectInfo>();

    // First parameter define the lathe axis (X, Y or Z)
    int axis = LatheTool.X_AXIS;
    if (parameters.size() >= 1) {
      String dir = parameters.get(0);
     if (dir.equals("Y")) axis = LatheTool.Y_AXIS;
      else if (dir.equals("Z")) axis = LatheTool.Z_AXIS;
    }
    
    // 2. parameter is sweep angle
    double sweepang = 360;
    if (parameters.size() >= 2) {
      sweepang = ctx.evaluateExpression(parameters.get(1));
    }

    // 3. parameter is radius
    double radius = 0.0;
    if (parameters.size() >= 3) {
      radius = ctx.evaluateExpression(parameters.get(2));
    }
    
    result.addAll(lathe(ParsedTree.evaluate(ctx, children), axis, sweepang, radius));
    return result;
  }
  
  /**
   * 
   * Lathes the given profiles using the given parameters and returns the result object.
   * 
   */
  public List<ObjectInfo> lathe(List<ObjectInfo> objects, int axis, double sweepang, double radius)
  {
    // Lathe each lathable child object
    List<ObjectInfo> resultobjects = new LinkedList<ObjectInfo>();
    Iterator<ObjectInfo> iter = objects.iterator();
    while (iter.hasNext()) {
      ObjectInfo profile = iter.next();
      Object3D profileobj = profile.getObject();
      Object3D obj3D = null;
      if (profileobj instanceof Curve) {
        Mesh mesh = LatheTool.latheCurve((Curve)profileobj, axis, 16, sweepang, radius);
        if (mesh instanceof Object3D) obj3D = (Object3D)mesh;
      }
      if (obj3D != null) {
        ObjectInfo objinfo = new ObjectInfo(obj3D, new CoordinateSystem(), "tmp");
        resultobjects.add(objinfo);
      }
      profile.setVisible(false);
    }
    // FIXME: Undo support?
    return resultobjects;
  }
}
