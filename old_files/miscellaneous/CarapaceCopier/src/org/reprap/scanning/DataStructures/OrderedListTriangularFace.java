package org.reprap.scanning.DataStructures;

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
* Last modified by Reece Arnott 2nd July 2010
*
*	This class stores an array of triangluar faces which can be accessed in an ordered way (ordered by a hashvalue) 
*	A triangular face is 3 vertices a,b,c and potentially 0,1, or 2 other points relating to the tetrahedrons that it is a face for. These are stored as simple indexes to a Point3d array.
* 
* TODO - This class may benefit from using  unconstrained ArrayList rather than fixed length array.
* 	- Go through and take out array cloning and change to create new array of same length+for loop to clone individual elements as this may be causing problems with FIFO insertion order array length=0 problem.
* 
* 
***********************************************************************************/
import org.reprap.scanning.Geometry.TriangularFace;
import org.reprap.scanning.Geometry.Point3d;

public class OrderedListTriangularFace {
		private TriangularFace[] Plist; // This is the point list array that is order by the hash value
		private int n; // This is the value passed into the constructor as the highest value that can be used as one of the indices which is used in the construction of the hashvalue
		private long[] insertionorder; // This is just used to keep track of the order in which the elements were inserted so you can extract them in LIFO or FIFO manner.
		private int nextFIFO; // a pointer to the array index of insertionorder containing the next hashvalue 
		//Constructor
		public OrderedListTriangularFace (int high){
			Plist=new TriangularFace[0];
			n=high;
			insertionorder=new long[0];
			nextFIFO=0;
		}
		public OrderedListTriangularFace clone(){
			OrderedListTriangularFace returnvalue=new OrderedListTriangularFace(n);
			returnvalue.Plist=Plist.clone();
			returnvalue.insertionorder=insertionorder.clone();
			returnvalue.nextFIFO=nextFIFO;
			return returnvalue;
		}
		
		public void InsertTetrahedronsIfFaceNotExist(OrderedListTriangularFace list){
			TriangularFace f=list.GetFirstFIFO();
			while (!f.IsNull()) {
				InsertIfNotExist(f);
				f=list.GetNextFIFO();
			}
		}
		
		// returns true if it inserted the addition
	public boolean InsertIfNotExist(TriangularFace addition){
		boolean insert=true;
			addition.SetHash(n);
			if (Plist.length==0) {
				Plist=new TriangularFace[1];
				Plist[0]=addition.clone();
				insertionorder=new long[1];
				insertionorder[0]=addition.hashvalue;
				nextFIFO=0;
				}
			else {
				int insertpoint;
				//If there is a possibility that the face already exists, find whether it does or not
				if ((Plist[0].hashvalue<=addition.hashvalue) && (Plist[Plist.length-1].hashvalue>=addition.hashvalue)){
					insertpoint=Find(addition.hashvalue);
					if (Plist[insertpoint].hashvalue==addition.hashvalue) insert=false; // if the face already exists we won't insert it
				} // end if
				else { 
					if (Plist[Plist.length-1].hashvalue<addition.hashvalue) insertpoint=Plist.length;
					else insertpoint=0;
				} // end else
				if (insert){
					TriangularFace[] returnvalue=new TriangularFace[Plist.length+1];
					for (int i=0;i<returnvalue.length;i++){
						if (i<insertpoint) returnvalue[i]=Plist[i].clone(); 
						else if (i>insertpoint)  returnvalue[i]=Plist[i-1].clone();
						else returnvalue[i]=addition.clone();
					} // end for
					Plist=returnvalue.clone();
					// Add the hashvalue to the end of the insertionorder array
					long[] insertorder=new long[insertionorder.length+1];
					for (int i=0;i<insertionorder.length;i++) insertorder[i]=insertionorder[i];
					insertorder[insertionorder.length]=addition.hashvalue;
					insertionorder=insertorder.clone();
				} // end if insert
		} // end else
		return insert;
	} // end InsertIfNotExist	
	
	// returns true if it deleted the entry
	public boolean DeleteIfExist(TriangularFace target){
		boolean returnvalue=false;
		if (Plist.length!=0){
			target.SetHash(n);
			int index=Exists(target.hashvalue);
			returnvalue=(index!=-1);
			if (returnvalue) DeleteEntry(index,true); 
		} // end if
		return returnvalue;
	} // end method
	
