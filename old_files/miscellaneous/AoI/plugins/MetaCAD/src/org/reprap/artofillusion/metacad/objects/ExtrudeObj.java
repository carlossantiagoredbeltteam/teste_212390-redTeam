package org.reprap.artofillusion.metacad.objects;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import org.reprap.artofillusion.metacad.MetaCADContext;
import org.reprap.artofillusion.metacad.ParsedTree;

import artofillusion.math.BoundingBox;
import artofillusion.math.CoordinateSystem;
import artofillusion.math.Mat4;
import artofillusion.math.Vec3;
import artofillusion.object.Curve;
import artofillusion.object.Mesh;
import artofillusion.object.MeshVertex;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;
import artofillusion.object.TriangleMesh;
import artofillusion.tools.ExtrudeTool;

public class ExtrudeObj extends MetaCADObject
{
  
  public List<ObjectInfo> evaluateObject(MetaCADContext ctx, 
                                         List<String> parameters, 
                                         List<ParsedTree> children) throws Exception {
  
    List<ObjectInfo> result = new LinkedList<ObjectInfo>();

    // Three first parameters define the extrusion vector
    Vec3 dir = Vec3.vz();
    if (parameters.size() >= 3) {
      dir = new Vec3(ctx.evaluateExpression(parameters.get(0)),
                     ctx.evaluateExpression(parameters.get(1)),
                     ctx.evaluateExpression(parameters.get(2)));
    }
    // 4. parameter is num segments
    int numsegments = 1;
    if (parameters.size() >= 4) {
      numsegments = (int)ctx.evaluateExpression(parameters.get(3));
      if (numsegments < 2) numsegments = 1;
    }
    // 5. parameter is twist degrees
    double twist = 0.0;
    if (parameters.size() >= 5) {
      twist = ctx.evaluateExpression(parameters.get(4));
    }
    boolean approximate = false;
    if (parameters.size() >= 6)
    {
      approximate = ctx.evaluateBoolean(parameters.get(5));
    }
    
    result.addAll(extrude(ParsedTree.evaluate(ctx, children), dir, numsegments, twist, approximate));
    return result;
  }
  
  /**
   * 
   * Extrudes the given profiles using the given parameters and returns the result object.
   * 
   * @param objects
   * @param dir
   * @param numsegments
   * @param twist
   * @return a list of ObjectInfos. The coordsys in the object infos are just there to move
   * the objects back to their original positions since the extrusion operation always 
   * centers the result in the origin.
   */
  public List<ObjectInfo> extrude(List<ObjectInfo> objects, Vec3 dir, int numsegments, double twist, boolean approximate)
  {
    // Build extrusion curve from vector and segments
    Vec3 v[] = new Vec3[numsegments+1];
    float smooth[] = new float[v.length];
    for (int i = 0; i < v.length; i++) {
      v[i] = new Vec3(dir);
      v[i].scale(1.0*i/numsegments);
      smooth[i] = 1.0f;
    }
    
    Curve path;
    if (approximate) {
      path = new Curve(v, smooth, Mesh.APPROXIMATING, false);
    }
    else {
      path = new Curve(v, smooth, Mesh.NO_SMOOTHING, false);
    }
      
    CoordinateSystem pathCS = new CoordinateSystem();

    // FIXME: Support specifying extrusion curves
    // Extrude each extrudable child object
    List<ObjectInfo> resultobjects = new LinkedList<ObjectInfo>();
    Iterator<ObjectInfo> iter = objects.iterator();
    while (iter.hasNext()) {
      ObjectInfo profile = iter.next();
      Object3D profileobj = profile.getObject();

      Object3D obj3D = null;
      if (profileobj instanceof Mesh) {
        applyCS(profile.coords, ((Mesh)profileobj));
        profile.setCoords(new CoordinateSystem());
        
        if (profileobj instanceof TriangleMesh) {
          obj3D = ExtrudeTool.extrudeMesh((TriangleMesh)profileobj, path, profile.getCoords(), pathCS, twist*Math.PI/180.0, true);
        }
        else if (profileobj instanceof Curve) {
          if (((Curve)profileobj).getSmoothingMethod() < Mesh.INTERPOLATING &&
              path.getSmoothingMethod() < Mesh.INTERPOLATING) {
            path.setSmoothingMethod(Mesh.INTERPOLATING);
          }
          obj3D = ExtrudeTool.extrudeCurve((Curve)profileobj, path, profile.getCoords(), pathCS, twist*Math.PI/180.0, true);
        }
      }
      if (obj3D != null) {
        // Since the result is centered in the origin, offset the extruded object to 
        // move it back to its original position
        // FIXME: This only works for linear extrusions, not off-center twists.
//        BoundingBox mybox = profile.getBounds();        
//        if (dir.x < 0) mybox.minx -= dir.x;
//        else mybox.maxx += dir.x;
//        if (dir.y < 0) mybox.miny -= dir.y;
//        else mybox.maxy += dir.y;
//        if (dir.z < 0) mybox.minz -= dir.z;
//        else mybox.maxz += dir.z;
        
//        Vec3 offset = profile.getCoords().fromLocal().times(mybox.getCenter()).
//        minus(((Mesh)obj3D).getBounds().getCenter());
        Vec3 offset = profile.getCoords().fromLocal().times(((Mesh)profileobj).getVertices()[0].r).
        minus(((Mesh)obj3D).getVertices()[0].r);
        
        CoordinateSystem coordsys = new CoordinateSystem(offset, Vec3.vz(), Vec3.vy());
        ObjectInfo objinfo = new ObjectInfo(obj3D, coordsys, "tmp");
        resultobjects.add(objinfo);
      }
      profile.setVisible(false);
    }
    // FIXME: Undo support?
    return resultobjects;
}

  void applyCS(CoordinateSystem cs, Mesh mesh) {
    MeshVertex[] verts = mesh.getVertices();
    Mat4 trans = cs.fromLocal();
    
    for (int i = 0; i < verts.length; i++) {
      trans.transform(verts[i].r);
    }
  }
  
}
