package org.reprap.geometry;

import javax.media.j3d.*;
import org.reprap.Preferences;
import org.reprap.Printer;
import org.reprap.geometry.polygons.*;
import org.reprap.gui.PreviewPanel;
import org.reprap.gui.RepRapBuild;
import org.reprap.machines.MachineFactory;
import org.reprap.machines.NullCartesianMachine;
import org.reprap.utilities.Debug;
import org.reprap.devices.pseudo.LinePrinter;

public class Producer {
	
	/**
	 * The machine doing the making
	 */
	protected Printer reprap;
	
	/**
	 * Line parallel to which odd-numbered layers will be hatched
	 */
	protected RrHalfPlane oddHatchDirection;
	
	/**
	 * Line parallel to which even-numbered layers will be hatched
	 */
	protected RrHalfPlane evenHatchDirection;
	
	/**
	 * The list of objects to be built
	 */
	protected RepRapBuild bld;

	
	/**
	 * @param preview
	 * @param builder
	 * @throws Exception
	 */
	public Producer(PreviewPanel preview, RepRapBuild builder) throws Exception {
		
		reprap = MachineFactory.create();
		reprap.setPreviewer(preview);
		preview.setMachine(reprap);
		bld = builder;

		//		Original hatch vectors
		oddHatchDirection = new RrHalfPlane(new Rr2Point(0.0, 0.0), new Rr2Point(1.0, 1.0));
		evenHatchDirection = new RrHalfPlane(new Rr2Point(0.0, 1.0), new Rr2Point(1.0, 0.0));
		
//		//		Vertical hatch vector
//		oddHatchDirection = new RrHalfPlane(new Rr2Point(0.0, 0.0), new Rr2Point(0.0, 1.0));
//		evenHatchDirection = new RrHalfPlane(new Rr2Point(0.0, 1.0), new Rr2Point(0.0, 0.0));
	
//		//		Horizontal hatch vector
//		oddHatchDirection = new RrHalfPlane(new Rr2Point(0.0, 0.0), new Rr2Point(1.0, 0.0));
//		evenHatchDirection = new RrHalfPlane(new Rr2Point(1.0, 0.0), new Rr2Point(0.0, 0.0));
		

	}
	
