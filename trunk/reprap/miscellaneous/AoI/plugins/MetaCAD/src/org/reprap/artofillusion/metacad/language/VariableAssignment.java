package org.reprap.artofillusion.metacad.language;

import org.reprap.artofillusion.metacad.MetaCADContext;

public class VariableAssignment implements ParsedStatement {
  public String name;
  public String formula;
  
  public String toString()
  {
    return this.name + "=" + this.formula;
  }
  
  public VariableAssignment(String n, String f)
  {
    this.name = n;
    this.formula = f;
  }

  public boolean execute(MetaCADContext context) {
    try {
      context.evaluateAssignment(this.name, this.formula);
    } catch (Exception ex) {
      return false;
    }
    return true;
  }
}
