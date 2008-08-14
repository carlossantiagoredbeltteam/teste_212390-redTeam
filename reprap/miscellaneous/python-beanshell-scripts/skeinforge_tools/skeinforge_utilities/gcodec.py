"""
Gcodec is a collection of utilities to decode and encode gcode.

To run gcodec, install python 2.x on your machine, which is avaliable from http://www.python.org/download/

Then in the folder which gcodec is in, type 'python' in a shell to run the python interpreter.  Finally type 'from gcodec import *' to import this program.

Below is an example of gcodec use.  This example is run in a terminal in the folder which contains Hollow Square.gcode and gcodec.py.

>>> from gcodec import *
>>> getFileText('Hollow Square.gcode')
'( GCode generated by April 17,2007 Skeinforge )\n( Extruder Initialization )\nM100 P210\nM103\nM105\n(<extrusionDiameter> P0.7\n(<extrusionWidth> P0.654\n(<layerThickness> P0.654\nG21\nG90\nG28\n( Extruder Movement )\n( Extruder paths for layer 0 of Hollow Square )\n(<extrusionStart>\nG1 X2.727 Y-2.505 Z0.33 F600.0\n
..
many lines of text
..

"""

from __future__ import absolute_import
#Init has to be imported first because it has code to workaround the python bug where relative imports don't work if the module is imported as a main module.
import __init__

from skeinforge_tools.skeinforge_utilities.vec3 import Vec3
import os
import sys


__author__ = "Enrique Perez (perez_enrique@yahoo.com)"
__date__ = "$Date: 2008/21/04 $"
__license__ = "GPL 3.0"


def createInitFile():
	"Create the __init__.py file."
	fileText = '__all__ = ' + str( getPythonFilenamesExceptInit() )
	writeFileText( '__init__.py', fileText )

def getDoubleAfterFirstLetter( word ):
	"""Get the double value of the word after the first letter.

	Keyword arguments:
	word -- string with value starting after the first letter"""
	return float( word[ 1 : ] )

def getDoubleForLetter( letter, splitLine ):
	"Get the double value of the word after the first occurence of the letter in the split line."
	return getDoubleAfterFirstLetter( splitLine[ indexOfStartingWithSecond( letter, splitLine ) ] )

def getDoubleFromCharacterSplitLineValue( character, splitLine, value ):
	"Get the double value of the string after the first occurence of the character in the split line."
	indexOfCharacter = indexOfStartingWithSecond( character, splitLine )
	if indexOfCharacter < 0:
		return value
	return float( splitLine[ indexOfCharacter ][ 1 : ] )

def getFeedrateMinute( feedrateMinute, splitLine ):
	"Get the feedrate per minute if the split line has a feedrate."
	indexOfF = indexOfStartingWithSecond( "F", splitLine )
	if indexOfF > 0:
		return getDoubleAfterFirstLetter( splitLine[ indexOfF ] )
	return feedrateMinute

def getFilesWithFileTypesWithoutWords( fileTypes, words = [], fileInDirectory = '' ):
	"""Get files which have a given file type, but with do not contain a word in a list.

	Keyword arguments:
	fileType -- file types required
	words -- list of words which the file must not have"""
	filesWithFileTypes = []
	for fileType in fileTypes:
		filesWithFileTypes += getFilesWithFileTypeWithoutWords( fileType, words, fileInDirectory )
	filesWithFileTypes.sort()
	return filesWithFileTypes

def getFilesWithFileTypeWithoutWords( fileType, words = [], fileInDirectory = '' ):
	"""Get files which have a given file type, but with do not contain a word in a list.

	Keyword arguments:
	fileType -- file type required
	words -- list of words which the file must not have"""
	filesWithFileType = []
	directoryName = os.getcwd()
	if fileInDirectory != '':
		directoryName = os.path.dirname( fileInDirectory )
	directory = os.listdir( directoryName )
	for filename in directory:
		joinedFilename = filename
		if fileInDirectory != '':
			joinedFilename = os.path.join( directoryName, filename )
		if isFileWithFileTypeWithoutWords( fileType, joinedFilename, words ):
			filesWithFileType.append( joinedFilename )
	filesWithFileType.sort()
	return filesWithFileType

