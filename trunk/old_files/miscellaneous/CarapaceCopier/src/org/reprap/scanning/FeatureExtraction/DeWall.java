package org.reprap.scanning.FeatureExtraction;


/******************************************************************************
* This program is free software; you can redistribute it and/or modify it under
* the terms of the GNU General Public License as published by the Free Software
* Foundation; either version 3 of the License, or (at your option) any later version.
* 
* This program is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
* details.
* 
* The license can be found on the WWW at: http://www.fsf.org/copyleft/gpl.html
* 
* Or by writing to: Free Software Foundation, Inc., 59 Temple Place - Suite
* 330, Boston, MA 02111-1307, USA.
*  
* 
* If you make changes you think others would like, please contact one of the
* authors or someone at the reprap.org web site.
* 
* 				Author list
* 				===========
* 
* Reece Arnott	reece.arnott@gmail.com
* 
* Last modified by Reece Arnott 2nd August 2010
* 
* Note that this breaks down if the first simplex made is made from 4 points in a plane or there are 5 points that are co-circular including the initial point so when this is called
* from the Main class the original simplex seed point is chosen as the midpoint in the array first by ordering the list based on x values, then if that doesn't work, by y and finally z. 
*
* This class is originally an implementation of the DeWall version of the recursive Delauney Divide and Conquer algorithm based on the paper http://dx.doi.org/10.1016/S0010-4485(97)00082-1
* "DeWall: A fast divide and conquer Delaunay triangulation algorithm in E^d" Computer-Aided Design Volume 30, Issue 5, April 1998, Pages 333-341 by P Cignoni and C Montani and R Scopigno
* It takes as input an array of 3d points and outputs an array of tetrahedrons.
*
* This is a restricted implementation in that it creates an array of tetrahedrons, not an array of (d-1)-faces as the general form would.
* This is only due to the fact that we are using Point3d objects as the underlying objects and the MakeSimplex method takes a triangular face and creates a tetrahedron rather than the generalised case as in the paper.
*
*  The current implementation of the dewall method uses an ordered list data structure that contains TriangularFaces which have a,b,c and optionally a d1 and d2 which are the fourth points for the 2 possible tetrahedrons.
*  This is a holdover from an older version where tetrahedrons were explicitly linked to 0,1, or 2 triangular faces.
*  
*   This is a recursive "Divide and Conquer" Strategy where the a "wall" is built of tetrahedron faces that straddle a wall based on the midpoint of the x,y, or z values of the points passed to the array.
*   Others lists are built of the faces of ajoining tetrahedra and put into one of two different arrays depending on which side of the wall the point is on. Once the wall is fully processed the two half sets of points + list of faces to be processed are recursively called
*   with the split plane cycling through the x,y, and z planes as the recursion deepens.
*   
*   There is occasional mis-categorisation of faces due to rounding errors in the calculation of the wall coordinate which leads to cyclic tetrahedron creation. When this is detected the process is terminated.
*   The calling code in the Main class simply starts again with a different dividing plane, or, if all else fails, implements a sequential running of the method by setting the recursive variable to false when calling the Triangularisation method
*   
*  The List fed to the dewall method is called AFL (from the original Active Face List) and in the sequential method method, rather than having its contents divided into AFLalpha, AFL1, and AFL2, the whole list is processed and new elements added to AFLalpha.
*  This is done by having the categorise method always return 0 when the recursionlevel reaches the value of maxrecurse. If the number of points to be processed (length of P fed to the method) is less than the minimum value the recursion level is set to this maximum
*  Otherwise it is set to one more than the parent calling method passed to it.  
*   
*  TODO - This class may benefit from using  unconstrained ArrayList rather than fixed length array.
*
************************************************************************************/

import javax.swing.JProgressBar;

import org.reprap.scanning.DataStructures.QuickSortPoints3D;
import org.reprap.scanning.DataStructures.Uniform3DGrid;
import org.reprap.scanning.DataStructures.OrderedListTriangularFace;
import org.reprap.scanning.Geometry.AxisAlignedBoundingBox;
import org.reprap.scanning.Geometry.Line3d;
import org.reprap.scanning.Geometry.Plane;
import org.reprap.scanning.Geometry.Point3d;
import org.reprap.scanning.Geometry.TriangularFace;
public class DeWall {
	
	public enum planeslice {x,y,z};
	public enum searching {oneradius,tworadii,currentminimumradius,all,exit}; // just for readability in the MakeSimplex method
	// These just for testing
	public static boolean printverbose=false;
	public static boolean print=false;
	public static boolean test=false;
	
	public int maxrecurse=21; // Once the maximum recursion level is reached the recursion stops and the algorithm reverts to a sequential form by having the Categorise method always returning 0. Given that is assumed a maximum of 2^21 points will be used (due to the way the TriangularFace hashvalue is calculated) it doesn't make sense to set a recursion level greater than 21.  
	public int minpoints=100; // If the number of points to be processed by DeWall is less than this, recursion stops by having the recursionlevel set to maxrecurse
	// Max recurse is not currently set outside of this class but is there for completeness. Just in case it does make sense to set it.
	
	public final double UGScale=1; // This scale factor is multiplied by the number of points to give the minimum number of cells the Uniform grid is created with
	private Point3d[] PointsList; // This is the list of points we are operating on. To limit the problem of trying to compare equality of floating point numbers the points will simply be referred to by their index in this array most of the time
	// These are just used so we can update the progress bar
	private int[] count;
	private boolean[] finished;
	
	private boolean CyclicTetrahedronCreation=false; // Is there a cyclic tetrahedron creation? Once it is detected the algorithm will cease.
	private TriangularFace[] Tetrahedrons; // The final list of tetrahedrons returned 
	
