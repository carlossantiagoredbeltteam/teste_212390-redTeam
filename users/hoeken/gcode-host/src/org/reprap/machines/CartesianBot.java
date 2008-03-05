import javax.media.j3d.*;

import org.reprap.Attributes;
import org.reprap.CartesianPrinter;
import org.reprap.Preferences;
import org.reprap.ReprapException;
import org.reprap.gui.Previewer;
import org.reprap.devices.NullExtruder;
import org.reprap.Extruder;
import org.reprap.utilities.Debug;

public abstract class CartesianBot implements CartesianPrinter {
	
	/**
	 * This is our previewer window
	 */
	protected Previewer previewer = null;

	/**
	 * How far have we moved, in mm.
	 */
	protected double totalDistanceMoved = 0.0;
	
	/**
	 * What distnace did we extrude, in mm.
	 */
	protected double totalDistanceExtruded = 0.0;
	
	/**
	 * Scale for each axis in steps/mm.
	 */
	protected double scaleX, scaleY, scaleZ;
	
	/**
	 * Current X, Y and Z position of the extruder 
	 */
	protected double currentX, currentY, currentZ;
	
	/**
	 * Maximum feedrate for X, Y, and Z axes
	 */
	protected double maxFeedrateX, maxFeedrateY, maxFeedrateZ;
	
	/**
	 * Number of extruders on the 3D printer
	 */
	protected int extruderCount;
	
	/**
	 * Array containing the extruders on the 3D printer
	 */
	protected Extruder extruders[];

	/**
	 * Current extruder?
	 */
	protected int extruder;
	
	/**
	 * When did we start printing?
	 */
	protected long startTime;
	
	/**
	 * Do we idle the z axis?
	 */
	protected boolean idleZ;
	
	/**
	 * 
	 */
	private double overRun;
	
	/**
	 * 
	 */
	private long delay;
	
