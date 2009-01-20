Warning this is the first release of this library.

Please read the html documentation for this library.  Start with index.html and read
the Main Page.  Next go to the Files tab and read the documentation for Fat16Config.h.
Finally go to the Classes tab and read the Fat16 class documentation.

If you wish to report bugs or have comments, send email to fat16lib@sbcglobal.net

Copy the Fat16 directory to the hardware/libraries sub-directory of the Arduino 
application directory.  It is necessary to set FAT16_PRINT_SUPPORT to zero if
you are using Arduino version 11.

The Fat16/examples directory has the following sketches.  

fat16print.pde - This sketch shows how to use the Arduino V12 Print class with Fat16.

fat16read.pde  - This sketch reads and prints the file PRINT00.TXT created by 
                 fat16print.pde or WRITE00.TXT created by fat16write.pde.

fat16tail.pde  - This sketch to reads and prints the tail of all files created
                 by fat16print.pde and fat16write.pde.

fat16write.pde - This sketch creates a new file and writes 100 lines to the file.

GPSLogger_mem.pde - The original version of Ladyada's GPS logger with the addition
                 of a function to print the amount of free RAM.  Also with a 
                 mod to print both CR and LF at the end of lines.  You must 
                 have AF_SDlog installed (may require recompile of library).

GPStest.pde   -  A version Ladyada's GPS logger that has been modified to 
                 use the Fat16 library.

fat16info.pde  - This Sketch attempts to initialize an SD card and analyze its format.
                 Used for debug problems with SD cards.


To access these examples from the Arduino development environment go to:
File -> Sketchbook -> Examples -> Library-Fat16 -> <Sketch Name>

Compile, download and click on Serial Monitor to run the example.

You must use a standard SD card that has been formatted with a FAT16 file system.
