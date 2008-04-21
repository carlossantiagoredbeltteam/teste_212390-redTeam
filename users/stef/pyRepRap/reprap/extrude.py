import math
import os
import reprap	# Import the reprap module.
import serial	# Import the pySerial modules.
import time


"""
Extrude is a script to display and extrude a gcode file.

To run fillet, install python 2.x on your machine, which is avaliable from http://www.python.org/download/

Then in the folder which extrude is in, type 'python' in a shell to run the python interpreter.

Finally type 'import extrude' to import this program.

To actually control the reprap requires write access to the serial device, running as root is one way to get that access.
"""

def display( filename = '' ):
	"Parse a gcode file and display the commands.  If no filename is specified, parse all the gcode files which are not log files in this folder."
	if filename == '':
		displayFiles( getGCodeFilesWithAreNotLogFiles() )
		return
	displayFile( filename )

def displayFile( filename ):
	"Parse a gcode file and display the commands."
	print( 'File ' + filename + ' is being displayed.' )
	fileText = getFileText( filename )
	writeFileMessageSuffix( filename, displayText( fileText ), 'The gcode log file is saved as ', '_log' )

def displayFiles( filenames ):
	"Parse gcode files and display the commands."
	for filename in filenames:
		displayFile( filename )

def displayText( gcodeText ):
	"Parse a gcode text and display the commands."
	skein = displaySkein()
	skein.parseText( gcodeText )
	return skein.output

def extrude( filename = '' ):
	"""Parse a gcode file and send the commands to the extruder.  If no filename is specified, parse all the gcode files which are not log files in this folder.
	This function requires write access to the serial device, running as root is one way to get that access."""
	if filename == '':
		extrudeFiles( getGCodeFilesWithAreNotLogFiles() )
		return
	extrudeFile( filename )

def extrudeFile( filename ):
	"""Parse a gcode file and send the commands to the extruder.
	This function requires write access to the serial device, running as root is one way to get that access."""
	print( 'File ' + filename + ' is being extruded.' )
	fileText = getFileText( filename )
	writeFileMessageSuffix( filename, extrudeText( fileText ), 'The gcode log file is saved as ', '_log' )

def extrudeFiles( filenames ):
	"""Parse gcode files and send the commands to the extruder.
	This function requires write access to the serial device, running as root is one way to get that access."""
	for filename in filenames:
		extrudeFile( filename )

def extrudeText( gcodeText ):
	"""Parse a gcode text and send the commands to the extruder.
	This function requires write access to the serial device, running as root is one way to get that access."""
	skein = extrudeSkein()
	skein.parseText( gcodeText )
	return skein.output

def getAngleAroundZAxisDifference( subtractFromVector3, subtractVector3 ):
	"""Get the angle around the Z axis difference between a pair of vec3s.

	Keyword arguments:
	subtractFromVector3 -- vec3 whose angle will be subtracted from
	subtractVector3 -- vec3 whose angle will be subtracted"""
	subtractVectorMirror = complex( subtractVector3.x , - subtractVector3.y )
	differenceVector = getVectorRotatedByPlaneAngle( subtractVectorMirror, subtractFromVector3 )
	return math.atan2( differenceVector.y, differenceVector.x )

def getDoubleAfterFirstLetter( word ):
	"""Get the double value of the word after the first letter.

	Keyword arguments:
	word -- string with value starting after the first letter"""
	return float( word[ 1 : ] )

def getDoubleForLetter( letter, splitLine ):
	"Get the double value of the word after the first occurence of the letter in the split line."
	return getDoubleAfterFirstLetter( splitLine[ indexOfStartingWithSecond( letter, splitLine ) ] )

def getFilesWithExtensionWithoutWords( extension, words ):
	"""Get files which have a given extension, but with do not contain a word in a list.

	Keyword arguments:
	extension -- extension required
	words -- list of words which the file must not have"""
	filesWithExtension = []
	directory = os.listdir( os.getcwd() )
	for filename in directory:
		if isFileWithExtensionWithoutWords( extension, filename, words ) == 1:
			filesWithExtension.append( filename )
	return filesWithExtension

def getFileText( filename ):
	"""Get the entire text of a file.

	Keyword arguments:
	filename -- name of the file"""
	file = open( filename, 'r' )
	fileText = file.read()
	file.close()
	return fileText

def getGCodeFilesWithAreNotLogFiles():
	"Get gcode files which are not log files."
	return getFilesWithExtensionWithoutWords( 'gcode', [ '_log' ] )

def getIntegerString( number ):
	"Get integer as string."
	return str( int( number ) )

