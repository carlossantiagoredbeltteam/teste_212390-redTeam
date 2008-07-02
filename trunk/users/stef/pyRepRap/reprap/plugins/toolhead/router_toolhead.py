import reprap, reprap.preferences
#from router_prefpanel import PreferencesPanel

Title = "Router"

class tool:
	def __init__(self):
		self.pref_toolDownPos = 0
		self.pref_toolUpPos = 0
		# Load preferences from file
		self.prefHandler = reprap.preferences.PreferenceHandler(self,  "toolhead_router.conf")
		self.prefHandler.load()
		self.penIsDown = False
	
	def prepare(self):
		pass
		# Switch on motor here TODO
	
	def idle(self):
		pass
		# Switch off motor here TODO
	
	def start(self):
		if not self.penIsDown:
			self.penIsDown = True
			self.output.cartesianMove(False, False, self.pref_toolDownPos, units = reprap.UNITS_STEPS)
	
	def stop(self):
		if self.penIsDown:
			self.penIsDown = False
			self.output.cartesianMove(False, False, self.pref_toolUpPos, units = reprap.UNITS_STEPS)