	private QuickSortPoints3D qsort; // Used to sort the PointsList
	
	
	// Constructor
	public DeWall(Point3d[] points){
		Tetrahedrons=new TriangularFace[0];
		PointsList=new Point3d[points.length];
		count=new int[points.length];
		finished=new boolean[points.length];
		for (int i=0;i<points.length;i++){
			PointsList[i]=points[i].clone();
			count[i]=0;
			finished[i]=false;
		}
	}
	
	// This method does some setting up and then calls the private DeWall method to carve the space around the points into tetrahedrons 
	public TriangularFace[] Triangularisation(JProgressBar bar, boolean recursive,String initialplane){
		//  set the progress bar min and max
		  bar.setMaximum(PointsList.length);
		  bar.setMinimum(0);
		  bar.setValue(bar.getMinimum());
		long starttime=System.currentTimeMillis();
		// Use this sorted list to build up a triangle list using DeWall divide and conquer
		qsort=new QuickSortPoints3D(PointsList);
		// Create the indexarray
		int[] indexarray=new int[PointsList.length];
		for (int i=0;i<indexarray.length;i++) indexarray[i]=i;
		CyclicTetrahedronCreation=false;
		int initialrecursionlevel=0;
		if (!recursive) initialrecursionlevel=maxrecurse;// Call to Sequential version of Dewall by setting the inital recursion level to the maximum 
			dewall(indexarray, new OrderedListTriangularFace(PointsList.length),planeslice.valueOf(initialplane), bar,System.currentTimeMillis(),initialrecursionlevel);
		bar.setValue(bar.getMaximum());
		if (print){
			 System.out.println("Total time:"+(System.currentTimeMillis()-starttime)+"ms  Total Tetrahedrons="+Tetrahedrons.length);
		 }
		if (printverbose){
			for (int i=0;i<Tetrahedrons.length;i++){
				System.out.print(i);
				Tetrahedrons[i].print();
				System.out.println();
			} // end for
		} // end if printverbose
		
		
		
		if ((test) && (!CyclicTetrahedronCreation)){
			
			// Tests hopefully ordered quickest first
			// Currently a selection of random points seem to be carved correctly and pass all the tests.
			TestPointInclusion(Tetrahedrons);
			TestEmptyTetrahedrons(Tetrahedrons);
			TestDelaunayspacing(Tetrahedrons);
			TestTrianglesMembersOfMax2Tetrahedrons(Tetrahedrons);
			TestInterpenetrationofTetrahedronFaces(Tetrahedrons);
			System.out.println("Testing done");
		}
		return Tetrahedrons;
	}
	public boolean IsCyclicTetrahedronCreationError(){
		return CyclicTetrahedronCreation;
	}
		
	
	/***********************************************************************************************************************************
	 * 
	 *  Private methods
	 * 
	 ***********************************************************************************************************************************/
	
