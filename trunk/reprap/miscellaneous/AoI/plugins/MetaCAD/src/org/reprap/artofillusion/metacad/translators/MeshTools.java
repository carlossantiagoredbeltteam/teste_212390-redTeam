package org.reprap.artofillusion.metacad.translators;
/*
 * utilities for messing with triangle meshes
 */

import java.awt.Frame;
import java.util.Vector;

import artofillusion.math.Vec3;
import buoy.widget.BFrame;

/**
 * merge duplicate points
 */
public class MeshTools {
    private int matchCount = 0;
    BFrame bframe = null;
    Frame frame = null;
    private boolean debug = false;

    /**
     * constructor
     */
    public MeshTools(BFrame parent) 
    {
        super();
        bframe = parent;
        frame = (Frame)bframe.getComponent();
    }

    /**
     * constructor
     */
    public MeshTools(Frame parent) 
    {
        super();
        frame = parent;
    }

    
    /**
     * merge duplicate vertices. This should fix overlapping but 
     * not connected faces.
     * @param vert
     * @param fc
     */
    public Vec3[] mergePoints(Vec3 vert[], int fc[][]) {
        // make sure there's something to do:
        if (vert.length == 0 || fc.length == 0)
            return vert;
        
        // start the new vertex list:
        Vector newVert = new Vector();        
        newVert.add(vert[0]);
        
        // add unique to new list:
        for (int i=1; i<vert.length; i++) {
            Vec3 thisVert = vert[i];

            // if not in newVert, add it:
            int vertNum = containsVertex(newVert, thisVert);
            if (vertNum < 0) {
                newVert.add(thisVert);
                vertNum = newVert.size() -1;
            }

            // renumber any faces using this vert:
            for (int j=0; j<fc.length; j++ ) {
                if (fc[j][0] == i)
                    fc[j][0] = vertNum;
                if (fc[j][1] == i)
                    fc[j][1] = vertNum;
                if (fc[j][2] == i)
                    fc[j][2] = vertNum;
            }
        }
        
        // construct return:
        Vec3 vert2[] = new Vec3[newVert.size()];
        for (int i=0; i<newVert.size(); i++) {
            vert2[i] = (Vec3)newVert.elementAt(i);
        }
        
        if (debug) System.err.println("DEBUG found and merged " + matchCount + " duplicate vertices, out of " + vert.length);
     
        return vert2;
    }
    

    /**
     * should be called after mergePoints()
     */
    public int[][] removeDegenerates(int fc[][])
    {
        Vector newFaces = new Vector();
        matchCount = 0;

        // check each face, dropping degenerates:
        for (int j=0; j<fc.length; j++ ) 
        {
            if (fc[j][0] == fc[j][1] || fc[j][0] == fc[j][2] || fc[j][1] == fc[j][2])
                // drop this face
                matchCount++;
            else
            {
                // save face (heh):
                newFaces.add(fc[j]);
            }
        }

        // build return array:
        int fc2[][] = new int[newFaces.size()][3];
        for (int i=0; i<newFaces.size(); i++)
        {
           int v[];
           v = (int[])newFaces.elementAt(i);
           fc2[i] = v;
        }

        if (debug) System.err.println("DEBUG found and removed: " + matchCount + " degenerate faces, out of " + fc.length);
        return fc2;
    }


