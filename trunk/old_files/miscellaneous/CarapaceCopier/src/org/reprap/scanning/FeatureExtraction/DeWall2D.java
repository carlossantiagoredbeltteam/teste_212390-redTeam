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
* Last modified by Reece Arnott 22nd December 2010
*
* This was originally a copy of the DeWall3D class as at 21st Decemeber 2010 and is changed to find 2d line segments and triangles rather than 3d triangles and tetrahedrons
* 
* Note that this breaks down if the first simplex made is made from 3 points in a line or there are 4 points that are co-circular including the initial point so when this is called
* the original simplex seed point is chosen as the midpoint in the array first by ordering the list based on x values, then if that doesn't work, by y.
* 
* This class is originally an implementation of the DeWall version of the recursive Delauney Divide and Conquer algorithm based on the paper http://dx.doi.org/10.1016/S0010-4485(97)00082-1
* "DeWall: A fast divide and conquer Delaunay triangulation algorithm in E^d" Computer-Aided Design Volume 30, Issue 5, April 1998, Pages 333-341 by P Cignoni and C Montani and R Scopigno
* It takes as input an array of 2d points and outputs an array of 2d triangles.
*
* This is a restricted implementation in that it creates an array of triangles, not an array of (d-1)-faces as the general form would.
* This is only due to the fact that we are using Point2d objects as the underlying objects and the MakeSimplex method takes a line segment and creates a triangle rather than the generalised case as in the paper.
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

import org.reprap.scanning.DataStructures.QuickSortPoints2D;
import org.reprap.scanning.DataStructures.Uniform2DGrid;
import org.reprap.scanning.DataStructures.OrderedListLineSegment2dIndices;
import org.reprap.scanning.Geometry.AxisAlignedBoundingBox;
import org.reprap.scanning.Geometry.LineSegment2D;
import org.reprap.scanning.Geometry.Point2d;
import org.reprap.scanning.Geometry.Triangle2D;
import org.reprap.scanning.Geometry.LineSegment2DIndices;
public class DeWall2D {
	
	public enum planeslice {x,y};
	public enum searching {oneradius,tworadii,currentminimumradius,all,exit}; // just for readability in the MakeSimplex method
	// These just for testing
	public static boolean printdebugging=false;
	public static boolean printverbose=false;
	public static boolean print=false;
	
	public int maxrecurse=21; // Once the maximum recursion level is reached the recursion stops and the algorithm reverts to a sequential form by having the Categorise method always returning 0. Given that is assumed a maximum of 2^21 points will be used (due to the way the TriangularFace hashvalue is calculated) it doesn't make sense to set a recursion level greater than 21.  
	public int minpoints=100; // If the number of points to be processed by DeWall is less than this, recursion stops by having the recursionlevel set to maxrecurse
	// Max recurse is not currently set outside of this class but is there for completeness. Just in case it does make sense to set it.
	
	public final double UGScale=1; // This scale factor is multiplied by the number of points to give the minimum number of cells the Uniform grid is created with
	private Point2d[] PointsList; // This is the list of points we are operating on. To limit the problem of trying to compare equality of floating point numbers the points will simply be referred to by their index in this array most of the time
	// These are just used so we can update the progress bar
	private int[] count;
	private boolean[] finished;
	
	private boolean CyclicTriangle2DCreation=false; // Is there a cyclic tetrahedron creation? Once it is detected the algorithm will cease.
	private Triangle2D[] FinalTriangles; // The final list of triangles but they are stored along with the 4th point for the tetrahedronso that can run the CTC check on them
	
	private QuickSortPoints2D qsort; // Used to sort the PointsList
	
	
	// Constructor
	public DeWall2D(Point2d[] points){
		FinalTriangles=new Triangle2D[0];
		PointsList=new Point2d[points.length];
		count=new int[points.length];
		finished=new boolean[points.length];
		for (int i=0;i<points.length;i++){
			PointsList[i]=points[i].clone();
			count[i]=0;
			finished[i]=false;
		}
	}
	
