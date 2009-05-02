package org.reprap.artofillusion;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import artofillusion.object.ObjectInfo;

public abstract class ParsedTree {
  public String name;
  public List<String> parameters;
  public List<ParsedTree> children;
  ObjectInfo aoiobj;
  
  public abstract ObjectInfo evaluate(MetaCADContext ctx) throws Exception;

  public List<ObjectInfo> evaluateChildren(MetaCADContext ctx) throws Exception {
    List<ObjectInfo> resultchildren = new LinkedList<ObjectInfo>();
    Iterator<ParsedTree> iter = this.children.iterator();
    while (iter.hasNext()) {
      ParsedTree treeobject = iter.next();
      resultchildren.add(treeobject.evaluate(ctx));
    }
    
    return resultchildren;
  }

  public ParsedTree() {
    this.parameters =  new ArrayList<String>();
    this.children = new ArrayList<ParsedTree>();
  }
    
}
