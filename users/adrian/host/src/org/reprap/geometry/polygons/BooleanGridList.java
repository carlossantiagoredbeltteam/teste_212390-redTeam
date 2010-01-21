package org.reprap.geometry.polygons;

import java.util.ArrayList;
import java.util.List;
import org.reprap.Attributes;
import org.reprap.Extruder;
import org.reprap.Preferences;
import org.reprap.geometry.LayerRules;
import org.reprap.utilities.Debug;

/**
 * Class to hold a list of BooleanGrids with associated atributes for each
 * @author ensab
 *
 */

public class BooleanGridList 
{

		private List<BooleanGrid> shapes = null;
		
		protected void finalize() throws Throwable
		{
			shapes = null;
			super.finalize();
		}
		
		public BooleanGridList()
		{
			shapes = new ArrayList<BooleanGrid>();
		}
		
		/**
		 * Return the ith shape
		 * @param i
		 * @return
		 */
		public BooleanGrid get(int i)
		{
			return shapes.get(i);
		}
		
		/**
		 * Return the ith attribute
		 * @param i
		 * @return
		 */
		public Attributes attribute(int i)
		{
			return shapes.get(i).attribute();
		}
		
		/**
		 * How many shapes are there in the list?
		 * @return
		 */
		public int size()
		{
			return shapes.size();
		}
		
		/**
		 * Remove an entry and close the gap
		 * @param i
		 */
		public void remove(int i)
		{
			shapes.remove(i);
		}

		
		/**
		 * Add a shape on the end
		 * @param p
		 */
		public void add(BooleanGrid b)
		{
			if(b == null)
				Debug.e("BooleanGridList.add(): attempt to add null BooleanGrid.");
			shapes.add(b);
		}
		
		/**
		 * Add another list of shapes on the end
		 * @param a
		 */
		public void add(BooleanGridList aa)
		{
			for(int i = 0; i < aa.size(); i++)
					add(aa.get(i));

		}
		
		public BooleanGridList offset(LayerRules lc, boolean outline)
		{
			boolean foundation = lc.getLayingSupport();
			if(outline && foundation)
				Debug.e("Offsetting a foundation outline!");
			
			BooleanGridList result = new BooleanGridList();
			for(int i = 0; i < size(); i++)
			{
				Attributes att = attribute(i);
				if(att == null)
					Debug.e("BooleanGridList.offset(): null attribute!");
				else
				{
					Extruder [] es = lc.getPrinter().getExtruders();
					Extruder e;
					int shells;
					if(foundation)
					{
						e = es[0];  // By convention extruder 0 builds the foundation
						shells = 1;
					} else
					{
						e = att.getExtruder();
						shells = e.getShells();					
					}
					if(outline)
					{
						for(int shell = 0; shell < shells; shell++)
								result.add(get(i).offset(-((double)shell + 0.5)*e.getExtrusionSize()));
					} else
					{
						// Must be a hatch.  Only do it if the gap is +ve or we're building the foundation
						double offSize;
						int ei = e.getInfillExtruder();
						Extruder ife = e;
						if(ei >= 0)
							ife = es[ei];
						if(foundation)
							offSize = 3;
						else
							offSize = -((double)shells + 0.5)*e.getExtrusionSize() + ife.getInfillOverlap();
						if (e.getExtrusionInfillWidth() > 0 || foundation)  // Z valuesn't mattere here
								result.add(get(i).offset(offSize));
					}
				}
			}
			return result;			
		}
		
		/**
		 * Work out all the polygons forming a set of borders
		 * @return
		 */
		public RrPolygonList borders()
		{
			RrPolygonList result = new RrPolygonList();
			for(int i = 0; i < size(); i++)
				result.add(get(i).allPerimiters(attribute(i))); 
			return result;
		}
		
		/**
		 * Work out all the open polygond forming a set of infill hatches.  If surface
		 * is true, these polygone are on the outside (top or bottom).  If it's false
		 * they are in the interior.
		 * @param layerConditions
		 * @param surface
		 * @return
		 */
		public RrPolygonList hatch(LayerRules layerConditions, boolean surface)
		{
			RrPolygonList result = new RrPolygonList();
			boolean foundation = layerConditions.getLayingSupport();
			Extruder [] es = layerConditions.getPrinter().getExtruders();
			for(int i = 0; i < size(); i++)
			{
				Extruder e;
				Attributes att = attribute(i);
				if(foundation)
					e = es[0]; // Extruder 0 is used for foundations
				else
					e = att.getExtruder();
				if(!surface)
				{
					int ei = e.getInfillExtruder();
					if(ei >= 0)
					{
						e = es[ei];
						att = new Attributes(e.getMaterial(), null, null, e.getAppearance());
					}
				}
				result.add(get(i).hatch(layerConditions.getHatchDirection(e), layerConditions.getHatchWidth(e), att)); 
			}	
			return result;
		}
		
