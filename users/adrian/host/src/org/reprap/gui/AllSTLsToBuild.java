package org.reprap.gui;

import java.util.List;
import java.util.ArrayList;
import org.reprap.geometry.polygons.*;
import org.reprap.geometry.LayerRules;
import org.reprap.Attributes;
import org.reprap.Extruder;
import org.reprap.Preferences;
import org.reprap.utilities.Debug;
import javax.media.j3d.Appearance;
import javax.media.j3d.BranchGroup;
import javax.media.j3d.GeometryArray;
import javax.media.j3d.Group;
import javax.media.j3d.SceneGraphObject;
import javax.media.j3d.Shape3D;
import javax.media.j3d.Transform3D;
import javax.vecmath.Point3d;
import javax.vecmath.Tuple3d;

import com.sun.j3d.utils.geometry.GeometryInfo;
import com.sun.j3d.utils.geometry.NormalGenerator;

/**
 * This class holds a list of STLObjects that represents everything that is to be built.
 * 
 * An STLObject may consist of items from several STL files, possible of different materials.
 * But they are all tied together relative to each other in space.
 * 
 * @author Adrian
 *
 */
public class AllSTLsToBuild 
{	
	/**
	 * Line segment consisting of two points.
	 * @author Adrian
	 *
	 */
	class LineSegment
	{	
		/**
		 * The ends of the line segment
		 */
		public Rr2Point a = null, b = null;
		
		/**
		 * The attribute (i.e. RepRap material) of the segment.
		 */
		public Attributes att = null;

		protected void finalize() throws Throwable
		{
			a = null;
			b = null;
			att = null;
			super.finalize();
		}
		
		/**
		 * Constructor takes two intersection points with an STL triangle edge.
		 * @param p
		 * @param q
		 */
		public LineSegment(Rr2Point p, Rr2Point q, Attributes at)
		{
			if(at == null)
				System.err.println("LineSegment(): null attributes!");
			a = p;
			b = q;
			att = at;
		}
	}
	
	/**
	 * Ring buffer cache to hold previously computed slices for doing 
	 * infill and support material calculations.
	 * @author ensab
	 *
	 */
	class SliceCache
	{
		private BooleanGridList[][] sliceRing;
		private int[] layerNumber;
		private int ringPointer;
		private final int noLayer = Integer.MIN_VALUE;
		private final int ringSize = 5;
		
		public SliceCache()
		{
			sliceRing = new BooleanGridList[ringSize][stls.size()];
			layerNumber = new int[ringSize];
			ringPointer = 0;
			for(int layer = 0; layer < ringSize; layer++)
				for(int stl = 0; stl < stls.size(); stl++)
				{
					sliceRing[layer][stl] = null;
					layerNumber[layer] = noLayer;
				}
		}
		
		public void set(BooleanGridList slice, int layer, int stl)
		{
			layerNumber[ringPointer] = layer;
			sliceRing[ringPointer][stl] = slice;
			ringPointer++;
			if(ringPointer >= ringSize)
				ringPointer = 0;
		}
		
		public BooleanGridList get(int layer, int stl)
		{
			int l = ringPointer;
			for(int i = 0; i < ringSize; i++)
			{
				l--;
				if(l < 0)
					l = ringSize - 1;
				if(layerNumber[l] == layer)
					return sliceRing[l][stl];
			}
			Debug.d("SliceCache.get(): layer not found.");
			return null;
		}
	}
	
	/**
	 * The list of things to be built
	 */
	private List<STLObject> stls;
	
	/**
	 * The XY box around everything
	 */
	private RrRectangle XYbox;
	
	/**
	 * The lowest and highest points
	 */
	private RrInterval Zrange;
	
	/**
	 * Is the list editable?
	 */
	private boolean frozen;
	
	/**
	 * Recently computed slices
	 */
	private SliceCache cache;
	
	/**
	 * Simple constructor
	 *
	 */
	public AllSTLsToBuild()
	{
		stls = new ArrayList<STLObject>();
		XYbox = null;
		Zrange = null;
		frozen = false;
		cache = null;
	}
	
	/**
	 * Add a new STLObject
	 * @param s
	 */
	public void add(STLObject s)
	{
		if(frozen)
			Debug.d("AllSTLsToBuild.add(): attempt to add an item to a frozen list.");
		stls.add(s);
	}
	