	public CartesianBot(Preferences prefs) throws Exception
	{
		startTime = System.currentTimeMillis();
		
		//load axis prefs
		int axes = prefs.loadInt("AxisCount");
		if (axes != 3)
			throw new Exception("A Cartesian Bot must contain 3 axes");
			
		//load extruder prefs
		extruderCount = prefs.loadInt("NumberOfExtruders");
		extruders = new Extruder[extruderCount];
		if (extruderCount < 1)
			throw new Exception("A Reprap printer must contain at least one extruder");
		
		//load our actual extruders.
		loadExtruders();
			
		// TODO This should be from calibration
		scaleX = prefs.loadDouble("XAxisScale(steps/mm)");
		scaleY = prefs.loadDouble("YAxisScale(steps/mm)");
		scaleZ = prefs.loadDouble("ZAxisScale(steps/mm)");
		
		// Load our maximum feedrate variables
		maxFeedrateX = prefs.loadDouble("MaximumFeedrateX(mm/minute)");
		maxFeedrateY = prefs.loadDouble("MaximumFeedrateY(mm/minute)");
		maxFeedrateZ = prefs.loadDouble("MaximumFeedrateZ(mm/minute)");
		
		//init our stuff.
		currentX = 0;
		currentY = 0;
		currentZ = 0;
	}
	
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#initialise()
	 */
	public void initialise() throws Exception {
		
		super.initialize();
		
		if (previewer != null)
			previewer.reset();
				
		Debug.d("Selecting material 0");
		selectExtruder(0);
		
		Debug.d("Setting temperature");
		getExtruder().heatOn();
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#calibrate()
	 */
	public void calibrate() {
	}
	
	public void loadExtruders()
	{
		//instantiate extruders
		extruderCount = config.loadInt("NumberOfExtruders");

		//use our factory.
		extruders = new Extruder[extruderCount];
		for(int i = 0; i < extruderCount; i++)
			extruders[i] = extruderFactory(prefs, i);

		extruder = 0;
	}
	
	public void extruderFactory(Preferences prefs, int count)
	{
		return new NullExtruder(prefs, count);
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#selectMaterial(int)
	 */
	public void selectExtruder(int materialIndex)
	{
		if (isCancelled())
			return;

		if(materialIndex < 0 || materialIndex >= extruderCount)
			System.err.println("Selected material (" + materialIndex + ") is out of range.");
		else
			extruder = materialIndex;

		//todo: move back to cartesian snap
		layerPrinter.changeExtruder(extruders[extruder]);

//		if (previewer != null)
//			previewer.setExtruder(extruders[extruder]);

		if (isCancelled())
			return;
		// TODO Select new material
		// TODO Load new x/y/z offsets for the new extruder
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#selectMaterial(int)
	 */
	public void selectExtruder(Attributes att) {
		for(int i = 0; i < extruderCount; i++)
		{
			if(att.getMaterial().equals(extruders[i].toString()))
			{
				selectExtruder(i);
				return;
			}
		}
		System.err.println("selectExtruder() - extruder not found for: " + att.getMaterial());
	}
	
	/**
	 * FIXME: Why don't these use round()? - AB.
	 * @param n
	 * @return
	 */
	protected int convertToStepX(double n) {
		return (int)((n + extruders[extruder].getOffsetX()) * scaleX);
	}

	/**
	 * @param n
	 * @return
	 */
	protected int convertToStepY(double n) {
		return (int)((n + extruders[extruder].getOffsetY()) * scaleY);
	}

	/**
	 * @param n
	 * @return
	 */
	protected int convertToStepZ(double n) {
		return (int)((n + extruders[extruder].getOffsetZ()) * scaleZ);
	}

	/**
	 * @param n
	 * @return
	 */
	protected double convertToPositionX(int n) {
		return n / scaleX - extruders[extruder].getOffsetX();
	}

	/**
	 * @param n
	 * @return
	 */
	protected double convertToPositionY(int n) {
		return n / scaleY - extruders[extruder].getOffsetY();
	}

	/**
	 * @param n
	 * @return
	 */
	protected double convertToPositionZ(int n) {
		return n / scaleZ - extruders[extruder].getOffsetZ();
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#getX()
	 */
	public double getX() {
		return currentX;
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#getY()
	 */
	public double getY() {
		return currentY;
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#getZ()
	 */
	public double getZ() {
		return currentZ;
	}
	
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#getTotalDistanceMoved()
	 */
	public double getTotalDistanceMoved() {
		return totalDistanceMoved;
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#getTotalDistanceExtruded()
	 */
	public double getTotalDistanceExtruded() {
		return totalDistanceExtruded;
	}
	
	/**
	 * @param x
	 * @param y
	 * @return segment length in millimeters
	 */
	public double segmentLength(double x, double y) {
		return Math.sqrt(x*x + y*y);
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#getTotalElapsedTime()
	 */
	public double getTotalElapsedTime() {
		long now = System.currentTimeMillis();
		return (now - startTime) / 1000.0;
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#getExtruder(String)
	 */
	public Extruder getExtruder(String name)
	{
		for(int i = 0; i < extruderCount; i++)
			if(name.equals(extruders[i].toString()))
				return extruders[i];
		return null;
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#getExtruder()
	 */
	public Extruder getExtruder()
	{
		return extruders[extruder];
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#getExtruder()
	 */
	public Extruder[] getExtruders()
	{
		return extruders;
	}
	
	/**
	 * Extrude for the given time in milliseconds, so that polymer is flowing
	 * before we try to move the extruder.
	 */
	public void printStartDelay(long msDelay) {
		try
		{
			extruders[extruder].setExtrusion(extruders[extruder].getExtruderSpeed());
			Thread.sleep(msDelay);
			extruders[extruder].setExtrusion(0);  // What's this for?  - AB
		} catch(Exception e)
		{
			// If anything goes wrong, we'll let someone else catch it.
		}
	}
	
	/**
	 * @param enable
	 * @throws IOException
	 */
	public void setCooling(boolean enable) throws IOException {
		extruders[extruder].setCooler(enable);
	}
		
	/* (non-Javadoc)
	 * @see org.reprap.Printer#setLowerShell(javax.media.j3d.Shape3D)
	 */
	public void setLowerShell(BranchGroup ls)
	{
		previewer.setLowerShell(ls);
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#setPreviewer(org.reprap.gui.Previewer)
	 */
	public void setPreviewer(Previewer previewer) {
		this.previewer = previewer;
	}
	
	/**
	 * Moves nozzle back and forth over wiper
	 */
	public void wipeNozzle() throws ReprapException, IOException {
		
		if (getExtruder().getNozzleWipeEnabled() == false) return;
		
		else {
			
			int freq = getExtruder().getNozzleWipeFreq();
			int datumX = getExtruder().getNozzleWipeDatumX();
			int datumY = getExtruder().getNozzleWipeDatumY();
			int stroke = getExtruder().getNozzleWipeStroke();
			
			setSpeed(fastSpeedXY);
			
			// Moves nozzle over wiper
			for (int w=0; w < freq; w++)
			{
				moveTo(50, datumY-(stroke/2), currentZ, false, false);
				moveTo(datumX, datumY-(stroke/2), currentZ, false, false);
				moveTo(datumX, datumY+(stroke/2), currentZ, false, false);
				moveTo(50, datumY+(stroke/2), currentZ, false, false);
			
			}	
		}
	}
	
	
	//	public double getExtrusionSize() {
	//		return extrusionSize;
	//	}

	//	public double getExtrusionHeight() {
	//		return extrusionHeight;
	//	}

	//	public double getInfillWidth() {
	//		return infillWidth;
	//	}

		/**
		 * Get the length before the end of a track to turn the extruder off
		 * to allow for the delay in the stream stopping.
		 */
	//	public double getOverRun() { return overRun; }

		/**
		 * Get the number of milliseconds to wait between turning an 
		 * extruder on and starting to move it.
		 */
	//	public long getDelay() { return delay; }
}