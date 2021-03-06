/*
 * Import geometry information from a .DXF file
 */

package org.reprap.artofillusion.metacad.translators;

import java.awt.Color;
import java.awt.Frame;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.LinkedList;
import java.util.List;
import java.util.Vector;

import artofillusion.ArtOfIllusion;
import artofillusion.ModellingApp;
import artofillusion.Scene;
import artofillusion.animation.PositionTrack;
import artofillusion.animation.RotationTrack;
import artofillusion.math.CoordinateSystem;
import artofillusion.math.RGBColor;
import artofillusion.math.Vec3;
import artofillusion.object.Curve;
import artofillusion.object.DirectionalLight;
import artofillusion.object.Mesh;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;
import artofillusion.object.SceneCamera;
import artofillusion.object.TriangleMesh;
import artofillusion.texture.Texture;
import artofillusion.texture.UniformTexture;
import artofillusion.ui.Translate;
import buoy.widget.BFileChooser;
import buoy.widget.BStandardDialog;

import com.ysystems.ycad.lib.ydxf.YdxfGet;
import com.ysystems.ycad.lib.ydxf.YdxfGetBuffer;
import com.ysystems.ycad.lib.yxxf.Yxxf;
import com.ysystems.ycad.lib.yxxf.YxxfEnt;
import com.ysystems.ycad.lib.yxxf.YxxfEnt3Dface;
import com.ysystems.ycad.lib.yxxf.YxxfEntArc;
import com.ysystems.ycad.lib.yxxf.YxxfEntBlock;
import com.ysystems.ycad.lib.yxxf.YxxfEntCircle;
import com.ysystems.ycad.lib.yxxf.YxxfEntHeader;
import com.ysystems.ycad.lib.yxxf.YxxfEntInsert;
import com.ysystems.ycad.lib.yxxf.YxxfEntLine;
import com.ysystems.ycad.lib.yxxf.YxxfEntLwpolyline;
import com.ysystems.ycad.lib.yxxf.YxxfEntPolyline;
import com.ysystems.ycad.lib.yxxf.YxxfEntVertex;
import com.ysystems.ycad.lib.yxxf.YxxfGfxContext;
import com.ysystems.ycad.lib.yxxf.YxxfGfxMatrix;
import com.ysystems.ycad.lib.yxxf.YxxfGfxPointW;
import com.ysystems.ycad.lib.yxxf.YxxfTblLayer;


class DXFLayer {
  public Vector<int[]> faces;
  public Vector<Vec3> vertices;
  public Vector<Vec3[]> polylines;
  
  public DXFLayer() {
    this.faces = new Vector<int[]>();
    this.vertices = new Vector<Vec3>();
    this.polylines = new Vector<Vec3[]>();
  }
};

/**
 * @see artofillusion.translators.DXFImporter
 * @author klynn
 */
public class DXFImporter {

  /**
   * AOI Scene into which we import
   */
  private static Scene theScene = null;
  private static boolean appendFlag = false;
  private static boolean debug = false;
  
  Frame parent;
  Boolean enableMeshRepair;
  Hashtable<YxxfTblLayer, DXFLayer> layers;
  YxxfGfxContext gc;
  List<ObjectInfo> importedobjects;
  Scene scene;
  
  public DXFImporter(Scene scene, Frame parent, Boolean enableMeshRepair) {
    this.parent = parent;
    this.enableMeshRepair = enableMeshRepair;
    this.gc = new YxxfGfxContext();
    this.layers = new Hashtable<YxxfTblLayer, DXFLayer>();
    this.importedobjects = new LinkedList<ObjectInfo>();
    this.scene = scene;
  }
  
