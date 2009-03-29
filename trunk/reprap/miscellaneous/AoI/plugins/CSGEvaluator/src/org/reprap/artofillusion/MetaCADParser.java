package org.reprap.artofillusion;

import java.util.Enumeration;
import java.util.Hashtable;

/**
 * 
 * Splits lines on the form "function1(arg1,arg2)function2(arg1;arg2)..." into
 * a mapping from name:parameters[arg1, arg2]
 */
public class MetaCADParser {

  String expr;
  Hashtable<String,String[]> expressions = new Hashtable<String,String[]>();
  
  public MetaCADParser(String expr) {
    this.expr = expr;
  }

  /**
   * Parses the current string of expressions and creates a hashtable of mapping from name -> parameter list
   * 
   * @return true if parse succeeded, false if parse failed
   */
  public Boolean parse() {
    Boolean found = false;    
    int pos = 0;
    int numopens = 0;
    while (true) {
      int posOpenBracket = this.expr.indexOf("(", pos);
      if (posOpenBracket > 0) {
        String name = this.expr.substring(pos, posOpenBracket).trim();
        numopens = 1;
        pos = posOpenBracket;
        while (numopens > 0) {
          pos++;
          if (pos == this.expr.length()) break;
          if (this.expr.charAt(pos) == '(') numopens++;
          else if (this.expr.charAt(pos) == ')') numopens--;
        }
        if (numopens > 0) {
          System.out.println("MetaCADParser: Unbalanced expression " + this.expr);
          return false;
        }
        String[] parameters = this.expr.substring(posOpenBracket + 1, pos).trim().split("[,;]");
        this.expressions.put(name, parameters);     
        pos++;
        found = true;
      }
      else {
        return found;
      }
      if (pos == this.expr.length()) break;
    }
    return found;
  }

  public Enumeration<String> getNames() {
    return this.expressions.keys();
  }

  public String[] getParameters(String key) {
    return this.expressions.get(key); 
  }
}
