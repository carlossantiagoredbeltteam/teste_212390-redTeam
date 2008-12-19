"""
Tower is a script to extrude a few layers up, then go across to other regions.

The default 'Activate Tower' checkbox is off.  The default is off because tower could result in the extruder collidiing with an
already extruded part of the shape and because extruding in one region for more than one layer could result in the shape
melting.  When it is on, the functions described below will work, when it is off, the functions will not be called.

This script commands the fabricator to extrude a disconnected region for a few layers, then go to another disconnected region
and extrude there.  Its purpose is to reduce the number of stringers between a shape and reduce extruder travel.  The important
value for the tower preferences is "Maximum Tower Height (layers)" which is the maximum number of layers that the extruder
will extrude in one region before going to another.

Tower works by looking for islands in each layer and if it finds another island in the layer above, it goes to the next layer above
instead of going across to other regions on the original layer.  It checks for collision with shapes already extruded within a cone
from the nozzle tip.  The "Extruder Possible Collision Cone Angle (degrees)" preference is the angle of that cone.  Realistic
values for the cone angle range between zero and ninety.  The higher the angle, the less likely a collision with the rest of the
shape is, generally the extruder will stay in the region for only a few layers before a collision is detected with the wide cone.
The default angle is sixty degrees.

The "Tower Start Layer" is the layer which the script starts extruding towers, after the last raft layer which does not have
support material.  It is best to not tower at least the first layer because the temperature of the first layer should sometimes be
different than that of the other layers.  The default preference is one.  To run tower, in a shell type:
> python tower.py

The following examples tower the files Hollow Square.gcode & Hollow Square.gts.  The examples are run in a terminal in the folder
which contains Hollow Square.gcode, Hollow Square.gts and tower.py.  The tower function will tower if 'Maximum Tower Layers' is
greater than zero, which can be set in the dialog or by changing the preferences file 'tower.csv' with a text editor or a spreadsheet
program set to separate tabs.  The functions writeOutput and getTowerChainGcode check to see if the text has been towered,
if not they call the getRaftChainGcode in raft.py to raft the text; once they have the rafted text, then they tower.  Pictures of
towering in action are available from the Metalab blog at:
http://reprap.soup.io/?search=towering


> python tower.py
This brings up the dialog, after clicking 'Tower', the following is printed:
File Hollow Square.gts is being chain towered.
The towered file is saved as Hollow Square_tower.gcode


>python
Python 2.5.1 (r251:54863, Sep 22 2007, 01:43:31)
[GCC 4.2.1 (SUSE Linux)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import tower
>>> tower.main()
This brings up the tower dialog.


>>> tower.writeOutput()
Hollow Square.gts
File Hollow Square.gts is being chain towered.
The towered file is saved as Hollow Square_tower.gcode


>>> tower.getTowerGcode("
( GCode generated by May 8, 2008 slice.py )
( Extruder Initialization )
..
many lines of gcode
..
")


>>> tower.getTowerChainGcode("
( GCode generated by May 8, 2008 slice.py )
( Extruder Initialization )
..
many lines of gcode
..
")

"""

from __future__ import absolute_import
#Init has to be imported first because it has code to workaround the python bug where relative imports don't work if the module is imported as a main module.
import __init__

from skeinforge_tools.skeinforge_utilities.vec3 import Vec3
from skeinforge_tools.skeinforge_utilities import euclidean
from skeinforge_tools.skeinforge_utilities import gcodec
from skeinforge_tools.skeinforge_utilities import intercircle
from skeinforge_tools.skeinforge_utilities import preferences
from skeinforge_tools import analyze
from skeinforge_tools import import_translator
from skeinforge_tools import polyfile
from skeinforge_tools import raft
import cStringIO
import math
import sys
import time


__author__ = "Enrique Perez (perez_enrique@yahoo.com)"
__date__ = "$Date: 2008/21/04 $"
__license__ = "GPL 3.0"

def getTowerChainGcode( filename, gcodeText, towerPreferences = None ):
	"Tower a gcode linear move text.  Chain tower the gcode if it is not already towered."
	gcodeText = gcodec.getGcodeFileText( filename, gcodeText )
	if not gcodec.isProcedureDone( gcodeText, 'raft' ):
		gcodeText = raft.getRaftChainGcode( filename, gcodeText )
	return getTowerGcode( gcodeText, towerPreferences )

