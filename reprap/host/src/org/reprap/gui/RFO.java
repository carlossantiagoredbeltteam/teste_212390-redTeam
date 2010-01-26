//package org.reprap.gui;
// http://www.devx.com/tips/Tip/14049
//
//import java.io.*;
//import java.nio.channels.*;
//import java.util.zip.*;
//
//public class RFO {
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
//}
