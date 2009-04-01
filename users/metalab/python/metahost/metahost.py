#!/usr/bin/env python

from __future__ import with_statement
import sys
import getopt
from BufferedSender import BufferedSender

if __name__ == "__main__":
    # optlist, args = getopt(sys.argv[1:], "");
    if len(sys.argv) < 2:
        print("Usage: " + sys.argv[0] + " <file.gcode>")
        exit(1)
    infile = sys.argv[1]
    print("Printing " + infile + "...")
#    with open(infile) as f:
#        for line in f:
#            line = line.strip()
#            if len(line) == 0: continue;
#            print(line)

    f = open(infile)

    sender = BufferedSender(f, verbose=False)
    sender.play()

    f.close()
