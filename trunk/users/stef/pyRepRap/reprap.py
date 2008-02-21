"""
    pyRepRap is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    pyRepRap is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with pyRepRap.  If not, see <http://www.gnu.org/licenses/>.
"""
"""    
    This is the main user imported module containing all end user functions    
   
    SNAP Addresses:
    *  0 PC
    * 1 Master controller (not currently used for ring network)
    * 2 X axis
    * 3 Y axis
    * 4 Z axis
    * 5-7 Reserved for 6 DoF? platforms (Stewart platform etc.)
    * 8..27 Extruders 1 to 20
    * 50 IOBox test tool
"""

import snap, time

printDebug = False
printDebug = True

# SNAP Control Commands - Taken from PIC code #

#extruder commands#
CMD_VERSION       =  0
CMD_FORWARD       =  1
CMD_REVERSE       =  2
CMD_SETPOS        =  3
CMD_GETPOS        =  4
CMD_SEEK          =  5
CMD_FREE          =  6
CMD_NOTIFY        =  7
CMD_ISEMPTY       =  8
CMD_SETHEAT       =  9
CMD_GETTEMP       = 10
CMD_SETCOOLER     = 11
CMD_PWMPERIOD     = 50
CMD_PRESCALER     = 51
CMD_SETVREF       = 52
CMD_SETTEMPSCALER = 53
CMD_GETDEBUGINFO  = 54
CMD_GETTEMPINFO   = 55

#stepper commands#
CMD_VERSION		=   0
CMD_FORWARD		=   1
CMD_REVERSE		=   2
CMD_SETPOS		=   3
CMD_GETPOS		=   4
CMD_SEEK		=   5
CMD_FREE		=   6
CMD_NOTIFY		=   7
CMD_SYNC		=   8
CMD_CALIBRATE		=   9
CMD_GETRANGE		=  10
CMD_DDA			=  11
CMD_FORWARD1		=  12
CMD_BACKWARD1		=  13
CMD_SETPOWER		=  14
CMD_GETSENSOR		=  15
CMD_HOMERESET		=  16
CMD_GETMODULETYPE	= 255

#sync modes#
sync_none	= 0	# no sync (default)
sync_seek	= 1	# synchronised seeking
sync_inc	= 2	# inc motor on each pulse
sync_dec	= 3	# dec motor on each pulse

snap.localAddress = 0		# local address of host PC. This will always be 0.


# Convert two 8 bit bytes to one integer
def bytes2int(LSB, MSB):		
	return (0x100 * MSB) | LSB

# Convert integer to two 8 bit bytes
def int2bytes(val):
	MSB = (val & 0xFF00) / 0x100
	LSB = val  & 0xFF
	return LSB, MSB

#def loopTest():
#	p = snap.SNAPPacket( serial, snap.localAddress, snap.localAddress, 0, 1, [] )

# Scan reprap network for devices (incomplete) - this will be used by autoconfig functions when complete
def scanNetwork():
	devices = []
	for remoteAddress in range(1, 10):									# For every address in range. full range will be 255
		print "Trying address " + str(remoteAddress)
		p = snap.SNAPPacket( serial, remoteAddress, snap.localAddress, 0, 1, [CMD_GETMODULETYPE] )	# Create snap packet requesting module type
		#p = snap.SNAPPacket( serial, remoteAddress, snap.localAddress, 0, 1, [CMD_VERSION] )
		if p.send():											# Send snap packet, if sent ok then await reply
			rep = p.getReply()
			if rep:
				#devices[ rep.dataBytes[1] ] = remoteAddress
				devices.append( { 'address':remoteAddress, 'type':rep.dataBytes[1], 'subType':rep.dataBytes[2] } )	# If device replies then add to device list.
			else:
				"print na"
		else:
			print "scan no ack"
		time.sleep(0.5)
	for d in devices:
		#now get versions
		print "device", d

def getNotification(serial):
	return snap.getPacket(serial)

