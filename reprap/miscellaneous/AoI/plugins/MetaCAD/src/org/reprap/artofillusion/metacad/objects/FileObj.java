package org.reprap.artofillusion.metacad.objects;

import java.io.File;
import java.lang.reflect.InvocationTargetException;
import java.util.LinkedList;
import java.util.List;

import org.reprap.artofillusion.metacad.MetaCADContext;
import org.reprap.artofillusion.metacad.ParsedTree;
import org.reprap.artofillusion.metacad.translators.DXFImporter;

import artofillusion.PluginRegistry;
import artofillusion.Scene;
import artofillusion.object.ObjectInfo;
import artofillusion.object.TriangleMesh;
import artofillusion.ui.MessageDialog;

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
    // Append filename to directory of the current AoI scene if it's not an absolute path
    if (!new File(filename).exists()) {
      filename = ctx.scene.getDirectory() + File.separator + filename;
    }

    List<ObjectInfo> objects = null;

    if (filename.toLowerCase().endsWith(".dxf")) {
      objects = DXFImporter.importFile(ctx.scene, filename, false);
    }
    else if (filename.toLowerCase().endsWith(".stl")) {
      try {
        Scene scene = (Scene)PluginRegistry.invokeExportedMethod("nik777.STLTranslator.import", new File(filename));
        // Only import triangle meshes (filters away cameras, lights)
        objects = new LinkedList<ObjectInfo>();
        for (ObjectInfo stlinfo : scene.getAllObjects()) {
          if (stlinfo.object instanceof TriangleMesh) {
            objects.add(stlinfo);
          }
        }
      }
      catch (NoSuchMethodException nsme) {
        nsme.printStackTrace();
        new MessageDialog(null, "Unable to access STL Translator.\nVerify that the STL Translator plugin is installed.");
      }
      catch (InvocationTargetException ite) {
        ite.printStackTrace();
        new MessageDialog(null, "Unable to access STL Translator.\nVerify that the STL Translator plugin is installed.");
      }
    }
  
    return objects;
  }
  
}
