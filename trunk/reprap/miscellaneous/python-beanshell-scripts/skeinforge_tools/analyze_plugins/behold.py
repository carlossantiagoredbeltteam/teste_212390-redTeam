"""
Behold is an analysis script to display a gcode file in an isometric view.

The default 'Activate Behold' checkbox is on.  When it is on, the functions described below will work when called from the
skeinforge toolchain, when it is off, the functions will not be called from the toolchain.  The functions will still be called, whether
or not the 'Activate Behold' checkbox is on, when behold is run directly.  Behold can not separate the layers when it reads
gcode without comments.

The viewer is simple, the viewpoint can only be moved in a sphere around the center of the model by changing the viewpoint
latitude and longitude.  Different regions of the model can be hidden by setting the width of the thread to zero.  The alternating
bands act as contour bands and their brightness and width can be changed.  The layers will be displayed starting at the "Layer
From" index up until the "Layer To" index.  All of the preferences can be set in the initial "Behold Preferences" window and
some can be changed after the viewer is running in the "Behold Dynamic Preferences" window.  In the viewer, dragging the
mouse will change the viewpoint.

The "Band Height" is height of the band in layers, with the default of five, a pair of bands is ten layers high.  The "Bottom Band
Brightness" is the ratio of the brightness of the bottom band over the brightness of the top band, the default is 0.7.  The "Bottom
Layer Brightness" is the ratio of the brightness of the bottom layer over the brightness of the top layer, the default is 1.0.  With a
low bottom layer brightness ratio the bottom of the model will be darker than the top of the model, as if it was being illuminated
by a light just above the top.  The "Bright Band Start" button group determines where the bright band starts from.  If the "From
the Bottom" choice is selected, the bright bands will start from the bottom.  If the default "From the Top" choice is selected, the
bright bands will start from the top.

If "Draw Arrows" is selected, arrows will be drawn at the end of each line segment, the default is on.  If "Go Around Extruder
Off Travel" is selected, the display will include the travel when the extruder is off, which means it will include the nozzle wipe
path if any.

The "Layer From" is the index of the bottom layer that will be displayed.  If the layer from is the default zero, the display will
start from the lowest layer.  If the the layer from index is negative, then the display will start from the layer from index below the
top layer.  The "Layer To" is the index of the top layer that will be displayed.  If the layer to index is a huge number like the
default 999999999, the display will go to the top of the model, at least until we model habitats:)  If the layer to index is negative,
then the display will go to the layer to index below the top layer.  The layer from until layer to index is a python slice.

The "Number of Fill Bottom Layers" is the number of layers at the bottom which will be colored olive.  The "Number of Fill Bottom
Layers" is the number of layers at the top which will be colored blue.

The "Pixels over Extrusion Width" preference is the scale of the image, the higher the number, the greater the size of the display.
The "Screen Horizontal Inset" determines how much the display will be inset in the horizontal direction from the edge of screen,
the higher the number the more it will be inset and the smaller it will be, the default is one hundred.  The "Screen Vertical Inset"
determines how much the display will be inset in the vertical direction from the edge of screen, the default is fifty.

The "Viewpoint Latitude" is the latitude of the viewpoint, the default is 15 degrees.  The "Viewpoint Longitude" is the longitude of
the viewpoint, the default is 210 degrees.  The viewpoint can also be moved by dragging the mouse.  The viewpoint latitude will
be increased when the mouse is dragged from the center towards the edge.  The viewpoint longitude will be changed by the
amount around the center the mouse is dragged.  This is not very intuitive, but I don't know how to do this the intuitive way and
I have other stuff to develop.  If the shift key is pressed; if the latitude is changed more than the longitude, only the latitude will
be changed, if the longitude is changed more only the longitude will be changed.

The "Width of Extrusion Thread" sets the width of the green extrusion threads, those threads which are not loops and not part of
the raft.  The default is one, if the width is zero the extrusion threads will be invisible.  The "Width of Fill Bottom Thread" sets
the width of the olive extrusion threads at the bottom of the model, the default is three.  The "Width of Fill Top Thread" sets the
width of the blue extrusion threads at the top of the model, the default is three.  The "Width of Loop Thread" sets the width of the
yellow loop threads, which are not perimeters, the default is three.  The "Width of Perimeter Inside Thread" sets the width of the
orange inside perimeter threads, the default is three.  The "Width of Perimeter Outside Thread" sets the width of the red outside
perimeter threads, the default is three.  The "Width of Raft Thread" sets the width of the brown raft threads, the default is one.
The "Width of Travel Thread" sets the width of the gray extruder off travel threads, the default is zero.

The "Width of X Axis" preference sets the width of the dark orange X Axis, the default is five pixels.  The "Width of Y Axis" sets
the width of the gold Y Axis, the default is five.  The "Width of Z Axis" sets the width of the sky blue Z Axis, the default is five.

To run behold, in a shell in the folder which behold is in type:
> python behold.py

An explanation of the gcodes is at:
http://reprap.org/bin/view/Main/Arduino_GCode_Interpreter

and at:
http://reprap.org/bin/view/Main/MCodeReference

A gode example is at:
http://forums.reprap.org/file.php?12,file=565

This example lets the viewer behold the gcode file Screw Holder.gcode.  This example is run in a terminal in the folder which
contains Screw Holder.gcode and behold.py.


> python behold.py
This brings up the behold dialog.


> python behold.py Screw Holder.gcode
This brings up the behold dialog to view the gcode file.


> python
Python 2.5.1 (r251:54863, Sep 22 2007, 01:43:31)
[GCC 4.2.1 (SUSE Linux)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import behold
>>> behold.main()
This brings up the behold dialog.


>>> behold.beholdFile()
This brings up the behold window to view the gcode file.

"""

from __future__ import absolute_import
#Init has to be imported first because it has code to workaround the python bug where relative imports don't work if the module is imported as a main module.
import __init__

from skeinforge_tools.skeinforge_utilities.vector3 import Vector3
from skeinforge_tools.skeinforge_utilities import euclidean
from skeinforge_tools.skeinforge_utilities import gcodec
from skeinforge_tools.skeinforge_utilities import preferences
from skeinforge_tools import polyfile
import math
import sys


__author__ = "Enrique Perez (perez_enrique@yahoo.com)"
__date__ = "$Date: 2008/21/04 $"
__license__ = "GPL 3.0"


