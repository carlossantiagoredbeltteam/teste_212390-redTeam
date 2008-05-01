#!/usr/bin/python
import reprap
reprap.openSerial( 0, 19200, 60 )						# Initialise serial port, here the first port (0) is used, timeout 60 seconds.
reprap.cartesian.x.active = True						# These devices are present in network, will automatically scan in the future.
reprap.cartesian.y.active = True
reprap.cartesian.z.active = True

reprap.cartesian.x.setNotify()						
reprap.cartesian.y.setNotify()
reprap.cartesian.z.setNotify()

reprap.cartesian.setMoveSpeed(220)
reprap.cartesian.setPower( int( 83 * 0.63 ) )
reprap.cartesian.homeReset()
