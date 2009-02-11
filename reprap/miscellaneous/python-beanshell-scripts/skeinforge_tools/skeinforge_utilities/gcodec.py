"""
Gcodec is a collection of utilities to decode and encode gcode.

To run gcodec, install python 2.x on your machine, which is avaliable from http://www.python.org/download/

Then in the folder which gcodec is in, type 'python' in a shell to run the python interpreter.  Finally type 'from gcodec import *' to import this program.

Below is an example of gcodec use.  This example is run in a terminal in the folder which contains Screw Holder Bottom.gcode and gcodec.py.

>>> from gcodec import *
>>> getFileText('Screw Holder Bottom.gcode')
'( GCode generated by April 17,2007 Skeinforge )\n( Extruder Initialization )\nM100 P210\nM103\nM105\n(<extrusionDiameter> P0.7\n(<extrusionWidth> P0.654\n(<layerThickness> P0.654\nG21\nG90\nG28\n( Extruder Movement )\n( Extruder paths for layer 0 of Screw Holder Bottom )\n(<extrusionStart>\nG1 X2.727 Y-2.505 Z0.33 F600.0\n
..
many lines of text
..

"""

from __future__ import absolute_import
#Init has to be imported first because it has code to workaround the python bug where relative imports don't work if the module is imported as a main module.
import __init__

from skeinforge_tools.skeinforge_utilities.vector3 import Vector3
import os
import sys


__author__ = "Enrique Perez (perez_enrique@yahoo.com)"
__date__ = "$Date: 2008/21/04 $"
__license__ = "GPL 3.0"


#getFileTextInFileDirectory might not be needed anymore
def createInitFile():
	"Create the __init__.py file."
	fileText = '__all__ = ' + str( getPythonFilenamesExceptInit() )
	writeFileText( '__init__.py', fileText )

def findWords( fileNames, search ):
	"Find in files the search."
	print( search + ' is being searched for.' )
	for fileName in fileNames:
		fileText = getFileText( fileName )
		if fileText != '':
			whereInText = fileText.find( search )
			if whereInText != - 1:
				print( fileName )
				print( whereInText )
				whereInTextFromEnd = fileText.rfind( search )
				if whereInTextFromEnd != whereInText:
					print( whereInTextFromEnd )

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
	for fileName in directory:
		joinedFilename = fileName
		if fileInDirectory != '':
			joinedFilename = os.path.join( directoryName, fileName )
		if isFileWithFileTypeWithoutWords( fileType, joinedFilename, words ):
			filesWithFileType.append( joinedFilename )
	filesWithFileType.sort()
	return filesWithFileType

def getFileText( fileName, readMode = 'r' ):
	"Get the entire text of a file."
	try:
		file = open( fileName, readMode )
		fileText = file.read()
		file.close()
		return fileText
	except IOError:
		print( 'The file ' + fileName + ' does not exist, an empty string will be returned.' )
		return ''

def getFileTextInFileDirectory( fileInDirectory, fileName, readMode = 'r' ):
	"Get the entire text of a file in the directory of the file in directory."
	absoluteFilePathInFileDirectory = os.path.join( os.path.dirname( fileInDirectory ), fileName )
	return getFileText( absoluteFilePathInFileDirectory, readMode )

def getFirstWord( splitLine ):
	"Get the first word of a split line."
	if len( splitLine ) > 0:
		return splitLine[ 0 ]
	return ''

def getGcodeFileText( fileName, gcodeText ):
	"Get the gcode text from a file if it the gcode text is empty and if the file is a gcode file."
	if gcodeText != '':
		return gcodeText
	if fileName[ - len( '.gcode' ) : ] == '.gcode':
		return getFileText( fileName )
	return ''

#def getGNUGcode( fileInDirectory = '' ):
#	"Get GNU Triangulated Surface files and gcode files which are not modified."
#	return getGNUTriangulatedSurfaceFiles( fileInDirectory ) + getUnmodifiedGCodeFiles( fileInDirectory )

#def getGNUDirectoryOrFile( isDirectory, fileName, wasCancelled ):
#	"Get the GNU Triangulated Surface files in the directory the file is in if isDirectory is true.  Otherwise, return the file in a list."
#	if str( fileName ) == '()' or wasCancelled:
#		return []
#	if isDirectory:
#		return getGNUTriangulatedSurfaceFiles( fileName )
#	return [ fileName ]

#def getGNUTriangulatedSurfaceFiles( fileInDirectory = '' ):
#	"Get GNU Triangulated Surface files."
#	return getFilesWithFileTypeWithoutWords( 'gts', [], fileInDirectory )

def getLocationFromSplitLine( oldLocation, splitLine ):
	"Get the location from the split line."
	if oldLocation == None:
		oldLocation = Vector3()
	return Vector3(
		getDoubleFromCharacterSplitLineValue( 'X', splitLine, oldLocation.x ),
		getDoubleFromCharacterSplitLineValue( 'Y', splitLine, oldLocation.y ),
		getDoubleFromCharacterSplitLineValue( 'Z', splitLine, oldLocation.z ) )