	/**
	 * Get the i-th STLObject
	 * @param i
	 * @return
	 */
	public STLObject get(int i)
	{
		return stls.get(i);
	}
	
	/**
	 * Delete an object
	 * @param i
	 */
	public void remove(int i)
	{
		if(frozen)
			Debug.d("AllSTLsToBuild.remove(): attempt to remove an item to a frozen list.");
		stls.remove(i);
	}
	
	/**
	 * Return the number of objects.
	 * @return
	 */
	public int size()
	{
		return stls.size();
	}
	
	/**
	 * Freeze the list - no more editing.
	 *
	 */
	private void freeze()
	{
		frozen = true;
		if(cache == null)
			cache = new SliceCache();
	}
	
	/**
	 * Run through a Shape3D and find its enclosing XY box
	 * @param shape
	 * @param trans
	 * @param z
	 */
	private RrRectangle BBoxPoints(Shape3D shape, Transform3D trans)
    {
		RrRectangle r = null;
        GeometryArray g = (GeometryArray)shape.getGeometry();
        Point3d p1 = new Point3d();
        Point3d q1 = new Point3d();
        
        if(g != null)
        {
            for(int i = 0; i < g.getVertexCount(); i++) 
            {
                g.getCoordinate(i, p1);
                trans.transform(p1, q1);
                if(r == null)
                	r = new RrRectangle(new RrInterval(q1.x, q1.x), new RrInterval(q1.y, q1.y));
                else
                	r.expand(new Rr2Point(q1.x, q1.y));
            }
        }
        return r;
    }
	
	/**
	 * Unpack the Shape3D(s) from value and find their exclosing XY box
	 * @param value
	 * @param trans
	 * @param z
	 */
	private RrRectangle BBox(Object value, Transform3D trans) 
    {
		RrRectangle r = null;
		RrRectangle s;
		
        if(value instanceof SceneGraphObject) 
        {
            SceneGraphObject sg = (SceneGraphObject)value;
            if(sg instanceof Group) 
            {
                Group g = (Group)sg;
                java.util.Enumeration<?> enumKids = g.getAllChildren( );
                while(enumKids.hasMoreElements())
                {
                	if(r == null)
                		r = BBox(enumKids.nextElement(), trans);
                	else
                	{
                		s = BBox(enumKids.nextElement(), trans);
                		if(s != null)
                			r = RrRectangle.union(r, s);
                	}
                }
            } else if (sg instanceof Shape3D) 
            {
                r = BBoxPoints((Shape3D)sg, trans);
            }
        }
        
        return r;
    }
	
	/**
	 * Return the XY box round everything, computing it if need be.
	 * Once this function has been called the list is frozen.
	 * @return
	 */
	public RrRectangle ObjectPlanRectangle()
	{
		freeze();
		if(XYbox != null)
			return XYbox;
		
		RrRectangle s;
		
		for(int i = 0; i < stls.size(); i++)
		{
			STLObject stl = stls.get(i);
			Transform3D trans = stl.getTransform();

			BranchGroup bg = stl.getSTL();
			java.util.Enumeration<?> enumKids = bg.getAllChildren();

			while(enumKids.hasMoreElements())
			{
				Object ob = enumKids.nextElement();

				if(ob instanceof BranchGroup)
				{
					BranchGroup bg1 = (BranchGroup)ob;
					Attributes att = (Attributes)(bg1.getUserData());
					if(XYbox == null)
						XYbox = BBox(att.getPart(), trans);
					else
					{
						s = BBox(att.getPart(), trans);
						if(s != null)
							XYbox = RrRectangle.union(XYbox, s);
					}
				}
			}

		}		
				
		return XYbox;
	}
	
	/**
	 * Find the top of the highest object.
	 * Calling this freezes the list.
	 * @return
	 */
	public double maxZ()
	{
		freeze();
		if(Zrange != null)
			return Zrange.high();

		STLObject stl;
		double zlo = Double.POSITIVE_INFINITY;
		double zhi = Double.NEGATIVE_INFINITY;

		for(int i = 0; i < stls.size(); i++)
		{
			stl = stls.get(i);
			if(stl.size().z > zhi)
				zhi = stl.size().z;
			if(stl.size().z < zlo)
				zlo = stl.size().z;
		}
		
		Zrange = new RrInterval(zlo, zhi);	

		return Zrange.high();
	}
	