#bring up the preferences window, maybe make dragging more intuitive
def beholdFile( fileName = '' ):
	"Behold a gcode file.  If no fileName is specified, behold the first gcode file in this folder that is not modified."
	if fileName == '':
		unmodified = gcodec.getUnmodifiedGCodeFiles()
		if len( unmodified ) == 0:
			print( "There are no unmodified gcode files in this folder." )
			return
		fileName = unmodified[ 0 ]
	gcodeText = gcodec.getFileText( fileName )
	displayBeholdFileGivenText( gcodeText )

def compareLayerSequence( first, second ):
	"Get comparison in order to sort skein panes in ascending order of layer zone index then sequence index."
	if first.layerZoneIndex > second.layerZoneIndex:
		return 1
	if first.layerZoneIndex < second.layerZoneIndex:
		return - 1
	if first.sequenceIndex > second.sequenceIndex:
		return 1
	if first.sequenceIndex < second.sequenceIndex:
		return - 1
	return 0

def displayBeholdFileGivenText( gcodeText, beholdPreferences = None ):
	"Display a beholded gcode file for a gcode file."
	if gcodeText == '':
		return ''
	if beholdPreferences == None:
		beholdPreferences = BeholdPreferences()
		preferences.getReadPreferences( beholdPreferences )
	displayBeholdFileGivenTextPreferences( gcodeText, beholdPreferences )

def displayBeholdFileGivenTextPreferences( gcodeText, beholdPreferences ):
	"Display the gcode text in a behold viewer."
	skein = BeholdSkein()
	skein.parseGcode( gcodeText, beholdPreferences )
	skeinWindow = SkeinWindow( beholdPreferences, skein )

def getBoundedLatitude( latitude ):
	"Get the bounded latitude.later get rounded"
	return round( min( 179.9, max( 0.1, latitude ) ), 1 )

def getPolygonComplexFromColoredLines( coloredLines ):
	"Get a complex polygon from the colored lines."
	polygonComplex = []
	for coloredLine in coloredLines:
		polygonComplex.append( coloredLine.begin.dropAxis( 2 ) )
	return polygonComplex

def getPreferencesConstructor():
	"Get the preferences constructor."
	return BeholdPreferences()

def getTwoHex( number ):
	"Get the first two hexadecimal digits."
	return ( '%s00' % hex( number ) )[ 2 : 4 ]

def writeOutput( fileName, gcodeText = '' ):
	"Write a beholded gcode file for a skeinforge gcode file, if 'Activate Behold' is selected."
	beholdPreferences = BeholdPreferences()
	preferences.getReadPreferences( beholdPreferences )
	if beholdPreferences.activateBehold.value:
		gcodeText = gcodec.getTextIfEmpty( fileName, gcodeText )
		displayBeholdFileGivenText( gcodeText, beholdPreferences )


