package org.reprap.artofillusion;

import java.util.LinkedList;
import java.util.List;

import org.cheffo.jeplite.ASTVarNode;
import org.reprap.artofillusion.language.MacroPrototype;

import artofillusion.object.ObjectInfo;

public class MacroObj extends MetaCADObject {
  protected MacroPrototype prototype;   
  
  public MacroObj(MacroPrototype prototype)
  {
    this.prototype = prototype;
  }
  public List<ObjectInfo> evaluateObject(MetaCADContext ctx, 
                                         List<String> parameters, 
                                         List<ParsedTree> children) throws Exception {
    
    if (parameters.size() >= prototype.variables.size())
    {
      int n = prototype.variables.size();      
      ASTVarNode[] backup = new ASTVarNode[n];
      double[] values = new double[n];
      // backup variables
      for (int i = 0;  i < n; i++)
      {
        backup[i] = ctx.jep.getVarNode(prototype.variables.get(i)); 
        values[i] = ctx.evaluateExpression(parameters.get(i));
      }
      // replace variables
      for (int i = 0;  i < n; i++)
      {
        ctx.jep.setVarNode(prototype.variables.get(i), null);
        ctx.jep.addVariable(prototype.variables.get(i), values[i]);
      }
      // evaluate
      List<ObjectInfo> result = ParsedTree.evaluate(ctx, prototype.children);
      // restore previous variables
      for (int i = 0;  i < n; i++)
      {
        ctx.jep.setVarNode(prototype.variables.get(i), backup[i]);
      }
      return result;
    }
    else
    {
      throw new Exception("Not enough parameters  given to Macro Call: " + prototype.name);
    }
  }

}