	// This method does some setting up and then calls the private DeWall method to carve the space around the points into tetrahedrons 
	public Triangle2D[] Triangularisation(JProgressBar bar, boolean recursive,String initialplane){
		//  set the progress bar min and max
		  bar.setMaximum(PointsList.length);
		  bar.setMinimum(0);
		  bar.setValue(bar.getMinimum());
		long starttime=System.currentTimeMillis();
		// Use this sorted list to build up a triangle list using DeWall divide and conquer
		qsort=new QuickSortPoints2D(PointsList);
		// Create the indexarray
		int[] indexarray=new int[PointsList.length];
		for (int i=0;i<indexarray.length;i++) indexarray[i]=i;
		CyclicTriangle2DCreation=false;
		int initialrecursionlevel=0;
		if (!recursive) initialrecursionlevel=maxrecurse;// Call to Sequential version of Dewall by setting the inital recursion level to the maximum 
			dewall(indexarray, new OrderedListLineSegment2dIndices(PointsList.length),planeslice.valueOf(initialplane), bar,System.currentTimeMillis(),initialrecursionlevel);
		bar.setValue(bar.getMaximum());
		if (print){
			 System.out.println("Total time:"+(System.currentTimeMillis()-starttime)+"ms  Total Triangle2Ds="+FinalTriangles.length);
		 }
		if (printverbose){
			for (int i=0;i<FinalTriangles.length;i++){
				System.out.print(i+" ");
				FinalTriangles[i].print();
				System.out.println();
			} // end for
		} // end if printverbose
		
		
		return FinalTriangles;
	}
	public boolean IsCyclicTriangle2DCreationError(){
		return CyclicTriangle2DCreation;
	}
		
	
	/***********************************************************************************************************************************
	 * 
	 *  Private methods
	 * 
	 ***********************************************************************************************************************************/
	
