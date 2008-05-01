"""
Code derived from a vague combination of :

BufferedCanvas -- Double-buffered, flicker-free canvas widget
Copyright (C) 2005, 2006 Daniel Keep
(GNU Lesser General Public License)

and

wxPython wiki : http://wiki.wxpython.org/IntegratingPyGame

"""


__license__ = """
This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public License as
published by the Free Software Foundation; either version 2.1 of the
License, or (at your option) any later version.

As a special exception, the copyright holders of this library 
hereby recind Section 3 of the GNU Lesser General Public License. This
means that you MAY NOT apply the terms of the ordinary GNU General 
Public License instead of this License to any given copy of the
Library. This has been done to prevent users of the Library from being
denied access or the ability to use future improvements.

This library is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser
General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
"""

"""
Example use:
class DrawCanvas(wxpygame.wxSDLPanel):

    def __init__( self, parent, ID=-1 ):
        wxpygame.wxSDLPanel.__init__( self, parent,ID )
        
    def draw( self ):
        surface = self.getSurface()
        if not surface is None:
            pygame.draw.circle( surface, (250, 0, 0), (100, 100), 50 )
            pygame.display.flip()

define this class in your wx script
"""



import wx, pygame, os, sys

class wxSDLPanel(wx.Panel):
    buffer = None
    backbuffer = None
    def __init__(self, parent, ID=-1, pos=wx.DefaultPosition, size=wx.DefaultSize, style=wx.NO_FULL_REPAINT_ON_RESIZE):
        wx.Panel.__init__(self,parent,ID,pos,size,style)
        self._initialized = 0
        self._resized = 0
        self._surface = None
        self.__needsDrawing = 1
        self.Bind(wx.EVT_IDLE, self.OnIdle)

    def OnIdle(self, ev):
        if not self._initialized or self._resized:
            if not self._initialized:
                # get the handle
                hwnd = self.GetHandle()
                
                os.environ['SDL_WINDOWID'] = str(hwnd)
                if sys.platform == 'win32':
                    os.environ['SDL_VIDEODRIVER'] = 'windib'
                
                pygame.init()
                
                self.Bind(wx.EVT_SIZE, self.OnSize)
                self.Bind(wx.EVT_MOTION, self.MouseMove)
                self.Bind(wx.EVT_LEFT_DOWN, self.OnMouseDown)
                self.Bind(wx.EVT_LEFT_UP, self.OnMouseUp)
                self.Bind(wx.EVT_MOUSEWHEEL, self.OnMouseWheel)
                self._initialized = 1
            else:
                self._resized = 0
            x,y = self.GetSizeTuple()
            self._surface = pygame.display.set_mode((x,y))

        if self.__needsDrawing:
            self.draw()

    def OnPaint(self, ev):
        self.__needsDrawing = 1

    def OnSize(self, ev):
        self._resized = 1

    def draw(self):
        raise NotImplementedError('please define a .draw() method!')

    def getSurface(self):
        return self._surface
        
    def update(self):
        self.Refresh()
        print "r"
        
    def MouseMove(self, event):
        raise NotImplementedError('please define a .MouseMove() method!')  
    def OnMouseDown(self, event):
        raise NotImplementedError('please define a .OnMouseDown() method!')  
    def OnMouseUp(self, event):
        raise NotImplementedError('please define a .OnMouseUp() method!')  
    def OnMouseWheel(self, event):
        raise NotImplementedError('please define a .OnMouseWheel() method!')  
    

#pygame.display.quit()




