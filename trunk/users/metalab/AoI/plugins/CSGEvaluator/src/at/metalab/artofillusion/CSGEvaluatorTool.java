/*
 *  This program is free software; you can redistribute it and/or modify it under the
 *  terms of the GNU General Public License as published by the Free Software
 *  Foundation; either version 2 of the License, or (at your option) any later version.
 *  This program is distributed in the hope that it will be useful, but WITHOUT ANY
 *  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 *  PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 */
package at.metalab.artofillusion;

import artofillusion.LayoutWindow;
import artofillusion.ModellingTool;


/**
 * 
 * Plugin interface for CSGEvaluator
 *
 */
public class CSGEvaluatorTool implements ModellingTool
{
  /**
   *  instance this tool,load it in memory
   */

  public CSGEvaluatorTool() { }


  /**
   *  Get the text that appear as the menu item.
   *
   *@return    The name value
   */
  public String getName()
  {
    return "CSGEvaluator...";
  }


  /**
   *  CSGEvaluator Command selection.
   *
   *@param  window  LayoutWindow
   */
  public void commandSelected(LayoutWindow window)
  {
    new CSGEvaluatorDialog(window);
    //this class should do no more because it's always loaded.
  }
}
