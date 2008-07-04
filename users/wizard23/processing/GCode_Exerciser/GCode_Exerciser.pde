import processing.serial.*;


// The serial port
Serial myPort;
String serialLine = "";

boolean initialized = false;
boolean started = false;
boolean finished = false;
boolean commandComplete = true;
int commandCount = 0;

String temperature = "?";

String gcode[] = {
};
int gcodeIndex = 0;

void setup()
{
  //init stuff
  size(1024, 600);
  //smooth();

  // List all the available serial ports
  println(Serial.list());
  //open the first port...
  myPort = new Serial(this, Serial.list()[0], 19200);

  //load our gcode lines
//  gcode = loadStrings("/home/wizard23/projects/reprap/downloads/gcodestuff/cooled_rings.gcode");
  //println(gcode);
}

void draw()
{
  String cmd;
  
  background(20, 20, 20);

  while (myPort.available() > 0)
  {
    int inByte = myPort.read();

    if (inByte == '\n')
    {
      println("Got: " + serialLine);

      String m[] = match(serialLine, "^T:([0-9]+)");
      ;
      if (m != null)
        temperature = m[0];

      if (match(serialLine, "^start") != null)
        started = true;

      if (match(serialLine, "^ok") != null)
      {
        commandComplete = true;

        if (gcodeIndex == gcode.length)
          println("Job's done!");
      }

      serialLine = "";
    }
    else if (inByte > 0)
    {
      serialLine += (char)inByte;
    }
  }

  if (started)
  {
    if (commandComplete)
    {
      
      
      if (!initialized)
      {
        initialized = true;
        cmd = "G91";
      }
      else
      { 
        cmd = getNextCommand();
      }
      if (cmd != null)
      {
        commandComplete = false;
        println("Sent: " +cmd);
        myPort.write(cmd);
      }
    }
  }
  
  if (started && finished)
  {
    println("Job's done!");
    started = false;
    finished = false;
  }

  PFont font;
  font = loadFont("ArialMT-48.vlw"); 
  textFont(font, 16);
  String temp = "Temperature: " + temperature + "C";
  temp += "\nTarget: " + targetTemp + "C";
  temp += "\nDC Speed: " + motorSpeed + "C";
  text(temp, 10, 20);

  temp =
    "Keys:\n";
  text(temp, 10, 80);

  temp = 
    "a: +X\n" +
    "d: -X\n" +
    "w: +Y\n" +
    "s: -Y\n" +
    "q: +Z\n" +
    "z: -Z\n";
  text(temp, 10, 100);
    
  temp = 
    "u: Set temp to 185\n" +
    "p: Increase temp\n" +
    "l: Decrease temp\n";
  text(temp, 100, 100);

  temp = 
    "i: Increase motor speed\n" +
    "j: Decrease motor speed\n";
  text(temp, 100, 160);

  temp = 
    "m: Extruder on\n" +
    "n: Extruder off\n" +
    "b: Extruder reverse\n";
  text(temp, 100,200);
}

int targetTemp = 20;
int motorSpeed = 0;

String getNextCommand()
{
  if (keyPressed)
  { 
    String c = null;
    
    if (key == 'a')
    {
      c = "G1 X10 Y0 Z0 F450";
    }
    if (key == 'd')
    {
      c = "G1 X-10 Y0 Z0 F450";
    }
    if (key == 'w')
    {
      c = "G1 X0 Y10 Z0 F450";
    }
    if (key == 's')
    {
      c = "G1 X0 Y-10 Z0 F450";
    }
    
    if (key == 'A')
    {
      c = "G1 X1 Y0 Z0 F450";
    }
    if (key == 'D')
    {
      c = "G1 X-1 Y0 Z0 F450";
    }
    if (key == 'W')
    {
      c = "G1 X0 Y1 Z0 F450";
    }
    if (key == 'S')
    {
      c = "G1 X0 Y-1 Z0 F450";
    }
    
    // Z axis
    if (key == 'q' || key == 'Q')
    {
      c = "G0 X0 Y0 Z2 F200";
    }    
    
    if (key == 'z')
    {
      c = "G0 X0 Y0 Z-2 F200";
    }
    if (key == 'Z')
    {
      c = "G0 X0 Y0 Z-0.2 F200";
    }
    
    if (key == 'u')
    {
      targetTemp = 185;
      c = "M104 S" + targetTemp;
    }
    
     if (key == 'p')
    {
      targetTemp += 5;
      c = "M104 S" + targetTemp;
    }
    
    if (key == 'l')
    {
      targetTemp -= 10;
      c = "M104 S" + targetTemp;
    }
    

    if (key == 'i')
    {
      motorSpeed += 1;
      c = "M108 S" + motorSpeed;
    }
    
    if (key == 'j')
    {
      motorSpeed -= 1;
      c = "M108 S" + motorSpeed;
    }
    
    
    if (key == 'm')
    {
      c = "M101 (extruder on)";
    }
    
    if (key == 'n' || key == ' ')
    {
      c = "M103 (extruder off)";
    }
    
    if (key == 'b')
    {
      c = "M102 (extruder reverse)";
    }
    
    if (key == 't' || key == 'T')
    {
      c = "M105 (get current temp)";
    }
    
    if (key == 'f')
    {
      c = "M106 (cooling on)";
    }
    
    if (key == 'f')
    {
      c = "M106 (cooling on)";
    }
    
    if (key == 'F')
    {
      c = "M107 (cooling off)";
    }
    
    
    

    return c;
  }
  else
    return null;
}
