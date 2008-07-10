## gcode.py is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by the
## Free Software Foundation; either version 2 of the License, or (at your
## option) any later version.  gcode.py is distributed in the hope that it
## will be useful, but WITHOUT ANY WARRANTY; without even the implied
## warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
## the GNU General Public License for more details.  You should have
## received a copy of the GNU General Public License along with gcode.py; if
## not, write to the Free Software Foundation, Inc., 59 Temple Place,
## Suite 330, Boston, MA 02111-1307 USA
## 
## gcode.py is Copyright (C) 2005 Chris Radek
## chris@timeguy.com

class gcode:
	lastx = lasty = lastz = lasta = lastgcode = None
	lastfeed = None

	def __init__(self, homeheight = 1.5, safetyheight = 0.04):
		self.homeheight = homeheight
		self.safetyheight = self.lastz = safetyheight

	def begin(self):
		return "G00 Z%.4f\n" % (self.safetyheight) + \
			"G17 G20 G40 G49\n" + "G54 G80 G90 G94\n" + \
			"S1000 M3\n" + "G04 P3"

	def end(self):
		return self.safety() + "\n" + "M2\n"

	def exactpath(self):
		return "G61"

	def continuous(self):
		return "G64"

	def rapid(self, x = None, y = None, z = None, a = None, gcode = "G00", feed=None):
		gcodestring = feedstring = xstring = ystring = zstring = astring = ""
		if x == None: x = self.lastx
		if y == None: y = self.lasty
		if z == None: z = self.lastz
		if a == None: a = self.lasta
		if gcode != self.lastgcode:
			gcodestring = gcode
			self.lastgcode = gcode
		if x != self.lastx:
			xstring = " X%.4f" % (x)
			self.lastx = x
		if y != self.lasty:
			ystring = " Y%.4f" % (y)
			self.lasty = y
		if z != self.lastz:
			zstring = " Z%.4f" % (z)
			self.lastz = z
		if a != self.lasta:
			astring = " A%.4f" % (a)
			self.lasta = a
		if gcode == "G01" and feed and feed != self.lastfeed:
			feedstring = " F%.4f" % (feed)
			self.lastfeed = feed
		return gcodestring + feedstring + xstring + ystring + zstring + astring

	def cut(self, x = None, y = None, z = None, a = None, feed=None):
		if x == None: x = self.lastx
		if y == None: y = self.lasty
		if z == None: z = self.lastz
		if a == None: a = self.lasta
		return self.rapid(x, y, z, a, gcode="G01", feed=feed)

	def home(self):
		return self.rapid(z=self.homeheight)

	def safety(self):
		return self.rapid(z=self.safetyheight)
