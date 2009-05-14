package org.reprap.artofillusion.metacad.objects;

import java.util.ArrayList;
import java.util.List;

import org.reprap.artofillusion.metacad.MetaCADContext;
import org.reprap.artofillusion.metacad.ParsedTree;

import artofillusion.math.Vec3;
import artofillusion.object.Object3D;
import artofillusion.object.ObjectInfo;
import artofillusion.object.TriangleMesh;

public class ScaleObj extends MetaCADObject {

  public List<ObjectInfo> evaluateObject(MetaCADContext ctx, 
                                         List<String> parameters, 
                                         List<ParsedTree> children) throws Exception {
    
    List<ObjectInfo> chlist = ParsedTree.evaluate(ctx, children);
  
    // workaround: duplicate all evaluated children to make sure we dont 
    // modify native objects
    List<ObjectInfo> newChlist = new ArrayList<ObjectInfo>(chlist.size());
    for (ObjectInfo child : chlist)
    {
      ObjectInfo clone = child.duplicate(child.object.duplicate());
      newChlist.add(clone);
    }  
    chlist = newChlist;
   
    
    double scaleX = 1, scaleY = 1, scaleZ = 1;
    
    if (parameters.size() >= 1) {
      scaleX = scaleY = scaleZ = ctx.evaluateExpression(parameters.get(0));
    }
    if (parameters.size() >= 3) {
      scaleY = ctx.evaluateExpression(parameters.get(1));
      scaleZ = ctx.evaluateExpression(parameters.get(2));
    }
    
    boolean absSize = false;
    if (parameters.size() >= 4) {
      if (parameters.get(3).toLowerCase().startsWith("abs"))
        absSize =  true;
    }
    
    for (ObjectInfo info : chlist)
    {
      try  {
        Object3D obj3D = info.object;
        if (absSize)
        {
          obj3D.setSize(scaleX, scaleY, scaleZ);
        }
        else
        {
          Vec3 sizes = obj3D.getBounds().getSize();
          obj3D.setSize(sizes.x * scaleX, sizes.y * scaleY, sizes.z * scaleZ); 
        }
      }
      catch (NullPointerException ex)
      {
        // WORKAROUND for failing CSGObjects
        TriangleMesh mesh = info.object.convertToTriangleMesh(0.1);
        
        if (absSize)
        {
          mesh.setSize(scaleX, scaleY, scaleZ);
        }
        else
        {
          Vec3 sizes = mesh.getBounds().getSize();
          mesh.setSize(sizes.x * scaleX, sizes.y * scaleY, sizes.z * scaleZ); 
        }
        info.setObject(mesh);
      }
    }
    
    return chlist;
  }

}
