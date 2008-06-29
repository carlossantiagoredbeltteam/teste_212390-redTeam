import reprap, reprap.preferences
from pen_prefpanel import PreferencesPanel

Title = "Pen"

def getPreferencePanel(parent):
	return PreferencesPanel(parent, -1)

class tool:
	def __init__(self, output):
		self.output = output
		self.pref_penDownPos = 0
		self.pref_penUpPos = 0
		# Load preferences from file
		self.prefHandler = reprap.preferences.PreferenceHandler(self,  "toolhead_pen.conf")
		self.prefHandler.load()
		self.penIsDown = False
		
	def toolPrepare(self):
		pass
	
	def toolIdle(self):
		pass
	
	def toolStart(self):
		if not self.penIsDown:
			self.penIsDown = True
			self.output.cartesianMove(False, False, self.pref_penDownPos, units = reprap.UNITS_STEPS)	#pen up and down pos' should be in mm with a conversion to stepss in reprap_output TODO
			self.output.toolStart()
	
	def toolStop(self):
		if self.penIsDown:
			self.penIsDown = False
			self.output.cartesianMove(False, False, self.pref_penUpPos, units = reprap.UNITS_STEPS)
			self.output.toolStop()

