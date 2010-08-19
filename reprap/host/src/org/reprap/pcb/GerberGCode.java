package org.reprap.pcb;

import javax.media.j3d.Appearance;
import javax.media.j3d.Material;
import javax.vecmath.Color3f;
import org.reprap.pcb.Cords;
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
		float width, height;
		char type;
		
		public Aperture(int num, float width, char type, boolean inInch)
		{
			this.num = num;
			this.width = width;
			this.height = width;
			this.type = type;
			
			if(inInch)
			{
				this.width = this.width*25.4f;
			}
		}
		
		public Aperture(int num, float width, float height, char type, boolean inInch)
		{
			this.num = num;
			this.width = width;
			this.height = height;
			this.type = type;
			
			if(inInch)
			{
				this.width = this.width*25.4f;
				this.height = this.height*25.4f;
			}
		}
		
	}
	



	String gcodestr = "";
	boolean dawingOn = true;
	LinkedList <Aperture> apertures = new LinkedList<Aperture>(); 
	float penWidth;
	Aperture curAperture = null;
	boolean inInch=false;
	Cords lastCords = null;
	RrPolygonList thePattern = new RrPolygonList();
	RrPolygon currentPolygon = null;
	
	int XYFeedrate = 1000;
	int ZFeedrate = 70;

	float drawingHeight = 1.8f;
	float freemoveHeight = 3.8f;//1.7f;
	Appearance looksLike;
	
	public GerberGCode(float penWidth, float drawingHeight, float freemoveHeight, int XYFeedrate, int ZFeedrate)
	{
		this.penWidth = penWidth;
		this.drawingHeight = drawingHeight;
		this.freemoveHeight = freemoveHeight;
		this.XYFeedrate = XYFeedrate;
		this.ZFeedrate = ZFeedrate;
		
		enableAbsolute();
		
		looksLike = new Appearance();
		looksLike.setMaterial(new Material(new Color3f(0.5f, 0.5f, 0.5f), new Color3f(0f, 0f, 0f), new Color3f(0.5f, 0.5f, 0.5f), new Color3f(0f, 0f, 0f), 0f));
		
	}
	
	private void polygon(double x, double y)
	{
		if(currentPolygon == null && dawingOn)
		{
			currentPolygon = new RrPolygon(new Attributes(null, null, null, looksLike), false);
			currentPolygon.add(new Rr2Point(x, y));
			return;
		}
		if(!dawingOn)
		{
			if(currentPolygon != null)
				thePattern.add(new RrPolygon(currentPolygon));
			currentPolygon = null;
			return;
		}
		currentPolygon.add(new Rr2Point(x, y));
	}
	
	public void enableAbsolute()
	{
		gcodestr += "G90\n";
	}
	
	public void enableRelative()
	{
		gcodestr += "G91\n";
	}
	
	public void setMetric()
	{
		gcodestr += "G21\n";
	}
	
	public void setImperial()
	{
		inInch=true;
		setMetric();
		//gcodestr += "G20\n";
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
	
	public void addCircleAperture(int apertureNum, float width)
	{
		apertures.add(new Aperture(apertureNum, width, 'C', inInch));
	}
	
	public void addRectangleAperture(int apertureNum, float width, float height)
	{
		apertures.add(new Aperture(apertureNum, width, height, 'R', inInch));
	}
	
	public void addFeedForMove()
	{
		gcodestr +=  "G1 F"+XYFeedrate+"\n";
	}
	
	public void enableDrawing()
	{
		if(!dawingOn)
		{
			addFeedForMove();
			
			gcodestr += "G1 Z"+drawingHeight+" F"+ZFeedrate+" \n";	
			dawingOn = true;
		}
	}
	
	public void disableDrawing()
	{
		if(dawingOn)
		{
			addFeedForMove();
			
			gcodestr += "G1 Z"+freemoveHeight+" F"+ZFeedrate+"\n";	
			dawingOn = false;
		}
	}
	
	
	
	public void addLine(Cords end)
	{
		
		addLine(null, end);
		
	}
	
	public void addLine(Cords start, Cords end)
	{
		addLine(start, end, true);
	}
	
	public void addLine(Cords end, boolean multiline)
	{
		
		addLine(null, end, multiline);
	}
	
	public void addLine(Cords start, Cords end, boolean multiline)
	{
		Cords vec = new Cords(0,0, false);
		
		gcodestr += ";Drawing a Line\n";
		
		if(start == null)
		{
			start = lastCords.clone();
		}
		
		int numberOfLines = Math.round(curAperture.width/penWidth);
		if(numberOfLines < 1 || multiline == false) numberOfLines = 1;
		
		//System.out.println("Drawing "+numberOfLines);
		
		if(numberOfLines > 1)
		{
			float length, factor;
			vec = new Cords((end.y-start.y)*(-1), end.x-start.x, false);
			
			
			length = vec.length();
			factor = penWidth/length;
			
			//System.out.println(" VEC X:"+vec.x+" Y: "+vec.y+" ("+vec.length()+")");
			vec.mul(factor);
			

			// Cords offCord = vec.clone().mul(Math.round(numberOfLines/2f));
			
			Cords offCord = vec.clone().mul((1f/2f)*(numberOfLines/2f));
			
			//System.out.println(" Off X:"+offCord.x+" Y: "+offCord.y+" ("+offCord.length()+")");
			
			start.sub(offCord);
			end.sub(offCord);

		
			
		}

		enableDrawing();

		for(int curLine=1; curLine <= numberOfLines; curLine++)
		{
			
			/*if(lastCords.distance(end) < lastCords.distance(start))
			{
				Cords tmp = end;
				end = start;
				start = tmp;
				disableDrawing();
			}*/
			
			
			if(!lastCords.equals(start))
			{
				disableDrawing();
				addFeedForMove();				
				gcodestr += "G1 X"+start.x+" Y"+start.y+" F"+XYFeedrate+"\n";
				polygon(start.x, start.y);
			}
			
			enableDrawing();
			addFeedForMove();				
			gcodestr += "G1 X"+end.x+" Y"+end.y+"  F"+XYFeedrate+"\n";
			polygon(end.x, end.y);
			lastCords = new Cords(end.x, end.y, false);
			
			//disableDrawing();
			
			start.add(vec);
			end.add(vec);
		}			
		
		
			
		//start.x += penWidth;
		//start.y += penWidth;
		//end.x += penWidth;
		//end.y += penWidth;
			
			
		
	}
	
	public void goTo(Cords p)
	{
		gcodestr += ";GoTo\n";
		
		disableDrawing();
		addFeedForMove();
		gcodestr += "G1 X"+p.x+" Y"+p.y+" F2000\n";
		polygon(p.x, p.y);
		lastCords = new Cords(p.x, p.y, false);
	}
	
	public void exposePoint(Cords p)
	{
		//if(curAperture.type == 'C')
		//	createCircle(p);
		//else
			createRec(p);
		
	}
	
	public void createRec(Cords p)
	{
		float startX, startY, endX, endY;
		
		gcodestr += ";Creating Rect\n";
		
		float recWidth = curAperture.width/2.0f;
		float recHeight = curAperture.height/2.0f;
		
		startX = p.x-recWidth;
		startY = p.y-recHeight;
		endX = p.x+recWidth;
		endY = p.y-recHeight;		
		//addLine(new Cords(startX, startY, false));
		goTo(new Cords(startX, startY, false));
		enableDrawing();
		//  ---->
		//  |   |
		addLine(new Cords(endX, endY, false), false);
			
		endX = p.x+recWidth;
		endY = p.y+recHeight;
		//   ____
		//  |    : 
		addLine(new Cords(endX, endY, false), false);
		
		endX = p.x-recWidth;
		endY = p.y+recHeight;				
		//  |    |
		//  <-----
		addLine(new Cords(endX, endY, false), false);
		
		endX = p.x-recWidth;
		endY = p.y-recHeight;				
		//  ^     |
		//  :_____|
		addLine(new Cords(endX, endY, false), false);
		

		

		disableDrawing();
		gcodestr += ";End Rect\n";
		
	}
	
	public void createCircle(Cords p)
	{
		float x,y;
		//FIXME
		for(float i=0; i < curAperture.width; i+=0.3)
		{
			
			y = (float) (p.y + Math.sqrt( Math.pow(curAperture.width, 2)  - Math.pow(i,2) )); 
			addLine(null, new Cords(p.x+i, y, false));
		}
		
		for(float i=0; i < curAperture.width; i+=0.3)
		{
			
			y = (float) (p.y - Math.sqrt( Math.pow(curAperture.width, 2)  - Math.pow(i,2) )); 
			addLine(null, new Cords(p.x+i, y, false));
		}
	}
	
	public String getGCode()
	{
		disableDrawing();
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

		return gcodestr;
	}
	



}
