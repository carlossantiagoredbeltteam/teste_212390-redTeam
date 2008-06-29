#!/usr/bin/env python

import reprap
from reprap_prefpanel import PreferencesPanel

Title = "Serial SNAP RepRap"

def getPreferencePanel(parent):
	return PreferencesPanel(parent, -1)

class output:
	# These init options are not normally used as eveything is loaded out of the preference file (all parents call without)
	def __init__(	self,
					toolhead = False,
					stepsPerMillimeterX = 0.0,
					stepsPerMillimeterY = 0.0,
					stepsPerMillimeterZ = 0.0,
					limitX = 0,
					limitY = 0,
					enableLimit = False,
					torque = 0,
					speed = 0,
					serialPort = 0,
					baudRate = 0,
					timeout = 0 ):
		
		self.toolhead = toolhead
		self.pref_stepsPerMillimeterX, pref_stepsPerMillimeterY, pref_stepsPerMillimeterZ = stepsPerMillimeterX, stepsPerMillimeterY, stepsPerMillimeterZ
		self.pref_limitX, self.pref_limitY = limitX, limitY
		self.pref_enableLimit = enableLimit
		self.pref_torque = torque
		self.pref_speed = speed
		self.pref_serialPort = serialPort
		self.pref_baudRate = baudRate
		self.pref_timeout = timeout
		
		# Load preferences from file
		self.prefHandler = reprap.preferences.PreferenceHandler(self,  "output_reprap.conf")
		self.prefHandler.load()
		
		if self.pref_enableLimit:
			reprap.cartesian.x.limit = self.pref_limitX
			reprap.cartesian.y.limit = self.pref_limitY
		else:
			reprap.cartesian.x.limit = 9999999      # does not really disable limit, just makes it really big :)
			reprap.cartesian.y.limit = 9999999
		
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
			reprap.cartesian.homeReset()
			#self.setStatusBar( "RepRap Enabled" )
		else:
			# TODO - create a message feedback system to the gui for popups / statusbar?
			print "You do not have the required permissions to access the serial port. Try granting your user permissions (recommended) or run as root (not recommended).", "pyRepRap Serial Port Error"
	
	def setToolhead(self, toolhead):
		self.toolhead = toolhead
	
	# Called by toolhead
	def toolStop(self):
		pass
	
	# Called by toolhead
	def toolStart(self):
		pass
	
	# Called by shapeplotter and toolhead
	def cartesianMove(self, x, y, z, units = reprap.UNITS_MM):
		if units == reprap.UNITS_MM:
			x, y, z = int(x * self.pref_stepsPerMillimeterX), int(y * self.pref_stepsPerMillimeterY), int(z * self.pref_stepsPerMillimeterZ)
		reprap.cartesian.seek( (x, y, z), waitArrival = True )
	
	def finish(self):
		reprap.cartesian.homeReset()
		reprap.cartesian.free()
		reprap.closeSerial()




