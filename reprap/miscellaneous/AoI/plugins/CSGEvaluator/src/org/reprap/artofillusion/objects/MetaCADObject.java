package org.reprap.artofillusion.objects;

import java.util.List;

import org.reprap.artofillusion.MetaCADContext;
import org.reprap.artofillusion.ParsedTree;

import artofillusion.object.ObjectInfo;

public abstract class MetaCADObject {

  public abstract List<ObjectInfo> evaluateObject(MetaCADContext ctx, 
                                         List<String> parameters, 
                                         List<ParsedTree> children) throws Exception;

}
