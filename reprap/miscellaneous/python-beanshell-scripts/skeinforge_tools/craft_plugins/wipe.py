"""
Wipe is a script to wipe the nozzle.

At the beginning of a layer, depending on the preferences, wipe will move the nozzle with the extruder off to the arrival point,
then to the wipe point, then to the departure point, then back to the layer.

The default 'Activate Wipe' checkbox is on.  When it is on, the functions described below will work, when it is off, the functions
will not be called.

The "Location Arrival X" preference, is the x coordinate of the arrival location.  The "Location Arrival Y" and "Location Arrival Z"
preferences are the y & z coordinates of the location.  The equivalent "Location Wipe.." and "Location Departure.." preferences
are for the wipe and departure locations.

The "Wipe Period (layers)" preference is the number of layers between wipes.  Wipe will always wipe just before the first layer,
afterwards it will wipe every "Wipe Period" layers.  With the default of three, wipe will wipe just before the zeroth layer, the
third layer, sixth layer and so on.

To run wipe, in a shell which wipe is in type:
> python wipe.py

The following examples wipes the files Screw Holder Bottom.gcode & Screw Holder Bottom.stl.  The examples are run in a
terminal in the folder which contains Screw Holder Bottom.gcode, Screw Holder Bottom.stl and wipe.py.  The wipe function
will wipe if the 'Activate Wipe' checkbox is on.  The functions writeOutput and getChainGcode check to see if the text
has been wiped, if not they call the getChainGcode in hop.py to hop the text; once they have the hopped text, then they
wipe.


> python wipe.py
This brings up the dialog, after clicking 'Wipe', the following is printed:
File Screw Holder Bottom.stl is being chain wiped.
The wiped file is saved as Screw Holder Bottom_wipe.gcode


> python wipe.py Screw Holder Bottom.stl
File Screw Holder Bottom.stl is being chain wiped.
The wiped file is saved as Screw Holder Bottom_wipe.gcode


> python
Python 2.5.1 (r251:54863, Sep 22 2007, 01:43:31)
[GCC 4.2.1 (SUSE Linux)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import wipe
>>> wipe.main()
This brings up the wipe dialog.


>>> wipe.writeOutput()
File Screw Holder Bottom.stl is being chain wiped.
The wiped file is saved as Screw Holder Bottom_wipe.gcode

"""

from __future__ import absolute_import
#Init has to be imported first because it has code to workaround the python bug where relative imports don't work if the module is imported as a main module.
import __init__

from skeinforge_tools import polyfile
from skeinforge_tools.skeinforge_utilities import consecution
from skeinforge_tools.skeinforge_utilities import euclidean
from skeinforge_tools.skeinforge_utilities import gcodec
from skeinforge_tools.skeinforge_utilities import interpret
from skeinforge_tools.skeinforge_utilities import preferences
from skeinforge_tools.skeinforge_utilities.vector3 import Vector3
import math
import sys


__author__ = "Enrique Perez (perez_enrique@yahoo.com)"
__date__ = "$Date: 2008/21/04 $"
__license__ = "GPL 3.0"


def getCraftedText( fileName, text, wipePreferences = None ):
	"Wipe a gcode linear move text."
	return getCraftedTextFromText( gcodec.getTextIfEmpty( fileName, text ), wipePreferences )

def getCraftedTextFromText( gcodeText, wipePreferences = None ):
	"Wipe a gcode linear move text."
	if gcodec.isProcedureDoneOrFileIsEmpty( gcodeText, 'wipe' ):
		return gcodeText
	if wipePreferences == None:
		wipePreferences = preferences.getReadPreferences( WipePreferences() )
	if not wipePreferences.activateWipe.value:
		return gcodeText
	return WipeSkein().getCraftedGcode( gcodeText, wipePreferences )

def getDisplayedPreferences():
	"Get the displayed preferences."
	return preferences.getDisplayedDialogFromConstructor( WipePreferences() )

def writeOutput( fileName = '' ):
	"Wipe a gcode linear move file.  Chain wipe the gcode if it is not already wiped. If no fileName is specified, wipe the first unmodified gcode file in this folder."
	fileName = interpret.getFirstTranslatorFileNameUnmodified( fileName )
	if fileName == '':
		return
	consecution.writeChainText( fileName, ' is being chain wiped.', 'The wiped file is saved as ', 'wipe' )