def getPlaneDot( vector3First, vector3Second ):
	"""Get the dot product of the x and y components of a pair of Vec3s.

	Keyword arguments:
	vector3First -- first Vec3
	vector3Second -- second Vec3"""
	return vector3First.x * vector3Second.x + vector3First.y * vector3Second.y

def getPointPlusSegmentWithLength( length, point, segment ):
	"Get point plus to a segment scaled to a given length."
	return segment.times( length / segment.length() ).plus( point )

def getPolar( angle, radius ):
	"""Get polar complex from counterclockwise angle from 1, 0 and radius.

	Keyword arguments:
	angle -- counterclockwise angle from 1, 0
	radius -- radius of complex"""
	return complex( radius * math.cos( angle ), radius * math.sin( angle ) )

def getRotatedWiddershinsQuarterAroundZAxis( vector3 ):
	"""Get Vec3 rotated a quarter widdershins turn around Z axis.

	Keyword arguments:
	vector3 -- vec3 whose rotation will be returned"""
	return vec3().getFromXYZ( - vector3.y, vector3.x, vector3.z )

def getTextLines( text ):
	"""Get the all the lines of text of a text.

	Keyword arguments:
	text -- text"""
	return text.replace( '\r', '\n' ).split( '\n' )

def getVectorRotatedByPlaneAngle( planeAngle, vector3 ):
	"""Get vec3 rotated by a plane angle.

	Keyword arguments:
	planeAngle - plane angle of the rotation
	vector3 - vec3 whose rotation will be returned"""
	return vec3().getFromXYZ( vector3.x * planeAngle.real - vector3.y * planeAngle.imag, vector3.x * planeAngle.imag + vector3.y * planeAngle.real, vector3.z )

def indexOfStartingWithSecond( letter, splitLine ):
	"Get index of the first occurence of the given letter in the split line, starting with the second word.  Return - 1 if letter is not found"
	for wordIndex in range( 1, len( splitLine ) ):
		word = splitLine[ wordIndex ]
		firstLetter = word[ 1 ]
		if firstLetter == letter:
			return wordIndex
	return - 1

def isFileWithExtensionWithoutWords( extension, filename, words ):
	"""Determine if file has a given extension, but with does not contain a word in a list.

	Keyword arguments:
	extension -- extension required
	filename -- name of the file
	words -- list of words which the filename must not have"""
	splitFile = filename.split( '.' )
	if splitFile[ - 1 ] != extension:
		return 0
	for word in words:
		if filename.find( word ) >= 0:
			return 0
	return 1

def writeFileMessageSuffix( filename, fileText, message, suffix ):
	"Write to a filename with a suffix and print a message."
	lastDotIndex = filename.rfind( '.' )
	suffixFilename = filename[ : lastDotIndex ] + suffix + filename[ lastDotIndex : ]
	writeFileText( suffixFilename, fileText )
	print( message + suffixFilename )

def writeFileText( filename, fileText ):
	"""Write a text to a file.

	Keyword arguments:
	filename -- name of the file
	fileText -- text which will be written to the file"""
	file = open( filename, 'w+' )
	file.write( fileText )
	file.close()


