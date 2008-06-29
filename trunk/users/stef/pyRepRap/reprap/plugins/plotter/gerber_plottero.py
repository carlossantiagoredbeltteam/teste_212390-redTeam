#######################################################################################################################################################
# This module plots gerber objects to reprap and / or a lineSet object (for pygame plotting). The gerber file is turned into objects in gerber_lib.   #
#######################################################################################################################################################
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
import reprap.shapeplotter, gerber_lib

Title = "Gerber"

# Returns file formats supported by module (for use in gui file filters)
def getSupportedFileExtensions():
	return ['.pho', '.gbl', '.gtl', '.gbs', '.gts', '.gbo', '.gto', '.gbr', '.gbx', '.phd', '.spl', '.art', '.top', '.bot']

# Returns general name of supported files (for use in gui file filters)
def getFileTitle():
	return Title + " Files"

# Class to plot gerber file to screen and / or reprap
class plotter(threading.Thread):
	def __init__(	self,
					fileName,
					outputs = [],
					offsetX = 0,
					offsetY = 0,
					lineDump = False,
					stepsPerMM = (30, 30),
					circleResolution = False,
					fillDensity = 4,
					debug = False,
					lineDelay = 0 ):
					
		threading.Thread.__init__(self)
		
		self.shapePlot = reprap.shapeplotter.plotter(	outputs = outputs,
														lineDump = lineDump,
														stepsPerMM = stepsPerMM,
														circleResolution = circleResolution,
														fillMode = reprap.shapeplotter.FILL_LOCUS,
														debug = debug,
														lineDelay = lineDelay )
		
		self.fileName = fileName
		self.offsetX, self.offsetY = offsetX, offsetY
		self.fillDensity = fillDensity
		self.debug = debug
		
		self.gerberFile = gerber_lib.gerber(self.fileName)

	# Run is executed when thread is started (in new thread)
	def run(self):
		self.alive = True
		self.terminated = False
		
		# Plotting is pretty simple at the moment, plotter blindly follows gerber file and plots out each trace / flash individually.
		# Can be impoved by re-ordering drawing, and by combining connected traces into continual events / removing overlap
		
		# Plot all gerber flashes
		for f in self.gerberFile.flashes:
			# Break if thread has been told to termiate
			if not self.alive: return False
			#f.printFlash()
			# Move is static flash type
			if f.aperture.isMacro: print "macro", f.aperture.macroName
			if f.aperture.apertureType == "C":
				# Using circular aperture
				if self.debug: print "aperture radius", radius, "mm"
				self.shapePlot.plotCircle( f.x + self.offsetX, f.y + self.offsetY, f.aperture.radius, filled = True, fillDensity = self.fillDensity )
			elif f.aperture.apertureType == "R":
				# Using rectangular aperture
				self.shapePlot.plotRectangle( f.x + self.offsetX, f.y + self.offsetY, f.aperture.width, f.aperture.height, self.fillDensity )
			elif f.aperture.apertureType == "O":
				print "TODO plot oval"
				self.shapePlot.plotEllipse( f.x + self.offsetX, f.y + self.offsetY, f.aperture.width / 2, f.aperture.height / 2, filled = True, fillDensity = self.fillDensity )
		
		# Plot all gerber traces
		for t in self.gerberFile.traces:
			# Break if thread has been told to termiate
			if not self.alive: return False
			#t.printTrace()
			# Move is aperture open (pen down) type
			if t.aperture.isMacro: print "macro", f.aperture.macroName
			if t.aperture.apertureType == "C":
				# Using circular aperture
				if t.aperture.code == 12 or  t.aperture.code == 13: print  t.aperture.code
				if self.debug: print "aperture radius", t.aperture.radius, "mm"
				self.shapePlot.plotMoveWithCircle( t.x1 + self.offsetX, t.y1 + self.offsetY, t.x2 + self.offsetX, t.y2 + self.offsetY, t.aperture.radius, self.fillDensity )
			elif t.aperture.apertureType == "R":
				# Using rectangular aperture
				print "TODO - rectangle transition"
				
		#if self.smilFile:
		#	self.shapePlot.writeSMILfile(self.smilFile)
		
		for o in self.shapePlot.outputs:
			o.finish()
			
	def getFileLimitsXY(self):
		minX, minY = 1000000, 1000000
		maxX, maxY = 0, 0
		for f in self.gerberFile.flashes:
			minX = min(f.x, minX)
			minY = min(f.y, minY)
			maxX = max(f.x, maxX)
			maxY = max(f.y, maxY)
			
		for f in self.gerberFile.traces:
			minX = min(f.x1, f.x2, minX)
			minY = min(f.y1, f.y2, minY)
			maxX = max(f.x1, f.x2, maxX)
			maxY = max(f.y1, f.y2, maxY)
		
		#TODO - this is not taking into account the aperture, only the central / start coordinate of an aperture
		return minX, minY, maxX, maxY

	# Tell thread to terminate ASAP (result of GUI 'Stop' button)
	def terminate(self):
		self.alive = False
		#self.shapePlot.penUp()
		#self.shapePlot.reprapEnable = False
		
	# For primary thread to wait in while waiting for plot thread to end. May be removed. TODO
	def waitTerminate(self):
		while not self.terminated:
			time.sleep(0.5)

	# Set plotter so send command to reprap
	def setReprapEnable( self, enabled ):
		self.shapePlot.setReprap(enabled)
		
	def setSMILfile( self, fileName ):
		self.smilFile = fileName
		self.shapePlot.setSMIL(True)
		
	#def writeSMILFile(self, fileName):
	#	self.shapePlot.writeSMILFile(fileName)


	# Set calibrated pen up and pen down positions
	def setPenPositions(self, upPos, downPos):
		self.shapePlot.setPenPositions(upPos, downPos)
		
	def setOffset(self, offset):
		self.offsetX, self.offsetY = offset






