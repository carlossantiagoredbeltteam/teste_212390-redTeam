/*
 *  This program is free software; you can redistribute it and/or modify it under the
 *  terms of the GNU General Public License as published by the Free Software
 *  Foundation; either version 2 of the License, or (at your option) any later version.
 *  This program is distributed in the hope that it will be useful, but WITHOUT ANY
 *  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 *  PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 */
package org.reprap.artofillusion.metacad;

import java.awt.event.KeyEvent;

import artofillusion.LayoutWindow;
import artofillusion.ModellingTool;
import artofillusion.keystroke.KeystrokeManager;
import artofillusion.keystroke.KeystrokeRecord;
import artofillusion.ui.Translate;


/**
 * 
 * Plugin interface for MetaCAD
 *
 * TODO:
 * o How should we handle materials when combining objects?
 * o Idea: Don't hide negative object, but set them to transparent.
 * o Make window dockable
 */
public class MetaCADTool implements ModellingTool
{
  MetaCADDialog dialog;


  /**
   *  instance this tool,load it in memory
   */

  public MetaCADTool()
  { 
    KeystrokeManager.addRecord(new KeystrokeRecord(KeyEvent.VK_M, 0, "MetaCAD Evaluator",
        "ModellingTool plugin = (ModellingTool)" +
        "PluginRegistry.getPluginObject(\"org.reprap.artofillusion.metacad.MetaCADTool\");" +
        "plugin.commandSelected(window);"));
  }

  /**
   *  Get the text that appear as the menu item.
   *
   *@return    The name value
   */
  public String getName()
  {
    return Translate.text("MetaCADEvaluator:name", "...");
  }


  /**
   *  CSGEvaluator Command selection.
   *
   *@param  window  LayoutWindow
   */
  public void commandSelected(LayoutWindow window)
  {
    for (int i = 0; i < window.getAllViews().length; i++)
    {
      window.getAllViews()[i].setGrid(1, 0, true, false);
      window.getAllViews()[i].setShowAxes(true);
    }
    window.repaint(); // FIXME: Repaint doesn't have immediate effect on Mac.
    
    
    // Light check for whether the dialog is already visible and to then close it.
    // FIXME: Should be done better, but then we need to keep track of the dialog per window.
    if (this.dialog != null && this.dialog.isVisible() && this.dialog.getParent() == window) {
      this.dialog.closeWindow();
    }
    else {
      this.dialog = new MetaCADDialog(window);
    }
    //this class should do no more because it's always loaded.
  }
}
