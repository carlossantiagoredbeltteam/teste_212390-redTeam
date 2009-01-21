package org.reprap.geometry;

import javax.swing.JCheckBoxMenuItem;
import org.reprap.Preferences;
import org.reprap.Printer;
import org.reprap.geometry.polygons.Rr2Point;
import org.reprap.geometry.polygons.RrRectangle;
import org.reprap.geometry.polygons.RrCSG;
import org.reprap.geometry.polygons.RrCSGPolygonList;
import org.reprap.geometry.polygons.RrHalfPlane;
import org.reprap.geometry.polygons.STLSlice;
import org.reprap.gui.RepRapBuild;
import org.reprap.utilities.Debug;
import org.reprap.utilities.RrGraphics;

public class Producer {
	
	private boolean paused = false;
	
	private LayerProducer layer = null;
	
	protected LayerRules layerRules = null;
	
	private RrGraphics simulationPlot = null;
	
	
	/**
	 * The list of objects to be built
	 */
	protected RepRapBuild bld;
	
//	protected boolean interLayerCooling;

	protected STLSlice stlc;
	
	/**
	 * @param preview
	 * @param builder
	 * @throws Exception
	 */
	public Producer(Printer pr, RepRapBuild builder) throws Exception 
	{
		bld = builder;	
		
		stlc = new STLSlice(bld.getSTLs());

		if(Preferences.loadGlobalBool("DisplaySimulation"))
		{
			simulationPlot = new RrGraphics("RepRap building simulation");
		} else
			simulationPlot = null;
		
		double modZMax = stlc.maxZ();
		double stepZ = pr.getExtruders()[0].getExtrusionHeight();
		int foundationLayers = Math.max(0, pr.getFoundationLayers());
		
		int modLMax = (int)(modZMax/stepZ);
		
		layerRules = new LayerRules(pr, modZMax, modZMax + foundationLayers*stepZ,
				modLMax, modLMax + foundationLayers, true);
	}
	
	/**
	 * Set the source checkbox used to determine if there should
	 * be a pause between segments.
	 * 
	 * @param segmentPause The source checkbox used to determine
	 * if there should be a pause.  This is a checkbox rather than
	 * a boolean so it can be changed on the fly. 
	 */
	public void setSegmentPause(JCheckBoxMenuItem segmentPause) {
		layerRules.getPrinter().setSegmentPause(segmentPause);
	}

	/**
	 * Set the source checkbox used to determine if there should
	 * be a pause between layers.
	 * 
	 * @param layerPause The source checkbox used to determine
	 * if there should be a pause.  This is a checkbox rather than
	 * a boolean so it can be changed on the fly.
	 */
	public void setLayerPause(JCheckBoxMenuItem layerPause) {
		layerRules.getPrinter().setLayerPause(layerPause);
	}
	
	public void setCancelled(boolean c)
	{
		layerRules.getPrinter().setCancelled(c);
	}
	
	public void pause()
	{
		paused = true;
		if(layer != null)
			layer.pause();
	}
	
	public void resume()
	{
		paused = false;
		if(layer != null)
			layer.resume();
	}
	
	/**
	 * NB - this does not call wait - this is a purely interactive function and
	 * does not control the machine
	 *
	 */
	private void waitWhilePaused()
	{
		while(paused)
		{
			try
			{
				Thread.sleep(200);
			} catch (Exception ex) {}
		}
	}
	
	public int getLayers()
	{
		return layerRules.getMachineLayerMax();
	}
	
	public int getLayer()
	{
		return layerRules.getMachineLayer();
	}	
	
	public void produce() throws Exception
	{
		if(Preferences.loadGlobalBool("Subtractive"))
			produceSubtractive();
		else
		{
			if(layerRules.getTopDown())
				produceAdditiveTopDown();
			else
				produceAdditiveGroundUp();
		}
	}
	
