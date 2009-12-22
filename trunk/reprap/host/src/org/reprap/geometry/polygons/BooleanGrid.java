package org.reprap.geometry.polygons;

/**
 * Integer 2D point
 * @author ensab
 *
 */
class iPoint
{
	public int x, y;
	
	iPoint(int xa, int ya)
	{
		x = xa;
		y = ya;
	}
}

/**
 * This class stores a rectangular grid at the same grid resolution
 * as the RepRap machine's finest resolution using a quad tree.
 * 
 * @author ensab
 *
 */
public class BooleanGrid 
{
	private static double xInc = 0.1;
	private static double yInc = 0.1;
	private static int xSize = 2000;
	private static int ySize = 2000;
	
	private BooleanGrid ne, nw, sw, se;
	private boolean visited[]; 
	private BooleanGrid root;
	private int x0, y0, x1, y1;
	private boolean pix;
	private boolean value;
	
	//**************************************************************************************************
	
	// Constructors and administration
	
	/**
	 * Destroy me and all that I point to
	 */
	public void destroy() 
	{
		
	}
	
	/**
	 * Build the grid from a CSG polygon
	 * @param csgP
	 */
	public BooleanGrid(RrCSGPolygon csgP)
	{
		value = false;
		root = this;
		pix = false;
		x0 = 0;
		y0 = 0;
		x1 = xSize;
		y1 = ySize;
		visited = null;
		generateQuadTree(csgP.csg());
	}
	
	/**
	 * Partial constructor for internal use
	 * @param xa
	 * @param ya
	 * @param xb
	 * @param yb
	 * @param a
	 * @param p
	 */
	private BooleanGrid(int xa, int ya, int xb, int yb, BooleanGrid r)
	{
		x0 = xa;
		y0 = ya;
		x1 = xb;
		y1 = yb;
		value = false;
		if(r == null)
			root = this;
		else
			root = r;
		visited = null;
	}
	
	/**
	 * Deep copy constructor; r should be null for an external call.
	 * NB - Attributes are not deep copied.
	 * @param bg
	 */
	private BooleanGrid(BooleanGrid bg, BooleanGrid r)
	{
		x0 = bg.x0;
		y0 = bg.y0;
		x1 = bg.x1;
		y1 = bg.y1;
		value = bg.value;
		if(r == null)
			root = this;
		else
			root = r;
		pix = bg.pix;
		if(pix)
		{
			visited = new boolean[1];
			visited[0] = false;
		} else
			visited = null;
		if(bg.leaf())
		{
			ne = null;
			nw = null;
			sw = null;
			se = null;
		} else
		{
			ne = new BooleanGrid(bg.ne, root);
			nw = new BooleanGrid(bg.nw, root);
			sw = new BooleanGrid(bg.sw, root);
			se = new BooleanGrid(bg.se, root);	
		}
	}
	

	/**
	 * When a quad is homogeneous, set the appropriate variables to make it a leaf.
	 * @param solid
	 */
	private void homogeneous(boolean solid)
	{
		value = solid;
		ne = null;
		nw = null;
		sw = null;
		se = null;		
	}
	
	/**
	 * Generate the quad tree beneath a node recursively.
	 * @param csg
	 */
	private void generateQuadTree(RrCSG csg)
	{
		Rr2Point p0 = new Rr2Point(x0*xInc, y0*yInc);
		
		if(x0 == x1 && y0 == y1)
		{
			pix = true;
			visited = new boolean[1];
			visited[0] = false;
			double v = csg.value(p0);
			homogeneous(v <= 0);
			return;
		}
		
		pix = false;
		Rr2Point p1 = new Rr2Point(x1*xInc, y1*yInc);
		RrRectangle r = new RrRectangle(p0, p1);
		RrInterval i = csg.value(r);
		if(!i.zero())
		{
			homogeneous(i.high() <= 0);
			return;
		}
		
		int xm = (x0 + x1)/2;
		int ym = (y0 + y1)/2;
		ne = new BooleanGrid(xm+1, ym+1, x1, y1, root);
		nw = new BooleanGrid(x0, ym+1, xm, y1, root);
		sw = new BooleanGrid(x0, y0, xm, ym, root);
		se = new BooleanGrid(xm+1, y0, x1, ym, root);
		Rr2Point inc = new Rr2Point(xInc*0.5, yInc*0.5);
		Rr2Point m = new Rr2Point((xm + 0.5)*xInc, (ym + 0.5)*yInc);
		ne.generateQuadTree(csg.prune(new RrRectangle(m, Rr2Point.add(p1, inc))));
		nw.generateQuadTree(csg);
		sw.generateQuadTree(csg);
		se.generateQuadTree(csg);
	}
	
	//*************************************************************************************
	
	// Interrogate and set data
	
	/**
	 * Are we a leaf (i.e. have we no child quads)?
	 * @return
	 */
	public boolean leaf()
	{
		return ne == null;
	}
	
