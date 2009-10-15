//povray/Wineglass.pov

global_settings {
  assumed_gamma 1.0
}

#include "povray/Wineglass.inc"

background {color rgb <0.9, 0.9, 0.9>}

object { m_wineglass_no_central_hole

	rotate 90*x+90
	rotate 90*y*clock
	texture {
		pigment {color rgb <0.1, 0.6, 0.1> }
		finish {
			ambient 0.15
			diffuse 0.85
			specular 0.3
		}
	}

}

light_source { <93.5095, 35.371, 143.7588> color rgb 2 }

light_source { <-93.5095, -35.371, -143.7588> color rgb 2 }
//camera {
//  location  <0.0, 0.5, -4.0>
//  direction 1.5*z
//  right     x*image_width/image_height
//  look_at   <0.0, 0.0,  0.0>
//}
/*
#declare Jump_Start  = 0.5;
#declare Jump_Height = 7;
#if (clock < Jump_Start )
 #declare Camera_Y = 1.00;
#else
 #declare Camera_Y = 1.00
   + Jump_Height*
     0.5*(1-cos(4*pi*(clock-Jump_Start)));
#end

camera {
 angle 38
 location <3,Camera_Y,-20>
 right x*image_width/image_height
 look_at <-3,3,5>
 rotate<0,-360*(clock+0.1),0>
} //------------------- end of camera
*/

camera {
	perspective
	location <372.038, 139.484, 143.7588>
	look_at <186.019, 69.742, 71.8794>
	}

