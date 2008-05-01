#######################################################################################################################################################
# This module plots dxf entities to reprap and / or a lineSet object (for pygame plotting). The dxf file is turned into entities in dxflib.           #
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
import shapeplotter
import dxflib

# Returns file formats supported by module (for use in gui file filters)
def getSupportedFileExtensions():
	return ['.dxf']

# Returns general name of supported files (for use in gui file filters)
def getFileTitle():
	return "DXF CAD Files"

# Class to plot dxf file to screen and / or reprap
class plotter(threading.Thread):
	# Run is executed when thread is started (in new thread)
	def run(self):
		self.stayRunning = True
		scale = 1.5
		for e in self.dxfFile.entities:
			if e.type == "LINE":
				line = e.startX * scale, e.startY * scale, e.endX * scale, e.endY * scale
				self.shapePlot.plotLine( line )
			elif e.type == "CIRCLE":
				self.shapePlot.plotCircle( e.centreX * scale, e.centreY * scale, e.radius * scale, filled = False )
			elif e.type == "ARC":
				self.shapePlot.plotArc( e.centreX * scale, e.centreY * scale, e.radius * scale, math.radians(e.startAngle), math.radians(e.endAngle) )
		self.shapePlot.penUp()

	# Tell thread to terminate ASAP (result of GUI 'Stop' button)
	def terminate(self):
		self.stayRunning = False
		self.shapePlot.penUp()
		self.shapePlot.reprapEnable = False

	# Called by main thread to set parameters for plotter.
	def setup( self, fileName, offset = (0, 0), fillDensity = 4, debug = False, stepsPerMillimeter = (30, 30), speed = 220, circleResolution = False ):
		self.currentX, self.currentY = 0, 0
		self.offsetX, self.offsetY = offset
		#self.fillDensity = fillDensity
		self.fileName = fileName
		self.debug = debug

		self.shapePlot = shapeplotter.plotter()
		self.shapePlot.setSpeed(speed)
		spmX, spmY = stepsPerMillimeter
		self.shapePlot.setStepsPerMM(spmX, spmY)
		self.shapePlot.setDebug(debug)
		self.shapePlot.setCircleResolution(circleResolution)
		
		self.dxfFile = dxflib.dxf( self.fileName )
		self.dxfFile.printEnts()

	# Set plotter so send command to reprap
	def setReprap( self, enabled ):
		self.shapePlot.setReprap(enabled)

	# Set lineSet object to add lines to while plotting (used for GUI preview plotting)
	def setLineDump(self, lineDump):
		self.shapePlot.setLineDump(lineDump)

	# Set calibrated pen up and pen down positions
	def setPenPositions(self, upPos, downPos):
		self.shapePlot.setPenPositions(upPos, downPos)

	# Set a delay between plotting lines (usefull only for testing)
	def setLineDelay(self, delay):
		self.shapePlot.setLineDelay(delay)





