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
import java.util.Enumeration;


import org.xml.sax.XMLReader;
import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.helpers.XMLReaderFactory;
import org.xml.sax.helpers.DefaultHandler;


import javax.media.j3d.Transform3D;
import javax.media.j3d.TransformGroup;
import javax.vecmath.Matrix4d;
//import javax.vecmath.Matrix3d;
//import javax.vecmath.Point3d;
//import javax.vecmath.Tuple3d;
//import javax.vecmath.Vector3d;

import org.reprap.geometry.polygons.AllSTLsToBuild;
import org.reprap.utilities.Debug;
import org.reprap.gui.STLObject;

public class RFO 
{
	static final int top = 100;
	static final String stlPrefix = "rfo-";
	static final String stlSuffix = ".stl";
	
	//**************************************************************************************
	//
	// XML file writing
	
	class XMLOut
	{
		PrintStream XMLStream;
		String[] stack;
		int sp;
		
		XMLOut(String LegendFile, String start)
		{
			FileOutputStream fileStream = null;
			try
			{
				fileStream = new FileOutputStream(LegendFile);
			} catch (Exception e)
			{
				Debug.e("XMLOut(): " + e);
			}
			XMLStream = new PrintStream(fileStream);
			stack = new String[top];
			sp = 0;
			push(start);
		}
		
		void push(String s)
		{
			for(int i = 0; i < sp; i++)
				XMLStream.print(" ");
			XMLStream.println("<" + s + ">");
			int end = s.indexOf(" ");
			if(end < 0)
				stack[sp] = s;
			else
				stack[sp] = s.substring(0, end);
			sp++;
			if(sp >= top)
				Debug.e("RFO: XMLOut stack overflow on " + s);
		}
		
		void write(String s)
		{
			for(int i = 0; i < sp; i++)
				XMLStream.print(" ");
			XMLStream.println("<" + s + "/>");
		}
		
		void pop()
		{
			sp--;
			for(int i = 0; i < sp; i++)
				XMLStream.print(" ");
			if(sp < 0)
				Debug.e("RFO: XMLOut stack underflow.");
			XMLStream.println("</" + stack[sp] + ">");
		}
		
		void close()
		{
			while(sp > 0)
				pop();
			XMLStream.close();
		}
	}
	
	//**************************************************************************************
	//
	// XML file reading
	
	class XMLIn extends DefaultHandler
	{
		private RFO rfo;
		String element;
		String location;
		String filetype;
		String material;
		double[] mElements;
		Transform3D transform;
		
		int rowNumber = 0;
		
		XMLIn(String legendFile, RFO r)
		{
			super();
			rfo = r;
			element = "";
			location = "";
			filetype = "";
			material = "";
			mElements = new double[16];
			setMToIdentity();			
			
			XMLReader xr = null;
			try
			{
				xr = XMLReaderFactory.createXMLReader();
			} catch (Exception e)
			{
				Debug.e("XMLIn() 1: " + e);
			}
			
			xr.setContentHandler(this);
			xr.setErrorHandler(this);
			try
			{
				xr.parse(new InputSource(legendFile));
			} catch (Exception e)
			{
				Debug.e("XMLIn() 2: " + e);
			}

		}

		private void setMToIdentity()
		{
			for(rowNumber = 0; rowNumber < 4; rowNumber++)
				for(int column = 0; column < 4; column++)
				{
					if(rowNumber == column)
						mElements[rowNumber*4 + column] = 1;
					else
						mElements[rowNumber*4 + column] = 0;
				}
			transform = new Transform3D(mElements);
			rowNumber = 0;
		}
		////////////////////////////////////////////////////////////////////
		// Event handlers.
		////////////////////////////////////////////////////////////////////


		public void startDocument ()
		{
			//System.out.println("Start document");
		}


		public void endDocument ()
		{
			//System.out.println("End document");
		}


		public void startElement (String uri, String name,
				String qName, org.xml.sax.Attributes atts)
		{
			if (uri.equals(""))
				element = qName;
			else
				element = name;
			//System.out.print(element);
			if(element.equalsIgnoreCase("reprap-fab-at-home-build"))
			{
				
			} else if(element.equalsIgnoreCase("object"))
			{
				
			} else  if(element.equalsIgnoreCase("files"))
			{
				
			} else if(element.equalsIgnoreCase("file"))
			{
				location = atts.getValue("location");
				filetype = atts.getValue("filetype");
				material = atts.getValue("material");
				if(!filetype.equalsIgnoreCase("application/sla"))
					Debug.e("XMLIn.startElement(): unreconised object file type (should be \"application/sla\"): " + filetype);
				
			} else if(element.equalsIgnoreCase("transform3D"))
			{
				setMToIdentity();
			} else if(element.equalsIgnoreCase("row"))
			{
				for(int column = 0; column < 4; column++)
					mElements[rowNumber*4 + column] = Double.parseDouble(atts.getValue("m" + rowNumber + column));
			} else
			{
				Debug.e("XMLIn.startElement(): unreconised RFO element: " + element);
			}
		}


