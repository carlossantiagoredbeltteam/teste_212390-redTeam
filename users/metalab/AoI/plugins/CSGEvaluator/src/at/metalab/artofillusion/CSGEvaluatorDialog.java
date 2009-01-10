/*
 *  This program is free software; you can redistribute it and/or modify it under the
 *  terms of the GNU General Public License as published by the Free Software
 *  Foundation; either version 2 of the License, or (at your option) any later version.
 *  This program is distributed in the hope that it will be useful, but WITHOUT ANY
 *  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 *  PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 */
package at.metalab.artofillusion;

import java.awt.Insets;

import artofillusion.LayoutWindow;
import artofillusion.ui.UIUtilities;
import buoy.event.CommandEvent;
import buoy.event.KeyPressedEvent;
import buoy.event.WindowClosingEvent;
import buoy.widget.BButton;
import buoy.widget.BDialog;
import buoy.widget.BLabel;
import buoy.widget.BorderContainer;
import buoy.widget.FormContainer;
import buoy.widget.LayoutInfo;
import buoy.widget.RowContainer;
import buoy.widget.Widget;

/**
 * CSGEvaluator dialog
 */
class CSGEvaluatorDialog extends BDialog
{
  public CSGEvaluatorDialog(LayoutWindow window)
  {
    super(window, "CSG Evaluator", false); // Modeless
    BorderContainer bc = new BorderContainer();
    this.setContent(bc);
    bc.setDefaultLayout(new LayoutInfo(LayoutInfo.CENTER, 
        LayoutInfo.NONE, 
        new Insets(10, 10, 10, 10), 
        null));
    bc.add(new BLabel("CSG Evaluator Control Panel"), BorderContainer.NORTH);
    FormContainer fc = new FormContainer(2, 5);
    bc.add(fc, BorderContainer.CENTER);
    RowContainer buttons = new RowContainer();
    bc.add(buttons, BorderContainer.SOUTH);

    // Setup buttons
    BButton evaluateButton, devaluateButton;
    BButton unionButton, intersectButton, subtractButton;
    Widget[] components = new Widget [] { 
        evaluateButton = new BButton("evaluate"),
        devaluateButton = new BButton("devaluate"),
        unionButton = new BButton("union"),
        intersectButton = new BButton("intersect"),
        subtractButton = new BButton("subtract"),
    };
    String[] labels = new String [] {"Actions", "", "Boolean Operations", "", ""};

    for (int i = 0; i < components.length; i++) {
      fc.add(new BLabel(labels[i]), 0, i, new LayoutInfo(LayoutInfo.EAST, LayoutInfo.NONE, new Insets(2, 0, 2, 5), null));
      fc.add(components[i], 1, i, new LayoutInfo(LayoutInfo.WEST, LayoutInfo.BOTH, new Insets(2, 0, 2, 0), null));
      // FIXME: What does this do?
      components[i].addEventLink(KeyPressedEvent.class, this, "keyPressed");
    }

    // Close button
    BButton closeButton;
    buttons.add(closeButton = new BButton("close"));

    // Events
    CSGEvaluatorEngine engine = new CSGEvaluatorEngine(window);
    evaluateButton.addEventLink(CommandEvent.class, engine, "evaluate");
    devaluateButton.addEventLink(CommandEvent.class, engine, "devaluate");
    unionButton.addEventLink(CommandEvent.class, engine, "union");
    intersectButton.addEventLink(CommandEvent.class, engine, "intersect");
    subtractButton.addEventLink(CommandEvent.class, engine, "subtract");

    closeButton.addEventLink(CommandEvent.class, this, "closeWindow");
    closeButton.addEventLink(KeyPressedEvent.class, this, "keyPressed");

    addEventLink(WindowClosingEvent.class, this, "closeWindow");
    setDefaultButton(closeButton);
    pack();
    setResizable(false);
    UIUtilities.centerDialog(this, window);
    setVisible(true);
  }

  /** Pressing Return and Escape are equivalent to clicking OK and Cancel. */
  public void keyPressed(KeyPressedEvent ev)
  {
    int code = ev.getKeyCode();
    if (code == KeyPressedEvent.VK_ESCAPE) closeWindow();
  }

  public void closeWindow()
  {
    dispose();
    //        for (int i = 0; i < comp.length; i++) comp[i].removeEventLink(KeyPressedEvent.class, this);
  }
}