class displaySkein:
	"A class to display a gcode skein of extrusions."
	def __init__( self ):
		self.extruderActive = 0
		self.feedrateMinute = 200.0
		self.oldLocation = None
		self.output = ''

	def addToOutput( self, line ):
		"Add line with a newline at the end to the output."
		print( line )
		self.output += line + '\n'

	def evaluateCommand( self, command ):
		"Add an extruder command to the output."
		self.addToOutput( command )

	def helicalMove( self, isCounterclockwise, splitLine ):
		"Parse a helical move gcode line and send the commands to the extruder."
		if self.oldLocation == None:
			return
		location = vec3().getFromVec3( self.oldLocation )
		self.setFeedrate( splitLine )
		self.setPointComponent( location, splitLine )
		location = location.plus( self.oldLocation )
		center = vec3().getFromVec3( self.oldLocation )
		indexOfR = indexOfStartingWithSecond( "R", splitLine )
		if indexOfR > 0:
			radius = getDoubleAfterFirstLetter( splitLine[ indexOfR ] )
			halfLocationMinusOld = location.minus( self.oldLocation )
			halfLocationMinusOld.scale( 0.5 )
			halfLocationMinusOldLength = halfLocationMinusOld.length()
			centerMidpointDistance = math.sqrt( radius * radius - halfLocationMinusOldLength * halfLocationMinusOldLength )
			centerMinusMidpoint = getRotatedWiddershinsQuarterAroundZAxis( halfLocationMinusOld )
			centerMinusMidpoint.normalize()
			centerMinusMidpoint.scale( centerMidpointDistance )
			if isCounterclockwise:
				center.getFromVec3( halfLocationMinusOld.plus( centerMinusMidpoint ) )
			else:
				center.getFromVec3( halfLocationMinusOld.minus( centerMinusMidpoint ) )
		else:
			center.x = getDoubleForLetter( "I", splitLine )
			center.y = getDoubleForLetter( "J", splitLine )
		curveSection = 0.5
		center = center.plus( self.oldLocation )
		afterCenterSegment = location.minus( center )
		beforeCenterSegment = self.oldLocation.minus( center )
		afterCenterDifferenceAngle = getAngleAroundZAxisDifference( afterCenterSegment, beforeCenterSegment )
		absoluteDifferenceAngle = abs( afterCenterDifferenceAngle )
		steps = int( math.ceil( max( absoluteDifferenceAngle * 2.4, absoluteDifferenceAngle * beforeCenterSegment.length() / curveSection ) ) )
		stepPlaneAngle = getPolar( afterCenterDifferenceAngle / steps, 1.0 )
		zIncrement = ( afterCenterSegment.z - beforeCenterSegment.z ) / float( steps )
		for step in range( 1, steps ):
			beforeCenterSegment = getVectorRotatedByPlaneAngle( stepPlaneAngle, beforeCenterSegment )
			beforeCenterSegment.z += zIncrement
			arcPoint = center.plus( beforeCenterSegment )
			self.moveExtruder( arcPoint )
		self.moveExtruder( location )
		self.oldLocation = location

	def homeReset( self ):
		"Send all axies to home position. Wait until arrival."
		homeCommandString = 'reprap.cartesian.homeReset( ' + getIntegerString( self.feedrateMinute ) + ', True )'
		self.evaluateCommand( homeCommandString )

	def linearMove( self, splitLine ):
		"Parse a linear move gcode line and send the commands to the extruder."
		location = vec3()
		if self.oldLocation != None:
			location = self.oldLocation
		self.setFeedrate( splitLine )
		self.setPointComponent( location, splitLine )
		self.moveExtruder( location )
		self.oldLocation = location

	def moveExtruder( self, location ):
		"Seek to location. Wait until arrival."
		moveSpeedString = getIntegerString( self.feedrateMinute )
		xMoveString = getIntegerString( location.x )
		yMoveString = getIntegerString( location.y )
		zMoveString = getIntegerString( location.z )
		moveCommandString = 'reprap.cartesian.seek( ( ' + xMoveString + ', ' + yMoveString + ', ' + zMoveString + '), ' + moveSpeedString + ', True )'
		self.evaluateCommand( moveCommandString )

	def parseGCode( self, lines ):
		"Parse gcode and send the commands to the extruder."
		self.evaluateCommand( 'reprap.serial = serial.Serial(0, 19200, timeout = 60)' )	# Initialise serial port, here the first port (0) is used.
		self.evaluateCommand( 'reprap.cartesian.x.active = True' )	# These devices are present in network, will automatically scan in the future.
		self.evaluateCommand( 'reprap.cartesian.y.active = True' )
		self.evaluateCommand( 'reprap.cartesian.z.active = True' )
		self.evaluateCommand( 'reprap.extruder.active = True' )
		self.evaluateCommand( 'reprap.cartesian.x.setNotify()' )
		self.evaluateCommand( 'reprap.cartesian.y.setNotify()' )
		self.evaluateCommand( 'reprap.cartesian.z.setNotify()' )
		self.evaluateCommand( 'reprap.cartesian.x.limit = 2523' )
		self.evaluateCommand( 'reprap.cartesian.y.limit = 2000' )
		self.homeReset()	# The module is now ready to receive commands
		for line in lines:
			self.parseLine( line )
		self.homeReset()
		self.evaluateCommand( 'reprap.cartesian.free()' )	# Shut off power to all motors.

	def parseLine( self, line ):
		"Parse a gcode line and send the command to the extruder."
		self.addToOutput( line )
		splitLine = line.split( ' ' )
		if len( splitLine ) < 1:
			return 0
		firstWord = splitLine[ 0 ]
		if firstWord == 'G1':
			self.linearMove( splitLine )
		if firstWord == 'G2':
			self.helicalMove( False, splitLine )
		if firstWord == 'G3':
			self.helicalMove( True, splitLine )
		if firstWord == 'M101':
			self.extruderActive = 1
			self.evaluateCommand( 'reprap.extruder.setMotor(reprap.CMD_REVERSE, 150)' )
		if firstWord == 'M103':
			self.extruderActive = 0
			self.evaluateCommand( 'reprap.extruder.setMotor(reprap.CMD_REVERSE, 0)' )
			self.oldActiveLocation = None

	def parseText( self, text ):
		"Parse a gcode text and evaluate the commands."
		textLines = getTextLines( text )
		self.parseGCode( textLines )

	def setFeedrate( self, splitLine ):
		"Set the feedrate to the gcode split line."
		indexOfF = indexOfStartingWithSecond( "F", splitLine )
		if indexOfF > 0:
			self.feedrateMinute = getDoubleAfterFirstLetter( splitLine[ indexOfF ] )

	def setPointComponent( self, point, splitLine ):
		"Set a point to the gcode split line."
		point.x = getDoubleForLetter( "X", splitLine )
		point.y = getDoubleForLetter( "Y", splitLine )
		indexOfZ = indexOfStartingWithSecond( "Z", splitLine )
		if indexOfZ > 0:
			point.z = getDoubleAfterFirstLetter( splitLine[ indexOfZ ] )