	private void dewall(int[] P, OrderedListTriangularFace AFL, planeslice currentplaneslice,JProgressBar bar, long lastprogressupdate,int recursionlevel){
		recursionlevel++;
		if (P.length<minpoints) recursionlevel=maxrecurse; 
		//Initialise the arrays we'll be using to be empty and calculate a splitting plane for the point array P
		OrderedListTriangularFace AFLalpha=new OrderedListTriangularFace(PointsList.length);
		OrderedListTriangularFace AFL1=new OrderedListTriangularFace(PointsList.length);
		OrderedListTriangularFace AFL2=new OrderedListTriangularFace(PointsList.length);
		// Set up the Uniform Grid
		Uniform3DGrid UG=new Uniform3DGrid(PointsList, P, (int)(UGScale*P.length));
		// Sort the list based on the direction of the currentplaneslice 
		P=qsort.Sortby(currentplaneslice.toString().charAt(0),P);
			
		// Partition the point array P into two other point arrays based on the splitting plane
		// Note that in the case where there is an odd number of elements the right hand array (P2) will be one larger than the left (P1)
		// Because of the way the rest of this works there shouldn't be only a couple of elements in the array so don't need to test for midpoint-1<0
		int midpoint=(int)Math.floor((double)P.length/2);
		// Set the dividing value
		//Note that we assume here that this method will not get called with 0 or 1 elements in P
		double splitplanecoordinate=(Coordinate(currentplaneslice,P[midpoint-1])+Coordinate(currentplaneslice,P[midpoint]))/2;
		// As the array is ordered the way we want we can use the midpoint index to divide the array
		// P1 from index 0 to midpoint
		// P2 is from midpoint to the end (including the midpoint)
		int[] P1=new int[midpoint];
		int[] P2=new int [P.length-midpoint];
		for (int i=0;i<P.length;i++){
			if (i<midpoint) P1[i]=P[i];
			else P2[i-midpoint]=P[i];
		} // end for
		
	//  Wall Construction 
	if ((AFL.getLength()==0) && (recursionlevel==1)){
		// Make the first simplex using as one point the closest point to the midpoint split, and as another a point on the other side.
			TriangularFace t=MakeFirstSimplex(P);
			if (!t.IsNull()) {
				t.SetHash(PointsList.length);
				TriangularFace[] temp=t.GetFaces(PointsList);
				for (int i=0;i<temp.length;i++) {
					if (i==0){ // Reverse the first face a and b so a normal calculated from ABxAC is pointing outwards
						int[] v=temp[i].GetFirstTetrahedron();
						t=new TriangularFace(v[1],v[0],v[2],v[3],PointsList);
						AFL.InsertIfNotExist(t);
					}
					AFL.InsertIfNotExist(temp[i]);
				}
				Tetrahedrons=new TriangularFace[1];
				Tetrahedrons[0]=t.clone();
				// Increment the counters for each of these four points by 3.
					int[] indexes=t.GetFirstTetrahedron();
					for (int i=0;i<indexes.length;i++)
						for (int j=0;j<3;j++) increment(indexes[i]);
				
			}
		}
		// Split the Active Face List into the correct sub lists
		TriangularFace f=AFL.GetFirstFIFO();
		while (!f.IsNull()){
			int category=Categorise(f,splitplanecoordinate,currentplaneslice,recursionlevel);
			switch(category){
				case 0:AFLalpha.InsertIfNotExist(f);break;
				case 1:AFL1.InsertIfNotExist(f);break;
				case 2:AFL2.InsertIfNotExist(f);break;
			}
		f=AFL.GetNextFIFO();
		}
		
		
		
//		 Main loop
		f=AFLalpha.ExtractFIFO();
		while (!f.IsNull()){
			if (printverbose){
				//System.out.println("AFL1="); AFL1.PrintFIFO();
				//System.out.println("AFL2=");AFL2.PrintFIFO();
				System.out.println("AFLalpha=");AFLalpha.PrintFIFO();
				//System.out.println("sum="); for (int i=0;i<sum.length;i++){sum[i].print();System.out.println();}
				//UG.Print();
			}
			 
			TriangularFace t=new TriangularFace();
				t=MakeSimplex(f,UG);
					// Test to make sure the tetrahedron constructed is a valid one
					// i.e. that none of the faces are made from triangles that have already been tested for inclusion in two tetrahedrons. 
					boolean valid=!t.IsNull();
					if (valid)
					{
						//int[] ind=t.GetFirstTetrahedron();
						//System.out.println(ind[0]+ind[1]+ind[2]+ind[3]+" "+ind[0]+" "+ind[1]+" "+ind[2]+" "+ind[3]);
						//System.out.println(ind[0]+" "+ind[1]+" "+ind[2]+" "+ind[3]);
						Tetrahedrons=Insert(Tetrahedrons,t); // Note that this will mean we end up with a list of TriangularFaces each attached to a single tetrahedron only.
						TriangularFace[] fdash=t.GetFaces(PointsList);
								for (int i=0;i<fdash.length;i++){
								if (!fdash[i].TriangleEqual(f)){
									// Update the correct Active Face list
									int category=Categorise(fdash[i],splitplanecoordinate,currentplaneslice,recursionlevel);
									switch(category){
										case 0:AFLalpha=Update(AFLalpha,fdash[i]);break;
										case 1:AFL1=Update(AFL1,fdash[i]);break;
										case 2:AFL2=Update(AFL2,fdash[i]);break;
									}
								} // end if
							} // end for
							//	 DecimalFormat format = new DecimalFormat("0.000000");
							//	System.out.println(" "+format.format(splitplanecoordinate));
						
					} // end if valid
			// Once every second update the progress bar and tidy up the lists
			if ((System.currentTimeMillis()-lastprogressupdate)>1000) {
				AFLalpha.DeleteExtractedFIFOOrder();
				int value=0;
				for (int i=0;i<finished.length;i++) if (finished[i]) value++;
				bar.setValue(value);
				lastprogressupdate=System.currentTimeMillis();
				}
			f=AFLalpha.ExtractFIFO();
			if (CyclicTetrahedronCreation){
				f=new TriangularFace(); // exit while loop
			}
		}//end while
		
		
//		 recurse and change the orientation of the plane slice
		planeslice nextplaneslice=planeslice.values()[(currentplaneslice.ordinal()+1)%planeslice.values().length];
		// Only recurse if need to i.e. there is at least one face in the Active face list that needs processed and a cyclic tetrahedron creation hasn't been flagged.
		if ((!CyclicTetrahedronCreation) && (AFL1.getLength()!=0)) dewall(P1,AFL1,nextplaneslice,bar, lastprogressupdate,recursionlevel);
		if ((!CyclicTetrahedronCreation) && (AFL2.getLength()!=0)) dewall(P2,AFL2,nextplaneslice,bar,lastprogressupdate,recursionlevel);
	} // end of method dewall (recursive)
	
//	 returns 0 if the slice-plane intersects the face and is to go into AFLalpha
	// returns 1 if the plane is on one side of the face (to go into AFL1)
	// returns 2 if the plane is on the other side of the face (to go into AFL2)
	// If the maximum recursion level has been reached it will also return 0 which essentially turns it into an iterative approach
	private int Categorise(TriangularFace f,double coordinate,planeslice currentplaneslice,int recursionlevel){
		if (recursionlevel>=maxrecurse) return 0; 
		else{		
			int[] indexes=f.GetFace();
			double a,b,c;
			a=Coordinate(currentplaneslice,indexes[0]);
			b=Coordinate(currentplaneslice,indexes[1]);
			c=Coordinate(currentplaneslice,indexes[2]);
			
			boolean v1,v2,v3;
			v1=(a<coordinate);
			v2=(b<coordinate);
			if (v1!=v2) return 0;
			else{
				v3=(c<coordinate);
				if (v1!=v3) {return 0;}
				else {
					if (v1) return 1;
					else return 2;
					}
			} // end else
		}
	} // end Categorise
	
	private double Coordinate(planeslice currentplaneslice,int index){
		double returnvalue=0;
		switch(currentplaneslice) {
		case x: returnvalue=PointsList[index].x;break;
		case z: returnvalue=PointsList[index].z;break;
		case y: returnvalue=PointsList[index].y;break;
		}
		return returnvalue;
	}
	
