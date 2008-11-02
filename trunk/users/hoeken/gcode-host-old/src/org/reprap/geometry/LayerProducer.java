/*
 * Created on May 1, 2006
 *
 * Changed by Vik to reject polts of less than 0.05mm
 */
package org.reprap.geometry;

import java.io.IOException;
import javax.media.j3d.*;
import org.reprap.Printer;
import org.reprap.Attributes;
import org.reprap.Preferences;
import org.reprap.ReprapException;
import org.reprap.geometry.polygons.*;
import org.reprap.devices.pseudo.LinePrinter;
import org.reprap.utilities.Debug;

/**
 *
 */
class segmentSpeeds
{
	/**
	 * 
	 */
	public Rr2Point p1, p2, p3;
	
	/**
	 * 
	 */
	public double ca;
	
	/**
	 * 
	 */
	public boolean plotMiddle;
	
	/**
	 * 
	 */
	public boolean abandon;
	
	/**
	 * @param before
	 * @param now
	 * @param after
	 * @param fastLength
	 */
	public segmentSpeeds(Rr2Point before, Rr2Point now, Rr2Point after, double fastLength)
	{
		Rr2Point a = Rr2Point.sub(now, before);
		double amod = a.mod();
		abandon = amod == 0;
		if(abandon)
			return;
		Rr2Point b = Rr2Point.sub(after, now);
		if(b.mod() == 0)
			ca = 0;
		else
			ca = Rr2Point.mul(a.norm(), b.norm());
		plotMiddle = true;
		if(amod <= 2*fastLength)
		{
			fastLength = amod*0.5;
			plotMiddle = false;
		}
		a = a.norm();
		p1 = Rr2Point.add(before, Rr2Point.mul(a, fastLength));
		p2 = Rr2Point.add(p1, Rr2Point.mul(a, amod - 2*fastLength));
		p3 = Rr2Point.add(p2, Rr2Point.mul(a, fastLength));
	}
	
	int speed(double currentFeedrate, double angFac)
	{
		double fac = (1 - 0.5*(1 + ca)*angFac);
		return LinePrinter.speedFix((int)currentFeedrate, fac);
	}
}

/**
 *
 */
public class LayerProducer {
	
	/**
	 * Identifier for movements without depositing
	 */
	//private static int gapMaterial = 0;
	
	/**
	 * Identifier for the actual depositing material
	 */
	//private static int solidMaterial = 1;
	
	/**
	 * @return the gap material identifier
	 */
	//public static int gapMaterial() { return gapMaterial; }
	
	/**
	 * @return the filler material identifier
	 */
	//public static int solidMaterial() { return solidMaterial; }

	/**
	 * The shape of the object built so far under the current layer
	 */
	private BranchGroup lowerShell;

	/**
	 * 
	 */
	private Printer printer;
	
	/**
	 * 
	 */
	private RrPolygonList hatchedPolygons;
	
	/**
	 * 
	 */
	private RrPolygonList borderPolygons;
	
	/**
	 * 
	 */
	private RrCSGPolygon csg_p;
	
	/**
	 * 
	 */
	private double scale;
	
	/**
	 * 
	 */
	private double z;
	
	
	/**
	 * 
	 */
	private int commonBorder, commonHatch;
	
	/**
	 * 
	 */
	private double currentFeedrate;
	
	/**
	 * 
	 */
	private Rr2Point p_0;
	
	/**
	 * 
	 */
	private Rr2Point pos;
		
