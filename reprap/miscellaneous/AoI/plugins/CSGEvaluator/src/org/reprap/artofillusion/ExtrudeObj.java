package org.reprap.artofillusion;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import artofillusion.math.CoordinateSystem;
import artofillusion.math.Vec3;
import artofillusion.object.CSGObject;
import artofillusion.object.Curve;
import artofillusion.object.Mesh;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;
import artofillusion.object.TriangleMesh;
import artofillusion.tools.ExtrudeTool;

public class ExtrudeObj extends ParsedTree
{
  
  public List<ObjectInfo> evaluateObject(MetaCADContext ctx) throws Exception {
  
    List<ObjectInfo> result = new LinkedList<ObjectInfo>();

    List<ObjectInfo> children = evaluateChildren(ctx);

    // Three first parameters define the extrusion vector
    Vec3 dir = Vec3.vz();
    if (this.parameters.size() >= 3) {
      dir = new Vec3(ctx.evaluateExpression(this.parameters.get(0)),
                     ctx.evaluateExpression(this.parameters.get(1)),
                     ctx.evaluateExpression(this.parameters.get(2)));
    }
    // 4. parameter is num segments
    int numsegments = 1;
    if (this.parameters.size() >= 4) {
      numsegments = (int)ctx.evaluateExpression(this.parameters.get(3));
      if (numsegments < 2) numsegments = 1;
    }
    // 5. parameter is twist degrees
    double twist = 0.0;
    if (this.parameters.size() >= 5) {
      twist = ctx.evaluateExpression(this.parameters.get(4));
    }
    
    result.add(extrude(children, dir, numsegments, twist));
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
   * @return an ObjectInfo. The coordsys in the object info is just there to move
   * the object back to it's original position since the extrusion operation always 
   * centers the result in the origin.
   */
  public ObjectInfo extrude(List<ObjectInfo> objects, Vec3 dir, int numsegments, double twist)
  {
    // Build extrusion curve from vector and segments
    Vec3 v[] = new Vec3[numsegments+1];
    float smooth[] = new float[v.length];
    for (int i = 0; i < v.length; i++) {
      v[i] = new Vec3(dir);
      v[i].scale(1.0*i/numsegments);
      smooth[i] = 1.0f;
    }
    Curve path = new Curve(v, smooth, Mesh.APPROXIMATING, false);
    CoordinateSystem pathCS = new CoordinateSystem();

    // FIXME: Support specifying extrusion curves
    // Extrude each extrudable child object
    List<ObjectInfo> resultobjects = new LinkedList<ObjectInfo>();
    Iterator<ObjectInfo> iter = objects.iterator();
    while(iter.hasNext()) {
      ObjectInfo profile = iter.next();
      Object3D profileobj = profile.getObject();
      if (!(profileobj instanceof TriangleMesh) &&
          profileobj.canConvertToTriangleMesh() != Object3D.CANT_CONVERT) {
        profileobj = profileobj.convertToTriangleMesh(0.1);
      }

      if (profileobj instanceof TriangleMesh) {
        Object3D obj3D = ExtrudeTool.extrudeMesh((TriangleMesh)profileobj, path, profile.getCoords(), pathCS, twist*Math.PI/180.0, true);
      
        // Since the result is centered in the origin, offset the extruded object to 
        // move it back to its original position
        // FIXME: Combine this with the user-specified coordinate system
        CoordinateSystem coordsys = new CoordinateSystem(new Vec3(), Vec3.vz(), Vec3.vy());
        Vec3 offset = profile.getCoords().fromLocal().times(((Mesh)profileobj).getVertices()[0].r).
          minus(coordsys.fromLocal().times(((Mesh)obj3D).getVertices()[0].r));
        coordsys.setOrigin(offset);
        ObjectInfo objinfo = new ObjectInfo(obj3D, coordsys, "tmp");
        resultobjects.add(objinfo);
      }
      profile.setVisible(false);
    }
    if (!resultobjects.isEmpty()) {
      try {
        // FIXME: Undo support?
        // FIXME: We don't really need to union. Join/group should suffice
        return CSGHelper.combine(resultobjects.iterator(), CSGObject.UNION);
      }
      catch (Exception e) {
      }
    }
    // FIXME: Print error
    return null;
  }

  
  
  
  
}
