package org.reprap.artofillusion.metacad.objects;

import java.util.LinkedList;
import java.util.List;
import java.util.Vector;

import javax.media.opengl.GL;
import javax.media.opengl.glu.GLU;
import javax.media.opengl.glu.GLUtessellator;
import javax.media.opengl.glu.GLUtessellatorCallback;

import org.reprap.artofillusion.metacad.MetaCADContext;
import org.reprap.artofillusion.metacad.ParsedTree;

import artofillusion.math.CoordinateSystem;
import artofillusion.math.Mat4;
import artofillusion.math.Vec3;
import artofillusion.object.Curve;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;
import artofillusion.object.TriangleMesh;

public class MeshObj extends MetaCADObject implements GLUtessellatorCallback
{
  Vector<Vec3> vertices;
  GLU glu;
  Vector<Integer> indices;
  List<ObjectInfo> results;
  MetaCADContext ctx;
  
  public List<ObjectInfo> evaluateObject(MetaCADContext ctx, 
                                         List<String> parameters, 
                                         List<ParsedTree> children) throws Exception {
    
    double tolerance = 0.2;
    if (parameters.size() > 0) {
      tolerance = ctx.evaluateExpression(parameters.get(0));
    }

    this.ctx = ctx;    
    this.results = new LinkedList<ObjectInfo>();
    
    
    // Merge all curves into one big vertex array
    this.vertices = new Vector<Vec3>();
    
    this.indices = new Vector<Integer>();

    this.glu = new GLU();
    GLUtessellator tobj = this.glu.gluNewTess();

    this.glu.gluTessCallback(tobj, GLU.GLU_TESS_VERTEX, this);
    this.glu.gluTessCallback(tobj, GLU.GLU_TESS_BEGIN, this);
    this.glu.gluTessCallback(tobj, GLU.GLU_TESS_END, this);
    this.glu.gluTessCallback(tobj, GLU.GLU_TESS_ERROR, this);
    this.glu.gluTessCallback(tobj, GLU.GLU_TESS_COMBINE, this);
    this.glu.gluTessCallback(tobj, GLU.GLU_TESS_EDGE_FLAG, this);
    this.glu.gluTessProperty(tobj, GLU.GLU_TESS_WINDING_RULE, GLU.GLU_TESS_WINDING_ODD);

    
    this.glu.gluTessBeginPolygon(tobj, null);
    int counter = 0;
    for (ObjectInfo chinfo : ParsedTree.evaluate(ctx, children)) {
      this.glu.gluTessBeginContour(tobj);
      Object3D obj3D = chinfo.getObject();
      if (obj3D instanceof Curve) {
        Mat4 trans = chinfo.coords.fromLocal();
        for (Vec3 v : ((Curve)obj3D).getVertexPositions()) {
          Vec3 tv = trans.times(v);
          this.vertices.add(tv);
          double[] vec = new double[3];
          vec[0] = tv.x;
          vec[1] = tv.y;
          vec[2] = tv.z;
          this.glu.gluTessVertex(tobj, vec, 0, counter++);
        }
      }
      this.glu.gluTessEndContour(tobj);
    }
    this.glu.gluTessEndPolygon(tobj);

    int[][] faces = new int[this.indices.size()/3][3];
    int i = 0;
    for (Integer idx : this.indices) {
      faces[i/3][i%3] = idx.intValue();
      i++;
    }
    Vec3[] vec3s = new Vec3[this.vertices.size()];
    TriangleMesh mesh = new TriangleMesh(this.vertices.toArray(vec3s), faces);
    ObjectInfo newinfo = new ObjectInfo(mesh, new CoordinateSystem(), "dummy");
    newinfo.setTexture(this.ctx.scene.getDefaultTexture(), this.ctx.scene.getDefaultTexture().getDefaultMapping(mesh));
    this.results.add(newinfo);
    
    return this.results;
  }
  
  void tesselate() {
    
  }

  public void begin(int type)
  {
    if (type != GL.GL_TRIANGLES) {
      String typestr;
      switch (type) {
      case GL.GL_TRIANGLE_FAN:
        typestr = "TRIANGLE_FAN";
        break;
      case GL.GL_TRIANGLE_STRIP:
        typestr = "TRIANGLE_STRIP";
        break;
      case GL.GL_TRIANGLES:
        typestr = "TRIANGLES";
        break;
      default:
        typestr = "<unknown>";
      break;
      }
      System.out.println("tessel.begin(): " + typestr);
    }
  }

  public void end()
  {
//    System.out.println("tessel.end()");
  }

  public void vertex(Object vertexData)
  {
    this.indices.add((Integer)vertexData);
  }

  public void vertexData(Object vertexData, Object polygonData)
  {
    System.out.println("tessel.vertexData()");
  }

  /*
   * combineCallback is used to create a new vertex when edges intersect.
   * coordinate location is trivial to calculate, but weight[4] may be used to
   * average color, normal, or texture coordinate data. In this program, color
   * is weighted.
   */
  public void combine(double[] coords, Object[] data, float[] weight, Object[] outData)
  {
    Vec3 newvertex = new Vec3(coords[0], coords[1], coords[2]);
    this.vertices.add(newvertex);
    Integer newidx = new Integer(this.vertices.size() - 1);
    outData[0] = newidx;
  }

  public void combineData(double[] coords, Object[] data, //
      float[] weight, Object[] outData, Object polygonData)
  {
    System.out.println("tessel.combineData()");
  }

  public void error(int errnum)
  {
    String estring;

    estring = this.glu.gluErrorString(errnum);
    System.err.println("Tessellation Error: " + estring);
    System.exit(0);
  }

  public void beginData(int type, Object polygonData)
  {
    System.out.println("tessel.beginData()");

  }

  public void endData(Object polygonData)
  {
    System.out.println("tessel.endData()");
  }

  public void edgeFlag(boolean boundaryEdge)
  {
  }

  public void edgeFlagData(boolean boundaryEdge, Object polygonData)
  {
    System.out.println("tessel.edgeFlagData()");
  }

  public void errorData(int errnum, Object polygonData)
  {
    System.out.println("tessel.errorData()");
  }
}
