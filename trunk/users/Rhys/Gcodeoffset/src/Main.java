import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;


public class Main {

	
	public static void main(String[] args) 
	{
		BufferedReader in;
		String line, splitline[];
		int extruder=-1;
		float offsetX=0;
		float offsetY=0;
		
		float ex1_offsetX=100;
		float ex1_offsetY=100;
		
		BufferedWriter outfile;
	
	
		
		try {
			in = new BufferedReader(new FileReader("/home/ftx/Desktop/base.gcode"));
			outfile = new BufferedWriter(new FileWriter("/home/ftx/Desktop/base_fixed.gcode"));
			
			
			while((line = in.readLine()) != null)
			{
				//System.out.println(line);
				
				if(line.startsWith(";#!LAYER"))
				{
					offsetX=0;
					offsetY=0;
					outfile.write(line+"\n");
				}
				else
				if(line.startsWith("T"))
				{
					//System.out.println(line);
					extruder = Integer.parseInt(line.substring(1,2 ));
					//System.out.println("Found Extruder: " + extruder);
					if(extruder == 1)
					{
						offsetX=ex1_offsetX;
						offsetY=ex1_offsetY;
					}
					else
					{
						offsetX=0;
						offsetY=0;
					}
					outfile.write(line+"\n");
				}
				else
				if(line.startsWith("G1"))
				{
					splitline = line.split(" ");
					float xcords=0, ycords=0;
					
					for(int i=0; i<splitline.length; i++)
					{
						if(splitline[i].startsWith("X"))
						{
							xcords = Float.parseFloat(splitline[i].substring(1))+offsetX;
							splitline[i] = "X"+xcords;
						}
						if(splitline[i].startsWith("Y"))
						{
							ycords = Float.parseFloat(splitline[i].substring(1))+offsetY;
							splitline[i] = "Y"+ycords;
						}
	
					}
					
					line = "";
					
					for(int i=0; i<splitline.length; i++)
					{
						line += splitline[i]+" ";
					}
					
					outfile.write(line+"\n");
					
				}
				else
				{
					outfile.write(line+"\n");
					
				}
			}
			
			outfile.close();
		}
		catch(Exception e)
		{
			
		}
		
	}
}
