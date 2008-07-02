import reprap, reprap.preferences
from pen_prefpanel import PreferencesPanel

Title = "Pen"

class tool:
	def __init__(self):
		self.pref_penDownPos = 0
		self.pref_penUpPos = 0
		# Load preferences from file
		self.prefHandler = reprap.preferences.PreferenceHandler(self,  "toolhead_pen.conf")
		self.prefHandler.load()
		self.penIsDown = False
	
	def prepare(self):
		pass
	
	def idle(self):
		pass
	
	def start(self):
		if not self.penIsDown:
			self.penIsDown = True
			self.output.cartesianMove(False, False, self.pref_penDownPos, units = reprap.UNITS_STEPS)
	
	def stop(self):
		if self.penIsDown:
			self.penIsDown = False
			self.output.cartesianMove(False, False, self.pref_penUpPos, units = reprap.UNITS_STEPS)



