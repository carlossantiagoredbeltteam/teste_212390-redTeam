package org.reprap.artofillusion.metacad.objects;

import java.util.Iterator;
import java.util.List;

import org.reprap.artofillusion.metacad.MetaCADContext;
import org.reprap.artofillusion.metacad.ParsedTree;

import artofillusion.math.CoordinateSystem;
import artofillusion.object.ObjectInfo;

public class RotateObj extends MetaCADObject {

  public List<ObjectInfo> evaluateObject(MetaCADContext ctx, 
                                         List<String> parameters, 
                                         List<ParsedTree> children) throws Exception {

    assert(children.size() == 1);
    List<ObjectInfo> chlist = ParsedTree.evaluate(ctx, children);
    
    CoordinateSystem coordsys = new CoordinateSystem();
    if (parameters.size() >= 3) {
      coordsys.setOrientation(ctx.evaluateExpression(parameters.get(0)),
                              ctx.evaluateExpression(parameters.get(1)),
                              ctx.evaluateExpression(parameters.get(2)));
    }
    
    Iterator<ObjectInfo> iter = chlist.iterator();
    while (iter.hasNext()) {
      ObjectInfo info = iter.next();
      info.coords.transformCoordinates(coordsys.fromLocal());
    }
    return chlist;
  }

}
