package org.reprap.artofillusion.objects;

import java.util.List;


import org.reprap.artofillusion.MetaCADContext;
import org.reprap.artofillusion.ParsedTree;
import org.reprap.artofillusion.translators.DXFImporter;

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
    
    List<ObjectInfo> objects = DXFImporter.importFile(ctx.scene, filename, false);
    
    return objects;
  }
  
}
