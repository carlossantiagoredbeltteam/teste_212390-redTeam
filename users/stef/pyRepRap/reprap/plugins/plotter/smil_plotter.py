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

import svg_lib, reprap.shapeplotter, threading
import smil_lib as smillib
from smil_prefpanel import PreferencesPanel #temp

Title = "SMIL"

def getPreferencePanel(parent):
	return PreferencesPanel(parent, -1)

# Returns file formats supported by module (for use in gui file filters)
def getSupportedFileExtensions():
	return ['.smil']

# Returns general name of supported files (for use in gui file filters)
def getFileTitle():
	return Title + " Files"

# Class to plot gerber file to screen and / or reprap
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
		self.smilFile = smillib.SMIL(self.fileName)
		print "Version", self.smilFile.version, "Layers", self.smilFile.layerCount, "Units", self.smilFile.units

	# Run is executed when thread is started (in new thread)
	def run(self):
		self.alive = True
		self.terminated = False
		
		polygons = self.smilFile.layers[0]
		for p in polygons:
			self.shapePlot.plotPolygon(p, self.offsetX, self.offsetY)
		# Plot using self.shapePlot here #
				
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
	
	# Set plot offset
	def setOffset(self, offset):
		self.offsetX, self.offsetY = offset





