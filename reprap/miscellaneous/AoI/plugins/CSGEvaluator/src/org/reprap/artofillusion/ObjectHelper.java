package org.reprap.artofillusion;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import artofillusion.MeshViewer;
import artofillusion.math.CoordinateSystem;
import artofillusion.math.Mat4;
import artofillusion.math.Vec3;
import artofillusion.object.Cube;
import artofillusion.object.MeshVertex;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;
import artofillusion.object.TriangleMesh;
import artofillusion.object.TriangleMesh.Edge;
import artofillusion.object.TriangleMesh.Face;
import artofillusion.object.TriangleMesh.Vertex;

public class ObjectHelper {
  public static ObjectInfo getErrorObject()
  {
    Cube errorObj = new Cube(10,10,10);  
    
    return new ObjectInfo(errorObj, new CoordinateSystem(), "dummy");
  }
  
  public static TriangleMesh applyCS(ObjectInfo obj, double tol)
  {
    TriangleMesh mesh;
    
    if (obj.object.getClass() != TriangleMesh.class)
      mesh = obj.object.convertToTriangleMesh(tol);
    else
      mesh = (TriangleMesh)obj.object.duplicate();
    
    MeshVertex[] v = mesh.getVertices();
    Mat4 trans = obj.coords.fromLocal();
    for (int i=0; i < v.length; i++)
    {
      trans.transform(v[i].r);
    }
    
    return mesh;
  }
  
  public static ObjectInfo join(List <ObjectInfo> objects, double tol)
  {
    int n = objects.size();
    TriangleMesh[] meshes = new TriangleMesh[n];
    
    // get number of vertices/faces in joined mesh
    int vtot = 0;
    int ftot = 0;
    int etot = 0;
    int[] numV = new int[n];
    
    for (int i = 0; i < n; i++)
    {
      TriangleMesh mesh = ObjectHelper.applyCS(objects.get(i), tol);
      meshes[i] = mesh;
      
      MeshVertex[] v = mesh.getVertices();
      Face[] f = mesh.getFaces();
      Edge[] e = mesh.getEdges();
      
      numV[i] = v.length;  // number of vertices in each object
      vtot += v.length;   // total number of vertices in resulting mesh
      ftot += f.length;  // total number of faces in resulting mesh
      etot += e.length;
    }
    
    //
    Vec3[] va = new Vec3[vtot];   // create an array to hold the new mesh vertex coordinates
    float[] vs = new float[vtot];  // create an array to hold the new mesh vertex Smoothness values
    float[] es = new float[etot];  // create an array to hold the new mesh edge Smoothness values
    int[][] fc = new int[ftot][3];  // create an array to hold the new mesh face data
    
    int count=0;
    int ecount=0;
    int fcount=0;
    int disp=0;
    
    // cycle through the selected objects
    for (int i = 0; i < n; i++)
    {
      // get vertex information and put into array for new mesh 
      MeshVertex[] v = meshes[i].getVertices();
      
      for (int j = 0; j < v.length; j++)
      {
              va[count] = v[j].r;
              vs[count] = ((Vertex)v[j]).smoothness;
              count++;
      }
      
      // get edge smoothness values and put into array for new mesh
      Edge[] e = meshes[i].getEdges();
      for (int k = 0; k < e.length; k++)
      {
              es[ecount]=e[k].smoothness;
              ecount++;
      }
       // get face information and put into array for new mesh 
      Face[] f=meshes[i].getFaces();
      for (int j = 0; j < f.length; j++)
      {
              fc[fcount][0]=f[j].v1+disp;
              fc[fcount][1]=f[j].v2+disp;
              fc[fcount][2]=f[j].v3+disp;
              fcount++;
      }
      disp = disp + numV[i];
    }
    
    TriangleMesh newMesh=new TriangleMesh(va,fc);
    newMesh.setSmoothingMethod(TriangleMesh.NO_SMOOTHING);
    
    // put original smoothness values back
    MeshVertex[] newVerts = newMesh.getVertices();
    for (int i = 0; i < newVerts.length; i++)
    {
            ((Vertex)newVerts[i]).smoothness=vs[i];
    }
    
    Edge[] newEdges=newMesh.getEdges();
    for (int i = 0; i < newEdges.length; i++)
    {
            newEdges[i].smoothness=es[i];
    }
    
    return new ObjectInfo(newMesh, new CoordinateSystem(), "dummy");
  }
}