class WipePreferences:
	"A class to handle the wipe preferences."
	def __init__( self ):
		"Set the default preferences, execute title & preferences fileName."
		#Set the default preferences.
		self.archive = []
		self.activateWipe = preferences.BooleanPreference().getFromValue( 'Activate Wipe', False )
		self.archive.append( self.activateWipe )
		self.fileNameInput = preferences.Filename().getFromFilename( interpret.getGNUTranslatorGcodeFileTypeTuples(), 'Open File to be Wiped', '' )
		self.archive.append( self.fileNameInput )
		self.locationArrivalX = preferences.FloatPreference().getFromValue( 'Location Arrival X (mm):', - 70.0 )
		self.archive.append( self.locationArrivalX )
		self.locationArrivalY = preferences.FloatPreference().getFromValue( 'Location Arrival Y (mm):', - 50.0 )
		self.archive.append( self.locationArrivalY )
		self.locationArrivalZ = preferences.FloatPreference().getFromValue( 'Location Arrival Z (mm):', 50.0 )
		self.archive.append( self.locationArrivalZ )
		self.locationDepartureX = preferences.FloatPreference().getFromValue( 'Location Departure X (mm):', - 70.0 )
		self.archive.append( self.locationDepartureX )
		self.locationDepartureY = preferences.FloatPreference().getFromValue( 'Location Departure Y (mm):', - 40.0 )
		self.archive.append( self.locationDepartureY )
		self.locationDepartureZ = preferences.FloatPreference().getFromValue( 'Location Departure Z (mm):', 50.0 )
		self.archive.append( self.locationDepartureZ )
		self.locationWipeX = preferences.FloatPreference().getFromValue( 'Location Wipe X (mm):', - 70.0 )
		self.archive.append( self.locationWipeX )
		self.locationWipeY = preferences.FloatPreference().getFromValue( 'Location Wipe Y (mm):', - 70.0 )
		self.archive.append( self.locationWipeY )
		self.locationWipeZ = preferences.FloatPreference().getFromValue( 'Location Wipe Z (mm):', 50.0 )
		self.archive.append( self.locationWipeZ )
		self.wipePeriod = preferences.IntPreference().getFromValue( 'Wipe Period (layers):', 3 )
		self.archive.append( self.wipePeriod )
		#Create the archive, title of the execute button, title of the dialog & preferences fileName.
		self.executeTitle = 'Wipe'
		self.saveTitle = 'Save Preferences'
		preferences.setHelpPreferencesFileNameTitleWindowPosition( self, 'skeinforge_tools.craft_plugins.wipe.html' )

	def execute( self ):
		"Wipe button has been clicked."
		fileNames = polyfile.getFileOrDirectoryTypesUnmodifiedGcode( self.fileNameInput.value, interpret.getImportPluginFilenames(), self.fileNameInput.wasCancelled )
		for fileName in fileNames:
			writeOutput( fileName )


