#!/usr/bin/python
import pygame, time, sys
import pydxf, reprap, serial

def screenPlotLine( window, colour, offset, line ):
	offX, offY = offset
	x1 = int(line.startX + offX)
	y1 = int(line.startY + offY)
	x2 = int(line.endX + offX)
	y2 = int(line.endY + offY)
	pygame.draw.line(window, colour, (x1, y1), (x2, y2))	

def screenPlotCircle( window, colour, offset, circle ):
	offX, offY = offset
	x = int(circle.centreX + offX)
	y = int(circle.centreY + offY)
	radius = int(circle.radius)
	pygame.draw.circle(window, colour, (x, y), radius, 1) # width = 1

def plotToScreen(dxfFile):
	WIDTH = 800
	HEIGHT = 600
	offset = (0, 0)

	pygame.init()
	window = pygame.display.set_mode( [WIDTH, HEIGHT] )
	pygame.display.set_caption('dxfPlot')
	pygame.display.flip()

	connected = 1
	while connected == 1:
		#for ev in pygame.event.get():
		#	if ev.type == QUIT:
		#		connected = 0
		#	time.sleep(0.01)
		plotColour = [255, 255, 255]
		window.fill( [0, 0, 0] )
		#pygame.draw.line(window, [255, 255, 255], (0, 100), (500, 399))
		#pygame.draw.rect(window, [100, 50, 255], pygame.Rect(0, 0, 5, 5))    
		for e in dxfFile.entities:
			if e.type == "LINE":
				screenPlotLine( window, plotColour, offset, e )
			elif e.type == "CIRCLE":
				screenPlotCircle( window, plotColour, offset, e )
		pygame.display.update()	
		time.sleep(0.01)	

	pygame.display.quit()


def rrPlotLine(offset, scale, moveSpeed, line):
	offX, offY = offset
	scaleX, scaleY = scale
	x1 = int( ( line.startX * scaleX ) + offX )
	y1 = int( ( line.startY * scaleY ) + offY )
	x2 = int( ( line.endX * scaleX ) + offX )
	y2 = int( ( line.endY * scaleY ) + offY )
	#raise tool here (if not)
	reprap.cartesian.seek( (x1, y1, 0), moveSpeed, True )
	#lower tool here
	reprap.cartesian.seek( (x2, y2, 0), moveSpeed, True )
	#raise tool here


def plotToRepRap(dxfFile):
	reprap.serial = serial.Serial(0, 19200, timeout = reprap.snap.messageTimeout)	# Initialise serial port, here the first port (0) is used.
	reprap.cartesian.x.active = True						# These devices are present in network, will automatically scan in the future.
	reprap.cartesian.y.active = True
	reprap.cartesian.z.active = True
	moveSpeed = 220
	offset = (0, 0)
	scale = (7, 7)
	reprap.cartesian.homeReset( moveSpeed, True )					# Send all axies to home position. Wait until arrival.

	for e in dxfFile.entities:
		if e.type == "LINE":
			rrPlotLine( offset, scale, moveSpeed, e )
		#elif e.type == "CIRCLE":
		#	screenPlotCircle( window, plotColour, offset, e )

				# Seek to (1000, 1000, 0). Wait until arrival.
	
	reprap.cartesian.homeReset( moveSpeed, True )					# Send all axies to home position. Wait until arrival.
	reprap.cartesian.free()								# Shut off power to all motors.


newdxf = pydxf.dxf( sys.argv[2] )
newdxf.printEnts()
if sys.argv[1] == "screen":
	plotToScreen(newdxf)
elif sys.argv[1] == "reprap":
	plotToRepRap(newdxf)