	// Manipulation of triangular faces arrays used above for compiling sum TriangularFace array
	private TriangularFace[] Insert(TriangularFace[] original, TriangularFace addition){
		addition.SetHash(PointsList.length);
		TriangularFace[] returnvalue=new TriangularFace[original.length+1];
		for (int i=0;i<original.length;i++){
			returnvalue[i]=original[i].clone();
			if (original[i].IncludesFirstTetrahedroninTetrahedron(addition)) CyclicTetrahedronCreation=true;
		}
		returnvalue[original.length]=addition.clone();
		return returnvalue;
	}
	// Only used by the original algorithm
	// Delete the face from the list if it exists and add it if it does not
	// Also increment or decrement the point counters accordingly
	private OrderedListTriangularFace Update(OrderedListTriangularFace AFL, TriangularFace f){
		boolean deleted=AFL.DeleteIfExist(f);
		if (!deleted) AFL.InsertIfNotExist(f);
		int[] indexes=f.GetFace();
		for (int i=0;i<indexes.length;i++)
			if (deleted) decrement(indexes[i]);
			else increment(indexes[i]);
		return AFL;
	}

	// Used to increment and decrement the point counters and set the finished variable
	private void increment(int i){count[i]++;finished[i]=false;}
	private void decrement(int i){if (!finished[i]) count[i]--; if (count[i]==0) finished[i]=true;}
	
	// Note that this doesn't take account of any points that are to be skipped, it is assumed that it is only called at the start of the procedure when all points are valid.
	// It is also assumed that the P index array is ordered corectly.
	private TriangularFace MakeFirstSimplex(int[] P){
		
		TriangularFace returnvalue=new TriangularFace();
		int midpoint=(int)Math.floor((double)P.length/2);
		
		  int a=P[midpoint-1];
			int b=-1;
			double mindistancesquared=Double.MAX_VALUE;
			for (int i=midpoint;i<P.length;i++){
				double distancesquared=(PointsList[a].minus(PointsList[P[i]])).lengthSquared();
					if (distancesquared<mindistancesquared) {
						b=P[i];
						mindistancesquared=distancesquared;
				}
			}
			if (b!=-1){
				// Now find the third point from the array that means the circumcircle has the smallest radius
				
				// The centre of a circumcircle in 2d can be found as the intersection point of lines that bisect neighbouring edges at right angles
				// In 3d these lines can be extended to be planes that include the mid-point of the line and have the vector of the line as their normal.
				// We then intersect these two planes with the third made by the triangle itself to find the centre point
				// Note that the intersection of the two mid-planes gives us a line which by definition passes through the circum-centre and has a vector of the normal of the triangle plane.
				// We can use this line to simplify finding the circumsphere centre with 4 points as we just find the intersection of this line with the mid-plane of the line segment between one of the existing points and the new fourth point.
				
				//Find the middle plane of the two points we currently have
				Line3d AB=new Line3d(PointsList[a],PointsList[b]);
				Plane p1=new Plane(AB);
				double minradiussquared=Double.MAX_VALUE;
				int c=-1;
				Point3d mincentre=new Point3d();
				for (int i=0;i<P.length;i++){
					if ((a!=P[i]) && (b!=P[i])){
						// Calculate the centre of the circumcircle using this point and from this calculate the radiussquared
						Line3d AC=new Line3d(PointsList[a],PointsList[P[i]]);
						Plane p2=new Plane(AC);
						Plane p3=new Plane(PointsList[a],PointsList[b],PointsList[P[i]]);
						
						if (p3.Intersect(p1,p2)){
							Point3d centre=p3.IntersectionPoint(p1,p2);
							double radiussquared=PointsList[a].minus(centre).lengthSquared();
							if (radiussquared<minradiussquared){
								minradiussquared=radiussquared;
								c=P[i];
								mincentre=centre.clone();
								} // end if
							if (printverbose) System.out.println("checking points "+a+" "+b+" "+P[i]+" radiussquared="+radiussquared+" radii="+Math.sqrt(PointsList[a].minus(centre).lengthSquared())+" "+Math.sqrt(PointsList[b].minus(centre).lengthSquared())+" "+Math.sqrt(PointsList[P[i]].minus(centre).lengthSquared()));
							
						} // end if
					} // end if
				} // end for
				if (c!=-1){
					// here starts substantially similar code to the core of the MakeSimplex method but for all points
					  // Set up the centre-line we will need
					  Plane p3=new Plane(PointsList[a],PointsList[b],PointsList[c]);
					  Line3d centreline=new Line3d();
					  centreline.resetPandV(mincentre,p3.getNormal());
					// Now go through the array and find the fourth point that gives the smallest dd value
					double currentmindd=Double.MAX_VALUE;
					int d=-1;
					returnvalue=new TriangularFace(a,b,c);
					returnvalue.CalculateNormal(PointsList);
					for(int i=0;i<P.length;i++){
						boolean valid=((a!=P[i]) && (b!=P[i]) && (c!=P[i]));
						if (valid){
							Plane ABC=new Plane(PointsList[a],PointsList[b],PointsList[c]);
							valid=ABC.getNormal().dot(PointsList[P[i]])!=ABC.normaldotP;// Check the point is not on the ABC plane
						}
						
						if (valid) {
							// Find the mid plane between the candidate point and vertex A
							Line3d AD=new Line3d(PointsList[a],PointsList[P[i]]);
							Plane p4=new Plane(AD);
							// Now find the intersection between this plane and the centre line
							if (p4.Intersect(centreline)){
								Point3d centre=p4.IntersectionPoint(centreline);
								double radiussquared=PointsList[P[i]].minus(centre).lengthSquared();
								
								// Check if the centre is on the same side of the plane made by the points A,B,C as point D.
				            	// If we can assume neither the centre nor the fourth point are on the plane this can be restated as the following boolean test:
				            	boolean sameside=(returnvalue.InsideHalfspace(PointsList[P[i]])==returnvalue.InsideHalfspace(centre));
				            	double dd=radiussquared;
				            	if (!sameside) dd=dd*-1;
				            	if (dd==currentmindd){
											System.out.println("Error: 5 cocircular points for the first simplex. Can't continue");
											d=-1;
											currentmindd=0;
								}
								if (dd<currentmindd){
									currentmindd=dd;
									d=P[i];
								}
							} // end if intersect centre line
					} // end if !skiptesting
				} // end for
				// If there wasn't a 4th point we drop the whole thing
				if (d==-1) returnvalue=new TriangularFace();
				else {
					// Find out whether point d is on the same side of the mid plane between a and b as point b and if it isn't swap point a and b around.
					// So the normals calculated by ABxAC on all but the first face will point outwards. Note that this means that for the first face to have a normal pointing outwards a and b will have to be swapped around once the face list has been extracted.
					if (p1.GetHalfspace(PointsList[d])!=p1.GetHalfspace(PointsList[b])) returnvalue=new TriangularFace(b,a,c);
					returnvalue.SetFirstTetrahedronPointD(d,PointsList);
				}
				} // end if c!=-1
			} // end if b!=-1
	return returnvalue;
	} // end of MakeFirstSimplex method

