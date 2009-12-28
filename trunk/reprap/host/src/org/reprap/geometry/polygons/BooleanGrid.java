
/**
 * This class stores a rectangular grid at the same grid resolution
 * as the RepRap machine's finest resolution using a quad tree.
 * 
 * It is thus effectively a pixel bitmap, but with much more
 * efficient storage.  There are two types of pixel: solid (or true),
 * and air (or false).
 * 
 * There are Boolean operators implemented to allow unions, intersections,
 * and differences of two bitmaps, and complements of one.
 * 
 * There are also functions to do ray-trace intersections, to find the parts
 * of lines that are solid, and outline following, to find the perimiters of
 * solid shapes as polygons.
 * 
 * @author Adrian Bowyer
 *
 */

package org.reprap.geometry.polygons;


import org.reprap.Attributes;

/**
 * Integer 2D point
 * @author ensab
 *
 */

public class BooleanGrid 
{
	static final double xInc = 0.1;
	static final double yInc = 0.1;
	static final int xSize = 2048; // N.B. Must be a power of 2
	static final int ySize = 2048;
	
	private BooleanGrid ne, nw, sw, se;
	private boolean visited[]; 
	private BooleanGrid root;
	private iPoint ipsw, ipne;
	private boolean pix;
	private boolean value;
	
	//**************************************************************************************************
	
	// Integer 2D point coordinates
	
	class iPoint
	{
		public int x, y;
		
		iPoint(int xa, int ya)
		{
			x = xa;
			y = ya;
		}
		
		Rr2Point realPoint()
		{
			return new Rr2Point(x*xInc, y*yInc);
		}
		
		boolean coincidesWith(iPoint b)
		{
			return x == b.x && y == b.y;
		}
		
		iPoint add(iPoint b)
		{
			return new iPoint(x + b.x, y + b.y);
		}
		
		iPoint divide(int i)
		{
			return new iPoint(x/i, y/i);
		}
		
		iPoint mean(iPoint b)
		{
			return add(b).divide(2);
		}
		
		public String toString()
		{
			return ": " + x + ", " + y + " :";
		}
	}
	
	//**************************************************************************************************
	
	// Constructors and administration
	
	/**
	 * Destroy me and all that I point to
	 */
	public void destroy() 
	{
		visited = null;
		root = null;
		if(!leaf())
		{
			ne.destroy();
			nw.destroy();
			sw.destroy();
			se.destroy();
		}
		ne = null;
		nw = null;
		sw = null;
		se = null;
	}
	
