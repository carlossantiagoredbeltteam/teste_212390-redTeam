"""
Comb is a script to comb the extrusion hair of a gcode file.

The default 'Activate Comb' checkbox is on.  When it is on, the functions described below will work, when it is off, the functions
will not be called.

Comb bends the extruder travel paths around holes in the slice, to avoid stringers.  It moves the extruder to the inside of outer
perimeters before turning the extruder on so any start up ooze will be inside the shape.  It jitters the loop end position to a
different place on each layer to prevent the a ridge from forming.  The 'Arrival Inset Follow Distance over Extrusion Width' is the
ratio of the amount before the start of the outer perimeter the extruder will be moved to.  A high value means the extruder will
move way before the beginning of the perimeter and a low value means the extruder will be moved just before the beginning.
The "Jitter Over Extrusion Width (ratio)" is the ratio of the amount the loop ends will be jittered.  A high value means the loops
will start all over the place and a low value means loops will start at roughly the same place on each layer.  The 'Minimum
Perimeter Departure Distance over Extrusion Width' is the ratio of the minimum distance that the extruder will travel and loop
before leaving an outer perimeter.  A high value means the extruder will loop many times before leaving, so that the ooze will
finish within the perimeter, a low value means the extruder will not loop and a stringer might be created from the outer
perimeter.  To run comb, in a shell type:
> python comb.py

The following examples comb the files Screw Holder Bottom.gcode & Screw Holder Bottom.stl.  The examples are run in a terminal in the folder
which contains Screw Holder Bottom.gcode, Screw Holder Bottom.stl and comb.py.  The comb function will comb if 'Activate Comb' is true, which
can be set in the dialog or by changing the preferences file 'comb.csv' in the '.skeinforge' folder in your home directory with a text
editor or a spreadsheet program set to separate tabs.  The functions writeOutput and getCombChainGcode check to see if the
text has been combed, if not they call getTowerChainGcode in tower.py to tower the text; once they have the towered text, then
they comb.  Pictures of combing in action are available from the Metalab blog at:
http://reprap.soup.io/?search=combing


> python comb.py
This brings up the dialog, after clicking 'Comb', the following is printed:
File Screw Holder Bottom.stl is being chain combed.
The combed file is saved as Screw Holder Bottom_comb.gcode


>python
Python 2.5.1 (r251:54863, Sep 22 2007, 01:43:31)
[GCC 4.2.1 (SUSE Linux)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import comb
>>> comb.main()
This brings up the comb dialog.


>>> comb.writeOutput()
Screw Holder Bottom.stl
File Screw Holder Bottom.stl is being chain combed.
The combed file is saved as Screw Holder Bottom_comb.gcode


>>> comb.getCombGcode("
( GCode generated by May 8, 2008 slice.py )
( Extruder Initialization )
..
many lines of gcode
..
")


>>> comb.getCombChainGcode("
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

from skeinforge_tools.skeinforge_utilities import euclidean
from skeinforge_tools.skeinforge_utilities import gcodec
from skeinforge_tools.skeinforge_utilities import intercircle
from skeinforge_tools.skeinforge_utilities import preferences
from skeinforge_tools import analyze
from skeinforge_tools import import_translator
from skeinforge_tools import polyfile
from skeinforge_tools import tower
import cStringIO
import math
import sys
import time


__author__ = "Enrique Perez (perez_enrique@yahoo.com)"
__date__ = "$Date: 2008/21/04 $"
__license__ = "GPL 3.0"

#patched over falling tower comb bug if location.z < self.getBetweens()[ 0 ][ 0 ].z + 0.5 * self.extrusionWidth, but a real solution would be nice
#addLoopsBeforeLeavingPerimeter or something before crossing bug, seen on layer 8 of Screw holder
def getCombChainGcode( filename, gcodeText, combPreferences = None ):
	"Comb a gcode linear move text.  Chain comb the gcode if it is not already combed."
	gcodeText = gcodec.getGcodeFileText( filename, gcodeText )
	if not gcodec.isProcedureDone( gcodeText, 'tower' ):
		gcodeText = tower.getTowerChainGcode( filename, gcodeText )
	return getCombGcode( gcodeText, combPreferences )

def getCombGcode( gcodeText, combPreferences = None ):
	"Comb a gcode linear move text."
	if gcodeText == '':
		return ''
	if gcodec.isProcedureDone( gcodeText, 'comb' ):
		return gcodeText
	if combPreferences == None:
		combPreferences = CombPreferences()
		preferences.readPreferences( combPreferences )
	if not combPreferences.activateComb.value:
		return gcodeText
	skein = CombSkein()
	skein.parseGcode( combPreferences, gcodeText )
	return skein.output.getvalue()

def isLoopNumberEqual( betweenX, betweenXIndex, loopNumber ):
	"Determine if the loop number is equal."
	if betweenXIndex >= len( betweenX ):
		return False
	return betweenX[ betweenXIndex ].index == loopNumber

def writeOutput( filename = '' ):
	"Comb a gcode linear move file.  Chain comb the gcode if it is not already combed.  If no filename is specified, comb the first unmodified gcode file in this folder."
	if filename == '':
		unmodified = import_translator.getGNUTranslatorFilesUnmodified()
		if len( unmodified ) == 0:
			print( "There are no unmodified gcode files in this folder." )
			return
		filename = unmodified[ 0 ]
	combPreferences = CombPreferences()
	preferences.readPreferences( combPreferences )
	startTime = time.time()
	print( 'File ' + gcodec.getSummarizedFilename( filename ) + ' is being chain combed.' )
	suffixFilename = filename[ : filename.rfind( '.' ) ] + '_comb.gcode'
	combGcode = getCombChainGcode( filename, '', combPreferences )
	if combGcode == '':
		return
	gcodec.writeFileText( suffixFilename, combGcode )
	print( 'The combed file is saved as ' + gcodec.getSummarizedFilename( suffixFilename ) )
	analyze.writeOutput( suffixFilename, combGcode )
	print( 'It took ' + str( int( round( time.time() - startTime ) ) ) + ' seconds to comb the file.' )


class CombPreferences:
	"A class to handle the comb preferences."
	def __init__( self ):
		"Set the default preferences, execute title & preferences filename."
		#Set the default preferences.
		self.archive = []
		self.activateComb = preferences.BooleanPreference().getFromValue( 'Activate Comb', True )
		self.archive.append( self.activateComb )
		self.arrivalInsetFollowDistanceOverExtrusionWidth = preferences.FloatPreference().getFromValue( 'Arrival Inset Follow Distance over Extrusion Width (ratio):', 3.0 )
		self.archive.append( self.arrivalInsetFollowDistanceOverExtrusionWidth )
		self.jitterOverExtrusionWidth = preferences.FloatPreference().getFromValue( 'Jitter Over Extrusion Width (ratio):', 2.0 )
		self.archive.append( self.jitterOverExtrusionWidth )
		self.minimumPerimeterDepartureDistanceOverExtrusionWidth = preferences.FloatPreference().getFromValue( 'Minimum Perimeter Departure Distance over Extrusion Width (ratio):', 30.0 )
		self.archive.append( self.minimumPerimeterDepartureDistanceOverExtrusionWidth )
		self.filenameInput = preferences.Filename().getFromFilename( import_translator.getGNUTranslatorGcodeFileTypeTuples(), 'Open File to be Combed', '' )
		self.archive.append( self.filenameInput )
		#Create the archive, title of the execute button, title of the dialog & preferences filename.
		self.executeTitle = 'Comb'
		self.filenamePreferences = preferences.getPreferencesFilePath( 'comb.csv' )
		self.filenameHelp = 'skeinforge_tools.comb.html'
		self.saveTitle = 'Save Preferences'
		self.title = 'Comb Preferences'

	def execute( self ):
		"Comb button has been clicked."
		filenames = polyfile.getFileOrDirectoryTypesUnmodifiedGcode( self.filenameInput.value, import_translator.getGNUTranslatorFileTypes(), self.filenameInput.wasCancelled )
		for filename in filenames:
			writeOutput( filename )


class CombSkein:
	"A class to comb a skein of extrusions."
	def __init__( self ):
		self.beforeLoopLocation = None
		self.betweenTable = {}
		self.boundaryLoop = None
		self.bridgeExtrusionWidthOverSolid = 1.0
		self.fillInset = 0.18
		self.isPerimeter = False
		self.layerFillInset = self.fillInset
		self.layer = None
		self.layers = []
		self.layerTable = {}
		self.layerZ = None
		self.lineIndex = 0
		self.lines = None
		self.nextLayerZ = None
		self.oldZ = None
		self.perimeter = None
		self.pointTable = {}
		self.initializeMoreParameters()

	def addGcodeFromThreadZ( self, thread, z ):
		"Add a gcode thread to the output."
		if len( thread ) > 0:
			self.addGcodeMovementZ( thread[ 0 ], z )
		else:
			print( "zero length vertex positions array which was skipped over, this should never happen" )
		if len( thread ) < 2:
			return
		self.addLine( 'M101' )
		self.addGcodePathZ( thread[ 1 : ], z )

	def addGcodeMovementZ( self, point, z ):
		"Add a movement to the output."
		if self.feedrateMinute == None:
			self.addLine( "G1 X%s Y%s Z%s" % ( self.getRounded( point.real ), self.getRounded( point.imag ), self.getRounded( z ) ) )
		else:
			self.addLine( "G1 X%s Y%s Z%s F%s" % ( self.getRounded( point.real ), self.getRounded( point.imag ), self.getRounded( z ), self.getRounded( self.feedrateMinute ) ) )

	def addGcodePathZ( self, path, z ):
		"Add a gcode path, without modifying the extruder, to the output."
		for point in path:
			self.addGcodeMovementZ( point, z )

	def addIfTravel( self, splitLine ):
		"Add travel move around loops if the extruder is off."
		location = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		if not self.extruderActive and self.oldLocation != None:
			if len( self.getBetweens() ) > 0:
				self.addGcodePathZ( self.getAroundBetweenPath( location ), location.z )
		self.oldLocation = location

	def addLine( self, line ):
		"Add a line of text and a newline to the output."
		self.output.write( line + "\n" )

	def addPathBeforeEnd( self, aroundBetweenPath, location, loop ):
		"Add the path before the end of the loop."
		halfFillInset = 0.5 * self.layerFillInset
		if self.arrivalInsetFollowDistance < halfFillInset:
			return
		locationComplex = location.dropAxis( 2 )
		closestInset = None
		closestDistanceIndex = euclidean.DistanceIndex( 999999999999999999.0, - 1 )
		loop = euclidean.getAwayPoints( loop, self.extrusionWidth )
		circleNodes = intercircle.getCircleNodesFromLoop( loop, self.layerFillInset )
		centers = []
		centers = intercircle.getCentersFromCircleNodes( circleNodes )
		for center in centers:
			inset = intercircle.getInsetFromClockwiseLoop( center, halfFillInset )
			if euclidean.isLargeSameDirection( inset, center, self.layerFillInset ):
				if euclidean.isPathInsideLoop( loop, inset ) == euclidean.isWiddershins( loop ):
					distanceIndex = euclidean.getNearestDistanceIndex( locationComplex, inset )
					if distanceIndex.distance < closestDistanceIndex.distance:
						closestInset = inset
						closestDistanceIndex = distanceIndex
		if closestInset == None:
			return
		extrusionHalfWidth = 0.5 * self.extrusionWidth
		closestInset = euclidean.getLoopStartingNearest( extrusionHalfWidth, locationComplex, closestInset )
		if euclidean.getPolygonLength( closestInset ) < 0.2 * self.arrivalInsetFollowDistance:
			return
		closestInset.append( closestInset[ 0 ] )
		closestInset = euclidean.getSimplifiedPath( closestInset, self.extrusionWidth )
		closestInset.reverse()
		pathBeforeArrival = euclidean.getClippedAtEndLoopPath( self.arrivalInsetFollowDistance, closestInset )
		pointBeforeArrival = pathBeforeArrival[ - 1 ]
		aroundBetweenPath.append( pointBeforeArrival )
		if self.arrivalInsetFollowDistance <= halfFillInset:
			return
		aroundBetweenPath += euclidean.getClippedAtEndLoopPath( halfFillInset, closestInset )[ len( pathBeforeArrival ) - 1 : ]

	def addPathBetween( self, aroundBetweenPath, betweenFirst, betweenSecond, isLeavingPerimeter, loopFirst ):
		"Add a path between the perimeter and the fill."
		clockwisePath = [ betweenFirst ]
		widdershinsPath = [ betweenFirst ]
		nearestFirstDistanceIndex = euclidean.getNearestDistanceIndex( betweenFirst, loopFirst )
		nearestSecondDistanceIndex = euclidean.getNearestDistanceIndex( betweenSecond, loopFirst )
		firstBeginIndex = ( nearestFirstDistanceIndex.index + 1 ) % len( loopFirst )
		secondBeginIndex = ( nearestSecondDistanceIndex.index + 1 ) % len( loopFirst )
		loopBeforeLeaving = euclidean.getAroundLoop( firstBeginIndex, firstBeginIndex, loopFirst )
		if nearestFirstDistanceIndex.index == nearestSecondDistanceIndex.index:
			nearestPoint = euclidean.getNearestPointOnSegment( loopFirst[ nearestSecondDistanceIndex.index ], loopFirst[ secondBeginIndex ], betweenSecond )
			widdershinsPath += [ nearestPoint ]
			clockwisePath += [ nearestPoint ]
			if euclidean.getPathLength( widdershinsPath ) < self.minimumPerimeterDepartureDistance:
				widdershinsPath = [ betweenFirst ] + loopBeforeLeaving + [ nearestPoint ]
				reversedLoop = loopBeforeLeaving[ : ]
				reversedLoop.reverse()
				clockwisePath = [ betweenFirst ] + reversedLoop + [ nearestPoint ]
		else:
			widdershinsLoop = euclidean.getAroundLoop( firstBeginIndex, secondBeginIndex, loopFirst )
			widdershinsPath += widdershinsLoop
			clockwiseLoop = euclidean.getAroundLoop( secondBeginIndex, firstBeginIndex, loopFirst )
			clockwiseLoop.reverse()
			clockwisePath += clockwiseLoop
			clockwisePath.append( betweenSecond )
			widdershinsPath.append( betweenSecond )
		if euclidean.getPathLength( widdershinsPath ) > euclidean.getPathLength( clockwisePath ):
			loopBeforeLeaving.reverse()
			widdershinsPath = clockwisePath
		if isLeavingPerimeter:
			totalDistance = euclidean.getPathLength( widdershinsPath )
			loopLength = euclidean.getPolygonLength( loopBeforeLeaving )
			while totalDistance < self.minimumPerimeterDepartureDistance:
				widdershinsPath = [ betweenFirst ] + loopBeforeLeaving + widdershinsPath[ 1 : ]
				totalDistance += loopLength
		aroundBetweenPath += widdershinsPath

	def addTailoredLoopPath( self ):
		"Add a clipped and jittered loop path."
		loop = self.loopPath.path[ : - 1 ]
		jitterDistance = self.layerJitter + self.arrivalInsetFollowDistance
		if self.beforeLoopLocation != None:
			extrusionHalfWidth = 0.5 * self.extrusionWidth
			loop = euclidean.getLoopStartingNearest( extrusionHalfWidth, self.beforeLoopLocation, loop )
		if jitterDistance != 0.0:
			loop = self.getJitteredLoop( jitterDistance, loop )
			loop = euclidean.getAwayPoints( loop, 0.2 * self.layerFillInset )
		self.loopPath.path = loop + [ loop[ 0 ] ]
		self.addGcodeFromThreadZ( self.loopPath.path, self.loopPath.z )
		self.loopPath = None

	def addToLoop( self, location ):
		"Add a location to loop."
		if self.layer == None:
			if not self.oldZ in self.layerTable:
				self.layerTable[ self.oldZ ] = []
			self.layer = self.layerTable[ self.oldZ ]
		if self.boundaryLoop == None:
			self.boundaryLoop = [] #starting with an empty array because a closed loop does not have to restate its beginning
			self.layer.append( self.boundaryLoop )
		if self.boundaryLoop != None:
			self.boundaryLoop.append( location.dropAxis( 2 ) )

	def getAroundBetweenPath( self, location ):
		"Insert paths around and between the perimeter and the fill."
		aroundBetweenPath = []
		outerPerimeter = None
		if str( location ) in self.pointTable:
			perimeter = self.pointTable[ str( location ) ]
			if euclidean.isWiddershins( perimeter ):
				outerPerimeter = perimeter
		nextBeginning = self.getOutloopLocation( location )
		pathEnd = self.getOutloopLocation( self.oldLocation )
		self.insertPathsBetween( aroundBetweenPath, nextBeginning, pathEnd )
		if outerPerimeter != None:
			self.addPathBeforeEnd( aroundBetweenPath, location, outerPerimeter )
		return aroundBetweenPath

	def getBetweens( self ):
		"Set betweens for the layer."
		if self.layerZ in self.betweenTable:
			return self.betweenTable[ self.layerZ ]
		if self.layerZ not in self.layerTable:
			return []
		halfFillInset = 0.5 * self.layerFillInset
		betweens = []
		for boundaryLoop in self.layerTable[ self.layerZ ]:
			circleNodes = intercircle.getCircleNodesFromLoop( boundaryLoop, self.layerFillInset )
			centers = intercircle.getCentersFromCircleNodes( circleNodes )
			for center in centers:
				inset = intercircle.getSimplifiedInsetFromClockwiseLoop( center, halfFillInset )
				if euclidean.isLargeSameDirection( inset, center, self.layerFillInset ):
					if euclidean.isPathInsideLoop( boundaryLoop, inset ) == euclidean.isWiddershins( boundaryLoop ):
						betweens.append( inset )
		self.betweenTable[ self.layerZ ] = betweens
		return betweens

	def getJitteredLoop( self, jitterDistance, jitterLoop ):
		"Get a jittered loop path."
		loopLength = euclidean.getPolygonLength( jitterLoop )
		lastLength = 0.0
		pointIndex = 0
		totalLength = 0.0
		jitterPosition = ( jitterDistance + 256.0 * loopLength ) % loopLength
		while totalLength < jitterPosition and pointIndex < len( jitterLoop ):
			firstPoint = jitterLoop[ pointIndex ]
			secondPoint  = jitterLoop[ ( pointIndex + 1 ) % len( jitterLoop ) ]
			pointIndex += 1
			lastLength = totalLength
			totalLength += abs( firstPoint - secondPoint )
		remainingLength = jitterPosition - lastLength
		pointIndex = pointIndex % len( jitterLoop )
		ultimateJitteredPoint = jitterLoop[ pointIndex ]
		penultimateJitteredPointIndex = ( pointIndex + len( jitterLoop ) - 1 ) % len( jitterLoop )
		penultimateJitteredPoint = jitterLoop[ penultimateJitteredPointIndex ]
		segment = ultimateJitteredPoint - penultimateJitteredPoint
		segmentLength = abs( segment )
		originalOffsetLoop = euclidean.getAroundLoop( pointIndex, pointIndex, jitterLoop )
		if segmentLength <= 0.0:
			return [ penultimateJitteredPoint ] + originalOffsetLoop[ - 1 ]
		newUltimatePoint = penultimateJitteredPoint + segment * remainingLength / segmentLength
		return [ newUltimatePoint ] + originalOffsetLoop

	def getOutloopLocation( self, point ):
		"Get location outside of loop."
		pointComplex = point.dropAxis( 2 )
		if str( point ) not in self.pointTable:
			return pointComplex
		closestBetween = None
		closestDistanceIndex = euclidean.DistanceIndex( 999999999999999999.0, - 1 )
		for between in self.getBetweens():
			distanceIndex = euclidean.getNearestDistanceIndex( pointComplex, between )
			if distanceIndex.distance < closestDistanceIndex.distance:
				closestBetween = between
				closestDistanceIndex = distanceIndex
		if closestBetween == None:
			print( 'This should never happen, closestBetween should always exist.' )
			print( point )
			print( self.getBetweens() )
			return pointComplex
		closestIndex = closestDistanceIndex.index
		segmentBegin = closestBetween[ closestIndex ]
		segmentEnd = closestBetween[ ( closestIndex + 1 ) % len( closestBetween ) ]
		nearestPoint = euclidean.getNearestPointOnSegment( segmentBegin, segmentEnd, pointComplex )
		distanceToNearestPoint = abs( pointComplex - nearestPoint )
		nearestMinusOld = 1.5 * ( nearestPoint - pointComplex )
		return pointComplex + nearestMinusOld

	def getRounded( self, number ):
		"Get number rounded to the number of carried decimal places as a string."
		return euclidean.getRoundedToDecimalPlaces( self.decimalPlacesCarried, number )

	def getStartIndex( self, xIntersections ):
		"Get the start index of the intersections."
		startIndex = 0
		while startIndex < len( xIntersections ) - 1:
			xIntersectionFirst = xIntersections[ startIndex ]
			xIntersectionSecond = xIntersections[ startIndex + 1 ]
			loopFirst = self.getBetweens()[ xIntersectionFirst.index ]
			loopSecond = self.getBetweens()[ xIntersectionSecond.index ]
			if loopFirst == loopSecond:
				return startIndex % 2
			startIndex += 1
		return 0

	def initializeMoreParameters( self ):
		"Add a movement to the output."
		self.extruderActive = False
		self.feedrateMinute = None
		self.isLoopPerimeter = False
		self.layerGolden = 0.0
		self.loopPath = None
		self.oldLocation = None
		self.output = cStringIO.StringIO()

	def insertPathsBetween( self, aroundBetweenPath, nextBeginning, pathEnd ):
		"Insert paths between the perimeter and the fill."
		betweenX = []
		switchX = []
		segment = euclidean.getNormalized( nextBeginning - pathEnd )
		segmentYMirror = complex( segment.real, - segment.imag )
		pathEndRotated = segmentYMirror * pathEnd
		nextBeginningRotated = segmentYMirror * nextBeginning
		y = pathEndRotated.imag
		for betweenIndex in xrange( len( self.getBetweens() ) ):
			between = self.getBetweens()[ betweenIndex ]
			betweenRotated = euclidean.getPointsRoundZAxis( segmentYMirror, between )
			euclidean.addXIntersectionIndexes( betweenRotated, betweenIndex, switchX, y )
		switchX.sort()
		maximumX = max( pathEndRotated.real, nextBeginningRotated.real )
		minimumX = min( pathEndRotated.real, nextBeginningRotated.real )
		for xIntersection in switchX:
			if xIntersection.x > minimumX and xIntersection.x < maximumX:
				betweenX.append( xIntersection )
		betweenXIndex = self.getStartIndex( betweenX )
		while betweenXIndex < len( betweenX ) - 1:
			betweenXFirst = betweenX[ betweenXIndex ]
			betweenXSecond = betweenX[ betweenXIndex + 1 ]
			loopFirst = self.getBetweens()[ betweenXFirst.index ]
			betweenFirst = segment * complex( betweenXFirst.x, y )
			betweenSecond = segment * complex( betweenXSecond.x, y )
			isLeavingPerimeter = False
			if betweenXSecond.index != betweenXFirst.index:
				isLeavingPerimeter = True
			self.addPathBetween( aroundBetweenPath, betweenFirst, betweenSecond, isLeavingPerimeter, loopFirst )
			betweenXIndex += 2

	def isNextExtruderOn( self ):
		"Determine if there is an extruder on command before a move command."
		line = self.lines[ self.lineIndex ]
		splitLine = line.split()
		for afterIndex in xrange( self.lineIndex + 1, len( self.lines ) ):
			line = self.lines[ afterIndex ]
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			if firstWord == 'G1' or firstWord == 'M103':
				return False
			elif firstWord == 'M101':
				return True
		return False

	def linearMove( self, splitLine ):
		"Add to loop path if this is a loop or path."
		location = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		self.feedrateMinute = gcodec.getFeedrateMinute( self.feedrateMinute, splitLine )
		if self.isLoopPerimeter:
			if self.isNextExtruderOn():
				self.loopPath = euclidean.PathZ( location.z )
				self.beforeLoopLocation = self.oldLocation.dropAxis( 2 )
		if self.loopPath != None:
			self.loopPath.path.append( location.dropAxis( 2 ) )
		self.oldLocation = location

	def parseAddJitter( self, line ):
		"Parse a gcode line, jitter it and add it to the comb skein."
		splitLine = line.split()
		if len( splitLine ) < 1:
			return
		firstWord = splitLine[ 0 ]
		if firstWord == 'G1':
			self.linearMove( splitLine )
		elif firstWord == 'M103':
			self.isLoopPerimeter = False
			if self.loopPath != None:
				self.addTailoredLoopPath()
		elif firstWord == '(<layerStart>':
			self.layerGolden += 0.61803398874989479
			self.layerJitter = self.jitter * ( math.fmod( self.layerGolden, 1.0 ) - 0.5 )
		elif firstWord == '(<loop>' or firstWord == '(<perimeter>':
			self.isLoopPerimeter = True
		if self.loopPath == None:
			self.addLine( line )

	def parseAddTravel( self, line ):
		"Parse a gcode line and add it to the comb skein."
		splitLine = line.split()
		if len( splitLine ) < 1:
			return
		firstWord = splitLine[ 0 ]
		if firstWord == 'G1':
			self.addIfTravel( splitLine )
			self.layerZ = self.nextLayerZ
		elif firstWord == 'M101':
			self.extruderActive = True
		elif firstWord == 'M103':
			self.extruderActive = False
		elif firstWord == '(<bridgeLayer>':
			self.layerFillInset = self.fillInset * self.bridgeExtrusionWidthOverSolid
		elif firstWord == '(<layerStart>':
			self.layerFillInset = self.fillInset
			self.nextLayerZ = float( splitLine[ 1 ] )
			if self.layerZ == None:
				self.layerZ = self.nextLayerZ
		self.addLine( line )

	def parseGcode( self, combPreferences, gcodeText ):
		"Parse gcode text and store the comb gcode."
		self.lines = gcodec.getTextLines( gcodeText )
		self.parseInitialization( combPreferences )
		for self.lineIndex in xrange( self.lineIndex, len( self.lines ) ):
			line = self.lines[ self.lineIndex ]
			self.parseAddJitter( line )
		self.lines = gcodec.getTextLines( self.output.getvalue() )
		self.initializeMoreParameters()
		for self.lineIndex in xrange( len( self.lines ) ):
			line = self.lines[ self.lineIndex ]
			self.parseLine( combPreferences, line )
		for self.lineIndex in xrange( len( self.lines ) ):
			line = self.lines[ self.lineIndex ]
			self.parseAddTravel( line )

	def parseInitialization( self, combPreferences ):
		"Parse gcode initialization and store the parameters."
		for self.lineIndex in xrange( len( self.lines ) ):
			line = self.lines[ self.lineIndex ]
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			if firstWord == '(<bridgeExtrusionWidthOverSolid>':
				self.bridgeExtrusionWidthOverSolid = float( splitLine[ 1 ] )
			elif firstWord == '(<decimalPlacesCarried>':
				self.decimalPlacesCarried = int( splitLine[ 1 ] )
			elif firstWord == '(<extrusionStart>':
				self.addLine( '(<procedureDone> comb )' )
				return
			elif firstWord == '(<extrusionWidth>':
				self.extrusionWidth = float( splitLine[ 1 ] )
				self.arrivalInsetFollowDistance = combPreferences.arrivalInsetFollowDistanceOverExtrusionWidth.value * self.extrusionWidth
				self.jitter = combPreferences.jitterOverExtrusionWidth.value * self.extrusionWidth
				self.minimumPerimeterDepartureDistance = combPreferences.minimumPerimeterDepartureDistanceOverExtrusionWidth.value * self.extrusionWidth
			elif firstWord == '(<fillInset>':
				self.fillInset = float( splitLine[ 1 ] )
			self.addLine( line )

	def parseLine( self, combPreferences, line ):
		"Parse a gcode line."
		splitLine = line.split()
		if len( splitLine ) < 1:
			return
		firstWord = splitLine[ 0 ]
		if firstWord == 'G1':
			if self.isPerimeter:
				location = gcodec.getLocationFromSplitLine( None, splitLine )
				self.pointTable[ str( location ) ] = self.boundaryLoop
		elif firstWord == 'M103':
			self.boundaryLoop = None
			self.isPerimeter = False
		elif firstWord == '(<boundaryPoint>':
			location = gcodec.getLocationFromSplitLine( None, splitLine )
			self.addToLoop( location )
		elif firstWord == '(<layerStart>':
			self.boundaryLoop = None
			self.layer = None
			self.oldZ = float( splitLine[ 1 ] )
		elif firstWord == '(<perimeter>':
			self.isPerimeter = True


def main( hashtable = None ):
	"Display the comb dialog."
	if len( sys.argv ) > 1:
		writeOutput( ' '.join( sys.argv[ 1 : ] ) )
	else:
		preferences.displayDialog( CombPreferences() )

if __name__ == "__main__":
	main()
