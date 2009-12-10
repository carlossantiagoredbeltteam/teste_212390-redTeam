"""
This page is in the table of contents.
Some filaments warp too much and to prevent this you have to print the object in a temperature regulated chamber or on a temperature regulated bed. The chamber tool allows you to control the bed and chamber temperature.

The chamber manual page is at:
http://www.bitsfrombytes.com/wiki/index.php?title=Skeinforge_Chamber

The default 'Activate Chamber' checkbox is on.  When it is on, the functions described below will work, when it is off, the functions will not be called.

The 'Bed Temperature' preference sets the temperature of the bed by sending an M110 command, the default is 60.0.  The 'Chamber Temperature' preference sets the temperature of the chamber by sending an M111 command, the default is 30.0.

Kulitorum has made a heated bed.  It is a 5mm Alu sheet with a pattern laid out in kapton tape.  The wire is a 0.6mm2 Konstantin wire and it's held in place by small pieces of kapton tape.  The description and picture is at:
http://gallery.kulitorum.com/main.php?g2_itemId=283

Other heated bed descriptions follow below.

A heated base by the Metalab folks:
http://reprap.soup.io

with information at:
http://reprap.soup.io/?search=heated%20base

A heated build stage by jmil, over at:
http://www.hive76.org

with articles at:
http://www.hive76.org/handling-hot-build-surfaces
http://www.hive76.org/heated-build-stage-success

A resistor heated aluminum plate by Pumpernickel2:
http://dev.forums.reprap.org/profile.php?14,844

with a picture at:
http://dev.forums.reprap.org/file.php?14,file=1228,filename=heatedplate.jpg

A resistor heated aluminum plate by Zaggo at Pleasant Software:
http://pleasantsoftware.com/developer/3d/

with articles at:
http://pleasantsoftware.com/developer/3d/2009/12/05/raftless/
http://pleasantsoftware.com/developer/3d/2009/11/12/canned-heat/

A resistive wire heated plexiglass plate by prusajr:
http://prusadjs.cz/

with an article at:
http://prusadjs.cz/2009/11/look-ma-no-warping-heated-reprap-print-bed/

jmil; http://www.hive76.org/heated-build-stage-success http://www.hive76.org/handling-hot-build-surfaces


The following examples chamber the file Screw Holder Bottom.stl.  The examples are run in a terminal in the folder which contains Screw Holder Bottom.stl and chamber.py.


> python chamber.py
This brings up the chamber dialog.


> python chamber.py Screw Holder Bottom.stl
The chamber tool is parsing the file:
Screw Holder Bottom.stl
..
The chamber tool has created the file:
Screw Holder Bottom_chamber.gcode


> python
Python 2.5.1 (r251:54863, Sep 22 2007, 01:43:31)
[GCC 4.2.1 (SUSE Linux)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import chamber
>>> chamber.main()
This brings up the chamber dialog.


>>> chamber.writeOutput( 'Screw Holder Bottom.stl' )
Screw Holder Bottom.stl
The chamber tool is parsing the file:
Screw Holder Bottom.stl
..
The chamber tool has created the file:
Screw Holder Bottom_chamber.gcode

"""


from __future__ import absolute_import
#Init has to be imported first because it has code to workaround the python bug where relative imports don't work if the module is imported as a main module.
import __init__

from skeinforge_tools.meta_plugins import polyfile
from skeinforge_tools.skeinforge_utilities import consecution
from skeinforge_tools.skeinforge_utilities import euclidean
from skeinforge_tools.skeinforge_utilities import gcodec
from skeinforge_tools.skeinforge_utilities import interpret
from skeinforge_tools.skeinforge_utilities import preferences
import sys


__author__ = "Enrique Perez (perez_enrique@yahoo.com)"
__date__ = "$Date: 2008/21/04 $"
__license__ = "GPL 3.0"


def getCraftedText( fileName, text = '', chamberRepository = None ):
	"Chamber the file or text."
	return getCraftedTextFromText( gcodec.getTextIfEmpty( fileName, text ), chamberRepository )

def getCraftedTextFromText( gcodeText, chamberRepository = None ):
	"Chamber a gcode linear move text."
	if gcodec.isProcedureDoneOrFileIsEmpty( gcodeText, 'chamber' ):
		return gcodeText
	if chamberRepository == None:
		chamberRepository = preferences.getReadRepository( ChamberRepository() )
	if not chamberRepository.activateChamber.value:
		return gcodeText
	return ChamberSkein().getCraftedGcode( gcodeText, chamberRepository )

