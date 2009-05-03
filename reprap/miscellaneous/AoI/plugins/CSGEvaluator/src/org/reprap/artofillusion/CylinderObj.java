package org.reprap.artofillusion;

import java.util.LinkedList;
import java.util.List;

import artofillusion.math.CoordinateSystem;
import artofillusion.object.Cylinder;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;

public class CylinderObj extends ParsedTree {

  public List<ObjectInfo> evaluateObject(MetaCADContext ctx) throws Exception {
  
    List<ObjectInfo> result = new LinkedList<ObjectInfo>();

    double mainparam = 1.0f;
    if (this.parameters.size() >= 1) {
      mainparam = ctx.evaluateExpression(this.parameters.get(0));
    }
    // First (main) parameter is height
    double height = mainparam;
    double rx = mainparam;
    double ry = mainparam;
    double ratio = 1;

    // Second parameter is radius
    if (this.parameters.size() >= 2) rx = ry = ctx.evaluateExpression(this.parameters.get(1));
    // Third parameter define separate y radius
    if (this.parameters.size() >= 3) ry = ctx.evaluateExpression(this.parameters.get(2));
    // Fourth parameter define top/bottom radius ratio
    // Cylinder takes an optional fourth parameter
    if (this.parameters.size() >= 4) {
      ratio = ctx.evaluateExpression(this.parameters.get(3));
      if (ratio > 1) ratio = 1.0;
      if (ratio < 0) ratio = 0.0;
    }
    Object3D obj3D = new Cylinder(height, rx, ry, ratio);
    result.add(new ObjectInfo(obj3D, new CoordinateSystem(), "dummy"));
    return result;
  }
}
