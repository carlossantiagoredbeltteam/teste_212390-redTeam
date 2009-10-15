//povray/Wineglass.pov

global_settings {
  assumed_gamma 1.0
}

#include "povray/Wineglass.inc"

background {color rgb <0.9, 0.9, 0.9>}

object { m_wineglass_no_central_hole

	rotate 90*x*clock
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

light_source { <93.5095, 35.371, 143.7588> color rgb 2 }

light_source { <-93.5095, -35.371, -143.7588> color rgb 2 }
//camera {
//  location  <0.0, 0.5, -4.0>
//  direction 1.5*z
//  right     x*image_width/image_height
//  look_at   <0.0, 0.0,  0.0>
//}

camera {
	perspective
	location <372.038, 139.484, 143.7588>
	look_at <186.019, 69.742, 71.8794>
	}
