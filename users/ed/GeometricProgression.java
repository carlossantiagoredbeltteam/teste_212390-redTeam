import java.applet.*;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.lang.Math;
import java.util.*;
import java.awt.geom.Ellipse2D;
import java.awt.*;

/*
 * Program to express the power of self replication
 * No death here ;-)
 */

public class GeometricProgression extends Applet
{
	   int cycles = 16;
	   int width, height;
	
	   Color[] spectrum;    // an array of elements, each of type Color
	
	   public void init() {
	
		  resize(1000,700);
		  
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
		
		final int FONT_SIZE = 20;
		Font key = new Font("Courier", Font.BOLD, FONT_SIZE);
		g2.setFont(key);
		
		for (int n = 0; n < 4; n++)
		{
			for (int click = 0; click < cycles; click++)
			{
				g2.setColor( spectrum[ click ] );
				
				g2.drawString("(R)ep cycles", 5, FONT_SIZE);
				g2.drawString("(T)otal orgs", 5, FONT_SIZE*2);
				
				for (int i=0; i< (Math.pow(2,click)-Math.pow(2,(click-1))); i++)
				{
					Random rand = new Random();
					double x = (width-160) * Math.abs(rand.nextDouble());
					double y = height * Math.abs(rand.nextDouble());
				
					Ellipse2D.Double dot = new Ellipse2D.Double(x+160,y,10,10);
	
					g2.fill(dot);
				}
					
				g2.drawString("R = " + click, 5, ((height/(cycles+2))*click+2*(height/(cycles+2))));
				g2.drawString("T = " + (int)Math.pow(2,click), 5, (height/(cycles+2))*click+FONT_SIZE+2*(height/(cycles+2)));
							
				System.out.println(Math.pow(2,click));
		
				try{
					Thread.sleep(1000);
				}
				catch(InterruptedException e){
					System.out.println("Error:" + e); 
				}
		
			}
			repaint();
		}
	}
	
	
	
}
