package org.reprap.artofillusion;

import artofillusion.object.CSGObject;

public class ObjFactory {
  public static ParsedTree create(String name) throws ObjFactoryException {
    name = name.toLowerCase();

    if (name.startsWith("sphere")) {
      return new SphereObj();
    }
    else if (name.startsWith("cube")) {
      return new CubeObj();
    }
    else if (name.startsWith("cylinder")) {
      return new CylinderObj();
    }
    else if (name.startsWith("cs")) {
      return new CSObj();
    }
    else if (name.startsWith("union") || name.startsWith("+")) {
      return new BooleanObj(CSGObject.UNION);
    }
    else if (name.startsWith("difference") || name.startsWith("-")) {
      return new BooleanObj(CSGObject.DIFFERENCE12);
    }
    else if (name.startsWith("intersection") || name.startsWith("/")) {
      return new BooleanObj(CSGObject.INTERSECTION);
    }
    else if (name.startsWith("star")) {
      return new PolygonObj(PolygonObj.STAR);
    }
    else if (name.startsWith("reg")) {
      return new PolygonObj(PolygonObj.REG);
    }
    else if (name.startsWith("roll")) {
      return new PolygonObj(PolygonObj.ROLL);
    }
    else if (name.startsWith("extrude")) {
      return new ExtrudeObj();
    }
    else if (name.startsWith("for")) {
      return new ForObj();
    }
    else if (name.startsWith("inset")) {
      return new InsetObj();
    }
    else if (name.startsWith("mesh")) {
      return new MeshObj();
    }

    throw new ObjFactoryException("ObjFactory: Unknown Object type: " + name);
  }
}