def getFileText( filename, readMode = 'r' ):
	"Get the entire text of a file."
	try:
		file = open( filename, readMode )
		fileText = file.read()
		file.close()
		return fileText
	except IOError:
		print( 'The file ' + filename + ' does not exist, an empty string will be returned.' )
		return ''

def getGcodeFileText( filename, gcodeText ):
	"Get the gcode text from a file if it the gcode text is empty and if the file is a gcode file."
	if gcodeText != '':
		return gcodeText
	if filename[ - len( '.gcode' ) : ] == '.gcode':
		return getFileText( filename )
	return ''

#def getGNUGcode( fileInDirectory = '' ):
#	"Get GNU Triangulated Surface files and gcode files which are not modified."
#	return getGNUTriangulatedSurfaceFiles( fileInDirectory ) + getUnmodifiedGCodeFiles( fileInDirectory )

#def getGNUDirectoryOrFile( isDirectory, filename, wasCancelled ):
#	"Get the GNU Triangulated Surface files in the directory the file is in if isDirectory is true.  Otherwise, return the file in a list."
#	if str( filename ) == '()' or wasCancelled:
#		return []
#	if isDirectory:
#		return getGNUTriangulatedSurfaceFiles( filename )
#	return [ filename ]

#def getGNUTriangulatedSurfaceFiles( fileInDirectory = '' ):
#	"Get GNU Triangulated Surface files."
#	return getFilesWithFileTypeWithoutWords( 'gts', [], fileInDirectory )

def getLocationFromSplitLine( oldLocation, splitLine ):
	"Get the location from the split line."
	if oldLocation == None:
		oldLocation = Vec3()
	return Vec3(
		getDoubleFromCharacterSplitLineValue( 'X', splitLine, oldLocation.x ),
		getDoubleFromCharacterSplitLineValue( 'Y', splitLine, oldLocation.y ),
		getDoubleFromCharacterSplitLineValue( 'Z', splitLine, oldLocation.z ) )

def getModule( filename, folderName, moduleFilename ):
	"Get the module from the filename and folder name."
	absoluteDirectory = os.path.join( os.path.dirname( os.path.abspath( moduleFilename ) ), folderName )
	originalSystemPath = sys.path[ : ]
	try:
		sys.path.insert( 0, absoluteDirectory )
		folderPluginsModule = __import__( filename )
		sys.path = originalSystemPath
		return folderPluginsModule
	except Exception, why:
		sys.path = originalSystemPath
		print( why )
		print( '' )
		print( 'That error means; could not import a module with the filename ' + filename )
		print( 'folder name ' + folderName )
		print( 'and module filename ' + moduleFilename )
		print( 'giving an absolute directory name of ' + absoluteDirectory )
		print( '' )
		print( 'The plugin could not be imported.  So to run ' + filename + ' directly and at least get a more informative error message,' )
		print( 'in a shell in the ' + folderName + ' folder type ' )
		print( '> python ' + filename + '.py' )
	return None

def getPluginFilenames( folderName, moduleFilename ):
	"Get the filenames of the python plugins in the export_plugins folder."
	pluginsFolderName = os.path.join( os.path.dirname( os.path.abspath( moduleFilename ) ), folderName )
	fileInDirectory = os.path.join( pluginsFolderName, '__init__.py' )
	fullPluginFilenames = getPythonFilenamesExceptInit( fileInDirectory )
	pluginFilenames = []
	for fullPluginFilename in fullPluginFilenames:
		pluginBasename = os.path.basename( fullPluginFilename )
		pluginBasename = pluginBasename[ : pluginBasename.rfind( '.py' ) ]
		pluginFilenames.append( pluginBasename )
	return pluginFilenames

def getPythonDirectoryNames( directoryName ):
	"Get the python directories."
	pythonDirectoryNames = []
	directory = os.listdir( directoryName )
	for filename in directory:
		subdirectoryName = os.path.join( directoryName, filename )
		if os.path.isdir( subdirectoryName ):
			if os.path.isfile( os.path.join( subdirectoryName, '__init__.py' ) ):
				pythonDirectoryNames.append( subdirectoryName )
	return pythonDirectoryNames

def getPythonDirectoryNamesRecursively( directoryName = '' ):
	"Get the python directories recursively."
	recursivePythonDirectoryNames = []
	if directoryName == '':
		directoryName = os.getcwd()
	if os.path.isfile( os.path.join( directoryName, '__init__.py' ) ):
		recursivePythonDirectoryNames.append( directoryName )
		pythonDirectoryNames = getPythonDirectoryNames( directoryName )
		for pythonDirectoryName in pythonDirectoryNames:
			recursivePythonDirectoryNames += getPythonDirectoryNamesRecursively( pythonDirectoryName )
	else:
		return []
	return recursivePythonDirectoryNames

