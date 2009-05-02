package org.reprap.artofillusion;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import artofillusion.object.ObjectInfo;

public class ParsedTree {
  public String name;
  public List<String> parameters;
  public List<ParsedTree> children;
  ObjectInfo aoiobj;
  
  public ObjectInfo evaluate(MetaCADContext ctx) throws Exception {
    ObjectInfo result = null;    

    List<ObjectInfo> resultchildren = new LinkedList<ObjectInfo>();
    Iterator<ParsedTree> iter = this.children.iterator();
    while (iter.hasNext()) {
      ParsedTree treeobject = iter.next();
      resultchildren.add(treeobject.evaluate(ctx));
    }
    
    Method meth;
    try {
      meth = ParsedTree.class.getMethod(this.name, List.class);
      result = (ObjectInfo)meth.invoke(this, resultchildren);
    } catch (Exception e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }

    return result;
  }

  public ParsedTree() {
    this.parameters =  new ArrayList<String>();
    this.children = new ArrayList<ParsedTree>();
  }
    
}