	/**
	 * Stitch together the some fo the edges to form a polygon.
	 * @param edges
	 * @return
	 */
	private RrPolygon getNextPolygon(ArrayList<LineSegment> edges)
	{
		if(edges.size() <= 0)
			return null;
		LineSegment next = edges.get(0);
		edges.remove(0);
		RrPolygon result = new RrPolygon(next.att, true);
		result.add(next.a);
		result.add(next.b);
		Rr2Point start = next.a;
		Rr2Point end = next.b;
		
		boolean first = true;
		while(edges.size() > 0)
		{
			double d2 = Rr2Point.dSquared(start, end);
			if(first)
				d2 = Math.max(d2, 1);
			first = false;
			boolean aEnd = false;
			int index = -1;
			for(int i = 0; i < edges.size(); i++)
			{
				double dd = Rr2Point.dSquared(edges.get(i).a, end);
				if(dd < d2)
				{
					d2 = dd;
					aEnd = true;
					index = i;
				}
				dd = Rr2Point.dSquared(edges.get(i).b, end);
				if(dd < d2)
				{
					d2 = dd;
					aEnd = false;
					index = i;
				}
			}

			if(index >= 0)
			{
				next = edges.get(index);
				edges.remove(index);
				int ipt = result.size() - 1;
				if(aEnd)
				{
					result.set(ipt, Rr2Point.mul(Rr2Point.add(next.a, result.point(ipt)), 0.5));
					result.add(next.b);
					end = next.b;
				} else
				{
					result.set(ipt, Rr2Point.mul(Rr2Point.add(next.b, result.point(ipt)), 0.5));
					result.add(next.a);
					end = next.a;				
				}
			} else
				return result;
		}
		
		Debug.d("STLSlice.getNextPolygon(): exhausted edge list!");
		
		return result;
	}
	
	/**
	 * Get all the polygons represented by the edges.
	 * @param edges
	 * @return
	 */
	private RrPolygonList simpleCull(ArrayList<LineSegment> edges)
	{
		RrPolygonList result = new RrPolygonList();
		RrPolygon next = getNextPolygon(edges);
		while(next != null)
		{
			if(next.size() >= 3)
				result.add(next);
			next = getNextPolygon(edges);
		}
		
		return result;
	}
	
	/**
	 * Compute the infill hatching polygons for this set of patterns
	 * @param layerConditions
	 * @return
	 */
	public RrPolygonList computeInfill(int stl, LayerRules layerConditions)
	{
		int layer = layerConditions.getMachineLayer();
		BooleanGridList shapes = slice(layer, stl, layerConditions);

		BooleanGridList previousSlices = slice(layer+1, stl, layerConditions);
		previousSlices = BooleanGridList.intersections(slice(layer+2, stl, layerConditions), previousSlices);
		BooleanGridList insides = null;
		
		if(previousSlices != null && layerConditions.getModelLayer() > 1)
		{
			insides = BooleanGridList.intersections(shapes, previousSlices);
			BooleanGridList temp = shapes;
			shapes = BooleanGridList.differences(shapes, previousSlices);
			shapes = shapes.offset(layerConditions, false, -1);
			shapes = BooleanGridList.intersections(shapes, temp);
		}
			
		shapes = shapes.offset(layerConditions, false, 1);
		
		if(insides != null)
			insides = insides.offset(layerConditions, false, 1);
		
		RrPolygonList hatchedPolygons = shapes.hatch(layerConditions, true);
		
//		if(layerConditions.getLayingSupport())
//			offHatch = offHatch.union(layerConditions.getPrinter().getExtruders());
			
		if(insides != null)
			hatchedPolygons.add(insides.hatch(layerConditions, false));
		
		return hatchedPolygons;
	}
	
