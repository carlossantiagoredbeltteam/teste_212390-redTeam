#!/usr/bin/python
import pygame, time, sys, math, thread
import pydxf, reprap, serial

PLOT_SCREEN = 1
PLOT_REPRAP = 2
PLOT_SIMULATE = 3
previewColour = [255, 255, 255]

plotColour = [255, 100, 100]
moveColour = [100, 100, 255]

WIDTH = 800
HEIGHT = 600


printedLines = []
movementLines = []

showPlot = True

def plotLine( line, plotType, offset, scale, surface, moveSpeed ):
	global printedLines
	global movementLines
	offX, offY = offset
	x1 = int( ( line.startX * scale ) + offX )
	y1 = int( ( line.startY * scale ) + offY )
	x2 = int( ( line.endX * scale ) + offX )
	y2 = int( ( line.endY * scale ) + offY )
	if plotType == PLOT_SCREEN:
		pygame.draw.line(surface, previewColour, (x1, y1), (x2, y2))	
	elif plotType == PLOT_REPRAP:
		#raise tool here (if not)
		reprap.cartesian.seek( (x1, y1, 0), moveSpeed, True )
		#lower tool here
		reprap.cartesian.seek( (x2, y2, 0), moveSpeed, True )
		#raise tool here	
	printedLines.append( (x1, y1, x2, y2) )

def calcCircle(theta, radius):
	x = math.cos( math.radians(theta) ) * radius
	y = math.sin( math.radians(theta) ) * radius
	return x, y

def plotCircle( circle, resolution, plotType, offset, scale, surface, moveSpeed ):
	offX, offY = offset
	centreX = ( circle.centreX * scale ) + offX
	centreY = ( circle.centreY * scale ) + offY
	radius = circle.radius * scale
	lastX, lastY = calcCircle( 0, radius )
	angleDiv = int( radius / ( resolution * scale ) )	# the angular steps in theta between line calculations
	if angleDiv < 1:
		angleDiv = 1	# workarround for very small circles (too small to draw at resolution used
	for theta in range( 0, 360 + angleDiv, angleDiv): # make detail proportional to radius to always give good resolution
		newX, newY = calcCircle(theta, radius)
		x1, y1, x2, y2 = int( lastX + centreX ), int( lastY + centreY ), int( newX + centreX ), int( newY + centreY )
		#print "x1", x1, "y1", y1, "x2", x2, "y2", y2 
		if plotType == PLOT_SCREEN:
			pygame.draw.line( surface, previewColour, (x1, y1), (x2, y2) )
		elif plotType == PLOT_REPRAP:
			#raise tool here (if not)
			reprap.cartesian.seek( (x1, y1, 0), moveSpeed, True )
			#lower tool here
			reprap.cartesian.seek( (x2, y2, 0), moveSpeed, True )
			#raise tool here
		printedLines.append( (x1, y1, x2, y2) )
		#print "Line from [", lastX, lastY, "] to [", x, y, "]"
		lastX, lastY = newX, newY

def plotArc( arc, resolution, plotType, offset, scale, surface, moveSpeed ):
	offX, offY = offset
	centreX = ( arc.centreX * scale ) + offX
	centreY = ( arc.centreY * scale ) + offY
	radius = arc.radius * scale
	lastX, lastY = calcCircle( arc.startAngle, radius )
	angleDiv = int( radius / ( resolution * scale ) )	# the angular steps in theta between line calculations
	if arc.startAngle > arc.endAngle:
		arc.endAngle += 360	# compensate for arc going beyond 360 deg
	#print "ad", angleDiv
	for theta in range( int(arc.startAngle), int( arc.endAngle + angleDiv ), angleDiv): # make detail proportional to radius to always give good resolution
		newX, newY = calcCircle(theta, radius)
		x1, y1, x2, y2 = int( lastX + centreX ), int( lastY + centreY ), int( newX + centreX ), int( newY + centreY )
		#print "x1", x1, "y1", y1, "x2", x2, "y2", y2 
		if plotType == PLOT_SCREEN:
			pygame.draw.line( surface, previewColour, (x1, y1), (x2, y2) )
		elif plotType == PLOT_REPRAP:
			#raise tool here (if not)
			reprap.cartesian.seek( (x1, y1, 0), moveSpeed, True )
			#lower tool here
			reprap.cartesian.seek( (x2, y2, 0), moveSpeed, True )
			#raise tool here
		printedLines.append( (x1, y1, x2, y2) )
		#print "Line from [", lastX, lastY, "] to [", x, y, "]"
		lastX, lastY = newX, newY

def plot( dxfFile, plotType, scale, offset, surface ):
	for e in dxfFile.entities:
		if e.type == "LINE":
			plotLine( e, plotType, offset, scale, surface, moveSpeed )
		elif e.type == "CIRCLE":
			plotCircle( e, curveResolution, plotType, offset, scale, surface, moveSpeed )
		elif e.type == "ARC":
			plotArc( e, curveResolution, plotType, offset, scale, surface, moveSpeed )

def previewPlot( dxfFile, scale, offset, windowZoom ):
	pygame.init()
	width = int( reprap.cartesian.x.limit * windowZoom )
	height = int( reprap.cartesian.y.limit * windowZoom )
	window = pygame.display.set_mode( [width, height] )
	pygame.display.set_caption('dxfPlot')
	pygame.display.flip()
	#scale = 1	#disable scaling for now
	connected = 1
	while connected == 1:
		plotColour = [255, 255, 255]
		window.fill( [0, 0, 0] )
  		plot( dxfFile, PLOT_SCREEN, scale * windowZoom, offset, window )
		pygame.display.update()	
		time.sleep(0.01)	
	pygame.display.quit()

