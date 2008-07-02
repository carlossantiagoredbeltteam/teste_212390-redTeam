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
			self.alive = False
			self.feedbackHandler.aborted()
		print "rral", self.alive
		if self.alive:
			self.toolhead.prepare()
			self.feedbackHandler.setStatus("Starting plot...")
		
		# Start plot
		x2, y2 = 0, 0
		for ip, poly in enumerate(self.polygons):
			if not self.alive:
				self.feedbackHandler.aborted()
				break
			progress = int( float(ip) / float( len(self.polygons) ) * 100 )
			self.feedbackHandler.setStatus("Plotting polygons..." + str(progress) + "%")
			x1, y1 = poly.points[0]
			# If we are not in the polygon start place, switch off tool and move there
			if (x1 != x2) or (y1 != y2):
				self.toolhead.stop()
				self.cartesianMove(x1, y1, None)
			# Start tool
			self.toolhead.start()
			# Plot polygon
			for p in poly.points[ 1: ]:
				if not self.alive:
					self.feedbackHandler.aborted()
					break
				x2, y2 = p
				# If we need to move somwhere, do it
				if (x1 != x2) or (y1 != y2):
					self.cartesianMove(x2, y2, None)
			x1, y1 = x2, y2
		
		self.toolhead.stop()
		self.toolhead.idle()
		reprap.cartesian.homeReset()
		reprap.cartesian.free()
		reprap.closeSerial()
		
		if self.alive:
			# Tell gui that plot is complete (redraw screen)
			print "reprap call complete"
			self.feedbackHandler.plotComplete()
	
	
	# Translate a cartesian movement into whatever the output plugin does with it (called locally and by toolhead)
	def cartesianMove(self, x, y, z, units = reprap.UNITS_MM):
		if units == reprap.UNITS_MM:
			if x != None:
				x = int(x * self.pref_stepsPerMillimeterX)
			if y != None:
				y = int(y * self.pref_stepsPerMillimeterY)
			if z != None:
				z = int(z * self.pref_stepsPerMillimeterZ)

		reprap.cartesian.seek( (x, y, z), waitArrival = True )





