@echo off
rem runs Reprap Java 3d-scanning plugin with an appropriate classpath

setlocal
rem Amount of RAM to allow Java
set RAM_SIZE=1024M

rem build up classpath
set CLASSPATH=.\CarapaceCopier.jar
set CLASSPATH=%CLASSPATH%;.\lib\swing-layout-1.0.3.jar
set CLASSPATH=%CLASSPATH%;.\lib\jama-1.0.2.jar
set CLASSPATH=%CLASSPATH%;.

rem This is where the libraries are installed
set LD_LIBRARY_PATH=".\lib"

rem invoke the code
java -cp %CLASSPATH% -Xmx%RAM_SIZE% org.reprap.scanning.GUI.Main
rem java -cp %CLASSPATH% -Xmx%RAM_SIZE% org.reprap.scanning.GUI.Main "non\default\folder\for\scanning.properties"