	private TriangularFace MakeSimplex(TriangularFace f,Uniform3DGrid UG){
		TriangularFace returnvalue;
		int currentnextpointindex=-1;
		int[] abc=f.GetFace();
		decrement(abc[0]);
		decrement(abc[1]);
		decrement(abc[2]);
		  	// The centre of a circumcircle in 2d can be found as the intersection point of lines that bisect neighbouring edges at right angles
			// In 3d these lines can be extended to be planes that include the mid-point of the line and have the vector of the line as their normal.
			// We then intersect these two planes with the third made by the triangle itself to find the centre point
			// Note that the intersection of the two mid-planes gives us a line which by definition passes through the circum-centre and has a vector of the normal of the triangle plane.
			// We can use this line to simplify finding the circumsphere centre with 4 points as we just find the intersection of this line with the mid-plane of the line segment between one of the existing points and the new fourth point.
			
		  
		  // Find this line of circumsphere centres
		  	Line3d AB=new Line3d(PointsList[abc[0]],PointsList[abc[1]]);
			Plane p1=new Plane(AB);
			Line3d AC=new Line3d(PointsList[abc[0]],PointsList[abc[2]]);
			Plane p2=new Plane(AC);
			Plane p3=new Plane(PointsList[abc[0]],PointsList[abc[1]],PointsList[abc[2]]);
			if (p3.Intersect(p1,p2)){
				Point3d p=p3.IntersectionPoint(p1,p2);
				Point3d v=f.normal.clone(); // Note that the normal is assumed to be oriented in the correct direction
				Line3d centreline=new Line3d();
				centreline.resetPandV(p,v);
				double circumradius=Math.sqrt((p.minus(PointsList[abc[0]])).lengthSquared());
				// Now go through points and find the fourth point that gives the smallest dd value
				// Go through the Uniform grid, first taking just the points in a sphere with the same center and radius of the circumcircle. 
				// then go out to have a bounding box with the center 2*circumradii along the centerline
				// If a point is found but has a circumsphere radius greater than the bounding box radius, test all points within that radius to be sure it is the correct one.
				// Finally, if no points have been found, test all points in the grid
				//The enum searching is defined at the top of the class as {oneradius,tworadii,currentminimumradius,all,exit}
				double currentmindd=Double.MAX_VALUE;
				searching state=searching.valueOf("oneradius");
				UG.resetMarked();
				while (state!=searching.valueOf("exit")){
					AxisAlignedBoundingBox box=new AxisAlignedBoundingBox();
					
					switch(state) {
					case oneradius:
						box=UG.GetBoundingBox(centreline.P,circumradius); // get the single cells that are within a circumsphere with the same centre and radius as the circumcircle
						break;
					case tworadii:
						// Find the point along the centerline (using Pytagoras) that makes a right angle triangle with the hypotenuse which is a multiple of the length of the circumcircle radius, one point the circumcircle centre, one point A.
						// hypotenuse^2=circumcircleradius^2+t^2 so t^2=n^2*circumradius^2-circumradius^2=(n^2-1)*circumradius^2, t= Math.sqrt(n^2-1)*circumradius
						// if we make things easy so we don't need to take square roots when working out hypotenuse and set n=2, we can simply set the t=sqrt(3)*circumradius
						double t=Math.sqrt(3)*circumradius;
						// This t is then the distance along the centerline ray so if the line vector is normalised (as it comes from the normal it is) this is simply l.P+t*V
						Point3d center=centreline.GetPointonLine(t);
						// get the cells centred on the point center in a box that also contains the point A.
						box=UG.GetBoundingBox(center,2*circumradius);
						//System.out.println(" box="+box.minx+" "+box.miny+" "+box.minz+"-"+box.maxx+" "+box.maxy+" "+box.maxz);
						break;
					case currentminimumradius:
						double boxradiussquared=currentmindd; //set the box radius to be the current min radius
						// Find the point along the centerline (using Pytagoras) that makes a right angle triangle with the hypotenuse the length of the boxradius, one point the circumcircle centre, one point A.
						// boxradius^2=circumcircleradius^2+t^2 so t^2=boxradius^2-circumradius^2
						t=Math.sqrt(boxradiussquared-(circumradius*circumradius));
						// This t is then the distance along the centerline ray so if the line vector is normalised (as it comes from the normal it is) this is simply l.P+t*V
						center=centreline.GetPointonLine(t);
						// get the cells centred on the point center in a box that also contains the point A.
						box=UG.GetBoundingBox(center,Math.sqrt(boxradiussquared)); 
						//System.out.println(" box="+box.minx+" "+box.miny+" "+box.minz+"-"+box.maxx+" "+box.maxy+" "+box.maxz);
						break;
					case all:
						box.minx=0;
						box.miny=0;
						box.minz=0;
						box.maxx=UG.arraysizex-1;
						box.maxy=UG.arraysizey-1;
						box.maxz=UG.arraysizez-1;
						break;
					}
					
					if (printverbose) System.out.println(state.toString());
					
				for (int x=(int)box.minx;x<=(int)box.maxx;x++){
					for (int y=(int)box.miny;y<=(int)box.maxy;y++){
						for (int z=(int)box.minz;z<=(int)box.maxz;z++){
							if (UG.ExaminableCell(f,x,y,z)){
								int i=UG.GetFirst(x,y,z);
								while (i!=-1){
									boolean valid=((i!=abc[0]) && (i!=abc[1]) && (i!=abc[2])); // make sure it isn't one the vertices we already have
									if (valid) valid=(!f.InsideHalfspace(PointsList[i])); // it is in the correct halfspace
									if (valid) valid=f.normal.dot(PointsList[i])!=f.normaldota;// Check the point is not on the ABC plane
									if (valid){
									  	// calculate the mid-plane of the AD line segment
										Line3d AD=new Line3d(PointsList[abc[0]],PointsList[i]);
							            Plane p4=new Plane(AD);
							            // Now find the intersection between this plane and the centre line
							            if (p4.Intersect(centreline)){
							            	Point3d centre=p4.IntersectionPoint(centreline);
							            	double radiussquared=PointsList[i].minus(centre).lengthSquared();
							            	//Check if the centre is on the same side of the plane made by the points A,B,C as point D.
							            	// If we can assume neither the centre nor the fourth point are on the plane this can be restated as the following boolean test:
							            	boolean sameside=(f.InsideHalfspace(PointsList[i])==f.InsideHalfspace(centre));
							            	double dd=radiussquared;
							            	if (!sameside) dd=dd*-1;
							            	if (dd<currentmindd){
							            		currentmindd=dd;
							            		currentnextpointindex=i;
							            	}
							            	if (printverbose) System.out.println("checking points "+abc[0]+" "+abc[1]+" "+abc[2]+" "+i+" dd="+dd+" radii="+Math.sqrt(PointsList[abc[0]].minus(centre).lengthSquared())+" "+Math.sqrt(PointsList[abc[1]].minus(centre).lengthSquared())+" "+Math.sqrt(PointsList[abc[2]].minus(centre).lengthSquared())+" "+Math.sqrt(PointsList[i].minus(centre).lengthSquared()));//+" count for d="+PointsList[i].readCount()+" skip for d="+PointsList[i].readSkip());
							            } // end if intersect centre line
									} // end if i!=a,b,c
						            i=UG.GetNext(x,y,z);
								} // end while
								UG.CellExamined(x,y,z);
							} // end if ExaminableCell
						} // end for z
					} // end for y
				} // end for x
				if (printverbose) System.out.println("final contender="+currentnextpointindex);
            	// Choose the next state - this is only relevent if the current state is one or two radii. If the current state was all or current min radius then we're finished so set to exit.
				switch (state){
				case currentminimumradius:
				case all:	
					state=searching.valueOf("exit");
					break;
				
				case tworadii:
					// the currentmindd is magnitude of the square of the radius
					// If a candidate was found with dd is less than the box radius it is definately the correct one.
					// If a candidate was found with dd more than the box radius then it may be the correct one so expand the search area and make sure
					// If no candidate has been found, search all the cells.
					if (currentnextpointindex!=-1) {
						if (currentmindd>(4*circumradius*circumradius)) state=searching.valueOf("currentminimumradius"); // i.e. it may not be the best one so double check
						else state=searching.valueOf("exit"); // exit if the min radius is less than the box radius, it is by definition the best one;
					}
					else state=searching.valueOf("all");
					break;
				case oneradius:
					if (currentnextpointindex!=-1) {
						if (currentmindd>(circumradius*circumradius)) state=searching.valueOf("currentminimumradius"); // This may not be the correct one so double check
						else state=searching.valueOf("exit"); // We've found the one we want
					}
					else state=searching.valueOf("tworadii"); // No candidate was found so expand the search
					break;
				}
			} // end while
				
				
			} // end if p1,p2,p3 intersect
			// If there wasn't a 4th point or it is to be ignored we drop the whole thing
	
			if ((currentnextpointindex==-1)) 
					returnvalue=new TriangularFace();
			else{
				returnvalue=f.clone();
				returnvalue.SetFirstTetrahedronPointD(currentnextpointindex,PointsList); //overwrite the old d value
			} // end else
		return returnvalue;
	}
	
