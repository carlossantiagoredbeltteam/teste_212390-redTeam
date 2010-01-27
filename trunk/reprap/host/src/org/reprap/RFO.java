/**
 * A .rfo file is a compressed archive containing multiple objects that are all to
 * be built in a RepRap machine at once.  See this web page:
 * 
 * 
 * for details.
 * 
 * This is the class that handles .rfo files.
 */
package org.reprap;
// http://www.devx.com/tips/Tip/14049

import java.io.*;
import java.nio.channels.*;
import java.util.zip.*;

import org.reprap.geometry.polygons.AllSTLsToBuild;

public class RFO {
	
	String fileName;
	String path;
	String tempDir;
	String[] names;
	String  rfoDir;
	AllSTLsToBuild astl;
	
	private RFO(String fn, AllSTLsToBuild as)
	{
		int sepIndex = fn.lastIndexOf(File.separator);
		int fIndex = fn.indexOf("file:");
		fileName = fn.substring(sepIndex + 1, fn.length());
		if(sepIndex >= 0)
		{
			if(fIndex >= 0)
				path = fn.substring(fIndex + 5, sepIndex + 1);
			else
				path = fn.substring(0, sepIndex + 1);
		} else
			path = "";
		tempDir = System.getProperty("java.io.tmpdir") + File.separator;
		System.out.println("Name: " + fileName);
		System.out.println("Path: " + path);
		System.out.println("Temp: " + tempDir);
		
		astl = as;
	}
	
	//****************************************************************************
	//
	// .rfo writing
	
	private void createRFOdir()
	{
		rfoDir = tempDir + fileName;
		File rfod = new File(rfoDir);
		if(!rfod.mkdir())
			throw new RuntimeException(rfoDir);
		rfoDir += File.separator;
	}
	
	private void copyFile(String from, String to) throws IOException
	{
		File inputFile;
	    File outputFile;
		int fIndex = from.indexOf("file:");
		int tIndex = to.indexOf("file:");
		if(fIndex < 0)
			inputFile = new File(from);
		else
			inputFile = new File(from.substring(fIndex + 5, from.length()));
		if(tIndex < 0)
			outputFile = new File(to);
		else
			outputFile = new File(to.substring(tIndex + 5, to.length()));

	    BufferedInputStream in = new BufferedInputStream(new FileInputStream(inputFile), 4096);
	    BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(outputFile), 4096);
	    int c;

	    while ((c = in.read()) != -1)
	      out.write(c);

	    in.close();
	    out.close();		
	}
	
	private void copySTLs() throws IOException
	{
		names = new String[astl.size()];
		String[] uniqueNames = new String[astl.size()];
		int uniqueP = 0;

		for(int i = 0; i < astl.size(); i++)
		{
			String s = astl.get(i).fileItCameFrom();
			int ni = -1;
			for(int j = 0; j < uniqueP; j++)
			{
				if(s.matches(uniqueNames[j]))
				{
					ni = j;
					break;
				}
			}
			if(ni < 0)
			{
				uniqueNames[uniqueP] = s;
				names[i] = "rfo-" + uniqueP + ".stl";
				uniqueP++;
			} else
			{
				names[i] = uniqueNames[ni];
			}
		}
		
		for(int i = 0; i < uniqueP; i++)
			copyFile(uniqueNames[i], rfoDir + "rfo-" + i + ".stl");
	}
	
	private void createLegend()
	{
		
	}
	
	private void compress()
	{
		
	}
	
	public static void save(String fn, AllSTLsToBuild allSTL) throws IOException
	{
		RFO rfo = new RFO(fn, allSTL);
		rfo.createRFOdir();
		rfo.copySTLs();
		rfo.createLegend();
		rfo.compress();
		System.out.println("Save RFO called with: " + fn);
	}
	
	//******************************************************************************************
	//
	// .rfo reading
	
	private void unCompress()
	{
		
	}
	
	private void interpretLegend()
	{
		
	}
	
	public static AllSTLsToBuild load(String fn)
	{
		RFO rfo = new RFO(fn, null);
		rfo.unCompress();
		rfo.interpretLegend();
		System.out.println("Load RFO called with: " + fn);
		return rfo.astl;
	}
//http://code.google.com/p/darkstar-contrib/source/browse/trunk/darkstar-integration-test/src/main/java/net/orfjackal/darkstar/integration/util/TempDirectory.java
//	
//String dirName = System.getProperty("java.io.tmpdir");
//
//	try 
//	{ 
//	    //create a ZipOutputStream to zip the data to 
//	    ZipOutputStream zos = new 
//	           ZipOutputStream(new FileOutputStream(".\\curDir.zip")); 
//	    //assuming that there is a directory named inFolder (If there 
//	    //isn't create one) in the same directory as the one the code 
//	    runs from, 
//	    //call the zipDir method 
//	    zipDir(".\\inFolder", zos); 
//	    //close the stream 
//	    zos.close(); 
//	} 
//	catch(Exception e) 
//	{ 
//	    //handle exception 
//	} 
////	here is the code for the method 
//	public void zipDir(String dir2zip, ZipOutputStream zos) 
//	{ 
//	    try 
//	   { 
//	        //create a new File object based on the directory we 
//	        have to zip File    
//	           zipDir = new File(dir2zip); 
//	        //get a listing of the directory content 
//	        String[] dirList = zipDir.list(); 
//	        byte[] readBuffer = new byte[2156]; 
//	        int bytesIn = 0; 
//	        //loop through dirList, and zip the files 
//	        for(int i=0; i<dirList.length; i++) 
//	        { 
//	            File f = new File(zipDir, dirList[i]); 
//	        if(f.isDirectory()) 
//	        { 
//	                //if the File object is a directory, call this 
//	                //function again to add its content recursively 
//	            String filePath = f.getPath(); 
//	            zipDir(filePath, zos); 
//	                //loop again 
//	            continue; 
//	        } 
//	            //if we reached here, the File object f was not 
//	            a directory 
//	            //create a FileInputStream on top of f 
//	            FileInputStream fis = new FileInputStream(f); 
//	            create a new zip entry 
//	        ZipEntry anEntry = new ZipEntry(f.getPath()); 
//	            //place the zip entry in the ZipOutputStream object 
//	        zos.putNextEntry(anEntry); 
//	            //now write the content of the file to the ZipOutputStream 
//	            while((bytesIn = fis.read(readBuffer)) != -1) 
//	            { 
//	                zos.write(readBuffer, 0, bytesIn); 
//	            } 
//	           //close the Stream 
//	           fis.close(); 
//	    } 
//	} 
//	catch(Exception e) 
//	{ 
//	    //handle exception 
//	} 
//
//public class FileUtils{
//    public static void copyFile(File in, File out) 
//        throws IOException 
//    {
//        FileChannel inChannel = new
//            FileInputStream(in).getChannel();
//        FileChannel outChannel = new
//            FileOutputStream(out).getChannel();
//        try {
//            inChannel.transferTo(0, inChannel.size(),
//                    outChannel);
//        } 
//        catch (IOException e) {
//            throw e;
//        }
//        finally {
//            if (inChannel != null) inChannel.close();
//            if (outChannel != null) outChannel.close();
//        }
//    }
//
//    public static void main(String args[]) throws IOException{
//        FileUtils.copyFile(new File(args[0]),new File(args[1]));
//  }
//}

//
}