  public static List<ObjectInfo> importFile(Scene scene, String filename, boolean enableMeshRepair) throws Exception {

    File f = new File(filename);

    String objName = f.getName();
    if (objName.lastIndexOf('.') > 0) objName = objName.substring(0, objName.lastIndexOf('.'));
    if (debug) System.out.println("Object name: " + objName);
    
    // open file:
    BufferedInputStream in = null;
    try {
      // read file using ycad lib:
      in = new BufferedInputStream(new FileInputStream(f));
      Yxxf drawing = new Yxxf();
      YdxfGetBuffer buffer = new YdxfGetBuffer();
      int type = YdxfGetBuffer.GET_TYPE_MAIN; // drawing (versus font) get this
      // from file somehow?
      buffer.setInput(type, in, drawing);
      YdxfGet.get(buffer);
      drawing = buffer.getDrawing();
      String blockName = drawing.secEntities.insMSpace.block.getBlockname2();
      if (debug) System.out.println("blockName: [" + blockName + "]");

      DXFImporter importer = new DXFImporter(scene, null, enableMeshRepair);
      for (int nextToDraw = 0;;) {
        YxxfEnt ent = (YxxfEnt) drawing.secEntities.insMSpace.block.nextEntity(nextToDraw);
        if (!(ent instanceof YxxfEntHeader)) break;
        importer.addEntity((YxxfEntHeader)ent);
        nextToDraw++;
      }
      Boolean geometryfound = false;
      Enumeration<YxxfTblLayer> keys = importer.layers.keys();
      while (keys.hasMoreElements()) {
        YxxfTblLayer layer = keys.nextElement();
        DXFLayer mylayer = importer.layers.get(layer);
        Color col = importer.gc.getPalette().jcolorarr[layer.aci];
        if (importer.createMesh(mylayer, objName, col) != null) geometryfound = true;
        if (importer.createCurve(mylayer, objName)) geometryfound = true;
      }
      if (!geometryfound) {
        throw new Exception("Import of file: \"" + f + "\" failed. No supported geometry found.");
      }
      return importer.importedobjects;
    } catch (Exception ex) {
      throw ex;
    } finally {
      try {
        in.close();
      } catch (Exception ex2) {
        throw new Exception("Unable to close file: \"" + f + "\"." + ex2.getMessage());
      }
    }
  }
  
