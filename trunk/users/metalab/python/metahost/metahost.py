#!/usr/bin/env python

from __future__ import with_statement
import sys
import getopt
from BufferedSender import BufferedSender

if __name__ == "__main__":
    try:
        opts, argv = getopt.getopt(sys.argv[1:], "vqnhp:", ["verbose","port="])
    except getopt.error, msg:
        raise Usage(msg)


    # option processing
    verbose = False
    port = None
    for option, value in opts:
        if option in ( "-v" , "--verbose" ):
            verbose = True
            print "You have requested that verbosity be set to True"
            print "All communication with the arduino will be printed"
        elif option in ( "-p" , "--port" ):
            port = value
    
    if len(argv) < 1:
        print("Usage: " + sys.argv[0] + " <file.gcode>")
        exit(1)

    infile = argv[0]
    print("Printing " + infile + "...")
    f = open(infile)
    sender = BufferedSender(f, port = port, baudrate = 115200, verbose = verbose)
    sender.play()
    f.close()
