/*
 * Created on May 1, 2006
 *
 * Changed by Vik to reject polts of less than 0.05mm
 */
package org.reprap.geometry;

import java.io.IOException;

import javax.media.j3d.BranchGroup;

import org.reprap.Printer;
import org.reprap.Extruder;
import org.reprap.Attributes;
import org.reprap.Preferences;
import org.reprap.ReprapException;
import org.reprap.devices.pseudo.LinePrinter;
import org.reprap.geometry.polygons.Rr2Point;
import org.reprap.geometry.polygons.RrCSGPolygonList;
import org.reprap.geometry.polygons.RrCSGPolygon;
import org.reprap.geometry.polygons.RrPolygon;
import org.reprap.geometry.polygons.RrPolygonList;
import org.reprap.utilities.Debug;
import org.reprap.utilities.RrGraphics;

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
	
	int speed(int currentSpeed, double angFac)
	{
		double fac = (1 - 0.5*(1 + ca)*angFac);
		return LinePrinter.speedFix(currentSpeed, fac);
	}
}

/**
 *
 */
public class LayerProducer {
	
	private RrGraphics simulationPlot = null;
	
	/**
	 * 
	 */
	private LayerRules layerConditions = null;
	
	/**
	 * 
	 */
	private boolean paused = false;

	/**
	 * The shape of the object built so far under the current layer
	 */
	private BranchGroup lowerShell = null;

	
	/**
	 * The polygons to infill
	 */
	private RrPolygonList hatchedPolygons = null;
	
	/**
	 * The polygons to outline
	 */
	private RrPolygonList borderPolygons = null;
	
	/**
	 * CSG representation of the polygons as input
	 */
	private RrCSGPolygonList csgP = null;
	
	/**
	 * CSG representation of the polygons offset by the width of
	 * the extruders
	 */
	RrCSGPolygonList offBorder = null;
	
	/**
	 * CSG representation of the polygons offset by the factor of the
	 * width of the extruders needed to lay down internal cross-hatching
	 */	
	RrCSGPolygonList offHatch = null;
	
	/**
	 * Counters use so that each material is plotted completely before
	 * moving on to the next.
	 */
	private int commonBorder, commonHatch;
	
	/**
	 * The clue is in the name...
	 */
	private double currentFeedrate;
	
	/**
	 * Record the end of each polygon as a clue where to start next
	 */
	private Rr2Point startNearHere = null;
	
	private boolean shellSet = false;
	
	/**
	 * Flag to prevent cyclic graphs going round forever
	 */
	private boolean beingDestroyed = false;
	
	/**
	 * Destroy me and all that I point to
	 */
	public void destroy() 
	{
		if(beingDestroyed) // Prevent infinite loop
			return;
		beingDestroyed = true;
		
		// Keep the lower shell - the graphics system is using it
		
		//lowerShell = null;

		// Keep the printer; that's needed for the next layer

		//printer = null;
		
		if(hatchedPolygons != null)
			hatchedPolygons.destroy();
		hatchedPolygons = null;
		
		if(borderPolygons != null)
			borderPolygons.destroy();
		borderPolygons = null;
		
		if(csgP != null)
			csgP.destroy();
		csgP = null;
		
		if(offBorder != null)
			offBorder.destroy();
		offBorder = null;
		
		if(offHatch != null)
			offHatch.destroy();
		offHatch = null;
		
		if(startNearHere != null)
			startNearHere.destroy();
		startNearHere = null;
		beingDestroyed = false;
	}
	
