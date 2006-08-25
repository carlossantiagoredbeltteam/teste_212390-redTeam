#!/bin/sh
# Does lots of pokes, hopefully getting a response at some point.
stty -F /dev/ttyUSB0 -echo -cooked
while (true)
do
	echo 6|./poke -d 8 -t /dev/ttyUSB0 -v -w &
	sleep 2
	killall -KILL poke
done