    /**
     * 
     * @param verts
     * @param thisVert
     * @return index number of matching vert, -1 if no match is found
     */
    private int containsVertex(Vector verts, Vec3 thisVert) {
       int contains = -1;
  
       for (int i=0; i<verts.size(); i++) {
           Vec3 thatVert = (Vec3)verts.elementAt(i);
           if (thisVert.x == thatVert.x && thisVert.y == thatVert.y && thisVert.z == thatVert.z) {
               contains = i;
               i = verts.size();
               matchCount++;               
           }
       }
       
       return contains;
    }
  
    
    /**
     * Kevin: EXPERIMENTAL
     * tries to ensure that edges are always listed in the same order. AOI wants them
     * listed in counterClockwise order. No idea how to do that, but we can at least
     * make sure they're all the same (then user can invert them all if needed).
     * This means that every edge that's shared by 2 faces should be traversed/listed
     * once in each direction.
     * The natural implementation of something like this would be to recurse over the
     * edges of each face and it's neighbors. This implementation tries to avoid the
     * memory requirements associated with a recursive approach, though it might not
     * be any faster.
     * Note that this routine changes the incoming faces list.
     * @param faces An array of vertex numbers in 3-space.
     */
    public void fixCirality(int faces[][])
    {
        // init:        
        int changeCount = 1;
        int prevChangeCount = -1;
        int done[] = new int[faces.length]; // 0 := not done
        if (faces.length == 0)
            return;
 
        // progress dialog for this mesh:  
        /*
        if (dialog == null)
            dialog = new ProgressDialog(bframe, faces.length, "Reordering edges...");                
        dialog.setProgress(0);
        if (!dialog.isAlive())
            dialog.run();
        */
                     
        while (changeCount > 0)
        {
            // reset counters:
            int badEdgeCount=0;
            changeCount = 0;
            done[0] = 1; 
            for (int i=1; i<done.length; i++) 
                done[i]= 0;  
            
            // loop over faces:
	        for (int f=0; f<faces.length; f++)
	        {
	            //dialog.setProgress(f);
	            int thisFace[] = faces[f];
		        	        	        		       
	            // get edges:
	            int edge1[] = new int[2];
	            edge1[0] = thisFace[0];
	            edge1[1] = thisFace[1];
	            int edge1Faces = 1;
	            int edge2[] = new int[2];
	            edge2[0] = thisFace[1];
	            edge2[1] = thisFace[2];
	            int edge2Faces = 1;
	            int edge3[] = new int[2];
	            edge3[0] = thisFace[2];
	            edge3[1] = thisFace[0];
	            int edge3Faces = 1;
	
	            for (int ix=0; ix<faces.length; ix++)
		        {
		            int thatFace[] = faces[ix];
		            
		            // if we haven't already done thatFace:
		            if (done[ix] == 0 && ix != f)
		            {
			            // edge1:
			            if (faceContainsEdge(thatFace, edge1)) 
			            {
		                    // invert the vertex order in that face:
		                    int tmpVertNum = thatFace[0];
		                	thatFace[0] = thatFace[1];
		                	thatFace[1] = tmpVertNum;
		                	changeCount++;
		                	edge1Faces++;
		                	
		                	// add to done list:
		                	done[ix] = 1;
		                	continue;
			            }
			            
			            // edge2:
			            if (faceContainsEdge(thatFace, edge2)) 
			            {
		                    // invert the vertex order in that face:
		                    int tmpVertNum = thatFace[0];
		                	thatFace[0] = thatFace[1];
		                	thatFace[1] = tmpVertNum;
		                	changeCount++;
		                	edge2Faces++;
		                	
		                	// add to done list:
		                	done[ix] = 1;
		                	continue;
			            }
			            
			            // edge3:
			            if (faceContainsEdge(thatFace, edge3)) 
			            {
		                    // invert the vertex order in that face:
		                    int tmpVertNum = thatFace[0];
		                	thatFace[0] = thatFace[1];
		                	thatFace[1] = tmpVertNum;
		                	changeCount++;
		                	edge3Faces++;
		                	
		                	// add to done list:
		                	done[ix] = 1;
		                	continue;
			            }	 
			            
			            // if neighbor, but no change, add to done:
			            if (faceContainsInvertedEdge(thatFace, edge1))
	                    {
		                	done[ix] = 1;
		                	edge1Faces++;
		                	continue;
	                    }
			            if (faceContainsInvertedEdge(thatFace, edge2))
           	            {
		                	done[ix] = 1;
		                	edge1Faces++;
		                	continue;
	                    }
			            if (faceContainsInvertedEdge(thatFace, edge3))
           	            {
		                	done[ix] = 1;
		                	edge1Faces++;
		                	continue;
                   	    }
		            }
		            
		        } //for
			  
	            // check this face for outside edges:
	            if (edge2Faces == 1)
	            {
	                permuteVertOrder(thisFace);
	                permuteVertOrder(thisFace);
	            }
	            else if (edge3Faces == 1)
	            {
	                permuteVertOrder(thisFace);
	            }
	            
                // check for bad mesh: DELETE all but (1st) 2??
                if (edge1Faces > 2) 
                {
                    badEdgeCount++;
                    //System.err.println("MESH ERROR: edge is shared by more than 2 faces [" + edge1Faces + "]! " + edge1[0] + "--" + edge1[1]);
                }
                if (edge2Faces > 2) 
                {
                    badEdgeCount++;
                    //System.err.println("MESH ERROR: edge is shared by more than 2 faces [" + edge2Faces + "]! " + edge2[0] + "--" + edge2[1]);
                }
                if (edge3Faces > 2)
                {
                    badEdgeCount++;
                    //System.err.println("MESH ERROR: edge is shared by more than 2 faces [" + edge3Faces + "]! " + edge3[0] + "--" + edge3[1]);
                }

	        } //for
	        if (debug) System.out.print("reorded edges in " + changeCount + " of " + faces.length + " faces.");
	        if (debug) System.out.println(" Found " + badEdgeCount + " edges being shared by more than 2 faces!");
	        if (changeCount == prevChangeCount)
	        {
	            if (debug) System.out.print("not making progress, so giving up!");
	            changeCount = 0;
	        }
	        prevChangeCount = changeCount;
        } //while        
   }
 
    
    /**
     * Utility to indicate whether the indicated face (list of 3 vertex indexes)
     * includes the indicated edge (list of 2 vertex indexes) in the opposite order.
     * @param face
     * @param edge
     * @return
     */
    private boolean faceContainsInvertedEdge(int[]face, int[] edge)
    {
        boolean match = false;
        
        // bail out on degenerate faces:
        if (face[0] == face[1] || face[0] == face[2] || face[1] == face[2])
            return false;
        
        // edge 1 of the face:     
        if (face[0] == edge[1] && face[1] == edge[0])
            return true;
        
        // edge 2 of the face:
        if (face[1] == edge[1] && face[2] == edge[0])
            return true;

        // edge 3 of the face:
        if (face[2] == edge[1] && face[0] == edge[0])
            return true;
             
        return match;
    }

    
    /**
     * Utility to indicate whether the indicated face (list of 3 vertex indexes)
     * includes the indicated edge (list of 2 vertex indexes).
     * 
     * @param face
     * @param edge
     * @return
     */
    private boolean faceContainsEdge(int[] face, int[] edge)
    {
       int[] invEdge = new int[2];
       invEdge[0] = edge[1];
       invEdge[1] = edge[0];
       
       return faceContainsInvertedEdge(face, invEdge);       
    }

    
    /**
     * Right-shift the values in the vertex list
     * (a,b,c) --> (c,a,b) 
     * @param face An array of 3 vertex indexes
     */
    private void permuteVertOrder(int[] face)
    {
        int old0 = face[0];
        int old1 = face[1];
        
        face[0] = face[2];
        face[1] = old0;
        face[2] = old1;
                
        return;
    }
    
    
    /**
     * If any edge has more than 2 faces using it, remove the extras.
     * @param fc  List fo faces
     * @param edge
     * @return
     *
    private int[][] removeExtraFaces(int faces[][])
    {
        // new faces:
        int dropCount = 0;
        int fc2[][] = new int[][3];
        
        for (int f=0; f<faces.length; f++)
        {           
            int thisFace[] = faces[f];
	        	        	        		       
            // get edges:
            int edge1[] = new int[2];
            edge1[0] = thisFace[0];
            edge1[1] = thisFace[1];
            int edge1Faces = 1;
            int edge2[] = new int[2];
            edge2[0] = thisFace[1];
            edge2[1] = thisFace[2];
            int edge2Faces = 1;
            int edge3[] = new int[2];
            edge3[0] = thisFace[2];
            edge3[1] = thisFace[0];
            int edge3Faces = 1;
        
            Vector newFaces = new Vector();
            for (int ix=0; ix<faces.length; ix++)
	        {
	            int thatFace[] = faces[ix];
	            int faceCount = 0;
	            
	            // if doesn't contain edge, or 1st 2, add to list
	            if (faceContainsEdge(thatFace, edge1))
	            {
	                faceCount++;
	                if (faceCount < 2) 
	                {
	                    newFaces.add(faces[ix]);
	                }
	                else 
	                {
	                    dropCount++;	                    
	                }
	            }
	            
	        }
        }
        
        return fc2;        
    }
    */
}