	/**
	 * Destroy just me
	 */
	protected void finalize() throws Throwable
	{
		// Keep the lower shell - the graphics system is using it
		
		//lowerShell = null;

		// Keep the printer; that's needed for the next layer

		//printer = null;
		
		hatchedPolygons = null;
		borderPolygons = null;
		csgP = null;
		offBorder = null;
		offHatch = null;
		startNearHere = null;
		super.finalize();
	}
	
		
	/**
	 * @param printer
	 * @param zValue
	 * @param csgPol
	 * @param ls
	 * @param hatchDirection
	 */
	public LayerProducer(RrCSGPolygonList csgPols, BranchGroup ls, LayerRules lc, RrGraphics simPlot) throws Exception 
	{
		layerConditions = lc;
		startNearHere = null;
		lowerShell = ls;
		shellSet = false;
		simulationPlot = simPlot;
		
		csgP = csgPols;
		
		//supportCalculations();
		
		offHatch = csgPols.offset(layerConditions, false);
		
		//RrGraphics g = new RrGraphics(offBorder, true);
		
		if(layerConditions.getLayingSupport())
		{
			borderPolygons = null;
			offHatch = offHatch.union(lc.getPrinter().getExtruders());
//			hatchedPolygons = offHatch.megList();
//			RrPolygon allHatch = new RrPolygon(hatchedPolygons.polygon(0).getAttributes());
//			for(int i = 0; i < hatchedPolygons.size(); i++)
//				allHatch.add(hatchedPolygons.polygon(i));
//			offHatch = new RrCSGPolygonList();
//			offHatch.add(new RrCSGPolygon(allHatch.CSGConvexHull(), hatchedPolygons.getBox(), hatchedPolygons.polygon(0).getAttributes()));
//			offHatch.divide(Preferences.tiny(), 1.01);
		} else
		{
			offBorder = csgPols.offset(layerConditions, true);
			offBorder.divide(Preferences.tiny(), 1.01);
			borderPolygons = offBorder.megList();
			borderPolygons.setClosed(true);
		}
		
		offHatch.divide(Preferences.tiny(), 1.01);		
		hatchedPolygons = new RrPolygonList();
		hatchedPolygons.add(offHatch.hatch(layerConditions));
		hatchedPolygons.setClosed(false);
		
		if(simulationPlot != null)
		{
			RrPolygonList pl = new RrPolygonList();
			pl.add(hatchedPolygons);
			if(borderPolygons != null)
				pl.add(borderPolygons);
			if(!simulationPlot.isInitialised())
				simulationPlot.init(pl.getBox(), false);
			simulationPlot.add(pl);
		}
	
//		RrPolygonList pllist = new RrPolygonList();
//		if(!layerConditions.getLayingFoundations())
//			pllist.add(borderPolygons);
//		pllist.add(hatchedPolygons);
//		RrGraphics g = new RrGraphics(pllist);
		
//		RrBox big = csgPols.box().scale(1.1);
		
//		double width = big.x().length();
//		double height = big.y().length();
	}
	
	private void supportCalculations()
	{
		if(!layerConditions.getTopDown())
			return;
		RrCSGPolygonList above = layerConditions.getLayer(1);
		if(above == null)
		{
			layerConditions.recordThisLayer(csgP);
			return;
		}
		Extruder [] es = layerConditions.getPrinter().getExtruders();
		
		RrCSGPolygonList supports = new RrCSGPolygonList();
		RrCSGPolygonList thisForTheRecord = new RrCSGPolygonList();
		
		for(int i = 0; i < csgP.size(); i++)
		{
			RrCSGPolygon pgThisLevel = csgP.get(i);
			Attributes aThisLevel = pgThisLevel.getAttributes();
			Extruder eThisLevel = aThisLevel.getExtruder(es);
			String supportName = eThisLevel.getSupportMaterial();
			if(!supportName.contentEquals("null"))
			{
				RrCSGPolygon aboveLevel = above.find(aThisLevel);
				if(aboveLevel != null)
				{
					RrCSGPolygon toRemember = RrCSGPolygon.union(aboveLevel, pgThisLevel);
					toRemember = toRemember.reEvaluate();
					thisForTheRecord.add(toRemember);
					RrCSGPolygon grown = pgThisLevel.offset(layerConditions.getZStep());
					RrCSGPolygon sup = RrCSGPolygon.difference(aboveLevel, grown);
					sup = sup.reEvaluate();
					sup.setAttributes(new Attributes(supportName, null, null, null));
					supports.add(sup);
				}
			}
		}
		
		layerConditions.recordThisLayer(thisForTheRecord);
		csgP.add(supports);
		
	}
	
	/**
	 * Stop printing
	 *
	 */
	public void pause()
	{
		paused = true;
	}
	
	/**
	 * Start printing
	 *
	 */
	public void resume()
	{
		paused = false;
	}
	
	/**
	 * @return current X and Y position of the printer
	 */
	private Rr2Point posNow()
	{
		return new Rr2Point(layerConditions.getPrinter().getX(), layerConditions.getPrinter().getY());
	}
	