def screenPlot( windowZoom ):
	global printedLines
	global showPlot
	pygame.init()
	width = int( reprap.cartesian.x.limit * windowZoom )
	height = int( reprap.cartesian.y.limit * windowZoom )
	window = pygame.display.set_mode( [width, height] )
	pygame.display.set_caption('dxfPlot')
	pygame.display.flip()
	
	while showPlot:
		plotColour = [255, 255, 255]
		window.fill( [0, 0, 0] )
  		for l in printedLines:
			x1, y1, x2, y2 = l
			x1, y1, x2, y2 = x1 * windowZoom, y1 * windowZoom, x2 * windowZoom, y2 * windowZoom
			pygame.draw.line( window, previewColour, (x1, y1), (x2, y2) )
		pygame.display.update()	
		time.sleep(0.01)	
	pygame.display.quit()

def plotToRepRap( dxfFile, scale, offset, windowZoom ):
	global printedLines
	thread.start_new_thread( screenPlot, (windowZoom,) )
	reprap.cartesian.x.setNotify()						# These devices are present in network, will automatically scan in the future.
	reprap.cartesian.y.setNotify()
	reprap.cartesian.z.setNotify()	
	reprap.cartesian.homeReset( moveSpeed, True )					# Send all axies to home position. Wait until arrival.
	plot( dxfFile, PLOT_REPRAP, scale, offset, False )
	
	reprap.cartesian.homeReset( moveSpeed, True )					# Send all axies to home position. Wait until arrival.
	reprap.cartesian.free()								# Shut off power to all motors.

def simulatePlot( dxfFile, scale, offset, windowZoom ):
	global printedLines
	global showPlot
	thread.start_new_thread( screenPlot, (windowZoom,) )
	print "Simulating Plot"
	plot( dxfFile, PLOT_SIMULATE, scale, offset, False )
	safeMinX, safeMinY = 100, 100				# not a good idea to get too close to endstops
	maxX, maxY, minX, minY = 0, 0, 10000, 10000
	totalX, totalY = 0, 0
	for l in printedLines:
		x1, y1, x2, y2 = l
		#print "Line ", x1, y1, x2, y2
		maxX = max( maxX, x1, x2 )
		maxY = max( maxY, y1, y2 )
		minX = min( minX, x1, x2 )
		minY = min( minY, y1, y2 )
		totalX += abs( x2 - x1 )
		totalY += abs( y2 - y1 )
	print "    Max X", maxX, 
	if maxX <= reprap.cartesian.x.limit:
		print "	OK    ",
	else:
		print "	Outside Limit!",
	print "		Max Y", maxY,
	if maxY <= reprap.cartesian.y.limit:
		print "	OK    "
	else:
		print "	Outside Limit!"

	print "    Min X", minX, 
	if minX >= safeMinX:
		print "	OK    ",
	else:
		print "	Unsafe",
	print "		Min Y", minY,
	if minY >= safeMinY:
		print "	OK    "
	else:
		print "Unsafe"
	
	print "    Total X	", totalX, "		Total Y		", totalY

#reprap.serial = serial.Serial(0, 19200, timeout = reprap.snap.messageTimeout)	# Initialise serial port, here the first port (0) is used.
reprap.serial = serial.Serial(0, 19200, timeout = 60)
reprap.cartesian.x.active = True						# These devices are present in network, will automatically scan in the future.
reprap.cartesian.y.active = True
reprap.cartesian.z.active = True

reprap.cartesian.x.limit = 2523
#reprap.cartesian.y.limit = 2743
reprap.cartesian.y.limit = 2000	#with extra pen support



offset = 0, 0
scale = 1
#moveSpeed = 220
moveSpeed = 200
curveResolution = 3
plotType = False
windowZoom = 1
torque = 48

for n in range( len(sys.argv) ):
	param = sys.argv[n]
	if param == "-o" or param == "--offset":
		offset = int( sys.argv[n + 1] ), int( sys.argv[n + 2] )
	elif param == "-s" or param == "--scale":
		scale = float( sys.argv[n + 1] )
	elif param == "preview":
		plotType = PLOT_SCREEN
	elif param == "plot":
		plotType = PLOT_REPRAP
	elif param == "simulate":
		plotType = PLOT_SIMULATE
	elif param == "-z" or param == "--zoom":
		windowZoom = float( sys.argv[n + 1] )
	elif param == "-h" or param == "--help":
		help = True
	elif param == "-t" or param == "--torque":
		torque = int( sys.argv[n + 1] )

fileName = sys.argv[ len(sys.argv) - 1 ]

if fileName[-4:] == ".dxf" and plotType:
	newdxf = pydxf.dxf( fileName )
	newdxf.printEnts()
	if plotType == PLOT_SCREEN:
		previewPlot( newdxf, scale, offset, windowZoom )
	elif plotType == PLOT_SIMULATE:
		simulatePlot( newdxf, scale, offset, windowZoom )
	elif plotType == PLOT_REPRAP:
		reprap.cartesian.setPower( int( torque * 0.63 ) )
		plotToRepRap( newdxf, scale, offset, windowZoom )
else:
	print "\nsudo python dxfplot.py [options] command file"
	print "    Options:"
	print "        -o   --offset   xOffset yOffset		Set plot offset"
	print "        -s   --scale    scale			Set plot scale"
	print "        -z   --zoom     zoom			Set window zoom"
	print "        -t   --torque   torque			Set torque (%) 48% by default"
	print "    Commands:"
	print "        preview					Display CAD file"
	print "        simulate					Simulate plot"
	print "        plot					Plot CAD file\n"



