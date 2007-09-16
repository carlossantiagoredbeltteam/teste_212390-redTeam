import java.applet.*;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.event.MouseListener;
import java.awt.event.MouseEvent;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JOptionPane;
import javax.swing.Timer;
import java.lang.Math;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
import java.awt.geom.Point2D;
import java.util.*;
import java.awt.geom.Ellipse2D;

import java.applet.*;
import java.awt.*;



public class GeometricProgression extends Applet
{

	
//	public GeometricProgression()
//	{
//		MouseListener clickListener = new MousePressListener();
//		addMouseListener(clickListener);
//	}
	   int cycles = 16;
	   
	   int width, height;
	
	   Color[] spectrum;    // an array of elements, each of type Color
	   Color[] spectrum2;   // another array

	   public void init() {
	
		  resize(600,600);
		  
		  width = getSize().width;
	      height = getSize().height;
	      setBackground( Color.black );

	      // Allocate the arrays; make them "N" elements long
	      spectrum = new Color[ cycles ];
	
	      for ( int i = 0; i < cycles; ++i ) {
	          // Here we specify colors by Hue, Saturation, and Brightness,
	          // each of which is a number in the range [0,1], and use
	          // a utility routine to convert it to an RGB value before
	          // passing it to the Color() constructor.
	          spectrum[i] = new Color( Color.HSBtoRGB(i/(float)cycles,1,1) );

	      }
	   }
	
	public void paint(Graphics g)
	
	{
		final Graphics2D g2 = (Graphics2D)g;
		
		final int FONT_SIZE = 40;
		Font hugeFont = new Font("Serif", Font.BOLD, FONT_SIZE);
		g2.setFont(hugeFont);
				
		for (int click = 0; click < cycles; click++)
		{
			g2.setColor( spectrum[ click ] );
			
			
			for (int i=0; i< (Math.pow(2,click)-Math.pow(2,(click-1))); i++)
			{
				Random rand = new Random();
				double x = (width-60) * Math.abs(rand.nextDouble());
				double y = height * Math.abs(rand.nextDouble());
			
				Ellipse2D.Double dot = new Ellipse2D.Double(x+60,y,6,6);

				g2.fill(dot);
			}
				
			g2.drawString(Integer.toString(click), 5, (height/cycles)*click);
			
			System.out.println(Math.pow(2,click));
	
				for (long j = 0;  j < 300000000; j++)
				{
					//sleep
				}
				
						
		}
	}
	
	
	
}
