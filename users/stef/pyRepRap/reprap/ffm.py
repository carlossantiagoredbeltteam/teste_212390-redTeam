import reprap, time

class FFM:
	def __init__(self, extrudeTemp, extrudeSpeed, moveSpeed, zBottomLayer, zIdleHeight, stopReverseMotorTime):
		self.extrudeTemp = extrudeTemp
		self.extrudeSpeed = extrudeSpeed
		self.moveSpeed = moveSpeed
		self.zBottomLayer = zBottomLayer
		self.zIdleHeight = zIdleHeight
		self.stopReverseMotorTime = stopReverseMotorTime
		self.fastSpeed = 200
		
		self.currentLayerHeight = self.zBottomLayer
		reprap.cartesian.setMoveSpeed(self.moveSpeed)
		
	def setExtrudeSpeed(self, speed):
		self.extrudeSpeed = speed
	
	def setExtrudeMoveSpeed(self, speed):
		self.moveSpeed = speed
	#	reprap.cartesian.setMoveSpeed(self.moveSpeed)
	
	# Layer down a line of plastic (Move to start point, lower tool (if not already), deposit plastic in line to end point, stop depositing.)
	def extrudeLine(self, x1, y1, x2, y2):
		if x1 != x2 or y1 != y2:
			reprap.cartesian.seek( (x1, y1, False), speed = self.fastSpeed )
			self.lowerTool()
			reprap.extruder.setMotor(reprap.MOTOR_FORWARD, self.extrudeSpeed)
			reprap.cartesian.seek( (x2, y2, False), speed = self.moveSpeed )
			reprap.extruder.setMotor(reprap.MOTOR_FORWARD, 0)
		
	def reverseMotorStopFlow(self):
		reprap.extruder.setMotor(reprap.MOTOR_BACKWARD, self.extrudeSpeed)
		time.sleep(self.stopReverseMotorTime)
		reprap.extruder.setMotor(reprap.MOTOR_BACKWARD, 0)
	
	# Raise tool to safe moving height
	def raiseTool(self):
		reprap.cartesian.z.seek(self.currentLayerHeight - self.zIdleHeight, speed = self.fastSpeed)
	
	# Lower tool to current layer working height
	def lowerTool(self):
		reprap.cartesian.z.seek(self.currentLayerHeight, speed = self.fastSpeed)
