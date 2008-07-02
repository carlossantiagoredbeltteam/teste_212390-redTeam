#!/usr/bin/env python
# -*- coding: utf-8 -*-
# generated by wxGlade 0.6.3 on Sun Jun 29 13:01:49 2008

import wx, reprap.preferences

# begin wxGlade: extracode
# end wxGlade


class PreferencesDialog(wx.Dialog):
    def __init__(self, *args, **kwds):
        # begin wxGlade: PreferencesDialog.__init__
        kwds["style"] = wx.DEFAULT_DIALOG_STYLE
        wx.Dialog.__init__(self, *args, **kwds)
        self.panel_pref = PreferencesPanel(self, -1)
        self.button_cancel = wx.Button(self, wx.ID_CANCEL, "")
        self.button_ok = wx.Button(self, wx.ID_OK, "")

        self.__set_properties()
        self.__do_layout()

        self.Bind(wx.EVT_BUTTON, self.onClickCancel, self.button_cancel)
        self.Bind(wx.EVT_BUTTON, self.onClickOk, self.button_ok)
        # end wxGlade

    def __set_properties(self):
        # begin wxGlade: PreferencesDialog.__set_properties
        self.SetTitle("Plot Settings")
        self.button_ok.SetDefault()
        # end wxGlade

    def __do_layout(self):
        # begin wxGlade: PreferencesDialog.__do_layout
        sizer_main = wx.BoxSizer(wx.HORIZONTAL)
        sizer_border = wx.BoxSizer(wx.VERTICAL)
        sizer_buttons = wx.BoxSizer(wx.HORIZONTAL)
        sizer_border.Add(self.panel_pref, 1, wx.EXPAND, 10)
        sizer_border.Add((20, 20), 0, wx.ADJUST_MINSIZE, 0)
        sizer_buttons.Add(self.button_cancel, 0, wx.ALIGN_RIGHT|wx.ADJUST_MINSIZE, 1)
        sizer_buttons.Add(self.button_ok, 0, wx.ALIGN_RIGHT|wx.ADJUST_MINSIZE, 1)
        sizer_border.Add(sizer_buttons, 0, wx.RIGHT|wx.ALIGN_RIGHT, 10)
        sizer_main.Add(sizer_border, 1, wx.ALL|wx.EXPAND, 10)
        self.SetSizer(sizer_main)
        sizer_main.Fit(self)
        self.Layout()
        # end wxGlade

    def onClickCancel(self, event): # wxGlade: PreferencesDialog.<event_handler>
        self.EndModal(wx.CANCEL) 

    def onClickOk(self, event): # wxGlade: PreferencesDialog.<event_handler>
        self.panel_pref.savePrefValues()
        self.EndModal(wx.OK)

# end of class PreferencesDialog

class PreferencesPanel(wx.Panel):
    def __init__(self, *args, **kwds):
        # begin wxGlade: PreferencesPanel.__init__
        kwds["style"] = wx.TAB_TRAVERSAL
        wx.Panel.__init__(self, *args, **kwds)
        self.label_1 = wx.StaticText(self, -1, "Plot Mode :")
        self.choice_mode = wx.Choice(self, -1, choices=["Area Fill", "Isolation Traces"])

        self.__set_properties()
        self.__do_layout()
        # end wxGlade
        
        self.prefHandler = reprap.preferences.PreferenceHandler(self,  "plotter_gerber.conf")
        
        # default values for preferences
        self.pref_plotMode = 1
        self.prefHandler.load()
        self.setPrefValues()

    def __set_properties(self):
        # begin wxGlade: PreferencesPanel.__set_properties
        self.choice_mode.SetSelection(0)
        # end wxGlade

    def __do_layout(self):
        # begin wxGlade: PreferencesPanel.__do_layout
        sizer_panel_main = wx.BoxSizer(wx.VERTICAL)
        sizer_row = wx.BoxSizer(wx.HORIZONTAL)
        sizer_row.Add(self.label_1, 0, wx.ADJUST_MINSIZE, 0)
        sizer_row.Add((10, 10), 0, wx.ADJUST_MINSIZE, 0)
        sizer_row.Add(self.choice_mode, 0, wx.ADJUST_MINSIZE, 0)
        sizer_panel_main.Add(sizer_row, 1, wx.ALL|wx.EXPAND, 10)
        self.SetSizer(sizer_panel_main)
        sizer_panel_main.Fit(self)
        # end wxGlade
        
    # Set values of frame control
    def setPrefValues(self):
        self.choice_mode.SetSelection(self.pref_plotMode)
    
    def savePrefValues(self):
        self.pref_plotMode = int(self.choice_mode.GetSelection())
        self.prefHandler.save()

# end of class PreferencesPanel

if __name__ == "__main__":
    app = wx.PySimpleApp(0)
    wx.InitAllImageHandlers()
    dialog_2 = MyDialog(None, -1, "")
    app.SetTopWindow(dialog_2)
    dialog_2.Show()
    app.MainLoop()