	/**********************************************************************************************************************************************
	 * 
	 * Here are the test methods. They are only called to test whether the the tetrahedron DeWall space carving is valid, in some cases using 
	 * different derivations of formulae used above.  
	 * 
	 **********************************************************************************************************************************************/
	
	

	private void TestInterpenetrationofTetrahedronFaces(TriangularFace[] tetrahedrons){
		// This is to be called once the points have been turned into tetrahedrons and is just used to test whether the result is valid
		// which in this case means that no faces are interpenetrating which is tested by checking the halfspaces of the 6 points involved
		System.out.println("Testing Overlaps and interpenetrations of triangular faces");
		//System.out.println("An overlap is where 1 triangular edge penetrates the face, and an interpenetration is where two edges penetrates the face");
		//System.out.println("There is also the case where all 3 edges of one triangle penetrate another triangle i.e. they are both on the same plane and overlap which is tested for as well");
		for (int i=0;i<tetrahedrons.length;i++){
			//Note that this assumes that each element in the array of triangular faces only has one tetrahedron attached to it!
			TriangularFace[] faces=tetrahedrons[i].GetFaces(PointsList);
			for (int j=0;j<faces.length;j++){
				// Calculate the plane made from this face
				int[] vertices=faces[j].GetFace();
				Plane plane1=new Plane(faces[j],PointsList);
				// For each tetrahedron 
				for (int k=0;k<tetrahedrons.length;k++)if (i!=k) {
						TriangularFace[] faces2=tetrahedrons[k].GetFaces(PointsList);
						// For each of its faces (that doesn't have any of the 3 current vertices...) create a representative plane
						for (int l=0;l<faces2.length;l++) if (!((faces2[l].IncludesPoint(vertices[0])) || (faces2[l].IncludesPoint(vertices[1])) || (faces2[l].IncludesPoint(vertices[2])))){
							int[] vertices2=faces2[l].GetFace();
							Plane plane2=new Plane(faces2[l],PointsList);
							// Test whether the planes intersect
							if (plane1.Intersect(plane2)){
								boolean[] halfspace=new boolean[3];
								boolean nopotentialforintersection=true;
								for (int m=0;m<vertices2.length;m++) halfspace[m]=plane1.GetHalfspace(PointsList[vertices2[m]]);
								for (int m=1;m<vertices2.length;m++) nopotentialforintersection=nopotentialforintersection && (halfspace[m]==halfspace[0]);
								if (!nopotentialforintersection){ // there is the posibility of an interpenetration, now do the same test on the vertices of the first plane
									nopotentialforintersection=true;
									for (int m=0;m<vertices.length;m++) halfspace[m]=plane2.GetHalfspace(PointsList[vertices[m]]);
									for (int m=1;m<vertices.length;m++) nopotentialforintersection=nopotentialforintersection && (halfspace[m]==halfspace[0]);
									if (!nopotentialforintersection){
										// The two triangles cross each others planes but this doesn't necessarily mean that the two triangles themselves cross.
										// If they do, one will have an edge that penetrates the triangle of the other so test for this now
										
										// Code copied and pasted from old edge penetration tests
										int interpenetrationcount=0;
										for (int linesegment=0;linesegment<3;linesegment++){
											int[] p=new int[2];
											if (linesegment==0){ p[0]=vertices2[0]; p[1]=vertices2[1];}
											else if (linesegment==1){ p[0]=vertices2[0]; p[1]=vertices2[2];}
											else if (linesegment==2){ p[0]=vertices2[1]; p[1]=vertices2[2];}
											Line3d line=new Line3d(PointsList[p[0]],PointsList[p[1]]);
											if (faces[j].LineSegmentIntersectTriangularFace(line,PointsList).lengthSquared()!=0) interpenetrationcount++;
										} // end for linesegment
										if (interpenetrationcount!=0){
											if (interpenetrationcount==1)System.out.print("Overlap ");
											if (interpenetrationcount==2)System.out.print("Interpenetration ");
											if (interpenetrationcount==3 )System.out.print("3 edge overlap/penetration ");
											System.out.print("detected between triangle "+j+" ");
											System.out.print("["+vertices[0]+","+vertices[1]+","+vertices[2]+"]");
											System.out.print(" of tetrahedron "+i);
											System.out.print(" and tetrahedron "+k);
											System.out.print(" triangle "+l+" ");
											System.out.print("["+vertices2[0]+","+vertices2[1]+","+vertices2[2]+"]");
											System.out.println();
										}
									} // end potential for intersection
								} // end if potential for intersection
							} // end if planes intersect
						} // end if/for l
					} // end if/for k
			} // end for j
		} // end for i
	}
	