def getNewRepository():
	"Get the repository constructor."
	return ChamberRepository()

def writeOutput( fileName = '' ):
	"Chamber a gcode linear move file."
	fileName = interpret.getFirstTranslatorFileNameUnmodified( fileName )
	if fileName == '':
		return
	consecution.writeChainTextWithNounMessage( fileName, 'chamber' )


class ChamberRepository:
	"A class to handle the chamber preferences."
	def __init__( self ):
		"Set the default preferences, execute title & preferences fileName."
		preferences.addListsToCraftTypeRepository( 'skeinforge_tools.craft_plugins.chamber.html', self )
		self.fileNameInput = preferences.FileNameInput().getFromFileName( interpret.getGNUTranslatorGcodeFileTypeTuples(), 'Open File for Chamber', self, '' )
		self.openWikiManualHelpPage = preferences.HelpPage().getOpenFromAbsolute( 'http://www.bitsfrombytes.com/wiki/index.php?title=Skeinforge_Chamber' )
		self.activateChamber = preferences.BooleanPreference().getFromValue( 'Activate Chamber:', self, True )
		self.bedTemperature = preferences.FloatSpin().getFromValue( 20.0, 'Bed Temperature (Celcius):', self, 90.0, 60.0 )
		self.chamberTemperature = preferences.FloatSpin().getFromValue( 20.0, 'Chamber Temperature (Celcius):', self, 90.0, 30.0 )
		self.executeTitle = 'Chamber'

	def execute( self ):
		"Chamber button has been clicked."
		fileNames = polyfile.getFileOrDirectoryTypesUnmodifiedGcode( self.fileNameInput.value, interpret.getImportPluginFileNames(), self.fileNameInput.wasCancelled )
		for fileName in fileNames:
			writeOutput( fileName )



class ChamberSkein:
	"A class to chamber a skein of extrusions."
	def __init__( self ):
		self.distanceFeedRate = gcodec.DistanceFeedRate()
		self.lineIndex = 0
		self.lines = None

	def addParameter( self, firstWord, parameter ):
		"Add the parameter if it is at least minus three hundred."
		self.distanceFeedRate.addLine( firstWord + ' S' + euclidean.getRoundedToThreePlaces( parameter ) ) # Set bed temperature.

	def getCraftedGcode( self, gcodeText, chamberRepository ):
		"Parse gcode text and store the chamber gcode."
		self.chamberRepository = chamberRepository
		self.lines = gcodec.getTextLines( gcodeText )
		self.parseInitialization()
		for line in self.lines[ self.lineIndex : ]:
			self.parseLine( line )
		return self.distanceFeedRate.output.getvalue()

	def parseInitialization( self ):
		"Parse gcode initialization and store the parameters."
		for self.lineIndex in xrange( len( self.lines ) ):
			line = self.lines[ self.lineIndex ]
			splitLine = gcodec.getSplitLineBeforeBracketSemicolon( line )
			firstWord = gcodec.getFirstWord( splitLine )
			self.distanceFeedRate.parseSplitLine( firstWord, splitLine )
			if firstWord == '(</extruderInitialization>)':
				self.distanceFeedRate.addLine( '(<procedureDone> chamber </procedureDone>)' )
				return
			self.distanceFeedRate.addLine( line )

	def parseLine( self, line ):
		"Parse a gcode line and add it to the chamber skein."
		splitLine = gcodec.getSplitLineBeforeBracketSemicolon( line )
		if len( splitLine ) < 1:
			return
		firstWord = splitLine[ 0 ]
		if firstWord == '(<extrusion>)':
			self.distanceFeedRate.addLine( line )
			self.addParameter( 'M110', self.chamberRepository.bedTemperature.value ) # Set bed temperature.
			self.addParameter( 'M111', self.chamberRepository.chamberTemperature.value ) # Set chamber temperature.
			return
		self.distanceFeedRate.addLine( line )


def main():
	"Display the chamber dialog."
	if len( sys.argv ) > 1:
		writeOutput( ' '.join( sys.argv[ 1 : ] ) )
	else:
		preferences.startMainLoopFromConstructor( getNewRepository() )

if __name__ == "__main__":
	main()
