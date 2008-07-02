class Polygon:
	def __init__(self, points = [], closed = False):
		#self.points = points
		self.points = []
		self.closed = closed
		self.pointsPlotted = 0
	
	def addPoint(self, point):
		self.points.append(point)
	
	def addPoints(self, points):
		self.points += points
	
	def addPolygon(self, poly):
		self.points += poly.points
	


