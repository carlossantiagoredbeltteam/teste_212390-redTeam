import sys
import os
import SerialFactory
from time import time

class BufferedSender:
    SILENT, NORMAL, DEBUG = range(3)

    def __init__(self, files, port, baudrate, verbose = NORMAL):
        """
            Opens the serial port and prepares for writing.
            port MUST be set, and values are operating system dependant.
        """
        self.files = files
        self.verbose = verbose
        self.bufferedlengths = []
        self.bufferedlines = []     # for debugging
        self.bufferavail = 128
        self.nextline = ""
        self.BUFFERMAX = 128

        if verbose >= BufferedSender.DEBUG: serial_verbose = True
        else: serial_verbose = False
        self.serial = SerialFactory.createSerialPort(port=port, 
                                                     baudrate=baudrate, 
                                                     verbose=serial_verbose)

        # Just in case there is some leftover communication from the Arduino
        while self.serial.inWaiting(): self.serial.read()

        if self.verbose >= BufferedSender.DEBUG:
            print("Serial Open?: " + str(self.serial.isOpen()))
            print("Baud Rate: " + str(self.serial.baudrate))

        self.currtemp = 0
        self.starttime = time()
        self.totalsize = 0
        self.totalsent = 0
        self.iterators = []
        for f in files:
            try:
                self.iterators.append(open(f))
                self.totalsize += os.path.getsize(f)
            except IOError, err:
                print("Unable to open file " + f)
        if self.verbose >= BufferedSender.DEBUG:
            print("Total size: " + str(self.totalsize) + " bytes");

    def printProgress(self):
        if self.totalsent > 10000:
            remainingtime = (time() - self.starttime) / self.totalsent * (self.totalsize - self.totalsent)
            seconds = "%02d" % (remainingtime % 60)
            minutes = "%02d" % (int(remainingtime / 60) % 60)
            hours = "%2d" % (int(remainingtime / 3600))
        else:
            hours = "??"
            minutes = "??"
            seconds = "??"
        print "(%4.1f%%) ETA %s:%s:%s T: %3d\10\10\10\10\10\10\10\10\10\10\10\10\10\10\10\10\10\10\10\10\10\10\10\10\10\10\10\10" % (100.0*self.totalsent/self.totalsize, hours, minutes, seconds, self.currtemp),
        sys.stdout.flush()
        
    def play(self):
        if self.verbose >= BufferedSender.NORMAL: print "Printing ",
        for iter in self.iterators:
            try:
                while True:
                    # fill buffer
                    while len(self.nextline) == 0 or self.nextline[0] == '(':
                        self.nextline = iter.next().strip();
                    # while next line fits in buffer
                    while self.bufferavail >= (len(self.nextline) + 1):
                        self.serial.write(self.nextline + "\n")
                        length = len(self.nextline) + 1
                        self.bufferedlengths.append(length)
                        self.bufferedlines.append(self.nextline)
                        self.bufferavail -= length
                        if self.verbose >= BufferedSender.DEBUG: print("sent: " + self.nextline)
                        self.nextline = ""
                        while len(self.nextline) == 0 or self.nextline[0] == '(':
                            self.nextline = iter.next().strip();

                    while self.serial.inWaiting():
                        recvline = self.serial.readline().strip()
                        if self.verbose >= BufferedSender.DEBUG: print("received: " + recvline)

                        if recvline.startswith("echo: "):
                            echo = recvline[6:]
                            if (echo != self.bufferedlines[0]):
                                print("\nMismatch -  sent: " + self.bufferedlines[0])
                                print("         but got: " + echo)
                                self.bufferedlines.pop(0)
                                self.bufferavail += self.bufferedlengths.pop(0)
                        elif recvline.startswith("ok"):
                            self.bufferedlines.pop(0)
                            size = self.bufferedlengths.pop(0)
                            self.totalsent += size
                            self.bufferavail += size
                            if self.verbose >= BufferedSender.NORMAL:
                                self.printProgress()
                                
                        elif recvline.startswith("error: "):
                            self.bufferedlines.pop(0)
                            self.bufferavail += self.bufferedlengths.pop(0)
                            print("\n" + recvline)
                        elif recvline.startswith("T:"):
                            self.currtemp = int(recvline[2:])
                            if self.verbose >= BufferedSender.NORMAL:
                                self.printProgress()
                        else:
                            print("\nunexpected serial line: " + recvline)
            except StopIteration:
                iter.close()
        if self.verbose >= BufferedSender.NORMAL: print("(100%) ")
