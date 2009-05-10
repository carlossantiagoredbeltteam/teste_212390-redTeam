package org.reprap.artofillusion.objects;

import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

import org.reprap.artofillusion.MetaCADContext;
import org.reprap.artofillusion.ParsedTree;

import artofillusion.math.CoordinateSystem;
import artofillusion.math.Vec3;
import artofillusion.object.Curve;
import artofillusion.object.Mesh;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;

public class PolygonObj extends MetaCADObject
{
  public static final int STAR = 0;
  public static final int REG = 1;
  public static final int ROLL = 2;
  int type;
  
  public PolygonObj(int type) {
    this.type = type;
  }
  
  public List<ObjectInfo> evaluateObject(MetaCADContext ctx, 
                                         List<String> parameters, 
                                         List<ParsedTree> children) throws Exception {
    
    List<ObjectInfo> result = new LinkedList<ObjectInfo>();

    Vec3[] v=null;
      switch (this.type) {
      case STAR: {
        int n = 6;
        double inner = 3;
        double outer = 5;
        if (parameters.size() >= 1) {
          n = (int)ctx.evaluateExpression(parameters.get(0));
        }
        if (parameters.size() >= 3) {
          inner  = ctx.evaluateExpression(parameters.get(1));
          outer = ctx.evaluateExpression(parameters.get(2));
        }

        v = createStar(n, inner, outer);
        break;
      }
      case REG: {
        int n = 6;
        double radiusx = 4;
        double radiusy = 4;
        if (parameters.size() >= 1) {
          n = (int)ctx.evaluateExpression(parameters.get(0));
        }
        if (parameters.size() >= 2) {
          radiusy = radiusx = ctx.evaluateExpression(parameters.get(1));
        }
        if (parameters.size() >= 3) {
          radiusy  = ctx.evaluateExpression(parameters.get(2));
        }

        v = createRegular(n, radiusx, radiusy);
        break;
      }
      case ROLL: {
        int n = 30;
        double big = 5;
        double small = 1;
        double small2 = 0.8;
        if (parameters.size() >= 1) {
          n = (int)ctx.evaluateExpression(parameters.get(0));
        }
        if (parameters.size() >= 3) {
          big  = ctx.evaluateExpression(parameters.get(1));
          small2 = small = ctx.evaluateExpression(parameters.get(2));
        }
        if (parameters.size() == 4) {
          small2 = ctx.evaluateExpression(parameters.get(3));
        }            
          
        v = createRoll(n, big, small, small2);
        break;
      }
      }

      if (v != null) {
        Object3D obj3D = createPolygon(v);
        result.add(new ObjectInfo(obj3D, new CoordinateSystem(), "dummy"));
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

  static public Object3D createPolygon(Vec3[] v) {
    Object3D obj3D;
    float smoothness[] = new float[v.length];
    Arrays.fill(smoothness, 0.0f);
    obj3D = new Curve(v, smoothness, Mesh.NO_SMOOTHING, true);
    return obj3D;
  }

  
}
