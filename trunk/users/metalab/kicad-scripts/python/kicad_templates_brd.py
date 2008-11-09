KICAD_BRD_TEMPLATE = """PCBNEW-BOARD Version 1 date 9/11/2008-04:06:17

$GENERAL
LayerCount 2
Ly 1FFF8001
Links 0
NoConn 0
Di 37361 33774 41639 37726
Ndraw 0
Ntrack 7
Nzone 0
Nmodule 0
Nnets 0
$EndGENERAL

$SHEETDESCR
Sheet A4 11700 8267
Title ""
Date "9 nov 2008"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndSHEETDESCR

$SETUP
InternalUnit 0.000100 INCH
UserGridSize 0.010000 0.010000 mm
ZoneGridSize 250
Layers 2
Layer[0] Loetseite signal
Layer[15] BestSeite signal
TrackWidth 276
TrackWidthHistory 276
TrackClearence 60
ZoneClearence 150
DrawSegmWidth 150
EdgeSegmWidth 150
ViaSize 450
ViaDrill 250
ViaSizeHistory 450
MicroViaSize 200
MicroViaDrill 80
MicroViasAllowed 0
TextPcbWidth 120
TextPcbSize 600 800
EdgeModWidth 150
TextModSize 600 600
TextModWidth 120
PadSize 600 600
PadDrill 320
AuxiliaryAxisOrg 0 0
$EndSETUP

$TRACK
%(Content)s
$EndTRACK
$ZONE
$EndZONE
$EndBOARD
"""
