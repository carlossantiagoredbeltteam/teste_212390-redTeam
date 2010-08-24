package org.reprap.pcb;

import javax.media.j3d.Appearance;
import javax.media.j3d.Material;
import javax.vecmath.Color3f;
//import org.reprap.pcb.Coords;
import org.reprap.geometry.polygons.*;
//import org.reprap.Attributes;
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
	BooleanGrid pcb;
	Rr2Point lastCoords = null;
	RrPolygonList thePattern = new RrPolygonList();
//	RrPolygon currentPolygon = null;
	
	Appearance looksLike;
	
	public GerberGCode(double penWidth, BooleanGrid p) //, double drawingHeight, double freemoveHeight, int XYFeedrate, int ZFeedrate)
	{
		this.penWidth = penWidth;
		enableAbsolute();
		disableDrawing();
		pcb = p;
		lastCoords = new Rr2Point(0, 0);
		looksLike = new Appearance();
		looksLike.setMaterial(new Material(new Color3f(0.5f, 0.5f, 0.5f), new Color3f(0f, 0f, 0f), new Color3f(0.5f, 0.5f, 0.5f), new Color3f(0f, 0f, 0f), 0f));
	}
	
	public RrRectangle drawLine(Rr2Point c)
	{
		return drawFatLine(fixCoords(c));
	}	
	
	public void goTo(Rr2Point c)
	{
		lastCoords = new Rr2Point(fixCoords(c));
//		disableDrawing();
//		addPointToPolygons(fixCoords(c));
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
	
	public RrRectangle exposePoint(Rr2Point c)
	{
		if(curAperture.type == 'C')
			return createCircle(fixCoords(c));
		else
			return createRec(fixCoords(c));
		
	}
	
	public RrRectangle createRec(Rr2Point c)
	{	
		//TODO: make this fill the rectangle
		double recWidth = curAperture.width/2.0f;
		double recHeight = curAperture.height/2.0f;
		c = fixCoords(c);
		Rr2Point p = new Rr2Point(recWidth, recHeight);
		RrRectangle result = new RrRectangle(Rr2Point.sub(c, p), Rr2Point.add(c, p));
		if(pcb == null)
			return result;
		pcb.homogeneous(result.sw(), result.ne(), true);
		return result;
	}
	
	public RrRectangle createCircle(Rr2Point c)
	{
		RrRectangle result = circleToRectangle(c);
		if(pcb == null)
			return result;
		pcb.disc(c, curAperture.width*0.5, true);
		//octagon(fixCoords(c), curAperture.width);
		return result;
	}
	
	public RrPolygonList getPolygons()
	{
		try 
		{
			if(Preferences.loadGlobalBool("DisplaySimulation"))
			{
				RrGraphics simulationPlot = new RrGraphics("PCB simulation");
//				if(currentPolygon != null)
//					thePattern.add(new RrPolygon(currentPolygon));
				simulationPlot.init(pcb.box(), false, 0);
				simulationPlot.add(pcb);
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return thePattern;
	}
	
//	private void addPointToPolygons(Rr2Point c)
//	{		
//		if(currentPolygon == null && dawingOn)
//		{
//			currentPolygon = new RrPolygon(new Attributes(null, null, null, looksLike), false);
//			currentPolygon.add(new Rr2Point(c));
//		} else if(!dawingOn)
//		{
//			if(currentPolygon != null)
//				if(currentPolygon.size() > 1)
//					thePattern.add(new RrPolygon(currentPolygon));
//			currentPolygon = new RrPolygon(new Attributes(null, null, null, looksLike), false);
//			currentPolygon.add(new Rr2Point(c));
//		} else
//			currentPolygon.add(new Rr2Point(c));
//		
//		lastCoords = new Rr2Point(c);
//		enableDrawing();
//	}
	
	private RrRectangle circleToRectangle(Rr2Point c)
	{
		Rr2Point p = new Rr2Point(0.5*curAperture.width, 0.5*curAperture.width);
		return new RrRectangle(Rr2Point.sub(c, p), Rr2Point.add(c, p));
	}
	
//	private void octagon(Rr2Point p, double diameter)
//	{
//		double x, y, r;
//		double ang = 22.5*Math.PI/180;
//		r = 0.5*diameter;
//		Rr2Point q;
//		disableDrawing();
//		for(int i = 0; i <= 8; i++)
//		{
//			q = new Rr2Point(p);
//			q = Rr2Point.add(q, new Rr2Point(r*Math.cos(ang), r*Math.sin(ang)));
//			addPointToPolygons(q);
//			ang += 0.25*Math.PI;
//		}
//		disableDrawing();		
//	}
	
//	private void drawOneLine(Rr2Point c)
//	{
//		addPointToPolygons(c);
//	}
	
	private RrRectangle drawFatLine(Rr2Point c)
	{
		RrRectangle result = circleToRectangle(c);
		result = RrRectangle.union(result, circleToRectangle(lastCoords));
		if(pcb == null)
			return result;
		//TODO: make this draw a fat line
		pcb.rectangle(lastCoords, c, 0.5*curAperture.width, true);
		pcb.disc(c, curAperture.width*0.5, true);
		pcb.disc(lastCoords, curAperture.width*0.5, true);
		lastCoords = new Rr2Point(c);
		return result;
	}

	private void enableDrawing()
	{
		dawingOn = true;
	}
	
	private void disableDrawing()
	{	
		dawingOn = false;
	}
	
	Rr2Point fixCoords(Rr2Point c)
	{
		if(!absolute)
		{
			c = new Rr2Point(c);
			c = Rr2Point.add(c, lastCoords);
		}
		return c;
	}

}