def getModule( fileName, folderName, moduleFilename ):
	"Get the module from the fileName and folder name."
	absoluteDirectory = os.path.join( os.path.dirname( os.path.abspath( moduleFilename ) ), folderName )
	originalSystemPath = sys.path[ : ]
	try:
		sys.path.insert( 0, absoluteDirectory )
		folderPluginsModule = __import__( fileName )
		sys.path = originalSystemPath
		return folderPluginsModule
	except Exception, why:
		sys.path = originalSystemPath
		print( why )
		print( '' )
		print( 'That error means; could not import a module with the fileName ' + fileName )
		print( 'folder name ' + folderName )
		print( 'and module fileName ' + moduleFilename )
		print( 'giving an absolute directory name of ' + absoluteDirectory )
		print( '' )
		print( 'The plugin could not be imported.  So to run ' + fileName + ' directly and at least get a more informative error message,' )
		print( 'in a shell in the ' + folderName + ' folder type ' )
		print( '> python ' + fileName + '.py' )
	return None

def getPluginFilenames( folderName, moduleFilename ):
	"Get the fileNames of the python plugins in the export_plugins folder."
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
	for fileName in directory:
		subdirectoryName = os.path.join( directoryName, fileName )
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
	"Get the python fileNames of the directory which the fileInDirectory is in, except for the __init__.py file."
	pythonFilenamesExceptInit = getFilesWithFileTypeWithoutWords( 'py', [ '__init__.py' ], fileInDirectory )
	pythonFilenamesExceptInit.sort()
	return pythonFilenamesExceptInit

def getPythonFilenamesExceptInitRecursively( directoryName = '' ):
	"Get the python fileNames of the directory recursively, except for the __init__.py files."
	pythonDirectoryNames = getPythonDirectoryNamesRecursively( directoryName )
	pythonFilenamesExceptInitRecursively = []
	for pythonDirectoryName in pythonDirectoryNames:
		pythonFilenamesExceptInitRecursively += getPythonFilenamesExceptInit( os.path.join( pythonDirectoryName, '__init__.py' ) )
	pythonFilenamesExceptInitRecursively.sort()
	return pythonFilenamesExceptInitRecursively

def getSummarizedFilename( fileName ):
	"Get the fileName basename if the file is in the current working directory, otherwise return the original full name."
	if os.getcwd() == os.path.dirname( fileName ):
		return os.path.basename( fileName )
	return fileName

def getTextLines( text ):
	"Get the all the lines of text of a text."
	return text.replace( '\r', '\n' ).replace( '\n\n', '\n' ).split( '\n' )

def getUnmodifiedGCodeFiles( fileInDirectory = '' ):
	"Get gcode files which are not modified."
	#transform may be needed in future but probably won't
	words = ' carve clip comb comment cool fill fillet hop inset oozebane raft stretch tower wipe'.replace( ' ', ' _' ).split()
	return getFilesWithFileTypeWithoutWords( 'gcode', words, fileInDirectory )

def getWithoutBracketsEqualTab( line ):
	"Get a string without the greater than sign, the bracket and less than sign, the equal sign or the tab."
	line = line.replace( '=', ' ' )
	line = line.replace( '(<', '' )
	line = line.replace( '>', '' )
	return line.replace( '\t', '' )

def indexOfStartingWithSecond( letter, splitLine ):
	"Get index of the first occurence of the given letter in the split line, starting with the second word.  Return - 1 if letter is not found"
	for wordIndex in xrange( 1, len( splitLine ) ):
		word = splitLine[ wordIndex ]
		firstLetter = word[ 0 ]
		if firstLetter == letter:
			return wordIndex
	return - 1

def isFileWithFileTypeWithoutWords( fileType, fileName, words ):
	"""Determine if file has a given file type, but with does not contain a word in a list.

	Keyword arguments:
	fileType -- file type required
	fileName -- name of the file
	words -- list of words which the fileName must not have"""
	fileName = os.path.basename( fileName )
	fileTypeDot = '.' + fileType
	if fileName[ - len( fileTypeDot ) : ] != fileTypeDot:
		return False
	for word in words:
		if fileName.find( word ) >= 0:
			return False
	return True

def isProcedureDone( gcodeText, procedure ):
	"Determine if the procedure has been done on the gcode text."
	if gcodeText == '':
		return False
	lines = getTextLines( gcodeText )
	for line in lines:
		splitLine = getWithoutBracketsEqualTab( line ).split()
		firstWord = getFirstWord( splitLine )
		if firstWord == 'procedureDone':
			if splitLine[ 1 ].find( procedure ) != - 1:
				return True
		elif firstWord == 'extrusionStart':
			return False
	return False

def isThereAFirstWord( firstWord, lines, startIndex ):
	"Parse gcode until the first word if there is one."
	for lineIndex in xrange( startIndex, len( lines ) ):
		line = lines[ lineIndex ]
		splitLine = line.split()
		if firstWord == getFirstWord( splitLine ):
			return True
	return False

def replaceWords( fileNames, original, replacement ):
	"Replace in files the original with the replacement."
	print( original + ' is being replaced with ' + replacement + ' in the following files:' )
	for fileName in fileNames:
		fileText = getFileText( fileName )
		if fileText != '':
			whereInText = fileText.find( original )
			if whereInText != - 1:
				print( fileName )
				print( whereInText )
				fileText = fileText.replace( original, replacement )
				writeFileText( fileName, fileText )

def writeFileMessageEnd( end, fileName, fileText, message ):
	"Write to a fileName with a suffix and print a message."
	suffixFilename = fileName[ : fileName.rfind( '.' ) ] + end
	writeFileText( suffixFilename, fileText )
	print( message + getSummarizedFilename( suffixFilename ) )

def writeFileText( fileName, fileText, writeMode = 'w+' ):
	"Write a text to a file."
	try:
		file = open( fileName, writeMode )
		file.write( fileText )
		file.close()
	except IOError:
		print( 'The file ' + fileName + ' can not be written to.' )
