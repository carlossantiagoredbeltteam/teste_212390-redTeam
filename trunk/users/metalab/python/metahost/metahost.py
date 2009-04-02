#!/usr/bin/env python

from __future__ import with_statement
import sys
import getopt
from BufferedSender import BufferedSender

def printUsage(err = None):
    if err and len(err.msg): print("Error: " + err.msg)
    print("Usage: " + sys.argv[0] + " [<args>] <file.gcode>")
    print("  FIXME: Print help about options here");
    exit(1)

if __name__ == "__main__":
    try:
        opts, argv = getopt.getopt(sys.argv[1:], "vb:p:", ["verbose", "port=", "baud="])
    except getopt.error, err:
        printUsage(err)

    # option processing
    verbose = False
    port = None
    for option, value in opts:
        if option in ( "-v" , "--verbose" ):
            verbose = True
            print "You have requested that verbosity be set to True"
            print "All communication with the arduino will be printed"
        elif option in ( "-b" , "--baud" ):
            baudrate = value
        elif option in ( "-p" , "--port" ):
            port = value
        else:
            print("Unhandled option: " + option + " " + value)
    
    if len(argv) < 1: printUsage()

    infile = argv[0]
    print("Printing " + infile + "...")
    f = open(infile)
    sender = BufferedSender(f, port = port, baudrate = baudrate, verbose = False)
    sender.play()
    f.close()
