
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
 * The class makes extensive use of lazy evaluation.
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
		 * Back and forth
		 * @param i
		 * @return
		 */
		double scale(int i) { return i*pixSize; }
		int iScale(double d) { return (int)(0.5 + d/pixSize); }
		
		/**
		 * Convert real-world point to integer
		 * @param a
		 */
		iPoint(Rr2Point a)
		{
			x = iScale(a.x()) - rec.swCorner.x;
			y = iScale(a.y()) - rec.swCorner.y;
		}
		
		/**
		 * Generate the equivalent real-world point
		 * @return
		 */
		Rr2Point realPoint()
		{
			return new Rr2Point(scale(rec.swCorner.x + x), scale(rec.swCorner.y + y));
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
		 * Opposite direction
		 * @return
		 */
		iPoint neg()
		{
			return new iPoint(-x, -y);
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
		 * Squared length
		 * @return
		 */
		long magnitude2()
		{
			return x*x + y*y;
		}
		
		/**
		 * Scalar product
		 * @param a
		 * @return
		 */
		long scalarProduct(iPoint a)
		{
			return x*a.x + y*a.y;
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
	 * Small class to hold rectangles represented by the sw point and
	 * the size.
	 * @author ensab
	 *
	 */
	class iRectangle
	{
		public iPoint swCorner;
		public iPoint size;
		
		/**
		 * Construct from the corner points
		 * @param min
		 * @param max
		 */
		public iRectangle(iPoint min, iPoint max)
		{
			swCorner = new iPoint(min);
			size = max.sub(min);
			size.x++;
			size.y++;
		}
		
		/**
		 * Copy constructor
		 * @param r
		 */
		public iRectangle(iRectangle r)
		{
			swCorner = new iPoint(r.swCorner);
			size = new iPoint(size);
		}
		
		/**
		 * Big rectangle containing the union of two.
		 * @param b
		 * @return
		 */
		public iRectangle union(iRectangle b)
		{
			iRectangle result = new iRectangle(this);
			result.swCorner.x = Math.min(result.swCorner.x, b.swCorner.x);
			result.swCorner.y = Math.min(result.swCorner.y, b.swCorner.y);
			int sx = result.swCorner.x + result.size.x - 1;
			sx = Math.max(sx, b.swCorner.x + b.size.x - 1) - result.swCorner.x + 1;
			int sy = result.swCorner.y + result.size.y - 1;
			sy = Math.max(sy, b.swCorner.y + b.size.y - 1) - result.swCorner.y + 1;
			result.size = new iPoint(sx, sy);			
			return result;
		}
		
		/**
		 * Rectangle containing the intersection of two.
		 * @param b
		 * @return
		 */
		public iRectangle intersection(iRectangle b)
		{
			iRectangle result = new iRectangle(this);
			result.swCorner.x = Math.max(result.swCorner.x, b.swCorner.x);
			result.swCorner.y = Math.max(result.swCorner.y, b.swCorner.y);
			int sx = result.swCorner.x + result.size.x - 1;
			sx = Math.min(sx, b.swCorner.x + b.size.x - 1) - result.swCorner.x + 1;
			int sy = result.swCorner.y + result.size.y - 1;
			sy = Math.min(sy, b.swCorner.y + b.size.y - 1) - result.swCorner.y + 1;
			result.size = new iPoint(sx, sy);			
			return result;
		}
		
		/**
		 * Anything there?
		 * @return
		 */
		public boolean isEmpty()
		{
			return size.x < 0 | size.y < 0;
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
	static final double realResolution = pixSize*1.5;
	static final double rSwell = 0.5; // mm by which to swell rectangles to give margins round stuff
	
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
	private iRectangle rec;
	
	/**
	 * The csg expression
	 */
	private RrCSG csg;
	
	/**
	 * How simple does a CSG expression have to be to not be worth pruning further?
	 */
	private static final int simpleEnough = 3;
	
	/**
	 * The attributes
	 */
	private Attributes att;
	
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
	
	/**
	 * Lookup table behaves like scalar product for two neighbours i and j; get it by neighbourProduct[Math.abs(j - i)]
	 */
	private final int[] neighbourProduct = {2, 1, 0, -1, -2, -1, 0, 1};
	
	//**************************************************************************************************
	// Debugging
	
	private static String stack[] = new String[20];
	private static int sp = -1;
	private static boolean debug = true;
	
	private void push(String s)
	{
		if(!debug)
			return;
		sp++;
		stack[sp] = s;
		for(int i = 0; i < sp; i++)
			System.out.print(" ");
		System.out.println("{ " + s);
		System.out.flush();
	}
	private void pop()
	{
		if(!debug)
			return;
		for(int i = 0; i < sp; i++)
			System.out.print(" ");
		System.out.println("} " + stack[sp]);
		System.out.flush();
		sp--;
	}
	
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
	 * This function is called by anything that queries the bitmap.
	 * It does nothing if the bitmap exists.  If it doesn't, it creates it.
	 *
	 */
	private void evaluateIfNeedBe()
	{
		if(bits != null)
			return;
		bits = new BitSet(rec.size.x*rec.size.y);
		visited = null;
		push("Build quad tree... ");
		//Debug.e("Quad start.");
		generateQuadTree(new iPoint(0, 0), new iPoint(rec.size.x - 1, rec.size.y - 1), csg);
		//Debug.e("Quad end.");
		pop();
		deWhisker();		
	}
	
	/**
	 * Build the grid from a CSG expression
	 * @param csgP
	 */
	public BooleanGrid(RrCSG csgExp, RrRectangle rectangle, Attributes a)
	{
		csg = csgExp;  // N.B. No deep copy
		att = a;
		RrRectangle ri = rectangle.offset(rSwell);
		rec = new iRectangle(new iPoint(0, 0), new iPoint(1, 1));  // Set the origin to (0, 0)...
		rec.swCorner = new iPoint(ri.sw());                        // That then gets subtracted by the iPoint constructor to give the true origin
		rec.size = new iPoint(ri.ne());                            // The true origin is now automatically subtracted.
		bits = null;
		visited = null;
	}
	
	
	/**
	 * Copy constructor
	 * N.B. attributes are _not_ deep copied
	 * @param bg
	 */
	public BooleanGrid(BooleanGrid bg)
	{
		csg = new RrCSG(bg.csg);
		att = bg.att;
		bits = null;
		visited = null;
		rec= new iRectangle(bg.rec);
	}
	
	/**
	 * The index of a pixel in the 1D bit array.
	 * @param x
	 * @param y
	 * @return
	 */
	private int pixI(int x, int y)
	{
		return x*rec.size.y + y;
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
		return new iPoint(i/rec.size.y, i%rec.size.y);
	}
	
	/**
	 * Return the attributes
	 * @return
	 */
	public Attributes attributes()
	{
		return att;
	}
	
	/**
	 * Any pixels set?
	 * @return
	 */
	public boolean isEmpty()
	{
		evaluateIfNeedBe();
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
		if(p.x >= rec.size.x)
			return false;
		if(p.y >= rec.size.y)
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
		evaluateIfNeedBe();
		if(!inside(p))
		{
			Debug.e("BoolenGrid.set(): attempt to set pixel beyond boundary!");
			return;
		}
		bits.set(pixI(p), v);
	}
	
	/**
	 * Fill a disc centre c radius r with v
	 * @param c
	 * @param r
	 * @param v
	 */
	public void disc(iPoint c, int r, boolean v)
	{
		evaluateIfNeedBe();
		for(int x = -r; x <= r; x++)
		{
			int y = (int)(0.5+Math.sqrt((double)(r*r - x*x)));
			bits.set(pixI(c.x + x, c.y -y), pixI(c.x + x, c.y + y) + 1, v);
		}
	}
	
	/**
	 * Fill a rectangle with centreline running from p0 to p1 of width 2r with v
	 * @param p0
	 * @param p1
	 * @param r
	 * @param v
	 */
	public void rectangle(iPoint p0, iPoint p1, int r, boolean v)
	{
		evaluateIfNeedBe();
		Rr2Point rp0 = new Rr2Point(p0.x, p0.y);
		Rr2Point rp1 = new Rr2Point(p1.x, p1.y);
		RrHalfPlane[] h = new RrHalfPlane[4];
		h[0] = new RrHalfPlane(rp0, rp1);
		h[2] = h[0].offset(r).complement();
		h[0] = h[0].offset(-r);
		h[1] = new RrHalfPlane(new RrLine(rp0, Rr2Point.add(rp0, h[0].normal())));
		h[3] = new RrHalfPlane(new RrLine(rp1, Rr2Point.add(rp1, h[2].normal())));
		double xMin = Double.MAX_VALUE;
		double xMax = Double.MIN_VALUE;
		Rr2Point p = null;
		for(int i = 0; i < 4; i++)
		{
			try
			{
				p = h[i].cross_point(h[(i+1)%4]);
			} catch (Exception e)
			{}
			xMin = Math.min(xMin, p.x());
			xMax = Math.max(xMax, p.x());
		}
		int iXMin = (int)(0.5 + xMin);
		int iXMax = (int)(0.5 + xMax);
		for(int x = iXMin; x <= iXMax; x++)
		{
			RrLine yLine = new RrLine(new Rr2Point(x, 0), new Rr2Point(x, 1));
			RrInterval iv = RrInterval.bigInterval();
			for(int i = 0; i < 4; i++)
				iv = h[i].wipe(yLine, iv);
			if(!iv.empty())
			{
				int yLow = (int)(0.5 + yLine.point(iv.low()).y());
				int yHigh = (int)(0.5 + yLine.point(iv.high()).y());
				bits.set(pixI(x, yLow), pixI(x, yHigh) + 1, v);
			}
		}
	}
	
	/**
	 * Set a whole rectangle to one value
	 * @param ipsw
	 * @param ipne
	 * @param v
	 */
	private void homogeneous(iPoint ipsw, iPoint ipne, boolean v)
	{
		evaluateIfNeedBe();
		// TODO: if v is false may we just return?
		for(int x = ipsw.x; x <= ipne.x; x++)
			bits.set(pixI(x, ipsw.y), pixI(x, ipne.y) + 1, v);
	}
	
	/**
	 * Set a whole rectangle to the right values for a CSG expression
	 * @param ipsw
	 * @param ipne
	 * @param v
	 */
	private void heterogeneous(iPoint ipsw, iPoint ipne, RrCSG csgExpression)
	{
		evaluateIfNeedBe();
		// TODO: if v is false may we just return?
		for(int x = ipsw.x; x <= ipne.x; x++)
			for(int y = ipsw.y; y <= ipne.y; y++)
				bits.set(pixI(x, y), csgExpression.value(new iPoint(x, y).realPoint()) <= 0);
	}
	
	/**
	 * The rectangle surrounding the set pixels in real coordinates.
	 * @return
	 */
	public RrRectangle box()
	{
		return new RrRectangle(new iPoint(0, 0).realPoint(), new iPoint(rec.size.x - 1, rec.size.y - 1).realPoint());
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
		evaluateIfNeedBe();
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
			visited = new BitSet(rec.size.x*rec.size.y);
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
	private void generateQuadTree(iPoint ipsw, iPoint ipne, RrCSG csgExpression)
	{
		Rr2Point inc = new Rr2Point(pixSize*0.5, pixSize*0.5);
		Rr2Point p0 = ipsw.realPoint();
		
		// Single pixel?
		
		if(ipsw.coincidesWith(ipne))
		{
			set(ipsw, csgExpression.value(p0) <= 0);
			return;
		}
		
		// Uniform rectangle?
		
		Rr2Point p1 = ipne.realPoint();
		RrInterval i = csgExpression.value(new RrRectangle(Rr2Point.sub(p0, inc), Rr2Point.add(p1, inc)));
		if(!i.zero())
		{
			homogeneous(ipsw, ipne, i.high() <= 0);
			return;
		}
		
		// Non-uniform, but simple, rectangle
		
		if(csgExpression.complexity() <= simpleEnough)
		{
			heterogeneous(ipsw, ipne, csgExpression);
			return;
		}
	
		// Divide this rectangle into four (roughly) congruent quads.
		
		// Work out the corner coordinates.
		
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
		
		// Special case - a single vertical line of pixels
		
		if(xd <= 1)
		{
			if(yd <= 1)
				Debug.e("BooleanGrid.generateQuadTree: attempt to divide single pixel!");
			sw = new iPoint(x0, y0);
			ne = new iPoint(x0, ym);
			generateQuadTree(sw, ne, csgExpression.prune(new RrRectangle(Rr2Point.sub(sw.realPoint(), inc), Rr2Point.add(ne.realPoint(), inc))));
			
			sw = new iPoint(x0, ym+1);
			ne = new iPoint(x0, y1);
			generateQuadTree(sw, ne, csgExpression.prune(new RrRectangle(Rr2Point.sub(sw.realPoint(), inc), Rr2Point.add(ne.realPoint(), inc))));
			
			return;
		}
		
		// Special case - a single horizontal line of pixels
		
		if(yd <= 1)
		{
			sw = new iPoint(x0, y0);
			ne = new iPoint(xm, y0);
			generateQuadTree(sw, ne, csgExpression.prune(new RrRectangle(Rr2Point.sub(sw.realPoint(), inc), Rr2Point.add(ne.realPoint(), inc))));
			
			sw = new iPoint(xm+1, y0);
			ne = new iPoint(x1, y0);
			generateQuadTree(sw, ne, csgExpression.prune(new RrRectangle(Rr2Point.sub(sw.realPoint(), inc), Rr2Point.add(ne.realPoint(), inc))));
			
			return;
		}
		
		// General case - 4 quads.
		
		sw = new iPoint(x0, y0);
		ne = new iPoint(xm, ym);
		generateQuadTree(sw, ne, csgExpression.prune(new RrRectangle(Rr2Point.sub(sw.realPoint(), inc), Rr2Point.add(ne.realPoint(), inc))));
		
		sw = new iPoint(x0, ym + 1);
		ne = new iPoint(xm, y1);
		generateQuadTree(sw, ne, csgExpression.prune(new RrRectangle(Rr2Point.sub(sw.realPoint(), inc), Rr2Point.add(ne.realPoint(), inc))));
		
		sw = new iPoint(xm+1, ym + 1);
		ne = new iPoint(x1, y1);
		generateQuadTree(sw, ne, csgExpression.prune(new RrRectangle(Rr2Point.sub(sw.realPoint(), inc), Rr2Point.add(ne.realPoint(), inc))));
		
		sw = new iPoint(xm+1, y0);
		ne = new iPoint(x1, ym);
		generateQuadTree(sw, ne, csgExpression.prune(new RrRectangle(Rr2Point.sub(sw.realPoint(), inc), Rr2Point.add(ne.realPoint(), inc))));		

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
		evaluateIfNeedBe();
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
	 * TODO: also need to do the same for cracks?
	 *
	 */
	private void deWhisker()
	{
		push("deWhisker... ");
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
		pop();
	}
	
	/**
	 * Look-up table to find the index of a neighbour point, n, from the point.
	 * @param n
	 * @return
	 */
	private int neighbourIndex(iPoint n)
	{
		switch((n.y + 1)*3 + n.x + 1)
		{
		case 0: return 0;
		case 1: return 1;
		case 2: return 2;
		case 3: return 7;
		case 5: return 3;
		case 6: return 6;
		case 7: return 5;
		case 8: return 4;
		default:
			Debug.e("BooleanGrid.neighbourIndex(): not a neighbour point!" + n.toString());	
		}
		return 0;
	}

	
	/**
	 * Find the index of the neighbouring point that's closest to a given real direction.
	 * @param p
	 * @return
	 */
	private int directionToNeighbour(Rr2Point p)
	{
		double score = Double.MIN_VALUE;
		int result = -1;
		for(int i = 0; i < 8; i++)
		{
			// Can't use neighbour.realPoint as that adds swCorner...
			// We have to normailze neighbour, to get answers proportional to cosines
			double s = Rr2Point.mul(p, new Rr2Point(neighbour[i].x, neighbour[i].y).norm()); 
			if(s > score)
			{
				result = i;
				score = s;
			}
		}
		if(result < 0)
			Debug.e("BooleanGrid.directionToNeighbour(): scalar product error!");
		return result;
	}
	
	
	/**
	 * Find a neighbour of a pixel that has not yet been visited, that is on an edge, and
	 * that is nearest to a given neighbour direction, nd.  If nd < 0 the first unvisited
	 * neighbour is returned.  If no valid neighbour exists, null is returned.
	 * @param a
	 * @param direction
	 * @return
	 */
	public iPoint findUnvisitedNeighbourOnEdgeInDirection(iPoint a, int nd)
	{
		iPoint result = null;
		int score = -5;
		for(int i = 0; i < 8; i++)
		{
			iPoint b = a.add(neighbour[i]);
			if(isEdgePixel(b))
				if(!vGet(b))
				{
					if(nd < 0)
						return b;
					int s = neighbourProduct[Math.abs(nd - i)];
					if(s > score)
					{
						score = s;
						result = b;
					}
				}
		}
		return result;
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
		
		push("Computing edges... ");
		
		iPoint thisPoint;
		
		int i = findUnvisitedEdgeIndex(0);
		
		while(i >= 0)
		{
			ip = new iPolygon(true);
			thisPoint = pixel(i);
			int direction = -1;
			iPoint newPoint;
			while(thisPoint != null)
			{
				ip.add(thisPoint);
				vSet(thisPoint, true);
				newPoint = findUnvisitedNeighbourOnEdgeInDirection(thisPoint, direction);
				if(newPoint != null)
					direction = neighbourIndex(newPoint.sub(thisPoint)); // Try to go in the same direction
				thisPoint = newPoint;
			}
			
			long d2 = ip.point(0).sub(ip.point(ip.size() - 1)).magnitude2();
			if(d2 > 2)
				Debug.e("BooleanGrid.iAllPerimitersRaw(): unjoined ends:" + d2);

			if(ip.size() >= 3)
				result.add(ip);
			
			i = findUnvisitedEdgeIndex(i + 1);
		}
		
		resetVisited();
		pop();
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
    	
    	int dir = directionToNeighbour(originPlane.normal());
    	
    	if(originPlane.value(targetPlane.pLine().origin()) < 0)
    		dir = neighbourIndex(neighbour[dir].neg());

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
    		p = findUnvisitedNeighbourOnEdgeInDirection(p, dir);
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
		push("Computing hatching... ");
		
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
		
		pop();
		
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
		RrCSG csgExpression = csg.offset(dist);
		RrRectangle rec = box().offset(dist);
		return new BooleanGrid(csgExpression, rec, att);
	}
	
	//*********************************************************************************************************
	
	// Boolean operators on the quad tree
	
	
	/**
	 * Complement a grid
	 * N.B. the grid doesn't get bigger, even though the expression
	 * it contains may now fill the whole of space.
	 * @return
	 */
	public BooleanGrid complement()
	{
		BooleanGrid result = new BooleanGrid(this);
		result.csg = result.csg.complement();
		//result.bits.flip(0, result.rec.size.x*result.rec.size.y - 1);
		return result;
	}
	
	
	
	
	/**
	 * Compute the union of two images
	 * @param d
	 * @param e
	 * @return
	 */
	public static BooleanGrid union(BooleanGrid d, BooleanGrid e)
	{
		BooleanGrid result = new BooleanGrid(d);
		result.rec = d.rec.union(e.rec);
		result.csg = RrCSG.union(result.csg, e.csg);
		//result.bits.or(e.bits);
		return result;
	}
	
	
	/**
	 * Compute the intersection of two quad trees
	 * @param d
	 * @param e
	 * @return
	 */
	public static BooleanGrid intersection(BooleanGrid d, BooleanGrid e)
	{
		BooleanGrid result = new BooleanGrid(d);
		result.rec = d.rec.intersection(e.rec);
		if(result.rec.isEmpty())
		{
			result.csg = RrCSG.nothing();
			result.rec.size = result.new iPoint(1,1); // For safety
		}else
			result.csg = RrCSG.intersection(result.csg, e.csg);		
		//result.bits.and(e.bits);
		return result;
	}
	/**
	 * Grid d - grid e
	 * d's rectangle is presumed to contain the result.
	 * TODO: write a function to compute the rectangle from the bitmap
	 * @param d
	 * @param e
	 * @return
	 */
	public static BooleanGrid difference(BooleanGrid d, BooleanGrid e)
	{
		BooleanGrid result = new BooleanGrid(d);
		result.csg = RrCSG.difference(d.csg, e.csg);
		//result.bits.andNot(e.bits);
		return result;
	}
}
