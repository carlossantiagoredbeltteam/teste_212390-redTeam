package org.reprap.artofillusion.metacad.objects;

import java.util.LinkedList;
import java.util.List;

import org.reprap.artofillusion.metacad.MetaCADContext;
import org.reprap.artofillusion.metacad.ParsedTree;

import artofillusion.object.ObjectInfo;

public class ForObj extends MetaCADObject {
  
  public List<ObjectInfo> evaluateObject(MetaCADContext ctx, 
                                         List<String> parameters, 
                                         List<ParsedTree> children) throws Exception {    
    ctx.pushScope();
    
    List<ObjectInfo> result = new LinkedList<ObjectInfo>();
    // evaluate first part of for loop i.e. i=0
    ctx.evaluateAssignment(parameters.get(0));

    // security count to exit loop even if we fuck up exit condition
    int count = 0;
    // condition loop evaluate the condition i.e. i < 10
    while (ctx.evaluateExpression(parameters.get(1)) != 0 && count < 100) {
      result.addAll(ParsedTree.evaluate(ctx, children));
      // "increment" evaluate 3rd for parameter i.e. i=i+1
      ctx.evaluateAssignment(parameters.get(2));
      count++;
    }
    
    ctx.popScope();
    
    return result;
  }

}