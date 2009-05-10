package org.reprap.artofillusion.language;

import java.util.List;

import org.reprap.artofillusion.MetaCADContext;
import org.reprap.artofillusion.ParsedTree;

public class MacroPrototype implements ParsedStatement {
  public String name;
  public List<String> variables;
  public List<ParsedTree> children;
  
  public MacroPrototype(String n, List<String> p, List<ParsedTree> c)
  {
    name = n;
    variables = p;
    children =  c;
  }

  public boolean execute(MetaCADContext context) {
    context.macros.put(name.toLowerCase(), this);
    return true;
  }
}
