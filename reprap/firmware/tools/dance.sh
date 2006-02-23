#!/bin/sh
echo "Makes the X Stepper dance back & forth ad infinitum"
# Add your "poke" command here.
export poke="./poke -d 2 -t /dev/ttyUSB0 -v "
echo 3 0 0 | $poke
while true; do
	echo 5 200 30 1 | $poke
	sleep 2
	echo 5 200 0 0 | $poke
	sleep 2
done
