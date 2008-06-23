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
  gcode = loadStrings("/home/wizard23/projects/reprap/downloads/gcodestuff/cooled_rings.gcode");
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
  text(temp, 10, 20);
}

String getNextCommand()
{
  if (keyPressed)
  { 
    String c = null;
    
    if (key == 'a')
    {
      c = "G1 X10 Y0 Z0 F200";
    }
    if (key == 'd')
    {
      c = "G1 X-10 Y0 Z0 F200";
    }
    if (key == 'w')
    {
      c = "G1 X0 Y10 Z0 F200";
    }
    if (key == 's')
    {
      c = "G1 X0 Y-10 Z0 F200";
    }
    
    // Z axsis
    if (key == 'q' || kez == 'Q')
    {
      c = "G1 X0 Y0 Z10 F200";
    }    
    
    if (key == 'z')
    {
      c = "G1 X0 Y0 Z-2 F100";
    }
    if (key == 'Z')
    {
      c = "G1 X0 Y0 Z-0.2 F100";
    }
    
    return c;
  }
  else
    return null;
}
