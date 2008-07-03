import os, sys

PLUGIN_IMPORT	= 1
PLUGIN_OUTPUT	= 2
PLUGIN_TOOLHEAD	= 3

if os.platform=="win32":
	# Windows
	pluginsPath = sys.path[0] + "/plugins"
else:
	# Linux
	pluginsPath = "/usr/share/reprap/plugins"

print "Plugins loading from path'" + pluginsPath + "'"

pluginsFolders = {PLUGIN_IMPORT:"import", PLUGIN_OUTPUT:"output", PLUGIN_TOOLHEAD:"toolhead"}

def loadPlugins(pluginsFolder, suffix):
	oldDir = os.getcwd()
	os.chdir(pluginsFolder)
	sys.path.append(pluginsFolder)
	plugins = []
	files = os.listdir(pluginsFolder)
	for p in files:
		if p[ -len(suffix): ] ==  suffix:
			newPlugin =  __import__( p[ :-3 ] ) 
			plugins.append(newPlugin)
			print "Loading plugin '" + newPlugin.Title + "' from file '" + p + "'"
	os.chdir(oldDir)
	sys.path.remove(pluginsFolder)
	return plugins

"""
def getPluginsList(pluginType):
	plugins = loadPlugins( os.path.join( pluginsPath, pluginsFolders[pluginType] ), "_" + pluginsFolders[pluginType] + ".py")
	pluginList = []
	for p in plugins:
		pluginList.append(p.Title)
	return pluginList
"""

def getPlugin(pluginType, index):
	plugins = loadPlugins( os.path.join( pluginsPath, pluginsFolders[pluginType] ), "_" + pluginsFolders[pluginType] + ".py")
	return plugins[index]

def getPlugins(pluginType):
	return loadPlugins( os.path.join( pluginsPath, pluginsFolders[pluginType] ), "_" + pluginsFolders[pluginType] + ".py")
	
def listTitles(plugins):
	pluginList = []
	for p in plugins:
		pluginList.append(p.Title)
	return pluginList
