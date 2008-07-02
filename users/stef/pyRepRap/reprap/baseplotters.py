#################################################################################################################
# Base classes for import and export plotters                                                       .           #
#################################################################################################################
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

import threading, reprap

# Base class for import plotters
class ImportPlotter(threading.Thread):
	def __init__(	self, fileName,	polygonList,
					feedbackHandler = False,
					arcResolution = False,
					fillDensity = 4,
					debug = False ):
		
		threading.Thread.__init__(self)
		
		self.fileName = fileName
		self.polygons = polygonList
		self.feedbackHandler = feedbackHandler
		self.arcResolution = arcResolution
		self.fillDensity = fillDensity
		self.debug = debug
		
		self.loadPreferences()
	
	# Tell thread to terminate ASAP (result of GUI 'Stop' button)
	def terminate(self):
		self.alive = False
	
	# Run is executed when thread is started (in new thread)
	def run(self):
		raise NotImplementedError('Import plotter plugin must define a .run() method!')
	
	# Return bounding limits of file (used for zeroing position)
	def getFileLimitsXY(self):
		raise NotImplementedError('Import plotter plugin must define a .getFileLimitsXY() method!')

	def loadPreferences(self):
		raise NotImplementedError('Import plotter plugin must define a .loadPreferences() method!')



# Base class for export plotters
class ExportPlotter(threading.Thread):
	def __init__(	self, polygons, toolhead,
					feedbackHandler = False,
					outputFilename = False):
		
		threading.Thread.__init__(self)
		
		self.polygons = polygons
		self.feedbackHandler = feedbackHandler
		self.toolhead = toolhead
		self.toolhead.output = self
		self.outputFilename = outputFilename
		
		self.loadPreferences()
	
	def run(self):
		raise NotImplementedError('Export plotter plugin must define a .run() method!')
	
	def cartesianMove(self, x, y, z, units = reprap.UNITS_MM):
		raise NotImplementedError('Export plotter plugin must define a .cartesianMove() method!')

	def loadPreferences(self):
		raise NotImplementedError('Export plotter plugin must define a .loadPreferences() method!')





