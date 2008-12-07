
package org.reprap.geometry;

import org.reprap.Printer;
import org.reprap.Extruder;
import org.reprap.geometry.polygons.RrHalfPlane;

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
	 * The increment in Z.  This ought to be the same for all extruders,
	 * or we're in trouble...
	 */
	private double stepZ;
	
	/**
	 * Putting down foundations?
	 */
	private boolean layingSupport;
	
	/**
	 * The hatching direction for even-numbered layers of the model
	 */
	private RrHalfPlane evenHatchDirection;
	
	/**
	 * The hatching direction for odd-numbered layers of the model
	 */	
	private RrHalfPlane oddHatchDirection;
	
	/**
	 * If we take a short step, remember it and add it on next time
	 */
	private double addToStep = 0;
	
	public LayerRules(Printer p, double modZ, double macZ, 
			int modLayer, int macLayer, double modZMax, double macZMax,
			int modLMax, int macLMax, double sz,
			boolean found, RrHalfPlane ehd, RrHalfPlane ohd)
	{
		printer = p;
		modelZ = modZ;
		machineZ = macZ;
		modelLayer = modLayer;
		machineLayer = macLayer;
		modelZMax = modZMax;
		machineZMax = macZMax;
		modelLayerMax = modLMax;
		machineLayerMax = macLMax;
		stepZ = sz;
		layingSupport = found;		
		evenHatchDirection = ehd;
		oddHatchDirection = ohd;
	}
	
	public void setPrinter(Printer p) { printer = p; }
	public Printer getPrinter() { return printer; }
	
	public void setModelZ(double mz) { modelZ = mz; }
	public double getModelZ() { return modelZ; }
	
	public double getMachineZ() { return machineZ; }
	
	public void setModelLayer(int ml) { modelLayer = ml; }
	public int getModelLayer() { return modelLayer; }
	
	public int getModelLayerMax() { return modelLayerMax; }
	
	public int getMachineLayerMax() { return machineLayerMax; }
	
	public int getMachineLayer() { return machineLayer; }
	
	public int getFoundationLayers() { return machineLayerMax - modelLayerMax; }
	
	public double getModelZMAx() { return modelZMax; }
	
	public double getMachineZMAx() { return machineZMax; }
	
	public double getStep() { return stepZ; }
	
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
	public RrHalfPlane getHatchDirection() 
	{
		if(getMachineLayer() < getFoundationLayers())
		{
			if(getFoundationLayers() - getMachineLayer() == 2)
				return evenHatchDirection;
			return oddHatchDirection;
		}
		
		if(getModelLayer()%2 == 0)
			return evenHatchDirection;
		else
			return oddHatchDirection;
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
	 * Move the machine up, but leave the model's layer where it is.
	 *
	 * @param e
	 */
	public void stepUpMachine(Extruder e)
	{
		machineZ += (stepZ + addToStep);
		addToStep = 0;
		machineLayer++;
		if(getFoundationLayers() - getMachineLayer() == 2)
			addToStep = -stepZ*(1 - e.getSeparationFraction());
		if(getFoundationLayers() - getMachineLayer() == 1)
			addToStep = stepZ*(1 - e.getSeparationFraction());
	}
	
	/**
	 * Move both the model and the machine up a layer
	 * @param e
	 */
	public void stepUp(Extruder e)
	{
		modelZ += (stepZ + addToStep);
		addToStep = 0;
		modelLayer++;
		stepUpMachine(e);
	}	
	
}
