#######################################################################################################################################################
# This module writes GCode toolpath files                                                                                                               #
#######################################################################################################################################################
"""
Licensed under GPL v2 and the 'I'm not going to help you kill people licence'. The latter overrules the former.
        
I'm not going to help you kill people licence v1.1:
The use of this software in any form for any purposes relating to any form of military activity or
research either directly or via subcontracts is strictly prohibited.
Any company or organisation affiliated with any military organisations either directly or through
subcontracts are strictly prohibited from using any part of this software.
Individuals who work for the above mentioned organisations working on PERSONAL or open source projects unrelated
to above mentioned organisations in their own time may use this software.

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

import reprap.preferences
from gcode_prefpanel import PreferencesPanel

Title = "GCode File"

def getPreferencePanel(parent):
	return PreferencesPanel(parent, -1)

class output:
	def __init__(self):
		self.prefHandler = reprap.preferences.PreferenceHandler(self,  "output_gcode.conf")
		self.prefHandler.load()
		self.gcode = GCode()
		self.curZ = 0
	
	def setToolhead(self, toolhead):
		self.toolhead = toolhead
	
	def toolStart(self):
		pass
	
	def toolStop(self):
		pass
	
	def cartesianMove(self, x, y, z, units = reprap.UNITS_MM):
		self.gcode.addCoordinate( x, y, z )
	
	def finish(self):
		self.toolhead.toolStop()
		self.gcode.writeFile("test.gcode")

# Class for gcode file
class GCode():
	def __init__(self):
		self.coordinates = []
	
	def addCoordinate(self, x, y, z):
		self.coordinates.append ( (x, y, z) )
	
	def generateGCode(self):
		self.gcodeText = "(GCode generated by RepRap Plotter)\nG21 (Millimeters)\nG28 (Go Home)\nG90 (Absolute Positioning)\n(Start Plot)\n"
		for x, y, z in self.coordinates:
			if z:
				self.gcodeText += 'G1 Z' + str(z) + '\n'
			elif x and y:
				self.gcodeText += 'G1 X' + str(x) + ' Y' + str(y) + '\n'
		self.gcodeText += "G28 (Go Home)"
	
	def writeFile(self, fileName):
		self.generateGCode()
		f = open( fileName, 'w' )
		f.write(self.gcodeText)
		f.close()


