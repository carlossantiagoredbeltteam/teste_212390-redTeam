package org.reprap.artofillusion.objects;

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

public class JoinCurvesObj extends MetaCADObject
{
  
  public List<ObjectInfo> evaluateObject(MetaCADContext ctx, 
                                         List<String> parameters, 
                                         List<ParsedTree> children) throws Exception {

    List<ObjectInfo> result = new LinkedList<ObjectInfo>();
    
    List<ObjectInfo> ch = ParsedTree.evaluate(ctx, children);
    
    // FIXME: Check that # children >= 2
    // FIXME: Check that all children are curves
    
    Vec3[][] ends = new Vec3[ch.size()][2];

    float tol = 0.1f;
    int smoothtype = 0;
    float smoothness = 1.0f;
    Boolean joinends = true;
    
    // get total number of curve points and start/end vertices of each curve
    int num = 0;
    int idx = 0;
    ObjectInfo[] curves = new ObjectInfo[ch.size()];
    curves = ch.toArray(curves);
    for (idx=0;idx<curves.length;idx++) {
      Mat4 mat = curves[idx].coords.fromLocal();
      MeshVertex[] verts = ((Curve)curves[idx].object).getVertices();
      num = num + verts.length;
      ends[idx][0] = mat.times(verts[0].r);
      ends[idx][1] = mat.times(verts[verts.length-1].r);
    }

    int end0found = 0;
    int end1found = 0;
    int i;
    // find ends
    for (i=0;i<curves.length;i++) {
      end0found = 0;
      end1found = 0;
      for (int j=0;j<curves.length;j++) {
        if (j == i) continue;
        for (int k=0;k<2;k++)	{
          if (ends[i][0].distance(ends[j][k]) < tol) end0found = 1;
          if (ends[i][1].distance(ends[j][k]) < tol) end1found = 1;
        }
      }
      if (end0found + end1found < 2) break;
    }
    if (end0found + end1found == 0) {
      // FIXME: Throw exception
//      new MessageDialog(window, "One or more of the curves are not within selected Proximity - either increase Proximity or move curves");
      return result;
    }

    //
    Boolean loop;
    int firstCurve;
    if (i == curves.length) {
      loop = true;
      firstCurve = 0; // if no ends found, then must be a loop so choose any starting curve
    }
    else {
      loop = false;
      firstCurve = i;  // otherwise curve i is at one end
    }

    // assemble the joined curve
    int[] curvesUsed = new int[curves.length];
    int curvesUsedIdx = 0;
    curvesUsed[curvesUsedIdx] = firstCurve;
    curvesUsedIdx++;
    Vec3[] curvePoints;
    int numCurvePoints = num - curves.length;
    if (!loop) numCurvePoints++;
    curvePoints = new Vec3[numCurvePoints];

    // add first curve
    int counter = 0;
    Mat4 mat = curves[firstCurve].coords.fromLocal();
    MeshVertex[] verts = ((Curve)curves[firstCurve].object).getVertices();
    if (end1found == 1) {
      for (int v=0;v<verts.length;v++) {
        curvePoints[v+counter]=mat.times(verts[v].r); // update position in world space
      }
    }
    if (end0found == 1) { // reverse order of vertices so curve starts at end
      for (int v=0;v<verts.length;v++) {
        curvePoints[verts.length-1-v+counter]=mat.times(verts[v].r); // update position in world space
      }
    }
    counter = counter + verts.length;
    if (joinends) counter--;

    //  assembly joined curve
    while (curvesUsedIdx < curves.length) {
      int c;
      for (c=0;c<curves.length;c++)  { //cycle through the selected curves
        if (c == curvesUsed[curvesUsedIdx-1]) continue; // skip if the same curve
        int pointToCheck;
        if (joinends) pointToCheck = counter;
        else pointToCheck = counter - 1;
        //
        if (curvePoints[pointToCheck].distance(ends[c][0])<tol) { // if start of curve c is close to end
          mat= curves[c].coords.fromLocal();
          verts = ((Curve)curves[c].object).getVertices();
          for (int v=0;v<verts.length;v++) {
            curvePoints[v+counter]=mat.times(verts[v].r);
          }
          curvesUsed[curvesUsedIdx]=c; // add curve to list of those used
          curvesUsedIdx++;  //update number of curves used
          counter=counter+verts.length;
          if (joinends) counter--;
          break;
        }
        if (curvePoints[pointToCheck].distance(ends[c][1])<tol) { // if end of curve c is close to end
          mat = curves[c].coords.fromLocal();
          verts = ((Curve)curves[c].object).getVertices();
          for (int v=0;v<verts.length;v++) {
            curvePoints[verts.length-1-v+counter]=mat.times(verts[v].r);
          }
          curvesUsed[curvesUsedIdx]=c; // add curve to list of those used
          curvesUsedIdx++;  //update number of curves used
          counter=counter+verts.length;
          if (joinends) counter--;
          break;
        }
      }
      if (c == curves.length) {
        // FIXME: Throw exception
//        new MessageDialog(window, "One or more of the curves are not within selected Proximity - either increase Proximity or move curves");
        return result;
      }
    }
//  create new curve
    float[] smooth = new float[num];
    for (i=0;i<num;i++) {
      smooth[i]=smoothness;
    }

    Curve curve = new Curve(curvePoints, smooth, smoothtype, joinends || loop);
    result.add(new ObjectInfo(curve, new CoordinateSystem(), "dummy"));
    return result;
  }
}