	private void TestEmptyTetrahedrons(TriangularFace[] tetrahedrons){
		// This is to be called once the points have been turned into tetrahedrons and is just used to test whether the result is valid
		// which in this case means that no points are on the inside halfspace of all the faces of a tetrahedron
		// Its not efficient but is written so can be easily checked for bugs
		System.out.println("Testing for points inside tetrahedrons");
		for (int i=0;i<tetrahedrons.length;i++){
			// Split the tetrahedron i into 4 faces
			// Note that this assumes that each element in the array of triangular faces only has one tetrahedron attached to it!
			// This is a property of the dewall method, not of the data structure itself.
			TriangularFace[] faces=tetrahedrons[i].GetFaces(PointsList);
			
			// Test all points not in the tetrahedron vertices
			if (faces.length!=0) for (int j=0;j<PointsList.length;j++){
					if (!tetrahedrons[i].IncludesPointinTetrahedron(j)){
						boolean insidetetrahedron=true;
						for (int k=0;k<faces.length;k++) insidetetrahedron=insidetetrahedron && faces[k].InsideHalfspace(PointsList[j]);
						if (insidetetrahedron) System.out.println("Point "+j+" is inside tetrahedron "+i);
					}
				} // end for j
		} // end for i
	} // end TestValidity method
	
	
	