		/**
		 * Make a list with a single entry: the union of all the entries.
		 * Set its attributes to that of extruder 0 in the extruder list.
		 * @param a
		 * @return
		 */
		public BooleanGridList union(Extruder[] es)
		{	
			BooleanGridList result = new BooleanGridList();
//			if(size() <= 0)
//				return result;
//			
//			BooleanGrid contents = get(0);
//			
//			Attributes att = attribute(0);
//			Boolean foundAttribute0 = false;
//			if(att.getExtruder() == es[0])
//				foundAttribute0 = true;
//			for(int i = 1; i < size(); i++)
//			{
//				if(!foundAttribute0)
//				{
//					if(attribute(i).getExtruder() == es[0])
//					{
//						att = attribute(i);
//						foundAttribute0 = true;
//					}
//				}
//				contents = BooleanGrid.union(contents, get(i));
//			}
//			if(!foundAttribute0)
//				Debug.e("RrCSGPolygonList.union(): Attribute of extruder 0 not found.");
//			result.add(contents);
			return result;
		}
		
		/**
		 * Return a list of intersections between the entries in a and b.
		 * Only pairs with the same extruder are intersected.  If an element
		 * of a has no corresponding element in b, then no entry is returned
		 * for that.
		 * @param a
		 * @param b
		 * @return
		 */
		private static BooleanGridList intersections(BooleanGridList a, BooleanGridList b)
		{
			BooleanGridList result = new BooleanGridList();
			for(int i = 0; i < a.size(); i++)
			{
				BooleanGrid abg = a.get(i);
				for(int j = 0; j < b.size(); j++)
				{
					if(abg.attribute().getExtruder() == b.attribute(j).getExtruder());
					{
						result.add(BooleanGrid.intersection(abg, b.get(j)));	
						break;
					}
				}
			}
			return result;
		}
		
		
		/**
		 * Return a list of differences between the entries in a and b.
		 * Only pairs with the same attribute are intersected.  If an element
		 * of a has no corresponding element in b, then an entry equal to a is returned
		 * for that.
		 * @param a
		 * @param b
		 * @return
		 */
		private static BooleanGridList differences(BooleanGridList a, BooleanGridList b)
		{
			BooleanGridList result = new BooleanGridList();
			for(int i = 0; i < a.size(); i++)
			{
				BooleanGrid abg = a.get(i);
				boolean untouched = true;
				for(int j = 0; j < b.size(); j++)
				{
					if(abg.attribute().getExtruder() == b.attribute(j).getExtruder());
					{
						result.add(BooleanGrid.difference(abg, b.get(j)));
						untouched = false;
						break;
					}
				}
				if(untouched)
					result.add(abg);
					
			}
			return result;
		}
		
		/**
		 * Compute the infill hatching polygons for this set of patterns
		 * @param layerConditions
		 * @return
		 */
		public RrPolygonList computeInfill(LayerRules layerConditions, BooleanGridList previousSlice)
		{
			BooleanGridList outsides = this;
			BooleanGridList insides = null;
			
			if(previousSlice != null && layerConditions.getModelLayer() > 1)
			{
				outsides = differences(this, previousSlice);
				insides = intersections(this, previousSlice);
			}
				
			outsides = outsides.offset(layerConditions, false);
			
			if(insides != null)
				insides = insides.offset(layerConditions, false);
			
			RrPolygonList hatchedPolygons = outsides.hatch(layerConditions, true);
			
//			if(layerConditions.getLayingSupport())
//				offHatch = offHatch.union(layerConditions.getPrinter().getExtruders());
				
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
		public RrPolygonList computeOutlines(LayerRules layerConditions, RrPolygonList hatchedPolygons, boolean shield)
		{
			
			RrPolygonList borderPolygons;
			
			if(layerConditions.getLayingSupport())
			{
				borderPolygons = null;
			} else
			{
				BooleanGridList offBorder = offset(layerConditions, true);
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

}
