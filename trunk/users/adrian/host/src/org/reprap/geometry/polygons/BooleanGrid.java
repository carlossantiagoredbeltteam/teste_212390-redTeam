
/**
 * This class stores a rectangular grid at the same grid resolution
 * as the RepRap machine's finest resolution using the Java BitSet class.
 * 
 * There are two types of pixel: solid (or true),
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
import org.reprap.Preferences;
import java.util.ArrayList;
import java.util.List;
import java.util.BitSet;
import org.reprap.utilities.Debug;
import org.reprap.utilities.RrGraphics;
import org.reprap.Extruder;
import org.reprap.geometry.LayerRules;

public class BooleanGrid 
{
	// Various internal classes to make things work...
	
	/**
	 * Integer 2D point
	 * @author ensab
	 *
	 */

	class iPoint
	{
		private int x, y;
		
		iPoint(int xa, int ya)
		{
			x = xa;
			y = ya;
		}
		
		/**
		 * Copy constructor
		 * @param a
		 */
		iPoint(iPoint a)
		{
			x = a.x;
			y = a.y;
		}
		
		/**
		 * Convert real-world point to integer
		 * @param a
		 */
		iPoint(Rr2Point a)
		{
			x = (int)(0.5 + a.x()/pixSize) - swCorner.x;
			y = (int)(0.5 + a.y()/pixSize) - swCorner.y;
		}		
		
		/**
		 * Generate the equivalent real-world point
		 * @return
		 */
		Rr2Point realPoint()
		{
			return new Rr2Point((swCorner.x + x)*pixSize, (swCorner.y + y)*pixSize);
		}
		
		/**
		 * Are two points the same?
		 * @param b
		 * @return
		 */
		boolean coincidesWith(iPoint b)
		{
			return x == b.x && y == b.y;
		}
		
		/**
		 * Vector addition
		 * @param b
		 * @return
		 */
		iPoint add(iPoint b)
		{
			return new iPoint(x + b.x, y + b.y);
		}
		
		/**
		 * Vector subtraction
		 * @param b
		 * @return
		 */
		iPoint sub(iPoint b)
		{
			return new iPoint(x - b.x, y - b.y);
		}
		
		/**
		 * Absolute value
		 * @return
		 */
		iPoint abs()
		{
			return new iPoint(Math.abs(x), Math.abs(y));
		}
		
		/**
		 * Divide by an integer
		 * @param i
		 * @return
		 */
		iPoint divide(int i)
		{
			return new iPoint(x/i, y/i);
		}
		
		/**
		 * Squared length
		 * @return
		 */
		long magnitude2()
		{
			return x*x + y*y;
		}
		
		/**
		 * Point half-way between two others
		 * @param b
		 * @return
		 */
		iPoint mean(iPoint b)
		{
			return add(b).divide(2);
		}
		
		/**
		 * For printing
		 */
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
		/**
		 * Auto-extending list of points
		 */
		private List<iPoint> points = null;
		
		/**
		 * Does the polygon loop back on itself?
		 */
		private boolean closed;
		
		protected void finalize() throws Throwable
		{
			points = null;
			super.finalize();
		}
		
		public iPolygon(boolean c)
		{
			points = new ArrayList<iPoint>();
			closed = c;
		}
		
		/**
		 * Deep copy
		 * @param a
		 */
		public iPolygon(iPolygon a)
		{
			points = new ArrayList<iPoint>();
			for(int i = 0; i < a.size(); i++)
				add(a.point(i));
			closed = a.closed;
		}
		
		/**
		 * Return the point at a given index
		 * @param i
		 * @return
		 */
		public iPoint point(int i)
		{
			return points.get(i);
		}
		
		/**
		 * How many points?
		 * @return
		 */
		public int size()
		{
			return points.size();
		}
		
		/**
		 * Add a new point on the end
		 * @param p
		 */
		public void add(iPoint p)
		{
			points.add(p);
		}
		
		/**
		 * Add a whole polygon on the end
		 * @param a
		 */
		public void add(iPolygon a)
		{
			for(int i = 0; i < a.size(); i++)
				add(a.point(i));
		}
		
		/**
		 * Delete a point and close the resulting gap
		 * @param i
		 */
		public void remove(int i)
		{
			points.remove(i);
		}
		
		/**
		 * Find the index of the point in the polygon nearest to another point
		 * @param a
		 * @return
		 */
		public int nearest(iPoint a)
		{
			int i = 0;
			int j = -1;
			long d0 = Long.MAX_VALUE;
			while(i < size())
			{
				long d1 = point(i).sub(a).magnitude2();
				if(d1 < d0)
				{
					j = i;
					d0 = d1;
				}
				i++;
			}
			return j;
		}
		
		/**
		 * Negate (i.e. reverse cyclic order)
		 * @return reversed polygon object
		 */
		public iPolygon negate()
		{
			iPolygon result = new iPolygon(closed);
			for(int i = size() - 1; i >= 0; i--)
				result.add(point(i)); 
			return result;
		}
		
		/**
		 * Find the furthest point from point v1 on the polygon such that the polygon between
		 * the two can be approximated by a DDA straight line from v1.
		 * @param v1
		 * @return
		 */
		private int findAngleStart(int v1)
		{
			int leng = size();
			iPoint p1 = point(v1%leng);
			int addOn = (leng + v1)/2 + 1;
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
				
				if(addOn%2 == 0)
					addOn = addOn/2;
				else
					addOn = 1 + addOn/2;
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
		
		/**
		 * Generate an equivalent polygon with fewer vertices by removing chains of points
		 * that lie in straight lines.
		 * @return
		 */
		public iPolygon simplify()
		{
			if(size() <= 3)
				return new iPolygon(this);
			iPolygon r = new iPolygon(closed);
			int v = 0;
			do
			{
				r.add(point(v));
				v = findAngleStart(v);
			}while(v < size());
			return r;
		}
		
		/**
		 * Convert the polygon into a polygon in the real world.
		 * @param a
		 * @return
		 */
		public RrPolygon realPolygon(Attributes a)
		{
			RrPolygon result = new RrPolygon(a, closed);
			for(int i = 0; i < size(); i++)
				result.add(point(i).realPoint());
			return result;
		}
	}
	
	/**
	 * A list of polygons
	 * @author ensab
	 *
	 */
	class iPolygonList
	{
		private List<iPolygon> polygons = null;
		
		protected void finalize() throws Throwable
		{
			polygons = null;
			super.finalize();
		}
		
		public iPolygonList()
		{
			polygons = new ArrayList<iPolygon>();
		}
		
		/**
		 * Return the ith polygon
		 * @param i
		 * @return
		 */
		public iPolygon polygon(int i)
		{
			return polygons.get(i);
		}
		
		/**
		 * How many polygons are there in the list?
		 * @return
		 */
		public int size()
		{
			return polygons.size();
		}
		
		/**
		 * Add a polygon on the end
		 * @param p
		 */
		public void add(iPolygon p)
		{
			polygons.add(p);
		}
		
		/**
		 * Add another list of polygons on the end
		 * @param a
		 */
		public void add(iPolygonList a)
		{
			for(int i = 0; i < a.size(); i++)
				add(a.polygon(i));
		}
		
		/**
		 * Turn all the polygons into real-world polygons
		 * @param a
		 * @return
		 */
		public RrPolygonList realPolygons(Attributes a)
		{
			RrPolygonList result = new RrPolygonList();
			for(int i = 0; i < size(); i++)
				result.add(polygon(i).realPolygon(a));
			return result;
		}
		
		/**
		 * Simplify all the polygons
		 * @return
		 */
		public iPolygonList simplify()
		{
			iPolygonList result = new iPolygonList();
			for(int i = 0; i < size(); i++)
				result.add(polygon(i).simplify());
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
		
		protected void finalize() throws Throwable
		{
			delta = null;
			count = null;
			p = null;
			super.finalize();
		}
		
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
	
	/**
	 * Little class to hold the ends of hatching patterns
	 * @author ensab
	 *
	 */
	class SnakeEnd
	{
		public iPolygon track;
		public int hitPlaneIndex;
		
		protected void finalize() throws Throwable
		{
			track = null;
			super.finalize();
		}
		
		public SnakeEnd(iPolygon t, int h)
		{
			track = t;
			hitPlaneIndex = h;
		}
	}
	
	//**************************************************************************************************
	
	// Start of BooleanGrid propper
	
	/**
	 * The resolution of the RepRap machine
	 */
	static final double pixSize = Preferences.machineResolution()*0.6;
	static final double realResolution = pixSize*0.1;

	/**
	 * The size of the pixel map
	 */
	//static final int xSize = 3400;
	//static final int ySize = 3900;
	
	/**
	 * The pixel map
	 */
	private BitSet bits;
	
	/**
	 * Flags for visited poxels during searches
	 */
	private BitSet visited;
	
	/**
	 * The bottom left corner in pixels
	 */
	private iPoint swCorner;
	
	/**
	 * The size of the pixelmap.
	 */
	private iPoint size;
	
	/**
	 * Run round the neighbours of a pixel anticlockwise from bottom left
	 */
	private final iPoint[] neighbour = {
		new iPoint(-1, -1),
		new iPoint(0, -1),
		new iPoint(1, -1),
		new iPoint(1, 0),
		new iPoint(1, 1),
		new iPoint(0, 1),
		new iPoint(-1, 1),
		new iPoint(-1, 0)
		};
	
	//**************************************************************************************************
	// Constructors and administration
	
	/**
	 * Bye!
	 */
	protected void finalize() throws Throwable
	{
		bits = null;
		visited = null;
		super.finalize();
	}
	
	/**
	 * Build the grid from a CSG expression
	 * @param csgP
	 */
	public BooleanGrid(RrCSG csg, RrRectangle rec)
	{
		Rr2Point margin = new Rr2Point(0.5, 0.5);
		swCorner = new iPoint(0, 0);                           // These two lines...
		swCorner = new iPoint(Rr2Point.sub(rec.sw(), margin)); // ...are a bit subtle.
		size = new iPoint(Rr2Point.add(rec.ne(), margin));
		bits = new BitSet(size.x*size.y);
		visited = null;
		//System.out.print("Starting quad tree... ");
		generateQuadTree(new iPoint(0, 0), new iPoint(size.x - 1, size.y - 1), csg);
		//System.out.println("Done quad tree");
		deWhisker();
	}
	
	
	/**
	 * Deep copy constructor
	 * @param bg
	 */
	public BooleanGrid(BooleanGrid bg)
	{
		bits = (BitSet)bg.bits.clone();
		if(bg.visited != null)
		{
			visited = (BitSet)bg.visited.clone();
		} else
			visited = null;
		swCorner = new iPoint(bg.swCorner);
		size = new iPoint(bg.size);
	}
	
	/**
	 * The index of a pixel in the 1D bit array.
	 * @param x
	 * @param y
	 * @return
	 */
	private int pixI(int x, int y)
	{
		return x*size.y + y;
	}
	
	/**
	 * The index of a pixel in the 1D bit array.
	 * @param p
	 * @return
	 */
	private int pixI(iPoint p)
	{
		return pixI(p.x, p.y);
	}
	
	/**
	 * The pixel corresponding to an index into the bit array
	 * @param i
	 * @return
	 */
	private iPoint pixel(int i)
	{
		return new iPoint(i/size.y, i%size.y);
	}
	
	
	/**
	 * Any pixels set?
	 * @return
	 */
	public boolean isEmpty()
	{
		return bits.isEmpty();
	}
	
	/**
	 * Is a point inside the image?
	 * @param p
	 * @return
	 */
	private boolean inside(iPoint p)
	{
		if(p.x < 0)
			return false;
		if(p.y < 0)
			return false;
		if(p.x >= size.x)
			return false;
		if(p.y >= size.y)
			return false;
		return true;
	}
	
	
	/**
	 * Set pixel p to value v
	 * @param p
	 * @param v
	 */
	public void set(iPoint p, boolean v)
	{
		if(!inside(p))
		{
			Debug.e("BoolenGrid.set(): attempt to set pixel beyond boundary!");
			return;
		}
		bits.set(pixI(p), v);
	}
	
	/**
	 * Set a whole rectangle to one value
	 * @param ipsw
	 * @param ipne
	 * @param v
	 */
	private void homogeneous(iPoint ipsw, iPoint ipne, boolean v)
	{
		// TODO: if v is false we may just return?
		for(int y = ipsw.y; y <= ipne.y; y++)
			for(int x = ipsw.x; x <= ipne.x; x++)
				bits.set(pixI(x, y), v);
	}
	
	/**
	 * The rectangle surrounding the set pixels in real coordinates.
	 * @return
	 */
	public RrRectangle box()
	{
		return new RrRectangle(new iPoint(0, 0).realPoint(), new iPoint(size.x - 1, size.y - 1).realPoint());
	}
	
	/**
	 * The value at a point.
	 * @param p
	 * @return
	 */
	public boolean get(iPoint p)
	{
		if(!inside(p))
			return false;
		return bits.get(pixI(p));
	}
	
	/**
	 * Set a point as visited
	 * @param p
	 * @param v
	 */
	private void vSet(iPoint p, boolean v)
	{
		if(!inside(p))
		{
			Debug.e("BoolenGrid.vSet(): attempt to set pixel beyond boundary!");
			return;
		}
		if(visited == null)
			visited = new BitSet(size.x*size.y);
		visited.set(pixI(p), v);
	}
	
	/**
	 * Has this point been visited?
	 * @param p
	 * @return
	 */
	private boolean vGet(iPoint p)
	{
		if(visited == null)
			return false;
		if(!inside(p))
			return false;		
		return visited.get(pixI(p));
	}
	
	/**
	 * Generate the entire image from a CSG experession recursively
	 * using a quad tree.
	 * @param ipsw
	 * @param ipne
	 * @param csg
	 */
	private void generateQuadTree(iPoint ipsw, iPoint ipne, RrCSG csg)
	{
		Rr2Point inc = new Rr2Point(pixSize*0.5, pixSize*0.5);
		Rr2Point p0 = ipsw.realPoint();
		
		if(ipsw.coincidesWith(ipne))
		{
			set(ipsw, csg.value(p0) <= 0);
			return;
		}
		
		Rr2Point p1 = ipne.realPoint();
		RrInterval i = csg.value(new RrRectangle(Rr2Point.sub(p0, inc), Rr2Point.add(p1, inc)));
		if(!i.zero())
		{
			homogeneous(ipsw, ipne, i.high() <= 0);
			return;
		}
	
		int x0 = ipsw.x;
		int y0 = ipsw.y;
		int x1 = ipne.x;
		int y1 = ipne.y;
		int xd = (x1 - x0 + 1);
		int yd = (y1 - y0 + 1);
		int xm = x0 + xd/2;
		if(xd == 2)
			xm--;
		int ym = y0 + yd/2;
		if(yd == 2)
			ym--;
		iPoint sw, ne;
		
		if(xd <= 1)
		{
			if(yd <= 1)
				Debug.e("BooleanGrid.generateQuadTree: attempt to divide single pixel!");
			sw = new iPoint(x0, y0);
			ne = new iPoint(x0, ym);
			generateQuadTree(sw, ne, csg.prune(new RrRectangle(Rr2Point.sub(sw.realPoint(), inc), Rr2Point.add(ne.realPoint(), inc))));
			
			sw = new iPoint(x0, ym+1);
			ne = new iPoint(x0, y1);
			generateQuadTree(sw, ne, csg.prune(new RrRectangle(Rr2Point.sub(sw.realPoint(), inc), Rr2Point.add(ne.realPoint(), inc))));
			
			return;
		}
		
		if(yd <= 1)
		{
			sw = new iPoint(x0, y0);
			ne = new iPoint(xm, y0);
			generateQuadTree(sw, ne, csg.prune(new RrRectangle(Rr2Point.sub(sw.realPoint(), inc), Rr2Point.add(ne.realPoint(), inc))));
			
			sw = new iPoint(xm+1, y0);
			ne = new iPoint(x1, y0);
			generateQuadTree(sw, ne, csg.prune(new RrRectangle(Rr2Point.sub(sw.realPoint(), inc), Rr2Point.add(ne.realPoint(), inc))));
			
			return;
		}
		
		sw = new iPoint(x0, y0);
		ne = new iPoint(xm, ym);
		generateQuadTree(sw, ne, csg.prune(new RrRectangle(Rr2Point.sub(sw.realPoint(), inc), Rr2Point.add(ne.realPoint(), inc))));
		
		sw = new iPoint(x0, ym + 1);
		ne = new iPoint(xm, y1);
		generateQuadTree(sw, ne, csg.prune(new RrRectangle(Rr2Point.sub(sw.realPoint(), inc), Rr2Point.add(ne.realPoint(), inc))));
		
		sw = new iPoint(xm+1, ym + 1);
		ne = new iPoint(x1, y1);
		generateQuadTree(sw, ne, csg.prune(new RrRectangle(Rr2Point.sub(sw.realPoint(), inc), Rr2Point.add(ne.realPoint(), inc))));
		
		sw = new iPoint(xm+1, y0);
		ne = new iPoint(x1, ym);
		generateQuadTree(sw, ne, csg.prune(new RrRectangle(Rr2Point.sub(sw.realPoint(), inc), Rr2Point.add(ne.realPoint(), inc))));		

	}

	
	//*************************************************************************************
	
	/**
	 * Reset all the visited flags for the entire image
	 *
	 */
	public void resetVisited()
	{
		if(visited != null)
			visited.clear();
	}
	
	
	/**
	 * Is a pixel on an edge?
	 * If it is solid and there is air at at least one
	 * of north, south, east, or west, then yes; otherwise
	 * no.
	 * @param a
	 * @return
	 */
	public boolean isEdgePixel(iPoint a)
	{
		if(!get(a))
			return false;
		
		if(!get(a.add(neighbour[1])))
			return true;
		if(!get(a.add(neighbour[3])))
			return true;
		if(!get(a.add(neighbour[5])))
			return true;
		if(!get(a.add(neighbour[7])))
			return true;
		return false;
	}
	

	/**
	 * Find the index in the bitmap of the next unvisited edge pixel after-and-including start.
	 * Return -1 if there isn't one.
	 * @param start
	 * @return
	 */
	private int findUnvisitedEdgeIndex(int start)
	{
		if(visited == null)
		{
			int i = bits.nextSetBit(start);
			if(i < 0)
				return -1;
			return i;
		}
		
		for(int i=bits.nextSetBit(start); i>=0; i=bits.nextSetBit(i+1)) 
		{
			if(!visited.get(i))
				if(isEdgePixel(pixel(i)))
					return i;
		}
		return -1;		
	}
	

	/**
	 * Remove whiskers (single threads of pixels).
	 *
	 */
	private void deWhisker()
	{
		//System.out.print("deWhisker... ");
		int i = findUnvisitedEdgeIndex(0);
		while(i >= 0)
		{
			iPoint p = pixel(i);
			boolean last = get(p.add(neighbour[7]));
			boolean here;
			boolean isWhisker = true;
			for(int n = 0; n < 8; n++)
			{
				here = get(p.add(neighbour[n]));
				if(here && last)
				{
					isWhisker = false;
					break;
				}
				last = here;
			}
			if(isWhisker)
				set(p, false);
			i = findUnvisitedEdgeIndex(i + 1);
		}
		//System.out.println(" done.");
	}
	
	/**
	 * Find a neighbour of a pixel that has not yet been visited and is on an edge.
	 * @param a
	 * @return
	 */
	public iPoint findUnvisitedNeighbourOnEdge(iPoint a)
	{
		for(int i = 0; i < 8; i++)
		{
			iPoint b = a.add(neighbour[i]);
			if(isEdgePixel(b))
				if(!vGet(b))
					return b;
		}
		return null;
	}
	
	/**
	 * Find a neighbour of a pixel that has not yet been visited, that is on an edge, and
	 * that is in a given direction.
	 * @param a
	 * @param direction
	 * @return
	 */
	public iPoint findUnvisitedNeighbourOnEdgeInDirection(iPoint a, Rr2Point direction)
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
					if(Rr2Point.mul(direction, myDir) > 0)
						if(isEdgePixel(b))
							if(!vGet(b))
								return b;
				}
		return null;
	}
	
	//********************************************************************************
	
	// Return geometrical constructions based on the pattern
	
	/**
	 * Return all the outlines of all the solid areas as polygons consisting of
	 * all the pixels that make up the outlines.
	 * @return
	 */
	private iPolygonList iAllPerimitersRaw()
	{
		iPolygonList result = new iPolygonList();
		iPolygon ip;
		
		//System.out.print("Starting edges... ");
		
		iPoint pixel;
		
		int i = findUnvisitedEdgeIndex(0);
		
		while(i >= 0)
		{
			ip = new iPolygon(true);
			pixel = pixel(i);
			while(pixel != null)
			{
				ip.add(pixel);
				vSet(pixel, true);
				pixel = findUnvisitedNeighbourOnEdge(pixel);
			}
			
			long d2 = ip.point(0).sub(ip.point(ip.size() - 1)).magnitude2();
			if(d2 > 2)
				Debug.e("BooleanGris.iAllPerimitersRaw(): unjoined ends:" + d2);

			if(ip.size() >= 3)
				result.add(ip);
			
			i = findUnvisitedEdgeIndex(i + 1);
		}
		
		resetVisited();
		//System.out.println("Done edges");
		return result;
	}
	
	/**
	 * Return all the outlines of all the solid areas as polygons in
	 * their simplest form.
	 * @return
	 */
	private iPolygonList iAllPerimiters()
	{
		return iAllPerimitersRaw().simplify();
	}
	
	/**
	 * Return all the outlines of all the solid areas as 
	 * real-world polygons with attributes a
	 * @param a
	 * @return
	 */
	public RrPolygonList allPerimiters(Attributes a)
	{
		RrPolygonList r = iAllPerimiters().realPolygons(a);
		r = r.simplify(realResolution);	
		return r;
	}
	
	/**
	 * Generate a sequence of point-pairs where the line h enters
	 * and leaves solid areas.  The point pairs are stored in a 
	 * polygon, which should consequently have an even number of points
	 * in it on return.
	 * @param h
	 * @return
	 */
	private iPolygon hatch(RrHalfPlane h)
	{
		iPolygon result = new iPolygon(false);
		
		RrInterval se = box().wipe(h.pLine(), RrInterval.bigInterval());
		
		if(se.empty())
			return result;
		
		iPoint s = new iPoint(h.pLine().point(se.low()));
		iPoint e = new iPoint(h.pLine().point(se.high()));
		if(get(s))
			Debug.e("BooleanGrid.hatch(): start point is in solid!");
		DDA dda = new DDA(s, e);
		
		iPoint n = dda.next();
		iPoint nOld = n;
		boolean v;
		boolean vs = false;
		while(n != null)
		{
			v = get(n);
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
		
		if(get(e))
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
     * @param hatches
     * @param originP
     * @param targetP
     * @return polygon edge between start/originaPlane and targetPlane
     */
    private SnakeEnd goToPlane(iPoint start, List<RrHalfPlane> hatches, int originP, int targetP) 
    {
    	iPolygon track = new iPolygon(false);
    	
    	RrHalfPlane originPlane = hatches.get(originP);
    	RrHalfPlane targetPlane= hatches.get(targetP);
    	
    	Rr2Point dir = originPlane.normal();
    	if(originPlane.value(targetPlane.pLine().origin()) < 0)
    		dir = dir.neg();

    	if(!get(start))
    	{
    		Debug.e("BooleanGrid.goToPlane(): start is not solid!");
    		return null;
    	}
    	
    	double vTarget = targetPlane.value(start.realPoint());
    	
    	vSet(start, true);
    	
    	iPoint p = findUnvisitedNeighbourOnEdgeInDirection(start, dir);
    	if(p == null)
    		return null;
    	
    	double vOrigin = originPlane.value(p.realPoint());
    	boolean notCrossedOriginPlane = originPlane.value(p.realPoint())*vOrigin >= 0;
    	boolean notCrossedTargetPlane = targetPlane.value(p.realPoint())*vTarget >= 0;
    	while(p != null && notCrossedOriginPlane && notCrossedTargetPlane)
    	{
    		track.add(p);
    		vSet(p, true);
    		p = findUnvisitedNeighbourOnEdge(p);
    		if(p == null)
    			return null;
    		notCrossedOriginPlane = originPlane.value(p.realPoint())*vOrigin >= 0;
        	notCrossedTargetPlane = targetPlane.value(p.realPoint())*vTarget >= 0;
    	}
    	
    	if(notCrossedOriginPlane)
    		return(new SnakeEnd(track, targetP));
    	
       	if(notCrossedTargetPlane)
    		return(new SnakeEnd(track, originP));
       	
       	Debug.e("BooleanGrid.goToPlane(): invalid ending!");
       	
    	return null;
    }

    /**
     * Take a list of hatch point pairs from hatch (above) and the corresponding lines
     * that created them, and stitch them together to make a weaving snake-like hatching
     * pattern for infill.
     * @param ipl
     * @param hatches
     * @param thisHatch
     * @param thisPt
     * @return
     */
	private iPolygon snakeGrow(iPolygonList ipl, List<RrHalfPlane> hatches, int thisHatch, int thisPt) 
	{
		iPolygon result = new iPolygon(false);
		
		iPolygon thisPolygon = ipl.polygon(thisHatch);
		iPoint pt = thisPolygon.point(thisPt);
		result.add(pt);
		SnakeEnd jump;
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
				result.add(jump.track);
				thisHatch = jump.hitPlaneIndex;
				thisPolygon = ipl.polygon(thisHatch);
				thisPt = thisPolygon.nearest(jump.track.point(jump.track.size() - 1));
			}
		} while(jump != null && thisPt >= 0);		
		return result;
	}
	
	/**
	 * Hatch all the polygons parallel to line hp with increment gap
	 * @param hp
	 * @param gap
	 * @param a
	 * @return a polygon list of hatch lines as the result with attributes a
	 */
	public RrPolygonList hatch(RrHalfPlane hp, double gap, Attributes a)
	{	
		//System.out.print("Starting hatching... ");
		
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
		//System.out.print(" done raw hatching... ");
		
		//return iHatches.realPolygons(a);
		
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
		
		resetVisited();
		
		//System.out.println(" joined up hatching... ");
		
		return snakes.realPolygons(a).simplify(realResolution);
	}
	
	
	/**
	 * Offset the pattern by a given real-world distance.  If the distance is
	 * negative the pattern is shrunk; if it is positive it is grown;
	 * @param dist
	 * @return
	 */
	public BooleanGrid offset(double dist)
	{	
		RrPolygonList rpl = allPerimiters(new Attributes(null, null, null, null));
		RrCSG csgp = rpl.toCSG(realResolution);
		RrCSG csg = csgp.offset(dist);
		RrRectangle rec = box().offset(dist);
		return new BooleanGrid(csg, rec);
	}
	
	//*********************************************************************************************************
	
	// Boolean operators on the quad tree
	
	// TODO: make them deal with different box sizes!
	
	
//	/**
//	 * Complement a grid
//	 * @return
//	 */
//	public BooleanGrid complement()
//	{
//		BooleanGrid result = new BooleanGrid(this);
//		result.bits.flip(0, size.x*size.y - 1);
//		return result;
//	}
//	
//	
//	/**
//	 * Compute the union of two images
//	 * @param d
//	 * @param e
//	 * @return
//	 */
//	public static BooleanGrid union(BooleanGrid d, BooleanGrid e)
//	{
//		BooleanGrid result = new BooleanGrid(d);
//		result.bits.or(e.bits);
//		return result;
//	}
//	
//	
//	/**
//	 * Compute the intersection of two quad trees
//	 * @param d
//	 * @param e
//	 * @return
//	 */
//	public static BooleanGrid intersection(BooleanGrid d, BooleanGrid e)
//	{
//		BooleanGrid result = new BooleanGrid(d);
//		result.bits.and(e.bits);
//		return result;
//	}
//	/**
//	 * Grid d - grid e
//	 * @param d
//	 * @param e
//	 * @return
//	 */
//	public static BooleanGrid difference(BooleanGrid d, BooleanGrid e)
//	{
//		BooleanGrid result = new BooleanGrid(d);
//		result.bits.andNot(e.bits);
//		return result;
//	}
}