	public TriangularFace GetFirstFIFO(){
		nextFIFO=0;
		return GetNextFIFO();
	}
	public void DeleteExtractedFIFOOrder(){
		if (nextFIFO!=0){
			long[] newinsertionorder=new long[insertionorder.length-nextFIFO];
			for (int i=nextFIFO;i<insertionorder.length;i++) newinsertionorder[i-nextFIFO]=insertionorder[i];
			insertionorder=newinsertionorder.clone();
			nextFIFO=0;
		} // end if nextFIFO!=0
	}
	
	public TriangularFace GetNextFIFO(){
		TriangularFace returnvalue;
		if (insertionorder.length==0) returnvalue=new TriangularFace();
		else {
			int index=-1;
			while ((index==-1) && (nextFIFO<insertionorder.length)) {
				index=Exists(insertionorder[nextFIFO]);
				nextFIFO++;
			}
			if ((nextFIFO>insertionorder.length) || (index==-1)){
				// There are no more valid hashes in the array
				returnvalue=new TriangularFace();
			}
			else returnvalue=Plist[index].clone();
		} // end else
		return returnvalue;	
	}
	// Same as above except it deletes the face as well
	public TriangularFace ExtractFIFO(){
		TriangularFace returnvalue;
		if (insertionorder.length==0) returnvalue=new TriangularFace();
		else {
			int index=-1;
			while ((index==-1) && (nextFIFO<insertionorder.length)) {
				index=Exists(insertionorder[nextFIFO]);
				nextFIFO++;
			}
			if ((nextFIFO>insertionorder.length) || (index==-1)){
				// There are no more valid hashes in the array
				Plist=new TriangularFace[0];
				insertionorder=new long[0];
				nextFIFO=0;
				returnvalue=new TriangularFace();
			}
			else {
				returnvalue=Plist[index].clone();
				DeleteEntry(index, true);
				//DeleteEntry(index, false); // Note that this won't change the insertion order array. It may be done faster by calling the DeleteExtractedFIFOOrder after a number of elements have been extracted
			}
		} // end else
		return returnvalue;	
	}
	
	public void PrintFIFO(){
		if (insertionorder.length!=0)
		{
			int i=0;
			int index=-1;
			while (i<insertionorder.length) {
				index=Exists(insertionorder[i]);
				if (index!=-1){
					// There is a valid hash in the array
					TriangularFace f=Plist[index].clone();
					System.out.print(i+" "+insertionorder[i]+": ");
					f.print();
					System.out.print(" "+TestedTwice(f));
				} // end if
				else System.out.print(i+" "+insertionorder[i]+" ");
				if (nextFIFO==i) System.out.print("  <=====");
				System.out.println();
				i++;
			} // end while
		} // end if
	}
	public void PrintList(){
		if (Plist.length!=0)
		{
			int i=0;
			while (i<Plist.length) {
				TriangularFace f=Plist[i].clone();
				System.out.print(i+": ");
				f.print();
				System.out.print(" "+TestedTwice(f));
				System.out.println();
				i++;
			} // end while
		} // end if
	}
	
	public void PrintInsertionOrder(){
		if (insertionorder.length!=0)
		{
			int i=0;
			while (i<insertionorder.length) {
				int index=Exists(insertionorder[i]);
				System.out.println(i+" "+insertionorder[i]+" "+index);
				i++;
			} // end while
		} // end if
	}
	
	public int getLength(){
		return Plist.length;
	}
	
	
	public boolean TestedTwice(TriangularFace P){
		boolean returnvalue=false;
		if (Plist.length!=0){
			P.SetHash(n);
			int index=Exists(P.hashvalue);
			if (index!=-1) returnvalue=Plist[index].FaceTestedForMultipleTetrahedrons();
		}
		return returnvalue;
	} 
	public boolean TestedTwice(int a,int b, int c){
		TriangularFace temp=new TriangularFace(a,b,c);
		return TestedTwice(temp);
	} 
	
