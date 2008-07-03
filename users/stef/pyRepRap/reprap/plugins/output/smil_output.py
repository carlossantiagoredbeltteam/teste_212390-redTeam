#######################################################################################################################################################
# This module write SMIL toolpath files                                                                                                               #
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

import threading, reprap.preferences
#from smil_prefpanel import PreferencesPanel

Title = "SMIL File"
FileOutput = True
Wildcard = 'SMIL files (*.smil)|*.smil|'

class output(reprap.baseplotters.ExportPlotter):
	# Load plotter preferences
	def loadPreferences(self):
		# make polygon merging an option TODO
		self.prefHandler = reprap.preferences.PreferenceHandler(self,  "output_smil.conf")
		self.prefHandler.load()
	
	# Start plot (as new thread)
	def run(self):
		self.alive = True
		self.smil = SMIL()
		self.curZ = 0
		for poly in self.polygons:
			if not self.alive:
				self.feedbackHandler.aborted()
				break
			#print "plot poly", poly.points, "pc", poly.closed
			x1, y1 = poly.points[0]
			self.cartesianMove(x1, y1, None)
			self.toolhead.start()
			for p in poly.points[ 1: ]:
				x2, y2 = p
				if (x1 != x2) or (y1 != y2):
					self.cartesianMove(x2, y2, None)
			x1, y1 = x2, y2
			self.toolhead.stop()
			self.smil.finishPolygon(poly.closed)
		self.smil.writeFile(self.outputFilename)
		
		if self.alive:
			# Tell gui that plot is complete (redraw screen)
			self.feedbackHandler.plotComplete()
	
	# Translate a cartesian movement into whatever the output plugin does with it (called locally and by toolhead)
	def cartesianMove(self, x, y, z, units = reprap.UNITS_MM):
		#if z != None:
		#	self.smil.addCoordinate( x, y, z )
		if x != None and y != None:
			self.smil.addCoordinate( x, y, z )
		# TODO, should we round coordinates

# Simple class for layer
class layer():
	def __init__(self):
		self.polygons = []
		self.currentPolygon = spolygon()
		
	def finishPolygon(self, closed):
		if closed:
			self.currentPolygon.closed = 1
		else:
			self.currentPolygon.closed = 0
		self.polygons.append(self.currentPolygon)
		self.currentPolygon = spolygon()
		
	def getPolygons(self):
		return self.polygons

# Simple class for polygon (single tool movement path)
class spolygon():
	def __init__(self):
		self.coordinates = []
		self.closed = False
	
	def addCoordinate(self, x, y, z):
		self.coordinates.append( (x, y, z) )
	
	def getCoordinates(self):
		return self.coordinates

# Class for smil file
class SMIL():
	def __init__(self):
		self.layers = []
		self.currentLayer = layer()
		
	def addCoordinate(self, x, y, z):
		self.currentLayer.currentPolygon.addCoordinate(x, y, z)
	
	def finishPolygon(self, closed):
		self.currentLayer.finishPolygon(closed)
	
	def newLayer(self):
		self.layers.append(self.currentLayer)
		self.currentLayer = layer()
	
	def generateSMIL(self):
		#self.finishPolygon(False)
		self.newLayer()
		self.toolName = "pen"	# temp
		self.smilText = '<SSIL LayerCount="' + str( len(self.layers) ) + '" Units="mm">\n'
		for layerIndex, layer in enumerate(self.layers):
			self.smilText += '\t<LAYER index="' + str(layerIndex) + '" >\n'
			for polygonIndex, polygon in enumerate( layer.getPolygons() ):
				self.smilText += '\t\t<TOOL Name="' + self.toolName + '" index="0">\n'
				self.smilText += '\t\t\t<THREAD index="' + str(polygonIndex) + '">\n'
				for coordinateIndex, coordinate in enumerate( polygon.getCoordinates() ):
					x, y, z = coordinate
					self.smilText += '\t\t\t\t<POINT X="' + str(x) + '" Y="' + str(y) + '" index="' + str(coordinateIndex) + '"/>\n'		# add z support here
				self.smilText += '\t\t\t</THREAD>\n'
			self.smilText += '\t\t</TOOL>\n'
		self.smilText += '\t</LAYER>\n'
		self.smilText += '</SSIL>\n'
		
	def generateSMIL2(self):
		#self.finishPolygon()
		self.newLayer()
		self.toolName = "pen"	# temp
		offsetX, offsetY = 0, 0
		self.smilText = '<SSIL version = "0.2" layers="' + str( len(self.layers) ) + '" units="mm" offset="' + str(offsetX) + ',' + str(offsetY) + '">\n'
		for layerIndex, layer in enumerate(self.layers):
			self.smilText += '\t<LAYER index="' + str(layerIndex) + '" >\n'
			for polygonIndex, polygon in enumerate( layer.getPolygons() ):
				self.smilText += '\t\t<TOOL name="' + self.toolName + '" index="0">\n'
				closed = 0
				self.smilText += '\t\t\t<POLYGON index="' + str(polygonIndex) + '" closed="' + str(polygon.closed) + '">\n'
				for coordinateIndex, coordinate in enumerate( polygon.getCoordinates() ):
					x, y, z = coordinate
					self.smilText += '\t\t\t\tX' + str(x) + '\tY' + str(y) + '\n'
				self.smilText += '\t\t\t</POLYGON>\n'
				self.smilText += '\t\t</TOOL>\n'
		self.smilText += '\t</LAYER>\n'
		self.smilText += '</SSIL>\n'
		
	def generatePlainTextSMIL(self):
		self.finishPolygon()
		self.newLayer()
		self.toolName = "pen"	# temp
		self.smilText = 'LayerCount ' + str( len(self.layers) ) + '\n'
		self.smilText += "UNITS mm"
		for layerIndex, layer in enumerate(self.layers):
			self.smilText += 'LAYER ' + str(layerIndex) + '\n'
			for polygonIndex, polygon in enumerate( layer.getPolygons() ):
				self.smilText += 'TOOL ' + self.toolName + ' 0\n'
				self.smilText += 'THREAD ' + str(polygonIndex) + '\n'
				for coordinateIndex, coordinate in enumerate( polygon.getCoordinates() ):
					x, y, z = coordinate
					self.smilText += 'I' + str(coordinateIndex) + ' X' + str(x) + ' Y' + str(y) + '\n'		# add z support here
				self.smilText += 'END THREAD\n'
			self.smilText += 'END TOOL\n'
		self.smilText += 'END LAYER\n'
		self.smilText += 'EOF\n'
	
	def writeFile(self, fileName):
		self.generateSMIL2()
		#self.generatePlainTextSMIL()
		#print self.smilText
		f = open( fileName, 'w' )
		f.write(self.smilText)
		f.close()


