package org.reprap.artofillusion.metacad.language;

import org.reprap.artofillusion.metacad.MetaCADContext;

public interface ParsedStatement {
  boolean execute(MetaCADContext context);
}

