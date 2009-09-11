"""
Raft is a script to create a reusable raft, elevate the nozzle and set the temperature.

Allan Ecker aka The Masked Retriever's has written the following two quicktips for raft.
"Skeinforge Quicktip: The Raft, Part 1" at: http://blog.thingiverse.com/2009/07/14/skeinforge-quicktip-the-raft-part-1/
"Skeinforge Quicktip: The Raft, Part II": http://blog.thingiverse.com/2009/08/04/skeinforge-quicktip-the-raft-part-ii/

The default 'Activate Raft' checkbox is on.  When it is on, the functions described below will work, when it is off, the
functions will not be called.  The raft script sets the temperature.  If the "Activate Raft, Elevate Nozzle, Orbit and Set
Altitude" checkbox is checked, the script will also create a raft, elevate the nozzle, orbit and set the altitude of the bottom
of the raft.

Raft is based on the Nophead's reusable raft, which has a base layer running one way, and a couple of perpendicular layers
above.  Each set of layers can be set to a different temperature.  There is the option of having the extruder orbit the raft for a
while, so the heater barrel has time to reach a different temperature, without ooze accumulating around the nozzle.  To run
raft, in a shell type:
> python raft.py

The important values for the raft preferences are the temperatures of the raft, the first layer and the next layers.  These will be
different for each material.  The default preferences for ABS, HDPE, PCL & PLA are extrapolated from Nophead's
experiments.  To change the material, in a shell type:
> python profile.py

This brings up the profile preferences dialog.  In that dialog you can add or delete a profile on the listbox and you change
the selected profile.  After you can change the selected profile, run raft again.  If there are preferences for the new profile,
those will be in the raft dialog.  If there are no preferences for the new profile, the preferences will be set to defaults and you
will have to set new preferences for the new profile.

The "Base Infill Density" preference is the infill density ratio of the base of the raft, the default ratio is half.  The "Base Layer
Height over Layer Thickness" preference is the ratio of the height & width of the base layer compared to the height and width
of the shape infill, the default is two.  The feedrate will be slower for raft layers which have thicker extrusions than the shape
infill.  The "Base Layers" preference is the number of base layers, the default is one.  The "Base Nozzle Lift over Half Base
Layer Thickness" is the amount the nozzle is above the center of the extrusion divided by half the base layer thickness.

The interface of the raft has equivalent preferences called "Interface Infill Density", "Interface Layer Thickness over Extrusion
Height", "Interface Layers" and "Interface Nozzle Lift over Half Base Layer Thickness".  The shape has the equivalent
preference of called "Operating Nozzle Lift over Half Layer Thickness".

The altitude that the bottom of the raft will be set to the "Bottom Altitude" preference.

The raft fills a rectangle whose size is the rectangle around the bottom layer of the shape expanded on each side by the
"Raft Outset Radius over Extrusion Width" preference times the extrusion width, minus the "Infill Overhang" ratio times the
width of the extrusion of the raft.

In the "Support Material Choice" radio button group, if "No Support Material" is selected then raft will not add support
material, this is the default because the raft takes time to generate.  If "Support Material Everywhere" is selected, support
material will be added wherever there are overhangs, even inside the object; because support material inside objects is hard
or impossible to remove, this option should only be chosen if the shape has a cavity that needs support and there is some
way to extract the support material.  If "Support Material on Exterior Only" is selected, support material will be added only
the exterior of the object; this is the best option for most objects which require support material.  The "Support Minimum
Angle" preference is the minimum angle that a surface overhangs before support material is added, the default is sixty
degrees. The "Support Flowrate over Operating Flowrate" is the ratio of the flowrate when the support is extruded over the
operating flowrate.  With a number less than one, the support flowrate will be smaller so the support will be thinner and
easier to remove, the default is 0.9.  The "Support Gap over Perimeter Extrusion Width" is the gap between the support
material and the object over the perimeter extrusion width, the default is 0.5.

If support material is generated, then if there is a file support_start.txt, it will add that to the start of the support gcode. After
it has added the support gcode, it will add the file support_end.txt if it exists.  Raft does not care if the text file names are
capitalized, but some file systems do not handle file name cases properly, so to be on the safe side you should give them
lower case names.  Raft looks for those files in the alterations folder in the .skeinforge folder in the home directory. If it
doesn't find the file it then looks in the alterations folder in the skeinforge_tools folder. If it doesn't find anything there it looks
in the skeinforge_tools folder.

The extruder will orbit for at least "Temperature Change Time Before Raft" seconds before extruding the raft.  It will orbit for
at least "Temperature Change Time Before First Layer Outline" seconds before extruding the outline of the first layer of the
shape.  It will orbit for at least "Temperature Change Time Before Next Threads" seconds before extruding within the outline
of the first layer of the shape and before extruding the next layers of the shape.  It will orbit for at least "Temperature
Change Time Before Support Layers" seconds before extruding the support layers.  It will orbit for at least "Temperature
Change Time Before Supported Layers" seconds before extruding the layer of the shape above the support layer.  If a time
is zero, it will not orbit.

The "Temperature of Raft" preference sets the temperature of the raft.  The "Temperature of Shape First Layer Outline"
preference sets the temperature of the outline of the first layer of the shape.  The "Temperature of Shape First Layer Within"
preference sets the temperature within the outline of the first layer of the shape.  The "Temperature of Shape Next Layers"
preference sets the temperature of the next layers of the shape.  The "Temperature of Support Layers" preference sets the
temperature of the support layer.  The "Temperature of Supported Layers" preference sets the temperature of the layer of the
shape above the support layer.

The following examples raft the files Screw Holder Bottom.gcode & Screw Holder Bottom.stl.  The examples are run in a terminal in the folder
which contains Screw Holder Bottom.gcode, Screw Holder Bottom.stl and raft.py.  The raft function will raft if "Activate Raft, Elevate Nozzle,
Orbit and Set Altitude" is true, which can be set in the dialog or by changing the preferences file 'raft.csv' with a text editor or a
spreadsheet program set to separate tabs.  The functions writeOutput and getChainGcode check to see if the text has
been rafted, if not they call getChainGcode in speed.py to get speeded gcode; once they have the speeded text, then
they raft.  Pictures of rafting in action are available from the Metalab blog at:
http://reprap.soup.io/?search=rafting


> python raft.py
This brings up the dialog, after clicking 'Raft', the following is printed:
File Screw Holder Bottom.stl is being chain rafted.
The rafted file is saved as Screw Holder Bottom_raft.gcode


>python
Python 2.5.1 (r251:54863, Sep 22 2007, 01:43:31)
[GCC 4.2.1 (SUSE Linux)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import raft
>>> raft.main()
This brings up the raft dialog.


>>> raft.writeOutput()
Screw Holder Bottom.stl
File Screw Holder Bottom.stl is being chain rafted.
The rafted file is saved as Screw Holder Bottom_raft.gcode

"""

from __future__ import absolute_import
#Init has to be imported first because it has code to workaround the python bug where relative imports don't work if the module is imported as a main module.
import __init__