	private void dewall(int[] P, OrderedListLineSegment2dIndices AFL, planeslice currentplaneslice,JProgressBar bar, long lastprogressupdate,int recursionlevel){
		recursionlevel++;
		if (P.length<minpoints) recursionlevel=maxrecurse; 
		
		//Initialise the arrays we'll be using to be empty and calculate a splitting plane for the point array P
		OrderedListLineSegment2dIndices AFLalpha=new OrderedListLineSegment2dIndices(PointsList.length);
		OrderedListLineSegment2dIndices AFL1=new OrderedListLineSegment2dIndices(PointsList.length);
		OrderedListLineSegment2dIndices AFL2=new OrderedListLineSegment2dIndices(PointsList.length);
		
		// Set up the Uniform Grid
		Uniform2DGrid UG=new Uniform2DGrid(PointsList, P, (int)(UGScale*P.length));
		
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
		if (printdebugging) {System.out.println("Recursion level "+recursionlevel+". Splitting points array of length "+P.length+" into arrays of length "+P1.length+" and "+P2.length);
		
		System.out.println("Split plane "+currentplaneslice.toString()+" "+splitplanecoordinate);
		System.out.println("P1");
		for (int i=0;i<P1.length;i++) {System.out.print(i+" "+P1[i]+" ");PointsList[P1[i]].print();System.out.println();}
		System.out.println("P2");
		for (int i=0;i<P2.length;i++) {System.out.print(i+" "+P2[i]+" ");PointsList[P2[i]].print();System.out.println();}
		System.out.println("P");
		for (int i=0;i<P.length;i++) {System.out.print(i+" "+P[i]+" ");PointsList[P[i]].print();System.out.println();}
		}
	//  Wall Construction 
	if (AFL.getLength()==0){
		// Make the first simplex using as one point the closest point to the midpoint split, and as another a point on the other side.
			Triangle2D tri=MakeFirstSimplex(P);
			if (!tri.isNull()) {
				LineSegment2DIndices[] temp=tri.GetFaces(PointsList);
				for (int i=0;i<temp.length;i++) {
					temp[i].SetHash(PointsList.length);
					//if (i==0){ // Reverse the first line segment normal
						//temp[0].FlipNormal(PointsList);
						//int[] v=temp[0].GetFace();
						//LineSegment2DIndices t=new LineSegment2DIndices(v[1],v[0],PointsList);
						//int[] oppositevertices=tri.GetVertices();
						//t.CalculateNormalAwayFromPoint(PointsList,PointsList[oppositevertices[0]]);
						//t.SetHash(PointsList.length);
						//AFL.InsertIfNotExist(t);
					//	AFL.InsertIfNotExist(temp[0]);
					//}
					//else 
					AFL.InsertIfNotExist(temp[i]);
				}
				FinalTriangles=new Triangle2D[1];
				FinalTriangles[0]=tri.clone();
				// Increment the counters for each of these four points by 3.
					int[] indexes=tri.GetVertices();
					for (int i=0;i<indexes.length;i++)
						for (int j=0;j<3;j++) increment(indexes[i]);
				
			}
		}
	
		// Split the Active Face List into the correct sub lists
		LineSegment2DIndices f=AFL.GetFirstFIFO();
			
		while (!f.IsNull()){
				int category=Categorise(f,splitplanecoordinate,currentplaneslice,recursionlevel);
				switch(category){
				case 0:AFLalpha.InsertIfNotExist(f);break;
				case 1:AFL1.InsertIfNotExist(f);break;
				case 2:AFL2.InsertIfNotExist(f);break;
			}
		f=AFL.ExtractFIFO();
		}
		
		
//		 Main loop
		f=AFLalpha.ExtractFIFO();
		while (!f.IsNull()){
			Triangle2D t=new Triangle2D();
			t=MakeSimplex(f,UG);
					// Test to make sure the tetrahedron constructed is a valid one
					boolean valid=!t.isNull();
					if (valid)
					{
						FinalTriangles=Insert(FinalTriangles,t); // Note that this will mean we end up with a list of TriangularFaces each attached to a single tetrahedron only.
						LineSegment2DIndices[] fdash=t.GetFaces(PointsList);
						for (int i=0;i<fdash.length;i++){
								if (!fdash[i].LineSegmentEqual(f)){
									// Update the correct Active Face list
									fdash[i].SetHash(PointsList.length);
									
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
			if (printdebugging) {
				System.out.println("AFLalpha "+AFLalpha.getLength());AFLalpha.PrintFIFO();
				//System.out.println("AFL1 "+AFL1.getLength());//AFL1.PrintFIFO();
				//System.out.println("AFL2 "+AFL2.getLength());//AFL2.PrintFIFO();
			}
			f=AFLalpha.ExtractFIFO();
			
			if (CyclicTriangle2DCreation){
				if (print) System.out.println("CTC error");
				f=new LineSegment2DIndices(); // exit while loop
			}
		}//end while
		
		// recurse and change the orientation of the plane slice
		planeslice nextplaneslice=planeslice.values()[(currentplaneslice.ordinal()+1)%planeslice.values().length];
		// Only recurse if need to i.e. there is at least one face in the Active face list that needs processed and a cyclic tetrahedron creation hasn't been flagged.
		if ((!CyclicTriangle2DCreation) && (AFL1.getLength()!=0)) dewall(P1,AFL1,nextplaneslice,bar, lastprogressupdate,recursionlevel);
		if ((!CyclicTriangle2DCreation) && (AFL2.getLength()!=0)) dewall(P2,AFL2,nextplaneslice,bar,lastprogressupdate,recursionlevel);
	} // end of method dewall (recursive)
	
//	 returns 0 if the slice-line intersects the line segment and is to go into AFLalpha
	// returns 1 if the line is on one side of the face (to go into AFL1)
	// returns 2 if the line is on the other side of the face (to go into AFL2)
	// If the maximum recursion level has been reached it will also return 0 which essentially turns it into an iterative approach
	private int Categorise(LineSegment2DIndices f,double coordinate,planeslice currentplaneslice,int recursionlevel){
		if (recursionlevel>=maxrecurse) return 0; 
		else{		
			int[] indexes=f.GetStartAndEndPointIndices();
			double start,end;
			start=Coordinate(currentplaneslice,indexes[0]);
			end=Coordinate(currentplaneslice,indexes[1]);
			boolean v1,v2;
			v1=(start<coordinate);
			v2=(end<coordinate);
			if (v1!=v2) return 0;
			else{
				if (v1) return 1;
					else return 2;
			} // end else
		}
	} // end Categorise
	
	private double Coordinate(planeslice currentplaneslice,int index){
		double returnvalue=0;
		switch(currentplaneslice) {
		case x: returnvalue=PointsList[index].x;break;
		case y: returnvalue=PointsList[index].y;break;
		}
		return returnvalue;
	}
	
	
	// Adds to a tetrahedron array and also checks for equivalent tetrahedron alreay existing
	private Triangle2D[] Insert(Triangle2D[] original, Triangle2D addition){
		Triangle2D[] returnvalue=new Triangle2D[original.length+1];
		for (int i=0;i<original.length;i++){
			returnvalue[i]=original[i].clone();
			if (original[i].isEquivalent(addition)) {
				CyclicTriangle2DCreation=true;
				System.out.print("CTC error adding triangle ");
				addition.print();
				System.out.println();
			}
		}
		returnvalue[original.length]=addition.clone();
		return returnvalue;
	}
	// Only used by the original algorithm
	// Delete the face from the list if it exists and add it if it does not
	// Also increment or decrement the point counters accordingly
	private OrderedListLineSegment2dIndices Update(OrderedListLineSegment2dIndices AFL, LineSegment2DIndices f){
		boolean deleted=AFL.DeleteIfExist(f);
		if (!deleted) AFL.InsertIfNotExist(f);
		int[] indexes=f.GetStartAndEndPointIndices();
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
	private Triangle2D MakeFirstSimplex(int[] P){
		
		
		Triangle2D returnvalue=new Triangle2D();
		int midpoint=(int)Math.floor((double)P.length/2);
		  int a=P[midpoint-1];
			int b=-1;
			double mindistancesquared=Double.MAX_VALUE;
			for (int i=midpoint;i<P.length;i++){
				double distancesquared=(PointsList[a].minusEquals(PointsList[P[i]])).lengthSquared();
					if (distancesquared<mindistancesquared) {
						b=P[i];
						mindistancesquared=distancesquared;
				}
			}
			
			if (b!=-1){
				// Now find the third point from the array that means the circumcircle has the smallest radius
				
				// The centre of a circumcircle in 2d can be found as the intersection point of lines that bisect neighbouring edges at right angles
				
				//Find the bisecting line of the two points we currently have
				LineSegment2DIndices AB=new LineSegment2DIndices(a,b,PointsList);
				Point2d bisectpoint=AB.GetPointOnLine(PointsList,0.5);
				LineSegment2D ABbisectline=new LineSegment2D(bisectpoint,bisectpoint.plusEquals(AB.normal));
				double currentmindd=Double.MAX_VALUE;
				int c=-1;
				for (int i=0;i<P.length;i++){
					if ((a!=P[i]) && (b!=P[i])){
						// Calculate the centre of the circumcircle using this point and from this calculate the radiussquared
//						Find the bisecting line of the two points we currently have
						LineSegment2DIndices AC=new LineSegment2DIndices(a,P[i],PointsList);
						bisectpoint=AC.GetPointOnLine(PointsList,0.5);
						LineSegment2D ACbisectline=new LineSegment2D(bisectpoint,bisectpoint.plusEquals(AC.normal));
						
						Point2d centre=ABbisectline.IntersectionPointofInfinite2DLines(ACbisectline);
						if (!(centre.isEqual(ABbisectline.start))){
							double radiussquared=PointsList[a].minusEquals(centre).lengthSquared();
							//Check if the centre is on the same side of the line AB as point C.
			            	boolean sameside=(AB.InsideHalfspace(PointsList[P[i]])==AB.InsideHalfspace(centre));
			            	double dd=radiussquared;
			            	if (!sameside) dd=dd*-1;
			            	if (dd==currentmindd){
									System.out.println("Error: 4 cocircular points for the first simplex. Can't continue");
									c=-1;
									currentmindd=0;
			            	}
			            	if (dd<currentmindd){
								currentmindd=dd;
								c=P[i];
							}
						} // end if
					} // end if
				} // end for
				// If there wasn't a 3rd point we drop the whole thing
				if (c==-1) returnvalue=new Triangle2D();
				else { 
					// Find out whether point c is on the same side of the mid line between a and b as point b and if it isn't swap point a and b around.
					// Point the normal away from c
					LineSegment2DIndices line=new LineSegment2DIndices(a,b,PointsList);
					line.SetHash(PointsList.length);
					if (AB.InsideHalfspace(PointsList[c])!=AB.InsideHalfspace(PointsList[b])){
						line=new LineSegment2DIndices(b,a,PointsList);
						line.SetHash(PointsList.length);
					}
					returnvalue=new Triangle2D(line,c,PointsList);
				}
			} // end if b!=-1
	return returnvalue;
	} // end of MakeFirstSimplex method

	private Triangle2D MakeSimplex(LineSegment2DIndices f,Uniform2DGrid UG){
		Triangle2D returnvalue;
		int currentnextpointindex=-1;
		int[] ab=f.GetStartAndEndPointIndices();
		decrement(ab[0]);
		decrement(ab[1]);
		if (printverbose) System.out.println("Attempting Make Simplex with "+ab[0]+" and "+ab[1]);
		
		  	// The centre of a circumcircle in 2d can be found as the intersection point of lines that bisect neighbouring edges at right angles
			
		  
		  // Find this line of circumsphere centres
		
		//Find the bisecting line of the two points we currently have
		Point2d bisectpoint=f.GetPointOnLine(PointsList,0.5);
		LineSegment2D ABbisectline=new LineSegment2D(bisectpoint,bisectpoint.plusEquals(f.normal));
		// Now go through points and find the third point that gives the smallest dd value
				
		// Go through the Uniform grid, first taking just the points in a sphere with the same center and radius of the circumcircle. 
		// then go out to have a bounding box with the center 2*circumradii along the centerline
		// If a point is found but has a circumsphere radius greater than the bounding box radius, test all points within that radius to be sure it is the correct one.
		// Finally, if no points have been found, test all points in the grid
		//The enum searching is defined at the top of the class as {oneradius,tworadii,currentminimumradius,all,exit}
		double circumradius=Math.sqrt((bisectpoint.minusEquals(PointsList[ab[0]])).lengthSquared());
		
		double currentmindd=Double.MAX_VALUE;
				searching state=searching.valueOf("oneradius");
				UG.resetMarked();
				while (state!=searching.valueOf("exit")){
					AxisAlignedBoundingBox box=new AxisAlignedBoundingBox();
					if (printverbose) System.out.println(state.toString());
					
					switch(state) {
					case oneradius:
						box=UG.GetBoundingBox(bisectpoint,circumradius); // get the single cells that are within a circumcircle centred on the middle of the line AB with a radius such that A and B are on the circumference
						break;
					case tworadii:
						// Find the point along the centerline (using Pytagoras) that makes a right angle triangle with the hypotenuse which is a multiple of the length of the circumcircle radius, one point the circumcircle centre, one point A.
						// hypotenuse^2=circumcircleradius^2+t^2 so t^2=n^2*circumradius^2-circumradius^2=(n^2-1)*circumradius^2, t= Math.sqrt(n^2-1)*circumradius
						// if we make things easy so we don't need to take square roots when working out hypotenuse and set n=2, we can simply set the t=sqrt(3)*circumradius
						double t=Math.sqrt(3)*circumradius;
						// This t is then the distance along the bisecting line ray so if the line vector is normalised (as it comes from the normal it is) this is simply l.P+t*V
						Point2d center=ABbisectline.GetPointOnLine(t);
						// get the cells centred on the point center in a box that also contains the point A.
						box=UG.GetBoundingBox(center,2*circumradius);
						break;
					case currentminimumradius:
						double boxradiussquared=currentmindd; //set the box radius to be the current min radius
						// Find the point along the centerline (using Pytagoras) that makes a right angle triangle with the hypotenuse the length of the boxradius, one point the circumcircle centre, one point A.
						// boxradius^2=circumcircleradius^2+t^2 so t^2=boxradius^2-circumradius^2
						t=Math.sqrt(boxradiussquared-(circumradius*circumradius));
						// This t is then the distance along the centerline ray so if the line vector is normalised (as it comes from the normal it is) this is simply l.P+t*V
						center=ABbisectline.GetPointOnLine(t);
						// get the cells centred on the point center in a box that also contains the point A.
						box=UG.GetBoundingBox(center,Math.sqrt(boxradiussquared)); 
						break;
					case all:
						box.minx=0;
						box.miny=0;
						box.maxx=UG.arraysizex-1;
						box.maxy=UG.arraysizey-1;
						break;
					}
					
					
				for (int x=(int)box.minx;x<=(int)box.maxx;x++){
					for (int y=(int)box.miny;y<=(int)box.maxy;y++){
							if (UG.ExaminableCell(x,y)){
								int i=UG.GetFirst(x,y);
								
								while (i!=-1){
									boolean valid=((i!=ab[0]) && (i!=ab[1])); // make sure it isn't one the vertices we already have
									if (valid) valid=(!f.InsideHalfspace(PointsList[i])); // it is in the correct halfspace
									if (valid) valid=f.normal.dot(PointsList[i])!=f.normaldota;// Check the point is not on the ABC plane
									if (valid){
									
										
										// Calculate the centre of the circumcircle using this point and from this calculate the radiussquared
										LineSegment2DIndices AC=new LineSegment2DIndices(ab[0],i,PointsList);
										bisectpoint=AC.GetPointOnLine(PointsList,0.5);
										LineSegment2D ACbisectline=new LineSegment2D(bisectpoint,bisectpoint.plusEquals(AC.normal));
										
										
										Point2d centre=ABbisectline.IntersectionPointofInfinite2DLines(ACbisectline);
										if (!(centre.isEqual(ABbisectline.start))){
											double radiussquared=PointsList[ab[0]].minusEquals(centre).lengthSquared();
											//Check if the centre is on the same side of the line AB as point C.
							            	boolean sameside=(f.InsideHalfspace(PointsList[i])==f.InsideHalfspace(centre));
							            	double dd=radiussquared;
							            	if (!sameside) dd=dd*-1;
							            	if (dd<currentmindd){
							            		currentmindd=dd;
							            		currentnextpointindex=i;
											}

							            	if (printverbose) System.out.println("checking points "+ab[0]+" "+ab[1]+" "+i+" dd="+dd+" radii="+Math.sqrt(PointsList[ab[0]].minusEquals(centre).lengthSquared())+" "+Math.sqrt(PointsList[ab[1]].minusEquals(centre).lengthSquared())+" "+Math.sqrt(PointsList[i].minusEquals(centre).lengthSquared()));
							            
										} // end if intersect centre line
									} // end if valid
						            i=UG.GetNext(x,y);
								} // end while
								UG.CellExamined(x,y);
							} // end if ExaminableCell
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
			// If there wasn't a 4th point or it is to be ignored we drop the whole thing
	
			if ((currentnextpointindex==-1)) 
					returnvalue=new Triangle2D();
			else{
				returnvalue=new Triangle2D(f,currentnextpointindex,PointsList);
			} // end else
		return returnvalue;
	}
	
	} // end of class