class BeholdPreferences:
	"A class to handle the behold preferences."
	def __init__( self ):
		"Set the default preferences, execute title & preferences fileName."
		#Set the default preferences.
		self.archive = []
		self.phoenixPreferenceTable = {}
		self.updatePreferences = []
		self.activateBehold = preferences.BooleanPreference().getFromValue( 'Activate Behold', True )
		self.archive.append( self.activateBehold )
		self.bandHeight = preferences.IntPreference().getFromValue( 'Band Height (layers):', 5 )
		self.addToArchivePhoenixUpdate( self.bandHeight )
		self.bottomBandBrightness = preferences.FloatPreference().getFromValue( 'Bottom Band Brightness (ratio):', 0.7 )
		self.addToArchivePhoenixUpdate( self.bottomBandBrightness )
		self.bottomLayerBrightness = preferences.FloatPreference().getFromValue( 'Bottom Layer Brightness (ratio):', 1.0 )
		self.addToArchivePhoenixUpdate( self.bottomLayerBrightness )
		self.brightBandStart = preferences.MenuButtonDisplay().getFromName( 'Bright Band Start: ' )
		self.addToArchiveUpdate( self.brightBandStart )
		self.fromTheBottom = preferences.MenuRadio().getFromMenuButtonDisplay( self.brightBandStart, 'From the Bottom', False )
		self.addToArchivePhoenixUpdate( self.fromTheBottom )
		self.fromTheTop = preferences.MenuRadio().getFromMenuButtonDisplay( self.brightBandStart, 'From the Top', True )
		self.addToArchivePhoenixUpdate( self.fromTheTop )
		self.displayLineTextWhenMouseMoves = preferences.BooleanPreference().getFromValue( 'Display Line Text when Mouse Moves', False )
		self.addToArchivePhoenixUpdate( self.displayLineTextWhenMouseMoves )
		self.drawArrows = preferences.BooleanPreference().getFromValue( 'Draw Arrows', False )
		self.addToArchiveUpdate( self.drawArrows )
		self.fileNameInput = preferences.Filename().getFromFilename( [ ( 'Gcode text files', '*.gcode' ) ], 'Open File to Behold', '' )
		self.archive.append( self.fileNameInput )
		self.goAroundExtruderOffTravel = preferences.BooleanPreference().getFromValue( 'Go Around Extruder Off Travel', False )
		self.addToArchivePhoenixUpdate( self.goAroundExtruderOffTravel )
		self.layersFrom = preferences.IntPreference().getFromValue( 'Layers From (index):', 0 )
		self.addToArchiveUpdate( self.layersFrom )
		self.layersTo = preferences.IntPreference().getFromValue( 'Layers To (index):', 999999999 )
		self.addToArchiveUpdate( self.layersTo )
		self.numberOfFillBottomLayers = preferences.IntPreference().getFromValue( 'Number of Fill Bottom Layers (integer):', 1 )
		self.addToArchivePhoenixUpdate( self.numberOfFillBottomLayers )
		self.numberOfFillTopLayers = preferences.IntPreference().getFromValue( 'Number of Fill Top Layers (integer):', 1 )
		self.addToArchivePhoenixUpdate( self.numberOfFillTopLayers )
		self.pixelsPerMillimeter = preferences.FloatPreference().getFromValue( 'Pixels per Millimeter (ratio):', 10.0 )
		self.addToArchivePhoenixUpdate( self.pixelsPerMillimeter )
		self.screenHorizontalInset = preferences.IntPreference().getFromValue( 'Screen Horizontal Inset (pixels):', 100 )
		self.addToArchivePhoenixUpdate( self.screenHorizontalInset )
		self.screenVerticalInset = preferences.IntPreference().getFromValue( 'Screen Vertical Inset (pixels):', 150 )
		self.addToArchivePhoenixUpdate( self.screenVerticalInset )
		self.viewpointLatitude = preferences.FloatPreference().getFromValue( 'Viewpoint Latitude (degrees):', 15.0 )
		self.addToArchiveUpdate( self.viewpointLatitude )
		self.viewpointLongitude = preferences.FloatPreference().getFromValue( 'Viewpoint Longitude (degrees):', 210.0 )
		self.addToArchiveUpdate( self.viewpointLongitude )
		self.widthOfExtrusionThread = preferences.IntPreference().getFromValue( 'Width of Extrusion Thread (pixels):', 1 )
		self.addToArchiveUpdate( self.widthOfExtrusionThread )
		self.widthOfFillBottomThread = preferences.IntPreference().getFromValue( 'Width of Fill Bottom Thread (pixels):', 3 )
		self.addToArchiveUpdate( self.widthOfFillBottomThread )
		self.widthOfFillTopThread = preferences.IntPreference().getFromValue( 'Width of Fill Top Thread (pixels):', 3 )
		self.addToArchiveUpdate( self.widthOfFillTopThread )
		self.widthOfLoopThread = preferences.IntPreference().getFromValue( 'Width of Loop Thread (pixels):', 3 )
		self.addToArchiveUpdate( self.widthOfLoopThread )
		self.widthOfPerimeterInsideThread = preferences.IntPreference().getFromValue( 'Width of Perimeter Inside Thread (pixels):', 4 )
		self.addToArchiveUpdate( self.widthOfPerimeterInsideThread )
		self.widthOfPerimeterOutsideThread = preferences.IntPreference().getFromValue( 'Width of Perimeter Outside Thread (pixels):', 4 )
		self.addToArchiveUpdate( self.widthOfPerimeterOutsideThread )
		self.raftThreadWidth = preferences.IntPreference().getFromValue( 'Width of Raft Thread (pixels):', 1 )
		self.addToArchiveUpdate( self.raftThreadWidth )
		self.travelThreadWidth = preferences.IntPreference().getFromValue( 'Width of Travel Thread (pixels):', 0 )
		self.addToArchiveUpdate( self.travelThreadWidth )
		self.widthOfXAxis = preferences.IntPreference().getFromValue( 'Width of X Axis (pixels):', 5 )
		self.addToArchiveUpdate( self.widthOfXAxis )
		self.widthOfYAxis = preferences.IntPreference().getFromValue( 'Width of Y Axis (pixels):', 5 )
		self.addToArchiveUpdate( self.widthOfYAxis )
		self.widthOfZAxis = preferences.IntPreference().getFromValue( 'Width of Z Axis (pixels):', 5 )
		self.addToArchiveUpdate( self.widthOfZAxis )
		self.windowPositionBeholdDynamicPreferences = preferences.WindowPosition().getFromValue( 'windowPositionBehold Dynamic Preferences', '0+0' )
		self.addToArchiveUpdate( self.windowPositionBeholdDynamicPreferences )
		#Create the archive, title of the execute button, title of the dialog & preferences fileName.
		self.executeTitle = 'Behold'
		self.saveCloseTitle = 'Save and Close'
		preferences.setHelpPreferencesFileNameTitleWindowPosition( self, 'skeinforge_tools.analyze_plugins.behold.html' )
		self.windowPositionPreferences.windowPositionName = None
		self.updateFunction = None

	def addToArchiveUpdate( self, archivablePreference ):
		"Add preference to the archive and the update preferences."
		self.archive.append( archivablePreference )
		self.updatePreferences.append( archivablePreference )

	def addToArchivePhoenixUpdate( self, archivablePreference ):
		"Add preference to the archive, the phoenix preferences, and the update preferences."
		self.addToArchiveUpdate( archivablePreference )
		self.phoenixPreferenceTable[ archivablePreference ] = None

	def displayImmediateUpdateDialog( self ):
		"Display the immediate update dialog."
		self.executeTitle = None
		self.saveCloseTitle = None
		self.title = 'Behold Dynamic Preferences'
		oldArchive = self.archive
		self.archive = self.updatePreferences
		self.lowerName = 'behold dynamic'
		preferences.getDisplayedDialogFromConstructor( self )
		self.archive = oldArchive

	def execute( self ):
		"Write button has been clicked."
		fileNames = polyfile.getFileOrGcodeDirectory( self.fileNameInput.value, self.fileNameInput.wasCancelled )
		for fileName in fileNames:
			beholdFile( fileName )

	def setUpdateFunction( self, updateFunction ):
		"Set the update function of the update preferences."
		self.updateFunction = updateFunction
		for updatePreference in self.updatePreferences:
			updatePreference.setUpdateFunction( self.setToDisplaySaveUpdate )

	def setToDisplaySaveUpdate( self, event = None ):
		"Set the preference values to the display, save the new values, then call the update function."
		for updatePreference in self.updatePreferences:
			updatePreference.setToDisplay()
		preferences.writePreferences( self )
		if self.updateFunction != None:
			self.updateFunction()