	/**
	 * @param printer
	 * @param zValue
	 * @param csgPol
	 * @param ls
	 * @param hatchDirection
	 */
	public LayerProducer(Printer printer, double zValue, RrCSGPolygonList csgPols, BranchGroup ls, RrHalfPlane hatchDirection) {
		this.printer = printer;
		lowerShell = ls;

		z = zValue;
		
		RrCSGPolygonList offBorder = csgPols.offset(printer.getExtruders(), true);
		RrCSGPolygonList offHatch = csgPols.offset(printer.getExtruders(), false);
		
		offBorder.divide(Preferences.tiny(), 1.01);
		offHatch.divide(Preferences.tiny(), 1.01);
		
		//RrGraphics g = new RrGraphics(offBorder, true);
		
		borderPolygons = offBorder.megList(); //(solidMaterial, solidMaterial);
		
		hatchedPolygons = new RrPolygonList();
		hatchedPolygons.add(offHatch.hatch(hatchDirection, printer.getExtruders()));
				//,solidMaterial, gapMaterial));	
	
//		RrPolygonList pllist = new RrPolygonList();
//		pllist.add(borderPolygons);
//		pllist.add(hatchedPolygons);
//		RrGraphics g = new RrGraphics(pllist, false);

		csg_p = null;
		
		RrBox big = csgPols.box().scale(1.1);
		
		double width = big.x().length();
		double height = big.y().length();
	}
	
	/**
	 * @return current X and Y position of the printer
	 */
	private Rr2Point posNow()
	{
		return new Rr2Point(printer.getX(), printer.getY());
	}
	
	/**
	 * speed up for short lines
	 * @param p
	 * @return
	 * @throws ReprapException
	 * @throws IOException
	 */
	private boolean shortLine(Rr2Point p) throws ReprapException, IOException
	{
		currentFeedrate = printer.getFeedrate();

		double shortLen = printer.getExtruder().getShortLength();
		if(shortLen < 0)
			return false;
		Rr2Point a = Rr2Point.sub(posNow(), p);
		double amod = a.mod();
		if(amod > shortLen) {
//			Debug.d("Long segment.  Current speed is: " + currentFeedrate);
			return false;
		}

		printer.setFeedrate(printer.getExtruder().getShortLineFeedrate());
// for some reason it was turning the extruder off at the end of a short line? - zach
//		printer.printTo(p.x(), p.y(), z, true);
		printer.printTo(p.x(), p.y(), z, false);

		//switch back now.
		printer.setFeedrate(currentFeedrate);
		
//		Debug.d("Short segment at speed " + printer.getExtruder().getShortLineFeedrate() + " derived from feedrate: " + printer.getExtruder().getXYFeedrate());
		return true;	
	}
	
	/**
	 * @param first First point, the start of the line segment to be plotted.
	 * @param second Second point, the end of the line segment to be plotted.
	 * @param turnOff True if the extruder should be turned off at the end of this segment.
	 * @throws ReprapException
	 * @throws IOException
	 */
	private void plot(Rr2Point first, Rr2Point second, boolean turnOff) throws ReprapException, IOException
	{
		if (printer.isCancelled())
			return;
		
		if(shortLine(first))
			return;
		
		double speedUpLength = printer.getExtruder().getAngleSpeedUpLength();
		if(speedUpLength > 0)
		{	
			currentFeedrate = printer.getFeedrate();
			
			segmentSpeeds ss = new segmentSpeeds(posNow(), first, second, 
					speedUpLength);
			if(ss.abandon)
				return;

			printer.printTo(ss.p1.x(), ss.p1.y(), z, false);

			if(ss.plotMiddle)
			{
				/*
				//old speed method
				int straightSpeed = LinePrinter.speedFix(currentFeedrate, (1 - 
						printer.getExtruder().getAngleSpeedFactor()));
				printer.setSpeed(straightSpeed);
				*/
				
				printer.setFeedrate(printer.getExtruder().getAngleFeedrate());
				printer.printTo(ss.p2.x(), ss.p2.y(), z, false);
			}

			//TODO: not entirely sure how to code this.
			printer.setFeedrate(printer.getExtruder().getAngleFeedrate());
			printer.printTo(ss.p3.x(), ss.p3.y(), z, turnOff);
//			printer.printTo(ss.p3.x(), ss.p3.y(), z, true);
// this was not respecting the turnOff variable - zach
			pos = ss.p3;
			// Leave speed set for the start of the next line.
		}
		else
			printer.printTo(first.x(), first.y(), z, turnOff);
//			printer.printTo(first.x(), first.y(), z, true);
// this was not respecting the turnOff variable - zach
	}

