
package org.reprap.geometry;

import org.reprap.Printer;
import org.reprap.Extruder;
import org.reprap.geometry.polygons.RrHalfPlane;
import org.reprap.geometry.polygons.Rr2Point;
import org.reprap.Preferences;

/**
 * This stores a set of facts about the layer currently being made, and the
 * rules for such things as infill patterns, support patterns etc.
 */
public class LayerRules 
{	
	/**
	 * The machine
	 */
	private Printer printer;
	
	/**
	 * How far up the model we are in mm
	 */
	private double modelZ;
	
	/**
	 * How far we are up from machine Z=0
	 */
	private double machineZ;
	
	/**
	 * The count of layers up the model
	 */
	private int modelLayer;
	
	/**
	 * The number of layers the machine has done
	 */
	private int machineLayer;
	
	/**
	 * The top of the model in model coordinates
	 */
	private double modelZMax;
	
	/**
	 * The highest the machine should go this build
	 */
	private double machineZMax;
	
	/**
	 * The number of the last model layer (first = 0)
	 */
	private int modelLayerMax;
	
	/**
	 * The number of the last machine layer (first = 0)
	 */
	private int machineLayerMax;
	
	/**
	 * Putting down foundations?
	 */
	private boolean layingSupport;
	
	/**
	 * The step height of all the extruders
	 */
	private double zStep;
	
	/**
	 * If we take a short step, remember it and add it on next time
	 */
	private double addToStep = 0;
	
	/**
	 * Are we going top to bottom or ground up?
	 */
	private boolean topDown = false;
	
	/**
	 * This is true until it is first read, when it becomes false
	 */
	private boolean notStartedYet;
	
	/**
	 * 
	 * @param p
	 * @param modZMax
	 * @param macZMax
	 * @param modLMax
	 * @param macLMax
	 * @param found
	 */
	public LayerRules(Printer p, double modZMax, double macZMax,
			int modLMax, int macLMax, boolean found)
	{
		printer = p;
		
		notStartedYet = true;

		topDown = false;

		modelZMax = modZMax;
		machineZMax = macZMax;
		modelLayerMax = modLMax;
		machineLayerMax = macLMax;
		if(topDown)
		{
			modelZ = modelZMax;
			machineZ = machineZMax;
			modelLayer = modelLayerMax;
			machineLayer = machineLayerMax;			
		} else
		{
			modelZ = 0;
			machineZ = 0;
			modelLayer = -1;
			machineLayer = 0;			
		}
		addToStep = 0;

		layingSupport = found;
		Extruder[] es = printer.getExtruders();
		zStep = es[0].getExtrusionHeight();
		if(es.length > 1)
		{
			for(int i = 1; i < es.length; i++)
			{
				if(Math.abs(es[i].getExtrusionHeight() - zStep) > Preferences.tiny())
					System.err.println("Not all extruders extrude the same height of filament: " + 
							zStep + " and " + es[i].getExtrusionHeight());
			}
		}
	}
	
	public boolean getTopDown() { return topDown; }
	
	public void setPrinter(Printer p) { printer = p; }
	public Printer getPrinter() { return printer; }
	
	//public void setModelZ(double mz) { modelZ = mz; }
	public double getModelZ() { return modelZ; }
	
	public double getMachineZ() { return machineZ; }
	
	//private void setModelLayer(int ml) { modelLayer = ml; }
	public int getModelLayer() { return Math.max(modelLayer, 0); }
	
	public int getModelLayerMax() { return modelLayerMax; }
	
	public int getMachineLayerMax() { return machineLayerMax; }
	
	public int getMachineLayer() { return machineLayer; }
	
	public int getFoundationLayers() { return machineLayerMax - modelLayerMax; }
	
	public double getModelZMAx() { return modelZMax; }
	
	public double getMachineZMAx() { return machineZMax; }
	
	public double getZStep() { return zStep; }
	
	public boolean notStartedYet()
	{
		if(notStartedYet)
		{
			notStartedYet = false;
			return true;
		}
		return false;
	}
	
	
	public void setLayingSupport(boolean lf) { layingSupport = lf; }
	public boolean getLayingSupport() { return layingSupport; }
	
	/**
	 * Does the layer about to be produced need to be recomputed?
	 * @return
	 */
	public boolean recomputeLayer()
	{
		return getFoundationLayers() - getMachineLayer() <= 2;
	}
	
	/**
	 * The hatch pattern is:
	 * 
	 *  Foundation:
	 *   All evenHatchDirection except for the penultimate hatch layer
	 *   
	 *  Model:
	 *   Alternate even then odd
	 *   
	 * @return
	 */
	public RrHalfPlane getHatchDirection(Extruder e) 
	{
		double angle;
		if(getMachineLayer() < getFoundationLayers())
		{
			if(getFoundationLayers() - getMachineLayer() == 2)
				angle = e.getEvenHatchDirection();
			else
				angle = e.getOddHatchDirection();
		} else
		{
			if(getModelLayer()%2 == 0)
				angle = e.getEvenHatchDirection();
			else
				angle = e.getOddHatchDirection();
		}
		angle = angle*Math.PI/180;
		return new RrHalfPlane(new Rr2Point(0.0, 0.0), new Rr2Point(Math.sin(angle), Math.cos(angle)));
	}
	
	/**
	 * The gap in the layer zig-zag is:
	 * 
	 *  Foundation:
	 *   The foundation width for all but...
	 *   ...the penultimate foundation layer, which is half that and..
	 *   ...the last foundation layer, which is the model fill width
	 *   
	 *  Model:
	 *   The model fill width
	 *   
	 * @param e
	 * @return
	 */
	public double getHatchWidth(Extruder e)
	{
		if(getMachineLayer() < getFoundationLayers())
		{
			if(getFoundationLayers() - getMachineLayer() == 2)
				return e.getExtrusionFoundationWidth()*0.5;
			//else if(getMachineLayer() == getFoundationLayers()-1)
				//return e.getExtrusionInfillWidth();
			
			return e.getExtrusionFoundationWidth();
		}
		
		if(e.getExtrusionBroadWidth() > 0)
		{
			if(modelLayer+1 > e.getLowerFineLayers() && modelLayer+1 <= modelLayerMax - e.getUpperFineLayers())
				return e.getExtrusionBroadWidth();
		}
		
		return e.getExtrusionInfillWidth();
	}
	
	/**
	 * Move the machine up/down, but leave the model's layer where it is.
	 *
	 * @param e
	 */
	public void stepMachine(Extruder e)
	{
		double sZ = e.getExtrusionHeight();
		if(topDown)
		{
			machineZ -= (sZ + addToStep);
			machineLayer--;
		} else
		{
			machineZ += (sZ + addToStep);
			machineLayer++;
		}
		addToStep = 0;
		if(getFoundationLayers() - getMachineLayer() == 2)
			addToStep = -sZ*(1 - e.getSeparationFraction());
		if(getFoundationLayers() - getMachineLayer() == 1)
			addToStep = sZ*(1 - e.getSeparationFraction());
	}
	
	/**
	 * Move both the model and the machine up/down a layer
	 * @param e
	 */
	public void step(Extruder e)
	{
		// modelLayer < 0 when we're building foundations
		if(modelLayer < 0)
			modelLayer = 0;
		
		double sZ = e.getExtrusionHeight();
		if(topDown)
		{
			modelZ -= (sZ + addToStep);
			modelLayer--;			
		} else
		{
			modelZ += (sZ + addToStep);
			modelLayer++;
		}
		addToStep = 0;
		stepMachine(e);
	}
	
}
