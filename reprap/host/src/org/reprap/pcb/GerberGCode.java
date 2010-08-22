package org.reprap.pcb;

import javax.media.j3d.Appearance;
import javax.media.j3d.Material;
import javax.vecmath.Color3f;
import org.reprap.pcb.Coords;
import org.reprap.geometry.polygons.*;
import org.reprap.Attributes;
import org.reprap.utilities.RrGraphics;
import org.reprap.Preferences;

import java.io.IOException;
import java.util.Iterator;
import java.util.LinkedList;

//import GerberGCode.Aperture;

public class GerberGCode {
	
	private class Aperture
	{
		int num;
		double width, height;
		char type;
		
		public Aperture(int num, double width, char type)
		{
			this.num = num;
			this.width = width;
			this.height = width;
			this.type = type;
		}
		
		public Aperture(int num, double width, double height, char type)
		{
			this.num = num;
			this.width = width;
			this.height = height;
			this.type = type;
		}
		
	}
	
	boolean dawingOn = false;
	LinkedList <Aperture> apertures = new LinkedList<Aperture>(); 
	double penWidth;
	Aperture curAperture = null;
	boolean absolute = true;
	Coords lastCoords = null;
	RrPolygonList thePattern = new RrPolygonList();
	RrPolygon currentPolygon = null;
	
	Appearance looksLike;
	
	public GerberGCode(double penWidth, double drawingHeight, double freemoveHeight, int XYFeedrate, int ZFeedrate)
	{
		this.penWidth = penWidth;
		enableAbsolute();
		disableDrawing();
		lastCoords = new Coords(0, 0);
		looksLike = new Appearance();
		looksLike.setMaterial(new Material(new Color3f(0.5f, 0.5f, 0.5f), new Color3f(0f, 0f, 0f), new Color3f(0.5f, 0.5f, 0.5f), new Color3f(0f, 0f, 0f), 0f));
	}
	
	public void drawLine(Coords c)
	{
		drawFatLine(fixCoords(c));
	}	
	
	public void goTo(Coords c)
	{
		disableDrawing();
		addPointToPolygons(fixCoords(c));
	}
	
	public void enableAbsolute()
	{
		absolute = true;
	}
	
	public void enableRelative()
	{
		absolute = false;
	}
	
	public void selectAperture(int aperture)
	{
		Iterator<Aperture> itr = apertures.iterator();
		Aperture cur;
		
		while(itr.hasNext())
		{
			cur = itr.next();
			if(cur.num == aperture)
			{
				curAperture = cur;
				break;
			}
		}
	}
	
	public void addCircleAperture(int apertureNum, double width)
	{
		apertures.add(new Aperture(apertureNum, width, 'C'));
	}
	
	public void addRectangleAperture(int apertureNum, double width, double height)
	{
		apertures.add(new Aperture(apertureNum, width, height, 'R'));
	}
	
	public void exposePoint(Coords c)
	{
		if(curAperture.type == 'C')
			createCircle(fixCoords(c));
		else
			createRec(fixCoords(c));
		
	}
	
	public void createRec(Coords c)
	{	
		//TODO: make this fill the rectangle
		double recWidth = curAperture.width/2.0f;
		double recHeight = curAperture.height/2.0f;
		c = fixCoords(c);
		Coords x = new Coords(recWidth, 0);
		Coords y = new Coords(0, recHeight);
		Coords sw = c.clone();
		Coords nw = c.clone();
		Coords ne = c.clone();
		Coords se = c.clone();		
		sw.sub(x);
		sw.sub(y);
		nw.sub(x);
		nw.add(y);
		ne.add(x);
		ne.add(y);
		se.add(x);
		se.sub(y);
		disableDrawing();	
		drawOneLine(sw);
		drawOneLine(nw);
		drawOneLine(ne);
		drawOneLine(se);
		drawOneLine(sw);		
		disableDrawing();		
	}
	
	public void createCircle(Coords c)
	{
		//TODO: make this fill the circle
		octagon(fixCoords(c), curAperture.width);
	}
	
	public RrPolygonList getPolygons()
	{
		try 
		{
			if(Preferences.loadGlobalBool("DisplaySimulation"))
			{
				RrGraphics simulationPlot = new RrGraphics("PCB simulation");
				if(currentPolygon != null)
					thePattern.add(new RrPolygon(currentPolygon));
				simulationPlot.init(thePattern.getBox(), false, 0);
				simulationPlot.add(thePattern);
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return thePattern;
	}
	
	private void addPointToPolygons(Coords c)
	{		
		if(currentPolygon == null && dawingOn)
		{
			currentPolygon = new RrPolygon(new Attributes(null, null, null, looksLike), false);
			currentPolygon.add(new Rr2Point(c.x, c.y));
		} else if(!dawingOn)
		{
			if(currentPolygon != null)
				if(currentPolygon.size() > 1)
					thePattern.add(new RrPolygon(currentPolygon));
			currentPolygon = new RrPolygon(new Attributes(null, null, null, looksLike), false);
			currentPolygon.add(new Rr2Point(c.x, c.y));
		} else
			currentPolygon.add(new Rr2Point(c.x, c.y));
		
		lastCoords = c.clone();
		enableDrawing();
	}
	
	private void octagon(Coords p, double diameter)
	{
		double x, y, r;
		double ang = 22.5*Math.PI/180;
		r = 0.5*diameter;
		Coords q;
		disableDrawing();
		for(int i = 0; i <= 8; i++)
		{
			q = p.clone();
			q.add(new Coords(r*Math.cos(ang), r*Math.sin(ang)));
			addPointToPolygons(q);
			ang += 0.25*Math.PI;
		}
		disableDrawing();		
	}
	
	private void drawOneLine(Coords c)
	{
		addPointToPolygons(c);
	}
	
	private void drawFatLine(Coords c)
	{
		//TODO: make this draw a fat line
		double r = 0.5*curAperture.width;
		addPointToPolygons(c);
	}

	private void enableDrawing()
	{
		dawingOn = true;
	}
	
	private void disableDrawing()
	{	
		dawingOn = false;
	}
	
	Coords fixCoords(Coords c)
	{
		if(!absolute)
		{
			c = c.clone();
			c.add(lastCoords);
		}
		return c;
	}

}