def getTowerGcode( gcodeText, towerPreferences = None ):
	"Tower a gcode linear move text."
	if gcodeText == '':
		return ''
	if gcodec.isProcedureDone( gcodeText, 'tower' ):
		return gcodeText
	if towerPreferences == None:
		towerPreferences = TowerPreferences()
		preferences.readPreferences( towerPreferences )
	if not towerPreferences.activateTower.value:
		return gcodeText
	skein = TowerSkein()
	skein.parseGcode( gcodeText, towerPreferences )
	return skein.output.getvalue()

def transferFillLoops( fillLoops, surroundingLoop ):
	"Transfer fill loops."
	for innerSurrounding in surroundingLoop.innerSurroundings:
		transferFillLoopsToSurroundingLoops( fillLoops, innerSurrounding.innerSurroundings )
	surroundingLoop.extraLoops = euclidean.getTransferredPathsComplexFunctionPlaceholder( fillLoops, surroundingLoop.boundary )

def transferFillLoopsToSurroundingLoops( fillLoops, surroundingLoops ):
	"Transfer fill loops to surrounding loops."
	for surroundingLoop in surroundingLoops:
		transferFillLoops( fillLoops, surroundingLoop )

def writeOutput( filename = '' ):
	"""Tower a gcode linear move file.  Chain tower the gcode if it is not already towered.
	If no filename is specified, tower the first unmodified gcode file in this folder."""
	if filename == '':
		unmodified = import_translator.getGNUTranslatorFilesUnmodified()
		if len( unmodified ) == 0:
			print( "There are no unmodified gcode files in this folder." )
			return
		filename = unmodified[ 0 ]
	towerPreferences = TowerPreferences()
	preferences.readPreferences( towerPreferences )
	startTime = time.time()
	print( filename )
	print( 'File ' + gcodec.getSummarizedFilename( filename ) + ' is being chain towered.' )
	suffixFilename = filename[ : filename.rfind( '.' ) ] + '_tower.gcode'
	towerGcode = getTowerChainGcode( filename, '', towerPreferences )
	if towerGcode == '':
		return
	gcodec.writeFileText( suffixFilename, towerGcode )
	print( 'The towered file is saved as ' + gcodec.getSummarizedFilename( suffixFilename ) )
	analyze.writeOutput( suffixFilename, towerGcode )
	print( 'It took ' + str( int( round( time.time() - startTime ) ) ) + ' seconds to tower the file.' )


class ThreadLayer:
	"A layer of loops and paths."
	def __init__( self ):
		"Thread layer constructor."
		self.boundaries = []
		self.loops = []
		self.paths = []
		self.surroundingLoops = []

	def __repr__( self ):
		"Get the string representation of this thread layer."
		return '%s, %s, %s, %s' % ( self.boundaries, self.loops, self.paths, self.surroundingLoops )


class TowerPreferences:
	"A class to handle the tower preferences."
	def __init__( self ):
		"Set the default preferences, execute title & preferences filename."
		#Set the default preferences.
		self.archive = []
		self.activateTower = preferences.BooleanPreference().getFromValue( 'Activate Tower', True )
		self.archive.append( self.activateTower )
		self.extruderPossibleCollisionConeAngle = preferences.FloatPreference().getFromValue( 'Extruder Possible Collision Cone Angle (degrees):', 60.0 )
		self.archive.append( self.extruderPossibleCollisionConeAngle )
		self.filenameInput = preferences.Filename().getFromFilename( import_translator.getGNUTranslatorGcodeFileTypeTuples(), 'Open File to be Towered', '' )
		self.archive.append( self.filenameInput )
		self.maximumTowerHeight = preferences.IntPreference().getFromValue( 'Maximum Tower Height (layers):', 0 )
		self.archive.append( self.maximumTowerHeight )
		self.towerStartLayer = preferences.IntPreference().getFromValue( 'Tower Start Layer (integer):', 1 )
		self.archive.append( self.towerStartLayer )
		#Create the archive, title of the execute button, title of the dialog & preferences filename.
		self.executeTitle = 'Tower'
		self.filenamePreferences = preferences.getPreferencesFilePath( 'tower.csv' )
		self.filenameHelp = 'skeinforge_tools.tower.html'
		self.saveTitle = 'Save Preferences'
		self.title = 'Tower Preferences'

	def execute( self ):
		"Tower button has been clicked."
		filenames = polyfile.getFileOrDirectoryTypesUnmodifiedGcode( self.filenameInput.value, import_translator.getGNUTranslatorFileTypes(), self.filenameInput.wasCancelled )
		for filename in filenames:
			writeOutput( filename )