from skeinforge_tools import polyfile
from skeinforge_tools.skeinforge_utilities import consecution
from skeinforge_tools.skeinforge_utilities import euclidean
from skeinforge_tools.skeinforge_utilities import gcodec
from skeinforge_tools.skeinforge_utilities import intercircle
from skeinforge_tools.skeinforge_utilities import interpret
from skeinforge_tools.skeinforge_utilities import preferences
from skeinforge_tools.skeinforge_utilities.vector3 import Vector3
import math
import os
import sys


__author__ = "Enrique Perez (perez_enrique@yahoo.com)"
__date__ = "$Date: 2008/21/04 $"
__license__ = "GPL 3.0"


#maybe later wide support
def addXIntersectionsFromSegment( index, segment, xIntersectionIndexList ):
	"Add the x intersections from the segment."
	for endpoint in segment:
		xIntersectionIndexList.append( euclidean.XIntersectionIndex( index, endpoint.point.real ) )

def addXIntersectionsFromSegments( index, segments, xIntersectionIndexList ):
	"Add the x intersections from the segments."
	for segment in segments:
		addXIntersectionsFromSegment( index, segment, xIntersectionIndexList )

#raft outline temperature http://hydraraptor.blogspot.com/2008/09/screw-top-pot.html
def getCraftedText( fileName, text = '', raftPreferences = None ):
	"Raft the file or text."
	return getCraftedTextFromText( gcodec.getTextIfEmpty( fileName, text ), raftPreferences )

def getCraftedTextFromText( gcodeText, raftPreferences = None ):
	"Raft a gcode linear move text."
	if gcodec.isProcedureDoneOrFileIsEmpty( gcodeText, 'raft' ):
		return gcodeText
	if raftPreferences == None:
		raftPreferences = preferences.getReadPreferences( RaftPreferences() )
	if not raftPreferences.activateRaft.value:
		return gcodeText
	return RaftSkein().getCraftedGcode( gcodeText, raftPreferences )

def getCrossHatchPointLine( crossHatchPointLineTable, y ):
	"Get the cross hatch point line."
	if not crossHatchPointLineTable.has_key( y ):
		crossHatchPointLineTable[ y ] = {}
	return crossHatchPointLineTable[ y ]

def getDisplayedPreferences():
	"Get the displayed preferences."
	return preferences.getDisplayedDialogFromConstructor( RaftPreferences() )

def getEndpointsFromYIntersections( x, yIntersections ):
	"Get endpoints from the y intersections."
	endpoints = []
	for yIntersectionIndex in xrange( 0, len( yIntersections ), 2 ):
		firstY = yIntersections[ yIntersectionIndex ]
		secondY = yIntersections[ yIntersectionIndex + 1 ]
		if firstY != secondY:
			firstComplex = complex( x, firstY )
			secondComplex = complex( x, secondY )
			endpointFirst = euclidean.Endpoint()
			endpointSecond = euclidean.Endpoint().getFromOtherPoint( endpointFirst, secondComplex )
			endpointFirst.getFromOtherPoint( endpointSecond, firstComplex )
			endpoints.append( endpointFirst )
			endpoints.append( endpointSecond )
	return endpoints

def getExtendedLineSegment( extensionDistance, lineSegment, loopXIntersections ):
	"Get extended line segment."
	pointBegin = lineSegment[ 0 ].point
	pointEnd = lineSegment[ 1 ].point
	segment = pointEnd - pointBegin
	segmentLength = abs( segment )
	if segmentLength <= 0.0:
		print( "This should never happen in getExtendedLineSegment in raft, the segment should have a length greater than zero." )
		print( lineSegment )
		return None
	segmentExtend = segment * extensionDistance / segmentLength
	lineSegment[ 0 ].point = pointBegin - segmentExtend
	lineSegment[ 1 ].point = pointEnd + segmentExtend
	for loopXIntersection in loopXIntersections:
		setExtendedPoint( lineSegment[ 0 ], pointBegin, loopXIntersection )
		setExtendedPoint( lineSegment[ 1 ], pointEnd, loopXIntersection )
	return lineSegment

def getFillXIntersectionIndexes( fillLoops, y ):
	"Get fill x intersection indexes inside loops."
	xIntersectionIndexList = []
	euclidean.addXIntersectionIndexesFromLoops( fillLoops, 0, xIntersectionIndexList, y )
	return xIntersectionIndexList

def getHorizontalSegments( fillLoops, alreadyFilledArounds, y ):
	"Get horizontal segments inside loops."
	xIntersectionIndexList = []
	euclidean.addXIntersectionIndexesFromLoops( fillLoops, - 1, xIntersectionIndexList, y )
	euclidean.addXIntersectionIndexesFromLoops( alreadyFilledArounds, 0, xIntersectionIndexList, y )
	return euclidean.getSegmentsFromXIntersectionIndexes( xIntersectionIndexList, y )

def getJoinOfXIntersectionIndexes( xIntersectionIndexList ):
	"Get x intersections from surrounding layers."
	xIntersectionList = []
	solidTable = {}
	solid = False
	xIntersectionIndexList.sort()
	for xIntersectionIndex in xIntersectionIndexList:
		euclidean.toggleHashtable( solidTable, xIntersectionIndex.index, "" )
		oldSolid = solid
		solid = len( solidTable ) > 0
		if oldSolid != solid:
			xIntersectionList.append( xIntersectionIndex.x )
	return xIntersectionList

def joinSegmentTables( fromTable, intoTable ):
	"Join both segment tables and put the join into the intoTable."
	intoTableKeys = intoTable.keys()
	fromTableKeys = fromTable.keys()
	joinedKeyTable = {}
	concatenatedSegmentTableKeys = intoTableKeys + fromTableKeys
	for concatenatedSegmentTableKey in concatenatedSegmentTableKeys:
		joinedKeyTable[ concatenatedSegmentTableKey ] = None
	joinedKeys = joinedKeyTable.keys()
	joinedKeys.sort()
	joinedSegmentTable = {}
	for joinedKey in joinedKeys:
		xIntersectionIndexList = []
		if joinedKey in intoTable:
			addXIntersectionsFromSegments( 0, intoTable[ joinedKey ], xIntersectionIndexList )
		if joinedKey in fromTable:
			addXIntersectionsFromSegments( 1, fromTable[ joinedKey ], xIntersectionIndexList )
		xIntersections = getJoinOfXIntersectionIndexes( xIntersectionIndexList )
		lineSegments = euclidean.getSegmentsFromXIntersections( xIntersections, joinedKey )
		if len( lineSegments ) > 0:
			intoTable[ joinedKey ] = lineSegments
		else:
			print( "This should never happen, there are no line segments in joinSegments in raft." )

def setExtendedPoint( lineSegmentEnd, pointOriginal, x ):
	"Set the point in the extended line segment."
	if x > min( lineSegmentEnd.point.real, pointOriginal.real ) and x < max( lineSegmentEnd.point.real, pointOriginal.real ):
		lineSegmentEnd.point = complex( x, pointOriginal.imag)

