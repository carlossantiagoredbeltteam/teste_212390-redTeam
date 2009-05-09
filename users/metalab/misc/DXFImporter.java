/*
 * Import geometry information from a .DXF file
 */

package klynn.aoi.translators;

import klynn.aoi.util.*;

import artofillusion.*;
import artofillusion.object.*;
import artofillusion.animation.*;
import artofillusion.math.*;

import java.awt.*;
import java.io.*;
import java.util.*;

import com.ysystems.ycad.lib.ydxf.*;
import com.ysystems.ycad.lib.yxxf.*;

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
  private static boolean debug = true;
  
  Frame parent;
  Boolean enableMeshRepair;
  Vector<int[]> faces;
  Vector<Vec3> vertices;
  Vector<Vec3[]> polylines;
  
  public DXFImporter(Frame parent, Boolean enableMeshRepair) {
    this.parent = parent;
    this.enableMeshRepair = enableMeshRepair;
    this.faces = new Vector<int[]>();
    this.vertices = new Vector<Vec3>();
    this.polylines = new Vector<Vec3[]>();
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
    // input file setup:
    FileDialog fd = new FileDialog(parent, "Import DXF File", FileDialog.LOAD);
    File f;
    if (ModellingApp.currentDirectory != null) fd.setDirectory(ModellingApp.currentDirectory);
    fd.show();
    if (fd.getFile() == null) return;
    f = new File(fd.getDirectory(), fd.getFile());
    ModellingApp.currentDirectory = fd.getDirectory();
    String objName = fd.getFile();
    if (objName.lastIndexOf('.') > 0) objName = objName.substring(0, objName.lastIndexOf('.'));
    if (debug) System.out.println("Object name: " + objName);

    // ask user to enable/disable mesh repair tools:
    String msgText = "WARNING: This option can be extremely slow!";
    AWTMessageDialog dialog = new AWTMessageDialog(parent, msgText, new String[] {
        " Mesh Repair ON ", " Mesh Repair OFF ", " Cancel " });
    int choice = dialog.getChoice();
    boolean enableMeshRepair = false;
    if (choice == 0) enableMeshRepair = true;
    if (choice == 2) return;
    dialog.dispose();

    ProgressDialog pdialog = null;
    /*
     * KEVIN threading is backwards! This won't work pdialog = new
     * ProgressDialog(parent, 100, "Importing...");
     * pdialog.setPriority(Thread.MAX_PRIORITY); pdialog.start();
     */

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

    // open file:
    BufferedInputStream in = null;
    String line = null;
    String formName = null;
    try {
      // read file using ycad lib:
      in = new BufferedInputStream(new FileInputStream(f));
      java.util.Vector faces = new java.util.Vector();
      Yxxf drawing = new Yxxf();
      YdxfGetBuffer buffer = new YdxfGetBuffer();
      int type = YdxfGetBuffer.GET_TYPE_MAIN; // drawing (versus font) get this
      // from file somehow?
      buffer.setInput(type, in, drawing);
      YdxfGet.get(buffer);
      drawing = buffer.getDrawing();
      String blockName = drawing.secEntities.insMSpace.block.getBlockname2();
      if (debug) System.out.println("blockName: [" + blockName + "]");

      DXFImporter importer = new DXFImporter(parent, enableMeshRepair);
      for (int nextToDraw = 0;;) {
        YxxfEnt ent = (YxxfEnt) drawing.secEntities.insMSpace.block.nextEntity(nextToDraw);
        if (ent == null) break;
        importer.addEntity(ent);
        nextToDraw++;
      }
      
      TriangleMesh mesh = importer.createMesh(objName);
      Boolean curvesfound = importer.createCurve(objName);
      if (mesh == null && !curvesfound) {
        new AWTMessageDialog(parent, new String[] { "Import of file: [" + f +
        "] failed. No supported geometry found." });
      }
      
    } catch (Exception ex) {
      new AWTMessageDialog(parent, new String[] {
          "Import of file: [" + f + "] failed with exception:", ex.getMessage() });
      return;
    } finally {
      try {
        in.close();
      } catch (Exception ex2) {
        new AWTMessageDialog(parent, new String[] { "Unable to close file: [" + f + "]. ",
            ex2.getMessage() });
      }
    }
    if (!appendFlag) ModellingApp.newWindow(theScene);
    return;
  }

  private Boolean createCurve(String objName) {
    for (int i=0;i<this.polylines.size();i++) {
      Vec3[] verts = this.polylines.get(i);
      float smoothness[] = new float[verts.length];
      Arrays.fill(smoothness, 0.0f);
      Curve curve = new Curve(verts, smoothness, Mesh.NO_SMOOTHING, false);
      ObjectInfo info = new ObjectInfo(curve, new CoordinateSystem(), objName + "_curve" + i);
      info.setTexture(theScene.getDefaultTexture(), theScene.getDefaultTexture().getDefaultMapping(curve));
      info.addTrack(new PositionTrack(info), 0);
      info.addTrack(new RotationTrack(info), 1);
      theScene.addObject(info, null);
    }
    if (this.polylines.size() > 0) return true;
    else return false;
  }

  private TriangleMesh createMesh(String objName) {
    int numVerts = this.vertices.size();
    if (numVerts == 0) return null;
    // construct AOI scene:
    double min[] = new double[] { Double.MAX_VALUE, Double.MAX_VALUE, Double.MAX_VALUE };
    double max[] = new double[] { -Double.MAX_VALUE, -Double.MAX_VALUE, -Double.MAX_VALUE };

    // vertices:
    Vec3 vert[] = new Vec3[numVerts], center = new Vec3();
    for (int i = 0; i < numVerts; i++) {
      vert[i] = this.vertices.elementAt(i);

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
    int fc[][] = new int[this.faces.size()][];
    for (int j = 0; j < this.faces.size(); j++)
      fc[j] = this.faces.elementAt(j);
    if (debug) System.out.println("numVerts=" + numVerts);
    if (debug) System.out.println("numFaces=" + this.faces.size());

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

      // add to scene:
      CoordinateSystem coords = new CoordinateSystem(center, Vec3.vz(), Vec3.vy());
      // coords.setOrientation(270, 0, 0);
      TriangleMesh mesh = new TriangleMesh(vert, fc);
      ObjectInfo info = new ObjectInfo(mesh, coords, objName);
      info.setTexture(theScene.getDefaultTexture(), theScene.getDefaultTexture()
          .getDefaultMapping(mesh));
      info.addTrack(new PositionTrack(info), 0);
      info.addTrack(new RotationTrack(info), 1);
      theScene.addObject(info, null);
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
  private void addEntity(YxxfEnt ent) {
    YxxfGfxMatrix m = new YxxfGfxMatrix();
    m.mtxSetIdentity();
    addEntity(ent, m);
  }
  
  private void addEntity(YxxfEnt ent, YxxfGfxMatrix mat) {
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
      this.vertices.add(new Vec3(pt1.x, pt1.y, pt1.z));
      this.vertices.add(new Vec3(pt2.x, pt2.y, pt2.z));
      this.vertices.add(new Vec3(pt3.x, pt3.y, pt3.z));
      if (pt3.x == pt4.x && pt3.y == pt4.y && pt3.z == pt4.z) {
        // 1 face
        this.faces.add(new int[] { this.vertices.size() - 1, this.vertices.size() - 2, this.vertices.size() - 3 });
      }
      else {
        // 2 faces
        this.vertices.add(new Vec3(pt4.x, pt4.y, pt4.z));
        this.faces.add(new int[] { this.vertices.size() - 1, this.vertices.size() - 2, this.vertices.size() - 3 });
        this.faces.add(new int[] { this.vertices.size() - 1, this.vertices.size() - 3, this.vertices.size() - 4 });
      }
    }
    else if (ent instanceof YxxfEntArc) {
      YxxfEntArc a = (YxxfEntArc) ent;
      if (debug) {
        System.out.printf("Found an Arc: c=%.2f,%.2f,%.2f r=%.2f start=%.2f end=%.2f\n",
                          a.center.x,a.center.y,a.center.z,a.radius,a.entbegang,a.entendang);
        
      }
      Vec3[] coords = createArc(mat, a.center, a.radius, a.entbegang, a.entendang);
      this.polylines.add(coords);
    }
    else if (ent instanceof YxxfEntCircle) {
      YxxfEntCircle c = (YxxfEntCircle)ent;
      Vec3[] coords = createArc(mat, c.center, c.radius, 0, 360);
      this.polylines.add(coords);
    }
    else if (ent instanceof YxxfEntInsert) {
      YxxfEntInsert e = (YxxfEntInsert) ent;
      if (debug) System.out.printf("Insert: %.2f,%.2f,%.2f\n",
                                   e.inspnt.x, e.inspnt.y, e.inspnt.z);
      YxxfEntBlock blk = (YxxfEntBlock)e.block;
      for (int nextToDraw = 0;;) {
        YxxfEnt ent2 = (YxxfEnt)blk.nextEntity(nextToDraw);
        if (ent2 == null) break;
        addEntity(ent2, e.M_insert);
        nextToDraw++;
      }
    }
    else if (ent instanceof YxxfEntLine) {
      if (debug) System.out.println("Found an Line");
      YxxfEntLine l = (YxxfEntLine)ent;
      Vec3[] polyline = new Vec3[2];
      YxxfGfxPointW p = mat.mtxTransformPoint(l.begpnt);
      polyline[0] = new Vec3(p.x, p.y, p.z);
      p = mat.mtxTransformPoint(l.begpnt);
      polyline[1] = new Vec3(p.x, p.y, p.z); 
      this.polylines.add(polyline);
    }
    else if (ent instanceof YxxfEntLwpolyline) {
      YxxfEntPolyline pl = (YxxfEntPolyline)((YxxfEntLwpolyline)ent).pline;
      Vec3[] polyline = new Vec3[pl.vtxEntities.size()];
      for (int i=0;i<pl.vtxEntities.size();i++) {
        YxxfGfxPointW p = mat.mtxTransformPoint(((YxxfEntVertex) pl.vtxEntities.get(i)).pnt);
        polyline[i] = new Vec3(p.x, p.y, p.z);
      }
      this.polylines.add(polyline);
    }
    
    else System.out.println("Skipping unknown/unsupported entity: " + ent.getClass().getName());

    return;
  }

  private Vec3[] createArc(YxxfGfxMatrix mat,
                           YxxfGfxPointW center, double radius, double startang, double endang) {
    int num = 8; // FIXME: Calculate a suitable # of segments
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

  /**
   * Separate a line into pieces divided by whitespace.
   * 
   * @param line
   *          an input String
   * @return String[] array of tokens
   */
  private static String[] splitLine(String line) {
    StringTokenizer st = new StringTokenizer(line);
    Vector v = new Vector();

    while (st.hasMoreTokens())
      v.addElement(st.nextToken());
    String result[] = new String[v.size()];
    v.copyInto(result);
    return result;
  }
}