		public void endElement (String uri, String name, String qName)
		{
			if (uri.equals(""))
				element = qName;
			else
				element = name;
			if(element.equalsIgnoreCase("reprap-fab-at-home-build"))
			{
				
			} else if(element.equalsIgnoreCase("object"))
			{
				
			} else  if(element.equalsIgnoreCase("files"))
			{
				
			} else if(element.equalsIgnoreCase("file"))
			{
				STLObject stl = new STLObject();
				STLObject lastPicked = null;
				org.reprap.Attributes att = stl.addSTL("file:" + rfoDir + location, null, Preferences.unselectedApp(), lastPicked);
				att.setMaterial(material);
				stl.setTransform(transform);
				rfo.astl.add(stl);
				location = "";
				filetype = "";
				material = "";

			} else if(element.equalsIgnoreCase("transform3D"))
			{
				if(rowNumber != 4)
					Debug.e("XMLIn.endElement(): incomplete Transform3D matrix - last row number is not 4: " + rowNumber);
				transform = new Transform3D(mElements);
			} else if(element.equalsIgnoreCase("row"))
			{
				rowNumber++;
			} else
			{
				Debug.e("XMLIn.endElement(): unreconised RFO element: " + element);
			}
		}


		public void characters (char ch[], int start, int length)
		{
//			System.out.print("Characters: \"");
//			for (int i = start; i < start + length; i++) 
//			{
//				switch (ch[i]) 
//				{
//				case '\\':
//					System.out.print("\\\\");
//					break;
//				case '"':
//					System.out.print("\\\"");
//					break;
//				case '\n':
//					System.out.print("\\n");
//					break;
//				case '\r':
//					System.out.print("\\r");
//					break;
//				case '\t':
//					System.out.print("\\t");
//					break;
//				default:
//					System.out.print(ch[i]);
//				break;
//				}
//			}
//			System.out.print("\"\n");
		}

	}
	
	//**************************************************************************************
	//
	// Start of RFO handling
	
	
	String fileName;
	String path;
	String tempDir;
	int[] names;
	String  rfoDir;
	AllSTLsToBuild astl;
	XMLOut xml;
	
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
		astl = as;

