
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
import java.util.ArrayList;
import java.util.List;
import org.reprap.utilities.Debug;

/**
 * Integer 2D point
 * @author ensab
 *
 */

public class BooleanGrid 
{
	// Integer 2D point coordinates
	
	class iPoint
	{
		public int x, y;
		
		iPoint(int xa, int ya)
		{
			x = xa;
			y = ya;
		}
		
		iPoint(iPoint a)
		{
			x = a.x;
			y = a.y;
		}
		
		iPoint(Rr2Point a)
		{
			x = (int)(0.5 + a.x()/xInc);
			y = (int)(0.5 + a.y()/yInc);
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
		
		iPoint sub(iPoint b)
		{
			return new iPoint(x - b.x, y - b.y);
		}
		
		iPoint abs()
		{
			return new iPoint(Math.abs(x), Math.abs(y));
		}
		
		iPoint divide(int i)
		{
			return new iPoint(x/i, y/i);
		}
		
		long magnitude2()
		{
			return x*x + y*y;
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
	
	/**
	 * Integer-point polygon
	 * @author ensab
	 *
	 */
	class iPolygon
	{
		private List<iPoint> points = null;
		private boolean closed;
		
		public iPolygon(boolean c)
		{
			points = new ArrayList<iPoint>();
			closed = c;
		}
		
		public iPolygon(iPolygon a)
		{
			points = new ArrayList<iPoint>();
			for(int i = 0; i < a.size(); i++)
				add(a.point(i));
			closed = a.closed;
		}
		
		public iPoint point(int i)
		{
			return points.get(i);
		}
		
		public int size()
		{
			return points.size();
		}
		
		public void add(iPoint p)
		{
			points.add(p);
		}
		
		public void add(iPolygon a)
		{
			for(int i = 0; i < a.size(); i++)
				add(a.point(i));
		}
		
		public void remove(int i)
		{
			points.remove(i);
		}
		
		public int nearest(iPoint a)
		{
			int i = 0;
			int j = -1;
			long d0 = Long.MAX_VALUE;
			while(i < size())
			{
				long d1 = point(i).magnitude2();
				if(d1 < d0)
				{
					j = i;
					d0 = d1;
				}
			}
			return j;
		}
		
		
		private int findAngleStart(int v1)
		{
			int leng = size();
			iPoint p1 = point(v1%leng);
			int addOn = leng/2;
			int v2 = v1 + addOn;
			int offCount = 0;
			while(addOn > 1)
			{
				DDA line = new DDA(p1, point(v2%leng));
				iPoint n = line.next();
				offCount = 0;
				int j = v1;

				while(n != null && offCount < 2)
				{		
					if(point(j%leng).coincidesWith(n))
						offCount = 0;
					else
						offCount++;
					n = line.next();
					j++;
				}
				
				addOn = addOn/2;
				if(offCount < 2)
					v2 = v2 + addOn;
				else
					v2 = v2 - addOn;
			}
			if(offCount < 2)
				return v2;
			else
				return v2 - 1;
		}
		
		public iPolygon simplify()
		{
			int leng = size();
			if(leng <= 3)
				return new iPolygon(this);
			iPolygon r = new iPolygon(closed);

			int v1 = findAngleStart(0);
			// We get back -1 if the points are in a straight line.
			if (v1<0)
			{
				r.add(point(0));
				r.add(point(leng-1));
				return r;
			}
			
			if(!closed)
				r.add(point(0));

			r.add(point(v1%leng));
			int v2 = v1;
			while(true)
			{
				// We get back -1 if the points are in a straight line. 
				v2 = findAngleStart(v2);
				if(v2<0)
				{
					Debug.e("iPolygon.simplify(): points were not in a straight line; now they are!");
					return(r);
				}
				
				if(v2 > leng || (!closed && v2 == leng))
				{
					return(r);
				}
				
				if(v2 == leng && closed)
				{
					r.points.add(0, point(0));
					return r;
				}
				r.add(point(v2%leng));
			}
			// The compiler is very clever to spot that no return
			// is needed here...
		}
		
		public RrPolygon realPolygon(Attributes a)
		{
			RrPolygon result = new RrPolygon(a, closed);
			for(int i = 0; i < size(); i++)
				result.add(point(i).realPoint());
			return result;
		}
	}
	
	class iPolygonList
	{
		private List<iPolygon> polygons = null;
		
		public iPolygonList()
		{
			polygons = new ArrayList<iPolygon>();
		}
		
		public iPolygon polygon(int i)
		{
			return polygons.get(i);
		}
		
		public int size()
		{
			return polygons.size();
		}
		
		public void add(iPolygon p)
		{
			polygons.add(p);
		}
		
		public RrPolygonList realPolygons(Attributes a)
		{
			RrPolygonList result = new RrPolygonList();
			for(int i = 0; i < size(); i++)
				result.add(polygon(i).realPolygon(a));
			return result;
		}
	}
	
	/**
	 * Straight-line DDA
	 * @author ensab
	 *
	 */
	class DDA
	{
		private iPoint delta, count, p;
		private int steps, taken;
		private boolean xPlus, yPlus, finished;
		
		/**
		 * Set up the DDA between a start and an end point
		 * @param s
		 * @param e
		 */
		DDA(iPoint s, iPoint e)
		{
			delta = e.sub(s).abs();

			steps = Math.max(delta.x, delta.y);
			taken = 0;
			
			xPlus = e.x >= s.x;
			yPlus = e.y >= s.y;

			count = new iPoint(-steps/2, -steps/2);
			
			p = new iPoint(s);
			
			finished = false;
		}
		
		/**
		 * Return the next point along the line, or null
		 * if the last point returned was the final one.
		 * @return
		 */
		iPoint next()
		{
			if(finished)
				return null;

			iPoint result = new iPoint(p);

			finished = taken >= steps;

			if(!finished)
			{
				taken++;
				count = count.add(delta);
				
				if (count.x > 0)
				{
					count.x -= steps;
					if (xPlus)
						p.x++;
					else
						p.x--;
				}

				if (count.y > 0)
				{
					count.y -= steps;
					if (yPlus)
						p.y++;
					else
						p.y--;
				}
			}
			
			return result;
		}
	}
	
	//**************************************************************************************************
	
	// Start of BooleanGrid propper
	
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
	// Constructors and administration
	
	/**
	 * Destroy all my pretty chickens and their dam 
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
		Debug.e("BooleanGrid leaf(): null result for contained point!");
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
			Debug.e("BooleanGrid vIndex(): not in the box!");
			return -1;
		}
		
		if(pix)
		{
			if(ipsw.coincidesWith(a))
				return 0;
			Debug.e("BooleanGrid vIndex(): not the single-pixel point!");
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


		Debug.e("BooleanGrid vIndex(): non-perimiter point:" + a.toString() + "(" + ipsw.toString() + ipne.toString() + ")");
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
	 * Find a neighbour of a pixel that has not yet been visited and is on an edge, and
	 * is in a given direction.
	 * @param xa
	 * @param ya
	 * @return
	 */
	public iPoint findNeighbourOnEdgeInDirection(iPoint a, Rr2Point direction)
	{
		Rr2Point start = a.realPoint();
		Rr2Point myDir;
		for(int x = -1; x <= 1; x++)
			for(int y = -1; y <= 1; y++)
				if(!(x == 0 && y == 0))
				{
					iPoint b = new iPoint(x, y);
					b = b.add(a);
					myDir = Rr2Point.sub(b.realPoint(), start);
					if(Rr2Point.mul(direction, myDir) >= 0)
						if(isEdgePixel(b))
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
		iPolygonList result = new iPolygonList();
		iPolygon ip;
		
		iPoint pixel = findUnvisitedEdgePixel();
		
		while(pixel != null)
		{
			ip = new iPolygon(true);
			
			while(pixel != null)
			{
				ip.add(pixel);
				setVisited(pixel, true);
				pixel = findUnvisitedNeighbourOnEdge(pixel);
			}
			System.out.print("ibefore: " + ip.size());
			ip = ip.simplify();
			System.out.print("  iafter: " + ip.size());
			if(ip.size() >= 3)
				result.add(ip);
			
			pixel = findUnvisitedEdgePixel();
		}
		
		resetVisited();
		RrPolygonList r = result.realPolygons(a);
		System.out.print("   rbefore: " + r.polygon(0).size());
		r = r.simplify(xInc);
		System.out.println("  rafter: " + r.polygon(0).size());		
		return r;
	}
	
	private iPolygon hatch(RrHalfPlane h)
	{
		iPolygon result = new iPolygon(false);
		
		RrInterval se = box().wipe(h.pLine(), RrInterval.bigInterval());
		
		if(se.empty())
			return result;
		
		iPoint s = new iPoint(h.pLine().point(se.low()));
		iPoint e = new iPoint(h.pLine().point(se.high()));
		if(value(s))
			Debug.e("BooleanGrid.hatch(): start point is in solid!");
		DDA dda = new DDA(s, e);
		
		iPoint n = dda.next();
		iPoint nOld = n;
		boolean v;
		boolean vs = false;
		while(n != null)
		{
			v = value(n);
			if(v != vs)
			{
				if(v)
					result.add(n);
				else
					result.add(nOld);
			}
			vs = v;
			nOld = n;
			n = dda.next();
		}
		
		if(value(e))
		{
			Debug.e("BooleanGrid.hatch(): end point is in solid!");
			result.add(e);
		}
		
		if(result.size()%2 != 0)
			Debug.e("BooleanGrid.hatch(): odd number of crossings: " + result.size());
		return result;
	}
	
    /**
     * Find the bit of polygon edge between start/originPlane and targetPlane
     * @param start
     * @param modelEdge
     * @param originPlane
     * @param targetPlane
     * @param flag
     * @return polygon edge between start/originaPlane and targetPlane
     */
    private iPolygon goToPlane(iPoint start, List<RrHalfPlane> hatches, int originP, int targetP) 
    {
    	iPolygon track = new iPolygon(false);
    	
    	RrHalfPlane originPlane = hatches.get(originP);
    	RrHalfPlane targetPlane= hatches.get(targetP);
    	
    	Rr2Point dir = originPlane.normal();
    	if(originPlane.value(targetPlane.pLine().origin()) < 0)
    		dir = dir.neg();

    	if(!value(start))
    	{
    		Debug.e("BooleanGrid.goToPlane(): start is not solid!");
    		return null;
    	}
    	
    	double vStart = targetPlane.value(start.realPoint());
    	
    	iPoint p = start;
    	while(p != null && targetPlane.value(p.realPoint())*vStart >= 0)
    	{
    		track.add(p);
    		p = findNeighbourOnEdgeInDirection(p, dir);
    	}
    	
    	if(p == null)
    		return null;
    	
    	return track.simplify();
    }

	private iPolygon snakeGrow(iPolygonList ipl, List<RrHalfPlane> hatches, int thisHatch, int thisPt) 
	{
		iPolygon result = new iPolygon(false);
		
		iPolygon thisPolygon = ipl.polygon(thisHatch);
		iPoint pt = thisPolygon.point(thisPt);
		result.add(pt);
		iPolygon jump;
		
		do
		{
			thisPolygon.remove(thisPt);
			if(thisPt%2 != 0)
				thisPt--;
			pt = thisPolygon.point(thisPt);
			result.add(pt);
			thisHatch++;
			if(thisHatch < hatches.size())
				jump = goToPlane(pt, hatches, thisHatch - 1, thisHatch); 
			else 
				jump = null;
			thisPolygon.remove(thisPt);
			if(jump != null)
			{
				result.add(jump);
				thisPolygon = ipl.polygon(thisHatch);
				thisPt = thisPolygon.nearest(jump.point(jump.size() - 1));
			}
		} while(jump != null && thisPt >= 0);
				
		return result;
	}
	
	/**
	 * Hatch a csg polygon parallel to line hp with index gap
	 * @param hp
	 * @param gap
	 * @param fg
	 * @param fs
	 * @return a polygon list of hatch lines as the result
	 */
	public RrPolygonList hatch(RrHalfPlane hp, double gap, Attributes a)
	{
		RrRectangle big = box().scale(1.1);
		double d = Math.sqrt(big.dSquared());
		
		Rr2Point orth = hp.normal();
		
		int quadPointing = (int)(2 + 2*Math.atan2(orth.y(), orth.x())/Math.PI);
		
		Rr2Point org = big.ne();
		
		switch(quadPointing)
		{
		case 0:
			break;
			
		case 1:
			org = big.nw();
			break;
			
		case 2:
			org = big.sw(); 
			break;
			
		case 3:
			org = big.se();
			break;
			
		default:
			Debug.e("BooleanGrid.hatch(): The atan2 function doesn't seem to work...");
		}
		
		RrHalfPlane hatcher = new 
			RrHalfPlane(org, Rr2Point.add(org, hp.pLine().direction()));

		List<RrHalfPlane> hatches = new ArrayList<RrHalfPlane>();
		iPolygonList iHatches = new iPolygonList();
		
		double g = 0;		
		while (g < d)
		{
			iPolygon ip = hatch(hatcher);
			
			if(ip.size() > 0)
			{
				hatches.add(hatcher);
				iHatches.add(ip);
			}
			hatcher = hatcher.offset(gap);
			g += gap;
		}
		
		iPolygonList snakes = new iPolygonList();
		int segment;
		do
		{
			segment = -1;
			for(int i = 0; i < iHatches.size(); i++)
			{
				if((iHatches.polygon(i)).size() > 0)
				{
					segment = i;
					break;
				}
			}
			if(segment >= 0)
			{
				snakes.add(snakeGrow(iHatches, hatches, segment, 0));
			}
		} while(segment >= 0);
		
		return snakes.realPolygons(a);
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
			Debug.e("BooleanGrid recursiveUnion(): different quads!");
		
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
			Debug.e("BooleanGrid recursiveIntersection(): different quads!");
		
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
