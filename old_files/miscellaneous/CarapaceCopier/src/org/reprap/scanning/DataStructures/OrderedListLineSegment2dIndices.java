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
* Last modified by Reece Arnott 21st December 2010
*
*	This class stores an array of line segments which can be accessed in an ordered way (ordered by a hashvalue) 
*	This was a copy of the OrderedListTriangle3D as at 21st Decemeber with the only changes a search and replace from Triangle3D to LineSegment2DIndices
* 
* TODO - This class may benefit from using  unconstrained ArrayList rather than fixed length array.
* 	
* 
***********************************************************************************/
import org.reprap.scanning.Geometry.LineSegment2DIndices;

public class OrderedListLineSegment2dIndices {
		private LineSegment2DIndices[] list; // This is the list array that is order by the hash value
		private int n; // This is the value passed into the constructor as the highest value that can be used as one of the indices which is used in the construction of the hashvalue
		private long[] insertionorder; // This is just used to keep track of the order in which the elements were inserted so you can extract them in LIFO or FIFO manner.
		private int nextFIFO; // a pointer to the array index of insertionorder containing the next hashvalue 
		//Constructor
		public OrderedListLineSegment2dIndices (int high){
			list=new LineSegment2DIndices[0];
			n=high;
			insertionorder=new long[0];
			nextFIFO=0;
		}
		public OrderedListLineSegment2dIndices clone(){
			OrderedListLineSegment2dIndices returnvalue=new OrderedListLineSegment2dIndices(n);
			returnvalue.list=list.clone();
			returnvalue.insertionorder=insertionorder.clone();
			returnvalue.nextFIFO=nextFIFO;
			return returnvalue;
		}
//		 returns true if it inserted the addition
		public boolean InsertIfNotExist(LineSegment2DIndices addition){
		boolean insert=true;
			addition.SetHash(n);
			if (list.length==0) {
				list=new LineSegment2DIndices[1];
				list[0]=addition.clone();
				insertionorder=new long[1];
				insertionorder[0]=addition.hashvalue;
				nextFIFO=0;
				}
			else {
				int insertpoint;
				//If there is a possibility that the face already exists, find whether it does or not
				if ((list[0].hashvalue<=addition.hashvalue) && (list[list.length-1].hashvalue>=addition.hashvalue)){
					insertpoint=Find(addition.hashvalue);
					if (list[insertpoint].hashvalue==addition.hashvalue) insert=false; // if the face already exists we won't insert it
				} // end if
				else { 
					if (list[list.length-1].hashvalue<addition.hashvalue) insertpoint=list.length;
					else insertpoint=0;
				} // end else
				if (insert){
					LineSegment2DIndices[] returnvalue=new LineSegment2DIndices[list.length+1];
					for (int i=0;i<returnvalue.length;i++){
						if (i<insertpoint) returnvalue[i]=list[i].clone(); 
						else if (i>insertpoint)  returnvalue[i]=list[i-1].clone();
						else returnvalue[i]=addition.clone();
					} // end for
					list=returnvalue.clone();
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
	public boolean DeleteIfExist(LineSegment2DIndices target){
		boolean returnvalue=false;
		if (list.length!=0){
			target.SetHash(n);
			int index=Exists(target.hashvalue);
			returnvalue=(index!=-1);
			if (returnvalue) DeleteEntry(index,true); 
		} // end if
		return returnvalue;
	} // end method

	public LineSegment2DIndices GetFirstFIFO(){
		nextFIFO=0;
		return ExtractFIFO();
	}
	public void DeleteExtractedFIFOOrder(){
		if (nextFIFO!=0){
			long[] newinsertionorder=new long[insertionorder.length-nextFIFO];
			for (int i=nextFIFO;i<insertionorder.length;i++) newinsertionorder[i-nextFIFO]=insertionorder[i];
			insertionorder=newinsertionorder.clone();
			nextFIFO=0;
		} // end if nextFIFO!=0
	}
	
	// Gets the next face (in FIFO order) and deletes the face as well
	public LineSegment2DIndices ExtractFIFO(){
		LineSegment2DIndices returnvalue;
		if (insertionorder.length==0) returnvalue=new LineSegment2DIndices();
		else {
			int index=-1;
			while ((index==-1) && (nextFIFO<insertionorder.length)) {
				index=Exists(insertionorder[nextFIFO]);
				nextFIFO++;
			}
			if ((nextFIFO>insertionorder.length) || (index==-1)){
				// There are no more valid hashes in the array
				list=new LineSegment2DIndices[0];
				insertionorder=new long[0];
				nextFIFO=0;
				returnvalue=new LineSegment2DIndices();
			}
			else {
				returnvalue=list[index].clone();
				DeleteEntry(index, true);
				//DeleteEntry(index, false); // Note that this won't change the insertion order array. It may be done faster by calling the DeleteExtractedFIFOOrder after a number of elements have been extracted
			}
		} // end else
		return returnvalue;	
	}
	public int getLength(){
		return list.length;
	}

	
	public boolean FaceExists(LineSegment2DIndices f){
		f.SetHash(n);
		return (Exists(f.hashvalue)!=-1);
		
	}
	
	public LineSegment2DIndices GetTetrahedron(LineSegment2DIndices candidate){
		LineSegment2DIndices returnvalue=candidate.clone();
		candidate.SetHash(n);
		int index=Find(candidate.hashvalue);
		if (index!=-1) returnvalue=list[index].clone();
		return returnvalue;
	}
	
	
	public LineSegment2DIndices[] GetFullUnorderedList(){
		return list;
	}
	// These are the private methods for this class

	// Assumes the source point list is ordered by hash value and does a binary recursive search returning either the array element that contains the hash or the element to the right of where it should be inserted
	private int Find(long targethash){
		int returnvalue;
		returnvalue=Find(targethash,0,list.length);
		return returnvalue;
	}
	// This returns either the index if the target exists or -1 if it doesn't
	private int Exists(long targethash){
		int index=Find(targethash,0,list.length);
		if (index==list.length) return -1;
		else {
			if (list[index].hashvalue!=targethash) return -1;
			else return index;
		}
		
	}
	
	private int Find(long targethash, int left, int right){
		int returnvalue;
		if ((right-left)<=1){
			// Maximum of two to test, if the hashvalue exists return which one it belongs to, otherwise return the right one
			if (list.length==0) returnvalue=0;
			else if (list[left].hashvalue==targethash) returnvalue=left;
			else returnvalue=right;
		}
		else {
			// which half should we be searching in
			int mid=(left+right)/2;
			if (list[mid].hashvalue>targethash) returnvalue=Find(targethash,left,mid);
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
		LineSegment2DIndices[] returnvalue=new LineSegment2DIndices[list.length-1];
		for (int i=0;i<list.length;i++){
			if (index>i) returnvalue[i]=list[i].clone();
			if (index<i) returnvalue[i-1]=list[i].clone();
		}
		list=returnvalue.clone();
	}
} // end of class