class TowerSkein:
	"A class to tower a skein of extrusions."
	def __init__( self ):
		self.beforeExtrusionLines = None
		self.decimalPlacesCarried = 3
		self.extruderActive = False
		self.extrusionWidth = 0.6
		self.feedrateMinute = 959.0
		self.feedrateTable = {}
		self.halfExtrusionHeight = 0.4
		self.islandLayers = []
		self.isLoop = False
		self.isPerimeter = False
		self.layerIndex = 0
		self.lineIndex = 0
		self.lines = None
		self.oldLayerIndex = None
		self.oldLocation = None
		self.oldOrderedLocation = Vec3()
		self.oldZ = - 999999999.0
		self.output = cStringIO.StringIO()
		self.shutdownLineIndex = sys.maxint
		self.surroundingLoop = None
		self.thread = None
		self.threadLayer = None
		self.threadLayers = []

	def addEntireLayer( self, layerIndex ):
		"Add entire thread layer."
		surroundingLoops = self.islandLayers[ layerIndex ]
		for line in self.threadLayers[ layerIndex ].beforeExtrusionLines:
			self.addLine( line )
		euclidean.addToThreadsRemoveFromSurroundingsComplexFunctionPlaceholder( self.oldOrderedLocation, surroundingLoops, self )

	def addGcodeFromThreadZ( self, thread, z ):
		"Add a gcode thread to the output."
		if len( thread ) > 0:
			firstPoint = thread[ 0 ]
			if z + self.halfExtrusionHeight < self.oldZ:
				highPoint = complex( firstPoint.real, firstPoint.imag )
				if self.oldLocation != None:
					oldLocationComplex = self.oldLocation.dropAxis( 2 )
					complexToPoint = firstPoint - oldLocationComplex
					toPointLength = abs( complexToPoint )
					if toPointLength > 0.0:
						truncatedLength = max( 0.5 * toPointLength, toPointLength - self.extrusionWidth )
						complexToPointTruncated = complexToPoint * truncatedLength / toPointLength
						highPoint = oldLocationComplex + complexToPointTruncated
				self.addGcodeMovementZ( highPoint, z )
			self.addGcodeMovementZ( firstPoint, z )
			self.oldZ = z
		else:
			print( "zero length vertex positions array which was skipped over, this should never happen" )
		if len( thread ) < 2:
			return
		self.addLine( 'M101' )
		for point in thread[ 1 : ]:
			self.addGcodeMovementZ( point, z )
		self.addLine( "M103" ) # Turn extruder off.

	def addGcodeMovementZ( self, point, z ):
		"Add a movement to the output."
		if point in self.feedrateTable:
			feedrateMinute = self.feedrateTable[ point ]
			self.addLine( 'G1 X%s Y%s Z%s F%s' % ( self.getRounded( point.real ), self.getRounded( point.imag ), self.getRounded( z ), self.getRounded( feedrateMinute ) ) )
			return
		self.addLine( 'G1 X%s Y%s Z%s' % ( self.getRounded( point.real ), self.getRounded( point.imag ), self.getRounded( z ) ) )

	def addIfTravel( self, splitLine ):
		"Add travel move around loops if this the extruder is off."
		location = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		self.oldLocation = location

	def addIslandLayer( self, threadLayer ):
		"Add a layer of surrounding islands."
		surroundingLoops = euclidean.getOrderedSurroundingLoopsComplexFunctionPlaceholder( self.extrusionWidth, threadLayer.surroundingLoops )
		for surroundingLoop in surroundingLoops:
			surroundingLoop.boundingLoop = intercircle.BoundingLoopComplexFunctionPlaceholder().getFromLoop( surroundingLoop.boundary )
		euclidean.transferPathsToSurroundingLoops( threadLayer.paths[ : ], surroundingLoops )
		transferFillLoopsToSurroundingLoops( threadLayer.loops[ : ], surroundingLoops )
		self.islandLayers.append( surroundingLoops )

	def addLayerLinesIfDifferent( self, layerIndex ):
		"Add gcode lines for the layer if it is different than the old bottom layer index."
		if layerIndex != self.oldLayerIndex:
			self.oldLayerIndex = layerIndex
			for line in self.threadLayers[ layerIndex ].beforeExtrusionLines:
				self.addLine( line )

	def addLine( self, line ):
		"Add a line of text and a newline to the output."
		self.output.write( line + "\n" )

	def addShutdownToOutput( self ):
		"Add shutdown gcode to the output."
		for line in self.lines[ self.shutdownLineIndex : ]:
			self.addLine( line )

	def addToExtrusion( self, location ):
		"Add a location to the thread."
		if self.oldLocation == None:
			return
		if self.threadLayer == None:
			return
		if self.surroundingLoop != None:
			if self.isPerimeter:
				if self.surroundingLoop.loop == None:
					self.surroundingLoop.loop = []
				self.surroundingLoop.addToLoop( location )
				return
			elif self.thread == None:
				self.thread = [ self.oldLocation.dropAxis( 2 ) ]
				self.surroundingLoop.perimeterPaths.append( self.thread )
		if self.thread == None:
			self.thread = []
			if self.isLoop: #do not add to loops because a closed loop does not have to restate its beginning
				self.threadLayer.loops.append( self.thread )
			else:
				self.thread.append( self.oldLocation.dropAxis( 2 ) )
				self.threadLayer.paths.append( self.thread )
		self.thread.append( location.dropAxis( 2 ) )

	def addTowers( self ):
		"Add towers."
		bottomLayerIndex = self.getBottomLayerIndex()
		if bottomLayerIndex == None:
			return
		self.addLayerLinesIfDifferent( bottomLayerIndex )
		removedIsland = euclidean.getTransferClosestSurroundingLoopComplexFunctionPlaceholder( self.oldOrderedLocation, self.islandLayers[ bottomLayerIndex ], self )
		while 1:
			self.climbTower( removedIsland )
			bottomLayerIndex = self.getBottomLayerIndex()
			if bottomLayerIndex == None:
				return
			self.addLayerLinesIfDifferent( bottomLayerIndex )
			removedIsland = euclidean.getTransferClosestSurroundingLoopComplexFunctionPlaceholder( self.oldOrderedLocation, self.islandLayers[ bottomLayerIndex ], self )

	def climbTower( self, removedIsland ):
		"Climb up the island to any islands directly above."
		outsetDistance = 1.5 * self.extrusionWidth
		for step in range( self.towerPreferences.maximumTowerHeight.value ):
			aboveIndex = self.oldLayerIndex + 1
			if aboveIndex >= len( self.islandLayers ):
				return
			outsetRemovedLoop = removedIsland.boundingLoop.getOutsetBoundingLoop( outsetDistance )
			islandsWithin = []
			for island in self.islandLayers[ aboveIndex ]:
				if self.isInsideRemovedOutsideCone( island, outsetRemovedLoop, aboveIndex ):
					islandsWithin.append( island )
			if len( islandsWithin ) < 1:
				return
			self.addLayerLinesIfDifferent( aboveIndex )
			removedIsland = euclidean.getTransferClosestSurroundingLoopComplexFunctionPlaceholder( self.oldOrderedLocation, islandsWithin, self )
			self.islandLayers[ aboveIndex ].remove( removedIsland )

	def getBottomLayerIndex( self ):
		"Get the index of the first island layer which has islands."
		for islandLayerIndex in range( len( self.islandLayers ) ):
			if len( self.islandLayers[ islandLayerIndex ] ) > 0:
				return islandLayerIndex
		return None

	def getRounded( self, number ):
		"Get number rounded to the number of carried decimal places as a string."
		return euclidean.getRoundedToDecimalPlaces( self.decimalPlacesCarried, number )

	def isInsideRemovedOutsideCone( self, island, removedBoundingLoop, untilLayerIndex ):
		"Determine if the island is entirely inside the removed bounding loop and outside the collision cone of the remaining islands."
		if not island.boundingLoop.isEntirelyInsideAnother( removedBoundingLoop ):
			return False
		bottomLayerIndex = self.getBottomLayerIndex()
		coneAngleTangent = math.tan( math.radians( self.towerPreferences.extruderPossibleCollisionConeAngle.value ) )
		for layerIndex in range( bottomLayerIndex, untilLayerIndex ):
			islands = self.islandLayers[ layerIndex ]
			outsetDistance = self.extrusionWidth * ( untilLayerIndex - layerIndex ) * coneAngleTangent + 0.5 * self.extrusionWidth
			for belowIsland in self.islandLayers[ layerIndex ]:
				outsetIslandLoop = belowIsland.boundingLoop.getOutsetBoundingLoop( outsetDistance )
				if island.boundingLoop.isOverlappingAnother( outsetIslandLoop ):
					return False
		return True

	def linearMove( self, splitLine ):
		"Add a linear move to the loop."
		location = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		self.feedrateMinute = gcodec.getFeedrateMinute( self.feedrateMinute, splitLine )
		self.feedrateTable[ location ] = self.feedrateMinute
		if self.extruderActive:
			self.addToExtrusion( location )
		self.oldLocation = location

	def parseGcode( self, gcodeText, towerPreferences ):
		"Parse gcode text and store the tower gcode."
		self.lines = gcodec.getTextLines( gcodeText )
		self.towerPreferences = towerPreferences
		self.parseInitialization()
		self.oldLocation = None
		if gcodec.isThereAFirstWord( '(<operatingLayerEnd>', self.lines, self.lineIndex ):
			self.parseUntilOperatingLayer()
		for lineIndex in range( self.lineIndex, len( self.lines ) ):
			self.parseLine( lineIndex )
		for threadLayer in self.threadLayers:
			self.addIslandLayer( threadLayer )
		for self.layerIndex in range( min( len( self.islandLayers ), towerPreferences.towerStartLayer.value ) ):
			self.addEntireLayer( self.layerIndex )
		self.addTowers()
		self.addShutdownToOutput()

	def parseInitialization( self ):
		"Parse gcode initialization and store the parameters."
		for self.lineIndex in range( len( self.lines ) ):
			line = self.lines[ self.lineIndex ]
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			if firstWord == '(<extrusionStart>':
				self.addLine( '(<procedureDone> tower )' )
				self.addLine( line )
				return
			if firstWord == '(<decimalPlacesCarried>':
				self.decimalPlacesCarried = int( splitLine[ 1 ] )
			elif firstWord == '(<extrusionHeight>':
				self.halfExtrusionHeight = 0.5 * float( splitLine[ 1 ] )
			elif firstWord == '(<extrusionWidth>':
				self.extrusionWidth = float( splitLine[ 1 ] )
			self.addLine( line )

	def parseLine( self, lineIndex ):
		"Parse a gcode line."
		line = self.lines[ lineIndex ]
		splitLine = line.split()
		if len( splitLine ) < 1:
			return
		firstWord = splitLine[ 0 ]
		if firstWord == 'G1':
			self.linearMove( splitLine )
		if firstWord == 'M101':
			self.extruderActive = True
		elif firstWord == 'M103':
			self.extruderActive = False
			self.thread = None
			self.isLoop = False
			self.isPerimeter = False
		elif firstWord == '(<boundaryPoint>':
			location = gcodec.getLocationFromSplitLine( None, splitLine )
			self.surroundingLoop.addToBoundary( location )
		elif firstWord == '(</extrusionStart>':
			self.shutdownLineIndex = lineIndex
		elif firstWord == '(<layerStart>':
			if self.beforeExtrusionLines != None:
				for beforeExtrusionLine in self.beforeExtrusionLines:
					self.addLine( beforeExtrusionLine )
			self.beforeExtrusionLines = []
			self.threadLayer = None
			self.thread = None
		elif firstWord == '(<loop>':
			self.isLoop = True
		elif firstWord == '(<perimeter>':
			self.isPerimeter = True
		elif firstWord == '(<surroundingLoop>':
			self.surroundingLoop = euclidean.SurroundingLoopZ()
			if self.threadLayer == None:
				self.threadLayer = ThreadLayer()
				if self.beforeExtrusionLines != None:
					self.threadLayer.beforeExtrusionLines = self.beforeExtrusionLines
					self.beforeExtrusionLines = None
				self.threadLayers.append( self.threadLayer )
			self.threadLayer.surroundingLoops.append( self.surroundingLoop )
			self.threadLayer.boundaries.append( self.surroundingLoop.boundary )
		elif firstWord == '(</surroundingLoop>':
			self.surroundingLoop = None
		if self.beforeExtrusionLines != None:
			self.beforeExtrusionLines.append( line )

	def parseUntilOperatingLayer( self ):
		"Parse gcode until the operating layer if there is one."
		for self.lineIndex in range( self.lineIndex, len( self.lines ) ):
			line = self.lines[ self.lineIndex ]
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			self.addLine( line )
			if firstWord == '(<operatingLayerEnd>':
				return


def main( hashtable = None ):
	"Display the tower dialog."
	if len( sys.argv ) > 1:
		writeOutput( ' '.join( sys.argv[ 1 : ] ) )
	else:
		preferences.displayDialog( TowerPreferences() )

if __name__ == "__main__":
	main()
