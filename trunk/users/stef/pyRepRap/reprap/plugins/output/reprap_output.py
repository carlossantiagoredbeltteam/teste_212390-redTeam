#!/usr/bin/env python

import threading, reprap, reprap.preferences
from reprap_prefpanel import PreferencesPanel

Title = "Serial SNAP RepRap"
FileOutput = False

class output(reprap.baseplotters.ExportPlotter):
	# Load plotter preferences
	def loadPreferences(self):
		# Default preferences
		self.pref_stepsPerMillimeterX, pref_stepsPerMillimeterY, pref_stepsPerMillimeterZ = 30, 30, 30
		self.pref_limitX, self.pref_limitY = 0, 0
		self.pref_enableLimit = False
		self.pref_torque = 65
		self.pref_speed = 180
		self.pref_serialPort = 0
		self.pref_baudRate = 19200
		self.pref_timeout = 60
		
		# Load preferences from file
		self.prefHandler = reprap.preferences.PreferenceHandler(self,  "output_reprap.conf")
		self.prefHandler.load()
	
	# Start plot (as new thread)
	def run(self):
		self.alive = True
		
		self.feedbackHandler.setStatus("Configuring RepRap...")
		if self.pref_enableLimit:
			reprap.cartesian.x.limit = self.pref_limitX
			reprap.cartesian.y.limit = self.pref_limitY
		else:
			reprap.cartesian.x.limit = 0
			reprap.cartesian.y.limit = 0
		
		# Prepare reprap for use
		
		if reprap.openSerial( self.pref_serialPort, self.pref_baudRate, self.pref_timeout ):	# Initialise serial port.
			reprap.cartesian.x.active = True	    											# These devices are present in network, will automatically scan in the future.
			reprap.cartesian.y.active = True
			reprap.cartesian.z.active = True
			reprap.cartesian.x.setNotify()
			reprap.cartesian.y.setNotify()
			reprap.cartesian.z.setNotify()
			print "st", self.pref_speed, self.pref_torque
			reprap.cartesian.setMoveSpeed(self.pref_speed)
			reprap.cartesian.setPower(self.pref_torque)
			self.feedbackHandler.setStatus("Reseting axies...")
			reprap.cartesian.homeReset()
		else:
			# TODO - create a message feedback system to the gui for popups / statusbar?
			#print , "pyRepRap Serial Port Error"
			self.feedbackHandler.showMessagePopup("You do not have the required permissions to access the serial port.\nTry granting your user permissions (recommended) or run as root (less recommended).")
		
		# Start plot
		self.feedbackHandler.setStatus("Starting plot...")
		for poly in self.polygons:
			x1, y1 = poly.points[0]
			self.cartesianMove(x1, y1, False)
			self.toolhead.start()
			for p in poly.points[ 1: ]:
				x2, y2 = p
				if (x1 != x2) or (y1 != y2):
					self.cartesianMove(x2, y2, False)
			x1, y1 = x2, y2
			self.toolhead.stop()
		reprap.cartesian.homeReset()
		reprap.cartesian.free()
		reprap.closeSerial()
	
	# Translate a cartesian movement into whatever the output plugin does with it (called locally and by toolhead)
	def cartesianMove(self, x, y, z, units = reprap.UNITS_MM):
		if units == reprap.UNITS_MM:
			x, y, z = int(x * self.pref_stepsPerMillimeterX), int(y * self.pref_stepsPerMillimeterY), int(z * self.pref_stepsPerMillimeterZ)
		reprap.cartesian.seek( (x, y, z), waitArrival = True )
		




