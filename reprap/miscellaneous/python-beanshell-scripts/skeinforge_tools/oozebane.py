"""
Oozebane is a script to turn off the extruder before the end of a thread and turn it on before the beginning.

The default 'Activate Oozebane' checkbox is on.  When it is on, the functions described below will work, when it is off, the functions
will not be called.

The important value for the oozebane preferences is "Early Shutdown Distance Over Extrusion Width (ratio)" which is the ratio of the
distance before the end of the thread that the extruder will be turned off over the extrusion width, the default is 2.0.  A higher ratio
means the extruder will turn off sooner and the end of the line will be thinner.

When oozebane turns the extruder off, it slows the feedrate down in steps so in theory the thread will remain at roughly the same
thickness until the end.  The "Turn Off Steps" preference is the number of steps, the more steps the smaller the size of the step that
the feedrate will be decreased and the larger the size of the resulting gcode file, the default is 5.

Oozebane also turns the extruder on just before the start of a thread.  The "Early Startup Maximum Distance Over Extrusion Width"
preference is the ratio of the maximum distance before the thread starts that the extruder will be turned off over the extrusion width,
the default is 2.0.  The longer the extruder has been off, the sooner the extruder will turn back on, the ratio is one minus one over e
to the power of the distance the extruder has been off over the "Early Startup Distance Constant Over Extrusion Width".

The "Minimum Distance for Early Startup over Extrusion Width" ratio is the minimum distance that the extruder has to be off before
the thread begins over the extrusion width for the early start up feature to activate.  The "Minimum Distance for Early Shutdown
over Extrusion Width" ratio is the minimum distance that the extruder has to be off after the thread end over the extrusion width for
the early shutdown feature to activate.

After oozebane turns the extruder on, it slows the feedrate down where the thread starts.  Then it speeds it up in steps so in theory
the thread will remain at roughly the same thickness from the beginning.

To run oozebane, in a shell which oozebane is in type:
> python oozebane.py

The following examples oozebane the files Hollow Square.gcode & Hollow Square.gts.  The examples are run in a terminal in the
folder which contains Hollow Square.gcode, Hollow Square.gts and oozebane.py.  The oozebane function will oozebane if the
'Activate Oozebane' checkbox is on.  The functions writeOutput and getOozebaneChainGcode check to see if the text has been
oozebaned, if not they call the getNozzleWipeChainGcode in nozzle_wipe.py to nozzle wipe the text; once they have the nozzle
wiped text, then they oozebane.


> python oozebane.py
This brings up the dialog, after clicking 'Oozebane', the following is printed:
File Hollow Square.gts is being chain oozebaned.
The oozebaned file is saved as Hollow Square_oozebane.gcode


> python oozebane.py Hollow Square.gts
File Hollow Square.gts is being chain oozebaned.
The oozebaned file is saved as Hollow Square_oozebane.gcode


> python
Python 2.5.1 (r251:54863, Sep 22 2007, 01:43:31)
[GCC 4.2.1 (SUSE Linux)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import oozebane
>>> oozebane.main()
This brings up the oozebane dialog.


>>> oozebane.writeOutput()
File Hollow Square.gts is being chain oozebaned.
The oozebaned file is saved as Hollow Square_oozebane.gcode


>>> oozebane.getOozebaneGcode("
( GCode generated by May 8, 2008 slice.py )
( Extruder Initialization )
..
many lines of gcode
..
")


>>> oozebane.getOozebaneChainGcode("
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
from skeinforge_tools.skeinforge_utilities import preferences
from skeinforge_tools import analyze
from skeinforge_tools import import_translator
from skeinforge_tools import nozzle_wipe
from skeinforge_tools import polyfile
import cStringIO
import math
import sys
import time


__author__ = "Enrique Perez (perez_enrique@yahoo.com)"
__date__ = "$Date: 2008/21/04 $"
__license__ = "GPL 3.0"


def getOozebaneChainGcode( filename, gcodeText, oozebanePreferences = None ):
	"Oozebane a gcode linear move text.  Chain oozebane the gcode if it is not already oozebaned."
	gcodeText = gcodec.getGcodeFileText( filename, gcodeText )
	if not gcodec.isProcedureDone( gcodeText, 'nozzle_wipe' ):
		gcodeText = nozzle_wipe.getNozzleWipeChainGcode( filename, gcodeText )
	return getOozebaneGcode( gcodeText, oozebanePreferences )

def getOozebaneGcode( gcodeText, oozebanePreferences = None ):
	"Oozebane a gcode linear move text."
	if gcodeText == '':
		return ''
	if gcodec.isProcedureDone( gcodeText, 'oozebane' ):
		return gcodeText
	if oozebanePreferences == None:
		oozebanePreferences = OozebanePreferences()
		preferences.readPreferences( oozebanePreferences )
	if not oozebanePreferences.activateOozebane.value:
		return gcodeText
	skein = OozebaneSkein()
	skein.parseGcode( gcodeText, oozebanePreferences )
	return skein.output.getvalue()

def writeOutput( filename = '' ):
	"Oozebane a gcode linear move file.  Chain oozebane the gcode if it is not already oozebaned. If no filename is specified, oozebane the first unmodified gcode file in this folder."
	if filename == '':
		unmodified = import_translator.getGNUTranslatorFilesUnmodified()
		if len( unmodified ) == 0:
			print( "There are no unmodified gcode files in this folder." )
			return
		filename = unmodified[ 0 ]
	oozebanePreferences = OozebanePreferences()
	preferences.readPreferences( oozebanePreferences )
	startTime = time.time()
	print( 'File ' + gcodec.getSummarizedFilename( filename ) + ' is being chain oozebaned.' )
	suffixFilename = filename[ : filename.rfind( '.' ) ] + '_oozebane.gcode'
	oozebaneGcode = getOozebaneChainGcode( filename, '', oozebanePreferences )
	if oozebaneGcode == '':
		return
	gcodec.writeFileText( suffixFilename, oozebaneGcode )
	print( 'The oozebaned file is saved as ' + gcodec.getSummarizedFilename( suffixFilename ) )
	analyze.writeOutput( suffixFilename, oozebaneGcode )
	print( 'It took ' + str( int( round( time.time() - startTime ) ) ) + ' seconds to oozebane the file.' )


class OozebanePreferences:
	"A class to handle the oozebane preferences."
	def __init__( self ):
		"Set the default preferences, execute title & preferences filename."
		#Set the default preferences.
		self.archive = []
		self.activateOozebane = preferences.BooleanPreference().getFromValue( 'Activate Oozebane', False )
		self.archive.append( self.activateOozebane )
		self.afterStartupDistanceOverExtrusionWidth = preferences.FloatPreference().getFromValue( 'After Startup Distance over Extrusion Width (ratio):', 2.0 )
		self.archive.append( self.afterStartupDistanceOverExtrusionWidth )
		self.earlyStartupDistanceConstantOverExtrusionWidth = preferences.FloatPreference().getFromValue( 'Early Startup Distance Constant over Extrusion Width (ratio):', 30.0 )
		self.archive.append( self.earlyStartupDistanceConstantOverExtrusionWidth )
		self.earlyStartupMaximumDistanceOverExtrusionWidth = preferences.FloatPreference().getFromValue( 'Early Startup Maximum Distance over Extrusion Width (ratio):', 2.0 )
		self.archive.append( self.earlyStartupMaximumDistanceOverExtrusionWidth )
		self.filenameInput = preferences.Filename().getFromFilename( import_translator.getGNUTranslatorGcodeFileTypeTuples(), 'Open File to be Oozebaned', '' )
		self.archive.append( self.filenameInput )
		self.minimumDistanceForEarlyStartupOverExtrusionWidth = preferences.FloatPreference().getFromValue( 'Minimum Distance for Early Startup over Extrusion Width (ratio):', 10.0 )
		self.archive.append( self.minimumDistanceForEarlyStartupOverExtrusionWidth )
		self.minimumDistanceForEarlyShutdownOverExtrusionWidth = preferences.FloatPreference().getFromValue( 'Minimum Distance for Early Shutdown over Extrusion Width (ratio):', 10.0 )
		self.archive.append( self.minimumDistanceForEarlyShutdownOverExtrusionWidth )
		self.slowdownStartupSteps = preferences.IntPreference().getFromValue( 'Slowdown Startup Steps (positive integer):', 3 )
		self.archive.append( self.slowdownStartupSteps )
		self.shutdownDistanceOverExtrusionWidth = preferences.FloatPreference().getFromValue( 'Shutdown Distance over Extrusion Width (ratio):', 2.0 )
		self.archive.append( self.shutdownDistanceOverExtrusionWidth )
		#Create the archive, title of the execute button, title of the dialog & preferences filename.
		self.executeTitle = 'Oozebane'
		self.filenamePreferences = preferences.getPreferencesFilePath( 'oozebane.csv' )
		self.filenameHelp = 'skeinforge_tools.oozebane.html'
		self.saveTitle = 'Save Preferences'
		self.title = 'Oozebane Preferences'

	def execute( self ):
		"Oozebane button has been clicked."
		filenames = polyfile.getFileOrDirectoryTypesUnmodifiedGcode( self.filenameInput.value, import_translator.getGNUTranslatorFileTypes(), self.filenameInput.wasCancelled )
		for filename in filenames:
			writeOutput( filename )


class OozebaneSkein:
	"A class to oozebane a skein of extrusions."
	def __init__( self ):
		self.decimalPlacesCarried = 3
		self.earlyStartupDistance = None
		self.extruderActive = False
		self.extruderInactiveLongEnough= False
		self.feedrateMinute = 960.0
		self.isShutdownEarly = False
		self.isShutdownNeeded = False
		self.isStartupEarly = False
		self.lineIndex = 0
		self.lines = None
		self.oldLocation = None
		self.output = cStringIO.StringIO()
		self.shutdownStepIndex = 999999999
		self.startupStepIndex = 999999999

	def addAfterStartupLine( self, splitLine ):
		"Add the after startup lines."
		distanceAfterThreadBeginning = self.getDistanceAfterThreadBeginning()
		location = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		segment = self.oldLocation.minus( location )
		segmentLength = segment.length()
		distanceBack = distanceAfterThreadBeginning - self.afterStartupDistances[ self.startupStepIndex ]
		if segmentLength > 0.0:
			locationBack = location.plus( segment.times( distanceBack / segmentLength ) )
			feedrate = self.feedrateMinute * self.afterStartupFlowRates[ self.startupStepIndex ]
			if not self.isCloseToEither( locationBack, location, self.oldLocation ):
				self.addLine( self.getLinearMoveWithFeedrate( feedrate, locationBack ) )
		self.startupStepIndex += 1

	def addLine( self, line ):
		"Add a line of text and a newline to the output."
		if line != '':
			self.output.write( line + "\n" )

	def addLineSetShutdowns( self, line ):
		"Add a line and set the shutdown variables."
		self.addLine( line )
		self.isShutdownNeeded = False
		self.isShutdownEarly = True

	def getAddAfterStartupLines( self, line ):
		"Get and / or add after the startup lines."
		splitLine = line.split()
		while self.isDistanceAfterThreadBeginningGreater():
			self.addAfterStartupLine( splitLine )
		if self.startupStepIndex >= len( self.afterStartupDistances ):
			self.startupStepIndex = len( self.afterStartupDistances ) + 999999999999
			return line
		feedrate = self.feedrateMinute * self.getStartupFlowRateMultiplier( self.getDistanceAfterThreadBeginning() / self.afterStartupDistance, len( self.afterStartupDistances ) )
		return self.getLinearMoveWithFeedrateSplitLine( feedrate, splitLine )

	def getAddBeforeStartupLines( self, line ):
		"Get and / or add before the startup lines."
		distanceThreadBeginning = self.getDistanceToThreadBeginning()
		splitLine = line.split()
		if distanceThreadBeginning == None:
			return line
		self.extruderInactiveLongEnough = False
		self.isStartupEarly = True
		location = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		segment = self.oldLocation.minus( location )
		segmentLength = segment.length()
		distanceBack = self.earlyStartupDistance - distanceThreadBeginning
		if segmentLength <= 0.0:
			print( 'This should never happen, segmentLength is zero in getAddBeforeStartupLines in oozebane.' )
			self.extruderInactiveLongEnough = True
			self.isStartupEarly = False
			return line
		locationBack = location.plus( segment.times( distanceBack / segmentLength ) )
		self.addLine( self.getLinearMoveWithFeedrate( self.feedrateMinute, locationBack ) )
		self.addLine( 'M101' )
		if self.isCloseToEither( locationBack, location, self.oldLocation ):
			return ''
		return line

	def getAddShutSlowDownLine( self, line ):
		"Add the shutdown and slowdown lines."
		splitLine = line.split()
		distanceThreadEnd = self.getDistanceToThreadEnd()
		location = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		segment = self.oldLocation.minus( location )
		segmentLength = segment.length()
		distanceBack = self.earlyShutdownDistances[ self.shutdownStepIndex ] - distanceThreadEnd
		if self.shutdownStepIndex == 0:
			self.isShutdownNeeded = True
		if segmentLength > 0.0:
			locationBack = location.plus( segment.times( distanceBack / segmentLength ) )
			feedrate = self.feedrateMinute * self.earlyShutdownFlowRates[ self.shutdownStepIndex ]
			if self.isCloseToEither( locationBack, location, self.oldLocation ):
				feedrate = self.feedrateMinute * self.getShutdownFlowRateMultiplier( 1.0 - distanceThreadEnd / self.earlyShutdownDistance, len( self.earlyShutdownDistances ) )
				shutdownLine = self.getLinearMoveWithFeedrateSplitLine( feedrate, splitLine )
				self.addLine( shutdownLine )
				line = shutdownLine
			else:
				self.addLine( self.getLinearMoveWithFeedrate( feedrate, locationBack ) )
		if self.isShutdownNeeded:
			self.addLineSetShutdowns( 'M103' )
		self.shutdownStepIndex += 1
		return line

	def getAddShutSlowDownLines( self, line ):
		"Get and / or add the shutdown and slowdown lines."
		distanceThreadEnd = self.getDistanceToThreadEnd()
		while self.getDistanceToThreadEnd() != None:
			line = self.getAddShutSlowDownLine( line )
#		if distanceThreadEnd != None:
#			if distanceThreadEnd >= 0.0:
#				feedrate = self.feedrateMinute * self.getShutdownFlowRateMultiplier( 1.0 - distanceThreadEnd / self.earlyShutdownDistance, len( self.earlyShutdownDistances ) )
#				shutdownLine = self.getLinearMoveWithFeedrateSplitLine( feedrate, splitLine )
#				if self.isShutdownNeeded:
#					self.addLineSetShutdowns( shutdownLine )
#					return 'M103'
#				return shutdownLine
		return line

	def getDistanceAfterThreadBeginning( self ):
		"Get the distance after the beginning of the thread."
		line = self.lines[ self.lineIndex ]
		splitLine = line.split()
		lastThreadLocation = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		totalDistance = 0.0
		extruderOnReached = False
		for beforeIndex in xrange( self.lineIndex - 1, 3, - 1 ):
			line = self.lines[ beforeIndex ]
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			if firstWord == 'G1':
				location = gcodec.getLocationFromSplitLine( lastThreadLocation, splitLine )
				totalDistance += location.distance( lastThreadLocation )
				lastThreadLocation = location
				if extruderOnReached:
					return totalDistance
			elif firstWord == 'M101':
				extruderOnReached = True
		return None

	def getDistanceToExtruderOffCommand( self, remainingDistance ):
		"Get the distance to the word."
		line = self.lines[ self.lineIndex ]
		splitLine = line.split()
		lastThreadLocation = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		totalDistance = 0.0
		for afterIndex in xrange( self.lineIndex + 1, len( self.lines ) ):
			line = self.lines[ afterIndex ]
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			if firstWord == 'G1':
				location = gcodec.getLocationFromSplitLine( lastThreadLocation, splitLine )
				distanceToLastThreadLocation = location.distance( lastThreadLocation )
				totalDistance += distanceToLastThreadLocation
				lastThreadLocation = location
				if totalDistance >= remainingDistance:
					return None
			elif firstWord == 'M103':
				return totalDistance
		return None

	def getDistanceToThreadBeginning( self ):
		"Get the distance to the beginning of the thread."
		if self.earlyStartupDistance == None:
			return None
		line = self.lines[ self.lineIndex ]
		splitLine = line.split()
		lastThreadLocation = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		totalDistance = 0.0
		for afterIndex in xrange( self.lineIndex + 1, len( self.lines ) ):
			line = self.lines[ afterIndex ]
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			if firstWord == 'G1':
				location = gcodec.getLocationFromSplitLine( lastThreadLocation, splitLine )
				distanceToLastThreadLocation = location.distance( lastThreadLocation )
				totalDistance += distanceToLastThreadLocation
				lastThreadLocation = location
				if totalDistance >= self.earlyStartupDistance:
					return None
			elif firstWord == 'M101':
				return totalDistance
		return None

	def getDistanceToThreadBeginningAfterThreadEnd( self, remainingDistance ):
		"Get the distance to the thread beginning after the end of this thread."
		extruderOnReached = False
		line = self.lines[ self.lineIndex ]
		splitLine = line.split()
		lastThreadLocation = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		threadEndReached = False
		totalDistance = 0.0
		for afterIndex in xrange( self.lineIndex + 1, len( self.lines ) ):
			line = self.lines[ afterIndex ]
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			if firstWord == 'G1':
				location = gcodec.getLocationFromSplitLine( lastThreadLocation, splitLine )
				distanceToLastThreadLocation = location.distance( lastThreadLocation )
				lastThreadLocation = location
				if threadEndReached:
					totalDistance += distanceToLastThreadLocation
					if totalDistance >= remainingDistance:
						return None
					if extruderOnReached:
						return totalDistance
			elif firstWord == 'M101':
				extruderOnReached = True
			elif firstWord == 'M103':
				threadEndReached = True
		return None

	def getDistanceToThreadEnd( self ):
		"Get the distance to the end of the thread."
		if self.shutdownStepIndex >= len( self.earlyShutdownDistances ):
			return None
		return self.getDistanceToExtruderOffCommand( self.earlyShutdownDistances[ self.shutdownStepIndex ] )

	def getLinearMoveWithFeedrate( self, feedrate, location ):
		"Get a linear move line with the feedrate."
		return 'G1 X%s Y%s Z%s F%s' % ( self.getRounded( location.x ), self.getRounded( location.y ), self.getRounded( location.z ), self.getRounded( feedrate ) )

	def getLinearMoveWithFeedrateSplitLine( self, feedrate, splitLine ):
		"Get a linear move line with the feedrate and split line."
		location = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		return self.getLinearMoveWithFeedrate( feedrate, location )

	def getOozebaneLine( self, line ):
		"Get oozebaned gcode line."
		splitLine = line.split()
		self.feedrateMinute = gcodec.getFeedrateMinute( self.feedrateMinute, splitLine )
		if self.oldLocation == None:
			return line
		if self.startupStepIndex < len( self.afterStartupDistances ):
			return self.getAddAfterStartupLines( line )
		if self.extruderInactiveLongEnough:
			return self.getAddBeforeStartupLines( line )
		if self.shutdownStepIndex < len( self.earlyShutdownDistances ):
			return self.getAddShutSlowDownLines( line )
		return line

	def getRounded( self, number ):
		"Get number rounded to the number of carried decimal places as a string."
		return euclidean.getRoundedToDecimalPlaces( self.decimalPlacesCarried, number )

	def getShutdownFlowRateMultiplier( self, along, numberOfDistances ):
		"Get the shut down flow rate multipler."
		if numberOfDistances <= 0:
			return 1.0
		return 1.0 - 0.5 / float( numberOfDistances ) - along * float( numberOfDistances - 1 ) / float( numberOfDistances )

	def getStartupFlowRateMultiplier( self, along, numberOfDistances ):
		"Get the startup flow rate multipler."
		if numberOfDistances <= 0:
			return 1.0
		return min( 1.0, 0.5 / float( numberOfDistances ) + along )

	def isClose( self, location, otherLocation ):
		"Determine if the location is close to the other location."
		return location.distance2( otherLocation ) < self.closeSquared

	def isCloseToEither( self, location, otherLocationFirst, otherLocationSecond ):
		"Determine if the location is close to the other locations."
		if self.isClose( location, otherLocationFirst ):
			return True
		return self.isClose( location, otherLocationSecond )

	def isDistanceAfterThreadBeginningGreater( self ):
		"Determine if the distance after the thread beginning is greater than the step index after startup distance."
		if self.startupStepIndex >= len( self.afterStartupDistances ):
			return False
		return self.getDistanceAfterThreadBeginning() > self.afterStartupDistances[ self.startupStepIndex ]

	def parseGcode( self, gcodeText, oozebanePreferences ):
		"Parse gcode text and store the oozebane gcode."
		self.lines = gcodec.getTextLines( gcodeText )
		self.oozebanePreferences = oozebanePreferences
		self.parseInitialization( oozebanePreferences )
		for self.lineIndex in xrange( self.lineIndex, len( self.lines ) ):
			line = self.lines[ self.lineIndex ]
			self.parseLine( line )

	def parseInitialization( self, oozebanePreferences ):
		"Parse gcode initialization and store the parameters."
		for self.lineIndex in xrange( len( self.lines ) ):
			line = self.lines[ self.lineIndex ]
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			if firstWord == '(<extrusionWidth>':
				self.extrusionWidth = float( splitLine[ 1 ] )
				self.setExtrusionWidth( oozebanePreferences )
			elif firstWord == '(<decimalPlacesCarried>':
				self.decimalPlacesCarried = int( splitLine[ 1 ] )
			elif firstWord == '(<extrusionStart>':
				self.addLine( '(<procedureDone> oozebane )' )
				return
			self.addLine( line )

	def parseLine( self, line ):
		"Parse a gcode line and add it to the bevel gcode."
		splitLine = line.split()
		if len( splitLine ) < 1:
			return
		firstWord = splitLine[ 0 ]
		if firstWord == 'G1':
			self.setEarlyStartupDistance( splitLine )
			line = self.getOozebaneLine( line )
			self.oldLocation = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		elif firstWord == 'M101':
			self.extruderActive = True
			self.extruderInactiveLongEnough = False
			if self.getDistanceToExtruderOffCommand( self.earlyShutdownDistance ) == None:
				self.setEarlyShutdown()
			if self.getDistanceToExtruderOffCommand( 1.03 * ( self.earlyShutdownDistance + self.afterStartupDistance ) ) == None:
				afterStartupRatio = 1.0
#				if self.minimumDistanceForEarlyStartup > 0.0:
#					afterStartupRatio = totalDistance / self.minimumDistanceForEarlyStartup
				self.setAfterStartupFlowRates( afterStartupRatio )
				self.startupStepIndex = 9999999999
				if len( self.afterStartupDistances ) > 0:
					self.startupStepIndex = 0
			if self.isStartupEarly:
				self.isStartupEarly = False
				return
		elif firstWord == 'M103':
			self.extruderActive = False
			self.shutdownStepIndex = 999999999
			if self.getDistanceToThreadBeginning() == None:
				self.extruderInactiveLongEnough = True
			self.earlyStartupDistance = None
			if self.isShutdownEarly:
				self.isShutdownEarly = False
				return
		self.addLine( line )

	def setAfterStartupFlowRates( self, afterStartupRatio ):
		"Set the after startup flow rates."
		afterStartupRatio = min( 1.0, afterStartupRatio )
		afterStartupRatio = max( 0.0, afterStartupRatio )
		self.afterStartupDistance = afterStartupRatio * self.oozebanePreferences.afterStartupDistanceOverExtrusionWidth.value * self.extrusionWidth
		self.afterStartupDistances = []
		self.afterStartupFlowRate = 1.0
		self.afterStartupFlowRates = []
		afterStartupSteps = int( math.floor( afterStartupRatio * float( self.oozebanePreferences.slowdownStartupSteps.value ) ) )
		if afterStartupSteps < 1:
			return
		if afterStartupSteps < 2:
			afterStartupSteps = 2
		for stepIndex in xrange( afterStartupSteps ):
			afterWay = ( stepIndex + 1 ) / float( afterStartupSteps )
			afterMiddleWay = self.getStartupFlowRateMultiplier( stepIndex / float( afterStartupSteps ), afterStartupSteps )
			self.afterStartupDistances.append( afterWay * self.afterStartupDistance )
			if stepIndex == 0:
				self.afterStartupFlowRate = afterMiddleWay
			else:
				self.afterStartupFlowRates.append( afterMiddleWay )
		if afterStartupSteps > 0:
			self.afterStartupFlowRates.append( 1.0 )

	def setEarlyStartupDistance( self, splitLine ):
		"Set the early startup distance."
		if self.earlyStartupDistance != None:
			return
		totalDistance = 0.0
		lastThreadLocation = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		if self.oldLocation != None:
			totalDistance = lastThreadLocation.distance( self.oldLocation )
		for afterIndex in xrange( self.lineIndex + 1, len( self.lines ) ):
			line = self.lines[ afterIndex ]
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			if firstWord == 'G1':
				location = gcodec.getLocationFromSplitLine( lastThreadLocation, splitLine )
				totalDistance += location.distance( lastThreadLocation )
				lastThreadLocation = location
			elif firstWord == 'M101':
				distanceConstants = totalDistance / self.earlyStartupDistanceConstant
				self.earlyStartupDistance = self.earlyStartupMaximumDistance * ( 1.0 - math.exp( - distanceConstants ) )
				return

	def setExtrusionWidth( self, oozebanePreferences ):
		"Set the extrusion width."
		self.closeSquared = 0.01 * self.extrusionWidth * self.extrusionWidth
		self.earlyStartupMaximumDistance = oozebanePreferences.earlyStartupMaximumDistanceOverExtrusionWidth.value * self.extrusionWidth
		self.earlyStartupDistanceConstant = oozebanePreferences.earlyStartupDistanceConstantOverExtrusionWidth.value * self.extrusionWidth
		self.minimumDistanceForEarlyStartup = oozebanePreferences.minimumDistanceForEarlyStartupOverExtrusionWidth.value * self.extrusionWidth
		self.minimumDistanceForEarlyShutdown = oozebanePreferences.minimumDistanceForEarlyShutdownOverExtrusionWidth.value * self.extrusionWidth
		self.setEarlyShutdownFlowRates( 1.0 )
		self.setAfterStartupFlowRates( 1.0 )

	def setEarlyShutdown( self ):
		"Set the early shutdown variables."
		distanceToThreadBeginning = self.getDistanceToThreadBeginningAfterThreadEnd( self.minimumDistanceForEarlyShutdown )
		if distanceToThreadBeginning == None:
			self.setEarlyShutdownFlowRates( 1.0 )
		else:
			earlyShutdownRatio = 1.0
			if self.minimumDistanceForEarlyShutdown > 0.0:
				earlyShutdownRatio = distanceToThreadBeginning / self.minimumDistanceForEarlyShutdown
			self.setEarlyShutdownFlowRates( earlyShutdownRatio )
		if len( self.earlyShutdownDistances ) > 0:
			self.isShutdownNeeded = True
			self.shutdownStepIndex = 0

	def setEarlyShutdownFlowRates( self, earlyShutdownRatio ):
		"Set the extrusion width."
		earlyShutdownRatio = min( 1.0, earlyShutdownRatio )
		earlyShutdownRatio = max( 0.0, earlyShutdownRatio )
		self.earlyShutdownDistance = earlyShutdownRatio * self.oozebanePreferences.shutdownDistanceOverExtrusionWidth.value * self.extrusionWidth
		self.earlyShutdownDistances = []
		self.earlyShutdownFlowRates = []
		earlyShutdownSteps = int( math.floor( earlyShutdownRatio * float( self.oozebanePreferences.slowdownStartupSteps.value ) ) )
		if earlyShutdownSteps < 2:
			earlyShutdownSteps = 0
		for stepIndex in xrange( earlyShutdownSteps ):
			downMiddleWay = self.getShutdownFlowRateMultiplier( stepIndex / float( earlyShutdownSteps ), earlyShutdownSteps )
			downWay = 1.0 - stepIndex / float( earlyShutdownSteps )
			self.earlyShutdownFlowRates.append( downMiddleWay )
			self.earlyShutdownDistances.append( downWay * self.earlyShutdownDistance )


def main( hashtable = None ):
	"Display the oozebane dialog."
	if len( sys.argv ) > 1:
		writeOutput( ' '.join( sys.argv[ 1 : ] ) )
	else:
		preferences.displayDialog( OozebanePreferences() )

if __name__ == "__main__":
	main()
