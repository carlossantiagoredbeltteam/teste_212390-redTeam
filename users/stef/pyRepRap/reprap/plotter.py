# merge with gerber class. or even better, specify this one in another file and use it for both gerber and dxf!!
# as most gcodes are simmilar to the functions being called in lineplotter.... gcode could be in lineplotter or dxf / gerber classes
# 'reprapPlot.py'

import reprap, math, time

#scale = 5		# just make thinks a bit bigger to look at in self.debugging
scale = 1		# normally 1, 1 unless you want to print enlarged. todo

# Plots circles, traces etc into a set of lines or to reprap
class linePlotter():
	def __init__(self):
		self.reprapEnable = False
		
	def setSpeed(self, speed):
		self.moveSpeed = speed
		
	def setStepsPerMM(self, x, y):
		self.stepsPmmX, self.stepsPmmY = x, y
		
	def setDebug(self, enabled):
		self.debug = enabled
		
	def setReprap( self, enabled ):
		self.reprapEnable = enabled
		
	def setLineDump(self, lineDump):
		self.lineDump = lineDump
		
	def setPenDownPos(self, pos):
		self.penDownPos = pos
		
	def setLineDelay(self, delay):
		self.lineDelay = delay
		
	# Plot and arc to screen or reprap with defined position, radius, start angle, end angle.
	def plotArc( self, x, y, radius, startAngle, endAngle, resolution = 1):
		# This function works in degrees but takes parameters in radians
		if self.debug: print "Plotting arc at", x, y, "from", startAngle, "(", math.degrees(startAngle), ") to", endAngle, "(", math.degrees(endAngle), ")"
		startAngle, endAngle = math.degrees(startAngle), math.degrees(endAngle)
		angleDiv = 20									# fixed until we can make it better
		lastX, lastY = calcCircle( startAngle, radius )
		if startAngle > endAngle:
			endAngle += 360								# compensate for arc going beyond 360 deg
		for theta in range( int(startAngle), int( endAngle + angleDiv ), angleDiv ):	# make detail proportional to radius to always give good resolution
			newX, newY = calcCircle( theta, radius )
			aLine = ( lastX + x ) * scale , ( lastY + y ) * scale , ( newX + x ) * scale, ( newY + y ) * scale
			if self.debug: print "aLine", aLine
			self.plotLine( aLine )
			lastX, lastY = newX, newY

	# Plot and filled circle to screen or reprap with defined position, radius.
	def plotCircle( self, x, y, radius, fillDensity ):
		if self.debug: print "PC, fill density", fillDensity
		numFills = int( float(fillDensity) * float(radius) )
		for d in range( 1, numFills + 1 ):
			r = ( float(d) / float(numFills) ) * float(radius)		# we really want a fill density to be in actual specifiable mm, not a factor.
			if self.debug: print "using r", r, "mm"
			self.plotArc( x, y, r, math.radians(0), math.radians(360) )

	# PLot a filled rectangle to screen or reprap
	def plotRectangle( self, x, y, width, height, fillDensity ):
		numFillsY = int( float(fillDensity) * float(height) )
		cornerX, cornerY = x - ( width / 2 ), y - ( height / 2 )
		invert = False
		for dy in range( 0, numFillsY + 1 ):
			ry = ( float(dy) / float(numFillsY) ) * float(height)
			line1 = (cornerX, cornerY + ry, cornerX + width, cornerY + ry )
			line2 = (cornerX, cornerY + ry, cornerX + width, cornerY - ry )
			if invert:
				line1 = reverseLine(line1)
			invert = not invert
			self.plotLine(line1)
		self.plotLine( ( cornerX, cornerY, cornerX, cornerY + height ) )
		self.plotLine( ( cornerX + width, cornerY, cornerX + width, cornerY + height ) )

	# Plot a filled photoplotter movement with circle aperture
	def plotMoveWithCircle( self, x1, y1, x2, y2, radius, fillDensity ):
		deltaY = y2 - y1
		deltaX = x2 - x1
		if self.debug: print "PMWC, fill density", fillDensity
		centreLine = ( x1 * scale, y1 * scale, x2 * scale, y2 * scale )
		#self.plotLine( reverseLine(centreLine) )			# this is to test, does it work? / imporve?
		self.plotLine( centreLine )

		numFills = int( float(fillDensity) * float(radius) )
		for d in range( 1, numFills + 1 ):
			r = ( float(d) / float(numFills) ) * float(radius)
			if self.debug: print "using r", r, "mm"
			theta = angleFromDeltas( deltaX, deltaY )
			rsintheta = r * math.sin( theta )
			rcostheta = r * math.cos( theta )
			line1 = ( ( x1 - rsintheta) * scale, ( y1 + rcostheta ) * scale, ( x2 - rsintheta ) * scale, ( y2 + rcostheta ) * scale )		# two lines of locus
			line1 = reverseLine( line1 )																									# reversing this lets locus be drawn in one continual motion
			line2 = ( ( x1 + rsintheta ) * scale, ( y1 - rcostheta ) * scale, ( x2 + rsintheta ) * scale, ( y2 - rcostheta ) * scale )		#
			if self.debug:
				print "line1", line1
				print "line2", line2
			if deltaX > 0:
				startOffset = math.radians(90)
				endOffset = math.radians(-90)
			else:
				startOffset = math.radians(-90)
				endOffset = math.radians(90)
			if deltaY < 0:
				startOffset = -startOffset
				endOffset = -endOffset

			self.plotLine( line1 )		
			self.plotArc( x1, y1, r, theta + startOffset, theta + endOffset )	# arc at start
			self.plotLine( line2 )
			self.plotArc( x2, y2, r, theta + -startOffset, theta + -endOffset )	# arc at end

	# Plot a line to screen and / or reprap
	def plotLine( self, line ):
		# everything is in mm until this point
		lineSteps = self.steps(line)
		if self.reprapEnable:
			self.reprapPlotLine( lineSteps )
		if self.lineDump:
			self.lineDump.addLine( lineSteps )
		if self.debug: print "JP", line, "mm", lineSteps, "steps"
		if self.lineDelay > 0:
			time.sleep(self.lineDelay)
		#raw_input('Press <enter> to continue')

	# Convert a line (4 value turple) in mm to a line in steps
	def steps( self, line ):
		x1, y1, x2, y2 = line
		return ( x1 * self.stepsPmmX, y1 * self.stepsPmmY, x2 * self.stepsPmmX, y2 * self.stepsPmmY )

	# Plot a line on reprap (All functions call this)
	def reprapPlotLine( self, line ):
		x1, y1, x2, y2 = line
		if self.debug:
			print "***RR PRINT LINE", x1, y1, x2, y2
		reprap.cartesian.seek( ( int(x1), int(y1), 0 ), self.moveSpeed )	# add toolhead lift / drop
		reprap.cartesian.seek( ( int(x2), int(y2), 0 ), self.moveSpeed )
		# note - put int functions into reprap module to stop this happening again!

	def reprapMoveTo( self, x, y ):
		line = self.steps( ( x, y, 0, 0 ) )
		x, y, null, null = line
		if self.debug:	
			print "***RR MOVE", x, y
		reprap.cartesian.seek( ( int(x), int(y), False ), self.moveSpeed )	# add toolhead lift / drop


	# Move pen to down position 0 is pen on paper.
	def penDown(self):
		#if self.debug: print "lower pen here", reprap.cartesian.z.getPos()
		if self.reprapEnable:
			reprap.cartesian.z.seek(self.penDownPos), reprap.cartesian.z.getPos()

	# Move pen to up position
	def penUp(self):
		#if self.debug: print "lift pen here"
		if self.reprapEnable:
			reprap.cartesian.z.seek(self.penDownPos - 30)				#make this adjustable property TODO




############# General Maths Functions #############

# Return the coordinates of a point on a circle at theta (rad) with radius.
def calcCircle(theta, radius):
	x = math.cos( math.radians(theta) ) * radius
	y = math.sin( math.radians(theta) ) * radius
	return x, y

# Reverse line (swap x1, y1 and x2, y2)
def reverseLine( line ):
	x1, y1, x2, y2 = line
	return x2, y2, x1, y1

# Return the angle between the line between two points (2D coordinates) and vetical?
def angleFromDeltas( dx, dy ):
	radius = math.sqrt( ( dx * dx ) + ( dy * dy ) )
	dx, dy = dx / radius, dy / radius
	if dx > 0:
		if dy > 0:
			return math.asin(dx)
		elif dy < 0:
			return math.acos(dx) + math.radians(90)
		else:
			#print "moo1"
			return 0
	elif dx < 0:
		if dy > 0:
			return math.asin(dy) + math.radians(270)
		elif dy < 0:
			return math.radians(180) - math.asin(dx)
		else:
			#print "moo2"
			return 0
	else:
		return math.radians(-90)	# i think this should really be 90, it just makes thae program work wen its -90 :)