	/**
	 * @param first
	 * @param second
	 * @param startUp
	 * @param endUp
	 * @throws ReprapException
	 * @throws IOException
	 */
	private void move(Rr2Point first, Rr2Point second, boolean startUp, boolean endUp) 
		throws ReprapException, IOException
	{
		if (printer.isCancelled()) return;
		
		//save our original feedrate.
		double feedrate = printer.getFeedrate();

		if(startUp)
		{
			printer.setFeedrate(printer.getFastFeedrateXY());
			printer.moveTo(first.x(), first.y(), z, startUp, endUp);
			return;
		}

		//use our normal rate.
		printer.setFeedrate(feedrate);
		
		double speedUpLength = printer.getExtruder().getAngleSpeedUpLength();
		if(speedUpLength > 0)
		{
			segmentSpeeds ss = new segmentSpeeds(posNow(), first, second, 
					speedUpLength);
			if(ss.abandon)
				return;

			printer.moveTo(ss.p1.x(), ss.p1.y(), z, startUp, startUp);

			if(ss.plotMiddle)
			{
				//printer.setFeedrate(currentFeedrate);
				printer.moveTo(ss.p2.x(), ss.p2.y(), z, startUp, startUp);
			}

			//TODO: not sure exactly how to do this either.
			//printer.setFeedrate(ss.speed(currentFeedrate, printer.getExtruder().getAngleSpeedFactor()));
			printer.moveTo(ss.p3.x(), ss.p3.y(), z, startUp, endUp);
			pos = ss.p3;
			// Leave speed set for the start of the next movement.
		} else
			printer.moveTo(first.x(), first.y(), z, startUp, endUp);
	}


	/**
	 * Plot a polygon
	 * @throws IOException
	 * @throws ReprapException
	 */
	private void plot(RrPolygon p, boolean outline) throws ReprapException, IOException
	{
		int leng = p.size();
		
		if(leng <= 1)
			return;
		// If the length of the plot is <0.05mm, don't bother with it.
		// This will not spot an attempt to plot 10,000 points in 1mm.
		double plotDist=0;
		Rr2Point lastPoint=p.point(0);
		for (int i=1; i<leng; i++)
		{
			Rr2Point n=p.point(i);
			plotDist+=Rr2Point.d(lastPoint, n);
			lastPoint=n;
		}
		if (plotDist<Preferences.machineResolution()*0.5) {
			Debug.d("Rejected line with "+leng+"points, length"+plotDist);
			return;
		}

		double outlineFeedrate = printer.getExtruder().getOutlineFeedrate();
		double infillFeedrate = printer.getExtruder().getInfillFeedrate();
		
		Attributes att = p.getAttributes();
		
		printer.selectExtruder(att);
		
		if(outline && printer.getExtruder().randomStart())
			p = p.randomStart();
		
		
		int stopExtruding = leng + 10;
		double backLength = printer.getExtruder().getExtrusionOverRun();
		if(backLength > 0)
			stopExtruding = p.backStep(backLength, outline);
		
		if (printer.isCancelled()) return;
		
		printer.setFeedrate(printer.getFastFeedrateXY());
		move(p.point(0), p.point(1), true, false);

		plot(p.point(0), p.point(1), false);
		
		// Print any lead-in.
		printer.printStartDelay(printer.getExtruder().getExtrusionDelay());
		
		if(outline)
		{
			printer.setFeedrate(outlineFeedrate);
			currentFeedrate = outlineFeedrate;			
		}
		else
		{
			printer.setFeedrate(infillFeedrate);
			currentFeedrate = infillFeedrate;			
		}
		
		if(outline)
		{
			for(int j = 1; j <= leng; j++)
			{
				int i = j%leng;
				Rr2Point next = p.point((j+1)%leng);
				
				if (printer.isCancelled())
				{
					printer.getExtruder().stopExtruding();
					move(posNow(), posNow(), true, true);
					return;
				}
				
				if(j > stopExtruding)
				{
					printer.getExtruder().stopExtruding();
					move(p.point(i), next, false, false);
				} else
					plot(p.point(i), next, false);
			}
		}
		else
		{
			for(int i = 1; i < leng; i++)
			{
				Rr2Point next = p.point((i+1)%leng);
				
				if (printer.isCancelled())
				{
					printer.getExtruder().stopExtruding();
					move(posNow(), posNow(), true, true);
					return;
				}
				
				if(i > stopExtruding)
				{
					printer.getExtruder().stopExtruding();
					move(p.point(i), next, false, false);
				} else
					plot(p.point(i), next, false);
			}
		}
		
		move(posNow(), posNow(), true, true);
		
//		int f = p.flag(0);
//		for(int j = 1; j <= leng; j++)
//		{
//			int i = j%leng;
//			Rr2Point next = p.point((j+1)%leng);
//			
//			if (printer.isCancelled()) return;
//			
//			if(f != gapMaterial && j <= stopExtruding)
//				plot(p.point(i), next, false);
//			else
//			{
//				printer.getExtruder().stopExtruding();
//				if(f == gapMaterial)
//				{
//					if(j == leng)
//						return;
//					else
//						move(p.point(i), next, true, false);
//				}else
//					move(p.point(i), next, false, false);
//			}
//			f = p.flag(i);
//		}
	}
	


