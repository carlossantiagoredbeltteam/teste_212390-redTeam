package org.reprap.gui;

import java.util.List;
import java.util.ArrayList;
import org.reprap.geometry.polygons.*;
import org.reprap.Attributes;
import org.reprap.Extruder;
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

public class AllSTLsToBuild 
{	
	private List<STLObject> stls;
	private STLSlice slice;
	private RrRectangle XYbox;
	private RrInterval Zrange;
	
	public AllSTLsToBuild()
	{
		stls = new ArrayList<STLObject>();
		slice = null;
		XYbox = null;
		Zrange = null;
	}
	
	public void add(STLObject s)
	{
		stls.add(s);
	}
	
	public STLObject get(int i)
	{
		return stls.get(i);
	}
	
	public void remove(int i)
	{
		stls.remove(i);
	}
	
	public int size()
	{
		return stls.size();
	}
	
	//TODO: delete this function...
	public List<STLObject> things()
	{
		return stls;
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
	
	public RrRectangle ObjectPlanRectangle()
	{
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
	
	public double maxZ()
	{
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
	
	public BooleanGridList slice(double z, Extruder[] extruders)
	{
		if(slice == null)
			slice = new STLSlice(stls);
		return slice.slice(z, extruders);	
	}
	
	public void destroyLayer() {}

}