class BeholdSkein:
	"A class to write a get a scalable vector graphics text for a gcode skein."
	def __init__( self ):
		self.coloredThread = []
		self.hasASurroundingLoopBeenReached = False
		self.isLoop = False
		self.isPerimeter = False
		self.isThereALayerStartWord = False
		self.layerTops = []
		self.oldLayerZoneIndex = 0
		self.oldZ = - 999999999999.0
		self.skeinPane = None
		self.skeinPanes = []
		self.thirdLayerThickness = 0.133333

	def addToPath( self, line, location ):
		'Add a point to travel and maybe extrusion.'
		if self.oldLocation == None:
			return
		begin = self.scale * self.oldLocation - self.scaleCenterBottom
		end = self.scale * location - self.scaleCenterBottom
		tagString = '%s %s' % ( self.lineIndex, line )
		coloredLine = ColoredLine( begin, '', end, tagString )
		coloredLine.z = location.z
		self.coloredThread.append( coloredLine )

	def getLayerTop( self ):
		"Get the layer top."
		if len( self.layerTops ) < 1:
			return - 9123456789123.9
		return self.layerTops[ - 1 ]

	def getLayerZoneIndex( self, z ):
		"Get the layer zone index."
		if self.layerTops[ self.oldLayerZoneIndex ] > z:
			if self.oldLayerZoneIndex == 0:
				return 0
			elif self.layerTops[ self.oldLayerZoneIndex - 1 ] < z:
				return self.oldLayerZoneIndex
		for layerTopIndex in xrange( len( self.layerTops ) ):
			layerTop = self.layerTops[ layerTopIndex ]
			if layerTop > z:
				self.oldLayerZoneIndex = layerTopIndex
				return layerTopIndex
		self.oldLayerZoneIndex = len( self.layerTops ) - 1
		return self.oldLayerZoneIndex

	def initializeActiveLocation( self ):
		"Set variables to default."
		self.extruderActive = False
		self.oldLocation = None

	def isLayerStart( self, firstWord, splitLine ):
		"Parse a gcode line and add it to the vector output."
		if self.isThereALayerStartWord:
			return firstWord == '(<layer>'
		if firstWord != 'G1' and firstWord != 'G2' and firstWord != 'G3':
			return False
		location = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		if location.z - self.oldZ > 0.1:
			self.oldZ = location.z
			return True
		return False

	def linearCorner( self, splitLine ):
		"Update the bounding corners."
		location = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		if self.extruderActive or self.goAroundExtruderOffTravel:
			self.cornerHigh = euclidean.getPointMaximum( self.cornerHigh, location )
			self.cornerLow = euclidean.getPointMinimum( self.cornerLow, location )
		self.oldLocation = location

	def linearMove( self, line, splitLine ):
		"Get statistics for a linear move."
		if self.skeinPane == None:
			return
		location = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		self.addToPath( line, location )
		self.oldLocation = location

	def moveColoredThreadToSkeinPane( self ):
		'Move a colored thread to the skein pane.'
		if len( self.coloredThread ) <= 0:
			return
		layerZoneIndex = self.getLayerZoneIndex( self.coloredThread[ 0 ].z )
		if not self.extruderActive:
			self.setColoredThread( ( 190.0, 190.0, 190.0 ), self.skeinPane.travelLines ) #gray
			return
		self.skeinPane.layerZoneIndex = layerZoneIndex
		if self.isPerimeter:
			perimeterComplex = getPolygonComplexFromColoredLines( self.coloredThread )
			if euclidean.isWiddershins( perimeterComplex ):
				self.setColoredThread( ( 255.0, 0.0, 0.0 ), self.skeinPane.perimeterOutsideLines ) #red
			else:
				self.setColoredThread( ( 255.0, 165.0, 0.0 ), self.skeinPane.perimeterInsideLines ) #orange
			return
		if self.isLoop:
			self.setColoredThread( ( 255.0, 255.0, 0.0 ), self.skeinPane.loopLines ) #yellow
			return
		if not self.hasASurroundingLoopBeenReached:
			self.setColoredThread( ( 165.0, 42.0, 42.0 ), self.skeinPane.raftLines ) #brown
			return
		if layerZoneIndex < self.beholdPreferences.numberOfFillBottomLayers.value:
			self.setColoredThread( ( 128.0, 128.0, 0.0 ), self.skeinPane.fillBottomLines ) #olive
			return
		if layerZoneIndex >= self.firstTopLayer:
			self.setColoredThread( ( 0.0, 0.0, 255.0 ), self.skeinPane.fillTopLines ) #blue
			return
		self.setColoredThread( ( 0.0, 255.0, 0.0 ), self.skeinPane.extrudeLines ) #green

	def parseCorner( self, line ):
		"Parse a gcode line and use the location to update the bounding corners."
		splitLine = line.split()
		if len( splitLine ) < 1:
			return
		firstWord = splitLine[ 0 ]
		if firstWord == 'G1':
			self.linearCorner( splitLine )
		elif firstWord == 'M101':
			self.extruderActive = True
		elif firstWord == 'M103':
			self.extruderActive = False
		elif firstWord == '(<layer>':
			self.layerTopZ = float( splitLine[ 1 ] ) + self.thirdLayerThickness
		elif firstWord == '(<layerThickness>':
			self.thirdLayerThickness = 0.33333333333 * float( splitLine[ 1 ] )
		elif firstWord == '(<surroundingLoop>)':
			if self.layerTopZ > self.getLayerTop():
				self.layerTops.append( self.layerTopZ )

	def parseGcode( self, gcodeText, beholdPreferences ):
		"Parse gcode text and store the vector output."
		self.beholdPreferences = beholdPreferences
		self.gcodeText = gcodeText
		self.initializeActiveLocation()
		self.cornerHigh = Vector3( - 999999999.0, - 999999999.0, - 999999999.0 )
		self.cornerLow = Vector3( 999999999.0, 999999999.0, 999999999.0 )
		self.goAroundExtruderOffTravel = beholdPreferences.goAroundExtruderOffTravel.value
		self.lines = gcodec.getTextLines( gcodeText )
		self.isThereALayerStartWord = gcodec.isThereAFirstWord( '(<layer>', self.lines, 1 )
		for line in self.lines:
			self.parseCorner( line )
		if len( self.layerTops ) > 0:
			self.layerTops[ - 1 ] += 912345678.9
		if len( self.layerTops ) > 1:
			self.oneMinusBrightnessOverTopLayerIndex = ( 1.0 - beholdPreferences.bottomLayerBrightness.value ) / float( len( self.layerTops ) - 1 )
		self.firstTopLayer = len( self.layerTops ) - self.beholdPreferences.numberOfFillTopLayers.value
		self.centerComplex = 0.5 * ( self.cornerHigh.dropAxis( 2 ) + self.cornerLow.dropAxis( 2 ) )
		self.centerBottom = Vector3( self.centerComplex.real, self.centerComplex.imag, self.cornerLow.z )
		self.scale = beholdPreferences.pixelsPerMillimeter.value
		self.scaleCenterBottom = self.scale * self.centerBottom
		self.scaleCornerHigh = self.scale * self.cornerHigh.dropAxis( 2 )
		self.scaleCornerLow = self.scale * self.cornerLow.dropAxis( 2 )
		print( "The lower left corner of the behold window is at %s, %s" % ( self.cornerLow.x, self.cornerLow.y ) )
		print( "The upper right corner of the behold window is at %s, %s" % ( self.cornerHigh.x, self.cornerHigh.y ) )
		self.cornerImaginaryTotal = self.cornerHigh.y + self.cornerLow.y
		margin = complex( 5.0, 5.0 )
		self.marginCornerLow = self.scaleCornerLow - margin
		self.screenSize = margin + 2.0 * ( self.scaleCornerHigh - self.marginCornerLow )
		self.initializeActiveLocation()
		for self.lineIndex in xrange( len( self.lines ) ):
			line = self.lines[ self.lineIndex ]
			self.parseLine( line )
		self.skeinPanes.sort( compareLayerSequence )

	def parseLine( self, line ):
		"Parse a gcode line and add it to the vector output."
		splitLine = line.split()
		if len( splitLine ) < 1:
			return
		firstWord = splitLine[ 0 ]
		if self.isLayerStart( firstWord, splitLine ):
			self.skeinPane = SkeinPane( len( self.skeinPanes ) )
			self.skeinPanes.append( self.skeinPane )
		if firstWord == 'G1':
			self.linearMove( line, splitLine )
		elif firstWord == 'M101':
			self.moveColoredThreadToSkeinPane()
			self.extruderActive = True
		elif firstWord == 'M103':
			self.moveColoredThreadToSkeinPane()
			self.extruderActive = False
			self.isLoop = False
			self.isPerimeter = False
		elif firstWord == '(<loop>)':
			self.isLoop = True
		elif firstWord == '(<perimeter>)':
			self.isPerimeter = True
		elif firstWord == '(<surroundingLoop>)':
			self.hasASurroundingLoopBeenReached = True

	def setColoredLineColor( self, coloredLine, colorTuple ):
		'Set the color and stipple of the colored line.'
		layerZoneIndex = self.getLayerZoneIndex( coloredLine.z )
		multiplier = self.beholdPreferences.bottomLayerBrightness.value
		if len( self.layerTops ) > 1:
			multiplier += self.oneMinusBrightnessOverTopLayerIndex * float( layerZoneIndex )
		bandIndex = layerZoneIndex / self.beholdPreferences.bandHeight.value
		if self.beholdPreferences.fromTheTop.value:
			brightZoneIndex = len( self.layerTops ) - 1 - layerZoneIndex
			bandIndex = brightZoneIndex / self.beholdPreferences.bandHeight.value + 1
		if bandIndex % 2 == 0:
			multiplier *= self.beholdPreferences.bottomBandBrightness.value
		red = getTwoHex( int( colorTuple[ 0 ] * multiplier ) )
		green = getTwoHex( int( colorTuple[ 1 ] * multiplier ) )
		blue = getTwoHex( int( colorTuple[ 2 ] * multiplier ) )
		coloredLine.colorName = '#%s%s%s' % ( red, green, blue )

	def setColoredThread( self, colorTuple, lineList ):
		'Set the colored thread, then move it to the line list and stipple of the colored line.'
		for coloredLine in self.coloredThread:
			self.setColoredLineColor( coloredLine, colorTuple )
		lineList += self.coloredThread
		self.coloredThread = []


