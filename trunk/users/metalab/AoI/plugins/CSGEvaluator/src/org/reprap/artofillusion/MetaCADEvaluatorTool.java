/*
 *  This program is free software; you can redistribute it and/or modify it under the
 *  terms of the GNU General Public License as published by the Free Software
 *  Foundation; either version 2 of the License, or (at your option) any later version.
 *  This program is distributed in the hope that it will be useful, but WITHOUT ANY
 *  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 *  PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 */
package org.reprap.artofillusion;

import java.awt.event.KeyEvent;

import artofillusion.LayoutWindow;
import artofillusion.ModellingTool;
import artofillusion.keystroke.KeystrokeManager;
import artofillusion.keystroke.KeystrokeRecord;


/**
 * 
 * Plugin interface for CSGEvaluator
 *
 * TODO:
 * o How should we handle materials when combining objects?
 * o Idea: Don't hide negative object, but set them to transparent.
 * o Make window dockable
 */
public class MetaCADEvaluatorTool implements ModellingTool
{
  CSGEvaluatorDialog dialog;


  /**
   *  instance this tool,load it in memory
   */

  public MetaCADEvaluatorTool()
  { 
    KeystrokeManager.addRecord(new KeystrokeRecord(KeyEvent.VK_C, 0, "CSG Evaluator",
        "ModellingTool plugin = (ModellingTool)" +
        "PluginRegistry.getPluginObject(\"org.reprap.artofillusion.CSGEvaluatorTool\");" +
        "plugin.commandSelected(window);"));
  }

  /**
   *  Get the text that appear as the menu item.
   *
   *@return    The name value
   */
  public String getName()
  {
    return "CSG Evaluator...";
  }


  /**
   *  CSGEvaluator Command selection.
   *
   *@param  window  LayoutWindow
   */
  public void commandSelected(LayoutWindow window)
  {
    // Light check for whether the dialog is already visible and to then close it.
    // FIXME: Should be done better, but then we need to keep track of the dialog per window.
    if (this.dialog != null && this.dialog.isVisible() && this.dialog.getParent() == window) {
      this.dialog.closeWindow();
    }
    else {
      this.dialog = new CSGEvaluatorDialog(window);
    }
    //this class should do no more because it's always loaded.
  }
}
