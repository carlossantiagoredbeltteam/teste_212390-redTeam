package org.reprap.artofillusion;

import java.util.List;

import artofillusion.object.ObjectInfo;

public abstract class MetaCADObject {

  public abstract List<ObjectInfo> evaluateObject(MetaCADContext ctx, 
                                         List<String> parameters, 
                                         List<ParsedTree> children) throws Exception;

}
