"""
Speed is a script to set the feedrate, and flowrate.

The default 'Activate Speed' checkbox is on.  When it is on, the functions described below will work, when it is off, the
functions will not be called.  The speed script sets the feedrate, and flowrate.  To run speed, in a shell type:
> python speed.py

The 'Extrusion Diameter over Thickness is the ratio of the extrusion diameter over the layer thickness, the default is 1.25.  The
extrusion fill density ratio that is printed to the console, ( it is derived quantity not a parameter ) is the area of the extrusion
diameter over the extrusion width over the layer thickness.  Assuming the extrusion diameter is correct, a high value means the
filament will be packed tightly, and the object will be almost as dense as the filament.  If the value is too high, there could be too
little room for the filament, and the extruder will end up plowing through the extra filament.  A low value means the filaments will
be far away from each other, the object will be leaky and light.  The value with the default extrusion preferences is around 0.82.

The feedrate for the shape will be set to the 'Feedrate" preference.  The 'Bridge Feedrate Multiplier' is the ratio of the feedrate on
the bridge layers over the feedrate of the typical non bridge layers, the default is 1.0.  The speed of the orbit compared to the
operating extruder speed will be set to the "Orbital Feedrate over Operating Feedrate" preference.  If you want the orbit to be
very short, set the "Orbital Feedrate over Operating Feedrate" preference to a low value like 0.1.  The 'Travel Feedrate' is the
feedrate when the extruder is off.  The default is 16 mm / s and it could be set as high as the extruder can be moved, it does
not have to be limited by the maximum extrusion rate.

In the "Flowrate Choice" radio button group, if "Do Not Add Flowrate" is selected then speed will not add a flowrate to the gcode
output.  If "Metric" is selected, the flowrate in cubic millimeters per second will be added to the output.  If "PWM Setting" is
selected, the value in the "Flowrate PWM Setting" field will be added to the output.

The 'Maximum Z Feedrate' is the maximum speed that the tool head will move in the z direction.  If your firmware limits the z
feed rate, you do not need to set this preference.  The default of 8 millimeters per second is the maximum z speed of Nophead's
direct drive z stage, the belt driven z stages have a lower maximum feed rate.

The 'Perimeter Feedrate over Operating Feedrate' is the ratio of the feedrate of the perimeter over the feedrate of the infill.  With
the default of 1.0, the perimeter feedrate will be the same as the infill feedrate.  The 'Perimeter Flowrate over Operating Flowrate'
is the ratio of the flowrate of the perimeter over the flowrate of the infill.  With the default of 1.0, the perimeter flow rate will be
the same as the infill flow rate.  To have higher build quality on the outside at the expense of slower build speed, a typical
setting for the 'Perimeter Feedrate over Operating Feedrate' would be 0.5.  To go along with that, if you are using a speed
controlled extruder, the 'Perimeter Flowrate over Operating Flowrate' should also be 0.5.  If you are using Pulse Width Modulation
to control the speed, then you'll probably need a slightly higher ratio because there is a minimum voltage 'Flowrate PWM Setting'
required for the extruder motor to turn.  The flow rate PWM ratio would be determined by trial and error, with the first trial being:
Perimeter Flowrate over Operating Flowrate ~
Perimeter Feedrate over Operating Feedrate * ( Flowrate PWM Setting - Minimum Flowrate PWM Setting )
+ Minimum Flowrate PWM Setting

The following examples speed the files Screw Holder Bottom.gcode & Screw Holder Bottom.stl.  The examples are run in a terminal in the
folder which contains Screw Holder Bottom.gcode, Screw Holder Bottom.stl and speed.py.  The speed function will speed if "Activate
Speed" is true, which can be set in the dialog or by changing the preferences file 'speed.csv' with a text editor or a spreadsheet
program set to separate tabs.  The functions writeOutput and getChainGcode check to see if the text has been speeded,
if not they call getMultiplyChainGcode in multiply.py to get multiplied gcode; once they have the multiplied text, then they
speed.


> python speed.py
This brings up the dialog, after clicking 'Speed', the following is printed:
File Screw Holder Bottom.stl is being chain speeded.
The speeded file is saved as Screw Holder Bottom_speed.gcode


>python
Python 2.5.1 (r251:54863, Sep 22 2007, 01:43:31)
[GCC 4.2.1 (SUSE Linux)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import speed
>>> speed.main()
This brings up the speed dialog.


>>> speed.writeOutput()
Screw Holder Bottom.stl
File Screw Holder Bottom.stl is being chain speeded.
The speeded file is saved as Screw Holder Bottom_speed.gcode


>>> speed.getGcode("
( GCode generated by May 8, 2008 carve.py )
( Extruder Initialization )
..
many lines of gcode
..
")


>>> speed.getChainGcode("
( GCode generated by May 8, 2008 carve.py )
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
from skeinforge_tools.skeinforge_utilities import interpret
from skeinforge_tools import multiply
from skeinforge_tools import polyfile
import cStringIO
import math
import sys
import time


__author__ = "Enrique Perez (perez_enrique@yahoo.com)"
__date__ = "$Date: 2008/21/04 $"
__license__ = "GPL 3.0"


def getChainGcode( fileName, gcodeText, speedPreferences = None ):
	"Speed a gcode linear move text.  Chain speed the gcode if it is not already speeded."
	gcodeText = gcodec.getGcodeFileText( fileName, gcodeText )
	if not gcodec.isProcedureDone( gcodeText, 'multiply' ):
		gcodeText = multiply.getMultiplyChainGcode( fileName, gcodeText )
	return getGcode( gcodeText, speedPreferences )

def getGcode( gcodeText, speedPreferences = None ):
	"Speed a gcode linear move text."
	if gcodeText == '':
		return ''
	if gcodec.isProcedureDone( gcodeText, 'speed' ):
		return gcodeText
	if speedPreferences == None:
		speedPreferences = SpeedPreferences()
		preferences.readPreferences( speedPreferences )
	if not speedPreferences.activateSpeed.value:
		return gcodeText
	skein = SpeedSkein()
	skein.parseGcode( gcodeText, speedPreferences )
	return skein.distanceFeedRate.output.getvalue()

def writeOutput( fileName = '' ):
	"""Speed a gcode linear move file.  Chain speed the gcode if it is not already speeded.
	If no fileName is specified, speed the first unmodified gcode file in this folder."""
	fileName = interpret.getFirstTranslatorFileNameUnmodified( fileName )
	if fileName == '':
		return
	speedPreferences = SpeedPreferences()
	preferences.readPreferences( speedPreferences )
	startTime = time.time()
	print( 'File ' + gcodec.getSummarizedFilename( fileName ) + ' is being chain speeded.' )
	suffixFilename = fileName[ : fileName.rfind( '.' ) ] + '_speed.gcode'
	speedGcode = getChainGcode( fileName, '', speedPreferences )
	if speedGcode == '':
		return
	gcodec.writeFileText( suffixFilename, speedGcode )
	print( 'The speeded file is saved as ' + gcodec.getSummarizedFilename( suffixFilename ) )
	analyze.writeOutput( suffixFilename, speedGcode )
	print( 'It took ' + str( int( round( time.time() - startTime ) ) ) + ' seconds to speed the file.' )


class SpeedPreferences:
	"A class to handle the speed preferences."
	def __init__( self ):
		"Set the default preferences, execute title & preferences fileName."
		#Set the default preferences.
		self.archive = []
		self.activateSpeed = preferences.BooleanPreference().getFromValue( 'Activate Speed:', True )
		self.archive.append( self.activateSpeed )
		self.bridgeFeedrateMultiplier = preferences.FloatPreference().getFromValue( 'Bridge Feedrate Multiplier (ratio):', 1.0 )
		self.archive.append( self.bridgeFeedrateMultiplier )
		self.extrusionDiameterOverThickness = preferences.FloatPreference().getFromValue( 'Extrusion Diameter over Thickness (ratio):', 1.25 )
		self.archive.append( self.extrusionDiameterOverThickness )
		self.feedratePerSecond = preferences.FloatPreference().getFromValue( 'Feedrate (mm/s):', 16.0 )
		self.archive.append( self.feedratePerSecond )
		self.fileNameInput = preferences.Filename().getFromFilename( interpret.getGNUTranslatorGcodeFileTypeTuples(), 'Open File to be Speeded', '' )
		self.archive.append( self.fileNameInput )
		flowrateRadio = []
		self.flowrateChoiceLabel = preferences.LabelDisplay().getFromName( 'Flowrate Choice: ' )
		self.archive.append( self.flowrateChoiceLabel )
		self.flowrateDoNotAddFlowratePreference = preferences.Radio().getFromRadio( 'Do Not Add Flowrate', flowrateRadio, False )
		self.archive.append( self.flowrateDoNotAddFlowratePreference )
		self.flowrateMetricPreference = preferences.Radio().getFromRadio( 'Metric', flowrateRadio, False )
		self.archive.append( self.flowrateMetricPreference )
		self.flowratePWMPreference = preferences.Radio().getFromRadio( 'PWM Setting', flowrateRadio, True )
		self.archive.append( self.flowratePWMPreference )
		self.flowratePWMSetting = preferences.FloatPreference().getFromValue( 'Flowrate PWM Setting (if PWM Setting is Chosen):', 210.0 )
		self.archive.append( self.flowratePWMSetting )
		self.maximumZFeedratePerSecond = preferences.FloatPreference().getFromValue( 'Maximum Z Feedrate (mm/s):', 8.0 )
		self.archive.append( self.maximumZFeedratePerSecond )
		self.orbitalFeedrateOverOperatingFeedrate = preferences.FloatPreference().getFromValue( 'Orbital Feedrate over Operating Feedrate (ratio):', 0.5 )
		self.archive.append( self.orbitalFeedrateOverOperatingFeedrate )
		self.perimeterFeedrateOverOperatingFeedrate = preferences.FloatPreference().getFromValue( 'Perimeter Feedrate over Operating Feedrate (ratio):', 1.0 )
		self.archive.append( self.perimeterFeedrateOverOperatingFeedrate )
		self.perimeterFlowrateOverOperatingFlowrate = preferences.FloatPreference().getFromValue( 'Perimeter Flowrate over Operating Flowrate (ratio):', 1.0 )
		self.archive.append( self.perimeterFlowrateOverOperatingFlowrate )
		self.travelFeedratePerSecond = preferences.FloatPreference().getFromValue( 'Travel Feedrate (mm/s):', 16.0 )
		self.archive.append( self.travelFeedratePerSecond )
		#Create the archive, title of the execute button, title of the dialog & preferences fileName.
		self.executeTitle = 'Speed'
		self.saveTitle = 'Save Preferences'
		preferences.setHelpPreferencesFileNameTitleWindowPosition( self, 'skeinforge_tools.speed.html' )

	def execute( self ):
		"Speed button has been clicked."
		fileNames = polyfile.getFileOrDirectoryTypesUnmodifiedGcode( self.fileNameInput.value, interpret.getImportPluginFilenames(), self.fileNameInput.wasCancelled )
		for fileName in fileNames:
			writeOutput( fileName )


class SpeedSkein:
	"A class to speed a skein of extrusions."
	def __init__( self ):
		self.distanceFeedRate = gcodec.DistanceFeedRate()
		self.feedratePerSecond = 16.0
		self.isExtruderActive = False
		self.isBridgeLayer = False
		self.isSurroundingLoopBeginning = False
		self.lineIndex = 0
		self.lines = None
		self.oldFlowrateString = None
		self.oldLocation = None

	def addFlowrateLineIfNecessary( self ):
		"Add flowrate line."
		flowrateString = self.getFlowrateString()
		if flowrateString != self.oldFlowrateString:
			self.distanceFeedRate.addLine( 'M108 S' + flowrateString )
		self.oldFlowrateString = flowrateString

	def getFlowrateString( self ):
		"Get the flowrate string."
		if self.speedPreferences.flowrateDoNotAddFlowratePreference.value:
			return None
		flowrate = self.getOperatingFlowrate()
		if self.isSurroundingLoopBeginning:
			flowrate *= self.speedPreferences.perimeterFlowrateOverOperatingFlowrate.value
		return euclidean.getRoundedToThreePlaces( flowrate )

	def getOperatingFlowrate( self ):
		"Get the operating flowrate."
		if self.speedPreferences.flowratePWMPreference.value:
			return self.speedPreferences.flowratePWMSetting.value
		return self.flowrateCubicMillimetersPerSecond

	def getSpeededLine( self, splitLine ):
		"Get gcode line with feedrate."
		location = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		self.oldLocation = location
		feedrateMinute = 60.0 * self.feedratePerSecond
		if self.isSurroundingLoopBeginning:
			feedrateMinute *= self.speedPreferences.perimeterFeedrateOverOperatingFeedrate.value
		self.addFlowrateLineIfNecessary()
		if self.isBridgeLayer:
			feedrateMinute *= self.speedPreferences.bridgeFeedrateMultiplier.value
		if not self.isExtruderActive:
			feedrateMinute = self.travelFeedratePerMinute
		return self.distanceFeedRate.getLinearGcodeMovementWithFeedrate( feedrateMinute, location.dropAxis( 2 ), location.z )

	def parseGcode( self, gcodeText, speedPreferences ):
		"Parse gcode text and store the speed gcode."
		self.speedPreferences = speedPreferences
		self.feedratePerSecond = speedPreferences.feedratePerSecond.value
		self.orbitalFeedratePerSecond = self.feedratePerSecond * speedPreferences.orbitalFeedrateOverOperatingFeedrate.value
		self.travelFeedratePerMinute = 60.0 * self.speedPreferences.travelFeedratePerSecond.value
		self.lines = gcodec.getTextLines( gcodeText )
		self.parseInitialization()
		for line in self.lines[ self.lineIndex : ]:
			self.parseLine( line )
		circleArea = self.extrusionDiameter * self.extrusionDiameter * math.pi / 4.0
		print( 'The extrusion fill density ratio is ' + euclidean.getRoundedToThreePlaces( circleArea / self.extrusionWidth / self.layerThickness ) )

	def parseInitialization( self ):
		"Parse gcode initialization and store the parameters."
		for self.lineIndex in xrange( len( self.lines ) ):
			line = self.lines[ self.lineIndex ]
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			self.distanceFeedRate.parseSplitLine( firstWord, splitLine )
			if firstWord == '(<layerThickness>':
				self.layerThickness = float( splitLine[ 1 ] )
				self.extrusionDiameter = self.speedPreferences.extrusionDiameterOverThickness.value * self.layerThickness
				self.flowrateCubicMillimetersPerSecond = math.pi * self.extrusionDiameter * self.extrusionDiameter / 4.0 * self.feedratePerSecond
				roundedFlowrate = euclidean.getRoundedToThreePlaces( self.flowrateCubicMillimetersPerSecond )
				self.distanceFeedRate.addLine( '(<flowrateCubicMillimetersPerSecond> ' + roundedFlowrate + ' </flowrateCubicMillimetersPerSecond>)' )
			elif firstWord == '(<extrusionWidth>':
				self.extrusionWidth = float( splitLine[ 1 ] )
				self.distanceFeedRate.addLine( '(<maximumZFeedratePerSecond> %s </maximumZFeedratePerSecond>)' % self.speedPreferences.maximumZFeedratePerSecond.value )
				self.distanceFeedRate.addLine( '(<operatingFeedratePerSecond> %s </operatingFeedratePerSecond>)' % self.feedratePerSecond )
				self.distanceFeedRate.addLine( '(<orbitalFeedratePerSecond> %s </orbitalFeedratePerSecond>)' % self.orbitalFeedratePerSecond )
				self.distanceFeedRate.addLine( '(<travelFeedratePerSecond> %s </travelFeedratePerSecond>)' % self.speedPreferences.travelFeedratePerSecond.value )
			elif firstWord == '(</extruderInitialization>)':
				self.distanceFeedRate.addLine( '(<procedureDone> speed </procedureDone>)' )
				self.distanceFeedRate.addLine( line )
				self.lineIndex += 1
				return
			self.distanceFeedRate.addLine( line )

	def parseLine( self, line ):
		"Parse a gcode line and add it to the speed skein."
		splitLine = line.split()
		if len( splitLine ) < 1:
			return
		firstWord = splitLine[ 0 ]
		if firstWord == 'G1':
			line = self.getSpeededLine( splitLine )
		elif firstWord == 'M101':
			self.isExtruderActive = True
		elif firstWord == 'M103':
			self.isSurroundingLoopBeginning = False
			self.isExtruderActive = False
		elif firstWord == '(<bridgeLayer>)':
			self.isBridgeLayer = True
		elif firstWord == '(<layer>':
			self.isBridgeLayer = False
			self.addFlowrateLineIfNecessary()
		elif firstWord == '(<surroundingLoop>)':
			self.isSurroundingLoopBeginning = True
		self.distanceFeedRate.addLine( line )


def main():
	"Display the speed dialog."
	if len( sys.argv ) > 1:
		writeOutput( ' '.join( sys.argv[ 1 : ] ) )
	else:
		preferences.displayDialog( SpeedPreferences() )

if __name__ == "__main__":
	main()
