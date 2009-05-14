package org.reprap.artofillusion.metacad;

import java.util.Iterator;

import artofillusion.math.CoordinateSystem;
import artofillusion.object.CSGObject;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;

/**
 *  Allows easy boolean modeling of multiple objects 
 *
 */
public class CSGHelper {
  int count;
  int operation;
  ObjectInfo buffer;
  CSGObject sum;
  ObjectInfo sumInfo;

  public CSGHelper(int op) {
    this.operation = op;
    this.count = 0;
    this.sum = null;
    this.buffer = null;
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
    if (this.count == 0) {
      this.buffer = obj;
    }
    else {
      if (this.sum == null) {
        this.sum = new CSGObject(this.buffer, obj, this.operation);
        this.sumInfo = new ObjectInfo(this.sum, new CoordinateSystem(), "tmp");
      } else {
        this.sum = new CSGObject(this.sumInfo, obj, this.operation);
        this.sumInfo = new ObjectInfo(this.sum, new CoordinateSystem(), "tmp");
      }
    }
    this.count++;
  }

  public ObjectInfo GetObjectInfo() {
    if (this.count == 0) return null;
    if (this.count == 1) return this.buffer;

    return this.sumInfo;
  }

  public Object3D GetObject() {
    if (this.count == 0) return null;
    if (this.count == 1) return this.buffer.object;

    return this.sum;
  }

}
