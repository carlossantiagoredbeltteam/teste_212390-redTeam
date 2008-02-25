"""
    pyRepRap is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    pyRepRap is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with pyRepRap.  If not, see <http://www.gnu.org/licenses/>.
"""

class dxfEntity():
	def __init__( self ):
		self.data = []
	def addLine( self, line ):
		self.data.append( line )
	def decode( self ):
		self.type = self.data[0][:-1]	
		for i in range( 1, len(self.data) - 1, 2 ):
			param = self.data[i][:-1].strip()
			value = self.data[i + 1][:-1].strip()
			#print "param '" + param + "' = '" + value + "'"
			if self.type == "CIRCLE":
				if param == "100":
					self.subclass = value
				elif param == "39":
					self.thickness = float(value)
				elif param == "10":
					self.centreX = float(value)
				elif param == "20":
					self.centreY = float(value)
				elif param == "30":
					self.centreZ = float(value)
				elif param == "40":
					self.radius = float(value)
				elif param == "210":
					self.extrusionDirX = float(value)
				elif param == "220":
					self.extrusionDirY = float(value)
				elif param == "230":
					self.extrusionDirZ = float(value)
			elif self.type == "LINE":
				if param == "100":
					self.subclass = value
				elif param == "39":
					self.thickness = float(value)
				elif param == "10":
					self.startX = float(value)
				elif param == "20":
					self.startY = float(value)
				elif param == "30":
					self.startZ = float(value)
				elif param == "11":
					self.endX = float(value)
				elif param == "21":
					self.endY = float(value)
				elif param == "31":
					self.endZ = float(value)
				elif param == "210":
					self.extrusionDirX = float(value)
				elif param == "220":
					self.extrusionDirY = float(value)
				elif param == "230":
					self.extrusionDirZ = float(value)
			elif self.type == "ARC":
				if param == "100":
					self.subclass = value
				elif param == "39":
					self.thickness = float(value)
				elif param == "10":
					self.centreX = float(value)
				elif param == "20":
					self.centreY = float(value)
				elif param == "30":
					self.centreZ = float(value)
				elif param == "40":
					self.radius = float(value)
				elif param == "50":
					self.startAngle = float(value)
				elif param == "51":
					self.endAngle = float(value)
				elif param == "210":
					self.extrusionDirX = float(value)
				elif param == "220":
					self.extrusionDirY = float(value)
				elif param == "230":
					self.extrusionDirZ = float(value)
					
class dxf():
	def __init__( self, fileName ):
		dxfFile = open( fileName, "r" )
		fileLines =  dxfFile.readlines() 
		entStart = 0
		currentEntStart = 0
		self.entities = []
		lineIsCommand = False
		currentEnt = False
		for n in range( 0, len(fileLines) ):
			line = fileLines[n][:-1].strip()
			#print "'" + line + "'"
			if line == "ENTITIES":
				entStart = n
			elif line == "CIRCLE" or fileLines[n][:-1] == "LINE" or fileLines[n][:-1] == "ARC":
				if not currentEnt:
					currentEnt = dxfEntity()
					lineIsCommand = False
				else:
					print "DXF Read Error"
			elif line == "0":				# end of shape
				if currentEnt and lineIsCommand:
					self.entities.append( currentEnt )
					currentEnt = False
			if currentEnt:
				currentEnt.addLine( fileLines[n] )
				lineIsCommand = not lineIsCommand	# set for next loop

		for e in self.entities:
			e.decode()

	def printEnts( self ):			
		for e in self.entities:
			if e.type == "LINE":
				print e.type, "from [", e.startX, e.startY, e.startZ, "] to [", e.endX, e.endY, e.endZ, "]"
			elif e.type == "CIRCLE":
				print e.type, "centre [", e.centreX, e.centreY, e.centreZ, "], radius [", e.radius, "]"
			elif e.type == "ARC":
				print e.type, "centre [", e.centreX, e.centreY, e.centreZ, "], radius [", e.radius, "] start [", e.startAngle, "] end [", e.endAngle, "]" 



			