	private void fillFoundationRectangle(Printer reprap, RrRectangle gp, boolean xDir) throws Exception
	{
		double x = gp.sw().x();
		double y = gp.sw().y();
		
		reprap.moveTo(x, y, layerRules.getMachineZ(), false, false);
		reprap.getExtruder().startExtruding();
		reprap.machineWait(reprap.getExtruder().getExtrusionDelayForLayer());
		reprap.setFeedrate(reprap.getExtruder().getInfillFeedrate());
		
		if(xDir)
		{
			y = gp.sw().y();
			while(y <= gp.ne().y())
			{
				if (reprap.isCancelled())
					break;
				waitWhilePaused();
				
				x = gp.ne().x();
				reprap.moveTo(x, y, layerRules.getMachineZ(), false, false);
				y += layerRules.getHatchWidth(reprap.getExtruder());
				reprap.moveTo(x, y, layerRules.getMachineZ(), false, false);
				x = gp.sw().x();
				reprap.moveTo(x, y, layerRules.getMachineZ(), false, false);
				y += layerRules.getHatchWidth(reprap.getExtruder());
				reprap.moveTo(x, y, layerRules.getMachineZ(), false, false);
			}
		} else
		{
			x = gp.sw().x();
			while(x <= gp.ne().x())
			{
				if (reprap.isCancelled())
					break;
				waitWhilePaused();
				
				y = gp.ne().y();
				reprap.moveTo(x, y, layerRules.getMachineZ(), false, false);
				x += layerRules.getHatchWidth(reprap.getExtruder());
				reprap.moveTo(x, y, layerRules.getMachineZ(), false, false);
				y = gp.sw().y();
				reprap.moveTo(x, y, layerRules.getMachineZ(), false, false);
				x += layerRules.getHatchWidth(reprap.getExtruder());
				reprap.moveTo(x, y, layerRules.getMachineZ(), false, false);
			}
		}
		reprap.getExtruder().stopExtruding();
		reprap.setFeedrate(reprap.getFastFeedrateXY());
	}
	
	private void layFoundationGroundUp() throws Exception
	{
		if(layerRules.getFoundationLayers() <= 0)
			return;
		
		Printer reprap = layerRules.getPrinter();
		
		RrRectangle gp = stlc.ObjectPlanRectangle();
		
		gp = new RrRectangle(new Rr2Point(gp.x().low() - 4, gp.y().low() - 4), 
				new Rr2Point(gp.x().high() + 4, gp.y().high() + 4));
		
		while(layerRules.getMachineLayer() < layerRules.getFoundationLayers()) 
		{
			
			if (reprap.isCancelled())
				break;
			waitWhilePaused();
			
			Debug.d("Commencing foundation layer at " + layerRules.getMachineZ());

			// Change Z height
			reprap.moveTo(reprap.getX(), reprap.getY(), layerRules.getMachineZ(), false, false);		

			reprap.startingLayer(layerRules);
			
			fillFoundationRectangle(reprap, gp, layerRules.getMachineLayer() != layerRules.getFoundationLayers() - 2);
			reprap.finishedLayer(layerRules);
			reprap.betweenLayers(layerRules);
			layerRules.stepMachine(reprap.getExtruder());
		}
		layerRules.setLayingSupport(false);
	}
	
