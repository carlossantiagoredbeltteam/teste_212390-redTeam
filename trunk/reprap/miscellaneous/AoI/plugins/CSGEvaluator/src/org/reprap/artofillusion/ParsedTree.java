package org.reprap.artofillusion;

import java.util.List;

import artofillusion.object.ObjectInfo;

interface TreeObject
{
  ObjectInfo evaluate(); 
}

class MyObject implements TreeObject {
  ObjectInfo obj;

  public ObjectInfo evaluate() {
    return this.obj;
  }       
}

public class ParsedTree implements TreeObject {

  String name;
  List<String> parameters;
  List<TreeObject> children;
  
  public ObjectInfo evaluate() {
    return null;
  }
  
}
