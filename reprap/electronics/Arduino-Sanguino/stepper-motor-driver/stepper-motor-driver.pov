//POVRay-File created by 3d41.ulp v1.05
///home/hoeken/Desktop/reprap/trunk/reprap/electronics/Arduino-Sanguino/stepper-motor-driver/stepper-motor-driver.brd
//2/16/09 8:05 PM

#version 3.5;

//Set to on if the file should be used as .inc
#local use_file_as_inc = off;
#if(use_file_as_inc=off)


//changes the apperance of resistors (1 Blob / 0 real)
#declare global_res_shape = 1;
//randomize color of resistors 1=random 0=same color
#declare global_res_colselect = 0;
//Number of the color for the resistors
//0=Green, 1="normal color" 2=Blue 3=Brown
#declare global_res_col = 1;
//Set to on if you want to render the PCB upside-down
#declare pcb_upsidedown = off;
//Set to x or z to rotate around the corresponding axis (referring to pcb_upsidedown)
#declare pcb_rotdir = x;
//Set the length off short pins over the PCB
#declare pin_length = 2.5;
#declare global_diode_bend_radius = 1;
#declare global_res_bend_radius = 1;
#declare global_solder = on;

#declare global_show_screws = on;
#declare global_show_washers = on;
#declare global_show_nuts = on;

//Animation
#declare global_anim = off;
#local global_anim_showcampath = no;

#declare global_fast_mode = off;

#declare col_preset = 2;
#declare pin_short = on;

#declare environment = on;

#local cam_x = 0;
#local cam_y = 242;
#local cam_z = -129;
#local cam_a = 20;
#local cam_look_x = 0;
#local cam_look_y = -5;
#local cam_look_z = 0;

#local pcb_rotate_x = 0;
#local pcb_rotate_y = 0;
#local pcb_rotate_z = 0;

#local pcb_board = on;
#local pcb_parts = on;
#if(global_fast_mode=off)
	#local pcb_polygons = on;
	#local pcb_silkscreen = on;
	#local pcb_wires = on;
	#local pcb_pads_smds = on;
#else
	#local pcb_polygons = off;
	#local pcb_silkscreen = off;
	#local pcb_wires = off;
	#local pcb_pads_smds = off;
#end

#local lgt1_pos_x = 21;
#local lgt1_pos_y = 32;
#local lgt1_pos_z = 29;
#local lgt1_intense = 0.745527;
#local lgt2_pos_x = -21;
#local lgt2_pos_y = 32;
#local lgt2_pos_z = 29;
#local lgt2_intense = 0.745527;
#local lgt3_pos_x = 21;
#local lgt3_pos_y = 32;
#local lgt3_pos_z = -20;
#local lgt3_intense = 0.745527;
#local lgt4_pos_x = -21;
#local lgt4_pos_y = 32;
#local lgt4_pos_z = -20;
#local lgt4_intense = 0.745527;

//Do not change these values
#declare pcb_height = 1.500000;
#declare pcb_cuheight = 0.035000;
#declare pcb_x_size = 56.447000;
#declare pcb_y_size = 56.458000;
#declare pcb_layer1_used = 1;
#declare pcb_layer16_used = 1;
#declare inc_testmode = off;
#declare global_seed=seed(339);
#declare global_pcb_layer_dis = array[16]
{
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	1.535000,
}
#declare global_pcb_real_hole = 2.000000;

#include "tools.inc"
#include "user.inc"

global_settings{charset utf8}

#if(environment=on)
sky_sphere {pigment {Navy}
pigment {bozo turbulence 0.65 octaves 7 omega 0.7 lambda 2
color_map {
[0.0 0.1 color rgb <0.85, 0.85, 0.85> color rgb <0.75, 0.75, 0.75>]
[0.1 0.5 color rgb <0.75, 0.75, 0.75> color rgbt <1, 1, 1, 1>]
[0.5 1.0 color rgbt <1, 1, 1, 1> color rgbt <1, 1, 1, 1>]}
scale <0.1, 0.5, 0.1>} rotate -90*x}
plane{y, -10.0-max(pcb_x_size,pcb_y_size)*abs(max(sin((pcb_rotate_x/180)*pi),sin((pcb_rotate_z/180)*pi)))
texture{T_Chrome_2D
normal{waves 0.1 frequency 3000.0 scale 3000.0}} translate<0,0,0>}
#end

//Animation data
#if(global_anim=on)
#declare global_anim_showcampath = no;
#end

#if((global_anim=on)|(global_anim_showcampath=yes))
#declare global_anim_npoints_cam_flight=0;
#warning "No/not enough Animation Data available (min. 3 points) (Flight path)"
#end

#if((global_anim=on)|(global_anim_showcampath=yes))
#declare global_anim_npoints_cam_view=0;
#warning "No/not enough Animation Data available (min. 3 points) (View path)"
#end

#if((global_anim=on)|(global_anim_showcampath=yes))
#end

#if((global_anim_showcampath=yes)&(global_anim=off))
#end
#if(global_anim=on)
camera
{
	location global_anim_spline_cam_flight(clock)
	#if(global_anim_npoints_cam_view>2)
		look_at global_anim_spline_cam_view(clock)
	#else
		look_at global_anim_spline_cam_flight(clock+0.01)-<0,-0.01,0>
	#end
	angle 45
}
light_source
{
	global_anim_spline_cam_flight(clock)
	color rgb <1,1,1>
	spotlight point_at 
	#if(global_anim_npoints_cam_view>2)
		global_anim_spline_cam_view(clock)
	#else
		global_anim_spline_cam_flight(clock+0.01)-<0,-0.01,0>
	#end
	radius 35 falloff  40
}
#else
camera
{
	location <cam_x,cam_y,cam_z>
	look_at <cam_look_x,cam_look_y,cam_look_z>
	angle cam_a
	//translates the camera that <0,0,0> is over the Eagle <0,0>
	//translate<-28.223500,0,-28.229000>
}
#end

background{col_bgr}


//Axis uncomment to activate
//object{TOOLS_AXIS_XYZ(100,100,100 //texture{ pigment{rgb<1,0,0>} finish{diffuse 0.8 phong 1}}, //texture{ pigment{rgb<1,1,1>} finish{diffuse 0.8 phong 1}})}

light_source{<lgt1_pos_x,lgt1_pos_y,lgt1_pos_z> White*lgt1_intense}
light_source{<lgt2_pos_x,lgt2_pos_y,lgt2_pos_z> White*lgt2_intense}
light_source{<lgt3_pos_x,lgt3_pos_y,lgt3_pos_z> White*lgt3_intense}
light_source{<lgt4_pos_x,lgt4_pos_y,lgt4_pos_z> White*lgt4_intense}
#end