	/**
	 * speed up for short lines
	 * @param p
	 * @return
	 * @throws ReprapException
	 * @throws IOException
	 */
	private boolean shortLine(Rr2Point p, boolean stopExtruder, boolean closeValve) throws ReprapException, IOException
	{
		Printer printer = layerConditions.getPrinter();
		double shortLen = printer.getExtruder().getShortLength();
		if(shortLen < 0)
			return false;
		Rr2Point a = Rr2Point.sub(posNow(), p);
		double amod = a.mod();
		if(amod > shortLen) {
//			Debug.d("Long segment.  Current feedrate is: " + currentFeedrate);
			return false;
		}

		printer.setFeedrate(printer.getExtruder().getShortLineFeedrate());
// TODO: FIX THIS
//		printer.setSpeed(LinePrinter.speedFix(printer.getExtruder().getXYSpeed(), 
//				printer.getExtruder().getShortSpeed()));
		printer.printTo(p.x(), p.y(), layerConditions.getMachineZ(), stopExtruder, closeValve);
		printer.setFeedrate(currentFeedrate);
		return true;	
	}
	
	/**
	 * @param first First point, the end of the line segment to be plotted to from the current position.
	 * @param second Second point, the end of the next line segment; used for angle calculations
	 * @param turnOff True if the extruder should be turned off at the end of this segment.
	 * @throws ReprapException
	 * @throws IOException
	 */
	private void plot(Rr2Point first, Rr2Point second, boolean stopExtruder, boolean closeValve) throws ReprapException, IOException
	{
		Printer printer = layerConditions.getPrinter();
		if (printer.isCancelled()) return;
		
		// Don't call delay; this isn't controlling the printer
		while(paused)
		{
			try
			{
				Thread.sleep(200);
			} catch (Exception ex) {}
		}
		
		if(shortLine(first, stopExtruder, closeValve))
			return;
		
		double z = layerConditions.getMachineZ();
		
		double speedUpLength = printer.getExtruder().getAngleSpeedUpLength();
		if(speedUpLength > 0)
		{
			segmentSpeeds ss = new segmentSpeeds(posNow(), first, second, 
					speedUpLength);
			if(ss.abandon)
				return;

			printer.printTo(ss.p1.x(), ss.p1.y(), z, false, false);

			if(ss.plotMiddle)
			{
//TODO: FIX THIS.
//				int straightSpeed = LinePrinter.speedFix(currentSpeed, (1 - 
//						printer.getExtruder().getAngleSpeedFactor()));
				printer.setFeedrate(printer.getExtruder().getAngleFeedrate());
				printer.printTo(ss.p2.x(), ss.p2.y(), z, false, false);
			}

			//printer.setSpeed(ss.speed(currentSpeed, printer.getExtruder().getAngleSpeedFactor()));
			
			printer.setFeedrate(printer.getExtruder().getAngleFeedrate());
			printer.printTo(ss.p3.x(), ss.p3.y(), z, stopExtruder, closeValve);
			//pos = ss.p3;
		// Leave speed set for the start of the next line.
		} else
			printer.printTo(first.x(), first.y(), z, stopExtruder, closeValve);
	}

	/**
	 * @param first
	 * @param second
	 * @param startUp
	 * @param endUp
	 * @throws ReprapException
	 * @throws IOException
	 */
	private void move(Rr2Point first, Rr2Point second, boolean startUp, boolean endUp, boolean fast) 
		throws ReprapException, IOException
	{
		Printer printer = layerConditions.getPrinter();
		if (printer.isCancelled()) return;
		
//		 Don't call delay; this isn't controlling the printer
		while(paused)
		{
			try
			{
				Thread.sleep(200);
			} catch (Exception ex) {}
		}
		
		double z = layerConditions.getMachineZ();
		
		//if(startUp)
		if(fast)
		{
			printer.setFeedrate(printer.getFastFeedrateXY());
			printer.moveTo(first.x(), first.y(), z, startUp, endUp);
			return;
		}
		
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
				printer.setFeedrate(currentFeedrate);
				printer.moveTo(ss.p2.x(), ss.p2.y(), z, startUp, startUp);
			}

