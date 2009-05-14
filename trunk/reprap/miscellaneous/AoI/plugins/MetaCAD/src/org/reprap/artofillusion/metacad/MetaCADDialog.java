/*
 *  This program is free software; you can redistribute it and/or modify it under the
 *  terms of the GNU General Public License as published by the Free Software
 *  Foundation; either version 2 of the License, or (at your option) any later version.
 *  This program is distributed in the hope that it will be useful, but WITHOUT ANY
 *  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 *  PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 */
package org.reprap.artofillusion.metacad;

import java.awt.Color;
import java.awt.Insets;
import java.awt.Rectangle;

import javax.swing.SwingUtilities;

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
import buoy.widget.ColumnContainer;
import buoy.widget.FormContainer;
import buoy.widget.LayoutInfo;
import buoy.widget.RowContainer;

/**
 * MetaCAD dialog
 */
class MetaCADDialog extends BDialog implements TextChangedListener
{
  protected  MetaCADEngine engine;
  protected LayoutWindow window;
  protected String[] primfunctions = new String [] {
      "cube", "cylinder", "sphere",
      "regular", "star", "roll"
  };
  protected String[] cadfunctions = new String [] {
      "union", "intersection", "difference",
      "move", "rotate", "scale", "trans", "group",
      "extrude", "lathe", "mesh", "joincurves", "extractmacro", "file"
  };
  
  protected BTextArea paramtab;
  
  public MetaCADDialog(LayoutWindow window)
  {
    super(window, Translate.text("MetaCAD:name"), false); // Modeless
    this.window = window;
    this.setResizable(true);
    
    this.engine = new MetaCADEngine(window);

    BorderContainer bc = new BorderContainer();
    bc.setDefaultLayout(new LayoutInfo(LayoutInfo.CENTER, LayoutInfo.BOTH));
    this.setContent(bc);

    ColumnContainer cc = new ColumnContainer();
    cc.setBackground(Color.BLACK);
    bc.add(cc, BorderContainer.CENTER, new LayoutInfo(LayoutInfo.CENTER, LayoutInfo.BOTH));

    // Tab widget
    BTabbedPane tabcontainer = new BTabbedPane();
    cc.add(tabcontainer, new LayoutInfo(LayoutInfo.CENTER, LayoutInfo.BOTH));

    String versionstr = MetaCADPlugin.getVersion();
    bc.add(new BLabel(Translate.text("MetaCAD:title", versionstr)), BorderContainer.NORTH);

    //  Primitives tab
    FormContainer operationstab = new FormContainer(3, 2);
    tabcontainer.add(operationstab, "Primitives");

    for (int i = 0; i < this.primfunctions.length; i++) {
      BButton button = new BButton(Translate.text("MetaCAD:"+this.primfunctions[i]));
      operationstab.add(button, i%3, i/3, new LayoutInfo(LayoutInfo.WEST, LayoutInfo.HORIZONTAL, new Insets(2, 0, 2, 0), null));
      button.addEventLink(KeyPressedEvent.class, this, "keyPressed"); // For Esc support
      button.addEventLink(CommandEvent.class, this.engine, this.primfunctions[i]);
    }
    
    // CAD tab
    FormContainer cadfuncs = new FormContainer(3, this.cadfunctions.length+1);
    tabcontainer.add(cadfuncs, "CAD");
    for (int i = 0; i < this.cadfunctions.length; i++) {
      BButton button = new BButton(Translate.text("MetaCAD:"+this.cadfunctions[i]));
      cadfuncs.add(button, i%3, i/3, new LayoutInfo(LayoutInfo.WEST, LayoutInfo.HORIZONTAL, new Insets(2, 0, 2, 0), null));
      button.addEventLink(KeyPressedEvent.class, this, "keyPressed"); // For Esc support
      button.addEventLink(CommandEvent.class, this.engine, this.cadfunctions[i]);
    }

    // Parameters tab
    this.paramtab=new BTextArea(this.engine.getParameters(), 10, 20) {
      @Override
      protected void textChanged() {
        super.textChanged();
        MetaCADDialog.this.engine.setParameters(this.getText());
      }
    };
    this.engine.addParameterChangedListener(this);
    
    BScrollPane scrollpane = new BScrollPane(this.paramtab);
    tabcontainer.add(scrollpane, "Parameters");

    // Evaluate & Devaluate
    RowContainer rc = new RowContainer();
    rc.setDefaultLayout(new LayoutInfo(LayoutInfo.CENTER, LayoutInfo.NONE));
    BButton button = new BButton(Translate.text("MetaCAD:evaluate"));
    button.addEventLink(KeyPressedEvent.class, this, "keyPressed"); // For Esc support
    button.addEventLink(CommandEvent.class, this.engine, "evaluate");
    rc.add(button);
    button = new BButton(Translate.text("MetaCAD:devaluate"));
    button.addEventLink(KeyPressedEvent.class, this, "keyPressed"); // For Esc support
    button.addEventLink(CommandEvent.class, this.engine, "devaluate");
    rc.add(button);
    cc.add(rc, new LayoutInfo(LayoutInfo.CENTER, LayoutInfo.NONE));        
    
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
        ev.getKeyCode() == KeyPressedEvent.VK_M) closeWindow();
  }

  public void closeWindow()
  {
    dispose();
  }

  public void textChanged(Object source) {
    final String newText = this.engine.getParameters();
    if (!newText.equals(this.paramtab.getText()))
    {
      SwingUtilities.invokeLater(new Runnable()
      {
        public void run()
        {
          MetaCADDialog.this.paramtab.setText(newText);
        }
      });
      
    }
  }
}