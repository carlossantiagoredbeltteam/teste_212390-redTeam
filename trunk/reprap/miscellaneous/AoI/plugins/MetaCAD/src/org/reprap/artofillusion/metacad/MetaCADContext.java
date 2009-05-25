package org.reprap.artofillusion.metacad;

// svn update ExtrudeObj.java -r 3025

import java.util.Dictionary;
import java.util.Hashtable;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import bsh.*;

import org.cheffo.jeplite.JEP;
import org.reprap.artofillusion.metacad.language.MacroPrototype;
import org.reprap.artofillusion.metacad.language.ParsedStatement;
import org.reprap.artofillusion.metacad.parser.MetaCADParser;

import artofillusion.Scene;

public class MetaCADContext {

  //private JEP jep = new JEP();
  bsh.Interpreter interpreter;
  public Scene scene;
  public Dictionary<String, MacroPrototype> macros;
  
  // stores the variables
  LinkedList<Hashtable<String, Object>> scopes;
  Hashtable<String, Object> currentScope;
  
  public MetaCADContext(Scene scene) {
    this.scene = scene;
    clearContext();
  }
  
  public void evaluateParameters(String parameters) throws Exception {
    this.clearContext();
    this.interpreter.eval("import java.lang.Math;" +
    		"double sin(double a) { return Math.sin(a); }" +
    		"double cos(double a) { return Math.cos(a); }" +
    		"double tan(double a) { return Math.tan(a); }" +
    		"double exp(double a, double b) { return Math.exp(a,b); }");
    Object v = this.interpreter.eval("sin(0)");
    this.interpreter.set("test", v);
    
    List<ParsedStatement> statements = 
      MetaCADParser.parseParameters(parameters);
    
    for (ParsedStatement statement : statements)
    {
      boolean success = statement.execute(this);
      if (!success)
      {
        throw new Exception("Error in statement: " + statement.toString());
      }
    }
  }

  // Evaluates an Expression like 3*x+sin(a) and returns the value of it or 0 if
  // any error occurred
  public double evaluateExpression(String expr) throws Exception {
    //pushScope();
    try {
      Object result = this.interpreter.eval(expr);
      if (result.getClass().equals(Boolean.class))
        return ((Boolean)result).booleanValue() ? 1 : 0;
      return ((Number)result).doubleValue();
    } catch (Exception ex) {
      // FIXME: Message?
      throw (new Exception("Error while evaluating Expression: \"" + expr
                           + "\" Syntax Error or unknown variable?", ex));
    }
  } 
  
  // Evaluates Expressions like x=2*radius and assigns the value to the given
  // variable
  public double evaluateAssignment(String curLine) throws Exception {
    int mark = curLine.indexOf("=");
    String name = curLine.substring(0, mark).trim();
    String formula = curLine.substring(mark + 1);
    return evaluateAssignment(name, formula);
  }
  
  public double evaluateAssignment(String name, String expr) throws Exception {
    double value = this.evaluateExpression(expr);
    this.assignValue(name, value);
    return value;
  }
  
  public void assignValue(String name, double value) throws Exception
  {
    // if we have not backed up the value of the variable then lets do taht now
    if (!this.currentScope.containsKey(name))
    {
      Object obj = this.interpreter.get(name);
      if (obj == null)
        obj = new EmptyObject();
      this.currentScope.put(name, obj);
    }
    this.interpreter.set(name, value);
  }
  
  public boolean evaluateBoolean(String expr) throws Exception {
    try {
      return this.evaluateExpression(expr) != 0;
    }
    catch (Exception ex) {
      // test special cases
      String lc = expr.toLowerCase();
      if (lc.equals("true") || lc.equals("yes") || lc.equals("on"))
        return true;
      if (lc.equals("false") || lc.equals("no") || lc.equals("off"))
        return false;
      // no special cases then well have to throw an exception
      throw (ex);
    }
  }
  
  public void clearContext()
  {
    this.macros = new Hashtable<String, MacroPrototype>();
    this.currentScope = new Hashtable<String, Object>();
    this.scopes = new LinkedList<Hashtable<String,Object>>();
    this.interpreter = new Interpreter();
  }
  
  // call this to "backup" the current state of the beanshell interpreter
  public void pushScope()
  {
    this.scopes.add(this.currentScope);
    this.currentScope = new Hashtable<String, Object>();
  }
  
  // to restore the old state of the beanshell interpreter
  public void popScope() throws Exception
  {
    for  (Map.Entry<String, Object> entry : this.currentScope.entrySet())
    {
      String key = entry.getKey();
      Object obj = entry.getValue();
      
      if (obj.getClass().equals(EmptyObject.class))
      {
        this.interpreter.set(key, null);
      }
      else
      {
        this.interpreter.set(key, obj);
      }
    }
    
    this.currentScope = this.scopes.poll(); 
  }
  
  // dummy cluss to store null objects in scopes
  protected class EmptyObject { };
}