	private void layFoundationTopDown() throws Exception
	{
		if(layerRules.getFoundationLayers() <= 0)
			return;
		
		layerRules.setLayingSupport(true);
		
		Printer reprap = layerRules.getPrinter();
		
		RrRectangle gp = stlc.ObjectPlanRectangle();
		
		gp = new RrRectangle(new Rr2Point(gp.x().low() - 8, gp.y().low() - 8), 
				new Rr2Point(gp.x().high() + 8, gp.y().high() + 8));
		
		while(layerRules.getMachineLayer() >= 0) 
		{
			
			if (reprap.isCancelled())
				break;
			waitWhilePaused();
			
			Debug.d("Commencing foundation layer at " + layerRules.getMachineZ());

			// Change Z height
			reprap.moveTo(reprap.getX(), reprap.getY(), layerRules.getMachineZ(), false, false);
						
			reprap.startingLayer(layerRules);
			
			fillFoundationRectangle(reprap, gp, layerRules.getMachineLayer() != layerRules.getFoundationLayers() - 2);
			
			reprap.betweenLayers(layerRules);
			reprap.finishedLayer(layerRules);
			
			layerRules.stepMachine(reprap.getExtruder());
		}

	}
	
//	private void layFoundationGroundUpOld() throws Exception
//	{
//		Printer reprap = layerRules.getPrinter();
//		
//		try {
//			interLayerCooling = Preferences.loadGlobalBool("InterLayerCooling");
//		} catch (Exception ex) {
//			interLayerCooling = true;
//			System.err.println("Warning: could not load InterLayerCooling flag, using default");
//		}
//		
//		Debug.d("Intialising reprap");
//		reprap.startRun();
//		// By convention, extruder 0 has the support/foundation material
//		Debug.d("Selecting material 0");
//		reprap.selectExtruder(0);
//		Debug.d("Setting temperature");
//		reprap.getExtruder().heatOn();
//		
//		RrCSGPolygonList slice = null;
//		
//		if(layerRules.getFoundationLayers() > 0)
//		{
//			Debug.d("Building foundation.");
//
//			slice = stlc.slice(layerRules.getModelZ() + layerRules.getZStep()*0.5,
//					reprap.getExtruders());
//			if(slice.size() <= 0)
//				return;
//			layer = new LayerProducer(slice, stlc.getBelow(), layerRules, simulationPlot);
//
//			if(layer == null)
//				return;
//		}
//		
//		// A "warmup" segment to get things in working order
//
//		waitWhilePaused();
//
//		reprap.setFeedrate(reprap.getExtruder().getXYFeedrate());
//		reprap.moveTo(1, 1, 0, false, false);
//
//		// Workaround to get the thing to start heating up
//		reprap.printTo(1, 1, 0, false, false);
//
//		if(reprap.getExtruder().getNozzleClearTime() <= 0)
//		{
//			Debug.d("Printing warmup segments, moving to (1,1)");
//			reprap.getExtruder().setMotor(true);
//			// Take it slow and easy.
//			Debug.d("Printing warmup segments, printing to (1,60)");
//			reprap.moveTo(1, 25, 0, false, false);
//			reprap.getExtruder().setValve(true);
//			reprap.setFeedrate(reprap.getExtruder().getOutlineFeedrate());
//			//reprap.setSpeed(LinePrinter.speedFix(reprap.getExtruder().getXYSpeed(), 
//			//		reprap.getExtruder().getOutlineSpeed(layerRules)));
//			reprap.printTo(1, 60, 0, false, false);
//			Debug.d("Printing warmup segments, printing to (3,60)");
//			reprap.printTo(3, 60, 0, false, false);
//			Debug.d("Printing warmup segments, printing to (3,25)");
//			reprap.printTo(3, 25, 0, true, true);
//			Debug.d("Warmup complete");
//			reprap.getExtruder().setMotor(false);
//		}
//		reprap.setFeedrate(reprap.getFastFeedrateXY());
//		
//		if(layerRules.getFoundationLayers() <= 0)
//		{
//			layerRules.setLayingSupport(false);
//			//layerRules.setModelLayer(0);
//			return;
//		} 
//
//	
//		
//		while(layerRules.getMachineLayer() < layerRules.getFoundationLayers()) 
//		{
//			
//			if (reprap.isCancelled())
//				break;
//			
//			waitWhilePaused();
//			
//			Debug.d("Commencing foundation layer at " + layerRules.getMachineZ());
//
//			// Change Z height
//			reprap.moveTo(reprap.getX(), reprap.getY(), layerRules.getMachineZ(), false, false);
//			
//			if (reprap.isCancelled())
//				break;
//			
//			waitWhilePaused();
//			
//			// Pretend we've just finished a layer first time;
//			// All other times we really will have.
//			
//			if (layerRules.getMachineLayer() == 0 || interLayerCooling) {
//				reprap.finishedLayer(layerRules);
//				reprap.betweenLayers(layerRules);
//				reprap.startingLayer(layerRules);
//			}
//						
//			if (reprap.isCancelled())
//				break;
//			
//			waitWhilePaused();
//			
//			if(layerRules.recomputeLayer())
//			{
//				reprap.waitWhileBufferNotEmpty();
//				reprap.slowBuffer();
//				layer.destroy();
//				slice.destroy();
//				slice = stlc.slice(layerRules.getModelZ() + layerRules.getZStep()*0.5,
//						reprap.getExtruders());
//				layer = new LayerProducer(slice, stlc.getBelow(), layerRules, simulationPlot);
//			}
//			
//			reprap.speedBuffer();
//			layer.plot();
//
//			layerRules.stepMachine(reprap.getExtruder());
//		}
//		
//		//layerRules.setModelLayer(0);
//		layerRules.setLayingSupport(false);
//		layer.destroy();
//		slice.destroy();
//		stlc.destroyLayer();
//	}
	
