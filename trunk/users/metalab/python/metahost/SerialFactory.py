#!/usr/bin/env python

import sys
import os
import serial
import time
import glob

def createSerialPort(port=None, baudrate=115200, verbose=False):
    if port == None:
        ports = scan()
        if verbose:
            print(ports)
        if len(ports) > 0: port = ports[0]

    if port == None:
        if verbose:
            print("No serial ports found")
        return None

    if verbose:
        print("Opening serial port: " + port)

    #Timeout value 10" max travel, 1RPM, 20 threads/in = 200 seconds
    serialport = serial.Serial(port, baudrate, timeout=200)
                
    if verbose:
        print("Serial Open?: " + str(serialport.isOpen()))
        print("Baud Rate: " + str(serialport.baudrate))

    return serialport

def scan():
    """scans for available ports. returns a list filenames"""
    available = []
    for i in range(256):
        try:
            s = serial.Serial(i)
            available.append(s.portstr)
            s.close()
        except serial.SerialException, err:
            pass
    if sys.platform.lower() == 'darwin':
            macports = glob.glob("/dev/tty.usbserial-*")
            available.extend(macports);
    return available
