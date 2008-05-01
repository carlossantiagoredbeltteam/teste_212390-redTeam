#######################################################################################################################################################
# This plots various shapes to a RepRap machine over serial                    .                                                                      #
#######################################################################################################################################################
"""
Licenced under GNU v2 and the 'I'm not going to help you kill people licence'. The latter overrules the former.
        
I'm not going to help you kill people licence v1:
The use of this software in any form for any purposes relating to any form of military activity or
research either directly or via subcontracts is strictly prohibited.
Any company or organisation affiliated with any military organisations either directly or through
subcontracts are strictly prohibited from using any part of this software.

GNU licence:        
RepRap Gerber Plotter is free software; you can redistribute it and/or modify it 
under the terms of the GNU General Public License as published by the Free Software Foundation; 
either version 2 of the License, or (at your option) any later version.

RepRap Gerber Plotter is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
See the GNU General Public License for more details. You should have received a copy of 
the GNU General Public License along with File Hunter; if not, write to 
the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
"""

import reprap, math, time


# Plots circles, traces etc into a set of lines or to reprap
class plotter():
	def __init__(self):
		self.reprapEnable = False
		self.penIsDown = False
		self.currentX = 0
		self.currentY = 0
		self.arcResolution = float(3)	# default value
		#self.scale = 5					# just make thinks a bit bigger to look at in self.debugging
		self.scale = 1					# normally 1 unless you want to print enlarged. todo
		
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
		
	def setPenPositions(self, upPos, downPos):
		self.penUpPos = upPos
		self.penDownPos = downPos
		
	def setLineDelay(self, delay):
		self.lineDelay = delay
		
	def setCircleResolution(self, resolution):
		self.circleResolution = float(resolution)
		
	# Plot and arc to screen or reprap with defined position, radius, start angle, end angle     resolution in lines per mm on circumference.
	def plotArc( self, x, y, radius, startAngle, endAngle, liftPen = True, resolution = False ):
		# This function works in degrees but takes parameters in radians
		if not resolution:
			resolution = self.circleResolution
		if self.debug: print "Plotting arc at", x, y, "from", startAngle, "(", math.degrees(startAngle), ") to", endAngle, "(", math.degrees(endAngle), ")"
		startAngle, endAngle = math.degrees(startAngle), math.degrees(endAngle)
		circumference = float(2) * math.pi * float(radius)
		angleDiv = ( float(360) / float( circumference * resolution ) )# + ( 360 % int( circumference * resolution ) )
		#print "div", angleDiv, "r", radius, "c", circumference
		lastX, lastY = calcCircle( startAngle, radius )
		if startAngle > endAngle:
			endAngle += 360								# compensate for arc going beyond 360 deg
		if liftPen:
			self.penUp()
		#print "plotting from", startAngle, "to", endAngle + angleDiv, "with div", angleDiv
		#print frange( startAngle, endAngle + angleDiv, angleDiv )
		for theta in frange( startAngle, endAngle + angleDiv, angleDiv ):	# make detail proportional to radius to always give good resolution
			newX, newY = calcCircle( theta, radius )
			aLine = ( lastX + x ) * self.scale , ( lastY + y ) * self.scale , ( newX + x ) * self.scale, ( newY + y ) * self.scale
			if self.debug: print "aLine", aLine
			self.plotLine( aLine, liftPen = False )
			lastX, lastY = newX, newY

	# Plot and filled circle to screen or reprap with defined position, radius.
	def plotCircle( self, x, y, radius, filled = False, fillDensity = 4, liftPen = True, resolution = False ):
		if self.debug: print "PC, fill density", fillDensity
		if filled:
			numFills = int( float(fillDensity) * float(radius) )
		else:
			numFills = 1
		if liftPen:
			self.penUp()
		for d in range( 1, numFills + 1 ):
			r = ( float(d) / float(numFills) ) * float(radius)		# we really want a fill density to be in actual specifiable mm, not a factor.
			if self.debug: print "using r", r, "mm"
			self.plotArc( x, y, r, math.radians(0), math.radians(360), liftPen = False, resolution = resolution )

	# PLot a filled rectangle to screen or reprap
	def plotRectangle( self, x, y, width, height, fillDensity, liftPen = True ):
		numFillsY = int( float(fillDensity) * float(height) )
		cornerX, cornerY = x - ( width / 2 ), y - ( height / 2 )
		invert = False
		if liftPen:
			self.penUp()
		for dy in range( 0, numFillsY + 1 ):
			ry = ( float(dy) / float(numFillsY) ) * float(height)
			line1 = (cornerX, cornerY + ry, cornerX + width, cornerY + ry )
			line2 = (cornerX, cornerY + ry, cornerX + width, cornerY - ry )
			if invert:
				line1 = reverseLine(line1)
			invert = not invert
			self.plotLine(line1, liftPen = False)
		self.plotLine( ( cornerX, cornerY, cornerX, cornerY + height ), liftPen = False )
		self.plotLine( ( cornerX + width, cornerY, cornerX + width, cornerY + height ), liftPen = False )

	# Plot a filled photoplotter movement with circle aperture
	def plotMoveWithCircle( self, x1, y1, x2, y2, radius, fillDensity, liftPen = True, resolution = False ):
		deltaY = y2 - y1
		deltaX = x2 - x1
		if self.debug: print "PMWC, fill density", fillDensity
		centreLine = ( x1 * self.scale, y1 * self.scale, x2 * self.scale, y2 * self.scale )
		if ( x1 != self.currentX or y1 != self.currentY ) and liftPen:
			self.penUp()
		#self.plotLine( reverseLine(centreLine) )			# this is to test, does it work? / imporve?
		self.plotLine( centreLine )

		numFills = int( float(fillDensity) * float(radius) )
		for d in range( 1, numFills + 1 ):
			r = ( float(d) / float(numFills) ) * float(radius)
			if self.debug: print "using r", r, "mm"
			theta = angleFromDeltas( deltaX, deltaY )
			rsintheta = r * math.sin( theta )
			rcostheta = r * math.cos( theta )
			line1 = ( ( x1 - rsintheta) * self.scale, ( y1 + rcostheta ) * self.scale, ( x2 - rsintheta ) * self.scale, ( y2 + rcostheta ) * self.scale )		# two lines of locus
			line1 = reverseLine( line1 )																									# reversing this lets locus be drawn in one continual motion
			line2 = ( ( x1 + rsintheta ) * self.scale, ( y1 - rcostheta ) * self.scale, ( x2 + rsintheta ) * self.scale, ( y2 - rcostheta ) * self.scale )		#
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

			self.plotLine( line1, liftPen = False )		
			self.plotArc( x1, y1, r, theta + startOffset, theta + endOffset, liftPen = False, resolution = resolution )	# arc at start
			self.plotLine( line2, liftPen = False )
			self.plotArc( x2, y2, r, theta + -startOffset, theta + -endOffset, liftPen = False, resolution = resolution )	# arc at end


	# Plot a line to screen and / or reprap
	def plotLine( self, line, liftPen = True ):
		newX, newY, endX, endY = line
		if ( newX != self.currentX or newY != self.currentY ) and liftPen:
			self.penUp()
		# If reversing any lines must do it before now
		self.currentX, self.currentY = endX, endY
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
		#print "id", self.penIsDown
		if not self.penIsDown:
			self.penDown()
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
		#print "PD"
		#if self.debug: print "lower pen here", reprap.cartesian.z.getPos()
		if self.reprapEnable:
			reprap.cartesian.z.seek(self.penDownPos), reprap.cartesian.z.getPos()
			self.penIsDown = True
			"set pid", self.penIsDown

	# Move pen to up position
	def penUp(self):
		#print "PU"
		#if self.debug: print "lift pen here"
		if self.reprapEnable:
			reprap.cartesian.z.seek(self.penUpPos)				#make this adjustable property TODO
			self.penIsDown = False
			"set pid", self.penIsDown




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

#Range function accepting floats (by Dinu Gherman)
def frange(start, end=None, inc=None):
	if end == None:
		end = start + 0.0
		start = 0.0
	if inc == None:
		inc = 1.0
	L = []
	while 1:
		next = start + len(L) * inc
		if inc > 0 and next >= end:
			break
		elif inc < 0 and next <= end:
			break
		L.append(next)
	return L