	public static double gridX()
	{
		return xInc;
	}
	
	public static double gridY()
	{
		return yInc;
	}
	
	public boolean value()
	{
		return value;
	}
	
	public int lowX()
	{
		return x0;
	}
	
	public int lowY()
	{
		return y0;
	}
	
	public int highX()
	{
		return x1;
	}
	
	public int highY()
	{
		return y1;
	}
	
	/**
	 * Recursively find the leaf containing a point
	 * @param xa
	 * @param ya
	 * @return
	 */
	public BooleanGrid leaf(int xa, int ya)
	{
		if(xa < x0)
			return null;
		if(xa > x1)
			return null;
		if(ya < y0)
			return null;
		if(ya > y1)
			return null;
		if(leaf())
			return this;
		BooleanGrid result = ne.leaf(xa, ya);
		if(result != null)
			return result;
		result = nw.leaf(xa, ya);
		if(result != null)
			return result;
		result = sw.leaf(xa, ya);
		if(result != null)
			return result;
		result = se.leaf(xa, ya);
		if(result != null)
			return result;
		System.err.println("BooleanGrid leaf(): null result for contained point!");
		return null;
	}
	
	/**
	 * Find the value at a point.  This is the attributes if the point
	 * is solid, or null if the point is in air.
	 * @param xa
	 * @param ya
	 * @return
	 */
	public boolean value(int xa, int ya)
	{
			BooleanGrid l = leaf(xa, ya);
			if(l == null)
				return false;
			return l.value;
	}
	
	/**
	 * Compute the index of a pixel on the periphery of a quad in the
	 * visited array.  visited[0] corresponds to the most north-easterly
	 * pixel in the quad, and the numbers increment anti-clockwise round 
	 * the edge.
	 * @param xa
	 * @param ya
	 * @return
	 */
	private int vIndex(int xa, int ya)
	{
		if(pix)
		{
			if(xa == x0 && ya == y0)
				return 0;
			System.err.println("BooleanGrid vIndex(): not the single-pixel point!");
			return -1;
		}
		
		int result = -1;
		
		if(ya == y1)
		{
			result = x1 - xa;
			if(result >= x0)
				return result;
		}
		
		if(xa == x0)
		{
			result = y1 - ya;
			if(result >= y0)
				return result + x1 - x0;			
		}
		
		if(ya == y0)
		{
			result = xa - x0;
			if(result <= x1)
				return result + x1 - x0 + y1 - y0;			
		}
		
		if(xa == x1)
		{
			result = ya - y0;
			if(result <= y1)
				return result + 2*(x1 - x0) + y1 - y0;			
		}

		System.err.println("BooleanGrid vIndex(): non-perimiter point!");
		return result;
	}
	
	/**
	 * Has a pixel been visited?
	 * @param xa
	 * @param ya
	 * @return
	 */
	public boolean visited(int xa, int ya)
	{
		BooleanGrid l = leaf(xa, ya);
		if(l == null)
			return false;
		if(l.visited == null)
			return false;
		int index = l.vIndex(xa, ya);
		if(index >= 0)
			return l.visited[index];
		else
			return false;
	}
	
	/**
	 * Set a pixel visited, or not
	 * @param xa
	 * @param ya
	 * @param v
	 */
	public void setVisited(int xa, int ya, boolean v)
	{
		BooleanGrid l = leaf(xa, ya);
		if(l == null)
			return;
		int i;
		if(l.visited == null)
		{
			int leng = 2*(l.x1 - l.x0 + l.y1 - l.y0);
			l.visited = new boolean[leng];
			for(i = 0; i < leng; i++)
				l.visited[i] = false;
		}
		i = l.vIndex(xa, ya);
		if(i >= 0)
			l.visited[i] = v;
	}
	
	
	/**
	 * Is a pixel on an edge?
	 * If it is solid and there is air at at least one
	 * of north, south, east, or west, then yes; otherwise
	 * no.
	 * @param xa
	 * @param ya
	 * @return
	 */
	public boolean isEdgePixel(int xa, int ya)
	{
		if(!value(xa, ya))
			return false;
		
		if(root.value(xa + 1, ya))
			return true;
		if(root.value(xa - 1, ya))
			return true;
		if(root.value(xa, ya + 1))
			return true;
		if(root.value(xa, ya - 1))
			return true;
		return false;
	}
	

