package org.reprap.artofillusion;

import artofillusion.math.CoordinateSystem;
import artofillusion.object.CSGObject;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;

// Allows easy boolean modelling of multiple objects 
// takes 
public class CSGHelper {
	int count;
	int operation;
	ObjectInfo buffer;
	CSGObject sum;
	ObjectInfo sumInfo;

	public CSGHelper(int op) {
		operation = op;
		count = 0;
		sum = null;
		buffer = null;
	}

	public void Add(ObjectInfo obj) {
		if (count == 0)
			buffer = obj;
		else {
			if (sum == null) {
				sum = new CSGObject(buffer, obj, operation);
				sumInfo = new ObjectInfo(sum,
						new CoordinateSystem(), "tmp");
			} else {
				sum = new CSGObject(sumInfo, obj, operation);
				sumInfo = new ObjectInfo(sum, new CoordinateSystem(), "tmp");
			}
		}
		count++;
	}

	public ObjectInfo GetObjectInfo() {
		if (count == 0)
			return null;
		if (count == 1)
			return buffer;

		return sumInfo;
	}

	public Object3D GetObject() {
		if (count == 0)
			return null;
		if (count == 1)
			return buffer.object;

		return sum;
	}

}
