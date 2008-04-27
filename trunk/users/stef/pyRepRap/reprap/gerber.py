#!/usr/bin/python

"""
Licenced under GNU v2 and the 'I'm not going to help you kill people licence'. The latter overrules the former.
        
I'm not going to help you kill people licence v1:
The use of this software in any form for any purposes relating to any form of military activity or
research either directly or via subcontracts is strictly prohibited.
Any company or organisation affiliated with any military organisations either directly or through
subcontracts are strictly prohibited from using any part of this software.

GNU licence:        
RepRap Gerber Plotter is free software; you can redistribute it and/or modify it 
under the terms of the GNU General Public License as published by the Free Software Foundation; 
either version 2 of the License, or (at your option) any later version.

RepRap Gerber Plotter is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
See the GNU General Public License for more details. You should have received a copy of 
the GNU General Public License along with File Hunter; if not, write to 
the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
"""

import reprap, pygame, thread, time, math, sys, threading
import plotter


units = "MM"		# Default. Value set by gerber file, TODO put this into class
const_mmPerInch = 25.4

FS_ABSOLUTE = 1		# coordinate modes
FS_INCREMENTAL = 2

keepGraphicsOpen = True

# Class for gerber aperture. Reads line from gerber file and extracts code, type & modifiers
class aperture:
	def __init__( self, paramString, units ):
		commorPos = paramString.find( ',' )
		self.code = int( paramString[ 3 : commorPos - 1 ] )
		self.apertureType = paramString[ commorPos - 1 : commorPos ]
		modString = paramString[ commorPos + 1 : -1 ]
		self.modifiers = []
		lastDiv = 0
		divPos = modString.find( 'X' )
		while divPos > 0:
			self.modifiers.append( modString[ lastDiv : divPos ] )
			modString = modString[ divPos + 1 : ]
			lastDiv = divPos
			divPos = modString.find( 'X' )
		self.modifiers.append( float(modString) )

		if self.apertureType == "C":
			self.radius = ( float( self.modifiers[0] ) / 2 )		# convert from diameter
			if units == "IN":
				self.radius = self.radius * const_mmPerInch
		elif self.apertureType == "R":
			self.width = float( self.modifiers[0] )
			self.height = float( self.modifiers[1] )
			if units == "IN":
				self.width = self.width * const_mmPerInch
				self.height = self.height * const_mmPerInch