def subtractFill( fillXIntersectionIndexTable, supportSegmentLayerTable ):
	"Subtract fill from the support layer table."
	supportSegmentLayerTableKeys = supportSegmentLayerTable.keys()
	supportSegmentLayerTableKeys.sort()
	if len( supportSegmentLayerTableKeys ) < 1:
		return
	for supportSegmentLayerTableKey in supportSegmentLayerTableKeys:
		xIntersectionIndexList = []
		addXIntersectionsFromSegments( - 1, supportSegmentLayerTable[ supportSegmentLayerTableKey ], xIntersectionIndexList )
		if supportSegmentLayerTableKey in fillXIntersectionIndexTable:
			addXIntersectionsFromSegments( 0, fillXIntersectionIndexTable[ supportSegmentLayerTableKey ], xIntersectionIndexList )
		lineSegments = euclidean.getSegmentsFromXIntersectionIndexes( xIntersectionIndexList, supportSegmentLayerTableKey )
		if len( lineSegments ) > 0:
			supportSegmentLayerTable[ supportSegmentLayerTableKey ] = lineSegments
		else:
			del supportSegmentLayerTable[ supportSegmentLayerTableKey ]

def writeOutput( fileName = '' ):
	"""Raft a gcode linear move file.  Chain raft the gcode if it is not already rafted.
	If no fileName is specified, raft the first unmodified gcode file in this folder."""
	fileName = interpret.getFirstTranslatorFileNameUnmodified( fileName )
	if fileName == '':
		return
	consecution.writeChainText( fileName, ' is being chain rafted.', 'The rafted file is saved as ', 'raft' )


class RaftPreferences:
	"A class to handle the raft preferences."
	def __init__( self ):
		"Set the default preferences, execute title & preferences fileName."
		#Set the default preferences.
		self.archive = []
		self.activateRaft = preferences.BooleanPreference().getFromValue( 'Activate Raft:', True )
		self.archive.append( self.activateRaft )
		self.addRaftElevateNozzleOrbitSetAltitude = preferences.BooleanPreference().getFromValue( 'Add Raft, Elevate Nozzle, Orbit and Set Altitude:', True )
		self.archive.append( self.addRaftElevateNozzleOrbitSetAltitude )
		self.baseInfillDensity = preferences.FloatPreference().getFromValue( 'Base Infill Density (ratio):', 0.5 )
		self.archive.append( self.baseInfillDensity )
		self.baseLayerThicknessOverLayerThickness = preferences.FloatPreference().getFromValue( 'Base Layer Thickness over Layer Thickness:', 2.0 )
		self.archive.append( self.baseLayerThicknessOverLayerThickness )
		self.baseLayers = preferences.IntPreference().getFromValue( 'Base Layers (integer):', 1 )
		self.archive.append( self.baseLayers )
		self.baseNozzleLiftOverHalfBaseLayerThickness = preferences.FloatPreference().getFromValue( 'Base Nozzle Lift over Half Base Layer Thickness (ratio):', 0.75 )
		self.archive.append( self.baseNozzleLiftOverHalfBaseLayerThickness )
		self.bottomAltitude = preferences.FloatPreference().getFromValue( 'Bottom Altitude:', 0.0 )
		self.archive.append( self.bottomAltitude )
		self.fileNameInput = preferences.Filename().getFromFilename( interpret.getGNUTranslatorGcodeFileTypeTuples(), 'Open File to be Rafted', '' )
		self.archive.append( self.fileNameInput )
		self.infillOverhang = preferences.FloatPreference().getFromValue( 'Infill Overhang (ratio):', 0.1 )
		self.archive.append( self.infillOverhang )
		self.interfaceInfillDensity = preferences.FloatPreference().getFromValue( 'Interface Infill Density (ratio):', 0.5 )
		self.archive.append( self.interfaceInfillDensity )
		self.interfaceLayerThicknessOverLayerThickness = preferences.FloatPreference().getFromValue( 'Interface Layer Thickness over Layer Thickness:', 1.0 )
		self.archive.append( self.interfaceLayerThicknessOverLayerThickness )
		self.interfaceLayers = preferences.IntPreference().getFromValue( 'Interface Layers (integer):', 2 )
		self.archive.append( self.interfaceLayers )
		self.interfaceNozzleLiftOverHalfInterfaceLayerThickness = preferences.FloatPreference().getFromValue( 'Interface Nozzle Lift over Half Interface Layer Thickness (ratio):', 1.0 )
		self.archive.append( self.interfaceNozzleLiftOverHalfInterfaceLayerThickness )
		self.operatingNozzleLiftOverHalfLayerThickness = preferences.FloatPreference().getFromValue( 'Operating Nozzle Lift over Half Layer Thickness (ratio):', 1.0 )
		self.archive.append( self.operatingNozzleLiftOverHalfLayerThickness )
		self.raftOutsetRadiusOverExtrusionWidth = preferences.FloatPreference().getFromValue( 'Raft Outset Radius over Extrusion Width (ratio):', 15.0 )
		self.archive.append( self.raftOutsetRadiusOverExtrusionWidth )
		self.supportCrossHatch = preferences.BooleanPreference().getFromValue( 'Support Cross Hatch:', False )
		self.archive.append( self.supportCrossHatch )
		self.supportFlowrateOverOperatingFlowrate = preferences.FloatPreference().getFromValue( 'Support Flowrate over Operating Flowrate (ratio):', 1.0 )
		self.archive.append( self.supportFlowrateOverOperatingFlowrate )
		self.supportGapOverPerimeterExtrusionWidth = preferences.FloatPreference().getFromValue( 'Support Gap over Perimeter Extrusion Width (ratio):', 1.0 )
		self.archive.append( self.supportGapOverPerimeterExtrusionWidth )
		self.supportMaterialChoice = preferences.MenuButtonDisplay().getFromName( 'Support Material Choice: ' )
		self.archive.append( self.supportMaterialChoice )
		self.supportChoiceNoSupportMaterial = preferences.MenuRadio().getFromMenuButtonDisplay( self.supportMaterialChoice, 'No Support Material', True )
		self.archive.append( self.supportChoiceNoSupportMaterial )
		self.supportChoiceSupportMateriaEverywhere = preferences.MenuRadio().getFromMenuButtonDisplay( self.supportMaterialChoice, 'Support Material Everywhere', False )
		self.archive.append( self.supportChoiceSupportMateriaEverywhere )
		self.supportChoiceSupportMaterialOnExteriorOnly = preferences.MenuRadio().getFromMenuButtonDisplay( self.supportMaterialChoice, 'Support Material on Exterior Only', False )
		self.archive.append( self.supportChoiceSupportMaterialOnExteriorOnly )
		self.supportMinimumAngle = preferences.FloatPreference().getFromValue( 'Support Minimum Angle (degrees):', 60.0 )
		self.archive.append( self.supportMinimumAngle )
		self.temperatureChangeBeforeTimeRaft = preferences.FloatPreference().getFromValue( 'Temperature Change Time Before Raft (seconds):', 150.0 )
		self.archive.append( self.temperatureChangeBeforeTimeRaft )
		self.temperatureChangeTimeBeforeFirstLayerOutline = preferences.FloatPreference().getFromValue( 'Temperature Change Time Before First Layer Outline (seconds):', 150.0 )
		self.archive.append( self.temperatureChangeTimeBeforeFirstLayerOutline )
		self.temperatureChangeTimeBeforeNextThreads = preferences.FloatPreference().getFromValue( 'Temperature Change Time Before Next Threads (seconds):', 150.0 )
		self.archive.append( self.temperatureChangeTimeBeforeNextThreads )
		self.temperatureChangeTimeBeforeSupportLayers = preferences.FloatPreference().getFromValue( 'Temperature Change Time Before Support Layers (seconds):', 150.0 )
		self.archive.append( self.temperatureChangeTimeBeforeSupportLayers )
		self.temperatureChangeTimeBeforeSupportedLayers = preferences.FloatPreference().getFromValue( 'Temperature Change Time Before Supported Layers (seconds):', 150.0 )
		self.archive.append( self.temperatureChangeTimeBeforeSupportedLayers )
		self.temperatureRaft = preferences.FloatPreference().getFromValue( 'Temperature of Raft (Celcius):', 200.0 )
		self.archive.append( self.temperatureRaft )
		self.temperatureShapeFirstLayerOutline = preferences.FloatPreference().getFromValue( 'Temperature of Shape First Layer Outline (Celcius):', 220.0 )
		self.archive.append( self.temperatureShapeFirstLayerOutline )
		self.temperatureShapeFirstLayerWithin = preferences.FloatPreference().getFromValue( 'Temperature of Shape First Layer Within (Celcius):', 195.0 )
		self.archive.append( self.temperatureShapeFirstLayerWithin )
		self.temperatureShapeNextLayers = preferences.FloatPreference().getFromValue( 'Temperature of Shape Next Layers (Celcius):', 230.0 )
		self.archive.append( self.temperatureShapeNextLayers )
		self.temperatureShapeSupportLayers = preferences.FloatPreference().getFromValue( 'Temperature of Support Layers (Celcius):', 200.0 )
		self.archive.append( self.temperatureShapeSupportLayers )
		self.temperatureShapeSupportedLayers = preferences.FloatPreference().getFromValue( 'Temperature of Supported Layers (Celcius):', 230.0 )
		self.archive.append( self.temperatureShapeSupportedLayers )
		#Create the archive, title of the execute button, title of the dialog & preferences fileName.
		self.executeTitle = 'Raft'
		self.saveTitle = 'Save Preferences'
		preferences.setHelpPreferencesFileNameTitleWindowPosition( self, 'skeinforge_tools.craft_plugins.raft.html' )

	def execute( self ):
		"Raft button has been clicked."
		fileNames = polyfile.getFileOrDirectoryTypesUnmodifiedGcode( self.fileNameInput.value, interpret.getImportPluginFilenames(), self.fileNameInput.wasCancelled )
		for fileName in fileNames:
			writeOutput( fileName )



