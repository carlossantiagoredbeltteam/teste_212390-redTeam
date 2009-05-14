package org.reprap.artofillusion.metacad.language;

import org.reprap.artofillusion.metacad.MetaCADContext;

public class VariableAssignment implements ParsedStatement {
  public String name;
  public String formula;
  
  public String toString()
  {
    return name + "=" + formula;
  }
  
  public VariableAssignment(String n, String f)
  {
    name = n;
    formula = f;
  }

  public boolean execute(MetaCADContext context) {
    try {
      context.jep.parseExpression(formula);
      double value = context.jep.getValue();
      context.jep.addVariable(name, value);
    } catch (Exception ex) {
      return false;
    }
    return true;
  }
}
