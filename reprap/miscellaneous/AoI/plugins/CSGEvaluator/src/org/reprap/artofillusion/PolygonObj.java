package org.reprap.artofillusion;

import java.util.Arrays;

import artofillusion.math.CoordinateSystem;
import artofillusion.math.Vec3;
import artofillusion.object.Curve;
import artofillusion.object.Mesh;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;

public class PolygonObj extends ParsedTree {

  public ObjectInfo evaluateObject(MetaCADContext ctx) throws Exception {
    
      Vec3[] v=null;
      
      if (this.parameters.size() == 4 && this.parameters.get(0).startsWith("star")) {
        int n = 6;
        double inner = 3;
        double outer = 5;
        if (this.parameters.size() >= 2) n = (int)ctx.evaluateExpression(this.parameters.get(1));
        if (this.parameters.size() >= 4) {
          inner  = ctx.evaluateExpression(this.parameters.get(2));
          outer = ctx.evaluateExpression(this.parameters.get(3));
        }

        v = createStar(n, inner, outer);
      }
      if (this.parameters.size() >= 3 && this.parameters.get(0).startsWith("reg")) {
        int n = 6;
        double radiusx = 4;
        double radiusy = 4;
        if (this.parameters.size() >= 2) n = (int)ctx.evaluateExpression(this.parameters.get(1));
        if (this.parameters.size() >= 3) {
          radiusy = radiusx = ctx.evaluateExpression(this.parameters.get(2));
        }
        if (this.parameters.size() >= 4) {
          radiusy  = ctx.evaluateExpression(this.parameters.get(3));
        }

        v = createRegular(n, radiusx, radiusy);
      }
      
      if (this.parameters.size() >= 4 && this.parameters.get(0).startsWith("roll")) {
        int n = 30;
        double big = 5;
        double small = 1;
        double small2 = 0.8;
        if (this.parameters.size() >= 2) n = (int)ctx.evaluateExpression(this.parameters.get(1));
        if (this.parameters.size() >= 4) {
          big  = ctx.evaluateExpression(this.parameters.get(2));
          small2 = small = ctx.evaluateExpression(this.parameters.get(3));
        }
        if (this.parameters.size() == 5) {
          small2 = ctx.evaluateExpression(this.parameters.get(4));
        }            
        
        v = createRoll(n, big, small, small2);
      }

      if (v != null) {
        Object3D obj3D = createPolygon(v);
        ObjectInfo result = new ObjectInfo(obj3D, new CoordinateSystem(), this.aoiobj.name);
        updateAOI(result);
        
        return result;
      }
      return null;
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

  
}
