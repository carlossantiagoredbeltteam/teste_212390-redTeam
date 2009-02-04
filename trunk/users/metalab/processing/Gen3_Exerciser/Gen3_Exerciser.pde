// Yep, this is actually -*- Java -*-

import processing.serial.*;


// The serial port
Serial myPort;
String serialLine = "";

boolean started = true;
boolean finished = false;
boolean commandComplete = true;
int commandCount = 0;

String temperature = "?";
String debug = "";
float feedrate = 200;

String gcode[] = {
};
int gcodeIndex = 0;

public Sanguino3GDriver driver;

void setup()
{
  //init stuff
  size(1024, 600);

  driver = new Sanguino3GDriver();
  driver.setInitialized(false);
  driver.initialize(this);
}

void draw()
{
  String cmd;

  background(20, 20, 20);

  while (driver.serial.available() > 0) {  
    int inByte = driver.serial.read();

    if (inByte == '\n') {
      println("Got: " + serialLine);
      serialLine = "";
    }
    else if (inByte > 0) {
      serialLine += (char)inByte;
    }
  }

  getNextCommand();

  PFont font;
  font = loadFont("ArialMT-48.vlw"); 
  textFont(font, 16);
  String temp = "Temperature: " + temperature + "C";
  temp += "\nTarget: " + targetTemp + "C";
  temp += "\nDC Speed: " + motorSpeed + "C";
  temp += "\nFeedrate: " + feedrate + " mm/min.             < >: dec/inc feedrate";
  text(temp, 10, 20);
  temp = "Status: " + debug + "\n";
  text(temp, 300, 20);

  temp =
    "Keys:\n";
  text(temp, 10, 100);

  temp = 
    "a: -X\n" +
    "d: +X\n" +
    "w: +Y\n" +
    "s: -Y\n" +
    "q: +Z\n" +
    "z: -Z\n";
  text(temp, 10, 120);

  temp = 
    "u: Set temp to 225\n" +
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
int motorSpeed = 130;

String getNextCommand()
{
  String c = null;
  if (keyPressed) { 
    switch (key) { 
    case '>':
      feedrate+=10;
      break;
    case '<':
      feedrate-=10;
      break;

    case 'e':
      c = "G21 (mm)";
      break;

    case 'r':
      c = "G90 (abs)";
      break;

      //case 'y':
      //  c = "G92 (set home)";
      //  break;

      // X axis
    case 'a':
      c = "G1 X-10 Y0 Z0 F" + int(feedrate);
      break;
    case 'd':
        Point3d delta = new Point3d(10, 0, 0);
        driver.queueDelta(delta);
      break;
    case 'A':
      c = "G1 X-1 Y0 Z0 F150";
      break;
    case 'D':
      c = "G1 X1 Y0 Z0 F150";
      break;
      // Y axis
    case 'w':
      c = "G1 X0 Y10 Z0 F" + int(feedrate);
      break;
    case 's':
      c = "G1 X0 Y-10 Z0 F" + int(feedrate);
      break;
    case 'W':
      c = "G1 X0 Y1 Z0 F150";
      break;
    case 'S':
      c = "G1 X0 Y-1 Z0 F150";
      break;
      // Z axis
    case 'q':
      c = "G1 X0 Y0 Z2 F150";
      break;
    case 'Q':
      c = "G1 X0 Y0 Z0.05 F30";
      break;
    case 'z':
      c = "G1 X0 Y0 Z-2 F150";
      break;
    case 'Z':    
      c = "G1 X0 Y0 Z-0.05 F30";
      break;

      // Temp    
    case 'u':
      targetTemp = 210;
      c = "M104 S" + targetTemp;
      break;
    case 'p':
      targetTemp += 5;
      c = "M104 S" + targetTemp;
      break;
    case 'l':
      targetTemp -= 10;
      c = "M104 S" + targetTemp;
      break;    
    case 't':
    case 'T':
      c = "M105 (get current temp)";
      break;

      // Motor
    case 'i':
      motorSpeed += 1;
      c = "M108 S" + motorSpeed;
      break;
    case 'j':
      motorSpeed -= 1;
      c = "M108 S" + motorSpeed;
      break;

      // Extruder    
    case 'm':
      c = "M101 (extruder on)";
      break;
    case 'n':
    case ' ':
      c = "M103 (extruder off)";
      break;
    case 'b':
      c = "M102 (extruder reverse)";
      break;

      // Cooling
    case 'f':
      c = "M106 (cooling on)";
      break;

    case 'F':
      c = "M107 (cooling off)";
      break;

      // Home
    case 'h':
      c = "G30 X0 Y0 Z0 F240";
      break;

      // Set zero
    case 'o':
      c = "G92";
      break;

      // Goto zero
    case '0':
      c = "G28 F" + int(feedrate);
      break;

    case 'y':
    case 'Y':
        driver.getVersion(2);
      break;

    }
  }

  return c;
}