class extruderClass:
	def __init__(self):
		self.address = 8
		self.active = False
	def getModuleType(self):	#note: do pics not support this yet? I can't see it in code and get no reply from pic
		p = snap.SNAPPacket( serial, self.address, snap.localAddress, 0, 1, [CMD_GETMODULETYPE] )	# Create SNAP packet requesting module type
		if p.send():
			rep = p.getReply()									# If packet sent ok and was acknoledged then await reply, otherwise return False
			if rep:
				return rep.dataBytes[1]								# If valid reply is recieved then return it, otherwise return False
		return False
	def getVersion(self):
		p = snap.SNAPPacket( serial, self.address, snap.localAddress, 0, 1, [CMD_VERSION] )
		p.send()
		rep = p.getReply()
		if rep:
			return rep.dataBytes[1], rep.dataBytes[2]
		else:
			return False
	def setMotor(self, direction, speed):
		p = snap.SNAPPacket( serial, self.address, snap.localAddress, 0, 1, [direction, speed] ) ##no command being sent, whats going on?
		p.send()
	def getTemp(self):
		if self.active:		
			p = snap.SNAPPacket( serial, self.address, snap.localAddress, 0, 1, [CMD_GETTEMP] )
			p.send()
			rep = p.getReply()
			if rep:
				#temp = bytes2int( rep.dataBytes[1], rep.dataBytes[2] )
				return rep.dataBytes[1]
		return False
	def setVoltateReference(self, val):
		if self.active:
			p = snap.SNAPPacket( serial, self.address, snap.localAddress, 0, 1, [CMD_SETVREF, val] )
			p.send()
		return False
	def setHeat(self, lowHeat, highHeat, tempTarget, tempMax):	
		tempTargetMSB, tempTargetLSB = int2bytes( tempTarget )
		tempMaxMSB ,tempMaxLSB = int2bytes( tempMax )
		p = snap.SNAPPacket( serial, self.address, snap.localAddress, 0, 1, [CMD_SETHEAT, lowHeat, highHeat, tempTargetMSB, tempTargetLSB, tempMaxMSB, tempMaxLSB] )	# assumes MSB first (don't know this!)
		p.send()
	def setCooler(self, speed):
		p = snap.SNAPPacket( serial, self.address, snap.localAddress, 0, 1, [CMD_SETCOOLER, speed] )
		p.send()
	def freeMotor(self):
		p = snap.SNAPPacket( serial, self.address, snap.localAddress, 0, 1, [CMD_FREE] )
		p.send()

extruder = extruderClass()

class axisClass:
	def __init__(self, address):
		self.address = address
		self.active = False	#when scanning network, set this, then in each func below, check alive before doing anything
	#move axis one step forward
	def forward1(self):
		p = snap.SNAPPacket( serial, self.address, snap.localAddress, 0, 1, [CMD_FORWARD1] ) 
		p.send()
	#move axis one step backward
	def backward1(self):
		p = snap.SNAPPacket( serial, self.address, snap.localAddress, 0, 1, [CMD_BACKWARD1] ) 
		p.send()
	#spin axis forward at given speed
	def forward(self, speed):
		if self.active:
			p = snap.SNAPPacket( serial, self.address, snap.localAddress, 0, 1, [CMD_FORWARD, speed] ) 
			p.send()
			return True
		else:
			return False
	#spin axis backward at given speed
	def backward(self, speed):
		p = snap.SNAPPacket( serial, self.address, snap.localAddress, 0, 1, [CMD_REVERSE, speed] ) 
		p.send()

	#debug only
	def getSensors(self):
		p = snap.SNAPPacket( serial, self.address, snap.localAddress, 0, 1, [CMD_GETSENSOR] )
		p.send()
		rep = p.getReply()
		print rep.dataBytes[1], rep.dataBytes[2]##?

	#get current axis position
	def getPos(self):
		if self.active:
			p = snap.SNAPPacket( serial, self.address, snap.localAddress, 0, 1, [CMD_GETPOS] )
			p.send()
			rep = p.getReply()
			if rep:
				pos = bytes2int( rep.dataBytes[1], rep.dataBytes[2] )
				return pos 
		return False

	#set current position (set variable not robot position)
	def setPos(self, pos):
		posMSB ,posLSB = int2bytes( pos )
		p = snap.SNAPPacket( serial, self.address, snap.localAddress, 0, 1, [CMD_SETPOS, posMSB, posLSB] )
		p.send()

	#power off coils on stepper
	def free(self):
		p = snap.SNAPPacket( serial, self.address, snap.localAddress, 0, 1, [CMD_FREE] ) 
		p.send()

	#seek to axis location. When waitArrival is True, funtion does not return until seek is compete
	def seek(self, pos, speed, waitArrival):
		if self.active:
			posMSB ,posLSB = int2bytes( pos )
			p = snap.SNAPPacket( serial, self.address, snap.localAddress, 0, 1, [CMD_SEEK, speed, posMSB ,posLSB] ) 
			p.send()
			if waitArrival:
				if printDebug: print "    wait notify"
				notif = getNotification( serial )
				if notif.dataBytes[0] == CMD_SEEK:
					if printDebug: print "valid notification for seek"
				if printDebug: print "    rec notif"
			return True
		return False
	
	#goto 0 position. When waitArrival is True, funtion does not return until reset is compete
	def homeReset(self, speed, waitArrival):
		if self.active:
			p = snap.SNAPPacket( serial, self.address, snap.localAddress, 0, 1, [CMD_HOMERESET, speed] ) 
			p.send()
			#time.sleep(0.5)
			if waitArrival:
				if printDebug: print "reset wait"
				notif = getNotification( serial )
				if notif.dataBytes[0] == CMD_HOMERESET:
					if printDebug: print "    valid notification for reset"
				
				if printDebug: print "reset done"
			return True
		return False

	def setNotify(self):
		if self.active:
			p = snap.SNAPPacket( serial, self.address, snap.localAddress, 0, 1, [CMD_NOTIFY, snap.localAddress] ) 	# set notifications to be sent to host
			p.send()
			return True
		return False

	def setSync( self, syncMode ):
		if self.active:
			p = snap.SNAPPacket( serial, self.address, snap.localAddress, 0, 1, [CMD_SYNC, syncMode] )
			p.send()
			return True
		return False

	def DDA( self, speed, seekTo, slaveDelta, waitArrival):
		if self.active:
			masterPosMSB, masterPosLSB = int2bytes( seekTo )
			slaveDeltaMSB, slaveDeltaLSB = int2bytes( slaveDelta )
			p = snap.SNAPPacket( serial, self.address, snap.localAddress, 0, 1, [CMD_DDA, speed, masterPosMSB ,masterPosLSB, slaveDeltaMSB, slaveDeltaLSB] ) 	#start sync
			p.send()
			if waitArrival:
				notif = getNotification( serial )
				if notif.dataBytes[0] == CMD_DDA:
					if printDebug: print "valid notification for DDA"	# todo: add actual enforement on wrong notification
			return True
		return False

