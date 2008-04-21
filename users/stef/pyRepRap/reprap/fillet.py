import math
import os


"""
Fillet is a script to fillet or bevel the corners on a gcode file.

To run fillet, install python 2.x on your machine, which is avaliable from http://www.python.org/download/

Then in the folder which expedium is in, type 'python' in a shell to run the python interpreter.

Finally type 'import fillet' to import this program.
"""

def arcPoint( filename = '' ):
	"Fillet a gcode linear move file into a helical point move file.  If no filename is specified, fillet all the unmodified gcode files in this folder."
	if filename == '':
		arcPointFiles( getUnmodifiedGCodeFiles() )
		return
	arcPointFile( filename )

def arcPointFile( filename ):
	"Fillet a gcode linear move file into a helical point move file."
	print( 'File ' + filename + ' is being filleted into arc points.' )
	fileText = getFileText( filename )
	writeFileMessageSuffix( filename, arcPointText( fileText ), 'The arc point file is saved as ', '_arc_point' )

def arcPointFiles( filenames ):
	"Fillet gcode linear move files into helical point move files."
	for filename in filenames:
		arcPointFile( filename )

def arcPointText( gcodeText ):
	"Fillet a gcode linear move text into a helical point move gcode text."
	skein = arcPointSkein()
	skein.parseText( gcodeText )
	return skein.output

def arcRadius( filename = '' ):
	"Fillet a gcode linear move file into a helical radius move file.  If no filename is specified, fillet all the unmodified gcode files in this folder."
	if filename == '':
		arcRadiusFiles( getUnmodifiedGCodeFiles() )
		return
	arcRadiusFile( filename )

def arcRadiusFile( filename ):
	"Fillet a gcode linear move file into a helical radius move file."
	print( 'File ' + filename + ' is being filleted into arc radiuses.' )
	fileText = getFileText( filename )
	writeFileMessageSuffix( filename, arcRadiusText( fileText ), 'The arc radius file is saved as ', '_arc_radius' )

def arcRadiusFiles( filenames ):
	"Fillet gcode linear move files into helical radius move files."
	for filename in filenames:
		arcRadiusFile( filename )

def arcRadiusText( gcodeText ):
	"Fillet a gcode linear move text into a helical radius move gcode text."
	skein = arcRadiusSkein()
	skein.parseText( gcodeText )
	return skein.output

def arcSegment( filename = '' ):
	"Fillet a gcode linear move file into an arc segment linear move file.  If no filename is specified, fillet all the unmodified gcode files in this folder."
	if filename == '':
		arcSegmentFiles( getUnmodifiedGCodeFiles() )
		return
	arcSegmentFile( filename )

def arcSegmentFile( filename ):
	"Fillet a gcode linear move file into an arc segment linear move file."
	print( 'File ' + filename + ' is being arc segmented.' )
	fileText = getFileText( filename )
	writeFileMessageSuffix( filename, arcSegmentText( fileText ), 'The arc segment file is saved as ', '_arc_segment' )

def arcSegmentFiles( filenames ):
	"Fillet gcode linear move files into arc segment linear move files."
	for filename in filenames:
		arcSegmentFile( filename )

def arcSegmentText( gcodeText ):
	"Fillet a gcode linear move text into an arc segment linear move gcode text."
	skein = arcSegmentSkein()
	skein.parseText( gcodeText )
	return skein.output

def bevel( filename = '' ):
	"Bevel a gcode linear move file.  If no filename is specified, bevel all the unmodified gcode files in this folder."
	if filename == '':
		bevelFiles( getUnmodifiedGCodeFiles() )
		return
	bevelFile( filename )

def bevelFile( filename ):
	"Bevel a gcode linear move file."
	print( 'File ' + filename + ' is being beveled.' )
	fileText = getFileText( filename )
	writeFileMessageSuffix( filename, bevelText( fileText ), 'The beveled file is saved as ', '_bevel' )

def bevelFiles( filenames ):
	"Bevel gcode linear move files."
	for filename in filenames:
		bevelFile( filename )

def bevelText( gcodeText ):
	"Bevel a gcode linear move text."
	skein = bevelSkein()
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

def getRoundedToThreePlaces( number ):
	"""Get value rounded to three places as string.

	Keyword arguments:
	value -- value which will be rounded"""
	return str( 0.001 * math.floor( number * 1000.0 + 0.5 ) )

def getTextLines( text ):
	"""Get the all the lines of text of a text.

	Keyword arguments:
	text -- text"""
	return text.replace( '\r', '\n' ).split( '\n' )

def getUnmodifiedGCodeFiles():
	"Get gcode files which are not generated by this script or extrude."
	return getFilesWithExtensionWithoutWords( 'gcode', [ '_arc_point', '_arc_radius', '_arc_segment', '_bevel', '_log' ] )

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