	/**
	 * Build the grid from a CSG expression
	 * @param csgP
	 */
	public BooleanGrid(RrCSG csg)
	{
		value = false;
		root = this;
		pix = false;
		ipsw = new iPoint(0, 0);
		ipne = new iPoint(xSize, ySize);
		visited = null;
		generateQuadTree(csg);
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
	private BooleanGrid(iPoint a, iPoint b, BooleanGrid r)
	{
		ipsw = a;
		ipne = b;
		value = false;
		if(r == null)
			root = this;
		else
			root = r;
		visited = null;
		ne = null;
		nw = null;
		sw = null;
		se = null;
	}
	
	/**
	 * Deep copy constructor; r should be set null.
	 * @param bg
	 */
	public BooleanGrid(BooleanGrid bg, BooleanGrid r)
	{
		ipsw = bg.ipsw;
		ipne = bg.ipne;
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
	private void homogeneous(boolean v)
	{
		value = v;
		ne = null;
		nw = null;
		sw = null;
		se = null;		
	}
	
	/**
	 * Set up the four quads to meet at the rectangle's mid point
	 *
	 */
	private void setQuadsToMiddle()
	{
		iPoint im = ipsw.mean(ipne);
		iPoint im1 = im.add(new iPoint(1,1));
		ne = new BooleanGrid(im1, ipne, root);
		nw = new BooleanGrid(new iPoint(ipsw.x, im1.y), new iPoint(im.x, ipne.y), root);
		sw = new BooleanGrid(ipsw, im, root);
		se = new BooleanGrid(new iPoint(im1.x, ipsw.y), new iPoint(ipne.x, im.y), root);		
	}
	
	/**
	 * Generate the quad tree beneath a node recursively.
	 * @param csg
	 */
	private void generateQuadTree(RrCSG csg)
	{
		Rr2Point p0 = ipsw.realPoint();
		
		if(ipsw.coincidesWith(ipne))
		{
			pix = true;
			visited = new boolean[1];
			visited[0] = false;
			homogeneous(csg.value(p0) <= 0);
			return;
		}
		
		pix = false;
		Rr2Point p1 = ipne.realPoint();
		RrInterval i = csg.value(new RrRectangle(p0, p1));
		if(!i.zero())
		{
			homogeneous(i.high() <= 0);
			return;
		}
		
		setQuadsToMiddle();
		
		Rr2Point inc = new Rr2Point(xInc*0.5, yInc*0.5);
		Rr2Point m = sw.ipne.realPoint();
		m = Rr2Point.add(m, inc);
		p0 = Rr2Point.sub(p0, inc);
		p1 = Rr2Point.add(p1, inc);
		
		ne.generateQuadTree(csg.prune(new RrRectangle(m, p1)));
		nw.generateQuadTree(csg.prune(new RrRectangle(new Rr2Point(p0.x(), m.y()), new Rr2Point(m.x(), p1.y()))));
		sw.generateQuadTree(csg.prune(new RrRectangle(p0, m)));
		se.generateQuadTree(csg.prune(new RrRectangle(new Rr2Point(m.x(), p0.y()), new Rr2Point(p1.x(), m.y()))));
	}
	
	/**
	 * Make a minimal quad tree after quads have been changed.
	 *
	 */
	private void compress()
	{
		if(!leaf())
		{
			ne.compress();
			nw.compress();
			sw.compress();
			se.compress();
			
			if(ne.leaf() && nw.leaf() && sw.leaf() && se.leaf())
			{
				if(ne.value == nw.value)
					if(ne.value == sw.value)
						if(ne.value == se.value)
						{
							this.value = ne.value;
							visited = null;
							ne = null;
							nw = null;
							sw = null;
							se = null;
						}
			}
		}
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
	
	public RrRectangle box()
	{
		return new RrRectangle(ipsw.realPoint(), ipne.realPoint());
	}
	
	public BooleanGrid northEast() { return ne; }
	public BooleanGrid northWest() { return nw; }
	public BooleanGrid southWest() { return sw; }
	public BooleanGrid southEast() { return se; }

	
	/**
	 * Is a point in the box?
	 * @param xa
	 * @param ya
	 * @return
	 */
	private boolean inside(iPoint a)
	{
		if(a.x < ipsw.x)
			return false;
		if(a.x > ipne.x)
			return false;
		if(a.y < ipsw.y)
			return false;
		if(a.y > ipne.y)
			return false;
		return true;
	}
	
	/**
	 * Recursively find the leaf containing a point
	 * If the point is outsede the grid, null is returned.
	 * @param xa
	 * @param ya
	 * @return
	 */
	public BooleanGrid leaf(iPoint a)
	{
		// Outside?
		
		if(!inside(a))
			return null;
		
		// Inside and this is the leaf quad?
		
		if(leaf())
			return this;
		
		// Recurse down the tree
		
		BooleanGrid result = ne.leaf(a);
		if(result != null)
			return result;
		result = nw.leaf(a);
		if(result != null)
			return result;
		result = sw.leaf(a);
		if(result != null)
			return result;
		result = se.leaf(a);
		if(result != null)
			return result;
		System.err.println("BooleanGrid leaf(): null result for contained point!");
		return null;
	}
	
	/**
	 * Find the value at a point.  This is true if the point
	 * is solid, or false if the point is in air.
	 * @param xa
	 * @param ya
	 * @return
	 */
	public boolean value(iPoint a)
	{
			BooleanGrid l = leaf(a);
			if(l == null)
				return false;
			return l.value;
	}
	
	/**
	 * Recursively divide down to a single pixel, setting it to v and all the other
	 * quads to theRest.
	 * @param xa
	 * @param ya
	 * @param v
	 * @param rest
	 */
	private void setValueRecursive(iPoint a, boolean v, boolean theRest)
	{		
		if(ipsw.coincidesWith(ipne))
		{
			pix = true;
			visited = new boolean[1];
			visited[0] = false;
			if(ipsw.coincidesWith(a))
				homogeneous(v);
			else
				homogeneous(theRest);
			return;
		}
		
		pix = false;

		if(!inside(a))
		{
			homogeneous(theRest);
			return;
		}
		
		setQuadsToMiddle();
				
		ne.setValueRecursive(a, v, theRest);
		nw.setValueRecursive(a, v, theRest);
		sw.setValueRecursive(a, v, theRest);
		se.setValueRecursive(a, v, theRest);
	}
	
	/**
	 * Set a single pixel, building the quad tree around it if need be
	 * @param xa
	 * @param ya
	 * @param v
	 */
	public void setValue(iPoint a, boolean v)
	{
		BooleanGrid l = leaf(a);
		if(l == null)
			return;
		if(l.value == v)
			return;
		if(l.pix)
		{
			l.value = v;
			return;
		}
		l.visited = null;
		l.value = false;
		l.setValueRecursive(a, v, l.value);
	}
	
	/**
	 * Compute the index of a pixel on the periphery of a quad in the
	 * visited array.  visited[0] corresponds to the most south-westerly
	 * pixel in the quad, and the numbers increment anti-clockwise round 
	 * the edge.
	 * @param xa
	 * @param ya
	 * @return
	 */
	private int vIndex(iPoint a)
	{
		if(!inside(a))
		{
			System.err.println("BooleanGrid vIndex(): not in the box!");
			return -1;
		}
		
		if(pix)
		{
			if(ipsw.coincidesWith(a))
				return 0;
			System.err.println("BooleanGrid vIndex(): not the single-pixel point!");
			return -1;
		}
		
		if(a.y == ipsw.y)
			return a.x - ipsw.x;
		
		if(a.x == ipne.x)
			return a.y - ipsw.y + ipne.x - ipsw.x;			
		
		if(a.y == ipne.y)
			return 2*ipne.x - a.x - ipsw.x + ipne.y - ipsw.y;		

		
		if(a.x == ipsw.x)
			return ipne.y - a.y + 2*(ipne.x - ipsw.x) + ipne.y - ipsw.y;


		System.err.println("BooleanGrid vIndex(): non-perimiter point:" + a.toString() + "(" + ipsw.toString() + ipne.toString() + ")");
		return -1;
	}
	
	/**
	 * Has a pixel been visited?
	 * @param xa
	 * @param ya
	 * @return
	 */
	public boolean visited(iPoint a)
	{
		BooleanGrid l = leaf(a);
		if(l == null)
			return false;
		if(l.visited == null)
			return false;
		int index = l.vIndex(a);
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
	public void setVisited(iPoint a, boolean v)
	{
		BooleanGrid l = leaf(a);
		if(l == null)
			return;
		int i;
		if(l.visited == null)
		{
			int leng = 2*(l.ipne.x - l.ipsw.x + l.ipne.y - l.ipsw.y);
			l.visited = new boolean[leng];
			for(i = 0; i < leng; i++)
				l.visited[i] = false;
		}
		i = l.vIndex(a);
		if(i >= 0)
			l.visited[i] = v;
	}
	
	/**
	 * Reset all the visited flags
	 *
	 */
	public void resetVisited()
	{
		if(leaf())
		{
			if(visited != null)
			{
				for(int i = 0; i < visited.length; i++)
					visited[i] = false;
			}
		} else
		{
			ne.resetVisited();
			nw.resetVisited();
			sw.resetVisited();
			se.resetVisited();
		}
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
	public boolean isEdgePixel(iPoint a)
	{
		if(!value(a))
			return false;
		
		if(!root.value(new iPoint(a.x + 1, a.y)))
			return true;
		if(!root.value(new iPoint(a.x - 1, a.y)))
			return true;
		if(!root.value(new iPoint(a.x, a.y + 1)))
			return true;
		if(!root.value(new iPoint(a.x, a.y - 1)))
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
			if(isEdgePixel(ipsw))
			{
				if(!visited[0])
					return ipsw;
			}	
		}
		
		// Are we a solid rectangle?
		
		if(leaf())
		{
			if(!value)
				return null;
			
			// Search the rectangle edges (middle pixels cannot be on an edge)
			
			iPoint p;
			
			for(int x = ipsw.x; x <= ipne.x; x++)
			{
				p = new iPoint(x, ipsw.y);
				if(isEdgePixel(p))
				{
					if(!visited(p))
						return p;
				}
				p = new iPoint(x, ipne.y);
				if(isEdgePixel(p))
				{
					if(!visited(p))
						return p;
				}
			}
			
			for(int y = ipsw.y + 1; y < ipne.y; y++)
			{
				p = new iPoint(ipsw.x, y);
				if(isEdgePixel(p))
				{
					if(!visited(p))
						return p;
				}
				p = new iPoint(ipne.x, y);
				if(isEdgePixel(p))
				{
					if(!visited(p))
						return p;
				}
			}
			
			return null;
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
	
	/**
	 * Find a neighbour of a pixel that has not yet been visited and is on an edge.
	 * @param xa
	 * @param ya
	 * @return
	 */
	public iPoint findUnvisitedNeighbourOnEdge(iPoint a)
	{
		for(int x = -1; x <= 1; x++)
			for(int y = -1; y <= 1; y++)
				if(!(x == 0 && y == 0))
				{
					iPoint b = new iPoint(x, y);
					b = b.add(a);
					if(isEdgePixel(b))
						if(!visited(b))
							return b;
				}
		return null;
	}
	
	/**
	 * Return all the outlines of all the solid areas as polygons
	 * @return
	 */
	public RrPolygonList allPerimiters(Attributes a)
	{
		RrPolygonList result = new RrPolygonList();
		RrPolygon p;
		
		iPoint pixel = findUnvisitedEdgePixel();
		
		while(pixel != null)
		{
			p = new RrPolygon(a, true);
			
			while(pixel != null)
			{
				p.add(pixel.realPoint());
				setVisited(pixel, true);
				pixel = findUnvisitedNeighbourOnEdge(pixel);
			}
			
			System.err.println("Polygon size: " + p.size());
			if(p.size() >= 3)
				result.add(p.simplify(1.3*Math.sqrt(xInc*xInc + yInc*yInc)));
			
			pixel = findUnvisitedEdgePixel();
		}
		
		resetVisited();
		
		return result;
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
		if(!d.ipsw.coincidesWith(e.ipsw) || !d.ipne.coincidesWith(e.ipne))
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
		
		result = new BooleanGrid(d.ipsw, d.ipne, r);
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
		BooleanGrid result = recursiveUnion(d, e, null);
		result.compress();
		return result;
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
		if(!d.ipsw.coincidesWith(e.ipsw) || !d.ipne.coincidesWith(e.ipne))
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
		
		result = new BooleanGrid(d.ipsw, d.ipne, r);
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
		BooleanGrid result = recursiveIntersection(d, e, null);
		result.compress();
		return result;
	}
	
	/**
	 * Grid d - grid e
	 * @param d
	 * @param e
	 * @return
	 */
	public static BooleanGrid difference(BooleanGrid d, BooleanGrid e)
	{
		BooleanGrid result = recursiveIntersection(d, e.complement(), null);
		result.compress();
		return result;
	}
}
