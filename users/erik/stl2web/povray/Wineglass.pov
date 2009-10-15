//povray/Wineglass.pov

#include "povray/Wineglass.inc"

#include "axes_macro.inc"

background {color rgb <0.9, 0.9, 0.9>}

light_source { <372.038, 139.484, 143.7588> color rgb 2 }

light_source { <-372.038, -139.484, -143.7588> color rgb 2 }

camera {
	perspective
	location <372.038, 139.484, 143.7588>
	look_at <21.602, 34.871, 21.602>
	}
// the coordinate grid and axes
Axes_Macro
(
	100,	// Axes_axesSize,	The distance from the origin to one of the grid's edges.	(float)
	50,	// Axes_majUnit,	The size of each large-unit square.	(float)
	10,	// Axes_minUnit,	The number of small-unit squares that make up a large-unit square.	(integer)
	0.005,	// Axes_thickRatio,	The thickness of the grid lines (as a factor of axesSize).	(float)
	on,	// Axes_aBool,		Turns the axes on/off. (boolian)
	on,	// Axes_mBool,		Turns the minor units on/off. (boolian)
	off,	// Axes_xBool,		Turns the plane perpendicular to the x-axis on/off.	(boolian)
	on,	// Axes_yBool,		Turns the plane perpendicular to the y-axis on/off.	(boolian)
	off	// Axes_zBool,		Turns the plane perpendicular to the z-axis on/off.	(boolian)
)

object
{
	Axes_Object
	}
object { m_"wineglass_no_central_hole";

	rotate 90*y
	texture {
		pigment {color rgb <0.1, 0.6, 0.1> }
		finish {
			ambient 0.15
			diffuse 0.85
			specular 0.3
		}
	}

}

