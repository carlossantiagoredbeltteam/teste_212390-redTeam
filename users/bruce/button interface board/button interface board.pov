//POVRay-File created by 3d41.ulp v1.05
//D:/Documents and Settings/Bruce Wattendorf/Desktop/Reprap SVN folder/reprap/trunk/users/bruce/button interface board/button interface board.brd
//10/25/2008 9:14:18 AM

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
#local cam_y = 174;
#local cam_z = -93;
#local cam_a = 20;
#local cam_look_x = 0;
#local cam_look_y = -4;
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

#local lgt1_pos_x = 15;
#local lgt1_pos_y = 23;
#local lgt1_pos_z = 21;
#local lgt1_intense = 0.724134;
#local lgt2_pos_x = -15;
#local lgt2_pos_y = 23;
#local lgt2_pos_z = 21;
#local lgt2_intense = 0.724134;
#local lgt3_pos_x = 15;
#local lgt3_pos_y = 23;
#local lgt3_pos_z = -14;
#local lgt3_intense = 0.724134;
#local lgt4_pos_x = -15;
#local lgt4_pos_y = 23;
#local lgt4_pos_z = -14;
#local lgt4_intense = 0.724134;

//Do not change these values
#declare pcb_height = 1.500000;
#declare pcb_cuheight = 0.035000;
#declare pcb_x_size = 41.580000;
#declare pcb_y_size = 40.630000;
#declare pcb_layer1_used = 1;
#declare pcb_layer16_used = 1;
#declare inc_testmode = off;
#declare global_seed=seed(955);
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
	//translate<-20.790000,0,-20.315000>
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


