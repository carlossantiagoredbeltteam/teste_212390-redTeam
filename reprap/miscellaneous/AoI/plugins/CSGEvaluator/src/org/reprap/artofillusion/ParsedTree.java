package org.reprap.artofillusion;

import java.util.ArrayList;
import java.util.List;

import artofillusion.object.ObjectInfo;

class MyObject implements TreeObject {
  ObjectInfo obj;

  public ObjectInfo evaluate() {
    return this.obj;
  }       
}

public class ParsedTree implements TreeObject {
  public String name;
  public List<String> parameters;
  public List<TreeObject> children;
  
  public ParsedTree()
  {
	  parameters =  new ArrayList<String>();
	  children = new ArrayList<TreeObject>();
  }
  
  public ObjectInfo evaluate() {
    return null;
  }
  
}