	/**
	 * Find an unvisited pixel on an edge
	 * @return
	 */
	public iPoint findUnvisitedEdgePixel()
	{
		// Are we a single pixel?
		
		if(pix)
		{
			if(!visited[0])
			{
				if(isEdgePixel(x0, y0))
					return new iPoint(x0, y0);
			}	
		}
		
		// Are we a solid rectangle?
		
		if(leaf())
		{
			if(!value)
				return null;
			
			// Search the rectangle edges (middle pixels cannot be on an edge)
			
			for(int x = x0; x <= x1; x++)
			{
				if(!visited(x, y0))
				{
					if(isEdgePixel(x, y0))
						return new iPoint(x, y0);
				}
				if(!visited(x, y1))
				{
					if(isEdgePixel(x, y1))
						return new iPoint(x, y1);
				}
			}
			
			for(int y = y0 + 1; y < y1; y++)
			{
				if(!visited(x0, y))
				{
					if(isEdgePixel(x0, y))
						return new iPoint(x0, y);
				}
				if(!visited(x1, y))
				{
					if(isEdgePixel(x1, y))
						return new iPoint(x1, y);
				}
			}
		}
		
		// Search the child quads recursively
		
		iPoint ip = ne.findUnvisitedEdgePixel();
		if(ip != null)
			return ip;
		
		ip = nw.findUnvisitedEdgePixel();
		if(ip != null)
			return ip;
		
		ip = sw.findUnvisitedEdgePixel();
		if(ip != null)
			return ip;
		
		ip = se.findUnvisitedEdgePixel();
		return ip;
	}

	
	//*********************************************************************************************************
	
	// Boolean operators
	
	/**
	 * Internal recusive complement function actually to do the
	 * work.  The tree has already been created by a deep copy.
	 *
	 */
	private void comp()
	{
		if(leaf())
		{
			value = !value;
			return;
		} else
			value = false;
		
		ne.comp();
		nw.comp();
		sw.comp();
		se.comp();
	}
	
	/**
	 * Complement a grid
	 * @return
	 */
	public BooleanGrid complement()
	{
		BooleanGrid result = new BooleanGrid(this, null);
		result.comp();
		return result;
	}
	
	/**
	 * Recursive function to walk two trees forming their union
	 * @param d
	 * @param e
	 * @param a
	 * @param p
	 * @return
	 */
	private static BooleanGrid recursiveUnion(BooleanGrid d, BooleanGrid e, BooleanGrid r)
	{
		if(d.x0 != e.x0 || d.x1 != e.x1)
			System.err.println("BooleanGrid recursiveUnion(): different quads!");
		
		BooleanGrid result;
		
		if(d.leaf())
		{
			if(d.value)
				result = new BooleanGrid(d, r);
			else
				result = new BooleanGrid(e, r);
			return result;
		}
		
		if(e.leaf())
		{
			if(e.value)
				result = new BooleanGrid(e, r);
			else
				result = new BooleanGrid(d, r);
			return result;
		}
		
		result = new BooleanGrid(d.x0, d.y0, d.x1, d.y1, r);
		result.ne = recursiveUnion(d.ne, e.ne, result.root);
		result.nw = recursiveUnion(d.nw, e.nw, result.root);
		result.sw = recursiveUnion(d.sw, e.sw, result.root);
		result.se = recursiveUnion(d.se, e.se, result.root);
		
		return result;
	}
	
	/**
	 * Wrapper function to compute the union of two grids
	 * @param d
	 * @param e
	 * @return
	 */
	public static BooleanGrid union(BooleanGrid d, BooleanGrid e)
	{
		return recursiveUnion(d, e, null);
	}
	
	/**
	 * Recursive function to walk two trees forming their intersection
	 * @param d
	 * @param e
	 * @param a
	 * @param p
	 * @return
	 */
	private static BooleanGrid recursiveIntersection(BooleanGrid d, BooleanGrid e, BooleanGrid r)
	{
		if(d.x0 != e.x0 || d.x1 != e.x1)
			System.err.println("BooleanGrid recursiveIntersection(): different quads!");
		
		BooleanGrid result;
		
		if(d.leaf())
		{
			if(d.value)
				result = new BooleanGrid(e, r);
			else
				result = new BooleanGrid(d, r);
			return result;
		}
		
		if(e.leaf())
		{
			if(e.value)
				result = new BooleanGrid(d, r);
			else
				result = new BooleanGrid(e, r);
			return result;
		}
		
		result = new BooleanGrid(d.x0, d.y0, d.x1, d.y1, r);
		result.ne = recursiveIntersection(d.ne, e.ne, result.root);
		result.nw = recursiveIntersection(d.nw, e.nw, result.root);
		result.sw = recursiveIntersection(d.sw, e.sw, result.root);
		result.se = recursiveIntersection(d.se, e.se, result.root);
		
		return result;
	}
	
	/**
	 * Wrapper function to compute the intersection of two grids
	 * @param d
	 * @param e
	 * @return
	 */
	public static BooleanGrid intersection(BooleanGrid d, BooleanGrid e)
	{
		return recursiveIntersection(d, e, null);
	}
	
	/**
	 * Grid d - grid e
	 * @param d
	 * @param e
	 * @return
	 */
	public static BooleanGrid difference(BooleanGrid d, BooleanGrid e)
	{
		return intersection(d, e.complement());
	}
}