		rfoDir = tempDir + fileName;
		File rfod = new File(rfoDir);
		if(!rfod.mkdir())
			throw new RuntimeException(rfoDir);
		rfoDir += File.separator;
	}
	
	//****************************************************************************
	//
	// .rfo writing
	
	
	private static void copyFile(File in, File out)
	{
		try
		{
			FileChannel inChannel = new	FileInputStream(in).getChannel();
			FileChannel outChannel = new FileOutputStream(out).getChannel();
			inChannel.transferTo(0, inChannel.size(), outChannel);
			inChannel.close();
			outChannel.close();			
		} catch (Exception e)
		{
			Debug.e("RFO.copyFile(): " + e);
		}

	}		
	
	private static void copyFile(String from, String to)
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
		//outputFile.deleteOnExit(); 
		copyFile(inputFile, outputFile);		
	}
	
	private String stlName(int i)
	{
		return stlPrefix + i + stlSuffix;
	}
	
	private void copySTLs()
	{
		names = new int[astl.size()];

		int u = 0;
		for(int i = 0; i < astl.size(); i++)
		{
			String s = astl.get(i).fileItCameFrom();
			names[i] = u;
			for(int j = 0; j < i; j++)
			{
				if(s.matches(astl.get(j).fileItCameFrom()))
				{
					names[i] = j;
					break;
				}
			}
			if(names[i] == u)
			{
				copyFile(s, rfoDir + stlName(u));
				u++;
			}
		}	
	}
	
	private void writeTransform(TransformGroup trans)
	{
		Transform3D t = new Transform3D();
		Matrix4d m = new Matrix4d();
		trans.getTransform(t);
		t.get(m);
		xml.push("transform3D");
		 xml.write("row m00=\"" + m.m00 + "\" m01=\"" + m.m01 + "\" m02=\"" + m.m02 + "\" m03=\"" + m.m03 + "\"");
		 xml.write("row m10=\"" + m.m10 + "\" m11=\"" + m.m11 + "\" m12=\"" + m.m12 + "\" m13=\"" + m.m13 + "\"");
		 xml.write("row m20=\"" + m.m20 + "\" m21=\"" + m.m21 + "\" m22=\"" + m.m22 + "\" m23=\"" + m.m23 + "\"");
		 xml.write("row m30=\"" + m.m30 + "\" m31=\"" + m.m31 + "\" m32=\"" + m.m32 + "\" m33=\"" + m.m33 + "\"");
		xml.pop();
	}
	
	private void createLegend()
	{
		xml = new XMLOut(rfoDir + "legend", "reprap-fab-at-home-build version=\"0.1\"");
		for(int i = 0; i < astl.size(); i++)
		{
			xml.push("object name=\"object-" + i + "\"");
			 xml.push("files");
			  STLObject stlo = astl.get(i);
			  xml.push("file location=\"" + stlName(names[i]) + "\" filetype=\"application/sla\" material=\"" + "PLA\"");
			   writeTransform(stlo.trans());
			  xml.pop();
			 xml.pop();
			xml.pop();
		}
		xml.close();
	}
	
	
	private void compress()
	{
		try
		{
			ZipOutputStream rfoFile = new ZipOutputStream(new FileOutputStream(path + fileName)); 
			File dirToZip = new File(rfoDir); 
			String[] fileList = dirToZip.list(); 
			byte[] buffer = new byte[4096]; 
			int bytesIn = 0; 

			for(int i=0; i<fileList.length; i++) 
			{ 
				File f = new File(dirToZip, fileList[i]); 
				FileInputStream fis = new FileInputStream(f); 
				String zEntry = f.getPath();
				zEntry = zEntry.substring(tempDir.length(), zEntry.length());
				ZipEntry entry = new ZipEntry(zEntry); 
				rfoFile.putNextEntry(entry); 
				while((bytesIn = fis.read(buffer)) != -1) 
					rfoFile.write(buffer, 0, bytesIn); 
				fis.close();
				if(!f.delete())
					Debug.e("RFO.compress(): Can't delete file: " + fileList[i]);
			}
			if(!dirToZip.delete())
				Debug.e("RFO.compress(): Can't delete directory: " + rfoDir);
			rfoFile.close();
		} catch (Exception e)
		{
			Debug.e("RFO.compress(): " + e);
		}
	}
	
	public static void save(String fn, AllSTLsToBuild allSTL)
	{
		RFO rfo = new RFO(fn, allSTL);
		rfo.copySTLs();
		rfo.createLegend();
		rfo.compress();
	}
	
	//******************************************************************************************
	//
	// .rfo reading
	
	private void unCompress()
	{
		try
		{
			byte[] buffer = new byte[4096];
			int bytesIn;
			ZipFile rfoFile = new ZipFile(path + fileName);
			Enumeration allFiles = rfoFile.entries();
			while(allFiles.hasMoreElements())
			{
				ZipEntry ze = (ZipEntry)allFiles.nextElement();
				InputStream is = rfoFile.getInputStream(ze);
				File element = new File(tempDir + ze.getName());
				FileOutputStream os = new FileOutputStream(element);
				while((bytesIn = is.read(buffer)) != -1) 
					os.write(buffer, 0, bytesIn);
				os.close();
			}
		} catch (Exception e)
		{
			Debug.e("RFO.unCompress(): " + e);
		}
	}
	
	private void interpretLegend()
	{
		XMLIn xi = new XMLIn(rfoDir + "legend", this);
		File f = new File(rfoDir + "legend");
		f.delete();
	}
	
	public static AllSTLsToBuild load(String fn)
	{
		RFO rfo = new RFO(fn, null);
		rfo.astl = new AllSTLsToBuild();
		rfo.unCompress();
		try
		{
			rfo.interpretLegend();
		} catch (Exception e)
		{
			Debug.e("RFO.load(): exception - " + e.toString());
		}
		
		File td = new File(rfo.rfoDir);
		String[] fileList = td.list(); 
		for(int i=0; i<fileList.length; i++) 
		{ 
			File f = new File(rfo.rfoDir, fileList[i]);
			if(!f.delete())
				Debug.e("RFO.AllSTLsToBuild(): Can't delete file: " + fileList[i]);
		}
		if(!td.delete())
			Debug.e("RFO.AllSTLsToBuild(): Can't delete file: " + rfo.rfoDir);
		return rfo.astl;
	}
}
