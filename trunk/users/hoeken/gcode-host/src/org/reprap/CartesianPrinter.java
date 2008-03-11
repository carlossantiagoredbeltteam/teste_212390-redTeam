package org.reprap;

import java.io.IOException;

/**
 *
 */
public interface CartesianPrinter extends Printer {

	/**
	 * Sync to zero X location.
	 * @throws ReprapException
	 * @throws IOException
	 */
	public void homeToZeroX() throws ReprapException, IOException;
	
	/**
	 * Sync to zero Y location.
	 * @throws ReprapException
	 * @throws IOException
	 */
	public void homeToZeroY() throws ReprapException, IOException;
	
	/**
	 * Sync to zero Z location.
	 * @throws ReprapException
	 * @throws IOException
	 */
	public void homeToZeroZ() throws ReprapException, IOException;
	
	public double getMaxFeedrateX();
	public double getMaxFeedrateY();
	public double getMaxFeedrateZ();
}