  /**
   * fetch DXF
   * 
   * @param parent
   *          Frame Parent GUI frame
   * @param inScene
   *          Scene Scene to append to
   */
  public static void importFile(Frame parent) {
    
    String dir = "";
    if (ArtOfIllusion.getCurrentDirectory() != null) dir= ArtOfIllusion.getCurrentDirectory();
    BFileChooser fc = new BFileChooser(BFileChooser.OPEN_FILE, Translate.text("importFile"), new File(dir));
    if (!fc.showDialog(null)) return;

    File f = fc.getSelectedFile();
    String filename = f.getPath();
    ArtOfIllusion.setCurrentDirectory(fc.getDirectory().getPath());

    // ask user to enable/disable mesh repair tools:
    BStandardDialog dlg = new BStandardDialog("", "WARNING: This option can be extremely slow!",
                                              BStandardDialog.QUESTION);
    String[] choices = new String[] { "Mesh Repair ON", "Mesh Repair OFF", "Cancel" };
    int choice = dlg.showOptionDialog(null, choices, choices[1]);
    boolean enableMeshRepair = false;
    if (choice == 0) enableMeshRepair = true;
    if (choice == 2) return;

    // create an AOI Scene to add objects to:
    if (theScene == null) {
      theScene = new Scene();
      CoordinateSystem coords = new CoordinateSystem(
          new Vec3(0.0, 0.0, ModellingApp.DIST_TO_SCREEN), new Vec3(0.0, 0.0, -1.0), Vec3.vy());
      ObjectInfo info = new ObjectInfo(new SceneCamera(), coords, "Camera 1");
      info.addTrack(new PositionTrack(info), 0);
      info.addTrack(new RotationTrack(info), 1);
      theScene.addObject(info, null);
      info = new ObjectInfo(new DirectionalLight(new RGBColor(1.0f, 1.0f, 1.0f), 0.8f), coords
          .duplicate(), "Light 1");
      info.addTrack(new PositionTrack(info), 0);
      info.addTrack(new RotationTrack(info), 1);
      theScene.addObject(info, null);
    }

    List<ObjectInfo> importedobjects;
    try {
      importedobjects = importFile(theScene, filename, enableMeshRepair);
      addObjects(importedobjects);
    } catch (Exception e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    
    if (!appendFlag) ArtOfIllusion.newWindow(theScene);
    return;
  }

  private void createObjectInfo(String objName, Object3D obj3d, Color col) {
    Texture tex;
    if (col != null) {
      tex = new UniformTexture();
      ((UniformTexture)tex).diffuseColor.setRGB(col.getRed(), col.getGreen(), col.getBlue());
    }
    else {
      tex = this.scene.getDefaultTexture();
    }
    ObjectInfo info = new ObjectInfo(obj3d, new CoordinateSystem(), objName);
    info.setTexture(tex, tex.getDefaultMapping(obj3d));
    info.addTrack(new PositionTrack(info), 0);
    info.addTrack(new RotationTrack(info), 1);
    this.importedobjects.add(info);
  }
  
  private static void addObjects(List<ObjectInfo> objects)
  {
    for (ObjectInfo info : objects) {
      theScene.addObject(info, null);
    }
  }

  private Boolean createCurve(DXFLayer mylayer, String objName) {
    for (int i=0;i<mylayer.polylines.size();i++) {
      Vec3[] verts = mylayer.polylines.get(i);
      float smoothness[] = new float[verts.length];
      Arrays.fill(smoothness, 0.0f);
      Curve curve = new Curve(verts, smoothness, Mesh.NO_SMOOTHING, false);
      createObjectInfo(objName + "_curve" + i, curve, null);
    }
    if (mylayer.polylines.size() > 0) return true;
    else return false;
  }

  private TriangleMesh createMesh(DXFLayer mylayer, String objName, Color col) {
    int numVerts = mylayer.vertices.size();
    if (numVerts == 0) return null;
    // construct AOI scene:
    double min[] = new double[] { Double.MAX_VALUE, Double.MAX_VALUE, Double.MAX_VALUE };
    double max[] = new double[] { -Double.MAX_VALUE, -Double.MAX_VALUE, -Double.MAX_VALUE };

    // vertices:
    Vec3 vert[] = new Vec3[numVerts], center = new Vec3();
    for (int i = 0; i < numVerts; i++) {
      vert[i] = mylayer.vertices.elementAt(i);

      // new min?
      if (vert[i].x < min[0]) min[0] = vert[i].x;
      if (vert[i].y < min[1]) min[1] = vert[i].y;
      if (vert[i].z < min[2]) min[2] = vert[i].z;

      // new max?
      if (vert[i].x > max[0]) max[0] = vert[i].x;
      if (vert[i].y > max[1]) max[1] = vert[i].y;
      if (vert[i].z > max[2]) max[2] = vert[i].z;

      center.add(vert[i]);
    }

    // faces:
    int fc[][] = new int[mylayer.faces.size()][];
    for (int j = 0; j < mylayer.faces.size(); j++)
      fc[j] = mylayer.faces.elementAt(j);
    if (debug) System.out.println("numVerts=" + numVerts);
    if (debug) System.out.println("numFaces=" + mylayer.faces.size());

    // scale mesh:
    double maxSize = Math.max(Math.max(max[0] - min[0], max[1] - min[1]), max[2] - min[2]);
    double scale = Math.pow(10.0, -Math.floor(Math.log(maxSize) / Math.log(10.0)));
    for (int i = 0; i < vert.length; i++)
      ((Vec3) vert[i]).scale(scale);

    // center mesh:
    center.scale(1.0 / vert.length);
    for (int i = 0; i < vert.length; i++)
      vert[i] = vert[i].minus(center);
    if (debug) System.out.println("CENTER: " + center);

    if (vert.length > 0) {
      // merge duplicate points:
      MeshTools mutil = new MeshTools(this.parent);
      vert = mutil.mergePoints(vert, fc);

      // attempt to fix normals (SLOW!):
      if (this.enableMeshRepair) mutil.fixCirality(fc);

      TriangleMesh mesh = new TriangleMesh(vert, fc);
      createObjectInfo(objName, mesh, col);
      return mesh;
    }
    return null;
  }

  /**
   * fetch DXF, append to specified scene
   * 
   * @param parent
   *          Frame Parent GUI frame
   * @param inScene
   *          Scene Scene to append to
   */
  public static void importFile(Frame parent, Scene inScene) {
    if (inScene != null) {
      theScene = inScene;
      appendFlag = true;
    }
    importFile(parent);
  }

  /**
   * Try to add the entity to the faces and vertices lists
   * 
   * @param
   * @return
   */
  private void addEntity(YxxfEntHeader ent) {
    YxxfGfxMatrix m = new YxxfGfxMatrix();
    m.mtxSetIdentity();
    addEntity(ent, m);
  }
  
  private void addEntity(YxxfEntHeader ent, YxxfGfxMatrix mat) {
    YxxfTblLayer layer = ent.hdr_layer;
    int colorindex = layer.aci;
    if (colorindex < 0) return;
    DXFLayer mylayer = this.layers.get(layer);
    if (mylayer == null) {
      mylayer = new DXFLayer();
      this.layers.put(layer, mylayer);
    }
    
    if (ent instanceof YxxfEnt3Dface) {
      // if (debug) System.out.println("Found a 3DFace");
      YxxfEnt3Dface f = (YxxfEnt3Dface) ent;
      YxxfGfxPointW pt1 = f.pnt1;
      YxxfGfxPointW pt2 = f.pnt2;
      YxxfGfxPointW pt3 = f.pnt3;
      YxxfGfxPointW pt4 = f.pnt4;
      // if (debug) System.out.println("pt1: " + pt1.x + ", " + pt1.y + ", " +
      // pt1.z);
      // if (debug) System.out.println("pt2: " + pt2.x + ", " + pt2.y + ", " +
      // pt2.z);
      // if (debug) System.out.println("pt3: " + pt3.x + ", " + pt3.y + ", " +
      // pt3.z);
      // if (debug) System.out.println("pt4: " + pt4.x + ", " + pt4.y + ", " +
      // pt4.z);
      mylayer.vertices.add(new Vec3(pt1.x, pt1.y, pt1.z));
      mylayer.vertices.add(new Vec3(pt2.x, pt2.y, pt2.z));
      mylayer.vertices.add(new Vec3(pt3.x, pt3.y, pt3.z));
      if (pt3.x == pt4.x && pt3.y == pt4.y && pt3.z == pt4.z) {
        // 1 face
        mylayer.faces.add(new int[] { mylayer.vertices.size() - 1, mylayer.vertices.size() - 2, mylayer.vertices.size() - 3 });
      }
      else {
        // 2 faces
        mylayer.vertices.add(new Vec3(pt4.x, pt4.y, pt4.z));
        mylayer.faces.add(new int[] { mylayer.vertices.size() - 1, mylayer.vertices.size() - 2, mylayer.vertices.size() - 3 });
        mylayer.faces.add(new int[] { mylayer.vertices.size() - 1, mylayer.vertices.size() - 3, mylayer.vertices.size() - 4 });
      }
    }
    else if (ent instanceof YxxfEntArc) {
      YxxfEntArc a = (YxxfEntArc) ent;
      if (debug) {
        System.out.printf("Found an Arc: c=%.2f,%.2f,%.2f r=%.2f start=%.2f end=%.2f\n",
                          a.center.x,a.center.y,a.center.z,a.radius,a.entbegang,a.entendang);
        
      }
      Vec3[] coords = createArc(mat, a.center, a.radius, a.entbegang, a.entendang);
      mylayer.polylines.add(coords);
    }
    else if (ent instanceof YxxfEntCircle) {
      YxxfEntCircle c = (YxxfEntCircle)ent;
      Vec3[] coords = createArc(mat, c.center, c.radius, 0, 360);
      mylayer.polylines.add(coords);
    }
    else if (ent instanceof YxxfEntLine) {
      if (debug) System.out.println("Found an Line");
      YxxfEntLine l = (YxxfEntLine)ent;
      Vec3[] polyline = new Vec3[2];
      YxxfGfxPointW p = mat.mtxTransformPoint(new YxxfGfxPointW(l.begpnt));
      polyline[0] = new Vec3(p.x, p.y, p.z);
      p = mat.mtxTransformPoint(new YxxfGfxPointW(l.endpnt));
      polyline[1] = new Vec3(p.x, p.y, p.z); 
      mylayer.polylines.add(polyline);
    }
    else if (ent instanceof YxxfEntLwpolyline) {
      YxxfEntPolyline pl = (YxxfEntPolyline)((YxxfEntLwpolyline)ent).pline;
      Vec3[] polyline = new Vec3[pl.vtxEntities.size()];
      for (int i=0;i<pl.vtxEntities.size();i++) {
        YxxfGfxPointW p = mat.mtxTransformPoint(new YxxfGfxPointW(((YxxfEntVertex)pl.vtxEntities.get(i)).pnt));
        polyline[i] = new Vec3(p.x, p.y, p.z);
      }
      mylayer.polylines.add(polyline);
    }
    else if (ent instanceof YxxfEntInsert) {
      YxxfEntInsert e = (YxxfEntInsert) ent;
      if (debug) System.out.printf("Insert: %.2f,%.2f,%.2f\n",
                                   e.inspnt.x, e.inspnt.y, e.inspnt.z);
      YxxfEntBlock blk = (YxxfEntBlock)e.block;
      for (int nextToDraw = 0;;) {
        YxxfEnt ent2 = (YxxfEnt)blk.nextEntity(nextToDraw);
        if (!(ent2 instanceof YxxfEntHeader)) break;
        YxxfGfxMatrix m = new YxxfGfxMatrix(e.M_insert);
        m.mtxTranslate(e.inspnt);
        addEntity((YxxfEntHeader)ent2, m);
        nextToDraw++;
      }
    }
    
    else System.out.println("Skipping unknown/unsupported entity: " + ent.getClass().getName());

    return;
  }

  private Vec3[] createArc(YxxfGfxMatrix mat,
                           YxxfGfxPointW center, double radius, double startang, double endang) {
    int num = 16; // FIXME: Calculate a suitable # of segments
    double sweepang = (endang - startang)*Math.PI/180;
    while (sweepang < 0) sweepang += Math.PI*2;
    double delta = sweepang/num;
    double angle = startang*Math.PI/180;
    Vec3[] coords = new Vec3[num+1]; 
    for (int i = 0; i <= num; i++) {
      YxxfGfxPointW p = mat.mtxTransformPoint(new YxxfGfxPointW(center.x + Math.cos(angle) * radius, 
                                                                center.y + Math.sin(angle) * radius, 
                                                                center.z));
      coords[i] = new Vec3(p.x, p.y, p.z);
      angle += delta;
    }
    return coords;
  }
}
