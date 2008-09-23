package org.reprap.geometry.polygons;

import org.reprap.Preferences;

/**
 * this class stores a grid of booleans at the same grid resolution
 * as the RepRap machine's finest resolution.
 * @author ensab
 *
 */
public class BooleanGrid 
{
	private static double xInc = 0.1;
	private static double yInc = 0.1;
	private static boolean initialized = true; //!!!!!!!!!!!!!!!
	
	private boolean[][] grid = null;
	private int x0, y0, x1, y1;
	
	/**
	 * Set up the grid steps.  These should never change.
	 *
	 */
	private static void initializeIfNeedBe()
	{
		if(initialized)
			return;
		xInc = 1.0/org.reprap.Main.gui.getPrinter().getXStepsPerMM();
		yInc = 1.0/org.reprap.Main.gui.getPrinter().getYStepsPerMM();
	}
	
	/**
	 * Slap a grid over a polygon in a box
	 * Note the box boundaries should ideally be on values returned by
	 * xMidGap and yMidGap.
	 * @param csgP
	 */
	public BooleanGrid(RrCSGPolygon csgP)
	{
		initializeIfNeedBe();
		x0 = 1 + (int)(csgP.box().x().low()/xInc);
		y0 = 1 + (int)(csgP.box().y().low()/yInc);
		x1 = (int)(csgP.box().x().high()/xInc);
		y1 = (int)(csgP.box().y().high()/yInc);
		grid = new boolean[x1 - x0 + 1][y1 - y0 + 1];
		Rr2Point p;
		int ix = x0;
		while(ix <= x1)
		{
			int iy = y0;
			while(iy <= y1)
			{
				p = new Rr2Point(ix*xInc, iy*yInc);
				grid[ix - x0][iy - y0] = csgP.value(p) <= 0;
				iy++;
			}
			ix++;
		}
		
	}
	
	public static double gridX()
	{
		return xInc;
	}
	
	public static double gridY()
	{
		return yInc;
	}
	
	public int firstX()
	{
		return x0;
	}
	
	public int firstY()
	{
		return y0;
	}
	
	public int lastX()
	{
		return x1;
	}
	
	public int lastY()
	{
		return y1;
	}
	
	public boolean value(int ix, int iy)
	{
		return grid[ix - x0][iy - y0];
	}
	
	/**
	 * Destroy me and all that I point to
	 */
	public void destroy() 
	{
		grid = null;
	}
	
	/**
	 * Find the point half way between the grid points nearest x
	 * @param x
	 * @return
	 */
	public static double xMidGap(double x)
	{
		initializeIfNeedBe();
		int below = (int)(x/xInc);
		return ((double)below + 0.5)*xInc;
	}
	
	/**
	 * Find the point half way between the grid points nearest y
	 * @param y
	 * @return
	 */
	public static double yMidGap(double y)
	{
		initializeIfNeedBe();
		int below = (int)(y/yInc);
		return ((double)below + 0.5)*yInc;
	}	
}
