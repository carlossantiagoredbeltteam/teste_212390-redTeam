package org.reprap.artofillusion.objects;

import java.util.LinkedList;
import java.util.List;

import org.reprap.artofillusion.CSGHelper;
import org.reprap.artofillusion.MetaCADContext;
import org.reprap.artofillusion.ParsedTree;

import artofillusion.object.ObjectInfo;


public class BooleanObj extends MetaCADObject {
  int type;

  public BooleanObj(int type) {
    this.type = type;
  }
  
  public List<ObjectInfo> evaluateObject(MetaCADContext ctx, 
                                         List<String> parameters, 
                                         List<ParsedTree> children) throws Exception {
    
    List<ObjectInfo> result = new LinkedList<ObjectInfo>();
    
    CSGHelper helper = new CSGHelper(this.type);
    helper.addAll(ParsedTree.evaluate(ctx, children).iterator());
    
    if (helper.GetObjectInfo() !=  null)
      result.add(helper.GetObjectInfo());
    return result;
    
  }

}
