package org.reprap.artofillusion.language;

import org.reprap.artofillusion.MetaCADContext;

public interface ParsedStatement {
  boolean execute(MetaCADContext context);
}