#macro BUTTON_INTERFACE_BOARD(mac_x_ver,mac_y_ver,mac_z_ver,mac_x_rot,mac_y_rot,mac_z_rot)
union{
#if(pcb_board = on)
difference{
union{
//Board
prism{-1.500000,0.000000,8
<4.610000,1.910000><46.190000,1.910000>
<46.190000,1.910000><46.190000,42.540000>
<46.190000,42.540000><4.610000,42.540000>
<4.610000,42.540000><4.610000,1.910000>
texture{col_brd}}
}//End union(Platine)
//Holes(real)/Parts
cylinder{<41.910000,1,6.350000><41.910000,-5,6.350000>1.500000 texture{col_hls}}
cylinder{<8.890000,1,6.350000><8.890000,-5,6.350000>1.500000 texture{col_hls}}
cylinder{<8.890000,1,38.100000><8.890000,-5,38.100000>1.500000 texture{col_hls}}
cylinder{<41.910000,1,38.100000><41.910000,-5,38.100000>1.500000 texture{col_hls}}
//Holes(real)/Board
//Holes(real)/Vias
}//End difference(reale Bohrungen/Durchbrüche)
#end
#if(pcb_parts=on)//Parts
union{
#ifndef(pack_JP2) #declare global_pack_JP2=yes; object {PH_1X7()translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<25.400000,0.000000,38.100000>}#end		//Header 2,54mm Grid 7Pin 1Row (jumper.lib) JP2  1X07
#ifndef(pack_LED1) #declare global_pack_LED1=yes; object {DIODE_DIS_LED_3MM(Red,0.500000,0.000000,)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<13.970000,0.000000,29.210000>}#end		//Diskrete 3MM LED LED1  LED3MM
#ifndef(pack_S1) #declare global_pack_S1=yes; object {SWITCH_B3F_10XX1()translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<25.400000,0.000000,29.210000>}#end		//Tactile Switch-Omron S1  B3F-10XX
#ifndef(pack_S2) #declare global_pack_S2=yes; object {SWITCH_B3F_10XX1()translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<38.100000,0.000000,19.050000>}#end		//Tactile Switch-Omron S2  B3F-10XX
#ifndef(pack_S3) #declare global_pack_S3=yes; object {SWITCH_B3F_10XX1()translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<25.400000,0.000000,8.890000>}#end		//Tactile Switch-Omron S3  B3F-10XX
#ifndef(pack_S4) #declare global_pack_S4=yes; object {SWITCH_B3F_10XX1()translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<12.700000,0.000000,19.050000>}#end		//Tactile Switch-Omron S4  B3F-10XX
#ifndef(pack_S5) #declare global_pack_S5=yes; object {SWITCH_B3F_10XX1()translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<25.400000,0.000000,19.050000>}#end		//Tactile Switch-Omron S5  B3F-10XX
}//End union
#end
#if(pcb_pads_smds=on)
//Pads&SMD/Parts
#ifndef(global_pack_JP2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<17.780000,0,38.100000> texture{col_thl}}
#ifndef(global_pack_JP2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<20.320000,0,38.100000> texture{col_thl}}
#ifndef(global_pack_JP2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<22.860000,0,38.100000> texture{col_thl}}
#ifndef(global_pack_JP2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<25.400000,0,38.100000> texture{col_thl}}
#ifndef(global_pack_JP2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<27.940000,0,38.100000> texture{col_thl}}
#ifndef(global_pack_JP2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<30.480000,0,38.100000> texture{col_thl}}
#ifndef(global_pack_JP2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<33.020000,0,38.100000> texture{col_thl}}
#ifndef(global_pack_LED1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<12.700000,0,29.210000> texture{col_thl}}
#ifndef(global_pack_LED1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<15.240000,0,29.210000> texture{col_thl}}
#ifndef(global_pack_S1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<22.148800,0,31.470600> texture{col_thl}}
#ifndef(global_pack_S1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<28.651200,0,31.470600> texture{col_thl}}
#ifndef(global_pack_S1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<22.148800,0,26.949400> texture{col_thl}}
#ifndef(global_pack_S1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<28.651200,0,26.949400> texture{col_thl}}
#ifndef(global_pack_S2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<34.848800,0,21.310600> texture{col_thl}}
#ifndef(global_pack_S2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<41.351200,0,21.310600> texture{col_thl}}
#ifndef(global_pack_S2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<34.848800,0,16.789400> texture{col_thl}}
#ifndef(global_pack_S2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<41.351200,0,16.789400> texture{col_thl}}
#ifndef(global_pack_S3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<22.148800,0,11.150600> texture{col_thl}}
#ifndef(global_pack_S3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<28.651200,0,11.150600> texture{col_thl}}
#ifndef(global_pack_S3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<22.148800,0,6.629400> texture{col_thl}}
#ifndef(global_pack_S3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<28.651200,0,6.629400> texture{col_thl}}
#ifndef(global_pack_S4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<9.448800,0,21.310600> texture{col_thl}}
#ifndef(global_pack_S4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<15.951200,0,21.310600> texture{col_thl}}
#ifndef(global_pack_S4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<9.448800,0,16.789400> texture{col_thl}}
#ifndef(global_pack_S4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<15.951200,0,16.789400> texture{col_thl}}
#ifndef(global_pack_S5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<22.148800,0,21.310600> texture{col_thl}}
#ifndef(global_pack_S5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<28.651200,0,21.310600> texture{col_thl}}
#ifndef(global_pack_S5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<22.148800,0,16.789400> texture{col_thl}}
#ifndef(global_pack_S5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<28.651200,0,16.789400> texture{col_thl}}
//Pads/Vias
#end
#if(pcb_wires=on)
union{
//Signals
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<9.448800,0.000000,16.789400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<10.160000,0.000000,16.510000>}
box{<0,0,-0.127000><0.764114,0.035000,0.127000> rotate<0,21.446321,0> translate<9.448800,0.000000,16.789400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<9.448800,-1.535000,16.789400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<10.160000,-1.535000,16.510000>}
box{<0,0,-0.127000><0.764114,0.035000,0.127000> rotate<0,21.446321,0> translate<9.448800,-1.535000,16.789400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<9.448800,-1.535000,21.310600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<10.160000,-1.535000,21.590000>}
box{<0,0,-0.127000><0.764114,0.035000,0.127000> rotate<0,-21.446321,0> translate<9.448800,-1.535000,21.310600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<10.160000,-1.535000,21.590000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<10.160000,-1.535000,33.020000>}
box{<0,0,-0.127000><11.430000,0.035000,0.127000> rotate<0,90.000000,0> translate<10.160000,-1.535000,33.020000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<10.160000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<11.430000,0.000000,17.780000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,-44.997030,0> translate<10.160000,0.000000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<11.430000,0.000000,17.780000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<11.430000,0.000000,25.400000>}
box{<0,0,-0.127000><7.620000,0.035000,0.127000> rotate<0,90.000000,0> translate<11.430000,0.000000,25.400000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<12.700000,0.000000,29.210000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<13.970000,0.000000,30.480000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,-44.997030,0> translate<12.700000,0.000000,29.210000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<13.970000,0.000000,30.480000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<13.970000,0.000000,36.830000>}
box{<0,0,-0.127000><6.350000,0.035000,0.127000> rotate<0,90.000000,0> translate<13.970000,0.000000,36.830000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<10.160000,-1.535000,16.510000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.240000,-1.535000,11.430000>}
box{<0,0,-0.127000><7.184205,0.035000,0.127000> rotate<0,44.997030,0> translate<10.160000,-1.535000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<11.430000,0.000000,25.400000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.240000,0.000000,29.210000>}
box{<0,0,-0.127000><5.388154,0.035000,0.127000> rotate<0,-44.997030,0> translate<11.430000,0.000000,25.400000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.240000,0.000000,29.210000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.240000,0.000000,34.290000>}
box{<0,0,-0.127000><5.080000,0.035000,0.127000> rotate<0,90.000000,0> translate<15.240000,0.000000,34.290000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.240000,-1.535000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<16.510000,-1.535000,11.430000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,0.000000,0> translate<15.240000,-1.535000,11.430000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.240000,-1.535000,29.210000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.780000,-1.535000,26.670000>}
box{<0,0,-0.127000><3.592102,0.035000,0.127000> rotate<0,44.997030,0> translate<15.240000,-1.535000,29.210000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.240000,0.000000,34.290000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.780000,0.000000,36.830000>}
box{<0,0,-0.127000><3.592102,0.035000,0.127000> rotate<0,-44.997030,0> translate<15.240000,0.000000,34.290000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.780000,0.000000,36.830000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.780000,0.000000,38.100000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,90.000000,0> translate<17.780000,0.000000,38.100000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<13.970000,0.000000,36.830000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.780000,0.000000,40.640000>}
box{<0,0,-0.127000><5.388154,0.035000,0.127000> rotate<0,-44.997030,0> translate<13.970000,0.000000,36.830000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.240000,-1.535000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.320000,-1.535000,6.350000>}
box{<0,0,-0.127000><7.184205,0.035000,0.127000> rotate<0,44.997030,0> translate<15.240000,-1.535000,11.430000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<16.510000,-1.535000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.320000,-1.535000,15.240000>}
box{<0,0,-0.127000><5.388154,0.035000,0.127000> rotate<0,-44.997030,0> translate<16.510000,-1.535000,11.430000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.320000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.320000,0.000000,38.100000>}
box{<0,0,-0.127000><2.540000,0.035000,0.127000> rotate<0,-90.000000,0> translate<20.320000,0.000000,38.100000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.780000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.320000,0.000000,40.640000>}
box{<0,0,-0.127000><2.540000,0.035000,0.127000> rotate<0,0.000000,0> translate<17.780000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.320000,-1.535000,6.350000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.590000,-1.535000,6.350000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,0.000000,0> translate<20.320000,-1.535000,6.350000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.320000,-1.535000,15.240000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.590000,-1.535000,16.510000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,-44.997030,0> translate<20.320000,-1.535000,15.240000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.780000,-1.535000,26.670000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.590000,-1.535000,26.670000>}
box{<0,0,-0.127000><3.810000,0.035000,0.127000> rotate<0,0.000000,0> translate<17.780000,-1.535000,26.670000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<10.160000,-1.535000,33.020000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.590000,-1.535000,33.020000>}
box{<0,0,-0.127000><11.430000,0.035000,0.127000> rotate<0,0.000000,0> translate<10.160000,-1.535000,33.020000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.590000,-1.535000,6.350000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.148800,-1.535000,6.629400>}
box{<0,0,-0.127000><0.624757,0.035000,0.127000> rotate<0,-26.563298,0> translate<21.590000,-1.535000,6.350000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.590000,-1.535000,16.510000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.148800,-1.535000,16.789400>}
box{<0,0,-0.127000><0.624757,0.035000,0.127000> rotate<0,-26.563298,0> translate<21.590000,-1.535000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.590000,-1.535000,26.670000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.148800,-1.535000,26.949400>}
box{<0,0,-0.127000><0.624757,0.035000,0.127000> rotate<0,-26.563298,0> translate<21.590000,-1.535000,26.670000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.148800,0.000000,11.150600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.860000,0.000000,11.430000>}
box{<0,0,-0.127000><0.764114,0.035000,0.127000> rotate<0,-21.446321,0> translate<22.148800,0.000000,11.150600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.148800,0.000000,21.310600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.860000,0.000000,21.590000>}
box{<0,0,-0.127000><0.764114,0.035000,0.127000> rotate<0,-21.446321,0> translate<22.148800,0.000000,21.310600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.148800,-1.535000,31.470600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.860000,-1.535000,31.750000>}
box{<0,0,-0.127000><0.764114,0.035000,0.127000> rotate<0,-21.446321,0> translate<22.148800,-1.535000,31.470600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.860000,0.000000,36.830000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.860000,0.000000,38.100000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,90.000000,0> translate<22.860000,0.000000,38.100000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.860000,0.000000,21.590000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.130000,0.000000,22.860000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,-44.997030,0> translate<22.860000,0.000000,21.590000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.860000,0.000000,36.830000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.130000,0.000000,35.560000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,44.997030,0> translate<22.860000,0.000000,36.830000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.130000,0.000000,22.860000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.130000,0.000000,35.560000>}
box{<0,0,-0.127000><12.700000,0.035000,0.127000> rotate<0,90.000000,0> translate<24.130000,0.000000,35.560000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.590000,-1.535000,33.020000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.400000,-1.535000,36.830000>}
box{<0,0,-0.127000><5.388154,0.035000,0.127000> rotate<0,-44.997030,0> translate<21.590000,-1.535000,33.020000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.400000,-1.535000,36.830000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.400000,-1.535000,38.100000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,90.000000,0> translate<25.400000,-1.535000,38.100000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.860000,0.000000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.670000,0.000000,15.240000>}
box{<0,0,-0.127000><5.388154,0.035000,0.127000> rotate<0,-44.997030,0> translate<22.860000,0.000000,11.430000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.860000,-1.535000,31.750000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.670000,-1.535000,35.560000>}
box{<0,0,-0.127000><5.388154,0.035000,0.127000> rotate<0,-44.997030,0> translate<22.860000,-1.535000,31.750000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.670000,0.000000,15.240000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.670000,0.000000,35.560000>}
box{<0,0,-0.127000><20.320000,0.035000,0.127000> rotate<0,90.000000,0> translate<26.670000,0.000000,35.560000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.670000,0.000000,35.560000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.940000,0.000000,36.830000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,-44.997030,0> translate<26.670000,0.000000,35.560000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.940000,0.000000,36.830000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.940000,0.000000,38.100000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,90.000000,0> translate<27.940000,0.000000,38.100000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,0.000000,36.830000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,0.000000,38.100000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,90.000000,0> translate<30.480000,0.000000,38.100000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.670000,-1.535000,35.560000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.750000,-1.535000,35.560000>}
box{<0,0,-0.127000><5.080000,0.035000,0.127000> rotate<0,0.000000,0> translate<26.670000,-1.535000,35.560000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,0.000000,36.830000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.750000,0.000000,35.560000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,44.997030,0> translate<30.480000,0.000000,36.830000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.750000,0.000000,24.130000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.750000,0.000000,35.560000>}
box{<0,0,-0.127000><11.430000,0.035000,0.127000> rotate<0,90.000000,0> translate<31.750000,0.000000,35.560000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.320000,-1.535000,15.240000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.020000,-1.535000,15.240000>}
box{<0,0,-0.127000><12.700000,0.035000,0.127000> rotate<0,0.000000,0> translate<20.320000,-1.535000,15.240000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.750000,-1.535000,35.560000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.020000,-1.535000,36.830000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,-44.997030,0> translate<31.750000,-1.535000,35.560000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.020000,-1.535000,36.830000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.020000,-1.535000,38.100000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,90.000000,0> translate<33.020000,-1.535000,38.100000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.020000,-1.535000,15.240000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.290000,-1.535000,16.510000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,-44.997030,0> translate<33.020000,-1.535000,15.240000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.750000,0.000000,24.130000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.290000,0.000000,21.590000>}
box{<0,0,-0.127000><3.592102,0.035000,0.127000> rotate<0,44.997030,0> translate<31.750000,0.000000,24.130000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.290000,-1.535000,16.510000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.848800,-1.535000,16.789400>}
box{<0,0,-0.127000><0.624757,0.035000,0.127000> rotate<0,-26.563298,0> translate<34.290000,-1.535000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.290000,0.000000,21.590000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.848800,0.000000,21.310600>}
box{<0,0,-0.127000><0.624757,0.035000,0.127000> rotate<0,26.563298,0> translate<34.290000,0.000000,21.590000> }
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
texture{col_pol}
}
#end
union{
cylinder{<17.780000,0.038000,38.100000><17.780000,-1.538000,38.100000>0.508000}
cylinder{<20.320000,0.038000,38.100000><20.320000,-1.538000,38.100000>0.508000}
cylinder{<22.860000,0.038000,38.100000><22.860000,-1.538000,38.100000>0.508000}
cylinder{<25.400000,0.038000,38.100000><25.400000,-1.538000,38.100000>0.508000}
cylinder{<27.940000,0.038000,38.100000><27.940000,-1.538000,38.100000>0.508000}
cylinder{<30.480000,0.038000,38.100000><30.480000,-1.538000,38.100000>0.508000}
cylinder{<33.020000,0.038000,38.100000><33.020000,-1.538000,38.100000>0.508000}
cylinder{<12.700000,0.038000,29.210000><12.700000,-1.538000,29.210000>0.406400}
cylinder{<15.240000,0.038000,29.210000><15.240000,-1.538000,29.210000>0.406400}
cylinder{<22.148800,0.038000,31.470600><22.148800,-1.538000,31.470600>0.508000}
cylinder{<28.651200,0.038000,31.470600><28.651200,-1.538000,31.470600>0.508000}
cylinder{<22.148800,0.038000,26.949400><22.148800,-1.538000,26.949400>0.508000}
cylinder{<28.651200,0.038000,26.949400><28.651200,-1.538000,26.949400>0.508000}
cylinder{<34.848800,0.038000,21.310600><34.848800,-1.538000,21.310600>0.508000}
cylinder{<41.351200,0.038000,21.310600><41.351200,-1.538000,21.310600>0.508000}
cylinder{<34.848800,0.038000,16.789400><34.848800,-1.538000,16.789400>0.508000}
cylinder{<41.351200,0.038000,16.789400><41.351200,-1.538000,16.789400>0.508000}
cylinder{<22.148800,0.038000,11.150600><22.148800,-1.538000,11.150600>0.508000}
cylinder{<28.651200,0.038000,11.150600><28.651200,-1.538000,11.150600>0.508000}
cylinder{<22.148800,0.038000,6.629400><22.148800,-1.538000,6.629400>0.508000}
cylinder{<28.651200,0.038000,6.629400><28.651200,-1.538000,6.629400>0.508000}
cylinder{<9.448800,0.038000,21.310600><9.448800,-1.538000,21.310600>0.508000}
cylinder{<15.951200,0.038000,21.310600><15.951200,-1.538000,21.310600>0.508000}
cylinder{<9.448800,0.038000,16.789400><9.448800,-1.538000,16.789400>0.508000}
cylinder{<15.951200,0.038000,16.789400><15.951200,-1.538000,16.789400>0.508000}
cylinder{<22.148800,0.038000,21.310600><22.148800,-1.538000,21.310600>0.508000}
cylinder{<28.651200,0.038000,21.310600><28.651200,-1.538000,21.310600>0.508000}
cylinder{<22.148800,0.038000,16.789400><22.148800,-1.538000,16.789400>0.508000}
cylinder{<28.651200,0.038000,16.789400><28.651200,-1.538000,16.789400>0.508000}
//Holes(fast)/Vias
//Holes(fast)/Board
texture{col_hls}
}
#if(pcb_silkscreen=on)
//Silk Screen
union{
//H1 silk screen
object{ARC(2.159000,2.489200,180.000000,270.000000,0.036000) translate<41.910000,0.000000,6.350000>}
object{ARC(2.159000,2.489200,0.000000,90.000000,0.036000) translate<41.910000,0.000000,6.350000>}
difference{
cylinder{<41.910000,0,6.350000><41.910000,0.036000,6.350000>3.505200 translate<0,0.000000,0>}
cylinder{<41.910000,-0.1,6.350000><41.910000,0.135000,6.350000>3.352800 translate<0,0.000000,0>}}
difference{
cylinder{<41.910000,0,6.350000><41.910000,0.036000,6.350000>0.990600 translate<0,0.000000,0>}
cylinder{<41.910000,-0.1,6.350000><41.910000,0.135000,6.350000>0.533400 translate<0,0.000000,0>}}
difference{
cylinder{<41.910000,0,6.350000><41.910000,0.036000,6.350000>1.701600 translate<0,0.000000,0>}
cylinder{<41.910000,-0.1,6.350000><41.910000,0.135000,6.350000>1.498400 translate<0,0.000000,0>}}
//H2 silk screen
object{ARC(2.159000,2.489200,180.000000,270.000000,0.036000) translate<8.890000,0.000000,6.350000>}
object{ARC(2.159000,2.489200,0.000000,90.000000,0.036000) translate<8.890000,0.000000,6.350000>}
difference{
cylinder{<8.890000,0,6.350000><8.890000,0.036000,6.350000>3.505200 translate<0,0.000000,0>}
cylinder{<8.890000,-0.1,6.350000><8.890000,0.135000,6.350000>3.352800 translate<0,0.000000,0>}}
difference{
cylinder{<8.890000,0,6.350000><8.890000,0.036000,6.350000>0.990600 translate<0,0.000000,0>}
cylinder{<8.890000,-0.1,6.350000><8.890000,0.135000,6.350000>0.533400 translate<0,0.000000,0>}}
difference{
cylinder{<8.890000,0,6.350000><8.890000,0.036000,6.350000>1.701600 translate<0,0.000000,0>}
cylinder{<8.890000,-0.1,6.350000><8.890000,0.135000,6.350000>1.498400 translate<0,0.000000,0>}}
//H3 silk screen
object{ARC(2.159000,2.489200,180.000000,270.000000,0.036000) translate<8.890000,0.000000,38.100000>}
object{ARC(2.159000,2.489200,0.000000,90.000000,0.036000) translate<8.890000,0.000000,38.100000>}
difference{
cylinder{<8.890000,0,38.100000><8.890000,0.036000,38.100000>3.505200 translate<0,0.000000,0>}
cylinder{<8.890000,-0.1,38.100000><8.890000,0.135000,38.100000>3.352800 translate<0,0.000000,0>}}
difference{
cylinder{<8.890000,0,38.100000><8.890000,0.036000,38.100000>0.990600 translate<0,0.000000,0>}
cylinder{<8.890000,-0.1,38.100000><8.890000,0.135000,38.100000>0.533400 translate<0,0.000000,0>}}
difference{
cylinder{<8.890000,0,38.100000><8.890000,0.036000,38.100000>1.701600 translate<0,0.000000,0>}
cylinder{<8.890000,-0.1,38.100000><8.890000,0.135000,38.100000>1.498400 translate<0,0.000000,0>}}
//H4 silk screen
object{ARC(2.159000,2.489200,180.000000,270.000000,0.036000) translate<41.910000,0.000000,38.100000>}
object{ARC(2.159000,2.489200,0.000000,90.000000,0.036000) translate<41.910000,0.000000,38.100000>}
difference{
cylinder{<41.910000,0,38.100000><41.910000,0.036000,38.100000>3.505200 translate<0,0.000000,0>}
cylinder{<41.910000,-0.1,38.100000><41.910000,0.135000,38.100000>3.352800 translate<0,0.000000,0>}}
difference{
cylinder{<41.910000,0,38.100000><41.910000,0.036000,38.100000>0.990600 translate<0,0.000000,0>}
cylinder{<41.910000,-0.1,38.100000><41.910000,0.135000,38.100000>0.533400 translate<0,0.000000,0>}}
difference{
cylinder{<41.910000,0,38.100000><41.910000,0.036000,38.100000>1.701600 translate<0,0.000000,0>}
cylinder{<41.910000,-0.1,38.100000><41.910000,0.135000,38.100000>1.498400 translate<0,0.000000,0>}}
//JP2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.210000,0.000000,38.735000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.845000,0.000000,39.370000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<29.210000,0.000000,38.735000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.845000,0.000000,39.370000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.115000,0.000000,39.370000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<29.845000,0.000000,39.370000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.115000,0.000000,39.370000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.750000,0.000000,38.735000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<31.115000,0.000000,39.370000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.750000,0.000000,38.735000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.750000,0.000000,37.465000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<31.750000,0.000000,37.465000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.750000,0.000000,37.465000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.115000,0.000000,36.830000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<31.115000,0.000000,36.830000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.115000,0.000000,36.830000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.845000,0.000000,36.830000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<29.845000,0.000000,36.830000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.845000,0.000000,36.830000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.210000,0.000000,37.465000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<29.210000,0.000000,37.465000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.765000,0.000000,39.370000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.035000,0.000000,39.370000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<24.765000,0.000000,39.370000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.035000,0.000000,39.370000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,38.735000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<26.035000,0.000000,39.370000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,38.735000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,37.465000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<26.670000,0.000000,37.465000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,37.465000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.035000,0.000000,36.830000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<26.035000,0.000000,36.830000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,38.735000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.305000,0.000000,39.370000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<26.670000,0.000000,38.735000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.305000,0.000000,39.370000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.575000,0.000000,39.370000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<27.305000,0.000000,39.370000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.575000,0.000000,39.370000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.210000,0.000000,38.735000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<28.575000,0.000000,39.370000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.210000,0.000000,38.735000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.210000,0.000000,37.465000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<29.210000,0.000000,37.465000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.210000,0.000000,37.465000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.575000,0.000000,36.830000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<28.575000,0.000000,36.830000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.575000,0.000000,36.830000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.305000,0.000000,36.830000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<27.305000,0.000000,36.830000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.305000,0.000000,36.830000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,37.465000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<26.670000,0.000000,37.465000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.590000,0.000000,38.735000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.225000,0.000000,39.370000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<21.590000,0.000000,38.735000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.225000,0.000000,39.370000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.495000,0.000000,39.370000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<22.225000,0.000000,39.370000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.495000,0.000000,39.370000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,38.735000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<23.495000,0.000000,39.370000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,38.735000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,37.465000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<24.130000,0.000000,37.465000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,37.465000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.495000,0.000000,36.830000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<23.495000,0.000000,36.830000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.495000,0.000000,36.830000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.225000,0.000000,36.830000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<22.225000,0.000000,36.830000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.225000,0.000000,36.830000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.590000,0.000000,37.465000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<21.590000,0.000000,37.465000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.765000,0.000000,39.370000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,38.735000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<24.130000,0.000000,38.735000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,37.465000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.765000,0.000000,36.830000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<24.130000,0.000000,37.465000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.035000,0.000000,36.830000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.765000,0.000000,36.830000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<24.765000,0.000000,36.830000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.145000,0.000000,39.370000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.415000,0.000000,39.370000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<17.145000,0.000000,39.370000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.415000,0.000000,39.370000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.050000,0.000000,38.735000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<18.415000,0.000000,39.370000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.050000,0.000000,38.735000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.050000,0.000000,37.465000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<19.050000,0.000000,37.465000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.050000,0.000000,37.465000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.415000,0.000000,36.830000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<18.415000,0.000000,36.830000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.050000,0.000000,38.735000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.685000,0.000000,39.370000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<19.050000,0.000000,38.735000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.685000,0.000000,39.370000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.955000,0.000000,39.370000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<19.685000,0.000000,39.370000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.955000,0.000000,39.370000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.590000,0.000000,38.735000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<20.955000,0.000000,39.370000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.590000,0.000000,38.735000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.590000,0.000000,37.465000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<21.590000,0.000000,37.465000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.590000,0.000000,37.465000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.955000,0.000000,36.830000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<20.955000,0.000000,36.830000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.955000,0.000000,36.830000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.685000,0.000000,36.830000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<19.685000,0.000000,36.830000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.685000,0.000000,36.830000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.050000,0.000000,37.465000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<19.050000,0.000000,37.465000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.510000,0.000000,38.735000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.510000,0.000000,37.465000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<16.510000,0.000000,37.465000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.145000,0.000000,39.370000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.510000,0.000000,38.735000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<16.510000,0.000000,38.735000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.510000,0.000000,37.465000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.145000,0.000000,36.830000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<16.510000,0.000000,37.465000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.415000,0.000000,36.830000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.145000,0.000000,36.830000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<17.145000,0.000000,36.830000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.385000,0.000000,39.370000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.655000,0.000000,39.370000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<32.385000,0.000000,39.370000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.655000,0.000000,39.370000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.290000,0.000000,38.735000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<33.655000,0.000000,39.370000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.290000,0.000000,38.735000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.290000,0.000000,37.465000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<34.290000,0.000000,37.465000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.290000,0.000000,37.465000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.655000,0.000000,36.830000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<33.655000,0.000000,36.830000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.385000,0.000000,39.370000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.750000,0.000000,38.735000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<31.750000,0.000000,38.735000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.750000,0.000000,37.465000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.385000,0.000000,36.830000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<31.750000,0.000000,37.465000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.655000,0.000000,36.830000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.385000,0.000000,36.830000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<32.385000,0.000000,36.830000> }
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<30.480000,0.000000,38.100000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<27.940000,0.000000,38.100000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<25.400000,0.000000,38.100000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<22.860000,0.000000,38.100000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<20.320000,0.000000,38.100000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<17.780000,0.000000,38.100000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<33.020000,0.000000,38.100000>}
//LED1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<15.544800,0.000000,27.940000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<15.544800,0.000000,30.480000>}
box{<0,0,-0.127000><2.540000,0.036000,0.127000> rotate<0,90.000000,0> translate<15.544800,0.000000,30.480000> }
object{ARC(1.524000,0.152400,140.196354,180.000000,0.036000) translate<13.970000,0.000000,29.210000>}
object{ARC(1.524000,0.152400,179.996240,221.629793,0.036000) translate<13.970000,0.000000,29.209900>}
object{ARC(1.524000,0.152400,0.000000,40.601295,0.036000) translate<13.970000,0.000000,29.210000>}
object{ARC(1.524000,0.152400,320.196354,360.000000,0.036000) translate<13.970000,0.000000,29.210000>}
object{ARC(1.524000,0.152400,35.538115,90.000000,0.036000) translate<13.970000,0.000000,29.210000>}
object{ARC(1.524000,0.152400,90.000000,143.130102,0.036000) translate<13.970000,0.000000,29.210000>}
object{ARC(1.524000,0.152400,270.000000,322.126995,0.036000) translate<13.970000,0.000000,29.210000>}
object{ARC(1.524000,0.152400,217.873005,270.000000,0.036000) translate<13.970000,0.000000,29.210000>}
object{ARC(0.635000,0.152400,90.000000,180.000000,0.036000) translate<13.970000,0.000000,29.210000>}
object{ARC(1.016000,0.152400,90.000000,180.000000,0.036000) translate<13.970000,0.000000,29.210000>}
object{ARC(0.635000,0.152400,270.000000,360.000000,0.036000) translate<13.970000,0.000000,29.210000>}
object{ARC(1.016000,0.152400,270.000000,360.000000,0.036000) translate<13.970000,0.000000,29.210000>}
object{ARC(2.032000,0.254000,39.807015,90.000000,0.036000) translate<13.970000,0.000000,29.210000>}
object{ARC(2.032000,0.254000,90.002820,151.929172,0.036000) translate<13.970100,0.000000,29.210000>}
object{ARC(2.032000,0.254000,270.000000,319.762648,0.036000) translate<13.970000,0.000000,29.210000>}
object{ARC(2.032000,0.254000,209.746980,270.002820,0.036000) translate<13.969900,0.000000,29.210000>}
object{ARC(2.032000,0.254000,151.698289,180.000000,0.036000) translate<13.970000,0.000000,29.210000>}
object{ARC(2.032000,0.254000,179.997180,211.605470,0.036000) translate<13.970000,0.000000,29.209900>}
//S1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.702000,0.000000,28.448000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,28.448000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<28.448000,0.000000,28.448000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.702000,0.000000,28.448000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.702000,0.000000,29.972000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,90.000000,0> translate<28.702000,0.000000,29.972000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,29.972000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.702000,0.000000,29.972000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<28.448000,0.000000,29.972000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,30.226000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,31.750000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,90.000000,0> translate<28.448000,0.000000,31.750000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.098000,0.000000,29.972000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,29.972000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<22.098000,0.000000,29.972000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.098000,0.000000,29.972000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.098000,0.000000,28.448000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,-90.000000,0> translate<22.098000,0.000000,28.448000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,28.448000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.098000,0.000000,28.448000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<22.098000,0.000000,28.448000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,31.750000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.940000,0.000000,32.258000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,44.997030,0> translate<27.940000,0.000000,32.258000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.940000,0.000000,26.162000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,26.670000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,-44.997030,0> translate<27.940000,0.000000,26.162000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,26.670000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,28.194000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,90.000000,0> translate<28.448000,0.000000,28.194000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.860000,0.000000,32.258000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,31.750000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,-44.997030,0> translate<22.352000,0.000000,31.750000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,31.750000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,30.226000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,-90.000000,0> translate<22.352000,0.000000,30.226000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.860000,0.000000,26.162000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,26.670000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,44.997030,0> translate<22.352000,0.000000,26.670000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,26.670000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,28.194000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,90.000000,0> translate<22.352000,0.000000,28.194000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,30.480000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,27.940000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,-90.000000,0> translate<24.130000,0.000000,27.940000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.670000,0.000000,27.940000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,27.940000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,0.000000,0> translate<24.130000,0.000000,27.940000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.670000,0.000000,27.940000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.670000,0.000000,30.480000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,90.000000,0> translate<26.670000,0.000000,30.480000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,30.480000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.670000,0.000000,30.480000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,0.000000,0> translate<24.130000,0.000000,30.480000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,32.258000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,32.004000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,-90.000000,0> translate<24.130000,0.000000,32.004000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.670000,0.000000,32.004000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,32.004000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,0.000000,0> translate<24.130000,0.000000,32.004000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.670000,0.000000,32.004000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.670000,0.000000,32.258000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,90.000000,0> translate<26.670000,0.000000,32.258000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.543000,0.000000,26.416000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,26.416000>}
box{<0,0,-0.025400><2.413000,0.036000,0.025400> rotate<0,0.000000,0> translate<24.130000,0.000000,26.416000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.543000,0.000000,26.416000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.543000,0.000000,26.162000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,-90.000000,0> translate<26.543000,0.000000,26.162000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,26.416000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,26.162000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,-90.000000,0> translate<24.130000,0.000000,26.162000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.940000,0.000000,26.162000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.559000,0.000000,26.162000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<27.559000,0.000000,26.162000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.860000,0.000000,26.162000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.241000,0.000000,26.162000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<22.860000,0.000000,26.162000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.241000,0.000000,26.162000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,26.162000>}
box{<0,0,-0.076200><0.889000,0.036000,0.076200> rotate<0,0.000000,0> translate<23.241000,0.000000,26.162000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.860000,0.000000,32.258000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.241000,0.000000,32.258000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<22.860000,0.000000,32.258000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.940000,0.000000,32.258000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.559000,0.000000,32.258000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<27.559000,0.000000,32.258000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.559000,0.000000,32.258000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,32.258000>}
box{<0,0,-0.076200><0.889000,0.036000,0.076200> rotate<0,0.000000,0> translate<26.670000,0.000000,32.258000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,32.258000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,32.258000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,0.000000,0> translate<24.130000,0.000000,32.258000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,32.258000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.241000,0.000000,32.258000>}
box{<0,0,-0.076200><0.889000,0.036000,0.076200> rotate<0,0.000000,0> translate<23.241000,0.000000,32.258000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,26.162000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.543000,0.000000,26.162000>}
box{<0,0,-0.076200><2.413000,0.036000,0.076200> rotate<0,0.000000,0> translate<24.130000,0.000000,26.162000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.543000,0.000000,26.162000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.559000,0.000000,26.162000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<26.543000,0.000000,26.162000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,28.448000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,28.194000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<28.448000,0.000000,28.194000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,29.972000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,30.226000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<28.448000,0.000000,30.226000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,28.448000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,28.194000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<22.352000,0.000000,28.194000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,29.972000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,30.226000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<22.352000,0.000000,30.226000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,27.051000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,27.051000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,0.000000,0> translate<24.130000,0.000000,27.051000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,31.496000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,31.496000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,0.000000,0> translate<24.130000,0.000000,31.496000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.987000,0.000000,30.480000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.987000,0.000000,29.718000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<22.987000,0.000000,29.718000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.987000,0.000000,28.702000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.987000,0.000000,27.940000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<22.987000,0.000000,27.940000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.987000,0.000000,29.718000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.241000,0.000000,28.829000>}
box{<0,0,-0.076200><0.924574,0.036000,0.076200> rotate<0,74.049717,0> translate<22.987000,0.000000,29.718000> }
difference{
cylinder{<25.400000,0,29.210000><25.400000,0.036000,29.210000>1.854200 translate<0,0.000000,0>}
cylinder{<25.400000,-0.1,29.210000><25.400000,0.135000,29.210000>1.701800 translate<0,0.000000,0>}}
difference{
cylinder{<23.241000,0,27.051000><23.241000,0.036000,27.051000>0.584200 translate<0,0.000000,0>}
cylinder{<23.241000,-0.1,27.051000><23.241000,0.135000,27.051000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<27.559000,0,27.178000><27.559000,0.036000,27.178000>0.584200 translate<0,0.000000,0>}
cylinder{<27.559000,-0.1,27.178000><27.559000,0.135000,27.178000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<27.559000,0,31.369000><27.559000,0.036000,31.369000>0.584200 translate<0,0.000000,0>}
cylinder{<27.559000,-0.1,31.369000><27.559000,0.135000,31.369000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<23.241000,0,31.369000><23.241000,0.036000,31.369000>0.584200 translate<0,0.000000,0>}
cylinder{<23.241000,-0.1,31.369000><23.241000,0.135000,31.369000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<25.400000,0,29.210000><25.400000,0.036000,29.210000>0.660400 translate<0,0.000000,0>}
cylinder{<25.400000,-0.1,29.210000><25.400000,0.135000,29.210000>0.609600 translate<0,0.000000,0>}}
difference{
cylinder{<25.400000,0,29.210000><25.400000,0.036000,29.210000>0.330200 translate<0,0.000000,0>}
cylinder{<25.400000,-0.1,29.210000><25.400000,0.135000,29.210000>0.177800 translate<0,0.000000,0>}}
//S2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,18.288000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.148000,0.000000,18.288000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.148000,0.000000,18.288000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,18.288000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,19.812000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.402000,0.000000,19.812000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.148000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,19.812000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.148000,0.000000,19.812000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.148000,0.000000,20.066000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.148000,0.000000,21.590000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.148000,0.000000,21.590000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,19.812000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.798000,0.000000,19.812000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,18.288000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,-90.000000,0> translate<34.798000,0.000000,18.288000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,18.288000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,18.288000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.798000,0.000000,18.288000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.148000,0.000000,21.590000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.640000,0.000000,22.098000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,44.997030,0> translate<40.640000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.640000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.148000,0.000000,16.510000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,-44.997030,0> translate<40.640000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.148000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.148000,0.000000,18.034000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.148000,0.000000,18.034000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.560000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,21.590000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,-44.997030,0> translate<35.052000,0.000000,21.590000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,21.590000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,20.066000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,-90.000000,0> translate<35.052000,0.000000,20.066000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.560000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,16.510000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,44.997030,0> translate<35.052000,0.000000,16.510000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,18.034000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,90.000000,0> translate<35.052000,0.000000,18.034000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.830000,0.000000,20.320000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.830000,0.000000,17.780000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,-90.000000,0> translate<36.830000,0.000000,17.780000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.370000,0.000000,17.780000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.830000,0.000000,17.780000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,0.000000,0> translate<36.830000,0.000000,17.780000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.370000,0.000000,17.780000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.370000,0.000000,20.320000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,90.000000,0> translate<39.370000,0.000000,20.320000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.830000,0.000000,20.320000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.370000,0.000000,20.320000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,0.000000,0> translate<36.830000,0.000000,20.320000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.830000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.830000,0.000000,21.844000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,-90.000000,0> translate<36.830000,0.000000,21.844000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.370000,0.000000,21.844000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.830000,0.000000,21.844000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,0.000000,0> translate<36.830000,0.000000,21.844000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.370000,0.000000,21.844000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.370000,0.000000,22.098000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,90.000000,0> translate<39.370000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.243000,0.000000,16.256000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.830000,0.000000,16.256000>}
box{<0,0,-0.025400><2.413000,0.036000,0.025400> rotate<0,0.000000,0> translate<36.830000,0.000000,16.256000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.243000,0.000000,16.256000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.243000,0.000000,16.002000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,-90.000000,0> translate<39.243000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.830000,0.000000,16.256000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.830000,0.000000,16.002000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,-90.000000,0> translate<36.830000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.640000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.259000,0.000000,16.002000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<40.259000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.560000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.941000,0.000000,16.002000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<35.560000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.941000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.830000,0.000000,16.002000>}
box{<0,0,-0.076200><0.889000,0.036000,0.076200> rotate<0,0.000000,0> translate<35.941000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.560000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.941000,0.000000,22.098000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<35.560000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.640000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.259000,0.000000,22.098000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<40.259000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.259000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.370000,0.000000,22.098000>}
box{<0,0,-0.076200><0.889000,0.036000,0.076200> rotate<0,0.000000,0> translate<39.370000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.370000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.830000,0.000000,22.098000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.830000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.830000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.941000,0.000000,22.098000>}
box{<0,0,-0.076200><0.889000,0.036000,0.076200> rotate<0,0.000000,0> translate<35.941000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.830000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.243000,0.000000,16.002000>}
box{<0,0,-0.076200><2.413000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.830000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.243000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.259000,0.000000,16.002000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<39.243000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.148000,0.000000,18.288000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.148000,0.000000,18.034000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<41.148000,0.000000,18.034000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.148000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.148000,0.000000,20.066000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.148000,0.000000,20.066000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,18.288000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,18.034000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<35.052000,0.000000,18.034000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,20.066000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<35.052000,0.000000,20.066000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.830000,0.000000,16.891000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.370000,0.000000,16.891000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.830000,0.000000,16.891000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.370000,0.000000,21.336000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.830000,0.000000,21.336000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.830000,0.000000,21.336000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.687000,0.000000,20.320000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.687000,0.000000,19.558000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<35.687000,0.000000,19.558000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.687000,0.000000,18.542000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.687000,0.000000,17.780000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<35.687000,0.000000,17.780000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.687000,0.000000,19.558000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.941000,0.000000,18.669000>}
box{<0,0,-0.076200><0.924574,0.036000,0.076200> rotate<0,74.049717,0> translate<35.687000,0.000000,19.558000> }
difference{
cylinder{<38.100000,0,19.050000><38.100000,0.036000,19.050000>1.854200 translate<0,0.000000,0>}
cylinder{<38.100000,-0.1,19.050000><38.100000,0.135000,19.050000>1.701800 translate<0,0.000000,0>}}
difference{
cylinder{<35.941000,0,16.891000><35.941000,0.036000,16.891000>0.584200 translate<0,0.000000,0>}
cylinder{<35.941000,-0.1,16.891000><35.941000,0.135000,16.891000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<40.259000,0,17.018000><40.259000,0.036000,17.018000>0.584200 translate<0,0.000000,0>}
cylinder{<40.259000,-0.1,17.018000><40.259000,0.135000,17.018000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<40.259000,0,21.209000><40.259000,0.036000,21.209000>0.584200 translate<0,0.000000,0>}
cylinder{<40.259000,-0.1,21.209000><40.259000,0.135000,21.209000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<35.941000,0,21.209000><35.941000,0.036000,21.209000>0.584200 translate<0,0.000000,0>}
cylinder{<35.941000,-0.1,21.209000><35.941000,0.135000,21.209000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<38.100000,0,19.050000><38.100000,0.036000,19.050000>0.660400 translate<0,0.000000,0>}
cylinder{<38.100000,-0.1,19.050000><38.100000,0.135000,19.050000>0.609600 translate<0,0.000000,0>}}
difference{
cylinder{<38.100000,0,19.050000><38.100000,0.036000,19.050000>0.330200 translate<0,0.000000,0>}
cylinder{<38.100000,-0.1,19.050000><38.100000,0.135000,19.050000>0.177800 translate<0,0.000000,0>}}
//S3 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.702000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,8.128000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<28.448000,0.000000,8.128000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.702000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.702000,0.000000,9.652000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,90.000000,0> translate<28.702000,0.000000,9.652000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,9.652000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.702000,0.000000,9.652000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<28.448000,0.000000,9.652000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,9.906000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,11.430000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,90.000000,0> translate<28.448000,0.000000,11.430000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.098000,0.000000,9.652000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,9.652000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<22.098000,0.000000,9.652000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.098000,0.000000,9.652000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.098000,0.000000,8.128000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,-90.000000,0> translate<22.098000,0.000000,8.128000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.098000,0.000000,8.128000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<22.098000,0.000000,8.128000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,11.430000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.940000,0.000000,11.938000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,44.997030,0> translate<27.940000,0.000000,11.938000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.940000,0.000000,5.842000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,6.350000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,-44.997030,0> translate<27.940000,0.000000,5.842000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,6.350000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,7.874000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,90.000000,0> translate<28.448000,0.000000,7.874000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.860000,0.000000,11.938000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,11.430000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,-44.997030,0> translate<22.352000,0.000000,11.430000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,11.430000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,9.906000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,-90.000000,0> translate<22.352000,0.000000,9.906000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.860000,0.000000,5.842000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,6.350000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,44.997030,0> translate<22.352000,0.000000,6.350000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,6.350000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,7.874000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,90.000000,0> translate<22.352000,0.000000,7.874000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,10.160000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,7.620000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,-90.000000,0> translate<24.130000,0.000000,7.620000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.670000,0.000000,7.620000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,7.620000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,0.000000,0> translate<24.130000,0.000000,7.620000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.670000,0.000000,7.620000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.670000,0.000000,10.160000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,90.000000,0> translate<26.670000,0.000000,10.160000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,10.160000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.670000,0.000000,10.160000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,0.000000,0> translate<24.130000,0.000000,10.160000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,11.938000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,11.684000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,-90.000000,0> translate<24.130000,0.000000,11.684000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.670000,0.000000,11.684000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,11.684000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,0.000000,0> translate<24.130000,0.000000,11.684000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.670000,0.000000,11.684000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.670000,0.000000,11.938000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,90.000000,0> translate<26.670000,0.000000,11.938000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.543000,0.000000,6.096000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,6.096000>}
box{<0,0,-0.025400><2.413000,0.036000,0.025400> rotate<0,0.000000,0> translate<24.130000,0.000000,6.096000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.543000,0.000000,6.096000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.543000,0.000000,5.842000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,-90.000000,0> translate<26.543000,0.000000,5.842000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,6.096000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,5.842000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,-90.000000,0> translate<24.130000,0.000000,5.842000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.940000,0.000000,5.842000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.559000,0.000000,5.842000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<27.559000,0.000000,5.842000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.860000,0.000000,5.842000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.241000,0.000000,5.842000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<22.860000,0.000000,5.842000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.241000,0.000000,5.842000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,5.842000>}
box{<0,0,-0.076200><0.889000,0.036000,0.076200> rotate<0,0.000000,0> translate<23.241000,0.000000,5.842000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.860000,0.000000,11.938000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.241000,0.000000,11.938000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<22.860000,0.000000,11.938000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.940000,0.000000,11.938000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.559000,0.000000,11.938000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<27.559000,0.000000,11.938000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.559000,0.000000,11.938000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,11.938000>}
box{<0,0,-0.076200><0.889000,0.036000,0.076200> rotate<0,0.000000,0> translate<26.670000,0.000000,11.938000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,11.938000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,11.938000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,0.000000,0> translate<24.130000,0.000000,11.938000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,11.938000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.241000,0.000000,11.938000>}
box{<0,0,-0.076200><0.889000,0.036000,0.076200> rotate<0,0.000000,0> translate<23.241000,0.000000,11.938000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,5.842000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.543000,0.000000,5.842000>}
box{<0,0,-0.076200><2.413000,0.036000,0.076200> rotate<0,0.000000,0> translate<24.130000,0.000000,5.842000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.543000,0.000000,5.842000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.559000,0.000000,5.842000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<26.543000,0.000000,5.842000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,7.874000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<28.448000,0.000000,7.874000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,9.652000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,9.906000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<28.448000,0.000000,9.906000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,7.874000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<22.352000,0.000000,7.874000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,9.652000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,9.906000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<22.352000,0.000000,9.906000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,6.731000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,6.731000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,0.000000,0> translate<24.130000,0.000000,6.731000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,11.176000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,11.176000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,0.000000,0> translate<24.130000,0.000000,11.176000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.987000,0.000000,10.160000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.987000,0.000000,9.398000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<22.987000,0.000000,9.398000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.987000,0.000000,8.382000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.987000,0.000000,7.620000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<22.987000,0.000000,7.620000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.987000,0.000000,9.398000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.241000,0.000000,8.509000>}
box{<0,0,-0.076200><0.924574,0.036000,0.076200> rotate<0,74.049717,0> translate<22.987000,0.000000,9.398000> }
difference{
cylinder{<25.400000,0,8.890000><25.400000,0.036000,8.890000>1.854200 translate<0,0.000000,0>}
cylinder{<25.400000,-0.1,8.890000><25.400000,0.135000,8.890000>1.701800 translate<0,0.000000,0>}}
difference{
cylinder{<23.241000,0,6.731000><23.241000,0.036000,6.731000>0.584200 translate<0,0.000000,0>}
cylinder{<23.241000,-0.1,6.731000><23.241000,0.135000,6.731000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<27.559000,0,6.858000><27.559000,0.036000,6.858000>0.584200 translate<0,0.000000,0>}
cylinder{<27.559000,-0.1,6.858000><27.559000,0.135000,6.858000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<27.559000,0,11.049000><27.559000,0.036000,11.049000>0.584200 translate<0,0.000000,0>}
cylinder{<27.559000,-0.1,11.049000><27.559000,0.135000,11.049000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<23.241000,0,11.049000><23.241000,0.036000,11.049000>0.584200 translate<0,0.000000,0>}
cylinder{<23.241000,-0.1,11.049000><23.241000,0.135000,11.049000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<25.400000,0,8.890000><25.400000,0.036000,8.890000>0.660400 translate<0,0.000000,0>}
cylinder{<25.400000,-0.1,8.890000><25.400000,0.135000,8.890000>0.609600 translate<0,0.000000,0>}}
difference{
cylinder{<25.400000,0,8.890000><25.400000,0.036000,8.890000>0.330200 translate<0,0.000000,0>}
cylinder{<25.400000,-0.1,8.890000><25.400000,0.135000,8.890000>0.177800 translate<0,0.000000,0>}}
//S4 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.002000,0.000000,18.288000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.748000,0.000000,18.288000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<15.748000,0.000000,18.288000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.002000,0.000000,18.288000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.002000,0.000000,19.812000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,90.000000,0> translate<16.002000,0.000000,19.812000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.748000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.002000,0.000000,19.812000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<15.748000,0.000000,19.812000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.748000,0.000000,20.066000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.748000,0.000000,21.590000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,90.000000,0> translate<15.748000,0.000000,21.590000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.398000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.652000,0.000000,19.812000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<9.398000,0.000000,19.812000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.398000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.398000,0.000000,18.288000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,-90.000000,0> translate<9.398000,0.000000,18.288000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.652000,0.000000,18.288000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.398000,0.000000,18.288000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<9.398000,0.000000,18.288000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.748000,0.000000,21.590000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.240000,0.000000,22.098000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,44.997030,0> translate<15.240000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.240000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.748000,0.000000,16.510000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,-44.997030,0> translate<15.240000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.748000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.748000,0.000000,18.034000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,90.000000,0> translate<15.748000,0.000000,18.034000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.160000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.652000,0.000000,21.590000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,-44.997030,0> translate<9.652000,0.000000,21.590000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.652000,0.000000,21.590000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.652000,0.000000,20.066000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,-90.000000,0> translate<9.652000,0.000000,20.066000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.160000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.652000,0.000000,16.510000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,44.997030,0> translate<9.652000,0.000000,16.510000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.652000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.652000,0.000000,18.034000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,90.000000,0> translate<9.652000,0.000000,18.034000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.430000,0.000000,20.320000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.430000,0.000000,17.780000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,-90.000000,0> translate<11.430000,0.000000,17.780000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.970000,0.000000,17.780000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.430000,0.000000,17.780000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,0.000000,0> translate<11.430000,0.000000,17.780000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.970000,0.000000,17.780000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.970000,0.000000,20.320000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,90.000000,0> translate<13.970000,0.000000,20.320000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.430000,0.000000,20.320000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.970000,0.000000,20.320000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,0.000000,0> translate<11.430000,0.000000,20.320000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.430000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.430000,0.000000,21.844000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,-90.000000,0> translate<11.430000,0.000000,21.844000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.970000,0.000000,21.844000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.430000,0.000000,21.844000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,0.000000,0> translate<11.430000,0.000000,21.844000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.970000,0.000000,21.844000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.970000,0.000000,22.098000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,90.000000,0> translate<13.970000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.843000,0.000000,16.256000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.430000,0.000000,16.256000>}
box{<0,0,-0.025400><2.413000,0.036000,0.025400> rotate<0,0.000000,0> translate<11.430000,0.000000,16.256000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.843000,0.000000,16.256000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.843000,0.000000,16.002000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,-90.000000,0> translate<13.843000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.430000,0.000000,16.256000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.430000,0.000000,16.002000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,-90.000000,0> translate<11.430000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.240000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.859000,0.000000,16.002000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<14.859000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.160000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.541000,0.000000,16.002000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<10.160000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.541000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.430000,0.000000,16.002000>}
box{<0,0,-0.076200><0.889000,0.036000,0.076200> rotate<0,0.000000,0> translate<10.541000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.160000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.541000,0.000000,22.098000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<10.160000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.240000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.859000,0.000000,22.098000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<14.859000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.859000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.970000,0.000000,22.098000>}
box{<0,0,-0.076200><0.889000,0.036000,0.076200> rotate<0,0.000000,0> translate<13.970000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.970000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.430000,0.000000,22.098000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,0.000000,0> translate<11.430000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.430000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.541000,0.000000,22.098000>}
box{<0,0,-0.076200><0.889000,0.036000,0.076200> rotate<0,0.000000,0> translate<10.541000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.430000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.843000,0.000000,16.002000>}
box{<0,0,-0.076200><2.413000,0.036000,0.076200> rotate<0,0.000000,0> translate<11.430000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.843000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.859000,0.000000,16.002000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<13.843000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.748000,0.000000,18.288000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.748000,0.000000,18.034000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<15.748000,0.000000,18.034000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.748000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.748000,0.000000,20.066000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<15.748000,0.000000,20.066000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.652000,0.000000,18.288000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.652000,0.000000,18.034000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<9.652000,0.000000,18.034000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.652000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.652000,0.000000,20.066000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<9.652000,0.000000,20.066000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.430000,0.000000,16.891000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.970000,0.000000,16.891000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,0.000000,0> translate<11.430000,0.000000,16.891000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.970000,0.000000,21.336000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.430000,0.000000,21.336000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,0.000000,0> translate<11.430000,0.000000,21.336000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.287000,0.000000,20.320000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.287000,0.000000,19.558000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<10.287000,0.000000,19.558000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.287000,0.000000,18.542000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.287000,0.000000,17.780000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<10.287000,0.000000,17.780000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.287000,0.000000,19.558000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.541000,0.000000,18.669000>}
box{<0,0,-0.076200><0.924574,0.036000,0.076200> rotate<0,74.049717,0> translate<10.287000,0.000000,19.558000> }
difference{
cylinder{<12.700000,0,19.050000><12.700000,0.036000,19.050000>1.854200 translate<0,0.000000,0>}
cylinder{<12.700000,-0.1,19.050000><12.700000,0.135000,19.050000>1.701800 translate<0,0.000000,0>}}
difference{
cylinder{<10.541000,0,16.891000><10.541000,0.036000,16.891000>0.584200 translate<0,0.000000,0>}
cylinder{<10.541000,-0.1,16.891000><10.541000,0.135000,16.891000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<14.859000,0,17.018000><14.859000,0.036000,17.018000>0.584200 translate<0,0.000000,0>}
cylinder{<14.859000,-0.1,17.018000><14.859000,0.135000,17.018000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<14.859000,0,21.209000><14.859000,0.036000,21.209000>0.584200 translate<0,0.000000,0>}
cylinder{<14.859000,-0.1,21.209000><14.859000,0.135000,21.209000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<10.541000,0,21.209000><10.541000,0.036000,21.209000>0.584200 translate<0,0.000000,0>}
cylinder{<10.541000,-0.1,21.209000><10.541000,0.135000,21.209000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<12.700000,0,19.050000><12.700000,0.036000,19.050000>0.660400 translate<0,0.000000,0>}
cylinder{<12.700000,-0.1,19.050000><12.700000,0.135000,19.050000>0.609600 translate<0,0.000000,0>}}
difference{
cylinder{<12.700000,0,19.050000><12.700000,0.036000,19.050000>0.330200 translate<0,0.000000,0>}
cylinder{<12.700000,-0.1,19.050000><12.700000,0.135000,19.050000>0.177800 translate<0,0.000000,0>}}
//S5 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.702000,0.000000,18.288000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,18.288000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<28.448000,0.000000,18.288000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.702000,0.000000,18.288000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.702000,0.000000,19.812000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,90.000000,0> translate<28.702000,0.000000,19.812000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.702000,0.000000,19.812000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<28.448000,0.000000,19.812000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,20.066000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,21.590000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,90.000000,0> translate<28.448000,0.000000,21.590000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.098000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,19.812000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<22.098000,0.000000,19.812000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.098000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.098000,0.000000,18.288000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,-90.000000,0> translate<22.098000,0.000000,18.288000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,18.288000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.098000,0.000000,18.288000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<22.098000,0.000000,18.288000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,21.590000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.940000,0.000000,22.098000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,44.997030,0> translate<27.940000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.940000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,16.510000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,-44.997030,0> translate<27.940000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,18.034000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,90.000000,0> translate<28.448000,0.000000,18.034000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.860000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,21.590000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,-44.997030,0> translate<22.352000,0.000000,21.590000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,21.590000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,20.066000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,-90.000000,0> translate<22.352000,0.000000,20.066000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.860000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,16.510000>}
box{<0,0,-0.076200><0.718420,0.036000,0.076200> rotate<0,44.997030,0> translate<22.352000,0.000000,16.510000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,18.034000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,90.000000,0> translate<22.352000,0.000000,18.034000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,20.320000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,17.780000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,-90.000000,0> translate<24.130000,0.000000,17.780000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.670000,0.000000,17.780000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,17.780000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,0.000000,0> translate<24.130000,0.000000,17.780000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.670000,0.000000,17.780000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.670000,0.000000,20.320000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,90.000000,0> translate<26.670000,0.000000,20.320000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,20.320000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.670000,0.000000,20.320000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,0.000000,0> translate<24.130000,0.000000,20.320000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,21.844000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,-90.000000,0> translate<24.130000,0.000000,21.844000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.670000,0.000000,21.844000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,21.844000>}
box{<0,0,-0.025400><2.540000,0.036000,0.025400> rotate<0,0.000000,0> translate<24.130000,0.000000,21.844000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.670000,0.000000,21.844000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.670000,0.000000,22.098000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,90.000000,0> translate<26.670000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.543000,0.000000,16.256000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,16.256000>}
box{<0,0,-0.025400><2.413000,0.036000,0.025400> rotate<0,0.000000,0> translate<24.130000,0.000000,16.256000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.543000,0.000000,16.256000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<26.543000,0.000000,16.002000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,-90.000000,0> translate<26.543000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,16.256000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.130000,0.000000,16.002000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,-90.000000,0> translate<24.130000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.940000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.559000,0.000000,16.002000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<27.559000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.860000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.241000,0.000000,16.002000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<22.860000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.241000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,16.002000>}
box{<0,0,-0.076200><0.889000,0.036000,0.076200> rotate<0,0.000000,0> translate<23.241000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.860000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.241000,0.000000,22.098000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<22.860000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.940000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.559000,0.000000,22.098000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<27.559000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.559000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,22.098000>}
box{<0,0,-0.076200><0.889000,0.036000,0.076200> rotate<0,0.000000,0> translate<26.670000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,22.098000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,0.000000,0> translate<24.130000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.241000,0.000000,22.098000>}
box{<0,0,-0.076200><0.889000,0.036000,0.076200> rotate<0,0.000000,0> translate<23.241000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.543000,0.000000,16.002000>}
box{<0,0,-0.076200><2.413000,0.036000,0.076200> rotate<0,0.000000,0> translate<24.130000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.543000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.559000,0.000000,16.002000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<26.543000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,18.288000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,18.034000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<28.448000,0.000000,18.034000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,20.066000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<28.448000,0.000000,20.066000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,18.288000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,18.034000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<22.352000,0.000000,18.034000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.352000,0.000000,20.066000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<22.352000,0.000000,20.066000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,16.891000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,16.891000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,0.000000,0> translate<24.130000,0.000000,16.891000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,21.336000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,21.336000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,0.000000,0> translate<24.130000,0.000000,21.336000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.987000,0.000000,20.320000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.987000,0.000000,19.558000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<22.987000,0.000000,19.558000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.987000,0.000000,18.542000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.987000,0.000000,17.780000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<22.987000,0.000000,17.780000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.987000,0.000000,19.558000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.241000,0.000000,18.669000>}
box{<0,0,-0.076200><0.924574,0.036000,0.076200> rotate<0,74.049717,0> translate<22.987000,0.000000,19.558000> }
difference{
cylinder{<25.400000,0,19.050000><25.400000,0.036000,19.050000>1.854200 translate<0,0.000000,0>}
cylinder{<25.400000,-0.1,19.050000><25.400000,0.135000,19.050000>1.701800 translate<0,0.000000,0>}}
difference{
cylinder{<23.241000,0,16.891000><23.241000,0.036000,16.891000>0.584200 translate<0,0.000000,0>}
cylinder{<23.241000,-0.1,16.891000><23.241000,0.135000,16.891000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<27.559000,0,17.018000><27.559000,0.036000,17.018000>0.584200 translate<0,0.000000,0>}
cylinder{<27.559000,-0.1,17.018000><27.559000,0.135000,17.018000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<27.559000,0,21.209000><27.559000,0.036000,21.209000>0.584200 translate<0,0.000000,0>}
cylinder{<27.559000,-0.1,21.209000><27.559000,0.135000,21.209000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<23.241000,0,21.209000><23.241000,0.036000,21.209000>0.584200 translate<0,0.000000,0>}
cylinder{<23.241000,-0.1,21.209000><23.241000,0.135000,21.209000>0.431800 translate<0,0.000000,0>}}
difference{
cylinder{<25.400000,0,19.050000><25.400000,0.036000,19.050000>0.660400 translate<0,0.000000,0>}
cylinder{<25.400000,-0.1,19.050000><25.400000,0.135000,19.050000>0.609600 translate<0,0.000000,0>}}
difference{
cylinder{<25.400000,0,19.050000><25.400000,0.036000,19.050000>0.330200 translate<0,0.000000,0>}
cylinder{<25.400000,-0.1,19.050000><25.400000,0.135000,19.050000>0.177800 translate<0,0.000000,0>}}
texture{col_slk}
}
#end
translate<mac_x_ver,mac_y_ver,mac_z_ver>
rotate<mac_x_rot,mac_y_rot,mac_z_rot>
}//End union
#end

#if(use_file_as_inc=off)
object{  BUTTON_INTERFACE_BOARD(-25.400000,0,-22.225000,pcb_rotate_x,pcb_rotate_y,pcb_rotate_z)
#if(pcb_upsidedown=on)
rotate pcb_rotdir*180
#end
}
#end


//Parts not found in 3dpack.dat or 3dusrpac.dat are:
//H1	MOUNT-HOLE3.0	3,0
//H2	MOUNT-HOLE3.0	3,0
//H3	MOUNT-HOLE3.0	3,0
//H4	MOUNT-HOLE3.0	3,0