class bevelSkein:
	"A class to bevel a skein of extrusions."
	def __init__( self ):
		self.extruderActive = 0
		self.feedrateMinute = 0.0
		self.halfExtrusionWidth = 0.0
		self.lineIndex = 0
		self.lines = None
		self.oldActiveLocation = None
		self.oldLocation = None
		self.output = ''
		self.shouldAddLine = 1

	def addFeedrateEnd( self ):
		"Add the gcode feedrate and a newline to the output."
		self.output += ' F' + getRoundedToThreePlaces( self.feedrateMinute ) + '\n'

	def addLinearMovePoint( self, point ):
		"Add a gcode linear move, feedrate and newline to the output."
		self.output += 'G1'
		self.addPoint( point )
		self.addFeedrateEnd()

	def addPoint( self, point ):
		"Add a gcode point to the output."
		self.output += ' X' + getRoundedToThreePlaces( point.x ) + ' Y' + getRoundedToThreePlaces( point.y ) + ' Z' + getRoundedToThreePlaces( point.z )

	def getNextActive( self, location ):
		"Get the next linear move where the extruder is still active.  Return none is none is found."
		for afterIndex in range( self.lineIndex + 1, len( self.lines ) ):
			line = self.lines[ afterIndex ]
			splitLine = line.split( ' ' )
			firstWord = "";
			if len( splitLine ) > 0:
				firstWord = splitLine[ 0 ]
			if firstWord == 'G1':
				nextActive = vec3().getFromVec3( location )
				self.setPointComponent( nextActive, splitLine )
				return nextActive
			if firstWord == 'M103':
				return None
		return None

	def linearMove( self, splitLine ):
		"Bevel a linear move."
		location = vec3()
		if self.oldLocation != None:
			location = self.oldLocation
		indexOfF = indexOfStartingWithSecond( "F", splitLine )
		if indexOfF > 0:
			self.feedrateMinute = getDoubleAfterFirstLetter( splitLine[ indexOfF ] )
		self.setPointComponent( location, splitLine )
		if not self.extruderActive:
			return
		if self.oldActiveLocation != None:
			nextActive = self.getNextActive( location )
			if nextActive != None:
				self.shouldAddLine = 0
				location = self.splitPointGetAfter( location, nextActive, self.oldActiveLocation )
		self.oldActiveLocation = location

	def parseGCode( self, lines ):
		"Parse gcode and store the bevel gcode."
		self.lines = lines
		for self.lineIndex in range( len( lines ) ):
			line = lines[ self.lineIndex ]
			self.parseLine( line )
		print( self.output )

	def parseLine( self, line ):
		"Parse a gcode line and add it to the bevel gcode."
		self.shouldAddLine = 1
		splitLine = line.split( ' ' )
		if len( splitLine ) < 1:
			return 0
		firstWord = splitLine[ 0 ]
		if firstWord == 'G1':
			self.linearMove( splitLine )
		if firstWord == 'M101':
			self.extruderActive = 1
		if firstWord == 'M103':
			self.extruderActive = 0
			self.oldActiveLocation = None
		if firstWord == 'M108':
			self.halfExtrusionWidth = 0.25 * math.sqrt( math.pi ) * getDoubleAfterFirstLetter( splitLine[ 1 ] )
		if firstWord == 'M109':
			self.halfExtrusionWidth = 0.5 * getDoubleAfterFirstLetter( splitLine[ 1 ] )
		if self.shouldAddLine:
			self.output += line + '\n'

	def parseText( self, text ):
		"Parse gcode text and store the bevel gcode."
		textLines = getTextLines( text )
		self.parseGCode( textLines )

	def setPointComponent( self, point, splitLine ):
		"Set a point to the gcode split line."
		point.x = getDoubleForLetter( "X", splitLine )
		point.y = getDoubleForLetter( "Y", splitLine )
		indexOfZ = indexOfStartingWithSecond( "Z", splitLine )
		if indexOfZ > 0:
			point.z = getDoubleAfterFirstLetter( splitLine[ indexOfZ ] )

	def splitPointGetAfter( self, location, nextActive, oldActiveLocation ):
		"Bevel a point and return the end of the bevel."
		bevelLength = 0.5 * self.halfExtrusionWidth
		beforeSegment = oldActiveLocation.minus( location )
		beforeSegmentLength = beforeSegment.length()
		if beforeSegmentLength == 0.0:
			self.shouldAddLine = 1
			return location
		afterSegment = nextActive.minus( location )
		afterSegmentExtension = 0.5 * afterSegment.length()
		if afterSegmentExtension == 0.0:
			self.shouldAddLine = 1
			return location
		bevelLength = min( afterSegmentExtension, bevelLength )
		if beforeSegmentLength < bevelLength:
			bevelLength = beforeSegmentLength
		else:
			beforePoint = getPointPlusSegmentWithLength( bevelLength, location, beforeSegment )
			self.addLinearMovePoint( beforePoint )
		afterPoint = getPointPlusSegmentWithLength( bevelLength, location, afterSegment )
		self.addLinearMovePoint( afterPoint )
		return afterPoint