class syncAxis:
	def __init__( self, axis, seekTo, delta, direction ):
		self.axis = axis
		self.seekTo = seekTo
		self.delta = delta
		self.direction = direction

		if self.direction > 0:
			self.syncMode = sync_inc
		else:
			self.syncMode = sync_dec


class cartesianClass:
	def __init__(self):
		#initiate axies with addresses
		self.x = axisClass(2)
		self.y = axisClass(3)
		self.z = axisClass(4)
	#goto home position (all axies)
	def homeReset(self, speed, waitArrival):
		self.x.homeReset( speed, waitArrival )		#setting these to true breaks waitArrival convention. need to rework waitArrival and possibly have each axis storing it's arrival flag and pos as variables?
		self.y.homeReset( speed, waitArrival )
		self.z.homeReset( speed, waitArrival )
		# add a way to collect all three notifications (in whatever order) then check they are all there. this will allow symultanious axis movement and use of waitArrival

	# seek to location (all axies). When waitArrival is True, funtion does not return until all seeks are compete
	# seek will automatically use syncSeek when it is required. Always use the seek function
	def seek(self, pos, speed, waitArrival):
		curX, curY, curZ = self.x.getPos(), self.y.getPos(), self.z.getPos()
		x, y, z = pos
		if printDebug: print "seek from [", curX, curY, curZ, "] to [", x, y, z, "]"
		if x == curX or y == curY:
			if printDebug: print "    standard seek"
			self.x.seek( x, speed, True )			#setting these to true breaks waitArrival convention. need to rework waitArrival and possibly have each axis storing it's arrival flag and pos as variables?
			self.y.seek( y, speed, True )
		else:
			if printDebug: print "    sync seek"
			self.syncSeek( pos, speed, waitArrival )
		if z != curZ:
			self.z.seek( z, speed, True )

	def syncSeek(self, pos, speed, waitArrival):
		curX, curY = self.x.getPos(), self.y.getPos()
		newX, newY, nullZ = pos
		deltaX = abs( curX - newX )		# calc delta movements
		deltaY = abs( curY - newY )
		directionX = ( curX - newX ) / -deltaX	# gives direction -1 or 1
		directionY = ( curY - newY ) / -deltaY	
		if printDebug: print "    dx", deltaX, "dy", deltaY, "dirX", directionX, "dirY", directionY
		if printDebug: print "    using x master"

		master = syncAxis( self.x, newX, deltaX, directionX )	# create two swapable data structures, set x as master, y as slave
		slave = syncAxis( self.y, newY, deltaY, directionY )
		
		if slave.delta > master.delta:		# if y has the greater movement then make y master
			slave, master = master, slave
			if printDebug: print "    switching to y master"
		if printDebug: print "    masterPos", master.seekTo, "slaveDelta", slave.delta
		slave.axis.setSync( slave.syncMode )
		master.axis.DDA( speed, master.seekTo, slave.delta, True )
		time.sleep(0.1)
		slave.axis.setSync( sync_none )
		if printDebug: print "    sync seek complete"
		
	def getPos(self):
		return self.x.getPos(), self.y.getPos(), self.z.getPos()
	def stop(self):
		self.x.forward( 0 )
		self.y.forward( 0 )
		self.z.forward( 0 )
	def free(self):
		self.x.free()
		self.y.free()
		self.z.free()

	
		
cartesian = cartesianClass()

#wait on serial only when after somthing? or do pics send messages without pc request?






