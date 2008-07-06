package org.reprap.machines;

import org.reprap.Preferences;
import org.reprap.Printer;
import org.reprap.ReprapException;

/**
 * Returns an appropriate Printer object based on the current properties
 */
public class MachineFactory {

	/**
	 * 
	 */
	private MachineFactory() {
	}
	
	/**
	 * Currently this just always assumes we're building
	 * a 3-axis cartesian printer.  It should build an
	 * appropriate type based on the local configuration.
	 * @return new machine
	 * @throws Exception
	 */
	static public Printer create() throws Exception {
		

		String geometry = Preferences.loadGlobalString("Geometry");
		
		if (geometry.compareToIgnoreCase("cartesian") == 0)
		  	return new Reprap();
		if (geometry.compareToIgnoreCase("gcodewriter") == 0)
		  	return new CartesianGCode();
		else if (geometry.compareToIgnoreCase("nullcartesian") == 0)
		    return new NullCartesianMachine();		
		else
			throw new ReprapException("Invalid geometry in properties file");
	}
	
}