# merge lineplot? TODO
# Class to plot gerber file to screen and / or reprap
class gerberPlotter(threading.Thread):
	def run(self):
		self.stayRunning = True
		f = open( self.fileName, 'r' )
		lines = f.readlines()
		self.parseLines(lines)

	def terminate(self):
		self.stayRunning = False
		self.linePlot.reprapEnable = False

	#def setup( self, fileName, offset = (0, 0), fillDensity = 4, debug = False, stepsPerMillimeter = (30, 30), speed = 220, lineDump = False ):
	def setup( self, fileName, offset = (0, 0), fillDensity = 4, debug = False, stepsPerMillimeter = (30, 30), speed = 220 ):
		self.apertures = {}
		self.currentAperture = False
		self.currentX, self.currentY = 0, 0
		
		self.offsetX, self.offsetY = offset
		self.fillDensity = fillDensity
		self.fileName = fileName
		self.debug = debug

		self.linePlot = plotter.linePlotter()
		self.linePlot.setSpeed(speed)
		spmX, spmY = stepsPerMillimeter
		self.linePlot.setStepsPerMM(spmX, spmY)
		self.linePlot.setDebug(debug)
		

	def setReprap( self, enabled ):
		self.linePlot.setReprap(enabled)

	def setLineDump(self, lineDump):
		self.linePlot.setLineDump(lineDump)
		
	def setPenDownPos(self, pos):
		self.linePlot.setPenDownPos(pos)
		
	def setLineDelay(self, delay):
		self.linePlot.setLineDelay(delay)

	# Parse all lines of the gerber file
	def parseLines( self, lines ):
		for l in lines:
			#print "Reading line '" + l[ : -1 ] + "'"
			firstChr = l[ : 1 ]
			lastChr = l[ -2 : -1 ]
			if firstChr == "G" and lastChr == "*":
				self.cmdGcode( l[ 1 : -2 ] )
			elif firstChr == "%" and lastChr == "%":
				self.cmdParameter( l[ 1 : -2 ] )
			elif firstChr == "X" and lastChr == "*":
				self.cmdMove( l[ : -2 ] )
			elif firstChr == "M" and lastChr == "*":
				self.cmdMisc( l[ 1 : -2 ] )
			else:
				print "Line error!"
			if not self.stayRunning:
				break

	# Handle an M code
	def cmdMisc( self, mstring ):
		code = int( mstring[ : 2 ] )
		remains = mstring[ 2: ]
		print "MCODE", code, remains

	# Handle a G code
	def cmdGcode( self, gstring ):
		code = int( gstring[ : 2 ] )
		remains = gstring[ 2: ]
		if code == 0:
			print "Move", "[COMMAND UNSUPORTED!]"
		elif code == 1:
			print "Linear interpolation (1X scale)", "[COMMAND UNSUPORTED!]"
		elif code == 2:
			print "Clockwise circular interpolation", "[COMMAND UNSUPORTED!]"
		elif code == 3:
			print "Counterclockwise circular interpolation", "[COMMAND UNSUPORTED!]"
		elif code == 4:
			# Ignore Line
			#print "Comment", remains
			comment = False
		elif code == 10:
			print "Linear interpolation (10X scale)", "[COMMAND UNSUPORTED!]"
		elif code == 11:
			print "Linear interpolation (0.1X scale)", "[COMMAND UNSUPORTED!]"
		elif code == 12:
			print "Linear interpolation (0.01X scale)", "[COMMAND UNSUPORTED!]"
		elif code == 36:
			print "Turn on Polygon Area Fill", "[COMMAND UNSUPORTED!]"
		elif code == 37:
			print "Turn off Polygon Area Fill", "[COMMAND UNSUPORTED!]"
		elif code == 54:
			#if self.debug: print "Tool prepare"
			if remains[ : 1 ] == "D":
				#if self.debug: print "    Selecting aperture", int( remains[ 1 : ] )
				self.currentAperture = self.apertures[ int( remains[ 1 : ] ) ]
			#print currentAperture.modifiers[0]
		elif code == 70:
			if self.debug: print "Specify inches"							# why are there two ways of setting units?
			self.units = "IN"
		elif code == 71:
			if self.debug: print "Specify millimeters"
			self.units = "MM"
		elif code == 74:
			print "Disable 360 deg circular interpolation (single quadrant)", "[COMMAND UNSUPORTED!]"
		elif code == 75:
			print "Enable 360 deg circular interpolation (multiquadrant)", "[COMMAND UNSUPORTED!]"
		elif code == 90:
			if self.debug: print "Absolute coordinate format"
			self.FSparameter = FS_ABSOLUTE
		elif code == 91:
			if self.debug: print "Incremental coordinate format - This mode is not supported"
			self.FSparameter = FS_INCREMENTAL

		else:
			print "COMMAND UNKNOWN"


	# Handle a parameter
	def cmdParameter( self, paramString ):
		#print "Parameter", paramString, paramString[ : 2]
		if paramString[ : 3 ] == "ADD" and paramString[ -1 : ] == "*":
			newAperture = aperture( paramString, self.units )
			self.apertures[ newAperture.code ] = newAperture
		elif paramString[ : 2 ] == "MO" and paramString[ -1 : ] == "*":
			self.units = paramString[ 2 : -1 ]
		else:
			print "PARAMETER UNKNOWN"

	# Hande a move
	def cmdMove( self, moveString ):
		yPos = moveString.find( 'Y' )
		dPos = moveString.find( 'D' )
		x = float( moveString[ 1 : yPos ] ) / float(10000)	# need to read this value from the file? or work out dp
		y = float( moveString[ yPos + 1 : dPos ] ) / -float(10000)
		if self.units == "IN":
			#print "CONV"
			# convert to mm
			x = x * const_mmPerInch
			y = y * const_mmPerInch
		d = int( moveString[ dPos + 1 : ] )
		x, y = x + self.offsetX, y + self.offsetY
		if self.debug: print "Move [", x, "mm,", y, "mm],", d
		if d == 1:
			# Move is aperture open (pen down) type
			if self.currentAperture.apertureType == "C":
				# Using circular aperture
				self.linePlot.penUp()
				self.linePlot.reprapMoveTo( x, y )
				self.linePlot.penDown()
				radius = self.currentAperture.radius
				if self.debug: print "aperture radius", radius, "mm"
				self.linePlot.plotMoveWithCircle( self.currentX, self.currentY, x, y, radius, self.fillDensity )
				self.linePlot.penUp()
			elif self.currentAperture.apertureType == "R":
				# Using rectangular aperture
				print "TODO - rectangle transition"
		elif d == 2:
			# Move is aperture closed (pen up) type
			self.linePlot.penUp()
			self.linePlot.reprapMoveTo( x, y )
		elif d == 3:
			# Move is static flash type
			if self.currentAperture.apertureType == "C":
				# Using circular aperture
				self.linePlot.penUp()
				self.linePlot.reprapMoveTo( x, y )
				self.linePlot.penDown()
				radius = self.currentAperture.radius
				if self.debug: print "aperture radius", radius, "mm"
				self.linePlot.plotCircle( x, y, radius, self.fillDensity )
				self.linePlot.penUp()
			if self.currentAperture.apertureType == "R":
				# Using rectangular aperture
				self.linePlot.penUp()
				self.linePlot.reprapMoveTo( x, y )
				self.linePlot.penDown()
				self.linePlot.plotRectangle( x, y, self.currentAperture.width, self.currentAperture.height, self.fillDensity )
				self.linePlot.penUp()
		self.currentX, self.currentY = x, y







