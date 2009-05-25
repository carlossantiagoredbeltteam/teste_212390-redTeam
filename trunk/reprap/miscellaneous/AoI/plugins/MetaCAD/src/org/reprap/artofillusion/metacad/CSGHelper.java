package org.reprap.artofillusion.metacad;

import java.util.Iterator;

import artofillusion.animation.PositionTrack;
import artofillusion.animation.RotationTrack;
import artofillusion.math.CoordinateSystem;
import artofillusion.math.Vec3;
import artofillusion.object.CSGObject;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;

/**
 *  Allows easy boolean modeling of multiple objects 
 *
 */
public class CSGHelper {
  int operation;
  ObjectInfo sumInfo;

  public CSGHelper(int op) {
    this.operation = op;
  }
  
  static public ObjectInfo combine(Iterator<ObjectInfo> iter, int op) {
    CSGHelper helper = new CSGHelper(op);
    helper.addAll(iter);
    return helper.GetObjectInfo();
  }
  
  public void addAll(Iterator<ObjectInfo> iter) {
    while (iter.hasNext()) {
      Add(iter.next());
    }
  }
  
  public void Add(ObjectInfo obj) {
    if (this.sumInfo == null) {
      this.sumInfo = obj;
    }
    else {
      CSGObject csg = new CSGObject(this.sumInfo, obj, this.operation);
      Vec3 center = csg.centerObjects();
      this.sumInfo = new ObjectInfo(csg, new CoordinateSystem(center, Vec3.vz(), Vec3.vy()), "tmp");
    }
  }

  public ObjectInfo GetObjectInfo() {
    return this.sumInfo;
  }

  public Object3D GetObject() {
    if (this.sumInfo != null) return this.sumInfo.object;
    return null;
  }
}
