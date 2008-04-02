//POVRay-File created by 3d41.ulp v1.05
///home/hoeken/Desktop/reprap/trunk/users/hoeken/arduino/electronics/arduino-breakout/arduino-breakout.brd
// 2/22/2008 15:31:05 

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
#local cam_y = 313;
#local cam_z = -167;
#local cam_a = 20;
#local cam_look_x = 0;
#local cam_look_y = -7;
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

#local lgt1_pos_x = 28;
#local lgt1_pos_y = 43;
#local lgt1_pos_z = 38;
#local lgt1_intense = 0.778634;
#local lgt2_pos_x = -28;
#local lgt2_pos_y = 43;
#local lgt2_pos_z = 38;
#local lgt2_intense = 0.778634;
#local lgt3_pos_x = 28;
#local lgt3_pos_y = 43;
#local lgt3_pos_z = -26;
#local lgt3_intense = 0.778634;
#local lgt4_pos_x = -28;
#local lgt4_pos_y = 43;
#local lgt4_pos_z = -26;
#local lgt4_intense = 0.778634;

//Do not change these values
#declare pcb_height = 1.500000;
#declare pcb_cuheight = 0.035000;
#declare pcb_x_size = 75.491800;
#declare pcb_y_size = 72.913400;
#declare pcb_layer1_used = 1;
#declare pcb_layer16_used = 1;
#declare inc_testmode = off;
#declare global_seed=seed(275);
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
	//translate<-37.745900,0,-36.456700>
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


