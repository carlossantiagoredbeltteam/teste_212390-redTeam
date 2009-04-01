class MetaHost:
        def __init__(self, serialPort, verbose=False):
		"""
			Opens the serial port and prepares for writing.
			port MUST be set, and values are operating system dependant.
		"""
		self._verbose = verbose
                self.lines = []
                # pointing to the command that will be sent next
                self.sendIndex = 0
                # pointing to the command which will be acknoledged by the next ok
                self.okIndex = 0
                self.sentBufferSize = 0
                self.BUFFERMAX = 128

		self.ser = serialPort

		if self._verbose:
			print >> sys.stdout, "Serial Open?: " + str(self.ser.isOpen())
			print >> sys.stdout, "Baud Rate: " + str(self.ser.baudrate)

                

        def write(self, line):
                self.lines.appen(line)

        def send(self):
                while (self.sendIndex < len(self.lines)):
                        # fill buffer
                        while (self.sendIndex < len(self.lines) && self.bufferSize < self.BUFFERMAX):
                                line = self.lines[self.sendIndex];
                                if len(line) < self.BUFFERMAX - self.bufferSize:
                                        self.ser.send(line)
                                        self.sendIndex += 1
                                        self.bufferSize += len(l)
                                        if self._verbose:
                                            print "sent: ", line
                                else:
                                        break # dont block anymore when buffer is full
                                
                        if (self.sendIndex >= len(self.lines):
                                break #dont block if there is nothing to send
                                    
                        while (self.ser.available()):
                            line = self.ser.readLine()
                            if self._verbose:
                                print "received: ", line
                            
                            if (line.startsWith("echo:")):
                                echo = line.sub(5)
                                if (echo != self.lines[self.okIndex]):
                                    print "Mismatch at index: ", self.okIndex, "sent: ", self.lines[self.okIndex], " but got: ", echo
                            else if (line.startsWith("ok")):
                                    self.sentBufferSize -= len(self.lines[self.okIndex])
                                    self.okIndex += 1
                            else:
                                print "unexpected serial line: ", line

                            
                            
