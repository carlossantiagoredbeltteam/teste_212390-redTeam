#!/bin/bash
# runs RepRap Java 3d-scanning plugin with an appropriate classpath

RAM_SIZE=1024M                     # Amount of RAM to allow Java VM to use
REPRAP_DIR=`dirname $0`

cd "$REPRAP_DIR"

# build up classpath
# when we move to OpenJDK/Java-6 these can be replaced with wildcard
# *.jar and we will not need swing-layout any more.
CLASSPATH=./CarapaceCopier.jar
CLASSPATH=$CLASSPATH:./lib/swing-layout-1.0.3.jar
CLASSPATH=$CLASSPATH:./lib/Jama-1.0.2.jar
CLASSPATH=$CLASSPATH:.

# This is where the libraries are installed
export LD_LIBRARY_PATH="./lib"

# invoke the code
java -cp $CLASSPATH  -Xmx$RAM_SIZE org.reprap.scanning.GUI.Main
#java -cp $CLASSPATH  -Xmx$RAM_SIZE org.reprap.scanning.GUI.Main "/non/default/folder/for/scanning.properties"
