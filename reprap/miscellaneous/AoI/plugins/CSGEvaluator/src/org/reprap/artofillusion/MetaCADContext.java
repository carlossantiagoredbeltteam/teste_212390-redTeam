package org.reprap.artofillusion;

import org.cheffo.jeplite.JEP;

public class MetaCADContext {

  public JEP jep = new JEP();

  // Evaluates an Expression like 3*x+sin(a) and returns the value of it or 0 if
  // any error occurred
  double evaluateExpression(String expr) throws Exception {
    try {
      this.jep.parseExpression(expr);
      return this.jep.getValue();
    } catch (Exception ex) {
      // FIXME: Message?
//      showMessage("Error while evaluating Expression: \"" + expr
//          + "\" Syntax Error or unknown variable?");
      throw (ex);
      // return 0;
    }
  }
  
}

