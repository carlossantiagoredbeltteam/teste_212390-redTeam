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
"""

# add commands to switch to gcode mode to allow any script using this library to write gcode too.

import snap, time, serial, math

printDebug = False	# print debug info
#printDebug = True	# print debug info

# SNAP Control Commands - Taken from PIC code #

# extruder commands #
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

# stepper commands #
CMD_VERSION			=   0
CMD_FORWARD			=   1
CMD_REVERSE			=   2
CMD_SETPOS			=   3
CMD_GETPOS			=   4
CMD_SEEK			=   5
CMD_FREE			=   6
CMD_NOTIFY			=   7
CMD_SYNC			=   8
CMD_CALIBRATE		=   9
CMD_GETRANGE		=  10
CMD_DDA				=  11
CMD_FORWARD1		=  12
CMD_BACKWARD1		=  13
CMD_SETPOWER		=  14
CMD_GETSENSOR		=  15
CMD_HOMERESET		=  16
CMD_GETMODULETYPE	= 255

# sync modes #
sync_none	= 0		# no sync (default)
sync_seek	= 1		# synchronised seeking
sync_inc	= 2		# inc motor on each pulse
sync_dec	= 3		# dec motor on each pulse

MOTOR_FORWARD = 1
MOTOR_BACKWARD = 2

snap.localAddress = 0		# local address of host PC. This will always be 0.

UNITS_MM = 1
UNITS_STEPS = 2

defaultSpeed = 220
#moveSpeed = 221

def openSerial( port = 0, rate = 19200, tout = 60 ):
	global serialPort
	try:
		serialPort = serial.Serial( port, rate, timeout = tout )
		return True
	#except 13:
	except:
		print "You do not have permissions to use the serial port, try running as root"
		return False

def closeSerial():
	serialPort.close()

# Convert two 8 bit bytes to one integer
def bytes2int(LSB, MSB):		
	return int( (0x100 * int(MSB) ) | int(LSB) )

# Convert integer to two 8 bit bytes
def int2bytes(val):
	MSB = int( ( int(val) & 0xFF00) / 0x100 )
	LSB = int( int(val) & 0xFF )
	return LSB, MSB

#def loopTest():
#	p = snap.SNAPPacket( serial, snap.localAddress, snap.localAddress, 0, 1, [] )

# Scan reprap network for devices (incomplete) - this will be used by autoconfig functions when complete
def scanNetwork():
	devices = []
	for remoteAddress in range(1, 10):									# For every address in range. full range will be 255
		print "Trying address " + str(remoteAddress)
		p = snap.SNAPPacket( serialPort, remoteAddress, snap.localAddress, 0, 1, [CMD_GETMODULETYPE] )	# Create snap packet requesting module type
		#p = snap.SNAPPacket( serialPort, remoteAddress, snap.localAddress, 0, 1, [CMD_VERSION] )
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

def testComms():
	p = snap.SNAPPacket( serialPort, snap.localAddress, snap.localAddress, 0, 1, [255, 0] ) 	#start sync
	if p.send():
		if waitArrival:
			notif = getNotification( serialPort )
			if notif.dataBytes[0] == 255:
				return True
	return False


def getNotification(serialPort):
	return snap.getPacket(serialPort)


class extruderClass:
	def __init__(self):
		self.address = 8
		self.active = False
		self.requestedTemperature = 0
		self.vRefFactor = 7			# Default in java (middle)
		self.hb = 20				# Variable Preference
		self.hm = 1.66667			# Variable Preference
		self.absZero = 273.15		# Static, K
		self.rz = 29000				# Variable Preference
		self.beta = 3480			# Variable Preference
		self.vdd = 5.0				# Static, volts
		self.cap = 0.0000001		# Variable Preference

	def getModuleType(self):	#note: do pics not support this yet? I can't see it in code and get no reply from pic
		if self.active:
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [CMD_GETMODULETYPE] )	# Create SNAP packet requesting module type
			if p.send():
				rep = p.getReply()
				data = checkReplyPacket( rep, 2, CMD_GETMODULETYPE )						# If packet sent ok and was acknoledged then await reply, otherwise return False
				if data:
					return data[1]								# If valid reply is recieved then return it, otherwise return False
		return False

	def getVersion(self):
		if self.active:
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [CMD_VERSION] )
			if p.send():
				rep = p.getReply()
				data = checkReplyPacket( rep, 3, CMD_VERSION )
				if data:
					return data[1], data[2]
		return False

	def setMotor(self, direction, speed):
		if self.active and int(direction) > 0 and int(direction) < 3 and int(speed) >= 0 and int(speed <= 255):
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [int(direction), int(speed)] ) ##no command being sent, whats going on?
			if p.send():
				return True
		return False
		
	def calculateResistance(self, picTemp, calibrationPicTemp):
		#// TODO remove hard coded constants
		#// TODO should use calibration value instead of first principles
		#//double resistor = 10000;                   // ohms
		#//double c = 1e-6;                           // farads - now cap from prefs(AB)
		scale = 1 << (self.tempScaler+1)
		clock = 4000000.0 / (4.0 * scale) #  // hertz		
		
	
		vRef = 0.25 * self.vdd + self.vdd * self.vRefFactor / 32.0 #  // volts
	
		T = picTemp / clock # // seconds
		resistance = -T / (math.log(1 - vRef / self.vdd) * self.cap)#  // ohms
		return resistance

	def calculateTemperature(self, resistance):
		return (1.0 / (1.0 / self.absZero + math.log(resistance/self.rz) / self.beta)) - self.absZero;
	
	def rerangeTemperature(self, rawHeat):
		notDone = False
		#print "from", self.vRefFactor
		if (rawHeat == 255 and self.vRefFactor > 0):
			self.vRefFactor -= 1
			#Debug.d(material + " extruder re-ranging temperature (faster): ")
			self.setTempRange()
		elif (rawHeat < 64 and self.vRefFactor < 15):
			self.vRefFactor += 1
			#Debug.d(material + " extruder re-ranging temperature (slower): ")
			self.setTempRange()
		else:
			notDone = True
		#print "to", self.vRefFactor
		return notDone

	def setTempRange(self):
		#// We will send the vRefFactor to the PIC.  At the same
		#// time we will send a suitable temperature scale as well.
		#// To maximize the range, when vRefFactor is high (15) then
		#// the scale is minimum (0).
		#Debug.d(material + " extruder vRefFactor set to " + vRefFactor);
		self.tempScaler = 7 - (self.vRefFactor >> 1);
		self.setVoltageReference(self.vRefFactor)
		#print "vr", self.vRefFactor
		self.setTempScaler(self.tempScaler)
		#print "ts", self.tempScaler
		if (self.requestedTemperature != 0):
			self.setTemp(self.requestedTemperature, False)			# should we be re-calling this function to make sure temp request is updated (rather than just calling it once. are we?)

	def getRawTemp(self):
		if self.active:		
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [CMD_GETTEMP] )
			if p.send():
				rep = p.getReply()
				data = checkReplyPacket( rep, 3, CMD_GETTEMP )
				if data:
					#rawTemp = data[1]
					#calibration = data[2]
					return data[1], data[2]
		return False
		
	def getTemp(self):
		self.autoTempRange()
		rawHeat, calibration = self.getRawTemp()
		while rawHeat == 255 or rawHeat == 0:
			time.sleep(0.1)
			self.autoTempRange()
		res = self.calculateResistance( rawHeat, calibration )
		temp = self.calculateTemperature(res)
		#print rawHeat, res, temp
		return round(temp, 1)	#there is no point returning more points than this
		
	def setTemp(self, temperature, lock = False):
		self.requestedTemperature = temperature
		#if(math.abs(self.requestedTemperature - extrusionTemp) > 5):
		#	print " extruder temperature set to " + self.requestedTemperature + "C, which is not the standard temperature (" + extrusionTemp + "C).")
		#// Aim for 10% above our target to ensure we reach it.  It doesn't matter
		#// if we go over because the power will be adjusted when we get there.  At
		#// the same time, if we aim too high, we'll overshoot a bit before we
		#// can react.
		
		#// Tighter temp constraints under test 10% -> 3% (10-1-8)
		temperature0 = temperature * 1.03
		
		#// A safety cutoff will be set at 20% above requested setting
		#// Tighter temp constraints added by eD 20% -> 6% (10-1-8)
		temperatureSafety = temperature * 1.06
		
		#// Calculate power output from hm, hb.  In general, the temperature
		#// we achieve is power * hm + hb.  So to achieve a given temperature
		#// we need a power of (temperature - hb) / hm
		
		#// If we reach our temperature, rather than switching completely off
		#// go to a reduced power level.
		power0 = int( round(((0.9 * temperature0) - self.hb) / self.hm) )
		if power0 < 0: power0 = 0
		if power0 > 255: power0 = 255

		#// Otherwise, this is the normal power level we will maintain
		power1 = int( round((temperature0 - self.hb) / self.hm) )
		if power1 < 0: power1 = 0
		if power1 > 255: power1 = 255

		#// Now convert temperatures to equivalent raw PIC temperature resistance value
		#// Here we use the original specified temperature, not the slight overshoot
		resistance0 = self.calculateResistanceForTemperature(temperature)				#ADD THIS FUNCTION!
		resistanceSafety = self.calculateResistanceForTemperature(temperatureSafety)

		#// Determine equivalent raw value
		t0 = self.calculatePicTempForResistance(resistance0)								#ADD THIS FUNCTION!
		if t0 < 0: t0 = 0
		if t0 > 255: t0 = 255
		t1 = self.calculatePicTempForResistance(resistanceSafety)
		if t1 < 0: t1 = 0
		if t1 > 255: t1 = 255
		
		if (temperature == 0):
			#self.setHeat( 0, 0 )#, lock )
			self.setHeat( 0, 0, 0, 0 )#, lock )
		else:
			self.setHeat( power0, power1, t0, t1 )#, lock )

	def calculateResistanceForTemperature(self, temperature):
		return self.rz * math.exp(self.beta * (1/(temperature + self.absZero) - 1/self.absZero))

	def calculatePicTempForResistance(self, resistance):
		scale = 1 << (self.tempScaler+1)
		clock = 4000000.0 / (4.0 * scale)	#// hertz		
		vRef = 0.25 * self.vdd + self.vdd * self.vRefFactor / 32.0	#// volts
		T = -resistance * (math.log(1 - vRef / self.vdd) * self.cap)
		picTemp = T * clock
		return int( round(picTemp) )

		
	def autoTempRange(self):
		rawHeat, calibration = self.getRawTemp()
		unChanged = self.rerangeTemperature(rawHeat)
		while not unChanged:
			rawHeat, calibration = self.getRawTemp()
			unChanged = self.rerangeTemperature(rawHeat)
			#print "rh", rawHeat, "uc", unChanged
			time.sleep(0.1)

	def setVoltageReference(self, val):
		if self.active:
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [CMD_SETVREF, int(val)] )
			if p.send():
				return True
		return False
		
	def setTempScaler(self, val):
		if self.active:
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [CMD_SETTEMPSCALER, int(val)] )
			if p.send():
				return True
		return False

	def setHeat(self, lowHeat, highHeat, tempTarget, tempMax):
		if self.active:
			print "Setting heater with params, ", "lowHeat", lowHeat, "highHeat", highHeat, "tempTarget", tempTarget, "tempMax", tempMax
			tempTargetMSB, tempTargetLSB = int2bytes( tempTarget )
			tempMaxMSB ,tempMaxLSB = int2bytes( tempMax )
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [CMD_SETHEAT, int(lowHeat), int(highHeat), tempTargetMSB, tempTargetLSB, tempMaxMSB, tempMaxLSB] )	# assumes MSB first (don't know this!)
			if p.send():
				return True
		return False

	def setCooler(self, speed):
		if self.active:
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [CMD_SETCOOLER, int(speed)] )
			if p.send():
				return True
		return False

	def freeMotor(self):
		if self.active:
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [CMD_FREE] )
			if p.send():
				return True
		return False

extruder = extruderClass()


def checkReplyPacket (packet, numExpectedBytes, command):
	if packet:
		if len( packet.dataBytes ) == numExpectedBytes:		# check correct number of data bytes have been recieved
			if packet.dataBytes[0] == command:			# check reply is a reply to sent command
				return packet.dataBytes
	return False
				


class axisClass:
	def __init__(self, address):
		self.address = address
		self.active = False	# when scanning network, set this, then in each func below, check alive before doing anything
		self.limit = 0
		self.speed = defaultSpeed
	
	# Move axis one step forward
	def forward1(self):
		if self.active:
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [CMD_FORWARD1] ) 
			if p.send():
				return True
		return False

	# Move axis one step backward
	def backward1(self):
		if self.active:
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [CMD_BACKWARD1] ) 
			if p.send():
				return True
		return False

	# Spin axis forward at given speed
	def forward(self, speed = False):
		if not speed:
			speed = self.speed
		if self.active and speed >=0 and speed <=255:
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [CMD_FORWARD, int(speed)] ) 
			if p.send():
				return True
		return False

	# Spin axis backward at given speed
	def backward(self, speed = False):
		# If speed is not specified use stored (or default)
		if not speed:
			speed = self.speed
		if self.active and speed >=0 and speed <=255:
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [CMD_REVERSE, int(speed)] ) 
			if p.send():
				return True
		return False

	# Debug only (raw PIC info)
	def getSensors(self):
		if self.active:
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [CMD_GETSENSOR] )
			if p.send():
				rep = p.getReply()
				data = checkReplyPacket( rep, 3, CMD_GETSENSOR )		# replace this with a proper object in SNAP module?
				if data:
					print data[1], data[2]
		return False

	# Get current axis position
	def getPos(self):
		if self.active:
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [CMD_GETPOS] )
			if p.send():
				rep = p.getReply()
				data = checkReplyPacket( rep, 3, CMD_GETPOS )
				if data:
					pos = bytes2int( data[1], data[2] )
					return pos 						# return value
		return False

	#set current position (set variable not robot position)
	def setPos(self, pos):
		if self.active and pos >=0 and pos <= 0xFFFF:
			posMSB ,posLSB = int2bytes( pos )
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [CMD_SETPOS, posMSB, posLSB] )
			if p.send():
				return True
		return False

	#power off coils on stepper
	def free(self):
		if self.active:
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [CMD_FREE] ) 
			if p.send():
				return True
		return False

	#seek to axis location. When waitArrival is True, funtion does not return until seek is compete
	def seek(self, pos, speed = False, waitArrival = True):
		if not speed:
			speed = self.speed
		if self.active and (pos <= self.limit or self.limit == 0) and pos >=0 and pos <= 0xFFFF and speed >=0 and speed <=255:
			posMSB ,posLSB = int2bytes( pos )
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [CMD_SEEK, int(speed), posMSB ,posLSB] ) 
			if p.send():
				if waitArrival:
					if printDebug: print "    wait notify"
					notif = getNotification( serialPort )
					if notif.dataBytes[0] == CMD_SEEK:
						if printDebug: print "    valid notification for seek"
					else:
						return False
					if printDebug: print "    rec notif"
				return True
		return False
	
	#goto 0 position. When waitArrival is True, funtion does not return until reset is compete
	def homeReset(self, speed = False, waitArrival = True):
		if not speed:
			speed = self.speed
		if self.active and speed >=0 and speed <=255:
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [CMD_HOMERESET, int(speed)] ) 
			if p.send():
				if waitArrival:
					if printDebug: print "reset wait"
					notif = getNotification( serialPort )
					if notif.dataBytes[0] == CMD_HOMERESET:
						if printDebug: print "    valid notification for reset"
					else:
						return False
					if printDebug: print "reset done"
				return True
		return False

	def setNotify(self):
		#global serialPort
		if self.active:
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [CMD_NOTIFY, snap.localAddress] ) 	# set notifications to be sent to host
			if p.send():
				return True
		return False

	def setSync( self, syncMode ):
		if self.active and syncMode >=0 and syncMode <=255:
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [CMD_SYNC, int(syncMode)] )
			if p.send():
				return True
		return False

	def DDA( self, seekTo, slaveDelta, speed = False, waitArrival = True):
		if not speed:
			speed = self.speed
		if self.active and (seekTo <= self.limit or self.limit == 0) and seekTo >=0 and seekTo <= 0xFFFF and slaveDelta >=0 and slaveDelta <= 0xFFFF and speed >=0 and speed <=255:
			masterPosMSB, masterPosLSB = int2bytes( seekTo )
			slaveDeltaMSB, slaveDeltaLSB = int2bytes( slaveDelta )
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [CMD_DDA, int(speed), masterPosMSB ,masterPosLSB, slaveDeltaMSB, slaveDeltaLSB] ) 	#start sync
			if p.send():
				if waitArrival:
					notif = getNotification( serialPort )
					if notif.dataBytes[0] == CMD_DDA:
						if printDebug: print "    valid notification for DDA"	# todo: add actual enforement on wrong notification
					else:
						return False
				return True
		return False

	def setPower( self, power ):
		power = int( float(power) * 0.63 )
		if self.active and power >=0 and power <=63:
			p = snap.SNAPPacket( serialPort, self.address, snap.localAddress, 0, 1, [CMD_SETPOWER, int( power * 0.63 )] ) # This is a value from 0 to 63 (6 bits)
			if p.send():
				return True
		return False
		
	def setMoveSpeed(self, speed):
		self.speed = speed

	#def setTurnaroundSteps(self, steps):
	#	self.turnArroundSteps = steps
		

# Class to hold axis info so master and slave on sync move can be swapped over.
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

# Main cartesian robot class
class cartesianClass:
	def __init__(self):
		# initiate axies with addresses
		self.x = axisClass(2)
		self.y = axisClass(3)
		self.z = axisClass(4)

	# Goto home position (all axies)
	def homeReset(self, speed = False, waitArrival = True):
		#z is done first so we don't break anything we just made
		if self.z.homeReset( speed = speed, waitArrival = waitArrival ):
			print "Z Reset"
		if self.x.homeReset( speed = speed, waitArrival = waitArrival ):		#setting these to true breaks waitArrival convention. need to rework waitArrival and possibly have each axis storing it's arrival flag and pos as variables?
			print "X Reset"		
		if self.y.homeReset( speed = speed, waitArrival = waitArrival ):
			print "Y Reset"
		
		# add a way to collect all three notifications (in whatever order) then check they are all there. this will allow symultanious axis movement and use of waitArrival

	# seek to location (all axies). When waitArrival is True, funtion does not return until all seeks are compete
	# seek will automatically use syncSeek when it is required. Always use the seek function
	def seek(self, pos, speed = False, waitArrival = True):
		#printDebug = True
		if not speed:
			speed = self.speed
		curX, curY, curZ = self.x.getPos(), self.y.getPos(), self.z.getPos()
		x, y, z = pos
		print "seek from", curX, curY, curZ, "to", x, y, z
		# Check that we are moving withing limits, and 
		if (x <= self.x.limit or self.x.limit == 0) and (y <= self.y.limit or self.y.limit == 0) and (z <= self.z.limit or self.z.limit == 0):
			if printDebug: print "seek from [", curX, curY, curZ, "] to [", x, y, z, "]"
			# Check if we need to do a standard seek or a DDA seek
			if x == curX or y == curY:
				if printDebug: print "    standard seek"
				if x and x != curX:				
					self.x.seek( x, speed, waitArrival )			#setting these to true breaks waitArrival convention. need to rework waitArrival and possibly have each axis storing it's arrival flag and pos as variables?
				if y and y != curY:
					self.y.seek( y, speed, waitArrival )
			elif x and y:
				if printDebug: print "    sync seek"
				self._syncSeek( pos, curX, curY, speed, waitArrival )
			if z and z != curZ:
				#self.z.seek( z, speed, True ) # why was this forced?
				self.z.seek( z, speed, waitArrival )
			return True
		else:
			print "Trying to print outside of limit, aborting seek"
			return False
	
	# perform syncronised x/y movement. This is called by seek when needed.
	def _syncSeek(self, pos, curX, curY, speed = False, waitArrival = True):
		#printDebug = True
		if not speed:
			speed = self.speed
		#curX, curY = self.x.getPos(), self.y.getPos()
		newX, newY, nullZ = pos
		deltaX = abs( curX - newX )		# calc delta movements
		deltaY = abs( curY - newY )
		print "syncseek deltas", deltaX, deltaY
		directionX = ( curX - newX ) / -deltaX	# gives direction -1 or 1
		directionY = ( curY - newY ) / -deltaY	
		
		master = syncAxis( self.x, newX, deltaX, directionX )	# create two swapable data structures, set x as master, y as slave
		slave = syncAxis( self.y, newY, deltaY, directionY )
		
		if slave.delta > master.delta:		# if y has the greater movement then make y master
			slave, master = master, slave
			if printDebug: print "    switching to y master"
		if printDebug: print "    masterPos", master.seekTo, "slaveDelta", slave.delta
		slave.axis.setSync( slave.syncMode )
		master.axis.DDA( master.seekTo, slave.delta, speed, True )	#why was this forced? # because we have to wait before we tell the slave axis to leave sync mode!
		#master.axis.DDA( master.seekTo, slave.delta, speed, waitArrival )
		time.sleep(0.01)	# TODO this is really bad, can we remove?
		slave.axis.setSync( sync_none )
		if printDebug: print "    sync seek complete"
	
	# get current position of all three axies	
	def getPos(self):
		return self.x.getPos(), self.y.getPos(), self.z.getPos()
	
	# Stop all motors (but retain current)
	def stop(self):
		self.x.forward(0)
		self.y.forward(0)
		self.z.forward(0)

	# Free all motors (no current on coils)
	def free(self):
		self.x.free()
		self.y.free()
		self.z.free()
	
	# Set stepper power 0% to 100%
	def setPower(self, power):
		self.x.setPower(power)
		self.y.setPower(power)
		self.z.setPower(power)
	
	#keep sending power down commands to all board every second
	#def lockout():
	
	# Set stepper speed (0 - 255)
	def setMoveSpeed(self, speed):
		self.speed = speed
		self.x.setMoveSpeed(speed)
		self.y.setMoveSpeed(speed)
		self.z.setMoveSpeed(speed)


cartesian = cartesianClass()