	private int plotOneMaterial(RrPolygonList polygons, int i, boolean outline)
		throws ReprapException, IOException
	{
		String material = polygons.polygon(i).getAttributes().getMaterial();
		
		while(i < polygons.size() && polygons.polygon(i).getAttributes().getMaterial().equals(material))
		{
			if (printer.isCancelled())
				return i;
			plot(polygons.polygon(i), outline);
			i++;
		}
		return i;
	}
	
	private boolean nextCommon(int ib, int ih)
	{
		commonBorder = ib;
		commonHatch = ih;
		
		for(int jb = ib; jb < borderPolygons.size(); jb++)
		{
			for(int jh = ih; jh < hatchedPolygons.size(); jh++)
			{
				if(borderPolygons.polygon(ib).getAttributes().getMaterial().equals(
						hatchedPolygons.polygon(ih).getAttributes().getMaterial()))
				{
					commonBorder = jb;
					commonHatch = jh;
					return true;
				}
			}
		}
		return false;
	}
		
	/**
	 * Master plot function - draw everything
	 * @throws IOException
	 * @throws ReprapException
	 */
	public void plot() throws ReprapException, IOException
	{
		int ib, jb, ih, jh;
		
		//borderPolygons = borderPolygons.filterShorts(Preferences.machineResolution()*2);
		//hatchedPolygons = hatchedPolygons.filterShorts(Preferences.machineResolution()*2);
		
		ib = 0;
		ih = 0;
		
		while(nextCommon(ib, ih)) 
		{	
			for(jb = ib; jb < commonBorder; jb++)
			{
				if (printer.isCancelled())
					break;
				plot(borderPolygons.polygon(jb), true);
			}
			ib = commonBorder;

			for(jh = ih; jh < commonHatch; jh++)
			{
				if (printer.isCancelled())
					break;
				plot(hatchedPolygons.polygon(jh), false);
			}
			ih = commonHatch;
			
			ib = plotOneMaterial(borderPolygons, ib, true);
			ih = plotOneMaterial(hatchedPolygons, ih, false);	
		}
		
		for(jb = ib; jb < borderPolygons.size(); jb++)
		{
			if (printer.isCancelled())
				break;
			plot(borderPolygons.polygon(jb), true);			
		}
		
		for(jh = ih; jh < commonHatch; jh++)
		{
			if (printer.isCancelled())
				break;
			plot(hatchedPolygons.polygon(jh), false);
		}

		printer.setLowerShell(lowerShell);
	}		
	
}