	/**
	 * Compute the outline polygons for this set of patterns.
	 * @param layerConditions
	 * @param hatchedPolygons
	 * @param shield
	 * @return
	 */
	public RrPolygonList computeOutlines(int stl, LayerRules layerConditions, RrPolygonList hatchedPolygons, boolean shield)
	{
		
		int layer = layerConditions.getMachineLayer();
		BooleanGridList shapes = slice(layer, stl, layerConditions);
		
		RrPolygonList borderPolygons;
		
		if(layerConditions.getLayingSupport())
		{
			borderPolygons = null;
		} else
		{
			BooleanGridList offBorder = shapes.offset(layerConditions, true, 1);
			borderPolygons = offBorder.borders();
		}


		if(borderPolygons != null && borderPolygons.size() > 0)
		{
			borderPolygons.middleStarts(hatchedPolygons, layerConditions);
			try
			{
				if(shield && Preferences.loadGlobalBool("Shield"))
				{
					RrRectangle rr = layerConditions.getBox();
					Rr2Point corner = Rr2Point.add(rr.sw(), new Rr2Point(-3, -3));
					RrPolygon ell = new RrPolygon(borderPolygons.polygon(0).getAttributes(), false);
					ell.add(corner);
					ell.add(Rr2Point.add(corner, new Rr2Point(-2, 10)));
					ell.add(Rr2Point.add(corner, new Rr2Point(-2, -2)));
					ell.add(Rr2Point.add(corner, new Rr2Point(20, -2)));
					borderPolygons.add(0, ell);
				}
			} catch (Exception ex)
			{}
		}
		
		return borderPolygons;
	}

	
	/**
	 * Generate a set of pixel-map representations, one for each extruder, for
	 * STLObject i at height z.
	 * 
	 * @param i
	 * @param z
	 * @param extruders
	 * @return
	 */
	private BooleanGridList slice(int layer, int stl, LayerRules layerRules)
	{
		freeze();
		BooleanGridList result = cache.get(layer, stl);
		if(result != null)
			return result;
		
		// Haven't got it in the cache, so we need to compute it
		
		double z = layerRules.getModelZ() + layerRules.getZStep()*0.5;
		Extruder[] extruders = layerRules.getPrinter().getExtruders();
		result = new BooleanGridList();
		RrCSG csgp = null;
		RrPolygonList pgl = new RrPolygonList();
		int extruderID;
		
		// Bin the edges by extruder ID.
		
		ArrayList<LineSegment>[] edges = new ArrayList[extruders.length];
		
		for(extruderID = 0; extruderID < extruders.length; extruderID++)
		{
			if(extruders[extruderID].getID() != extruderID)
				Debug.e("AllSTLsToBuild.slice(): extruder " + extruderID + "out of sequence: " + extruders[extruderID].getID());
			edges[extruderID] = new ArrayList<LineSegment>();
		}
		

		
		// Generate all the edges for STLObject i at this z
		
		STLObject stlObject = stls.get(stl);
		Transform3D trans = stlObject.getTransform();

		BranchGroup bg = stlObject.getSTL();
		java.util.Enumeration<?> enumKids = bg.getAllChildren();

		while(enumKids.hasMoreElements())
		{
			Object ob = enumKids.nextElement();

			if(ob instanceof BranchGroup)
			{
				BranchGroup bg1 = (BranchGroup)ob;
				Attributes attr = (Attributes)(bg1.getUserData());
				recursiveSetEdges(attr.getPart(), trans, z, attr, edges);
			}
		}

		// Turn them into lists of polygons, one for each extruder, then
		// turn those into pixelmaps.
		
		for(extruderID = 0; extruderID < edges.length; extruderID++)
		{
			pgl = simpleCull(edges[extruderID]);
			
			if(pgl.size() > 0)
			{
				// Remove wrinkles

				pgl = pgl.simplify(Preferences.gridRes()*1.5);

				// Fix small radii

				pgl = pgl.arcCompensate();

				csgp = pgl.toCSG(Preferences.tiny());

				result.add(new BooleanGrid(csgp, pgl.getBox(), pgl.polygon(0).getAttributes()));	
			}
		}
		
		cache.set(result, layer, stl);
		
		return result;
	}

	
	public void destroyLayer() {}
	
