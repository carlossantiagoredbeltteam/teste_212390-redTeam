#!/usr/bin/python

import xml.dom.minidom
from xml.dom.minidom import Node


class SMIL:
	def __init__(self, fileName, debug = False):
		self.fileName = fileName
		self.debug = debug
		self.readXML()
	
	def readXML(self):
		doc = xml.dom.minidom.parse(self.fileName)
		self.layers = []
		currentLayer = []
		for smilNode in doc.getElementsByTagName("SSIL"):
			self.version = smilNode.getAttribute("version")
			self.layerCount = smilNode.getAttribute("layers")
			self.units = smilNode.getAttribute("units")
			
			for layerNode in smilNode.getElementsByTagName("LAYER"):
				index = layerNode.getAttribute("index")
				if self.debug: print "Layer index", index
				for toolNode in layerNode.getElementsByTagName("TOOL"):
					name = toolNode.getAttribute("name")
					index = layerNode.getAttribute("index")
					if self.debug: print "Tool name",name , "index", index
					for polygonNode in toolNode.getElementsByTagName("POLYGON"):
						index = polygonNode.getAttribute("index")
						if self.debug: print "Polygon index", index
						polygon = []
						for d in polygonNode.childNodes:
							if d.nodeType == Node.TEXT_NODE:
								lines = d.data.splitlines()
								for l in lines:
									parts = l.split('\t')
									for i in range( parts.count('') ):
										parts.remove('')
									if len(parts) > 0:
										if self.debug: print parts
										if parts[0][0] == "X" and parts[1][0] == "Y":
											polygon.append( ( float(parts[0][ 1: ]), float(parts[1][ 1: ]) ) )
						if len(polygon):
							currentLayer.append(polygon)
				self.layers.append(currentLayer)