#macro ARDUINO_BREAKOUT(mac_x_ver,mac_y_ver,mac_z_ver,mac_x_rot,mac_y_rot,mac_z_rot)
union{
#if(pcb_board = on)
difference{
union{
//Board
prism{-1.500000,0.000000,8
<28.079600,6.380400><103.346000,6.455000>
<103.346000,6.455000><103.444400,79.244600>
<103.444400,79.244600><27.952600,79.293800>
<27.952600,79.293800><28.079600,6.380400>
texture{col_brd}}
}//End union(Platine)
//Holes(real)/Parts
//Holes(real)/Board
//Holes(real)/Vias
}//End difference(reale Bohrungen/Durchbrüche)
#end
#if(pcb_parts=on)//Parts
union{
#ifndef(pack_S1) #declare global_pack_S1=yes; object {SWITCH_B3F_10XX1()translate<0,0,0> rotate<0,0.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<47.140000,-0.000000,35.480000>}#end		//Tactile Switch-Omron S1  B3F-10XX
#ifndef(pack_X1) #declare global_pack_X1=yes; object {CON_PHOENIX_508_MSTBV_12()translate<0,0,0> rotate<0,0.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<99.570000,-0.000000,42.710000>}#end		//Connector PHOENIX type MSTBV vertical 12 pins X1 MSTBV12 MSTBV12
#ifndef(pack_X2) #declare global_pack_X2=yes; object {CON_PHOENIX_508_MSTBV_12()translate<0,0,0> rotate<0,0.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<59.410600,-0.000000,75.260200>}#end		//Connector PHOENIX type MSTBV vertical 12 pins X2 MSTBV12 MSTBV12
#ifndef(pack_X5) #declare global_pack_X5=yes; object {CON_PHOENIX_508_MSTBV_12()translate<0,0,0> rotate<0,0.000000,0>rotate<0,-0.000000,0> rotate<0,0,0> translate<59.664600,-0.000000,10.134600>}#end		//Connector PHOENIX type MSTBV vertical 12 pins X5 MSTBV12 MSTBV12
}//End union
#end
#if(pcb_pads_smds=on)
//Pads&SMD/Parts
#ifndef(global_pack_S1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<44.879400,0,32.228800> texture{col_thl}}
#ifndef(global_pack_S1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<44.879400,0,38.731200> texture{col_thl}}
#ifndef(global_pack_S1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<49.400600,0,32.228800> texture{col_thl}}
#ifndef(global_pack_S1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<49.400600,0,38.731200> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<58.242200,0,17.678400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<60.782200,0,17.678400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<73.482200,0,17.678400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<76.022200,0,17.678400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<78.562200,0,17.678400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<81.102200,0,17.678400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<83.642200,0,17.678400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<86.182200,0,17.678400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<46.558200,0,65.938400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<81.102200,0,65.938400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<78.562200,0,65.938400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<76.022200,0,65.938400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<73.482200,0,65.938400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<70.942200,0,65.938400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<68.402200,0,65.938400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<64.338200,0,65.938400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<61.798200,0,65.938400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<59.258200,0,65.938400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<56.718200,0,65.938400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<54.178200,0,65.938400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<51.638200,0,65.938400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<49.098200,0,65.938400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<65.862200,0,17.678400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<63.322200,0,17.678400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<55.702200,0,17.678400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<86.182200,0,65.938400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<83.642200,0,65.938400> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<68.402200,0,17.678400> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<99.570000,0,14.770000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<99.570000,0,19.850000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<99.570000,0,24.930000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<99.570000,0,30.010000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<99.570000,0,35.090000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<99.570000,0,40.170000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<99.570000,0,45.250000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<99.570000,0,50.330000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<99.570000,0,55.410000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<99.570000,0,60.490000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<99.570000,0,65.570000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<99.570000,0,70.650000> texture{col_thl}}
#ifndef(global_pack_X2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<87.350600,0,75.260200> texture{col_thl}}
#ifndef(global_pack_X2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<82.270600,0,75.260200> texture{col_thl}}
#ifndef(global_pack_X2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<77.190600,0,75.260200> texture{col_thl}}
#ifndef(global_pack_X2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<72.110600,0,75.260200> texture{col_thl}}
#ifndef(global_pack_X2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<67.030600,0,75.260200> texture{col_thl}}
#ifndef(global_pack_X2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<61.950600,0,75.260200> texture{col_thl}}
#ifndef(global_pack_X2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<56.870600,0,75.260200> texture{col_thl}}
#ifndef(global_pack_X2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<51.790600,0,75.260200> texture{col_thl}}
#ifndef(global_pack_X2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<46.710600,0,75.260200> texture{col_thl}}
#ifndef(global_pack_X2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<41.630600,0,75.260200> texture{col_thl}}
#ifndef(global_pack_X2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<36.550600,0,75.260200> texture{col_thl}}
#ifndef(global_pack_X2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<31.470600,0,75.260200> texture{col_thl}}
#ifndef(global_pack_X5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<31.724600,0,10.134600> texture{col_thl}}
#ifndef(global_pack_X5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<36.804600,0,10.134600> texture{col_thl}}
#ifndef(global_pack_X5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<41.884600,0,10.134600> texture{col_thl}}
#ifndef(global_pack_X5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<46.964600,0,10.134600> texture{col_thl}}
#ifndef(global_pack_X5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<52.044600,0,10.134600> texture{col_thl}}
#ifndef(global_pack_X5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<57.124600,0,10.134600> texture{col_thl}}
#ifndef(global_pack_X5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<62.204600,0,10.134600> texture{col_thl}}
#ifndef(global_pack_X5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<67.284600,0,10.134600> texture{col_thl}}
#ifndef(global_pack_X5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<72.364600,0,10.134600> texture{col_thl}}
#ifndef(global_pack_X5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<77.444600,0,10.134600> texture{col_thl}}
#ifndef(global_pack_X5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<82.524600,0,10.134600> texture{col_thl}}
#ifndef(global_pack_X5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<87.604600,0,10.134600> texture{col_thl}}
//Pads/Vias
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<65.024000,0,14.224000> texture{col_thl}}
#end
#if(pcb_wires=on)
union{
//Signals
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<31.724600,-0.000000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<32.004000,-0.000000,12.192000>}
box{<0,0,-0.254000><2.076285,0.035000,0.254000> rotate<0,-82.260973,0> translate<31.724600,-0.000000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<32.004000,-0.000000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<32.004000,-0.000000,30.480000>}
box{<0,0,-0.254000><18.288000,0.035000,0.254000> rotate<0,90.000000,0> translate<32.004000,-0.000000,30.480000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<31.470600,-0.000000,75.260200>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<32.512000,-0.000000,73.914000>}
box{<0,0,-0.254000><1.701990,0.035000,0.254000> rotate<0,52.271555,0> translate<31.470600,-0.000000,75.260200> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<36.804600,-0.000000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<37.084000,-0.000000,12.192000>}
box{<0,0,-0.254000><2.076285,0.035000,0.254000> rotate<0,-82.260973,0> translate<36.804600,-0.000000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<37.084000,-0.000000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<37.084000,-0.000000,34.036000>}
box{<0,0,-0.254000><21.844000,0.035000,0.254000> rotate<0,90.000000,0> translate<37.084000,-0.000000,34.036000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<36.550600,-0.000000,75.260200>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<37.592000,-0.000000,73.914000>}
box{<0,0,-0.254000><1.701990,0.035000,0.254000> rotate<0,52.271555,0> translate<36.550600,-0.000000,75.260200> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<32.512000,-0.000000,73.914000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<38.100000,-0.000000,68.326000>}
box{<0,0,-0.254000><7.902625,0.035000,0.254000> rotate<0,44.997030,0> translate<32.512000,-0.000000,73.914000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<41.884600,-1.535000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<42.164000,-1.535000,12.192000>}
box{<0,0,-0.254000><2.076285,0.035000,0.254000> rotate<0,-82.260973,0> translate<41.884600,-1.535000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<42.164000,-1.535000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<42.164000,-1.535000,39.116000>}
box{<0,0,-0.254000><26.924000,0.035000,0.254000> rotate<0,90.000000,0> translate<42.164000,-1.535000,39.116000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<37.592000,-0.000000,73.914000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<42.164000,-0.000000,69.342000>}
box{<0,0,-0.254000><6.465784,0.035000,0.254000> rotate<0,44.997030,0> translate<37.592000,-0.000000,73.914000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<41.630600,-0.000000,75.260200>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<42.672000,-0.000000,73.914000>}
box{<0,0,-0.254000><1.701990,0.035000,0.254000> rotate<0,52.271555,0> translate<41.630600,-0.000000,75.260200> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<44.879400,-0.000000,32.228800>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<44.958000,-0.000000,33.528000>}
box{<0,0,-0.254000><1.301575,0.035000,0.254000> rotate<0,-86.532185,0> translate<44.879400,-0.000000,32.228800> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<44.879400,-0.000000,38.731200>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<44.958000,-0.000000,37.338000>}
box{<0,0,-0.254000><1.395415,0.035000,0.254000> rotate<0,86.765247,0> translate<44.879400,-0.000000,38.731200> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<44.958000,-0.000000,33.528000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<44.958000,-0.000000,37.338000>}
box{<0,0,-0.254000><3.810000,0.035000,0.254000> rotate<0,90.000000,0> translate<44.958000,-0.000000,37.338000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<44.879400,-0.000000,32.228800>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<45.212000,-0.000000,30.734000>}
box{<0,0,-0.254000><1.531356,0.035000,0.254000> rotate<0,77.450659,0> translate<44.879400,-0.000000,32.228800> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<45.212000,-0.000000,28.956000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<45.212000,-0.000000,30.734000>}
box{<0,0,-0.254000><1.778000,0.035000,0.254000> rotate<0,90.000000,0> translate<45.212000,-0.000000,30.734000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<32.004000,-0.000000,30.480000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<46.228000,-0.000000,44.704000>}
box{<0,0,-0.254000><20.115774,0.035000,0.254000> rotate<0,-44.997030,0> translate<32.004000,-0.000000,30.480000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<46.228000,-0.000000,44.704000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<46.228000,-0.000000,64.770000>}
box{<0,0,-0.254000><20.066000,0.035000,0.254000> rotate<0,90.000000,0> translate<46.228000,-0.000000,64.770000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<42.672000,-0.000000,73.914000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<46.228000,-0.000000,70.358000>}
box{<0,0,-0.254000><5.028943,0.035000,0.254000> rotate<0,44.997030,0> translate<42.672000,-0.000000,73.914000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<46.228000,-0.000000,64.770000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<46.558200,-0.000000,65.938400>}
box{<0,0,-0.254000><1.214163,0.035000,0.254000> rotate<0,-74.214349,0> translate<46.228000,-0.000000,64.770000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<46.710600,-0.000000,75.260200>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<47.752000,-0.000000,73.914000>}
box{<0,0,-0.254000><1.701990,0.035000,0.254000> rotate<0,52.271555,0> translate<46.710600,-0.000000,75.260200> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<46.964600,-0.000000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<48.006000,-0.000000,9.652000>}
box{<0,0,-0.254000><1.147788,0.035000,0.254000> rotate<0,24.862056,0> translate<46.964600,-0.000000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<49.400600,-0.000000,32.228800>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<49.530000,-0.000000,33.528000>}
box{<0,0,-0.254000><1.305628,0.035000,0.254000> rotate<0,-84.306549,0> translate<49.400600,-0.000000,32.228800> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<49.400600,-0.000000,38.731200>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<49.530000,-0.000000,37.338000>}
box{<0,0,-0.254000><1.399196,0.035000,0.254000> rotate<0,84.688019,0> translate<49.400600,-0.000000,38.731200> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<49.530000,-0.000000,33.528000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<49.530000,-0.000000,37.338000>}
box{<0,0,-0.254000><3.810000,0.035000,0.254000> rotate<0,90.000000,0> translate<49.530000,-0.000000,37.338000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<49.098200,-1.535000,65.938400>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<49.530000,-1.535000,67.056000>}
box{<0,0,-0.254000><1.198116,0.035000,0.254000> rotate<0,-68.870735,0> translate<49.098200,-1.535000,65.938400> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<49.400600,-1.535000,32.228800>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<50.038000,-1.535000,31.242000>}
box{<0,0,-0.254000><1.174757,0.035000,0.254000> rotate<0,57.136751,0> translate<49.400600,-1.535000,32.228800> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<49.530000,-1.535000,67.056000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<50.038000,-1.535000,67.056000>}
box{<0,0,-0.254000><0.508000,0.035000,0.254000> rotate<0,0.000000,0> translate<49.530000,-1.535000,67.056000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<47.752000,-0.000000,73.914000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<50.292000,-0.000000,71.374000>}
box{<0,0,-0.254000><3.592102,0.035000,0.254000> rotate<0,44.997030,0> translate<47.752000,-0.000000,73.914000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<37.084000,-0.000000,34.036000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<51.308000,-0.000000,48.260000>}
box{<0,0,-0.254000><20.115774,0.035000,0.254000> rotate<0,-44.997030,0> translate<37.084000,-0.000000,34.036000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<51.308000,-0.000000,48.260000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<51.308000,-0.000000,64.770000>}
box{<0,0,-0.254000><16.510000,0.035000,0.254000> rotate<0,90.000000,0> translate<51.308000,-0.000000,64.770000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<51.308000,-0.000000,64.770000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<51.638200,-0.000000,65.938400>}
box{<0,0,-0.254000><1.214163,0.035000,0.254000> rotate<0,-74.214349,0> translate<51.308000,-0.000000,64.770000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<51.790600,-0.000000,75.260200>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<52.832000,-0.000000,73.914000>}
box{<0,0,-0.254000><1.701990,0.035000,0.254000> rotate<0,52.271555,0> translate<51.790600,-0.000000,75.260200> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<52.044600,-1.535000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<53.086000,-1.535000,11.430000>}
box{<0,0,-0.254000><1.662100,0.035000,0.254000> rotate<0,-51.200069,0> translate<52.044600,-1.535000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<50.038000,-1.535000,67.056000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<53.086000,-1.535000,70.104000>}
box{<0,0,-0.254000><4.310523,0.035000,0.254000> rotate<0,-44.997030,0> translate<50.038000,-1.535000,67.056000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<42.164000,-1.535000,39.116000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<53.848000,-1.535000,50.800000>}
box{<0,0,-0.254000><16.523671,0.035000,0.254000> rotate<0,-44.997030,0> translate<42.164000,-1.535000,39.116000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<53.848000,-1.535000,50.800000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<53.848000,-1.535000,64.770000>}
box{<0,0,-0.254000><13.970000,0.035000,0.254000> rotate<0,90.000000,0> translate<53.848000,-1.535000,64.770000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<53.848000,-1.535000,64.770000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<54.178200,-1.535000,65.938400>}
box{<0,0,-0.254000><1.214163,0.035000,0.254000> rotate<0,-74.214349,0> translate<53.848000,-1.535000,64.770000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<52.832000,-0.000000,73.914000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<54.356000,-0.000000,72.390000>}
box{<0,0,-0.254000><2.155261,0.035000,0.254000> rotate<0,44.997030,0> translate<52.832000,-0.000000,73.914000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<38.100000,-0.000000,68.326000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<54.610000,-0.000000,68.326000>}
box{<0,0,-0.254000><16.510000,0.035000,0.254000> rotate<0,0.000000,0> translate<38.100000,-0.000000,68.326000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<48.006000,-0.000000,9.652000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<55.118000,-0.000000,16.764000>}
box{<0,0,-0.254000><10.057887,0.035000,0.254000> rotate<0,-44.997030,0> translate<48.006000,-0.000000,9.652000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<50.038000,-1.535000,31.242000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<55.118000,-1.535000,31.242000>}
box{<0,0,-0.254000><5.080000,0.035000,0.254000> rotate<0,0.000000,0> translate<50.038000,-1.535000,31.242000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<42.164000,-0.000000,69.342000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<55.118000,-0.000000,69.342000>}
box{<0,0,-0.254000><12.954000,0.035000,0.254000> rotate<0,0.000000,0> translate<42.164000,-0.000000,69.342000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<45.212000,-0.000000,28.956000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<55.372000,-0.000000,18.796000>}
box{<0,0,-0.254000><14.368410,0.035000,0.254000> rotate<0,44.997030,0> translate<45.212000,-0.000000,28.956000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<46.228000,-0.000000,70.358000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<55.626000,-0.000000,70.358000>}
box{<0,0,-0.254000><9.398000,0.035000,0.254000> rotate<0,0.000000,0> translate<46.228000,-0.000000,70.358000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<55.118000,-0.000000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<55.702200,-0.000000,17.678400>}
box{<0,0,-0.254000><1.085088,0.035000,0.254000> rotate<0,-57.422153,0> translate<55.118000,-0.000000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<55.372000,-0.000000,18.796000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<55.702200,-0.000000,17.678400>}
box{<0,0,-0.254000><1.165359,0.035000,0.254000> rotate<0,73.535132,0> translate<55.372000,-0.000000,18.796000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<54.610000,-0.000000,68.326000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<56.134000,-0.000000,66.802000>}
box{<0,0,-0.254000><2.155261,0.035000,0.254000> rotate<0,44.997030,0> translate<54.610000,-0.000000,68.326000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<55.118000,-0.000000,69.342000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<56.134000,-0.000000,68.326000>}
box{<0,0,-0.254000><1.436841,0.035000,0.254000> rotate<0,44.997030,0> translate<55.118000,-0.000000,69.342000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<50.292000,-0.000000,71.374000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<56.134000,-0.000000,71.374000>}
box{<0,0,-0.254000><5.842000,0.035000,0.254000> rotate<0,0.000000,0> translate<50.292000,-0.000000,71.374000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<55.626000,-0.000000,70.358000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<56.642000,-0.000000,69.342000>}
box{<0,0,-0.254000><1.436841,0.035000,0.254000> rotate<0,44.997030,0> translate<55.626000,-0.000000,70.358000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<54.356000,-0.000000,72.390000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<56.642000,-0.000000,72.390000>}
box{<0,0,-0.254000><2.286000,0.035000,0.254000> rotate<0,0.000000,0> translate<54.356000,-0.000000,72.390000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<56.134000,-0.000000,66.802000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<56.718200,-0.000000,65.938400>}
box{<0,0,-0.254000><1.042638,0.035000,0.254000> rotate<0,55.919114,0> translate<56.134000,-0.000000,66.802000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<53.086000,-1.535000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<57.150000,-1.535000,15.494000>}
box{<0,0,-0.254000><5.747364,0.035000,0.254000> rotate<0,-44.997030,0> translate<53.086000,-1.535000,11.430000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<56.134000,-0.000000,68.326000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<57.150000,-0.000000,68.326000>}
box{<0,0,-0.254000><1.016000,0.035000,0.254000> rotate<0,0.000000,0> translate<56.134000,-0.000000,68.326000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<56.134000,-0.000000,71.374000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<57.150000,-0.000000,70.358000>}
box{<0,0,-0.254000><1.436841,0.035000,0.254000> rotate<0,44.997030,0> translate<56.134000,-0.000000,71.374000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<56.642000,-0.000000,72.390000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<57.658000,-0.000000,71.374000>}
box{<0,0,-0.254000><1.436841,0.035000,0.254000> rotate<0,44.997030,0> translate<56.642000,-0.000000,72.390000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<56.870600,-0.000000,75.260200>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<57.912000,-0.000000,73.914000>}
box{<0,0,-0.254000><1.701990,0.035000,0.254000> rotate<0,52.271555,0> translate<56.870600,-0.000000,75.260200> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<57.124600,-1.535000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<58.166000,-1.535000,11.430000>}
box{<0,0,-0.254000><1.662100,0.035000,0.254000> rotate<0,-51.200069,0> translate<57.124600,-1.535000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<58.242200,-0.000000,17.678400>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<58.674000,-0.000000,18.796000>}
box{<0,0,-0.254000><1.198116,0.035000,0.254000> rotate<0,-68.870735,0> translate<58.242200,-0.000000,17.678400> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<57.150000,-0.000000,68.326000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<58.674000,-0.000000,66.802000>}
box{<0,0,-0.254000><2.155261,0.035000,0.254000> rotate<0,44.997030,0> translate<57.150000,-0.000000,68.326000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<56.642000,-0.000000,69.342000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<58.674000,-0.000000,69.342000>}
box{<0,0,-0.254000><2.032000,0.035000,0.254000> rotate<0,0.000000,0> translate<56.642000,-0.000000,69.342000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<58.674000,-0.000000,66.802000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<59.258200,-0.000000,65.938400>}
box{<0,0,-0.254000><1.042638,0.035000,0.254000> rotate<0,55.919114,0> translate<58.674000,-0.000000,66.802000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<57.912000,-0.000000,73.914000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<59.436000,-0.000000,72.390000>}
box{<0,0,-0.254000><2.155261,0.035000,0.254000> rotate<0,44.997030,0> translate<57.912000,-0.000000,73.914000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<57.150000,-0.000000,70.358000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<60.198000,-0.000000,70.358000>}
box{<0,0,-0.254000><3.048000,0.035000,0.254000> rotate<0,0.000000,0> translate<57.150000,-0.000000,70.358000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<58.166000,-1.535000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<60.960000,-1.535000,14.224000>}
box{<0,0,-0.254000><3.951313,0.035000,0.254000> rotate<0,-44.997030,0> translate<58.166000,-1.535000,11.430000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<60.782200,-0.000000,17.678400>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<60.960000,-0.000000,16.510000>}
box{<0,0,-0.254000><1.181851,0.035000,0.254000> rotate<0,81.342090,0> translate<60.782200,-0.000000,17.678400> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<58.674000,-0.000000,69.342000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<61.214000,-0.000000,66.802000>}
box{<0,0,-0.254000><3.592102,0.035000,0.254000> rotate<0,44.997030,0> translate<58.674000,-0.000000,69.342000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<57.658000,-0.000000,71.374000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<61.722000,-0.000000,71.374000>}
box{<0,0,-0.254000><4.064000,0.035000,0.254000> rotate<0,0.000000,0> translate<57.658000,-0.000000,71.374000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<61.214000,-0.000000,66.802000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<61.798200,-0.000000,65.938400>}
box{<0,0,-0.254000><1.042638,0.035000,0.254000> rotate<0,55.919114,0> translate<61.214000,-0.000000,66.802000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<59.436000,-0.000000,72.390000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<62.230000,-0.000000,72.390000>}
box{<0,0,-0.254000><2.794000,0.035000,0.254000> rotate<0,0.000000,0> translate<59.436000,-0.000000,72.390000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<61.950600,-0.000000,75.260200>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<62.992000,-0.000000,73.914000>}
box{<0,0,-0.254000><1.701990,0.035000,0.254000> rotate<0,52.271555,0> translate<61.950600,-0.000000,75.260200> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<62.204600,-1.535000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<63.246000,-1.535000,11.430000>}
box{<0,0,-0.254000><1.662100,0.035000,0.254000> rotate<0,-51.200069,0> translate<62.204600,-1.535000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<62.230000,-0.000000,72.390000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<63.246000,-0.000000,71.374000>}
box{<0,0,-0.254000><1.436841,0.035000,0.254000> rotate<0,44.997030,0> translate<62.230000,-0.000000,72.390000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<60.198000,-0.000000,70.358000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<63.754000,-0.000000,66.802000>}
box{<0,0,-0.254000><5.028943,0.035000,0.254000> rotate<0,44.997030,0> translate<60.198000,-0.000000,70.358000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<63.754000,-0.000000,66.802000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<64.338200,-0.000000,65.938400>}
box{<0,0,-0.254000><1.042638,0.035000,0.254000> rotate<0,55.919114,0> translate<63.754000,-0.000000,66.802000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<60.960000,-0.000000,16.510000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<64.516000,-0.000000,12.954000>}
box{<0,0,-0.254000><5.028943,0.035000,0.254000> rotate<0,44.997030,0> translate<60.960000,-0.000000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<62.992000,-0.000000,73.914000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<64.516000,-0.000000,72.390000>}
box{<0,0,-0.254000><2.155261,0.035000,0.254000> rotate<0,44.997030,0> translate<62.992000,-0.000000,73.914000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<63.246000,-1.535000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<64.770000,-1.535000,12.954000>}
box{<0,0,-0.254000><2.155261,0.035000,0.254000> rotate<0,-44.997030,0> translate<63.246000,-1.535000,11.430000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<60.960000,-1.535000,14.224000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<65.024000,-1.535000,14.224000>}
box{<0,0,-0.254000><4.064000,0.035000,0.254000> rotate<0,0.000000,0> translate<60.960000,-1.535000,14.224000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<63.246000,-0.000000,71.374000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<65.786000,-0.000000,71.374000>}
box{<0,0,-0.254000><2.540000,0.035000,0.254000> rotate<0,0.000000,0> translate<63.246000,-0.000000,71.374000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<61.722000,-0.000000,71.374000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<66.294000,-0.000000,66.802000>}
box{<0,0,-0.254000><6.465784,0.035000,0.254000> rotate<0,44.997030,0> translate<61.722000,-0.000000,71.374000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<55.118000,-1.535000,31.242000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<66.675000,-1.535000,19.685000>}
box{<0,0,-0.254000><16.344066,0.035000,0.254000> rotate<0,44.997030,0> translate<55.118000,-1.535000,31.242000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<66.675000,-1.535000,19.685000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<66.802000,-1.535000,19.812000>}
box{<0,0,-0.254000><0.179605,0.035000,0.254000> rotate<0,-44.997030,0> translate<66.675000,-1.535000,19.685000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<64.516000,-0.000000,72.390000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<67.310000,-0.000000,72.390000>}
box{<0,0,-0.254000><2.794000,0.035000,0.254000> rotate<0,0.000000,0> translate<64.516000,-0.000000,72.390000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<66.675000,-1.535000,19.685000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<67.818000,-1.535000,18.542000>}
box{<0,0,-0.254000><1.616446,0.035000,0.254000> rotate<0,44.997030,0> translate<66.675000,-1.535000,19.685000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<66.294000,-0.000000,66.802000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<67.818000,-0.000000,66.802000>}
box{<0,0,-0.254000><1.524000,0.035000,0.254000> rotate<0,0.000000,0> translate<66.294000,-0.000000,66.802000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<64.770000,-1.535000,12.954000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<68.072000,-1.535000,12.954000>}
box{<0,0,-0.254000><3.302000,0.035000,0.254000> rotate<0,0.000000,0> translate<64.770000,-1.535000,12.954000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<67.030600,-0.000000,75.260200>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<68.072000,-0.000000,74.168000>}
box{<0,0,-0.254000><1.509111,0.035000,0.254000> rotate<0,46.360868,0> translate<67.030600,-0.000000,75.260200> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<67.284600,-1.535000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<68.326000,-1.535000,11.430000>}
box{<0,0,-0.254000><1.662100,0.035000,0.254000> rotate<0,-51.200069,0> translate<67.284600,-1.535000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<67.818000,-1.535000,18.542000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<68.402200,-1.535000,17.678400>}
box{<0,0,-0.254000><1.042638,0.035000,0.254000> rotate<0,55.919114,0> translate<67.818000,-1.535000,18.542000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<67.818000,-0.000000,66.802000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<68.402200,-0.000000,65.938400>}
box{<0,0,-0.254000><1.042638,0.035000,0.254000> rotate<0,55.919114,0> translate<67.818000,-0.000000,66.802000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<57.150000,-1.535000,15.494000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<69.088000,-1.535000,15.494000>}
box{<0,0,-0.254000><11.938000,0.035000,0.254000> rotate<0,0.000000,0> translate<57.150000,-1.535000,15.494000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<68.072000,-1.535000,12.954000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<70.104000,-1.535000,14.986000>}
box{<0,0,-0.254000><2.873682,0.035000,0.254000> rotate<0,-44.997030,0> translate<68.072000,-1.535000,12.954000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<69.088000,-1.535000,15.494000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<70.358000,-1.535000,16.764000>}
box{<0,0,-0.254000><1.796051,0.035000,0.254000> rotate<0,-44.997030,0> translate<69.088000,-1.535000,15.494000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<65.786000,-0.000000,71.374000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<70.358000,-0.000000,66.802000>}
box{<0,0,-0.254000><6.465784,0.035000,0.254000> rotate<0,44.997030,0> translate<65.786000,-0.000000,71.374000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<68.326000,-1.535000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<70.866000,-1.535000,13.970000>}
box{<0,0,-0.254000><3.592102,0.035000,0.254000> rotate<0,-44.997030,0> translate<68.326000,-1.535000,11.430000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<70.358000,-0.000000,66.802000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<70.942200,-0.000000,65.938400>}
box{<0,0,-0.254000><1.042638,0.035000,0.254000> rotate<0,55.919114,0> translate<70.358000,-0.000000,66.802000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<71.882000,-0.000000,73.406000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<72.110600,-0.000000,75.260200>}
box{<0,0,-0.254000><1.868239,0.035000,0.254000> rotate<0,-82.966128,0> translate<71.882000,-0.000000,73.406000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<65.024000,-0.000000,14.224000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<72.898000,-0.000000,14.224000>}
box{<0,0,-0.254000><7.874000,0.035000,0.254000> rotate<0,0.000000,0> translate<65.024000,-0.000000,14.224000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<70.358000,-1.535000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<72.898000,-1.535000,16.764000>}
box{<0,0,-0.254000><2.540000,0.035000,0.254000> rotate<0,0.000000,0> translate<70.358000,-1.535000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<67.310000,-0.000000,72.390000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<72.898000,-0.000000,66.802000>}
box{<0,0,-0.254000><7.902625,0.035000,0.254000> rotate<0,44.997030,0> translate<67.310000,-0.000000,72.390000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<72.364600,-1.535000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<73.406000,-1.535000,11.430000>}
box{<0,0,-0.254000><1.662100,0.035000,0.254000> rotate<0,-51.200069,0> translate<72.364600,-1.535000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<72.898000,-1.535000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<73.482200,-1.535000,17.678400>}
box{<0,0,-0.254000><1.085088,0.035000,0.254000> rotate<0,-57.422153,0> translate<72.898000,-1.535000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<72.898000,-0.000000,66.802000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<73.482200,-0.000000,65.938400>}
box{<0,0,-0.254000><1.042638,0.035000,0.254000> rotate<0,55.919114,0> translate<72.898000,-0.000000,66.802000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<73.406000,-1.535000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<74.930000,-1.535000,12.954000>}
box{<0,0,-0.254000><2.155261,0.035000,0.254000> rotate<0,-44.997030,0> translate<73.406000,-1.535000,11.430000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<72.898000,-0.000000,14.224000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<75.438000,-0.000000,16.764000>}
box{<0,0,-0.254000><3.592102,0.035000,0.254000> rotate<0,-44.997030,0> translate<72.898000,-0.000000,14.224000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<68.072000,-0.000000,74.168000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<75.438000,-0.000000,66.802000>}
box{<0,0,-0.254000><10.417097,0.035000,0.254000> rotate<0,44.997030,0> translate<68.072000,-0.000000,74.168000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<75.438000,-0.000000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<76.022200,-0.000000,17.678400>}
box{<0,0,-0.254000><1.085088,0.035000,0.254000> rotate<0,-57.422153,0> translate<75.438000,-0.000000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<75.438000,-0.000000,66.802000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<76.022200,-0.000000,65.938400>}
box{<0,0,-0.254000><1.042638,0.035000,0.254000> rotate<0,55.919114,0> translate<75.438000,-0.000000,66.802000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<70.104000,-1.535000,14.986000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<76.200000,-1.535000,14.986000>}
box{<0,0,-0.254000><6.096000,0.035000,0.254000> rotate<0,0.000000,0> translate<70.104000,-1.535000,14.986000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<70.866000,-1.535000,13.970000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<77.724000,-1.535000,13.970000>}
box{<0,0,-0.254000><6.858000,0.035000,0.254000> rotate<0,0.000000,0> translate<70.866000,-1.535000,13.970000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<77.190600,-0.000000,75.260200>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<77.724000,-0.000000,73.406000>}
box{<0,0,-0.254000><1.929397,0.035000,0.254000> rotate<0,73.946115,0> translate<77.190600,-0.000000,75.260200> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<76.200000,-1.535000,14.986000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<77.978000,-1.535000,16.764000>}
box{<0,0,-0.254000><2.514472,0.035000,0.254000> rotate<0,-44.997030,0> translate<76.200000,-1.535000,14.986000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<71.882000,-0.000000,73.406000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<78.232000,-0.000000,67.056000>}
box{<0,0,-0.254000><8.980256,0.035000,0.254000> rotate<0,44.997030,0> translate<71.882000,-0.000000,73.406000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<77.444600,-1.535000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<78.486000,-1.535000,9.652000>}
box{<0,0,-0.254000><1.147788,0.035000,0.254000> rotate<0,24.862056,0> translate<77.444600,-1.535000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<77.978000,-1.535000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<78.562200,-1.535000,17.678400>}
box{<0,0,-0.254000><1.085088,0.035000,0.254000> rotate<0,-57.422153,0> translate<77.978000,-1.535000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<78.232000,-0.000000,67.056000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<78.562200,-0.000000,65.938400>}
box{<0,0,-0.254000><1.165359,0.035000,0.254000> rotate<0,73.535132,0> translate<78.232000,-0.000000,67.056000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<74.930000,-1.535000,12.954000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<79.248000,-1.535000,12.954000>}
box{<0,0,-0.254000><4.318000,0.035000,0.254000> rotate<0,0.000000,0> translate<74.930000,-1.535000,12.954000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<64.516000,-0.000000,12.954000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<80.010000,-0.000000,12.954000>}
box{<0,0,-0.254000><15.494000,0.035000,0.254000> rotate<0,0.000000,0> translate<64.516000,-0.000000,12.954000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<77.724000,-1.535000,13.970000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<80.518000,-1.535000,16.764000>}
box{<0,0,-0.254000><3.951313,0.035000,0.254000> rotate<0,-44.997030,0> translate<77.724000,-1.535000,13.970000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<77.724000,-0.000000,73.406000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<80.772000,-0.000000,70.358000>}
box{<0,0,-0.254000><4.310523,0.035000,0.254000> rotate<0,44.997030,0> translate<77.724000,-0.000000,73.406000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<80.772000,-0.000000,67.056000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<80.772000,-0.000000,70.358000>}
box{<0,0,-0.254000><3.302000,0.035000,0.254000> rotate<0,90.000000,0> translate<80.772000,-0.000000,70.358000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<80.518000,-1.535000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<81.102200,-1.535000,17.678400>}
box{<0,0,-0.254000><1.085088,0.035000,0.254000> rotate<0,-57.422153,0> translate<80.518000,-1.535000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<80.772000,-0.000000,67.056000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<81.102200,-0.000000,65.938400>}
box{<0,0,-0.254000><1.165359,0.035000,0.254000> rotate<0,73.535132,0> translate<80.772000,-0.000000,67.056000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<80.010000,-0.000000,12.954000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<81.534000,-0.000000,11.430000>}
box{<0,0,-0.254000><2.155261,0.035000,0.254000> rotate<0,44.997030,0> translate<80.010000,-0.000000,12.954000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<81.534000,-0.000000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<82.524600,-0.000000,10.134600>}
box{<0,0,-0.254000><1.630751,0.035000,0.254000> rotate<0,52.591172,0> translate<81.534000,-0.000000,11.430000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<79.248000,-1.535000,12.954000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<83.058000,-1.535000,16.764000>}
box{<0,0,-0.254000><5.388154,0.035000,0.254000> rotate<0,-44.997030,0> translate<79.248000,-1.535000,12.954000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<82.270600,-0.000000,75.260200>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<83.312000,-0.000000,73.914000>}
box{<0,0,-0.254000><1.701990,0.035000,0.254000> rotate<0,52.271555,0> translate<82.270600,-0.000000,75.260200> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<83.312000,-0.000000,67.056000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<83.312000,-0.000000,73.914000>}
box{<0,0,-0.254000><6.858000,0.035000,0.254000> rotate<0,90.000000,0> translate<83.312000,-0.000000,73.914000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<82.524600,-0.000000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<83.566000,-0.000000,10.160000>}
box{<0,0,-0.254000><1.041710,0.035000,0.254000> rotate<0,-1.397089,0> translate<82.524600,-0.000000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<83.058000,-1.535000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<83.642200,-1.535000,17.678400>}
box{<0,0,-0.254000><1.085088,0.035000,0.254000> rotate<0,-57.422153,0> translate<83.058000,-1.535000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<83.312000,-0.000000,67.056000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<83.642200,-0.000000,65.938400>}
box{<0,0,-0.254000><1.165359,0.035000,0.254000> rotate<0,73.535132,0> translate<83.312000,-0.000000,67.056000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<78.486000,-1.535000,9.652000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<85.598000,-1.535000,16.764000>}
box{<0,0,-0.254000><10.057887,0.035000,0.254000> rotate<0,-44.997030,0> translate<78.486000,-1.535000,9.652000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<85.598000,-1.535000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<86.182200,-1.535000,17.678400>}
box{<0,0,-0.254000><1.085088,0.035000,0.254000> rotate<0,-57.422153,0> translate<85.598000,-1.535000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<83.566000,-0.000000,10.160000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<86.614000,-0.000000,10.160000>}
box{<0,0,-0.254000><3.048000,0.035000,0.254000> rotate<0,0.000000,0> translate<83.566000,-0.000000,10.160000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<86.182200,-0.000000,65.938400>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<86.614000,-0.000000,67.056000>}
box{<0,0,-0.254000><1.198116,0.035000,0.254000> rotate<0,-68.870735,0> translate<86.182200,-0.000000,65.938400> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<86.614000,-0.000000,67.056000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<86.614000,-0.000000,73.660000>}
box{<0,0,-0.254000><6.604000,0.035000,0.254000> rotate<0,90.000000,0> translate<86.614000,-0.000000,73.660000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<86.614000,-0.000000,73.660000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<87.350600,-0.000000,75.260200>}
box{<0,0,-0.254000><1.761596,0.035000,0.254000> rotate<0,-65.278251,0> translate<86.614000,-0.000000,73.660000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<86.614000,-0.000000,10.160000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<87.604600,-0.000000,10.134600>}
box{<0,0,-0.254000><0.990926,0.035000,0.254000> rotate<0,1.468704,0> translate<86.614000,-0.000000,10.160000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<87.604600,-0.000000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<87.884000,-0.000000,12.192000>}
box{<0,0,-0.254000><2.076285,0.035000,0.254000> rotate<0,-82.260973,0> translate<87.604600,-0.000000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<87.884000,-0.000000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<87.884000,-0.000000,21.336000>}
box{<0,0,-0.254000><9.144000,0.035000,0.254000> rotate<0,90.000000,0> translate<87.884000,-0.000000,21.336000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<58.674000,-0.000000,18.796000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<96.201000,-0.000000,57.123000>}
box{<0,0,-0.254000><53.639861,0.035000,0.254000> rotate<0,-45.601242,0> translate<58.674000,-0.000000,18.796000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<66.802000,-1.535000,19.812000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<97.598000,-1.535000,19.912000>}
box{<0,0,-0.254000><30.796162,0.035000,0.254000> rotate<0,-0.186036,0> translate<66.802000,-1.535000,19.812000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<96.201000,-0.000000,57.123000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<97.598000,-0.000000,55.726000>}
box{<0,0,-0.254000><1.975656,0.035000,0.254000> rotate<0,44.997030,0> translate<96.201000,-0.000000,57.123000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<53.086000,-1.535000,70.104000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<97.598000,-1.535000,70.204000>}
box{<0,0,-0.254000><44.512112,0.035000,0.254000> rotate<0,-0.128711,0> translate<53.086000,-1.535000,70.104000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<87.884000,-0.000000,21.336000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<98.106000,-0.000000,32.358000>}
box{<0,0,-0.254000><15.032424,0.035000,0.254000> rotate<0,-47.153496,0> translate<87.884000,-0.000000,21.336000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<98.106000,-0.000000,32.358000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<98.106000,-0.000000,34.136000>}
box{<0,0,-0.254000><1.778000,0.035000,0.254000> rotate<0,90.000000,0> translate<98.106000,-0.000000,34.136000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<96.201000,-0.000000,57.123000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<98.614000,-0.000000,59.536000>}
box{<0,0,-0.254000><3.412497,0.035000,0.254000> rotate<0,-44.997030,0> translate<96.201000,-0.000000,57.123000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<97.598000,-1.535000,19.912000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.570000,-1.535000,19.850000>}
box{<0,0,-0.254000><1.972974,0.035000,0.254000> rotate<0,1.800677,0> translate<97.598000,-1.535000,19.912000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<98.106000,-0.000000,34.136000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.570000,-0.000000,35.090000>}
box{<0,0,-0.254000><1.747401,0.035000,0.254000> rotate<0,-33.087664,0> translate<98.106000,-0.000000,34.136000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<97.598000,-0.000000,55.726000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.570000,-0.000000,55.410000>}
box{<0,0,-0.254000><1.997158,0.035000,0.254000> rotate<0,9.103274,0> translate<97.598000,-0.000000,55.726000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<98.614000,-0.000000,59.536000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.570000,-0.000000,60.490000>}
box{<0,0,-0.254000><1.350575,0.035000,0.254000> rotate<0,-44.937039,0> translate<98.614000,-0.000000,59.536000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<97.598000,-1.535000,70.204000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.570000,-1.535000,70.650000>}
box{<0,0,-0.254000><2.021806,0.035000,0.254000> rotate<0,-12.743132,0> translate<97.598000,-1.535000,70.204000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.570000,-0.000000,14.770000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.630000,-0.000000,15.594000>}
box{<0,0,-0.254000><0.826182,0.035000,0.254000> rotate<0,-85.829663,0> translate<99.570000,-0.000000,14.770000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.630000,-0.000000,18.896000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.630000,-0.000000,15.594000>}
box{<0,0,-0.254000><3.302000,0.035000,0.254000> rotate<0,-90.000000,0> translate<99.630000,-0.000000,15.594000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.570000,-0.000000,19.850000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.630000,-0.000000,18.896000>}
box{<0,0,-0.254000><0.955885,0.035000,0.254000> rotate<0,86.395530,0> translate<99.570000,-0.000000,19.850000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.570000,-0.000000,24.930000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.630000,-0.000000,25.754000>}
box{<0,0,-0.254000><0.826182,0.035000,0.254000> rotate<0,-85.829663,0> translate<99.570000,-0.000000,24.930000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.630000,-0.000000,29.056000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.630000,-0.000000,25.754000>}
box{<0,0,-0.254000><3.302000,0.035000,0.254000> rotate<0,-90.000000,0> translate<99.630000,-0.000000,25.754000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.570000,-0.000000,30.010000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.630000,-0.000000,29.056000>}
box{<0,0,-0.254000><0.955885,0.035000,0.254000> rotate<0,86.395530,0> translate<99.570000,-0.000000,30.010000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.570000,-0.000000,35.090000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.630000,-0.000000,35.914000>}
box{<0,0,-0.254000><0.826182,0.035000,0.254000> rotate<0,-85.829663,0> translate<99.570000,-0.000000,35.090000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.570000,-0.000000,40.170000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.630000,-0.000000,39.216000>}
box{<0,0,-0.254000><0.955885,0.035000,0.254000> rotate<0,86.395530,0> translate<99.570000,-0.000000,40.170000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.630000,-0.000000,35.914000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.630000,-0.000000,39.216000>}
box{<0,0,-0.254000><3.302000,0.035000,0.254000> rotate<0,90.000000,0> translate<99.630000,-0.000000,39.216000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.570000,-0.000000,45.250000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.630000,-0.000000,46.074000>}
box{<0,0,-0.254000><0.826182,0.035000,0.254000> rotate<0,-85.829663,0> translate<99.570000,-0.000000,45.250000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.630000,-0.000000,49.376000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.630000,-0.000000,46.074000>}
box{<0,0,-0.254000><3.302000,0.035000,0.254000> rotate<0,-90.000000,0> translate<99.630000,-0.000000,46.074000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.570000,-0.000000,50.330000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.630000,-0.000000,49.376000>}
box{<0,0,-0.254000><0.955885,0.035000,0.254000> rotate<0,86.395530,0> translate<99.570000,-0.000000,50.330000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.570000,-0.000000,65.570000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.630000,-0.000000,66.394000>}
box{<0,0,-0.254000><0.826182,0.035000,0.254000> rotate<0,-85.829663,0> translate<99.570000,-0.000000,65.570000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.630000,-0.000000,69.696000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.630000,-0.000000,66.394000>}
box{<0,0,-0.254000><3.302000,0.035000,0.254000> rotate<0,-90.000000,0> translate<99.630000,-0.000000,66.394000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.570000,-0.000000,70.650000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.630000,-0.000000,69.696000>}
box{<0,0,-0.254000><0.955885,0.035000,0.254000> rotate<0,86.395530,0> translate<99.570000,-0.000000,70.650000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.570000,-1.535000,45.250000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<100.900000,-1.535000,44.296000>}
box{<0,0,-0.254000><1.636770,0.035000,0.254000> rotate<0,35.649265,0> translate<99.570000,-1.535000,45.250000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.570000,-1.535000,65.570000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<100.900000,-1.535000,64.616000>}
box{<0,0,-0.254000><1.636770,0.035000,0.254000> rotate<0,35.649265,0> translate<99.570000,-1.535000,65.570000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.570000,-1.535000,30.010000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<101.154000,-1.535000,30.834000>}
box{<0,0,-0.254000><1.785506,0.035000,0.254000> rotate<0,-27.481728,0> translate<99.570000,-1.535000,30.010000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<101.154000,-1.535000,32.866000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<101.154000,-1.535000,30.834000>}
box{<0,0,-0.254000><2.032000,0.035000,0.254000> rotate<0,-90.000000,0> translate<101.154000,-1.535000,30.834000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.570000,-1.535000,50.330000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<101.154000,-1.535000,51.154000>}
box{<0,0,-0.254000><1.785506,0.035000,0.254000> rotate<0,-27.481728,0> translate<99.570000,-1.535000,50.330000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<101.154000,-1.535000,53.186000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<101.154000,-1.535000,51.154000>}
box{<0,0,-0.254000><2.032000,0.035000,0.254000> rotate<0,-90.000000,0> translate<101.154000,-1.535000,51.154000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<101.154000,-1.535000,32.866000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<102.424000,-1.535000,34.136000>}
box{<0,0,-0.254000><1.796051,0.035000,0.254000> rotate<0,-44.997030,0> translate<101.154000,-1.535000,32.866000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<102.424000,-1.535000,42.772000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<102.424000,-1.535000,34.136000>}
box{<0,0,-0.254000><8.636000,0.035000,0.254000> rotate<0,-90.000000,0> translate<102.424000,-1.535000,34.136000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<100.900000,-1.535000,44.296000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<102.424000,-1.535000,42.772000>}
box{<0,0,-0.254000><2.155261,0.035000,0.254000> rotate<0,44.997030,0> translate<100.900000,-1.535000,44.296000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<101.154000,-1.535000,53.186000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<102.424000,-1.535000,54.456000>}
box{<0,0,-0.254000><1.796051,0.035000,0.254000> rotate<0,-44.997030,0> translate<101.154000,-1.535000,53.186000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<102.424000,-1.535000,63.092000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<102.424000,-1.535000,54.456000>}
box{<0,0,-0.254000><8.636000,0.035000,0.254000> rotate<0,-90.000000,0> translate<102.424000,-1.535000,54.456000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<100.900000,-1.535000,64.616000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<102.424000,-1.535000,63.092000>}
box{<0,0,-0.254000><2.155261,0.035000,0.254000> rotate<0,44.997030,0> translate<100.900000,-1.535000,64.616000> }
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
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.300000,-1.535000,6.700000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.300000,-1.535000,79.100000>}
box{<0,0,-0.203200><72.400000,0.035000,0.203200> rotate<0,90.000000,0> translate<28.300000,-1.535000,79.100000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.300000,-1.535000,6.700000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<103.000000,-1.535000,6.700000>}
box{<0,0,-0.203200><74.700000,0.035000,0.203200> rotate<0,0.000000,0> translate<28.300000,-1.535000,6.700000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.300000,-1.535000,79.100000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<103.000000,-1.535000,79.100000>}
box{<0,0,-0.203200><74.700000,0.035000,0.203200> rotate<0,0.000000,0> translate<28.300000,-1.535000,79.100000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<103.000000,-1.535000,79.100000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<103.000000,-1.535000,6.700000>}
box{<0,0,-0.203200><72.400000,0.035000,0.203200> rotate<0,-90.000000,0> translate<103.000000,-1.535000,6.700000> }
texture{col_pol}
}
#end
union{
cylinder{<44.879400,0.038000,32.228800><44.879400,-1.538000,32.228800>0.508000}
cylinder{<44.879400,0.038000,38.731200><44.879400,-1.538000,38.731200>0.508000}
cylinder{<49.400600,0.038000,32.228800><49.400600,-1.538000,32.228800>0.508000}
cylinder{<49.400600,0.038000,38.731200><49.400600,-1.538000,38.731200>0.508000}
cylinder{<58.242200,0.038000,17.678400><58.242200,-1.538000,17.678400>0.400000}
cylinder{<60.782200,0.038000,17.678400><60.782200,-1.538000,17.678400>0.400000}
cylinder{<73.482200,0.038000,17.678400><73.482200,-1.538000,17.678400>0.400000}
cylinder{<76.022200,0.038000,17.678400><76.022200,-1.538000,17.678400>0.400000}
cylinder{<78.562200,0.038000,17.678400><78.562200,-1.538000,17.678400>0.400000}
cylinder{<81.102200,0.038000,17.678400><81.102200,-1.538000,17.678400>0.400000}
cylinder{<83.642200,0.038000,17.678400><83.642200,-1.538000,17.678400>0.400000}
cylinder{<86.182200,0.038000,17.678400><86.182200,-1.538000,17.678400>0.400000}
cylinder{<46.558200,0.038000,65.938400><46.558200,-1.538000,65.938400>0.400000}
cylinder{<81.102200,0.038000,65.938400><81.102200,-1.538000,65.938400>0.400000}
cylinder{<78.562200,0.038000,65.938400><78.562200,-1.538000,65.938400>0.400000}
cylinder{<76.022200,0.038000,65.938400><76.022200,-1.538000,65.938400>0.400000}
cylinder{<73.482200,0.038000,65.938400><73.482200,-1.538000,65.938400>0.400000}
cylinder{<70.942200,0.038000,65.938400><70.942200,-1.538000,65.938400>0.400000}
cylinder{<68.402200,0.038000,65.938400><68.402200,-1.538000,65.938400>0.400000}
cylinder{<64.338200,0.038000,65.938400><64.338200,-1.538000,65.938400>0.400000}
cylinder{<61.798200,0.038000,65.938400><61.798200,-1.538000,65.938400>0.400000}
cylinder{<59.258200,0.038000,65.938400><59.258200,-1.538000,65.938400>0.400000}
cylinder{<56.718200,0.038000,65.938400><56.718200,-1.538000,65.938400>0.400000}
cylinder{<54.178200,0.038000,65.938400><54.178200,-1.538000,65.938400>0.400000}
cylinder{<51.638200,0.038000,65.938400><51.638200,-1.538000,65.938400>0.400000}
cylinder{<49.098200,0.038000,65.938400><49.098200,-1.538000,65.938400>0.400000}
cylinder{<65.862200,0.038000,17.678400><65.862200,-1.538000,17.678400>0.400000}
cylinder{<63.322200,0.038000,17.678400><63.322200,-1.538000,17.678400>0.400000}
cylinder{<55.702200,0.038000,17.678400><55.702200,-1.538000,17.678400>0.400000}
cylinder{<86.182200,0.038000,65.938400><86.182200,-1.538000,65.938400>0.400000}
cylinder{<83.642200,0.038000,65.938400><83.642200,-1.538000,65.938400>0.400000}
cylinder{<68.402200,0.038000,17.678400><68.402200,-1.538000,17.678400>0.400000}
cylinder{<99.570000,0.038000,14.770000><99.570000,-1.538000,14.770000>0.698500}
cylinder{<99.570000,0.038000,19.850000><99.570000,-1.538000,19.850000>0.698500}
cylinder{<99.570000,0.038000,24.930000><99.570000,-1.538000,24.930000>0.698500}
cylinder{<99.570000,0.038000,30.010000><99.570000,-1.538000,30.010000>0.698500}
cylinder{<99.570000,0.038000,35.090000><99.570000,-1.538000,35.090000>0.698500}
cylinder{<99.570000,0.038000,40.170000><99.570000,-1.538000,40.170000>0.698500}
cylinder{<99.570000,0.038000,45.250000><99.570000,-1.538000,45.250000>0.698500}
cylinder{<99.570000,0.038000,50.330000><99.570000,-1.538000,50.330000>0.698500}
cylinder{<99.570000,0.038000,55.410000><99.570000,-1.538000,55.410000>0.698500}
cylinder{<99.570000,0.038000,60.490000><99.570000,-1.538000,60.490000>0.698500}
cylinder{<99.570000,0.038000,65.570000><99.570000,-1.538000,65.570000>0.698500}
cylinder{<99.570000,0.038000,70.650000><99.570000,-1.538000,70.650000>0.698500}
cylinder{<87.350600,0.038000,75.260200><87.350600,-1.538000,75.260200>0.698500}
cylinder{<82.270600,0.038000,75.260200><82.270600,-1.538000,75.260200>0.698500}
cylinder{<77.190600,0.038000,75.260200><77.190600,-1.538000,75.260200>0.698500}
cylinder{<72.110600,0.038000,75.260200><72.110600,-1.538000,75.260200>0.698500}
cylinder{<67.030600,0.038000,75.260200><67.030600,-1.538000,75.260200>0.698500}
cylinder{<61.950600,0.038000,75.260200><61.950600,-1.538000,75.260200>0.698500}
cylinder{<56.870600,0.038000,75.260200><56.870600,-1.538000,75.260200>0.698500}
cylinder{<51.790600,0.038000,75.260200><51.790600,-1.538000,75.260200>0.698500}
cylinder{<46.710600,0.038000,75.260200><46.710600,-1.538000,75.260200>0.698500}
cylinder{<41.630600,0.038000,75.260200><41.630600,-1.538000,75.260200>0.698500}
cylinder{<36.550600,0.038000,75.260200><36.550600,-1.538000,75.260200>0.698500}
cylinder{<31.470600,0.038000,75.260200><31.470600,-1.538000,75.260200>0.698500}
cylinder{<31.724600,0.038000,10.134600><31.724600,-1.538000,10.134600>0.698500}
cylinder{<36.804600,0.038000,10.134600><36.804600,-1.538000,10.134600>0.698500}
cylinder{<41.884600,0.038000,10.134600><41.884600,-1.538000,10.134600>0.698500}
cylinder{<46.964600,0.038000,10.134600><46.964600,-1.538000,10.134600>0.698500}
cylinder{<52.044600,0.038000,10.134600><52.044600,-1.538000,10.134600>0.698500}
cylinder{<57.124600,0.038000,10.134600><57.124600,-1.538000,10.134600>0.698500}
cylinder{<62.204600,0.038000,10.134600><62.204600,-1.538000,10.134600>0.698500}
cylinder{<67.284600,0.038000,10.134600><67.284600,-1.538000,10.134600>0.698500}
cylinder{<72.364600,0.038000,10.134600><72.364600,-1.538000,10.134600>0.698500}
cylinder{<77.444600,0.038000,10.134600><77.444600,-1.538000,10.134600>0.698500}
cylinder{<82.524600,0.038000,10.134600><82.524600,-1.538000,10.134600>0.698500}
cylinder{<87.604600,0.038000,10.134600><87.604600,-1.538000,10.134600>0.698500}
//Holes(fast)/Vias
cylinder{<65.024000,0.038000,14.224000><65.024000,-1.538000,14.224000>0.304800 }
//Holes(fast)/Board
texture{col_hls}
}
#if(pcb_silkscreen=on)
//Silk Screen
union{
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.631500,0.000000,22.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.800800,0.000000,22.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<36.631500,0.000000,22.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.800800,0.000000,22.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.800800,0.000000,23.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<37.800800,0.000000,23.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.800800,0.000000,23.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.606000,0.000000,23.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<37.606000,0.000000,23.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.606000,0.000000,23.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.826400,0.000000,23.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<36.826400,0.000000,23.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.826400,0.000000,23.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.631500,0.000000,23.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<36.631500,0.000000,23.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.631500,0.000000,23.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.631500,0.000000,22.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<36.631500,0.000000,22.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.800800,0.000000,23.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.800800,0.000000,24.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<37.800800,0.000000,24.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.800800,0.000000,23.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.631500,0.000000,23.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<36.631500,0.000000,23.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.631500,0.000000,23.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.631500,0.000000,24.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<36.631500,0.000000,24.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.826400,0.000000,25.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.631500,0.000000,25.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<36.631500,0.000000,25.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.631500,0.000000,25.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.631500,0.000000,24.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<36.631500,0.000000,24.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.631500,0.000000,24.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.826400,0.000000,24.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<36.631500,0.000000,24.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.826400,0.000000,24.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.606000,0.000000,24.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<36.826400,0.000000,24.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.606000,0.000000,24.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.800800,0.000000,24.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<37.606000,0.000000,24.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.800800,0.000000,24.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.800800,0.000000,25.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<37.800800,0.000000,25.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.800800,0.000000,25.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.606000,0.000000,25.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<37.606000,0.000000,25.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.606000,0.000000,25.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.216200,0.000000,25.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<37.216200,0.000000,25.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.216200,0.000000,25.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.216200,0.000000,24.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<37.216200,0.000000,24.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.800800,0.000000,25.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.800800,0.000000,26.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<37.800800,0.000000,26.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.800800,0.000000,25.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.631500,0.000000,25.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<36.631500,0.000000,25.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.631500,0.000000,25.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.631500,0.000000,26.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<36.631500,0.000000,26.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.021300,0.000000,27.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.631500,0.000000,28.013000>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<36.631500,0.000000,28.013000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.631500,0.000000,28.013000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.800800,0.000000,28.013000>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<36.631500,0.000000,28.013000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.800800,0.000000,27.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.800800,0.000000,28.402800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<37.800800,0.000000,28.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.826400,0.000000,28.792600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.631500,0.000000,28.987400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<36.631500,0.000000,28.987400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.631500,0.000000,28.987400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.631500,0.000000,29.377200>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<36.631500,0.000000,29.377200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.631500,0.000000,29.377200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.826400,0.000000,29.572100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<36.631500,0.000000,29.377200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.826400,0.000000,29.572100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.021300,0.000000,29.572100>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<36.826400,0.000000,29.572100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.021300,0.000000,29.572100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.216200,0.000000,29.377200>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<37.021300,0.000000,29.572100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.216200,0.000000,29.377200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.216200,0.000000,29.182300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<37.216200,0.000000,29.182300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.216200,0.000000,29.377200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.411100,0.000000,29.572100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<37.216200,0.000000,29.377200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.411100,0.000000,29.572100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.606000,0.000000,29.572100>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<37.411100,0.000000,29.572100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.606000,0.000000,29.572100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.800800,0.000000,29.377200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<37.606000,0.000000,29.572100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.800800,0.000000,29.377200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.800800,0.000000,28.987400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<37.800800,0.000000,28.987400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.800800,0.000000,28.987400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.606000,0.000000,28.792600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<37.606000,0.000000,28.792600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.838500,0.000000,22.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.007800,0.000000,22.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<41.838500,0.000000,22.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.007800,0.000000,22.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.007800,0.000000,23.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<43.007800,0.000000,23.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.007800,0.000000,23.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.813000,0.000000,23.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<42.813000,0.000000,23.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.813000,0.000000,23.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.033400,0.000000,23.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<42.033400,0.000000,23.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.033400,0.000000,23.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.838500,0.000000,23.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<41.838500,0.000000,23.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.838500,0.000000,23.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.838500,0.000000,22.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<41.838500,0.000000,22.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.007800,0.000000,23.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.007800,0.000000,24.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<43.007800,0.000000,24.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.007800,0.000000,23.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.838500,0.000000,23.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<41.838500,0.000000,23.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.838500,0.000000,23.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.838500,0.000000,24.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<41.838500,0.000000,24.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.033400,0.000000,25.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.838500,0.000000,25.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<41.838500,0.000000,25.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.838500,0.000000,25.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.838500,0.000000,24.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<41.838500,0.000000,24.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.838500,0.000000,24.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.033400,0.000000,24.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<41.838500,0.000000,24.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.033400,0.000000,24.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.813000,0.000000,24.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<42.033400,0.000000,24.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.813000,0.000000,24.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.007800,0.000000,24.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<42.813000,0.000000,24.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.007800,0.000000,24.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.007800,0.000000,25.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<43.007800,0.000000,25.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.007800,0.000000,25.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.813000,0.000000,25.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<42.813000,0.000000,25.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.813000,0.000000,25.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.423200,0.000000,25.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<42.423200,0.000000,25.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.423200,0.000000,25.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.423200,0.000000,24.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<42.423200,0.000000,24.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.007800,0.000000,25.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.007800,0.000000,26.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<43.007800,0.000000,26.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.007800,0.000000,25.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.838500,0.000000,25.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<41.838500,0.000000,25.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.838500,0.000000,25.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.838500,0.000000,26.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<41.838500,0.000000,26.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.228300,0.000000,27.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.838500,0.000000,28.013000>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<41.838500,0.000000,28.013000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.838500,0.000000,28.013000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.007800,0.000000,28.013000>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<41.838500,0.000000,28.013000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.007800,0.000000,27.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.007800,0.000000,28.402800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<43.007800,0.000000,28.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.007800,0.000000,29.572100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.007800,0.000000,28.792600>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<43.007800,0.000000,28.792600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.007800,0.000000,28.792600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.228300,0.000000,29.572100>}
box{<0,0,-0.050800><1.102379,0.036000,0.050800> rotate<0,44.997030,0> translate<42.228300,0.000000,29.572100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.228300,0.000000,29.572100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.033400,0.000000,29.572100>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<42.033400,0.000000,29.572100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.033400,0.000000,29.572100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.838500,0.000000,29.377200>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<41.838500,0.000000,29.377200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.838500,0.000000,29.377200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.838500,0.000000,28.987400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<41.838500,0.000000,28.987400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.838500,0.000000,28.987400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.033400,0.000000,28.792600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<41.838500,0.000000,28.987400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.588300,0.000000,58.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.757600,0.000000,58.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<30.588300,0.000000,58.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.757600,0.000000,58.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.757600,0.000000,59.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<31.757600,0.000000,59.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.757600,0.000000,59.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.562800,0.000000,59.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<31.562800,0.000000,59.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.562800,0.000000,59.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.783200,0.000000,59.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<30.783200,0.000000,59.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.783200,0.000000,59.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.588300,0.000000,59.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<30.588300,0.000000,59.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.588300,0.000000,59.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.588300,0.000000,58.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<30.588300,0.000000,58.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.757600,0.000000,59.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.757600,0.000000,60.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<31.757600,0.000000,60.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.757600,0.000000,59.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.588300,0.000000,59.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<30.588300,0.000000,59.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.588300,0.000000,59.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.588300,0.000000,60.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<30.588300,0.000000,60.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.783200,0.000000,61.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.588300,0.000000,61.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<30.588300,0.000000,61.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.588300,0.000000,61.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.588300,0.000000,60.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<30.588300,0.000000,60.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.588300,0.000000,60.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.783200,0.000000,60.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<30.588300,0.000000,60.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.783200,0.000000,60.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.562800,0.000000,60.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<30.783200,0.000000,60.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.562800,0.000000,60.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.757600,0.000000,60.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<31.562800,0.000000,60.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.757600,0.000000,60.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.757600,0.000000,61.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<31.757600,0.000000,61.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.757600,0.000000,61.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.562800,0.000000,61.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<31.562800,0.000000,61.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.562800,0.000000,61.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.173000,0.000000,61.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<31.173000,0.000000,61.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.173000,0.000000,61.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.173000,0.000000,60.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<31.173000,0.000000,60.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.757600,0.000000,61.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.757600,0.000000,62.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<31.757600,0.000000,62.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.757600,0.000000,61.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.588300,0.000000,61.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<30.588300,0.000000,61.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.588300,0.000000,61.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.588300,0.000000,62.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<30.588300,0.000000,62.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.978100,0.000000,63.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.588300,0.000000,64.013000>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<30.588300,0.000000,64.013000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.588300,0.000000,64.013000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.757600,0.000000,64.013000>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<30.588300,0.000000,64.013000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.757600,0.000000,63.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.757600,0.000000,64.402800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<31.757600,0.000000,64.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.978100,0.000000,64.792600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.588300,0.000000,65.182300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<30.588300,0.000000,65.182300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.588300,0.000000,65.182300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.757600,0.000000,65.182300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<30.588300,0.000000,65.182300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.757600,0.000000,64.792600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.757600,0.000000,65.572100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<31.757600,0.000000,65.572100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.922300,0.000000,58.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.091600,0.000000,58.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<35.922300,0.000000,58.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.091600,0.000000,58.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.091600,0.000000,59.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<37.091600,0.000000,59.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.091600,0.000000,59.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.896800,0.000000,59.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<36.896800,0.000000,59.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.896800,0.000000,59.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.117200,0.000000,59.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<36.117200,0.000000,59.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.117200,0.000000,59.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.922300,0.000000,59.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<35.922300,0.000000,59.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.922300,0.000000,59.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.922300,0.000000,58.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<35.922300,0.000000,58.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.091600,0.000000,59.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.091600,0.000000,60.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<37.091600,0.000000,60.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.091600,0.000000,59.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.922300,0.000000,59.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<35.922300,0.000000,59.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.922300,0.000000,59.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.922300,0.000000,60.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<35.922300,0.000000,60.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.117200,0.000000,61.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.922300,0.000000,61.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<35.922300,0.000000,61.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.922300,0.000000,61.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.922300,0.000000,60.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<35.922300,0.000000,60.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.922300,0.000000,60.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.117200,0.000000,60.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<35.922300,0.000000,60.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.117200,0.000000,60.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.896800,0.000000,60.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<36.117200,0.000000,60.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.896800,0.000000,60.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.091600,0.000000,60.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<36.896800,0.000000,60.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.091600,0.000000,60.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.091600,0.000000,61.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<37.091600,0.000000,61.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.091600,0.000000,61.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.896800,0.000000,61.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<36.896800,0.000000,61.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.896800,0.000000,61.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.507000,0.000000,61.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<36.507000,0.000000,61.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.507000,0.000000,61.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.507000,0.000000,60.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<36.507000,0.000000,60.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.091600,0.000000,61.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.091600,0.000000,62.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<37.091600,0.000000,62.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.091600,0.000000,61.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.922300,0.000000,61.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<35.922300,0.000000,61.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.922300,0.000000,61.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.922300,0.000000,62.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<35.922300,0.000000,62.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.312100,0.000000,63.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.922300,0.000000,64.013000>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<35.922300,0.000000,64.013000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.922300,0.000000,64.013000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.091600,0.000000,64.013000>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<35.922300,0.000000,64.013000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.091600,0.000000,63.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.091600,0.000000,64.402800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<37.091600,0.000000,64.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.896800,0.000000,64.792600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.117200,0.000000,64.792600>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<36.117200,0.000000,64.792600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.117200,0.000000,64.792600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.922300,0.000000,64.987400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<35.922300,0.000000,64.987400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.922300,0.000000,64.987400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.922300,0.000000,65.377200>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<35.922300,0.000000,65.377200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.922300,0.000000,65.377200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.117200,0.000000,65.572100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<35.922300,0.000000,65.377200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.117200,0.000000,65.572100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.896800,0.000000,65.572100>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<36.117200,0.000000,65.572100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.896800,0.000000,65.572100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.091600,0.000000,65.377200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<36.896800,0.000000,65.572100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.091600,0.000000,65.377200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.091600,0.000000,64.987400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<37.091600,0.000000,64.987400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.091600,0.000000,64.987400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.896800,0.000000,64.792600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<36.896800,0.000000,64.792600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.896800,0.000000,64.792600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.117200,0.000000,65.572100>}
box{<0,0,-0.050800><1.102450,0.036000,0.050800> rotate<0,44.993355,0> translate<36.117200,0.000000,65.572100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.672100,0.000000,58.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.841400,0.000000,58.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<40.672100,0.000000,58.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.841400,0.000000,58.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.841400,0.000000,59.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<41.841400,0.000000,59.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.841400,0.000000,59.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.646600,0.000000,59.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<41.646600,0.000000,59.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.646600,0.000000,59.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.867000,0.000000,59.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<40.867000,0.000000,59.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.867000,0.000000,59.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.672100,0.000000,59.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<40.672100,0.000000,59.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.672100,0.000000,59.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.672100,0.000000,58.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<40.672100,0.000000,58.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.841400,0.000000,59.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.841400,0.000000,60.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<41.841400,0.000000,60.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.841400,0.000000,59.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.672100,0.000000,59.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<40.672100,0.000000,59.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.672100,0.000000,59.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.672100,0.000000,60.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<40.672100,0.000000,60.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.867000,0.000000,61.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.672100,0.000000,61.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<40.672100,0.000000,61.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.672100,0.000000,61.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.672100,0.000000,60.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<40.672100,0.000000,60.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.672100,0.000000,60.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.867000,0.000000,60.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<40.672100,0.000000,60.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.867000,0.000000,60.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.646600,0.000000,60.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<40.867000,0.000000,60.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.646600,0.000000,60.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.841400,0.000000,60.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<41.646600,0.000000,60.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.841400,0.000000,60.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.841400,0.000000,61.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<41.841400,0.000000,61.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.841400,0.000000,61.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.646600,0.000000,61.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<41.646600,0.000000,61.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.646600,0.000000,61.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.256800,0.000000,61.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<41.256800,0.000000,61.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.256800,0.000000,61.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.256800,0.000000,60.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<41.256800,0.000000,60.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.841400,0.000000,61.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.841400,0.000000,62.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<41.841400,0.000000,62.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.841400,0.000000,61.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.672100,0.000000,61.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<40.672100,0.000000,61.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.672100,0.000000,61.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.672100,0.000000,62.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<40.672100,0.000000,62.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.646600,0.000000,63.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.841400,0.000000,63.818100>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<41.646600,0.000000,63.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.841400,0.000000,63.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.841400,0.000000,64.207900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<41.841400,0.000000,64.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.841400,0.000000,64.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.646600,0.000000,64.402800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<41.646600,0.000000,64.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.646600,0.000000,64.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.867000,0.000000,64.402800>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<40.867000,0.000000,64.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.867000,0.000000,64.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.672100,0.000000,64.207900>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<40.672100,0.000000,64.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.672100,0.000000,64.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.672100,0.000000,63.818100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<40.672100,0.000000,63.818100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.672100,0.000000,63.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.867000,0.000000,63.623300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<40.672100,0.000000,63.818100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.867000,0.000000,63.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.061900,0.000000,63.623300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<40.867000,0.000000,63.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.061900,0.000000,63.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.256800,0.000000,63.818100>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<41.061900,0.000000,63.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.256800,0.000000,63.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.256800,0.000000,64.402800>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,90.000000,0> translate<41.256800,0.000000,64.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.980700,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.150000,0.000000,57.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<45.980700,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.150000,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.150000,0.000000,58.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<47.150000,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.150000,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.955200,0.000000,58.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<46.955200,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.955200,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.175600,0.000000,58.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<46.175600,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.175600,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.980700,0.000000,58.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<45.980700,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.980700,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.980700,0.000000,57.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<45.980700,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.150000,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.150000,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<47.150000,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.150000,0.000000,58.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.980700,0.000000,58.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<45.980700,0.000000,58.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.980700,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.980700,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<45.980700,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.175600,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.980700,0.000000,60.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<45.980700,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.980700,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.980700,0.000000,59.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<45.980700,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.980700,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.175600,0.000000,59.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<45.980700,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.175600,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.955200,0.000000,59.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<46.175600,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.955200,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.150000,0.000000,59.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<46.955200,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.150000,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.150000,0.000000,60.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<47.150000,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.150000,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.955200,0.000000,60.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<46.955200,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.955200,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.565400,0.000000,60.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<46.565400,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.565400,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.565400,0.000000,59.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<46.565400,0.000000,59.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.150000,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.150000,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<47.150000,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.150000,0.000000,60.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.980700,0.000000,60.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<45.980700,0.000000,60.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.980700,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.980700,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<45.980700,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.175600,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.980700,0.000000,62.818100>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<45.980700,0.000000,62.818100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.980700,0.000000,62.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.980700,0.000000,63.207900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<45.980700,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.980700,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.175600,0.000000,63.402800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<45.980700,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.175600,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.370500,0.000000,63.402800>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<46.175600,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.370500,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.565400,0.000000,63.207900>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<46.370500,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.565400,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.760300,0.000000,63.402800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<46.565400,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.760300,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.955200,0.000000,63.402800>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<46.760300,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.955200,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.150000,0.000000,63.207900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<46.955200,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.150000,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.150000,0.000000,62.818100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<47.150000,0.000000,62.818100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.150000,0.000000,62.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.955200,0.000000,62.623300>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<46.955200,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.955200,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.760300,0.000000,62.623300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<46.760300,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.760300,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.565400,0.000000,62.818100>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<46.565400,0.000000,62.818100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.565400,0.000000,62.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.370500,0.000000,62.623300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<46.370500,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.370500,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.175600,0.000000,62.623300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<46.175600,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.565400,0.000000,62.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.565400,0.000000,63.207900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<46.565400,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.341200,0.000000,57.095900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.171900,0.000000,57.095900>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<86.171900,0.000000,57.095900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.171900,0.000000,57.095900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.171900,0.000000,57.680500>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<86.171900,0.000000,57.680500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.171900,0.000000,57.680500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.366800,0.000000,57.875400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<86.171900,0.000000,57.680500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.366800,0.000000,57.875400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.756600,0.000000,57.875400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<86.366800,0.000000,57.875400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.756600,0.000000,57.875400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.951500,0.000000,57.680500>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<86.756600,0.000000,57.875400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.951500,0.000000,57.680500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.951500,0.000000,57.095900>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<86.951500,0.000000,57.095900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.951500,0.000000,57.485600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.341200,0.000000,57.875400>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<86.951500,0.000000,57.485600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.171900,0.000000,58.265200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.341200,0.000000,59.044700>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,-33.686713,0> translate<86.171900,0.000000,58.265200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.171900,0.000000,59.044700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.341200,0.000000,58.265200>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,33.686713,0> translate<86.171900,0.000000,59.044700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.341200,0.000000,59.434500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.171900,0.000000,60.214000>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,33.686713,0> translate<86.171900,0.000000,60.214000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.171900,0.000000,60.603800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.341200,0.000000,60.603800>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<86.171900,0.000000,60.603800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.341200,0.000000,60.603800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.341200,0.000000,61.188400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<87.341200,0.000000,61.188400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.341200,0.000000,61.188400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.146400,0.000000,61.383300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<87.146400,0.000000,61.383300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.146400,0.000000,61.383300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.366800,0.000000,61.383300>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<86.366800,0.000000,61.383300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.366800,0.000000,61.383300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.171900,0.000000,61.188400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<86.171900,0.000000,61.188400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.171900,0.000000,61.188400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.171900,0.000000,60.603800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<86.171900,0.000000,60.603800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.146400,0.000000,61.773100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.366800,0.000000,61.773100>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<86.366800,0.000000,61.773100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.366800,0.000000,61.773100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.171900,0.000000,61.967900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<86.171900,0.000000,61.967900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.171900,0.000000,61.967900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.171900,0.000000,62.357700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<86.171900,0.000000,62.357700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.171900,0.000000,62.357700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.366800,0.000000,62.552600>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<86.171900,0.000000,62.357700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.366800,0.000000,62.552600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.146400,0.000000,62.552600>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<86.366800,0.000000,62.552600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.146400,0.000000,62.552600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.341200,0.000000,62.357700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<87.146400,0.000000,62.552600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.341200,0.000000,62.357700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.341200,0.000000,61.967900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<87.341200,0.000000,61.967900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.341200,0.000000,61.967900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.146400,0.000000,61.773100>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<87.146400,0.000000,61.773100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.146400,0.000000,61.773100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.366800,0.000000,62.552600>}
box{<0,0,-0.050800><1.102450,0.036000,0.050800> rotate<0,44.993355,0> translate<86.366800,0.000000,62.552600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,57.638000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,57.638000>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<81.787100,0.000000,57.638000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,57.248300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,58.027800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<81.787100,0.000000,58.027800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,58.417600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,59.197100>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,-33.686713,0> translate<81.787100,0.000000,58.417600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,59.197100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,58.417600>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,33.686713,0> translate<81.787100,0.000000,59.197100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,59.586900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,60.366400>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,33.686713,0> translate<81.787100,0.000000,60.366400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,60.756200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,60.756200>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<81.787100,0.000000,60.756200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,60.756200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,61.340800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<82.956400,0.000000,61.340800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,61.340800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.761600,0.000000,61.535700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<82.761600,0.000000,61.535700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.761600,0.000000,61.535700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.982000,0.000000,61.535700>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<81.982000,0.000000,61.535700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.982000,0.000000,61.535700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,61.340800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<81.787100,0.000000,61.340800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,61.340800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,60.756200>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<81.787100,0.000000,60.756200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.176900,0.000000,61.925500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,62.315200>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<81.787100,0.000000,62.315200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,62.315200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,62.315200>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<81.787100,0.000000,62.315200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,61.925500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,62.705000>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<82.956400,0.000000,62.705000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.075900,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.245200,0.000000,57.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<72.075900,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.245200,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.245200,0.000000,58.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<73.245200,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.245200,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.050400,0.000000,58.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<73.050400,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.050400,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.270800,0.000000,58.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<72.270800,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.270800,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.075900,0.000000,58.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<72.075900,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.075900,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.075900,0.000000,57.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<72.075900,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.245200,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.245200,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<73.245200,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.245200,0.000000,58.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.075900,0.000000,58.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<72.075900,0.000000,58.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.075900,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.075900,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<72.075900,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.270800,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.075900,0.000000,60.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<72.075900,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.075900,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.075900,0.000000,59.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<72.075900,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.075900,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.270800,0.000000,59.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<72.075900,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.270800,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.050400,0.000000,59.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<72.270800,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.050400,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.245200,0.000000,59.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<73.050400,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.245200,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.245200,0.000000,60.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<73.245200,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.245200,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.050400,0.000000,60.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<73.050400,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.050400,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.660600,0.000000,60.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<72.660600,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.660600,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.660600,0.000000,59.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<72.660600,0.000000,59.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.245200,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.245200,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<73.245200,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.245200,0.000000,60.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.075900,0.000000,60.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<72.075900,0.000000,60.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.075900,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.075900,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<72.075900,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.270800,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.075900,0.000000,62.818100>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<72.075900,0.000000,62.818100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.075900,0.000000,62.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.075900,0.000000,63.207900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<72.075900,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.075900,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.270800,0.000000,63.402800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<72.075900,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.270800,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.465700,0.000000,63.402800>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<72.270800,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.465700,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.660600,0.000000,63.207900>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<72.465700,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.660600,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.660600,0.000000,63.013000>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<72.660600,0.000000,63.013000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.660600,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.855500,0.000000,63.402800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<72.660600,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.855500,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.050400,0.000000,63.402800>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<72.855500,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.050400,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.245200,0.000000,63.207900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<73.050400,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.245200,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.245200,0.000000,62.818100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<73.245200,0.000000,62.818100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.245200,0.000000,62.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.050400,0.000000,62.623300>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<73.050400,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.884900,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.054200,0.000000,57.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<66.884900,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.054200,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.054200,0.000000,58.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<68.054200,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.054200,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.859400,0.000000,58.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<67.859400,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.859400,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.079800,0.000000,58.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<67.079800,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.079800,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.884900,0.000000,58.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<66.884900,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.884900,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.884900,0.000000,57.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<66.884900,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.054200,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.054200,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<68.054200,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.054200,0.000000,58.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.884900,0.000000,58.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<66.884900,0.000000,58.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.884900,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.884900,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<66.884900,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.079800,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.884900,0.000000,60.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<66.884900,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.884900,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.884900,0.000000,59.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<66.884900,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.884900,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.079800,0.000000,59.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<66.884900,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.079800,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.859400,0.000000,59.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<67.079800,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.859400,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.054200,0.000000,59.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<67.859400,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.054200,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.054200,0.000000,60.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<68.054200,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.054200,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.859400,0.000000,60.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<67.859400,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.859400,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.469600,0.000000,60.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<67.469600,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.469600,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.469600,0.000000,59.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<67.469600,0.000000,59.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.054200,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.054200,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<68.054200,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.054200,0.000000,60.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.884900,0.000000,60.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<66.884900,0.000000,60.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.884900,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.884900,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<66.884900,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.054200,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.884900,0.000000,63.207900>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<66.884900,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.884900,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.469600,0.000000,62.623300>}
box{<0,0,-0.050800><0.826820,0.036000,0.050800> rotate<0,44.992130,0> translate<66.884900,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.469600,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.469600,0.000000,63.402800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<67.469600,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.169900,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.339200,0.000000,57.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<61.169900,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.339200,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.339200,0.000000,58.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<62.339200,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.339200,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.144400,0.000000,58.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<62.144400,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.144400,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.364800,0.000000,58.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<61.364800,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.364800,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.169900,0.000000,58.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<61.169900,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.169900,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.169900,0.000000,57.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<61.169900,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.339200,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.339200,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<62.339200,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.339200,0.000000,58.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.169900,0.000000,58.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<61.169900,0.000000,58.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.169900,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.169900,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<61.169900,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.364800,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.169900,0.000000,60.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<61.169900,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.169900,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.169900,0.000000,59.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<61.169900,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.169900,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.364800,0.000000,59.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<61.169900,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.364800,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.144400,0.000000,59.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<61.364800,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.144400,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.339200,0.000000,59.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<62.144400,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.339200,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.339200,0.000000,60.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<62.339200,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.339200,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.144400,0.000000,60.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<62.144400,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.144400,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.754600,0.000000,60.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<61.754600,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.754600,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.754600,0.000000,59.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<61.754600,0.000000,59.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.339200,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.339200,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<62.339200,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.339200,0.000000,60.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.169900,0.000000,60.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<61.169900,0.000000,60.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.169900,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.169900,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<61.169900,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.169900,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.169900,0.000000,62.623300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<61.169900,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.169900,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.754600,0.000000,62.623300>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,0.000000,0> translate<61.169900,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.754600,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.559700,0.000000,63.013000>}
box{<0,0,-0.050800><0.435720,0.036000,0.050800> rotate<0,63.424882,0> translate<61.559700,0.000000,63.013000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.559700,0.000000,63.013000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.559700,0.000000,63.207900>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,90.000000,0> translate<61.559700,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.559700,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.754600,0.000000,63.402800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<61.559700,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.754600,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.144400,0.000000,63.402800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<61.754600,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.144400,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.339200,0.000000,63.207900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<62.144400,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.339200,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.339200,0.000000,62.818100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<62.339200,0.000000,62.818100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.339200,0.000000,62.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.144400,0.000000,62.623300>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<62.144400,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.810500,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.979800,0.000000,57.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<55.810500,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.979800,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.979800,0.000000,58.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<56.979800,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.979800,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.785000,0.000000,58.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<56.785000,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.785000,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.005400,0.000000,58.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<56.005400,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.005400,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.810500,0.000000,58.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<55.810500,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.810500,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.810500,0.000000,57.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<55.810500,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.979800,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.979800,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<56.979800,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.979800,0.000000,58.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.810500,0.000000,58.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<55.810500,0.000000,58.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.810500,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.810500,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<55.810500,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.005400,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.810500,0.000000,60.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<55.810500,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.810500,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.810500,0.000000,59.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<55.810500,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.810500,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.005400,0.000000,59.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<55.810500,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.005400,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.785000,0.000000,59.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<56.005400,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.785000,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.979800,0.000000,59.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<56.785000,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.979800,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.979800,0.000000,60.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<56.979800,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.979800,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.785000,0.000000,60.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<56.785000,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.785000,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.395200,0.000000,60.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<56.395200,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.395200,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.395200,0.000000,59.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<56.395200,0.000000,59.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.979800,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.979800,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<56.979800,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.979800,0.000000,60.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.810500,0.000000,60.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<55.810500,0.000000,60.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.810500,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.810500,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<55.810500,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.810500,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.005400,0.000000,63.013000>}
box{<0,0,-0.050800><0.435810,0.036000,0.050800> rotate<0,63.430762,0> translate<55.810500,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.005400,0.000000,63.013000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.395200,0.000000,62.623300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<56.005400,0.000000,63.013000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.395200,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.785000,0.000000,62.623300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<56.395200,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.785000,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.979800,0.000000,62.818100>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<56.785000,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.979800,0.000000,62.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.979800,0.000000,63.207900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<56.979800,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.979800,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.785000,0.000000,63.402800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<56.785000,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.785000,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.590100,0.000000,63.402800>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<56.590100,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.590100,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.395200,0.000000,63.207900>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<56.395200,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.395200,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.395200,0.000000,62.623300>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<56.395200,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.416300,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.585600,0.000000,57.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<51.416300,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.585600,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.585600,0.000000,58.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<52.585600,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.585600,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.390800,0.000000,58.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<52.390800,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.390800,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.611200,0.000000,58.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<51.611200,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.611200,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.416300,0.000000,58.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<51.416300,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.416300,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.416300,0.000000,57.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<51.416300,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.585600,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.585600,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<52.585600,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.585600,0.000000,58.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.416300,0.000000,58.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<51.416300,0.000000,58.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.416300,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.416300,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<51.416300,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.611200,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.416300,0.000000,60.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<51.416300,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.416300,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.416300,0.000000,59.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<51.416300,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.416300,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.611200,0.000000,59.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<51.416300,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.611200,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.390800,0.000000,59.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<51.611200,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.390800,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.585600,0.000000,59.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<52.390800,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.585600,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.585600,0.000000,60.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<52.585600,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.585600,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.390800,0.000000,60.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<52.390800,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.390800,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.001000,0.000000,60.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<52.001000,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.001000,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.001000,0.000000,59.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<52.001000,0.000000,59.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.585600,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.585600,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<52.585600,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.585600,0.000000,60.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.416300,0.000000,60.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<51.416300,0.000000,60.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.416300,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.416300,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<51.416300,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.416300,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.416300,0.000000,63.402800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<51.416300,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.416300,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.611200,0.000000,63.402800>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<51.416300,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.611200,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.390800,0.000000,62.623300>}
box{<0,0,-0.050800><1.102450,0.036000,0.050800> rotate<0,44.993355,0> translate<51.611200,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.390800,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.585600,0.000000,62.623300>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<52.390800,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.044900,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.044900,0.000000,53.904100>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<29.044900,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.044900,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.714300,0.000000,54.573600>}
box{<0,0,-0.088900><0.946745,0.036000,0.088900> rotate<0,-45.001309,0> translate<29.044900,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.714300,0.000000,54.573600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.383700,0.000000,53.904100>}
box{<0,0,-0.088900><0.946745,0.036000,0.088900> rotate<0,45.001309,0> translate<29.714300,0.000000,54.573600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.383700,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.383700,0.000000,52.565300>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<30.383700,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.044900,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.383700,0.000000,53.569400>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<29.044900,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.056200,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.056200,0.000000,53.904100>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<31.056200,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.056200,0.000000,53.234700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.725600,0.000000,53.904100>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<31.056200,0.000000,53.234700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.725600,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.060300,0.000000,53.904100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<31.725600,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.071100,0.000000,54.573600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.071100,0.000000,52.565300>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,-90.000000,0> translate<34.071100,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.071100,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.067000,0.000000,52.565300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<33.067000,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.067000,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.732300,0.000000,52.900000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<32.732300,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.732300,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.732300,0.000000,53.569400>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<32.732300,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.732300,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.067000,0.000000,53.904100>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<32.732300,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.067000,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.071100,0.000000,53.904100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<33.067000,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.743600,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.743600,0.000000,52.900000>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<34.743600,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.743600,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.078300,0.000000,52.565300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<34.743600,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.078300,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.082400,0.000000,52.565300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<35.078300,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.082400,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.082400,0.000000,53.904100>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<36.082400,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.754900,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.089600,0.000000,53.904100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<36.754900,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.089600,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.089600,0.000000,52.565300>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<37.089600,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.754900,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.424300,0.000000,52.565300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<36.754900,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.089600,0.000000,54.908300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.089600,0.000000,54.573600>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<37.089600,0.000000,54.573600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.095800,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.095800,0.000000,53.904100>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<38.095800,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.095800,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.099900,0.000000,53.904100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<38.095800,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.099900,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.434600,0.000000,53.569400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<39.099900,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.434600,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.434600,0.000000,52.565300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<39.434600,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.441800,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.111200,0.000000,52.565300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<40.441800,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.111200,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.445900,0.000000,52.900000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<41.111200,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.445900,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.445900,0.000000,53.569400>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<41.445900,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.445900,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.111200,0.000000,53.904100>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<41.111200,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.111200,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.441800,0.000000,53.904100>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<40.441800,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.441800,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.107100,0.000000,53.569400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<40.107100,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.107100,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.107100,0.000000,52.900000>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<40.107100,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.107100,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.441800,0.000000,52.565300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<40.107100,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.129700,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.129700,0.000000,54.573600>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,90.000000,0> translate<44.129700,0.000000,54.573600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.129700,0.000000,54.573600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.133800,0.000000,54.573600>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<44.129700,0.000000,54.573600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.133800,0.000000,54.573600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.468500,0.000000,54.238800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<45.133800,0.000000,54.573600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.468500,0.000000,54.238800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.468500,0.000000,53.904100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<45.468500,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.468500,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.133800,0.000000,53.569400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<45.133800,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.133800,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.468500,0.000000,53.234700>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<45.133800,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.468500,0.000000,53.234700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.468500,0.000000,52.900000>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<45.468500,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.468500,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.133800,0.000000,52.565300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<45.133800,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.133800,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.129700,0.000000,52.565300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<44.129700,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.129700,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.133800,0.000000,53.569400>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<44.129700,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.141000,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.141000,0.000000,53.904100>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<46.141000,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.141000,0.000000,53.234700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.810400,0.000000,53.904100>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<46.141000,0.000000,53.234700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.810400,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.145100,0.000000,53.904100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<46.810400,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.821200,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.151800,0.000000,52.565300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<48.151800,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.151800,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.817100,0.000000,52.900000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<47.817100,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.817100,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.817100,0.000000,53.569400>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<47.817100,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.817100,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.151800,0.000000,53.904100>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<47.817100,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.151800,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.821200,0.000000,53.904100>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<48.151800,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.821200,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.155900,0.000000,53.569400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<48.821200,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.155900,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.155900,0.000000,53.234700>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<49.155900,0.000000,53.234700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.155900,0.000000,53.234700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.817100,0.000000,53.234700>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<47.817100,0.000000,53.234700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.163100,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.832500,0.000000,53.904100>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<50.163100,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.832500,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.167200,0.000000,53.569400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<50.832500,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.167200,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.167200,0.000000,52.565300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<51.167200,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.167200,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.163100,0.000000,52.565300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<50.163100,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.163100,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.828400,0.000000,52.900000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<49.828400,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.828400,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.163100,0.000000,53.234700>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<49.828400,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.163100,0.000000,53.234700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.167200,0.000000,53.234700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<50.163100,0.000000,53.234700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.839700,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.839700,0.000000,54.573600>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,90.000000,0> translate<51.839700,0.000000,54.573600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.843800,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.839700,0.000000,53.234700>}
box{<0,0,-0.088900><1.206778,0.036000,0.088900> rotate<0,33.687844,0> translate<51.839700,0.000000,53.234700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.839700,0.000000,53.234700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.843800,0.000000,53.904100>}
box{<0,0,-0.088900><1.206778,0.036000,0.088900> rotate<0,-33.687844,0> translate<51.839700,0.000000,53.234700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.850500,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.519900,0.000000,52.565300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<53.850500,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.519900,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.854600,0.000000,52.900000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<54.519900,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.854600,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.854600,0.000000,53.569400>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<54.854600,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.854600,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.519900,0.000000,53.904100>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<54.519900,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.519900,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.850500,0.000000,53.904100>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<53.850500,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.850500,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.515800,0.000000,53.569400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<53.515800,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.515800,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.515800,0.000000,52.900000>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<53.515800,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.515800,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.850500,0.000000,52.565300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<53.515800,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.527100,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.527100,0.000000,52.900000>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<55.527100,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.527100,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.861800,0.000000,52.565300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<55.527100,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.861800,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.865900,0.000000,52.565300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<55.861800,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.865900,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.865900,0.000000,53.904100>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<56.865900,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.873100,0.000000,54.238800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.873100,0.000000,52.900000>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<57.873100,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.873100,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.207800,0.000000,52.565300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<57.873100,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.538400,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.207800,0.000000,53.904100>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<57.538400,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.890600,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.560000,0.000000,52.565300>}
box{<0,0,-0.088900><1.496824,0.036000,0.088900> rotate<0,63.430762,0> translate<60.890600,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.560000,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.229400,0.000000,53.904100>}
box{<0,0,-0.088900><1.496824,0.036000,0.088900> rotate<0,-63.430762,0> translate<61.560000,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.901900,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.571300,0.000000,54.573600>}
box{<0,0,-0.088900><0.946745,0.036000,0.088900> rotate<0,-45.001309,0> translate<62.901900,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.571300,0.000000,54.573600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.571300,0.000000,52.565300>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,-90.000000,0> translate<63.571300,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.901900,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.240700,0.000000,52.565300>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<62.901900,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.913200,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.913200,0.000000,52.900000>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<64.913200,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.913200,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.247900,0.000000,52.900000>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<64.913200,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.247900,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.247900,0.000000,52.565300>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<65.247900,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.247900,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.913200,0.000000,52.565300>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<64.913200,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.918800,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.588200,0.000000,54.573600>}
box{<0,0,-0.088900><0.946745,0.036000,0.088900> rotate<0,-45.001309,0> translate<65.918800,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.588200,0.000000,54.573600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.588200,0.000000,52.565300>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,-90.000000,0> translate<66.588200,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.918800,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<67.257600,0.000000,52.565300>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<65.918800,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.400500,0.000000,44.616800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.400500,0.000000,42.608500>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,-90.000000,0> translate<29.400500,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.400500,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.739300,0.000000,42.608500>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<29.400500,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.411800,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.746500,0.000000,43.947300>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<31.411800,0.000000,43.947300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.746500,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.746500,0.000000,42.608500>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<31.746500,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.411800,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.081200,0.000000,42.608500>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<31.411800,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.746500,0.000000,44.951500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.746500,0.000000,44.616800>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<31.746500,0.000000,44.616800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.091500,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.087400,0.000000,43.947300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<33.087400,0.000000,43.947300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.087400,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.752700,0.000000,43.612600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<32.752700,0.000000,43.612600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.752700,0.000000,43.612600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.752700,0.000000,42.943200>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<32.752700,0.000000,42.943200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.752700,0.000000,42.943200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.087400,0.000000,42.608500>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<32.752700,0.000000,42.943200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.087400,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.091500,0.000000,42.608500>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<33.087400,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.768100,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.098700,0.000000,42.608500>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<35.098700,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.098700,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.764000,0.000000,42.943200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<34.764000,0.000000,42.943200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.764000,0.000000,42.943200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.764000,0.000000,43.612600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<34.764000,0.000000,43.612600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.764000,0.000000,43.612600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.098700,0.000000,43.947300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<34.764000,0.000000,43.612600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.098700,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.768100,0.000000,43.947300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<35.098700,0.000000,43.947300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.768100,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.102800,0.000000,43.612600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<35.768100,0.000000,43.947300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.102800,0.000000,43.612600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.102800,0.000000,43.277900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<36.102800,0.000000,43.277900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.102800,0.000000,43.277900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.764000,0.000000,43.277900>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<34.764000,0.000000,43.277900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.775300,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.775300,0.000000,43.947300>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<36.775300,0.000000,43.947300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.775300,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.779400,0.000000,43.947300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<36.775300,0.000000,43.947300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.779400,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.114100,0.000000,43.612600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<37.779400,0.000000,43.947300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.114100,0.000000,43.612600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.114100,0.000000,42.608500>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<38.114100,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.786600,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.790700,0.000000,42.608500>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<38.786600,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.790700,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.125400,0.000000,42.943200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<39.790700,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.125400,0.000000,42.943200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.790700,0.000000,43.277900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<39.790700,0.000000,43.277900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.790700,0.000000,43.277900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.121300,0.000000,43.277900>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<39.121300,0.000000,43.277900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.121300,0.000000,43.277900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.786600,0.000000,43.612600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<38.786600,0.000000,43.612600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.786600,0.000000,43.612600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.121300,0.000000,43.947300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<38.786600,0.000000,43.612600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.121300,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.125400,0.000000,43.947300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<39.121300,0.000000,43.947300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.802000,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.132600,0.000000,42.608500>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<41.132600,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.132600,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.797900,0.000000,42.943200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<40.797900,0.000000,42.943200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.797900,0.000000,42.943200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.797900,0.000000,43.612600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<40.797900,0.000000,43.612600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.797900,0.000000,43.612600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.132600,0.000000,43.947300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<40.797900,0.000000,43.612600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.132600,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.802000,0.000000,43.947300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<41.132600,0.000000,43.947300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.802000,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.136700,0.000000,43.612600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<41.802000,0.000000,43.947300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.136700,0.000000,43.612600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.136700,0.000000,43.277900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<42.136700,0.000000,43.277900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.136700,0.000000,43.277900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.797900,0.000000,43.277900>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<40.797900,0.000000,43.277900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.159300,0.000000,44.282000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.824600,0.000000,44.616800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<45.824600,0.000000,44.616800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.824600,0.000000,44.616800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.155200,0.000000,44.616800>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<45.155200,0.000000,44.616800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.155200,0.000000,44.616800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.820500,0.000000,44.282000>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,-45.005588,0> translate<44.820500,0.000000,44.282000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.820500,0.000000,44.282000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.820500,0.000000,42.943200>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<44.820500,0.000000,42.943200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.820500,0.000000,42.943200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.155200,0.000000,42.608500>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<44.820500,0.000000,42.943200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.155200,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.824600,0.000000,42.608500>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<45.155200,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.824600,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.159300,0.000000,42.943200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<45.824600,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.159300,0.000000,42.943200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.159300,0.000000,43.612600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<46.159300,0.000000,43.612600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.159300,0.000000,43.612600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.489900,0.000000,43.612600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<45.489900,0.000000,43.612600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.831800,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.831800,0.000000,44.616800>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,90.000000,0> translate<46.831800,0.000000,44.616800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.831800,0.000000,44.616800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.835900,0.000000,44.616800>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<46.831800,0.000000,44.616800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.835900,0.000000,44.616800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.170600,0.000000,44.282000>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<47.835900,0.000000,44.616800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.170600,0.000000,44.282000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.170600,0.000000,43.612600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<48.170600,0.000000,43.612600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.170600,0.000000,43.612600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.835900,0.000000,43.277900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<47.835900,0.000000,43.277900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.835900,0.000000,43.277900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.831800,0.000000,43.277900>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<46.831800,0.000000,43.277900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.843100,0.000000,44.616800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.843100,0.000000,42.608500>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,-90.000000,0> translate<48.843100,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.843100,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.181900,0.000000,42.608500>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<48.843100,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.865700,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.535100,0.000000,42.608500>}
box{<0,0,-0.088900><1.496824,0.036000,0.088900> rotate<0,63.430762,0> translate<52.865700,0.000000,43.947300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.535100,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.204500,0.000000,43.947300>}
box{<0,0,-0.088900><1.496824,0.036000,0.088900> rotate<0,-63.430762,0> translate<53.535100,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.215800,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.877000,0.000000,42.608500>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<54.877000,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.877000,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.215800,0.000000,43.947300>}
box{<0,0,-0.088900><1.893349,0.036000,0.088900> rotate<0,-44.997030,0> translate<54.877000,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.215800,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.215800,0.000000,44.282000>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<56.215800,0.000000,44.282000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.215800,0.000000,44.282000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.881100,0.000000,44.616800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<55.881100,0.000000,44.616800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.881100,0.000000,44.616800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.211700,0.000000,44.616800>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<55.211700,0.000000,44.616800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.211700,0.000000,44.616800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.877000,0.000000,44.282000>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,-45.005588,0> translate<54.877000,0.000000,44.282000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.888300,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.888300,0.000000,42.943200>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<56.888300,0.000000,42.943200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.888300,0.000000,42.943200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.223000,0.000000,42.943200>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<56.888300,0.000000,42.943200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.223000,0.000000,42.943200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.223000,0.000000,42.608500>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<57.223000,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.223000,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.888300,0.000000,42.608500>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<56.888300,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.893900,0.000000,42.943200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.893900,0.000000,44.282000>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<57.893900,0.000000,44.282000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.893900,0.000000,44.282000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.228600,0.000000,44.616800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,-45.005588,0> translate<57.893900,0.000000,44.282000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.228600,0.000000,44.616800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.898000,0.000000,44.616800>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<58.228600,0.000000,44.616800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.898000,0.000000,44.616800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.232700,0.000000,44.282000>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<58.898000,0.000000,44.616800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.232700,0.000000,44.282000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.232700,0.000000,42.943200>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<59.232700,0.000000,42.943200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.232700,0.000000,42.943200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.898000,0.000000,42.608500>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<58.898000,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.898000,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.228600,0.000000,42.608500>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<58.228600,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.228600,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.893900,0.000000,42.943200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<57.893900,0.000000,42.943200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.893900,0.000000,42.943200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.232700,0.000000,44.282000>}
box{<0,0,-0.088900><1.893349,0.036000,0.088900> rotate<0,-44.997030,0> translate<57.893900,0.000000,42.943200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.044900,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.044900,0.000000,51.160900>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<29.044900,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.044900,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.379600,0.000000,51.160900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<29.044900,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.379600,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.714300,0.000000,50.826200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<29.379600,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.714300,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.714300,0.000000,49.822100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<29.714300,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.714300,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.049000,0.000000,51.160900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<29.714300,0.000000,50.826200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.049000,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.383700,0.000000,50.826200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<30.049000,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.383700,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.383700,0.000000,49.822100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<30.383700,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.390900,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.060300,0.000000,51.160900>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<31.390900,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.060300,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.395000,0.000000,50.826200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<32.060300,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.395000,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.395000,0.000000,49.822100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<32.395000,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.395000,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.390900,0.000000,49.822100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<31.390900,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.390900,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.056200,0.000000,50.156800>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<31.056200,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.056200,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.390900,0.000000,50.491500>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<31.056200,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.390900,0.000000,50.491500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.395000,0.000000,50.491500>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<31.390900,0.000000,50.491500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.067500,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.067500,0.000000,51.830400>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,90.000000,0> translate<33.067500,0.000000,51.830400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.071600,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.067500,0.000000,50.491500>}
box{<0,0,-0.088900><1.206778,0.036000,0.088900> rotate<0,33.687844,0> translate<33.067500,0.000000,50.491500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.067500,0.000000,50.491500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.071600,0.000000,51.160900>}
box{<0,0,-0.088900><1.206778,0.036000,0.088900> rotate<0,-33.687844,0> translate<33.067500,0.000000,50.491500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.747700,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.078300,0.000000,49.822100>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<35.078300,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.078300,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.743600,0.000000,50.156800>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<34.743600,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.743600,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.743600,0.000000,50.826200>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<34.743600,0.000000,50.826200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.743600,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.078300,0.000000,51.160900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<34.743600,0.000000,50.826200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.078300,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.747700,0.000000,51.160900>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<35.078300,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.747700,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.082400,0.000000,50.826200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<35.747700,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.082400,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.082400,0.000000,50.491500>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<36.082400,0.000000,50.491500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.082400,0.000000,50.491500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.743600,0.000000,50.491500>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<34.743600,0.000000,50.491500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.754900,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.754900,0.000000,50.156800>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<36.754900,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.754900,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.089600,0.000000,50.156800>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<36.754900,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.089600,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.089600,0.000000,49.822100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<37.089600,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.089600,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.754900,0.000000,49.822100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<36.754900,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.760500,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.760500,0.000000,51.160900>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<37.760500,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.760500,0.000000,50.491500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.429900,0.000000,51.160900>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<37.760500,0.000000,50.491500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.429900,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.764600,0.000000,51.160900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<38.429900,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.436600,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.436600,0.000000,51.160900>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<39.436600,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.436600,0.000000,50.491500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.106000,0.000000,51.160900>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<39.436600,0.000000,50.491500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.106000,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.440700,0.000000,51.160900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<40.106000,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.112700,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.112700,0.000000,51.160900>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<41.112700,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.112700,0.000000,50.491500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.782100,0.000000,51.160900>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<41.112700,0.000000,50.491500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.782100,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.116800,0.000000,51.160900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<41.782100,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.123500,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.123500,0.000000,51.495600>}
box{<0,0,-0.088900><1.673500,0.036000,0.088900> rotate<0,90.000000,0> translate<43.123500,0.000000,51.495600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.123500,0.000000,51.495600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.458200,0.000000,51.830400>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,-45.005588,0> translate<43.123500,0.000000,51.495600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.788800,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.458200,0.000000,50.826200>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<42.788800,0.000000,50.826200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.129700,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.129700,0.000000,50.156800>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<44.129700,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.129700,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.464400,0.000000,50.156800>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<44.129700,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.464400,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.464400,0.000000,49.822100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<44.464400,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.464400,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.129700,0.000000,49.822100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<44.129700,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.470000,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.139400,0.000000,49.822100>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<45.470000,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.139400,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.474100,0.000000,50.156800>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<46.139400,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.474100,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.474100,0.000000,50.826200>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<46.474100,0.000000,50.826200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.474100,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.139400,0.000000,51.160900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<46.139400,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.139400,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.470000,0.000000,51.160900>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<45.470000,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.470000,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.135300,0.000000,50.826200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<45.135300,0.000000,50.826200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.135300,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.135300,0.000000,50.156800>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<45.135300,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.135300,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.470000,0.000000,49.822100>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<45.135300,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.146600,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.146600,0.000000,51.160900>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<47.146600,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.146600,0.000000,50.491500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.816000,0.000000,51.160900>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<47.146600,0.000000,50.491500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.816000,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.150700,0.000000,51.160900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<47.816000,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.492100,0.000000,49.152700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.826800,0.000000,49.152700>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<49.492100,0.000000,49.152700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.826800,0.000000,49.152700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.161500,0.000000,49.487400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<49.826800,0.000000,49.152700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.161500,0.000000,49.487400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.161500,0.000000,51.160900>}
box{<0,0,-0.088900><1.673500,0.036000,0.088900> rotate<0,90.000000,0> translate<50.161500,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.161500,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.157400,0.000000,51.160900>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<49.157400,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.157400,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.822700,0.000000,50.826200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<48.822700,0.000000,50.826200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.822700,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.822700,0.000000,50.156800>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<48.822700,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.822700,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.157400,0.000000,49.822100>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<48.822700,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.157400,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.161500,0.000000,49.822100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<49.157400,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.834000,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.172800,0.000000,51.830400>}
box{<0,0,-0.088900><2.413639,0.036000,0.088900> rotate<0,-56.307533,0> translate<50.834000,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.180000,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.849400,0.000000,51.160900>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<53.180000,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.849400,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.184100,0.000000,50.826200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<53.849400,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.184100,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.184100,0.000000,49.822100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<54.184100,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.184100,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.180000,0.000000,49.822100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<53.180000,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.180000,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.845300,0.000000,50.156800>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<52.845300,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.845300,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.180000,0.000000,50.491500>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<52.845300,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.180000,0.000000,50.491500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.184100,0.000000,50.491500>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<53.180000,0.000000,50.491500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.856600,0.000000,51.830400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.856600,0.000000,49.822100>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,-90.000000,0> translate<54.856600,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.856600,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.860700,0.000000,49.822100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<54.856600,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.860700,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.195400,0.000000,50.156800>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<55.860700,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.195400,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.195400,0.000000,50.826200>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<56.195400,0.000000,50.826200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.195400,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.860700,0.000000,51.160900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<55.860700,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.860700,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.856600,0.000000,51.160900>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<54.856600,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.867900,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.206700,0.000000,50.826200>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<56.867900,0.000000,50.826200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.879200,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.548600,0.000000,51.830400>}
box{<0,0,-0.088900><0.946745,0.036000,0.088900> rotate<0,-45.001309,0> translate<58.879200,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.548600,0.000000,51.830400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.548600,0.000000,49.822100>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,-90.000000,0> translate<59.548600,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.879200,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.218000,0.000000,49.822100>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<58.879200,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.890500,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.890500,0.000000,50.156800>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<60.890500,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.890500,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.225200,0.000000,50.156800>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<60.890500,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.225200,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.225200,0.000000,49.822100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<61.225200,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.225200,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.890500,0.000000,49.822100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<60.890500,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.896100,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.565500,0.000000,51.830400>}
box{<0,0,-0.088900><0.946745,0.036000,0.088900> rotate<0,-45.001309,0> translate<61.896100,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.565500,0.000000,51.830400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.565500,0.000000,49.822100>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,-90.000000,0> translate<62.565500,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.896100,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.234900,0.000000,49.822100>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<61.896100,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.409100,0.000000,47.634800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.074400,0.000000,47.969600>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<30.074400,0.000000,47.969600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.074400,0.000000,47.969600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.405000,0.000000,47.969600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<29.405000,0.000000,47.969600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.405000,0.000000,47.969600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.070300,0.000000,47.634800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,-45.005588,0> translate<29.070300,0.000000,47.634800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.070300,0.000000,47.634800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.070300,0.000000,46.296000>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<29.070300,0.000000,46.296000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.070300,0.000000,46.296000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.405000,0.000000,45.961300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<29.070300,0.000000,46.296000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.405000,0.000000,45.961300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.074400,0.000000,45.961300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<29.405000,0.000000,45.961300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.074400,0.000000,45.961300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.409100,0.000000,46.296000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<30.074400,0.000000,45.961300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.416300,0.000000,45.961300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.085700,0.000000,45.961300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<31.416300,0.000000,45.961300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.085700,0.000000,45.961300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.420400,0.000000,46.296000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<32.085700,0.000000,45.961300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.420400,0.000000,46.296000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.420400,0.000000,46.965400>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<32.420400,0.000000,46.965400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.420400,0.000000,46.965400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.085700,0.000000,47.300100>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<32.085700,0.000000,47.300100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.085700,0.000000,47.300100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.416300,0.000000,47.300100>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<31.416300,0.000000,47.300100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.416300,0.000000,47.300100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.081600,0.000000,46.965400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<31.081600,0.000000,46.965400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.081600,0.000000,46.965400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.081600,0.000000,46.296000>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<31.081600,0.000000,46.296000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.081600,0.000000,46.296000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.416300,0.000000,45.961300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<31.081600,0.000000,46.296000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.092900,0.000000,45.291900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.092900,0.000000,47.300100>}
box{<0,0,-0.088900><2.008200,0.036000,0.088900> rotate<0,90.000000,0> translate<33.092900,0.000000,47.300100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.092900,0.000000,47.300100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.097000,0.000000,47.300100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<33.092900,0.000000,47.300100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.097000,0.000000,47.300100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.431700,0.000000,46.965400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<34.097000,0.000000,47.300100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.431700,0.000000,46.965400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.431700,0.000000,46.296000>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<34.431700,0.000000,46.296000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.431700,0.000000,46.296000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.097000,0.000000,45.961300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<34.097000,0.000000,45.961300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.097000,0.000000,45.961300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.092900,0.000000,45.961300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<33.092900,0.000000,45.961300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.104200,0.000000,47.300100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.104200,0.000000,46.296000>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<35.104200,0.000000,46.296000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.104200,0.000000,46.296000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.438900,0.000000,45.961300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<35.104200,0.000000,46.296000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.438900,0.000000,45.961300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.443000,0.000000,45.961300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<35.438900,0.000000,45.961300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.443000,0.000000,47.300100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.443000,0.000000,45.626600>}
box{<0,0,-0.088900><1.673500,0.036000,0.088900> rotate<0,-90.000000,0> translate<36.443000,0.000000,45.626600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.443000,0.000000,45.626600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.108300,0.000000,45.291900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<36.108300,0.000000,45.291900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.108300,0.000000,45.291900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.773600,0.000000,45.291900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<35.773600,0.000000,45.291900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.115500,0.000000,45.961300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.115500,0.000000,47.300100>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<37.115500,0.000000,47.300100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.115500,0.000000,46.630700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.784900,0.000000,47.300100>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<37.115500,0.000000,46.630700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.784900,0.000000,47.300100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.119600,0.000000,47.300100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<37.784900,0.000000,47.300100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.791600,0.000000,47.300100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.126300,0.000000,47.300100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<38.791600,0.000000,47.300100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.126300,0.000000,47.300100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.126300,0.000000,45.961300>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<39.126300,0.000000,45.961300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.791600,0.000000,45.961300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.461000,0.000000,45.961300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<38.791600,0.000000,45.961300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.126300,0.000000,48.304300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.126300,0.000000,47.969600>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<39.126300,0.000000,47.969600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.801900,0.000000,45.291900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.136600,0.000000,45.291900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<40.801900,0.000000,45.291900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.136600,0.000000,45.291900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.471300,0.000000,45.626600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<41.136600,0.000000,45.291900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.471300,0.000000,45.626600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.471300,0.000000,47.300100>}
box{<0,0,-0.088900><1.673500,0.036000,0.088900> rotate<0,90.000000,0> translate<41.471300,0.000000,47.300100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.471300,0.000000,47.300100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.467200,0.000000,47.300100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<40.467200,0.000000,47.300100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.467200,0.000000,47.300100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.132500,0.000000,46.965400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<40.132500,0.000000,46.965400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.132500,0.000000,46.965400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.132500,0.000000,46.296000>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<40.132500,0.000000,46.296000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.132500,0.000000,46.296000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.467200,0.000000,45.961300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<40.132500,0.000000,46.296000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.467200,0.000000,45.961300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.471300,0.000000,45.961300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<40.467200,0.000000,45.961300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.143800,0.000000,47.969600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.143800,0.000000,45.961300>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,-90.000000,0> translate<42.143800,0.000000,45.961300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.143800,0.000000,46.965400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.478500,0.000000,47.300100>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<42.143800,0.000000,46.965400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.478500,0.000000,47.300100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.147900,0.000000,47.300100>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<42.478500,0.000000,47.300100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.147900,0.000000,47.300100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.482600,0.000000,46.965400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<43.147900,0.000000,47.300100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.482600,0.000000,46.965400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.482600,0.000000,45.961300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<43.482600,0.000000,45.961300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.489800,0.000000,47.634800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.489800,0.000000,46.296000>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<44.489800,0.000000,46.296000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.489800,0.000000,46.296000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.824500,0.000000,45.961300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<44.489800,0.000000,46.296000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.155100,0.000000,47.300100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.824500,0.000000,47.300100>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<44.155100,0.000000,47.300100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.507300,0.000000,45.961300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.507300,0.000000,47.969600>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,90.000000,0> translate<47.507300,0.000000,47.969600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.507300,0.000000,47.969600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.511400,0.000000,47.969600>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<47.507300,0.000000,47.969600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.511400,0.000000,47.969600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.846100,0.000000,47.634800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<48.511400,0.000000,47.969600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.846100,0.000000,47.634800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.846100,0.000000,46.965400>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<48.846100,0.000000,46.965400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.846100,0.000000,46.965400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.511400,0.000000,46.630700>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<48.511400,0.000000,46.630700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.511400,0.000000,46.630700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.507300,0.000000,46.630700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<47.507300,0.000000,46.630700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.176700,0.000000,46.630700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.846100,0.000000,45.961300>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,44.997030,0> translate<48.176700,0.000000,46.630700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.518600,0.000000,45.961300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.518600,0.000000,47.969600>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,90.000000,0> translate<49.518600,0.000000,47.969600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.518600,0.000000,47.969600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.522700,0.000000,47.969600>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<49.518600,0.000000,47.969600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.522700,0.000000,47.969600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.857400,0.000000,47.634800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<50.522700,0.000000,47.969600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.857400,0.000000,47.634800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.857400,0.000000,46.965400>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<50.857400,0.000000,46.965400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.857400,0.000000,46.965400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.522700,0.000000,46.630700>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<50.522700,0.000000,46.630700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.522700,0.000000,46.630700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.518600,0.000000,46.630700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<49.518600,0.000000,46.630700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.188000,0.000000,46.630700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.857400,0.000000,45.961300>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,44.997030,0> translate<50.188000,0.000000,46.630700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.529900,0.000000,45.961300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.529900,0.000000,47.969600>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,90.000000,0> translate<51.529900,0.000000,47.969600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.529900,0.000000,47.969600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.534000,0.000000,47.969600>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<51.529900,0.000000,47.969600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.534000,0.000000,47.969600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.868700,0.000000,47.634800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<52.534000,0.000000,47.969600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.868700,0.000000,47.634800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.868700,0.000000,46.965400>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<52.868700,0.000000,46.965400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.868700,0.000000,46.965400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.534000,0.000000,46.630700>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<52.534000,0.000000,46.630700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.534000,0.000000,46.630700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.529900,0.000000,46.630700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<51.529900,0.000000,46.630700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.199300,0.000000,46.630700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.868700,0.000000,45.961300>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,44.997030,0> translate<52.199300,0.000000,46.630700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.541200,0.000000,45.961300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.541200,0.000000,47.969600>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,90.000000,0> translate<53.541200,0.000000,47.969600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.541200,0.000000,47.969600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.880000,0.000000,47.969600>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<53.541200,0.000000,47.969600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.541200,0.000000,46.965400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.210600,0.000000,46.965400>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<53.541200,0.000000,46.965400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.902600,0.000000,45.961300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.563800,0.000000,45.961300>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<57.563800,0.000000,45.961300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.563800,0.000000,45.961300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.902600,0.000000,47.300100>}
box{<0,0,-0.088900><1.893349,0.036000,0.088900> rotate<0,-44.997030,0> translate<57.563800,0.000000,45.961300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.902600,0.000000,47.300100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.902600,0.000000,47.634800>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<58.902600,0.000000,47.634800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.902600,0.000000,47.634800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.567900,0.000000,47.969600>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<58.567900,0.000000,47.969600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.567900,0.000000,47.969600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.898500,0.000000,47.969600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<57.898500,0.000000,47.969600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.898500,0.000000,47.969600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.563800,0.000000,47.634800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,-45.005588,0> translate<57.563800,0.000000,47.634800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.575100,0.000000,46.296000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.575100,0.000000,47.634800>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<59.575100,0.000000,47.634800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.575100,0.000000,47.634800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.909800,0.000000,47.969600>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,-45.005588,0> translate<59.575100,0.000000,47.634800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.909800,0.000000,47.969600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.579200,0.000000,47.969600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<59.909800,0.000000,47.969600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.579200,0.000000,47.969600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.913900,0.000000,47.634800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<60.579200,0.000000,47.969600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.913900,0.000000,47.634800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.913900,0.000000,46.296000>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<60.913900,0.000000,46.296000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.913900,0.000000,46.296000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.579200,0.000000,45.961300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<60.579200,0.000000,45.961300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.579200,0.000000,45.961300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.909800,0.000000,45.961300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<59.909800,0.000000,45.961300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.909800,0.000000,45.961300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.575100,0.000000,46.296000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<59.575100,0.000000,46.296000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.575100,0.000000,46.296000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.913900,0.000000,47.634800>}
box{<0,0,-0.088900><1.893349,0.036000,0.088900> rotate<0,-44.997030,0> translate<59.575100,0.000000,46.296000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.586400,0.000000,46.296000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.586400,0.000000,47.634800>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<61.586400,0.000000,47.634800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.586400,0.000000,47.634800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.921100,0.000000,47.969600>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,-45.005588,0> translate<61.586400,0.000000,47.634800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.921100,0.000000,47.969600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.590500,0.000000,47.969600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<61.921100,0.000000,47.969600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.590500,0.000000,47.969600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.925200,0.000000,47.634800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<62.590500,0.000000,47.969600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.925200,0.000000,47.634800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.925200,0.000000,46.296000>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<62.925200,0.000000,46.296000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.925200,0.000000,46.296000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.590500,0.000000,45.961300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<62.590500,0.000000,45.961300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.590500,0.000000,45.961300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.921100,0.000000,45.961300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<61.921100,0.000000,45.961300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.921100,0.000000,45.961300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.586400,0.000000,46.296000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<61.586400,0.000000,46.296000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.586400,0.000000,46.296000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.925200,0.000000,47.634800>}
box{<0,0,-0.088900><1.893349,0.036000,0.088900> rotate<0,-44.997030,0> translate<61.586400,0.000000,46.296000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.597700,0.000000,47.634800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.932400,0.000000,47.969600>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,-45.005588,0> translate<63.597700,0.000000,47.634800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.932400,0.000000,47.969600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.601800,0.000000,47.969600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<63.932400,0.000000,47.969600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.601800,0.000000,47.969600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.936500,0.000000,47.634800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<64.601800,0.000000,47.969600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.936500,0.000000,47.634800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.936500,0.000000,47.300100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<64.936500,0.000000,47.300100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.936500,0.000000,47.300100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.601800,0.000000,46.965400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<64.601800,0.000000,46.965400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.601800,0.000000,46.965400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.936500,0.000000,46.630700>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<64.601800,0.000000,46.965400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.936500,0.000000,46.630700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.936500,0.000000,46.296000>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<64.936500,0.000000,46.296000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.936500,0.000000,46.296000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.601800,0.000000,45.961300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<64.601800,0.000000,45.961300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.601800,0.000000,45.961300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.932400,0.000000,45.961300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<63.932400,0.000000,45.961300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.932400,0.000000,45.961300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.597700,0.000000,46.296000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<63.597700,0.000000,46.296000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.597700,0.000000,46.296000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.597700,0.000000,46.630700>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<63.597700,0.000000,46.630700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.597700,0.000000,46.630700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.932400,0.000000,46.965400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<63.597700,0.000000,46.630700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.932400,0.000000,46.965400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.597700,0.000000,47.300100>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<63.597700,0.000000,47.300100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.597700,0.000000,47.300100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.597700,0.000000,47.634800>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<63.597700,0.000000,47.634800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.932400,0.000000,46.965400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.601800,0.000000,46.965400>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<63.932400,0.000000,46.965400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.790900,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.960200,0.000000,57.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<76.790900,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.960200,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.960200,0.000000,58.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<77.960200,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.960200,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.765400,0.000000,58.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<77.765400,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.765400,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.985800,0.000000,58.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<76.985800,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.985800,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.790900,0.000000,58.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<76.790900,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.790900,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.790900,0.000000,57.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<76.790900,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.960200,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.960200,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<77.960200,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.960200,0.000000,58.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.790900,0.000000,58.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<76.790900,0.000000,58.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.790900,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.790900,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<76.790900,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.985800,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.790900,0.000000,60.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<76.790900,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.790900,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.790900,0.000000,59.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<76.790900,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.790900,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.985800,0.000000,59.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<76.790900,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.985800,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.765400,0.000000,59.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<76.985800,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.765400,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.960200,0.000000,59.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<77.765400,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.960200,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.960200,0.000000,60.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<77.960200,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.960200,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.765400,0.000000,60.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<77.765400,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.765400,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.375600,0.000000,60.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<77.375600,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.375600,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.375600,0.000000,59.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<77.375600,0.000000,59.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.960200,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.960200,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<77.960200,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.960200,0.000000,60.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.790900,0.000000,60.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<76.790900,0.000000,60.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.790900,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.790900,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<76.790900,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.960200,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.960200,0.000000,62.623300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<77.960200,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.960200,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.180700,0.000000,63.402800>}
box{<0,0,-0.050800><1.102379,0.036000,0.050800> rotate<0,44.997030,0> translate<77.180700,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.180700,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.985800,0.000000,63.402800>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<76.985800,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.985800,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.790900,0.000000,63.207900>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<76.790900,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.790900,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.790900,0.000000,62.818100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<76.790900,0.000000,62.818100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.790900,0.000000,62.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.985800,0.000000,62.623300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<76.790900,0.000000,62.818100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,23.622000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.427100,0.000000,23.622000>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<77.427100,0.000000,23.622000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.427100,0.000000,23.622000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,24.011700>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<77.037300,0.000000,24.011700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,24.011700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.427100,0.000000,24.401500>}
box{<0,0,-0.050800><0.551260,0.036000,0.050800> rotate<0,-44.997030,0> translate<77.037300,0.000000,24.011700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.427100,0.000000,24.401500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,24.401500>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<77.427100,0.000000,24.401500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.622000,0.000000,23.622000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.622000,0.000000,24.401500>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<77.622000,0.000000,24.401500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,24.791300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,24.791300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<77.037300,0.000000,24.791300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,24.791300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,25.570800>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,-33.686713,0> translate<77.037300,0.000000,24.791300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,25.570800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,25.570800>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<77.037300,0.000000,25.570800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,25.960600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.427100,0.000000,25.960600>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<77.427100,0.000000,25.960600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.427100,0.000000,25.960600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,26.350300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<77.037300,0.000000,26.350300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,26.350300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.427100,0.000000,26.740100>}
box{<0,0,-0.050800><0.551260,0.036000,0.050800> rotate<0,-44.997030,0> translate<77.037300,0.000000,26.350300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.427100,0.000000,26.740100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,26.740100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<77.427100,0.000000,26.740100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.622000,0.000000,25.960600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.622000,0.000000,26.740100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<77.622000,0.000000,26.740100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,27.129900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,27.129900>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<77.037300,0.000000,27.129900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,27.129900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,27.909400>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<78.206600,0.000000,27.909400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,28.883800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,28.494000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<77.037300,0.000000,28.494000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,28.494000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.232200,0.000000,28.299200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<77.037300,0.000000,28.494000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.232200,0.000000,28.299200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.011800,0.000000,28.299200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<77.232200,0.000000,28.299200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.011800,0.000000,28.299200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,28.494000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<78.011800,0.000000,28.299200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,28.494000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,28.883800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<78.206600,0.000000,28.883800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,28.883800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.011800,0.000000,29.078700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<78.011800,0.000000,29.078700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.011800,0.000000,29.078700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.232200,0.000000,29.078700>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<77.232200,0.000000,29.078700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.232200,0.000000,29.078700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,28.883800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<77.037300,0.000000,28.883800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.232200,0.000000,30.248000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,30.053100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<77.037300,0.000000,30.053100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,30.053100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,29.663300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<77.037300,0.000000,29.663300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,29.663300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.232200,0.000000,29.468500>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<77.037300,0.000000,29.663300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.232200,0.000000,29.468500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.011800,0.000000,29.468500>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<77.232200,0.000000,29.468500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.011800,0.000000,29.468500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,29.663300>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<78.011800,0.000000,29.468500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,29.663300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,30.053100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<78.206600,0.000000,30.053100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,30.053100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.011800,0.000000,30.248000>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<78.011800,0.000000,30.248000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.011800,0.000000,30.248000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.622000,0.000000,30.248000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<77.622000,0.000000,30.248000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.622000,0.000000,30.248000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.622000,0.000000,29.858200>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<77.622000,0.000000,29.858200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,32.586600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,31.807100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<77.037300,0.000000,31.807100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,31.807100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.622000,0.000000,31.807100>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,0.000000,0> translate<77.037300,0.000000,31.807100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.622000,0.000000,31.807100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.427100,0.000000,32.196800>}
box{<0,0,-0.050800><0.435720,0.036000,0.050800> rotate<0,63.424882,0> translate<77.427100,0.000000,32.196800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.427100,0.000000,32.196800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.427100,0.000000,32.391700>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,90.000000,0> translate<77.427100,0.000000,32.391700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.427100,0.000000,32.391700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.622000,0.000000,32.586600>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<77.427100,0.000000,32.391700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.622000,0.000000,32.586600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.011800,0.000000,32.586600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<77.622000,0.000000,32.586600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.011800,0.000000,32.586600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,32.391700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<78.011800,0.000000,32.586600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,32.391700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,32.001900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<78.206600,0.000000,32.001900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,32.001900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.011800,0.000000,31.807100>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<78.011800,0.000000,31.807100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,34.145700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,34.925200>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,33.686713,0> translate<77.037300,0.000000,34.925200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,36.484300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,36.484300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<77.037300,0.000000,36.484300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,36.484300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,37.068900>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<78.206600,0.000000,37.068900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,37.068900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.011800,0.000000,37.263800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<78.011800,0.000000,37.263800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.011800,0.000000,37.263800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.232200,0.000000,37.263800>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<77.232200,0.000000,37.263800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.232200,0.000000,37.263800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,37.068900>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<77.037300,0.000000,37.068900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,37.068900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,36.484300>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<77.037300,0.000000,36.484300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.427100,0.000000,37.653600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,38.043300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<77.037300,0.000000,38.043300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,38.043300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,38.043300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<77.037300,0.000000,38.043300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,37.653600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,38.433100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<78.206600,0.000000,38.433100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.011800,0.000000,38.822900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,39.017700>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<78.011800,0.000000,38.822900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,39.017700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,39.407500>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<78.206600,0.000000,39.407500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.206600,0.000000,39.407500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.011800,0.000000,39.602400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<78.011800,0.000000,39.602400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.011800,0.000000,39.602400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.232200,0.000000,39.602400>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<77.232200,0.000000,39.602400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.232200,0.000000,39.602400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,39.407500>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<77.037300,0.000000,39.407500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,39.407500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,39.017700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<77.037300,0.000000,39.017700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.037300,0.000000,39.017700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.232200,0.000000,38.822900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<77.037300,0.000000,39.017700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.232200,0.000000,38.822900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.427100,0.000000,38.822900>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<77.232200,0.000000,38.822900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.427100,0.000000,38.822900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.622000,0.000000,39.017700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<77.427100,0.000000,38.822900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.622000,0.000000,39.017700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.622000,0.000000,39.602400>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,90.000000,0> translate<77.622000,0.000000,39.602400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,23.495000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.474100,0.000000,23.495000>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<72.474100,0.000000,23.495000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.474100,0.000000,23.495000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,23.884700>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<72.084300,0.000000,23.884700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,23.884700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.474100,0.000000,24.274500>}
box{<0,0,-0.050800><0.551260,0.036000,0.050800> rotate<0,-44.997030,0> translate<72.084300,0.000000,23.884700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.474100,0.000000,24.274500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,24.274500>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<72.474100,0.000000,24.274500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.669000,0.000000,23.495000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.669000,0.000000,24.274500>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<72.669000,0.000000,24.274500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,24.664300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,24.664300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<72.084300,0.000000,24.664300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,24.664300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,25.443800>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,-33.686713,0> translate<72.084300,0.000000,24.664300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,25.443800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,25.443800>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<72.084300,0.000000,25.443800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,25.833600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.474100,0.000000,25.833600>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<72.474100,0.000000,25.833600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.474100,0.000000,25.833600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,26.223300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<72.084300,0.000000,26.223300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,26.223300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.474100,0.000000,26.613100>}
box{<0,0,-0.050800><0.551260,0.036000,0.050800> rotate<0,-44.997030,0> translate<72.084300,0.000000,26.223300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.474100,0.000000,26.613100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,26.613100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<72.474100,0.000000,26.613100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.669000,0.000000,25.833600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.669000,0.000000,26.613100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<72.669000,0.000000,26.613100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,27.002900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,27.002900>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<72.084300,0.000000,27.002900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,27.002900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,27.782400>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<73.253600,0.000000,27.782400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,28.756800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,28.367000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<72.084300,0.000000,28.367000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,28.367000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.279200,0.000000,28.172200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<72.084300,0.000000,28.367000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.279200,0.000000,28.172200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.058800,0.000000,28.172200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<72.279200,0.000000,28.172200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.058800,0.000000,28.172200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,28.367000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<73.058800,0.000000,28.172200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,28.367000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,28.756800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<73.253600,0.000000,28.756800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,28.756800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.058800,0.000000,28.951700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<73.058800,0.000000,28.951700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.058800,0.000000,28.951700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.279200,0.000000,28.951700>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<72.279200,0.000000,28.951700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.279200,0.000000,28.951700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,28.756800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<72.084300,0.000000,28.756800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.279200,0.000000,30.121000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,29.926100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<72.084300,0.000000,29.926100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,29.926100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,29.536300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<72.084300,0.000000,29.536300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,29.536300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.279200,0.000000,29.341500>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<72.084300,0.000000,29.536300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.279200,0.000000,29.341500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.058800,0.000000,29.341500>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<72.279200,0.000000,29.341500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.058800,0.000000,29.341500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,29.536300>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<73.058800,0.000000,29.341500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,29.536300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,29.926100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<73.253600,0.000000,29.926100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,29.926100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.058800,0.000000,30.121000>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<73.058800,0.000000,30.121000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.058800,0.000000,30.121000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.669000,0.000000,30.121000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<72.669000,0.000000,30.121000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.669000,0.000000,30.121000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.669000,0.000000,29.731200>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<72.669000,0.000000,29.731200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,32.264700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,32.264700>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<72.084300,0.000000,32.264700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,32.264700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.669000,0.000000,31.680100>}
box{<0,0,-0.050800><0.826820,0.036000,0.050800> rotate<0,44.992130,0> translate<72.084300,0.000000,32.264700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.669000,0.000000,31.680100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.669000,0.000000,32.459600>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<72.669000,0.000000,32.459600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,34.018700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,34.798200>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,33.686713,0> translate<72.084300,0.000000,34.798200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,36.357300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,36.357300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<72.084300,0.000000,36.357300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,36.357300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,36.941900>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<73.253600,0.000000,36.941900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,36.941900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.058800,0.000000,37.136800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<73.058800,0.000000,37.136800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.058800,0.000000,37.136800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.279200,0.000000,37.136800>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<72.279200,0.000000,37.136800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.279200,0.000000,37.136800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,36.941900>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<72.084300,0.000000,36.941900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,36.941900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,36.357300>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<72.084300,0.000000,36.357300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.474100,0.000000,37.526600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,37.916300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<72.084300,0.000000,37.916300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,37.916300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,37.916300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<72.084300,0.000000,37.916300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,37.526600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,38.306100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<73.253600,0.000000,38.306100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.279200,0.000000,38.695900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,38.890700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<72.084300,0.000000,38.890700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,38.890700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,39.280500>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<72.084300,0.000000,39.280500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.084300,0.000000,39.280500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.279200,0.000000,39.475400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<72.084300,0.000000,39.280500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.279200,0.000000,39.475400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.474100,0.000000,39.475400>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<72.279200,0.000000,39.475400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.474100,0.000000,39.475400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.669000,0.000000,39.280500>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<72.474100,0.000000,39.475400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.669000,0.000000,39.280500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.863900,0.000000,39.475400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<72.669000,0.000000,39.280500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.863900,0.000000,39.475400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.058800,0.000000,39.475400>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<72.863900,0.000000,39.475400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.058800,0.000000,39.475400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,39.280500>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<73.058800,0.000000,39.475400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,39.280500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,38.890700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<73.253600,0.000000,38.890700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.253600,0.000000,38.890700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.058800,0.000000,38.695900>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<73.058800,0.000000,38.695900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.058800,0.000000,38.695900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.863900,0.000000,38.695900>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<72.863900,0.000000,38.695900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.863900,0.000000,38.695900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.669000,0.000000,38.890700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<72.669000,0.000000,38.890700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.669000,0.000000,38.890700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.474100,0.000000,38.695900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<72.474100,0.000000,38.695900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.474100,0.000000,38.695900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.279200,0.000000,38.695900>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<72.279200,0.000000,38.695900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.669000,0.000000,38.890700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.669000,0.000000,39.280500>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<72.669000,0.000000,39.280500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,23.368000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.343300,0.000000,23.368000>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<67.343300,0.000000,23.368000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.343300,0.000000,23.368000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,23.757700>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<66.953500,0.000000,23.757700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,23.757700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.343300,0.000000,24.147500>}
box{<0,0,-0.050800><0.551260,0.036000,0.050800> rotate<0,-44.997030,0> translate<66.953500,0.000000,23.757700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.343300,0.000000,24.147500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,24.147500>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<67.343300,0.000000,24.147500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.538200,0.000000,23.368000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.538200,0.000000,24.147500>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<67.538200,0.000000,24.147500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,24.537300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,24.537300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<66.953500,0.000000,24.537300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,24.537300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,25.316800>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,-33.686713,0> translate<66.953500,0.000000,24.537300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,25.316800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,25.316800>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<66.953500,0.000000,25.316800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,25.706600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.343300,0.000000,25.706600>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<67.343300,0.000000,25.706600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.343300,0.000000,25.706600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,26.096300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<66.953500,0.000000,26.096300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,26.096300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.343300,0.000000,26.486100>}
box{<0,0,-0.050800><0.551260,0.036000,0.050800> rotate<0,-44.997030,0> translate<66.953500,0.000000,26.096300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.343300,0.000000,26.486100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,26.486100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<67.343300,0.000000,26.486100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.538200,0.000000,25.706600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.538200,0.000000,26.486100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<67.538200,0.000000,26.486100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,26.875900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,26.875900>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<66.953500,0.000000,26.875900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,26.875900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,27.655400>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<68.122800,0.000000,27.655400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,28.629800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,28.240000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<66.953500,0.000000,28.240000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,28.240000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.148400,0.000000,28.045200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<66.953500,0.000000,28.240000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.148400,0.000000,28.045200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.928000,0.000000,28.045200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<67.148400,0.000000,28.045200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.928000,0.000000,28.045200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,28.240000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<67.928000,0.000000,28.045200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,28.240000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,28.629800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<68.122800,0.000000,28.629800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,28.629800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.928000,0.000000,28.824700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<67.928000,0.000000,28.824700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.928000,0.000000,28.824700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.148400,0.000000,28.824700>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<67.148400,0.000000,28.824700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.148400,0.000000,28.824700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,28.629800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<66.953500,0.000000,28.629800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.148400,0.000000,29.994000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,29.799100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<66.953500,0.000000,29.799100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,29.799100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,29.409300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<66.953500,0.000000,29.409300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,29.409300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.148400,0.000000,29.214500>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<66.953500,0.000000,29.409300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.148400,0.000000,29.214500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.928000,0.000000,29.214500>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<67.148400,0.000000,29.214500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.928000,0.000000,29.214500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,29.409300>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<67.928000,0.000000,29.214500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,29.409300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,29.799100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<68.122800,0.000000,29.799100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,29.799100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.928000,0.000000,29.994000>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<67.928000,0.000000,29.994000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.928000,0.000000,29.994000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.538200,0.000000,29.994000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<67.538200,0.000000,29.994000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.538200,0.000000,29.994000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.538200,0.000000,29.604200>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<67.538200,0.000000,29.604200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.148400,0.000000,31.553100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,31.747900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<66.953500,0.000000,31.747900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,31.747900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,32.137700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<66.953500,0.000000,32.137700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,32.137700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.148400,0.000000,32.332600>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<66.953500,0.000000,32.137700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.148400,0.000000,32.332600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.343300,0.000000,32.332600>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<67.148400,0.000000,32.332600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.343300,0.000000,32.332600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.538200,0.000000,32.137700>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<67.343300,0.000000,32.332600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.538200,0.000000,32.137700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.538200,0.000000,31.942800>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<67.538200,0.000000,31.942800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.538200,0.000000,32.137700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.733100,0.000000,32.332600>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<67.538200,0.000000,32.137700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.733100,0.000000,32.332600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.928000,0.000000,32.332600>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<67.733100,0.000000,32.332600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.928000,0.000000,32.332600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,32.137700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<67.928000,0.000000,32.332600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,32.137700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,31.747900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<68.122800,0.000000,31.747900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,31.747900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.928000,0.000000,31.553100>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<67.928000,0.000000,31.553100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,33.891700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,34.671200>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,33.686713,0> translate<66.953500,0.000000,34.671200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,36.230300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,36.230300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<66.953500,0.000000,36.230300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,36.230300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,36.814900>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<68.122800,0.000000,36.814900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,36.814900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.928000,0.000000,37.009800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<67.928000,0.000000,37.009800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.928000,0.000000,37.009800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.148400,0.000000,37.009800>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<67.148400,0.000000,37.009800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.148400,0.000000,37.009800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,36.814900>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<66.953500,0.000000,36.814900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,36.814900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,36.230300>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<66.953500,0.000000,36.230300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.343300,0.000000,37.399600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,37.789300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<66.953500,0.000000,37.789300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,37.789300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,37.789300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<66.953500,0.000000,37.789300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,37.399600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,38.179100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<68.122800,0.000000,38.179100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,38.568900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,39.348400>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<66.953500,0.000000,39.348400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.953500,0.000000,39.348400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.148400,0.000000,39.348400>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<66.953500,0.000000,39.348400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.148400,0.000000,39.348400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.928000,0.000000,38.568900>}
box{<0,0,-0.050800><1.102450,0.036000,0.050800> rotate<0,44.993355,0> translate<67.148400,0.000000,39.348400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.928000,0.000000,38.568900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.122800,0.000000,38.568900>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<67.928000,0.000000,38.568900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,23.291800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.187100,0.000000,23.291800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<62.187100,0.000000,23.291800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.187100,0.000000,23.291800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,23.681500>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<61.797300,0.000000,23.681500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,23.681500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.187100,0.000000,24.071300>}
box{<0,0,-0.050800><0.551260,0.036000,0.050800> rotate<0,-44.997030,0> translate<61.797300,0.000000,23.681500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.187100,0.000000,24.071300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,24.071300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<62.187100,0.000000,24.071300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.382000,0.000000,23.291800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.382000,0.000000,24.071300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<62.382000,0.000000,24.071300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,24.461100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,24.461100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<61.797300,0.000000,24.461100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,24.461100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,25.240600>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,-33.686713,0> translate<61.797300,0.000000,24.461100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,25.240600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,25.240600>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<61.797300,0.000000,25.240600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,25.630400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.187100,0.000000,25.630400>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<62.187100,0.000000,25.630400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.187100,0.000000,25.630400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,26.020100>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<61.797300,0.000000,26.020100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,26.020100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.187100,0.000000,26.409900>}
box{<0,0,-0.050800><0.551260,0.036000,0.050800> rotate<0,-44.997030,0> translate<61.797300,0.000000,26.020100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.187100,0.000000,26.409900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,26.409900>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<62.187100,0.000000,26.409900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.382000,0.000000,25.630400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.382000,0.000000,26.409900>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<62.382000,0.000000,26.409900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,26.799700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,26.799700>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<61.797300,0.000000,26.799700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,26.799700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,27.579200>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<62.966600,0.000000,27.579200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,28.553600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,28.163800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<61.797300,0.000000,28.163800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,28.163800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.992200,0.000000,27.969000>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<61.797300,0.000000,28.163800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.992200,0.000000,27.969000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.771800,0.000000,27.969000>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<61.992200,0.000000,27.969000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.771800,0.000000,27.969000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,28.163800>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<62.771800,0.000000,27.969000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,28.163800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,28.553600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<62.966600,0.000000,28.553600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,28.553600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.771800,0.000000,28.748500>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<62.771800,0.000000,28.748500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.771800,0.000000,28.748500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.992200,0.000000,28.748500>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<61.992200,0.000000,28.748500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.992200,0.000000,28.748500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,28.553600>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<61.797300,0.000000,28.553600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.992200,0.000000,29.917800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,29.722900>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<61.797300,0.000000,29.722900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,29.722900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,29.333100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<61.797300,0.000000,29.333100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,29.333100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.992200,0.000000,29.138300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<61.797300,0.000000,29.333100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.992200,0.000000,29.138300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.771800,0.000000,29.138300>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<61.992200,0.000000,29.138300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.771800,0.000000,29.138300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,29.333100>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<62.771800,0.000000,29.138300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,29.333100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,29.722900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<62.966600,0.000000,29.722900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,29.722900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.771800,0.000000,29.917800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<62.771800,0.000000,29.917800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.771800,0.000000,29.917800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.382000,0.000000,29.917800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<62.382000,0.000000,29.917800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.382000,0.000000,29.917800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.382000,0.000000,29.528000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<62.382000,0.000000,29.528000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,32.256400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,31.476900>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<62.966600,0.000000,31.476900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,31.476900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.187100,0.000000,32.256400>}
box{<0,0,-0.050800><1.102379,0.036000,0.050800> rotate<0,44.997030,0> translate<62.187100,0.000000,32.256400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.187100,0.000000,32.256400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.992200,0.000000,32.256400>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<61.992200,0.000000,32.256400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.992200,0.000000,32.256400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,32.061500>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<61.797300,0.000000,32.061500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,32.061500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,31.671700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<61.797300,0.000000,31.671700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,31.671700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.992200,0.000000,31.476900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<61.797300,0.000000,31.671700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,33.815500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,34.595000>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,33.686713,0> translate<61.797300,0.000000,34.595000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,36.154100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,36.154100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<61.797300,0.000000,36.154100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,36.154100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,36.738700>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<62.966600,0.000000,36.738700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,36.738700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.771800,0.000000,36.933600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<62.771800,0.000000,36.933600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.771800,0.000000,36.933600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.992200,0.000000,36.933600>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<61.992200,0.000000,36.933600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.992200,0.000000,36.933600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,36.738700>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<61.797300,0.000000,36.738700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,36.738700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,36.154100>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<61.797300,0.000000,36.154100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.187100,0.000000,37.323400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,37.713100>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<61.797300,0.000000,37.713100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,37.713100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,37.713100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<61.797300,0.000000,37.713100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,37.323400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,38.102900>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<62.966600,0.000000,38.102900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.797300,0.000000,39.272200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.992200,0.000000,38.882400>}
box{<0,0,-0.050800><0.435810,0.036000,0.050800> rotate<0,63.430762,0> translate<61.797300,0.000000,39.272200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.992200,0.000000,38.882400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.382000,0.000000,38.492700>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<61.992200,0.000000,38.882400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.382000,0.000000,38.492700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.771800,0.000000,38.492700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<62.382000,0.000000,38.492700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.771800,0.000000,38.492700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,38.687500>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<62.771800,0.000000,38.492700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,38.687500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,39.077300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<62.966600,0.000000,39.077300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.966600,0.000000,39.077300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.771800,0.000000,39.272200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<62.771800,0.000000,39.272200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.771800,0.000000,39.272200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.576900,0.000000,39.272200>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<62.576900,0.000000,39.272200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.576900,0.000000,39.272200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.382000,0.000000,39.077300>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<62.382000,0.000000,39.077300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.382000,0.000000,39.077300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.382000,0.000000,38.492700>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<62.382000,0.000000,38.492700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,23.215600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.929300,0.000000,23.215600>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<56.929300,0.000000,23.215600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.929300,0.000000,23.215600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,23.605300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<56.539500,0.000000,23.605300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,23.605300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.929300,0.000000,23.995100>}
box{<0,0,-0.050800><0.551260,0.036000,0.050800> rotate<0,-44.997030,0> translate<56.539500,0.000000,23.605300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.929300,0.000000,23.995100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,23.995100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<56.929300,0.000000,23.995100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.124200,0.000000,23.215600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.124200,0.000000,23.995100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<57.124200,0.000000,23.995100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,24.384900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,24.384900>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<56.539500,0.000000,24.384900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,24.384900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,25.164400>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,-33.686713,0> translate<56.539500,0.000000,24.384900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,25.164400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,25.164400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<56.539500,0.000000,25.164400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,25.554200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.929300,0.000000,25.554200>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<56.929300,0.000000,25.554200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.929300,0.000000,25.554200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,25.943900>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<56.539500,0.000000,25.943900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,25.943900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.929300,0.000000,26.333700>}
box{<0,0,-0.050800><0.551260,0.036000,0.050800> rotate<0,-44.997030,0> translate<56.539500,0.000000,25.943900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.929300,0.000000,26.333700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,26.333700>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<56.929300,0.000000,26.333700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.124200,0.000000,25.554200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.124200,0.000000,26.333700>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<57.124200,0.000000,26.333700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,26.723500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,26.723500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<56.539500,0.000000,26.723500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,26.723500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,27.503000>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<57.708800,0.000000,27.503000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,28.477400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,28.087600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<56.539500,0.000000,28.087600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,28.087600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.734400,0.000000,27.892800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<56.539500,0.000000,28.087600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.734400,0.000000,27.892800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.514000,0.000000,27.892800>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<56.734400,0.000000,27.892800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.514000,0.000000,27.892800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,28.087600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<57.514000,0.000000,27.892800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,28.087600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,28.477400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<57.708800,0.000000,28.477400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,28.477400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.514000,0.000000,28.672300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<57.514000,0.000000,28.672300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.514000,0.000000,28.672300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.734400,0.000000,28.672300>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<56.734400,0.000000,28.672300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.734400,0.000000,28.672300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,28.477400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<56.539500,0.000000,28.477400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.734400,0.000000,29.841600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,29.646700>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<56.539500,0.000000,29.646700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,29.646700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,29.256900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<56.539500,0.000000,29.256900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,29.256900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.734400,0.000000,29.062100>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<56.539500,0.000000,29.256900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.734400,0.000000,29.062100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.514000,0.000000,29.062100>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<56.734400,0.000000,29.062100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.514000,0.000000,29.062100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,29.256900>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<57.514000,0.000000,29.062100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,29.256900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,29.646700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<57.708800,0.000000,29.646700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,29.646700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.514000,0.000000,29.841600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<57.514000,0.000000,29.841600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.514000,0.000000,29.841600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.124200,0.000000,29.841600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<57.124200,0.000000,29.841600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.124200,0.000000,29.841600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.124200,0.000000,29.451800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<57.124200,0.000000,29.451800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.929300,0.000000,31.400700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,31.790400>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<56.539500,0.000000,31.790400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,31.790400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,31.790400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<56.539500,0.000000,31.790400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,31.400700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,32.180200>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<57.708800,0.000000,32.180200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,33.739300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,34.518800>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,33.686713,0> translate<56.539500,0.000000,34.518800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,36.077900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,36.077900>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<56.539500,0.000000,36.077900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,36.077900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,36.662500>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<57.708800,0.000000,36.662500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,36.662500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.514000,0.000000,36.857400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<57.514000,0.000000,36.857400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.514000,0.000000,36.857400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.734400,0.000000,36.857400>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<56.734400,0.000000,36.857400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.734400,0.000000,36.857400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,36.662500>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<56.539500,0.000000,36.662500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,36.662500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,36.077900>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<56.539500,0.000000,36.077900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.929300,0.000000,37.247200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,37.636900>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<56.539500,0.000000,37.636900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,37.636900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,37.636900>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<56.539500,0.000000,37.636900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,37.247200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,38.026700>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<57.708800,0.000000,38.026700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,39.196000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,38.416500>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<56.539500,0.000000,38.416500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.539500,0.000000,38.416500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.124200,0.000000,38.416500>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,0.000000,0> translate<56.539500,0.000000,38.416500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.124200,0.000000,38.416500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.929300,0.000000,38.806200>}
box{<0,0,-0.050800><0.435720,0.036000,0.050800> rotate<0,63.424882,0> translate<56.929300,0.000000,38.806200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.929300,0.000000,38.806200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.929300,0.000000,39.001100>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,90.000000,0> translate<56.929300,0.000000,39.001100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.929300,0.000000,39.001100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.124200,0.000000,39.196000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<56.929300,0.000000,39.001100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.124200,0.000000,39.196000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.514000,0.000000,39.196000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<57.124200,0.000000,39.196000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.514000,0.000000,39.196000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,39.001100>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<57.514000,0.000000,39.196000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,39.001100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,38.611300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<57.708800,0.000000,38.611300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.708800,0.000000,38.611300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.514000,0.000000,38.416500>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<57.514000,0.000000,38.416500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,23.088600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.052500,0.000000,23.088600>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<52.052500,0.000000,23.088600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.052500,0.000000,23.088600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,23.478300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<51.662700,0.000000,23.478300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,23.478300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.052500,0.000000,23.868100>}
box{<0,0,-0.050800><0.551260,0.036000,0.050800> rotate<0,-44.997030,0> translate<51.662700,0.000000,23.478300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.052500,0.000000,23.868100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,23.868100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<52.052500,0.000000,23.868100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.247400,0.000000,23.088600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.247400,0.000000,23.868100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<52.247400,0.000000,23.868100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,24.257900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,24.257900>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<51.662700,0.000000,24.257900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,24.257900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,25.037400>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,-33.686713,0> translate<51.662700,0.000000,24.257900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,25.037400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,25.037400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<51.662700,0.000000,25.037400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,25.427200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.052500,0.000000,25.427200>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<52.052500,0.000000,25.427200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.052500,0.000000,25.427200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,25.816900>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<51.662700,0.000000,25.816900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,25.816900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.052500,0.000000,26.206700>}
box{<0,0,-0.050800><0.551260,0.036000,0.050800> rotate<0,-44.997030,0> translate<51.662700,0.000000,25.816900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.052500,0.000000,26.206700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,26.206700>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<52.052500,0.000000,26.206700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.247400,0.000000,25.427200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.247400,0.000000,26.206700>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<52.247400,0.000000,26.206700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,26.596500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,26.596500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<51.662700,0.000000,26.596500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,26.596500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,27.376000>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<52.832000,0.000000,27.376000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,28.350400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,27.960600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<51.662700,0.000000,27.960600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,27.960600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.857600,0.000000,27.765800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<51.662700,0.000000,27.960600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.857600,0.000000,27.765800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.637200,0.000000,27.765800>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<51.857600,0.000000,27.765800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.637200,0.000000,27.765800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,27.960600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<52.637200,0.000000,27.765800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,27.960600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,28.350400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<52.832000,0.000000,28.350400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,28.350400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.637200,0.000000,28.545300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<52.637200,0.000000,28.545300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.637200,0.000000,28.545300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.857600,0.000000,28.545300>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<51.857600,0.000000,28.545300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.857600,0.000000,28.545300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,28.350400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<51.662700,0.000000,28.350400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.857600,0.000000,29.714600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,29.519700>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<51.662700,0.000000,29.519700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,29.519700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,29.129900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<51.662700,0.000000,29.129900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,29.129900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.857600,0.000000,28.935100>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<51.662700,0.000000,29.129900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.857600,0.000000,28.935100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.637200,0.000000,28.935100>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<51.857600,0.000000,28.935100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.637200,0.000000,28.935100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,29.129900>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<52.637200,0.000000,28.935100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,29.129900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,29.519700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<52.832000,0.000000,29.519700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,29.519700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.637200,0.000000,29.714600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<52.637200,0.000000,29.714600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.637200,0.000000,29.714600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.247400,0.000000,29.714600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<52.247400,0.000000,29.714600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.247400,0.000000,29.714600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.247400,0.000000,29.324800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<52.247400,0.000000,29.324800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.637200,0.000000,31.273700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.857600,0.000000,31.273700>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<51.857600,0.000000,31.273700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.857600,0.000000,31.273700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,31.468500>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<51.662700,0.000000,31.468500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,31.468500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,31.858300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<51.662700,0.000000,31.858300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,31.858300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.857600,0.000000,32.053200>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<51.662700,0.000000,31.858300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.857600,0.000000,32.053200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.637200,0.000000,32.053200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<51.857600,0.000000,32.053200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.637200,0.000000,32.053200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,31.858300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<52.637200,0.000000,32.053200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,31.858300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,31.468500>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<52.832000,0.000000,31.468500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,31.468500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.637200,0.000000,31.273700>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<52.637200,0.000000,31.273700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.637200,0.000000,31.273700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.857600,0.000000,32.053200>}
box{<0,0,-0.050800><1.102450,0.036000,0.050800> rotate<0,44.993355,0> translate<51.857600,0.000000,32.053200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,33.612300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,34.391800>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,33.686713,0> translate<51.662700,0.000000,34.391800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,35.950900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,35.950900>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<51.662700,0.000000,35.950900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,35.950900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,36.535500>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<52.832000,0.000000,36.535500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,36.535500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.637200,0.000000,36.730400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<52.637200,0.000000,36.730400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.637200,0.000000,36.730400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.857600,0.000000,36.730400>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<51.857600,0.000000,36.730400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.857600,0.000000,36.730400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,36.535500>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<51.662700,0.000000,36.535500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,36.535500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,35.950900>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<51.662700,0.000000,35.950900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.052500,0.000000,37.120200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,37.509900>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<51.662700,0.000000,37.509900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,37.509900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,37.509900>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<51.662700,0.000000,37.509900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,37.120200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,37.899700>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<52.832000,0.000000,37.899700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.832000,0.000000,38.874100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,38.874100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<51.662700,0.000000,38.874100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.662700,0.000000,38.874100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.247400,0.000000,38.289500>}
box{<0,0,-0.050800><0.826820,0.036000,0.050800> rotate<0,44.992130,0> translate<51.662700,0.000000,38.874100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.247400,0.000000,38.289500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.247400,0.000000,39.069000>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<52.247400,0.000000,39.069000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.592000,0.000000,22.555200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.422700,0.000000,22.555200>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<46.422700,0.000000,22.555200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.422700,0.000000,22.555200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.422700,0.000000,23.139800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<46.422700,0.000000,23.139800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.422700,0.000000,23.139800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.617600,0.000000,23.334700>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<46.422700,0.000000,23.139800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.617600,0.000000,23.334700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.007400,0.000000,23.334700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<46.617600,0.000000,23.334700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.007400,0.000000,23.334700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.202300,0.000000,23.139800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<47.007400,0.000000,23.334700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.202300,0.000000,23.139800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.202300,0.000000,22.555200>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<47.202300,0.000000,22.555200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.202300,0.000000,22.944900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.592000,0.000000,23.334700>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<47.202300,0.000000,22.944900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.422700,0.000000,24.504000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.422700,0.000000,23.724500>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<46.422700,0.000000,23.724500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.422700,0.000000,23.724500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.592000,0.000000,23.724500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<46.422700,0.000000,23.724500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.592000,0.000000,23.724500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.592000,0.000000,24.504000>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<47.592000,0.000000,24.504000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.007400,0.000000,23.724500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.007400,0.000000,24.114200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<47.007400,0.000000,24.114200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.617600,0.000000,25.673300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.422700,0.000000,25.478400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<46.422700,0.000000,25.478400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.422700,0.000000,25.478400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.422700,0.000000,25.088600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<46.422700,0.000000,25.088600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.422700,0.000000,25.088600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.617600,0.000000,24.893800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<46.422700,0.000000,25.088600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.617600,0.000000,24.893800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.812500,0.000000,24.893800>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<46.617600,0.000000,24.893800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.812500,0.000000,24.893800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.007400,0.000000,25.088600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<46.812500,0.000000,24.893800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.007400,0.000000,25.088600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.007400,0.000000,25.478400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<47.007400,0.000000,25.478400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.007400,0.000000,25.478400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.202300,0.000000,25.673300>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<47.007400,0.000000,25.478400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.202300,0.000000,25.673300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.397200,0.000000,25.673300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<47.202300,0.000000,25.673300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.397200,0.000000,25.673300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.592000,0.000000,25.478400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<47.397200,0.000000,25.673300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.592000,0.000000,25.478400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.592000,0.000000,25.088600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<47.592000,0.000000,25.088600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.592000,0.000000,25.088600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.397200,0.000000,24.893800>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<47.397200,0.000000,24.893800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.422700,0.000000,26.842600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.422700,0.000000,26.063100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<46.422700,0.000000,26.063100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.422700,0.000000,26.063100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.592000,0.000000,26.063100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<46.422700,0.000000,26.063100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.592000,0.000000,26.063100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.592000,0.000000,26.842600>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<47.592000,0.000000,26.842600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.007400,0.000000,26.063100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.007400,0.000000,26.452800>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<47.007400,0.000000,26.452800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.592000,0.000000,27.622100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.422700,0.000000,27.622100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<46.422700,0.000000,27.622100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.422700,0.000000,27.232400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.422700,0.000000,28.011900>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<46.422700,0.000000,28.011900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.486600,0.000000,22.428200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.707100,0.000000,22.428200>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<31.707100,0.000000,22.428200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.707100,0.000000,22.428200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.317300,0.000000,22.817900>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<31.317300,0.000000,22.817900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.317300,0.000000,22.817900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.707100,0.000000,23.207700>}
box{<0,0,-0.050800><0.551260,0.036000,0.050800> rotate<0,-44.997030,0> translate<31.317300,0.000000,22.817900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.707100,0.000000,23.207700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.486600,0.000000,23.207700>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<31.707100,0.000000,23.207700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.902000,0.000000,22.428200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.902000,0.000000,23.207700>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<31.902000,0.000000,23.207700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.486600,0.000000,23.597500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.317300,0.000000,23.597500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<31.317300,0.000000,23.597500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.317300,0.000000,23.597500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.317300,0.000000,24.182100>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<31.317300,0.000000,24.182100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.317300,0.000000,24.182100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.512200,0.000000,24.377000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<31.317300,0.000000,24.182100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.512200,0.000000,24.377000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.902000,0.000000,24.377000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<31.512200,0.000000,24.377000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.902000,0.000000,24.377000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.096900,0.000000,24.182100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<31.902000,0.000000,24.377000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.096900,0.000000,24.182100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.096900,0.000000,23.597500>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<32.096900,0.000000,23.597500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.096900,0.000000,23.987200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.486600,0.000000,24.377000>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<32.096900,0.000000,23.987200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.317300,0.000000,25.546300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.317300,0.000000,24.766800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<31.317300,0.000000,24.766800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.317300,0.000000,24.766800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.486600,0.000000,24.766800>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<31.317300,0.000000,24.766800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.486600,0.000000,24.766800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.486600,0.000000,25.546300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<32.486600,0.000000,25.546300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.902000,0.000000,24.766800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.902000,0.000000,25.156500>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<31.902000,0.000000,25.156500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.486600,0.000000,25.936100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.317300,0.000000,25.936100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<31.317300,0.000000,25.936100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.317300,0.000000,25.936100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.317300,0.000000,26.715600>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<31.317300,0.000000,26.715600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.902000,0.000000,25.936100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.902000,0.000000,26.325800>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<31.902000,0.000000,26.325800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.604100,0.000000,58.771600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.290600,0.000000,58.458100>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<74.290600,0.000000,58.458100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.290600,0.000000,58.458100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.977100,0.000000,58.458100>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<73.977100,0.000000,58.458100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.977100,0.000000,58.458100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.663500,0.000000,58.771600>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<73.663500,0.000000,58.771600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.604100,0.000000,59.081700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.663500,0.000000,59.081700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<73.663500,0.000000,59.081700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.663500,0.000000,59.081700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.663500,0.000000,59.552000>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<73.663500,0.000000,59.552000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.663500,0.000000,59.552000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.820300,0.000000,59.708700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<73.663500,0.000000,59.552000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.820300,0.000000,59.708700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.133800,0.000000,59.708700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<73.820300,0.000000,59.708700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.133800,0.000000,59.708700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.290600,0.000000,59.552000>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<74.133800,0.000000,59.708700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.290600,0.000000,59.552000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.290600,0.000000,59.081700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<74.290600,0.000000,59.081700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.663500,0.000000,60.017200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.604100,0.000000,60.017200>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<73.663500,0.000000,60.017200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.604100,0.000000,60.017200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.290600,0.000000,60.330700>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<74.290600,0.000000,60.330700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.290600,0.000000,60.330700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.604100,0.000000,60.644200>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<74.290600,0.000000,60.330700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.604100,0.000000,60.644200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.663500,0.000000,60.644200>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<73.663500,0.000000,60.644200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.604100,0.000000,60.952700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.663500,0.000000,60.952700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<73.663500,0.000000,60.952700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.663500,0.000000,60.952700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.977100,0.000000,61.266200>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<73.663500,0.000000,60.952700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.977100,0.000000,61.266200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.663500,0.000000,61.579700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<73.663500,0.000000,61.579700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.663500,0.000000,61.579700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.604100,0.000000,61.579700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<73.663500,0.000000,61.579700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.604100,0.000000,61.888200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.290600,0.000000,62.201700>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<74.290600,0.000000,62.201700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.290600,0.000000,62.201700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.977100,0.000000,62.201700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<73.977100,0.000000,62.201700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.977100,0.000000,62.201700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.663500,0.000000,61.888200>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<73.663500,0.000000,61.888200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.774300,0.000000,58.771600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.460800,0.000000,58.458100>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<63.460800,0.000000,58.458100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.460800,0.000000,58.458100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.147300,0.000000,58.458100>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<63.147300,0.000000,58.458100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.147300,0.000000,58.458100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.833700,0.000000,58.771600>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<62.833700,0.000000,58.771600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.774300,0.000000,59.081700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.833700,0.000000,59.081700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<62.833700,0.000000,59.081700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.833700,0.000000,59.081700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.833700,0.000000,59.552000>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<62.833700,0.000000,59.552000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.833700,0.000000,59.552000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.990500,0.000000,59.708700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<62.833700,0.000000,59.552000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.990500,0.000000,59.708700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.304000,0.000000,59.708700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<62.990500,0.000000,59.708700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.304000,0.000000,59.708700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.460800,0.000000,59.552000>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<63.304000,0.000000,59.708700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.460800,0.000000,59.552000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.460800,0.000000,59.081700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<63.460800,0.000000,59.081700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.833700,0.000000,60.017200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.774300,0.000000,60.017200>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<62.833700,0.000000,60.017200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.774300,0.000000,60.017200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.460800,0.000000,60.330700>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<63.460800,0.000000,60.330700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.460800,0.000000,60.330700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.774300,0.000000,60.644200>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<63.460800,0.000000,60.330700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.774300,0.000000,60.644200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.833700,0.000000,60.644200>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<62.833700,0.000000,60.644200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.774300,0.000000,60.952700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.833700,0.000000,60.952700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<62.833700,0.000000,60.952700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.833700,0.000000,60.952700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.147300,0.000000,61.266200>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<62.833700,0.000000,60.952700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.147300,0.000000,61.266200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.833700,0.000000,61.579700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<62.833700,0.000000,61.579700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.833700,0.000000,61.579700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.774300,0.000000,61.579700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<62.833700,0.000000,61.579700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.774300,0.000000,61.888200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.460800,0.000000,62.201700>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<63.460800,0.000000,62.201700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.460800,0.000000,62.201700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.147300,0.000000,62.201700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<63.147300,0.000000,62.201700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.147300,0.000000,62.201700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.833700,0.000000,61.888200>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<62.833700,0.000000,61.888200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.618100,0.000000,58.695400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.304600,0.000000,58.381900>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<58.304600,0.000000,58.381900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.304600,0.000000,58.381900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.991100,0.000000,58.381900>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<57.991100,0.000000,58.381900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.991100,0.000000,58.381900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.677500,0.000000,58.695400>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<57.677500,0.000000,58.695400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.618100,0.000000,59.005500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.677500,0.000000,59.005500>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<57.677500,0.000000,59.005500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.677500,0.000000,59.005500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.677500,0.000000,59.475800>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<57.677500,0.000000,59.475800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.677500,0.000000,59.475800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.834300,0.000000,59.632500>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<57.677500,0.000000,59.475800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.834300,0.000000,59.632500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.147800,0.000000,59.632500>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<57.834300,0.000000,59.632500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.147800,0.000000,59.632500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.304600,0.000000,59.475800>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<58.147800,0.000000,59.632500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.304600,0.000000,59.475800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.304600,0.000000,59.005500>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<58.304600,0.000000,59.005500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.677500,0.000000,59.941000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.618100,0.000000,59.941000>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<57.677500,0.000000,59.941000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.618100,0.000000,59.941000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.304600,0.000000,60.254500>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<58.304600,0.000000,60.254500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.304600,0.000000,60.254500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.618100,0.000000,60.568000>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<58.304600,0.000000,60.254500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.618100,0.000000,60.568000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.677500,0.000000,60.568000>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<57.677500,0.000000,60.568000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.618100,0.000000,60.876500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.677500,0.000000,60.876500>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<57.677500,0.000000,60.876500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.677500,0.000000,60.876500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.991100,0.000000,61.190000>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<57.677500,0.000000,60.876500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.991100,0.000000,61.190000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.677500,0.000000,61.503500>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<57.677500,0.000000,61.503500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.677500,0.000000,61.503500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.618100,0.000000,61.503500>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<57.677500,0.000000,61.503500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.618100,0.000000,61.812000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.304600,0.000000,62.125500>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<58.304600,0.000000,62.125500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.304600,0.000000,62.125500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.991100,0.000000,62.125500>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<57.991100,0.000000,62.125500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.991100,0.000000,62.125500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.677500,0.000000,61.812000>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<57.677500,0.000000,61.812000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.200300,0.000000,58.771600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.886800,0.000000,58.458100>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<42.886800,0.000000,58.458100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.886800,0.000000,58.458100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.573300,0.000000,58.458100>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<42.573300,0.000000,58.458100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.573300,0.000000,58.458100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.259700,0.000000,58.771600>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<42.259700,0.000000,58.771600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.200300,0.000000,59.081700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.259700,0.000000,59.081700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<42.259700,0.000000,59.081700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.259700,0.000000,59.081700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.259700,0.000000,59.552000>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<42.259700,0.000000,59.552000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.259700,0.000000,59.552000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.416500,0.000000,59.708700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<42.259700,0.000000,59.552000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.416500,0.000000,59.708700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.730000,0.000000,59.708700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<42.416500,0.000000,59.708700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.730000,0.000000,59.708700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.886800,0.000000,59.552000>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<42.730000,0.000000,59.708700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.886800,0.000000,59.552000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.886800,0.000000,59.081700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<42.886800,0.000000,59.081700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.259700,0.000000,60.017200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.200300,0.000000,60.017200>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<42.259700,0.000000,60.017200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.200300,0.000000,60.017200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.886800,0.000000,60.330700>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<42.886800,0.000000,60.330700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.886800,0.000000,60.330700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.200300,0.000000,60.644200>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<42.886800,0.000000,60.330700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.200300,0.000000,60.644200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.259700,0.000000,60.644200>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<42.259700,0.000000,60.644200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.200300,0.000000,60.952700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.259700,0.000000,60.952700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<42.259700,0.000000,60.952700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.259700,0.000000,60.952700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.573300,0.000000,61.266200>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<42.259700,0.000000,60.952700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.573300,0.000000,61.266200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.259700,0.000000,61.579700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<42.259700,0.000000,61.579700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.259700,0.000000,61.579700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.200300,0.000000,61.579700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<42.259700,0.000000,61.579700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.200300,0.000000,61.888200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.886800,0.000000,62.201700>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<42.886800,0.000000,62.201700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.886800,0.000000,62.201700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.573300,0.000000,62.201700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<42.573300,0.000000,62.201700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.573300,0.000000,62.201700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.259700,0.000000,61.888200>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<42.259700,0.000000,61.888200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.475900,0.000000,58.771600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.162400,0.000000,58.458100>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<38.162400,0.000000,58.458100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.162400,0.000000,58.458100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.848900,0.000000,58.458100>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<37.848900,0.000000,58.458100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.848900,0.000000,58.458100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.535300,0.000000,58.771600>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<37.535300,0.000000,58.771600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.475900,0.000000,59.081700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.535300,0.000000,59.081700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<37.535300,0.000000,59.081700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.535300,0.000000,59.081700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.535300,0.000000,59.552000>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<37.535300,0.000000,59.552000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.535300,0.000000,59.552000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.692100,0.000000,59.708700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<37.535300,0.000000,59.552000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.692100,0.000000,59.708700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.005600,0.000000,59.708700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<37.692100,0.000000,59.708700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.005600,0.000000,59.708700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.162400,0.000000,59.552000>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<38.005600,0.000000,59.708700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.162400,0.000000,59.552000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.162400,0.000000,59.081700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<38.162400,0.000000,59.081700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.535300,0.000000,60.017200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.475900,0.000000,60.017200>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<37.535300,0.000000,60.017200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.475900,0.000000,60.017200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.162400,0.000000,60.330700>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<38.162400,0.000000,60.330700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.162400,0.000000,60.330700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.475900,0.000000,60.644200>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<38.162400,0.000000,60.330700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.475900,0.000000,60.644200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.535300,0.000000,60.644200>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<37.535300,0.000000,60.644200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.475900,0.000000,60.952700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.535300,0.000000,60.952700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<37.535300,0.000000,60.952700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.535300,0.000000,60.952700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.848900,0.000000,61.266200>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<37.535300,0.000000,60.952700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.848900,0.000000,61.266200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.535300,0.000000,61.579700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<37.535300,0.000000,61.579700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.535300,0.000000,61.579700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.475900,0.000000,61.579700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<37.535300,0.000000,61.579700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.475900,0.000000,61.888200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.162400,0.000000,62.201700>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<38.162400,0.000000,62.201700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.162400,0.000000,62.201700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.848900,0.000000,62.201700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<37.848900,0.000000,62.201700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.848900,0.000000,62.201700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.535300,0.000000,61.888200>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<37.535300,0.000000,61.888200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.116500,0.000000,59.695400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.803000,0.000000,59.381900>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<32.803000,0.000000,59.381900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.803000,0.000000,59.381900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.489500,0.000000,59.381900>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<32.489500,0.000000,59.381900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.489500,0.000000,59.381900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.175900,0.000000,59.695400>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<32.175900,0.000000,59.695400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.116500,0.000000,60.005500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.175900,0.000000,60.005500>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<32.175900,0.000000,60.005500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.175900,0.000000,60.005500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.175900,0.000000,60.475800>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<32.175900,0.000000,60.475800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.175900,0.000000,60.475800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.332700,0.000000,60.632500>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<32.175900,0.000000,60.475800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.332700,0.000000,60.632500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.646200,0.000000,60.632500>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<32.332700,0.000000,60.632500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.646200,0.000000,60.632500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.803000,0.000000,60.475800>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<32.646200,0.000000,60.632500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.803000,0.000000,60.475800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.803000,0.000000,60.005500>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<32.803000,0.000000,60.005500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.175900,0.000000,60.941000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.116500,0.000000,60.941000>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<32.175900,0.000000,60.941000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.116500,0.000000,60.941000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.803000,0.000000,61.254500>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<32.803000,0.000000,61.254500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.803000,0.000000,61.254500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.116500,0.000000,61.568000>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<32.803000,0.000000,61.254500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.116500,0.000000,61.568000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.175900,0.000000,61.568000>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<32.175900,0.000000,61.568000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.116500,0.000000,61.876500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.175900,0.000000,61.876500>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<32.175900,0.000000,61.876500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.175900,0.000000,61.876500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.489500,0.000000,62.190000>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<32.175900,0.000000,61.876500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.489500,0.000000,62.190000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.175900,0.000000,62.503500>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<32.175900,0.000000,62.503500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.175900,0.000000,62.503500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.116500,0.000000,62.503500>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<32.175900,0.000000,62.503500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.116500,0.000000,62.812000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.803000,0.000000,63.125500>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<32.803000,0.000000,63.125500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.803000,0.000000,63.125500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.489500,0.000000,63.125500>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<32.489500,0.000000,63.125500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.489500,0.000000,63.125500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.175900,0.000000,62.812000>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<32.175900,0.000000,62.812000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.848000,0.000000,67.300800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,67.029600>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-45.007595,0> translate<91.576900,0.000000,67.029600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,67.029600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,66.487300>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,-90.000000,0> translate<91.576900,0.000000,66.487300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,66.487300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.848000,0.000000,66.216200>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<91.576900,0.000000,66.487300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.848000,0.000000,66.216200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,66.216200>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,0.000000,0> translate<91.848000,0.000000,66.216200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,66.216200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,66.487300>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<92.932700,0.000000,66.216200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,66.487300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,67.029600>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,90.000000,0> translate<93.203800,0.000000,67.029600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,67.029600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,67.300800>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,45.007595,0> translate<92.932700,0.000000,67.300800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,67.300800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,67.300800>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<92.390400,0.000000,67.300800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,67.300800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,66.758500>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,-90.000000,0> translate<92.390400,0.000000,66.758500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,67.853300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,67.853300>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,0.000000,0> translate<91.576900,0.000000,67.853300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,67.853300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,68.937900>}
box{<0,0,-0.076200><1.955290,0.036000,0.076200> rotate<0,-33.687844,0> translate<91.576900,0.000000,67.853300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,68.937900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,68.937900>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,0.000000,0> translate<91.576900,0.000000,68.937900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,69.490400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,69.490400>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,0.000000,0> translate<91.576900,0.000000,69.490400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,69.490400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,70.303800>}
box{<0,0,-0.076200><0.813400,0.036000,0.076200> rotate<0,90.000000,0> translate<93.203800,0.000000,70.303800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,70.303800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,70.575000>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,45.007595,0> translate<92.932700,0.000000,70.575000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,70.575000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.848000,0.000000,70.575000>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,0.000000,0> translate<91.848000,0.000000,70.575000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.848000,0.000000,70.575000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,70.303800>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-45.007595,0> translate<91.576900,0.000000,70.303800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,70.303800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,69.490400>}
box{<0,0,-0.076200><0.813400,0.036000,0.076200> rotate<0,-90.000000,0> translate<91.576900,0.000000,69.490400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.848000,0.000000,46.980800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,46.709600>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-45.007595,0> translate<91.576900,0.000000,46.709600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,46.709600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,46.167300>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,-90.000000,0> translate<91.576900,0.000000,46.167300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,46.167300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.848000,0.000000,45.896200>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<91.576900,0.000000,46.167300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.848000,0.000000,45.896200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,45.896200>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,0.000000,0> translate<91.848000,0.000000,45.896200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,45.896200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,46.167300>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<92.932700,0.000000,45.896200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,46.167300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,46.709600>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,90.000000,0> translate<93.203800,0.000000,46.709600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,46.709600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,46.980800>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,45.007595,0> translate<92.932700,0.000000,46.980800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,46.980800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,46.980800>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<92.390400,0.000000,46.980800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,46.980800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,46.438500>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,-90.000000,0> translate<92.390400,0.000000,46.438500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,47.533300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,47.533300>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,0.000000,0> translate<91.576900,0.000000,47.533300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,47.533300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,48.617900>}
box{<0,0,-0.076200><1.955290,0.036000,0.076200> rotate<0,-33.687844,0> translate<91.576900,0.000000,47.533300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,48.617900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,48.617900>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,0.000000,0> translate<91.576900,0.000000,48.617900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,49.170400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,49.170400>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,0.000000,0> translate<91.576900,0.000000,49.170400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,49.170400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,49.983800>}
box{<0,0,-0.076200><0.813400,0.036000,0.076200> rotate<0,90.000000,0> translate<93.203800,0.000000,49.983800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,49.983800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,50.255000>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,45.007595,0> translate<92.932700,0.000000,50.255000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,50.255000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.848000,0.000000,50.255000>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,0.000000,0> translate<91.848000,0.000000,50.255000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.848000,0.000000,50.255000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,49.983800>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-45.007595,0> translate<91.576900,0.000000,49.983800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,49.983800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,49.170400>}
box{<0,0,-0.076200><0.813400,0.036000,0.076200> rotate<0,-90.000000,0> translate<91.576900,0.000000,49.170400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.848000,0.000000,26.660800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,26.389600>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-45.007595,0> translate<91.576900,0.000000,26.389600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,26.389600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,25.847300>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,-90.000000,0> translate<91.576900,0.000000,25.847300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,25.847300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.848000,0.000000,25.576200>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<91.576900,0.000000,25.847300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.848000,0.000000,25.576200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,25.576200>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,0.000000,0> translate<91.848000,0.000000,25.576200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,25.576200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,25.847300>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<92.932700,0.000000,25.576200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,25.847300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,26.389600>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,90.000000,0> translate<93.203800,0.000000,26.389600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,26.389600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,26.660800>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,45.007595,0> translate<92.932700,0.000000,26.660800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,26.660800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,26.660800>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<92.390400,0.000000,26.660800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,26.660800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,26.118500>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,-90.000000,0> translate<92.390400,0.000000,26.118500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,27.213300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,27.213300>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,0.000000,0> translate<91.576900,0.000000,27.213300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,27.213300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,28.297900>}
box{<0,0,-0.076200><1.955290,0.036000,0.076200> rotate<0,-33.687844,0> translate<91.576900,0.000000,27.213300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,28.297900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,28.297900>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,0.000000,0> translate<91.576900,0.000000,28.297900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,28.850400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,28.850400>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,0.000000,0> translate<91.576900,0.000000,28.850400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,28.850400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,29.663800>}
box{<0,0,-0.076200><0.813400,0.036000,0.076200> rotate<0,90.000000,0> translate<93.203800,0.000000,29.663800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,29.663800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,29.935000>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,45.007595,0> translate<92.932700,0.000000,29.935000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,29.935000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.848000,0.000000,29.935000>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,0.000000,0> translate<91.848000,0.000000,29.935000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.848000,0.000000,29.935000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,29.663800>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-45.007595,0> translate<91.576900,0.000000,29.663800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,29.663800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,28.850400>}
box{<0,0,-0.076200><0.813400,0.036000,0.076200> rotate<0,-90.000000,0> translate<91.576900,0.000000,28.850400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,15.416200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.661500,0.000000,15.416200>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<91.576900,0.000000,15.416200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.661500,0.000000,15.416200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,15.958500>}
box{<0,0,-0.076200><0.766928,0.036000,0.076200> rotate<0,-44.997030,0> translate<92.661500,0.000000,15.416200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,15.958500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.661500,0.000000,16.500800>}
box{<0,0,-0.076200><0.766928,0.036000,0.076200> rotate<0,44.997030,0> translate<92.661500,0.000000,16.500800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.661500,0.000000,16.500800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,16.500800>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<91.576900,0.000000,16.500800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.119200,0.000000,17.053300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.119200,0.000000,17.324400>}
box{<0,0,-0.076200><0.271100,0.036000,0.076200> rotate<0,90.000000,0> translate<92.119200,0.000000,17.324400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.119200,0.000000,17.324400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,17.324400>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<92.119200,0.000000,17.324400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,17.053300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,17.595600>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,90.000000,0> translate<93.203800,0.000000,17.595600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.305700,0.000000,17.324400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,17.324400>}
box{<0,0,-0.076200><0.271200,0.036000,0.076200> rotate<0,0.000000,0> translate<91.305700,0.000000,17.324400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,18.144700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.119200,0.000000,18.144700>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<92.119200,0.000000,18.144700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.119200,0.000000,18.144700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.119200,0.000000,18.958100>}
box{<0,0,-0.076200><0.813400,0.036000,0.076200> rotate<0,90.000000,0> translate<92.119200,0.000000,18.958100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.119200,0.000000,18.958100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,19.229300>}
box{<0,0,-0.076200><0.383535,0.036000,0.076200> rotate<0,-44.997030,0> translate<92.119200,0.000000,18.958100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,19.229300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,19.229300>}
box{<0,0,-0.076200><0.813400,0.036000,0.076200> rotate<0,0.000000,0> translate<92.390400,0.000000,19.229300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.848000,0.000000,56.056200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,56.327300>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<91.576900,0.000000,56.327300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,56.327300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,56.869600>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,90.000000,0> translate<91.576900,0.000000,56.869600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,56.869600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.848000,0.000000,57.140800>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-45.007595,0> translate<91.576900,0.000000,56.869600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.848000,0.000000,57.140800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.119200,0.000000,57.140800>}
box{<0,0,-0.076200><0.271200,0.036000,0.076200> rotate<0,0.000000,0> translate<91.848000,0.000000,57.140800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.119200,0.000000,57.140800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,56.869600>}
box{<0,0,-0.076200><0.383535,0.036000,0.076200> rotate<0,44.997030,0> translate<92.119200,0.000000,57.140800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,56.869600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,56.598500>}
box{<0,0,-0.076200><0.271100,0.036000,0.076200> rotate<0,-90.000000,0> translate<92.390400,0.000000,56.598500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,56.869600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.661500,0.000000,57.140800>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-45.007595,0> translate<92.390400,0.000000,56.869600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.661500,0.000000,57.140800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,57.140800>}
box{<0,0,-0.076200><0.271200,0.036000,0.076200> rotate<0,0.000000,0> translate<92.661500,0.000000,57.140800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,57.140800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,56.869600>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,45.007595,0> translate<92.932700,0.000000,57.140800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,56.869600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,56.327300>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,-90.000000,0> translate<93.203800,0.000000,56.327300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,56.327300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,56.056200>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<92.932700,0.000000,56.056200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,57.693300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.661500,0.000000,57.693300>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<91.576900,0.000000,57.693300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.661500,0.000000,57.693300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,58.235600>}
box{<0,0,-0.076200><0.766928,0.036000,0.076200> rotate<0,-44.997030,0> translate<92.661500,0.000000,57.693300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,58.235600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.661500,0.000000,58.777900>}
box{<0,0,-0.076200><0.766928,0.036000,0.076200> rotate<0,44.997030,0> translate<92.661500,0.000000,58.777900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.661500,0.000000,58.777900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,58.777900>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<91.576900,0.000000,58.777900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.848000,0.000000,59.330400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,59.601500>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<91.576900,0.000000,59.601500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,59.601500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,60.143800>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,90.000000,0> translate<91.576900,0.000000,60.143800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,60.143800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.848000,0.000000,60.415000>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-45.007595,0> translate<91.576900,0.000000,60.143800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.848000,0.000000,60.415000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.119200,0.000000,60.415000>}
box{<0,0,-0.076200><0.271200,0.036000,0.076200> rotate<0,0.000000,0> translate<91.848000,0.000000,60.415000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.119200,0.000000,60.415000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,60.143800>}
box{<0,0,-0.076200><0.383535,0.036000,0.076200> rotate<0,44.997030,0> translate<92.119200,0.000000,60.415000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,60.143800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,59.872700>}
box{<0,0,-0.076200><0.271100,0.036000,0.076200> rotate<0,-90.000000,0> translate<92.390400,0.000000,59.872700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,60.143800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.661500,0.000000,60.415000>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-45.007595,0> translate<92.390400,0.000000,60.143800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.661500,0.000000,60.415000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,60.415000>}
box{<0,0,-0.076200><0.271200,0.036000,0.076200> rotate<0,0.000000,0> translate<92.661500,0.000000,60.415000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,60.415000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,60.143800>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,45.007595,0> translate<92.932700,0.000000,60.415000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,60.143800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,59.601500>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,-90.000000,0> translate<93.203800,0.000000,59.601500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,59.601500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,59.330400>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<92.932700,0.000000,59.330400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,36.820800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,35.736200>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,-90.000000,0> translate<91.576900,0.000000,35.736200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,35.736200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,35.736200>}
box{<0,0,-0.076200><0.813500,0.036000,0.076200> rotate<0,0.000000,0> translate<91.576900,0.000000,35.736200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,35.736200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.119200,0.000000,36.278500>}
box{<0,0,-0.076200><0.606332,0.036000,0.076200> rotate<0,63.426537,0> translate<92.119200,0.000000,36.278500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.119200,0.000000,36.278500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.119200,0.000000,36.549600>}
box{<0,0,-0.076200><0.271100,0.036000,0.076200> rotate<0,90.000000,0> translate<92.119200,0.000000,36.549600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.119200,0.000000,36.549600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,36.820800>}
box{<0,0,-0.076200><0.383535,0.036000,0.076200> rotate<0,-44.997030,0> translate<92.119200,0.000000,36.549600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.390400,0.000000,36.820800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,36.820800>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<92.390400,0.000000,36.820800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,36.820800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,36.549600>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,45.007595,0> translate<92.932700,0.000000,36.820800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,36.549600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,36.007300>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,-90.000000,0> translate<93.203800,0.000000,36.007300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,36.007300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.932700,0.000000,35.736200>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<92.932700,0.000000,35.736200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,37.373300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.661500,0.000000,37.373300>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<91.576900,0.000000,37.373300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.661500,0.000000,37.373300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,37.915600>}
box{<0,0,-0.076200><0.766928,0.036000,0.076200> rotate<0,-44.997030,0> translate<92.661500,0.000000,37.373300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.203800,0.000000,37.915600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.661500,0.000000,38.457900>}
box{<0,0,-0.076200><0.766928,0.036000,0.076200> rotate<0,44.997030,0> translate<92.661500,0.000000,38.457900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.661500,0.000000,38.457900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.576900,0.000000,38.457900>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<91.576900,0.000000,38.457900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.116900,0.000000,24.020800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.116900,0.000000,22.936200>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,-90.000000,0> translate<82.116900,0.000000,22.936200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.116900,0.000000,22.936200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.930400,0.000000,22.936200>}
box{<0,0,-0.076200><0.813500,0.036000,0.076200> rotate<0,0.000000,0> translate<82.116900,0.000000,22.936200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.930400,0.000000,22.936200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.659200,0.000000,23.478500>}
box{<0,0,-0.076200><0.606332,0.036000,0.076200> rotate<0,63.426537,0> translate<82.659200,0.000000,23.478500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.659200,0.000000,23.478500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.659200,0.000000,23.749600>}
box{<0,0,-0.076200><0.271100,0.036000,0.076200> rotate<0,90.000000,0> translate<82.659200,0.000000,23.749600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.659200,0.000000,23.749600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.930400,0.000000,24.020800>}
box{<0,0,-0.076200><0.383535,0.036000,0.076200> rotate<0,-44.997030,0> translate<82.659200,0.000000,23.749600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.930400,0.000000,24.020800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.472700,0.000000,24.020800>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<82.930400,0.000000,24.020800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.472700,0.000000,24.020800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.743800,0.000000,23.749600>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,45.007595,0> translate<83.472700,0.000000,24.020800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.743800,0.000000,23.749600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.743800,0.000000,23.207300>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,-90.000000,0> translate<83.743800,0.000000,23.207300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.743800,0.000000,23.207300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.472700,0.000000,22.936200>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<83.472700,0.000000,22.936200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.116900,0.000000,24.573300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.201500,0.000000,24.573300>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<82.116900,0.000000,24.573300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.201500,0.000000,24.573300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.743800,0.000000,25.115600>}
box{<0,0,-0.076200><0.766928,0.036000,0.076200> rotate<0,-44.997030,0> translate<83.201500,0.000000,24.573300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.743800,0.000000,25.115600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.201500,0.000000,25.657900>}
box{<0,0,-0.076200><0.766928,0.036000,0.076200> rotate<0,44.997030,0> translate<83.201500,0.000000,25.657900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.201500,0.000000,25.657900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.116900,0.000000,25.657900>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<82.116900,0.000000,25.657900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.196900,0.000000,24.020800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.196900,0.000000,22.936200>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,-90.000000,0> translate<87.196900,0.000000,22.936200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.196900,0.000000,22.936200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.010400,0.000000,22.936200>}
box{<0,0,-0.076200><0.813500,0.036000,0.076200> rotate<0,0.000000,0> translate<87.196900,0.000000,22.936200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.010400,0.000000,22.936200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.739200,0.000000,23.478500>}
box{<0,0,-0.076200><0.606332,0.036000,0.076200> rotate<0,63.426537,0> translate<87.739200,0.000000,23.478500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.739200,0.000000,23.478500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.739200,0.000000,23.749600>}
box{<0,0,-0.076200><0.271100,0.036000,0.076200> rotate<0,90.000000,0> translate<87.739200,0.000000,23.749600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.739200,0.000000,23.749600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.010400,0.000000,24.020800>}
box{<0,0,-0.076200><0.383535,0.036000,0.076200> rotate<0,-44.997030,0> translate<87.739200,0.000000,23.749600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.010400,0.000000,24.020800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.552700,0.000000,24.020800>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<88.010400,0.000000,24.020800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.552700,0.000000,24.020800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.823800,0.000000,23.749600>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,45.007595,0> translate<88.552700,0.000000,24.020800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.823800,0.000000,23.749600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.823800,0.000000,23.207300>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,-90.000000,0> translate<88.823800,0.000000,23.207300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.823800,0.000000,23.207300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.552700,0.000000,22.936200>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<88.552700,0.000000,22.936200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.196900,0.000000,24.573300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.281500,0.000000,24.573300>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<87.196900,0.000000,24.573300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.281500,0.000000,24.573300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.823800,0.000000,25.115600>}
box{<0,0,-0.076200><0.766928,0.036000,0.076200> rotate<0,-44.997030,0> translate<88.281500,0.000000,24.573300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.823800,0.000000,25.115600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.281500,0.000000,25.657900>}
box{<0,0,-0.076200><0.766928,0.036000,0.076200> rotate<0,44.997030,0> translate<88.281500,0.000000,25.657900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.281500,0.000000,25.657900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.196900,0.000000,25.657900>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<87.196900,0.000000,25.657900> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<28.448000,0.000000,70.866000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<28.448000,0.000000,56.642000>}
box{<0,0,-0.203200><14.224000,0.036000,0.203200> rotate<0,-90.000000,0> translate<28.448000,0.000000,56.642000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<28.448000,0.000000,56.642000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<34.036000,0.000000,56.642000>}
box{<0,0,-0.203200><5.588000,0.036000,0.203200> rotate<0,0.000000,0> translate<28.448000,0.000000,56.642000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<39.116000,0.000000,56.642000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<44.196000,0.000000,56.642000>}
box{<0,0,-0.203200><5.080000,0.036000,0.203200> rotate<0,0.000000,0> translate<39.116000,0.000000,56.642000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<49.276000,0.000000,56.642000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<54.356000,0.000000,56.642000>}
box{<0,0,-0.203200><5.080000,0.036000,0.203200> rotate<0,0.000000,0> translate<49.276000,0.000000,56.642000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<59.436000,0.000000,56.642000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<64.516000,0.000000,56.642000>}
box{<0,0,-0.203200><5.080000,0.036000,0.203200> rotate<0,0.000000,0> translate<59.436000,0.000000,56.642000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<69.850000,0.000000,56.642000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<74.930000,0.000000,56.642000>}
box{<0,0,-0.203200><5.080000,0.036000,0.203200> rotate<0,0.000000,0> translate<69.850000,0.000000,56.642000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<79.756000,0.000000,56.642000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<84.836000,0.000000,56.642000>}
box{<0,0,-0.203200><5.080000,0.036000,0.203200> rotate<0,0.000000,0> translate<79.756000,0.000000,56.642000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<84.836000,0.000000,56.642000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.424000,0.000000,56.642000>}
box{<0,0,-0.203200><5.588000,0.036000,0.203200> rotate<0,0.000000,0> translate<84.836000,0.000000,56.642000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.424000,0.000000,56.642000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.424000,0.000000,70.866000>}
box{<0,0,-0.203200><14.224000,0.036000,0.203200> rotate<0,90.000000,0> translate<90.424000,0.000000,70.866000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<34.036000,0.000000,70.612000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<34.036000,0.000000,56.642000>}
box{<0,0,-0.203200><13.970000,0.036000,0.203200> rotate<0,-90.000000,0> translate<34.036000,0.000000,56.642000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<34.036000,0.000000,56.642000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<39.116000,0.000000,56.642000>}
box{<0,0,-0.203200><5.080000,0.036000,0.203200> rotate<0,0.000000,0> translate<34.036000,0.000000,56.642000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<39.116000,0.000000,56.642000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<39.116000,0.000000,70.866000>}
box{<0,0,-0.203200><14.224000,0.036000,0.203200> rotate<0,90.000000,0> translate<39.116000,0.000000,70.866000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<44.196000,0.000000,70.866000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<44.196000,0.000000,56.642000>}
box{<0,0,-0.203200><14.224000,0.036000,0.203200> rotate<0,-90.000000,0> translate<44.196000,0.000000,56.642000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<44.196000,0.000000,56.642000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<49.276000,0.000000,56.642000>}
box{<0,0,-0.203200><5.080000,0.036000,0.203200> rotate<0,0.000000,0> translate<44.196000,0.000000,56.642000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<49.276000,0.000000,56.642000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<49.276000,0.000000,70.866000>}
box{<0,0,-0.203200><14.224000,0.036000,0.203200> rotate<0,90.000000,0> translate<49.276000,0.000000,70.866000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<54.356000,0.000000,70.866000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<54.356000,0.000000,56.642000>}
box{<0,0,-0.203200><14.224000,0.036000,0.203200> rotate<0,-90.000000,0> translate<54.356000,0.000000,56.642000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<54.356000,0.000000,56.642000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<59.436000,0.000000,56.642000>}
box{<0,0,-0.203200><5.080000,0.036000,0.203200> rotate<0,0.000000,0> translate<54.356000,0.000000,56.642000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<59.436000,0.000000,56.642000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<59.436000,0.000000,70.866000>}
box{<0,0,-0.203200><14.224000,0.036000,0.203200> rotate<0,90.000000,0> translate<59.436000,0.000000,70.866000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<64.516000,0.000000,70.612000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<64.516000,0.000000,56.642000>}
box{<0,0,-0.203200><13.970000,0.036000,0.203200> rotate<0,-90.000000,0> translate<64.516000,0.000000,56.642000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<64.516000,0.000000,56.642000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<69.850000,0.000000,56.642000>}
box{<0,0,-0.203200><5.334000,0.036000,0.203200> rotate<0,0.000000,0> translate<64.516000,0.000000,56.642000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<69.850000,0.000000,56.642000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<69.850000,0.000000,70.866000>}
box{<0,0,-0.203200><14.224000,0.036000,0.203200> rotate<0,90.000000,0> translate<69.850000,0.000000,70.866000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<74.930000,0.000000,70.866000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<74.930000,0.000000,56.642000>}
box{<0,0,-0.203200><14.224000,0.036000,0.203200> rotate<0,-90.000000,0> translate<74.930000,0.000000,56.642000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<74.930000,0.000000,56.642000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<79.756000,0.000000,56.642000>}
box{<0,0,-0.203200><4.826000,0.036000,0.203200> rotate<0,0.000000,0> translate<74.930000,0.000000,56.642000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<79.756000,0.000000,56.642000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<79.756000,0.000000,70.866000>}
box{<0,0,-0.203200><14.224000,0.036000,0.203200> rotate<0,90.000000,0> translate<79.756000,0.000000,70.866000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<84.836000,0.000000,70.866000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<84.836000,0.000000,56.642000>}
box{<0,0,-0.203200><14.224000,0.036000,0.203200> rotate<0,-90.000000,0> translate<84.836000,0.000000,56.642000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.678000,0.000000,14.478000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.678000,0.000000,41.400000>}
box{<0,0,-0.203200><26.922000,0.036000,0.203200> rotate<0,90.000000,0> translate<90.678000,0.000000,41.400000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<80.010000,0.000000,41.402000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<69.850000,0.000000,41.402000>}
box{<0,0,-0.203200><10.160000,0.036000,0.203200> rotate<0,0.000000,0> translate<69.850000,0.000000,41.402000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<69.850000,0.000000,41.402000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<64.770000,0.000000,41.402000>}
box{<0,0,-0.203200><5.080000,0.036000,0.203200> rotate<0,0.000000,0> translate<64.770000,0.000000,41.402000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<59.690000,0.000000,41.402000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<49.530000,0.000000,41.402000>}
box{<0,0,-0.203200><10.160000,0.036000,0.203200> rotate<0,0.000000,0> translate<49.530000,0.000000,41.402000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<49.530000,0.000000,41.402000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<39.370000,0.000000,41.402000>}
box{<0,0,-0.203200><10.160000,0.036000,0.203200> rotate<0,0.000000,0> translate<39.370000,0.000000,41.402000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<39.370000,0.000000,41.402000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<28.702000,0.000000,41.402000>}
box{<0,0,-0.203200><10.668000,0.036000,0.203200> rotate<0,0.000000,0> translate<28.702000,0.000000,41.402000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<28.702000,0.000000,41.402000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<28.702000,0.000000,14.732000>}
box{<0,0,-0.203200><26.670000,0.036000,0.203200> rotate<0,-90.000000,0> translate<28.702000,0.000000,14.732000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<34.290000,0.000000,14.478000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<34.290000,0.000000,41.148000>}
box{<0,0,-0.203200><26.670000,0.036000,0.203200> rotate<0,90.000000,0> translate<34.290000,0.000000,41.148000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<39.370000,0.000000,14.478000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<39.370000,0.000000,41.402000>}
box{<0,0,-0.203200><26.924000,0.036000,0.203200> rotate<0,90.000000,0> translate<39.370000,0.000000,41.402000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<39.370000,0.000000,41.402000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<44.450000,0.000000,41.402000>}
box{<0,0,-0.203200><5.080000,0.036000,0.203200> rotate<0,0.000000,0> translate<39.370000,0.000000,41.402000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<44.450000,0.000000,41.402000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<44.450000,0.000000,14.478000>}
box{<0,0,-0.203200><26.924000,0.036000,0.203200> rotate<0,-90.000000,0> translate<44.450000,0.000000,14.478000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<49.530000,0.000000,14.478000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<49.530000,0.000000,41.402000>}
box{<0,0,-0.203200><26.924000,0.036000,0.203200> rotate<0,90.000000,0> translate<49.530000,0.000000,41.402000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<49.530000,0.000000,41.402000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<54.610000,0.000000,41.402000>}
box{<0,0,-0.203200><5.080000,0.036000,0.203200> rotate<0,0.000000,0> translate<49.530000,0.000000,41.402000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<54.610000,0.000000,41.402000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<54.610000,0.000000,14.478000>}
box{<0,0,-0.203200><26.924000,0.036000,0.203200> rotate<0,-90.000000,0> translate<54.610000,0.000000,14.478000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<59.690000,0.000000,14.478000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<59.690000,0.000000,41.402000>}
box{<0,0,-0.203200><26.924000,0.036000,0.203200> rotate<0,90.000000,0> translate<59.690000,0.000000,41.402000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<59.690000,0.000000,41.402000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<64.770000,0.000000,41.402000>}
box{<0,0,-0.203200><5.080000,0.036000,0.203200> rotate<0,0.000000,0> translate<59.690000,0.000000,41.402000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<64.770000,0.000000,41.402000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<64.770000,0.000000,14.478000>}
box{<0,0,-0.203200><26.924000,0.036000,0.203200> rotate<0,-90.000000,0> translate<64.770000,0.000000,14.478000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<69.850000,0.000000,14.478000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<69.850000,0.000000,41.402000>}
box{<0,0,-0.203200><26.924000,0.036000,0.203200> rotate<0,90.000000,0> translate<69.850000,0.000000,41.402000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<69.850000,0.000000,41.402000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<74.930000,0.000000,41.402000>}
box{<0,0,-0.203200><5.080000,0.036000,0.203200> rotate<0,0.000000,0> translate<69.850000,0.000000,41.402000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<74.930000,0.000000,41.402000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<74.930000,0.000000,14.478000>}
box{<0,0,-0.203200><26.924000,0.036000,0.203200> rotate<0,-90.000000,0> translate<74.930000,0.000000,14.478000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<80.010000,0.000000,14.478000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<80.010000,0.000000,41.402000>}
box{<0,0,-0.203200><26.924000,0.036000,0.203200> rotate<0,90.000000,0> translate<80.010000,0.000000,41.402000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<80.264000,0.000000,41.400000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<85.090000,0.000000,41.400000>}
box{<0,0,-0.203200><4.826000,0.036000,0.203200> rotate<0,0.000000,0> translate<80.264000,0.000000,41.400000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<85.090000,0.000000,41.400000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.678000,0.000000,41.400000>}
box{<0,0,-0.203200><5.588000,0.036000,0.203200> rotate<0,0.000000,0> translate<85.090000,0.000000,41.400000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<85.090000,0.000000,14.478000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<85.090000,0.000000,41.400000>}
box{<0,0,-0.203200><26.922000,0.036000,0.203200> rotate<0,90.000000,0> translate<85.090000,0.000000,41.400000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<95.820000,0.000000,73.760000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.740000,0.000000,73.760000>}
box{<0,0,-0.203200><5.080000,0.036000,0.203200> rotate<0,0.000000,0> translate<90.740000,0.000000,73.760000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.740000,0.000000,73.760000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.740000,0.000000,63.600000>}
box{<0,0,-0.203200><10.160000,0.036000,0.203200> rotate<0,-90.000000,0> translate<90.740000,0.000000,63.600000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.740000,0.000000,63.600000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.740000,0.000000,53.440000>}
box{<0,0,-0.203200><10.160000,0.036000,0.203200> rotate<0,-90.000000,0> translate<90.740000,0.000000,53.440000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.740000,0.000000,53.440000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.740000,0.000000,43.280000>}
box{<0,0,-0.203200><10.160000,0.036000,0.203200> rotate<0,-90.000000,0> translate<90.740000,0.000000,43.280000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.740000,0.000000,43.280000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.740000,0.000000,33.120000>}
box{<0,0,-0.203200><10.160000,0.036000,0.203200> rotate<0,-90.000000,0> translate<90.740000,0.000000,33.120000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.740000,0.000000,33.120000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.740000,0.000000,22.960000>}
box{<0,0,-0.203200><10.160000,0.036000,0.203200> rotate<0,-90.000000,0> translate<90.740000,0.000000,22.960000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.740000,0.000000,22.960000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.740000,0.000000,10.260000>}
box{<0,0,-0.203200><12.700000,0.036000,0.203200> rotate<0,-90.000000,0> translate<90.740000,0.000000,10.260000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.740000,0.000000,10.260000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<95.820000,0.000000,10.260000>}
box{<0,0,-0.203200><5.080000,0.036000,0.203200> rotate<0,0.000000,0> translate<90.740000,0.000000,10.260000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<95.820000,0.000000,10.260000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<95.820000,0.000000,12.800000>}
box{<0,0,-0.203200><2.540000,0.036000,0.203200> rotate<0,90.000000,0> translate<95.820000,0.000000,12.800000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<95.820000,0.000000,63.600000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.740000,0.000000,63.600000>}
box{<0,0,-0.203200><5.080000,0.036000,0.203200> rotate<0,0.000000,0> translate<90.740000,0.000000,63.600000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<95.820000,0.000000,53.440000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.740000,0.000000,53.440000>}
box{<0,0,-0.203200><5.080000,0.036000,0.203200> rotate<0,0.000000,0> translate<90.740000,0.000000,53.440000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<95.820000,0.000000,43.280000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.740000,0.000000,43.280000>}
box{<0,0,-0.203200><5.080000,0.036000,0.203200> rotate<0,0.000000,0> translate<90.740000,0.000000,43.280000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<95.820000,0.000000,33.120000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.740000,0.000000,33.120000>}
box{<0,0,-0.203200><5.080000,0.036000,0.203200> rotate<0,0.000000,0> translate<90.740000,0.000000,33.120000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<95.820000,0.000000,22.960000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.740000,0.000000,22.960000>}
box{<0,0,-0.203200><5.080000,0.036000,0.203200> rotate<0,0.000000,0> translate<90.740000,0.000000,22.960000> }
//S1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.902000,0.000000,38.782000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.902000,0.000000,38.528000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<47.902000,0.000000,38.528000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.902000,0.000000,38.782000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.378000,0.000000,38.782000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.378000,0.000000,38.782000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.378000,0.000000,38.528000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.378000,0.000000,38.782000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<46.378000,0.000000,38.782000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.124000,0.000000,38.528000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.600000,0.000000,38.528000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<44.600000,0.000000,38.528000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.378000,0.000000,32.178000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.378000,0.000000,32.432000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<46.378000,0.000000,32.432000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.378000,0.000000,32.178000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.902000,0.000000,32.178000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.378000,0.000000,32.178000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.902000,0.000000,32.432000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.902000,0.000000,32.178000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<47.902000,0.000000,32.178000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.600000,0.000000,38.528000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.092000,0.000000,38.020000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,-44.997030,0> translate<44.092000,0.000000,38.020000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.188000,0.000000,38.020000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.680000,0.000000,38.528000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,44.997030,0> translate<49.680000,0.000000,38.528000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.680000,0.000000,38.528000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.156000,0.000000,38.528000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<48.156000,0.000000,38.528000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.092000,0.000000,32.940000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.600000,0.000000,32.432000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,44.997030,0> translate<44.092000,0.000000,32.940000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.600000,0.000000,32.432000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.124000,0.000000,32.432000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<44.600000,0.000000,32.432000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.188000,0.000000,32.940000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.680000,0.000000,32.432000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,-44.997030,0> translate<49.680000,0.000000,32.432000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.680000,0.000000,32.432000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.156000,0.000000,32.432000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<48.156000,0.000000,32.432000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<45.870000,0.000000,34.210000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<48.410000,0.000000,34.210000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,0.000000,0> translate<45.870000,0.000000,34.210000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<48.410000,0.000000,36.750000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<48.410000,0.000000,34.210000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,-90.000000,0> translate<48.410000,0.000000,34.210000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<48.410000,0.000000,36.750000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<45.870000,0.000000,36.750000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,0.000000,0> translate<45.870000,0.000000,36.750000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<45.870000,0.000000,34.210000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<45.870000,0.000000,36.750000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,90.000000,0> translate<45.870000,0.000000,36.750000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<44.092000,0.000000,34.210000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<44.346000,0.000000,34.210000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,0.000000,0> translate<44.092000,0.000000,34.210000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<44.346000,0.000000,36.750000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<44.346000,0.000000,34.210000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,-90.000000,0> translate<44.346000,0.000000,34.210000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<44.346000,0.000000,36.750000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<44.092000,0.000000,36.750000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,0.000000,0> translate<44.092000,0.000000,36.750000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<49.934000,0.000000,36.623000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<49.934000,0.000000,34.210000>}
box{<0,0,-0.025400><2.413000,0.036000,0.025400> rotate<0,-90.000000,0> translate<49.934000,0.000000,34.210000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<49.934000,0.000000,36.623000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<50.188000,0.000000,36.623000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,0.000000,0> translate<49.934000,0.000000,36.623000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<49.934000,0.000000,34.210000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<50.188000,0.000000,34.210000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,0.000000,0> translate<49.934000,0.000000,34.210000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.188000,0.000000,38.020000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.188000,0.000000,37.639000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<50.188000,0.000000,37.639000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.188000,0.000000,32.940000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.188000,0.000000,33.321000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<50.188000,0.000000,33.321000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.188000,0.000000,33.321000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.188000,0.000000,34.210000>}
box{<0,0,-0.076200><0.889000,0.036000,0.076200> rotate<0,90.000000,0> translate<50.188000,0.000000,34.210000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.092000,0.000000,32.940000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.092000,0.000000,33.321000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<44.092000,0.000000,33.321000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.092000,0.000000,38.020000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.092000,0.000000,37.639000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<44.092000,0.000000,37.639000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.092000,0.000000,37.639000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.092000,0.000000,36.750000>}
box{<0,0,-0.076200><0.889000,0.036000,0.076200> rotate<0,-90.000000,0> translate<44.092000,0.000000,36.750000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.092000,0.000000,36.750000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.092000,0.000000,34.210000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,-90.000000,0> translate<44.092000,0.000000,34.210000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.092000,0.000000,34.210000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.092000,0.000000,33.321000>}
box{<0,0,-0.076200><0.889000,0.036000,0.076200> rotate<0,-90.000000,0> translate<44.092000,0.000000,33.321000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.188000,0.000000,34.210000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.188000,0.000000,36.623000>}
box{<0,0,-0.076200><2.413000,0.036000,0.076200> rotate<0,90.000000,0> translate<50.188000,0.000000,36.623000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.188000,0.000000,36.623000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.188000,0.000000,37.639000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<50.188000,0.000000,37.639000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.902000,0.000000,38.528000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.156000,0.000000,38.528000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<47.902000,0.000000,38.528000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.378000,0.000000,38.528000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.124000,0.000000,38.528000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.124000,0.000000,38.528000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.902000,0.000000,32.432000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.156000,0.000000,32.432000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<47.902000,0.000000,32.432000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.378000,0.000000,32.432000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.124000,0.000000,32.432000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.124000,0.000000,32.432000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.299000,0.000000,34.210000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.299000,0.000000,36.750000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,90.000000,0> translate<49.299000,0.000000,36.750000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.854000,0.000000,36.750000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.854000,0.000000,34.210000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,-90.000000,0> translate<44.854000,0.000000,34.210000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.870000,0.000000,33.067000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.632000,0.000000,33.067000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<45.870000,0.000000,33.067000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.648000,0.000000,33.067000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.410000,0.000000,33.067000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<47.648000,0.000000,33.067000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.632000,0.000000,33.067000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.521000,0.000000,33.321000>}
box{<0,0,-0.076200><0.924574,0.036000,0.076200> rotate<0,-15.944344,0> translate<46.632000,0.000000,33.067000> }
difference{
cylinder{<47.140000,0,35.480000><47.140000,0.036000,35.480000>1.854200 translate<0,0.000000,0>}
cylinder{<47.140000,-0.1,35.480000><47.140000,0.135000,35.480000>1.701800 translate<0,0.000000,0>}}
difference{
cylinder{<49.299000,0,33.321000><49.299000,0.036000,33.321000>0.584200 translate<0,0.000000,0>}
cylinder{<49.299000,-0.1,33.321000><49.299000,0.135000,33.321000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<49.172000,0,37.639000><49.172000,0.036000,37.639000>0.584200 translate<0,0.000000,0>}
cylinder{<49.172000,-0.1,37.639000><49.172000,0.135000,37.639000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<44.981000,0,37.639000><44.981000,0.036000,37.639000>0.584200 translate<0,0.000000,0>}
cylinder{<44.981000,-0.1,37.639000><44.981000,0.135000,37.639000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<44.981000,0,33.321000><44.981000,0.036000,33.321000>0.584200 translate<0,0.000000,0>}
cylinder{<44.981000,-0.1,33.321000><44.981000,0.135000,33.321000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<47.140000,0,35.480000><47.140000,0.036000,35.480000>0.660400 translate<0,0.000000,0>}
cylinder{<47.140000,-0.1,35.480000><47.140000,0.135000,35.480000>0.609600 translate<0,0.000000,0>}}
difference{
cylinder{<47.140000,0,35.480000><47.140000,0.036000,35.480000>0.330200 translate<0,0.000000,0>}
cylinder{<47.140000,-0.1,35.480000><47.140000,0.135000,35.480000>0.177800 translate<0,0.000000,0>}}
//U$1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<88.468200,0.000000,68.478400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<88.468200,0.000000,15.138400>}
box{<0,0,-0.063500><53.340000,0.036000,0.063500> rotate<0,-90.000000,0> translate<88.468200,0.000000,15.138400> }
//X1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,14.135000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,14.135000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,14.135000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,14.135000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,15.405000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<100.205000,0.000000,15.405000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,15.405000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,15.405000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,15.405000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,15.405000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,14.135000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<98.935000,0.000000,14.135000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,14.135000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,15.405000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<98.935000,0.000000,14.135000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,14.135000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,15.405000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<98.935000,0.000000,15.405000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,11.595000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,11.595000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,11.595000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,11.595000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<103.380000,0.000000,11.595000>}
box{<0,0,-0.076200><7.874000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,11.595000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,12.230000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,12.230000>}
box{<0,0,-0.076200><5.334000,0.036000,0.076200> rotate<0,0.000000,0> translate<96.776000,0.000000,12.230000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,12.230000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,12.230000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<96.522000,0.000000,12.230000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,24.295000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,24.295000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,24.295000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,24.295000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,25.565000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<100.205000,0.000000,25.565000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,25.565000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,25.565000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,25.565000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,25.565000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,24.295000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<98.935000,0.000000,24.295000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,24.295000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,25.565000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<98.935000,0.000000,24.295000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,24.295000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,25.565000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<98.935000,0.000000,25.565000> }
object{ARC(2.667000,0.152400,306.869898,360.000000,0.036000) translate<100.459000,0.000000,14.770000>}
object{ARC(2.667000,0.152400,0.000000,53.130102,0.036000) translate<100.459000,0.000000,14.770000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,16.929000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,17.691000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,90.000000,0> translate<102.110000,0.000000,17.691000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,12.230000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,12.661800>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,90.000000,0> translate<102.110000,0.000000,12.661800> }
object{ARC(2.667000,0.152400,306.869898,360.000000,0.036000) translate<100.459000,0.000000,24.930000>}
object{ARC(2.667000,0.152400,0.000000,53.130102,0.036000) translate<100.459000,0.000000,30.010000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,12.230000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,14.262000>}
box{<0,0,-0.076200><2.032000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,14.262000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,14.262000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,15.278000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,15.278000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,15.278000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,19.342000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,19.342000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,19.342000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,20.358000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,20.358000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,20.358000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,24.422000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,24.422000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,24.422000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,25.438000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,25.438000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,25.438000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,29.502000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,29.502000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,29.502000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,30.518000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,30.518000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,11.595000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,14.262000>}
box{<0,0,-0.076200><2.667000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,14.262000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,14.262000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,15.278000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,15.278000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,15.278000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,19.342000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,19.342000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,19.342000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,20.358000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,20.358000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,20.358000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,24.422000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,24.422000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,24.422000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,25.438000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,25.438000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,25.438000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,29.502000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,29.502000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,29.502000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,30.518000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,30.518000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,24.422000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,24.422000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,24.422000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,25.438000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,25.438000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,25.438000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,11.595000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,14.008000>}
box{<0,0,-0.076200><2.413000,0.036000,0.076200> rotate<0,90.000000,0> translate<95.506000,0.000000,14.008000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,15.532000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,19.088000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,90.000000,0> translate<95.506000,0.000000,19.088000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,20.612000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,24.168000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,90.000000,0> translate<95.506000,0.000000,24.168000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,24.168000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,24.422000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,26.563298,0> translate<94.998000,0.000000,24.422000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,24.168000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,24.168000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,24.168000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,24.168000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,24.422000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<96.522000,0.000000,24.168000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,24.168000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,20.612000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,-90.000000,0> translate<96.522000,0.000000,20.612000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,19.088000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,15.532000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,-90.000000,0> translate<96.522000,0.000000,15.532000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,14.008000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,12.230000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<96.522000,0.000000,12.230000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,25.438000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,25.692000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-26.563298,0> translate<94.998000,0.000000,25.438000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,25.692000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,29.248000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,90.000000,0> translate<95.506000,0.000000,29.248000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,25.692000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,25.692000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,25.692000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,25.692000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,25.438000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<96.522000,0.000000,25.692000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,25.692000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,29.248000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.522000,0.000000,29.248000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,15.278000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,15.278000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,15.278000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,14.262000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,14.262000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,14.262000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,14.008000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,14.008000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,14.008000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,15.532000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,15.532000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,15.532000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,15.278000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,15.532000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-26.563298,0> translate<94.998000,0.000000,15.278000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,14.008000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,14.262000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,26.563298,0> translate<94.998000,0.000000,14.262000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,14.008000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,14.262000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<96.522000,0.000000,14.008000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,15.532000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,15.278000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<96.522000,0.000000,15.532000> }
object{ARC(2.667000,0.152400,306.869898,360.000000,0.036000) translate<100.459000,0.000000,19.850000>}
object{ARC(2.667000,0.152400,0.000000,53.130102,0.036000) translate<100.459000,0.000000,19.850000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,22.009000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,22.771000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,90.000000,0> translate<102.110000,0.000000,22.771000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,19.215000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,20.485000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<100.205000,0.000000,20.485000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,19.215000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,19.215000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,19.215000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,20.485000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,19.215000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<98.935000,0.000000,19.215000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,20.485000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,20.485000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,20.485000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,19.215000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,20.485000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<98.935000,0.000000,20.485000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,19.215000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,20.485000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<98.935000,0.000000,19.215000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,19.342000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,19.342000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,19.342000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,20.358000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,20.358000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,20.358000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,20.612000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,20.612000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,20.612000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,20.358000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,20.612000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-26.563298,0> translate<94.998000,0.000000,20.358000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,20.612000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,20.358000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<96.522000,0.000000,20.612000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,19.088000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,19.342000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,26.563298,0> translate<94.998000,0.000000,19.342000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,19.088000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,19.088000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,19.088000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,19.088000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,19.342000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<96.522000,0.000000,19.088000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,30.645000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,30.645000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,30.645000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,30.645000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,29.375000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<98.935000,0.000000,29.375000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,29.375000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,29.375000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,29.375000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,29.375000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,30.645000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<98.935000,0.000000,29.375000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,29.375000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,30.645000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<98.935000,0.000000,30.645000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,29.375000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,30.645000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<100.205000,0.000000,30.645000> }
object{ARC(2.667000,0.152400,306.869898,360.000000,0.036000) translate<100.459000,0.000000,30.010000>}
object{ARC(2.667000,0.152400,0.000000,53.130102,0.036000) translate<100.459000,0.000000,24.930000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,27.089000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,27.851000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,90.000000,0> translate<102.110000,0.000000,27.851000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,30.518000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,30.518000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,30.518000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,30.772000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,30.772000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,30.772000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,30.518000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,30.772000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-26.563298,0> translate<94.998000,0.000000,30.518000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,30.772000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,30.518000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<96.522000,0.000000,30.772000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,29.502000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,29.502000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,29.502000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,29.248000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,29.248000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,29.248000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,29.248000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,29.502000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,26.563298,0> translate<94.998000,0.000000,29.502000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,29.248000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,29.502000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<96.522000,0.000000,29.248000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,34.455000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,34.455000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,34.455000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,34.455000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,35.725000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<100.205000,0.000000,35.725000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,35.725000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,35.725000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,35.725000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,35.725000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,34.455000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<98.935000,0.000000,34.455000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,34.455000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,35.725000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<98.935000,0.000000,34.455000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,34.455000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,35.725000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<98.935000,0.000000,35.725000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<103.380000,0.000000,11.595000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<103.380000,0.000000,73.825000>}
box{<0,0,-0.076200><62.230000,0.036000,0.076200> rotate<0,90.000000,0> translate<103.380000,0.000000,73.825000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<103.380000,0.000000,73.825000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,73.825000>}
box{<0,0,-0.076200><7.874000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,73.825000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,73.825000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,73.825000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,73.825000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,73.190000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,73.190000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<96.522000,0.000000,73.190000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,73.190000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,73.190000>}
box{<0,0,-0.076200><5.334000,0.036000,0.076200> rotate<0,0.000000,0> translate<96.776000,0.000000,73.190000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,44.615000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,44.615000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,44.615000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,44.615000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,45.885000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<100.205000,0.000000,45.885000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,45.885000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,45.885000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,45.885000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,45.885000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,44.615000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<98.935000,0.000000,44.615000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,44.615000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,45.885000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<98.935000,0.000000,44.615000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,44.615000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,45.885000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<98.935000,0.000000,45.885000> }
object{ARC(2.667000,0.152400,306.869898,360.000000,0.036000) translate<100.459000,0.000000,35.090000>}
object{ARC(2.667000,0.152400,0.000000,53.130102,0.036000) translate<100.459000,0.000000,35.090000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,37.249000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,38.011000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,90.000000,0> translate<102.110000,0.000000,38.011000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,32.118200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,32.981800>}
box{<0,0,-0.076200><0.863600,0.036000,0.076200> rotate<0,90.000000,0> translate<102.110000,0.000000,32.981800> }
object{ARC(2.667000,0.152400,306.869898,360.000000,0.036000) translate<100.459000,0.000000,45.250000>}
object{ARC(2.667000,0.152400,0.000000,53.130102,0.036000) translate<100.459000,0.000000,70.650000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,72.758200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,73.190000>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,90.000000,0> translate<102.110000,0.000000,73.190000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,30.518000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,34.582000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,34.582000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,34.582000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,35.598000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,35.598000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,35.598000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,39.662000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,39.662000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,39.662000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,40.678000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,40.678000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,40.678000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,44.742000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,44.742000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,44.742000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,45.758000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,45.758000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,45.758000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,49.822000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,49.822000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,49.822000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,50.838000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,50.838000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,50.838000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,54.902000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,54.902000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,54.902000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,55.918000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,55.918000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,55.918000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,59.982000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,59.982000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,59.982000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,60.998000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,60.998000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,60.998000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,65.062000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,65.062000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,65.062000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,66.078000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,66.078000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,66.078000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,70.142000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,70.142000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,70.142000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,71.158000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,71.158000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,71.158000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,73.190000>}
box{<0,0,-0.076200><2.032000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.776000,0.000000,73.190000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,30.518000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,34.582000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,34.582000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,34.582000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,35.598000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,35.598000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,35.598000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,39.662000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,39.662000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,39.662000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,40.678000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,40.678000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,40.678000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,44.742000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,44.742000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,44.742000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,45.758000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,45.758000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,45.758000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,49.822000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,49.822000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,49.822000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,50.838000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,50.838000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,50.838000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,54.902000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,54.902000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,54.902000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,55.918000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,55.918000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,55.918000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,59.982000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,59.982000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,59.982000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,60.998000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,60.998000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,60.998000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,65.062000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,65.062000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,65.062000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,66.078000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,66.078000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,66.078000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,70.142000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,70.142000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,70.142000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,71.158000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,71.158000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,71.158000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,73.825000>}
box{<0,0,-0.076200><2.667000,0.036000,0.076200> rotate<0,90.000000,0> translate<94.998000,0.000000,73.825000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,44.742000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,44.742000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,44.742000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,45.758000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,45.758000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,45.758000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,30.772000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,34.328000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,90.000000,0> translate<95.506000,0.000000,34.328000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,35.852000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,39.408000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,90.000000,0> translate<95.506000,0.000000,39.408000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,40.932000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,44.488000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,90.000000,0> translate<95.506000,0.000000,44.488000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,44.488000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,44.742000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,26.563298,0> translate<94.998000,0.000000,44.742000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,44.488000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,44.488000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,44.488000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,44.488000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,44.742000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<96.522000,0.000000,44.488000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,44.488000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,40.932000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,-90.000000,0> translate<96.522000,0.000000,40.932000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,39.408000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,35.852000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,-90.000000,0> translate<96.522000,0.000000,35.852000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,34.328000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,30.772000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,-90.000000,0> translate<96.522000,0.000000,30.772000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,45.758000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,46.012000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-26.563298,0> translate<94.998000,0.000000,45.758000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,46.012000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,49.568000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,90.000000,0> translate<95.506000,0.000000,49.568000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,51.092000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,54.648000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,90.000000,0> translate<95.506000,0.000000,54.648000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,56.172000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,59.728000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,90.000000,0> translate<95.506000,0.000000,59.728000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,61.252000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,64.808000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,90.000000,0> translate<95.506000,0.000000,64.808000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,66.332000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,69.888000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,90.000000,0> translate<95.506000,0.000000,69.888000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,71.412000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,73.825000>}
box{<0,0,-0.076200><2.413000,0.036000,0.076200> rotate<0,90.000000,0> translate<95.506000,0.000000,73.825000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,46.012000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,46.012000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,46.012000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,46.012000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,45.758000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<96.522000,0.000000,46.012000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,46.012000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,49.568000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.522000,0.000000,49.568000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,51.092000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,54.648000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.522000,0.000000,54.648000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,56.172000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,59.728000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.522000,0.000000,59.728000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,61.252000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,64.808000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.522000,0.000000,64.808000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,66.332000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,69.888000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.522000,0.000000,69.888000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,71.412000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,73.190000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.522000,0.000000,73.190000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,35.598000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,35.598000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,35.598000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,34.582000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,34.582000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,34.582000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,34.328000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,34.328000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,34.328000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,35.852000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,35.852000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,35.852000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,35.598000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,35.852000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-26.563298,0> translate<94.998000,0.000000,35.598000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,34.328000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,34.582000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,26.563298,0> translate<94.998000,0.000000,34.582000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,34.328000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,34.582000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<96.522000,0.000000,34.328000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,35.852000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,35.598000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<96.522000,0.000000,35.852000> }
object{ARC(2.667000,0.152400,306.869898,360.000000,0.036000) translate<100.459000,0.000000,40.170000>}
object{ARC(2.667000,0.152400,0.000000,53.130102,0.036000) translate<100.459000,0.000000,40.170000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,42.329000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,43.091000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,90.000000,0> translate<102.110000,0.000000,43.091000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,39.535000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,40.805000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<100.205000,0.000000,40.805000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,39.535000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,39.535000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,39.535000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,40.805000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,39.535000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<98.935000,0.000000,39.535000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,40.805000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,40.805000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,40.805000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,39.535000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,40.805000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<98.935000,0.000000,40.805000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,39.535000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,40.805000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<98.935000,0.000000,39.535000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,39.662000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,39.662000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,39.662000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,40.678000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,40.678000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,40.678000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,40.932000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,40.932000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,40.932000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,40.678000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,40.932000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-26.563298,0> translate<94.998000,0.000000,40.678000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,40.932000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,40.678000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<96.522000,0.000000,40.932000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,39.408000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,39.662000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,26.563298,0> translate<94.998000,0.000000,39.662000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,39.408000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,39.408000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,39.408000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,39.408000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,39.662000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<96.522000,0.000000,39.408000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,50.965000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,50.965000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,50.965000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,50.965000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,49.695000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<98.935000,0.000000,49.695000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,49.695000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,49.695000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,49.695000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,49.695000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,50.965000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<98.935000,0.000000,49.695000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,49.695000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,50.965000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<98.935000,0.000000,50.965000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,49.695000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,50.965000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<100.205000,0.000000,50.965000> }
object{ARC(2.667000,0.152400,306.869898,360.000000,0.036000) translate<100.459000,0.000000,50.330000>}
object{ARC(2.667000,0.152400,0.000000,53.130102,0.036000) translate<100.459000,0.000000,45.250000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,47.409000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,48.171000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,90.000000,0> translate<102.110000,0.000000,48.171000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,50.838000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,50.838000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,50.838000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,51.092000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,51.092000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,51.092000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,50.838000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,51.092000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-26.563298,0> translate<94.998000,0.000000,50.838000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,51.092000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,50.838000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<96.522000,0.000000,51.092000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,49.822000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,49.822000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,49.822000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,49.568000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,49.568000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,49.568000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,49.568000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,49.822000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,26.563298,0> translate<94.998000,0.000000,49.822000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,49.568000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,49.822000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<96.522000,0.000000,49.568000> }
object{ARC(2.667000,0.152400,306.869898,360.000000,0.036000) translate<100.459000,0.000000,55.410000>}
object{ARC(2.667000,0.152400,0.000000,53.130102,0.036000) translate<100.459000,0.000000,50.330000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,52.489000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,53.251000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,90.000000,0> translate<102.110000,0.000000,53.251000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,55.918000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,55.918000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,55.918000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,56.172000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,56.172000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,56.172000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,55.918000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,56.172000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-26.563298,0> translate<94.998000,0.000000,55.918000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,56.172000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,55.918000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<96.522000,0.000000,56.172000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,54.902000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,54.902000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,54.902000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,54.648000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,54.902000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,26.563298,0> translate<94.998000,0.000000,54.902000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,54.648000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,54.648000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,54.648000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,54.648000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,54.902000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<96.522000,0.000000,54.648000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,56.045000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,54.775000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<98.935000,0.000000,54.775000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,56.045000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,56.045000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,56.045000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,54.775000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,54.775000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,54.775000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,54.775000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,56.045000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<100.205000,0.000000,56.045000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,54.775000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,56.045000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<98.935000,0.000000,54.775000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,54.775000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,56.045000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<98.935000,0.000000,56.045000> }
object{ARC(2.667000,0.152400,306.869898,360.000000,0.036000) translate<100.459000,0.000000,60.490000>}
object{ARC(2.667000,0.152400,0.000000,53.130102,0.036000) translate<100.459000,0.000000,55.410000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,57.569000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,58.331000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,90.000000,0> translate<102.110000,0.000000,58.331000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,60.998000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,60.998000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,60.998000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,61.252000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,61.252000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,61.252000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,60.998000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,61.252000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-26.563298,0> translate<94.998000,0.000000,60.998000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,61.252000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,60.998000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<96.522000,0.000000,61.252000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,59.982000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,59.982000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,59.982000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,59.728000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,59.728000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,59.728000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,59.728000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,59.982000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,26.563298,0> translate<94.998000,0.000000,59.982000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,59.728000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,59.982000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<96.522000,0.000000,59.728000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,61.125000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,61.125000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,61.125000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,61.125000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,59.855000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<98.935000,0.000000,59.855000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,59.855000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,59.855000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,59.855000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,59.855000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,61.125000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<100.205000,0.000000,61.125000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,59.855000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,61.125000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<98.935000,0.000000,59.855000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,59.855000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,61.125000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<98.935000,0.000000,61.125000> }
object{ARC(2.667000,0.152400,306.869898,360.000000,0.036000) translate<100.459000,0.000000,65.570000>}
object{ARC(2.667000,0.152400,0.000000,53.130102,0.036000) translate<100.459000,0.000000,60.490000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,62.649000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,63.411000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,90.000000,0> translate<102.110000,0.000000,63.411000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,66.078000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,66.078000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,66.078000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,66.332000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,66.332000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,66.332000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,66.078000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,66.332000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-26.563298,0> translate<94.998000,0.000000,66.078000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,66.332000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,66.078000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<96.522000,0.000000,66.332000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,65.062000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,65.062000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,65.062000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,64.808000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,65.062000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,26.563298,0> translate<94.998000,0.000000,65.062000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,64.808000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,64.808000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,64.808000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,64.808000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,65.062000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<96.522000,0.000000,64.808000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,66.205000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,66.205000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,66.205000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,66.205000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,64.935000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<98.935000,0.000000,64.935000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,64.935000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,64.935000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,64.935000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,64.935000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,66.205000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<100.205000,0.000000,66.205000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,64.935000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,66.205000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<98.935000,0.000000,64.935000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,64.935000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,66.205000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<98.935000,0.000000,66.205000> }
object{ARC(2.667000,0.152400,306.869898,360.000000,0.036000) translate<100.459000,0.000000,70.650000>}
object{ARC(2.667000,0.152400,0.000000,53.130102,0.036000) translate<100.459000,0.000000,65.570000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,67.729000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<102.110000,0.000000,68.491000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,90.000000,0> translate<102.110000,0.000000,68.491000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,71.158000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,71.158000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,71.158000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,71.412000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,71.412000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,71.412000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,71.158000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,71.412000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-26.563298,0> translate<94.998000,0.000000,71.158000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,71.412000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,71.158000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<96.522000,0.000000,71.412000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,70.142000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,70.142000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<94.998000,0.000000,70.142000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,69.888000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.998000,0.000000,70.142000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,26.563298,0> translate<94.998000,0.000000,70.142000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.506000,0.000000,69.888000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,69.888000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.506000,0.000000,69.888000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.522000,0.000000,69.888000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.776000,0.000000,70.142000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<96.522000,0.000000,69.888000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,71.285000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,71.285000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,71.285000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,71.285000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,70.015000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<98.935000,0.000000,70.015000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,70.015000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,70.015000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<98.935000,0.000000,70.015000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,70.015000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,71.285000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<100.205000,0.000000,71.285000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,70.015000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,71.285000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<98.935000,0.000000,70.015000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<100.205000,0.000000,70.015000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.935000,0.000000,71.285000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<98.935000,0.000000,71.285000> }
//X2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.985600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.985600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<87.985600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.985600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.715600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<86.715600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.715600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.715600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<86.715600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.715600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.985600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<86.715600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.985600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.715600,0.000000,75.895200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<86.715600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.985600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.715600,0.000000,74.625200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<86.715600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<90.525600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<90.525600,0.000000,71.196200>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,90.000000,0> translate<90.525600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<90.525600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<90.525600,0.000000,79.070200>}
box{<0,0,-0.076200><7.874000,0.036000,0.076200> rotate<0,90.000000,0> translate<90.525600,0.000000,79.070200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<89.890600,0.000000,77.800200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<89.890600,0.000000,72.466200>}
box{<0,0,-0.076200><5.334000,0.036000,0.076200> rotate<0,-90.000000,0> translate<89.890600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<89.890600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<89.890600,0.000000,72.212200>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<89.890600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.825600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.825600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<77.825600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.825600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.555600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<76.555600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.555600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.555600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<76.555600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.555600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.825600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<76.555600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.825600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.555600,0.000000,75.895200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<76.555600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.825600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.555600,0.000000,74.625200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<76.555600,0.000000,74.625200> }
object{ARC(2.667000,0.152400,36.869898,90.000000,0.036000) translate<87.350600,0.000000,76.149200>}
object{ARC(2.667000,0.152400,90.000000,143.130102,0.036000) translate<87.350600,0.000000,76.149200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<85.191600,0.000000,77.800200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<84.429600,0.000000,77.800200>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<84.429600,0.000000,77.800200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<89.890600,0.000000,77.800200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<89.458800,0.000000,77.800200>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<89.458800,0.000000,77.800200> }
object{ARC(2.667000,0.152400,36.869898,90.000000,0.036000) translate<77.190600,0.000000,76.149200>}
object{ARC(2.667000,0.152400,90.000000,143.130102,0.036000) translate<72.110600,0.000000,76.149200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<89.890600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.858600,0.000000,72.466200>}
box{<0,0,-0.076200><2.032000,0.036000,0.076200> rotate<0,0.000000,0> translate<87.858600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.858600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.842600,0.000000,72.466200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<86.842600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.842600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.778600,0.000000,72.466200>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<82.778600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.778600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.762600,0.000000,72.466200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<81.762600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.762600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.698600,0.000000,72.466200>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<77.698600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.698600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.682600,0.000000,72.466200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<76.682600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.682600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.618600,0.000000,72.466200>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<72.618600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.618600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.602600,0.000000,72.466200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<71.602600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<90.525600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.858600,0.000000,70.688200>}
box{<0,0,-0.076200><2.667000,0.036000,0.076200> rotate<0,0.000000,0> translate<87.858600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.858600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.842600,0.000000,70.688200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<86.842600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.842600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.778600,0.000000,70.688200>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<82.778600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.778600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.762600,0.000000,70.688200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<81.762600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.762600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.698600,0.000000,70.688200>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<77.698600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.698600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.682600,0.000000,70.688200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<76.682600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.682600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.618600,0.000000,70.688200>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<72.618600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.618600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.602600,0.000000,70.688200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<71.602600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.698600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.698600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<77.698600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.682600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.682600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<76.682600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<90.525600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.112600,0.000000,71.196200>}
box{<0,0,-0.076200><2.413000,0.036000,0.076200> rotate<0,0.000000,0> translate<88.112600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.588600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.032600,0.000000,71.196200>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<83.032600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.508600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.952600,0.000000,71.196200>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<77.952600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.952600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.698600,0.000000,70.688200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<77.698600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.952600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.952600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<77.952600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.952600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.698600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<77.698600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.952600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.508600,0.000000,72.212200>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<77.952600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.032600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.588600,0.000000,72.212200>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<83.032600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.112600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<89.890600,0.000000,72.212200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<88.112600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.682600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.428600,0.000000,71.196200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<76.428600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.428600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.872600,0.000000,71.196200>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<72.872600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.428600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.428600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<76.428600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.428600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.682600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<76.428600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.428600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.872600,0.000000,72.212200>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<72.872600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.842600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.842600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<86.842600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.858600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.858600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<87.858600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.112600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.112600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<88.112600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.588600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.588600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<86.588600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.842600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.588600,0.000000,71.196200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<86.588600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.112600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.858600,0.000000,70.688200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<87.858600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.112600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.858600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<87.858600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.588600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.842600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<86.588600,0.000000,72.212200> }
object{ARC(2.667000,0.152400,36.869898,90.000000,0.036000) translate<82.270600,0.000000,76.149200>}
object{ARC(2.667000,0.152400,90.000000,143.130102,0.036000) translate<82.270600,0.000000,76.149200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.111600,0.000000,77.800200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<79.349600,0.000000,77.800200>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<79.349600,0.000000,77.800200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.905600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.635600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<81.635600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.905600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.905600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<82.905600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.635600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.905600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<81.635600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.635600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.635600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<81.635600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.905600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.635600,0.000000,74.625200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<81.635600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.905600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.635600,0.000000,75.895200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<81.635600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.778600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.778600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<82.778600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.762600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.762600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<81.762600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.508600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.508600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<81.508600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.762600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.508600,0.000000,71.196200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<81.508600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.508600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.762600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<81.508600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.032600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.778600,0.000000,70.688200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<82.778600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.032600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.032600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<83.032600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.032600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.778600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<82.778600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.475600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.475600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<71.475600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.475600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.745600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<71.475600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.745600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.745600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<72.745600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.745600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.475600,0.000000,75.895200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<71.475600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.745600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.475600,0.000000,74.625200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<71.475600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.745600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.475600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<71.475600,0.000000,75.895200> }
object{ARC(2.667000,0.152400,36.869898,90.000000,0.036000) translate<72.110600,0.000000,76.149200>}
object{ARC(2.667000,0.152400,90.000000,143.130102,0.036000) translate<77.190600,0.000000,76.149200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<75.031600,0.000000,77.800200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<74.269600,0.000000,77.800200>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<74.269600,0.000000,77.800200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.602600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.602600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<71.602600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.348600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.348600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<71.348600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.602600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.348600,0.000000,71.196200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<71.348600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.348600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.602600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<71.348600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.618600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.618600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<72.618600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.872600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.872600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<72.872600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.872600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.618600,0.000000,70.688200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<72.618600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.872600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.618600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<72.618600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.665600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.665600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<67.665600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.665600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.395600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<66.395600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.395600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.395600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<66.395600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.395600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.665600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<66.395600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.665600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.395600,0.000000,75.895200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<66.395600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.665600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.395600,0.000000,74.625200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<66.395600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<90.525600,0.000000,79.070200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.295600,0.000000,79.070200>}
box{<0,0,-0.076200><62.230000,0.036000,0.076200> rotate<0,0.000000,0> translate<28.295600,0.000000,79.070200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.295600,0.000000,79.070200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.295600,0.000000,71.196200>}
box{<0,0,-0.076200><7.874000,0.036000,0.076200> rotate<0,-90.000000,0> translate<28.295600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.295600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.295600,0.000000,70.688200>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,-90.000000,0> translate<28.295600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.930600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.930600,0.000000,72.466200>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<28.930600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.930600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.930600,0.000000,77.800200>}
box{<0,0,-0.076200><5.334000,0.036000,0.076200> rotate<0,90.000000,0> translate<28.930600,0.000000,77.800200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.505600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.505600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<57.505600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.505600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.235600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<56.235600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.235600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.235600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<56.235600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.235600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.505600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<56.235600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.505600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.235600,0.000000,75.895200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<56.235600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.505600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.235600,0.000000,74.625200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<56.235600,0.000000,74.625200> }
object{ARC(2.667000,0.152400,36.869898,90.000000,0.036000) translate<67.030600,0.000000,76.149200>}
object{ARC(2.667000,0.152400,90.000000,143.130102,0.036000) translate<67.030600,0.000000,76.149200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.871600,0.000000,77.800200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.109600,0.000000,77.800200>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<64.109600,0.000000,77.800200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.002400,0.000000,77.800200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.138800,0.000000,77.800200>}
box{<0,0,-0.076200><0.863600,0.036000,0.076200> rotate<0,0.000000,0> translate<69.138800,0.000000,77.800200> }
object{ARC(2.667000,0.152400,36.869898,90.000000,0.036000) translate<56.870600,0.000000,76.149200>}
object{ARC(2.667000,0.152400,90.000000,143.130102,0.036000) translate<31.470600,0.000000,76.149200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.362400,0.000000,77.800200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.930600,0.000000,77.800200>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<28.930600,0.000000,77.800200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.602600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.538600,0.000000,72.466200>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<67.538600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.538600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.522600,0.000000,72.466200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<66.522600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.522600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.458600,0.000000,72.466200>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<62.458600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.458600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.442600,0.000000,72.466200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<61.442600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.442600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.378600,0.000000,72.466200>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.378600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.378600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.362600,0.000000,72.466200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<56.362600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.362600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.298600,0.000000,72.466200>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<52.298600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.298600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.282600,0.000000,72.466200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<51.282600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.282600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.218600,0.000000,72.466200>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<47.218600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.218600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.202600,0.000000,72.466200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.202600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.202600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.138600,0.000000,72.466200>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<42.138600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.138600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.122600,0.000000,72.466200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.122600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.122600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.058600,0.000000,72.466200>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<37.058600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.058600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.042600,0.000000,72.466200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.042600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.042600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.978600,0.000000,72.466200>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<31.978600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.978600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.962600,0.000000,72.466200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<30.962600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.962600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.930600,0.000000,72.466200>}
box{<0,0,-0.076200><2.032000,0.036000,0.076200> rotate<0,0.000000,0> translate<28.930600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.602600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.538600,0.000000,70.688200>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<67.538600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.538600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.522600,0.000000,70.688200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<66.522600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.522600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.458600,0.000000,70.688200>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<62.458600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.458600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.442600,0.000000,70.688200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<61.442600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.442600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.378600,0.000000,70.688200>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.378600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.378600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.362600,0.000000,70.688200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<56.362600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.362600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.298600,0.000000,70.688200>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<52.298600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.298600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.282600,0.000000,70.688200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<51.282600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.282600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.218600,0.000000,70.688200>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<47.218600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.218600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.202600,0.000000,70.688200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.202600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.202600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.138600,0.000000,70.688200>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<42.138600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.138600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.122600,0.000000,70.688200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.122600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.122600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.058600,0.000000,70.688200>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<37.058600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.058600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.042600,0.000000,70.688200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.042600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.042600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.978600,0.000000,70.688200>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<31.978600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.978600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.962600,0.000000,70.688200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<30.962600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.962600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.295600,0.000000,70.688200>}
box{<0,0,-0.076200><2.667000,0.036000,0.076200> rotate<0,0.000000,0> translate<28.295600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.378600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.378600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<57.378600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.362600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.362600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<56.362600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.348600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.792600,0.000000,71.196200>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<67.792600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.268600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.712600,0.000000,71.196200>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<62.712600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.188600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.632600,0.000000,71.196200>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.632600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.632600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.378600,0.000000,70.688200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<57.378600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.632600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.632600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<57.632600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.632600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.378600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<57.378600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.632600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.188600,0.000000,72.212200>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.632600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.712600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.268600,0.000000,72.212200>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<62.712600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.792600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.348600,0.000000,72.212200>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<67.792600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.362600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.108600,0.000000,71.196200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<56.108600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.108600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.552600,0.000000,71.196200>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<52.552600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.028600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.472600,0.000000,71.196200>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<47.472600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.948600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.392600,0.000000,71.196200>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<42.392600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.868600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.312600,0.000000,71.196200>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<37.312600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.788600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.232600,0.000000,71.196200>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<32.232600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.708600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.295600,0.000000,71.196200>}
box{<0,0,-0.076200><2.413000,0.036000,0.076200> rotate<0,0.000000,0> translate<28.295600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.108600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.108600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<56.108600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.108600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.362600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<56.108600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.108600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.552600,0.000000,72.212200>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<52.552600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.028600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.472600,0.000000,72.212200>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<47.472600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.948600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.392600,0.000000,72.212200>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<42.392600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.868600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.312600,0.000000,72.212200>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<37.312600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.788600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.232600,0.000000,72.212200>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<32.232600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.708600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.930600,0.000000,72.212200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<28.930600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.522600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.522600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<66.522600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.538600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.538600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<67.538600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.792600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.792600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<67.792600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.268600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.268600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<66.268600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.522600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.268600,0.000000,71.196200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<66.268600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.792600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.538600,0.000000,70.688200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<67.538600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.792600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.538600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<67.538600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.268600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.522600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<66.268600,0.000000,72.212200> }
object{ARC(2.667000,0.152400,36.869898,90.000000,0.036000) translate<61.950600,0.000000,76.149200>}
object{ARC(2.667000,0.152400,90.000000,143.130102,0.036000) translate<61.950600,0.000000,76.149200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.791600,0.000000,77.800200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.029600,0.000000,77.800200>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<59.029600,0.000000,77.800200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.585600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.315600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<61.315600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.585600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.585600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<62.585600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.315600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.585600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<61.315600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.315600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.315600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<61.315600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.585600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.315600,0.000000,74.625200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<61.315600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.585600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.315600,0.000000,75.895200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<61.315600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.458600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.458600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<62.458600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.442600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.442600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<61.442600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.188600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.188600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<61.188600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.442600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.188600,0.000000,71.196200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<61.188600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.188600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.442600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<61.188600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.712600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.458600,0.000000,70.688200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<62.458600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.712600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.712600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<62.712600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.712600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.458600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<62.458600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.155600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.155600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<51.155600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.155600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.425600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<51.155600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.425600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.425600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<52.425600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.425600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.155600,0.000000,75.895200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<51.155600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.425600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.155600,0.000000,74.625200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<51.155600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.425600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.155600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<51.155600,0.000000,75.895200> }
object{ARC(2.667000,0.152400,36.869898,90.000000,0.036000) translate<51.790600,0.000000,76.149200>}
object{ARC(2.667000,0.152400,90.000000,143.130102,0.036000) translate<56.870600,0.000000,76.149200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.711600,0.000000,77.800200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.949600,0.000000,77.800200>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<53.949600,0.000000,77.800200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.282600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.282600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<51.282600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.028600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.028600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<51.028600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.282600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.028600,0.000000,71.196200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<51.028600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.028600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.282600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<51.028600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.298600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.298600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<52.298600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.552600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.552600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<52.552600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.552600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.298600,0.000000,70.688200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<52.298600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.552600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.298600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<52.298600,0.000000,72.466200> }
object{ARC(2.667000,0.152400,36.869898,90.000000,0.036000) translate<46.710600,0.000000,76.149200>}
object{ARC(2.667000,0.152400,90.000000,143.130102,0.036000) translate<51.790600,0.000000,76.149200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.631600,0.000000,77.800200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.869600,0.000000,77.800200>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<48.869600,0.000000,77.800200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.202600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.202600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<46.202600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.948600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.948600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<45.948600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.202600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.948600,0.000000,71.196200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<45.948600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.948600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.202600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<45.948600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.218600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.218600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<47.218600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.472600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.218600,0.000000,70.688200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<47.218600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.472600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.472600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<47.472600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.472600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.218600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<47.218600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.075600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.345600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.075600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.075600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.075600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<46.075600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.345600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.345600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<47.345600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.345600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.075600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.075600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.345600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.075600,0.000000,75.895200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<46.075600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.345600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.075600,0.000000,74.625200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<46.075600,0.000000,74.625200> }
object{ARC(2.667000,0.152400,36.869898,90.000000,0.036000) translate<41.630600,0.000000,76.149200>}
object{ARC(2.667000,0.152400,90.000000,143.130102,0.036000) translate<46.710600,0.000000,76.149200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.551600,0.000000,77.800200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.789600,0.000000,77.800200>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<43.789600,0.000000,77.800200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.122600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.122600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<41.122600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.868600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.868600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<40.868600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.122600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.868600,0.000000,71.196200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<40.868600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.868600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.122600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<40.868600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.138600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.138600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<42.138600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.392600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.392600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<42.392600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.392600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.138600,0.000000,70.688200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<42.138600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.392600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.138600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<42.138600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.995600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.995600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<40.995600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.995600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.265600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<40.995600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.265600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.265600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<42.265600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.265600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.995600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<40.995600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.265600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.995600,0.000000,75.895200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<40.995600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.265600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.995600,0.000000,74.625200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<40.995600,0.000000,74.625200> }
object{ARC(2.667000,0.152400,36.869898,90.000000,0.036000) translate<36.550600,0.000000,76.149200>}
object{ARC(2.667000,0.152400,90.000000,143.130102,0.036000) translate<41.630600,0.000000,76.149200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.471600,0.000000,77.800200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.709600,0.000000,77.800200>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<38.709600,0.000000,77.800200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.042600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.042600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<36.042600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.788600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.788600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<35.788600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.042600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.788600,0.000000,71.196200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<35.788600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.788600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.042600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<35.788600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.058600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.058600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<37.058600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.312600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.058600,0.000000,70.688200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<37.058600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.312600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.312600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<37.312600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.312600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.058600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<37.058600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.915600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.915600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<35.915600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.915600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.185600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<35.915600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.185600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.185600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<37.185600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.185600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.915600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<35.915600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.185600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.915600,0.000000,75.895200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<35.915600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.185600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.915600,0.000000,74.625200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<35.915600,0.000000,74.625200> }
object{ARC(2.667000,0.152400,36.869898,90.000000,0.036000) translate<31.470600,0.000000,76.149200>}
object{ARC(2.667000,0.152400,90.000000,143.130102,0.036000) translate<36.550600,0.000000,76.149200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.391600,0.000000,77.800200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.629600,0.000000,77.800200>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<33.629600,0.000000,77.800200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.962600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.962600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<30.962600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.708600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.708600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<30.708600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.962600,0.000000,70.688200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.708600,0.000000,71.196200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<30.708600,0.000000,71.196200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.708600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.962600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<30.708600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.978600,0.000000,72.466200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.978600,0.000000,70.688200>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<31.978600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.232600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.978600,0.000000,70.688200>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<31.978600,0.000000,70.688200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.232600,0.000000,71.196200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.232600,0.000000,72.212200>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<32.232600,0.000000,72.212200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.232600,0.000000,72.212200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.978600,0.000000,72.466200>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<31.978600,0.000000,72.466200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.835600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.835600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<30.835600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.835600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.105600,0.000000,74.625200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<30.835600,0.000000,74.625200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.105600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.105600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<32.105600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.105600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.835600,0.000000,75.895200>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<30.835600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.105600,0.000000,74.625200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.835600,0.000000,75.895200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<30.835600,0.000000,75.895200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.105600,0.000000,75.895200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.835600,0.000000,74.625200>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<30.835600,0.000000,74.625200> }
//X5 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.089600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.089600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<31.089600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.089600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.359600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<31.089600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.359600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.359600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<32.359600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.359600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.089600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<31.089600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.089600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.359600,0.000000,9.499600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<31.089600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.089600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.359600,0.000000,10.769600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<31.089600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.549600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.549600,0.000000,14.198600>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,-90.000000,0> translate<28.549600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.184600,0.000000,7.594600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.184600,0.000000,12.928600>}
box{<0,0,-0.076200><5.334000,0.036000,0.076200> rotate<0,90.000000,0> translate<29.184600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.184600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.184600,0.000000,13.182600>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<29.184600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.249600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.249600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<41.249600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.249600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.519600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.249600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.519600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.519600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<42.519600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.519600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.249600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.249600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.249600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.519600,0.000000,9.499600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<41.249600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.249600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.519600,0.000000,10.769600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<41.249600,0.000000,9.499600> }
object{ARC(2.667000,0.152400,216.869898,270.000000,0.036000) translate<31.724600,0.000000,9.245600>}
object{ARC(2.667000,0.152400,270.000000,323.130102,0.036000) translate<31.724600,0.000000,9.245600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.883600,0.000000,7.594600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.645600,0.000000,7.594600>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<33.883600,0.000000,7.594600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.184600,0.000000,7.594600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.616400,0.000000,7.594600>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<29.184600,0.000000,7.594600> }
object{ARC(2.667000,0.152400,216.869898,270.000000,0.036000) translate<41.884600,0.000000,9.245600>}
object{ARC(2.667000,0.152400,270.000000,323.130102,0.036000) translate<46.964600,0.000000,9.245600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.184600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.216600,0.000000,12.928600>}
box{<0,0,-0.076200><2.032000,0.036000,0.076200> rotate<0,0.000000,0> translate<29.184600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.216600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.232600,0.000000,12.928600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<31.216600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.232600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.296600,0.000000,12.928600>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<32.232600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.296600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.312600,0.000000,12.928600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.296600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.312600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.376600,0.000000,12.928600>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<37.312600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.376600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.392600,0.000000,12.928600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.376600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.392600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.456600,0.000000,12.928600>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<42.392600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.456600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.472600,0.000000,12.928600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.456600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.549600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.216600,0.000000,14.706600>}
box{<0,0,-0.076200><2.667000,0.036000,0.076200> rotate<0,0.000000,0> translate<28.549600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.216600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.232600,0.000000,14.706600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<31.216600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.232600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.296600,0.000000,14.706600>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<32.232600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.296600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.312600,0.000000,14.706600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.296600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.312600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.376600,0.000000,14.706600>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<37.312600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.376600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.392600,0.000000,14.706600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.376600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.392600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.456600,0.000000,14.706600>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<42.392600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.456600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.472600,0.000000,14.706600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.456600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.376600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.376600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.376600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.392600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.392600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<42.392600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.549600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.962600,0.000000,14.198600>}
box{<0,0,-0.076200><2.413000,0.036000,0.076200> rotate<0,0.000000,0> translate<28.549600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.486600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.042600,0.000000,14.198600>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<32.486600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.566600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.122600,0.000000,14.198600>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<37.566600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.122600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.376600,0.000000,14.706600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<41.122600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.122600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.122600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<41.122600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.122600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.376600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<41.122600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.122600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.566600,0.000000,13.182600>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<37.566600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.042600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.486600,0.000000,13.182600>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<32.486600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.962600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.184600,0.000000,13.182600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<29.184600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.392600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.646600,0.000000,14.198600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<42.392600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.646600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.202600,0.000000,14.198600>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<42.646600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.646600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.646600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<42.646600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.646600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.392600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<42.392600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.646600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.202600,0.000000,13.182600>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<42.646600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.232600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.232600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<32.232600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.216600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.216600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<31.216600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.962600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.962600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<30.962600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.486600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.486600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<32.486600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.232600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.486600,0.000000,14.198600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<32.232600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.962600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.216600,0.000000,14.706600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<30.962600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.962600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.216600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<30.962600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.486600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.232600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<32.232600,0.000000,12.928600> }
object{ARC(2.667000,0.152400,216.869898,270.000000,0.036000) translate<36.804600,0.000000,9.245600>}
object{ARC(2.667000,0.152400,270.000000,323.130102,0.036000) translate<36.804600,0.000000,9.245600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.963600,0.000000,7.594600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.725600,0.000000,7.594600>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<38.963600,0.000000,7.594600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.169600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.439600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.169600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.169600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.169600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<36.169600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.439600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.169600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.169600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.439600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.439600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<37.439600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.169600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.439600,0.000000,10.769600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<36.169600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.169600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.439600,0.000000,9.499600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<36.169600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.296600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.296600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<36.296600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.312600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.312600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<37.312600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.566600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.566600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<37.566600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.312600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.566600,0.000000,14.198600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<37.312600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.566600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.312600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<37.312600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.042600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.296600,0.000000,14.706600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<36.042600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.042600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.042600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<36.042600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.042600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.296600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<36.042600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.599600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.599600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<47.599600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.599600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.329600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.329600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.329600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.329600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<46.329600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.329600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.599600,0.000000,9.499600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<46.329600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.329600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.599600,0.000000,10.769600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<46.329600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.329600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.599600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.329600,0.000000,9.499600> }
object{ARC(2.667000,0.152400,216.869898,270.000000,0.036000) translate<46.964600,0.000000,9.245600>}
object{ARC(2.667000,0.152400,270.000000,323.130102,0.036000) translate<41.884600,0.000000,9.245600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.043600,0.000000,7.594600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.805600,0.000000,7.594600>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<44.043600,0.000000,7.594600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.472600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.472600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<47.472600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.726600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.726600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<47.726600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.472600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.726600,0.000000,14.198600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<47.472600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.726600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.472600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<47.472600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.456600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.456600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<46.456600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.202600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.202600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<46.202600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.202600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.456600,0.000000,14.706600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<46.202600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.202600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.456600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<46.202600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.409600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.409600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<51.409600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.409600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.679600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<51.409600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.679600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.679600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<52.679600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.679600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.409600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<51.409600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.409600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.679600,0.000000,9.499600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<51.409600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.409600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.679600,0.000000,10.769600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<51.409600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<90.779600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<90.779600,0.000000,14.706600>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,90.000000,0> translate<90.779600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<90.144600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<90.144600,0.000000,12.928600>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<90.144600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<90.144600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<90.144600,0.000000,7.594600>}
box{<0,0,-0.076200><5.334000,0.036000,0.076200> rotate<0,-90.000000,0> translate<90.144600,0.000000,7.594600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.569600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.569600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<61.569600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.569600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.839600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<61.569600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.839600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.839600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<62.839600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.839600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.569600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<61.569600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.569600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.839600,0.000000,9.499600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<61.569600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.569600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.839600,0.000000,10.769600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<61.569600,0.000000,9.499600> }
object{ARC(2.667000,0.152400,216.869898,270.000000,0.036000) translate<52.044600,0.000000,9.245600>}
object{ARC(2.667000,0.152400,270.000000,323.130102,0.036000) translate<52.044600,0.000000,9.245600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.203600,0.000000,7.594600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.965600,0.000000,7.594600>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<54.203600,0.000000,7.594600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.072800,0.000000,7.594600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.936400,0.000000,7.594600>}
box{<0,0,-0.076200><0.863600,0.036000,0.076200> rotate<0,0.000000,0> translate<49.072800,0.000000,7.594600> }
object{ARC(2.667000,0.152400,216.869898,270.000000,0.036000) translate<62.204600,0.000000,9.245600>}
object{ARC(2.667000,0.152400,270.000000,323.130102,0.036000) translate<87.604600,0.000000,9.245600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<89.712800,0.000000,7.594600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<90.144600,0.000000,7.594600>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<89.712800,0.000000,7.594600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.472600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.536600,0.000000,12.928600>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<47.472600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.536600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.552600,0.000000,12.928600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<51.536600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.552600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.616600,0.000000,12.928600>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<52.552600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.616600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.632600,0.000000,12.928600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<56.616600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.632600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.696600,0.000000,12.928600>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.632600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.696600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.712600,0.000000,12.928600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<61.696600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.712600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.776600,0.000000,12.928600>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<62.712600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.776600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.792600,0.000000,12.928600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<66.776600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.792600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.856600,0.000000,12.928600>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<67.792600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.856600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.872600,0.000000,12.928600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<71.856600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.872600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.936600,0.000000,12.928600>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<72.872600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.936600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.952600,0.000000,12.928600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<76.936600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.952600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.016600,0.000000,12.928600>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<77.952600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.016600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.032600,0.000000,12.928600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<82.016600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.032600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.096600,0.000000,12.928600>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<83.032600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.096600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.112600,0.000000,12.928600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<87.096600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.112600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<90.144600,0.000000,12.928600>}
box{<0,0,-0.076200><2.032000,0.036000,0.076200> rotate<0,0.000000,0> translate<88.112600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.472600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.536600,0.000000,14.706600>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<47.472600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.536600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.552600,0.000000,14.706600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<51.536600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.552600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.616600,0.000000,14.706600>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<52.552600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.616600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.632600,0.000000,14.706600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<56.616600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.632600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.696600,0.000000,14.706600>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.632600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.696600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.712600,0.000000,14.706600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<61.696600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.712600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.776600,0.000000,14.706600>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<62.712600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.776600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.792600,0.000000,14.706600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<66.776600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.792600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.856600,0.000000,14.706600>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<67.792600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.856600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.872600,0.000000,14.706600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<71.856600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.872600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.936600,0.000000,14.706600>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<72.872600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.936600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.952600,0.000000,14.706600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<76.936600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.952600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.016600,0.000000,14.706600>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<77.952600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.016600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.032600,0.000000,14.706600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<82.016600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.032600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.096600,0.000000,14.706600>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<83.032600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.096600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.112600,0.000000,14.706600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<87.096600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.112600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<90.779600,0.000000,14.706600>}
box{<0,0,-0.076200><2.667000,0.036000,0.076200> rotate<0,0.000000,0> translate<88.112600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.696600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.696600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<61.696600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.712600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.712600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<62.712600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.726600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.282600,0.000000,14.198600>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<47.726600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.806600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.362600,0.000000,14.198600>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<52.806600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.886600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.442600,0.000000,14.198600>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.886600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.442600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.696600,0.000000,14.706600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<61.442600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.442600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.442600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<61.442600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.442600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.696600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<61.442600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.442600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.886600,0.000000,13.182600>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.886600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.362600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.806600,0.000000,13.182600>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<52.806600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.282600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.726600,0.000000,13.182600>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<47.726600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.712600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.966600,0.000000,14.198600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<62.712600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.966600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.522600,0.000000,14.198600>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<62.966600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.046600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.602600,0.000000,14.198600>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<68.046600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.126600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.682600,0.000000,14.198600>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<73.126600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.206600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.762600,0.000000,14.198600>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<78.206600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.286600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.842600,0.000000,14.198600>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<83.286600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.366600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<90.779600,0.000000,14.198600>}
box{<0,0,-0.076200><2.413000,0.036000,0.076200> rotate<0,0.000000,0> translate<88.366600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.966600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.966600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<62.966600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.966600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.712600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<62.712600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.966600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.522600,0.000000,13.182600>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<62.966600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.046600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.602600,0.000000,13.182600>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<68.046600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.126600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.682600,0.000000,13.182600>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<73.126600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.206600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.762600,0.000000,13.182600>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<78.206600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.286600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.842600,0.000000,13.182600>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<83.286600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.366600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<90.144600,0.000000,13.182600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<88.366600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.552600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.552600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<52.552600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.536600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.536600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<51.536600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.282600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.282600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<51.282600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.806600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.806600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<52.806600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.552600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.806600,0.000000,14.198600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<52.552600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.282600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.536600,0.000000,14.706600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<51.282600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.282600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.536600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<51.282600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.806600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.552600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<52.552600,0.000000,12.928600> }
object{ARC(2.667000,0.152400,216.869898,270.000000,0.036000) translate<57.124600,0.000000,9.245600>}
object{ARC(2.667000,0.152400,270.000000,323.130102,0.036000) translate<57.124600,0.000000,9.245600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.283600,0.000000,7.594600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.045600,0.000000,7.594600>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<59.283600,0.000000,7.594600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.489600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.759600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<56.489600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.489600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.489600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<56.489600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.759600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.489600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<56.489600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.759600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.759600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<57.759600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.489600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.759600,0.000000,10.769600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<56.489600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.489600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.759600,0.000000,9.499600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<56.489600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.616600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.616600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<56.616600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.632600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.632600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<57.632600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.886600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.886600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<57.886600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.632600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.886600,0.000000,14.198600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<57.632600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.886600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.632600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<57.632600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.362600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.616600,0.000000,14.706600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<56.362600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.362600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.362600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<56.362600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.362600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.616600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<56.362600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.919600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.919600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<67.919600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.919600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.649600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<66.649600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.649600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.649600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<66.649600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.649600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.919600,0.000000,9.499600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<66.649600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.649600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.919600,0.000000,10.769600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<66.649600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.649600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.919600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<66.649600,0.000000,9.499600> }
object{ARC(2.667000,0.152400,216.869898,270.000000,0.036000) translate<67.284600,0.000000,9.245600>}
object{ARC(2.667000,0.152400,270.000000,323.130102,0.036000) translate<62.204600,0.000000,9.245600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.363600,0.000000,7.594600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.125600,0.000000,7.594600>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<64.363600,0.000000,7.594600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.792600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.792600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<67.792600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.046600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.046600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<68.046600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.792600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.046600,0.000000,14.198600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<67.792600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.046600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.792600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<67.792600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.776600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.776600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<66.776600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.522600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.522600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<66.522600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.522600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.776600,0.000000,14.706600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<66.522600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.522600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.776600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<66.522600,0.000000,13.182600> }
object{ARC(2.667000,0.152400,216.869898,270.000000,0.036000) translate<72.364600,0.000000,9.245600>}
object{ARC(2.667000,0.152400,270.000000,323.130102,0.036000) translate<67.284600,0.000000,9.245600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.443600,0.000000,7.594600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.205600,0.000000,7.594600>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<69.443600,0.000000,7.594600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.872600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.872600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<72.872600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.126600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.126600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<73.126600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.872600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.126600,0.000000,14.198600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<72.872600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.126600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.872600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<72.872600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.856600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.856600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<71.856600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.602600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.856600,0.000000,14.706600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<71.602600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.602600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.602600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<71.602600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.602600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.856600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<71.602600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.999600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.729600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<71.729600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.999600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.999600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<72.999600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.729600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.729600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<71.729600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.729600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.999600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<71.729600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.729600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.999600,0.000000,9.499600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<71.729600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.729600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.999600,0.000000,10.769600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<71.729600,0.000000,9.499600> }
object{ARC(2.667000,0.152400,216.869898,270.000000,0.036000) translate<77.444600,0.000000,9.245600>}
object{ARC(2.667000,0.152400,270.000000,323.130102,0.036000) translate<72.364600,0.000000,9.245600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<74.523600,0.000000,7.594600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<75.285600,0.000000,7.594600>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<74.523600,0.000000,7.594600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.952600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.952600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<77.952600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.206600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.206600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<78.206600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.952600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.206600,0.000000,14.198600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<77.952600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.206600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.952600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<77.952600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.936600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.936600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<76.936600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.682600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.682600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<76.682600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.682600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.936600,0.000000,14.706600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<76.682600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.682600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.936600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<76.682600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.079600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.079600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<78.079600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.079600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.809600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<76.809600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.809600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.809600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<76.809600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.809600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.079600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<76.809600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.809600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.079600,0.000000,9.499600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<76.809600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.809600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.079600,0.000000,10.769600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<76.809600,0.000000,9.499600> }
object{ARC(2.667000,0.152400,216.869898,270.000000,0.036000) translate<82.524600,0.000000,9.245600>}
object{ARC(2.667000,0.152400,270.000000,323.130102,0.036000) translate<77.444600,0.000000,9.245600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<79.603600,0.000000,7.594600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.365600,0.000000,7.594600>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<79.603600,0.000000,7.594600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.032600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.032600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<83.032600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.286600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.286600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<83.286600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.032600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.286600,0.000000,14.198600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<83.032600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.286600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.032600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<83.032600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.016600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.016600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<82.016600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.762600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.016600,0.000000,14.706600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<81.762600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.762600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.762600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<81.762600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.762600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.016600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<81.762600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.159600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.159600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<83.159600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.159600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.889600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<81.889600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.889600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.889600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<81.889600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.889600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.159600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<81.889600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.889600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.159600,0.000000,9.499600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<81.889600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.889600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.159600,0.000000,10.769600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<81.889600,0.000000,9.499600> }
object{ARC(2.667000,0.152400,216.869898,270.000000,0.036000) translate<87.604600,0.000000,9.245600>}
object{ARC(2.667000,0.152400,270.000000,323.130102,0.036000) translate<82.524600,0.000000,9.245600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<84.683600,0.000000,7.594600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<85.445600,0.000000,7.594600>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<84.683600,0.000000,7.594600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.112600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.112600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<88.112600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.366600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.366600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<88.366600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.112600,0.000000,14.706600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.366600,0.000000,14.198600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<88.112600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.366600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.112600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<88.112600,0.000000,12.928600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.096600,0.000000,12.928600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.096600,0.000000,14.706600>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<87.096600,0.000000,14.706600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.842600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.096600,0.000000,14.706600>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<86.842600,0.000000,14.198600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.842600,0.000000,14.198600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.842600,0.000000,13.182600>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<86.842600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.842600,0.000000,13.182600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.096600,0.000000,12.928600>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<86.842600,0.000000,13.182600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.239600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.239600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<88.239600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.239600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.969600,0.000000,10.769600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<86.969600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.969600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.969600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<86.969600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.969600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.239600,0.000000,9.499600>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<86.969600,0.000000,9.499600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.969600,0.000000,10.769600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.239600,0.000000,9.499600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<86.969600,0.000000,10.769600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.969600,0.000000,9.499600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.239600,0.000000,10.769600>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<86.969600,0.000000,9.499600> }
texture{col_slk}
}
#end
translate<mac_x_ver,mac_y_ver,mac_z_ver>
rotate<mac_x_rot,mac_y_rot,mac_z_rot>
}//End union
#end

#if(use_file_as_inc=off)
object{  ARDUINO_BREAKOUT(-65.698500,0,-42.837100,pcb_rotate_x,pcb_rotate_y,pcb_rotate_z)
#if(pcb_upsidedown=on)
rotate pcb_rotdir*180
#end
}
#end


//Parts not found in 3dpack.dat or 3dusrpac.dat are:
//U$1	ARDUINODIECIMILIA	ARDUINO