	/**
	 * Add the edge where the plane z cuts the triangle (p, q, r) (if it does).
	 * Also update the triangulation of the object below the current slice used
	 * for the simulation window.
	 * @param p
	 * @param q
	 * @param r
	 * @param z
	 */
	private void addEdge(Point3d p, Point3d q, Point3d r, double z, Attributes att, ArrayList<LineSegment> edges[])
	{
		Point3d odd = null, even1 = null, even2 = null;
		int pat = 0;
		//boolean twoBelow = false;
		
		if(p.z < z)
			pat = pat | 1;
		if(q.z < z)
			pat = pat | 2;
		if(r.z < z)
			pat = pat | 4;
		
		switch(pat)
		{
		// All above
		case 0:
			return;
			
		// All below
		case 7:
			return;
			
		// q, r below, p above	
		case 6:
			//twoBelow = true;
		// p below, q, r above
		case 1:
			odd = p;
			even1 = q;
			even2 = r;
			break;
			
		// p, r below, q above	
		case 5:
			//twoBelow = true;
		// q below, p, r above	
		case 2:
			odd = q;
			even1 = r;
			even2 = p;
			break;

		// p, q below, r above	
		case 3:
			//twoBelow = true;
		// r below, p, q above	
		case 4:
			odd = r;
			even1 = p;
			even2 = q;
			break;
			
		default:
			System.err.println("addEdge(): the | function doesn't seem to work...");
		}
		
		// Work out the intersection line segment (e1 -> e2) between the z plane and the triangle
		
		even1.sub((Tuple3d)odd);
		even2.sub((Tuple3d)odd);
		double t = (z - odd.z)/even1.z;	
		Rr2Point e1 = new Rr2Point(odd.x + t*even1.x, odd.y + t*even1.y);	
		//Point3d e3_1 = new Point3d(e1.x(), e1.y(), z);
		//e1 = new Rr2Point(toGrid(e1.x()), toGrid(e1.y()));
		e1 = new Rr2Point(e1.x(), e1.y());
		t = (z - odd.z)/even2.z;
		Rr2Point e2 = new Rr2Point(odd.x + t*even2.x, odd.y + t*even2.y);
		//Point3d e3_2 = new Point3d(e2.x(), e2.y(), z);
		//e2 = new Rr2Point(toGrid(e2.x()), toGrid(e2.y()));
		e2 = new Rr2Point(e2.x(), e2.y());
		
		// Too short?
		if(!Rr2Point.same(e1, e2, Preferences.lessGridSquare()))
			edges[att.getExtruder().getID()].add(new LineSegment(e1, e2, att));
	}
	

	
	/**
	 * Run through a Shape3D and set edges from it at plane z
	 * Apply the transform first
	 * @param shape
	 * @param trans
	 * @param z
	 */
	private void addAllEdges(Shape3D shape, Transform3D trans, double z, Attributes att, ArrayList<LineSegment> edges[])
    {
        GeometryArray g = (GeometryArray)shape.getGeometry();
        Point3d p1 = new Point3d();
        Point3d p2 = new Point3d();
        Point3d p3 = new Point3d();
        Point3d q1 = new Point3d();
        Point3d q2 = new Point3d();
        Point3d q3 = new Point3d();
        
        if(g.getVertexCount()%3 != 0)
        {
        	System.err.println("addAllEdges(): shape3D with vertices not a multiple of 3!");
        }
        if(g != null)
        {
            for(int i = 0; i < g.getVertexCount(); i+=3) 
            {
                g.getCoordinate(i, p1);
                g.getCoordinate(i+1, p2);
                g.getCoordinate(i+2, p3);
                trans.transform(p1, q1);
                trans.transform(p2, q2);
                trans.transform(p3, q3);
                addEdge(q1, q2, q3, z, att, edges);
            }
        }
    }
	
	/**
	 * Unpack the Shape3D(s) from value and set edges from them
	 * @param value
	 * @param trans
	 * @param z
	 */
	private void recursiveSetEdges(Object value, Transform3D trans, double z, Attributes att, ArrayList<LineSegment> edges[]) 
    {
        if(value instanceof SceneGraphObject) 
        {
            SceneGraphObject sg = (SceneGraphObject)value;
            if(sg instanceof Group) 
            {
                Group g = (Group)sg;
                java.util.Enumeration<?> enumKids = g.getAllChildren( );
                while(enumKids.hasMoreElements())
                    recursiveSetEdges(enumKids.nextElement(), trans, z, att, edges);
            } else if (sg instanceof Shape3D) 
            {
                addAllEdges((Shape3D)sg, trans, z, att, edges);
            }
        }
    }

}
