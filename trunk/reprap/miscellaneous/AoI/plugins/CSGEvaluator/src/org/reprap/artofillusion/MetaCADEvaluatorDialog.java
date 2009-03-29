/*
 *  This program is free software; you can redistribute it and/or modify it under the
 *  terms of the GNU General Public License as published by the Free Software
 *  Foundation; either version 2 of the License, or (at your option) any later version.
 *  This program is distributed in the hope that it will be useful, but WITHOUT ANY
 *  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 *  PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 */
package org.reprap.artofillusion;

import java.awt.Insets;
import java.awt.Rectangle;

import artofillusion.LayoutWindow;
import artofillusion.ui.Translate;
import buoy.event.CommandEvent;
import buoy.event.KeyPressedEvent;
import buoy.event.WindowClosingEvent;
import buoy.widget.BButton;
import buoy.widget.BDialog;
import buoy.widget.BLabel;
import buoy.widget.BScrollPane;
import buoy.widget.BTabbedPane;
import buoy.widget.BTextArea;
import buoy.widget.BorderContainer;
import buoy.widget.FormContainer;
import buoy.widget.LayoutInfo;

/**
 * CSGEvaluator dialog
 */
class MetaCADEvaluatorDialog extends BDialog
{
  protected  MetaCADEvaluatorEngine engine;
  protected LayoutWindow window;
  protected String[] csgfunctions = new String [] {
      "evaluate", "devaluate", "union", "intersection", "difference"
  };
  protected String[] csglabels = new String [] {
      Translate.text("MetaCADEvaluator:Actions"), null, Translate.text("MetaCADEvaluator:BooleanOp"), null,null,null
  };
  protected String[] cadfunctions = new String [] {
      "cube", "cylinder", "sphere", "polygon", "extrude"
  };
  protected String[] cadlabels = new String [] {
      Translate.text("MetaCADEvaluator:Objects"), null, null, null, Translate.text("MetaCADEvaluator:Operations")
  };
  
  public MetaCADEvaluatorDialog(LayoutWindow window)
  {
    super(window, Translate.text("MetaCADEvaluator:name"), false); // Modeless
    this.window = window;
    this.setResizable(true);
    
    this.engine = new MetaCADEvaluatorEngine(window);

    BorderContainer bc = new BorderContainer();
    bc.setDefaultLayout(new LayoutInfo());
    this.setContent(bc);

    BTabbedPane tabcontainer = new BTabbedPane();
    bc.add(tabcontainer, BorderContainer.CENTER, new LayoutInfo(LayoutInfo.CENTER, LayoutInfo.BOTH));
    
    String versionstr = CSGEvaluatorPlugin.getVersion();
    bc.add(new BLabel(Translate.text("MetaCADEvaluator:title", versionstr)), BorderContainer.NORTH);

    //  Operations tab
    FormContainer buttonstab = new FormContainer(2, this.csgfunctions.length+1);
    tabcontainer.add(buttonstab, "Operations");

    for (int i = 0; i < this.csgfunctions.length; i++) {
      if (this.csglabels[i] != null) {
        buttonstab.add(new BLabel(this.csglabels[i]), 0, i, new LayoutInfo(LayoutInfo.EAST, LayoutInfo.NONE, new Insets(2, 0, 2, 5), null));
      }
      BButton button = new BButton(Translate.text("MetaCADEvaluator:"+this.csgfunctions[i]));
      buttonstab.add(button, 1, i, new LayoutInfo(LayoutInfo.WEST, LayoutInfo.HORIZONTAL, new Insets(2, 0, 2, 0), null));
      button.addEventLink(KeyPressedEvent.class, this, "keyPressed"); // For Esc support
      button.addEventLink(CommandEvent.class, this.engine, this.csgfunctions[i]);
    }
    
    // Parameters tab
    BTextArea paramtab=new BTextArea(this.engine.getParameters(), 10, 20) {
      @Override
      protected void textChanged() {
        super.textChanged();
        MetaCADEvaluatorDialog.this.engine.setParameters(this.getText());
      }
    };
    BScrollPane scrollpane = new BScrollPane(paramtab);
    tabcontainer.add(scrollpane, "Parameters");

    // CAD tab
    FormContainer cadtab = new FormContainer(2, this.cadfunctions.length+1);
    tabcontainer.add(cadtab, "CAD");

    for (int i = 0; i < this.cadfunctions.length; i++) {
      if (this.cadlabels[i] != null) {
        cadtab.add(new BLabel(this.cadlabels[i]), 0, i, new LayoutInfo(LayoutInfo.EAST, LayoutInfo.NONE, new Insets(2, 0, 2, 5), null));
      }
      BButton button = new BButton(Translate.text("MetaCADEvaluator:"+this.cadfunctions[i]));
      cadtab.add(button, 1, i, new LayoutInfo(LayoutInfo.WEST, LayoutInfo.HORIZONTAL, new Insets(2, 0, 2, 0), null));
      button.addEventLink(KeyPressedEvent.class, this, "keyPressed"); // For Esc support
      button.addEventLink(CommandEvent.class, this.engine, this.cadfunctions[i]);
    }

    // Close button
    BButton closeButton;
    bc.add(closeButton = Translate.button("close", this, "closeWindow"), BorderContainer.SOUTH);
    //closeButton.addEventLink(KeyPressedEvent.class, this, "keyPressed"); // For Esc support
    addEventLink(KeyPressedEvent.class, this, "keyPressed"); // For Esc support
    // FIXME: Other events (most noticeably Cmd-Z (undo)) are consumed and won't reach our
    // parent window.
    setDefaultButton(closeButton);

    addEventLink(WindowClosingEvent.class, this, "closeWindow");
    pack();

    // Move dialog to lower left corner
    Rectangle r1 = window.getBounds(), r2 = this.getBounds();
    int x = r1.x;
    int y = r1.y+r1.height-r2.height;
    if (x < 0) x = 0;
    if (y < 0) y = 0;
    this.setBounds(new Rectangle(x, y, r2.width, r2.height));

    setVisible(true);
  }

  /** Pressing Escape are equivalent to clicking close */
  public void keyPressed(KeyPressedEvent ev)
  {
    if (ev.getKeyCode() == KeyPressedEvent.VK_ESCAPE ||
        ev.getKeyCode() == KeyPressedEvent.VK_C) closeWindow();
  }

  public void closeWindow()
  {
    dispose();
  }
}