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
import buoy.event.CommandEvent;
import buoy.event.KeyPressedEvent;
import buoy.event.WindowClosingEvent;
import buoy.widget.BButton;
import buoy.widget.BDialog;
import buoy.widget.BLabel;
import buoy.widget.BorderContainer;
import buoy.widget.FormContainer;
import buoy.widget.LayoutInfo;




import java.util.*;
import java.io.*;

import org.cheffo.jeplite.*;
import org.cheffo.jeplite.util.*;
import org.cheffo.jeplite.optimizer.*;


/**
 * CSGEvaluator dialog
 */
class CSGEvaluatorDialog extends BDialog
{
  LayoutWindow window;
  JEP jep = new JEP();
  
  public CSGEvaluatorDialog(LayoutWindow window)
  {
    super(window, "CSG Evaluator ", false); // Modeless

    jep.addVariable("x", 22.5);
    jep.parseExpression("x*2-3");

    this.window = window;
    this.setResizable(false);
    
    CSGEvaluatorEngine engine = new MetaCADEvaluatorEngine(window); // new CSGEvaluatorEngine(window);

    BorderContainer bc = new BorderContainer();
    this.setContent(bc);

    bc.setDefaultLayout(new LayoutInfo());

    String versionstr = "1.0";
    // FIXME: This was an attempt to pick up the version from the extensions.xml file,
    // but it didn't work out since the classloader found the wrong file.
    /*
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    DocumentBuilder builder;
    try {
      builder = factory.newDocumentBuilder();
      Document doc = builder.parse(CSGEvaluatorDialog.class.getResourceAsStream("/extensions.xml"));
      Element extensions = doc.getDocumentElement();
      versionstr = extensions.getAttribute("version");
    } catch (Exception e) {
      e.printStackTrace();
    }
    */
    
    try {
      
   
      bc.add(new BLabel("<html>CSG Evaluator Control Panel <font size=1>V"+versionstr+"</font>" + jep.getValue() + "</html>"), BorderContainer.NORTH);
    }
    catch (Exception ex)
    {}
    
    String[] buttons = new String [] {"evaluate", "devaluate", "union", "intersection", "difference", "readParameters"};
    String[] labels = new String [] {"Actions", null, "Boolean Op", null, null, null};

    FormContainer fc = new FormContainer(2, buttons.length+1);
    bc.add(fc, BorderContainer.CENTER);

    for (int i = 0; i < buttons.length; i++) {
      if (labels[i] != null) {
        fc.add(new BLabel(labels[i]), 0, i, new LayoutInfo(LayoutInfo.EAST, LayoutInfo.NONE, new Insets(2, 0, 2, 5), null));
      }
      BButton button = new BButton(buttons[i]);
      fc.add(button, 1, i, new LayoutInfo(LayoutInfo.WEST, LayoutInfo.HORIZONTAL, new Insets(2, 0, 2, 0), null));
      button.addEventLink(KeyPressedEvent.class, this, "keyPressed"); // For Esc support
      button.addEventLink(CommandEvent.class, engine, buttons[i]);
    }
//    BButton button = new BButton("test");
//    fc.add(button, 1, buttons.length);
//    button.addEventLink(CommandEvent.class, this, "test");

    // Close button
    BButton closeButton;
    bc.add(closeButton = new BButton("close"), BorderContainer.SOUTH);
    closeButton.addEventLink(CommandEvent.class, this, "closeWindow");
    closeButton.addEventLink(KeyPressedEvent.class, this, "keyPressed"); // For Esc support
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
  
  public void test()
  {
    int[] selidx = this.window.getSelectedIndices(); 
    for (int i : selidx) {
      System.out.println("sel: " + i);
    }
  }
}
