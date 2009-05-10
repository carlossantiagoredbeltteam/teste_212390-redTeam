package org.reprap.artofillusion;

import java.util.Dictionary;
import java.util.Hashtable;

import org.cheffo.jeplite.JEP;
import org.reprap.artofillusion.language.MacroPrototype;

import artofillusion.Scene;

public class MetaCADContext {

  public JEP jep = new JEP();
  public Scene scene;
  public Dictionary<String, MacroPrototype> macros;
  
  public MetaCADContext(Scene scene) {
    this.scene = scene;
    this.macros = new Hashtable<String, MacroPrototype>();
  }

  // Evaluates an Expression like 3*x+sin(a) and returns the value of it or 0 if
  // any error occurred
  double evaluateExpression(String expr) throws Exception {
    try {
      this.jep.parseExpression(expr);
      return this.jep.getValue();
    } catch (Exception ex) {
      // FIXME: Message?
      throw (new Exception("Error while evaluating Expression: \"" + expr
                           + "\" Syntax Error or unknown variable?", ex));
    }
  } 
  
  // Evaluates Expressions like x=2*radius and assigns the value to the given
  // variable
  void evaluateAssignment(String curLine) throws Exception {
    try {
      int mark = curLine.indexOf("=");
      String name = curLine.substring(0, mark).trim();
      String formula = curLine.substring(mark + 1);
      this.jep.parseExpression(formula);
      double value = this.jep.getValue();
      this.jep.addVariable(name, value);
    } catch (Exception ex) {
      throw (ex);
    }
  }
}

