/*

RepRap
------

The Replicating Rapid Prototyper Project


Copyright (C) 2005
Adrian Bowyer & The University of Bath

http://reprap.org

Principal author:

Adrian Bowyer
Department of Mechanical Engineering
Faculty of Engineering and Design
University of Bath
Bath BA2 7AY
U.K.

e-mail: A.Bowyer@bath.ac.uk

RepRap is free; you can redistribute it and/or
modify it under the terms of the GNU Library General Public
Licence as published by the Free Software Foundation; either
version 2 of the Licence, or (at your option) any later version.

RepRap is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Library General Public Licence for more details.

For this purpose the words "software" and "library" in the GNU Library
General Public Licence are taken to mean any and all computer programs
computer files data results documents and other copyright information
available from the RepRap project.

You should have received a copy of the GNU Library General Public
Licence along with RepRap; if not, write to the Free
Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA,
or see

http://www.gnu.org/

=====================================================================


rr_graphics: Simple 2D graphics

First version 20 May 2005
This version: 9 October 2005 (translation to Java)

*/

import java.awt.*;
import javax.swing.*;
    
class rr_graphics 
{
    private final int frameWidth = 600;
    private int frameHeight;
    private rr_p_list p_list;
    private double scale;
    private rr_2point p_0;
    private rr_2point pos;
    private Graphics2D g2d;

    rr_graphics(rr_p_list pl) 
    {
	p_list = pl;

	rr_box big = pl.box.scale(1.1);

        double width = big.x.length();
        double height = big.y.length();
	frameHeight = (int)(0.5 + (frameWidth*height)/width);
        double xs = (double)frameWidth/width;
        double ys = (double)frameHeight/height;

        if (xs < ys)
            scale = xs;
        else
            scale = ys;
        p_0 = new rr_2point((frameWidth - (width + 2*big.x.low)*scale)*0.5,
			   (frameHeight - (height + 2*big.y.low)*scale)*0.5);

	pos = new rr_2point(width*0.5, height*0.5);

	// Display the frame

	JFrame frame = new JFrame();
	frame.setSize(frameWidth, frameHeight);
	frame.getContentPane().add(new MyComponent());
	frame.setVisible(true);
    }

    private rr_2point transform(rr_2point p)
    {
        return new rr_2point(p_0.x + scale*p.x, (double)frameHeight - (p_0.y + scale*p.y));
    }

    private void move(rr_2point p)
    {
        pos = transform(p);
    }

    private void plot(rr_2point p)
    {
        rr_2point a = transform(p);
        g2d.drawLine((int)(pos.x + 0.5), (int)(pos.y + 0.5), 
		     (int)(a.x + 0.5), (int)(a.y + 0.5));
	pos = a;
    }

    private void colour(int c)
    {
	switch(c)
	    {
	    case 0:
		g2d.setColor(Color.white);
		break;

	    case 1:
		g2d.setColor(Color.black);
		break;

	    case 2:
		g2d.setColor(Color.red);
		break;

	    case 3:
		g2d.setColor(Color.green);
		break;

	    case 4:
		g2d.setColor(Color.blue);
		break;

	    default:
		g2d.setColor(Color.orange);
		break;

	    }
    }

    private void plot(rr_polygon p)
    {
	int leng = p.points.size();
	for(int j = 0; j <= leng; j++)
	    {
		int i = j%leng;
		int f = ((Integer)(p.flags.get(i))).intValue();
		if(f != 0 && j != 0)
		    {
			colour(f);
			plot((rr_2point)p.points.get(i));
		    } else
		    move((rr_2point)p.points.get(i)); 
	    }
    }


    private void plot()
    {
	int leng = p_list.polygons.size();
	for(int i = 0; i < leng; i++)
	   plot((rr_polygon)p_list.polygons.get(i));
    }
    
    class MyComponent extends JComponent 
    {
	// This method is called whenever the contents needs to be painted
	public void paint(Graphics g) 
	{
	    // Retrieve the graphics context; this object is used to paint shapes
	    g2d = (Graphics2D)g;
    
	    plot();
	}
    }
}