	/**
	 * @throws Exception
	 */
	public void produce() throws Exception 
	{
		int movementSpeedZ = 212;
		
		boolean subtractive = false;
		
		try {
			subtractive = Preferences.loadGlobalBool("Subtractive");
			movementSpeedZ = Preferences.loadGlobalInt("MovementSpeedZ(0..255)");
		} catch (Exception ex) {
			movementSpeedZ = 212;
			subtractive = false;
			System.err.println("Warning: could not load Z MovementSpeed and subtractive flag, using default");
		}
		

		reprap.setSpeedZ(movementSpeedZ);
		Debug.d("Intialising reprap");
		reprap.initialise();
		Debug.d("Selecting material 0");
		reprap.selectExtruder(0);
		Debug.d("Setting temperature");
		reprap.getExtruder().heatOn();
		
		// A "warmup" segment to get things in working order
		if (!subtractive) {
			
			Debug.d("Printing warmup segments, moving to (5,5)");
			reprap.setSpeed(reprap.getExtruder().getXYSpeed());
			reprap.moveTo(5, 5, 0, false, false);
			
			// Workaround to get the thing to start heating up
			reprap.printTo(5, 5, 0, true);
			// Take it slow and easy.
			
			if(reprap.getExtruder().getNozzleClearTime() <= 0)
			{
				Debug.d("Printing warmup segments, printing to (5,50)");
				reprap.moveTo(5, 25, 0, false, false);
				reprap.setSpeed(LinePrinter.speedFix(reprap.getExtruder().getXYSpeed(), 
						reprap.getExtruder().getOutlineSpeed()));
				reprap.printTo(5, 60, 0, false);
				Debug.d("Printing warmup segments, printing to (7,50)");
				reprap.printTo(7, 60, 0, false);
				Debug.d("Printing warmup segments, printing to (7,5)");
				reprap.printTo(7, 25, 0, true);
				Debug.d("Warmup complete");
			}
			reprap.setSpeed(reprap.getFastSpeed());
			
		}
		
		// This should now split off layers one at a time
		// and pass them to the LayerProducer.  
		
		boolean isEvenLayer = true;
		STLSlice stlc;
		double zMax;
//		if(testPiece)
//		{
//			stlc = null;
//			zMax = 5;
//		} else
//		{
			bld.mouseToWorld();
			stlc = new STLSlice(bld.getSTLs());
			zMax = stlc.maxZ();
			// zMax = 1.6;  // For testing.
//		}
		
		double startZ;
		double endZ;
		double stepZ;
		if (subtractive) {
			// Subtractive construction works from the top, downwards
			startZ = zMax;
			endZ = 0;
			stepZ = -reprap.getExtruder().getExtrusionHeight();
			reprap.setZManual(startZ);
		} else {
			// Normal constructive fabrication, start at the bottom and work up.
			
			// Note that we start extruding one layer off the baseboard...
			// startZ = reprap.getExtruder().getExtrusionHeight();
			
			startZ = 0;
			endZ = zMax;
			
			stepZ = reprap.getExtruder().getExtrusionHeight();
		
		}
		
		int layerNumber = 0;
		
		for(double z = startZ; subtractive ? z > endZ : z < endZ; z += stepZ) {
			
			
			if (reprap.isCancelled())
				break;
			Debug.d("Commencing layer at " + z);

			// Change Z height
			reprap.moveTo(reprap.getX(), reprap.getY(), z, false, false);

			// Layer cooling phase - after we've just raised the head.
			//Only if we're not a null device.
//			if ((z != startZ && reprap.getExtruder().getCoolingPeriod() > 0)&&!(reprap instanceof NullCartesianMachine)) {
//				Debug.d("Starting a cooling period");
//				// Save where we are. We'll come back after we've cooled off.
//				double storedX=reprap.getX();
//				double storedY=reprap.getY();
//				reprap.getExtruder().setCooler(true);	// On with the fan.
//				//reprap.homeToZeroX();		// Seek (0,0)
//				//reprap.homeToZeroY();
//				reprap.setSpeed(reprap.getFastSpeed());
//				reprap.moveTo(0, 0, z, true, true);
//				Thread.sleep(1000 * reprap.getExtruder().getCoolingPeriod());
//				reprap.getExtruder().setCooler(false);
//				Debug.d("Brief delay for head to warm up.");
//				Thread.sleep(200 * reprap.getExtruder().getCoolingPeriod());
//				Debug.d("End of cooling period");
//				// TODO: BUG! Strangely, this only restores Y axis!
//				//System.out.println("stored X and Y: " + storedX + "   " + storedY);
//				
//				// The next layer will go where it wants to.
//				
//				//reprap.moveTo(storedX, storedY, z, true, true);
//				//reprap.setSpeed(reprap.getExtruder().getXYSpeed());
//				//reprap.moveTo(storedX, reprap.getY(), z, true, true);
//			}
			
			if (reprap.isCancelled())
				break;

			Preferences prefs;
			
			//Debug.d("Attempting to wiping nozzle");
			//reprap.wipeNozzle(); // Wipes current active extruder, if wipe function enabled
			
			// Do all the actions (cooling, nozzle wipe) that need to be
			// done between one layer and the next.
			
			reprap.betweenLayers(layerNumber);
			
			LayerProducer layer;
//			if(testPiece)
//			{
//				layer = new LayerProducer(reprap, z, hex(), null,
//						isEvenLayer?evenHatchDirection:oddHatchDirection);
//			} else
//			{
				RrCSGPolygonList slice = stlc.slice(z+reprap.getExtruder().getExtrusionHeight()*0.5); 
						// ,LayerProducer.solidMaterial(), LayerProducer.gapMaterial());
				BranchGroup lowerShell = stlc.getBelow();
				if(slice.size() > 0)
					layer = new LayerProducer(reprap, z, slice, lowerShell,
						isEvenLayer?evenHatchDirection:oddHatchDirection, layerNumber);
				else
					layer = null;

//			}
			
			if(layer != null)
				layer.plot();
		
			isEvenLayer = !isEvenLayer;
			
			layerNumber++;
		}

		if (subtractive)
			reprap.moveTo(0, 0, startZ, true, true);
		else
			reprap.moveTo(0, 0, reprap.getZ(), true, true);
		
		reprap.terminate();

	}

	/**
	 * The total distance moved is the total distance extruded plus 
	 * plus additional movements of the extruder when no materials 
	 * was deposited
	 * 
	 * @return total distance the extruder has moved 
	 */
	public double getTotalDistanceMoved() {
		return reprap.getTotalDistanceMoved();
	}
	
	/**
	 * @return total distance that has been extruded in millimeters
	 */
	public double getTotalDistanceExtruded() {
		return reprap.getTotalDistanceExtruded();
	}
	
	/**
	 * TODO: This figure needs to get added up as we go along to allow for different extruders
	 * @return total volume that has been extruded
	 */
	public double getTotalVolumeExtruded() {
		return reprap.getTotalDistanceExtruded() * reprap.getExtruder().getExtrusionHeight() * 
		reprap.getExtruder().getExtrusionSize();
	}
	
	/**
	 * 
	 */
	public void dispose() {
		reprap.dispose();
	}

	/**
	 * @return total elapsed time in seconds between start and end of building the 3D object
	 */
	public double getTotalElapsedTime() {
		return reprap.getTotalElapsedTime();
	}
	
}