class RaftSkein:
	"A class to raft a skein of extrusions."
	def __init__( self ):
		self.addLineLayerStart = True
		self.boundaryLayers = []
		self.distanceFeedRate = gcodec.DistanceFeedRate()
		self.extrusionStart = True
		self.extrusionTop = 0.0
		self.feedrateMinute = 961.0
		self.interfaceStepsUntilEnd = []
		self.isFirstLayerWithinTemperatureAdded = False
		self.isStartupEarly = False
		self.isSurroundingLoop = True
		self.layerIndex = - 1
		self.layerStarted = False
		self.layerThickness = 0.4
		self.lineIndex = 0
		self.lines = None
		self.oldFlowrateString = None
		self.oldLocation = None
		self.operatingFlowrateString = None
		self.operatingLayerEndLine = '(<operatingLayerEnd> </operatingLayerEnd>)'
		self.operatingJump = None
		self.orbitalFeedratePerSecond = 2.01
		self.perimeterWidth = 0.6
		self.supportFlowrateString = None
		self.supportLayers = []
		self.supportSegmentTables = []
		self.travelFeedratePerMinute = None

	def addBaseLayer( self, baseExtrusionWidth, baseStep, stepBegin, stepEnd ):
		"Add a base layer."
		baseLayerThickness = self.layerThickness * self.baseLayerThicknessOverLayerThickness
		halfBaseLayerThickness = 0.5 * baseLayerThickness
		halfBaseExtrusionWidth = 0.5 * baseExtrusionWidth
		stepsUntilEnd = self.getStepsUntilEnd( stepBegin.real + halfBaseExtrusionWidth, stepEnd.real, baseStep )
		baseOverhang = self.raftPreferences.infillOverhang.value * halfBaseExtrusionWidth - halfBaseExtrusionWidth
		beginY = stepBegin.imag - baseOverhang
		endY = stepEnd.imag + baseOverhang
		segments = []
		zCenter = self.extrusionTop + halfBaseLayerThickness
		z = zCenter + halfBaseLayerThickness * self.raftPreferences.baseNozzleLiftOverHalfBaseLayerThickness.value
		for x in stepsUntilEnd:
			begin = complex( x, beginY )
			end = complex( x, endY )
			segments.append( euclidean.getSegmentFromPoints( begin, end ) )
		if len( segments ) < 1:
			print( 'This should never happen, the base layer has a size of zero.' )
			return
		self.addLayerFromSegments( baseLayerThickness, self.baseLayerThicknessOverLayerThickness, segments, z )

	def addFlowrateLineIfNecessary( self, flowrateString ):
		"Add a line of flowrate if different."
		if flowrateString == self.oldFlowrateString:
			return
		if flowrateString != None:
			self.distanceFeedRate.addLine( 'M108 S' + flowrateString ) # Set flowrate.
		self.oldFlowrateString = flowrateString

	def addInterfaceLayer( self ):
		"Add an interface layer."
		interfaceLayerThickness = self.layerThickness * self.interfaceLayerThicknessOverLayerThickness
		halfInterfaceLayerThickness = 0.5 * interfaceLayerThickness
		segments = []
		zCenter = self.extrusionTop + halfInterfaceLayerThickness
		z = zCenter + halfInterfaceLayerThickness * self.raftPreferences.interfaceNozzleLiftOverHalfInterfaceLayerThickness.value
		for y in self.interfaceStepsUntilEnd:
			begin = complex( self.interfaceBeginX, y )
			end = complex( self.interfaceEndX, y )
			segments.append( euclidean.getSegmentFromPoints( begin, end ) )
		if len( segments ) < 1:
			print( 'This should never happen, the interface layer has a size of zero.' )
			return
		self.addLayerFromSegments( interfaceLayerThickness, self.interfaceLayerThicknessOverLayerThickness, segments, z )

	def addLayerFromSegments( self, layerLayerThickness, layerThicknessRatio, segments, z ):
		"Add a layer from segments and raise the extrusion top."
		layerThicknessRatioSquared = layerThicknessRatio * layerThicknessRatio
		feedrateMinute = self.feedrateMinute / layerThicknessRatioSquared
		firstSegment = segments[ 0 ]
		nearestPoint = firstSegment[ 1 ].point
		path = [ firstSegment[ 0 ].point, nearestPoint ]
		for segment in segments[ 1 : ]:
			segmentBegin = segment[ 0 ]
			segmentEnd = segment[ 1 ]
			nextEndpoint = segmentBegin
			if abs( nearestPoint - segmentBegin.point ) > abs( nearestPoint - segmentEnd.point ):
				nextEndpoint = segmentEnd
			path.append( nextEndpoint.point )
			nextEndpoint = nextEndpoint.otherEndpoint
			nearestPoint = nextEndpoint.point
			path.append( nearestPoint )
		self.addLayerLine( z )
		if layerThicknessRatioSquared != 1.0:
			self.distanceFeedRate.addExtrusionDistanceRatio( 1.0 / layerThicknessRatioSquared )
		self.distanceFeedRate.addGcodeFromFeedRateThreadZ( feedrateMinute, path, z )
		self.extrusionTop += layerLayerThickness

	def addLayerLine( self, z ):
		"Add the layer gcode line and close the last layer gcode block."
		if self.layerStarted:
			self.distanceFeedRate.addLine( '(</layer>)' )
		self.distanceFeedRate.addLine( '(<layer> ' + self.distanceFeedRate.getRounded( z ) + ' )' ) # Indicate that a new layer is starting.
		self.layerStarted = True

	def addRaft( self ):
		"Add the raft."
		self.extrusionTop = self.raftPreferences.bottomAltitude.value
		complexRadius = complex( self.raftOutsetRadius, self.raftOutsetRadius )
		self.baseLayerThicknessOverLayerThickness = self.raftPreferences.baseLayerThicknessOverLayerThickness.value
		baseExtrusionWidth = self.perimeterWidth * self.baseLayerThicknessOverLayerThickness
		baseStep = baseExtrusionWidth / self.raftPreferences.baseInfillDensity.value
		self.interfaceLayerThicknessOverLayerThickness = self.raftPreferences.interfaceLayerThicknessOverLayerThickness.value
		interfaceExtrusionWidth = self.perimeterWidth * self.interfaceLayerThicknessOverLayerThickness
		self.interfaceStep = interfaceExtrusionWidth / self.raftPreferences.interfaceInfillDensity.value
		self.setCornersZ()
		self.cornerLowComplex = self.cornerLow.dropAxis( 2 )
		halfLayerThickness = 0.5 * self.layerThickness
		self.complexHigh = complexRadius + self.cornerHighComplex
		self.complexLow = self.cornerLowComplex - complexRadius
		extent = self.complexHigh - self.complexLow
		extentStepX = interfaceExtrusionWidth + 2.0 * self.interfaceStep * math.ceil( 0.5 * ( extent.real - self.interfaceStep ) / self.interfaceStep )
		extentStepY = baseExtrusionWidth + 2.0 * baseStep * math.ceil( 0.5 * ( extent.imag - baseStep ) / baseStep )
		center = 0.5 * ( self.complexHigh + self.complexLow )
		extentStep = complex( extentStepX, extentStepY )
		stepBegin = center - 0.5 * extentStep
		stepEnd = stepBegin + extentStep
		zBegin = self.extrusionTop + self.layerThickness
		beginLoop = euclidean.getSquareLoop( self.cornerLowComplex, self.cornerHighComplex )
		extrudeRaft = self.raftPreferences.baseLayers.value > 0 or self.raftPreferences.interfaceLayers.value > 0
		if extrudeRaft:
			self.addTemperature( self.raftPreferences.temperatureRaft.value )
		else:
			self.addTemperature( self.raftPreferences.temperatureShapeFirstLayerOutline.value )
		self.addLayerLine( zBegin )
		intercircle.addOrbits( beginLoop, self, self.raftPreferences.temperatureChangeBeforeTimeRaft.value, zBegin )
		for baseLayerIndex in xrange( self.raftPreferences.baseLayers.value ):
			self.addBaseLayer( baseExtrusionWidth, baseStep, stepBegin, stepEnd )
		self.setInterfaceVariables( interfaceExtrusionWidth, stepBegin, stepEnd )
		for interfaceLayerIndex in xrange( self.raftPreferences.interfaceLayers.value ):
			self.addInterfaceLayer()
		self.operatingJump = self.extrusionTop - self.cornerLow.z + halfLayerThickness + halfLayerThickness * self.raftPreferences.operatingNozzleLiftOverHalfLayerThickness.value
		self.setBoundaryLayers()
		if extrudeRaft and len( self.boundaryLayers ) > 0:
			boundaryZ = self.boundaryLayers[ 0 ].z
			self.addLayerLine( boundaryZ )
			self.addTemperature( self.raftPreferences.temperatureShapeFirstLayerOutline.value )
			squareLoop = euclidean.getSquareLoop( stepBegin, stepEnd )
			intercircle.addOrbits( squareLoop, self, self.raftPreferences.temperatureChangeTimeBeforeFirstLayerOutline.value, boundaryZ )
			self.addLineLayerStart = False

	def addSupportSegmentTable( self, layerIndex ):
		"Add support segments from the boundary layers."
		aboveLayer = self.boundaryLayers[ layerIndex + 1 ]
		aboveLoops = aboveLayer.loops
		if len( aboveLoops ) < 1:
			self.supportSegmentTables.append( {} )
			return
		horizontalSegmentTable = {}
		boundaryLayer = self.boundaryLayers[ layerIndex ]
		rise = aboveLayer.z - boundaryLayer.z
		outsetSupportLayer = intercircle.getInsetSeparateLoopsFromLoops( - self.minimumSupportRatio * rise, boundaryLayer.loops )
		numberOfSubSteps = 4
		subStepSize = numberOfSubSteps + self.interfaceStep / float( numberOfSubSteps )
		untilEdgeSubSteps = int( self.supportOutset / subStepSize )
		for y in self.interfaceStepsUntilEnd:
			xTotalIntersectionIndexList = []
			for subStepIndex in xrange( - untilEdgeSubSteps, untilEdgeSubSteps + 1 ):
				ySubStep = y + subStepIndex * subStepSize
				xIntersectionIndexList = []
				euclidean.addXIntersectionIndexesFromLoops( aboveLoops, - 1, xIntersectionIndexList, ySubStep )
				euclidean.addXIntersectionIndexesFromLoops( outsetSupportLayer, 0, xIntersectionIndexList, ySubStep )
				xIntersections = euclidean.getXIntersectionsFromIntersections( xIntersectionIndexList )
				for xIntersection in xIntersections:
					xTotalIntersectionIndexList.append( euclidean.XIntersectionIndex( subStepIndex + untilEdgeSubSteps, xIntersection ) )
			xTotalIntersections = getJoinOfXIntersectionIndexes( xTotalIntersectionIndexList )
			lineSegments = euclidean.getSegmentsFromXIntersections( xTotalIntersections, y )
			if len( lineSegments ) > 0:
				horizontalSegmentTable[ y ] = lineSegments
		self.supportSegmentTables.append( horizontalSegmentTable )

	def addSupportLayerTemperature( self, endpoints, z ):
		"Add support layer and temperature before the object layer."
		self.distanceFeedRate.addLines( self.supportStartLines )
		self.addTemperatureOrbits( endpoints, self.raftPreferences.temperatureShapeSupportLayers, self.raftPreferences.temperatureChangeTimeBeforeSupportLayers, z )
		aroundPixelTable = {}
		layerFillInset = 0.9 * self.perimeterWidth
		aroundWidth = 0.12 * layerFillInset
		boundaryLoops = self.boundaryLayers[ self.layerIndex ].loops
		halfSupportOutset = 0.5 * self.supportOutset
		aroundBoundaryLoops = intercircle.getAroundsFromLoops( boundaryLoops, halfSupportOutset )
		for aroundBoundaryLoop in aroundBoundaryLoops:
			euclidean.addLoopToPixelTable( aroundBoundaryLoop, aroundPixelTable, aroundWidth )
		paths = euclidean.getPathsFromEndpoints( endpoints, layerFillInset, aroundPixelTable, aroundWidth )
		self.addFlowrateLineIfNecessary( self.supportFlowrateString )
		for path in paths:
			self.distanceFeedRate.addGcodeFromFeedRateThreadZ( self.feedrateMinute, path, z )
		self.addFlowrateLineIfNecessary( self.operatingFlowrateString )
		self.addTemperatureOrbits( endpoints, self.raftPreferences.temperatureShapeSupportedLayers, self.raftPreferences.temperatureChangeTimeBeforeSupportedLayers, z )
		self.distanceFeedRate.addLines( self.supportEndLines )

	def addTemperature( self, temperature ):
		"Add a line of temperature."
		self.distanceFeedRate.addLine( 'M104 S' + euclidean.getRoundedToThreePlaces( temperature ) ) # Set temperature.

	def addTemperatureOrbits( self, endpoints, temperaturePreference, temperatureTimeChangePreference, z ):
		"Add the temperature and orbits around the support layer."
		if self.layerIndex < 0:
			return
		boundaryLoops = self.boundaryLayers[ self.layerIndex ].loops
		self.addTemperature( temperaturePreference.value )
		if len( boundaryLoops ) < 1:
			layerCornerHigh = complex( - 999999999.0, - 999999999.0 )
			layerCornerLow = complex( 999999999.0, 999999999.0 )
			for endpoint in endpoints:
				layerCornerHigh = euclidean.getMaximum( layerCornerHigh, endpoint.point )
				layerCornerLow = euclidean.getMinimum( layerCornerLow, endpoint.point )
			squareLoop = euclidean.getSquareLoop( layerCornerLow, layerCornerHigh )
			intercircle.addOrbits( squareLoop, self, temperatureTimeChangePreference.value, z )
			return
		perimeterInset = 0.4 * self.perimeterWidth
		insetBoundaryLoops = intercircle.getInsetLoopsFromLoops( perimeterInset, boundaryLoops )
		if len( insetBoundaryLoops ) < 1:
			insetBoundaryLoops = boundaryLoops
		largestLoop = euclidean.getLargestLoop( insetBoundaryLoops )
		intercircle.addOrbits( largestLoop, self, temperatureTimeChangePreference.value, z )

	def addToFillXIntersectionIndexTables( self, fillXIntersectionIndexTables, layerIndex ):
		"Add fill segments from the boundary layers."
		supportLoops = self.supportLayers[ layerIndex ]
		if len( supportLoops ) < 1:
			fillXIntersectionIndexTables.append( {} )
			return
		fillXIntersectionIndexTable = {}
		for y in self.interfaceStepsUntilEnd:
			xIntersectionIndexes = getFillXIntersectionIndexes( supportLoops, y )
			if len( xIntersectionIndexes ) > 0:
				xIntersections = getJoinOfXIntersectionIndexes( xIntersectionIndexes )
				lineSegments = euclidean.getSegmentsFromXIntersections( xIntersections, y )
				fillXIntersectionIndexTable[ y ] = lineSegments
		fillXIntersectionIndexTables.append( fillXIntersectionIndexTable )

	def extendSegments( self, loops, radius, supportSegmentTableIndex ):
		"Extend the support segments."
		supportSegmentTable = self.supportSegmentTables[ supportSegmentTableIndex ]
		supportLayerKeys = supportSegmentTable.keys()
		horizontalSegmentSegmentTable = {}
		for supportLayerKey in supportLayerKeys:
			lineSegments = supportSegmentTable[ supportLayerKey ]
			xIntersectionIndexList = []
			loopXIntersections = []
			euclidean.addXIntersectionsFromLoops( loops, loopXIntersections, supportLayerKey )
			for lineSegmentIndex in xrange( len( lineSegments ) ):
				lineSegment = lineSegments[ lineSegmentIndex ]
				extendedLineSegment = getExtendedLineSegment( radius, lineSegment, loopXIntersections )
				if extendedLineSegment != None:
					addXIntersectionsFromSegment( lineSegmentIndex, extendedLineSegment, xIntersectionIndexList )
			xIntersections = getJoinOfXIntersectionIndexes( xIntersectionIndexList )
			for xIntersectionIndex in xrange( len( xIntersections ) ):
				xIntersection = xIntersections[ xIntersectionIndex ]
				xIntersection = max( xIntersection, self.interfaceBeginX )
				xIntersection = min( xIntersection, self.interfaceEndX )
				xIntersections[ xIntersectionIndex ] = xIntersection
			if len( xIntersections ) > 0:
				extendedLineSegments = euclidean.getSegmentsFromXIntersections( xIntersections, supportLayerKey )
				supportSegmentTable[ supportLayerKey ] = extendedLineSegments
			else:
				del supportSegmentTable[ supportLayerKey ]

	def getCraftedGcode( self, gcodeText, raftPreferences ):
		"Parse gcode text and store the raft gcode."
		self.raftPreferences = raftPreferences
		self.supportEndText = preferences.getFileInGivenPreferencesDirectory( os.path.dirname( __file__ ), 'Support_End.txt' )
		self.supportEndLines = gcodec.getTextLines( self.supportEndText )
		self.supportStartText = preferences.getFileInGivenPreferencesDirectory( os.path.dirname( __file__ ), 'Support_Start.txt' )
		self.supportStartLines = gcodec.getTextLines( self.supportStartText )
		self.minimumSupportRatio = math.tan( math.radians( raftPreferences.supportMinimumAngle.value ) )
		self.raftOutsetRadius = self.raftPreferences.raftOutsetRadiusOverExtrusionWidth.value * self.perimeterWidth
		self.lines = gcodec.getTextLines( gcodeText )
		self.parseInitialization()
		if raftPreferences.addRaftElevateNozzleOrbitSetAltitude.value:
			self.addRaft()
		self.addTemperature( raftPreferences.temperatureShapeFirstLayerOutline.value )
		for line in self.lines[ self.lineIndex : ]:
			self.parseLine( line )
		return self.distanceFeedRate.output.getvalue()

	def getElevatedBoundaryLine( self, splitLine ):
		"Get elevated boundary gcode line."
		location = gcodec.getLocationFromSplitLine( None, splitLine )
		if self.operatingJump != None:
			location.z += self.operatingJump
		return self.distanceFeedRate.getBoundaryLine( location )

	def getRaftedLine( self, splitLine ):
		"Get elevated gcode line with operating feedrate."
		location = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		self.feedrateMinute = gcodec.getFeedrateMinute( self.feedrateMinute, splitLine )
		self.oldLocation = location
		z = location.z
		if self.operatingJump != None:
			z += self.operatingJump
		if not self.isFirstLayerWithinTemperatureAdded and not self.isSurroundingLoop:
			self.isFirstLayerWithinTemperatureAdded = True
			self.addTemperature( self.raftPreferences.temperatureShapeFirstLayerWithin.value )
			if self.raftPreferences.addRaftElevateNozzleOrbitSetAltitude.value:
				boundaryLoops = self.boundaryLayers[ self.layerIndex ].loops
				if len( boundaryLoops ) > 1:
					intercircle.addOperatingOrbits( boundaryLoops, euclidean.getXYComplexFromVector3( self.oldLocation ), self, self.raftPreferences.temperatureChangeTimeBeforeNextThreads.value, z )
		return self.distanceFeedRate.getLinearGcodeMovementWithFeedrate( self.feedrateMinute, location.dropAxis( 2 ), z )

	def getStepsUntilEnd( self, begin, end, stepSize ):
		"Get steps from the beginning until the end."
		step = begin
		steps = []
		while step < end:
			steps.append( step )
			step += stepSize
		return steps

	def getSupportEndpoints( self ):
		"Get the support layer segments."
		if len( self.supportSegmentTables ) <= self.layerIndex:
			return []
		supportSegmentTable = self.supportSegmentTables[ self.layerIndex ]
		endpoints = []
		segmentTableKeys = supportSegmentTable.keys()
		segmentTableKeys.sort()
		for segmentTableKey in segmentTableKeys:
			for segment in supportSegmentTable[ segmentTableKey ]:
				for endpoint in segment:
					endpoints.append( endpoint )
		if self.layerIndex % 2 == 0 or not self.raftPreferences.supportCrossHatch.value:
			return endpoints
		crossEndpoints = []
		crossHatchPointLineTable = {}
		for endpoint in endpoints:
			self.interfaceStep
			segmentBeginXStep = int( math.ceil( min( endpoint.point.real, endpoint.otherEndpoint.point.real ) / self.interfaceStep ) )
			segmentEndXStep = int( math.ceil( max( endpoint.point.real, endpoint.otherEndpoint.point.real ) / self.interfaceStep ) )
			for step in xrange( segmentBeginXStep, segmentEndXStep ):
				x = self.interfaceStep * step
				crossHatchPointLine = getCrossHatchPointLine( crossHatchPointLineTable, x )
				crossHatchPointLine[ int( round( endpoint.point.imag / self.interfaceStep ) ) ] = True
		crossHatchPointLineTableKeys = crossHatchPointLineTable.keys()
		crossHatchPointLineTableKeys.sort()
		for crossHatchPointLineTableKey in crossHatchPointLineTableKeys:
			crossHatchPointLine = crossHatchPointLineTable[ crossHatchPointLineTableKey ]
			crossHatchPointLineKeys = crossHatchPointLine.keys()
			for crossHatchPointLineKey in crossHatchPointLineKeys:
				if not crossHatchPointLine.has_key( crossHatchPointLineKey - 1 ) and not crossHatchPointLine.has_key( crossHatchPointLineKey + 1 ):
					del crossHatchPointLine[ crossHatchPointLineKey ]
			crossHatchPointLineKeys = crossHatchPointLine.keys()
			crossHatchPointLineKeys.sort()
			yIntersections = []
			for crossHatchPointLineKey in crossHatchPointLineKeys:
				if crossHatchPointLine.has_key( crossHatchPointLineKey - 1 ) != crossHatchPointLine.has_key( crossHatchPointLineKey + 1 ):
					yIntersection = self.interfaceStep * crossHatchPointLineKey
					yIntersections.append( yIntersection )
			crossEndpoints += getEndpointsFromYIntersections( crossHatchPointLineTableKey, yIntersections )
		return crossEndpoints

	def joinSegments( self, supportSegmentTableIndex ):
		"Join the support segments of this layer with those of the layer above."
		horizontalSegmentTable = self.supportSegmentTables[ supportSegmentTableIndex ]
		horizontalSegmentTableKeys = horizontalSegmentTable.keys()
		aboveHorizontalSegmentTable = self.supportSegmentTables[ supportSegmentTableIndex + 1 ]
		aboveHorizontalSegmentTableKeys = aboveHorizontalSegmentTable.keys()
		joinSegmentTables( aboveHorizontalSegmentTable, horizontalSegmentTable )

	def parseInitialization( self ):
		"Parse gcode initialization and store the parameters."
		for self.lineIndex in xrange( len( self.lines ) ):
			line = self.lines[ self.lineIndex ]
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			self.distanceFeedRate.parseSplitLine( firstWord, splitLine )
			if firstWord == 'M108':
				self.setOperatingFlowString( splitLine )
			elif firstWord == '(</extruderInitialization>)':
				self.distanceFeedRate.addLine( '(<procedureDone> raft </procedureDone>)' )
			elif firstWord == '(<layer>':
				return
			elif firstWord == '(<layerThickness>':
				self.layerThickness = float( splitLine[ 1 ] )
			elif firstWord == '(<orbitalFeedratePerSecond>':
				self.orbitalFeedratePerSecond = float( splitLine[ 1 ] )
			elif firstWord == '(<operatingFeedratePerSecond>':
				self.feedrateMinute = 60.0 * float( splitLine[ 1 ] )
			elif firstWord == '(<perimeterWidth>':
				self.perimeterWidth = float( splitLine[ 1 ] )
				self.supportOutset = self.perimeterWidth + self.perimeterWidth * self.raftPreferences.supportGapOverPerimeterExtrusionWidth.value
			elif firstWord == '(<travelFeedratePerSecond>':
				self.travelFeedratePerMinute = 60.0 * float( splitLine[ 1 ] )
			self.distanceFeedRate.addLine( line )

	def parseLine( self, line ):
		"Parse a gcode line and add it to the raft skein."
		splitLine = line.split()
		if len( splitLine ) < 1:
			return
		firstWord = splitLine[ 0 ]
		if firstWord == 'G1':
			if self.extrusionStart:
				line = self.getRaftedLine( splitLine )
		elif firstWord == 'M101':
			if self.isStartupEarly:
				self.isStartupEarly = False
				return
		elif firstWord == 'M108':
			self.setOperatingFlowString( splitLine )
		elif firstWord == '(<boundaryPoint>':
			line = self.getElevatedBoundaryLine( splitLine )
		elif firstWord == '(</extrusion>)':
			self.extrusionStart = False
			self.distanceFeedRate.addLine( self.operatingLayerEndLine )
		elif firstWord == '(<layer>':
			self.layerIndex += 1
			boundaryLayer = None
			layerHeight = self.extrusionTop + float( splitLine[ 1 ] )
			if len( self.boundaryLayers ) > 0:
				boundaryLayer = self.boundaryLayers[ self.layerIndex ]
				layerHeight = boundaryLayer.z
			if self.operatingJump != None:
				line = '(<layer> ' + self.distanceFeedRate.getRounded( layerHeight ) + ' )'
			if self.layerStarted and self.addLineLayerStart:
				self.distanceFeedRate.addLine( '(</layer>)' )
			self.layerStarted = False
			if self.layerIndex > len( self.supportSegmentTables ) + 1:
				self.distanceFeedRate.addLine( self.operatingLayerEndLine )
				self.operatingLayerEndLine = ''
			if self.addLineLayerStart:
				self.distanceFeedRate.addLine( line )
			self.addLineLayerStart = True
			line = ''
			endpoints = self.getSupportEndpoints()
			if self.layerIndex == 1:
				if len( endpoints ) < 1:
					self.addTemperature( self.raftPreferences.temperatureShapeNextLayers.value )
					if self.raftPreferences.addRaftElevateNozzleOrbitSetAltitude.value:
						boundaryLoops = boundaryLayer.loops
						if len( boundaryLoops ) > 0:
							temperatureChangeTimeBeforeNextThreads = self.raftPreferences.temperatureChangeTimeBeforeNextThreads.value
							intercircle.addOperatingOrbits( boundaryLoops, euclidean.getXYComplexFromVector3( self.oldLocation ), self, temperatureChangeTimeBeforeNextThreads, layerHeight )
			if len( endpoints ) > 0:
				self.addSupportLayerTemperature( endpoints, layerHeight )
		self.distanceFeedRate.addLine( line )

	def setBoundaryLayers( self ):
		"Set the boundary layers."
		boundaryLoop = None
		boundaryLayer = None
		for line in self.lines[ self.lineIndex : ]:
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			if firstWord == '(<boundaryPoint>':
				location = gcodec.getLocationFromSplitLine( None, splitLine )
				if boundaryLoop == None:
					boundaryLoop = []
					boundaryLayer.loops.append( boundaryLoop )
				boundaryLoop.append( location.dropAxis( 2 ) )
			elif firstWord == '(<layer>':
				z = float( splitLine[ 1 ] )
				if self.operatingJump != None:
					z += self.operatingJump
				boundaryLayer = euclidean.LoopLayer( z )
				self.boundaryLayers.append( boundaryLayer )
			elif firstWord == '(</surroundingLoop>)':
				boundaryLoop = None
		if self.raftPreferences.supportChoiceNoSupportMaterial.value:
			return
		if len( self.interfaceStepsUntilEnd ) < 1:
			return
		if len( self.boundaryLayers ) < 2:
			return
		for boundaryLayer in self.boundaryLayers:
			supportLoops = intercircle.getInsetSeparateLoopsFromLoops( - self.supportOutset, boundaryLayer.loops )
			self.supportLayers.append( supportLoops )
		for layerIndex in xrange( len( self.supportLayers ) - 1 ):
			self.addSupportSegmentTable( layerIndex )
		self.truncateSupportSegmentTables()
		for supportSegmentTableIndex in xrange( len( self.supportSegmentTables ) ):
			self.extendSegments( self.boundaryLayers[ supportSegmentTableIndex ].loops, self.supportOutset, supportSegmentTableIndex )
		fillXIntersectionIndexTables = []
		for supportSegmentTableIndex in xrange( len( self.supportSegmentTables ) ):
			self.addToFillXIntersectionIndexTables( fillXIntersectionIndexTables, supportSegmentTableIndex )
		if self.raftPreferences.supportChoiceSupportMaterialOnExteriorOnly.value:
			for supportSegmentTableIndex in xrange( 1, len( self.supportSegmentTables ) ):
				self.subtractJoinedFill( fillXIntersectionIndexTables, supportSegmentTableIndex )
		for supportSegmentTableIndex in xrange( len( self.supportSegmentTables ) - 2, - 1, - 1 ):
			self.joinSegments( supportSegmentTableIndex )
		for supportSegmentTableIndex in xrange( len( self.supportSegmentTables ) ):
			self.extendSegments( self.supportLayers[ supportSegmentTableIndex ], self.raftOutsetRadius, supportSegmentTableIndex )
		for supportSegmentTableIndex in xrange( len( self.supportSegmentTables ) ):
			subtractFill( fillXIntersectionIndexTables[ supportSegmentTableIndex ], self.supportSegmentTables[ supportSegmentTableIndex ] )

	def setCornersZ( self ):
		"Set maximum and minimum corners and z."
		layerIndex = - 1
		self.cornerHighComplex = complex( - 999999999.0, - 999999999.0 )
		self.cornerLow = Vector3( 999999999.0, 999999999.0, 999999999.0 )
		for line in self.lines[ self.lineIndex : ]:
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			if firstWord == 'G1':
				location = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
				self.cornerHighComplex = euclidean.getMaximum( self.cornerHighComplex, location.dropAxis( 2 ) )
				self.cornerLow = euclidean.getPointMinimum( self.cornerLow, location )
				self.oldLocation = location
			elif firstWord == '(<layer>':
				layerIndex += 1
				if self.raftPreferences.supportChoiceNoSupportMaterial.value:
					if layerIndex > 1:
						return

	def setInterfaceVariables( self, interfaceExtrusionWidth, stepBegin, stepEnd ):
		"Set the interface variables."
		halfInterfaceExtrusionWidth = 0.5 * interfaceExtrusionWidth
		self.interfaceStepsUntilEnd = self.getStepsUntilEnd( stepBegin.imag + halfInterfaceExtrusionWidth, stepEnd.imag, self.interfaceStep )
		self.interfaceOverhang = self.raftPreferences.infillOverhang.value * halfInterfaceExtrusionWidth - halfInterfaceExtrusionWidth
		self.interfaceBeginX = stepBegin.real - self.interfaceOverhang
		self.interfaceEndX = stepEnd.real + self.interfaceOverhang

	def setOperatingFlowString( self, splitLine ):
		"Set the operating flow string from the split line."
		self.operatingFlowrateString = splitLine[ 1 ][ 1 : ]
		self.supportFlowrateString = self.distanceFeedRate.getRounded( float( self.operatingFlowrateString ) * self.raftPreferences.supportFlowrateOverOperatingFlowrate.value )

	def subtractJoinedFill( self, fillXIntersectionIndexTables, supportSegmentTableIndex ):
		"Join the fill then subtract it from the support layer table."
		supportSegmentTable = self.supportSegmentTables[ supportSegmentTableIndex ]
		fillXIntersectionIndexTable = fillXIntersectionIndexTables[ supportSegmentTableIndex ]
		fillXIntersectionIndexTableKeys = fillXIntersectionIndexTable.keys()
		belowHorizontalSegmentTable = fillXIntersectionIndexTables[ supportSegmentTableIndex - 1 ]
		belowHorizontalSegmentTableKeys = belowHorizontalSegmentTable.keys()
		joinSegmentTables( belowHorizontalSegmentTable, fillXIntersectionIndexTable )
		subtractFill( fillXIntersectionIndexTable, supportSegmentTable )

	def truncateSupportSegmentTables( self ):
		"Truncate the support segments after the last support segment which contains elements."
		for supportSegmentTableIndex in xrange( len( self.supportSegmentTables ) - 1, - 1, - 1 ):
			if len( self.supportSegmentTables[ supportSegmentTableIndex ] ) > 0:
				self.supportSegmentTables = self.supportSegmentTables[ : supportSegmentTableIndex + 1 ]
				return
		self.supportSegmentTables = []


def main():
	"Display the raft dialog."
	if len( sys.argv ) > 1:
		writeOutput( ' '.join( sys.argv[ 1 : ] ) )
	else:
		getDisplayedPreferences().root.mainloop()

if __name__ == "__main__":
	main()
