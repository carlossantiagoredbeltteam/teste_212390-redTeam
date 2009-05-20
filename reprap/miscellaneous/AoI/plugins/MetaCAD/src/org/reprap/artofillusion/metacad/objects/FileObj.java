package org.reprap.artofillusion.metacad.objects;

import java.io.File;
import java.util.List;

import org.reprap.artofillusion.metacad.MetaCADContext;
import org.reprap.artofillusion.metacad.ParsedTree;
import org.reprap.artofillusion.metacad.translators.DXFImporter;

import artofillusion.object.ObjectInfo;

public class FileObj extends MetaCADObject
{
  public List<ObjectInfo> evaluateObject(MetaCADContext ctx, 
                                         List<String> parameters, 
                                         List<ParsedTree> children) throws Exception {
    
    String filename = null;
    if (parameters.size() > 0) {
      filename = parameters.get(0);
      if (filename.charAt(0) == '"') filename = filename.substring(1, filename.length()-1);
    }
    
    List<ObjectInfo> objects = null;
    
    // lets see if the file exists
    boolean absExists = (new File(filename)).exists();
    if (absExists) {
      objects = DXFImporter.importFile(ctx.scene, filename, false);
    } 
    // otherwise lets try to append the path of the aoi scene
    else {
      String dir = ctx.scene.getDirectory();
      objects = DXFImporter.importFile(ctx.scene, dir + File.separator + filename, false);
    }
  
    return objects;
  }
  
}
