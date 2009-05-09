package org.reprap.artofillusion;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import artofillusion.math.CoordinateSystem;
import artofillusion.math.Vec2;
import artofillusion.math.Vec3;
import artofillusion.object.Curve;
import artofillusion.object.Mesh;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;

public class InsetObj extends MetaCADObject
{
  
  public List<ObjectInfo> evaluateObject(MetaCADContext ctx, 
                                         List<String> parameters, 
                                         List<ParsedTree> children) throws Exception {

    double inset = 1.0;
    if (parameters.size() > 0) {
      inset = ctx.evaluateExpression(parameters.get(0));
    }
    
    List<ObjectInfo> result = new LinkedList<ObjectInfo>();

    Iterator<ObjectInfo> iter = ParsedTree.evaluate(ctx, children).iterator();

    while (iter.hasNext()) {
      ObjectInfo chinfo = iter.next();
      Object3D obj3D = chinfo.object;
      if (obj3D instanceof Curve) {
        Curve curve = (Curve)obj3D;
        Vec3[] newvec = insetPoly(curve.getVertexPositions(), inset);
        obj3D = PolygonObj.createPolygon(newvec);
        result.add(new ObjectInfo(obj3D, new CoordinateSystem(), "dummy"));
      }
    }
    return result;
  }
  
  Vec3[] createRoll(int n, double big, double small, double small2) {
    Vec3[] v;
    v = new Vec3[n];
    int index = 0;
    for (int i = 0; i < n; i++)
    {
      double biga=(2*Math.PI*i)/n;
      double len = big*biga;
      double smalla=len/small;
      double x,y;
      
      x = (big+small)*Math.cos(biga) + (small2)*Math.cos(smalla);
      y = (big+small)*Math.sin(biga) + (small2)*Math.sin(smalla);
      
      v[index] = new Vec3(x, y, 0 );
      
      index++;
    }
    return v;
  }

  Vec3[] createRegular(int n, double radiusx, double radiusy) {
    Vec3[] v;
    v = new Vec3[n];
    int index = 0;
    for (int i = 0; i < n; i++)
    {
      v[index] = new Vec3( radiusx*Math.cos( 2*Math.PI * index / (double) n ),
          radiusy*Math.sin(2*Math.PI * index / (double) n ), 0 );
      index++;
    }
    return v;
  }

  Vec3[] createStar(int n, double inner, double outer) {
    Vec3[] v;
    v = new Vec3[2*n];
    int index = 0;
    for (int i = 0; i < n; i++) {
      v[index] = new Vec3(Math.cos(Math.PI * index / (double) n),
                          Math.sin(Math.PI * index / (double) n), 0);
      v[index].scale(inner);
      v[index+1] = new Vec3(Math.cos(Math.PI * (index + 1) / (double) n),
                            Math.sin(Math.PI * (index + 1) / (double) n), 0);
      v[index+1].scale(outer);
      index += 2;
    }
    return v;
  }

  Object3D createPolygon(Vec3[] v) {
    Object3D obj3D;
    float smoothness[] = new float[v.length];
    Arrays.fill(smoothness, 0.0f);
    obj3D = new Curve(v, smoothness, Mesh.NO_SMOOTHING, true).convertToTriangleMesh(0);
    return obj3D;
  }

///////////////////////////////////////////
//math helpers
 
  // solves system of 2 linear equations in 2 unknown 
  class LinearSolve2
  {
    public boolean error;
    public double x1, x2;
  
    // matrix looks like this 
    // a b
    // c d
    public double det(double a,double b, double c, double d)
    {
      return a*d-b*c;  
    }
    // the equations look like thsi looks like this
    // x1*a + x2*b = r1
    // x1*c + x2*d = r2
    public LinearSolve2(double a,double b, double c, double d, double r1, double r2)
    {
      double q;
      
      q=det(a,b,c,d);
      if (Math.abs(q) < 0.00000001)
      {
        this.error = true;
      }
      else
      {
        this.error = false;
        this.x1=det(r1,b,r2,d)/q;
        this.x2=det(a,r1,c,r2)/q;
      }
    }
  }
  
  class MetaCADLine {
    protected Vec2 start,end, dir;
    protected Vec2 normal;
    
    public MetaCADLine(Vec3 s,Vec3 e)
    {
      this.start = new Vec2(s.x,s.y);
      this.end = new Vec2(e.x, e.y);
      this.dir = this.end.minus(this.start);
      this.normal = new Vec2(this.dir);
      this.normal.normalize();
      this.normal.set(-this.normal.y, this.normal.x);
    }
    
    public void parallelMove(double d)
    {
      this.start.add(this.normal.times(d));
    }
    
    public Vec3 intersect3(MetaCADLine l)
    {
      LinearSolve2 solve = new LinearSolve2(l.dir.x, -this.dir.x, l.dir.y, -this.dir.y, this.start.x-l.start.x, this.start.y-l.start.y);
      if (solve.error)
      {
        return null;
      }
      else
      {
        Vec2 point = this.start.plus(this.dir.times(solve.x2)); 
        return new Vec3(point.x,point.y, 0);
      }
    }
  }

  Vec3[] insetPoly(Vec3[] poly, double inset)
  {
    //List<MetaCADLine> lines = new ArrayList<MetaCADLine>();
    List<Vec3> points = new ArrayList<Vec3>();
    
    for (int i = 0; i < poly.length; i++)
    {
        int iprev = (i+poly.length-1)%poly.length;
        int inext = (i+1)%poly.length;
        
        MetaCADLine prev = new MetaCADLine(poly[iprev], poly[i]);
        MetaCADLine next = new MetaCADLine(poly[i], poly[inext]);
        
        prev.parallelMove(inset);
        next.parallelMove(inset);
        
        Vec3 intersect=prev.intersect3(next);
        if (intersect ==  null)
        {
          intersect = new Vec3(0,0,0);
        }
        points.add(intersect);
    }
     
    return points.toArray(new Vec3[1]);
  }
  
}