	// returns true if at least one tetrahedron was inserted
	public boolean InsertTetrahedronsIfNotExistAndSetTestedTwiceIfExist(TriangularFace addition,Point3d[] array){
		addition.SetHash(n);
		boolean returnvalue=InsertIfNotExist(addition);
		if (!returnvalue) {// i.e. it wasn't inserted because it existed
			int mergepoint=Find(addition.hashvalue);
			int count=0;
			int[] d=new int[2];
			int d1=Plist[mergepoint].GetFirstTetrahedronPointD();
			int d2=Plist[mergepoint].GetSecondTetrahedronPointD();
			// Put the value(s) to add in the d array
			if (!addition.GetFirstTetrahedronNull()) {d[count]=addition.GetFirstTetrahedronPointD();count++;}
			if (!addition.GetSecondTetrahedronNull()){d[count]=addition.GetSecondTetrahedronPointD();count++;}
			// Put as many d value(s) in the TriangularFace as possible
			if ((count!=0) && (Plist[mergepoint].GetFirstTetrahedronNull())){
				count--;
				if (d[count]==d2) {Plist[mergepoint].SetFaceTestedForMultipleTetrahedrons(); count=0;}
				else {Plist[mergepoint].SetFirstTetrahedronPointD(d[count],array); returnvalue=true;}
				}
			if ((count!=0) && (Plist[mergepoint].GetSecondTetrahedronNull())){
				count--;
				if (d[count]==d1) {Plist[mergepoint].SetFaceTestedForMultipleTetrahedrons(); count=0;}
				else {Plist[mergepoint].SetSecondTetrahedronPointD(d[count],array); returnvalue=true;}
				}
		} // end if
	return returnvalue;
	} // end InsertTetrahedronIfNotExistAndSetTestedTwiceIfExist

	
	public boolean FaceExists(TriangularFace f){
		f.SetHash(n);
		return (Exists(f.hashvalue)!=-1);
		
	}
	
	public TriangularFace GetTetrahedron(TriangularFace candidate){
		TriangularFace returnvalue=candidate.clone();
		candidate.SetHash(n);
		int index=Find(candidate.hashvalue);
		if (index!=-1) returnvalue=Plist[index].clone();
		return returnvalue;
	}
	
	
	public TriangularFace[] GetFullUnorderedList(){
		return Plist;
	}
	// These are the private methods for this class

	// Assumes the source point list is ordered by hash value and does a binary recursive search returning either the array element that contains the hash or the element to the right of where it should be inserted
	private int Find(long targethash){
		int returnvalue;
		returnvalue=Find(targethash,0,Plist.length);
		return returnvalue;
	}
	// This returns either the index if the target exists or -1 if it doesn't
	private int Exists(long targethash){
		int index=Find(targethash,0,Plist.length);
		if (index==Plist.length) return -1;
		else {
			if (Plist[index].hashvalue!=targethash) return -1;
			else return index;
		}
		
	}
	
	private int Find(long targethash, int left, int right){
		int returnvalue;
		if ((right-left)<=1){
			// Maximum of two to test, if the hashvalue exists return which one it belongs to, otherwise return the right one
			if (Plist.length==0) returnvalue=0;
			else if (Plist[left].hashvalue==targethash) returnvalue=left;
			else returnvalue=right;
		}
		else {
			// which half should we be searching in
			int mid=(left+right)/2;
			if (Plist[mid].hashvalue>targethash) returnvalue=Find(targethash,left,mid);
			else  returnvalue= Find(targethash,mid,right);
		}
		return returnvalue;
		
	}
	private void DeleteEntry(int index, boolean changeinsertionorderarray){
		// First go through the insertionorder array and take out the entry if requested 
		if (changeinsertionorderarray){
			int numberofmatches=0;
			for (int i=0;i<insertionorder.length;i++)if (insertionorder[i]==index) numberofmatches++;
			if (numberofmatches!=0){
				long[] newinsertionarray=new long[insertionorder.length-numberofmatches];
				int j=0;
				for (int i=0;i<insertionorder.length;i++){
					if (insertionorder[i]!=index){
						newinsertionarray[j]=insertionorder[i];
						j++;
					} // end if
					else if (i<nextFIFO) nextFIFO--;
				} // end for
				insertionorder=newinsertionarray.clone();
			} // end if numberofmatches!=0
		} // end if changeinsertionorderarray
		// Now delete it from the P array
		TriangularFace[] returnvalue=new TriangularFace[Plist.length-1];
		for (int i=0;i<Plist.length;i++){
			if (index>i) returnvalue[i]=Plist[i].clone();
			if (index<i) returnvalue[i-1]=Plist[i].clone();
		}
		Plist=returnvalue.clone();
	}

} // end of class