def getPythonFilenamesExceptInit( fileInDirectory = '' ):
	"Get the python filenames of the directory which the fileInDirectory is in, except for the __init__.py file."
	pythonFilenamesExceptInit = getFilesWithFileTypeWithoutWords( 'py', [ '__init__.py' ], fileInDirectory )
	pythonFilenamesExceptInit.sort()
	return pythonFilenamesExceptInit

def getPythonFilenamesExceptInitRecursively( directoryName = '' ):
	"Get the python filenames of the directory recursively, except for the __init__.py files."
	pythonDirectoryNames = getPythonDirectoryNamesRecursively( directoryName )
	pythonFilenamesExceptInitRecursively = []
	for pythonDirectoryName in pythonDirectoryNames:
		pythonFilenamesExceptInitRecursively += getPythonFilenamesExceptInit( os.path.join( pythonDirectoryName, '__init__.py' ) )
	return pythonFilenamesExceptInitRecursively

def getSummarizedFilename( filename ):
	"Get the filename basename if the file is in the current working directory, otherwise return the original full name."
	if os.getcwd() == os.path.dirname( filename ):
		return os.path.basename( filename )
	return filename

def getTextLines( text ):
	"Get the all the lines of text of a text."
	return text.replace( '\r', '\n' ).split( '\n' )

def getUnmodifiedGCodeFiles( fileInDirectory = '' ):
	"Get gcode files which are not modified."
	words = '_comb,_comment,_cool,_fill,_fillet,_hop,_oozebane,_raft,_slice,_statistic,_stretch,_tower,_transform,_wipe'.split( ',' )
	return getFilesWithFileTypeWithoutWords( 'gcode', words, fileInDirectory )

def indexOfStartingWithSecond( letter, splitLine ):
	"Get index of the first occurence of the given letter in the split line, starting with the second word.  Return - 1 if letter is not found"
	for wordIndex in range( 1, len( splitLine ) ):
		word = splitLine[ wordIndex ]
		firstLetter = word[ 0 ]
		if firstLetter == letter:
			return wordIndex
	return - 1

def isFileWithFileTypeWithoutWords( fileType, filename, words ):
	"""Determine if file has a given file type, but with does not contain a word in a list.

	Keyword arguments:
	fileType -- file type required
	filename -- name of the file
	words -- list of words which the filename must not have"""
	filename = os.path.basename( filename )
	fileTypeDot = '.' + fileType
	if filename[ - len( fileTypeDot ) : ] != fileTypeDot:
		return False
	for word in words:
		if filename.find( word ) >= 0:
			return False
	return True

def isProcedureDone( gcodeText, procedure ):
	"Determine if the procedure has been done on the gcode text."
	if gcodeText == '':
		return False
	lines = getTextLines( gcodeText )
	for line in lines:
		splitLine = line.split( ' ' )
		firstWord = ''
		if len( splitLine ) > 0:
			firstWord = splitLine[ 0 ]
		if firstWord == '(<procedureDone>':
			if splitLine[ 1 ].find( procedure ) != - 1:
				return True
		elif firstWord == '(<extrusionStart>':
			return False
	return False

def replaceWords( filenames, original, replacement ):
	"Replace in files the original with the replacement."
	print( original + ' is being replaced with ' + replacement + ' in the following files:' )
	for filename in filenames:
		fileText = getFileText( filename )
		if fileText != '':
			print( filename )
			fileText = fileText.replace( original, replacement )
			writeFileText( filename, fileText )

def writeFileMessageEnd( end, filename, fileText, message ):
	"Write to a filename with a suffix and print a message."
	suffixFilename = filename[ : filename.rfind( '.' ) ] + end
	writeFileText( suffixFilename, fileText )
	print( message + getSummarizedFilename( suffixFilename ) )

def writeFileText( filename, fileText, writeMode = 'w+' ):
	"Write a text to a file."
	try:
		file = open( filename, writeMode )
		file.write( fileText )
		file.close()
	except IOError:
		print( 'The file ' + filename + ' can not be written to.' )