class WipeSkein:
	"A class to wipe a skein of extrusions."
	def __init__( self ):
		self.distanceFeedRate = gcodec.DistanceFeedRate()
		self.extruderActive = False
		self.highestZ = None
		self.layerIndex = - 1
		self.lineIndex = 0
		self.lines = None
		self.oldLocation = None
		self.shouldWipe = False
		self.travelFeedratePerMinute = 957.0

	def addHop( self, begin, end ):
		"Add hop to highest point."
		beginEndDistance = begin.distance( end )
		if beginEndDistance < 3.0 * self.absolutePerimeterWidth:
			return
		alongWay = self.absolutePerimeterWidth / beginEndDistance
		closeToOldLocation = euclidean.getIntermediateLocation( alongWay, begin, end )
		closeToOldLocation.z = self.highestZ
		self.distanceFeedRate.addLine( self.getLinearMoveWithFeedrate( self.travelFeedratePerMinute, closeToOldLocation ) )
		closeToOldArrival = euclidean.getIntermediateLocation( alongWay, end, begin )
		closeToOldArrival.z = self.highestZ
		self.distanceFeedRate.addLine( self.getLinearMoveWithFeedrate( self.travelFeedratePerMinute, closeToOldArrival ) )

	def addWipeTravel( self, splitLine ):
		"Add the wipe travel gcode."
		location = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		self.highestZ = max( self.highestZ, location.z )
		if not self.shouldWipe:
			return
		self.shouldWipe = False
		if self.extruderActive:
			self.distanceFeedRate.addLine( 'M103' )
		if self.oldLocation != None:
			self.addHop( self.oldLocation, self.locationArrival )
		self.distanceFeedRate.addLine( self.getLinearMoveWithFeedrate( self.travelFeedratePerMinute, self.locationArrival ) )
		self.distanceFeedRate.addLine( self.getLinearMoveWithFeedrate( self.travelFeedratePerMinute, self.locationWipe ) )
		self.distanceFeedRate.addLine( self.getLinearMoveWithFeedrate( self.travelFeedratePerMinute, self.locationDeparture ) )
		self.addHop( self.locationDeparture, location )
		if self.extruderActive:
			self.distanceFeedRate.addLine( 'M101' )

	def getCraftedGcode( self, gcodeText, wipePreferences ):
		"Parse gcode text and store the wipe gcode."
		self.lines = gcodec.getTextLines( gcodeText )
		self.wipePeriod = wipePreferences.wipePeriod.value
		self.parseInitialization( wipePreferences )
		self.locationArrival = Vector3( wipePreferences.locationArrivalX.value, wipePreferences.locationArrivalY.value, wipePreferences.locationArrivalZ.value )
		self.locationDeparture = Vector3( wipePreferences.locationDepartureX.value, wipePreferences.locationDepartureY.value, wipePreferences.locationDepartureZ.value )
		self.locationWipe = Vector3( wipePreferences.locationWipeX.value, wipePreferences.locationWipeY.value, wipePreferences.locationWipeZ.value )
		for self.lineIndex in xrange( self.lineIndex, len( self.lines ) ):
			line = self.lines[ self.lineIndex ]
			self.parseLine( line )
		return self.distanceFeedRate.output.getvalue()

	def getLinearMoveWithFeedrate( self, feedrate, location ):
		"Get a linear move line with the feedrate."
		return self.distanceFeedRate.getLinearGcodeMovementWithFeedrate( feedrate, location.dropAxis( 2 ), location.z )

	def parseInitialization( self, wipePreferences ):
		"Parse gcode initialization and store the parameters."
		for self.lineIndex in xrange( len( self.lines ) ):
			line = self.lines[ self.lineIndex ]
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			self.distanceFeedRate.parseSplitLine( firstWord, splitLine )
			if firstWord == '(</extruderInitialization>)':
				self.distanceFeedRate.addLine( '(<procedureDone> wipe </procedureDone>)' )
				return
			elif firstWord == '(<perimeterWidth>':
				self.absolutePerimeterWidth = abs( float( splitLine[ 1 ] ) )
			elif firstWord == '(<travelFeedratePerSecond>':
				self.travelFeedratePerMinute = 60.0 * float( splitLine[ 1 ] )
			self.distanceFeedRate.addLine( line )

	def parseLine( self, line ):
		"Parse a gcode line and add it to the bevel gcode."
		splitLine = line.split()
		if len( splitLine ) < 1:
			return
		firstWord = splitLine[ 0 ]
		if firstWord == 'G1':
			self.addWipeTravel( splitLine )
			self.oldLocation = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		elif firstWord == '(<layer>':
			self.layerIndex += 1
			if self.layerIndex % self.wipePeriod == 0:
				self.shouldWipe = True
		elif firstWord == 'M101':
			self.extruderActive = True
		elif firstWord == 'M103':
			self.extruderActive = False
		self.distanceFeedRate.addLine( line )


def main():
	"Display the wipe dialog."
	if len( sys.argv ) > 1:
		writeOutput( ' '.join( sys.argv[ 1 : ] ) )
	else:
		getDisplayedPreferences().root.mainloop()

if __name__ == "__main__":
	main()