class arcSegmentSkein( bevelSkein ):
	"A class to arc segment a skein of extrusions."
	def addArc( self, afterCenterDifferenceAngle, afterPoint, beforeCenterSegment, beforePoint, center ):
		"Add arc segments to the filleted skein."
		curveSection = 0.5
		absoluteDifferenceAngle = math.fabs( afterCenterDifferenceAngle )
		steps = int( math.ceil( max( absoluteDifferenceAngle * 2.4, absoluteDifferenceAngle * beforeCenterSegment.length() / curveSection ) ) )
		stepPlaneAngle = getPolar( afterCenterDifferenceAngle / steps, 1.0 )
		for step in range( 1, steps ):
			beforeCenterSegment = getVectorRotatedByPlaneAngle( stepPlaneAngle, beforeCenterSegment )
			arcPoint = center.plus( beforeCenterSegment )
			self.addLinearMovePoint( arcPoint )
		self.addLinearMovePoint( afterPoint )

	def splitPointGetAfter( self, location, nextActive, oldActiveLocation ):
		"Fillet a point into arc segments and return the end of the last segment."
		afterSegment = nextActive.minus( location )
		afterSegmentLength = afterSegment.length()
		afterSegmentExtension = 0.5 * afterSegmentLength
		if afterSegmentExtension == 0.0:
			self.shouldAddLine = 1
			return location
		beforeSegment = oldActiveLocation.minus( location )
		beforeSegmentLength = beforeSegment.length()
		if beforeSegmentLength == 0.0:
			self.shouldAddLine = 1
			return location
		radius = self.halfExtrusionWidth
		afterSegmentNormalized = afterSegment.times( 1.0 / afterSegmentLength )
		beforeSegmentNormalized = beforeSegment.times( 1.0 / beforeSegmentLength )
		betweenCenterDotNormalized = afterSegmentNormalized.plus( beforeSegmentNormalized )
		betweenCenterDotNormalized.normalize()
		beforeSegmentNormalizedWiddershins = getRotatedWiddershinsQuarterAroundZAxis( beforeSegmentNormalized )
		betweenAfterPlaneDot = math.fabs( getPlaneDot( betweenCenterDotNormalized, beforeSegmentNormalizedWiddershins ) )
		centerDotDistance = radius / betweenAfterPlaneDot
		bevelLength = math.sqrt( centerDotDistance * centerDotDistance - radius * radius )
		radiusOverBevelLength = radius / bevelLength
		bevelLength = min( bevelLength, radius )
		bevelLength = min( afterSegmentExtension, bevelLength )
		beforePoint = oldActiveLocation
		if beforeSegmentLength < bevelLength:
			bevelLength = beforeSegmentLength
		else:
			beforePoint = getPointPlusSegmentWithLength( bevelLength, location, beforeSegment )
			self.addLinearMovePoint( beforePoint )
		afterPoint = getPointPlusSegmentWithLength( bevelLength, location, afterSegment )
		radius = bevelLength * radiusOverBevelLength
		centerDotDistance = radius / betweenAfterPlaneDot
		center = location.plus( betweenCenterDotNormalized.times( centerDotDistance ) )
		afterCenterSegment = afterPoint.minus( center )
		beforeCenterSegment = beforePoint.minus( center )
		afterCenterDifferenceAngle = getAngleAroundZAxisDifference( afterCenterSegment, beforeCenterSegment )
		self.addArc( afterCenterDifferenceAngle, afterPoint, beforeCenterSegment, beforePoint, center )
		return afterPoint


class arcPointSkein( arcSegmentSkein ):
	"A class to arc point a skein of extrusions."
	def addArc( self, afterCenterDifferenceAngle, afterPoint, beforeCenterSegment, beforePoint, center ):
		"Add an arc point to the filleted skein."
		afterPointMinusBefore = afterPoint.minus( beforePoint )
		centerMinusBefore = center.minus( beforePoint )
		if afterCenterDifferenceAngle > 0.0:
			self.output += 'G3'
		else:
			self.output += 'G2'
		self.addPoint( afterPointMinusBefore )
		self.addRelativeCenter( centerMinusBefore )
		self.addFeedrateEnd()

	def addRelativeCenter( self, centerMinusBefore ):
		"Add the relative center to a line of the arc point filleted skein."
		self.output += ' I' + getRoundedToThreePlaces( centerMinusBefore.x ) + ' J' + getRoundedToThreePlaces( centerMinusBefore.y )


class arcRadiusSkein( arcPointSkein ):
	"A class to arc radius a skein of extrusions."
	def addRelativeCenter( self, centerMinusBefore ):
		"Add the relative center to a line of the arc radius filleted skein."
		planeCenterMinusBefore = centerMinusBefore.dropAxis( 2 )
		radius = abs( planeCenterMinusBefore )
		self.output += ' R' + getRoundedToThreePlaces( radius )


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

print( 'Fillet has been imported.' )
print( 'The gcode files in this directory that are not already beveled or filleted are the following:' )
print( getUnmodifiedGCodeFiles() )