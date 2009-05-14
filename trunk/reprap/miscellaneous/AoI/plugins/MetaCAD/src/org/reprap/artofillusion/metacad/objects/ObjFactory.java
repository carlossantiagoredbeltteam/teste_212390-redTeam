package org.reprap.artofillusion.metacad.objects;

import org.reprap.artofillusion.metacad.MetaCADContext;
import org.reprap.artofillusion.metacad.language.MacroPrototype;

import artofillusion.object.CSGObject;

public class ObjFactory {
  public static MetaCADObject create(MetaCADContext ctx, String name) throws ObjFactoryException {
    name = name.toLowerCase();

    if (name.equals("native")) {
      return new NativeObj();
    }
    else if (name.startsWith("sphere")) {
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
    else if (name.startsWith("joincurves")) {
      return new JoinCurvesObj();
    }
    else if (name.startsWith("lathe")) {
      return new LatheObj();
    }
    else if (name.startsWith("scale")) {
      return new ScaleObj();
    }
    else if (name.startsWith("file")) {
      return new FileObj();
    }
    else {
      MacroPrototype macroPrototype = ctx.macros.get(name.toLowerCase());
      if (macroPrototype != null)
      {
        return new MacroObj(macroPrototype);
      }
    }

    throw new ObjFactoryException("ObjFactory: Unknown Object type: " + name);
  }
}