#macro STEPPER_MOTOR_DRIVER(mac_x_ver,mac_y_ver,mac_z_ver,mac_x_rot,mac_y_rot,mac_z_rot)
union{
#if(pcb_board = on)
difference{
union{
//Board
prism{-1.500000,0.000000,8
<41.948000,10.673000><98.295000,10.673000>
<98.295000,10.673000><98.295000,67.031000>
<98.295000,67.031000><41.848000,67.131000>
<41.848000,67.131000><41.948000,10.673000>
texture{col_brd}}
}//End union(Platine)
//Holes(real)/Parts
cylinder{<44.069000,1,52.324000><44.069000,-5,52.324000>1.625600 texture{col_hls}}
cylinder{<44.069000,1,40.894000><44.069000,-5,40.894000>1.625600 texture{col_hls}}
cylinder{<44.069000,1,36.703000><44.069000,-5,36.703000>1.625600 texture{col_hls}}
cylinder{<44.069000,1,25.273000><44.069000,-5,25.273000>1.625600 texture{col_hls}}
cylinder{<46.400000,1,62.400000><46.400000,-5,62.400000>2.500000 texture{col_hls}}
cylinder{<93.600000,1,62.400000><93.600000,-5,62.400000>2.500000 texture{col_hls}}
cylinder{<46.500000,1,15.300000><46.500000,-5,15.300000>2.500000 texture{col_hls}}
cylinder{<93.600000,1,15.300000><93.600000,-5,15.300000>2.500000 texture{col_hls}}
//Holes(real)/Board
//Holes(real)/Vias
}//End difference(reale Bohrungen/Durchbrüche)
#end
#if(pcb_parts=on)//Parts
union{
#ifndef(pack_C1) #declare global_pack_C1=yes; object {CAP_SMD_CHIP_1206(DarkWood)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-270.000000,0> rotate<0,0,0> translate<69.596000,0.000000,49.326800>translate<0,0.035000,0> }#end		//SMD Capacitor 1206 C1 100nF C1206
#ifndef(pack_C2) #declare global_pack_C2=yes; object {CAP_SMD_CHIP_1206(DarkWood)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-270.000000,0> rotate<0,0,0> translate<71.043800,0.000000,28.625800>translate<0,0.035000,0> }#end		//SMD Capacitor 1206 C2 1nF C1206K
#ifndef(pack_C3) #declare global_pack_C3=yes; object {CAP_SMD_CHIP_1206(DarkWood)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<64.770000,0.000000,49.326800>translate<0,0.035000,0> }#end		//SMD Capacitor 1206 C3 220nF C1206
#ifndef(pack_C4) #declare global_pack_C4=yes; object {CAP_SMD_CHIP_1206(DarkWood)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<67.183000,0.000000,49.326800>translate<0,0.035000,0> }#end		//SMD Capacitor 1206 C4 100nF C1206
#ifndef(pack_C6) #declare global_pack_C6=yes; object {CAP_SMD_CHIP_1206(DarkWood)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<81.686400,0.000000,51.917600>translate<0,0.035000,0> }#end		//SMD Capacitor 1206 C6 100nF C1206K
#ifndef(pack_C8) #declare global_pack_C8=yes; object {CAP_SMD_CHIP_1206(DarkWood)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<60.655200,0.000000,28.321000>translate<0,0.035000,0> }#end		//SMD Capacitor 1206 C8 100nF C1206K
#ifndef(pack_C12) #declare global_pack_C12=yes; object {CAP_SMD_CHIP_1206(DarkWood)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<86.785600,0.000000,19.510600>translate<0,0.035000,0> }#end		//SMD Capacitor 1206 C12 100nF C1206
#ifndef(pack_DRIVER) #declare global_pack_DRIVER=yes; object {IC_SMD_SO24W("A3982","",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<74.930000,0.000000,38.912800>translate<0,0.035000,0> }#end		//SMD IC SO24-Wide Package DRIVER A3982 SO24W
#ifndef(pack_IC3) #declare global_pack_IC3=yes; object {TR_TO252("7805DT","",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<59.969400,0.000000,47.523400>translate<0,0.035000,0> }#end		//TO252 IC3 7805DT TO252
#ifndef(pack_R2) #declare global_pack_R2=yes; object {RES_SMD_CHIP_1206("103",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<75.946000,0.000000,51.790600>translate<0,0.035000,0> }#end		//SMD Resistor 1206 R2 10K R1206
#ifndef(pack_R5) #declare global_pack_R5=yes; object {RES_SMD_CHIP_1206("102",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-270.000000,0> rotate<0,0,0> translate<86.203000,0.000000,27.346800>translate<0,0.035000,0> }#end		//SMD Resistor 1206 R5 1K R1206
#ifndef(pack_R6) #declare global_pack_R6=yes; object {RES_SMD_CHIP_1206("222",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<68.199000,0.000000,28.498800>translate<0,0.035000,0> }#end		//SMD Resistor 1206 R6 2.2K R1206
#ifndef(pack_R7) #declare global_pack_R7=yes; object {RES_SMD_CHIP_1206("102",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<54.381400,0.000000,61.899800>translate<0,0.035000,0> }#end		//SMD Resistor 1206 R7 1K R1206
#ifndef(pack_R8) #declare global_pack_R8=yes; object {RES_SMD_CHIP_1206("102",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<86.224000,0.000000,50.048800>translate<0,0.035000,0> }#end		//SMD Resistor 1206 R8 1K R1206
#ifndef(pack_R17) #declare global_pack_R17=yes; object {RES_SMD_CHIP_1206("102",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<69.672200,0.000000,24.231600>translate<0,0.035000,0> }#end		//SMD Resistor 1206 R17 1K R1206
#ifndef(pack_SV1) #declare global_pack_SV1=yes; object {CON_DIS_WS10G()translate<0,0,0> rotate<0,180.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<66.167000,0.000000,15.240000>}#end		//Shrouded Header 10Pin SV1  ML10
}//End union
#end
#if(pcb_pads_smds=on)
//Pads&SMD/Parts
object{TOOLS_PCB_SMD(1.600000,1.800000,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<69.596000,0.000000,50.726800>}
object{TOOLS_PCB_SMD(1.600000,1.800000,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<69.596000,0.000000,47.926800>}
object{TOOLS_PCB_SMD(1.500000,2.000000,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<71.043800,0.000000,30.125800>}
object{TOOLS_PCB_SMD(1.500000,2.000000,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<71.043800,0.000000,27.125800>}
object{TOOLS_PCB_SMD(1.600000,1.800000,0.037000,0) rotate<0,-90.000000,0> texture{col_pds} translate<64.770000,0.000000,47.926800>}
object{TOOLS_PCB_SMD(1.600000,1.800000,0.037000,0) rotate<0,-90.000000,0> texture{col_pds} translate<64.770000,0.000000,50.726800>}
object{TOOLS_PCB_SMD(1.600000,1.800000,0.037000,0) rotate<0,-90.000000,0> texture{col_pds} translate<67.183000,0.000000,47.926800>}
object{TOOLS_PCB_SMD(1.600000,1.800000,0.037000,0) rotate<0,-90.000000,0> texture{col_pds} translate<67.183000,0.000000,50.726800>}
object{TOOLS_PCB_SMD(1.500000,2.000000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<80.186400,0.000000,51.917600>}
object{TOOLS_PCB_SMD(1.500000,2.000000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<83.186400,0.000000,51.917600>}
object{TOOLS_PCB_SMD(1.500000,2.000000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<59.155200,0.000000,28.321000>}
object{TOOLS_PCB_SMD(1.500000,2.000000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<62.155200,0.000000,28.321000>}
object{TOOLS_PCB_SMD(3.600000,1.300000,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<84.150200,0.000000,56.196800>}
object{TOOLS_PCB_SMD(3.600000,1.300000,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<84.150200,0.000000,64.071800>}
object{TOOLS_PCB_SMD(3.600000,1.300000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<57.060400,0.000000,36.322000>}
object{TOOLS_PCB_SMD(3.600000,1.300000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<64.935400,0.000000,36.322000>}
object{TOOLS_PCB_SMD(1.600000,1.800000,0.037000,0) rotate<0,-90.000000,0> texture{col_pds} translate<86.785600,0.000000,18.110600>}
object{TOOLS_PCB_SMD(1.600000,1.800000,0.037000,0) rotate<0,-90.000000,0> texture{col_pds} translate<86.785600,0.000000,20.910600>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<81.915000,0.000000,43.512800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<80.645000,0.000000,43.512800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<79.375000,0.000000,43.512800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<78.105000,0.000000,43.512800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<76.835000,0.000000,43.512800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<75.565000,0.000000,43.512800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<74.295000,0.000000,43.512800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<73.025000,0.000000,43.512800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<71.755000,0.000000,43.512800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<70.485000,0.000000,43.512800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<69.215000,0.000000,43.512800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<67.945000,0.000000,43.512800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<67.945000,0.000000,34.312800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<69.215000,0.000000,34.312800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<70.485000,0.000000,34.312800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<71.755000,0.000000,34.312800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<73.025000,0.000000,34.312800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<74.295000,0.000000,34.312800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<75.565000,0.000000,34.312800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<76.835000,0.000000,34.312800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<78.105000,0.000000,34.312800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<79.375000,0.000000,34.312800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<80.645000,0.000000,34.312800>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<81.915000,0.000000,34.312800>}
object{TOOLS_PCB_SMD(1.000000,1.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<62.249400,0.000000,52.323400>}
object{TOOLS_PCB_SMD(1.000000,1.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<57.689400,0.000000,52.323400>}
object{TOOLS_PCB_SMD(5.400000,6.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<59.969400,0.000000,45.023400>}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.498600,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<50.419000,0,51.054000> texture{col_thl}}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.498600,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<52.959000,0,49.784000> texture{col_thl}}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.498600,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<50.419000,0,48.514000> texture{col_thl}}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.498600,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<52.959000,0,47.244000> texture{col_thl}}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.498600,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<50.419000,0,45.974000> texture{col_thl}}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.498600,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<52.959000,0,44.704000> texture{col_thl}}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.498600,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<50.419000,0,43.434000> texture{col_thl}}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.498600,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<52.959000,0,42.164000> texture{col_thl}}
#ifndef(global_pack_J2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.498600,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<50.419000,0,35.433000> texture{col_thl}}
#ifndef(global_pack_J2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.498600,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<52.959000,0,34.163000> texture{col_thl}}
#ifndef(global_pack_J2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.498600,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<50.419000,0,32.893000> texture{col_thl}}
#ifndef(global_pack_J2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.498600,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<52.959000,0,31.623000> texture{col_thl}}
#ifndef(global_pack_J2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.498600,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<50.419000,0,30.353000> texture{col_thl}}
#ifndef(global_pack_J2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.498600,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<52.959000,0,29.083000> texture{col_thl}}
#ifndef(global_pack_J2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.498600,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<50.419000,0,27.813000> texture{col_thl}}
#ifndef(global_pack_J2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.498600,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<52.959000,0,26.543000> texture{col_thl}}
object{TOOLS_PCB_SMD(1.500000,1.500000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<52.050000,0.000000,60.096000>}
object{TOOLS_PCB_SMD(1.500000,1.500000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<52.050000,0.000000,63.596000>}
object{TOOLS_PCB_SMD(1.500000,1.500000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<94.234000,0.000000,25.478800>}
object{TOOLS_PCB_SMD(1.500000,1.500000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<94.234000,0.000000,28.978800>}
object{TOOLS_PCB_SMD(1.500000,1.500000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<90.297000,0.000000,28.978800>}
object{TOOLS_PCB_SMD(1.500000,1.500000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<90.297000,0.000000,25.478800>}
object{TOOLS_PCB_SMD(1.500000,1.500000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<94.234000,0.000000,51.838800>}
object{TOOLS_PCB_SMD(1.500000,1.500000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<94.234000,0.000000,48.338800>}
object{TOOLS_PCB_SMD(1.500000,1.500000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<90.297000,0.000000,48.338800>}
object{TOOLS_PCB_SMD(1.500000,1.500000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<90.297000,0.000000,51.838800>}
#ifndef(global_pack_POWER) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.600000,1.600000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<59.613800,0,60.121800> texture{col_thl}}
#ifndef(global_pack_POWER) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.600000,1.600000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<64.693800,0,60.121800> texture{col_thl}}
#ifndef(global_pack_POWER) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.600000,1.600000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<69.773800,0,60.121800> texture{col_thl}}
#ifndef(global_pack_POWER) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.600000,1.600000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<74.853800,0,60.121800> texture{col_thl}}
#ifndef(global_pack_R1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<83.030000,0,19.670000> texture{col_thl}}
#ifndef(global_pack_R1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<77.950000,0,19.670000> texture{col_thl}}
#ifndef(global_pack_R1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<80.490000,0,17.130000> texture{col_thl}}
object{TOOLS_PCB_SMD(1.600000,1.803000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<74.524000,0.000000,51.790600>}
object{TOOLS_PCB_SMD(1.600000,1.803000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<77.368000,0.000000,51.790600>}
object{TOOLS_PCB_SMD(1.800000,3.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<81.057400,0.000000,30.022800>}
object{TOOLS_PCB_SMD(1.800000,3.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<75.457400,0.000000,30.022800>}
object{TOOLS_PCB_SMD(1.600000,1.803000,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<86.203000,0.000000,28.768800>}
object{TOOLS_PCB_SMD(1.600000,1.803000,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<86.203000,0.000000,25.924800>}
object{TOOLS_PCB_SMD(1.600000,1.803000,0.037000,0) rotate<0,-90.000000,0> texture{col_pds} translate<68.199000,0.000000,27.076800>}
object{TOOLS_PCB_SMD(1.600000,1.803000,0.037000,0) rotate<0,-90.000000,0> texture{col_pds} translate<68.199000,0.000000,29.920800>}
object{TOOLS_PCB_SMD(1.600000,1.803000,0.037000,0) rotate<0,-90.000000,0> texture{col_pds} translate<54.381400,0.000000,60.477800>}
object{TOOLS_PCB_SMD(1.600000,1.803000,0.037000,0) rotate<0,-90.000000,0> texture{col_pds} translate<54.381400,0.000000,63.321800>}
object{TOOLS_PCB_SMD(1.600000,1.803000,0.037000,0) rotate<0,-90.000000,0> texture{col_pds} translate<86.224000,0.000000,48.626800>}
object{TOOLS_PCB_SMD(1.600000,1.803000,0.037000,0) rotate<0,-90.000000,0> texture{col_pds} translate<86.224000,0.000000,51.470800>}
object{TOOLS_PCB_SMD(1.800000,3.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<81.286000,0.000000,48.336200>}
object{TOOLS_PCB_SMD(1.800000,3.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<75.686000,0.000000,48.336200>}
object{TOOLS_PCB_SMD(1.600000,1.803000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<68.250200,0.000000,24.231600>}
object{TOOLS_PCB_SMD(1.600000,1.803000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<71.094200,0.000000,24.231600>}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,0.914400,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<61.087000,0,13.970000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,0.914400,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<61.087000,0,16.510000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,0.914400,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<63.627000,0,13.970000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,0.914400,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<63.627000,0,16.510000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,0.914400,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<66.167000,0,13.970000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,0.914400,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<66.167000,0,16.510000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,0.914400,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<68.707000,0,13.970000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,0.914400,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<68.707000,0,16.510000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,0.914400,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<71.247000,0,13.970000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,0.914400,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<71.247000,0,16.510000> texture{col_thl}}
#ifndef(global_pack_TP1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.159000,1.320800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<80.519800,0,13.962400> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.550000,1.700000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<90.170000,0,32.718800> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.550000,1.700000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<90.170000,0,36.678800> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.550000,1.700000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<90.170000,0,40.638800> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.550000,1.700000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<90.170000,0,44.598800> texture{col_thl}}
#ifndef(global_pack_X2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.609600,1.000000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<45.974000,0,49.149000> texture{col_thl}}
#ifndef(global_pack_X2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.609600,1.000000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<45.974000,0,46.609000> texture{col_thl}}
#ifndef(global_pack_X2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.609600,1.000000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<45.974000,0,44.069000> texture{col_thl}}
#ifndef(global_pack_X3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.609600,1.000000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<45.974000,0,33.528000> texture{col_thl}}
#ifndef(global_pack_X3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.609600,1.000000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<45.974000,0,30.988000> texture{col_thl}}
#ifndef(global_pack_X3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.609600,1.000000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<45.974000,0,28.448000> texture{col_thl}}
//Pads/Vias
object{TOOLS_PCB_VIA(1.108000,0.600000,1,16,1,0) translate<78.105000,0,32.385000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.108000,0.600000,1,16,1,0) translate<77.978000,0,45.440600> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.508000,1,16,1,0) translate<77.038200,0,36.398200> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.508000,1,16,1,0) translate<65.862200,0,25.577800> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.508000,1,16,1,0) translate<77.038200,0,41.173400> texture{col_thl}}
object{TOOLS_PCB_VIA(1.117600,0.609600,1,16,1,0) translate<59.309000,0,40.767000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.508000,1,16,1,0) translate<65.481200,0,21.742400> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.508000,1,16,1,0) translate<63.652400,0,23.571200> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.508000,1,16,1,0) translate<63.017400,0,21.615400> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.508000,1,16,1,0) translate<67.767200,0,22.301200> texture{col_thl}}
object{TOOLS_PCB_VIA(1.117600,0.609600,1,16,1,0) translate<67.183000,0,52.705000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.508000,1,16,1,0) translate<74.498200,0,53.416200> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.508000,1,16,1,0) translate<66.421000,0,43.611800> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.508000,1,16,1,0) translate<66.421000,0,33.959800> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.508000,1,16,1,0) translate<60.833000,0,34.975800> texture{col_thl}}
#end
#if(pcb_wires=on)
union{
//Signals
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<45.974000,-1.535000,30.988000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<47.294800,-1.535000,31.597600>}
box{<0,0,-0.190500><1.454691,0.035000,0.190500> rotate<0,-24.773506,0> translate<45.974000,-1.535000,30.988000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<45.974000,-1.535000,46.609000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<47.294800,-1.535000,47.218600>}
box{<0,0,-0.190500><1.454691,0.035000,0.190500> rotate<0,-24.773506,0> translate<45.974000,-1.535000,46.609000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<45.974000,0.000000,28.448000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<47.371000,0.000000,28.067000>}
box{<0,0,-0.317500><1.448023,0.035000,0.317500> rotate<0,15.254112,0> translate<45.974000,0.000000,28.448000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<45.974000,0.000000,44.069000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<47.371000,0.000000,43.688000>}
box{<0,0,-0.317500><1.448023,0.035000,0.317500> rotate<0,15.254112,0> translate<45.974000,0.000000,44.069000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<45.974000,0.000000,33.528000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<47.574200,0.000000,33.858200>}
box{<0,0,-0.190500><1.633913,0.035000,0.190500> rotate<0,-11.658523,0> translate<45.974000,0.000000,33.528000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<45.974000,0.000000,49.149000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<47.574200,0.000000,49.479200>}
box{<0,0,-0.190500><1.633913,0.035000,0.190500> rotate<0,-11.658523,0> translate<45.974000,0.000000,49.149000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<47.574200,0.000000,33.858200>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<49.758600,0.000000,33.858200>}
box{<0,0,-0.190500><2.184400,0.035000,0.190500> rotate<0,0.000000,0> translate<47.574200,0.000000,33.858200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<49.758600,0.000000,34.036000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<49.758600,0.000000,33.858200>}
box{<0,0,-0.190500><0.177800,0.035000,0.190500> rotate<0,-90.000000,0> translate<49.758600,0.000000,33.858200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<47.574200,0.000000,49.479200>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<49.758600,0.000000,49.479200>}
box{<0,0,-0.190500><2.184400,0.035000,0.190500> rotate<0,0.000000,0> translate<47.574200,0.000000,49.479200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<49.758600,0.000000,49.657000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<49.758600,0.000000,49.479200>}
box{<0,0,-0.190500><0.177800,0.035000,0.190500> rotate<0,-90.000000,0> translate<49.758600,0.000000,49.479200> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<47.371000,0.000000,28.067000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<49.784000,0.000000,28.067000>}
box{<0,0,-0.317500><2.413000,0.035000,0.317500> rotate<0,0.000000,0> translate<47.371000,0.000000,28.067000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<47.371000,0.000000,43.688000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<49.784000,0.000000,43.688000>}
box{<0,0,-0.317500><2.413000,0.035000,0.317500> rotate<0,0.000000,0> translate<47.371000,0.000000,43.688000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<49.784000,0.000000,28.067000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<50.419000,0.000000,27.813000>}
box{<0,0,-0.317500><0.683916,0.035000,0.317500> rotate<0,21.799971,0> translate<49.784000,0.000000,28.067000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<49.784000,0.000000,43.688000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<50.419000,0.000000,43.434000>}
box{<0,0,-0.317500><0.683916,0.035000,0.317500> rotate<0,21.799971,0> translate<49.784000,0.000000,43.688000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<47.294800,-1.535000,31.597600>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<50.825400,-1.535000,31.597600>}
box{<0,0,-0.190500><3.530600,0.035000,0.190500> rotate<0,0.000000,0> translate<47.294800,-1.535000,31.597600> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<47.294800,-1.535000,47.218600>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<50.825400,-1.535000,47.218600>}
box{<0,0,-0.190500><3.530600,0.035000,0.190500> rotate<0,0.000000,0> translate<47.294800,-1.535000,47.218600> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<49.758600,0.000000,34.036000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<50.927000,0.000000,34.036000>}
box{<0,0,-0.190500><1.168400,0.035000,0.190500> rotate<0,0.000000,0> translate<49.758600,0.000000,34.036000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<49.758600,0.000000,49.657000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<50.927000,0.000000,49.657000>}
box{<0,0,-0.190500><1.168400,0.035000,0.190500> rotate<0,0.000000,0> translate<49.758600,0.000000,49.657000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<50.419000,0.000000,27.813000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<51.054000,0.000000,27.559000>}
box{<0,0,-0.317500><0.683916,0.035000,0.317500> rotate<0,21.799971,0> translate<50.419000,0.000000,27.813000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<50.419000,0.000000,43.434000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<51.054000,0.000000,43.688000>}
box{<0,0,-0.317500><0.683916,0.035000,0.317500> rotate<0,-21.799971,0> translate<50.419000,0.000000,43.434000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<50.419000,0.000000,30.353000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<51.155600,0.000000,30.657800>}
box{<0,0,-0.190500><0.797172,0.035000,0.190500> rotate<0,-22.477951,0> translate<50.419000,0.000000,30.353000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<50.419000,0.000000,45.974000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<51.155600,0.000000,46.278800>}
box{<0,0,-0.190500><0.797172,0.035000,0.190500> rotate<0,-22.477951,0> translate<50.419000,0.000000,45.974000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.050000,0.000000,60.152600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.050000,0.000000,60.096000>}
box{<0,0,-0.406400><0.056600,0.035000,0.406400> rotate<0,-90.000000,0> translate<52.050000,0.000000,60.096000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.050000,0.000000,60.152600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.070000,0.000000,60.172600>}
box{<0,0,-0.406400><0.028284,0.035000,0.406400> rotate<0,-44.997030,0> translate<52.050000,0.000000,60.152600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.070000,0.000000,60.172600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.095400,0.000000,60.147200>}
box{<0,0,-0.406400><0.035921,0.035000,0.406400> rotate<0,44.997030,0> translate<52.070000,0.000000,60.172600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.095400,0.000000,58.115200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.095400,0.000000,60.147200>}
box{<0,0,-0.406400><2.032000,0.035000,0.406400> rotate<0,90.000000,0> translate<52.095400,0.000000,60.147200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<51.155600,0.000000,30.657800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<52.222400,0.000000,31.724600>}
box{<0,0,-0.190500><1.508683,0.035000,0.190500> rotate<0,-44.997030,0> translate<51.155600,0.000000,30.657800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<51.155600,0.000000,46.278800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<52.222400,0.000000,47.345600>}
box{<0,0,-0.190500><1.508683,0.035000,0.190500> rotate<0,-44.997030,0> translate<51.155600,0.000000,46.278800> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<51.054000,0.000000,27.559000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<52.324000,0.000000,26.289000>}
box{<0,0,-0.317500><1.796051,0.035000,0.317500> rotate<0,44.997030,0> translate<51.054000,0.000000,27.559000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<51.054000,0.000000,43.688000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<52.324000,0.000000,42.418000>}
box{<0,0,-0.317500><1.796051,0.035000,0.317500> rotate<0,44.997030,0> translate<51.054000,0.000000,43.688000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<50.825400,-1.535000,31.597600>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<52.628800,-1.535000,29.794200>}
box{<0,0,-0.190500><2.550393,0.035000,0.190500> rotate<0,44.997030,0> translate<50.825400,-1.535000,31.597600> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<50.927000,0.000000,34.036000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<52.628800,0.000000,32.334200>}
box{<0,0,-0.190500><2.406709,0.035000,0.190500> rotate<0,44.997030,0> translate<50.927000,0.000000,34.036000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<50.825400,-1.535000,47.218600>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<52.628800,-1.535000,45.415200>}
box{<0,0,-0.190500><2.550393,0.035000,0.190500> rotate<0,44.997030,0> translate<50.825400,-1.535000,47.218600> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<50.927000,0.000000,49.657000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<52.628800,0.000000,47.955200>}
box{<0,0,-0.190500><2.406709,0.035000,0.190500> rotate<0,44.997030,0> translate<50.927000,0.000000,49.657000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<52.324000,0.000000,26.289000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<52.959000,0.000000,26.543000>}
box{<0,0,-0.317500><0.683916,0.035000,0.317500> rotate<0,-21.799971,0> translate<52.324000,0.000000,26.289000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<52.628800,-1.535000,29.794200>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<52.959000,-1.535000,29.083000>}
box{<0,0,-0.190500><0.784116,0.035000,0.190500> rotate<0,65.090935,0> translate<52.628800,-1.535000,29.794200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<52.222400,0.000000,31.724600>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<52.959000,0.000000,31.623000>}
box{<0,0,-0.190500><0.743574,0.035000,0.190500> rotate<0,7.852795,0> translate<52.222400,0.000000,31.724600> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<52.628800,0.000000,32.334200>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<52.959000,0.000000,31.623000>}
box{<0,0,-0.190500><0.784116,0.035000,0.190500> rotate<0,65.090935,0> translate<52.628800,0.000000,32.334200> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<52.324000,0.000000,42.418000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<52.959000,0.000000,42.164000>}
box{<0,0,-0.317500><0.683916,0.035000,0.317500> rotate<0,21.799971,0> translate<52.324000,0.000000,42.418000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<52.628800,-1.535000,45.415200>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<52.959000,-1.535000,44.704000>}
box{<0,0,-0.190500><0.784116,0.035000,0.190500> rotate<0,65.090935,0> translate<52.628800,-1.535000,45.415200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<52.222400,0.000000,47.345600>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<52.959000,0.000000,47.244000>}
box{<0,0,-0.190500><0.743574,0.035000,0.190500> rotate<0,7.852795,0> translate<52.222400,0.000000,47.345600> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<52.628800,0.000000,47.955200>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<52.959000,0.000000,47.244000>}
box{<0,0,-0.190500><0.784116,0.035000,0.190500> rotate<0,65.090935,0> translate<52.628800,0.000000,47.955200> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<52.959000,0.000000,26.543000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<53.594000,0.000000,26.289000>}
box{<0,0,-0.317500><0.683916,0.035000,0.317500> rotate<0,21.799971,0> translate<52.959000,0.000000,26.543000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<52.959000,-1.535000,42.164000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<53.594000,-1.535000,41.910000>}
box{<0,0,-0.317500><0.683916,0.035000,0.317500> rotate<0,21.799971,0> translate<52.959000,-1.535000,42.164000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<52.959000,-1.535000,29.083000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<53.695600,-1.535000,28.778200>}
box{<0,0,-0.190500><0.797172,0.035000,0.190500> rotate<0,22.477951,0> translate<52.959000,-1.535000,29.083000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<52.959000,0.000000,31.623000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<53.695600,0.000000,31.318200>}
box{<0,0,-0.190500><0.797172,0.035000,0.190500> rotate<0,22.477951,0> translate<52.959000,0.000000,31.623000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<52.959000,-1.535000,44.704000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<53.695600,-1.535000,44.399200>}
box{<0,0,-0.190500><0.797172,0.035000,0.190500> rotate<0,22.477951,0> translate<52.959000,-1.535000,44.704000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<52.959000,0.000000,47.244000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<53.695600,0.000000,47.548800>}
box{<0,0,-0.190500><0.797172,0.035000,0.190500> rotate<0,-22.477951,0> translate<52.959000,0.000000,47.244000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.050000,0.000000,63.596000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<54.082200,0.000000,63.596000>}
box{<0,0,-0.406400><2.032200,0.035000,0.406400> rotate<0,0.000000,0> translate<52.050000,0.000000,63.596000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<54.082200,0.000000,63.596000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<54.483000,0.000000,63.195200>}
box{<0,0,-0.406400><0.566817,0.035000,0.406400> rotate<0,44.997030,0> translate<54.082200,0.000000,63.596000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<54.381400,0.000000,60.477800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<54.508400,0.000000,59.334400>}
box{<0,0,-0.406400><1.150431,0.035000,0.406400> rotate<0,83.656487,0> translate<54.381400,0.000000,60.477800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<54.381400,0.000000,63.321800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<54.508400,0.000000,63.220600>}
box{<0,0,-0.406400><0.162390,0.035000,0.406400> rotate<0,38.547059,0> translate<54.381400,0.000000,63.321800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<54.483000,0.000000,63.195200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<54.508400,0.000000,63.220600>}
box{<0,0,-0.406400><0.035921,0.035000,0.406400> rotate<0,-44.997030,0> translate<54.483000,0.000000,63.195200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<53.695600,-1.535000,28.778200>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<55.295800,-1.535000,28.778200>}
box{<0,0,-0.190500><1.600200,0.035000,0.190500> rotate<0,0.000000,0> translate<53.695600,-1.535000,28.778200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<53.695600,0.000000,47.548800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<56.108600,0.000000,47.548800>}
box{<0,0,-0.190500><2.413000,0.035000,0.190500> rotate<0,0.000000,0> translate<53.695600,0.000000,47.548800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<56.108600,0.000000,41.300400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<56.108600,0.000000,47.548800>}
box{<0,0,-0.406400><6.248400,0.035000,0.406400> rotate<0,90.000000,0> translate<56.108600,0.000000,47.548800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<56.108600,0.000000,47.548800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<56.108600,0.000000,50.901600>}
box{<0,0,-0.406400><3.352800,0.035000,0.406400> rotate<0,90.000000,0> translate<56.108600,0.000000,50.901600> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<53.695600,0.000000,31.318200>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<56.515000,0.000000,29.794200>}
box{<0,0,-0.190500><3.204933,0.035000,0.190500> rotate<0,28.391146,0> translate<53.695600,0.000000,31.318200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.095400,0.000000,58.115200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<57.689400,0.000000,53.537200>}
box{<0,0,-0.406400><7.228480,0.035000,0.406400> rotate<0,39.293506,0> translate<52.095400,0.000000,58.115200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<57.689400,0.000000,52.323400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<57.689400,0.000000,53.537200>}
box{<0,0,-0.406400><1.213800,0.035000,0.406400> rotate<0,90.000000,0> translate<57.689400,0.000000,53.537200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<53.695600,-1.535000,44.399200>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<57.734200,-1.535000,44.399200>}
box{<0,0,-0.190500><4.038600,0.035000,0.190500> rotate<0,0.000000,0> translate<53.695600,-1.535000,44.399200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<57.689400,0.000000,52.323400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<57.734800,0.000000,52.323400>}
box{<0,0,-0.406400><0.045400,0.035000,0.406400> rotate<0,0.000000,0> translate<57.689400,0.000000,52.323400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<56.108600,0.000000,41.300400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<57.759600,0.000000,39.903400>}
box{<0,0,-0.406400><2.162732,0.035000,0.406400> rotate<0,40.233703,0> translate<56.108600,0.000000,41.300400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<57.759600,0.000000,37.414200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<57.759600,0.000000,39.903400>}
box{<0,0,-0.406400><2.489200,0.035000,0.406400> rotate<0,90.000000,0> translate<57.759600,0.000000,39.903400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<56.108600,0.000000,50.901600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<57.759600,0.000000,52.298600>}
box{<0,0,-0.406400><2.162732,0.035000,0.406400> rotate<0,-40.233703,0> translate<56.108600,0.000000,50.901600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<57.734800,0.000000,52.323400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<57.759600,0.000000,52.298600>}
box{<0,0,-0.406400><0.035072,0.035000,0.406400> rotate<0,44.997030,0> translate<57.734800,0.000000,52.323400> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<53.594000,0.000000,26.289000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<57.785000,0.000000,26.289000>}
box{<0,0,-0.317500><4.191000,0.035000,0.317500> rotate<0,0.000000,0> translate<53.594000,0.000000,26.289000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<57.759600,0.000000,37.414200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<57.873900,0.000000,37.299900>}
box{<0,0,-0.406400><0.161645,0.035000,0.406400> rotate<0,44.997030,0> translate<57.759600,0.000000,37.414200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<57.060400,0.000000,36.322000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<57.912000,0.000000,37.338000>}
box{<0,0,-0.190500><1.325699,0.035000,0.190500> rotate<0,-50.027330,0> translate<57.060400,0.000000,36.322000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<57.873900,0.000000,37.299900>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<57.912000,0.000000,37.338000>}
box{<0,0,-0.190500><0.053882,0.035000,0.190500> rotate<0,-44.997030,0> translate<57.873900,0.000000,37.299900> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<53.594000,-1.535000,41.910000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<58.420000,-1.535000,41.910000>}
box{<0,0,-0.317500><4.826000,0.035000,0.317500> rotate<0,0.000000,0> translate<53.594000,-1.535000,41.910000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<58.775600,-1.535000,34.721800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<58.775600,-1.535000,38.430200>}
box{<0,0,-0.190500><3.708400,0.035000,0.190500> rotate<0,90.000000,0> translate<58.775600,-1.535000,38.430200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<56.515000,0.000000,29.794200>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<59.155200,0.000000,28.321000>}
box{<0,0,-0.190500><3.023404,0.035000,0.190500> rotate<0,29.159070,0> translate<56.515000,0.000000,29.794200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<59.155200,0.000000,28.321000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<59.282200,0.000000,35.102800>}
box{<0,0,-0.406400><6.782989,0.035000,0.406400> rotate<0,-88.921302,0> translate<59.155200,0.000000,28.321000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<57.873900,0.000000,37.299900>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<59.282200,0.000000,35.891600>}
box{<0,0,-0.406400><1.991637,0.035000,0.406400> rotate<0,44.997030,0> translate<57.873900,0.000000,37.299900> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<59.282200,0.000000,35.102800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<59.282200,0.000000,35.891600>}
box{<0,0,-0.406400><0.788800,0.035000,0.406400> rotate<0,90.000000,0> translate<59.282200,0.000000,35.891600> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<58.420000,-1.535000,41.910000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<59.309000,-1.535000,40.767000>}
box{<0,0,-0.317500><1.448023,0.035000,0.317500> rotate<0,52.121576,0> translate<58.420000,-1.535000,41.910000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<59.309000,0.000000,40.767000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<59.690000,0.000000,41.148000>}
box{<0,0,-0.317500><0.538815,0.035000,0.317500> rotate<0,-44.997030,0> translate<59.309000,0.000000,40.767000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<59.690000,0.000000,41.148000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<59.969400,0.000000,41.402000>}
box{<0,0,-0.317500><0.377598,0.035000,0.317500> rotate<0,-42.270899,0> translate<59.690000,0.000000,41.148000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<59.944000,0.000000,45.085000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<59.969400,0.000000,45.008800>}
box{<0,0,-0.317500><0.080322,0.035000,0.317500> rotate<0,71.560328,0> translate<59.944000,0.000000,45.085000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<59.969400,0.000000,41.402000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<59.969400,0.000000,45.008800>}
box{<0,0,-0.406400><3.606800,0.035000,0.406400> rotate<0,90.000000,0> translate<59.969400,0.000000,45.008800> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<59.944000,0.000000,45.085000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<59.969400,0.000000,45.023400>}
box{<0,0,-0.317500><0.066631,0.035000,0.317500> rotate<0,67.587341,0> translate<59.944000,0.000000,45.085000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<59.969400,0.000000,45.008800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<60.020200,0.000000,44.958000>}
box{<0,0,-0.406400><0.071842,0.035000,0.406400> rotate<0,44.997030,0> translate<59.969400,0.000000,45.008800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<60.147200,0.000000,46.685200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<60.147200,0.000000,47.066200>}
box{<0,0,-0.406400><0.381000,0.035000,0.406400> rotate<0,90.000000,0> translate<60.147200,0.000000,47.066200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<60.020200,0.000000,44.958000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<60.274200,0.000000,45.212000>}
box{<0,0,-0.406400><0.359210,0.035000,0.406400> rotate<0,-44.997030,0> translate<60.020200,0.000000,44.958000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<60.147200,0.000000,46.685200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<60.274200,0.000000,46.685200>}
box{<0,0,-0.203200><0.127000,0.035000,0.203200> rotate<0,0.000000,0> translate<60.147200,0.000000,46.685200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<60.274200,0.000000,45.212000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<60.274200,0.000000,46.685200>}
box{<0,0,-0.406400><1.473200,0.035000,0.406400> rotate<0,90.000000,0> translate<60.274200,0.000000,46.685200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<54.508400,0.000000,59.334400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<60.274200,0.000000,54.584600>}
box{<0,0,-0.406400><7.470278,0.035000,0.406400> rotate<0,39.478700,0> translate<54.508400,0.000000,59.334400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<60.274200,0.000000,46.685200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<60.274200,0.000000,54.584600>}
box{<0,0,-0.406400><7.899400,0.035000,0.406400> rotate<0,90.000000,0> translate<60.274200,0.000000,54.584600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<60.274200,0.000000,54.584600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<60.274200,0.000000,54.762400>}
box{<0,0,-0.406400><0.177800,0.035000,0.406400> rotate<0,90.000000,0> translate<60.274200,0.000000,54.762400> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<58.775600,-1.535000,38.430200>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<60.706000,-1.535000,40.360600>}
box{<0,0,-0.190500><2.729998,0.035000,0.190500> rotate<0,-44.997030,0> translate<58.775600,-1.535000,38.430200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<57.734200,-1.535000,44.399200>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<60.706000,-1.535000,41.427400>}
box{<0,0,-0.190500><4.202760,0.035000,0.190500> rotate<0,44.997030,0> translate<57.734200,-1.535000,44.399200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<60.706000,-1.535000,40.360600>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<60.706000,-1.535000,41.427400>}
box{<0,0,-0.190500><1.066800,0.035000,0.190500> rotate<0,90.000000,0> translate<60.706000,-1.535000,41.427400> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<59.282200,0.000000,35.102800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<60.833000,0.000000,34.975800>}
box{<0,0,-0.190500><1.555992,0.035000,0.190500> rotate<0,4.681379,0> translate<59.282200,0.000000,35.102800> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<61.087000,-1.535000,13.970000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<61.087000,-1.535000,16.383000>}
box{<0,0,-0.508000><2.413000,0.035000,0.508000> rotate<0,90.000000,0> translate<61.087000,-1.535000,16.383000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<57.785000,0.000000,26.289000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<61.087000,0.000000,22.987000>}
box{<0,0,-0.317500><4.669733,0.035000,0.317500> rotate<0,44.997030,0> translate<57.785000,0.000000,26.289000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<61.087000,-1.535000,16.383000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<61.214000,-1.535000,16.510000>}
box{<0,0,-0.508000><0.179605,0.035000,0.508000> rotate<0,-44.997030,0> translate<61.087000,-1.535000,16.383000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<61.087000,-1.535000,16.510000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<61.214000,-1.535000,16.510000>}
box{<0,0,-0.508000><0.127000,0.035000,0.508000> rotate<0,0.000000,0> translate<61.087000,-1.535000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<61.087000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<61.341000,0.000000,17.145000>}
box{<0,0,-0.317500><0.683916,0.035000,0.317500> rotate<0,-68.194090,0> translate<61.087000,0.000000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<61.087000,0.000000,22.987000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<61.341000,0.000000,22.860000>}
box{<0,0,-0.317500><0.283981,0.035000,0.317500> rotate<0,26.563298,0> translate<61.087000,0.000000,22.987000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<61.341000,0.000000,17.145000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<61.341000,0.000000,22.860000>}
box{<0,0,-0.317500><5.715000,0.035000,0.317500> rotate<0,90.000000,0> translate<61.341000,0.000000,22.860000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.103000,0.000000,28.194000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.103000,0.000000,28.321000>}
box{<0,0,-0.406400><0.127000,0.035000,0.406400> rotate<0,90.000000,0> translate<62.103000,0.000000,28.321000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<62.103000,0.000000,28.194000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<62.155200,0.000000,28.321000>}
box{<0,0,-0.317500><0.137309,0.035000,0.317500> rotate<0,-67.651715,0> translate<62.103000,0.000000,28.194000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<61.341000,0.000000,22.860000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.230000,0.000000,22.860000>}
box{<0,0,-0.406400><0.889000,0.035000,0.406400> rotate<0,0.000000,0> translate<61.341000,0.000000,22.860000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.103000,0.000000,28.194000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.230000,0.000000,22.860000>}
box{<0,0,-0.406400><5.335512,0.035000,0.406400> rotate<0,88.630223,0> translate<62.103000,0.000000,28.194000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.230000,0.000000,53.594000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.230000,0.000000,52.324000>}
box{<0,0,-0.406400><1.270000,0.035000,0.406400> rotate<0,-90.000000,0> translate<62.230000,0.000000,52.324000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.230000,0.000000,52.324000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.230600,0.000000,52.323400>}
box{<0,0,-0.406400><0.000849,0.035000,0.406400> rotate<0,44.997030,0> translate<62.230000,0.000000,52.324000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.230600,0.000000,52.323400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.249400,0.000000,52.323400>}
box{<0,0,-0.406400><0.018800,0.035000,0.406400> rotate<0,0.000000,0> translate<62.230600,0.000000,52.323400> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<62.155200,0.000000,28.321000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<62.357000,0.000000,31.369000>}
box{<0,0,-0.317500><3.054673,0.035000,0.317500> rotate<0,-86.206437,0> translate<62.155200,0.000000,28.321000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<62.155200,0.000000,28.321000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<62.484000,0.000000,32.258000>}
box{<0,0,-0.317500><3.950706,0.035000,0.317500> rotate<0,-85.220376,0> translate<62.155200,0.000000,28.321000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.230000,0.000000,53.594000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.484000,0.000000,53.848000>}
box{<0,0,-0.406400><0.359210,0.035000,0.406400> rotate<0,-44.997030,0> translate<62.230000,0.000000,53.594000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<55.295800,-1.535000,28.778200>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<62.585600,-1.535000,21.615400>}
box{<0,0,-0.190500><10.219926,0.035000,0.190500> rotate<0,44.493599,0> translate<55.295800,-1.535000,28.778200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<62.585600,-1.535000,21.615400>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<63.017400,-1.535000,21.615400>}
box{<0,0,-0.190500><0.431800,0.035000,0.190500> rotate<0,0.000000,0> translate<62.585600,-1.535000,21.615400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<60.147200,0.000000,47.066200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<63.373000,0.000000,50.292000>}
box{<0,0,-0.406400><4.561970,0.035000,0.406400> rotate<0,-44.997030,0> translate<60.147200,0.000000,47.066200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<58.775600,-1.535000,34.721800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<63.652400,-1.535000,29.845000>}
box{<0,0,-0.190500><6.896837,0.035000,0.190500> rotate<0,44.997030,0> translate<58.775600,-1.535000,34.721800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<63.652400,-1.535000,23.571200>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<63.652400,-1.535000,29.845000>}
box{<0,0,-0.190500><6.273800,0.035000,0.190500> rotate<0,90.000000,0> translate<63.652400,-1.535000,29.845000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<62.484000,0.000000,32.258000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<63.881000,0.000000,36.322000>}
box{<0,0,-0.317500><4.297407,0.035000,0.317500> rotate<0,-71.024905,0> translate<62.484000,0.000000,32.258000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<63.627000,-1.535000,13.970000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<63.957200,-1.535000,14.706600>}
box{<0,0,-0.190500><0.807225,0.035000,0.190500> rotate<0,-65.850112,0> translate<63.627000,-1.535000,13.970000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<63.627000,-1.535000,16.510000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<63.957200,-1.535000,17.246600>}
box{<0,0,-0.190500><0.807225,0.035000,0.190500> rotate<0,-65.850112,0> translate<63.627000,-1.535000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<63.957200,-1.535000,17.246600>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<63.957200,-1.535000,21.539200>}
box{<0,0,-0.190500><4.292600,0.035000,0.190500> rotate<0,90.000000,0> translate<63.957200,-1.535000,21.539200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<59.969400,0.000000,41.402000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.058800,0.000000,37.312600>}
box{<0,0,-0.406400><5.783285,0.035000,0.406400> rotate<0,44.997030,0> translate<59.969400,0.000000,41.402000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.058800,0.000000,37.312600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.084200,0.000000,37.338000>}
box{<0,0,-0.406400><0.035921,0.035000,0.406400> rotate<0,-44.997030,0> translate<64.058800,0.000000,37.312600> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<64.058800,0.000000,37.312600>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<64.135000,0.000000,37.338000>}
box{<0,0,-0.317500><0.080322,0.035000,0.317500> rotate<0,-18.433732,0> translate<64.058800,0.000000,37.312600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<63.373000,0.000000,50.292000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.516000,0.000000,50.292000>}
box{<0,0,-0.406400><1.143000,0.035000,0.406400> rotate<0,0.000000,0> translate<63.373000,0.000000,50.292000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<64.770000,0.000000,47.926800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<64.770000,0.000000,47.548800>}
box{<0,0,-0.190500><0.378000,0.035000,0.190500> rotate<0,-90.000000,0> translate<64.770000,0.000000,47.548800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<64.188800,0.000000,50.726800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<64.770000,0.000000,50.726800>}
box{<0,0,-0.203200><0.581200,0.035000,0.203200> rotate<0,0.000000,0> translate<64.188800,0.000000,50.726800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<60.274200,0.000000,54.762400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.770000,0.000000,60.147200>}
box{<0,0,-0.406400><7.014862,0.035000,0.406400> rotate<0,-50.137994,0> translate<60.274200,0.000000,54.762400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.693800,0.000000,60.121800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.770000,0.000000,60.147200>}
box{<0,0,-0.406400><0.080322,0.035000,0.406400> rotate<0,-18.433732,0> translate<64.693800,0.000000,60.121800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<63.957200,-1.535000,14.706600>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<64.795400,-1.535000,15.544800>}
box{<0,0,-0.190500><1.185394,0.035000,0.190500> rotate<0,-44.997030,0> translate<63.957200,-1.535000,14.706600> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<64.795400,-1.535000,15.544800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<64.795400,-1.535000,18.643600>}
box{<0,0,-0.190500><3.098800,0.035000,0.190500> rotate<0,90.000000,0> translate<64.795400,-1.535000,18.643600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.770000,0.000000,50.726800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.843200,0.000000,50.726800>}
box{<0,0,-0.406400><0.073200,0.035000,0.406400> rotate<0,0.000000,0> translate<64.770000,0.000000,50.726800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.846200,0.000000,60.147200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.846200,0.000000,63.500000>}
box{<0,0,-0.406400><3.352800,0.035000,0.406400> rotate<0,90.000000,0> translate<64.846200,0.000000,63.500000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.693800,0.000000,60.121800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.871600,0.000000,60.096400>}
box{<0,0,-0.406400><0.179605,0.035000,0.406400> rotate<0,8.129566,0> translate<64.693800,0.000000,60.121800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.693800,0.000000,60.121800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.871600,0.000000,60.121800>}
box{<0,0,-0.406400><0.177800,0.035000,0.406400> rotate<0,0.000000,0> translate<64.693800,0.000000,60.121800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.846200,0.000000,60.147200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.871600,0.000000,60.121800>}
box{<0,0,-0.406400><0.035921,0.035000,0.406400> rotate<0,44.997030,0> translate<64.846200,0.000000,60.147200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.871600,0.000000,60.096400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.871600,0.000000,60.121800>}
box{<0,0,-0.406400><0.025400,0.035000,0.406400> rotate<0,90.000000,0> translate<64.871600,0.000000,60.121800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.871600,0.000000,60.198000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.871600,0.000000,60.121800>}
box{<0,0,-0.406400><0.076200,0.035000,0.406400> rotate<0,-90.000000,0> translate<64.871600,0.000000,60.121800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.516000,0.000000,50.292000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.897000,0.000000,50.673000>}
box{<0,0,-0.406400><0.538815,0.035000,0.406400> rotate<0,-44.997030,0> translate<64.516000,0.000000,50.292000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.843200,0.000000,50.726800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.897000,0.000000,50.673000>}
box{<0,0,-0.406400><0.076085,0.035000,0.406400> rotate<0,44.997030,0> translate<64.843200,0.000000,50.726800> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<63.881000,0.000000,36.322000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<64.935400,0.000000,36.322000>}
box{<0,0,-0.317500><1.054400,0.035000,0.317500> rotate<0,0.000000,0> translate<63.881000,0.000000,36.322000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<64.135000,0.000000,37.338000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<64.935400,0.000000,36.322000>}
box{<0,0,-0.317500><1.293405,0.035000,0.317500> rotate<0,51.765711,0> translate<64.135000,0.000000,37.338000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<63.652400,0.000000,23.571200>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<65.481200,0.000000,21.742400>}
box{<0,0,-0.190500><2.586314,0.035000,0.190500> rotate<0,44.997030,0> translate<63.652400,0.000000,23.571200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<65.786000,0.000000,18.846800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<65.786000,0.000000,17.195800>}
box{<0,0,-0.190500><1.651000,0.035000,0.190500> rotate<0,-90.000000,0> translate<65.786000,0.000000,17.195800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<63.017400,0.000000,21.615400>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<65.786000,0.000000,18.846800>}
box{<0,0,-0.190500><3.915392,0.035000,0.190500> rotate<0,44.997030,0> translate<63.017400,0.000000,21.615400> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<65.862200,0.000000,22.656800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<65.862200,0.000000,25.577800>}
box{<0,0,-0.190500><2.921000,0.035000,0.190500> rotate<0,90.000000,0> translate<65.862200,0.000000,25.577800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<65.862200,-1.535000,25.577800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<65.862200,-1.535000,30.759400>}
box{<0,0,-0.190500><5.181600,0.035000,0.190500> rotate<0,90.000000,0> translate<65.862200,-1.535000,30.759400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.484000,0.000000,53.848000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<66.040000,0.000000,53.848000>}
box{<0,0,-0.406400><3.556000,0.035000,0.406400> rotate<0,0.000000,0> translate<62.484000,0.000000,53.848000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<65.786000,0.000000,17.195800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<66.167000,0.000000,16.510000>}
box{<0,0,-0.190500><0.784527,0.035000,0.190500> rotate<0,60.941374,0> translate<65.786000,0.000000,17.195800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<60.833000,-1.535000,34.975800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<66.421000,-1.535000,33.959800>}
box{<0,0,-0.190500><5.679613,0.035000,0.190500> rotate<0,10.304166,0> translate<60.833000,-1.535000,34.975800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<66.421000,-1.535000,33.959800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<66.421000,-1.535000,43.611800>}
box{<0,0,-0.190500><9.652000,0.035000,0.190500> rotate<0,90.000000,0> translate<66.421000,-1.535000,43.611800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<66.167000,0.000000,13.970000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<66.497200,0.000000,14.706600>}
box{<0,0,-0.190500><0.807225,0.035000,0.190500> rotate<0,-65.850112,0> translate<66.167000,0.000000,13.970000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<66.497200,0.000000,14.706600>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<66.497200,0.000000,15.189200>}
box{<0,0,-0.190500><0.482600,0.035000,0.190500> rotate<0,90.000000,0> translate<66.497200,0.000000,15.189200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<64.770000,0.000000,47.548800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<66.802000,0.000000,45.516800>}
box{<0,0,-0.190500><2.873682,0.035000,0.190500> rotate<0,44.997030,0> translate<64.770000,0.000000,47.548800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<67.157600,0.000000,52.679600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<67.157600,0.000000,50.723800>}
box{<0,0,-0.406400><1.955800,0.035000,0.406400> rotate<0,-90.000000,0> translate<67.157600,0.000000,50.723800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.183000,0.000000,47.926800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.183000,0.000000,47.167800>}
box{<0,0,-0.190500><0.759000,0.035000,0.190500> rotate<0,-90.000000,0> translate<67.183000,0.000000,47.167800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<67.157600,0.000000,50.723800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<67.183000,0.000000,50.698400>}
box{<0,0,-0.203200><0.035921,0.035000,0.203200> rotate<0,44.997030,0> translate<67.157600,0.000000,50.723800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<67.183000,0.000000,50.698400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<67.183000,0.000000,50.726800>}
box{<0,0,-0.203200><0.028400,0.035000,0.203200> rotate<0,90.000000,0> translate<67.183000,0.000000,50.726800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<66.040000,0.000000,53.848000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<67.183000,0.000000,52.705000>}
box{<0,0,-0.406400><1.616446,0.035000,0.406400> rotate<0,44.997030,0> translate<66.040000,0.000000,53.848000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<67.157600,0.000000,52.679600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<67.183000,0.000000,52.705000>}
box{<0,0,-0.406400><0.035921,0.035000,0.406400> rotate<0,-44.997030,0> translate<67.157600,0.000000,52.679600> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<65.481200,-1.535000,21.742400>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.259200,-1.535000,23.520400>}
box{<0,0,-0.190500><2.514472,0.035000,0.190500> rotate<0,-44.997030,0> translate<65.481200,-1.535000,21.742400> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<66.497200,0.000000,15.189200>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.335400,0.000000,16.027400>}
box{<0,0,-0.190500><1.185394,0.035000,0.190500> rotate<0,-44.997030,0> translate<66.497200,0.000000,15.189200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<65.862200,0.000000,22.656800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.335400,0.000000,21.183600>}
box{<0,0,-0.190500><2.083419,0.035000,0.190500> rotate<0,44.997030,0> translate<65.862200,0.000000,22.656800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.335400,0.000000,16.027400>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.335400,0.000000,21.183600>}
box{<0,0,-0.190500><5.156200,0.035000,0.190500> rotate<0,90.000000,0> translate<67.335400,0.000000,21.183600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.846200,0.000000,63.500000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<67.386200,0.000000,65.151000>}
box{<0,0,-0.406400><3.029423,0.035000,0.406400> rotate<0,-33.021688,0> translate<64.846200,0.000000,63.500000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<66.421000,0.000000,43.611800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.411600,0.000000,43.611800>}
box{<0,0,-0.190500><0.990600,0.035000,0.190500> rotate<0,0.000000,0> translate<66.421000,0.000000,43.611800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<66.421000,0.000000,33.959800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.538600,0.000000,34.086800>}
box{<0,0,-0.190500><1.124793,0.035000,0.190500> rotate<0,-6.482646,0> translate<66.421000,0.000000,33.959800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<64.795400,-1.535000,18.643600>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.767200,-1.535000,21.615400>}
box{<0,0,-0.190500><4.202760,0.035000,0.190500> rotate<0,-44.997030,0> translate<64.795400,-1.535000,18.643600> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.767200,-1.535000,21.615400>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.767200,-1.535000,22.301200>}
box{<0,0,-0.190500><0.685800,0.035000,0.190500> rotate<0,90.000000,0> translate<67.767200,-1.535000,22.301200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.767200,0.000000,22.301200>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.767200,0.000000,23.342600>}
box{<0,0,-0.190500><1.041400,0.035000,0.190500> rotate<0,90.000000,0> translate<67.767200,0.000000,23.342600> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.538600,0.000000,34.086800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.945000,0.000000,34.312800>}
box{<0,0,-0.190500><0.465013,0.035000,0.190500> rotate<0,-29.076620,0> translate<67.538600,0.000000,34.086800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.411600,0.000000,43.611800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.945000,0.000000,43.512800>}
box{<0,0,-0.190500><0.542510,0.035000,0.190500> rotate<0,10.513860,0> translate<67.411600,0.000000,43.611800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.183000,0.000000,47.167800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.945000,0.000000,46.405800>}
box{<0,0,-0.190500><1.077631,0.035000,0.190500> rotate<0,44.997030,0> translate<67.183000,0.000000,47.167800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<68.072000,0.000000,27.051000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<68.097800,0.000000,27.076800>}
box{<0,0,-0.190500><0.036487,0.035000,0.190500> rotate<0,-44.997030,0> translate<68.072000,0.000000,27.051000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<68.097800,0.000000,27.076800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<68.199000,0.000000,27.076800>}
box{<0,0,-0.190500><0.101200,0.035000,0.190500> rotate<0,0.000000,0> translate<68.097800,0.000000,27.076800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.199000,0.000000,29.920800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.224000,0.000000,29.920800>}
box{<0,0,-0.203200><0.025000,0.035000,0.203200> rotate<0,0.000000,0> translate<68.199000,0.000000,29.920800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.767200,0.000000,23.342600>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<68.250200,0.000000,24.231600>}
box{<0,0,-0.190500><1.011736,0.035000,0.190500> rotate<0,-61.480395,0> translate<67.767200,0.000000,23.342600> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.259200,-1.535000,23.520400>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<68.300600,-1.535000,23.520400>}
box{<0,0,-0.190500><1.041400,0.035000,0.190500> rotate<0,0.000000,0> translate<67.259200,-1.535000,23.520400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.224000,0.000000,29.920800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.429000,0.000000,30.125800>}
box{<0,0,-0.203200><0.289914,0.035000,0.203200> rotate<0,-44.997030,0> translate<68.224000,0.000000,29.920800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<66.802000,0.000000,45.516800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<68.453000,0.000000,45.516800>}
box{<0,0,-0.190500><1.651000,0.035000,0.190500> rotate<0,0.000000,0> translate<66.802000,0.000000,45.516800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<68.580000,0.000000,34.312800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<68.580000,0.000000,34.290000>}
box{<0,0,-0.406400><0.022800,0.035000,0.406400> rotate<0,-90.000000,0> translate<68.580000,0.000000,34.290000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<67.945000,0.000000,34.312800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<68.580000,0.000000,34.312800>}
box{<0,0,-0.406400><0.635000,0.035000,0.406400> rotate<0,0.000000,0> translate<67.945000,0.000000,34.312800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<67.945000,0.000000,46.405800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<68.961000,0.000000,46.405800>}
box{<0,0,-0.190500><1.016000,0.035000,0.190500> rotate<0,0.000000,0> translate<67.945000,0.000000,46.405800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<68.707000,-1.535000,13.970000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<69.037200,-1.535000,14.706600>}
box{<0,0,-0.190500><0.807225,0.035000,0.190500> rotate<0,-65.850112,0> translate<68.707000,-1.535000,13.970000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<68.580000,0.000000,34.312800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.215000,0.000000,34.312800>}
box{<0,0,-0.406400><0.635000,0.035000,0.406400> rotate<0,0.000000,0> translate<68.580000,0.000000,34.312800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<69.215000,0.000000,43.512800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<69.215000,0.000000,43.484800>}
box{<0,0,-0.190500><0.028000,0.035000,0.190500> rotate<0,-90.000000,0> translate<69.215000,0.000000,43.484800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<69.215000,0.000000,44.754800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<69.215000,0.000000,43.512800>}
box{<0,0,-0.190500><1.242000,0.035000,0.190500> rotate<0,-90.000000,0> translate<69.215000,0.000000,43.512800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<68.453000,0.000000,45.516800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<69.215000,0.000000,44.754800>}
box{<0,0,-0.190500><1.077631,0.035000,0.190500> rotate<0,44.997030,0> translate<68.453000,0.000000,45.516800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<69.037200,-1.535000,14.706600>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<69.291200,-1.535000,15.189200>}
box{<0,0,-0.190500><0.545361,0.035000,0.190500> rotate<0,-62.237352,0> translate<69.037200,-1.535000,14.706600> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<69.596000,0.000000,47.167800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<69.596000,0.000000,47.926800>}
box{<0,0,-0.190500><0.759000,0.035000,0.190500> rotate<0,90.000000,0> translate<69.596000,0.000000,47.926800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<68.072000,0.000000,27.051000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<69.723000,0.000000,25.527000>}
box{<0,0,-0.190500><2.246859,0.035000,0.190500> rotate<0,42.706571,0> translate<68.072000,0.000000,27.051000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<69.723000,0.000000,22.733000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<69.723000,0.000000,25.527000>}
box{<0,0,-0.190500><2.794000,0.035000,0.190500> rotate<0,90.000000,0> translate<69.723000,0.000000,25.527000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.871600,0.000000,60.198000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.748400,0.000000,60.198000>}
box{<0,0,-0.406400><4.876800,0.035000,0.406400> rotate<0,0.000000,0> translate<64.871600,0.000000,60.198000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.850000,0.000000,34.312800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.850000,0.000000,34.290000>}
box{<0,0,-0.406400><0.022800,0.035000,0.406400> rotate<0,-90.000000,0> translate<69.850000,0.000000,34.290000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.215000,0.000000,34.312800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.850000,0.000000,34.312800>}
box{<0,0,-0.406400><0.635000,0.035000,0.406400> rotate<0,0.000000,0> translate<69.215000,0.000000,34.312800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.773800,0.000000,60.121800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.875400,0.000000,60.274200>}
box{<0,0,-0.406400><0.183162,0.035000,0.406400> rotate<0,-56.306216,0> translate<69.773800,0.000000,60.121800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.748400,0.000000,60.198000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.900800,0.000000,60.528200>}
box{<0,0,-0.406400><0.363673,0.035000,0.406400> rotate<0,-65.220555,0> translate<69.748400,0.000000,60.198000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.773800,0.000000,58.775600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.900800,0.000000,60.528200>}
box{<0,0,-0.406400><1.757195,0.035000,0.406400> rotate<0,-85.849710,0> translate<69.773800,0.000000,58.775600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.875400,0.000000,60.274200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.900800,0.000000,60.528200>}
box{<0,0,-0.406400><0.255267,0.035000,0.406400> rotate<0,-84.283844,0> translate<69.875400,0.000000,60.274200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<69.291200,-1.535000,15.189200>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<70.002400,-1.535000,15.773400>}
box{<0,0,-0.190500><0.920378,0.035000,0.190500> rotate<0,-39.398060,0> translate<69.291200,-1.535000,15.189200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<68.300600,-1.535000,23.520400>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<70.002400,-1.535000,21.437600>}
box{<0,0,-0.190500><2.689643,0.035000,0.190500> rotate<0,50.745314,0> translate<68.300600,-1.535000,23.520400> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<70.002400,-1.535000,15.773400>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<70.002400,-1.535000,21.437600>}
box{<0,0,-0.190500><5.664200,0.035000,0.190500> rotate<0,90.000000,0> translate<70.002400,-1.535000,21.437600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<70.180200,0.000000,34.290000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<70.203000,0.000000,34.312800>}
box{<0,0,-0.203200><0.032244,0.035000,0.203200> rotate<0,-44.997030,0> translate<70.180200,0.000000,34.290000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<69.596000,0.000000,50.726800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<70.482000,0.000000,50.726800>}
box{<0,0,-0.190500><0.886000,0.035000,0.190500> rotate<0,0.000000,0> translate<69.596000,0.000000,50.726800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<70.485000,0.000000,34.239200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<70.485000,0.000000,32.588200>}
box{<0,0,-0.203200><1.651000,0.035000,0.203200> rotate<0,-90.000000,0> translate<70.485000,0.000000,32.588200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<70.180200,0.000000,34.290000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<70.485000,0.000000,34.239200>}
box{<0,0,-0.203200><0.309004,0.035000,0.203200> rotate<0,9.461698,0> translate<70.180200,0.000000,34.290000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.850000,0.000000,34.312800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<70.485000,0.000000,34.312800>}
box{<0,0,-0.406400><0.635000,0.035000,0.406400> rotate<0,0.000000,0> translate<69.850000,0.000000,34.312800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<70.203000,0.000000,34.312800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<70.485000,0.000000,34.312800>}
box{<0,0,-0.203200><0.282000,0.035000,0.203200> rotate<0,0.000000,0> translate<70.203000,0.000000,34.312800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<70.485000,0.000000,44.881800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<70.485000,0.000000,43.512800>}
box{<0,0,-0.190500><1.369000,0.035000,0.190500> rotate<0,-90.000000,0> translate<70.485000,0.000000,43.512800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<68.961000,0.000000,46.405800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<70.485000,0.000000,44.881800>}
box{<0,0,-0.190500><2.155261,0.035000,0.190500> rotate<0,44.997030,0> translate<68.961000,0.000000,46.405800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<69.723000,0.000000,22.733000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<70.609000,0.000000,21.720000>}
box{<0,0,-0.190500><1.345795,0.035000,0.190500> rotate<0,48.822868,0> translate<69.723000,0.000000,22.733000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.429000,0.000000,30.125800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.043800,0.000000,30.125800>}
box{<0,0,-0.203200><2.614800,0.035000,0.203200> rotate<0,0.000000,0> translate<68.429000,0.000000,30.125800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.043800,0.000000,31.775400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.043800,0.000000,30.125800>}
box{<0,0,-0.203200><1.649600,0.035000,0.203200> rotate<0,-90.000000,0> translate<71.043800,0.000000,30.125800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<70.485000,0.000000,32.588200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.043800,0.000000,31.775400>}
box{<0,0,-0.203200><0.986358,0.035000,0.203200> rotate<0,55.487815,0> translate<70.485000,0.000000,32.588200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.043800,0.000000,27.125800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.067800,0.000000,27.125800>}
box{<0,0,-0.203200><0.024000,0.035000,0.203200> rotate<0,0.000000,0> translate<71.043800,0.000000,27.125800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.067800,0.000000,27.125800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.069200,0.000000,27.127200>}
box{<0,0,-0.203200><0.001980,0.035000,0.203200> rotate<0,-44.997030,0> translate<71.067800,0.000000,27.125800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.069200,0.000000,27.127200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.094200,0.000000,27.102200>}
box{<0,0,-0.203200><0.035355,0.035000,0.203200> rotate<0,44.997030,0> translate<71.069200,0.000000,27.127200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.094200,0.000000,24.231600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.094200,0.000000,27.102200>}
box{<0,0,-0.203200><2.870600,0.035000,0.203200> rotate<0,90.000000,0> translate<71.094200,0.000000,27.102200> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<71.247000,0.000000,13.970000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<71.247000,0.000000,16.510000>}
box{<0,0,-0.508000><2.540000,0.035000,0.508000> rotate<0,90.000000,0> translate<71.247000,0.000000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<70.482000,0.000000,50.726800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<71.374000,0.000000,49.834800>}
box{<0,0,-0.190500><1.261478,0.035000,0.190500> rotate<0,44.997030,0> translate<70.482000,0.000000,50.726800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<71.374000,0.000000,46.786800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<71.374000,0.000000,49.834800>}
box{<0,0,-0.190500><3.048000,0.035000,0.190500> rotate<0,90.000000,0> translate<71.374000,0.000000,49.834800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<71.043800,0.000000,27.125800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<71.424800,0.000000,27.406600>}
box{<0,0,-0.190500><0.473297,0.035000,0.190500> rotate<0,-36.388105,0> translate<71.043800,0.000000,27.125800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<71.755000,0.000000,32.562800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<71.755000,0.000000,34.312800>}
box{<0,0,-0.190500><1.750000,0.035000,0.190500> rotate<0,90.000000,0> translate<71.755000,0.000000,34.312800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<71.755000,0.000000,43.512800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<71.755000,0.000000,43.484800>}
box{<0,0,-0.190500><0.028000,0.035000,0.190500> rotate<0,-90.000000,0> translate<71.755000,0.000000,43.484800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<69.596000,0.000000,47.167800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<71.755000,0.000000,45.008800>}
box{<0,0,-0.190500><3.053287,0.035000,0.190500> rotate<0,44.997030,0> translate<69.596000,0.000000,47.167800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<71.755000,0.000000,43.512800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<71.755000,0.000000,45.008800>}
box{<0,0,-0.190500><1.496000,0.035000,0.190500> rotate<0,90.000000,0> translate<71.755000,0.000000,45.008800> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<67.183000,-1.535000,52.705000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<71.755000,-1.535000,56.261000>}
box{<0,0,-0.317500><5.792091,0.035000,0.317500> rotate<0,-37.872484,0> translate<67.183000,-1.535000,52.705000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.773800,0.000000,58.775600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<72.542400,0.000000,56.007000>}
box{<0,0,-0.406400><3.915392,0.035000,0.406400> rotate<0,44.997030,0> translate<69.773800,0.000000,58.775600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<72.542400,0.000000,47.472600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<72.542400,0.000000,56.007000>}
box{<0,0,-0.406400><8.534400,0.035000,0.406400> rotate<0,90.000000,0> translate<72.542400,0.000000,56.007000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<71.424800,0.000000,27.406600>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<72.898000,0.000000,29.006800>}
box{<0,0,-0.190500><2.175077,0.035000,0.190500> rotate<0,-47.363122,0> translate<71.424800,0.000000,27.406600> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<71.755000,0.000000,32.562800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<72.898000,0.000000,31.038800>}
box{<0,0,-0.190500><1.905000,0.035000,0.190500> rotate<0,53.126596,0> translate<71.755000,0.000000,32.562800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<72.898000,0.000000,29.006800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<72.898000,0.000000,31.038800>}
box{<0,0,-0.190500><2.032000,0.035000,0.190500> rotate<0,90.000000,0> translate<72.898000,0.000000,31.038800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<72.999600,0.000000,34.239200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<73.025000,0.000000,34.213800>}
box{<0,0,-0.203200><0.035921,0.035000,0.203200> rotate<0,44.997030,0> translate<72.999600,0.000000,34.239200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<73.025000,0.000000,32.385000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<73.025000,0.000000,34.213800>}
box{<0,0,-0.203200><1.828800,0.035000,0.203200> rotate<0,90.000000,0> translate<73.025000,0.000000,34.213800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<72.999600,0.000000,34.239200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<73.025000,0.000000,34.264600>}
box{<0,0,-0.203200><0.035921,0.035000,0.203200> rotate<0,-44.997030,0> translate<72.999600,0.000000,34.239200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<73.025000,0.000000,34.264600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<73.025000,0.000000,34.312800>}
box{<0,0,-0.203200><0.048200,0.035000,0.203200> rotate<0,90.000000,0> translate<73.025000,0.000000,34.312800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<73.025000,0.000000,43.512800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<73.025000,0.000000,43.484800>}
box{<0,0,-0.190500><0.028000,0.035000,0.190500> rotate<0,-90.000000,0> translate<73.025000,0.000000,43.484800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<71.374000,0.000000,46.786800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<73.025000,0.000000,45.135800>}
box{<0,0,-0.190500><2.334867,0.035000,0.190500> rotate<0,44.997030,0> translate<71.374000,0.000000,46.786800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<73.025000,0.000000,43.512800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<73.025000,0.000000,45.135800>}
box{<0,0,-0.190500><1.623000,0.035000,0.190500> rotate<0,90.000000,0> translate<73.025000,0.000000,45.135800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<73.660000,0.000000,28.194000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<73.761600,0.000000,28.194000>}
box{<0,0,-0.190500><0.101600,0.035000,0.190500> rotate<0,0.000000,0> translate<73.660000,0.000000,28.194000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<73.025000,0.000000,32.385000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<73.761600,0.000000,31.394400>}
box{<0,0,-0.203200><1.234450,0.035000,0.203200> rotate<0,53.362364,0> translate<73.025000,0.000000,32.385000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<73.761600,0.000000,28.194000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<73.761600,0.000000,31.394400>}
box{<0,0,-0.203200><3.200400,0.035000,0.203200> rotate<0,90.000000,0> translate<73.761600,0.000000,31.394400> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<71.755000,-1.535000,56.261000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<73.787000,-1.535000,58.293000>}
box{<0,0,-0.317500><2.873682,0.035000,0.317500> rotate<0,-44.997030,0> translate<71.755000,-1.535000,56.261000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<73.660000,0.000000,28.194000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<73.914000,0.000000,27.940000>}
box{<0,0,-0.190500><0.359210,0.035000,0.190500> rotate<0,44.997030,0> translate<73.660000,0.000000,28.194000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<73.914000,0.000000,27.178000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<73.914000,0.000000,27.940000>}
box{<0,0,-0.190500><0.762000,0.035000,0.190500> rotate<0,90.000000,0> translate<73.914000,0.000000,27.940000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.058800,0.000000,37.312600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.218800,0.000000,37.312600>}
box{<0,0,-0.406400><10.160000,0.035000,0.406400> rotate<0,0.000000,0> translate<64.058800,0.000000,37.312600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.295000,0.000000,34.312800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.295000,0.000000,34.163000>}
box{<0,0,-0.406400><0.149800,0.035000,0.406400> rotate<0,-90.000000,0> translate<74.295000,0.000000,34.163000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.295000,0.000000,37.160200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.295000,0.000000,34.312800>}
box{<0,0,-0.406400><2.847400,0.035000,0.406400> rotate<0,-90.000000,0> translate<74.295000,0.000000,34.312800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.295000,0.000000,37.236400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.295000,0.000000,37.160200>}
box{<0,0,-0.406400><0.076200,0.035000,0.406400> rotate<0,-90.000000,0> translate<74.295000,0.000000,37.160200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.041000,0.000000,37.211000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.295000,0.000000,37.236400>}
box{<0,0,-0.406400><0.255267,0.035000,0.406400> rotate<0,-5.710216,0> translate<74.041000,0.000000,37.211000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.218800,0.000000,37.312600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.295000,0.000000,37.236400>}
box{<0,0,-0.406400><0.107763,0.035000,0.406400> rotate<0,44.997030,0> translate<74.218800,0.000000,37.312600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.295000,0.000000,37.236400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.295000,0.000000,43.512800>}
box{<0,0,-0.406400><6.276400,0.035000,0.406400> rotate<0,90.000000,0> translate<74.295000,0.000000,43.512800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<72.542400,0.000000,47.472600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.295000,0.000000,45.593000>}
box{<0,0,-0.406400><2.569923,0.035000,0.406400> rotate<0,46.999431,0> translate<72.542400,0.000000,47.472600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.295000,0.000000,43.512800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.295000,0.000000,45.593000>}
box{<0,0,-0.406400><2.080200,0.035000,0.406400> rotate<0,90.000000,0> translate<74.295000,0.000000,45.593000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.371200,0.000000,33.832800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.371200,0.000000,32.791400>}
box{<0,0,-0.406400><1.041400,0.035000,0.406400> rotate<0,-90.000000,0> translate<74.371200,0.000000,32.791400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.295000,0.000000,34.163000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.371200,0.000000,33.832800>}
box{<0,0,-0.406400><0.338878,0.035000,0.406400> rotate<0,77.000301,0> translate<74.295000,0.000000,34.163000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<66.421000,-1.535000,43.611800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<74.498200,-1.535000,51.562000>}
box{<0,0,-0.190500><11.333439,0.035000,0.190500> rotate<0,-44.543062,0> translate<66.421000,-1.535000,43.611800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<74.498200,0.000000,53.416200>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<74.498200,0.000000,52.679600>}
box{<0,0,-0.190500><0.736600,0.035000,0.190500> rotate<0,-90.000000,0> translate<74.498200,0.000000,52.679600> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<74.498200,-1.535000,51.562000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<74.498200,-1.535000,53.416200>}
box{<0,0,-0.190500><1.854200,0.035000,0.190500> rotate<0,90.000000,0> translate<74.498200,-1.535000,53.416200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<74.498200,0.000000,52.679600>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<74.524000,0.000000,51.790600>}
box{<0,0,-0.190500><0.889374,0.035000,0.190500> rotate<0,88.331835,0> translate<74.498200,0.000000,52.679600> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<73.787000,-1.535000,58.293000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<74.853800,-1.535000,60.121800>}
box{<0,0,-0.317500><2.117208,0.035000,0.317500> rotate<0,-59.739620,0> translate<73.787000,-1.535000,58.293000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.853800,0.000000,58.750200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.980800,0.000000,59.639200>}
box{<0,0,-0.406400><0.898026,0.035000,0.406400> rotate<0,-81.864495,0> translate<74.853800,0.000000,58.750200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.853800,0.000000,60.121800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.031600,0.000000,59.791600>}
box{<0,0,-0.406400><0.375027,0.035000,0.406400> rotate<0,61.695172,0> translate<74.853800,0.000000,60.121800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.980800,0.000000,59.639200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.031600,0.000000,59.791600>}
box{<0,0,-0.406400><0.160644,0.035000,0.406400> rotate<0,-71.560328,0> translate<74.980800,0.000000,59.639200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.371200,0.000000,32.791400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.254200,0.000000,31.324200>}
box{<0,0,-0.406400><1.712415,0.035000,0.406400> rotate<0,58.955461,0> translate<74.371200,0.000000,32.791400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.457400,0.000000,30.022800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.457400,0.000000,29.190600>}
box{<0,0,-0.406400><0.832200,0.035000,0.406400> rotate<0,-90.000000,0> translate<75.457400,0.000000,29.190600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.254200,0.000000,31.324200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.457400,0.000000,30.022800>}
box{<0,0,-0.406400><1.317168,0.035000,0.406400> rotate<0,81.120165,0> translate<75.254200,0.000000,31.324200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.565000,0.000000,34.312800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.565000,0.000000,34.264600>}
box{<0,0,-0.406400><0.048200,0.035000,0.406400> rotate<0,-90.000000,0> translate<75.565000,0.000000,34.264600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.565000,0.000000,35.941000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.565000,0.000000,34.312800>}
box{<0,0,-0.406400><1.628200,0.035000,0.406400> rotate<0,-90.000000,0> translate<75.565000,0.000000,34.312800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.041000,0.000000,37.211000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.565000,0.000000,35.941000>}
box{<0,0,-0.406400><1.983803,0.035000,0.406400> rotate<0,39.802944,0> translate<74.041000,0.000000,37.211000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.295000,0.000000,37.160200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.565000,0.000000,38.608000>}
box{<0,0,-0.406400><1.925883,0.035000,0.406400> rotate<0,-48.739771,0> translate<74.295000,0.000000,37.160200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.565000,0.000000,38.608000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.565000,0.000000,43.561000>}
box{<0,0,-0.406400><4.953000,0.035000,0.406400> rotate<0,90.000000,0> translate<75.565000,0.000000,43.561000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.559000,0.000000,45.587000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.565000,0.000000,45.339000>}
box{<0,0,-0.406400><0.248073,0.035000,0.406400> rotate<0,88.608234,0> translate<75.559000,0.000000,45.587000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.565000,0.000000,43.561000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.565000,0.000000,45.339000>}
box{<0,0,-0.406400><1.778000,0.035000,0.406400> rotate<0,90.000000,0> translate<75.565000,0.000000,45.339000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.565000,0.000000,43.512800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.567600,0.000000,43.512800>}
box{<0,0,-0.406400><0.002600,0.035000,0.406400> rotate<0,0.000000,0> translate<75.565000,0.000000,43.512800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.565000,0.000000,43.561000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.567600,0.000000,43.512800>}
box{<0,0,-0.406400><0.048270,0.035000,0.406400> rotate<0,86.906613,0> translate<75.565000,0.000000,43.561000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.559000,0.000000,45.587000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.686000,0.000000,48.336200>}
box{<0,0,-0.406400><2.752132,0.035000,0.406400> rotate<0,-87.349322,0> translate<75.559000,0.000000,45.587000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<70.993000,-1.535000,16.510000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<76.454000,-1.535000,21.971000>}
box{<0,0,-0.508000><7.723020,0.035000,0.508000> rotate<0,-44.997030,0> translate<70.993000,-1.535000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<73.914000,0.000000,27.178000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<76.708000,0.000000,24.384000>}
box{<0,0,-0.190500><3.951313,0.035000,0.190500> rotate<0,44.997030,0> translate<73.914000,0.000000,27.178000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.457400,0.000000,29.190600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<76.727400,0.000000,29.190600>}
box{<0,0,-0.406400><1.270000,0.035000,0.406400> rotate<0,0.000000,0> translate<75.457400,0.000000,29.190600> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<63.957200,-1.535000,21.539200>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<76.784200,-1.535000,34.366200>}
box{<0,0,-0.190500><18.140117,0.035000,0.190500> rotate<0,-44.997030,0> translate<63.957200,-1.535000,21.539200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<76.784200,0.000000,35.407600>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<76.835000,0.000000,34.312800>}
box{<0,0,-0.190500><1.095978,0.035000,0.190500> rotate<0,87.337550,0> translate<76.784200,0.000000,35.407600> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<76.835000,0.000000,43.512800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<76.835000,0.000000,43.484800>}
box{<0,0,-0.190500><0.028000,0.035000,0.190500> rotate<0,-90.000000,0> translate<76.835000,0.000000,43.484800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<76.835000,0.000000,43.512800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<76.835000,0.000000,45.694600>}
box{<0,0,-0.190500><2.181800,0.035000,0.190500> rotate<0,90.000000,0> translate<76.835000,0.000000,45.694600> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<76.835000,0.000000,43.512800>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<76.911200,0.000000,42.418000>}
box{<0,0,-0.190500><1.097449,0.035000,0.190500> rotate<0,86.012857,0> translate<76.835000,0.000000,43.512800> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<76.784200,-1.535000,34.366200>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<77.038200,-1.535000,36.398200>}
box{<0,0,-0.190500><2.047813,0.035000,0.190500> rotate<0,-82.869514,0> translate<76.784200,-1.535000,34.366200> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<76.784200,0.000000,35.407600>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<77.038200,0.000000,36.398200>}
box{<0,0,-0.190500><1.022646,0.035000,0.190500> rotate<0,-75.613615,0> translate<76.784200,0.000000,35.407600> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<65.862200,-1.535000,30.759400>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<77.038200,-1.535000,41.173400>}
box{<0,0,-0.190500><15.275941,0.035000,0.190500> rotate<0,-42.975799,0> translate<65.862200,-1.535000,30.759400> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<76.911200,0.000000,42.418000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<77.038200,0.000000,41.173400>}
box{<0,0,-0.190500><1.251063,0.035000,0.190500> rotate<0,84.168103,0> translate<76.911200,0.000000,42.418000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<76.835000,0.000000,45.694600>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<77.368000,0.000000,46.735600>}
box{<0,0,-0.190500><1.169517,0.035000,0.190500> rotate<0,-62.883054,0> translate<76.835000,0.000000,45.694600> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<77.368000,0.000000,46.735600>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<77.368000,0.000000,51.790600>}
box{<0,0,-0.190500><5.055000,0.035000,0.190500> rotate<0,90.000000,0> translate<77.368000,0.000000,51.790600> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<70.609000,0.000000,21.720000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<77.950000,0.000000,19.670000>}
box{<0,0,-0.190500><7.621862,0.035000,0.190500> rotate<0,15.601548,0> translate<70.609000,0.000000,21.720000> }
cylinder{<0,0,0><0,0.035000,0>0.381000 translate<77.978000,0.000000,45.466000>}
cylinder{<0,0,0><0,0.035000,0>0.381000 translate<77.978000,0.000000,45.440600>}
box{<0,0,-0.381000><0.025400,0.035000,0.381000> rotate<0,-90.000000,0> translate<77.978000,0.000000,45.440600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<78.105000,0.000000,32.385000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<78.105000,0.000000,34.312800>}
box{<0,0,-0.406400><1.927800,0.035000,0.406400> rotate<0,90.000000,0> translate<78.105000,0.000000,34.312800> }
cylinder{<0,0,0><0,0.035000,0>0.381000 translate<78.105000,0.000000,43.512800>}
cylinder{<0,0,0><0,0.035000,0>0.381000 translate<78.105000,0.000000,43.510200>}
box{<0,0,-0.381000><0.002600,0.035000,0.381000> rotate<0,-90.000000,0> translate<78.105000,0.000000,43.510200> }
cylinder{<0,0,0><0,0.035000,0>0.381000 translate<77.978000,0.000000,45.466000>}
cylinder{<0,0,0><0,0.035000,0>0.381000 translate<78.105000,0.000000,45.339000>}
box{<0,0,-0.381000><0.179605,0.035000,0.381000> rotate<0,44.997030,0> translate<77.978000,0.000000,45.466000> }
cylinder{<0,0,0><0,0.035000,0>0.381000 translate<78.105000,0.000000,43.512800>}
cylinder{<0,0,0><0,0.035000,0>0.381000 translate<78.105000,0.000000,45.339000>}
box{<0,0,-0.381000><1.826200,0.035000,0.381000> rotate<0,90.000000,0> translate<78.105000,0.000000,45.339000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<67.386200,0.000000,65.151000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<78.181200,0.000000,65.151000>}
box{<0,0,-0.406400><10.795000,0.035000,0.406400> rotate<0,0.000000,0> translate<67.386200,0.000000,65.151000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<77.978000,-1.535000,45.440600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<78.692800,-1.535000,44.598800>}
box{<0,0,-0.406400><1.104340,0.035000,0.406400> rotate<0,49.661044,0> translate<77.978000,-1.535000,45.440600> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<76.708000,0.000000,24.384000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<79.248000,0.000000,24.384000>}
box{<0,0,-0.190500><2.540000,0.035000,0.190500> rotate<0,0.000000,0> translate<76.708000,0.000000,24.384000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<79.375000,0.000000,34.312800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<79.375000,0.000000,43.512800>}
box{<0,0,-0.406400><9.200000,0.035000,0.406400> rotate<0,90.000000,0> translate<79.375000,0.000000,43.512800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<79.375000,0.000000,43.512800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<79.375000,0.000000,50.139600>}
box{<0,0,-0.406400><6.626800,0.035000,0.406400> rotate<0,90.000000,0> translate<79.375000,0.000000,50.139600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<76.727400,0.000000,29.190600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<79.756000,0.000000,26.162000>}
box{<0,0,-0.406400><4.283087,0.035000,0.406400> rotate<0,44.997030,0> translate<76.727400,0.000000,29.190600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<78.181200,0.000000,65.151000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.085400,0.000000,63.246800>}
box{<0,0,-0.406400><2.692945,0.035000,0.406400> rotate<0,44.997030,0> translate<78.181200,0.000000,65.151000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<79.375000,0.000000,50.139600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.110200,0.000000,51.306600>}
box{<0,0,-0.406400><1.379278,0.035000,0.406400> rotate<0,-57.785610,0> translate<79.375000,0.000000,50.139600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.110200,0.000000,51.306600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.186400,0.000000,51.917600>}
box{<0,0,-0.406400><0.615733,0.035000,0.406400> rotate<0,-82.885672,0> translate<80.110200,0.000000,51.306600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.111600,0.000000,54.203600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.186400,0.000000,54.203600>}
box{<0,0,-0.406400><0.074800,0.035000,0.406400> rotate<0,0.000000,0> translate<80.111600,0.000000,54.203600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.186400,0.000000,51.917600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.186400,0.000000,54.203600>}
box{<0,0,-0.406400><2.286000,0.035000,0.406400> rotate<0,90.000000,0> translate<80.186400,0.000000,54.203600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.853800,0.000000,58.750200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.186400,0.000000,54.306600>}
box{<0,0,-0.406400><6.941340,0.035000,0.406400> rotate<0,39.801465,0> translate<74.853800,0.000000,58.750200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.186400,0.000000,54.203600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.186400,0.000000,54.306600>}
box{<0,0,-0.406400><0.103000,0.035000,0.406400> rotate<0,90.000000,0> translate<80.186400,0.000000,54.306600> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<80.085400,0.000000,63.246800>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<80.391000,0.000000,63.500000>}
box{<0,0,-0.317500><0.396865,0.035000,0.317500> rotate<0,-39.640288,0> translate<80.085400,0.000000,63.246800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.490000,0.000000,13.998000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.490000,0.000000,17.130000>}
box{<0,0,-0.406400><3.132000,0.035000,0.406400> rotate<0,90.000000,0> translate<80.490000,0.000000,17.130000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.490000,0.000000,17.130000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.490000,0.000000,17.300000>}
box{<0,0,-0.406400><0.170000,0.035000,0.406400> rotate<0,90.000000,0> translate<80.490000,0.000000,17.300000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<79.248000,0.000000,24.384000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<80.518000,0.000000,23.114000>}
box{<0,0,-0.190500><1.796051,0.035000,0.190500> rotate<0,44.997030,0> translate<79.248000,0.000000,24.384000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<80.518000,0.000000,19.050000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<80.518000,0.000000,23.114000>}
box{<0,0,-0.190500><4.064000,0.035000,0.190500> rotate<0,90.000000,0> translate<80.518000,0.000000,23.114000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.490000,0.000000,13.998000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.519800,0.000000,13.968200>}
box{<0,0,-0.406400><0.042144,0.035000,0.406400> rotate<0,44.997030,0> translate<80.490000,0.000000,13.998000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.519800,0.000000,13.962400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.519800,0.000000,13.968200>}
box{<0,0,-0.406400><0.005800,0.035000,0.406400> rotate<0,90.000000,0> translate<80.519800,0.000000,13.968200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.490000,0.000000,17.130000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.547000,0.000000,17.116000>}
box{<0,0,-0.406400><0.058694,0.035000,0.406400> rotate<0,13.798575,0> translate<80.490000,0.000000,17.130000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<80.518000,0.000000,19.050000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<80.547000,0.000000,18.190000>}
box{<0,0,-0.190500><0.860489,0.035000,0.190500> rotate<0,88.062853,0> translate<80.518000,0.000000,19.050000> }
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<80.547000,0.000000,17.116000>}
cylinder{<0,0,0><0,0.035000,0>0.190500 translate<80.547000,0.000000,18.190000>}
box{<0,0,-0.190500><1.074000,0.035000,0.190500> rotate<0,90.000000,0> translate<80.547000,0.000000,18.190000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.645000,0.000000,31.800800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.645000,0.000000,34.312800>}
box{<0,0,-0.406400><2.512000,0.035000,0.406400> rotate<0,90.000000,0> translate<80.645000,0.000000,34.312800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.645000,0.000000,43.512800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.645000,0.000000,43.510200>}
box{<0,0,-0.406400><0.002600,0.035000,0.406400> rotate<0,-90.000000,0> translate<80.645000,0.000000,43.510200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.645000,0.000000,43.512800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.645000,0.000000,45.262800>}
box{<0,0,-0.406400><1.750000,0.035000,0.406400> rotate<0,90.000000,0> translate<80.645000,0.000000,45.262800> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<76.454000,-1.535000,21.971000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<80.772000,-1.535000,21.971000>}
box{<0,0,-0.508000><4.318000,0.035000,0.508000> rotate<0,0.000000,0> translate<76.454000,-1.535000,21.971000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<79.756000,0.000000,26.162000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.772000,0.000000,26.162000>}
box{<0,0,-0.406400><1.016000,0.035000,0.406400> rotate<0,0.000000,0> translate<79.756000,0.000000,26.162000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.490000,0.000000,17.300000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.026000,0.000000,16.764000>}
box{<0,0,-0.406400><0.758018,0.035000,0.406400> rotate<0,44.997030,0> translate<80.490000,0.000000,17.300000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.645000,0.000000,31.800800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.057400,0.000000,30.397800>}
box{<0,0,-0.406400><1.462355,0.035000,0.406400> rotate<0,73.614888,0> translate<80.645000,0.000000,31.800800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.026000,0.000000,30.505400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.057400,0.000000,30.397800>}
box{<0,0,-0.406400><0.112088,0.035000,0.406400> rotate<0,73.726751,0> translate<81.026000,0.000000,30.505400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.057400,0.000000,30.022800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.057400,0.000000,30.397800>}
box{<0,0,-0.406400><0.375000,0.035000,0.406400> rotate<0,90.000000,0> translate<81.057400,0.000000,30.397800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.645000,0.000000,45.262800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.286000,0.000000,46.284800>}
box{<0,0,-0.406400><1.206385,0.035000,0.406400> rotate<0,-57.900177,0> translate<80.645000,0.000000,45.262800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.286000,0.000000,46.284800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.286000,0.000000,48.336200>}
box{<0,0,-0.406400><2.051400,0.035000,0.406400> rotate<0,90.000000,0> translate<81.286000,0.000000,48.336200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.788000,0.000000,21.844000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.788000,0.000000,21.590000>}
box{<0,0,-0.406400><0.254000,0.035000,0.406400> rotate<0,-90.000000,0> translate<81.788000,0.000000,21.590000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.788000,0.000000,25.146000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.788000,0.000000,21.844000>}
box{<0,0,-0.406400><3.302000,0.035000,0.406400> rotate<0,-90.000000,0> translate<81.788000,0.000000,21.844000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.788000,0.000000,21.844000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.788000,0.000000,22.860000>}
box{<0,0,-0.406400><1.016000,0.035000,0.406400> rotate<0,90.000000,0> translate<81.788000,0.000000,22.860000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.772000,0.000000,26.162000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.788000,0.000000,25.146000>}
box{<0,0,-0.406400><1.436841,0.035000,0.406400> rotate<0,44.997030,0> translate<80.772000,0.000000,26.162000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.788000,0.000000,21.844000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.912000,0.000000,21.720000>}
box{<0,0,-0.406400><0.175362,0.035000,0.406400> rotate<0,44.997030,0> translate<81.788000,0.000000,21.844000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.915000,0.000000,41.935400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.915000,0.000000,43.512800>}
box{<0,0,-0.406400><1.577400,0.035000,0.406400> rotate<0,90.000000,0> translate<81.915000,0.000000,43.512800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.788000,0.000000,21.590000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.918000,0.000000,21.720000>}
box{<0,0,-0.406400><0.183848,0.035000,0.406400> rotate<0,-44.997030,0> translate<81.788000,0.000000,21.590000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<78.105000,-1.535000,32.385000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<82.144800,-1.535000,36.678800>}
box{<0,0,-0.406400><5.895482,0.035000,0.406400> rotate<0,-46.742694,0> translate<78.105000,-1.535000,32.385000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.111600,0.000000,54.203600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<82.904800,0.000000,56.996800>}
box{<0,0,-0.406400><3.950181,0.035000,0.406400> rotate<0,-44.997030,0> translate<80.111600,0.000000,54.203600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.915000,0.000000,41.935400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<82.981800,0.000000,40.614600>}
box{<0,0,-0.406400><1.697815,0.035000,0.406400> rotate<0,51.069086,0> translate<81.915000,0.000000,41.935400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.912000,0.000000,21.720000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<83.030000,0.000000,19.670000>}
box{<0,0,-0.406400><2.335043,0.035000,0.406400> rotate<0,61.389405,0> translate<81.912000,0.000000,21.720000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.918000,0.000000,21.720000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<83.030000,0.000000,19.670000>}
box{<0,0,-0.406400><2.332176,0.035000,0.406400> rotate<0,61.518808,0> translate<81.918000,0.000000,21.720000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<83.030000,-1.535000,19.670000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<83.043000,-1.535000,19.670000>}
box{<0,0,-0.508000><0.013000,0.035000,0.508000> rotate<0,0.000000,0> translate<83.030000,-1.535000,19.670000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<80.772000,-1.535000,21.971000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<83.058000,-1.535000,19.685000>}
box{<0,0,-0.508000><3.232892,0.035000,0.508000> rotate<0,44.997030,0> translate<80.772000,-1.535000,21.971000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<83.043000,-1.535000,19.670000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<83.058000,-1.535000,19.685000>}
box{<0,0,-0.508000><0.021213,0.035000,0.508000> rotate<0,-44.997030,0> translate<83.043000,-1.535000,19.670000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<82.904800,0.000000,56.996800>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<83.185000,0.000000,57.023000>}
box{<0,0,-0.317500><0.281422,0.035000,0.317500> rotate<0,-5.341537,0> translate<82.904800,0.000000,56.996800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<83.186400,0.000000,52.122200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<83.186400,0.000000,51.917600>}
box{<0,0,-0.406400><0.204600,0.035000,0.406400> rotate<0,-90.000000,0> translate<83.186400,0.000000,51.917600> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<83.185000,0.000000,57.023000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<83.947000,0.000000,57.023000>}
box{<0,0,-0.317500><0.762000,0.035000,0.317500> rotate<0,0.000000,0> translate<83.185000,0.000000,57.023000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<80.391000,0.000000,63.500000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<83.947000,0.000000,63.500000>}
box{<0,0,-0.317500><3.556000,0.035000,0.317500> rotate<0,0.000000,0> translate<80.391000,0.000000,63.500000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<83.947000,0.000000,57.023000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<84.150200,0.000000,56.196800>}
box{<0,0,-0.317500><0.850821,0.035000,0.317500> rotate<0,76.177588,0> translate<83.947000,0.000000,57.023000> }
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<83.947000,0.000000,63.500000>}
cylinder{<0,0,0><0,0.035000,0>0.317500 translate<84.150200,0.000000,64.071800>}
box{<0,0,-0.317500><0.606832,0.035000,0.317500> rotate<0,-70.431715,0> translate<83.947000,0.000000,63.500000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<84.150200,0.000000,64.071800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<84.327200,0.000000,63.246800>}
box{<0,0,-0.406400><0.843774,0.035000,0.406400> rotate<0,77.885875,0> translate<84.150200,0.000000,64.071800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<84.302600,0.000000,63.271400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<84.327200,0.000000,63.246800>}
box{<0,0,-0.406400><0.034790,0.035000,0.406400> rotate<0,44.997030,0> translate<84.302600,0.000000,63.271400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<83.186400,0.000000,52.122200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<84.582000,0.000000,53.390800>}
box{<0,0,-0.406400><1.886013,0.035000,0.406400> rotate<0,-42.268038,0> translate<83.186400,0.000000,52.122200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.026000,0.000000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<84.836000,0.000000,16.764000>}
box{<0,0,-0.406400><3.810000,0.035000,0.406400> rotate<0,0.000000,0> translate<81.026000,0.000000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<83.030000,0.000000,19.670000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<85.214000,0.000000,20.831000>}
box{<0,0,-0.406400><2.473414,0.035000,0.406400> rotate<0,-27.992970,0> translate<83.030000,0.000000,19.670000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<84.836000,0.000000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<85.515600,0.000000,17.443600>}
box{<0,0,-0.406400><0.961100,0.035000,0.406400> rotate<0,-44.997030,0> translate<84.836000,0.000000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<85.214000,0.000000,20.831000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<85.515600,0.000000,20.910400>}
box{<0,0,-0.406400><0.311876,0.035000,0.406400> rotate<0,-14.748200,0> translate<85.214000,0.000000,20.831000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<85.515600,0.000000,20.910400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<85.598000,0.000000,20.828000>}
box{<0,0,-0.406400><0.116531,0.035000,0.406400> rotate<0,44.997030,0> translate<85.515600,0.000000,20.910400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.915000,0.000000,34.312800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<85.956200,0.000000,34.312800>}
box{<0,0,-0.406400><4.041200,0.035000,0.406400> rotate<0,0.000000,0> translate<81.915000,0.000000,34.312800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<86.055200,0.000000,25.908000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<86.072000,0.000000,25.924800>}
box{<0,0,-0.406400><0.023759,0.035000,0.406400> rotate<0,-44.997030,0> translate<86.055200,0.000000,25.908000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<86.055200,0.000000,48.564800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<86.117200,0.000000,48.626800>}
box{<0,0,-0.406400><0.087681,0.035000,0.406400> rotate<0,-44.997030,0> translate<86.055200,0.000000,48.564800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<86.072000,0.000000,25.924800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<86.203000,0.000000,25.924800>}
box{<0,0,-0.406400><0.131000,0.035000,0.406400> rotate<0,0.000000,0> translate<86.072000,0.000000,25.924800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<86.203000,0.000000,28.768800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<86.203000,0.000000,31.186600>}
box{<0,0,-0.406400><2.417800,0.035000,0.406400> rotate<0,90.000000,0> translate<86.203000,0.000000,31.186600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<86.117200,0.000000,48.626800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<86.224000,0.000000,48.626800>}
box{<0,0,-0.406400><0.106800,0.035000,0.406400> rotate<0,0.000000,0> translate<86.117200,0.000000,48.626800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<84.582000,0.000000,53.390800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<86.283800,0.000000,53.390800>}
box{<0,0,-0.406400><1.701800,0.035000,0.406400> rotate<0,0.000000,0> translate<84.582000,0.000000,53.390800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<86.055200,0.000000,25.908000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<86.484400,0.000000,25.478800>}
box{<0,0,-0.406400><0.606980,0.035000,0.406400> rotate<0,44.997030,0> translate<86.055200,0.000000,25.908000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<85.515600,0.000000,17.443600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<86.785600,0.000000,18.110600>}
box{<0,0,-0.406400><1.434500,0.035000,0.406400> rotate<0,-27.706485,0> translate<85.515600,0.000000,17.443600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<85.515600,0.000000,20.910400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<86.785600,0.000000,20.910600>}
box{<0,0,-0.406400><1.270000,0.035000,0.406400> rotate<0,-0.009022,0> translate<85.515600,0.000000,20.910400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<85.956200,0.000000,34.312800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<87.553800,0.000000,32.715200>}
box{<0,0,-0.406400><2.259348,0.035000,0.406400> rotate<0,44.997030,0> translate<85.956200,0.000000,34.312800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<87.553800,0.000000,32.715200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<87.782400,0.000000,32.715200>}
box{<0,0,-0.406400><0.228600,0.035000,0.406400> rotate<0,0.000000,0> translate<87.553800,0.000000,32.715200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<87.782400,0.000000,32.766000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<87.782400,0.000000,32.715200>}
box{<0,0,-0.406400><0.050800,0.035000,0.406400> rotate<0,-90.000000,0> translate<87.782400,0.000000,32.715200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<86.203000,0.000000,31.186600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<87.782400,0.000000,32.766000>}
box{<0,0,-0.406400><2.233609,0.035000,0.406400> rotate<0,-44.997030,0> translate<86.203000,0.000000,31.186600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<86.283800,0.000000,53.390800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<87.909400,0.000000,55.778400>}
box{<0,0,-0.406400><2.888461,0.035000,0.406400> rotate<0,-55.747288,0> translate<86.283800,0.000000,53.390800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<87.909400,0.000000,59.664600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<87.909400,0.000000,55.778400>}
box{<0,0,-0.406400><3.886200,0.035000,0.406400> rotate<0,-90.000000,0> translate<87.909400,0.000000,55.778400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<84.327200,0.000000,63.246800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<87.909400,0.000000,59.664600>}
box{<0,0,-0.406400><5.065996,0.035000,0.406400> rotate<0,44.997030,0> translate<84.327200,0.000000,63.246800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<86.224000,0.000000,51.470800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<89.977200,0.000000,51.470800>}
box{<0,0,-0.406400><3.753200,0.035000,0.406400> rotate<0,0.000000,0> translate<86.224000,0.000000,51.470800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<86.055200,0.000000,48.564800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.021200,0.000000,44.598800>}
box{<0,0,-0.406400><5.608771,0.035000,0.406400> rotate<0,44.997030,0> translate<86.055200,0.000000,48.564800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<82.981800,0.000000,40.614600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.093800,0.000000,40.614600>}
box{<0,0,-0.406400><7.112000,0.035000,0.406400> rotate<0,0.000000,0> translate<82.981800,0.000000,40.614600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<87.782400,0.000000,32.715200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.119200,0.000000,32.715200>}
box{<0,0,-0.406400><2.336800,0.035000,0.406400> rotate<0,0.000000,0> translate<87.782400,0.000000,32.715200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.093800,0.000000,40.614600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.119200,0.000000,40.640000>}
box{<0,0,-0.406400><0.035921,0.035000,0.406400> rotate<0,-44.997030,0> translate<90.093800,0.000000,40.614600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.119200,0.000000,40.640000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.120400,0.000000,40.638800>}
box{<0,0,-0.406400><0.001697,0.035000,0.406400> rotate<0,44.997030,0> translate<90.119200,0.000000,40.640000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.119200,0.000000,32.715200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.122800,0.000000,32.718800>}
box{<0,0,-0.406400><0.005091,0.035000,0.406400> rotate<0,-44.997030,0> translate<90.119200,0.000000,32.715200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.122800,0.000000,32.718800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.170000,0.000000,32.718800>}
box{<0,0,-0.406400><0.047200,0.035000,0.406400> rotate<0,0.000000,0> translate<90.122800,0.000000,32.718800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<82.144800,-1.535000,36.678800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.170000,-1.535000,36.678800>}
box{<0,0,-0.406400><8.025200,0.035000,0.406400> rotate<0,0.000000,0> translate<82.144800,-1.535000,36.678800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.120400,0.000000,40.638800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.170000,0.000000,40.638800>}
box{<0,0,-0.406400><0.049600,0.035000,0.406400> rotate<0,0.000000,0> translate<90.120400,0.000000,40.638800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<78.692800,-1.535000,44.598800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.170000,-1.535000,44.598800>}
box{<0,0,-0.406400><11.477200,0.035000,0.406400> rotate<0,0.000000,0> translate<78.692800,-1.535000,44.598800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.021200,0.000000,44.598800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.170000,0.000000,44.598800>}
box{<0,0,-0.406400><0.148800,0.035000,0.406400> rotate<0,0.000000,0> translate<90.021200,0.000000,44.598800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.170000,0.000000,48.234600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.274200,0.000000,48.338800>}
box{<0,0,-0.406400><0.147361,0.035000,0.406400> rotate<0,-44.997030,0> translate<90.170000,0.000000,48.234600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<86.484400,0.000000,25.478800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.297000,0.000000,25.478800>}
box{<0,0,-0.406400><3.812600,0.035000,0.406400> rotate<0,0.000000,0> translate<86.484400,0.000000,25.478800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.274200,0.000000,48.338800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.297000,0.000000,48.338800>}
box{<0,0,-0.406400><0.022800,0.035000,0.406400> rotate<0,0.000000,0> translate<90.274200,0.000000,48.338800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.297000,0.000000,25.478800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.319800,0.000000,25.478800>}
box{<0,0,-0.406400><0.022800,0.035000,0.406400> rotate<0,0.000000,0> translate<90.297000,0.000000,25.478800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<89.977200,0.000000,51.470800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.345200,0.000000,51.838800>}
box{<0,0,-0.406400><0.520431,0.035000,0.406400> rotate<0,-44.997030,0> translate<89.977200,0.000000,51.470800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.297000,0.000000,51.838800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.345200,0.000000,51.838800>}
box{<0,0,-0.406400><0.048200,0.035000,0.406400> rotate<0,0.000000,0> translate<90.297000,0.000000,51.838800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.345200,0.000000,51.838800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.373200,0.000000,51.866800>}
box{<0,0,-0.406400><0.039598,0.035000,0.406400> rotate<0,-44.997030,0> translate<90.345200,0.000000,51.838800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.319800,0.000000,25.478800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.449400,0.000000,25.349200>}
box{<0,0,-0.406400><0.183282,0.035000,0.406400> rotate<0,44.997030,0> translate<90.319800,0.000000,25.478800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.449400,0.000000,25.349200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.579000,0.000000,25.478800>}
box{<0,0,-0.406400><0.183282,0.035000,0.406400> rotate<0,-44.997030,0> translate<90.449400,0.000000,25.349200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.170000,0.000000,36.678800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.854600,0.000000,36.678800>}
box{<0,0,-0.406400><0.684600,0.035000,0.406400> rotate<0,0.000000,0> translate<90.170000,0.000000,36.678800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.170000,0.000000,40.638800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<91.413400,0.000000,40.638800>}
box{<0,0,-0.406400><1.243400,0.035000,0.406400> rotate<0,0.000000,0> translate<90.170000,0.000000,40.638800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.005400,0.000000,48.463200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.129800,0.000000,48.338800>}
box{<0,0,-0.406400><0.175928,0.035000,0.406400> rotate<0,44.997030,0> translate<94.005400,0.000000,48.463200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.297000,0.000000,28.978800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.206000,0.000000,28.978800>}
box{<0,0,-0.406400><3.909000,0.035000,0.406400> rotate<0,0.000000,0> translate<90.297000,0.000000,28.978800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.132400,0.000000,28.905200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.206000,0.000000,28.978800>}
box{<0,0,-0.406400><0.104086,0.035000,0.406400> rotate<0,-44.997030,0> translate<94.132400,0.000000,28.905200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.579000,0.000000,25.478800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.234000,0.000000,25.478800>}
box{<0,0,-0.406400><3.655000,0.035000,0.406400> rotate<0,0.000000,0> translate<90.579000,0.000000,25.478800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.206000,0.000000,28.978800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.234000,0.000000,28.978800>}
box{<0,0,-0.406400><0.028000,0.035000,0.406400> rotate<0,0.000000,0> translate<94.206000,0.000000,28.978800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.234000,0.000000,29.006800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.234000,0.000000,28.978800>}
box{<0,0,-0.406400><0.028000,0.035000,0.406400> rotate<0,-90.000000,0> translate<94.234000,0.000000,28.978800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.206000,0.000000,28.978800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.234000,0.000000,29.006800>}
box{<0,0,-0.406400><0.039598,0.035000,0.406400> rotate<0,-44.997030,0> translate<94.206000,0.000000,28.978800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.234000,0.000000,33.299400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.234000,0.000000,29.006800>}
box{<0,0,-0.406400><4.292600,0.035000,0.406400> rotate<0,-90.000000,0> translate<94.234000,0.000000,29.006800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.854600,0.000000,36.678800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.234000,0.000000,33.299400>}
box{<0,0,-0.406400><4.779193,0.035000,0.406400> rotate<0,44.997030,0> translate<90.854600,0.000000,36.678800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.274200,0.000000,48.338800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.234000,0.000000,48.338800>}
box{<0,0,-0.406400><3.959800,0.035000,0.406400> rotate<0,0.000000,0> translate<90.274200,0.000000,48.338800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.129800,0.000000,48.338800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.234000,0.000000,48.338800>}
box{<0,0,-0.406400><0.104200,0.035000,0.406400> rotate<0,0.000000,0> translate<94.129800,0.000000,48.338800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<90.297000,0.000000,51.838800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.236600,0.000000,51.838800>}
box{<0,0,-0.406400><3.939600,0.035000,0.406400> rotate<0,0.000000,0> translate<90.297000,0.000000,51.838800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.234000,0.000000,51.838800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.236600,0.000000,51.838800>}
box{<0,0,-0.406400><0.002600,0.035000,0.406400> rotate<0,0.000000,0> translate<94.234000,0.000000,51.838800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<91.413400,0.000000,40.638800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.259400,0.000000,43.484800>}
box{<0,0,-0.406400><4.024852,0.035000,0.406400> rotate<0,-44.997030,0> translate<91.413400,0.000000,40.638800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.129800,0.000000,48.338800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.259400,0.000000,48.209200>}
box{<0,0,-0.406400><0.183282,0.035000,0.406400> rotate<0,44.997030,0> translate<94.129800,0.000000,48.338800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.259400,0.000000,43.484800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.259400,0.000000,48.209200>}
box{<0,0,-0.406400><4.724400,0.035000,0.406400> rotate<0,90.000000,0> translate<94.259400,0.000000,48.209200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.236600,0.000000,51.838800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<94.284800,0.000000,51.790600>}
box{<0,0,-0.406400><0.068165,0.035000,0.406400> rotate<0,44.997030,0> translate<94.236600,0.000000,51.838800> }
//Text
//Rect
union{
texture{col_pds}
}
texture{col_wrs}
}
#end
#if(pcb_polygons=on)
union{
//Polygons
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.640000,0.000000,10.160000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.640000,0.000000,68.580000>}
box{<0,0,-0.203200><58.420000,0.035000,0.203200> rotate<0,90.000000,0> translate<40.640000,0.000000,68.580000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.640000,-1.535000,10.160000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.640000,-1.535000,68.580000>}
box{<0,0,-0.203200><58.420000,0.035000,0.203200> rotate<0,90.000000,0> translate<40.640000,-1.535000,68.580000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.640000,0.000000,10.160000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<99.060000,0.000000,10.160000>}
box{<0,0,-0.203200><58.420000,0.035000,0.203200> rotate<0,0.000000,0> translate<40.640000,0.000000,10.160000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.640000,-1.535000,10.160000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<99.060000,-1.535000,10.160000>}
box{<0,0,-0.203200><58.420000,0.035000,0.203200> rotate<0,0.000000,0> translate<40.640000,-1.535000,10.160000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.640000,0.000000,68.580000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<99.060000,0.000000,68.580000>}
box{<0,0,-0.203200><58.420000,0.035000,0.203200> rotate<0,0.000000,0> translate<40.640000,0.000000,68.580000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.640000,-1.535000,68.580000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<99.060000,-1.535000,68.580000>}
box{<0,0,-0.203200><58.420000,0.035000,0.203200> rotate<0,0.000000,0> translate<40.640000,-1.535000,68.580000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<99.060000,0.000000,68.580000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<99.060000,0.000000,10.160000>}
box{<0,0,-0.203200><58.420000,0.035000,0.203200> rotate<0,-90.000000,0> translate<99.060000,0.000000,10.160000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<99.060000,-1.535000,68.580000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<99.060000,-1.535000,10.160000>}
box{<0,0,-0.203200><58.420000,0.035000,0.203200> rotate<0,-90.000000,0> translate<99.060000,-1.535000,10.160000> }
texture{col_pol}
}
#end
union{
cylinder{<50.419000,0.038000,51.054000><50.419000,-1.538000,51.054000>0.444500}
cylinder{<52.959000,0.038000,49.784000><52.959000,-1.538000,49.784000>0.444500}
cylinder{<50.419000,0.038000,48.514000><50.419000,-1.538000,48.514000>0.444500}
cylinder{<52.959000,0.038000,47.244000><52.959000,-1.538000,47.244000>0.444500}
cylinder{<50.419000,0.038000,45.974000><50.419000,-1.538000,45.974000>0.444500}
cylinder{<52.959000,0.038000,44.704000><52.959000,-1.538000,44.704000>0.444500}
cylinder{<50.419000,0.038000,43.434000><50.419000,-1.538000,43.434000>0.444500}
cylinder{<52.959000,0.038000,42.164000><52.959000,-1.538000,42.164000>0.444500}
cylinder{<50.419000,0.038000,35.433000><50.419000,-1.538000,35.433000>0.444500}
cylinder{<52.959000,0.038000,34.163000><52.959000,-1.538000,34.163000>0.444500}
cylinder{<50.419000,0.038000,32.893000><50.419000,-1.538000,32.893000>0.444500}
cylinder{<52.959000,0.038000,31.623000><52.959000,-1.538000,31.623000>0.444500}
cylinder{<50.419000,0.038000,30.353000><50.419000,-1.538000,30.353000>0.444500}
cylinder{<52.959000,0.038000,29.083000><52.959000,-1.538000,29.083000>0.444500}
cylinder{<50.419000,0.038000,27.813000><50.419000,-1.538000,27.813000>0.444500}
cylinder{<52.959000,0.038000,26.543000><52.959000,-1.538000,26.543000>0.444500}
cylinder{<59.613800,0.038000,60.121800><59.613800,-1.538000,60.121800>0.800000}
cylinder{<64.693800,0.038000,60.121800><64.693800,-1.538000,60.121800>0.800000}
cylinder{<69.773800,0.038000,60.121800><69.773800,-1.538000,60.121800>0.800000}
cylinder{<74.853800,0.038000,60.121800><74.853800,-1.538000,60.121800>0.800000}
cylinder{<83.030000,0.038000,19.670000><83.030000,-1.538000,19.670000>0.406400}
cylinder{<77.950000,0.038000,19.670000><77.950000,-1.538000,19.670000>0.406400}
cylinder{<80.490000,0.038000,17.130000><80.490000,-1.538000,17.130000>0.406400}
cylinder{<61.087000,0.038000,13.970000><61.087000,-1.538000,13.970000>0.457200}
cylinder{<61.087000,0.038000,16.510000><61.087000,-1.538000,16.510000>0.457200}
cylinder{<63.627000,0.038000,13.970000><63.627000,-1.538000,13.970000>0.457200}
cylinder{<63.627000,0.038000,16.510000><63.627000,-1.538000,16.510000>0.457200}
cylinder{<66.167000,0.038000,13.970000><66.167000,-1.538000,13.970000>0.457200}
cylinder{<66.167000,0.038000,16.510000><66.167000,-1.538000,16.510000>0.457200}
cylinder{<68.707000,0.038000,13.970000><68.707000,-1.538000,13.970000>0.457200}
cylinder{<68.707000,0.038000,16.510000><68.707000,-1.538000,16.510000>0.457200}
cylinder{<71.247000,0.038000,13.970000><71.247000,-1.538000,13.970000>0.457200}
cylinder{<71.247000,0.038000,16.510000><71.247000,-1.538000,16.510000>0.457200}
cylinder{<80.519800,0.038000,13.962400><80.519800,-1.538000,13.962400>0.660400}
cylinder{<90.170000,0.038000,32.718800><90.170000,-1.538000,32.718800>0.850000}
cylinder{<90.170000,0.038000,36.678800><90.170000,-1.538000,36.678800>0.850000}
cylinder{<90.170000,0.038000,40.638800><90.170000,-1.538000,40.638800>0.850000}
cylinder{<90.170000,0.038000,44.598800><90.170000,-1.538000,44.598800>0.850000}
cylinder{<45.974000,0.038000,49.149000><45.974000,-1.538000,49.149000>0.500000}
cylinder{<45.974000,0.038000,46.609000><45.974000,-1.538000,46.609000>0.500000}
cylinder{<45.974000,0.038000,44.069000><45.974000,-1.538000,44.069000>0.500000}
cylinder{<45.974000,0.038000,33.528000><45.974000,-1.538000,33.528000>0.500000}
cylinder{<45.974000,0.038000,30.988000><45.974000,-1.538000,30.988000>0.500000}
cylinder{<45.974000,0.038000,28.448000><45.974000,-1.538000,28.448000>0.500000}
//Holes(fast)/Vias
cylinder{<78.105000,0.038000,32.385000><78.105000,-1.538000,32.385000>0.300000 }
cylinder{<77.978000,0.038000,45.440600><77.978000,-1.538000,45.440600>0.300000 }
cylinder{<77.038200,0.038000,36.398200><77.038200,-1.538000,36.398200>0.254000 }
cylinder{<65.862200,0.038000,25.577800><65.862200,-1.538000,25.577800>0.254000 }
cylinder{<77.038200,0.038000,41.173400><77.038200,-1.538000,41.173400>0.254000 }
cylinder{<59.309000,0.038000,40.767000><59.309000,-1.538000,40.767000>0.304800 }
cylinder{<65.481200,0.038000,21.742400><65.481200,-1.538000,21.742400>0.254000 }
cylinder{<63.652400,0.038000,23.571200><63.652400,-1.538000,23.571200>0.254000 }
cylinder{<63.017400,0.038000,21.615400><63.017400,-1.538000,21.615400>0.254000 }
cylinder{<67.767200,0.038000,22.301200><67.767200,-1.538000,22.301200>0.254000 }
cylinder{<67.183000,0.038000,52.705000><67.183000,-1.538000,52.705000>0.304800 }
cylinder{<74.498200,0.038000,53.416200><74.498200,-1.538000,53.416200>0.254000 }
cylinder{<66.421000,0.038000,43.611800><66.421000,-1.538000,43.611800>0.254000 }
cylinder{<66.421000,0.038000,33.959800><66.421000,-1.538000,33.959800>0.254000 }
cylinder{<60.833000,0.038000,34.975800><60.833000,-1.538000,34.975800>0.254000 }
//Holes(fast)/Board
texture{col_hls}
}
#if(pcb_silkscreen=on)
//Silk Screen
union{
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.011300,0.000000,66.176200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.816400,0.000000,66.371100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<51.816400,0.000000,66.371100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.816400,0.000000,66.371100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.426600,0.000000,66.371100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<51.426600,0.000000,66.371100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.426600,0.000000,66.371100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.231800,0.000000,66.176200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<51.231800,0.000000,66.176200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.231800,0.000000,66.176200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.231800,0.000000,65.981300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<51.231800,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.231800,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.426600,0.000000,65.786400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<51.231800,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.426600,0.000000,65.786400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.816400,0.000000,65.786400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<51.426600,0.000000,65.786400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.816400,0.000000,65.786400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.011300,0.000000,65.591500>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<51.816400,0.000000,65.786400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.011300,0.000000,65.591500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.011300,0.000000,65.396600>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<52.011300,0.000000,65.396600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.011300,0.000000,65.396600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.816400,0.000000,65.201800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<51.816400,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.816400,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.426600,0.000000,65.201800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<51.426600,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.426600,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.231800,0.000000,65.396600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<51.231800,0.000000,65.396600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.595900,0.000000,66.176200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.595900,0.000000,65.396600>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,-90.000000,0> translate<52.595900,0.000000,65.396600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.595900,0.000000,65.396600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.790800,0.000000,65.201800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<52.595900,0.000000,65.396600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.401100,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.790800,0.000000,65.981300>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,0.000000,0> translate<52.401100,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.765200,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.375400,0.000000,65.201800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<53.375400,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.375400,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.180600,0.000000,65.396600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<53.180600,0.000000,65.396600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.180600,0.000000,65.396600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.180600,0.000000,65.786400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<53.180600,0.000000,65.786400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.180600,0.000000,65.786400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.375400,0.000000,65.981300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<53.180600,0.000000,65.786400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.375400,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.765200,0.000000,65.981300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<53.375400,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.765200,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.960100,0.000000,65.786400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<53.765200,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.960100,0.000000,65.786400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.960100,0.000000,65.591500>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<53.960100,0.000000,65.591500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.960100,0.000000,65.591500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.180600,0.000000,65.591500>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<53.180600,0.000000,65.591500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.349900,0.000000,64.812100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.349900,0.000000,65.981300>}
box{<0,0,-0.050800><1.169200,0.036000,0.050800> rotate<0,90.000000,0> translate<54.349900,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.349900,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.934500,0.000000,65.981300>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<54.349900,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.934500,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.129400,0.000000,65.786400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<54.934500,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.129400,0.000000,65.786400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.129400,0.000000,65.396600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<55.129400,0.000000,65.396600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.129400,0.000000,65.396600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.934500,0.000000,65.201800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<54.934500,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.934500,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.349900,0.000000,65.201800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<54.349900,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.519200,0.000000,64.812100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.519200,0.000000,65.981300>}
box{<0,0,-0.050800><1.169200,0.036000,0.050800> rotate<0,90.000000,0> translate<55.519200,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.519200,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.103800,0.000000,65.981300>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<55.519200,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.103800,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.298700,0.000000,65.786400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<56.103800,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.298700,0.000000,65.786400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.298700,0.000000,65.396600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<56.298700,0.000000,65.396600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.298700,0.000000,65.396600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.103800,0.000000,65.201800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<56.103800,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.103800,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.519200,0.000000,65.201800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<55.519200,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.273100,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.883300,0.000000,65.201800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<56.883300,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.883300,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.688500,0.000000,65.396600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<56.688500,0.000000,65.396600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.688500,0.000000,65.396600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.688500,0.000000,65.786400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<56.688500,0.000000,65.786400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.688500,0.000000,65.786400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.883300,0.000000,65.981300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<56.688500,0.000000,65.786400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.883300,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.273100,0.000000,65.981300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<56.883300,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.273100,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.468000,0.000000,65.786400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<57.273100,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.468000,0.000000,65.786400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.468000,0.000000,65.591500>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<57.468000,0.000000,65.591500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.468000,0.000000,65.591500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.688500,0.000000,65.591500>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<56.688500,0.000000,65.591500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.857800,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.857800,0.000000,65.981300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<57.857800,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.857800,0.000000,65.591500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.247500,0.000000,65.981300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<57.857800,0.000000,65.591500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.247500,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.442400,0.000000,65.981300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<58.247500,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.001500,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.001500,0.000000,66.371100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,90.000000,0> translate<60.001500,0.000000,66.371100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.001500,0.000000,66.371100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.391200,0.000000,65.981300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,45.004380,0> translate<60.001500,0.000000,66.371100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.391200,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.781000,0.000000,66.371100>}
box{<0,0,-0.050800><0.551260,0.036000,0.050800> rotate<0,-44.997030,0> translate<60.391200,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.781000,0.000000,66.371100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.781000,0.000000,65.201800>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,-90.000000,0> translate<60.781000,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.365600,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.755400,0.000000,65.201800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<61.365600,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.755400,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.950300,0.000000,65.396600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<61.755400,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.950300,0.000000,65.396600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.950300,0.000000,65.786400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<61.950300,0.000000,65.786400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.950300,0.000000,65.786400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.755400,0.000000,65.981300>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<61.755400,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.755400,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.365600,0.000000,65.981300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<61.365600,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.365600,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.170800,0.000000,65.786400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<61.170800,0.000000,65.786400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.170800,0.000000,65.786400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.170800,0.000000,65.396600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<61.170800,0.000000,65.396600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.170800,0.000000,65.396600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.365600,0.000000,65.201800>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<61.170800,0.000000,65.396600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.534900,0.000000,66.176200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.534900,0.000000,65.396600>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,-90.000000,0> translate<62.534900,0.000000,65.396600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.534900,0.000000,65.396600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.729800,0.000000,65.201800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<62.534900,0.000000,65.396600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.340100,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.729800,0.000000,65.981300>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,0.000000,0> translate<62.340100,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.314400,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.704200,0.000000,65.201800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<63.314400,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.704200,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.899100,0.000000,65.396600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<63.704200,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.899100,0.000000,65.396600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.899100,0.000000,65.786400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<63.899100,0.000000,65.786400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.899100,0.000000,65.786400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.704200,0.000000,65.981300>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<63.704200,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.704200,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.314400,0.000000,65.981300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<63.314400,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.314400,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.119600,0.000000,65.786400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<63.119600,0.000000,65.786400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.119600,0.000000,65.786400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.119600,0.000000,65.396600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<63.119600,0.000000,65.396600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.119600,0.000000,65.396600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.314400,0.000000,65.201800>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<63.119600,0.000000,65.396600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.288900,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.288900,0.000000,65.981300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<64.288900,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.288900,0.000000,65.591500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.678600,0.000000,65.981300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<64.288900,0.000000,65.591500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.678600,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.873500,0.000000,65.981300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<64.678600,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.432600,0.000000,66.371100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.432600,0.000000,65.201800>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,-90.000000,0> translate<66.432600,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.432600,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.017200,0.000000,65.201800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<66.432600,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.017200,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.212100,0.000000,65.396600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<67.017200,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.212100,0.000000,65.396600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.212100,0.000000,66.176200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,90.000000,0> translate<67.212100,0.000000,66.176200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.212100,0.000000,66.176200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.017200,0.000000,66.371100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<67.017200,0.000000,66.371100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.017200,0.000000,66.371100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.432600,0.000000,66.371100>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<66.432600,0.000000,66.371100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.601900,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.601900,0.000000,65.981300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<67.601900,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.601900,0.000000,65.591500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.991600,0.000000,65.981300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<67.601900,0.000000,65.591500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.991600,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.186500,0.000000,65.981300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<67.991600,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.576300,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.771100,0.000000,65.981300>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<68.576300,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.771100,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.771100,0.000000,65.201800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<68.771100,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.576300,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.966000,0.000000,65.201800>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,0.000000,0> translate<68.576300,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.771100,0.000000,66.566000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.771100,0.000000,66.371100>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<68.771100,0.000000,66.371100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.355800,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.745500,0.000000,65.201800>}
box{<0,0,-0.050800><0.871485,0.036000,0.050800> rotate<0,63.433702,0> translate<69.355800,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.745500,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<70.135300,0.000000,65.981300>}
box{<0,0,-0.050800><0.871530,0.036000,0.050800> rotate<0,-63.427823,0> translate<69.745500,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.109700,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<70.719900,0.000000,65.201800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<70.719900,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<70.719900,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<70.525100,0.000000,65.396600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<70.525100,0.000000,65.396600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<70.525100,0.000000,65.396600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<70.525100,0.000000,65.786400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<70.525100,0.000000,65.786400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<70.525100,0.000000,65.786400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<70.719900,0.000000,65.981300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<70.525100,0.000000,65.786400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<70.719900,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.109700,0.000000,65.981300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<70.719900,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.109700,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.304600,0.000000,65.786400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<71.109700,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.304600,0.000000,65.786400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.304600,0.000000,65.591500>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<71.304600,0.000000,65.591500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.304600,0.000000,65.591500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<70.525100,0.000000,65.591500>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<70.525100,0.000000,65.591500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.694400,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.694400,0.000000,65.981300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<71.694400,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.694400,0.000000,65.591500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084100,0.000000,65.981300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<71.694400,0.000000,65.591500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084100,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.279000,0.000000,65.981300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<72.084100,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.838100,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.227800,0.000000,65.201800>}
box{<0,0,-0.050800><0.871485,0.036000,0.050800> rotate<0,63.433702,0> translate<73.838100,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.227800,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.617600,0.000000,65.981300>}
box{<0,0,-0.050800><0.871530,0.036000,0.050800> rotate<0,-63.427823,0> translate<74.227800,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.786900,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.007400,0.000000,65.201800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<75.007400,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.007400,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.786900,0.000000,65.981300>}
box{<0,0,-0.050800><1.102379,0.036000,0.050800> rotate<0,-44.997030,0> translate<75.007400,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.786900,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.786900,0.000000,66.176200>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,90.000000,0> translate<75.786900,0.000000,66.176200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.786900,0.000000,66.176200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.592000,0.000000,66.371100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<75.592000,0.000000,66.371100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.592000,0.000000,66.371100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.202200,0.000000,66.371100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<75.202200,0.000000,66.371100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.202200,0.000000,66.371100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.007400,0.000000,66.176200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<75.007400,0.000000,66.176200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.176700,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.176700,0.000000,65.396600>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,90.000000,0> translate<76.176700,0.000000,65.396600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.176700,0.000000,65.396600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.371500,0.000000,65.396600>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<76.176700,0.000000,65.396600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.371500,0.000000,65.396600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.371500,0.000000,65.201800>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,-90.000000,0> translate<76.371500,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.371500,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.176700,0.000000,65.201800>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<76.176700,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.761300,0.000000,66.176200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.956100,0.000000,66.371100>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<76.761300,0.000000,66.176200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.956100,0.000000,66.371100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.345900,0.000000,66.371100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<76.956100,0.000000,66.371100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.345900,0.000000,66.371100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.540800,0.000000,66.176200>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<77.345900,0.000000,66.371100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.540800,0.000000,66.176200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.540800,0.000000,65.981300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<77.540800,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.540800,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.345900,0.000000,65.786400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<77.345900,0.000000,65.786400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.345900,0.000000,65.786400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.151000,0.000000,65.786400>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<77.151000,0.000000,65.786400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.345900,0.000000,65.786400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.540800,0.000000,65.591500>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<77.345900,0.000000,65.786400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.540800,0.000000,65.591500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.540800,0.000000,65.396600>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<77.540800,0.000000,65.396600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.540800,0.000000,65.396600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.345900,0.000000,65.201800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<77.345900,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.345900,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.956100,0.000000,65.201800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<76.956100,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.956100,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.761300,0.000000,65.396600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<76.761300,0.000000,65.396600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.099900,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.099900,0.000000,65.981300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<79.099900,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.099900,0.000000,65.591500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.489600,0.000000,65.981300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<79.099900,0.000000,65.591500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.489600,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.684500,0.000000,65.981300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<79.489600,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<80.074300,0.000000,65.981300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<80.464000,0.000000,66.371100>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<80.074300,0.000000,65.981300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<80.464000,0.000000,66.371100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<80.464000,0.000000,65.201800>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,-90.000000,0> translate<80.464000,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<80.074300,0.000000,65.201800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<80.853800,0.000000,65.201800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<80.074300,0.000000,65.201800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.573900,0.000000,34.739300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.573900,0.000000,34.230800>}
box{<0,0,-0.050800><0.508500,0.036000,0.050800> rotate<0,-90.000000,0> translate<83.573900,0.000000,34.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.573900,0.000000,34.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.743400,0.000000,34.061400>}
box{<0,0,-0.050800><0.239638,0.036000,0.050800> rotate<0,44.980125,0> translate<83.573900,0.000000,34.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.743400,0.000000,34.061400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.082400,0.000000,34.061400>}
box{<0,0,-0.050800><0.339000,0.036000,0.050800> rotate<0,0.000000,0> translate<83.743400,0.000000,34.061400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.082400,0.000000,34.061400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,34.230800>}
box{<0,0,-0.050800><0.239568,0.036000,0.050800> rotate<0,-44.997030,0> translate<84.082400,0.000000,34.061400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,34.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,34.739300>}
box{<0,0,-0.050800><0.508500,0.036000,0.050800> rotate<0,90.000000,0> translate<84.251800,0.000000,34.739300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,35.090400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,35.090400>}
box{<0,0,-0.050800><1.016800,0.036000,0.050800> rotate<0,0.000000,0> translate<83.235000,0.000000,35.090400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,35.090400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,35.598800>}
box{<0,0,-0.050800><0.508400,0.036000,0.050800> rotate<0,90.000000,0> translate<83.235000,0.000000,35.598800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,35.598800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,35.768300>}
box{<0,0,-0.050800><0.239709,0.036000,0.050800> rotate<0,-44.997030,0> translate<83.235000,0.000000,35.598800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,35.768300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.743400,0.000000,35.768300>}
box{<0,0,-0.050800><0.338900,0.036000,0.050800> rotate<0,0.000000,0> translate<83.404500,0.000000,35.768300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.743400,0.000000,35.768300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.912900,0.000000,35.598800>}
box{<0,0,-0.050800><0.239709,0.036000,0.050800> rotate<0,44.997030,0> translate<83.743400,0.000000,35.768300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.912900,0.000000,35.598800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.912900,0.000000,35.090400>}
box{<0,0,-0.050800><0.508400,0.036000,0.050800> rotate<0,-90.000000,0> translate<83.912900,0.000000,35.090400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.912900,0.000000,35.429300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,35.768300>}
box{<0,0,-0.050800><0.479348,0.036000,0.050800> rotate<0,-45.005482,0> translate<83.912900,0.000000,35.429300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,36.119400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,36.119400>}
box{<0,0,-0.050800><1.016800,0.036000,0.050800> rotate<0,0.000000,0> translate<83.235000,0.000000,36.119400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,36.119400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,36.627800>}
box{<0,0,-0.050800><0.508400,0.036000,0.050800> rotate<0,90.000000,0> translate<83.235000,0.000000,36.627800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,36.627800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,36.797300>}
box{<0,0,-0.050800><0.239709,0.036000,0.050800> rotate<0,-44.997030,0> translate<83.235000,0.000000,36.627800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,36.797300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.743400,0.000000,36.797300>}
box{<0,0,-0.050800><0.338900,0.036000,0.050800> rotate<0,0.000000,0> translate<83.404500,0.000000,36.797300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.743400,0.000000,36.797300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.912900,0.000000,36.627800>}
box{<0,0,-0.050800><0.239709,0.036000,0.050800> rotate<0,44.997030,0> translate<83.743400,0.000000,36.797300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.912900,0.000000,36.627800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.912900,0.000000,36.119400>}
box{<0,0,-0.050800><0.508400,0.036000,0.050800> rotate<0,-90.000000,0> translate<83.912900,0.000000,36.119400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.912900,0.000000,36.458300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,36.797300>}
box{<0,0,-0.050800><0.479348,0.036000,0.050800> rotate<0,-45.005482,0> translate<83.912900,0.000000,36.458300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,37.148400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,37.148400>}
box{<0,0,-0.050800><1.016800,0.036000,0.050800> rotate<0,0.000000,0> translate<83.235000,0.000000,37.148400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,37.148400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,37.656800>}
box{<0,0,-0.050800><0.508400,0.036000,0.050800> rotate<0,90.000000,0> translate<83.235000,0.000000,37.656800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,37.656800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,37.826300>}
box{<0,0,-0.050800><0.239709,0.036000,0.050800> rotate<0,-44.997030,0> translate<83.235000,0.000000,37.656800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,37.826300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.743400,0.000000,37.826300>}
box{<0,0,-0.050800><0.338900,0.036000,0.050800> rotate<0,0.000000,0> translate<83.404500,0.000000,37.826300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.743400,0.000000,37.826300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.912900,0.000000,37.656800>}
box{<0,0,-0.050800><0.239709,0.036000,0.050800> rotate<0,44.997030,0> translate<83.743400,0.000000,37.826300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.912900,0.000000,37.656800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.912900,0.000000,37.148400>}
box{<0,0,-0.050800><0.508400,0.036000,0.050800> rotate<0,-90.000000,0> translate<83.912900,0.000000,37.148400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.912900,0.000000,37.487300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,37.826300>}
box{<0,0,-0.050800><0.479348,0.036000,0.050800> rotate<0,-45.005482,0> translate<83.912900,0.000000,37.487300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,38.177400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,38.177400>}
box{<0,0,-0.050800><1.016800,0.036000,0.050800> rotate<0,0.000000,0> translate<83.235000,0.000000,38.177400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,38.177400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,38.855300>}
box{<0,0,-0.050800><0.677900,0.036000,0.050800> rotate<0,90.000000,0> translate<83.235000,0.000000,38.855300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.743400,0.000000,38.177400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.743400,0.000000,38.516300>}
box{<0,0,-0.050800><0.338900,0.036000,0.050800> rotate<0,90.000000,0> translate<83.743400,0.000000,38.516300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,40.913300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,40.235400>}
box{<0,0,-0.050800><0.677900,0.036000,0.050800> rotate<0,-90.000000,0> translate<84.251800,0.000000,40.235400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,40.235400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.573900,0.000000,40.913300>}
box{<0,0,-0.050800><0.958695,0.036000,0.050800> rotate<0,44.997030,0> translate<83.573900,0.000000,40.913300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.573900,0.000000,40.913300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,40.913300>}
box{<0,0,-0.050800><0.169400,0.036000,0.050800> rotate<0,0.000000,0> translate<83.404500,0.000000,40.913300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,40.913300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,40.743800>}
box{<0,0,-0.050800><0.239709,0.036000,0.050800> rotate<0,-44.997030,0> translate<83.235000,0.000000,40.743800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,40.743800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,40.404800>}
box{<0,0,-0.050800><0.339000,0.036000,0.050800> rotate<0,-90.000000,0> translate<83.235000,0.000000,40.404800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,40.404800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,40.235400>}
box{<0,0,-0.050800><0.239638,0.036000,0.050800> rotate<0,44.980125,0> translate<83.235000,0.000000,40.404800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.082400,0.000000,41.264400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,41.264400>}
box{<0,0,-0.050800><0.677900,0.036000,0.050800> rotate<0,0.000000,0> translate<83.404500,0.000000,41.264400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,41.264400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,41.433800>}
box{<0,0,-0.050800><0.239638,0.036000,0.050800> rotate<0,44.980125,0> translate<83.235000,0.000000,41.433800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,41.433800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,41.772800>}
box{<0,0,-0.050800><0.339000,0.036000,0.050800> rotate<0,90.000000,0> translate<83.235000,0.000000,41.772800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,41.772800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,41.942300>}
box{<0,0,-0.050800><0.239709,0.036000,0.050800> rotate<0,-44.997030,0> translate<83.235000,0.000000,41.772800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,41.942300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.082400,0.000000,41.942300>}
box{<0,0,-0.050800><0.677900,0.036000,0.050800> rotate<0,0.000000,0> translate<83.404500,0.000000,41.942300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.082400,0.000000,41.942300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,41.772800>}
box{<0,0,-0.050800><0.239638,0.036000,0.050800> rotate<0,45.013935,0> translate<84.082400,0.000000,41.942300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,41.772800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,41.433800>}
box{<0,0,-0.050800><0.339000,0.036000,0.050800> rotate<0,-90.000000,0> translate<84.251800,0.000000,41.433800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,41.433800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.082400,0.000000,41.264400>}
box{<0,0,-0.050800><0.239568,0.036000,0.050800> rotate<0,-44.997030,0> translate<84.082400,0.000000,41.264400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.082400,0.000000,41.264400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,41.942300>}
box{<0,0,-0.050800><0.958695,0.036000,0.050800> rotate<0,44.997030,0> translate<83.404500,0.000000,41.942300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.082400,0.000000,42.293400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,42.293400>}
box{<0,0,-0.050800><0.677900,0.036000,0.050800> rotate<0,0.000000,0> translate<83.404500,0.000000,42.293400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,42.293400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,42.462800>}
box{<0,0,-0.050800><0.239638,0.036000,0.050800> rotate<0,44.980125,0> translate<83.235000,0.000000,42.462800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,42.462800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,42.801800>}
box{<0,0,-0.050800><0.339000,0.036000,0.050800> rotate<0,90.000000,0> translate<83.235000,0.000000,42.801800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,42.801800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,42.971300>}
box{<0,0,-0.050800><0.239709,0.036000,0.050800> rotate<0,-44.997030,0> translate<83.235000,0.000000,42.801800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,42.971300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.082400,0.000000,42.971300>}
box{<0,0,-0.050800><0.677900,0.036000,0.050800> rotate<0,0.000000,0> translate<83.404500,0.000000,42.971300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.082400,0.000000,42.971300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,42.801800>}
box{<0,0,-0.050800><0.239638,0.036000,0.050800> rotate<0,45.013935,0> translate<84.082400,0.000000,42.971300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,42.801800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,42.462800>}
box{<0,0,-0.050800><0.339000,0.036000,0.050800> rotate<0,-90.000000,0> translate<84.251800,0.000000,42.462800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,42.462800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.082400,0.000000,42.293400>}
box{<0,0,-0.050800><0.239568,0.036000,0.050800> rotate<0,-44.997030,0> translate<84.082400,0.000000,42.293400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.082400,0.000000,42.293400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,42.971300>}
box{<0,0,-0.050800><0.958695,0.036000,0.050800> rotate<0,44.997030,0> translate<83.404500,0.000000,42.971300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,43.322400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,43.491800>}
box{<0,0,-0.050800><0.239638,0.036000,0.050800> rotate<0,44.980125,0> translate<83.235000,0.000000,43.491800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,43.491800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,43.830800>}
box{<0,0,-0.050800><0.339000,0.036000,0.050800> rotate<0,90.000000,0> translate<83.235000,0.000000,43.830800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235000,0.000000,43.830800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,44.000300>}
box{<0,0,-0.050800><0.239709,0.036000,0.050800> rotate<0,-44.997030,0> translate<83.235000,0.000000,43.830800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,44.000300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.573900,0.000000,44.000300>}
box{<0,0,-0.050800><0.169400,0.036000,0.050800> rotate<0,0.000000,0> translate<83.404500,0.000000,44.000300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.573900,0.000000,44.000300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.743400,0.000000,43.830800>}
box{<0,0,-0.050800><0.239709,0.036000,0.050800> rotate<0,44.997030,0> translate<83.573900,0.000000,44.000300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.743400,0.000000,43.830800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.912900,0.000000,44.000300>}
box{<0,0,-0.050800><0.239709,0.036000,0.050800> rotate<0,-44.997030,0> translate<83.743400,0.000000,43.830800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.912900,0.000000,44.000300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.082400,0.000000,44.000300>}
box{<0,0,-0.050800><0.169500,0.036000,0.050800> rotate<0,0.000000,0> translate<83.912900,0.000000,44.000300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.082400,0.000000,44.000300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,43.830800>}
box{<0,0,-0.050800><0.239638,0.036000,0.050800> rotate<0,45.013935,0> translate<84.082400,0.000000,44.000300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,43.830800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,43.491800>}
box{<0,0,-0.050800><0.339000,0.036000,0.050800> rotate<0,-90.000000,0> translate<84.251800,0.000000,43.491800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,43.491800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.082400,0.000000,43.322400>}
box{<0,0,-0.050800><0.239568,0.036000,0.050800> rotate<0,-44.997030,0> translate<84.082400,0.000000,43.322400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.082400,0.000000,43.322400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.912900,0.000000,43.322400>}
box{<0,0,-0.050800><0.169500,0.036000,0.050800> rotate<0,0.000000,0> translate<83.912900,0.000000,43.322400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.912900,0.000000,43.322400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.743400,0.000000,43.491800>}
box{<0,0,-0.050800><0.239638,0.036000,0.050800> rotate<0,44.980125,0> translate<83.743400,0.000000,43.491800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.743400,0.000000,43.491800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.573900,0.000000,43.322400>}
box{<0,0,-0.050800><0.239638,0.036000,0.050800> rotate<0,-44.980125,0> translate<83.573900,0.000000,43.322400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.573900,0.000000,43.322400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.404500,0.000000,43.322400>}
box{<0,0,-0.050800><0.169400,0.036000,0.050800> rotate<0,0.000000,0> translate<83.404500,0.000000,43.322400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.743400,0.000000,43.491800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.743400,0.000000,43.830800>}
box{<0,0,-0.050800><0.339000,0.036000,0.050800> rotate<0,90.000000,0> translate<83.743400,0.000000,43.830800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.600800,0.000000,12.768300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.405900,0.000000,12.573400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<54.405900,0.000000,12.573400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.405900,0.000000,12.573400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.405900,0.000000,12.183600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<54.405900,0.000000,12.183600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.405900,0.000000,12.183600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.600800,0.000000,11.988800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<54.405900,0.000000,12.183600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.600800,0.000000,11.988800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.380400,0.000000,11.988800>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<54.600800,0.000000,11.988800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.380400,0.000000,11.988800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.575200,0.000000,12.183600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<55.380400,0.000000,11.988800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.575200,0.000000,12.183600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.575200,0.000000,12.573400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<55.575200,0.000000,12.573400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.575200,0.000000,12.573400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.380400,0.000000,12.768300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<55.380400,0.000000,12.768300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.380400,0.000000,12.768300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.990600,0.000000,12.768300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<54.990600,0.000000,12.768300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.990600,0.000000,12.768300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.990600,0.000000,12.378500>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<54.990600,0.000000,12.378500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.575200,0.000000,13.158100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.405900,0.000000,13.158100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<54.405900,0.000000,13.158100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.405900,0.000000,13.158100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.405900,0.000000,13.742700>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<54.405900,0.000000,13.742700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.405900,0.000000,13.742700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.600800,0.000000,13.937600>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<54.405900,0.000000,13.742700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.600800,0.000000,13.937600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.990600,0.000000,13.937600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<54.600800,0.000000,13.937600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.990600,0.000000,13.937600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.185500,0.000000,13.742700>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<54.990600,0.000000,13.937600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.185500,0.000000,13.742700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.185500,0.000000,13.158100>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<55.185500,0.000000,13.158100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.405900,0.000000,14.327400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.575200,0.000000,14.327400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<54.405900,0.000000,14.327400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.575200,0.000000,14.327400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.575200,0.000000,15.106900>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<55.575200,0.000000,15.106900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.795700,0.000000,15.496700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.575200,0.000000,15.886400>}
box{<0,0,-0.050800><0.871485,0.036000,0.050800> rotate<0,-26.560358,0> translate<54.795700,0.000000,15.496700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.575200,0.000000,15.886400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.795700,0.000000,16.276200>}
box{<0,0,-0.050800><0.871530,0.036000,0.050800> rotate<0,26.566238,0> translate<54.795700,0.000000,16.276200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.575200,0.000000,17.445500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.575200,0.000000,16.666000>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<55.575200,0.000000,16.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.575200,0.000000,16.666000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.795700,0.000000,17.445500>}
box{<0,0,-0.050800><1.102379,0.036000,0.050800> rotate<0,44.997030,0> translate<54.795700,0.000000,17.445500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.795700,0.000000,17.445500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.600800,0.000000,17.445500>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<54.600800,0.000000,17.445500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.600800,0.000000,17.445500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.405900,0.000000,17.250600>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<54.405900,0.000000,17.250600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.405900,0.000000,17.250600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.405900,0.000000,16.860800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<54.405900,0.000000,16.860800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.405900,0.000000,16.860800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.600800,0.000000,16.666000>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<54.405900,0.000000,16.860800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.583100,0.000000,22.822700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.583100,0.000000,21.882100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<42.583100,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.583100,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.053400,0.000000,21.882100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<42.583100,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.053400,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.210100,0.000000,22.038800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<43.053400,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.210100,0.000000,22.038800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.210100,0.000000,22.665900>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,90.000000,0> translate<43.210100,0.000000,22.665900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.210100,0.000000,22.665900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.053400,0.000000,22.822700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<43.053400,0.000000,22.822700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.053400,0.000000,22.822700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.583100,0.000000,22.822700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<42.583100,0.000000,22.822700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.988900,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.675300,0.000000,21.882100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<43.675300,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.675300,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.518600,0.000000,22.038800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<43.518600,0.000000,22.038800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.518600,0.000000,22.038800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.518600,0.000000,22.352400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<43.518600,0.000000,22.352400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.518600,0.000000,22.352400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.675300,0.000000,22.509100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<43.518600,0.000000,22.352400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.675300,0.000000,22.509100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.988900,0.000000,22.509100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<43.675300,0.000000,22.509100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.988900,0.000000,22.509100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.145600,0.000000,22.352400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<43.988900,0.000000,22.509100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.145600,0.000000,22.352400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.145600,0.000000,22.195600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<44.145600,0.000000,22.195600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.145600,0.000000,22.195600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.518600,0.000000,22.195600>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<43.518600,0.000000,22.195600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.454100,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.924400,0.000000,21.882100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<44.454100,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.924400,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.081100,0.000000,22.038800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<44.924400,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.081100,0.000000,22.038800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.924400,0.000000,22.195600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<44.924400,0.000000,22.195600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.924400,0.000000,22.195600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.610800,0.000000,22.195600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<44.610800,0.000000,22.195600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.610800,0.000000,22.195600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.454100,0.000000,22.352400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<44.454100,0.000000,22.352400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.454100,0.000000,22.352400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.610800,0.000000,22.509100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<44.454100,0.000000,22.352400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.610800,0.000000,22.509100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.081100,0.000000,22.509100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<44.610800,0.000000,22.509100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.389600,0.000000,22.509100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.546300,0.000000,22.509100>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<45.389600,0.000000,22.509100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.546300,0.000000,22.509100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.546300,0.000000,21.882100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<45.546300,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.389600,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.703100,0.000000,21.882100>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<45.389600,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.546300,0.000000,22.979400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.546300,0.000000,22.822700>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,-90.000000,0> translate<45.546300,0.000000,22.822700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.326700,0.000000,21.568600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.483500,0.000000,21.568600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<46.326700,0.000000,21.568600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.483500,0.000000,21.568600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.640200,0.000000,21.725400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<46.483500,0.000000,21.568600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.640200,0.000000,21.725400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.640200,0.000000,22.509100>}
box{<0,0,-0.038100><0.783700,0.036000,0.038100> rotate<0,90.000000,0> translate<46.640200,0.000000,22.509100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.640200,0.000000,22.509100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.169900,0.000000,22.509100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<46.169900,0.000000,22.509100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.169900,0.000000,22.509100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.013200,0.000000,22.352400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<46.013200,0.000000,22.352400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.013200,0.000000,22.352400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.013200,0.000000,22.038800>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<46.013200,0.000000,22.038800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.013200,0.000000,22.038800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.169900,0.000000,21.882100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<46.013200,0.000000,22.038800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.169900,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.640200,0.000000,21.882100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<46.169900,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.948700,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.948700,0.000000,22.509100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<46.948700,0.000000,22.509100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.948700,0.000000,22.509100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.419000,0.000000,22.509100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<46.948700,0.000000,22.509100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.419000,0.000000,22.509100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.575700,0.000000,22.352400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<47.419000,0.000000,22.509100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.575700,0.000000,22.352400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.575700,0.000000,21.882100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<47.575700,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.354500,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.040900,0.000000,21.882100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<48.040900,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.040900,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.884200,0.000000,22.038800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<47.884200,0.000000,22.038800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.884200,0.000000,22.038800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.884200,0.000000,22.352400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<47.884200,0.000000,22.352400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.884200,0.000000,22.352400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.040900,0.000000,22.509100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<47.884200,0.000000,22.352400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.040900,0.000000,22.509100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.354500,0.000000,22.509100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<48.040900,0.000000,22.509100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.354500,0.000000,22.509100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.511200,0.000000,22.352400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<48.354500,0.000000,22.509100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.511200,0.000000,22.352400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.511200,0.000000,22.195600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.511200,0.000000,22.195600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.511200,0.000000,22.195600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.884200,0.000000,22.195600>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<47.884200,0.000000,22.195600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.446700,0.000000,22.822700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.446700,0.000000,21.882100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<49.446700,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.446700,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.976400,0.000000,21.882100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<48.976400,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.976400,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.819700,0.000000,22.038800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<48.819700,0.000000,22.038800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.819700,0.000000,22.038800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.819700,0.000000,22.352400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<48.819700,0.000000,22.352400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.819700,0.000000,22.352400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.976400,0.000000,22.509100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<48.819700,0.000000,22.352400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.976400,0.000000,22.509100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.446700,0.000000,22.509100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<48.976400,0.000000,22.509100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.690700,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.690700,0.000000,22.822700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<50.690700,0.000000,22.822700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.690700,0.000000,22.822700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.161000,0.000000,22.822700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<50.690700,0.000000,22.822700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.161000,0.000000,22.822700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.317700,0.000000,22.665900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<51.161000,0.000000,22.822700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.317700,0.000000,22.665900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.317700,0.000000,22.509100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<51.317700,0.000000,22.509100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.317700,0.000000,22.509100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.161000,0.000000,22.352400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<51.161000,0.000000,22.352400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.161000,0.000000,22.352400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.317700,0.000000,22.195600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<51.161000,0.000000,22.352400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.317700,0.000000,22.195600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.317700,0.000000,22.038800>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<51.317700,0.000000,22.038800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.317700,0.000000,22.038800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.161000,0.000000,21.882100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<51.161000,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.161000,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.690700,0.000000,21.882100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<50.690700,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.690700,0.000000,22.352400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.161000,0.000000,22.352400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<50.690700,0.000000,22.352400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.626200,0.000000,22.509100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.626200,0.000000,22.038800>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<51.626200,0.000000,22.038800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.626200,0.000000,22.038800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.782900,0.000000,21.882100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<51.626200,0.000000,22.038800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.782900,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.253200,0.000000,21.882100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<51.782900,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.253200,0.000000,22.509100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.253200,0.000000,21.725400>}
box{<0,0,-0.038100><0.783700,0.036000,0.038100> rotate<0,-90.000000,0> translate<52.253200,0.000000,21.725400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.253200,0.000000,21.725400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.096500,0.000000,21.568600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<52.096500,0.000000,21.568600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.096500,0.000000,21.568600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.939700,0.000000,21.568600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<51.939700,0.000000,21.568600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.561700,0.000000,22.509100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.718400,0.000000,22.509100>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<52.561700,0.000000,22.509100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.718400,0.000000,22.509100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.718400,0.000000,22.352400>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,-90.000000,0> translate<52.718400,0.000000,22.352400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.718400,0.000000,22.352400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.561700,0.000000,22.352400>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<52.561700,0.000000,22.352400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.561700,0.000000,22.352400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.561700,0.000000,22.509100>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,90.000000,0> translate<52.561700,0.000000,22.509100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.561700,0.000000,22.038800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.718400,0.000000,22.038800>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<52.561700,0.000000,22.038800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.718400,0.000000,22.038800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.718400,0.000000,21.882100>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,-90.000000,0> translate<52.718400,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.718400,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.561700,0.000000,21.882100>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<52.561700,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.561700,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.561700,0.000000,22.038800>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,90.000000,0> translate<52.561700,0.000000,22.038800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.710100,0.000000,21.476500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.337100,0.000000,21.476500>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<42.710100,0.000000,21.476500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.337100,0.000000,21.476500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.337100,0.000000,21.319700>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<43.337100,0.000000,21.319700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.337100,0.000000,21.319700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.710100,0.000000,20.692600>}
box{<0,0,-0.038100><0.886783,0.036000,0.038100> rotate<0,-45.001599,0> translate<42.710100,0.000000,20.692600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.710100,0.000000,20.692600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.710100,0.000000,20.535900>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,-90.000000,0> translate<42.710100,0.000000,20.535900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.710100,0.000000,20.535900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.337100,0.000000,20.535900>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<42.710100,0.000000,20.535900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.802300,0.000000,21.162900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.115900,0.000000,21.162900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<43.802300,0.000000,21.162900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.115900,0.000000,21.162900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.272600,0.000000,21.006200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<44.115900,0.000000,21.162900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.272600,0.000000,21.006200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.272600,0.000000,20.535900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<44.272600,0.000000,20.535900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.272600,0.000000,20.535900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.802300,0.000000,20.535900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<43.802300,0.000000,20.535900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.802300,0.000000,20.535900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.645600,0.000000,20.692600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<43.645600,0.000000,20.692600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.645600,0.000000,20.692600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.802300,0.000000,20.849400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<43.645600,0.000000,20.692600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.802300,0.000000,20.849400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.272600,0.000000,20.849400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<43.802300,0.000000,20.849400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.208100,0.000000,21.162900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.737800,0.000000,21.162900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<44.737800,0.000000,21.162900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.737800,0.000000,21.162900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.581100,0.000000,21.006200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<44.581100,0.000000,21.006200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.581100,0.000000,21.006200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.581100,0.000000,20.692600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<44.581100,0.000000,20.692600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.581100,0.000000,20.692600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.737800,0.000000,20.535900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<44.581100,0.000000,20.692600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.737800,0.000000,20.535900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.208100,0.000000,20.535900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<44.737800,0.000000,20.535900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.516600,0.000000,21.476500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.516600,0.000000,20.535900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<45.516600,0.000000,20.535900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.516600,0.000000,21.006200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.673300,0.000000,21.162900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<45.516600,0.000000,21.006200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.673300,0.000000,21.162900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.986900,0.000000,21.162900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<45.673300,0.000000,21.162900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.986900,0.000000,21.162900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.143600,0.000000,21.006200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<45.986900,0.000000,21.162900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.143600,0.000000,21.006200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.143600,0.000000,20.535900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<46.143600,0.000000,20.535900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.452100,0.000000,20.535900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.452100,0.000000,21.476500>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<46.452100,0.000000,21.476500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.452100,0.000000,21.006200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.079100,0.000000,21.006200>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<46.452100,0.000000,21.006200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.079100,0.000000,21.476500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.079100,0.000000,20.535900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<47.079100,0.000000,20.535900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.544300,0.000000,20.535900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.857900,0.000000,20.535900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<47.544300,0.000000,20.535900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.857900,0.000000,20.535900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.014600,0.000000,20.692600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<47.857900,0.000000,20.535900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.014600,0.000000,20.692600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.014600,0.000000,21.006200>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<48.014600,0.000000,21.006200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.014600,0.000000,21.006200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.857900,0.000000,21.162900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<47.857900,0.000000,21.162900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.857900,0.000000,21.162900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.544300,0.000000,21.162900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<47.544300,0.000000,21.162900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.544300,0.000000,21.162900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.387600,0.000000,21.006200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<47.387600,0.000000,21.006200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.387600,0.000000,21.006200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.387600,0.000000,20.692600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<47.387600,0.000000,20.692600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.387600,0.000000,20.692600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.544300,0.000000,20.535900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<47.387600,0.000000,20.692600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.793400,0.000000,20.535900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.479800,0.000000,20.535900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<48.479800,0.000000,20.535900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.479800,0.000000,20.535900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.323100,0.000000,20.692600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<48.323100,0.000000,20.692600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.323100,0.000000,20.692600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.323100,0.000000,21.006200>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<48.323100,0.000000,21.006200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.323100,0.000000,21.006200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.479800,0.000000,21.162900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<48.323100,0.000000,21.006200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.479800,0.000000,21.162900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.793400,0.000000,21.162900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<48.479800,0.000000,21.162900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.793400,0.000000,21.162900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.950100,0.000000,21.006200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<48.793400,0.000000,21.162900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.950100,0.000000,21.006200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.950100,0.000000,20.849400>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.950100,0.000000,20.849400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.950100,0.000000,20.849400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.323100,0.000000,20.849400>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<48.323100,0.000000,20.849400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.258600,0.000000,20.535900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.258600,0.000000,21.476500>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<49.258600,0.000000,21.476500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.728900,0.000000,20.535900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.258600,0.000000,20.849400>}
box{<0,0,-0.038100><0.565212,0.036000,0.038100> rotate<0,33.685033,0> translate<49.258600,0.000000,20.849400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.258600,0.000000,20.849400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.728900,0.000000,21.162900>}
box{<0,0,-0.038100><0.565212,0.036000,0.038100> rotate<0,-33.685033,0> translate<49.258600,0.000000,20.849400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.508400,0.000000,20.535900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.194800,0.000000,20.535900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<50.194800,0.000000,20.535900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.194800,0.000000,20.535900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.038100,0.000000,20.692600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<50.038100,0.000000,20.692600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.038100,0.000000,20.692600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.038100,0.000000,21.006200>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<50.038100,0.000000,21.006200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.038100,0.000000,21.006200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.194800,0.000000,21.162900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<50.038100,0.000000,21.006200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.194800,0.000000,21.162900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.508400,0.000000,21.162900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<50.194800,0.000000,21.162900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.508400,0.000000,21.162900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.665100,0.000000,21.006200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<50.508400,0.000000,21.162900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.665100,0.000000,21.006200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.665100,0.000000,20.849400>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<50.665100,0.000000,20.849400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.665100,0.000000,20.849400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.038100,0.000000,20.849400>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<50.038100,0.000000,20.849400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.973600,0.000000,20.535900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.973600,0.000000,21.162900>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<50.973600,0.000000,21.162900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.973600,0.000000,21.162900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.443900,0.000000,21.162900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<50.973600,0.000000,21.162900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.443900,0.000000,21.162900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.600600,0.000000,21.006200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<51.443900,0.000000,21.162900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.600600,0.000000,21.006200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.600600,0.000000,20.535900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<51.600600,0.000000,20.535900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.909100,0.000000,20.535900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.909100,0.000000,20.692600>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,90.000000,0> translate<51.909100,0.000000,20.692600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.909100,0.000000,20.692600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.065800,0.000000,20.692600>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<51.909100,0.000000,20.692600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.065800,0.000000,20.692600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.065800,0.000000,20.535900>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,-90.000000,0> translate<52.065800,0.000000,20.535900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.065800,0.000000,20.535900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.909100,0.000000,20.535900>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<51.909100,0.000000,20.535900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.003800,0.000000,21.162900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.533500,0.000000,21.162900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<52.533500,0.000000,21.162900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.533500,0.000000,21.162900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.376800,0.000000,21.006200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<52.376800,0.000000,21.006200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.376800,0.000000,21.006200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.376800,0.000000,20.692600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<52.376800,0.000000,20.692600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.376800,0.000000,20.692600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.533500,0.000000,20.535900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<52.376800,0.000000,20.692600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.533500,0.000000,20.535900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.003800,0.000000,20.535900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<52.533500,0.000000,20.535900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.469000,0.000000,20.535900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.782600,0.000000,20.535900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<53.469000,0.000000,20.535900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.782600,0.000000,20.535900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.939300,0.000000,20.692600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<53.782600,0.000000,20.535900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.939300,0.000000,20.692600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.939300,0.000000,21.006200>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<53.939300,0.000000,21.006200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.939300,0.000000,21.006200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.782600,0.000000,21.162900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<53.782600,0.000000,21.162900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.782600,0.000000,21.162900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.469000,0.000000,21.162900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<53.469000,0.000000,21.162900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.469000,0.000000,21.162900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.312300,0.000000,21.006200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<53.312300,0.000000,21.006200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.312300,0.000000,21.006200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.312300,0.000000,20.692600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<53.312300,0.000000,20.692600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.312300,0.000000,20.692600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.469000,0.000000,20.535900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<53.312300,0.000000,20.692600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.247800,0.000000,20.535900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.247800,0.000000,21.162900>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<54.247800,0.000000,21.162900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.247800,0.000000,21.162900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.404500,0.000000,21.162900>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<54.247800,0.000000,21.162900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.404500,0.000000,21.162900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.561300,0.000000,21.006200>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<54.404500,0.000000,21.162900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.561300,0.000000,21.006200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.561300,0.000000,20.535900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<54.561300,0.000000,20.535900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.561300,0.000000,21.006200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.718100,0.000000,21.162900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<54.561300,0.000000,21.006200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.718100,0.000000,21.162900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.874800,0.000000,21.006200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<54.718100,0.000000,21.162900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.874800,0.000000,21.006200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.874800,0.000000,20.535900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<54.874800,0.000000,20.535900> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.942400,0.000000,31.775400>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.383300,0.000000,31.775400>}
box{<0,0,-0.101600><1.559100,0.036000,0.101600> rotate<0,0.000000,0> translate<96.383300,0.000000,31.775400> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.383300,0.000000,31.775400>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.603700,0.000000,32.554900>}
box{<0,0,-0.101600><1.102450,0.036000,0.101600> rotate<0,44.993355,0> translate<95.603700,0.000000,32.554900> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.603700,0.000000,32.554900>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.383300,0.000000,33.334500>}
box{<0,0,-0.101600><1.102521,0.036000,0.101600> rotate<0,-44.997030,0> translate<95.603700,0.000000,32.554900> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.383300,0.000000,33.334500>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.942400,0.000000,33.334500>}
box{<0,0,-0.101600><1.559100,0.036000,0.101600> rotate<0,0.000000,0> translate<96.383300,0.000000,33.334500> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.773100,0.000000,31.775400>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.773100,0.000000,33.334500>}
box{<0,0,-0.101600><1.559100,0.036000,0.101600> rotate<0,90.000000,0> translate<96.773100,0.000000,33.334500> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.942400,0.000000,35.585400>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.603700,0.000000,35.585400>}
box{<0,0,-0.101600><2.338700,0.036000,0.101600> rotate<0,0.000000,0> translate<95.603700,0.000000,35.585400> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.603700,0.000000,35.585400>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.603700,0.000000,36.754700>}
box{<0,0,-0.101600><1.169300,0.036000,0.101600> rotate<0,90.000000,0> translate<95.603700,0.000000,36.754700> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.603700,0.000000,36.754700>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.993500,0.000000,37.144500>}
box{<0,0,-0.101600><0.551260,0.036000,0.101600> rotate<0,-44.997030,0> translate<95.603700,0.000000,36.754700> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.993500,0.000000,37.144500>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.383300,0.000000,37.144500>}
box{<0,0,-0.101600><0.389800,0.036000,0.101600> rotate<0,0.000000,0> translate<95.993500,0.000000,37.144500> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.383300,0.000000,37.144500>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.773100,0.000000,36.754700>}
box{<0,0,-0.101600><0.551260,0.036000,0.101600> rotate<0,44.997030,0> translate<96.383300,0.000000,37.144500> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.773100,0.000000,36.754700>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.162900,0.000000,37.144500>}
box{<0,0,-0.101600><0.551260,0.036000,0.101600> rotate<0,-44.997030,0> translate<96.773100,0.000000,36.754700> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.162900,0.000000,37.144500>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.552700,0.000000,37.144500>}
box{<0,0,-0.101600><0.389800,0.036000,0.101600> rotate<0,0.000000,0> translate<97.162900,0.000000,37.144500> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.552700,0.000000,37.144500>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.942400,0.000000,36.754700>}
box{<0,0,-0.101600><0.551190,0.036000,0.101600> rotate<0,45.004380,0> translate<97.552700,0.000000,37.144500> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.942400,0.000000,36.754700>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.942400,0.000000,35.585400>}
box{<0,0,-0.101600><1.169300,0.036000,0.101600> rotate<0,-90.000000,0> translate<97.942400,0.000000,35.585400> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.773100,0.000000,35.585400>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.773100,0.000000,36.754700>}
box{<0,0,-0.101600><1.169300,0.036000,0.101600> rotate<0,90.000000,0> translate<96.773100,0.000000,36.754700> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.993500,0.000000,41.589500>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.603700,0.000000,41.199700>}
box{<0,0,-0.101600><0.551260,0.036000,0.101600> rotate<0,-44.997030,0> translate<95.603700,0.000000,41.199700> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.603700,0.000000,41.199700>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.603700,0.000000,40.420100>}
box{<0,0,-0.101600><0.779600,0.036000,0.101600> rotate<0,-90.000000,0> translate<95.603700,0.000000,40.420100> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.603700,0.000000,40.420100>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.993500,0.000000,40.030400>}
box{<0,0,-0.101600><0.551190,0.036000,0.101600> rotate<0,44.989680,0> translate<95.603700,0.000000,40.420100> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.993500,0.000000,40.030400>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.552700,0.000000,40.030400>}
box{<0,0,-0.101600><1.559200,0.036000,0.101600> rotate<0,0.000000,0> translate<95.993500,0.000000,40.030400> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.552700,0.000000,40.030400>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.942400,0.000000,40.420100>}
box{<0,0,-0.101600><0.551119,0.036000,0.101600> rotate<0,-44.997030,0> translate<97.552700,0.000000,40.030400> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.942400,0.000000,40.420100>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.942400,0.000000,41.199700>}
box{<0,0,-0.101600><0.779600,0.036000,0.101600> rotate<0,90.000000,0> translate<97.942400,0.000000,41.199700> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.942400,0.000000,41.199700>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.552700,0.000000,41.589500>}
box{<0,0,-0.101600><0.551190,0.036000,0.101600> rotate<0,45.004380,0> translate<97.552700,0.000000,41.589500> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.603700,0.000000,43.840400>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.942400,0.000000,43.840400>}
box{<0,0,-0.101600><2.338700,0.036000,0.101600> rotate<0,0.000000,0> translate<95.603700,0.000000,43.840400> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.942400,0.000000,43.840400>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.942400,0.000000,45.009700>}
box{<0,0,-0.101600><1.169300,0.036000,0.101600> rotate<0,90.000000,0> translate<97.942400,0.000000,45.009700> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.942400,0.000000,45.009700>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.552700,0.000000,45.399500>}
box{<0,0,-0.101600><0.551190,0.036000,0.101600> rotate<0,45.004380,0> translate<97.552700,0.000000,45.399500> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.552700,0.000000,45.399500>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.993500,0.000000,45.399500>}
box{<0,0,-0.101600><1.559200,0.036000,0.101600> rotate<0,0.000000,0> translate<95.993500,0.000000,45.399500> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.993500,0.000000,45.399500>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.603700,0.000000,45.009700>}
box{<0,0,-0.101600><0.551260,0.036000,0.101600> rotate<0,-44.997030,0> translate<95.603700,0.000000,45.009700> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.603700,0.000000,45.009700>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.603700,0.000000,43.840400>}
box{<0,0,-0.101600><1.169300,0.036000,0.101600> rotate<0,-90.000000,0> translate<95.603700,0.000000,43.840400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.856900,0.000000,54.317900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.856900,0.000000,56.326200>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,90.000000,0> translate<48.856900,0.000000,56.326200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.856900,0.000000,56.326200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.526300,0.000000,55.656700>}
box{<0,0,-0.088900><0.946745,0.036000,0.088900> rotate<0,45.001309,0> translate<48.856900,0.000000,56.326200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.526300,0.000000,55.656700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.195700,0.000000,56.326200>}
box{<0,0,-0.088900><0.946745,0.036000,0.088900> rotate<0,-45.001309,0> translate<49.526300,0.000000,55.656700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.195700,0.000000,56.326200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.195700,0.000000,54.317900>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,-90.000000,0> translate<50.195700,0.000000,54.317900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.868200,0.000000,54.317900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.868200,0.000000,55.656700>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<50.868200,0.000000,55.656700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.868200,0.000000,55.656700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.537600,0.000000,56.326200>}
box{<0,0,-0.088900><0.946745,0.036000,0.088900> rotate<0,-45.001309,0> translate<50.868200,0.000000,55.656700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.537600,0.000000,56.326200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.207000,0.000000,55.656700>}
box{<0,0,-0.088900><0.946745,0.036000,0.088900> rotate<0,45.001309,0> translate<51.537600,0.000000,56.326200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.207000,0.000000,55.656700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.207000,0.000000,54.317900>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<52.207000,0.000000,54.317900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.868200,0.000000,55.322000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.207000,0.000000,55.322000>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<50.868200,0.000000,55.322000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.879500,0.000000,56.326200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.218300,0.000000,54.317900>}
box{<0,0,-0.088900><2.413639,0.036000,0.088900> rotate<0,56.307533,0> translate<52.879500,0.000000,56.326200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.218300,0.000000,56.326200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.879500,0.000000,54.317900>}
box{<0,0,-0.088900><2.413639,0.036000,0.088900> rotate<0,-56.307533,0> translate<52.879500,0.000000,54.317900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.696100,0.000000,23.583900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.687800,0.000000,23.583900>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,0.000000,0> translate<55.687800,0.000000,23.583900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.687800,0.000000,23.583900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.357300,0.000000,24.253300>}
box{<0,0,-0.088900><0.946745,0.036000,0.088900> rotate<0,-44.992751,0> translate<55.687800,0.000000,23.583900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.357300,0.000000,24.253300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.687800,0.000000,24.922700>}
box{<0,0,-0.088900><0.946745,0.036000,0.088900> rotate<0,44.992751,0> translate<55.687800,0.000000,24.922700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.687800,0.000000,24.922700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.696100,0.000000,24.922700>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,0.000000,0> translate<55.687800,0.000000,24.922700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.696100,0.000000,25.595200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.696100,0.000000,26.264600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<57.696100,0.000000,26.264600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.696100,0.000000,25.929900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.687800,0.000000,25.929900>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,0.000000,0> translate<55.687800,0.000000,25.929900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.687800,0.000000,25.595200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.687800,0.000000,26.264600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<55.687800,0.000000,26.264600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.696100,0.000000,26.936100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.687800,0.000000,26.936100>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,0.000000,0> translate<55.687800,0.000000,26.936100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.687800,0.000000,26.936100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.696100,0.000000,28.274900>}
box{<0,0,-0.088900><2.413639,0.036000,0.088900> rotate<0,-33.686527,0> translate<55.687800,0.000000,26.936100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.696100,0.000000,28.274900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.687800,0.000000,28.274900>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,0.000000,0> translate<55.687800,0.000000,28.274900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.676800,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.676800,0.000000,55.034000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<55.676800,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.676800,0.000000,55.034000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.897100,0.000000,55.034000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<55.676800,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.897100,0.000000,55.034000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.117400,0.000000,54.813700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<55.897100,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.117400,0.000000,54.813700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.117400,0.000000,54.152800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<56.117400,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.117400,0.000000,54.813700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.337700,0.000000,55.034000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<56.117400,0.000000,54.813700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.337700,0.000000,55.034000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.558000,0.000000,54.813700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<56.337700,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.558000,0.000000,54.813700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.558000,0.000000,54.152800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<56.558000,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.206800,0.000000,55.034000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.647400,0.000000,55.034000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<57.206800,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.647400,0.000000,55.034000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.867700,0.000000,54.813700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<57.647400,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.867700,0.000000,54.813700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.867700,0.000000,54.152800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<57.867700,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.867700,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.206800,0.000000,54.152800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<57.206800,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.206800,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.986500,0.000000,54.373100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<56.986500,0.000000,54.373100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.986500,0.000000,54.373100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.206800,0.000000,54.593400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<56.986500,0.000000,54.373100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.206800,0.000000,54.593400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.867700,0.000000,54.593400>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<57.206800,0.000000,54.593400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.296200,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.296200,0.000000,55.474700>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,90.000000,0> translate<58.296200,0.000000,55.474700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.957100,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.296200,0.000000,54.593400>}
box{<0,0,-0.050800><0.794303,0.036000,0.050800> rotate<0,33.687844,0> translate<58.296200,0.000000,54.593400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.296200,0.000000,54.593400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.957100,0.000000,55.034000>}
box{<0,0,-0.050800><0.794303,0.036000,0.050800> rotate<0,-33.687844,0> translate<58.296200,0.000000,54.593400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.048500,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.607900,0.000000,54.152800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<59.607900,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.607900,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.387600,0.000000,54.373100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<59.387600,0.000000,54.373100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.387600,0.000000,54.373100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.387600,0.000000,54.813700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,90.000000,0> translate<59.387600,0.000000,54.813700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.387600,0.000000,54.813700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.607900,0.000000,55.034000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<59.387600,0.000000,54.813700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.607900,0.000000,55.034000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.048500,0.000000,55.034000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<59.607900,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.048500,0.000000,55.034000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.268800,0.000000,54.813700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<60.048500,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.268800,0.000000,54.813700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.268800,0.000000,54.593400>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<60.268800,0.000000,54.593400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.268800,0.000000,54.593400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.387600,0.000000,54.593400>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<59.387600,0.000000,54.593400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.697300,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.697300,0.000000,54.373100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,90.000000,0> translate<60.697300,0.000000,54.373100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.697300,0.000000,54.373100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.917600,0.000000,54.373100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<60.697300,0.000000,54.373100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.917600,0.000000,54.373100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.917600,0.000000,54.152800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<60.917600,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.917600,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.697300,0.000000,54.152800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<60.697300,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.352100,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.352100,0.000000,55.034000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<61.352100,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.352100,0.000000,54.593400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.792700,0.000000,55.034000>}
box{<0,0,-0.050800><0.623102,0.036000,0.050800> rotate<0,-44.997030,0> translate<61.352100,0.000000,54.593400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.792700,0.000000,55.034000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.013000,0.000000,55.034000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<61.792700,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.443500,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.443500,0.000000,55.034000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<62.443500,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.443500,0.000000,54.593400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.884100,0.000000,55.034000>}
box{<0,0,-0.050800><0.623102,0.036000,0.050800> rotate<0,-44.997030,0> translate<62.443500,0.000000,54.593400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.884100,0.000000,55.034000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.104400,0.000000,55.034000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<62.884100,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.534900,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.534900,0.000000,55.034000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<63.534900,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.534900,0.000000,54.593400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.975500,0.000000,55.034000>}
box{<0,0,-0.050800><0.623102,0.036000,0.050800> rotate<0,-44.997030,0> translate<63.534900,0.000000,54.593400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.975500,0.000000,55.034000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.195800,0.000000,55.034000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<63.975500,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.846600,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.846600,0.000000,55.254400>}
box{<0,0,-0.050800><1.101600,0.036000,0.050800> rotate<0,90.000000,0> translate<64.846600,0.000000,55.254400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.846600,0.000000,55.254400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.066900,0.000000,55.474700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<64.846600,0.000000,55.254400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.626300,0.000000,54.813700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.066900,0.000000,54.813700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<64.626300,0.000000,54.813700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.499400,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.499400,0.000000,54.373100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,90.000000,0> translate<65.499400,0.000000,54.373100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.499400,0.000000,54.373100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.719700,0.000000,54.373100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<65.499400,0.000000,54.373100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.719700,0.000000,54.373100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.719700,0.000000,54.152800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<65.719700,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.719700,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.499400,0.000000,54.152800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<65.499400,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.374500,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.815100,0.000000,54.152800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<66.374500,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.815100,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.035400,0.000000,54.373100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<66.815100,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.035400,0.000000,54.373100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.035400,0.000000,54.813700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,90.000000,0> translate<67.035400,0.000000,54.813700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.035400,0.000000,54.813700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.815100,0.000000,55.034000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<66.815100,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.815100,0.000000,55.034000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.374500,0.000000,55.034000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<66.374500,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.374500,0.000000,55.034000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.154200,0.000000,54.813700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<66.154200,0.000000,54.813700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.154200,0.000000,54.813700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.154200,0.000000,54.373100>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,-90.000000,0> translate<66.154200,0.000000,54.373100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.154200,0.000000,54.373100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.374500,0.000000,54.152800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<66.154200,0.000000,54.373100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.463900,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.463900,0.000000,55.034000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<67.463900,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.463900,0.000000,54.593400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.904500,0.000000,55.034000>}
box{<0,0,-0.050800><0.623102,0.036000,0.050800> rotate<0,-44.997030,0> translate<67.463900,0.000000,54.593400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.904500,0.000000,55.034000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.124800,0.000000,55.034000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<67.904500,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.995900,0.000000,53.712200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.216200,0.000000,53.712200>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<68.995900,0.000000,53.712200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.216200,0.000000,53.712200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.436500,0.000000,53.932500>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<69.216200,0.000000,53.712200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.436500,0.000000,53.932500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.436500,0.000000,55.034000>}
box{<0,0,-0.050800><1.101500,0.036000,0.050800> rotate<0,90.000000,0> translate<69.436500,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.436500,0.000000,55.034000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.775600,0.000000,55.034000>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<68.775600,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.775600,0.000000,55.034000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.555300,0.000000,54.813700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<68.555300,0.000000,54.813700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.555300,0.000000,54.813700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.555300,0.000000,54.373100>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,-90.000000,0> translate<68.555300,0.000000,54.373100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.555300,0.000000,54.373100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.775600,0.000000,54.152800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<68.555300,0.000000,54.373100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.775600,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.436500,0.000000,54.152800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<68.775600,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.865000,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<70.746200,0.000000,55.474700>}
box{<0,0,-0.050800><1.588689,0.036000,0.050800> rotate<0,-56.308217,0> translate<69.865000,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.174700,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.835600,0.000000,54.152800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<71.174700,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.835600,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.055900,0.000000,54.373100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<71.835600,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.055900,0.000000,54.373100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.835600,0.000000,54.593400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<71.835600,0.000000,54.593400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.835600,0.000000,54.593400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.395000,0.000000,54.593400>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<71.395000,0.000000,54.593400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.395000,0.000000,54.593400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.174700,0.000000,54.813700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<71.174700,0.000000,54.813700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.174700,0.000000,54.813700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.395000,0.000000,55.034000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<71.174700,0.000000,54.813700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.395000,0.000000,55.034000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.055900,0.000000,55.034000>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<71.395000,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.484400,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.484400,0.000000,55.034000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<72.484400,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.484400,0.000000,55.034000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.704700,0.000000,55.034000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<72.484400,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.704700,0.000000,55.034000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.925000,0.000000,54.813700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<72.704700,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.925000,0.000000,54.813700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.925000,0.000000,54.152800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<72.925000,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.925000,0.000000,54.813700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.145300,0.000000,55.034000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<72.925000,0.000000,54.813700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.145300,0.000000,55.034000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.365600,0.000000,54.813700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<73.145300,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.365600,0.000000,54.813700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.365600,0.000000,54.152800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<73.365600,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.675300,0.000000,55.474700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.675300,0.000000,54.152800>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,-90.000000,0> translate<74.675300,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.675300,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.014400,0.000000,54.152800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<74.014400,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.014400,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.794100,0.000000,54.373100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<73.794100,0.000000,54.373100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.794100,0.000000,54.373100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.794100,0.000000,54.813700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,90.000000,0> translate<73.794100,0.000000,54.813700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.794100,0.000000,54.813700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.014400,0.000000,55.034000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<73.794100,0.000000,54.813700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.014400,0.000000,55.034000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.675300,0.000000,55.034000>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<74.014400,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.103800,0.000000,54.813700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.985000,0.000000,54.813700>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<75.103800,0.000000,54.813700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.294700,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.413500,0.000000,54.152800>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<76.413500,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.413500,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.294700,0.000000,55.034000>}
box{<0,0,-0.050800><1.246205,0.036000,0.050800> rotate<0,-44.997030,0> translate<76.413500,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.294700,0.000000,55.034000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.294700,0.000000,55.254400>}
box{<0,0,-0.050800><0.220400,0.036000,0.050800> rotate<0,90.000000,0> translate<77.294700,0.000000,55.254400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.294700,0.000000,55.254400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.074400,0.000000,55.474700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<77.074400,0.000000,55.474700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.074400,0.000000,55.474700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.633800,0.000000,55.474700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<76.633800,0.000000,55.474700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.633800,0.000000,55.474700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.413500,0.000000,55.254400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<76.413500,0.000000,55.254400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.723200,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.723200,0.000000,54.373100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,90.000000,0> translate<77.723200,0.000000,54.373100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.723200,0.000000,54.373100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.943500,0.000000,54.373100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<77.723200,0.000000,54.373100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.943500,0.000000,54.373100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.943500,0.000000,54.152800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<77.943500,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.943500,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.723200,0.000000,54.152800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<77.723200,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.378000,0.000000,55.254400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.598300,0.000000,55.474700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<78.378000,0.000000,55.254400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.598300,0.000000,55.474700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.038900,0.000000,55.474700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<78.598300,0.000000,55.474700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.038900,0.000000,55.474700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.259200,0.000000,55.254400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<79.038900,0.000000,55.474700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.259200,0.000000,55.254400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.259200,0.000000,55.034000>}
box{<0,0,-0.050800><0.220400,0.036000,0.050800> rotate<0,-90.000000,0> translate<79.259200,0.000000,55.034000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.259200,0.000000,55.034000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.038900,0.000000,54.813700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<79.038900,0.000000,54.813700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.038900,0.000000,54.813700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.818600,0.000000,54.813700>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<78.818600,0.000000,54.813700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.038900,0.000000,54.813700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.259200,0.000000,54.593400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<79.038900,0.000000,54.813700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.259200,0.000000,54.593400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.259200,0.000000,54.373100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<79.259200,0.000000,54.373100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.259200,0.000000,54.373100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.038900,0.000000,54.152800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<79.038900,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.038900,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.598300,0.000000,54.152800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<78.598300,0.000000,54.152800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.598300,0.000000,54.152800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.378000,0.000000,54.373100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<78.378000,0.000000,54.373100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.025300,0.000000,58.051700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.025300,0.000000,58.788900>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,90.000000,0> translate<50.025300,0.000000,58.788900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.025300,0.000000,58.788900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.393900,0.000000,58.788900>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<50.025300,0.000000,58.788900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.393900,0.000000,58.788900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.516700,0.000000,58.666000>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<50.393900,0.000000,58.788900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.516700,0.000000,58.666000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.516700,0.000000,58.420300>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,-90.000000,0> translate<50.516700,0.000000,58.420300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.516700,0.000000,58.420300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.393900,0.000000,58.297400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<50.393900,0.000000,58.297400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.393900,0.000000,58.297400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.025300,0.000000,58.297400>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<50.025300,0.000000,58.297400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.142300,0.000000,58.788900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.896500,0.000000,58.788900>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<50.896500,0.000000,58.788900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.896500,0.000000,58.788900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.773700,0.000000,58.666000>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<50.773700,0.000000,58.666000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.773700,0.000000,58.666000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.773700,0.000000,58.174500>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,-90.000000,0> translate<50.773700,0.000000,58.174500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.773700,0.000000,58.174500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.896500,0.000000,58.051700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<50.773700,0.000000,58.174500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.896500,0.000000,58.051700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.142300,0.000000,58.051700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<50.896500,0.000000,58.051700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.142300,0.000000,58.051700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.265100,0.000000,58.174500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<51.142300,0.000000,58.051700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.265100,0.000000,58.174500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.265100,0.000000,58.666000>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,90.000000,0> translate<51.265100,0.000000,58.666000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.265100,0.000000,58.666000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.142300,0.000000,58.788900>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<51.142300,0.000000,58.788900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.522100,0.000000,58.788900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.522100,0.000000,58.051700>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,-90.000000,0> translate<51.522100,0.000000,58.051700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.522100,0.000000,58.051700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.767800,0.000000,58.297400>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,-44.997030,0> translate<51.522100,0.000000,58.051700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.767800,0.000000,58.297400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.013500,0.000000,58.051700>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,44.997030,0> translate<51.767800,0.000000,58.297400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.013500,0.000000,58.051700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.013500,0.000000,58.788900>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,90.000000,0> translate<52.013500,0.000000,58.788900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.761900,0.000000,58.788900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.270500,0.000000,58.788900>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<52.270500,0.000000,58.788900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.270500,0.000000,58.788900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.270500,0.000000,58.051700>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,-90.000000,0> translate<52.270500,0.000000,58.051700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.270500,0.000000,58.051700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.761900,0.000000,58.051700>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<52.270500,0.000000,58.051700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.270500,0.000000,58.420300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.516200,0.000000,58.420300>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,0.000000,0> translate<52.270500,0.000000,58.420300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.018900,0.000000,58.051700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.018900,0.000000,58.788900>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,90.000000,0> translate<53.018900,0.000000,58.788900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.018900,0.000000,58.788900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.387500,0.000000,58.788900>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<53.018900,0.000000,58.788900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.387500,0.000000,58.788900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.510300,0.000000,58.666000>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<53.387500,0.000000,58.788900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.510300,0.000000,58.666000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.510300,0.000000,58.420300>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,-90.000000,0> translate<53.510300,0.000000,58.420300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.510300,0.000000,58.420300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.387500,0.000000,58.297400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<53.387500,0.000000,58.297400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.387500,0.000000,58.297400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.018900,0.000000,58.297400>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<53.018900,0.000000,58.297400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.264600,0.000000,58.297400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.510300,0.000000,58.051700>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,44.997030,0> translate<53.264600,0.000000,58.297400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.226100,0.000000,20.370800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.615800,0.000000,20.370800>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,0.000000,0> translate<57.226100,0.000000,20.370800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.420900,0.000000,20.370800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.420900,0.000000,21.540100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,90.000000,0> translate<57.420900,0.000000,21.540100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.226100,0.000000,21.540100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.615800,0.000000,21.540100>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,0.000000,0> translate<57.226100,0.000000,21.540100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.005600,0.000000,20.370800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.005600,0.000000,21.540100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,90.000000,0> translate<58.005600,0.000000,21.540100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.005600,0.000000,21.540100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.785100,0.000000,20.370800>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,56.307347,0> translate<58.005600,0.000000,21.540100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.785100,0.000000,20.370800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.785100,0.000000,21.540100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,90.000000,0> translate<58.785100,0.000000,21.540100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.564600,0.000000,20.370800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.564600,0.000000,21.540100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,90.000000,0> translate<59.564600,0.000000,21.540100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.174900,0.000000,21.540100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.954400,0.000000,21.540100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<59.174900,0.000000,21.540100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.123700,0.000000,21.540100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.344200,0.000000,21.540100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<60.344200,0.000000,21.540100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.344200,0.000000,21.540100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.344200,0.000000,20.370800>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,-90.000000,0> translate<60.344200,0.000000,20.370800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.344200,0.000000,20.370800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.123700,0.000000,20.370800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<60.344200,0.000000,20.370800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.344200,0.000000,20.955400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.733900,0.000000,20.955400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,0.000000,0> translate<60.344200,0.000000,20.955400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.513500,0.000000,20.370800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.513500,0.000000,21.540100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,90.000000,0> translate<61.513500,0.000000,21.540100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.513500,0.000000,21.540100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.098100,0.000000,21.540100>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<61.513500,0.000000,21.540100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.098100,0.000000,21.540100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.293000,0.000000,21.345200>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<62.098100,0.000000,21.540100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.293000,0.000000,21.345200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.293000,0.000000,20.955400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<62.293000,0.000000,20.955400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.293000,0.000000,20.955400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.098100,0.000000,20.760500>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<62.098100,0.000000,20.760500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.098100,0.000000,20.760500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.513500,0.000000,20.760500>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<61.513500,0.000000,20.760500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.903200,0.000000,20.760500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.293000,0.000000,20.370800>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<61.903200,0.000000,20.760500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.682800,0.000000,20.370800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.682800,0.000000,21.540100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,90.000000,0> translate<62.682800,0.000000,21.540100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.682800,0.000000,21.540100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.462300,0.000000,21.540100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<62.682800,0.000000,21.540100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.682800,0.000000,20.955400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.072500,0.000000,20.955400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,0.000000,0> translate<62.682800,0.000000,20.955400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.852100,0.000000,20.370800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.852100,0.000000,21.150300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<63.852100,0.000000,21.150300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.852100,0.000000,21.150300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.241800,0.000000,21.540100>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<63.852100,0.000000,21.150300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.241800,0.000000,21.540100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.631600,0.000000,21.150300>}
box{<0,0,-0.050800><0.551260,0.036000,0.050800> rotate<0,44.997030,0> translate<64.241800,0.000000,21.540100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.631600,0.000000,21.150300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.631600,0.000000,20.370800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<64.631600,0.000000,20.370800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.852100,0.000000,20.955400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.631600,0.000000,20.955400>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<63.852100,0.000000,20.955400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.800900,0.000000,21.345200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.606000,0.000000,21.540100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<65.606000,0.000000,21.540100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.606000,0.000000,21.540100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.216200,0.000000,21.540100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<65.216200,0.000000,21.540100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.216200,0.000000,21.540100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.021400,0.000000,21.345200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<65.021400,0.000000,21.345200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.021400,0.000000,21.345200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.021400,0.000000,20.565600>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,-90.000000,0> translate<65.021400,0.000000,20.565600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.021400,0.000000,20.565600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.216200,0.000000,20.370800>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<65.021400,0.000000,20.565600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.216200,0.000000,20.370800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.606000,0.000000,20.370800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<65.216200,0.000000,20.370800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.606000,0.000000,20.370800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.800900,0.000000,20.565600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<65.606000,0.000000,20.370800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.970200,0.000000,21.540100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.190700,0.000000,21.540100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<66.190700,0.000000,21.540100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.190700,0.000000,21.540100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.190700,0.000000,20.370800>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,-90.000000,0> translate<66.190700,0.000000,20.370800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.190700,0.000000,20.370800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.970200,0.000000,20.370800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<66.190700,0.000000,20.370800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.190700,0.000000,20.955400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.580400,0.000000,20.955400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,0.000000,0> translate<66.190700,0.000000,20.955400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.580700,0.000000,58.050800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.190900,0.000000,58.440500>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<77.190900,0.000000,58.440500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.190900,0.000000,58.440500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.360200,0.000000,58.440500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<77.190900,0.000000,58.440500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.360200,0.000000,58.050800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.360200,0.000000,58.830300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<78.360200,0.000000,58.830300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.360200,0.000000,59.999600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.360200,0.000000,59.220100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<78.360200,0.000000,59.220100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.360200,0.000000,59.220100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.580700,0.000000,59.999600>}
box{<0,0,-0.050800><1.102379,0.036000,0.050800> rotate<0,44.997030,0> translate<77.580700,0.000000,59.999600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.580700,0.000000,59.999600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.385800,0.000000,59.999600>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<77.385800,0.000000,59.999600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.385800,0.000000,59.999600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.190900,0.000000,59.804700>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<77.190900,0.000000,59.804700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.190900,0.000000,59.804700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.190900,0.000000,59.414900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<77.190900,0.000000,59.414900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.190900,0.000000,59.414900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.385800,0.000000,59.220100>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<77.190900,0.000000,59.414900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.190900,0.000000,60.389400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.970500,0.000000,60.389400>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<77.190900,0.000000,60.389400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.970500,0.000000,60.389400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.360200,0.000000,60.779100>}
box{<0,0,-0.050800><0.551119,0.036000,0.050800> rotate<0,-44.997030,0> translate<77.970500,0.000000,60.389400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.360200,0.000000,60.779100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.970500,0.000000,61.168900>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,45.004380,0> translate<77.970500,0.000000,61.168900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.970500,0.000000,61.168900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.190900,0.000000,61.168900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<77.190900,0.000000,61.168900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.985800,0.000000,59.130300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.790900,0.000000,58.935400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<66.790900,0.000000,58.935400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.790900,0.000000,58.935400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.790900,0.000000,58.545600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<66.790900,0.000000,58.545600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.790900,0.000000,58.545600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.985800,0.000000,58.350800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<66.790900,0.000000,58.545600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.985800,0.000000,58.350800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.765400,0.000000,58.350800>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<66.985800,0.000000,58.350800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.765400,0.000000,58.350800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.960200,0.000000,58.545600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<67.765400,0.000000,58.350800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.960200,0.000000,58.545600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.960200,0.000000,58.935400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<67.960200,0.000000,58.935400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.960200,0.000000,58.935400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.765400,0.000000,59.130300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<67.765400,0.000000,59.130300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.765400,0.000000,59.130300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.375600,0.000000,59.130300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<67.375600,0.000000,59.130300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.375600,0.000000,59.130300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.375600,0.000000,58.740500>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<67.375600,0.000000,58.740500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.960200,0.000000,59.520100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.790900,0.000000,59.520100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<66.790900,0.000000,59.520100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.790900,0.000000,59.520100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.960200,0.000000,60.299600>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,-33.686713,0> translate<66.790900,0.000000,59.520100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.960200,0.000000,60.299600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.790900,0.000000,60.299600>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<66.790900,0.000000,60.299600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.790900,0.000000,60.689400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.960200,0.000000,60.689400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<66.790900,0.000000,60.689400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.960200,0.000000,60.689400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.960200,0.000000,61.274000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<67.960200,0.000000,61.274000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.960200,0.000000,61.274000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.765400,0.000000,61.468900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<67.765400,0.000000,61.468900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.765400,0.000000,61.468900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.985800,0.000000,61.468900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<66.985800,0.000000,61.468900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.985800,0.000000,61.468900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.790900,0.000000,61.274000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<66.790900,0.000000,61.274000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.790900,0.000000,61.274000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.790900,0.000000,60.689400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<66.790900,0.000000,60.689400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.490900,0.000000,59.730300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.490900,0.000000,58.950800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<56.490900,0.000000,58.950800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.490900,0.000000,58.950800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.075600,0.000000,58.950800>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,0.000000,0> translate<56.490900,0.000000,58.950800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.075600,0.000000,58.950800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.880700,0.000000,59.340500>}
box{<0,0,-0.050800><0.435720,0.036000,0.050800> rotate<0,63.424882,0> translate<56.880700,0.000000,59.340500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.880700,0.000000,59.340500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.880700,0.000000,59.535400>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,90.000000,0> translate<56.880700,0.000000,59.535400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.880700,0.000000,59.535400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.075600,0.000000,59.730300>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<56.880700,0.000000,59.535400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.075600,0.000000,59.730300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.465400,0.000000,59.730300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<57.075600,0.000000,59.730300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.465400,0.000000,59.730300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.660200,0.000000,59.535400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<57.465400,0.000000,59.730300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.660200,0.000000,59.535400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.660200,0.000000,59.145600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<57.660200,0.000000,59.145600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.660200,0.000000,59.145600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.465400,0.000000,58.950800>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<57.465400,0.000000,58.950800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.490900,0.000000,60.120100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.270500,0.000000,60.120100>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<56.490900,0.000000,60.120100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.270500,0.000000,60.120100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.660200,0.000000,60.509800>}
box{<0,0,-0.050800><0.551119,0.036000,0.050800> rotate<0,-44.997030,0> translate<57.270500,0.000000,60.120100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.660200,0.000000,60.509800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.270500,0.000000,60.899600>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,45.004380,0> translate<57.270500,0.000000,60.899600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.270500,0.000000,60.899600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.490900,0.000000,60.899600>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<56.490900,0.000000,60.899600> }
difference{
cylinder{<83.921600,0,34.417000><83.921600,0.036000,34.417000>0.637100 translate<0,0.000000,0>}
cylinder{<83.921600,-0.1,34.417000><83.921600,0.135000,34.417000>0.586300 translate<0,0.000000,0>}}
//C1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<70.383000,0.000000,50.291800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<70.383000,0.000000,48.361800>}
box{<0,0,-0.050800><1.930000,0.036000,0.050800> rotate<0,-90.000000,0> translate<70.383000,0.000000,48.361800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.809000,0.000000,50.291800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.809000,0.000000,48.361800>}
box{<0,0,-0.050800><1.930000,0.036000,0.050800> rotate<0,-90.000000,0> translate<68.809000,0.000000,48.361800> }
box{<-0.375000,0,-0.850000><0.375000,0.036000,0.850000> rotate<0,-270.000000,0> translate<69.595000,0.000000,50.653500>}
box{<-0.375000,0,-0.850000><0.375000,0.036000,0.850000> rotate<0,-270.000000,0> translate<69.596900,0.000000,48.000100>}
//C2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.793800,0.000000,30.150800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.793800,0.000000,27.100800>}
box{<0,0,-0.050800><3.050000,0.036000,0.050800> rotate<0,-90.000000,0> translate<71.793800,0.000000,27.100800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<70.293800,0.000000,27.100800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<70.293800,0.000000,30.150800>}
box{<0,0,-0.050800><3.050000,0.036000,0.050800> rotate<0,90.000000,0> translate<70.293800,0.000000,30.150800> }
box{<-0.250000,0,-0.800000><0.250000,0.036000,0.800000> rotate<0,-270.000000,0> translate<71.043800,0.000000,29.975800>}
box{<-0.250000,0,-0.800000><0.250000,0.036000,0.800000> rotate<0,-270.000000,0> translate<71.043800,0.000000,27.275800>}
//C3 silk screen
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.983000,0.000000,48.361800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.983000,0.000000,50.291800>}
box{<0,0,-0.050800><1.930000,0.036000,0.050800> rotate<0,90.000000,0> translate<63.983000,0.000000,50.291800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.557000,0.000000,48.361800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.557000,0.000000,50.291800>}
box{<0,0,-0.050800><1.930000,0.036000,0.050800> rotate<0,90.000000,0> translate<65.557000,0.000000,50.291800> }
box{<-0.375000,0,-0.850000><0.375000,0.036000,0.850000> rotate<0,-90.000000,0> translate<64.770800,0.000000,48.000100>}
box{<-0.375000,0,-0.850000><0.375000,0.036000,0.850000> rotate<0,-90.000000,0> translate<64.769100,0.000000,50.653500>}
//C4 silk screen
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.396000,0.000000,48.361800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.396000,0.000000,50.291800>}
box{<0,0,-0.050800><1.930000,0.036000,0.050800> rotate<0,90.000000,0> translate<66.396000,0.000000,50.291800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.970000,0.000000,48.361800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.970000,0.000000,50.291800>}
box{<0,0,-0.050800><1.930000,0.036000,0.050800> rotate<0,90.000000,0> translate<67.970000,0.000000,50.291800> }
box{<-0.375000,0,-0.850000><0.375000,0.036000,0.850000> rotate<0,-90.000000,0> translate<67.183800,0.000000,48.000100>}
box{<-0.375000,0,-0.850000><0.375000,0.036000,0.850000> rotate<0,-90.000000,0> translate<67.182100,0.000000,50.653500>}
//C6 silk screen
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<80.161400,0.000000,52.667600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.211400,0.000000,52.667600>}
box{<0,0,-0.050800><3.050000,0.036000,0.050800> rotate<0,0.000000,0> translate<80.161400,0.000000,52.667600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.211400,0.000000,51.167600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<80.161400,0.000000,51.167600>}
box{<0,0,-0.050800><3.050000,0.036000,0.050800> rotate<0,0.000000,0> translate<80.161400,0.000000,51.167600> }
box{<-0.250000,0,-0.800000><0.250000,0.036000,0.800000> rotate<0,-0.000000,0> translate<80.336400,0.000000,51.917600>}
box{<-0.250000,0,-0.800000><0.250000,0.036000,0.800000> rotate<0,-0.000000,0> translate<83.036400,0.000000,51.917600>}
//C8 silk screen
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.130200,0.000000,29.071000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.180200,0.000000,29.071000>}
box{<0,0,-0.050800><3.050000,0.036000,0.050800> rotate<0,0.000000,0> translate<59.130200,0.000000,29.071000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.180200,0.000000,27.571000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.130200,0.000000,27.571000>}
box{<0,0,-0.050800><3.050000,0.036000,0.050800> rotate<0,0.000000,0> translate<59.130200,0.000000,27.571000> }
box{<-0.250000,0,-0.800000><0.250000,0.036000,0.800000> rotate<0,-0.000000,0> translate<59.305200,0.000000,28.321000>}
box{<-0.250000,0,-0.800000><0.250000,0.036000,0.800000> rotate<0,-0.000000,0> translate<62.005200,0.000000,28.321000>}
//C10 silk screen
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.407000,0.000000,64.221500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.407000,0.000000,64.171800>}
box{<0,0,-0.050800><0.049700,0.036000,0.050800> rotate<0,-90.000000,0> translate<81.407000,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.508600,0.000000,64.283200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.508600,0.000000,64.171800>}
box{<0,0,-0.050800><0.111400,0.036000,0.050800> rotate<0,-90.000000,0> translate<81.508600,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.610200,0.000000,64.344900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.610200,0.000000,64.171800>}
box{<0,0,-0.050800><0.173100,0.036000,0.050800> rotate<0,-90.000000,0> translate<81.610200,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.711800,0.000000,64.406500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.711800,0.000000,64.171800>}
box{<0,0,-0.050800><0.234700,0.036000,0.050800> rotate<0,-90.000000,0> translate<81.711800,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.813400,0.000000,64.468200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.813400,0.000000,64.171800>}
box{<0,0,-0.050800><0.296400,0.036000,0.050800> rotate<0,-90.000000,0> translate<81.813400,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.915000,0.000000,64.517700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.915000,0.000000,64.171800>}
box{<0,0,-0.050800><0.345900,0.036000,0.050800> rotate<0,-90.000000,0> translate<81.915000,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.016600,0.000000,64.563600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.016600,0.000000,64.171800>}
box{<0,0,-0.050800><0.391800,0.036000,0.050800> rotate<0,-90.000000,0> translate<82.016600,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.118200,0.000000,64.609500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.118200,0.000000,64.171800>}
box{<0,0,-0.050800><0.437700,0.036000,0.050800> rotate<0,-90.000000,0> translate<82.118200,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.219800,0.000000,64.655400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.219800,0.000000,64.171800>}
box{<0,0,-0.050800><0.483600,0.036000,0.050800> rotate<0,-90.000000,0> translate<82.219800,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.321400,0.000000,64.701300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.321400,0.000000,64.171800>}
box{<0,0,-0.050800><0.529500,0.036000,0.050800> rotate<0,-90.000000,0> translate<82.321400,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.423000,0.000000,64.741500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.423000,0.000000,64.171800>}
box{<0,0,-0.050800><0.569700,0.036000,0.050800> rotate<0,-90.000000,0> translate<82.423000,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.524600,0.000000,64.773300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.524600,0.000000,64.171800>}
box{<0,0,-0.050800><0.601500,0.036000,0.050800> rotate<0,-90.000000,0> translate<82.524600,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.626200,0.000000,64.805000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.626200,0.000000,64.171800>}
box{<0,0,-0.050800><0.633200,0.036000,0.050800> rotate<0,-90.000000,0> translate<82.626200,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.727800,0.000000,64.836800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.727800,0.000000,64.171800>}
box{<0,0,-0.050800><0.665000,0.036000,0.050800> rotate<0,-90.000000,0> translate<82.727800,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.829400,0.000000,64.868600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.829400,0.000000,64.171800>}
box{<0,0,-0.050800><0.696800,0.036000,0.050800> rotate<0,-90.000000,0> translate<82.829400,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.931000,0.000000,64.900400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.931000,0.000000,64.171800>}
box{<0,0,-0.050800><0.728600,0.036000,0.050800> rotate<0,-90.000000,0> translate<82.931000,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.032600,0.000000,64.921800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.032600,0.000000,64.171800>}
box{<0,0,-0.050800><0.750000,0.036000,0.050800> rotate<0,-90.000000,0> translate<83.032600,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.134200,0.000000,64.940500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.134200,0.000000,64.171800>}
box{<0,0,-0.050800><0.768700,0.036000,0.050800> rotate<0,-90.000000,0> translate<83.134200,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235800,0.000000,64.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.235800,0.000000,64.171800>}
box{<0,0,-0.050800><0.787400,0.036000,0.050800> rotate<0,-90.000000,0> translate<83.235800,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.337400,0.000000,64.977900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.337400,0.000000,64.171800>}
box{<0,0,-0.050800><0.806100,0.036000,0.050800> rotate<0,-90.000000,0> translate<83.337400,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.439000,0.000000,64.996500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.439000,0.000000,64.171800>}
box{<0,0,-0.050800><0.824700,0.036000,0.050800> rotate<0,-90.000000,0> translate<83.439000,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.540600,0.000000,65.015200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.540600,0.000000,64.171800>}
box{<0,0,-0.050800><0.843400,0.036000,0.050800> rotate<0,-90.000000,0> translate<83.540600,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.642200,0.000000,65.021400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.642200,0.000000,64.171800>}
box{<0,0,-0.050800><0.849600,0.036000,0.050800> rotate<0,-90.000000,0> translate<83.642200,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.743800,0.000000,65.027600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.743800,0.000000,64.171800>}
box{<0,0,-0.050800><0.855800,0.036000,0.050800> rotate<0,-90.000000,0> translate<83.743800,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.845400,0.000000,65.033700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.845400,0.000000,64.171800>}
box{<0,0,-0.050800><0.861900,0.036000,0.050800> rotate<0,-90.000000,0> translate<83.845400,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.947000,0.000000,65.039900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.947000,0.000000,64.171800>}
box{<0,0,-0.050800><0.868100,0.036000,0.050800> rotate<0,-90.000000,0> translate<83.947000,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.048600,0.000000,65.046000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.048600,0.000000,64.171800>}
box{<0,0,-0.050800><0.874200,0.036000,0.050800> rotate<0,-90.000000,0> translate<84.048600,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.150200,0.000000,65.050600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.150200,0.000000,64.171800>}
box{<0,0,-0.050800><0.878800,0.036000,0.050800> rotate<0,-90.000000,0> translate<84.150200,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,65.044400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.251800,0.000000,64.171800>}
box{<0,0,-0.050800><0.872600,0.036000,0.050800> rotate<0,-90.000000,0> translate<84.251800,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.353400,0.000000,65.038300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.353400,0.000000,64.171800>}
box{<0,0,-0.050800><0.866500,0.036000,0.050800> rotate<0,-90.000000,0> translate<84.353400,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.455000,0.000000,65.032100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.455000,0.000000,64.171800>}
box{<0,0,-0.050800><0.860300,0.036000,0.050800> rotate<0,-90.000000,0> translate<84.455000,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.556600,0.000000,65.025900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.556600,0.000000,64.171800>}
box{<0,0,-0.050800><0.854100,0.036000,0.050800> rotate<0,-90.000000,0> translate<84.556600,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.658200,0.000000,65.019800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.658200,0.000000,64.171800>}
box{<0,0,-0.050800><0.848000,0.036000,0.050800> rotate<0,-90.000000,0> translate<84.658200,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.759800,0.000000,65.010500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.759800,0.000000,64.171800>}
box{<0,0,-0.050800><0.838700,0.036000,0.050800> rotate<0,-90.000000,0> translate<84.759800,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.861400,0.000000,64.991800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.861400,0.000000,64.171800>}
box{<0,0,-0.050800><0.820000,0.036000,0.050800> rotate<0,-90.000000,0> translate<84.861400,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.963000,0.000000,64.973200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.963000,0.000000,64.171800>}
box{<0,0,-0.050800><0.801400,0.036000,0.050800> rotate<0,-90.000000,0> translate<84.963000,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.064600,0.000000,64.954500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.064600,0.000000,64.171800>}
box{<0,0,-0.050800><0.782700,0.036000,0.050800> rotate<0,-90.000000,0> translate<85.064600,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.166200,0.000000,64.935800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.166200,0.000000,64.171800>}
box{<0,0,-0.050800><0.764000,0.036000,0.050800> rotate<0,-90.000000,0> translate<85.166200,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.267800,0.000000,64.917100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.267800,0.000000,64.171800>}
box{<0,0,-0.050800><0.745300,0.036000,0.050800> rotate<0,-90.000000,0> translate<85.267800,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.369400,0.000000,64.892400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.369400,0.000000,64.171800>}
box{<0,0,-0.050800><0.720600,0.036000,0.050800> rotate<0,-90.000000,0> translate<85.369400,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.471000,0.000000,64.860700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.471000,0.000000,64.171800>}
box{<0,0,-0.050800><0.688900,0.036000,0.050800> rotate<0,-90.000000,0> translate<85.471000,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.572600,0.000000,64.828900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.572600,0.000000,64.171800>}
box{<0,0,-0.050800><0.657100,0.036000,0.050800> rotate<0,-90.000000,0> translate<85.572600,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.674200,0.000000,64.797100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.674200,0.000000,64.171800>}
box{<0,0,-0.050800><0.625300,0.036000,0.050800> rotate<0,-90.000000,0> translate<85.674200,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.775800,0.000000,64.765400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.775800,0.000000,64.171800>}
box{<0,0,-0.050800><0.593600,0.036000,0.050800> rotate<0,-90.000000,0> translate<85.775800,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.877400,0.000000,64.733600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.877400,0.000000,64.171800>}
box{<0,0,-0.050800><0.561800,0.036000,0.050800> rotate<0,-90.000000,0> translate<85.877400,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.979000,0.000000,64.690000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.979000,0.000000,64.171800>}
box{<0,0,-0.050800><0.518200,0.036000,0.050800> rotate<0,-90.000000,0> translate<85.979000,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.080600,0.000000,64.644000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.080600,0.000000,64.171800>}
box{<0,0,-0.050800><0.472200,0.036000,0.050800> rotate<0,-90.000000,0> translate<86.080600,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.182200,0.000000,64.598100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.182200,0.000000,64.171800>}
box{<0,0,-0.050800><0.426300,0.036000,0.050800> rotate<0,-90.000000,0> translate<86.182200,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.283800,0.000000,64.552200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.283800,0.000000,64.171800>}
box{<0,0,-0.050800><0.380400,0.036000,0.050800> rotate<0,-90.000000,0> translate<86.283800,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.385400,0.000000,64.506300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.385400,0.000000,64.171800>}
box{<0,0,-0.050800><0.334500,0.036000,0.050800> rotate<0,-90.000000,0> translate<86.385400,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.487000,0.000000,64.452900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.487000,0.000000,64.171800>}
box{<0,0,-0.050800><0.281100,0.036000,0.050800> rotate<0,-90.000000,0> translate<86.487000,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.588600,0.000000,64.391300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.588600,0.000000,64.171800>}
box{<0,0,-0.050800><0.219500,0.036000,0.050800> rotate<0,-90.000000,0> translate<86.588600,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.690200,0.000000,64.329600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.690200,0.000000,64.171800>}
box{<0,0,-0.050800><0.157800,0.036000,0.050800> rotate<0,-90.000000,0> translate<86.690200,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.791800,0.000000,64.267900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.791800,0.000000,64.171800>}
box{<0,0,-0.050800><0.096100,0.036000,0.050800> rotate<0,-90.000000,0> translate<86.791800,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.893400,0.000000,64.206200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.893400,0.000000,64.171800>}
box{<0,0,-0.050800><0.034400,0.036000,0.050800> rotate<0,-90.000000,0> translate<86.893400,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.950200,0.000000,64.171800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.438900,0.000000,64.482200>}
box{<0,0,-0.050800><0.598144,0.036000,0.050800> rotate<0,31.259037,0> translate<86.438900,0.000000,64.482200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.438900,0.000000,64.482200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.893800,0.000000,64.728500>}
box{<0,0,-0.050800><0.598162,0.036000,0.050800> rotate<0,24.313927,0> translate<85.893800,0.000000,64.728500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.893800,0.000000,64.728500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.323000,0.000000,64.907000>}
box{<0,0,-0.050800><0.598059,0.036000,0.050800> rotate<0,17.364309,0> translate<85.323000,0.000000,64.907000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.323000,0.000000,64.907000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.734700,0.000000,65.015200>}
box{<0,0,-0.050800><0.598167,0.036000,0.050800> rotate<0,10.420674,0> translate<84.734700,0.000000,65.015200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.734700,0.000000,65.015200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.137700,0.000000,65.051400>}
box{<0,0,-0.050800><0.598097,0.036000,0.050800> rotate<0,3.469739,0> translate<84.137700,0.000000,65.051400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.137700,0.000000,65.051400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.540700,0.000000,65.015200>}
box{<0,0,-0.050800><0.598097,0.036000,0.050800> rotate<0,-3.469739,0> translate<83.540700,0.000000,65.015200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.540700,0.000000,65.015200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.952400,0.000000,64.907000>}
box{<0,0,-0.050800><0.598167,0.036000,0.050800> rotate<0,-10.420674,0> translate<82.952400,0.000000,64.907000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.952400,0.000000,64.907000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.381600,0.000000,64.728500>}
box{<0,0,-0.050800><0.598059,0.036000,0.050800> rotate<0,-17.364309,0> translate<82.381600,0.000000,64.728500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.381600,0.000000,64.728500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.836500,0.000000,64.482200>}
box{<0,0,-0.050800><0.598162,0.036000,0.050800> rotate<0,-24.313927,0> translate<81.836500,0.000000,64.482200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.836500,0.000000,64.482200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.325200,0.000000,64.171800>}
box{<0,0,-0.050800><0.598144,0.036000,0.050800> rotate<0,-31.259037,0> translate<81.325200,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.325200,0.000000,64.171800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.950200,0.000000,64.171800>}
box{<0,0,-0.050800><5.625000,0.036000,0.050800> rotate<0,0.000000,0> translate<81.325200,0.000000,64.171800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.250200,0.000000,65.221800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.250200,0.000000,55.821800>}
box{<0,0,-0.050800><9.400000,0.036000,0.050800> rotate<0,-90.000000,0> translate<89.250200,0.000000,55.821800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.250200,0.000000,55.821800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.450200,0.000000,55.021800>}
box{<0,0,-0.050800><1.131371,0.036000,0.050800> rotate<0,-44.997030,0> translate<88.450200,0.000000,55.021800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.450200,0.000000,55.021800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.850200,0.000000,55.021800>}
box{<0,0,-0.050800><8.600000,0.036000,0.050800> rotate<0,0.000000,0> translate<79.850200,0.000000,55.021800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.850200,0.000000,55.021800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.050200,0.000000,55.821800>}
box{<0,0,-0.050800><1.131371,0.036000,0.050800> rotate<0,44.997030,0> translate<79.050200,0.000000,55.821800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.050200,0.000000,55.821800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.050200,0.000000,65.221800>}
box{<0,0,-0.050800><9.400000,0.036000,0.050800> rotate<0,90.000000,0> translate<79.050200,0.000000,65.221800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.050200,0.000000,65.221800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.250200,0.000000,65.221800>}
box{<0,0,-0.050800><10.200000,0.036000,0.050800> rotate<0,0.000000,0> translate<79.050200,0.000000,65.221800> }
object{ARC(4.948200,0.101600,279.870072,440.129928,0.036000) translate<84.152000,0.000000,60.121800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.025200,0.000000,65.221800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.250200,0.000000,65.221800>}
box{<0,0,-0.050800><4.225000,0.036000,0.050800> rotate<0,0.000000,0> translate<85.025200,0.000000,65.221800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.250200,0.000000,65.221800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.250200,0.000000,55.821800>}
box{<0,0,-0.050800><9.400000,0.036000,0.050800> rotate<0,-90.000000,0> translate<89.250200,0.000000,55.821800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.250200,0.000000,55.821800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.450200,0.000000,55.021800>}
box{<0,0,-0.050800><1.131371,0.036000,0.050800> rotate<0,-44.997030,0> translate<88.450200,0.000000,55.021800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.850200,0.000000,55.021800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.050200,0.000000,55.821800>}
box{<0,0,-0.050800><1.131371,0.036000,0.050800> rotate<0,44.997030,0> translate<79.050200,0.000000,55.821800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.050200,0.000000,55.821800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.050200,0.000000,65.221800>}
box{<0,0,-0.050800><9.400000,0.036000,0.050800> rotate<0,90.000000,0> translate<79.050200,0.000000,65.221800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.050200,0.000000,65.221800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.300200,0.000000,65.221800>}
box{<0,0,-0.050800><4.250000,0.036000,0.050800> rotate<0,0.000000,0> translate<79.050200,0.000000,65.221800> }
object{ARC(4.948200,0.101600,99.870072,260.129928,0.036000) translate<84.148400,0.000000,60.121800>}
difference{
cylinder{<84.150200,0,60.121800><84.150200,0.036000,60.121800>5.000800 translate<0,0.000000,0>}
cylinder{<84.150200,-0.1,60.121800><84.150200,0.135000,60.121800>4.899200 translate<0,0.000000,0>}}
//C11 silk screen
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.085100,0.000000,39.065200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,39.065200>}
box{<0,0,-0.050800><0.049700,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,39.065200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.146800,0.000000,38.963600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,38.963600>}
box{<0,0,-0.050800><0.111400,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,38.963600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.208500,0.000000,38.862000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,38.862000>}
box{<0,0,-0.050800><0.173100,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,38.862000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.270100,0.000000,38.760400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,38.760400>}
box{<0,0,-0.050800><0.234700,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,38.760400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.331800,0.000000,38.658800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,38.658800>}
box{<0,0,-0.050800><0.296400,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,38.658800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.381300,0.000000,38.557200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,38.557200>}
box{<0,0,-0.050800><0.345900,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,38.557200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.427200,0.000000,38.455600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,38.455600>}
box{<0,0,-0.050800><0.391800,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,38.455600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.473100,0.000000,38.354000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,38.354000>}
box{<0,0,-0.050800><0.437700,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,38.354000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.519000,0.000000,38.252400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,38.252400>}
box{<0,0,-0.050800><0.483600,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,38.252400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.564900,0.000000,38.150800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,38.150800>}
box{<0,0,-0.050800><0.529500,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,38.150800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.605100,0.000000,38.049200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,38.049200>}
box{<0,0,-0.050800><0.569700,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,38.049200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.636900,0.000000,37.947600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,37.947600>}
box{<0,0,-0.050800><0.601500,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,37.947600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.668600,0.000000,37.846000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,37.846000>}
box{<0,0,-0.050800><0.633200,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,37.846000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.700400,0.000000,37.744400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,37.744400>}
box{<0,0,-0.050800><0.665000,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,37.744400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.732200,0.000000,37.642800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,37.642800>}
box{<0,0,-0.050800><0.696800,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,37.642800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.764000,0.000000,37.541200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,37.541200>}
box{<0,0,-0.050800><0.728600,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,37.541200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.785400,0.000000,37.439600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,37.439600>}
box{<0,0,-0.050800><0.750000,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,37.439600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.804100,0.000000,37.338000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,37.338000>}
box{<0,0,-0.050800><0.768700,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,37.338000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.822800,0.000000,37.236400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,37.236400>}
box{<0,0,-0.050800><0.787400,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,37.236400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.841500,0.000000,37.134800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,37.134800>}
box{<0,0,-0.050800><0.806100,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,37.134800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.860100,0.000000,37.033200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,37.033200>}
box{<0,0,-0.050800><0.824700,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,37.033200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.878800,0.000000,36.931600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,36.931600>}
box{<0,0,-0.050800><0.843400,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,36.931600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.885000,0.000000,36.830000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,36.830000>}
box{<0,0,-0.050800><0.849600,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,36.830000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.891200,0.000000,36.728400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,36.728400>}
box{<0,0,-0.050800><0.855800,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,36.728400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.897300,0.000000,36.626800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,36.626800>}
box{<0,0,-0.050800><0.861900,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,36.626800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.903500,0.000000,36.525200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,36.525200>}
box{<0,0,-0.050800><0.868100,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,36.525200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.909600,0.000000,36.423600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,36.423600>}
box{<0,0,-0.050800><0.874200,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,36.423600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.914200,0.000000,36.322000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,36.322000>}
box{<0,0,-0.050800><0.878800,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,36.322000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.908000,0.000000,36.220400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,36.220400>}
box{<0,0,-0.050800><0.872600,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,36.220400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.901900,0.000000,36.118800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,36.118800>}
box{<0,0,-0.050800><0.866500,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,36.118800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.895700,0.000000,36.017200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,36.017200>}
box{<0,0,-0.050800><0.860300,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,36.017200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.889500,0.000000,35.915600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,35.915600>}
box{<0,0,-0.050800><0.854100,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,35.915600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.883400,0.000000,35.814000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,35.814000>}
box{<0,0,-0.050800><0.848000,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,35.814000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.874100,0.000000,35.712400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,35.712400>}
box{<0,0,-0.050800><0.838700,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,35.712400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.855400,0.000000,35.610800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,35.610800>}
box{<0,0,-0.050800><0.820000,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,35.610800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.836800,0.000000,35.509200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,35.509200>}
box{<0,0,-0.050800><0.801400,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,35.509200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.818100,0.000000,35.407600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,35.407600>}
box{<0,0,-0.050800><0.782700,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,35.407600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.799400,0.000000,35.306000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,35.306000>}
box{<0,0,-0.050800><0.764000,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,35.306000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.780700,0.000000,35.204400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,35.204400>}
box{<0,0,-0.050800><0.745300,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,35.204400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.756000,0.000000,35.102800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,35.102800>}
box{<0,0,-0.050800><0.720600,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,35.102800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.724300,0.000000,35.001200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,35.001200>}
box{<0,0,-0.050800><0.688900,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,35.001200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.692500,0.000000,34.899600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,34.899600>}
box{<0,0,-0.050800><0.657100,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,34.899600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.660700,0.000000,34.798000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,34.798000>}
box{<0,0,-0.050800><0.625300,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,34.798000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.629000,0.000000,34.696400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,34.696400>}
box{<0,0,-0.050800><0.593600,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,34.696400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.597200,0.000000,34.594800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,34.594800>}
box{<0,0,-0.050800><0.561800,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,34.594800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.553600,0.000000,34.493200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,34.493200>}
box{<0,0,-0.050800><0.518200,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,34.493200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.507600,0.000000,34.391600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,34.391600>}
box{<0,0,-0.050800><0.472200,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,34.391600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.461700,0.000000,34.290000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,34.290000>}
box{<0,0,-0.050800><0.426300,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,34.290000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.415800,0.000000,34.188400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,34.188400>}
box{<0,0,-0.050800><0.380400,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,34.188400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.369900,0.000000,34.086800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,34.086800>}
box{<0,0,-0.050800><0.334500,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,34.086800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.316500,0.000000,33.985200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,33.985200>}
box{<0,0,-0.050800><0.281100,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,33.985200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.254900,0.000000,33.883600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,33.883600>}
box{<0,0,-0.050800><0.219500,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,33.883600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.193200,0.000000,33.782000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,33.782000>}
box{<0,0,-0.050800><0.157800,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,33.782000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.131500,0.000000,33.680400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,33.680400>}
box{<0,0,-0.050800><0.096100,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,33.680400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.069800,0.000000,33.578800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,33.578800>}
box{<0,0,-0.050800><0.034400,0.036000,0.050800> rotate<0,0.000000,0> translate<65.035400,0.000000,33.578800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,33.522000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.345800,0.000000,34.033300>}
box{<0,0,-0.050800><0.598144,0.036000,0.050800> rotate<0,-58.735024,0> translate<65.035400,0.000000,33.522000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.345800,0.000000,34.033300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.592100,0.000000,34.578400>}
box{<0,0,-0.050800><0.598162,0.036000,0.050800> rotate<0,-65.680133,0> translate<65.345800,0.000000,34.033300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.592100,0.000000,34.578400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.770600,0.000000,35.149200>}
box{<0,0,-0.050800><0.598059,0.036000,0.050800> rotate<0,-72.629752,0> translate<65.592100,0.000000,34.578400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.770600,0.000000,35.149200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.878800,0.000000,35.737500>}
box{<0,0,-0.050800><0.598167,0.036000,0.050800> rotate<0,-79.573386,0> translate<65.770600,0.000000,35.149200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.878800,0.000000,35.737500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.915000,0.000000,36.334500>}
box{<0,0,-0.050800><0.598097,0.036000,0.050800> rotate<0,-86.524322,0> translate<65.878800,0.000000,35.737500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.915000,0.000000,36.334500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.878800,0.000000,36.931500>}
box{<0,0,-0.050800><0.598097,0.036000,0.050800> rotate<0,86.524322,0> translate<65.878800,0.000000,36.931500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.878800,0.000000,36.931500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.770600,0.000000,37.519800>}
box{<0,0,-0.050800><0.598167,0.036000,0.050800> rotate<0,79.573386,0> translate<65.770600,0.000000,37.519800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.770600,0.000000,37.519800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.592100,0.000000,38.090600>}
box{<0,0,-0.050800><0.598059,0.036000,0.050800> rotate<0,72.629752,0> translate<65.592100,0.000000,38.090600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.592100,0.000000,38.090600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.345800,0.000000,38.635700>}
box{<0,0,-0.050800><0.598162,0.036000,0.050800> rotate<0,65.680133,0> translate<65.345800,0.000000,38.635700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.345800,0.000000,38.635700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,39.147000>}
box{<0,0,-0.050800><0.598144,0.036000,0.050800> rotate<0,58.735024,0> translate<65.035400,0.000000,39.147000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,39.147000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.035400,0.000000,33.522000>}
box{<0,0,-0.050800><5.625000,0.036000,0.050800> rotate<0,-90.000000,0> translate<65.035400,0.000000,33.522000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.085400,0.000000,31.222000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.685400,0.000000,31.222000>}
box{<0,0,-0.050800><9.400000,0.036000,0.050800> rotate<0,0.000000,0> translate<56.685400,0.000000,31.222000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.685400,0.000000,31.222000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.885400,0.000000,32.022000>}
box{<0,0,-0.050800><1.131371,0.036000,0.050800> rotate<0,44.997030,0> translate<55.885400,0.000000,32.022000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.885400,0.000000,32.022000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.885400,0.000000,40.622000>}
box{<0,0,-0.050800><8.600000,0.036000,0.050800> rotate<0,90.000000,0> translate<55.885400,0.000000,40.622000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.885400,0.000000,40.622000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.685400,0.000000,41.422000>}
box{<0,0,-0.050800><1.131371,0.036000,0.050800> rotate<0,-44.997030,0> translate<55.885400,0.000000,40.622000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.685400,0.000000,41.422000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.085400,0.000000,41.422000>}
box{<0,0,-0.050800><9.400000,0.036000,0.050800> rotate<0,0.000000,0> translate<56.685400,0.000000,41.422000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.085400,0.000000,41.422000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.085400,0.000000,31.222000>}
box{<0,0,-0.050800><10.200000,0.036000,0.050800> rotate<0,-90.000000,0> translate<66.085400,0.000000,31.222000> }
object{ARC(4.948200,0.101600,189.870072,350.129928,0.036000) translate<60.985400,0.000000,36.320200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.085400,0.000000,35.447000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.085400,0.000000,31.222000>}
box{<0,0,-0.050800><4.225000,0.036000,0.050800> rotate<0,-90.000000,0> translate<66.085400,0.000000,31.222000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.085400,0.000000,31.222000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.685400,0.000000,31.222000>}
box{<0,0,-0.050800><9.400000,0.036000,0.050800> rotate<0,0.000000,0> translate<56.685400,0.000000,31.222000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.685400,0.000000,31.222000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.885400,0.000000,32.022000>}
box{<0,0,-0.050800><1.131371,0.036000,0.050800> rotate<0,44.997030,0> translate<55.885400,0.000000,32.022000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.885400,0.000000,40.622000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.685400,0.000000,41.422000>}
box{<0,0,-0.050800><1.131371,0.036000,0.050800> rotate<0,-44.997030,0> translate<55.885400,0.000000,40.622000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.685400,0.000000,41.422000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.085400,0.000000,41.422000>}
box{<0,0,-0.050800><9.400000,0.036000,0.050800> rotate<0,0.000000,0> translate<56.685400,0.000000,41.422000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.085400,0.000000,41.422000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.085400,0.000000,37.172000>}
box{<0,0,-0.050800><4.250000,0.036000,0.050800> rotate<0,-90.000000,0> translate<66.085400,0.000000,37.172000> }
object{ARC(4.948200,0.101600,9.870072,170.129928,0.036000) translate<60.985400,0.000000,36.323800>}
difference{
cylinder{<60.985400,0,36.322000><60.985400,0.036000,36.322000>5.000800 translate<0,0.000000,0>}
cylinder{<60.985400,-0.1,36.322000><60.985400,0.135000,36.322000>4.899200 translate<0,0.000000,0>}}
//C12 silk screen
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.998600,0.000000,18.545600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.998600,0.000000,20.475600>}
box{<0,0,-0.050800><1.930000,0.036000,0.050800> rotate<0,90.000000,0> translate<85.998600,0.000000,20.475600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.572600,0.000000,18.545600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.572600,0.000000,20.475600>}
box{<0,0,-0.050800><1.930000,0.036000,0.050800> rotate<0,90.000000,0> translate<87.572600,0.000000,20.475600> }
box{<-0.375000,0,-0.850000><0.375000,0.036000,0.850000> rotate<0,-90.000000,0> translate<86.786400,0.000000,18.183900>}
box{<-0.375000,0,-0.850000><0.375000,0.036000,0.850000> rotate<0,-90.000000,0> translate<86.784700,0.000000,20.837300>}
//DRIVER silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<67.150000,0.000000,42.612800>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<82.710000,0.000000,42.612800>}
box{<0,0,-0.101600><15.560000,0.036000,0.101600> rotate<0,0.000000,0> translate<67.150000,0.000000,42.612800> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<82.710000,0.000000,42.612800>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<82.710000,0.000000,42.112800>}
box{<0,0,-0.101600><0.500000,0.036000,0.101600> rotate<0,-90.000000,0> translate<82.710000,0.000000,42.112800> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<82.710000,0.000000,42.112800>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<82.710000,0.000000,35.212800>}
box{<0,0,-0.101600><6.900000,0.036000,0.101600> rotate<0,-90.000000,0> translate<82.710000,0.000000,35.212800> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<82.710000,0.000000,35.212800>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<67.150000,0.000000,35.212800>}
box{<0,0,-0.101600><15.560000,0.036000,0.101600> rotate<0,0.000000,0> translate<67.150000,0.000000,35.212800> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<67.150000,0.000000,42.112800>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<82.710000,0.000000,42.112800>}
box{<0,0,-0.101600><15.560000,0.036000,0.101600> rotate<0,0.000000,0> translate<67.150000,0.000000,42.112800> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<67.150000,0.000000,35.212800>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<67.150000,0.000000,42.112800>}
box{<0,0,-0.101600><6.900000,0.036000,0.101600> rotate<0,90.000000,0> translate<67.150000,0.000000,42.112800> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<67.150000,0.000000,42.112800>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<67.150000,0.000000,42.612800>}
box{<0,0,-0.101600><0.500000,0.036000,0.101600> rotate<0,90.000000,0> translate<67.150000,0.000000,42.612800> }
object{ARC(1.232000,0.127000,88.818715,270.000000,0.036000) translate<82.575400,0.000000,38.671600>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<81.915000,0.000000,43.472700>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<80.645000,0.000000,43.472700>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<79.375000,0.000000,43.472700>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<78.105000,0.000000,43.472700>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<76.835000,0.000000,43.472700>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<75.565000,0.000000,43.472700>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<74.295000,0.000000,43.472700>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<73.025000,0.000000,43.472700>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<71.755000,0.000000,43.472700>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<70.485000,0.000000,43.472700>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<69.215000,0.000000,43.472700>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<67.945000,0.000000,43.472700>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<67.945000,0.000000,34.352800>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<69.215000,0.000000,34.352800>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<70.485000,0.000000,34.352800>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<71.755000,0.000000,34.352800>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<73.025000,0.000000,34.352800>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<74.295000,0.000000,34.352800>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<75.565000,0.000000,34.352800>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<76.835000,0.000000,34.352800>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<78.105000,0.000000,34.352800>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<79.375000,0.000000,34.352800>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<80.645000,0.000000,34.352800>}
box{<-0.245100,0,-0.759900><0.245100,0.036000,0.759900> rotate<0,-180.000000,0> translate<81.915000,0.000000,34.352800>}
//IC3 silk screen
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<62.534800,0.000000,43.527400>}
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<57.404000,0.000000,43.527400>}
box{<0,0,-0.099900><5.130800,0.036000,0.099900> rotate<0,0.000000,0> translate<57.404000,0.000000,43.527400> }
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<62.534800,0.000000,43.327600>}
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<57.404000,0.000000,43.327600>}
box{<0,0,-0.099900><5.130800,0.036000,0.099900> rotate<0,0.000000,0> translate<57.404000,0.000000,43.327600> }
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<62.534800,0.000000,43.127800>}
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<57.404000,0.000000,43.127800>}
box{<0,0,-0.099900><5.130800,0.036000,0.099900> rotate<0,0.000000,0> translate<57.404000,0.000000,43.127800> }
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<62.534800,0.000000,42.928000>}
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<57.404000,0.000000,42.928000>}
box{<0,0,-0.099900><5.130800,0.036000,0.099900> rotate<0,0.000000,0> translate<57.404000,0.000000,42.928000> }
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<62.387800,0.000000,42.728200>}
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<57.551000,0.000000,42.728200>}
box{<0,0,-0.099900><4.836800,0.036000,0.099900> rotate<0,0.000000,0> translate<57.551000,0.000000,42.728200> }
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<62.188000,0.000000,42.528400>}
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<57.750800,0.000000,42.528400>}
box{<0,0,-0.099900><4.437200,0.036000,0.099900> rotate<0,0.000000,0> translate<57.750800,0.000000,42.528400> }
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<62.534800,0.000000,43.586400>}
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<62.534800,0.000000,42.875200>}
box{<0,0,-0.099900><0.711200,0.036000,0.099900> rotate<0,-90.000000,0> translate<62.534800,0.000000,42.875200> }
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<62.534800,0.000000,42.875200>}
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<62.077600,0.000000,42.418000>}
box{<0,0,-0.099900><0.646578,0.036000,0.099900> rotate<0,-44.997030,0> translate<62.077600,0.000000,42.418000> }
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<62.077600,0.000000,42.418000>}
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<57.861200,0.000000,42.418000>}
box{<0,0,-0.099900><4.216400,0.036000,0.099900> rotate<0,0.000000,0> translate<57.861200,0.000000,42.418000> }
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<57.861200,0.000000,42.418000>}
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<57.404000,0.000000,42.875200>}
box{<0,0,-0.099900><0.646578,0.036000,0.099900> rotate<0,44.997030,0> translate<57.404000,0.000000,42.875200> }
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<57.404000,0.000000,42.875200>}
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<57.404000,0.000000,43.586400>}
box{<0,0,-0.099900><0.711200,0.036000,0.099900> rotate<0,90.000000,0> translate<57.404000,0.000000,43.586400> }
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<57.404000,0.000000,43.586400>}
cylinder{<0,0,0><0,0.036000,0>0.099900 translate<62.534800,0.000000,43.586400>}
box{<0,0,-0.099900><5.130800,0.036000,0.099900> rotate<0,0.000000,0> translate<57.404000,0.000000,43.586400> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<56.692800,0.000000,43.688000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<56.692400,0.000000,49.682400>}
box{<0,0,-0.101600><5.994400,0.036000,0.101600> rotate<0,89.990237,0> translate<56.692400,0.000000,49.682400> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<56.692400,0.000000,49.682400>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<63.246400,0.000000,49.682400>}
box{<0,0,-0.101600><6.554000,0.036000,0.101600> rotate<0,0.000000,0> translate<56.692400,0.000000,49.682400> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<63.246400,0.000000,49.682400>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<63.246000,0.000000,43.688000>}
box{<0,0,-0.101600><5.994400,0.036000,0.101600> rotate<0,-89.990237,0> translate<63.246000,0.000000,43.688000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<63.246400,0.000000,43.688400>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<56.692000,0.000000,43.688800>}
box{<0,0,-0.101600><6.554400,0.036000,0.101600> rotate<0,0.003496,0> translate<56.692000,0.000000,43.688800> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<62.534800,0.000000,43.586400>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<62.534800,0.000000,42.875200>}
box{<0,0,-0.101600><0.711200,0.036000,0.101600> rotate<0,-90.000000,0> translate<62.534800,0.000000,42.875200> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<62.534800,0.000000,42.875200>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<62.077600,0.000000,42.418000>}
box{<0,0,-0.101600><0.646578,0.036000,0.101600> rotate<0,-44.997030,0> translate<62.077600,0.000000,42.418000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<62.077600,0.000000,42.418000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<57.861200,0.000000,42.418000>}
box{<0,0,-0.101600><4.216400,0.036000,0.101600> rotate<0,0.000000,0> translate<57.861200,0.000000,42.418000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<57.861200,0.000000,42.418000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<57.404000,0.000000,42.875200>}
box{<0,0,-0.101600><0.646578,0.036000,0.101600> rotate<0,44.997030,0> translate<57.404000,0.000000,42.875200> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<57.404000,0.000000,42.875200>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<57.404000,0.000000,43.586400>}
box{<0,0,-0.101600><0.711200,0.036000,0.101600> rotate<0,90.000000,0> translate<57.404000,0.000000,43.586400> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<57.404000,0.000000,43.586400>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<62.534800,0.000000,43.586400>}
box{<0,0,-0.101600><5.130800,0.036000,0.101600> rotate<0,0.000000,0> translate<57.404000,0.000000,43.586400> }
box{<-0.431800,0,-1.447800><0.431800,0.036000,1.447800> rotate<0,-180.000000,0> translate<62.255400,0.000000,51.231800>}
box{<-0.431800,0,-1.447800><0.431800,0.036000,1.447800> rotate<0,-180.000000,0> translate<57.683400,0.000000,51.231800>}
box{<-0.431800,0,-0.381000><0.431800,0.036000,0.381000> rotate<0,-180.000000,0> translate<59.969400,0.000000,50.165000>}
//J1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,54.187000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,51.308000>}
box{<0,0,-0.101600><2.879004,0.036000,0.101600> rotate<0,89.894561,0> translate<55.113000,0.000000,54.187000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,50.800000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,50.038000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-90.000000,0> translate<55.113000,0.000000,50.038000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,48.768000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-90.000000,0> translate<55.118000,0.000000,48.768000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,48.260000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,47.498000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-90.000000,0> translate<55.118000,0.000000,47.498000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,46.228000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-90.000000,0> translate<55.118000,0.000000,46.228000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,45.720000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.112900,0.000000,44.958000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-89.986542,0> translate<55.112900,0.000000,44.958000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,44.450000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,43.688000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-90.000000,0> translate<55.118000,0.000000,43.688000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118100,0.000000,42.418000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,89.986542,0> translate<55.118000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.112900,0.000000,41.910000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,39.031000>}
box{<0,0,-0.101600><2.879000,0.036000,0.101600> rotate<0,89.992070,0> translate<55.112900,0.000000,41.910000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,50.038000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,49.530000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<53.848000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,48.768000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,48.260000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<51.308000,0.000000,48.260000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,47.498000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,46.990000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<53.848000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,50.038000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,50.038000>}
box{<0,0,-0.101600><0.005000,0.036000,0.101600> rotate<0,0.000000,0> translate<55.113000,0.000000,50.038000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,50.038000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,50.038000>}
box{<0,0,-0.101600><1.265000,0.036000,0.101600> rotate<0,0.000000,0> translate<53.848000,0.000000,50.038000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,48.768000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,48.768000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<51.308000,0.000000,48.768000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<53.848000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,47.498000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,47.498000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<53.848000,0.000000,47.498000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,48.260000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,48.260000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<51.308000,0.000000,48.260000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,46.228000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,46.228000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<51.308000,0.000000,46.228000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<53.848000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,46.228000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,45.720000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<51.308000,0.000000,45.720000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,45.720000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,45.720000>}
box{<0,0,-0.101600><0.005000,0.036000,0.101600> rotate<0,0.000000,0> translate<55.113000,0.000000,45.720000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,45.720000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,45.720000>}
box{<0,0,-0.101600><3.805000,0.036000,0.101600> rotate<0,0.000000,0> translate<51.308000,0.000000,45.720000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,51.308000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,50.800000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<51.308000,0.000000,50.800000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,51.308000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,51.308000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<51.308000,0.000000,51.308000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,50.800000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,50.800000>}
box{<0,0,-0.101600><0.005000,0.036000,0.101600> rotate<0,0.000000,0> translate<55.113000,0.000000,50.800000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,50.800000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,50.800000>}
box{<0,0,-0.101600><3.805000,0.036000,0.101600> rotate<0,0.000000,0> translate<51.308000,0.000000,50.800000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,44.958000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,44.450000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<53.848000,0.000000,44.450000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118100,0.000000,44.958000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,44.958000>}
box{<0,0,-0.101600><1.270100,0.036000,0.101600> rotate<0,0.000000,0> translate<53.848000,0.000000,44.958000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,44.450000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,44.450000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<53.848000,0.000000,44.450000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.112900,0.000000,42.418000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-89.986542,0> translate<55.112900,0.000000,42.418000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,43.688000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,43.688000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<51.308000,0.000000,43.688000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,43.688000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,43.180000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<51.308000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,43.180000>}
box{<0,0,-0.101600><3.805000,0.036000,0.101600> rotate<0,0.000000,0> translate<51.308000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,42.418000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,41.910000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<53.848000,0.000000,41.910000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118100,0.000000,42.418000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,42.418000>}
box{<0,0,-0.101600><1.270100,0.036000,0.101600> rotate<0,0.000000,0> translate<53.848000,0.000000,42.418000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118100,0.000000,41.910000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.112900,0.000000,41.910000>}
box{<0,0,-0.101600><0.005200,0.036000,0.101600> rotate<0,0.000000,0> translate<55.112900,0.000000,41.910000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.112900,0.000000,41.910000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,41.910000>}
box{<0,0,-0.101600><1.264900,0.036000,0.101600> rotate<0,0.000000,0> translate<53.848000,0.000000,41.910000> }
//J2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,38.566000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,35.687000>}
box{<0,0,-0.101600><2.879004,0.036000,0.101600> rotate<0,89.894561,0> translate<55.113000,0.000000,38.566000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,35.179000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,34.417000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-90.000000,0> translate<55.113000,0.000000,34.417000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,33.909000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,33.147000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-90.000000,0> translate<55.118000,0.000000,33.147000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,32.639000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,31.877000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-90.000000,0> translate<55.118000,0.000000,31.877000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,31.369000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,30.607000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-90.000000,0> translate<55.118000,0.000000,30.607000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,30.099000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.112900,0.000000,29.337000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-89.986542,0> translate<55.112900,0.000000,29.337000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,28.829000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,28.067000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-90.000000,0> translate<55.118000,0.000000,28.067000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,27.559000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118100,0.000000,26.797000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,89.986542,0> translate<55.118000,0.000000,27.559000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.112900,0.000000,26.289000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,23.410000>}
box{<0,0,-0.101600><2.879000,0.036000,0.101600> rotate<0,89.992070,0> translate<55.112900,0.000000,26.289000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,34.417000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,33.909000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<53.848000,0.000000,33.909000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,33.147000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,32.639000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<51.308000,0.000000,32.639000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,31.877000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,31.369000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<53.848000,0.000000,31.369000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,34.417000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,34.417000>}
box{<0,0,-0.101600><0.005000,0.036000,0.101600> rotate<0,0.000000,0> translate<55.113000,0.000000,34.417000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,34.417000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,34.417000>}
box{<0,0,-0.101600><1.265000,0.036000,0.101600> rotate<0,0.000000,0> translate<53.848000,0.000000,34.417000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,33.147000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,33.147000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<51.308000,0.000000,33.147000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,33.909000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,33.909000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<53.848000,0.000000,33.909000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,31.877000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,31.877000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<53.848000,0.000000,31.877000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,32.639000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,32.639000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<51.308000,0.000000,32.639000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,30.607000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,30.607000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<51.308000,0.000000,30.607000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,31.369000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,31.369000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<53.848000,0.000000,31.369000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,30.607000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,30.099000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<51.308000,0.000000,30.099000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,30.099000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,30.099000>}
box{<0,0,-0.101600><0.005000,0.036000,0.101600> rotate<0,0.000000,0> translate<55.113000,0.000000,30.099000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,30.099000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,30.099000>}
box{<0,0,-0.101600><3.805000,0.036000,0.101600> rotate<0,0.000000,0> translate<51.308000,0.000000,30.099000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,35.687000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,35.179000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<51.308000,0.000000,35.179000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,35.687000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,35.687000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<51.308000,0.000000,35.687000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,35.179000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,35.179000>}
box{<0,0,-0.101600><0.005000,0.036000,0.101600> rotate<0,0.000000,0> translate<55.113000,0.000000,35.179000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,35.179000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,35.179000>}
box{<0,0,-0.101600><3.805000,0.036000,0.101600> rotate<0,0.000000,0> translate<51.308000,0.000000,35.179000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,29.337000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,28.829000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<53.848000,0.000000,28.829000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118100,0.000000,29.337000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,29.337000>}
box{<0,0,-0.101600><1.270100,0.036000,0.101600> rotate<0,0.000000,0> translate<53.848000,0.000000,29.337000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,28.829000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,28.829000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<53.848000,0.000000,28.829000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,27.559000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.112900,0.000000,26.797000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-89.986542,0> translate<55.112900,0.000000,26.797000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118000,0.000000,28.067000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,28.067000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<51.308000,0.000000,28.067000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,28.067000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,27.559000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<51.308000,0.000000,27.559000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.113000,0.000000,27.559000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.308000,0.000000,27.559000>}
box{<0,0,-0.101600><3.805000,0.036000,0.101600> rotate<0,0.000000,0> translate<51.308000,0.000000,27.559000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,26.797000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,26.289000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<53.848000,0.000000,26.289000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118100,0.000000,26.797000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,26.797000>}
box{<0,0,-0.101600><1.270100,0.036000,0.101600> rotate<0,0.000000,0> translate<53.848000,0.000000,26.797000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.118100,0.000000,26.289000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.112900,0.000000,26.289000>}
box{<0,0,-0.101600><0.005200,0.036000,0.101600> rotate<0,0.000000,0> translate<55.112900,0.000000,26.289000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.112900,0.000000,26.289000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.848000,0.000000,26.289000>}
box{<0,0,-0.101600><1.264900,0.036000,0.101600> rotate<0,0.000000,0> translate<53.848000,0.000000,26.289000> }
//LED1 silk screen
object{ARC(0.400800,0.101600,183.690466,356.309534,0.036000) translate<52.050000,0.000000,63.471800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.250000,0.000000,60.896000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.250000,0.000000,62.796000>}
box{<0,0,-0.050800><1.900000,0.036000,0.050800> rotate<0,90.000000,0> translate<51.250000,0.000000,62.796000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.850000,0.000000,62.796000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.850000,0.000000,60.896000>}
box{<0,0,-0.050800><1.900000,0.036000,0.050800> rotate<0,-90.000000,0> translate<52.850000,0.000000,60.896000> }
difference{
cylinder{<51.500000,0,63.271000><51.500000,0.036000,63.271000>0.150800 translate<0,0.000000,0>}
cylinder{<51.500000,-0.1,63.271000><51.500000,0.135000,63.271000>0.049200 translate<0,0.000000,0>}}
box{<-0.250000,0,-0.062500><0.250000,0.036000,0.062500> rotate<0,-0.000000,0> translate<51.450000,0.000000,63.433500>}
box{<-0.112500,0,-0.162500><0.112500,0.036000,0.162500> rotate<0,-0.000000,0> translate<51.312500,0.000000,63.233500>}
box{<-0.062500,0,-0.112500><0.062500,0.036000,0.112500> rotate<0,-0.000000,0> translate<51.662500,0.000000,63.183500>}
box{<-0.212500,0,-0.062500><0.212500,0.036000,0.062500> rotate<0,-0.000000,0> translate<51.612500,0.000000,63.133500>}
box{<-0.250000,0,-0.175000><0.250000,0.036000,0.175000> rotate<0,-0.000000,0> translate<52.650000,0.000000,63.321000>}
box{<-0.300000,0,-0.062500><0.300000,0.036000,0.062500> rotate<0,-0.000000,0> translate<52.600000,0.000000,63.133500>}
box{<-0.850000,0,-0.150000><0.850000,0.036000,0.150000> rotate<0,-0.000000,0> translate<52.050000,0.000000,62.946000>}
box{<-0.850000,0,-0.350000><0.850000,0.036000,0.350000> rotate<0,-0.000000,0> translate<52.050000,0.000000,60.546000>}
box{<-0.162500,0,-0.212500><0.162500,0.036000,0.212500> rotate<0,-0.000000,0> translate<51.362500,0.000000,62.408500>}
box{<-0.162500,0,-0.212500><0.162500,0.036000,0.212500> rotate<0,-0.000000,0> translate<52.737500,0.000000,62.408500>}
box{<-0.175000,0,-0.175000><0.175000,0.036000,0.175000> rotate<0,-0.000000,0> translate<52.050000,0.000000,62.021000>}
//LED2 silk screen
object{ARC(0.400800,0.101600,183.690466,356.309534,0.036000) translate<94.234000,0.000000,28.854600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<93.434000,0.000000,26.278800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<93.434000,0.000000,28.178800>}
box{<0,0,-0.050800><1.900000,0.036000,0.050800> rotate<0,90.000000,0> translate<93.434000,0.000000,28.178800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<95.034000,0.000000,28.178800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<95.034000,0.000000,26.278800>}
box{<0,0,-0.050800><1.900000,0.036000,0.050800> rotate<0,-90.000000,0> translate<95.034000,0.000000,26.278800> }
difference{
cylinder{<93.684000,0,28.653800><93.684000,0.036000,28.653800>0.150800 translate<0,0.000000,0>}
cylinder{<93.684000,-0.1,28.653800><93.684000,0.135000,28.653800>0.049200 translate<0,0.000000,0>}}
box{<-0.250000,0,-0.062500><0.250000,0.036000,0.062500> rotate<0,-0.000000,0> translate<93.634000,0.000000,28.816300>}
box{<-0.112500,0,-0.162500><0.112500,0.036000,0.162500> rotate<0,-0.000000,0> translate<93.496500,0.000000,28.616300>}
box{<-0.062500,0,-0.112500><0.062500,0.036000,0.112500> rotate<0,-0.000000,0> translate<93.846500,0.000000,28.566300>}
box{<-0.212500,0,-0.062500><0.212500,0.036000,0.062500> rotate<0,-0.000000,0> translate<93.796500,0.000000,28.516300>}
box{<-0.250000,0,-0.175000><0.250000,0.036000,0.175000> rotate<0,-0.000000,0> translate<94.834000,0.000000,28.703800>}
box{<-0.300000,0,-0.062500><0.300000,0.036000,0.062500> rotate<0,-0.000000,0> translate<94.784000,0.000000,28.516300>}
box{<-0.850000,0,-0.150000><0.850000,0.036000,0.150000> rotate<0,-0.000000,0> translate<94.234000,0.000000,28.328800>}
box{<-0.850000,0,-0.350000><0.850000,0.036000,0.350000> rotate<0,-0.000000,0> translate<94.234000,0.000000,25.928800>}
box{<-0.162500,0,-0.212500><0.162500,0.036000,0.212500> rotate<0,-0.000000,0> translate<93.546500,0.000000,27.791300>}
box{<-0.162500,0,-0.212500><0.162500,0.036000,0.212500> rotate<0,-0.000000,0> translate<94.921500,0.000000,27.791300>}
box{<-0.175000,0,-0.175000><0.175000,0.036000,0.175000> rotate<0,-0.000000,0> translate<94.234000,0.000000,27.403800>}
//LED3 silk screen
object{ARC(0.400800,0.101600,3.690466,176.309534,0.036000) translate<90.297000,0.000000,25.603000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<91.097000,0.000000,28.178800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<91.097000,0.000000,26.278800>}
box{<0,0,-0.050800><1.900000,0.036000,0.050800> rotate<0,-90.000000,0> translate<91.097000,0.000000,26.278800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.497000,0.000000,26.278800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.497000,0.000000,28.178800>}
box{<0,0,-0.050800><1.900000,0.036000,0.050800> rotate<0,90.000000,0> translate<89.497000,0.000000,28.178800> }
difference{
cylinder{<90.847000,0,25.803800><90.847000,0.036000,25.803800>0.150800 translate<0,0.000000,0>}
cylinder{<90.847000,-0.1,25.803800><90.847000,0.135000,25.803800>0.049200 translate<0,0.000000,0>}}
box{<-0.250000,0,-0.062500><0.250000,0.036000,0.062500> rotate<0,-180.000000,0> translate<90.897000,0.000000,25.641300>}
box{<-0.112500,0,-0.162500><0.112500,0.036000,0.162500> rotate<0,-180.000000,0> translate<91.034500,0.000000,25.841300>}
box{<-0.062500,0,-0.112500><0.062500,0.036000,0.112500> rotate<0,-180.000000,0> translate<90.684500,0.000000,25.891300>}
box{<-0.212500,0,-0.062500><0.212500,0.036000,0.062500> rotate<0,-180.000000,0> translate<90.734500,0.000000,25.941300>}
box{<-0.250000,0,-0.175000><0.250000,0.036000,0.175000> rotate<0,-180.000000,0> translate<89.697000,0.000000,25.753800>}
box{<-0.300000,0,-0.062500><0.300000,0.036000,0.062500> rotate<0,-180.000000,0> translate<89.747000,0.000000,25.941300>}
box{<-0.850000,0,-0.150000><0.850000,0.036000,0.150000> rotate<0,-180.000000,0> translate<90.297000,0.000000,26.128800>}
box{<-0.850000,0,-0.350000><0.850000,0.036000,0.350000> rotate<0,-180.000000,0> translate<90.297000,0.000000,28.528800>}
box{<-0.162500,0,-0.212500><0.162500,0.036000,0.212500> rotate<0,-180.000000,0> translate<90.984500,0.000000,26.666300>}
box{<-0.162500,0,-0.212500><0.162500,0.036000,0.212500> rotate<0,-180.000000,0> translate<89.609500,0.000000,26.666300>}
box{<-0.175000,0,-0.175000><0.175000,0.036000,0.175000> rotate<0,-180.000000,0> translate<90.297000,0.000000,27.053800>}
//LED4 silk screen
object{ARC(0.400800,0.101600,3.690466,176.309534,0.036000) translate<94.234000,0.000000,48.463000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<95.034000,0.000000,51.038800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<95.034000,0.000000,49.138800>}
box{<0,0,-0.050800><1.900000,0.036000,0.050800> rotate<0,-90.000000,0> translate<95.034000,0.000000,49.138800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<93.434000,0.000000,49.138800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<93.434000,0.000000,51.038800>}
box{<0,0,-0.050800><1.900000,0.036000,0.050800> rotate<0,90.000000,0> translate<93.434000,0.000000,51.038800> }
difference{
cylinder{<94.784000,0,48.663800><94.784000,0.036000,48.663800>0.150800 translate<0,0.000000,0>}
cylinder{<94.784000,-0.1,48.663800><94.784000,0.135000,48.663800>0.049200 translate<0,0.000000,0>}}
box{<-0.250000,0,-0.062500><0.250000,0.036000,0.062500> rotate<0,-180.000000,0> translate<94.834000,0.000000,48.501300>}
box{<-0.112500,0,-0.162500><0.112500,0.036000,0.162500> rotate<0,-180.000000,0> translate<94.971500,0.000000,48.701300>}
box{<-0.062500,0,-0.112500><0.062500,0.036000,0.112500> rotate<0,-180.000000,0> translate<94.621500,0.000000,48.751300>}
box{<-0.212500,0,-0.062500><0.212500,0.036000,0.062500> rotate<0,-180.000000,0> translate<94.671500,0.000000,48.801300>}
box{<-0.250000,0,-0.175000><0.250000,0.036000,0.175000> rotate<0,-180.000000,0> translate<93.634000,0.000000,48.613800>}
box{<-0.300000,0,-0.062500><0.300000,0.036000,0.062500> rotate<0,-180.000000,0> translate<93.684000,0.000000,48.801300>}
box{<-0.850000,0,-0.150000><0.850000,0.036000,0.150000> rotate<0,-180.000000,0> translate<94.234000,0.000000,48.988800>}
box{<-0.850000,0,-0.350000><0.850000,0.036000,0.350000> rotate<0,-180.000000,0> translate<94.234000,0.000000,51.388800>}
box{<-0.162500,0,-0.212500><0.162500,0.036000,0.212500> rotate<0,-180.000000,0> translate<94.921500,0.000000,49.526300>}
box{<-0.162500,0,-0.212500><0.162500,0.036000,0.212500> rotate<0,-180.000000,0> translate<93.546500,0.000000,49.526300>}
box{<-0.175000,0,-0.175000><0.175000,0.036000,0.175000> rotate<0,-180.000000,0> translate<94.234000,0.000000,49.913800>}
//LED5 silk screen
object{ARC(0.400800,0.101600,183.690466,356.309534,0.036000) translate<90.297000,0.000000,51.714600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.497000,0.000000,49.138800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.497000,0.000000,51.038800>}
box{<0,0,-0.050800><1.900000,0.036000,0.050800> rotate<0,90.000000,0> translate<89.497000,0.000000,51.038800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<91.097000,0.000000,51.038800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<91.097000,0.000000,49.138800>}
box{<0,0,-0.050800><1.900000,0.036000,0.050800> rotate<0,-90.000000,0> translate<91.097000,0.000000,49.138800> }
difference{
cylinder{<89.747000,0,51.513800><89.747000,0.036000,51.513800>0.150800 translate<0,0.000000,0>}
cylinder{<89.747000,-0.1,51.513800><89.747000,0.135000,51.513800>0.049200 translate<0,0.000000,0>}}
box{<-0.250000,0,-0.062500><0.250000,0.036000,0.062500> rotate<0,-0.000000,0> translate<89.697000,0.000000,51.676300>}
box{<-0.112500,0,-0.162500><0.112500,0.036000,0.162500> rotate<0,-0.000000,0> translate<89.559500,0.000000,51.476300>}
box{<-0.062500,0,-0.112500><0.062500,0.036000,0.112500> rotate<0,-0.000000,0> translate<89.909500,0.000000,51.426300>}
box{<-0.212500,0,-0.062500><0.212500,0.036000,0.062500> rotate<0,-0.000000,0> translate<89.859500,0.000000,51.376300>}
box{<-0.250000,0,-0.175000><0.250000,0.036000,0.175000> rotate<0,-0.000000,0> translate<90.897000,0.000000,51.563800>}
box{<-0.300000,0,-0.062500><0.300000,0.036000,0.062500> rotate<0,-0.000000,0> translate<90.847000,0.000000,51.376300>}
box{<-0.850000,0,-0.150000><0.850000,0.036000,0.150000> rotate<0,-0.000000,0> translate<90.297000,0.000000,51.188800>}
box{<-0.850000,0,-0.350000><0.850000,0.036000,0.350000> rotate<0,-0.000000,0> translate<90.297000,0.000000,48.788800>}
box{<-0.162500,0,-0.212500><0.162500,0.036000,0.212500> rotate<0,-0.000000,0> translate<89.609500,0.000000,50.651300>}
box{<-0.162500,0,-0.212500><0.162500,0.036000,0.212500> rotate<0,-0.000000,0> translate<90.984500,0.000000,50.651300>}
box{<-0.175000,0,-0.175000><0.175000,0.036000,0.175000> rotate<0,-0.000000,0> translate<90.297000,0.000000,50.263800>}
//POWER silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<78.683800,0.000000,56.091800>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.783800,0.000000,56.091800>}
box{<0,0,-0.101600><22.900000,0.036000,0.101600> rotate<0,0.000000,0> translate<55.783800,0.000000,56.091800> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.783800,0.000000,56.091800>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.783800,0.000000,62.151800>}
box{<0,0,-0.101600><6.060000,0.036000,0.101600> rotate<0,90.000000,0> translate<55.783800,0.000000,62.151800> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.783800,0.000000,62.151800>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<57.783800,0.000000,64.151800>}
box{<0,0,-0.101600><2.828427,0.036000,0.101600> rotate<0,-44.997030,0> translate<55.783800,0.000000,62.151800> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<57.783800,0.000000,64.151800>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<76.683800,0.000000,64.151800>}
box{<0,0,-0.101600><18.900000,0.036000,0.101600> rotate<0,0.000000,0> translate<57.783800,0.000000,64.151800> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<76.683800,0.000000,64.151800>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<78.683800,0.000000,62.151800>}
box{<0,0,-0.101600><2.828427,0.036000,0.101600> rotate<0,44.997030,0> translate<76.683800,0.000000,64.151800> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<78.683800,0.000000,62.151800>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<78.683800,0.000000,56.091800>}
box{<0,0,-0.101600><6.060000,0.036000,0.101600> rotate<0,-90.000000,0> translate<78.683800,0.000000,56.091800> }
//R1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.315000,0.000000,16.241000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.665000,0.000000,16.241000>}
box{<0,0,-0.076200><6.350000,0.036000,0.076200> rotate<0,0.000000,0> translate<77.315000,0.000000,16.241000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.665000,0.000000,23.099000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.030000,0.000000,23.099000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,0.000000,0> translate<83.030000,0.000000,23.099000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.315000,0.000000,16.241000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.061000,0.000000,16.495000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<77.061000,0.000000,16.495000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.315000,0.000000,23.099000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.061000,0.000000,22.845000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<77.061000,0.000000,22.845000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.061000,0.000000,22.845000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.061000,0.000000,21.194000>}
box{<0,0,-0.076200><1.651000,0.036000,0.076200> rotate<0,-90.000000,0> translate<77.061000,0.000000,21.194000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.061000,0.000000,21.194000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.061000,0.000000,19.924000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<77.061000,0.000000,19.924000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.061000,0.000000,19.924000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.061000,0.000000,16.495000>}
box{<0,0,-0.076200><3.429000,0.036000,0.076200> rotate<0,-90.000000,0> translate<77.061000,0.000000,16.495000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.665000,0.000000,23.099000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.919000,0.000000,22.845000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<83.665000,0.000000,23.099000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.665000,0.000000,16.241000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.919000,0.000000,16.495000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<83.665000,0.000000,16.241000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.919000,0.000000,16.495000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.919000,0.000000,19.924000>}
box{<0,0,-0.076200><3.429000,0.036000,0.076200> rotate<0,90.000000,0> translate<83.919000,0.000000,19.924000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.919000,0.000000,19.924000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.919000,0.000000,21.194000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<83.919000,0.000000,21.194000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.919000,0.000000,21.194000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.919000,0.000000,22.845000>}
box{<0,0,-0.076200><1.651000,0.036000,0.076200> rotate<0,90.000000,0> translate<83.919000,0.000000,22.845000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<79.728000,0.000000,19.670000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.966000,0.000000,19.670000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<78.966000,0.000000,19.670000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.966000,0.000000,19.670000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.966000,0.000000,18.908000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<78.966000,0.000000,18.908000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.966000,0.000000,18.908000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<79.728000,0.000000,18.908000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<78.966000,0.000000,18.908000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<79.728000,0.000000,18.908000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.109000,0.000000,18.527000>}
box{<0,0,-0.076200><0.538815,0.036000,0.076200> rotate<0,44.997030,0> translate<79.728000,0.000000,18.908000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.109000,0.000000,18.527000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.109000,0.000000,18.146000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<80.109000,0.000000,18.146000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.109000,0.000000,17.384000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.871000,0.000000,17.384000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<80.109000,0.000000,17.384000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.871000,0.000000,17.384000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.871000,0.000000,18.146000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,90.000000,0> translate<80.871000,0.000000,18.146000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.871000,0.000000,18.527000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.252000,0.000000,18.908000>}
box{<0,0,-0.076200><0.538815,0.036000,0.076200> rotate<0,-44.997030,0> translate<80.871000,0.000000,18.527000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.252000,0.000000,18.908000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.014000,0.000000,18.908000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<81.252000,0.000000,18.908000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.014000,0.000000,18.908000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.014000,0.000000,19.670000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,90.000000,0> translate<82.014000,0.000000,19.670000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.014000,0.000000,19.670000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.252000,0.000000,19.670000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<81.252000,0.000000,19.670000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.871000,0.000000,20.051000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.252000,0.000000,19.670000>}
box{<0,0,-0.076200><0.538815,0.036000,0.076200> rotate<0,44.997030,0> translate<80.871000,0.000000,20.051000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.871000,0.000000,20.051000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.871000,0.000000,20.432000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<80.871000,0.000000,20.432000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.871000,0.000000,21.194000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.109000,0.000000,21.194000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<80.109000,0.000000,21.194000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.109000,0.000000,21.194000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.109000,0.000000,20.432000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<80.109000,0.000000,20.432000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.109000,0.000000,20.051000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<79.728000,0.000000,19.670000>}
box{<0,0,-0.076200><0.538815,0.036000,0.076200> rotate<0,-44.997030,0> translate<79.728000,0.000000,19.670000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<82.268000,0.000000,21.067000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<82.522000,0.000000,21.321000>}
box{<0,0,-0.152400><0.359210,0.036000,0.152400> rotate<0,-44.997030,0> translate<82.268000,0.000000,21.067000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<78.712000,0.000000,21.067000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<78.458000,0.000000,21.321000>}
box{<0,0,-0.152400><0.359210,0.036000,0.152400> rotate<0,44.997030,0> translate<78.458000,0.000000,21.321000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<78.102400,0.000000,19.289000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<77.721400,0.000000,19.289000>}
box{<0,0,-0.152400><0.381000,0.036000,0.152400> rotate<0,0.000000,0> translate<77.721400,0.000000,19.289000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<78.712000,0.000000,17.638000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<78.458000,0.000000,17.384000>}
box{<0,0,-0.152400><0.359210,0.036000,0.152400> rotate<0,-44.997030,0> translate<78.458000,0.000000,17.384000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<80.490000,0.000000,16.952200>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<80.490000,0.000000,16.571200>}
box{<0,0,-0.152400><0.381000,0.036000,0.152400> rotate<0,-90.000000,0> translate<80.490000,0.000000,16.571200> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<82.395000,0.000000,17.638000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<82.649000,0.000000,17.384000>}
box{<0,0,-0.152400><0.359210,0.036000,0.152400> rotate<0,44.997030,0> translate<82.395000,0.000000,17.638000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<82.877600,0.000000,19.289000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<83.258600,0.000000,19.289000>}
box{<0,0,-0.152400><0.381000,0.036000,0.152400> rotate<0,0.000000,0> translate<82.877600,0.000000,19.289000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.109000,0.000000,18.146000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.871000,0.000000,18.146000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<80.109000,0.000000,18.146000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.109000,0.000000,18.146000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.109000,0.000000,17.384000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<80.109000,0.000000,17.384000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.871000,0.000000,18.146000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.871000,0.000000,18.527000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<80.871000,0.000000,18.527000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.109000,0.000000,20.432000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.871000,0.000000,20.432000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<80.109000,0.000000,20.432000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.109000,0.000000,20.432000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.109000,0.000000,20.051000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<80.109000,0.000000,20.051000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.871000,0.000000,20.432000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.871000,0.000000,21.194000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,90.000000,0> translate<80.871000,0.000000,21.194000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.030000,0.000000,22.718000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.030000,0.000000,23.099000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<83.030000,0.000000,23.099000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.506000,0.000000,22.718000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<79.474000,0.000000,22.718000>}
box{<0,0,-0.076200><2.032000,0.036000,0.076200> rotate<0,0.000000,0> translate<79.474000,0.000000,22.718000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.950000,0.000000,23.099000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.950000,0.000000,22.718000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<77.950000,0.000000,22.718000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.030000,0.000000,23.099000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.125000,0.000000,23.099000>}
box{<0,0,-0.076200><1.905000,0.036000,0.076200> rotate<0,0.000000,0> translate<81.125000,0.000000,23.099000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.125000,0.000000,23.099000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<79.855000,0.000000,23.099000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<79.855000,0.000000,23.099000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<79.855000,0.000000,23.099000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.950000,0.000000,23.099000>}
box{<0,0,-0.076200><1.905000,0.036000,0.076200> rotate<0,0.000000,0> translate<77.950000,0.000000,23.099000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.950000,0.000000,23.099000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.315000,0.000000,23.099000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,0.000000,0> translate<77.315000,0.000000,23.099000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.030000,0.000000,22.718000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.506000,0.000000,22.718000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<81.506000,0.000000,22.718000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<79.474000,0.000000,22.718000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.950000,0.000000,22.718000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<77.950000,0.000000,22.718000> }
difference{
cylinder{<80.490000,0,19.289000><80.490000,0.036000,19.289000>2.108200 translate<0,0.000000,0>}
cylinder{<80.490000,-0.1,19.289000><80.490000,0.135000,19.289000>1.955800 translate<0,0.000000,0>}}
//R2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.898500,0.000000,50.977800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<74.980800,0.000000,50.977800>}
box{<0,0,-0.076200><1.917700,0.036000,0.076200> rotate<0,0.000000,0> translate<74.980800,0.000000,50.977800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.898500,0.000000,52.603400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<74.980800,0.000000,52.603400>}
box{<0,0,-0.076200><1.917700,0.036000,0.076200> rotate<0,0.000000,0> translate<74.980800,0.000000,52.603400> }
box{<-0.368300,0,-0.876300><0.368300,0.036000,0.876300> rotate<0,-0.000000,0> translate<74.625200,0.000000,51.790600>}
box{<-0.368300,0,-0.876300><0.368300,0.036000,0.876300> rotate<0,-0.000000,0> translate<77.266800,0.000000,51.790600>}
//R3 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.619400,0.000000,28.549800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<75.870400,0.000000,28.549800>}
box{<0,0,-0.076200><4.749000,0.036000,0.076200> rotate<0,0.000000,0> translate<75.870400,0.000000,28.549800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.619400,0.000000,31.495800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<75.870400,0.000000,31.495800>}
box{<0,0,-0.076200><4.749000,0.036000,0.076200> rotate<0,0.000000,0> translate<75.870400,0.000000,31.495800> }
box{<-0.424900,0,-1.550000><0.424900,0.036000,1.550000> rotate<0,-180.000000,0> translate<81.032700,0.000000,30.022200>}
box{<-0.424900,0,-1.550000><0.424900,0.036000,1.550000> rotate<0,-180.000000,0> translate<75.470300,0.000000,30.022200>}
//R5 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<85.390200,0.000000,26.394300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<85.390200,0.000000,28.312000>}
box{<0,0,-0.076200><1.917700,0.036000,0.076200> rotate<0,90.000000,0> translate<85.390200,0.000000,28.312000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.015800,0.000000,26.394300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.015800,0.000000,28.312000>}
box{<0,0,-0.076200><1.917700,0.036000,0.076200> rotate<0,90.000000,0> translate<87.015800,0.000000,28.312000> }
box{<-0.368300,0,-0.876300><0.368300,0.036000,0.876300> rotate<0,-270.000000,0> translate<86.203000,0.000000,28.667600>}
box{<-0.368300,0,-0.876300><0.368300,0.036000,0.876300> rotate<0,-270.000000,0> translate<86.203000,0.000000,26.026000>}
//R6 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.011800,0.000000,29.451300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.011800,0.000000,27.533600>}
box{<0,0,-0.076200><1.917700,0.036000,0.076200> rotate<0,-90.000000,0> translate<69.011800,0.000000,27.533600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.386200,0.000000,29.451300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.386200,0.000000,27.533600>}
box{<0,0,-0.076200><1.917700,0.036000,0.076200> rotate<0,-90.000000,0> translate<67.386200,0.000000,27.533600> }
box{<-0.368300,0,-0.876300><0.368300,0.036000,0.876300> rotate<0,-90.000000,0> translate<68.199000,0.000000,27.178000>}
box{<-0.368300,0,-0.876300><0.368300,0.036000,0.876300> rotate<0,-90.000000,0> translate<68.199000,0.000000,29.819600>}
//R7 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.194200,0.000000,62.852300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.194200,0.000000,60.934600>}
box{<0,0,-0.076200><1.917700,0.036000,0.076200> rotate<0,-90.000000,0> translate<55.194200,0.000000,60.934600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.568600,0.000000,62.852300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.568600,0.000000,60.934600>}
box{<0,0,-0.076200><1.917700,0.036000,0.076200> rotate<0,-90.000000,0> translate<53.568600,0.000000,60.934600> }
box{<-0.368300,0,-0.876300><0.368300,0.036000,0.876300> rotate<0,-90.000000,0> translate<54.381400,0.000000,60.579000>}
box{<-0.368300,0,-0.876300><0.368300,0.036000,0.876300> rotate<0,-90.000000,0> translate<54.381400,0.000000,63.220600>}
//R8 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.036800,0.000000,51.001300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.036800,0.000000,49.083600>}
box{<0,0,-0.076200><1.917700,0.036000,0.076200> rotate<0,-90.000000,0> translate<87.036800,0.000000,49.083600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<85.411200,0.000000,51.001300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<85.411200,0.000000,49.083600>}
box{<0,0,-0.076200><1.917700,0.036000,0.076200> rotate<0,-90.000000,0> translate<85.411200,0.000000,49.083600> }
box{<-0.368300,0,-0.876300><0.368300,0.036000,0.876300> rotate<0,-90.000000,0> translate<86.224000,0.000000,48.728000>}
box{<-0.368300,0,-0.876300><0.368300,0.036000,0.876300> rotate<0,-90.000000,0> translate<86.224000,0.000000,51.369600>}
//R16 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.848000,0.000000,46.863200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.099000,0.000000,46.863200>}
box{<0,0,-0.076200><4.749000,0.036000,0.076200> rotate<0,0.000000,0> translate<76.099000,0.000000,46.863200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.848000,0.000000,49.809200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.099000,0.000000,49.809200>}
box{<0,0,-0.076200><4.749000,0.036000,0.076200> rotate<0,0.000000,0> translate<76.099000,0.000000,49.809200> }
box{<-0.424900,0,-1.550000><0.424900,0.036000,1.550000> rotate<0,-180.000000,0> translate<81.261300,0.000000,48.335600>}
box{<-0.424900,0,-1.550000><0.424900,0.036000,1.550000> rotate<0,-180.000000,0> translate<75.698900,0.000000,48.335600>}
//R17 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.624700,0.000000,23.418800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.707000,0.000000,23.418800>}
box{<0,0,-0.076200><1.917700,0.036000,0.076200> rotate<0,0.000000,0> translate<68.707000,0.000000,23.418800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.624700,0.000000,25.044400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.707000,0.000000,25.044400>}
box{<0,0,-0.076200><1.917700,0.036000,0.076200> rotate<0,0.000000,0> translate<68.707000,0.000000,25.044400> }
box{<-0.368300,0,-0.876300><0.368300,0.036000,0.876300> rotate<0,-0.000000,0> translate<68.351400,0.000000,24.231600>}
box{<-0.368300,0,-0.876300><0.368300,0.036000,0.876300> rotate<0,-0.000000,0> translate<70.993000,0.000000,24.231600>}
//SV1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,18.415000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<75.057000,0.000000,18.415000>}
box{<0,0,-0.076200><17.780000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.277000,0.000000,18.415000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<75.057000,0.000000,12.065000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<75.057000,0.000000,18.415000>}
box{<0,0,-0.076200><6.350000,0.036000,0.076200> rotate<0,90.000000,0> translate<75.057000,0.000000,18.415000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,18.415000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,12.065000>}
box{<0,0,-0.076200><6.350000,0.036000,0.076200> rotate<0,-90.000000,0> translate<57.277000,0.000000,12.065000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.007000,0.000000,19.685000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,19.685000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<56.007000,0.000000,19.685000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.327000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.628000,0.000000,10.795000>}
box{<0,0,-0.076200><4.699000,0.036000,0.076200> rotate<0,0.000000,0> translate<71.628000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.327000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.327000,0.000000,19.685000>}
box{<0,0,-0.076200><8.890000,0.036000,0.076200> rotate<0,90.000000,0> translate<76.327000,0.000000,19.685000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.007000,0.000000,19.685000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.007000,0.000000,10.795000>}
box{<0,0,-0.076200><8.890000,0.036000,0.076200> rotate<0,-90.000000,0> translate<56.007000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<75.057000,0.000000,12.065000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.739000,0.000000,12.065000>}
box{<0,0,-0.076200><4.318000,0.036000,0.076200> rotate<0,0.000000,0> translate<70.739000,0.000000,12.065000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.199000,0.000000,12.827000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.135000,0.000000,12.827000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<64.135000,0.000000,12.827000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.135000,0.000000,12.065000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.135000,0.000000,12.827000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,90.000000,0> translate<64.135000,0.000000,12.827000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.135000,0.000000,12.065000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,12.065000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.277000,0.000000,12.065000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.135000,0.000000,12.065000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.135000,0.000000,11.811000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<64.135000,0.000000,11.811000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.199000,0.000000,12.827000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.199000,0.000000,12.065000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<68.199000,0.000000,12.065000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.199000,0.000000,12.065000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.199000,0.000000,11.811000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<68.199000,0.000000,11.811000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<75.057000,0.000000,19.685000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<75.057000,0.000000,19.939000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<75.057000,0.000000,19.939000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<75.057000,0.000000,19.939000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.787000,0.000000,19.939000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<73.787000,0.000000,19.939000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.787000,0.000000,19.685000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.787000,0.000000,19.939000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<73.787000,0.000000,19.939000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<75.057000,0.000000,19.685000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.327000,0.000000,19.685000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<75.057000,0.000000,19.685000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.802000,0.000000,19.939000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.532000,0.000000,19.939000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<65.532000,0.000000,19.939000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.802000,0.000000,19.939000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.802000,0.000000,19.685000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<66.802000,0.000000,19.685000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.802000,0.000000,19.685000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.787000,0.000000,19.685000>}
box{<0,0,-0.076200><6.985000,0.036000,0.076200> rotate<0,0.000000,0> translate<66.802000,0.000000,19.685000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.532000,0.000000,19.939000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.532000,0.000000,19.685000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<65.532000,0.000000,19.685000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.547000,0.000000,19.939000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,19.939000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.277000,0.000000,19.939000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,19.939000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,19.685000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<57.277000,0.000000,19.685000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.547000,0.000000,19.939000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.547000,0.000000,19.685000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<58.547000,0.000000,19.685000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.547000,0.000000,19.685000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.532000,0.000000,19.685000>}
box{<0,0,-0.076200><6.985000,0.036000,0.076200> rotate<0,0.000000,0> translate<58.547000,0.000000,19.685000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.326000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.199000,0.000000,10.795000>}
box{<0,0,-0.076200><0.127000,0.036000,0.076200> rotate<0,0.000000,0> translate<68.199000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.199000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.135000,0.000000,10.795000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<64.135000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.215000,0.000000,12.065000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.215000,0.000000,11.811000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<69.215000,0.000000,11.811000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.215000,0.000000,12.065000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.199000,0.000000,12.065000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<68.199000,0.000000,12.065000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.739000,0.000000,12.065000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.739000,0.000000,11.811000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<70.739000,0.000000,11.811000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.739000,0.000000,12.065000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.215000,0.000000,12.065000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<69.215000,0.000000,12.065000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.326000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.707000,0.000000,11.303000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,-53.126596,0> translate<68.326000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.247000,0.000000,11.303000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.628000,0.000000,10.795000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,53.126596,0> translate<71.247000,0.000000,11.303000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.247000,0.000000,11.303000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.739000,0.000000,11.303000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,0.000000,0> translate<70.739000,0.000000,11.303000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<69.215000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<68.199000,0.000000,11.811000>}
box{<0,0,-0.025400><1.016000,0.036000,0.025400> rotate<0,0.000000,0> translate<68.199000,0.000000,11.811000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.199000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.199000,0.000000,10.795000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<68.199000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<70.739000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<75.311000,0.000000,11.811000>}
box{<0,0,-0.025400><4.572000,0.036000,0.025400> rotate<0,0.000000,0> translate<70.739000,0.000000,11.811000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<75.311000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<75.311000,0.000000,18.669000>}
box{<0,0,-0.025400><6.858000,0.036000,0.025400> rotate<0,90.000000,0> translate<75.311000,0.000000,18.669000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<75.311000,0.000000,18.669000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<57.023000,0.000000,18.669000>}
box{<0,0,-0.025400><18.288000,0.036000,0.025400> rotate<0,0.000000,0> translate<57.023000,0.000000,18.669000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<57.023000,0.000000,18.669000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<57.023000,0.000000,11.811000>}
box{<0,0,-0.025400><6.858000,0.036000,0.025400> rotate<0,-90.000000,0> translate<57.023000,0.000000,11.811000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<57.023000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<64.135000,0.000000,11.811000>}
box{<0,0,-0.025400><7.112000,0.036000,0.025400> rotate<0,0.000000,0> translate<57.023000,0.000000,11.811000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.135000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.135000,0.000000,10.795000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<64.135000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.215000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.215000,0.000000,11.303000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,-90.000000,0> translate<69.215000,0.000000,11.303000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.215000,0.000000,11.303000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.707000,0.000000,11.303000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,0.000000,0> translate<68.707000,0.000000,11.303000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.739000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.739000,0.000000,11.303000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,-90.000000,0> translate<70.739000,0.000000,11.303000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.739000,0.000000,11.303000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.215000,0.000000,11.303000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<69.215000,0.000000,11.303000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.135000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.722000,0.000000,10.795000>}
box{<0,0,-0.076200><2.413000,0.036000,0.076200> rotate<0,0.000000,0> translate<61.722000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.722000,0.000000,10.922000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.722000,0.000000,10.795000>}
box{<0,0,-0.076200><0.127000,0.036000,0.076200> rotate<0,-90.000000,0> translate<61.722000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.722000,0.000000,10.922000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.452000,0.000000,10.922000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<60.452000,0.000000,10.922000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.452000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.452000,0.000000,10.922000>}
box{<0,0,-0.076200><0.127000,0.036000,0.076200> rotate<0,90.000000,0> translate<60.452000,0.000000,10.922000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.452000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.007000,0.000000,10.795000>}
box{<0,0,-0.076200><4.445000,0.036000,0.076200> rotate<0,0.000000,0> translate<56.007000,0.000000,10.795000> }
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<63.627000,0.000000,16.510000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<61.087000,0.000000,16.510000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<66.167000,0.000000,16.510000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<71.247000,0.000000,16.510000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<68.707000,0.000000,16.510000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<63.627000,0.000000,13.970000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<61.087000,0.000000,13.970000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<66.167000,0.000000,13.970000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<71.247000,0.000000,13.970000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<68.707000,0.000000,13.970000>}
//TP1 silk screen
difference{
cylinder{<80.519800,0,13.962400><80.519800,0.036000,13.962400>0.838200 translate<0,0.000000,0>}
cylinder{<80.519800,-0.1,13.962400><80.519800,0.135000,13.962400>0.685800 translate<0,0.000000,0>}}
box{<-0.330200,0,-0.330200><0.330200,0.036000,0.330200> rotate<0,-0.000000,0> translate<80.519800,0.000000,13.962400>}
//U$1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<50.845000,0.000000,62.400000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<48.559000,0.000000,62.400000>}
box{<0,0,-0.025400><2.286000,0.036000,0.025400> rotate<0,0.000000,0> translate<48.559000,0.000000,62.400000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<46.400000,0.000000,66.845000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<46.400000,0.000000,64.559000>}
box{<0,0,-0.025400><2.286000,0.036000,0.025400> rotate<0,-90.000000,0> translate<46.400000,0.000000,64.559000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<44.241000,0.000000,62.400000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<41.955000,0.000000,62.400000>}
box{<0,0,-0.025400><2.286000,0.036000,0.025400> rotate<0,0.000000,0> translate<41.955000,0.000000,62.400000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<46.400000,0.000000,60.241000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<46.400000,0.000000,57.955000>}
box{<0,0,-0.025400><2.286000,0.036000,0.025400> rotate<0,-90.000000,0> translate<46.400000,0.000000,57.955000> }
object{ARC(2.540000,3.911600,180.000000,270.000000,0.036000) translate<46.400000,0.000000,62.400000>}
object{ARC(2.540000,3.911600,0.000000,90.000000,0.036000) translate<46.400000,0.000000,62.400000>}
difference{
cylinder{<46.400000,0,62.400000><46.400000,0.036000,62.400000>4.572000 translate<0,0.000000,0>}
cylinder{<46.400000,-0.1,62.400000><46.400000,0.135000,62.400000>4.419600 translate<0,0.000000,0>}}
difference{
cylinder{<46.400000,0,62.400000><46.400000,0.036000,62.400000>0.990600 translate<0,0.000000,0>}
cylinder{<46.400000,-0.1,62.400000><46.400000,0.135000,62.400000>0.533400 translate<0,0.000000,0>}}
difference{
cylinder{<46.400000,0,62.400000><46.400000,0.036000,62.400000>2.676200 translate<0,0.000000,0>}
cylinder{<46.400000,-0.1,62.400000><46.400000,0.135000,62.400000>2.523800 translate<0,0.000000,0>}}
//U$2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<98.045000,0.000000,62.400000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<95.759000,0.000000,62.400000>}
box{<0,0,-0.025400><2.286000,0.036000,0.025400> rotate<0,0.000000,0> translate<95.759000,0.000000,62.400000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<93.600000,0.000000,66.845000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<93.600000,0.000000,64.559000>}
box{<0,0,-0.025400><2.286000,0.036000,0.025400> rotate<0,-90.000000,0> translate<93.600000,0.000000,64.559000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<91.441000,0.000000,62.400000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<89.155000,0.000000,62.400000>}
box{<0,0,-0.025400><2.286000,0.036000,0.025400> rotate<0,0.000000,0> translate<89.155000,0.000000,62.400000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<93.600000,0.000000,60.241000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<93.600000,0.000000,57.955000>}
box{<0,0,-0.025400><2.286000,0.036000,0.025400> rotate<0,-90.000000,0> translate<93.600000,0.000000,57.955000> }
object{ARC(2.540000,3.911600,180.000000,270.000000,0.036000) translate<93.600000,0.000000,62.400000>}
object{ARC(2.540000,3.911600,0.000000,90.000000,0.036000) translate<93.600000,0.000000,62.400000>}
difference{
cylinder{<93.600000,0,62.400000><93.600000,0.036000,62.400000>4.572000 translate<0,0.000000,0>}
cylinder{<93.600000,-0.1,62.400000><93.600000,0.135000,62.400000>4.419600 translate<0,0.000000,0>}}
difference{
cylinder{<93.600000,0,62.400000><93.600000,0.036000,62.400000>0.990600 translate<0,0.000000,0>}
cylinder{<93.600000,-0.1,62.400000><93.600000,0.135000,62.400000>0.533400 translate<0,0.000000,0>}}
difference{
cylinder{<93.600000,0,62.400000><93.600000,0.036000,62.400000>2.676200 translate<0,0.000000,0>}
cylinder{<93.600000,-0.1,62.400000><93.600000,0.135000,62.400000>2.523800 translate<0,0.000000,0>}}
//U$3 silk screen
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<50.945000,0.000000,15.300000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<48.659000,0.000000,15.300000>}
box{<0,0,-0.025400><2.286000,0.036000,0.025400> rotate<0,0.000000,0> translate<48.659000,0.000000,15.300000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<46.500000,0.000000,19.745000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<46.500000,0.000000,17.459000>}
box{<0,0,-0.025400><2.286000,0.036000,0.025400> rotate<0,-90.000000,0> translate<46.500000,0.000000,17.459000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<44.341000,0.000000,15.300000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<42.055000,0.000000,15.300000>}
box{<0,0,-0.025400><2.286000,0.036000,0.025400> rotate<0,0.000000,0> translate<42.055000,0.000000,15.300000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<46.500000,0.000000,13.141000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<46.500000,0.000000,10.855000>}
box{<0,0,-0.025400><2.286000,0.036000,0.025400> rotate<0,-90.000000,0> translate<46.500000,0.000000,10.855000> }
object{ARC(2.540000,3.911600,180.000000,270.000000,0.036000) translate<46.500000,0.000000,15.300000>}
object{ARC(2.540000,3.911600,0.000000,90.000000,0.036000) translate<46.500000,0.000000,15.300000>}
difference{
cylinder{<46.500000,0,15.300000><46.500000,0.036000,15.300000>4.572000 translate<0,0.000000,0>}
cylinder{<46.500000,-0.1,15.300000><46.500000,0.135000,15.300000>4.419600 translate<0,0.000000,0>}}
difference{
cylinder{<46.500000,0,15.300000><46.500000,0.036000,15.300000>0.990600 translate<0,0.000000,0>}
cylinder{<46.500000,-0.1,15.300000><46.500000,0.135000,15.300000>0.533400 translate<0,0.000000,0>}}
difference{
cylinder{<46.500000,0,15.300000><46.500000,0.036000,15.300000>2.676200 translate<0,0.000000,0>}
cylinder{<46.500000,-0.1,15.300000><46.500000,0.135000,15.300000>2.523800 translate<0,0.000000,0>}}
//U$4 silk screen
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<98.045000,0.000000,15.300000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<95.759000,0.000000,15.300000>}
box{<0,0,-0.025400><2.286000,0.036000,0.025400> rotate<0,0.000000,0> translate<95.759000,0.000000,15.300000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<93.600000,0.000000,19.745000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<93.600000,0.000000,17.459000>}
box{<0,0,-0.025400><2.286000,0.036000,0.025400> rotate<0,-90.000000,0> translate<93.600000,0.000000,17.459000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<91.441000,0.000000,15.300000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<89.155000,0.000000,15.300000>}
box{<0,0,-0.025400><2.286000,0.036000,0.025400> rotate<0,0.000000,0> translate<89.155000,0.000000,15.300000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<93.600000,0.000000,13.141000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<93.600000,0.000000,10.855000>}
box{<0,0,-0.025400><2.286000,0.036000,0.025400> rotate<0,-90.000000,0> translate<93.600000,0.000000,10.855000> }
object{ARC(2.540000,3.911600,180.000000,270.000000,0.036000) translate<93.600000,0.000000,15.300000>}
object{ARC(2.540000,3.911600,0.000000,90.000000,0.036000) translate<93.600000,0.000000,15.300000>}
difference{
cylinder{<93.600000,0,15.300000><93.600000,0.036000,15.300000>4.572000 translate<0,0.000000,0>}
cylinder{<93.600000,-0.1,15.300000><93.600000,0.135000,15.300000>4.419600 translate<0,0.000000,0>}}
difference{
cylinder{<93.600000,0,15.300000><93.600000,0.036000,15.300000>0.990600 translate<0,0.000000,0>}
cylinder{<93.600000,-0.1,15.300000><93.600000,0.135000,15.300000>0.533400 translate<0,0.000000,0>}}
difference{
cylinder{<93.600000,0,15.300000><93.600000,0.036000,15.300000>2.676200 translate<0,0.000000,0>}
cylinder{<93.600000,-0.1,15.300000><93.600000,0.135000,15.300000>2.523800 translate<0,0.000000,0>}}
//X1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.220000,0.000000,46.428800>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.220000,0.000000,44.628800>}
box{<0,0,-0.101600><1.800000,0.036000,0.101600> rotate<0,-90.000000,0> translate<85.220000,0.000000,44.628800> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.220000,0.000000,44.628800>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.220000,0.000000,32.713800>}
box{<0,0,-0.101600><11.915000,0.036000,0.101600> rotate<0,-90.000000,0> translate<85.220000,0.000000,32.713800> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.220000,0.000000,32.713800>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.220000,0.000000,30.913800>}
box{<0,0,-0.101600><1.800000,0.036000,0.101600> rotate<0,-90.000000,0> translate<85.220000,0.000000,30.913800> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.220000,0.000000,30.913800>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<94.995000,0.000000,30.913800>}
box{<0,0,-0.101600><9.775000,0.036000,0.101600> rotate<0,0.000000,0> translate<85.220000,0.000000,30.913800> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<94.995000,0.000000,30.913800>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<94.995000,0.000000,46.428800>}
box{<0,0,-0.101600><15.515000,0.036000,0.101600> rotate<0,90.000000,0> translate<94.995000,0.000000,46.428800> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<94.995000,0.000000,46.428800>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.220000,0.000000,46.428800>}
box{<0,0,-0.101600><9.775000,0.036000,0.101600> rotate<0,0.000000,0> translate<85.220000,0.000000,46.428800> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<87.645000,0.000000,32.713800>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<87.645000,0.000000,44.628800>}
box{<0,0,-0.101600><11.915000,0.036000,0.101600> rotate<0,90.000000,0> translate<87.645000,0.000000,44.628800> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<87.645000,0.000000,44.628800>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.220000,0.000000,44.628800>}
box{<0,0,-0.101600><2.425000,0.036000,0.101600> rotate<0,0.000000,0> translate<85.220000,0.000000,44.628800> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<87.645000,0.000000,32.713800>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.220000,0.000000,32.713800>}
box{<0,0,-0.101600><2.425000,0.036000,0.101600> rotate<0,0.000000,0> translate<85.220000,0.000000,32.713800> }
//X2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<49.149000,0.000000,50.419000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<49.149000,0.000000,42.799000>}
box{<0,0,-0.127000><7.620000,0.036000,0.127000> rotate<0,-90.000000,0> translate<49.149000,0.000000,42.799000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<49.149000,0.000000,42.799000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<47.244000,0.000000,42.799000>}
box{<0,0,-0.127000><1.905000,0.036000,0.127000> rotate<0,0.000000,0> translate<47.244000,0.000000,42.799000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<47.244000,0.000000,42.799000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<42.799000,0.000000,42.799000>}
box{<0,0,-0.127000><4.445000,0.036000,0.127000> rotate<0,0.000000,0> translate<42.799000,0.000000,42.799000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<42.799000,0.000000,42.799000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<42.799000,0.000000,50.419000>}
box{<0,0,-0.127000><7.620000,0.036000,0.127000> rotate<0,90.000000,0> translate<42.799000,0.000000,50.419000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<42.799000,0.000000,50.419000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<47.244000,0.000000,50.419000>}
box{<0,0,-0.127000><4.445000,0.036000,0.127000> rotate<0,0.000000,0> translate<42.799000,0.000000,50.419000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<47.244000,0.000000,50.419000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<49.149000,0.000000,50.419000>}
box{<0,0,-0.127000><1.905000,0.036000,0.127000> rotate<0,0.000000,0> translate<47.244000,0.000000,50.419000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<47.244000,0.000000,50.419000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<47.244000,0.000000,42.799000>}
box{<0,0,-0.127000><7.620000,0.036000,0.127000> rotate<0,-90.000000,0> translate<47.244000,0.000000,42.799000> }
//X3 silk screen
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<49.149000,0.000000,34.798000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<49.149000,0.000000,27.178000>}
box{<0,0,-0.127000><7.620000,0.036000,0.127000> rotate<0,-90.000000,0> translate<49.149000,0.000000,27.178000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<49.149000,0.000000,27.178000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<47.244000,0.000000,27.178000>}
box{<0,0,-0.127000><1.905000,0.036000,0.127000> rotate<0,0.000000,0> translate<47.244000,0.000000,27.178000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<47.244000,0.000000,27.178000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<42.799000,0.000000,27.178000>}
box{<0,0,-0.127000><4.445000,0.036000,0.127000> rotate<0,0.000000,0> translate<42.799000,0.000000,27.178000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<42.799000,0.000000,27.178000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<42.799000,0.000000,34.798000>}
box{<0,0,-0.127000><7.620000,0.036000,0.127000> rotate<0,90.000000,0> translate<42.799000,0.000000,34.798000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<42.799000,0.000000,34.798000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<47.244000,0.000000,34.798000>}
box{<0,0,-0.127000><4.445000,0.036000,0.127000> rotate<0,0.000000,0> translate<42.799000,0.000000,34.798000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<47.244000,0.000000,34.798000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<49.149000,0.000000,34.798000>}
box{<0,0,-0.127000><1.905000,0.036000,0.127000> rotate<0,0.000000,0> translate<47.244000,0.000000,34.798000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<47.244000,0.000000,34.798000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<47.244000,0.000000,27.178000>}
box{<0,0,-0.127000><7.620000,0.036000,0.127000> rotate<0,-90.000000,0> translate<47.244000,0.000000,27.178000> }
texture{col_slk}
}
#end
translate<mac_x_ver,mac_y_ver,mac_z_ver>
rotate<mac_x_rot,mac_y_rot,mac_z_rot>
}//End union
#end

#if(use_file_as_inc=off)
object{  STEPPER_MOTOR_DRIVER(-70.071500,0,-38.902000,pcb_rotate_x,pcb_rotate_y,pcb_rotate_z)
#if(pcb_upsidedown=on)
rotate pcb_rotdir*180
#end
}
#end


//Parts not found in 3dpack.dat or 3dusrpac.dat are:
//C10	100uF	UD-10X10_NICHICON
//C11	100uF	UD-10X10_NICHICON
//J1		520426-4
//J2		520426-4
//LED1		CHIPLED_1206
//LED2	A	CHIPLED_1206
//LED3	B	CHIPLED_1206
//LED4	C	CHIPLED_1206
//LED5	D	CHIPLED_1206
//POWER	9090-4V	9090-4V
//R1	10K	B25P
//R3	0.25	R2512
//R16	0.25	R2512
//TP1	TPPAD1-13	P1-13
//U$1		5,0
//U$2		5,0
//U$3		5,0
//U$4		5,0
//X1		KK-156-4
//X2	22-23-2031	22-23-2031
//X3	22-23-2031	22-23-2031