class ColoredLine:
	"A colored line."
	def __init__( self, begin, colorName, end, tagString ):
		"Set the color name and corners."
		self.begin = begin
		self.colorName = colorName
		self.end = end
		self.tagString = tagString
	
	def __repr__( self ):
		"Get the string representation of this colored line."
		return '%s, %s, %s' % ( self.colorName, self.begin, self.end, self.tagString )


class LatitudeLongitude:
	"A latitude and longitude."
	def __init__( self, newCoordinate, skeinWindow, shift ):
		"Set the latitude and longitude."
		buttonOnePressedCentered = skeinWindow.getCenteredScreened( skeinWindow.buttonOnePressedCoordinate )
		buttonOnePressedRadius = abs( buttonOnePressedCentered )
		buttonOnePressedComplexMirror = complex( buttonOnePressedCentered.real, - buttonOnePressedCentered.imag )
		buttonOneReleasedCentered = skeinWindow.getCenteredScreened( newCoordinate )
		buttonOneReleasedRadius = abs( buttonOneReleasedCentered )
		pressedReleasedRotationComplex = buttonOneReleasedCentered * buttonOnePressedComplexMirror
		self.deltaLatitude = math.degrees( buttonOneReleasedRadius - buttonOnePressedRadius )
		self.originalDeltaLongitude = math.degrees( math.atan2( pressedReleasedRotationComplex.imag, pressedReleasedRotationComplex.real ) )
		self.deltaLongitude = self.originalDeltaLongitude
		if skeinWindow.beholdPreferences.viewpointLatitude.value > 90.0:
			self.deltaLongitude = - self.deltaLongitude
		if shift:
			if abs( self.deltaLatitude ) > abs( self.deltaLongitude ):
				self.deltaLongitude = 0.0
			else:
				self.deltaLatitude = 0.0
		self.latitude = getBoundedLatitude( skeinWindow.beholdPreferences.viewpointLatitude.value + self.deltaLatitude )
		self.longitude = round( ( skeinWindow.beholdPreferences.viewpointLongitude.value + self.deltaLongitude ) % 360.0, 1 )


class SkeinPane:
	"A class to hold the colored lines for a layer."
	def __init__( self, sequenceIndex ):
		"Create empty line lists."
		self.extrudeLines = []
		self.fillBottomLines = []
		self.fillTopLines = []
		self.layerZoneIndex = 0
		self.loopLines = []
		self.perimeterInsideLines = []
		self.perimeterOutsideLines = []
		self.raftLines = []
		self.sequenceIndex = sequenceIndex
		self.travelLines = []