	/**
	 * @throws Exception
	 */
	private void produceAdditiveGroundUp() throws Exception 
	{		
		bld.mouseToWorld();

		layFoundationGroundUp();
		
		Printer reprap = layerRules.getPrinter();
		
		while(layerRules.getMachineLayer() < layerRules.getMachineLayerMax()) 
		{
			
			if (reprap.isCancelled())
				break;
			waitWhilePaused();
			
			Debug.d("Commencing layer at " + layerRules.getMachineZ());

			// Change Z height
			reprap.moveTo(reprap.getX(), reprap.getY(), layerRules.getMachineZ(), false, false);
			
			reprap.startingLayer(layerRules);
			
			reprap.waitWhileBufferNotEmpty();
			reprap.slowBuffer();
			
			RrCSGPolygonList slice = stlc.slice(layerRules.getModelZ() + layerRules.getZStep()*0.5,
					reprap.getExtruders()); 
			
			layer = null;
			if(slice.size() > 0)
				layer = new LayerProducer(slice, stlc.getBelow(), layerRules, simulationPlot);
			else
				Debug.d("Null slice at model Z = " + layerRules.getModelZ());

						
			if (reprap.isCancelled())
				break;		
			waitWhilePaused();
			
			reprap.speedBuffer();
			
			if(layer != null)
			{
				layer.plot();
				layer.destroy();
			} else
				Debug.d("Null layer at model Z = " + layerRules.getModelZ());
			
			reprap.finishedLayer(layerRules);
			reprap.betweenLayers(layerRules);
			layer = null;
			
			slice.destroy();
			stlc.destroyLayer();

			layerRules.step(reprap.getExtruder());
		}
		
		reprap.terminate();
	}
	
	/**
	 * @throws Exception
	 */
	private void produceAdditiveTopDown() throws Exception 
	{		
		bld.mouseToWorld();
		
		Printer reprap = layerRules.getPrinter();
		
		while(layerRules.getModelLayer() >= 0 ) 
		{
			
			if (reprap.isCancelled())
				break;
			waitWhilePaused();
			
			Debug.d("Commencing layer at " + layerRules.getMachineZ());

			// Change Z height
			reprap.moveTo(reprap.getX(), reprap.getY(), layerRules.getMachineZ(), false, false);
			
			reprap.startingLayer(layerRules);
			
			reprap.waitWhileBufferNotEmpty();
			reprap.slowBuffer();
			
			RrCSGPolygonList slice = stlc.slice(layerRules.getModelZ() + layerRules.getZStep()*0.5,
					reprap.getExtruders()); 
			
			layer = null;
			if(slice.size() > 0)
				layer = new LayerProducer(slice, stlc.getBelow(), layerRules, simulationPlot);
			else
				Debug.d("Null slice at model Z = " + layerRules.getModelZ());

						
			if (reprap.isCancelled())
				break;		
			waitWhilePaused();
			
			reprap.speedBuffer();
			
			if(layer != null)
			{
				layer.plot();
				layer.destroy();
			} else
				Debug.d("Null layer at model Z = " + layerRules.getModelZ());
			
			reprap.finishedLayer(layerRules);
			reprap.betweenLayers(layerRules);
			layer = null;
			
			slice.destroy();
			stlc.destroyLayer();

			layerRules.step(reprap.getExtruder());
		}
		
		layFoundationTopDown();
		
		reprap.terminate();
	}
	

	private void produceSubtractive() throws Exception 
	{
		System.err.println("Need to implement the Producer.produceSubtractive() function... :-)");
	}

	/**
	 * The total distance moved is the total distance extruded plus 
	 * plus additional movements of the extruder when no materials 
	 * was deposited
	 * 
	 * @return total distance the extruder has moved 
	 */
	public double getTotalDistanceMoved() {
		return layerRules.getPrinter().getTotalDistanceMoved();
	}
	
	/**
	 * @return total distance that has been extruded in millimeters
	 */
	public double getTotalDistanceExtruded() {
		return layerRules.getPrinter().getTotalDistanceExtruded();
	}
	
	/**
	 * TODO: This figure needs to get added up as we go along to allow for different extruders
	 * @return total volume that has been extruded
	 */
	public double getTotalVolumeExtruded() {
		return layerRules.getPrinter().getTotalDistanceExtruded() * layerRules.getPrinter().getExtruder().getExtrusionHeight() * 
		layerRules.getPrinter().getExtruder().getExtrusionSize();
	}
	
	/**
	 * 
	 */
	public void dispose() {
		layerRules.getPrinter().dispose();
	}

	/**
	 * @return total elapsed time in seconds between start and end of building the 3D object
	 */
	public double getTotalElapsedTime() {
		return layerRules.getPrinter().getTotalElapsedTime();
	}
	
}
