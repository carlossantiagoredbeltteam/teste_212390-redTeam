package org.reprap.artofillusion.metacad.objects;

import java.util.List;

import org.reprap.artofillusion.metacad.MetaCADContext;
import org.reprap.artofillusion.metacad.ParsedTree;

import artofillusion.object.ObjectInfo;

public abstract class MetaCADObject {

  public abstract List<ObjectInfo> evaluateObject(MetaCADContext ctx, 
                                         List<String> parameters, 
                                         List<ParsedTree> children) throws Exception;

}
