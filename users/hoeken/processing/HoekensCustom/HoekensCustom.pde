/***********************************
* include our necessary libraries
***********************************/
import processing.serial.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

//Where the GUI is created:
JMenuBar menuBar;
//JMenu menu, submenu;
//JMenuItem menuItem;
//JRadioButtonMenuItem rbMenuItem;
//JCheckBoxMenuItem cbMenuItem;

//Create the menu bar.
//menuBar = new JMenuBar();

// The serial port:
Serial port;

void setup()
{
  size(1024, 800);
  smooth();
  strokeJoin(ROUND);
}

void draw()
{
}
