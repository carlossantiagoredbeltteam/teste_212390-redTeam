import serial, reprap, time							# Import the reprap and pySerial modules.

reprap.openSerial( 0, 19200, 60 )					# Initialise serial port, here the first port (0) is used.

reprap.cartesian.x.active = True					# These devices are present in network, will automatically scan in the future.
reprap.cartesian.y.active = True
reprap.cartesian.z.active = True
reprap.extruder.active = True

reprap.cartesian.x.setNotify()						# Set x axis to notify arrivals
reprap.cartesian.y.setNotify()						# Set y axis to notify arrivals
reprap.cartesian.z.setNotify()						# Set z axis to notify arrivals

reprap.cartesian.setMoveSpeed(220)					# Set stepper speed to 220 (out of 255)
reprap.cartesian.setPower( int( 83 * 0.63 ) )		# Set power to 83%

# The module is now ready to recieve commands #

reprap.cartesian.homeReset()						# Send all axies to home position. Wait until arrival.
reprap.cartesian.seek( (1000, 1000, 0) )			# Seek to (1000, 1000, 0). Wait until arrival.
time.sleep(2)										# Pause.
reprap.cartesian.seek( (500, 1000, 0) )				# Seek to (500, 1000, 0). Wait until arrival.
time.sleep(2)
reprap.cartesian.seek( (1000, 500, 0) )				# Seek to (1000, 500, 0). Wait until arrival.
time.sleep(2)
reprap.cartesian.seek( (100, 100, 0) )				# Seek to (100, 100, 0). Wait until arrival.

reprap.cartesian.homeReset()						# Send all axies to home position. Wait until arrival.
reprap.cartesian.free()								# Shut off power to all motors.