			//TODO: FIX ME!
			//printer.setSpeed(ss.speed(currentSpeed, printer.getExtruder().getAngleSpeedFactor()));
			
			printer.setFeedrate(printer.getExtruder().getAngleFeedrate());
			printer.moveTo(ss.p3.x(), ss.p3.y(), z, startUp, endUp);
			//pos = ss.p3;
			// Leave speed set for the start of the next movement.
		} else
			printer.moveTo(first.x(), first.y(), z, startUp, endUp);
	}


	/**
	 * Plot a polygon
	 * @throws IOException
	 * @throws ReprapException
	 * @return
	 */
	private void plot(RrPolygon p, boolean outline, boolean firstOneInLayer) throws ReprapException, IOException
	{
		int leng = p.size();
	
		if(leng <= 1)
		{
			startNearHere = null;
			return;
		}

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
			Debug.d("Rejected line with "+leng+" points, length: "+plotDist);
			startNearHere = null;
			return;
		}

		Printer printer = layerConditions.getPrinter();		
		Attributes att = p.getAttributes();
		
		/* changed for feedrate stuff. - ZMS
		int baseSpeed = att.getExtruder(printer.getExtruders()).getXYSpeed();
		int outlineSpeed = LinePrinter.speedFix(baseSpeed, 
				att.getExtruder(printer.getExtruders()).getOutlineSpeed(layerConditions));
		int infillSpeed = LinePrinter.speedFix(baseSpeed, 
				att.getExtruder(printer.getExtruders()).getInfillSpeed(layerConditions));
		*/
		
		/* double baseFeedrate = */ att.getExtruder(printer.getExtruders()).getXYFeedrate();
		double outlineFeedrate = att.getExtruder(printer.getExtruders()).getOutlineFeedrate();
		double infillFeedrate = att.getExtruder(printer.getExtruders()).getInfillFeedrate();
		
		printer.selectExtruder(att);
		
		// Warning: if incrementedStart is activated, this will override the randomStart
		if(outline && printer.getExtruder().incrementedStart())
			p = p.incrementedStart(layerConditions);
		else if(outline && printer.getExtruder().randomStart())
			p = p.randomStart();
		
		// The last point is near where we want to start next
		if(outline)
			startNearHere = p.point(0);	
		else
			startNearHere = p.point(p.size() - 1);
		
		int stopExtruding = leng + 10;
		int stopValve = stopExtruding;
		double extrudeBackLength = printer.getExtruder().getExtrusionOverRun();
		double valveBackLength = printer.getExtruder().getValveOverRun();
		if(extrudeBackLength >= valveBackLength)
		{
			if(extrudeBackLength > 0)
				stopExtruding = p.backStep(extrudeBackLength, outline);
			if(valveBackLength > 0)
				stopValve = p.backStep(valveBackLength, outline);
		} else
		{
			if(valveBackLength > 0)
				stopValve = p.backStep(valveBackLength, outline);
			if(extrudeBackLength > 0)
				stopExtruding = p.backStep(extrudeBackLength, outline);			
		}
		
		if (printer.isCancelled()) return;
		
		// If getMinLiftedZ() is negative, never lift the head
		
		Boolean lift = printer.getExtruder().getMinLiftedZ() >= 0;
		
		printer.setFeedrate(printer.getFastFeedrateXY());
		move(p.point(0), p.point(1), lift, false, true);

		//printer.getExtruder().setMotor(true);
		plot(p.point(0), p.point(1), false, false);
		
		// Print any lead-in.
		printer.printStartDelay(firstOneInLayer);
				
		if(outline)
		{
			printer.setFeedrate(outlineFeedrate);
			currentFeedrate = outlineFeedrate;			
		} else
		{
			printer.setFeedrate(infillFeedrate);
			currentFeedrate = infillFeedrate;			
		}
		
		if(outline)
		{
			for(int j = 1; j <= p.size(); j++)
			{
				int i = j%p.size();
				Rr2Point next = p.point((j+1)%p.size());
				
				if (printer.isCancelled())
				{
					printer.stopMotor();
					move(posNow(), posNow(), lift, true, true);
					return;
				}
				
				if(j > stopExtruding || j == p.size())
					plot(p.point(i), next, true, j == p.size()); //plot(p.point(i), next, lift, j == p.size());
				else
					plot(p.point(i), next, false, false);
				
				if(j > stopValve || j == p.size())
					plot(p.point(i), next, j == p.size(), true); //plot(p.point(i), next, lift, j == p.size());
				else
					plot(p.point(i), next, false, false);
			}
		} else
		{
			for(int i = 1; i < p.size(); i++)
			{
				Rr2Point next = p.point((i+1)%p.size());
				
				if (printer.isCancelled())
				{
					printer.stopMotor();
					move(posNow(), posNow(), lift, lift, true);
					return;
				}
				
				if(i > stopExtruding || i == p.size()-1)
					plot(p.point(i), next, true, i == p.size()-1);
				else
					plot(p.point(i), next, false, false);
				
				if(i > stopValve || i == p.size()-1)
					plot(p.point(i), next, i == p.size()-1, true); //plot(p.point(i), next, i == p.size()-1, lift);
				else
					plot(p.point(i), next, false, false);
			}
		}
		
		move(posNow(), posNow(), lift, lift, true);
		
	}
	


	private int plotOneMaterial(RrPolygonList polygons, int i, boolean outline, boolean firstOneInLayer)
		throws ReprapException, IOException
	{
		String material = polygons.polygon(i).getAttributes().getMaterial();
		
		while(i < polygons.size() && polygons.polygon(i).getAttributes().getMaterial().equals(material))
		{
			if (layerConditions.getPrinter().isCancelled())
				return i;
			plot(polygons.polygon(i), outline, firstOneInLayer);
			firstOneInLayer = false;
			i++;
		}
		return i;
	}
	
	private boolean nextCommon(int ib, int ih)
	{
		if(borderPolygons == null || hatchedPolygons == null)
			return false;
		
		commonBorder = ib;
		commonHatch = ih;
		
		if(borderPolygons.size() <= 0)
		{
			commonHatch = hatchedPolygons.size();
			return false;
		}


		if(hatchedPolygons.size() <= 0)
		{
			commonBorder = borderPolygons.size();
			return false;
		}

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
	 * Master plot function - draw everything.  Supress border and/or hatch by
	 * setting borderPolygons and/or hatchedPolygons null
	 * @throws IOException
	 * @throws ReprapException
	 */
	public void plot() throws ReprapException, IOException
	{
		int ib, jb, ih, jh;

		boolean firstOneInLayer = true;

		//borderPolygons = borderPolygons.filterShorts(Preferences.machineResolution()*2);
		//hatchedPolygons = hatchedPolygons.filterShorts(Preferences.machineResolution()*2);

		ib = 0;
		ih = 0;
		
		Printer printer = layerConditions.getPrinter();	
		
		while(nextCommon(ib, ih)) 
		{	
			for(jb = ib; jb < commonBorder; jb++)
			{
				if (printer.isCancelled())
					break;
				plot(borderPolygons.polygon(jb), true, firstOneInLayer);
				firstOneInLayer = false;
			}
			ib = commonBorder;

			for(jh = ih; jh < commonHatch; jh++)
			{
				if (printer.isCancelled())
					break;
				plot(hatchedPolygons.polygon(jh), false, firstOneInLayer);
				firstOneInLayer = false;
			}
			ih = commonHatch;

			firstOneInLayer = true;
			ib = plotOneMaterial(borderPolygons, ib, true, firstOneInLayer);
			firstOneInLayer = false;
			hatchedPolygons = hatchedPolygons.nearEnds(startNearHere);
			ih = plotOneMaterial(hatchedPolygons, ih, false, firstOneInLayer);	
		}

		firstOneInLayer = true; // Not sure about this - AB

		if(borderPolygons != null)
		{
			for(jb = ib; jb < borderPolygons.size(); jb++)
			{
				if (printer.isCancelled())
					break;
				plot(borderPolygons.polygon(jb), true, firstOneInLayer);
				firstOneInLayer = false;
			}
		}

		if(hatchedPolygons != null)
		{
			for(jh = ih; jh < hatchedPolygons.size(); jh++)
			{
				if (printer.isCancelled())
					break;
				plot(hatchedPolygons.polygon(jh), false, firstOneInLayer);
				firstOneInLayer = false;
			}
		}
		if(!shellSet)
		{
			printer.setLowerShell(lowerShell);
			shellSet = true;
		}
	}		
	
}
