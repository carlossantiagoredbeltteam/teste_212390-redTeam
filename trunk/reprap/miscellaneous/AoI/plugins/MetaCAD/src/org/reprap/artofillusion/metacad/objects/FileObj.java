package org.reprap.artofillusion.metacad.objects;

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
    
    List<ObjectInfo> objects = DXFImporter.importFile(ctx.scene, filename, false);
    
    return objects;
  }
  
}