class extrudeSkein( displaySkein ):
	"A class to extrude a gcode skein of extrusions."
	def evaluateCommand( self, command ):
		"""Add an extruder command to the output and evaluate the extruder command.
		Display the entire command, but only evaluate the command after the first equal sign."""
		self.addToOutput( command )
		firstEqualIndex = command.find( '=' )
		exec( command )

class vec3:
	"A three dimensional vector class."
	def __init__( self ):
		self.x = 0.0
		self.y = 0.0
		self.z = 0.0

	def distance( self, another ):
		"""Get the Euclidean distance between this vector and another one.

		Keyword arguments:
		another -- vec3 whose distance to the original will be calculated"""
		return math.sqrt( self.distance2( another ) )

	def distance2( self, another ):
		"""Get the square of the Euclidean distance between this vector and another one.

		Keyword arguments:
		another -- vec3 whose squared distance to the original will be calculated"""
		separationX = self.x - another.x
		separationY = self.y - another.y
		separationZ = self.z - another.z
		return separationX * separationX + separationY * separationY + separationZ * separationZ

	def dropAxis( self, which ):
		"""Get a complex by removing one axis of this one.

		Keyword arguments:
		which -- the axis to drop (0=X, 1=Y, 2=Z)"""
		if which == 0:
			return complex( self.y, self.z )
		if which == 1:
			return complex( self.x, self.z )
		if which == 2:
			return complex( self.x, self.y )

	def getFromVec3( self, another ):
		"""Get a new vec3 identical to another one."""
		return self.getFromXYZ( another.x, another.y, another.z )

	def getFromXYZ( self, x, y, z ):
		"""Get a new vec3 with the specified x, y, and z components."""
		self.x = x
		self.y = y
		self.z = z
		return self

	def length( self ):
		"""Get the length of the vec3."""
		return math.sqrt( self.length2() )

	def length2( self ):
		"""Get the square of the length of the vec3."""
		return self.x * self.x + self.y * self.y + self.z * self.z

	def minus( self, subtractVec3 ):
		"""Get the difference between the vec3 and another one.

		Keyword arguments:
		subtractVec3 -- vec3 which will be subtracted from the original"""
		return vec3().getFromXYZ( self.x - subtractVec3.x, self.y - subtractVec3.y, self.z - subtractVec3.z )

	def normalize( self ):
		"Scale each component of this vec3 so that it has a length of 1. If this vec3 has a length of 0, this method has no effect."
		length = self.length()
		if length == 0.0:
			return
		self.scale( 1.0 / length )

	def plus( self, plusVec3 ):
		"""Get the sum of this vec3 and another one.

		Keyword arguments:
		plusVec3 -- vec3 which will be added to the original"""
		return vec3().getFromXYZ( self.x + plusVec3.x, self.y + plusVec3.y, self.z + plusVec3.z )

	def scale( self, multiplier ):
		"Scale each component of this vec3 by a multiplier."
		self.x *= multiplier
		self.y *= multiplier
		self.z *= multiplier

	def times( self, multiplier ):
		"Get a new vec3 by multiplying each component of this one by a multiplier."
		return vec3().getFromXYZ( self.x * multiplier, self.y * multiplier, self.z * multiplier )

	def toString( self ):
		"Get the string representatino of this vec3."
		return 'vec3 xyz: ' + str( self.x ) + ' ' + str( self.y ) + ' ' + str( self.z )


print( 'Extrude has been imported.' )
print( 'The gcode files in this directory that are not log files are the following:' )
print( getGCodeFilesWithAreNotLogFiles() )