#######################################################################################################################################################
# This module plots dxf entities to reprap and / or a lineSet object (for pygame plotting). The dxf file is turned into entities in dxf_lib.           #
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

import time, math, sys, threading
import reprap.shapeplotter
import dxf_lib
from dxf_prefpanel import PreferencesPanel #temp

Title = "DXF Cad"

def getPreferencePanel(parent):
	return PreferencesPanel(parent, -1)

# Returns file formats supported by module (for use in gui file filters)
def getSupportedFileExtensions():
	return ['.dxf']

# Returns general name of supported files (for use in gui file filters)
def getFileTitle():
	return Title + " Files"

# Class to plot dxf file to screen and / or reprap
class plotter(threading.Thread):
	def __init__(	self,
					fileName,
					outputs = [],
					toolhead = 0,
					feedbackHandler = False,
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
														toolhead = toolhead,
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
		self.feedbackHandler = feedbackHandler
		
		self.dxfFile = dxf_lib.dxf( self.fileName )
		self.dxfFile.printEnts()
	
	# Run is executed when thread is started (in new thread)
	def run(self):
		self.alive = True
		scale = 1
		for e in self.dxfFile.entities:
			# Break if thread has been told to termiate
			if not self.alive: return False
			if e.type == "LINE":
				line = (e.startX * scale) + self.offsetX, (e.startY * scale) + self.offsetY, (e.endX * scale) + self.offsetX, (e.endY * scale) + self.offsetY
				self.shapePlot.plotLine( line )
			elif e.type == "CIRCLE":
				self.shapePlot.plotCircle( (e.centreX * scale) + self.offsetX, (e.centreY * scale) + self.offsetY, e.radius * scale, filled = False )
			elif e.type == "ARC":
				self.shapePlot.plotArc( (e.centreX * scale) + self.offsetX, (e.centreY * scale) + self.offsetY, e.radius * scale, math.radians(e.startAngle), math.radians(e.endAngle) )
		for o in self.shapePlot.outputs:
			o.finish()

	def getFileLimitsXY(self):
		minX, minY = 1000000, 1000000
		maxX, maxY = 0, 0
		# Calc limits
		return minX, minY, maxX, maxY
		

	# Tell thread to terminate ASAP (result of GUI 'Stop' button)
	def terminate(self):
		self.alive = False
		self.shapePlot.penUp()
		self.shapePlot.reprapEnable = False

	# Set plotter so send command to reprap
	def setReprapEnable( self, enabled ):
		self.shapePlot.setReprap(enabled)

	# Set calibrated pen up and pen down positions
	def setPenPositions(self, upPos, downPos):
		self.shapePlot.setPenPositions(upPos, downPos)

	def setOffset(self, offset):
		self.offsetX, self.offsetY = offset