class SkeinWindow:
	def __init__( self, beholdPreferences, skein ):
		"Initialize the skein window."
		title = 'Behold Viewer'
		self.arrowshape = ( 24, 30, 9 )
		self.beholdPreferences = beholdPreferences
		self.buttonOnePressedCoordinate = None
		self.screenSize = skein.screenSize
		self.center = 0.5 * self.screenSize
		self.index = 0
		self.motionStippleName = 'gray75'
		self.movementTextID = None
		self.oldPixelsPerMillimeter = beholdPreferences.pixelsPerMillimeter.value
		self.root = preferences.Tkinter.Tk()
		self.root.title( title )
		self.skein = skein
		self.skeinPanes = skein.skeinPanes
		for phoenixPreferenceTableKey in beholdPreferences.phoenixPreferenceTable.keys():
			beholdPreferences.phoenixPreferenceTable[ phoenixPreferenceTableKey ] = phoenixPreferenceTableKey.value
		fileHelpMenuBar = preferences.FileHelpMenuBar( self.root )
		fileHelpMenuBar.helpMenu.add_command( label = 'Behold', command = preferences.HelpPage().getOpenFromDocumentationSubName( 'skeinforge_tools.analyze_plugins.behold.html' ) )
		fileHelpMenuBar.completeMenu( self.destroyAllDialogWindows, beholdPreferences.lowerName )
		frame = preferences.Tkinter.Frame( self.root )
		xScrollbar = preferences.Tkinter.Scrollbar( self.root, orient = preferences.Tkinter.HORIZONTAL )
		yScrollbar = preferences.Tkinter.Scrollbar( self.root )
		self.canvasHeight = min( int( self.screenSize.imag ), self.root.winfo_screenheight() - beholdPreferences.screenVerticalInset.value )
		self.canvasWidth = min( int( self.screenSize.real ), self.root.winfo_screenwidth() - beholdPreferences.screenHorizontalInset.value )
		self.canvas = preferences.Tkinter.Canvas( self.root, width = self.canvasWidth, height = self.canvasHeight, scrollregion = ( 0, 0, int( self.screenSize.real ), int( self.screenSize.imag ) ) )
		self.canvas.grid( row = 0, rowspan = 98, column = 0, columnspan = 99, sticky = preferences.Tkinter.W )
		xScrollbar.grid( row = 98, column = 0, columnspan = 99, sticky = preferences.Tkinter.E + preferences.Tkinter.W )
		xScrollbar.config( command = self.canvas.xview )
		yScrollbar.grid( row = 0, rowspan = 98, column = 99, sticky = preferences.Tkinter.N + preferences.Tkinter.S )
		yScrollbar.config( command = self.canvas.yview )
		self.canvas[ 'xscrollcommand' ] = xScrollbar.set
		self.canvas[ 'yscrollcommand' ] = yScrollbar.set
		self.exitButton = preferences.Tkinter.Button( self.root, text = 'Exit', activebackground = 'black', activeforeground = 'red', command = self.destroyAllDialogWindows, fg = 'red' )
		self.exitButton.grid( row = 99, column = 95, columnspan = 5, sticky = preferences.Tkinter.W )
		preferences.CloseListener( title.lower(), self ).listenToWidget( self.exitButton )
		self.showPreferencesButton = preferences.Tkinter.Button( self.root, activebackground = 'black', activeforeground = 'purple', command = self.showPreferences, text = 'Show Preferences' )
		self.showPreferencesButton.grid( row = 99, column = 0, sticky = preferences.Tkinter.W )
		self.canvas.bind( '<Button-1>', self.buttonOneClicked )
		self.canvas.bind( '<ButtonRelease-1>', self.buttonOneReleased )
		self.canvas.bind( '<Shift-ButtonRelease-1>', self.buttonOneReleasedShift )
		self.canvas.bind( '<Leave>', self.leave )
		self.canvas.bind( '<Motion>', self.motion )
		self.canvas.bind( '<Shift-Motion>', self.motionShift )
		halfCenter = 0.5 * self.center.real
		self.xAxisLine = ColoredLine( Vector3(), 'darkorange', Vector3( halfCenter ), 'X Axis' )
		self.yAxisLine = ColoredLine( Vector3(), 'gold', Vector3( 0.0, halfCenter ), 'Y Axis' )
		self.zAxisLine = ColoredLine( Vector3(), 'skyblue', Vector3( 0.0, 0.0, halfCenter ), 'Z Axis' )
		self.canvas.xview( preferences.Tkinter.MOVETO, 0.5 * ( 1.0 - float( self.canvasWidth ) / float( self.screenSize.real ) ) )
		self.canvas.yview( preferences.Tkinter.MOVETO, 0.5 * ( 1.0 - float( self.canvasHeight ) / float( self.screenSize.imag ) ) )
		self.update()
		geometryString = self.root.geometry()
		if geometryString == '1x1+0+0':
			self.root.update_idletasks()
			geometryString = self.root.geometry()
		lastPlusIndex = geometryString.rfind( '+' )
		windowY = int( geometryString[ lastPlusIndex + 1 : ] )
		if windowY != 0:
			geometryString = geometryString[ : lastPlusIndex + 1 ] + '0'
			self.root.geometry( geometryString )
			self.root.update_idletasks()
		self.showPreferences()

	def buttonOneClicked( self, event ):
		"Print the line clicked."
		x = self.canvas.canvasx( event.x )
		y = self.canvas.canvasy( event.y )
		self.buttonOnePressedCoordinate = complex( x, y )
		self.canvas.delete( 'motion' )
		print( 'The line clicked is: ' + self.getTagsGivenXY( x, y ) )

	def buttonOneReleased( self, event, shift = False ):
		"Move the viewpoint if the mouse was released."
		if self.buttonOnePressedCoordinate == None:
			return
		x = self.canvas.canvasx( event.x )
		y = self.canvas.canvasy( event.y )
		buttonOneReleasedCoordinate = complex( x, y )
		if abs( self.buttonOnePressedCoordinate - buttonOneReleasedCoordinate ) < 3:
			self.buttonOnePressedCoordinate = None
			self.canvas.delete( 'motion' )
			return
		latitudeLongitude = LatitudeLongitude( buttonOneReleasedCoordinate, self, shift )
		self.beholdPreferences.viewpointLatitude.value = latitudeLongitude.latitude
		self.beholdPreferences.viewpointLatitude.setStateToValue()
		self.beholdPreferences.viewpointLongitude.value = latitudeLongitude.longitude
		self.beholdPreferences.viewpointLongitude.setStateToValue()
		self.buttonOnePressedCoordinate = None
		preferences.writePreferences( self.beholdPreferences )
		self.update()

	def buttonOneReleasedShift( self, event ):
		"Move the viewpoint if the mouse was released and the shift key was pressed."
		self.buttonOneReleased( event, True )

	def destroyAllDialogWindows( self ):
		"Destroy all the dialog windows."
		if self.showPreferencesButton[ 'state' ] == preferences.Tkinter.DISABLED:
			self.beholdPreferences.preferencesDialog.root.destroy()
		self.root.destroy()

	def destroyMovementText( self ):
		'Destroy the movement text.'
		self.canvas.delete( self.movementTextID )
		self.movementTextID = None

	def drawColoredLine( self, arrowType, coloredLine, viewVectors, width ):
		"Draw colored line."
		complexBegin = self.getViewComplex( coloredLine.begin, viewVectors )
		complexEnd = self.getViewComplex( coloredLine.end, viewVectors )
		self.canvas.create_line(
			complexBegin.real,
			complexBegin.imag,
			complexEnd.real,
			complexEnd.imag,
			fill = coloredLine.colorName,
			arrow = arrowType,
			tags = coloredLine.tagString,
			width = width )

	def drawColoredLineMotion( self, coloredLine, viewVectors, width ):
		"Draw colored line with motion stipple and tag."
		complexBegin = self.getViewComplex( coloredLine.begin, viewVectors )
		complexEnd = self.getViewComplex( coloredLine.end, viewVectors )
		self.canvas.create_line(
			complexBegin.real,
			complexBegin.imag,
			complexEnd.real,
			complexEnd.imag,
			fill = coloredLine.colorName,
			arrow = 'last',
			arrowshape = self.arrowshape,
			stipple = self.motionStippleName,
			tags = 'motion',
			width = width + 4 )

	def drawColoredLines( self, coloredLines, viewVectors, width ):
		"Draw colored lines."
		if width <= 0:
			return
		for coloredLine in coloredLines:
			self.drawColoredLine( self.arrowType, coloredLine, viewVectors, width )

	def drawSkeinPane( self, skeinPane, viewVectors ):
		"Draw colored lines."
		self.drawColoredLines( skeinPane.raftLines, viewVectors, self.beholdPreferences.raftThreadWidth.value )
		self.drawColoredLines( skeinPane.travelLines, viewVectors, self.beholdPreferences.travelThreadWidth.value )
		self.drawColoredLines( skeinPane.fillBottomLines, viewVectors, self.beholdPreferences.widthOfFillBottomThread.value )
		self.drawColoredLines( skeinPane.extrudeLines, viewVectors, self.beholdPreferences.widthOfExtrusionThread.value )
		self.drawColoredLines( skeinPane.fillTopLines, viewVectors, self.beholdPreferences.widthOfFillTopThread.value )
		self.drawColoredLines( skeinPane.loopLines, viewVectors, self.beholdPreferences.widthOfLoopThread.value )
		self.drawColoredLines( skeinPane.perimeterInsideLines, viewVectors, self.beholdPreferences.widthOfPerimeterInsideThread.value )
		self.drawColoredLines( skeinPane.perimeterOutsideLines, viewVectors, self.beholdPreferences.widthOfPerimeterOutsideThread.value )

	def drawXYAxisLines( self, viewVectors ):
		"Draw the x and y axis lines."
		if self.beholdPreferences.widthOfXAxis.value > 0:
			self.drawColoredLine( 'last', self.xAxisLine, viewVectors, self.beholdPreferences.widthOfXAxis.value )
		if self.beholdPreferences.widthOfYAxis.value > 0:
			self.drawColoredLine( 'last', self.yAxisLine, viewVectors, self.beholdPreferences.widthOfYAxis.value )

	def drawZAxisLine( self, viewVectors ):
		"Draw the z axis line."
		if self.beholdPreferences.widthOfZAxis.value > 0:
			self.drawColoredLine( 'last', self.zAxisLine, viewVectors, self.beholdPreferences.widthOfZAxis.value )

	def getCentered( self, coordinate ):
		"Get the centered coordinate."
		relativeToCenter = complex( coordinate.real - self.center.real, self.center.imag - coordinate.imag )
		if abs( relativeToCenter ) < 1.0:
			relativeToCenter = complex( 0.0, 1.0 )
		return relativeToCenter

	def getCenteredScreened( self, coordinate ):
		"Get the normalized centered coordinate."
		relativeToCenter = self.getCentered( coordinate )
		smallestHalfSize = 0.5 * min( float( self.canvasHeight ), float( self.canvasWidth ) )
		return relativeToCenter / smallestHalfSize

	def getScreenComplex( self, pointComplex ):
		"Get the point in screen perspective."
		return complex( pointComplex.real, - pointComplex.imag ) + self.center

	def getTagsGivenXY( self, x, y ):
		"Get the tag for the x and y."
		if self.movementTextID != None:
			self.destroyMovementText()
		tags = self.canvas.itemcget( self.canvas.find_closest( x, y ), 'tags' )
		currentEnd = ' current'
		if tags.find( currentEnd ) != - 1:
			return tags[ : - len( currentEnd ) ]
		return tags

	def getViewComplex( self, point, viewVectors ):
		"Get the point in view perspective."
		screenComplexX = point.dot( viewVectors.viewXVector3 )
		screenComplexY = point.dot( viewVectors.viewYVector3 )
		return self.getScreenComplex( complex( screenComplexX, screenComplexY ) )

	def leave( self, event ):
		"Null the button one pressed coordinate because the mouse has left the canvas."
		self.buttonOnePressedCoordinate = None
		self.canvas.delete( 'motion' )
		self.destroyMovementText()

	def motion( self, event, shift = False ):
		"Move the viewpoint if the mouse was moved."
		if self.buttonOnePressedCoordinate == None:
			if not self.beholdPreferences.displayLineTextWhenMouseMoves.value:
				return
			x = self.canvas.canvasx( event.x )
			y = self.canvas.canvasy( event.y )
			tags = self.getTagsGivenXY( x, y )
			if tags != '':
				self.movementTextID = self.canvas.create_text ( x, y, anchor = preferences.Tkinter.SW, text = 'The line is: ' + tags )
			return
		x = self.canvas.canvasx( event.x )
		y = self.canvas.canvasy( event.y )
		motionCoordinate = complex( x, y )
		latitudeLongitude = LatitudeLongitude( motionCoordinate, self, shift )
		viewVectors = ViewVectors( latitudeLongitude.latitude, latitudeLongitude.longitude )
		motionCentered = self.getCentered( motionCoordinate )
		motionCenteredNormalized = motionCentered / abs( motionCentered )
		buttonOnePressedCentered = self.getCentered( self.buttonOnePressedCoordinate )
		buttonOnePressedAngle = math.degrees( math.atan2( buttonOnePressedCentered.imag, buttonOnePressedCentered.real ) )
		buttonOnePressedLength = abs( buttonOnePressedCentered )
		buttonOnePressedCorner = complex( buttonOnePressedLength, buttonOnePressedLength )
		buttonOnePressedCornerBottomLeft = self.getScreenComplex( - buttonOnePressedCorner )
		buttonOnePressedCornerUpperRight = self.getScreenComplex( buttonOnePressedCorner )
		motionPressedStart = buttonOnePressedLength * motionCenteredNormalized
		motionPressedScreen = self.getScreenComplex( motionPressedStart )
		motionColorName = '#4B0082'
		motionWidth = 9
		self.canvas.delete( 'motion' )
		if abs( latitudeLongitude.deltaLongitude ) > 0.0:
			self.canvas.create_arc(
				buttonOnePressedCornerBottomLeft.real,
				buttonOnePressedCornerBottomLeft.imag,
				buttonOnePressedCornerUpperRight.real,
				buttonOnePressedCornerUpperRight.imag,
				extent = latitudeLongitude.originalDeltaLongitude,
				start = buttonOnePressedAngle,
				outline = motionColorName,
				outlinestipple = self.motionStippleName,
				style = preferences.Tkinter.ARC,
				tags = 'motion',
				width = motionWidth )
		if abs( latitudeLongitude.deltaLatitude ) > 0.0:
			self.canvas.create_line(
				motionPressedScreen.real,
				motionPressedScreen.imag,
				x,
				y,
				fill = motionColorName,
				arrow = 'last',
				arrowshape = self.arrowshape,
				stipple = self.motionStippleName,
				tags = 'motion',
				width = motionWidth )
		if self.beholdPreferences.widthOfXAxis.value > 0:
			self.drawColoredLineMotion( self.xAxisLine, viewVectors, self.beholdPreferences.widthOfXAxis.value )
		if self.beholdPreferences.widthOfYAxis.value > 0:
			self.drawColoredLineMotion( self.yAxisLine, viewVectors, self.beholdPreferences.widthOfYAxis.value )
		if self.beholdPreferences.widthOfZAxis.value > 0:
			self.drawColoredLineMotion( self.zAxisLine, viewVectors, self.beholdPreferences.widthOfZAxis.value )

	def motionShift( self, event ):
		"Move the viewpoint if the mouse was moved and the shift key was pressed."
		self.motion( event, True )

	def preferencesDestroyed( self, event ):
		"Enable the show preferences button because the dynamic preferences were destroyed."
		try:
			self.showPreferencesButton.config( state = preferences.Tkinter.NORMAL )
		except:
			pass

	def printHexadecimalColorName( self, name ):
		"Print the color name in hexadecimal."
		colorTuple = self.canvas.winfo_rgb( name )
		print( '#%s%s%s' % ( getTwoHex( colorTuple[ 0 ] ), getTwoHex( colorTuple[ 1 ] ), getTwoHex( colorTuple[ 2 ] ) ) )

	def showPreferences( self ):
		"Show the dynamic preferences."
		self.beholdPreferences.displayImmediateUpdateDialog()
		self.beholdPreferences.setUpdateFunction( self.update  )
		self.beholdPreferences.drawArrows.checkbutton.bind( '<Destroy>', self.preferencesDestroyed )
		self.showPreferencesButton.config( state = preferences.Tkinter.DISABLED )

	def update( self ):
		"Update the screen."
		if len( self.skeinPanes ) < 1:
			return
		for phoenixPreferenceTableKey in self.beholdPreferences.phoenixPreferenceTable.keys():
			if self.beholdPreferences.phoenixPreferenceTable[ phoenixPreferenceTableKey ] != phoenixPreferenceTableKey.value:
				self.destroyAllDialogWindows()
				displayBeholdFileGivenTextPreferences( self.skein.gcodeText, self.beholdPreferences )
				return
		self.arrowType = None
		if self.beholdPreferences.drawArrows.value:
			self.arrowType = 'last'
		self.canvas.delete( preferences.Tkinter.ALL )
		self.beholdPreferences.viewpointLatitude.value = getBoundedLatitude( self.beholdPreferences.viewpointLatitude.value )
		self.beholdPreferences.viewpointLongitude.value = round( self.beholdPreferences.viewpointLongitude.value, 1 )
		viewVectors = ViewVectors( self.beholdPreferences.viewpointLatitude.value, self.beholdPreferences.viewpointLongitude.value )
		skeinPanesCopy = self.skeinPanes[ self.beholdPreferences.layersFrom.value : self.beholdPreferences.layersTo.value ]
		if viewVectors.viewpointLatitudeRatio.real > 0.0:
			self.drawXYAxisLines( viewVectors )
		else:
			skeinPanesCopy.reverse()
			self.drawZAxisLine( viewVectors )
		for skeinPane in skeinPanesCopy:
			self.drawSkeinPane( skeinPane, viewVectors )
		if viewVectors.viewpointLatitudeRatio.real > 0.0:
			self.drawZAxisLine( viewVectors )
		else:
			self.drawXYAxisLines( viewVectors )


class ViewVectors:
	def __init__( self, viewpointLatitude, viewpointLongitude ):
		"Initialize the view vectors."
		longitudeComplex = euclidean.getPolar( math.radians( 90.0 - viewpointLongitude ) )
		self.viewpointLatitudeRatio = euclidean.getPolar( math.radians( viewpointLatitude ) )
		self.viewpointVector3 = Vector3( self.viewpointLatitudeRatio.imag * longitudeComplex.real, self.viewpointLatitudeRatio.imag * longitudeComplex.imag, self.viewpointLatitudeRatio.real )
		self.viewXVector3 = Vector3( - longitudeComplex.imag, longitudeComplex.real, 0.0 )
		self.viewXVector3.normalize()
		self.viewYVector3 = self.viewpointVector3.cross( self.viewXVector3 )
		self.viewYVector3.normalize()


def main():
	"Display the behold dialog."
	if len( sys.argv ) > 1:
		beholdFile( ' '.join( sys.argv[ 1 : ] ) )
	else:
		preferences.startMainLoopFromConstructor( getPreferencesConstructor() )

if __name__ == "__main__":
	main()
