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
    baudrate = 115200
    startfile = "warmup.gcode"
    endfile = "cooldown.gcode"
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

    infiles = [startfile]
    infiles.append(argv[0])
    infiles.append(endfile)

    print("Printing " + argv[0] + "...")

    if verbose: vlevel = BufferedSender.DEBUG
    else: vlevel = BufferedSender.NORMAL
    sender = BufferedSender(infiles, port = port, baudrate = baudrate, verbose = vlevel)
    try:
        sender.play()
    except KeyboardInterrupt:
        # Safe shutdown
        print("User break! Shutting down safely..")
        sender = BufferedSender([endfile], port = port, baudrate = baudrate, verbose = BufferedSender.SILENT)
        # FIXME: The previous play() has outstanding commands. We need to
        # wait for OK from these commands in addition to from endfile, otherwise
        # things will go wrong.
        sender.play()
        print("Shutdown complete")