	private void TestDelaunayspacing(TriangularFace[] tetrahedrons){
//		 This is to be called once the points have been turned into tetrahedrons and is just used to test whether the result is valid
		// which in this case means that the circumcircle made for each triangle has no other points inside it. 
		// Its not efficient but is written so can be easily checked for bugs

		System.out.println("Testing Delaunay spacing");
		
		for (int i=0;i<tetrahedrons.length;i++){
			// First break each tetrahedron into its triangles
			TriangularFace[] faces=tetrahedrons[i].GetFaces(PointsList);
			// For each triangle, calculate the circumcenter and radius
			for (int j=0;j<faces.length;j++){
				// Rearranging equations from http://www.ics.uci.edu/~eppstein/junkyard/circumcenter.html
				// if numeratorvector=|AC|^2*(ABxAC)xAB+|AB|^2*ACx(ABxAC)
				// and denominator=2*|ABxAC|^2
				// the circumcircle radius = |numeratorvector|/denominator
				// circumcircle center= A+ numeratorvector/denominator
				int[] faceindex=faces[j].GetFace();
				Point3d A=PointsList[faceindex[0]].clone();
				Point3d B=PointsList[faceindex[1]].clone();
				Point3d C=PointsList[faceindex[2]].clone();
				Point3d AB=B.minus(A);
				Point3d AC=C.minus(A);
				Point3d ABxAC=AB.crossProduct(AC);
				Point3d numeratorvector=ABxAC.crossProduct(AB).times(AC.lengthSquared()).plus(AC.crossProduct(ABxAC).times(AB.lengthSquared()));
				double denominator=2*ABxAC.lengthSquared();
				double radius=Math.sqrt(numeratorvector.lengthSquared())/denominator;
				Point3d center=A.plus(numeratorvector.times(1/denominator));
				double radiussquared=radius*radius;
			// Now go through each point in the point list and make sure it isn't in the circumcircle.
			for (int k=0;k<PointsList.length;k++){
			// First, check the distance between and circum-center and the point (if the point isn't in the triangle)
				if (!faces[j].IncludesPoint(k)) if (PointsList[k].minus(center).lengthSquared()<radiussquared) {
					// If it is within the radius distance away, check to see if it is in the plane of the triangle
					// as using floating point, actually just check that it is quite close to plane
					if (Math.abs(faces[j].normal.dot(PointsList[k])-faces[j].normaldota)<0.00000001){
					//if (Math.abs(faces[j].normal.dot(PointsList[k])-faces[j].normaldota)==0){
						System.out.print("Triangle ");
						System.out.print("["+faceindex[0]+","+faceindex[1]+","+faceindex[2]+"]");
						System.out.print("of tetrahedron "+i);
						System.out.print(" not DeLaunay, it contains point "+k+" within the circumcircle");
						System.out.println();
					} // end if
				} // end if
				} // end for k
			} // end for j
		} // end for i
	} // end test method

	
	private void TestPointInclusion(TriangularFace[] tetrahedrons){
		// This is to be called once the points have been turned into tetrahedrons and is just used to test whether the result is valid
		// which in this case means that all points have been included in at least one tetrahedron. 
		// Could use boolean but using an int count in case want to expand to output how often a point is used as a vertex etc. 
		// Its not efficient but is written so can be easily checked for bugs
		
		System.out.println("Testing Point Inclusion");
		int[] PointUsageCount=new int[PointsList.length];
		for (int i=0;i<PointUsageCount.length;i++) PointUsageCount[i]=0;
		for (int i=0;i<tetrahedrons.length;i++){
			int[] index=tetrahedrons[i].GetFirstTetrahedron();
			for (int j=0;j<index.length;j++) PointUsageCount[index[j]]++;
			// Just in case there is a second tetrahedron associated with the face.
			int j=tetrahedrons[i].GetSecondTetrahedronPointD();
			if (j>=0) PointUsageCount[j]++;
		}
		for (int i=0;i<PointUsageCount.length;i++)
			if (PointUsageCount[i]==0) System.out.println("Point "+i+" not included in any tetrahedron");
	}
	

	private void TestTrianglesMembersOfMax2Tetrahedrons(TriangularFace[] tetrahedrons){
		// This is to be called once the points have been turned into tetrahedrons and is just used to test whether the result is valid
		// which in this case means that a triangle is part of only 1 or 2 tetrahedrons and if it is a member of two they are on opposite sides of the triangle i.e. halfspaces
		// It assumes that the tetrahedrons are single with the first d value being the one that is filled in.
		// Its not efficient but is written so can be easily checked for bugs
		int[] d=new int[3]; // We only need to keep track of at most 3 d values;
		int[] tetra=new int[3]; // We only need to keep track of at most 3 index values 
		System.out.println("Testing Triangular Faces are only part of 1 or 2 tetrahedrons, in different half-spaces.");
		for (int i=0;i<tetrahedrons.length;i++){
			// First break each tetrahedron into its faces
			TriangularFace[] faces=tetrahedrons[i].GetFaces(PointsList);
			// Go through each tetrahedron and see if it includes all the points of one or more of the faces
			for (int k=0;k<faces.length;k++){
				d[0]=faces[k].GetFirstTetrahedronPointD();
				tetra[0]=i;
				int count=0;
				for (int j=0;j<tetrahedrons.length;j++){
					if (i!=j){
							if (tetrahedrons[j].IncludesTriangleinTetrahedron(faces[k])){
								count++;
								// Find the vertex that isn't the triangle
								int[] vertices=tetrahedrons[j].GetFirstTetrahedron();
								int x=0;
								while (faces[k].IncludesPoint(vertices[x])) x++;
								d[count]=vertices[x];
								tetra[count]=j;
								if (count>1) {
									System.out.print("Face ");
									faces[k].print();
									System.out.println(" of tetrahedron "+tetra[0]+" is joined to point "+d[0]+" and more than 1 other point including "+d[1]+" (tetrahedron "+tetra[1]+") and "+d[2]+" (tetrahedron "+tetra[2]+")");
											
									k=faces.length;j=tetrahedrons.length; // skip to end as don't need to test any more
								} // end if count>1
							} // end if
					} // end if i!=j
				} // end for j
				if (count==1) // compare the halfspaces
					if (faces[k].InsideHalfspace(PointsList[d[0]])==faces[k].InsideHalfspace(PointsList[d[1]])) {
						System.out.print("Face ");
						faces[k].print();
						System.out.println(" of tetrahedron "+i+" is joined to form another tetrahedron in the same half-space using point "+d[1]+" (tetrahedron "+tetra[1]+")");
					}
				} // end for k
			} // end for i
	} // end of method

	} // end of class
