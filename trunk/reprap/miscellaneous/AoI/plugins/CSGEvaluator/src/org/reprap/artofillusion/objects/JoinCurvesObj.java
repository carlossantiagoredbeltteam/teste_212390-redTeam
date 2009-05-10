package org.reprap.artofillusion.objects;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import org.reprap.artofillusion.MetaCADContext;
import org.reprap.artofillusion.ParsedTree;

import artofillusion.math.CoordinateSystem;
import artofillusion.math.Mat4;
import artofillusion.math.Vec3;
import artofillusion.object.Curve;
import artofillusion.object.MeshVertex;
import artofillusion.object.ObjectInfo;

class Polyline {
  public LinkedList<ObjectInfo> curves = new LinkedList<ObjectInfo>();
  public LinkedList<Boolean> flipped = new LinkedList<Boolean>();
  public boolean loop = false;
  public int numvertices = 0;
}

public class JoinCurvesObj extends MetaCADObject
{
  
  public List<ObjectInfo> evaluateObject(MetaCADContext ctx, 
                                         List<String> parameters, 
                                         List<ParsedTree> children) throws Exception {

    int smoothtype = 0;
    float smoothness = 1.0f;

    // First parameters is joinends
    boolean joinends = true;
    if (parameters.size() >= 1) {
      joinends = ((int)ctx.evaluateExpression(parameters.get(0)) != 0);
    }
    // 2. parameter is tolerance
    double tol = 0.1f;
    if (parameters.size() >= 2) {
      tol = ctx.evaluateExpression(parameters.get(1));
    }
    
    List<ObjectInfo> result = new LinkedList<ObjectInfo>();
    
    List<ObjectInfo> ch = ParsedTree.evaluate(ctx, children);
    
    // FIXME: Check that # children >= 2
    // FIXME: Check that all children are curves
    ObjectInfo[] curves = ch.toArray(new ObjectInfo[ch.size()]);

    // Cache end vertices
    Vec3[][] ends = new Vec3[ch.size()][2];
    for (int i=0;i<curves.length;i++) {
      Mat4 mat = curves[i].coords.fromLocal();
      MeshVertex[] verts = ((Curve)curves[i].object).getVertices();
      ends[i][0] = mat.times(verts[0].r);
      ends[i][1] = mat.times(verts[verts.length-1].r);
    }

    int curvesconsumed = 0;
    List<Polyline> polylines = new LinkedList<Polyline>();
    int curridx = 0;
    while (curvesconsumed < curves.length) {
      while (curves[curridx] == null) curridx++;
      Polyline polyline = new Polyline();

      polyline.curves.add(curves[curridx]);
      polyline.flipped.add(false);
      polyline.numvertices += ((Curve)curves[curridx].object).getVertices().length;
      curvesconsumed++;
      curves[curridx] = null;
      
      
      Vec3 loopstart = ends[curridx][0];
      Vec3 loopend = ends[curridx][1];
      int i;
      for (i=curridx+1;i<curves.length;i++) {
        for (int k=0;k<2;k++) {
          if (loopstart.distance(ends[i][k]) < tol) {
            polyline.curves.addFirst(curves[i]);
            polyline.numvertices += ((Curve)curves[i].object).getVertices().length;
            polyline.flipped.addFirst(k == 0);
            curvesconsumed++;
            curves[i] = null;

            loopstart = ends[i][(k+1)%2];
          }
          if (loopend.distance(ends[i][k]) < tol) {
            polyline.curves.addLast(curves[i]);
            polyline.numvertices += ((Curve)curves[i].object).getVertices().length;
            polyline.flipped.addFirst(k == 1);
            curvesconsumed++;
            curves[i] = null;

            loopend = ends[i][(k+1)%2];
          }
          if (loopstart.distance(loopend) < tol) break; // Loop found
        }
      }
      if (i != curves.length) polyline.loop = true;
      polylines.add(polyline);
    }

    for (Polyline polyline : polylines) {
      Iterator<ObjectInfo> c_iter = polyline.curves.iterator();
      Iterator<Boolean> f_iter = polyline.flipped.iterator();
      int numvertices = polyline.numvertices - polyline.curves.size();
      if (!polyline.loop) numvertices++;
      Vec3[] vertices = new Vec3[numvertices];
      int currvidx = 0;
      while (c_iter.hasNext() && f_iter.hasNext()) {
        ObjectInfo info = c_iter.next();
        boolean flipped = f_iter.next();

        Mat4 mat = info.coords.fromLocal();
        MeshVertex[] verts = ((Curve)info.object).getVertices();
        for (int v=0;v<verts.length;v++) {
          vertices[currvidx + (flipped?v:verts.length-1-v)] = mat.times(verts[v].r);
        }
        currvidx += verts.length - 1;
      }
      //  create new curve
      float[] smooth = new float[numvertices];
      for (int i=0;i<numvertices;i++) {
        smooth[i] = smoothness;
      }
      Curve curve = new Curve(vertices, smooth, smoothtype, joinends || polyline.loop);
      result.add(new ObjectInfo(curve, new CoordinateSystem(), "dummy"));
    }
    
    return result;
  }
}
