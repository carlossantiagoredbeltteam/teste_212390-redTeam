package org.reprap.pcb;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.File;
import org.reprap.Extruder;
import org.reprap.Attributes;
import org.reprap.geometry.polygons.*;

//import java.io.IOException;

public class PCB {
	
	GerberGCode gerberGcode; 
	String[] splitline;
	boolean debug = true;

	BufferedReader in;
	String line;
	String formatX = "23", formatY="23";

	double scale = 1;


	// Config
	double penWidth = 0.7f;		
	double offsetX=40;
	double offsetY=40;
	int XYFeedrate = 1000;
	int ZFeedrate = 70;
	double drawingHeight = 1.8f;
	double freemoveHeight = 3.8f;//1.7f;
	/**
	 * @param args
	 */
	public void pcb(File inputFile, File outputFile, Extruder pcbPen) {

		// Config end


		penWidth = pcbPen.getExtrusionSize();
		System.out.println("Gerber RS274X to GCoder Converter for RepRap\n");


		System.out.println("Input: " + inputFile.getName());
		System.out.println("Output: " + outputFile.getName()+"\n");
		System.out.println("Pen Width: " + penWidth + " mm");
		System.out.println("Offset X: " + offsetX + " mm");
		System.out.println("Offset Y: " + offsetY + " mm");
		System.out.println("Drawing Height: " + drawingHeight + " mm");
		System.out.println("Freemove Height: " + freemoveHeight + " mm\n");

		gerberGcode = new GerberGCode(penWidth, null); //, drawingHeight, freemoveHeight, XYFeedrate, ZFeedrate);
		
		RrRectangle box = new RrRectangle();

		// processing Gerber file
		try {
			in = new BufferedReader(new FileReader(inputFile));

			while((line = in.readLine()) != null)
			{
				RrRectangle r = processLine(line);
				if(r != null)
					box = RrRectangle.union(box, r);
			}
			if(debug)
				System.out.println("Surrounding reactangle: " + box);
			in.close();
			
			in = new BufferedReader(new FileReader(inputFile));
			
			gerberGcode = new GerberGCode(penWidth, new BooleanGrid(RrCSG.nothing(), box, new Attributes(null, null, null, pcbPen.getAppearance())));

			while((line = in.readLine()) != null)
			{
				processLine(line);
			}


			//System.out.println(gerberGcode.getGCode());

//			BufferedWriter outfile;

//			outfile = new BufferedWriter(new FileWriter(outputFile));
//			outfile.write(gerberGcode.getPolygons());
//			outfile.close();

			gerberGcode.getPolygons();
			
			System.out.println("GCode file generated succesfully !");

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}



	}
	
	private RrRectangle processLine(String line)
	{
		if(debug) System.out.println(line);
		
		RrRectangle result = null;

		if(line.startsWith("%FSLA"))
		{

			formatX = line.substring(6, 8);
			formatY = line.substring(9, 11);
			if(debug) System.out.println("Format X: " + formatX + " Format Y: " + formatY);
		}
		else
			if(line.startsWith("%ADD"))
			{
				String apertureNum, apertureType, apertureSize;


				line = line.substring(4, line.length()-2);
				apertureNum = line.substring(0, 2); 

				line = line.substring(2);
				splitline = line.split(",");
				apertureType = splitline[0];
				apertureSize = splitline[1]; 

				if(debug) 
				{
					System.out.println("\n\nAparture: " + apertureNum);
					System.out.println("Type: " + apertureType);
				}

				if(apertureType.equals("C"))
				{
					double s = scale*Double.parseDouble(apertureSize);
					gerberGcode.addCircleAperture(Integer.parseInt(apertureNum), s);
					if(debug) 
						System.out.println("Size: " + s + " mm");
				}
				else
					if(apertureType.equals("R"))
					{

						String rectSides[] = apertureSize.split("X");
						double x = scale*Double.parseDouble(rectSides[0]);
						double y = scale*Double.parseDouble(rectSides[1]);

						gerberGcode.addRectangleAperture(Integer.parseInt(apertureNum), x, y);
						if(debug) 
							System.out.println("Size: " + x + "x" + y + "mm x mm");
					}
					else
						if(apertureType.equals("OC8"))
						{
							gerberGcode.addCircleAperture(Integer.parseInt(apertureNum), scale*Double.parseDouble(apertureSize));							
						}
						else
						{
							System.out.println(" [-] aparture type: " + apertureType + " not supported [" + line+"]\n");
							//System.exit(-1);
						}

			}
			else
				if(line.startsWith("G90"))
				{
					gerberGcode.enableAbsolute();
					if(debug)
						System.out.println("Absolute coordinates");
				}
				else
					if(line.startsWith("G91"))
					{
						gerberGcode.enableRelative();
						if(debug)
							System.out.println("Relative coordinates");
					}
					else
						if(line.startsWith("G70"))
						{
							scale = 25.4;
							if(debug)
								System.out.println("Inches");
						}
						else
							if(line.startsWith("G71"))
							{
								scale = 1;
								if(debug)
									System.out.println("Metric");
							}
							else
								if(line.startsWith("G54"))
								{
									int aperture;

									aperture = Integer.valueOf(line.substring(4, line.length()-1).trim());
									gerberGcode.selectAperture(aperture);
									if(debug)
										System.out.println("Apature: " + aperture + " selected.");

								}
								else
									if(line.startsWith("X"))
									{
										double x, y;
										int d;
										int divFactorX = (int)Math.pow(10.0,Integer.parseInt(formatX.substring(1)));
										int divFactorY = (int)Math.pow(10.0,Integer.parseInt(formatY.substring(1)));

										x = scale*Double.valueOf(line.substring(1, line.indexOf("Y")))/divFactorX;
										y = scale*Double.valueOf(line.substring(line.indexOf("Y")+1, line.indexOf("D")))/divFactorY;
										d = Integer.valueOf(line.substring(line.indexOf("D")+1, line.indexOf("D")+3));

										x += offsetX;
										y += offsetY;

										if(debug)
											System.out.println(" X: "+x+" Y:"+y+" D:"+d);

										if(d==1)
										{
											result = gerberGcode.drawLine(new Rr2Point(x, y));
										}
										else
											if(d==2)
											{
												gerberGcode.goTo(new Rr2Point(x, y));
											}	
											else
												if(d==3)
												{
													result = gerberGcode.exposePoint(new Rr2Point(x, y));
												}
									}
									else
										if(line.startsWith("D"))
										{
											int aperture;

											aperture = Integer.valueOf(line.substring(1, 3));
											gerberGcode.selectAperture(aperture);
											if(debug)
												System.out.println("Apature: " + aperture + " selected.");
										}
		return result;
	}
}
