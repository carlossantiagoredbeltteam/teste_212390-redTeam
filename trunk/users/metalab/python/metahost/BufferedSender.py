import sys
import SerialFactory

# The iterator should produce lines of gcode
class BufferedSender:
    def __init__(self, iterator, port, verbose=False):
        """
            Opens the serial port and prepares for writing.
            port MUST be set, and values are operating system dependant.
        """
        self.iterator = iterator
        self.verbose = verbose
        self.bufferedlengths = []
        self.bufferedlines = []     # for debugging
        self.bufferavail = 128
        self.nextline = ""
        self.BUFFERMAX = 128

        self.serial = SerialFactory.createSerialPort(port,verbose=True)

        while self.serial.inWaiting(): self.serial.read()

        if self.verbose:
            print >> sys.stdout, "Serial Open?: " + str(self.serial.isOpen())
            print >> sys.stdout, "Baud Rate: " + str(self.serial.baudrate)

    def play(self):
        try:
            while True:
                # fill buffer
                while len(self.nextline) == 0 or self.nextline[0] == '(':
                    self.nextline = self.iterator.next().strip();
                # while next line fits in buffer
                while self.bufferavail >= (len(self.nextline) + 1):
                    self.serial.write(self.nextline + "\n")
                    length = len(self.nextline) + 1
                    self.bufferedlengths.append(length)
                    self.bufferedlines.append(self.nextline)
                    self.bufferavail -= length
                    if self.verbose: print("sent: ", self.nextline)
                    self.nextline = ""
                    while len(self.nextline) == 0 or self.nextline[0] == '(':
                        self.nextline = self.iterator.next().strip();
                
                while self.serial.inWaiting():
                    recvline = self.serial.readline().strip()
                    if self.verbose: print("received: ", recvline)
                
                    if recvline.startswith("echo: "):
                        echo = recvline[6:]
                        if (echo != self.bufferedlines[0]):
                            print "Mismatch: sent: ", self.bufferedlines[0], " but got: ", echo
                        self.bufferedlines.pop(0)
                        size = self.bufferedlengths.pop(0)
                        self.bufferavail += size
                    elif recvline.startswith("ok"):
                        self.bufferedlines.pop(0)
                        size = self.bufferedlengths.pop(0)
                        self.bufferavail += size
                    else:
                        print "unexpected serial line: ", recvline
        except StopIteration:
            print("EOF")

