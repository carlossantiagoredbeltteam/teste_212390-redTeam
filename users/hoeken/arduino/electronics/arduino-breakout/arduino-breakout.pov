//POVRay-File created by 3d41.ulp v1.05
///Users/iowa/Desktop/reprap/trunk/users/hoeken/arduino/electronics/arduino-breakout/arduino-breakout.brd
// 1/04/2008 14:56:39 

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

#local lgt1_pos_x = 31;
#local lgt1_pos_y = 46;
#local lgt1_pos_z = 38;
#local lgt1_intense = 0.785493;
#local lgt2_pos_x = -31;
#local lgt2_pos_y = 46;
#local lgt2_pos_z = 38;
#local lgt2_intense = 0.785493;
#local lgt3_pos_x = 31;
#local lgt3_pos_y = 46;
#local lgt3_pos_z = -26;
#local lgt3_intense = 0.785493;
#local lgt4_pos_x = -31;
#local lgt4_pos_y = 46;
#local lgt4_pos_z = -26;
#local lgt4_intense = 0.785493;

//Do not change these values
#declare pcb_height = 1.500000;
#declare pcb_cuheight = 0.035000;
#declare pcb_x_size = 81.991400;
#declare pcb_y_size = 72.989600;
#declare pcb_layer1_used = 1;
#declare pcb_layer16_used = 1;
#declare inc_testmode = off;
#declare global_seed=seed(890);
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
	//translate<-40.995700,0,-36.494800>
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
<18.681600,6.380400><100.546000,6.355000>
<100.546000,6.355000><100.444400,79.344600>
<100.444400,79.344600><18.554600,79.293800>
<18.554600,79.293800><18.681600,6.380400>
texture{col_brd}}
}//End union(Platine)
//Holes(real)/Parts
cylinder{<95.783400,1,10.439400><95.783400,-5,10.439400>1.500000 texture{col_hls}}
cylinder{<95.529400,1,74.803000><95.529400,-5,74.803000>1.500000 texture{col_hls}}
cylinder{<23.749000,1,10.287000><23.749000,-5,10.287000>1.500000 texture{col_hls}}
cylinder{<23.241000,1,74.625200><23.241000,-5,74.625200>1.500000 texture{col_hls}}
//Holes(real)/Board
//Holes(real)/Vias
}//End difference(reale Bohrungen/Durchbrüche)
#end
#if(pcb_parts=on)//Parts
union{
#ifndef(pack_C1) #declare global_pack_C1=yes; object {CAP_DIS_CERAMIC_50MM_76MM("100nf",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<95.317800,-0.000000,44.190400>}#end		//ceramic disc capacitator C1 100nf C050-030X075
#ifndef(pack_D1) #declare global_pack_D1=yes; object {DIODE_DIS_DO41_102MM_H("1N4004",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-0.000000,0> rotate<0,0,0> translate<93.980000,-0.000000,20.828000>}#end		//Diode DO35 10mm hor. D1 1N4004 DO41-10
#ifndef(pack_LED1) #declare global_pack_LED1=yes; object {DIODE_DIS_LED_5MM(Green,0.500000,0.000000,)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<94.733600,-0.000000,31.363400>}#end		//Diskrete 5MM LED LED1  LED5MM
#ifndef(pack_R1) #declare global_pack_R1=yes; object {RES_DIS_0207_075MM(texture{pigment{Green*0.7}finish{phong 0.2}},texture{pigment{Blue}finish{phong 0.2}},texture{pigment{DarkBrown}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-0.000000,0> rotate<0,0,0> translate<95.368600,-0.000000,25.369000>}#end		//Discrete Resistor 0,3W 7,5MM Grid R1 560 0207/7
#ifndef(pack_X2) #declare global_pack_X2=yes; object {CON_PHOENIX_508_MSTBV_12()translate<0,0,0> rotate<0,0.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<59.410600,-0.000000,75.260200>}#end		//Connector PHOENIX type MSTBV vertical 12 pins X2 MSTBV12 MSTBV12
#ifndef(pack_X5) #declare global_pack_X5=yes; object {CON_PHOENIX_508_MSTBV_12()translate<0,0,0> rotate<0,0.000000,0>rotate<0,-0.000000,0> rotate<0,0,0> translate<59.664600,-0.000000,10.134600>}#end		//Connector PHOENIX type MSTBV vertical 12 pins X5 MSTBV12 MSTBV12
}//End union
#end
#if(pcb_pads_smds=on)
//Pads&SMD/Parts
#ifndef(global_pack_C1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<97.857800,0,44.190400> texture{col_thl}}
#ifndef(global_pack_C1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<92.777800,0,44.190400> texture{col_thl}}
#ifndef(global_pack_C2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.600200,0.812800,1,16,1+global_tmp,0) rotate<0,-180.000000,0>translate<96.410000,0,38.196000> texture{col_thl}}
#ifndef(global_pack_C2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.600200,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<93.870000,0,38.196000> texture{col_thl}}
#ifndef(global_pack_D1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.676400,1.117600,1,16,1+global_tmp,0) rotate<0,-0.000000,0>translate<99.060000,0,20.828000> texture{col_thl}}
#ifndef(global_pack_D1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.676400,1.117600,1,16,1+global_tmp,0) rotate<0,-0.000000,0>translate<88.900000,0,20.828000> texture{col_thl}}
#ifndef(global_pack_LED1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<94.733600,0,30.093400> texture{col_thl}}
#ifndef(global_pack_LED1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<94.733600,0,32.633400> texture{col_thl}}
#ifndef(global_pack_R1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<91.558600,0,25.369000> texture{col_thl}}
#ifndef(global_pack_R1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<99.178600,0,25.369000> texture{col_thl}}
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
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.600000,1.600000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<96.308600,0,65.700000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.600000,1.600000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<96.308600,0,60.620000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.600000,1.600000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<96.308600,0,55.540000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.600000,1.600000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<96.308600,0,50.460000> texture{col_thl}}
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
#end
#if(pcb_wires=on)
union{
//Signals
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<31.724600,-0.000000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<32.004000,-0.000000,12.192000>}
box{<0,0,-0.254000><2.076285,0.035000,0.254000> rotate<0,-82.260973,0> translate<31.724600,-0.000000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<32.004000,-0.000000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<32.004000,-0.000000,13.716000>}
box{<0,0,-0.254000><1.524000,0.035000,0.254000> rotate<0,90.000000,0> translate<32.004000,-0.000000,13.716000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<31.470600,-0.000000,75.260200>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<32.512000,-0.000000,74.422000>}
box{<0,0,-0.254000><1.336822,0.035000,0.254000> rotate<0,38.827262,0> translate<31.470600,-0.000000,75.260200> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<33.782000,-0.000000,74.422000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<33.782000,-0.000000,73.152000>}
box{<0,0,-0.254000><1.270000,0.035000,0.254000> rotate<0,-90.000000,0> translate<33.782000,-0.000000,73.152000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<32.512000,-0.000000,74.422000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<33.782000,-0.000000,74.422000>}
box{<0,0,-0.254000><1.270000,0.035000,0.254000> rotate<0,0.000000,0> translate<32.512000,-0.000000,74.422000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<33.782000,-0.000000,73.152000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<36.322000,-0.000000,70.612000>}
box{<0,0,-0.254000><3.592102,0.035000,0.254000> rotate<0,44.997030,0> translate<33.782000,-0.000000,73.152000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<36.804600,-1.535000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<37.084000,-1.535000,12.192000>}
box{<0,0,-0.254000><2.076285,0.035000,0.254000> rotate<0,-82.260973,0> translate<36.804600,-1.535000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<36.550600,-1.535000,75.260200>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<37.592000,-1.535000,74.422000>}
box{<0,0,-0.254000><1.336822,0.035000,0.254000> rotate<0,38.827262,0> translate<36.550600,-1.535000,75.260200> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<38.862000,-1.535000,74.422000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<38.862000,-1.535000,73.152000>}
box{<0,0,-0.254000><1.270000,0.035000,0.254000> rotate<0,-90.000000,0> translate<38.862000,-1.535000,73.152000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<37.592000,-1.535000,74.422000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<38.862000,-1.535000,74.422000>}
box{<0,0,-0.254000><1.270000,0.035000,0.254000> rotate<0,0.000000,0> translate<37.592000,-1.535000,74.422000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<37.084000,-1.535000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<39.116000,-1.535000,12.192000>}
box{<0,0,-0.254000><2.032000,0.035000,0.254000> rotate<0,0.000000,0> translate<37.084000,-1.535000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<38.862000,-1.535000,73.152000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<41.402000,-1.535000,70.612000>}
box{<0,0,-0.254000><3.592102,0.035000,0.254000> rotate<0,44.997030,0> translate<38.862000,-1.535000,73.152000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<41.884600,-0.000000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<42.164000,-0.000000,12.192000>}
box{<0,0,-0.254000><2.076285,0.035000,0.254000> rotate<0,-82.260973,0> translate<41.884600,-0.000000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<41.630600,-0.000000,75.260200>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<42.672000,-0.000000,74.422000>}
box{<0,0,-0.254000><1.336822,0.035000,0.254000> rotate<0,38.827262,0> translate<41.630600,-0.000000,75.260200> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<39.116000,-1.535000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<43.688000,-1.535000,16.764000>}
box{<0,0,-0.254000><6.465784,0.035000,0.254000> rotate<0,-44.997030,0> translate<39.116000,-1.535000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<43.942000,-0.000000,74.422000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<43.942000,-0.000000,73.152000>}
box{<0,0,-0.254000><1.270000,0.035000,0.254000> rotate<0,-90.000000,0> translate<43.942000,-0.000000,73.152000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<42.672000,-0.000000,74.422000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<43.942000,-0.000000,74.422000>}
box{<0,0,-0.254000><1.270000,0.035000,0.254000> rotate<0,0.000000,0> translate<42.672000,-0.000000,74.422000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<42.164000,-0.000000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<44.196000,-0.000000,12.192000>}
box{<0,0,-0.254000><2.032000,0.035000,0.254000> rotate<0,0.000000,0> translate<42.164000,-0.000000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<43.942000,-0.000000,73.152000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<45.466000,-0.000000,71.628000>}
box{<0,0,-0.254000><2.155261,0.035000,0.254000> rotate<0,44.997030,0> translate<43.942000,-0.000000,73.152000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<44.196000,-0.000000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<45.720000,-0.000000,13.716000>}
box{<0,0,-0.254000><2.155261,0.035000,0.254000> rotate<0,-44.997030,0> translate<44.196000,-0.000000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<32.004000,-0.000000,13.716000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<45.974000,-0.000000,27.686000>}
box{<0,0,-0.254000><19.756563,0.035000,0.254000> rotate<0,-44.997030,0> translate<32.004000,-0.000000,13.716000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<45.974000,-0.000000,27.686000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<45.974000,-0.000000,65.024000>}
box{<0,0,-0.254000><37.338000,0.035000,0.254000> rotate<0,90.000000,0> translate<45.974000,-0.000000,65.024000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<45.974000,-0.000000,65.024000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<46.558200,-0.000000,65.938400>}
box{<0,0,-0.254000><1.085088,0.035000,0.254000> rotate<0,-57.422153,0> translate<45.974000,-0.000000,65.024000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<46.964600,-1.535000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<47.244000,-1.535000,12.192000>}
box{<0,0,-0.254000><2.076285,0.035000,0.254000> rotate<0,-82.260973,0> translate<46.964600,-1.535000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<46.710600,-1.535000,75.260200>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<47.752000,-1.535000,74.422000>}
box{<0,0,-0.254000><1.336822,0.035000,0.254000> rotate<0,38.827262,0> translate<46.710600,-1.535000,75.260200> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<49.022000,-1.535000,74.422000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<49.022000,-1.535000,73.152000>}
box{<0,0,-0.254000><1.270000,0.035000,0.254000> rotate<0,-90.000000,0> translate<49.022000,-1.535000,73.152000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<47.752000,-1.535000,74.422000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<49.022000,-1.535000,74.422000>}
box{<0,0,-0.254000><1.270000,0.035000,0.254000> rotate<0,0.000000,0> translate<47.752000,-1.535000,74.422000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<47.244000,-1.535000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<49.276000,-1.535000,12.192000>}
box{<0,0,-0.254000><2.032000,0.035000,0.254000> rotate<0,0.000000,0> translate<47.244000,-1.535000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<36.322000,-0.000000,70.612000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<49.276000,-0.000000,70.612000>}
box{<0,0,-0.254000><12.954000,0.035000,0.254000> rotate<0,0.000000,0> translate<36.322000,-0.000000,70.612000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<49.022000,-1.535000,73.152000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<50.546000,-1.535000,71.628000>}
box{<0,0,-0.254000><2.155261,0.035000,0.254000> rotate<0,44.997030,0> translate<49.022000,-1.535000,73.152000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<51.054000,-0.000000,68.834000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<51.054000,-0.000000,66.802000>}
box{<0,0,-0.254000><2.032000,0.035000,0.254000> rotate<0,-90.000000,0> translate<51.054000,-0.000000,66.802000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<49.276000,-0.000000,70.612000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<51.054000,-0.000000,68.834000>}
box{<0,0,-0.254000><2.514472,0.035000,0.254000> rotate<0,44.997030,0> translate<49.276000,-0.000000,70.612000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<51.054000,-0.000000,66.802000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<51.638200,-0.000000,65.938400>}
box{<0,0,-0.254000><1.042638,0.035000,0.254000> rotate<0,55.919114,0> translate<51.054000,-0.000000,66.802000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<49.276000,-1.535000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<51.816000,-1.535000,14.732000>}
box{<0,0,-0.254000><3.592102,0.035000,0.254000> rotate<0,-44.997030,0> translate<49.276000,-1.535000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<41.402000,-1.535000,70.612000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<51.816000,-1.535000,70.612000>}
box{<0,0,-0.254000><10.414000,0.035000,0.254000> rotate<0,0.000000,0> translate<41.402000,-1.535000,70.612000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<52.044600,-1.535000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<52.324000,-1.535000,12.192000>}
box{<0,0,-0.254000><2.076285,0.035000,0.254000> rotate<0,-82.260973,0> translate<52.044600,-1.535000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<51.790600,-0.000000,75.260200>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<52.832000,-0.000000,74.422000>}
box{<0,0,-0.254000><1.336822,0.035000,0.254000> rotate<0,38.827262,0> translate<51.790600,-0.000000,75.260200> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<45.466000,-0.000000,71.628000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<53.340000,-0.000000,71.628000>}
box{<0,0,-0.254000><7.874000,0.035000,0.254000> rotate<0,0.000000,0> translate<45.466000,-0.000000,71.628000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<53.594000,-1.535000,68.834000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<53.594000,-1.535000,66.802000>}
box{<0,0,-0.254000><2.032000,0.035000,0.254000> rotate<0,-90.000000,0> translate<53.594000,-1.535000,66.802000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<51.816000,-1.535000,70.612000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<53.594000,-1.535000,68.834000>}
box{<0,0,-0.254000><2.514472,0.035000,0.254000> rotate<0,44.997030,0> translate<51.816000,-1.535000,70.612000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<52.832000,-0.000000,74.422000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<54.102000,-0.000000,74.422000>}
box{<0,0,-0.254000><1.270000,0.035000,0.254000> rotate<0,0.000000,0> translate<52.832000,-0.000000,74.422000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<54.102000,-0.000000,73.152000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<54.102000,-0.000000,74.422000>}
box{<0,0,-0.254000><1.270000,0.035000,0.254000> rotate<0,90.000000,0> translate<54.102000,-0.000000,74.422000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<53.594000,-1.535000,66.802000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<54.178200,-1.535000,65.938400>}
box{<0,0,-0.254000><1.042638,0.035000,0.254000> rotate<0,55.919114,0> translate<53.594000,-1.535000,66.802000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<52.324000,-1.535000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<54.356000,-1.535000,12.192000>}
box{<0,0,-0.254000><2.032000,0.035000,0.254000> rotate<0,0.000000,0> translate<52.324000,-1.535000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<43.688000,-1.535000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<55.118000,-1.535000,16.764000>}
box{<0,0,-0.254000><11.430000,0.035000,0.254000> rotate<0,0.000000,0> translate<43.688000,-1.535000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<54.102000,-0.000000,73.152000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<55.626000,-0.000000,71.628000>}
box{<0,0,-0.254000><2.155261,0.035000,0.254000> rotate<0,44.997030,0> translate<54.102000,-0.000000,73.152000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<55.118000,-1.535000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<55.702200,-1.535000,17.678400>}
box{<0,0,-0.254000><1.085088,0.035000,0.254000> rotate<0,-57.422153,0> translate<55.118000,-1.535000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<54.356000,-1.535000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<55.880000,-1.535000,13.716000>}
box{<0,0,-0.254000><2.155261,0.035000,0.254000> rotate<0,-44.997030,0> translate<54.356000,-1.535000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<50.546000,-1.535000,71.628000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<55.880000,-1.535000,71.628000>}
box{<0,0,-0.254000><5.334000,0.035000,0.254000> rotate<0,0.000000,0> translate<50.546000,-1.535000,71.628000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<56.134000,-0.000000,68.834000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<56.134000,-0.000000,66.802000>}
box{<0,0,-0.254000><2.032000,0.035000,0.254000> rotate<0,-90.000000,0> translate<56.134000,-0.000000,66.802000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<53.340000,-0.000000,71.628000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<56.134000,-0.000000,68.834000>}
box{<0,0,-0.254000><3.951313,0.035000,0.254000> rotate<0,44.997030,0> translate<53.340000,-0.000000,71.628000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<45.720000,-0.000000,13.716000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<56.388000,-0.000000,13.716000>}
box{<0,0,-0.254000><10.668000,0.035000,0.254000> rotate<0,0.000000,0> translate<45.720000,-0.000000,13.716000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<56.134000,-0.000000,66.802000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<56.718200,-0.000000,65.938400>}
box{<0,0,-0.254000><1.042638,0.035000,0.254000> rotate<0,55.919114,0> translate<56.134000,-0.000000,66.802000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<57.124600,-0.000000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<57.404000,-0.000000,12.192000>}
box{<0,0,-0.254000><2.076285,0.035000,0.254000> rotate<0,-82.260973,0> translate<57.124600,-0.000000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<56.388000,-0.000000,13.716000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<57.658000,-0.000000,14.986000>}
box{<0,0,-0.254000><1.796051,0.035000,0.254000> rotate<0,-44.997030,0> translate<56.388000,-0.000000,13.716000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<57.658000,-0.000000,14.986000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<57.658000,-0.000000,16.764000>}
box{<0,0,-0.254000><1.778000,0.035000,0.254000> rotate<0,90.000000,0> translate<57.658000,-0.000000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<56.870600,-0.000000,75.260200>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<57.912000,-0.000000,74.422000>}
box{<0,0,-0.254000><1.336822,0.035000,0.254000> rotate<0,38.827262,0> translate<56.870600,-0.000000,75.260200> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<57.658000,-0.000000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<58.242200,-0.000000,17.678400>}
box{<0,0,-0.254000><1.085088,0.035000,0.254000> rotate<0,-57.422153,0> translate<57.658000,-0.000000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<55.626000,-0.000000,71.628000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<58.420000,-0.000000,71.628000>}
box{<0,0,-0.254000><2.794000,0.035000,0.254000> rotate<0,0.000000,0> translate<55.626000,-0.000000,71.628000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<58.674000,-1.535000,68.834000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<58.674000,-1.535000,66.802000>}
box{<0,0,-0.254000><2.032000,0.035000,0.254000> rotate<0,-90.000000,0> translate<58.674000,-1.535000,66.802000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<55.880000,-1.535000,71.628000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<58.674000,-1.535000,68.834000>}
box{<0,0,-0.254000><3.951313,0.035000,0.254000> rotate<0,44.997030,0> translate<55.880000,-1.535000,71.628000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<58.674000,-1.535000,66.802000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<59.258200,-1.535000,65.938400>}
box{<0,0,-0.254000><1.042638,0.035000,0.254000> rotate<0,55.919114,0> translate<58.674000,-1.535000,66.802000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<57.404000,-0.000000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<59.436000,-0.000000,12.192000>}
box{<0,0,-0.254000><2.032000,0.035000,0.254000> rotate<0,0.000000,0> translate<57.404000,-0.000000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<57.912000,-0.000000,74.422000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<59.436000,-0.000000,74.422000>}
box{<0,0,-0.254000><1.524000,0.035000,0.254000> rotate<0,0.000000,0> translate<57.912000,-0.000000,74.422000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<59.436000,-0.000000,73.152000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<59.436000,-0.000000,74.422000>}
box{<0,0,-0.254000><1.270000,0.035000,0.254000> rotate<0,90.000000,0> translate<59.436000,-0.000000,74.422000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<51.816000,-1.535000,14.732000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<59.944000,-1.535000,14.732000>}
box{<0,0,-0.254000><8.128000,0.035000,0.254000> rotate<0,0.000000,0> translate<51.816000,-1.535000,14.732000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<59.944000,-1.535000,14.732000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<60.198000,-1.535000,14.986000>}
box{<0,0,-0.254000><0.359210,0.035000,0.254000> rotate<0,-44.997030,0> translate<59.944000,-1.535000,14.732000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<60.198000,-1.535000,14.986000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<60.198000,-1.535000,16.764000>}
box{<0,0,-0.254000><1.778000,0.035000,0.254000> rotate<0,90.000000,0> translate<60.198000,-1.535000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<55.880000,-1.535000,13.716000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<60.452000,-1.535000,13.716000>}
box{<0,0,-0.254000><4.572000,0.035000,0.254000> rotate<0,0.000000,0> translate<55.880000,-1.535000,13.716000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<60.198000,-1.535000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<60.782200,-1.535000,17.678400>}
box{<0,0,-0.254000><1.085088,0.035000,0.254000> rotate<0,-57.422153,0> translate<60.198000,-1.535000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<59.436000,-0.000000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<60.960000,-0.000000,13.716000>}
box{<0,0,-0.254000><2.155261,0.035000,0.254000> rotate<0,-44.997030,0> translate<59.436000,-0.000000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<58.420000,-0.000000,71.628000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<61.214000,-0.000000,68.834000>}
box{<0,0,-0.254000><3.951313,0.035000,0.254000> rotate<0,44.997030,0> translate<58.420000,-0.000000,71.628000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<61.214000,-0.000000,66.802000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<61.214000,-0.000000,68.834000>}
box{<0,0,-0.254000><2.032000,0.035000,0.254000> rotate<0,90.000000,0> translate<61.214000,-0.000000,68.834000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<60.452000,-1.535000,13.716000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<61.468000,-1.535000,14.732000>}
box{<0,0,-0.254000><1.436841,0.035000,0.254000> rotate<0,-44.997030,0> translate<60.452000,-1.535000,13.716000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<61.214000,-0.000000,66.802000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<61.798200,-0.000000,65.938400>}
box{<0,0,-0.254000><1.042638,0.035000,0.254000> rotate<0,55.919114,0> translate<61.214000,-0.000000,66.802000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<62.204600,-1.535000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<62.484000,-1.535000,12.192000>}
box{<0,0,-0.254000><2.076285,0.035000,0.254000> rotate<0,-82.260973,0> translate<62.204600,-1.535000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<61.950600,-1.535000,75.260200>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<62.738000,-1.535000,73.660000>}
box{<0,0,-0.254000><1.783435,0.035000,0.254000> rotate<0,63.795675,0> translate<61.950600,-1.535000,75.260200> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<59.436000,-0.000000,73.152000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<63.754000,-0.000000,68.834000>}
box{<0,0,-0.254000><6.106574,0.035000,0.254000> rotate<0,44.997030,0> translate<59.436000,-0.000000,73.152000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<63.754000,-0.000000,66.802000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<63.754000,-0.000000,68.834000>}
box{<0,0,-0.254000><2.032000,0.035000,0.254000> rotate<0,90.000000,0> translate<63.754000,-0.000000,68.834000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<62.738000,-1.535000,73.660000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<64.008000,-1.535000,73.660000>}
box{<0,0,-0.254000><1.270000,0.035000,0.254000> rotate<0,0.000000,0> translate<62.738000,-1.535000,73.660000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<64.008000,-1.535000,72.898000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<64.008000,-1.535000,73.660000>}
box{<0,0,-0.254000><0.762000,0.035000,0.254000> rotate<0,90.000000,0> translate<64.008000,-1.535000,73.660000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<63.754000,-0.000000,66.802000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<64.338200,-0.000000,65.938400>}
box{<0,0,-0.254000><1.042638,0.035000,0.254000> rotate<0,55.919114,0> translate<63.754000,-0.000000,66.802000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<62.484000,-1.535000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<64.516000,-1.535000,12.192000>}
box{<0,0,-0.254000><2.032000,0.035000,0.254000> rotate<0,0.000000,0> translate<62.484000,-1.535000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<64.516000,-1.535000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<66.040000,-1.535000,13.716000>}
box{<0,0,-0.254000><2.155261,0.035000,0.254000> rotate<0,-44.997030,0> translate<64.516000,-1.535000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<67.284600,-1.535000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<67.564000,-1.535000,12.192000>}
box{<0,0,-0.254000><2.076285,0.035000,0.254000> rotate<0,-82.260973,0> translate<67.284600,-1.535000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<64.008000,-1.535000,72.898000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<67.818000,-1.535000,69.088000>}
box{<0,0,-0.254000><5.388154,0.035000,0.254000> rotate<0,44.997030,0> translate<64.008000,-1.535000,72.898000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<67.818000,-1.535000,66.802000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<67.818000,-1.535000,69.088000>}
box{<0,0,-0.254000><2.286000,0.035000,0.254000> rotate<0,90.000000,0> translate<67.818000,-1.535000,69.088000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<67.030600,-0.000000,75.260200>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<67.818000,-0.000000,73.660000>}
box{<0,0,-0.254000><1.783435,0.035000,0.254000> rotate<0,63.795675,0> translate<67.030600,-0.000000,75.260200> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<67.818000,-0.000000,71.628000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<67.818000,-0.000000,73.660000>}
box{<0,0,-0.254000><2.032000,0.035000,0.254000> rotate<0,90.000000,0> translate<67.818000,-0.000000,73.660000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<67.818000,-1.535000,66.802000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<68.402200,-1.535000,65.938400>}
box{<0,0,-0.254000><1.042638,0.035000,0.254000> rotate<0,55.919114,0> translate<67.818000,-1.535000,66.802000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<61.468000,-1.535000,14.732000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<68.834000,-1.535000,14.732000>}
box{<0,0,-0.254000><7.366000,0.035000,0.254000> rotate<0,0.000000,0> translate<61.468000,-1.535000,14.732000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<68.402200,-0.000000,17.678400>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<68.834000,-0.000000,18.796000>}
box{<0,0,-0.254000><1.198116,0.035000,0.254000> rotate<0,-68.870735,0> translate<68.402200,-0.000000,17.678400> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<68.834000,-1.535000,14.732000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<69.088000,-1.535000,14.986000>}
box{<0,0,-0.254000><0.359210,0.035000,0.254000> rotate<0,-44.997030,0> translate<68.834000,-1.535000,14.732000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<69.088000,-1.535000,14.986000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<69.088000,-1.535000,15.748000>}
box{<0,0,-0.254000><0.762000,0.035000,0.254000> rotate<0,90.000000,0> translate<69.088000,-1.535000,15.748000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<66.040000,-1.535000,13.716000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<69.342000,-1.535000,13.716000>}
box{<0,0,-0.254000><3.302000,0.035000,0.254000> rotate<0,0.000000,0> translate<66.040000,-1.535000,13.716000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<67.564000,-1.535000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<69.596000,-1.535000,12.192000>}
box{<0,0,-0.254000><2.032000,0.035000,0.254000> rotate<0,0.000000,0> translate<67.564000,-1.535000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<69.342000,-1.535000,13.716000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<70.358000,-1.535000,14.732000>}
box{<0,0,-0.254000><1.436841,0.035000,0.254000> rotate<0,-44.997030,0> translate<69.342000,-1.535000,13.716000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<69.088000,-1.535000,15.748000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<70.358000,-1.535000,15.748000>}
box{<0,0,-0.254000><1.270000,0.035000,0.254000> rotate<0,0.000000,0> translate<69.088000,-1.535000,15.748000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<67.818000,-0.000000,71.628000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<70.612000,-0.000000,68.834000>}
box{<0,0,-0.254000><3.951313,0.035000,0.254000> rotate<0,44.997030,0> translate<67.818000,-0.000000,71.628000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<70.612000,-0.000000,67.056000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<70.612000,-0.000000,68.834000>}
box{<0,0,-0.254000><1.778000,0.035000,0.254000> rotate<0,90.000000,0> translate<70.612000,-0.000000,68.834000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<68.834000,-0.000000,18.796000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<70.866000,-0.000000,18.796000>}
box{<0,0,-0.254000><2.032000,0.035000,0.254000> rotate<0,0.000000,0> translate<68.834000,-0.000000,18.796000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<70.612000,-0.000000,67.056000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<70.942200,-0.000000,65.938400>}
box{<0,0,-0.254000><1.165359,0.035000,0.254000> rotate<0,73.535132,0> translate<70.612000,-0.000000,67.056000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<69.596000,-1.535000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<71.120000,-1.535000,13.716000>}
box{<0,0,-0.254000><2.155261,0.035000,0.254000> rotate<0,-44.997030,0> translate<69.596000,-1.535000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<70.358000,-1.535000,15.748000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<71.374000,-1.535000,16.764000>}
box{<0,0,-0.254000><1.436841,0.035000,0.254000> rotate<0,-44.997030,0> translate<70.358000,-1.535000,15.748000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<72.364600,-0.000000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<72.644000,-0.000000,12.192000>}
box{<0,0,-0.254000><2.076285,0.035000,0.254000> rotate<0,-82.260973,0> translate<72.364600,-0.000000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<70.866000,-0.000000,18.796000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<72.644000,-0.000000,20.574000>}
box{<0,0,-0.254000><2.514472,0.035000,0.254000> rotate<0,-44.997030,0> translate<70.866000,-0.000000,18.796000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<71.374000,-1.535000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<72.898000,-1.535000,16.764000>}
box{<0,0,-0.254000><1.524000,0.035000,0.254000> rotate<0,0.000000,0> translate<71.374000,-1.535000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<72.110600,-0.000000,75.260200>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<73.152000,-0.000000,73.914000>}
box{<0,0,-0.254000><1.701990,0.035000,0.254000> rotate<0,52.271555,0> translate<72.110600,-0.000000,75.260200> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<73.152000,-0.000000,67.056000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<73.152000,-0.000000,73.914000>}
box{<0,0,-0.254000><6.858000,0.035000,0.254000> rotate<0,90.000000,0> translate<73.152000,-0.000000,73.914000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<72.898000,-1.535000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<73.482200,-1.535000,17.678400>}
box{<0,0,-0.254000><1.085088,0.035000,0.254000> rotate<0,-57.422153,0> translate<72.898000,-1.535000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<73.152000,-0.000000,67.056000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<73.482200,-0.000000,65.938400>}
box{<0,0,-0.254000><1.165359,0.035000,0.254000> rotate<0,73.535132,0> translate<73.152000,-0.000000,67.056000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<60.960000,-0.000000,13.716000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<74.168000,-0.000000,13.716000>}
box{<0,0,-0.254000><13.208000,0.035000,0.254000> rotate<0,0.000000,0> translate<60.960000,-0.000000,13.716000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<72.644000,-0.000000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<74.676000,-0.000000,12.192000>}
box{<0,0,-0.254000><2.032000,0.035000,0.254000> rotate<0,0.000000,0> translate<72.644000,-0.000000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<74.168000,-0.000000,13.716000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<75.438000,-0.000000,14.986000>}
box{<0,0,-0.254000><1.796051,0.035000,0.254000> rotate<0,-44.997030,0> translate<74.168000,-0.000000,13.716000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<75.438000,-0.000000,14.986000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<75.438000,-0.000000,16.764000>}
box{<0,0,-0.254000><1.778000,0.035000,0.254000> rotate<0,90.000000,0> translate<75.438000,-0.000000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<75.438000,-0.000000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<76.022200,-0.000000,17.678400>}
box{<0,0,-0.254000><1.085088,0.035000,0.254000> rotate<0,-57.422153,0> translate<75.438000,-0.000000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<76.022200,-0.000000,65.938400>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<76.454000,-0.000000,67.056000>}
box{<0,0,-0.254000><1.198116,0.035000,0.254000> rotate<0,-68.870735,0> translate<76.022200,-0.000000,65.938400> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<76.454000,-0.000000,67.056000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<76.454000,-0.000000,73.660000>}
box{<0,0,-0.254000><6.604000,0.035000,0.254000> rotate<0,90.000000,0> translate<76.454000,-0.000000,73.660000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<76.454000,-0.000000,73.660000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<77.190600,-0.000000,75.260200>}
box{<0,0,-0.254000><1.761596,0.035000,0.254000> rotate<0,-65.278251,0> translate<76.454000,-0.000000,73.660000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<74.676000,-0.000000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<77.216000,-0.000000,14.732000>}
box{<0,0,-0.254000><3.592102,0.035000,0.254000> rotate<0,-44.997030,0> translate<74.676000,-0.000000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<77.444600,-0.000000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<77.724000,-0.000000,12.192000>}
box{<0,0,-0.254000><2.076285,0.035000,0.254000> rotate<0,-82.260973,0> translate<77.444600,-0.000000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<70.358000,-1.535000,14.732000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<77.724000,-1.535000,14.732000>}
box{<0,0,-0.254000><7.366000,0.035000,0.254000> rotate<0,0.000000,0> translate<70.358000,-1.535000,14.732000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<77.724000,-1.535000,14.732000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<77.978000,-1.535000,14.986000>}
box{<0,0,-0.254000><0.359210,0.035000,0.254000> rotate<0,-44.997030,0> translate<77.724000,-1.535000,14.732000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<77.978000,-1.535000,14.986000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<77.978000,-1.535000,16.764000>}
box{<0,0,-0.254000><1.778000,0.035000,0.254000> rotate<0,90.000000,0> translate<77.978000,-1.535000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<77.978000,-1.535000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<78.562200,-1.535000,17.678400>}
box{<0,0,-0.254000><1.085088,0.035000,0.254000> rotate<0,-57.422153,0> translate<77.978000,-1.535000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<78.562200,-0.000000,65.938400>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<78.994000,-0.000000,67.056000>}
box{<0,0,-0.254000><1.198116,0.035000,0.254000> rotate<0,-68.870735,0> translate<78.562200,-0.000000,65.938400> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<78.994000,-0.000000,67.056000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<78.994000,-0.000000,68.834000>}
box{<0,0,-0.254000><1.778000,0.035000,0.254000> rotate<0,90.000000,0> translate<78.994000,-0.000000,68.834000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<71.120000,-1.535000,13.716000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<79.248000,-1.535000,13.716000>}
box{<0,0,-0.254000><8.128000,0.035000,0.254000> rotate<0,0.000000,0> translate<71.120000,-1.535000,13.716000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<77.724000,-0.000000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<79.756000,-0.000000,12.192000>}
box{<0,0,-0.254000><2.032000,0.035000,0.254000> rotate<0,0.000000,0> translate<77.724000,-0.000000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<79.248000,-1.535000,13.716000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<80.518000,-1.535000,14.986000>}
box{<0,0,-0.254000><1.796051,0.035000,0.254000> rotate<0,-44.997030,0> translate<79.248000,-1.535000,13.716000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<80.518000,-1.535000,14.986000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<80.518000,-1.535000,16.764000>}
box{<0,0,-0.254000><1.778000,0.035000,0.254000> rotate<0,90.000000,0> translate<80.518000,-1.535000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<80.518000,-1.535000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<81.102200,-1.535000,17.678400>}
box{<0,0,-0.254000><1.085088,0.035000,0.254000> rotate<0,-57.422153,0> translate<80.518000,-1.535000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<79.756000,-0.000000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<81.280000,-0.000000,13.716000>}
box{<0,0,-0.254000><2.155261,0.035000,0.254000> rotate<0,-44.997030,0> translate<79.756000,-0.000000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<81.102200,-1.535000,65.938400>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<81.534000,-1.535000,67.056000>}
box{<0,0,-0.254000><1.198116,0.035000,0.254000> rotate<0,-68.870735,0> translate<81.102200,-1.535000,65.938400> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<81.534000,-1.535000,67.056000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<81.534000,-1.535000,69.088000>}
box{<0,0,-0.254000><2.032000,0.035000,0.254000> rotate<0,90.000000,0> translate<81.534000,-1.535000,69.088000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<78.994000,-0.000000,68.834000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<81.788000,-0.000000,71.628000>}
box{<0,0,-0.254000><3.951313,0.035000,0.254000> rotate<0,-44.997030,0> translate<78.994000,-0.000000,68.834000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<81.788000,-0.000000,71.628000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<81.788000,-0.000000,73.406000>}
box{<0,0,-0.254000><1.778000,0.035000,0.254000> rotate<0,90.000000,0> translate<81.788000,-0.000000,73.406000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<81.788000,-0.000000,73.406000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<82.270600,-0.000000,75.260200>}
box{<0,0,-0.254000><1.915975,0.035000,0.254000> rotate<0,-75.406104,0> translate<81.788000,-0.000000,73.406000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<82.524600,-0.000000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<82.804000,-0.000000,12.192000>}
box{<0,0,-0.254000><2.076285,0.035000,0.254000> rotate<0,-82.260973,0> translate<82.524600,-0.000000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<77.216000,-0.000000,14.732000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<82.804000,-0.000000,14.732000>}
box{<0,0,-0.254000><5.588000,0.035000,0.254000> rotate<0,0.000000,0> translate<77.216000,-0.000000,14.732000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<82.804000,-0.000000,14.732000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<83.058000,-0.000000,14.986000>}
box{<0,0,-0.254000><0.359210,0.035000,0.254000> rotate<0,-44.997030,0> translate<82.804000,-0.000000,14.732000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<83.058000,-0.000000,14.986000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<83.058000,-0.000000,16.764000>}
box{<0,0,-0.254000><1.778000,0.035000,0.254000> rotate<0,90.000000,0> translate<83.058000,-0.000000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<83.058000,-0.000000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<83.642200,-0.000000,17.678400>}
box{<0,0,-0.254000><1.085088,0.035000,0.254000> rotate<0,-57.422153,0> translate<83.058000,-0.000000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<83.642200,-0.000000,65.938400>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<83.820000,-0.000000,64.770000>}
box{<0,0,-0.254000><1.181851,0.035000,0.254000> rotate<0,81.342090,0> translate<83.642200,-0.000000,65.938400> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<83.820000,-0.000000,29.210000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<83.820000,-0.000000,64.770000>}
box{<0,0,-0.254000><35.560000,0.035000,0.254000> rotate<0,90.000000,0> translate<83.820000,-0.000000,64.770000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<81.280000,-0.000000,13.716000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<84.328000,-0.000000,13.716000>}
box{<0,0,-0.254000><3.048000,0.035000,0.254000> rotate<0,0.000000,0> translate<81.280000,-0.000000,13.716000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<82.804000,-0.000000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<84.836000,-0.000000,12.192000>}
box{<0,0,-0.254000><2.032000,0.035000,0.254000> rotate<0,0.000000,0> translate<82.804000,-0.000000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<81.534000,-1.535000,69.088000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<85.344000,-1.535000,72.898000>}
box{<0,0,-0.254000><5.388154,0.035000,0.254000> rotate<0,-44.997030,0> translate<81.534000,-1.535000,69.088000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<85.344000,-1.535000,72.898000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<85.344000,-1.535000,73.660000>}
box{<0,0,-0.254000><0.762000,0.035000,0.254000> rotate<0,90.000000,0> translate<85.344000,-1.535000,73.660000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<84.328000,-0.000000,13.716000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<85.598000,-0.000000,14.986000>}
box{<0,0,-0.254000><1.796051,0.035000,0.254000> rotate<0,-44.997030,0> translate<84.328000,-0.000000,13.716000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<85.598000,-0.000000,14.986000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<85.598000,-0.000000,16.764000>}
box{<0,0,-0.254000><1.778000,0.035000,0.254000> rotate<0,90.000000,0> translate<85.598000,-0.000000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<85.598000,-0.000000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<86.182200,-0.000000,17.678400>}
box{<0,0,-0.254000><1.085088,0.035000,0.254000> rotate<0,-57.422153,0> translate<85.598000,-0.000000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<86.182200,-1.535000,65.938400>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<86.614000,-1.535000,65.024000>}
box{<0,0,-0.254000><1.011226,0.035000,0.254000> rotate<0,64.718006,0> translate<86.182200,-1.535000,65.938400> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<86.614000,-1.535000,26.416000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<86.614000,-1.535000,65.024000>}
box{<0,0,-0.254000><38.608000,0.035000,0.254000> rotate<0,90.000000,0> translate<86.614000,-1.535000,65.024000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<85.344000,-1.535000,73.660000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<86.614000,-1.535000,73.660000>}
box{<0,0,-0.254000><1.270000,0.035000,0.254000> rotate<0,0.000000,0> translate<85.344000,-1.535000,73.660000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<86.614000,-1.535000,73.660000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<87.350600,-1.535000,75.260200>}
box{<0,0,-0.254000><1.761596,0.035000,0.254000> rotate<0,-65.278251,0> translate<86.614000,-1.535000,73.660000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<87.604600,-1.535000,10.134600>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<87.884000,-1.535000,12.192000>}
box{<0,0,-0.254000><2.076285,0.035000,0.254000> rotate<0,-82.260973,0> translate<87.604600,-1.535000,10.134600> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<87.884000,-1.535000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<87.884000,-1.535000,13.716000>}
box{<0,0,-0.254000><1.524000,0.035000,0.254000> rotate<0,90.000000,0> translate<87.884000,-1.535000,13.716000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<72.644000,-0.000000,20.574000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<88.138000,-0.000000,20.574000>}
box{<0,0,-0.254000><15.494000,0.035000,0.254000> rotate<0,0.000000,0> translate<72.644000,-0.000000,20.574000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<88.138000,-0.000000,20.574000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<88.900000,-0.000000,20.828000>}
box{<0,0,-0.254000><0.803219,0.035000,0.254000> rotate<0,-18.433732,0> translate<88.138000,-0.000000,20.574000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<87.884000,-1.535000,13.716000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<91.440000,-1.535000,17.272000>}
box{<0,0,-0.254000><5.028943,0.035000,0.254000> rotate<0,-44.997030,0> translate<87.884000,-1.535000,13.716000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<84.836000,-0.000000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<91.440000,-0.000000,18.796000>}
box{<0,0,-0.254000><9.339466,0.035000,0.254000> rotate<0,-44.997030,0> translate<84.836000,-0.000000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<83.820000,-0.000000,29.210000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<91.440000,-0.000000,21.590000>}
box{<0,0,-0.254000><10.776307,0.035000,0.254000> rotate<0,44.997030,0> translate<83.820000,-0.000000,29.210000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<86.614000,-1.535000,26.416000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<91.440000,-1.535000,21.590000>}
box{<0,0,-0.254000><6.824995,0.035000,0.254000> rotate<0,44.997030,0> translate<86.614000,-1.535000,26.416000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<91.440000,-1.535000,17.272000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<91.440000,-1.535000,21.590000>}
box{<0,0,-0.254000><4.318000,0.035000,0.254000> rotate<0,90.000000,0> translate<91.440000,-1.535000,21.590000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<91.440000,-0.000000,18.796000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<91.440000,-0.000000,21.590000>}
box{<0,0,-0.254000><2.794000,0.035000,0.254000> rotate<0,90.000000,0> translate<91.440000,-0.000000,21.590000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<91.558600,-0.000000,25.369000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<92.202000,-0.000000,25.654000>}
box{<0,0,-0.254000><0.703696,0.035000,0.254000> rotate<0,-23.889815,0> translate<91.558600,-0.000000,25.369000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<92.202000,-0.000000,25.654000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<93.726000,-0.000000,25.654000>}
box{<0,0,-0.254000><1.524000,0.035000,0.254000> rotate<0,0.000000,0> translate<92.202000,-0.000000,25.654000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<93.726000,-0.000000,25.654000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<94.996000,-0.000000,26.924000>}
box{<0,0,-0.254000><1.796051,0.035000,0.254000> rotate<0,-44.997030,0> translate<93.726000,-0.000000,25.654000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<94.733600,-0.000000,30.093400>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<94.996000,-0.000000,29.464000>}
box{<0,0,-0.254000><0.681908,0.035000,0.254000> rotate<0,67.364055,0> translate<94.733600,-0.000000,30.093400> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<94.996000,-0.000000,26.924000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<94.996000,-0.000000,29.464000>}
box{<0,0,-0.254000><2.540000,0.035000,0.254000> rotate<0,90.000000,0> translate<94.996000,-0.000000,29.464000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<96.266000,-0.000000,35.814000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<96.266000,-0.000000,37.592000>}
box{<0,0,-0.254000><1.778000,0.035000,0.254000> rotate<0,90.000000,0> translate<96.266000,-0.000000,37.592000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<96.266000,-0.000000,37.592000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<96.410000,-0.000000,38.196000>}
box{<0,0,-0.254000><0.620928,0.035000,0.254000> rotate<0,-76.585349,0> translate<96.266000,-0.000000,37.592000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<96.410000,-0.000000,38.196000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<97.028000,-0.000000,38.608000>}
box{<0,0,-0.254000><0.742744,0.035000,0.254000> rotate<0,-33.687844,0> translate<96.410000,-0.000000,38.196000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<97.028000,-0.000000,38.608000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<97.028000,-0.000000,41.656000>}
box{<0,0,-0.254000><3.048000,0.035000,0.254000> rotate<0,90.000000,0> translate<97.028000,-0.000000,41.656000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<96.308600,-0.000000,50.460000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<97.282000,-0.000000,49.276000>}
box{<0,0,-0.254000><1.532763,0.035000,0.254000> rotate<0,50.572068,0> translate<96.308600,-0.000000,50.460000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<97.282000,-0.000000,44.450000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<97.282000,-0.000000,49.276000>}
box{<0,0,-0.254000><4.826000,0.035000,0.254000> rotate<0,90.000000,0> translate<97.282000,-0.000000,49.276000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<97.028000,-0.000000,41.656000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<97.536000,-0.000000,42.164000>}
box{<0,0,-0.254000><0.718420,0.035000,0.254000> rotate<0,-44.997030,0> translate<97.028000,-0.000000,41.656000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<97.536000,-0.000000,42.164000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<97.536000,-0.000000,43.688000>}
box{<0,0,-0.254000><1.524000,0.035000,0.254000> rotate<0,90.000000,0> translate<97.536000,-0.000000,43.688000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<97.282000,-0.000000,44.450000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<97.857800,-0.000000,44.190400>}
box{<0,0,-0.254000><0.631615,0.035000,0.254000> rotate<0,24.266678,0> translate<97.282000,-0.000000,44.450000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<97.536000,-0.000000,43.688000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<97.857800,-0.000000,44.190400>}
box{<0,0,-0.254000><0.596625,0.035000,0.254000> rotate<0,-57.355618,0> translate<97.536000,-0.000000,43.688000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<96.266000,-0.000000,35.814000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<98.552000,-0.000000,33.528000>}
box{<0,0,-0.254000><3.232892,0.035000,0.254000> rotate<0,44.997030,0> translate<96.266000,-0.000000,35.814000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<98.552000,-0.000000,25.654000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<98.552000,-0.000000,33.528000>}
box{<0,0,-0.254000><7.874000,0.035000,0.254000> rotate<0,90.000000,0> translate<98.552000,-0.000000,33.528000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.060000,-0.000000,20.828000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.060000,-0.000000,24.892000>}
box{<0,0,-0.254000><4.064000,0.035000,0.254000> rotate<0,90.000000,0> translate<99.060000,-0.000000,24.892000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<98.552000,-0.000000,25.654000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.178600,-0.000000,25.369000>}
box{<0,0,-0.254000><0.688369,0.035000,0.254000> rotate<0,24.456118,0> translate<98.552000,-0.000000,25.654000> }
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.060000,-0.000000,24.892000>}
cylinder{<0,0,0><0,0.035000,0>0.254000 translate<99.178600,-0.000000,25.369000>}
box{<0,0,-0.254000><0.491523,0.035000,0.254000> rotate<0,-76.032245,0> translate<99.060000,-0.000000,24.892000> }
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
cylinder{<97.857800,0.038000,44.190400><97.857800,-1.538000,44.190400>0.406400}
cylinder{<92.777800,0.038000,44.190400><92.777800,-1.538000,44.190400>0.406400}
cylinder{<96.410000,0.038000,38.196000><96.410000,-1.538000,38.196000>0.406400}
cylinder{<93.870000,0.038000,38.196000><93.870000,-1.538000,38.196000>0.406400}
cylinder{<99.060000,0.038000,20.828000><99.060000,-1.538000,20.828000>0.558800}
cylinder{<88.900000,0.038000,20.828000><88.900000,-1.538000,20.828000>0.558800}
cylinder{<94.733600,0.038000,30.093400><94.733600,-1.538000,30.093400>0.406400}
cylinder{<94.733600,0.038000,32.633400><94.733600,-1.538000,32.633400>0.406400}
cylinder{<91.558600,0.038000,25.369000><91.558600,-1.538000,25.369000>0.406400}
cylinder{<99.178600,0.038000,25.369000><99.178600,-1.538000,25.369000>0.406400}
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
cylinder{<96.308600,0.038000,65.700000><96.308600,-1.538000,65.700000>0.800000}
cylinder{<96.308600,0.038000,60.620000><96.308600,-1.538000,60.620000>0.800000}
cylinder{<96.308600,0.038000,55.540000><96.308600,-1.538000,55.540000>0.800000}
cylinder{<96.308600,0.038000,50.460000><96.308600,-1.538000,50.460000>0.800000}
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
//Holes(fast)/Board
texture{col_hls}
}
#if(pcb_silkscreen=on)
//Silk Screen
union{
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.631500,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.800800,0.000000,57.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<30.631500,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.800800,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.800800,0.000000,58.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<31.800800,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.800800,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.606000,0.000000,58.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<31.606000,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.606000,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.826400,0.000000,58.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<30.826400,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.826400,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.631500,0.000000,58.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<30.631500,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.631500,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.631500,0.000000,57.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<30.631500,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.800800,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.800800,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<31.800800,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.800800,0.000000,58.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.631500,0.000000,58.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<30.631500,0.000000,58.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.631500,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.631500,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<30.631500,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.826400,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.631500,0.000000,60.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<30.631500,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.631500,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.631500,0.000000,59.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<30.631500,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.631500,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.826400,0.000000,59.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<30.631500,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.826400,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.606000,0.000000,59.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<30.826400,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.606000,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.800800,0.000000,59.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<31.606000,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.800800,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.800800,0.000000,60.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<31.800800,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.800800,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.606000,0.000000,60.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<31.606000,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.606000,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.216200,0.000000,60.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<31.216200,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.216200,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.216200,0.000000,59.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<31.216200,0.000000,59.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.800800,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.800800,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<31.800800,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.800800,0.000000,60.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.631500,0.000000,60.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<30.631500,0.000000,60.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.631500,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.631500,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<30.631500,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.021300,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.631500,0.000000,63.013000>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<30.631500,0.000000,63.013000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.631500,0.000000,63.013000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.800800,0.000000,63.013000>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<30.631500,0.000000,63.013000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.800800,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.800800,0.000000,63.402800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<31.800800,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.826400,0.000000,63.792600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.631500,0.000000,63.987400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<30.631500,0.000000,63.987400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.631500,0.000000,63.987400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.631500,0.000000,64.377200>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<30.631500,0.000000,64.377200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.631500,0.000000,64.377200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.826400,0.000000,64.572100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<30.631500,0.000000,64.377200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.826400,0.000000,64.572100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.021300,0.000000,64.572100>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<30.826400,0.000000,64.572100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.021300,0.000000,64.572100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.216200,0.000000,64.377200>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<31.021300,0.000000,64.572100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.216200,0.000000,64.377200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.216200,0.000000,64.182300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<31.216200,0.000000,64.182300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.216200,0.000000,64.377200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.411100,0.000000,64.572100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<31.216200,0.000000,64.377200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.411100,0.000000,64.572100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.606000,0.000000,64.572100>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<31.411100,0.000000,64.572100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.606000,0.000000,64.572100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.800800,0.000000,64.377200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<31.606000,0.000000,64.572100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.800800,0.000000,64.377200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.800800,0.000000,63.987400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<31.800800,0.000000,63.987400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.800800,0.000000,63.987400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.606000,0.000000,63.792600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<31.606000,0.000000,63.792600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.838500,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007800,0.000000,57.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<35.838500,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007800,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007800,0.000000,58.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<37.007800,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007800,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.813000,0.000000,58.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<36.813000,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.813000,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.033400,0.000000,58.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<36.033400,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.033400,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.838500,0.000000,58.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<35.838500,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.838500,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.838500,0.000000,57.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<35.838500,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007800,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007800,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<37.007800,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007800,0.000000,58.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.838500,0.000000,58.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<35.838500,0.000000,58.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.838500,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.838500,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<35.838500,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.033400,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.838500,0.000000,60.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<35.838500,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.838500,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.838500,0.000000,59.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<35.838500,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.838500,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.033400,0.000000,59.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<35.838500,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.033400,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.813000,0.000000,59.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<36.033400,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.813000,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007800,0.000000,59.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<36.813000,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007800,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007800,0.000000,60.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<37.007800,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007800,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.813000,0.000000,60.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<36.813000,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.813000,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.423200,0.000000,60.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<36.423200,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.423200,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.423200,0.000000,59.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<36.423200,0.000000,59.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007800,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007800,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<37.007800,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007800,0.000000,60.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.838500,0.000000,60.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<35.838500,0.000000,60.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.838500,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.838500,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<35.838500,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.228300,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.838500,0.000000,63.013000>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<35.838500,0.000000,63.013000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.838500,0.000000,63.013000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007800,0.000000,63.013000>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<35.838500,0.000000,63.013000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007800,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007800,0.000000,63.402800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<37.007800,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007800,0.000000,64.572100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007800,0.000000,63.792600>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<37.007800,0.000000,63.792600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007800,0.000000,63.792600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.228300,0.000000,64.572100>}
box{<0,0,-0.050800><1.102379,0.036000,0.050800> rotate<0,44.997030,0> translate<36.228300,0.000000,64.572100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.228300,0.000000,64.572100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.033400,0.000000,64.572100>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<36.033400,0.000000,64.572100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.033400,0.000000,64.572100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.838500,0.000000,64.377200>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<35.838500,0.000000,64.377200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.838500,0.000000,64.377200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.838500,0.000000,63.987400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<35.838500,0.000000,63.987400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.838500,0.000000,63.987400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.033400,0.000000,63.792600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<35.838500,0.000000,63.987400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.588300,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.757600,0.000000,57.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<40.588300,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.757600,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.757600,0.000000,58.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<41.757600,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.757600,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.562800,0.000000,58.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<41.562800,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.562800,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.783200,0.000000,58.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<40.783200,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.783200,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.588300,0.000000,58.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<40.588300,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.588300,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.588300,0.000000,57.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<40.588300,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.757600,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.757600,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<41.757600,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.757600,0.000000,58.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.588300,0.000000,58.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<40.588300,0.000000,58.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.588300,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.588300,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<40.588300,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.783200,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.588300,0.000000,60.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<40.588300,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.588300,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.588300,0.000000,59.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<40.588300,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.588300,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.783200,0.000000,59.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<40.588300,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.783200,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.562800,0.000000,59.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<40.783200,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.562800,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.757600,0.000000,59.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<41.562800,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.757600,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.757600,0.000000,60.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<41.757600,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.757600,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.562800,0.000000,60.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<41.562800,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.562800,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.173000,0.000000,60.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<41.173000,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.173000,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.173000,0.000000,59.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<41.173000,0.000000,59.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.757600,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.757600,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<41.757600,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.757600,0.000000,60.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.588300,0.000000,60.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<40.588300,0.000000,60.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.588300,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.588300,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<40.588300,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.978100,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.588300,0.000000,63.013000>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<40.588300,0.000000,63.013000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.588300,0.000000,63.013000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.757600,0.000000,63.013000>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<40.588300,0.000000,63.013000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.757600,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.757600,0.000000,63.402800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<41.757600,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.978100,0.000000,63.792600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.588300,0.000000,64.182300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<40.588300,0.000000,64.182300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.588300,0.000000,64.182300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.757600,0.000000,64.182300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<40.588300,0.000000,64.182300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.757600,0.000000,63.792600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.757600,0.000000,64.572100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<41.757600,0.000000,64.572100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.922300,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.091600,0.000000,57.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<45.922300,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.091600,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.091600,0.000000,58.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<47.091600,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.091600,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.896800,0.000000,58.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<46.896800,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.896800,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.117200,0.000000,58.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<46.117200,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.117200,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.922300,0.000000,58.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<45.922300,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.922300,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.922300,0.000000,57.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<45.922300,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.091600,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.091600,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<47.091600,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.091600,0.000000,58.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.922300,0.000000,58.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<45.922300,0.000000,58.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.922300,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.922300,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<45.922300,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.117200,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.922300,0.000000,60.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<45.922300,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.922300,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.922300,0.000000,59.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<45.922300,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.922300,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.117200,0.000000,59.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<45.922300,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.117200,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.896800,0.000000,59.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<46.117200,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.896800,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.091600,0.000000,59.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<46.896800,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.091600,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.091600,0.000000,60.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<47.091600,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.091600,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.896800,0.000000,60.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<46.896800,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.896800,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.507000,0.000000,60.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<46.507000,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.507000,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.507000,0.000000,59.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<46.507000,0.000000,59.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.091600,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.091600,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<47.091600,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.091600,0.000000,60.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.922300,0.000000,60.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<45.922300,0.000000,60.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.922300,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.922300,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<45.922300,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.312100,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.922300,0.000000,63.013000>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<45.922300,0.000000,63.013000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.922300,0.000000,63.013000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.091600,0.000000,63.013000>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<45.922300,0.000000,63.013000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.091600,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.091600,0.000000,63.402800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<47.091600,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.896800,0.000000,63.792600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.117200,0.000000,63.792600>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<46.117200,0.000000,63.792600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.117200,0.000000,63.792600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.922300,0.000000,63.987400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<45.922300,0.000000,63.987400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.922300,0.000000,63.987400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.922300,0.000000,64.377200>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<45.922300,0.000000,64.377200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<45.922300,0.000000,64.377200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.117200,0.000000,64.572100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<45.922300,0.000000,64.377200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.117200,0.000000,64.572100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.896800,0.000000,64.572100>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<46.117200,0.000000,64.572100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.896800,0.000000,64.572100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.091600,0.000000,64.377200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<46.896800,0.000000,64.572100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.091600,0.000000,64.377200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.091600,0.000000,63.987400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<47.091600,0.000000,63.987400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.091600,0.000000,63.987400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.896800,0.000000,63.792600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<46.896800,0.000000,63.792600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.896800,0.000000,63.792600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.117200,0.000000,64.572100>}
box{<0,0,-0.050800><1.102450,0.036000,0.050800> rotate<0,44.993355,0> translate<46.117200,0.000000,64.572100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.672100,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.841400,0.000000,57.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<50.672100,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.841400,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.841400,0.000000,58.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<51.841400,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.841400,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.646600,0.000000,58.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<51.646600,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.646600,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.867000,0.000000,58.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<50.867000,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.867000,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.672100,0.000000,58.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<50.672100,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.672100,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.672100,0.000000,57.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<50.672100,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.841400,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.841400,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<51.841400,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.841400,0.000000,58.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.672100,0.000000,58.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<50.672100,0.000000,58.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.672100,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.672100,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<50.672100,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.867000,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.672100,0.000000,60.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<50.672100,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.672100,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.672100,0.000000,59.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<50.672100,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.672100,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.867000,0.000000,59.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<50.672100,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.867000,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.646600,0.000000,59.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<50.867000,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.646600,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.841400,0.000000,59.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<51.646600,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.841400,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.841400,0.000000,60.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<51.841400,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.841400,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.646600,0.000000,60.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<51.646600,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.646600,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.256800,0.000000,60.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<51.256800,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.256800,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.256800,0.000000,59.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<51.256800,0.000000,59.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.841400,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.841400,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<51.841400,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.841400,0.000000,60.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.672100,0.000000,60.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<50.672100,0.000000,60.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.672100,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.672100,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<50.672100,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.646600,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.841400,0.000000,62.818100>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<51.646600,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.841400,0.000000,62.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.841400,0.000000,63.207900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<51.841400,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.841400,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.646600,0.000000,63.402800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<51.646600,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.646600,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.867000,0.000000,63.402800>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<50.867000,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.867000,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.672100,0.000000,63.207900>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<50.672100,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.672100,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.672100,0.000000,62.818100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<50.672100,0.000000,62.818100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.672100,0.000000,62.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.867000,0.000000,62.623300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<50.672100,0.000000,62.818100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.867000,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.061900,0.000000,62.623300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<50.867000,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.061900,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.256800,0.000000,62.818100>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<51.061900,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.256800,0.000000,62.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.256800,0.000000,63.402800>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,90.000000,0> translate<51.256800,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.980700,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.150000,0.000000,57.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<55.980700,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.150000,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.150000,0.000000,58.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<57.150000,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.150000,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.955200,0.000000,58.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<56.955200,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.955200,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.175600,0.000000,58.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<56.175600,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.175600,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.980700,0.000000,58.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<55.980700,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.980700,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.980700,0.000000,57.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<55.980700,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.150000,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.150000,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<57.150000,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.150000,0.000000,58.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.980700,0.000000,58.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<55.980700,0.000000,58.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.980700,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.980700,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<55.980700,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.175600,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.980700,0.000000,60.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<55.980700,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.980700,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.980700,0.000000,59.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<55.980700,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.980700,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.175600,0.000000,59.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<55.980700,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.175600,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.955200,0.000000,59.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<56.175600,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.955200,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.150000,0.000000,59.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<56.955200,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.150000,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.150000,0.000000,60.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<57.150000,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.150000,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.955200,0.000000,60.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<56.955200,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.955200,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.565400,0.000000,60.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<56.565400,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.565400,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.565400,0.000000,59.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<56.565400,0.000000,59.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.150000,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.150000,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<57.150000,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.150000,0.000000,60.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.980700,0.000000,60.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<55.980700,0.000000,60.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.980700,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.980700,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<55.980700,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.175600,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.980700,0.000000,62.818100>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<55.980700,0.000000,62.818100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.980700,0.000000,62.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.980700,0.000000,63.207900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<55.980700,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.980700,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.175600,0.000000,63.402800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<55.980700,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.175600,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.370500,0.000000,63.402800>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<56.175600,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.370500,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.565400,0.000000,63.207900>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<56.370500,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.565400,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.760300,0.000000,63.402800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<56.565400,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.760300,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.955200,0.000000,63.402800>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<56.760300,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.955200,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.150000,0.000000,63.207900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<56.955200,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.150000,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.150000,0.000000,62.818100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<57.150000,0.000000,62.818100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.150000,0.000000,62.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.955200,0.000000,62.623300>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<56.955200,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.955200,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.760300,0.000000,62.623300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<56.760300,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.760300,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.565400,0.000000,62.818100>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<56.565400,0.000000,62.818100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.565400,0.000000,62.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.370500,0.000000,62.623300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<56.370500,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.370500,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.175600,0.000000,62.623300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<56.175600,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.565400,0.000000,62.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.565400,0.000000,63.207900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<56.565400,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,23.781100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,23.781100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<86.917900,0.000000,23.781100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,23.781100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,24.365700>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<86.917900,0.000000,24.365700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,24.365700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.112800,0.000000,24.560600>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<86.917900,0.000000,24.365700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.112800,0.000000,24.560600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.502600,0.000000,24.560600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<87.112800,0.000000,24.560600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.502600,0.000000,24.560600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.697500,0.000000,24.365700>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<87.502600,0.000000,24.560600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.697500,0.000000,24.365700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.697500,0.000000,23.781100>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<87.697500,0.000000,23.781100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.697500,0.000000,24.170800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,24.560600>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<87.697500,0.000000,24.170800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,24.950400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,25.729900>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,-33.686713,0> translate<86.917900,0.000000,24.950400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,25.729900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,24.950400>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,33.686713,0> translate<86.917900,0.000000,25.729900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,27.289000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,28.068500>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,33.686713,0> translate<86.917900,0.000000,28.068500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,29.627600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,29.627600>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<86.917900,0.000000,29.627600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,29.627600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,30.212200>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<88.087200,0.000000,30.212200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,30.212200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.892400,0.000000,30.407100>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<87.892400,0.000000,30.407100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.892400,0.000000,30.407100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.112800,0.000000,30.407100>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<87.112800,0.000000,30.407100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.112800,0.000000,30.407100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,30.212200>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<86.917900,0.000000,30.212200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,30.212200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,29.627600>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<86.917900,0.000000,29.627600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,30.796900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,31.186600>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<88.087200,0.000000,31.186600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,30.991700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,30.991700>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<86.917900,0.000000,30.991700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,30.796900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,31.186600>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<86.917900,0.000000,31.186600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.112800,0.000000,32.355900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,32.161000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<86.917900,0.000000,32.161000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,32.161000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,31.771200>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<86.917900,0.000000,31.771200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,31.771200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.112800,0.000000,31.576400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<86.917900,0.000000,31.771200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.112800,0.000000,31.576400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.892400,0.000000,31.576400>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<87.112800,0.000000,31.576400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.892400,0.000000,31.576400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,31.771200>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<87.892400,0.000000,31.576400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,31.771200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,32.161000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<88.087200,0.000000,32.161000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,32.161000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.892400,0.000000,32.355900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<87.892400,0.000000,32.355900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.892400,0.000000,32.355900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.502600,0.000000,32.355900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<87.502600,0.000000,32.355900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.502600,0.000000,32.355900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.502600,0.000000,31.966100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<87.502600,0.000000,31.966100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,32.745700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,33.135400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<88.087200,0.000000,33.135400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,32.940500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,32.940500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<86.917900,0.000000,32.940500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,32.745700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,33.135400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<86.917900,0.000000,33.135400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.892400,0.000000,34.694500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.112800,0.000000,34.694500>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<87.112800,0.000000,34.694500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.112800,0.000000,34.694500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,34.889300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<86.917900,0.000000,34.889300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,34.889300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,35.279100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<86.917900,0.000000,35.279100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.917900,0.000000,35.279100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.112800,0.000000,35.474000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<86.917900,0.000000,35.279100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.112800,0.000000,35.474000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.892400,0.000000,35.474000>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<87.112800,0.000000,35.474000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.892400,0.000000,35.474000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,35.279100>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<87.892400,0.000000,35.474000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,35.279100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,34.889300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<88.087200,0.000000,34.889300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.087200,0.000000,34.889300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.892400,0.000000,34.694500>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<87.892400,0.000000,34.694500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.892400,0.000000,34.694500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.112800,0.000000,35.474000>}
box{<0,0,-0.050800><1.102450,0.036000,0.050800> rotate<0,44.993355,0> translate<87.112800,0.000000,35.474000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,24.069200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,24.069200>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<81.787100,0.000000,24.069200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,23.679500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,24.459000>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<81.787100,0.000000,24.459000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,24.848800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,25.628300>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,-33.686713,0> translate<81.787100,0.000000,24.848800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,25.628300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,24.848800>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,33.686713,0> translate<81.787100,0.000000,25.628300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,27.187400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,27.966900>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,33.686713,0> translate<81.787100,0.000000,27.966900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,29.526000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,29.526000>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<81.787100,0.000000,29.526000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,29.526000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,30.110600>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<82.956400,0.000000,30.110600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,30.110600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.761600,0.000000,30.305500>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<82.761600,0.000000,30.305500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.761600,0.000000,30.305500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.982000,0.000000,30.305500>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<81.982000,0.000000,30.305500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.982000,0.000000,30.305500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,30.110600>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<81.787100,0.000000,30.110600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,30.110600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,29.526000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<81.787100,0.000000,29.526000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,30.695300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,31.085000>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<82.956400,0.000000,31.085000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,30.890100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,30.890100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<81.787100,0.000000,30.890100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,30.695300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,31.085000>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<81.787100,0.000000,31.085000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.982000,0.000000,32.254300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,32.059400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<81.787100,0.000000,32.059400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,32.059400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,31.669600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<81.787100,0.000000,31.669600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,31.669600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.982000,0.000000,31.474800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<81.787100,0.000000,31.669600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.982000,0.000000,31.474800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.761600,0.000000,31.474800>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<81.982000,0.000000,31.474800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.761600,0.000000,31.474800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,31.669600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<82.761600,0.000000,31.474800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,31.669600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,32.059400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<82.956400,0.000000,32.059400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,32.059400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.761600,0.000000,32.254300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<82.761600,0.000000,32.254300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.761600,0.000000,32.254300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.371800,0.000000,32.254300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<82.371800,0.000000,32.254300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.371800,0.000000,32.254300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.371800,0.000000,31.864500>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<82.371800,0.000000,31.864500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,32.644100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,33.033800>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<82.956400,0.000000,33.033800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,32.838900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,32.838900>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<81.787100,0.000000,32.838900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,32.644100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,33.033800>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<81.787100,0.000000,33.033800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.176900,0.000000,34.592900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,34.982600>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<81.787100,0.000000,34.982600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.787100,0.000000,34.982600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,34.982600>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<81.787100,0.000000,34.982600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,34.592900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.956400,0.000000,35.372400>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<82.956400,0.000000,35.372400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.075900,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245200,0.000000,57.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<81.075900,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245200,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245200,0.000000,58.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<82.245200,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245200,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.050400,0.000000,58.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<82.050400,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.050400,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.270800,0.000000,58.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<81.270800,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.270800,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.075900,0.000000,58.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<81.075900,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.075900,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.075900,0.000000,57.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<81.075900,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245200,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245200,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<82.245200,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245200,0.000000,58.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.075900,0.000000,58.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<81.075900,0.000000,58.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.075900,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.075900,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<81.075900,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.270800,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.075900,0.000000,60.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<81.075900,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.075900,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.075900,0.000000,59.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<81.075900,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.075900,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.270800,0.000000,59.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<81.075900,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.270800,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.050400,0.000000,59.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<81.270800,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.050400,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245200,0.000000,59.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<82.050400,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245200,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245200,0.000000,60.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<82.245200,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245200,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.050400,0.000000,60.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<82.050400,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.050400,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.660600,0.000000,60.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<81.660600,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.660600,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.660600,0.000000,59.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<81.660600,0.000000,59.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245200,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245200,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<82.245200,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245200,0.000000,60.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.075900,0.000000,60.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<81.075900,0.000000,60.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.075900,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.075900,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<81.075900,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.270800,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.075900,0.000000,62.818100>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<81.075900,0.000000,62.818100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.075900,0.000000,62.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.075900,0.000000,63.207900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<81.075900,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.075900,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.270800,0.000000,63.402800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<81.075900,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.270800,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.465700,0.000000,63.402800>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<81.270800,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.465700,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.660600,0.000000,63.207900>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<81.465700,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.660600,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.660600,0.000000,63.013000>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<81.660600,0.000000,63.013000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.660600,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.855500,0.000000,63.402800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<81.660600,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.855500,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.050400,0.000000,63.402800>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<81.855500,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.050400,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245200,0.000000,63.207900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<82.050400,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245200,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245200,0.000000,62.818100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<82.245200,0.000000,62.818100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245200,0.000000,62.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.050400,0.000000,62.623300>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<82.050400,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.884900,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.054200,0.000000,57.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<76.884900,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.054200,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.054200,0.000000,58.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<78.054200,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.054200,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.859400,0.000000,58.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<77.859400,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.859400,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.079800,0.000000,58.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<77.079800,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.079800,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.884900,0.000000,58.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<76.884900,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.884900,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.884900,0.000000,57.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<76.884900,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.054200,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.054200,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<78.054200,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.054200,0.000000,58.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.884900,0.000000,58.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<76.884900,0.000000,58.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.884900,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.884900,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<76.884900,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.079800,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.884900,0.000000,60.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<76.884900,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.884900,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.884900,0.000000,59.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<76.884900,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.884900,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.079800,0.000000,59.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<76.884900,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.079800,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.859400,0.000000,59.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<77.079800,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.859400,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.054200,0.000000,59.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<77.859400,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.054200,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.054200,0.000000,60.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<78.054200,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.054200,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.859400,0.000000,60.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<77.859400,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.859400,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.469600,0.000000,60.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<77.469600,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.469600,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.469600,0.000000,59.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<77.469600,0.000000,59.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.054200,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.054200,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<78.054200,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.054200,0.000000,60.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.884900,0.000000,60.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<76.884900,0.000000,60.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.884900,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.884900,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<76.884900,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.054200,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.884900,0.000000,63.207900>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<76.884900,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.884900,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.469600,0.000000,62.623300>}
box{<0,0,-0.050800><0.826820,0.036000,0.050800> rotate<0,44.992130,0> translate<76.884900,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.469600,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.469600,0.000000,63.402800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<77.469600,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.169900,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.339200,0.000000,57.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<71.169900,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.339200,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.339200,0.000000,58.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<72.339200,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.339200,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.144400,0.000000,58.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<72.144400,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.144400,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.364800,0.000000,58.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<71.364800,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.364800,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.169900,0.000000,58.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<71.169900,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.169900,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.169900,0.000000,57.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<71.169900,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.339200,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.339200,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<72.339200,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.339200,0.000000,58.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.169900,0.000000,58.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<71.169900,0.000000,58.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.169900,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.169900,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<71.169900,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.364800,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.169900,0.000000,60.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<71.169900,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.169900,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.169900,0.000000,59.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<71.169900,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.169900,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.364800,0.000000,59.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<71.169900,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.364800,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.144400,0.000000,59.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<71.364800,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.144400,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.339200,0.000000,59.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<72.144400,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.339200,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.339200,0.000000,60.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<72.339200,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.339200,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.144400,0.000000,60.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<72.144400,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.144400,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.754600,0.000000,60.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<71.754600,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.754600,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.754600,0.000000,59.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<71.754600,0.000000,59.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.339200,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.339200,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<72.339200,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.339200,0.000000,60.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.169900,0.000000,60.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<71.169900,0.000000,60.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.169900,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.169900,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<71.169900,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.169900,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.169900,0.000000,62.623300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<71.169900,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.169900,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.754600,0.000000,62.623300>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,0.000000,0> translate<71.169900,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.754600,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.559700,0.000000,63.013000>}
box{<0,0,-0.050800><0.435720,0.036000,0.050800> rotate<0,63.424882,0> translate<71.559700,0.000000,63.013000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.559700,0.000000,63.013000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.559700,0.000000,63.207900>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,90.000000,0> translate<71.559700,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.559700,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.754600,0.000000,63.402800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<71.559700,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.754600,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.144400,0.000000,63.402800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<71.754600,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.144400,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.339200,0.000000,63.207900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<72.144400,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.339200,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.339200,0.000000,62.818100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<72.339200,0.000000,62.818100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.339200,0.000000,62.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.144400,0.000000,62.623300>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<72.144400,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.810500,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.979800,0.000000,57.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<65.810500,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.979800,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.979800,0.000000,58.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<66.979800,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.979800,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.785000,0.000000,58.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<66.785000,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.785000,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.005400,0.000000,58.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<66.005400,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.005400,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.810500,0.000000,58.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<65.810500,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.810500,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.810500,0.000000,57.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<65.810500,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.979800,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.979800,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<66.979800,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.979800,0.000000,58.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.810500,0.000000,58.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<65.810500,0.000000,58.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.810500,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.810500,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<65.810500,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.005400,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.810500,0.000000,60.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<65.810500,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.810500,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.810500,0.000000,59.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<65.810500,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.810500,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.005400,0.000000,59.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<65.810500,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.005400,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.785000,0.000000,59.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<66.005400,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.785000,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.979800,0.000000,59.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<66.785000,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.979800,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.979800,0.000000,60.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<66.979800,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.979800,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.785000,0.000000,60.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<66.785000,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.785000,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.395200,0.000000,60.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<66.395200,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.395200,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.395200,0.000000,59.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<66.395200,0.000000,59.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.979800,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.979800,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<66.979800,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.979800,0.000000,60.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.810500,0.000000,60.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<65.810500,0.000000,60.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.810500,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.810500,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<65.810500,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.810500,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.005400,0.000000,63.013000>}
box{<0,0,-0.050800><0.435810,0.036000,0.050800> rotate<0,63.430762,0> translate<65.810500,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.005400,0.000000,63.013000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.395200,0.000000,62.623300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<66.005400,0.000000,63.013000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.395200,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.785000,0.000000,62.623300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<66.395200,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.785000,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.979800,0.000000,62.818100>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<66.785000,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.979800,0.000000,62.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.979800,0.000000,63.207900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<66.979800,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.979800,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.785000,0.000000,63.402800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<66.785000,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.785000,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.590100,0.000000,63.402800>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<66.590100,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.590100,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.395200,0.000000,63.207900>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<66.395200,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.395200,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.395200,0.000000,62.623300>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<66.395200,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.416300,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.585600,0.000000,57.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<61.416300,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.585600,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.585600,0.000000,58.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<62.585600,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.585600,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.390800,0.000000,58.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<62.390800,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.390800,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.611200,0.000000,58.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<61.611200,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.611200,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.416300,0.000000,58.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<61.416300,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.416300,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.416300,0.000000,57.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<61.416300,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.585600,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.585600,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<62.585600,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.585600,0.000000,58.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.416300,0.000000,58.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<61.416300,0.000000,58.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.416300,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.416300,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<61.416300,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.611200,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.416300,0.000000,60.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<61.416300,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.416300,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.416300,0.000000,59.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<61.416300,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.416300,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.611200,0.000000,59.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<61.416300,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.611200,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.390800,0.000000,59.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<61.611200,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.390800,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.585600,0.000000,59.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<62.390800,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.585600,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.585600,0.000000,60.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<62.585600,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.585600,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.390800,0.000000,60.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<62.390800,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.390800,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.001000,0.000000,60.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<62.001000,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.001000,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.001000,0.000000,59.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<62.001000,0.000000,59.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.585600,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.585600,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<62.585600,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.585600,0.000000,60.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.416300,0.000000,60.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<61.416300,0.000000,60.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.416300,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.416300,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<61.416300,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.416300,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.416300,0.000000,63.402800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<61.416300,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.416300,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.611200,0.000000,63.402800>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<61.416300,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.611200,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.390800,0.000000,62.623300>}
box{<0,0,-0.050800><1.102450,0.036000,0.050800> rotate<0,44.993355,0> translate<61.611200,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.390800,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.585600,0.000000,62.623300>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<62.390800,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.568900,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.568900,0.000000,53.904100>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<30.568900,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.568900,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.238300,0.000000,54.573600>}
box{<0,0,-0.088900><0.946745,0.036000,0.088900> rotate<0,-45.001309,0> translate<30.568900,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.238300,0.000000,54.573600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.907700,0.000000,53.904100>}
box{<0,0,-0.088900><0.946745,0.036000,0.088900> rotate<0,45.001309,0> translate<31.238300,0.000000,54.573600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.907700,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.907700,0.000000,52.565300>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<31.907700,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.568900,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.907700,0.000000,53.569400>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<30.568900,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.580200,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.580200,0.000000,53.904100>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<32.580200,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.580200,0.000000,53.234700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.249600,0.000000,53.904100>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<32.580200,0.000000,53.234700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.249600,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.584300,0.000000,53.904100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<33.249600,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.595100,0.000000,54.573600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.595100,0.000000,52.565300>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,-90.000000,0> translate<35.595100,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.595100,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.591000,0.000000,52.565300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<34.591000,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.591000,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.256300,0.000000,52.900000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<34.256300,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.256300,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.256300,0.000000,53.569400>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<34.256300,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.256300,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.591000,0.000000,53.904100>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<34.256300,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.591000,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.595100,0.000000,53.904100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<34.591000,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.267600,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.267600,0.000000,52.900000>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<36.267600,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.267600,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.602300,0.000000,52.565300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<36.267600,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.602300,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.606400,0.000000,52.565300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<36.602300,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.606400,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.606400,0.000000,53.904100>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<37.606400,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.278900,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.613600,0.000000,53.904100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<38.278900,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.613600,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.613600,0.000000,52.565300>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<38.613600,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.278900,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.948300,0.000000,52.565300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<38.278900,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.613600,0.000000,54.908300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.613600,0.000000,54.573600>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<38.613600,0.000000,54.573600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.619800,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.619800,0.000000,53.904100>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<39.619800,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.619800,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.623900,0.000000,53.904100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<39.619800,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.623900,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.958600,0.000000,53.569400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<40.623900,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.958600,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.958600,0.000000,52.565300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<40.958600,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.965800,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.635200,0.000000,52.565300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<41.965800,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.635200,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.969900,0.000000,52.900000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<42.635200,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.969900,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.969900,0.000000,53.569400>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<42.969900,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.969900,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.635200,0.000000,53.904100>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<42.635200,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.635200,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.965800,0.000000,53.904100>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<41.965800,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.965800,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.631100,0.000000,53.569400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<41.631100,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.631100,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.631100,0.000000,52.900000>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<41.631100,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.631100,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.965800,0.000000,52.565300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<41.631100,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.653700,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.653700,0.000000,54.573600>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,90.000000,0> translate<45.653700,0.000000,54.573600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.653700,0.000000,54.573600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.657800,0.000000,54.573600>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<45.653700,0.000000,54.573600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.657800,0.000000,54.573600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.992500,0.000000,54.238800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<46.657800,0.000000,54.573600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.992500,0.000000,54.238800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.992500,0.000000,53.904100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<46.992500,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.992500,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.657800,0.000000,53.569400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<46.657800,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.657800,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.992500,0.000000,53.234700>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<46.657800,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.992500,0.000000,53.234700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.992500,0.000000,52.900000>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<46.992500,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.992500,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.657800,0.000000,52.565300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<46.657800,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.657800,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.653700,0.000000,52.565300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<45.653700,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.653700,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.657800,0.000000,53.569400>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<45.653700,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.665000,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.665000,0.000000,53.904100>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<47.665000,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.665000,0.000000,53.234700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.334400,0.000000,53.904100>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<47.665000,0.000000,53.234700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.334400,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.669100,0.000000,53.904100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<48.334400,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.345200,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.675800,0.000000,52.565300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<49.675800,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.675800,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.341100,0.000000,52.900000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<49.341100,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.341100,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.341100,0.000000,53.569400>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<49.341100,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.341100,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.675800,0.000000,53.904100>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<49.341100,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.675800,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.345200,0.000000,53.904100>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<49.675800,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.345200,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.679900,0.000000,53.569400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<50.345200,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.679900,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.679900,0.000000,53.234700>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<50.679900,0.000000,53.234700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.679900,0.000000,53.234700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.341100,0.000000,53.234700>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<49.341100,0.000000,53.234700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.687100,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.356500,0.000000,53.904100>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<51.687100,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.356500,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.691200,0.000000,53.569400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<52.356500,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.691200,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.691200,0.000000,52.565300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<52.691200,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.691200,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.687100,0.000000,52.565300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<51.687100,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.687100,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.352400,0.000000,52.900000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<51.352400,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.352400,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.687100,0.000000,53.234700>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<51.352400,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.687100,0.000000,53.234700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.691200,0.000000,53.234700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<51.687100,0.000000,53.234700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.363700,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.363700,0.000000,54.573600>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,90.000000,0> translate<53.363700,0.000000,54.573600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.367800,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.363700,0.000000,53.234700>}
box{<0,0,-0.088900><1.206778,0.036000,0.088900> rotate<0,33.687844,0> translate<53.363700,0.000000,53.234700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.363700,0.000000,53.234700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.367800,0.000000,53.904100>}
box{<0,0,-0.088900><1.206778,0.036000,0.088900> rotate<0,-33.687844,0> translate<53.363700,0.000000,53.234700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.374500,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.043900,0.000000,52.565300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<55.374500,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.043900,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.378600,0.000000,52.900000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<56.043900,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.378600,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.378600,0.000000,53.569400>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<56.378600,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.378600,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.043900,0.000000,53.904100>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<56.043900,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.043900,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.374500,0.000000,53.904100>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<55.374500,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.374500,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.039800,0.000000,53.569400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<55.039800,0.000000,53.569400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.039800,0.000000,53.569400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.039800,0.000000,52.900000>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<55.039800,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.039800,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.374500,0.000000,52.565300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<55.039800,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.051100,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.051100,0.000000,52.900000>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<57.051100,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.051100,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.385800,0.000000,52.565300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<57.051100,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.385800,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.389900,0.000000,52.565300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<57.385800,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.389900,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.389900,0.000000,53.904100>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<58.389900,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.397100,0.000000,54.238800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.397100,0.000000,52.900000>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<59.397100,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.397100,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.731800,0.000000,52.565300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<59.397100,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.062400,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.731800,0.000000,53.904100>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<59.062400,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.414600,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.084000,0.000000,52.565300>}
box{<0,0,-0.088900><1.496824,0.036000,0.088900> rotate<0,63.430762,0> translate<62.414600,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.084000,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.753400,0.000000,53.904100>}
box{<0,0,-0.088900><1.496824,0.036000,0.088900> rotate<0,-63.430762,0> translate<63.084000,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.425900,0.000000,53.904100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.095300,0.000000,54.573600>}
box{<0,0,-0.088900><0.946745,0.036000,0.088900> rotate<0,-45.001309,0> translate<64.425900,0.000000,53.904100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.095300,0.000000,54.573600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.095300,0.000000,52.565300>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,-90.000000,0> translate<65.095300,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.425900,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.764700,0.000000,52.565300>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<64.425900,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.437200,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.437200,0.000000,52.900000>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<66.437200,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.437200,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.771900,0.000000,52.900000>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<66.437200,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.771900,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.771900,0.000000,52.565300>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<66.771900,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.771900,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.437200,0.000000,52.565300>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<66.437200,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<67.442800,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<67.442800,0.000000,54.238800>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<67.442800,0.000000,54.238800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<67.442800,0.000000,54.238800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<67.777500,0.000000,54.573600>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,-45.005588,0> translate<67.442800,0.000000,54.238800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<67.777500,0.000000,54.573600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<68.446900,0.000000,54.573600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<67.777500,0.000000,54.573600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<68.446900,0.000000,54.573600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<68.781600,0.000000,54.238800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<68.446900,0.000000,54.573600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<68.781600,0.000000,54.238800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<68.781600,0.000000,52.900000>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<68.781600,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<68.781600,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<68.446900,0.000000,52.565300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<68.446900,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<68.446900,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<67.777500,0.000000,52.565300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<67.777500,0.000000,52.565300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<67.777500,0.000000,52.565300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<67.442800,0.000000,52.900000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<67.442800,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<67.442800,0.000000,52.900000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<68.781600,0.000000,54.238800>}
box{<0,0,-0.088900><1.893349,0.036000,0.088900> rotate<0,-44.997030,0> translate<67.442800,0.000000,52.900000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.670500,0.000000,44.616800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.670500,0.000000,42.608500>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,-90.000000,0> translate<30.670500,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.670500,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.009300,0.000000,42.608500>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<30.670500,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.681800,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.016500,0.000000,43.947300>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<32.681800,0.000000,43.947300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.016500,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.016500,0.000000,42.608500>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<33.016500,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.681800,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.351200,0.000000,42.608500>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<32.681800,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.016500,0.000000,44.951500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.016500,0.000000,44.616800>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<33.016500,0.000000,44.616800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.361500,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.357400,0.000000,43.947300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<34.357400,0.000000,43.947300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.357400,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.022700,0.000000,43.612600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<34.022700,0.000000,43.612600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.022700,0.000000,43.612600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.022700,0.000000,42.943200>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<34.022700,0.000000,42.943200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.022700,0.000000,42.943200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.357400,0.000000,42.608500>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<34.022700,0.000000,42.943200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.357400,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.361500,0.000000,42.608500>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<34.357400,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.038100,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.368700,0.000000,42.608500>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<36.368700,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.368700,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.034000,0.000000,42.943200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<36.034000,0.000000,42.943200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.034000,0.000000,42.943200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.034000,0.000000,43.612600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<36.034000,0.000000,43.612600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.034000,0.000000,43.612600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.368700,0.000000,43.947300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<36.034000,0.000000,43.612600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.368700,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.038100,0.000000,43.947300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<36.368700,0.000000,43.947300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.038100,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.372800,0.000000,43.612600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<37.038100,0.000000,43.947300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.372800,0.000000,43.612600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.372800,0.000000,43.277900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<37.372800,0.000000,43.277900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.372800,0.000000,43.277900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.034000,0.000000,43.277900>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<36.034000,0.000000,43.277900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.045300,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.045300,0.000000,43.947300>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<38.045300,0.000000,43.947300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.045300,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.049400,0.000000,43.947300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<38.045300,0.000000,43.947300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.049400,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.384100,0.000000,43.612600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<39.049400,0.000000,43.947300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.384100,0.000000,43.612600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.384100,0.000000,42.608500>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<39.384100,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.056600,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.060700,0.000000,42.608500>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<40.056600,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.060700,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.395400,0.000000,42.943200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<41.060700,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.395400,0.000000,42.943200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.060700,0.000000,43.277900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<41.060700,0.000000,43.277900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.060700,0.000000,43.277900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.391300,0.000000,43.277900>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<40.391300,0.000000,43.277900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.391300,0.000000,43.277900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.056600,0.000000,43.612600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<40.056600,0.000000,43.612600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.056600,0.000000,43.612600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.391300,0.000000,43.947300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<40.056600,0.000000,43.612600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.391300,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.395400,0.000000,43.947300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<40.391300,0.000000,43.947300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.072000,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.402600,0.000000,42.608500>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<42.402600,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.402600,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.067900,0.000000,42.943200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<42.067900,0.000000,42.943200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.067900,0.000000,42.943200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.067900,0.000000,43.612600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<42.067900,0.000000,43.612600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.067900,0.000000,43.612600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.402600,0.000000,43.947300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<42.067900,0.000000,43.612600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.402600,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.072000,0.000000,43.947300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<42.402600,0.000000,43.947300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.072000,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.406700,0.000000,43.612600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<43.072000,0.000000,43.947300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.406700,0.000000,43.612600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.406700,0.000000,43.277900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<43.406700,0.000000,43.277900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.406700,0.000000,43.277900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.067900,0.000000,43.277900>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<42.067900,0.000000,43.277900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.429300,0.000000,44.282000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.094600,0.000000,44.616800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<47.094600,0.000000,44.616800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.094600,0.000000,44.616800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.425200,0.000000,44.616800>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<46.425200,0.000000,44.616800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.425200,0.000000,44.616800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.090500,0.000000,44.282000>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,-45.005588,0> translate<46.090500,0.000000,44.282000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.090500,0.000000,44.282000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.090500,0.000000,42.943200>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<46.090500,0.000000,42.943200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.090500,0.000000,42.943200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.425200,0.000000,42.608500>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<46.090500,0.000000,42.943200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.425200,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.094600,0.000000,42.608500>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<46.425200,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.094600,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.429300,0.000000,42.943200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<47.094600,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.429300,0.000000,42.943200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.429300,0.000000,43.612600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<47.429300,0.000000,43.612600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.429300,0.000000,43.612600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.759900,0.000000,43.612600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<46.759900,0.000000,43.612600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.101800,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.101800,0.000000,44.616800>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,90.000000,0> translate<48.101800,0.000000,44.616800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.101800,0.000000,44.616800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.105900,0.000000,44.616800>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<48.101800,0.000000,44.616800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.105900,0.000000,44.616800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.440600,0.000000,44.282000>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<49.105900,0.000000,44.616800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.440600,0.000000,44.282000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.440600,0.000000,43.612600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<49.440600,0.000000,43.612600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.440600,0.000000,43.612600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.105900,0.000000,43.277900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<49.105900,0.000000,43.277900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.105900,0.000000,43.277900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.101800,0.000000,43.277900>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<48.101800,0.000000,43.277900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.113100,0.000000,44.616800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.113100,0.000000,42.608500>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,-90.000000,0> translate<50.113100,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.113100,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.451900,0.000000,42.608500>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<50.113100,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.135700,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.805100,0.000000,42.608500>}
box{<0,0,-0.088900><1.496824,0.036000,0.088900> rotate<0,63.430762,0> translate<54.135700,0.000000,43.947300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.805100,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.474500,0.000000,43.947300>}
box{<0,0,-0.088900><1.496824,0.036000,0.088900> rotate<0,-63.430762,0> translate<54.805100,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.485800,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.147000,0.000000,42.608500>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<56.147000,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.147000,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.485800,0.000000,43.947300>}
box{<0,0,-0.088900><1.893349,0.036000,0.088900> rotate<0,-44.997030,0> translate<56.147000,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.485800,0.000000,43.947300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.485800,0.000000,44.282000>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<57.485800,0.000000,44.282000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.485800,0.000000,44.282000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.151100,0.000000,44.616800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<57.151100,0.000000,44.616800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.151100,0.000000,44.616800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.481700,0.000000,44.616800>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<56.481700,0.000000,44.616800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.481700,0.000000,44.616800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.147000,0.000000,44.282000>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,-45.005588,0> translate<56.147000,0.000000,44.282000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.158300,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.158300,0.000000,42.943200>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<58.158300,0.000000,42.943200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.158300,0.000000,42.943200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.493000,0.000000,42.943200>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<58.158300,0.000000,42.943200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.493000,0.000000,42.943200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.493000,0.000000,42.608500>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<58.493000,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.493000,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.158300,0.000000,42.608500>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<58.158300,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.163900,0.000000,42.943200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.163900,0.000000,44.282000>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<59.163900,0.000000,44.282000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.163900,0.000000,44.282000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.498600,0.000000,44.616800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,-45.005588,0> translate<59.163900,0.000000,44.282000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.498600,0.000000,44.616800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.168000,0.000000,44.616800>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<59.498600,0.000000,44.616800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.168000,0.000000,44.616800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.502700,0.000000,44.282000>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<60.168000,0.000000,44.616800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.502700,0.000000,44.282000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.502700,0.000000,42.943200>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<60.502700,0.000000,42.943200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.502700,0.000000,42.943200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.168000,0.000000,42.608500>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<60.168000,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.168000,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.498600,0.000000,42.608500>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<59.498600,0.000000,42.608500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.498600,0.000000,42.608500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.163900,0.000000,42.943200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<59.163900,0.000000,42.943200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.163900,0.000000,42.943200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.502700,0.000000,44.282000>}
box{<0,0,-0.088900><1.893349,0.036000,0.088900> rotate<0,-44.997030,0> translate<59.163900,0.000000,42.943200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.568900,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.568900,0.000000,51.160900>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<30.568900,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.568900,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.903600,0.000000,51.160900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<30.568900,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.903600,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.238300,0.000000,50.826200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<30.903600,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.238300,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.238300,0.000000,49.822100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<31.238300,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.238300,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.573000,0.000000,51.160900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<31.238300,0.000000,50.826200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.573000,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.907700,0.000000,50.826200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<31.573000,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.907700,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.907700,0.000000,49.822100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<31.907700,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.914900,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.584300,0.000000,51.160900>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<32.914900,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.584300,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.919000,0.000000,50.826200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<33.584300,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.919000,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.919000,0.000000,49.822100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<33.919000,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.919000,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.914900,0.000000,49.822100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<32.914900,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.914900,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.580200,0.000000,50.156800>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<32.580200,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.580200,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.914900,0.000000,50.491500>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<32.580200,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.914900,0.000000,50.491500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.919000,0.000000,50.491500>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<32.914900,0.000000,50.491500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.591500,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.591500,0.000000,51.830400>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,90.000000,0> translate<34.591500,0.000000,51.830400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.595600,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.591500,0.000000,50.491500>}
box{<0,0,-0.088900><1.206778,0.036000,0.088900> rotate<0,33.687844,0> translate<34.591500,0.000000,50.491500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.591500,0.000000,50.491500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.595600,0.000000,51.160900>}
box{<0,0,-0.088900><1.206778,0.036000,0.088900> rotate<0,-33.687844,0> translate<34.591500,0.000000,50.491500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.271700,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.602300,0.000000,49.822100>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<36.602300,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.602300,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.267600,0.000000,50.156800>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<36.267600,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.267600,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.267600,0.000000,50.826200>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<36.267600,0.000000,50.826200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.267600,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.602300,0.000000,51.160900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<36.267600,0.000000,50.826200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.602300,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.271700,0.000000,51.160900>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<36.602300,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.271700,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.606400,0.000000,50.826200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<37.271700,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.606400,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.606400,0.000000,50.491500>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<37.606400,0.000000,50.491500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.606400,0.000000,50.491500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.267600,0.000000,50.491500>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<36.267600,0.000000,50.491500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.278900,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.278900,0.000000,50.156800>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<38.278900,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.278900,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.613600,0.000000,50.156800>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<38.278900,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.613600,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.613600,0.000000,49.822100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<38.613600,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.613600,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.278900,0.000000,49.822100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<38.278900,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.284500,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.284500,0.000000,51.160900>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<39.284500,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.284500,0.000000,50.491500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.953900,0.000000,51.160900>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<39.284500,0.000000,50.491500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.953900,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.288600,0.000000,51.160900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<39.953900,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.960600,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.960600,0.000000,51.160900>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<40.960600,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.960600,0.000000,50.491500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.630000,0.000000,51.160900>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<40.960600,0.000000,50.491500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.630000,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.964700,0.000000,51.160900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<41.630000,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.636700,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.636700,0.000000,51.160900>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<42.636700,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.636700,0.000000,50.491500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.306100,0.000000,51.160900>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<42.636700,0.000000,50.491500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.306100,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.640800,0.000000,51.160900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<43.306100,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.647500,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.647500,0.000000,51.495600>}
box{<0,0,-0.088900><1.673500,0.036000,0.088900> rotate<0,90.000000,0> translate<44.647500,0.000000,51.495600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.647500,0.000000,51.495600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.982200,0.000000,51.830400>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,-45.005588,0> translate<44.647500,0.000000,51.495600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.312800,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.982200,0.000000,50.826200>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<44.312800,0.000000,50.826200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.653700,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.653700,0.000000,50.156800>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<45.653700,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.653700,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.988400,0.000000,50.156800>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<45.653700,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.988400,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.988400,0.000000,49.822100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<45.988400,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.988400,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.653700,0.000000,49.822100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<45.653700,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.994000,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.663400,0.000000,49.822100>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<46.994000,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.663400,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.998100,0.000000,50.156800>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<47.663400,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.998100,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.998100,0.000000,50.826200>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<47.998100,0.000000,50.826200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.998100,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.663400,0.000000,51.160900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<47.663400,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<47.663400,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.994000,0.000000,51.160900>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<46.994000,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.994000,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.659300,0.000000,50.826200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<46.659300,0.000000,50.826200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.659300,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.659300,0.000000,50.156800>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<46.659300,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.659300,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.994000,0.000000,49.822100>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<46.659300,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.670600,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.670600,0.000000,51.160900>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<48.670600,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<48.670600,0.000000,50.491500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.340000,0.000000,51.160900>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<48.670600,0.000000,50.491500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.340000,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.674700,0.000000,51.160900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<49.340000,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.016100,0.000000,49.152700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.350800,0.000000,49.152700>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<51.016100,0.000000,49.152700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.350800,0.000000,49.152700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.685500,0.000000,49.487400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<51.350800,0.000000,49.152700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.685500,0.000000,49.487400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.685500,0.000000,51.160900>}
box{<0,0,-0.088900><1.673500,0.036000,0.088900> rotate<0,90.000000,0> translate<51.685500,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.685500,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.681400,0.000000,51.160900>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<50.681400,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.681400,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.346700,0.000000,50.826200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<50.346700,0.000000,50.826200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.346700,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.346700,0.000000,50.156800>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<50.346700,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.346700,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.681400,0.000000,49.822100>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<50.346700,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.681400,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.685500,0.000000,49.822100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<50.681400,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.358000,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.696800,0.000000,51.830400>}
box{<0,0,-0.088900><2.413639,0.036000,0.088900> rotate<0,-56.307533,0> translate<52.358000,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.704000,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.373400,0.000000,51.160900>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<54.704000,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.373400,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.708100,0.000000,50.826200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<55.373400,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.708100,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.708100,0.000000,49.822100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<55.708100,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.708100,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.704000,0.000000,49.822100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<54.704000,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.704000,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.369300,0.000000,50.156800>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<54.369300,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.369300,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.704000,0.000000,50.491500>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<54.369300,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.704000,0.000000,50.491500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.708100,0.000000,50.491500>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<54.704000,0.000000,50.491500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.380600,0.000000,51.830400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.380600,0.000000,49.822100>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,-90.000000,0> translate<56.380600,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.380600,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.384700,0.000000,49.822100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<56.380600,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.384700,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.719400,0.000000,50.156800>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<57.384700,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.719400,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.719400,0.000000,50.826200>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<57.719400,0.000000,50.826200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.719400,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.384700,0.000000,51.160900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<57.384700,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<57.384700,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.380600,0.000000,51.160900>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<56.380600,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<58.391900,0.000000,50.826200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.730700,0.000000,50.826200>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<58.391900,0.000000,50.826200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.403200,0.000000,51.160900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.072600,0.000000,51.830400>}
box{<0,0,-0.088900><0.946745,0.036000,0.088900> rotate<0,-45.001309,0> translate<60.403200,0.000000,51.160900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.072600,0.000000,51.830400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.072600,0.000000,49.822100>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,-90.000000,0> translate<61.072600,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.403200,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.742000,0.000000,49.822100>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<60.403200,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.414500,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.414500,0.000000,50.156800>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<62.414500,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.414500,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.749200,0.000000,50.156800>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<62.414500,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.749200,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.749200,0.000000,49.822100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<62.749200,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.749200,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.414500,0.000000,49.822100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<62.414500,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.420100,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.420100,0.000000,51.495600>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<63.420100,0.000000,51.495600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.420100,0.000000,51.495600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.754800,0.000000,51.830400>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,-45.005588,0> translate<63.420100,0.000000,51.495600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.754800,0.000000,51.830400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.424200,0.000000,51.830400>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<63.754800,0.000000,51.830400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.424200,0.000000,51.830400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.758900,0.000000,51.495600>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<64.424200,0.000000,51.830400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.758900,0.000000,51.495600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.758900,0.000000,50.156800>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<64.758900,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.758900,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.424200,0.000000,49.822100>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<64.424200,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.424200,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.754800,0.000000,49.822100>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<63.754800,0.000000,49.822100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.754800,0.000000,49.822100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.420100,0.000000,50.156800>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<63.420100,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.420100,0.000000,50.156800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.758900,0.000000,51.495600>}
box{<0,0,-0.088900><1.893349,0.036000,0.088900> rotate<0,-44.997030,0> translate<63.420100,0.000000,50.156800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.933100,0.000000,47.380800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.598400,0.000000,47.715600>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<31.598400,0.000000,47.715600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.598400,0.000000,47.715600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.929000,0.000000,47.715600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<30.929000,0.000000,47.715600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.929000,0.000000,47.715600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.594300,0.000000,47.380800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,-45.005588,0> translate<30.594300,0.000000,47.380800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.594300,0.000000,47.380800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.594300,0.000000,46.042000>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<30.594300,0.000000,46.042000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.594300,0.000000,46.042000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.929000,0.000000,45.707300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<30.594300,0.000000,46.042000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.929000,0.000000,45.707300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.598400,0.000000,45.707300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<30.929000,0.000000,45.707300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.598400,0.000000,45.707300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.933100,0.000000,46.042000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<31.598400,0.000000,45.707300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.940300,0.000000,45.707300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.609700,0.000000,45.707300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<32.940300,0.000000,45.707300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.609700,0.000000,45.707300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.944400,0.000000,46.042000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<33.609700,0.000000,45.707300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.944400,0.000000,46.042000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.944400,0.000000,46.711400>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<33.944400,0.000000,46.711400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.944400,0.000000,46.711400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.609700,0.000000,47.046100>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<33.609700,0.000000,47.046100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<33.609700,0.000000,47.046100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.940300,0.000000,47.046100>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<32.940300,0.000000,47.046100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.940300,0.000000,47.046100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.605600,0.000000,46.711400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<32.605600,0.000000,46.711400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.605600,0.000000,46.711400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.605600,0.000000,46.042000>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<32.605600,0.000000,46.042000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.605600,0.000000,46.042000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<32.940300,0.000000,45.707300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<32.605600,0.000000,46.042000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.616900,0.000000,45.037900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.616900,0.000000,47.046100>}
box{<0,0,-0.088900><2.008200,0.036000,0.088900> rotate<0,90.000000,0> translate<34.616900,0.000000,47.046100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.616900,0.000000,47.046100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.621000,0.000000,47.046100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<34.616900,0.000000,47.046100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.621000,0.000000,47.046100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.955700,0.000000,46.711400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<35.621000,0.000000,47.046100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.955700,0.000000,46.711400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.955700,0.000000,46.042000>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<35.955700,0.000000,46.042000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.955700,0.000000,46.042000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.621000,0.000000,45.707300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<35.621000,0.000000,45.707300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<35.621000,0.000000,45.707300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<34.616900,0.000000,45.707300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<34.616900,0.000000,45.707300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.628200,0.000000,47.046100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.628200,0.000000,46.042000>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<36.628200,0.000000,46.042000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.628200,0.000000,46.042000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.962900,0.000000,45.707300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<36.628200,0.000000,46.042000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<36.962900,0.000000,45.707300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.967000,0.000000,45.707300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<36.962900,0.000000,45.707300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.967000,0.000000,47.046100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.967000,0.000000,45.372600>}
box{<0,0,-0.088900><1.673500,0.036000,0.088900> rotate<0,-90.000000,0> translate<37.967000,0.000000,45.372600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.967000,0.000000,45.372600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.632300,0.000000,45.037900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<37.632300,0.000000,45.037900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.632300,0.000000,45.037900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<37.297600,0.000000,45.037900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<37.297600,0.000000,45.037900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.639500,0.000000,45.707300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.639500,0.000000,47.046100>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<38.639500,0.000000,47.046100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<38.639500,0.000000,46.376700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.308900,0.000000,47.046100>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<38.639500,0.000000,46.376700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.308900,0.000000,47.046100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<39.643600,0.000000,47.046100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<39.308900,0.000000,47.046100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.315600,0.000000,47.046100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.650300,0.000000,47.046100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<40.315600,0.000000,47.046100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.650300,0.000000,47.046100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.650300,0.000000,45.707300>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<40.650300,0.000000,45.707300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.315600,0.000000,45.707300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.985000,0.000000,45.707300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<40.315600,0.000000,45.707300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.650300,0.000000,48.050300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<40.650300,0.000000,47.715600>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<40.650300,0.000000,47.715600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.325900,0.000000,45.037900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.660600,0.000000,45.037900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<42.325900,0.000000,45.037900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.660600,0.000000,45.037900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.995300,0.000000,45.372600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<42.660600,0.000000,45.037900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.995300,0.000000,45.372600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.995300,0.000000,47.046100>}
box{<0,0,-0.088900><1.673500,0.036000,0.088900> rotate<0,90.000000,0> translate<42.995300,0.000000,47.046100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.995300,0.000000,47.046100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.991200,0.000000,47.046100>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<41.991200,0.000000,47.046100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.991200,0.000000,47.046100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.656500,0.000000,46.711400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<41.656500,0.000000,46.711400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.656500,0.000000,46.711400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.656500,0.000000,46.042000>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<41.656500,0.000000,46.042000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.656500,0.000000,46.042000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.991200,0.000000,45.707300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<41.656500,0.000000,46.042000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<41.991200,0.000000,45.707300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<42.995300,0.000000,45.707300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<41.991200,0.000000,45.707300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.667800,0.000000,47.715600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.667800,0.000000,45.707300>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,-90.000000,0> translate<43.667800,0.000000,45.707300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<43.667800,0.000000,46.711400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.002500,0.000000,47.046100>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<43.667800,0.000000,46.711400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.002500,0.000000,47.046100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.671900,0.000000,47.046100>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<44.002500,0.000000,47.046100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<44.671900,0.000000,47.046100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.006600,0.000000,46.711400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<44.671900,0.000000,47.046100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.006600,0.000000,46.711400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.006600,0.000000,45.707300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<45.006600,0.000000,45.707300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.013800,0.000000,47.380800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.013800,0.000000,46.042000>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<46.013800,0.000000,46.042000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.013800,0.000000,46.042000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.348500,0.000000,45.707300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<46.013800,0.000000,46.042000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<45.679100,0.000000,47.046100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<46.348500,0.000000,47.046100>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<45.679100,0.000000,47.046100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.031300,0.000000,45.707300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.031300,0.000000,47.715600>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,90.000000,0> translate<49.031300,0.000000,47.715600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.031300,0.000000,47.715600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.035400,0.000000,47.715600>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<49.031300,0.000000,47.715600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.035400,0.000000,47.715600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.370100,0.000000,47.380800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<50.035400,0.000000,47.715600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.370100,0.000000,47.380800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.370100,0.000000,46.711400>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<50.370100,0.000000,46.711400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.370100,0.000000,46.711400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.035400,0.000000,46.376700>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<50.035400,0.000000,46.376700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.035400,0.000000,46.376700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.031300,0.000000,46.376700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<49.031300,0.000000,46.376700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<49.700700,0.000000,46.376700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<50.370100,0.000000,45.707300>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,44.997030,0> translate<49.700700,0.000000,46.376700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.042600,0.000000,45.707300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.042600,0.000000,47.715600>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,90.000000,0> translate<51.042600,0.000000,47.715600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.042600,0.000000,47.715600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.046700,0.000000,47.715600>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<51.042600,0.000000,47.715600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.046700,0.000000,47.715600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.381400,0.000000,47.380800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<52.046700,0.000000,47.715600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.381400,0.000000,47.380800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.381400,0.000000,46.711400>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<52.381400,0.000000,46.711400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.381400,0.000000,46.711400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.046700,0.000000,46.376700>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<52.046700,0.000000,46.376700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.046700,0.000000,46.376700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.042600,0.000000,46.376700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<51.042600,0.000000,46.376700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<51.712000,0.000000,46.376700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<52.381400,0.000000,45.707300>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,44.997030,0> translate<51.712000,0.000000,46.376700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.053900,0.000000,45.707300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.053900,0.000000,47.715600>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,90.000000,0> translate<53.053900,0.000000,47.715600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.053900,0.000000,47.715600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.058000,0.000000,47.715600>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<53.053900,0.000000,47.715600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.058000,0.000000,47.715600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.392700,0.000000,47.380800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<54.058000,0.000000,47.715600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.392700,0.000000,47.380800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.392700,0.000000,46.711400>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<54.392700,0.000000,46.711400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.392700,0.000000,46.711400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.058000,0.000000,46.376700>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<54.058000,0.000000,46.376700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.058000,0.000000,46.376700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.053900,0.000000,46.376700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<53.053900,0.000000,46.376700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<53.723300,0.000000,46.376700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<54.392700,0.000000,45.707300>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,44.997030,0> translate<53.723300,0.000000,46.376700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.065200,0.000000,45.707300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.065200,0.000000,47.715600>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,90.000000,0> translate<55.065200,0.000000,47.715600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.065200,0.000000,47.715600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<56.404000,0.000000,47.715600>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<55.065200,0.000000,47.715600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.065200,0.000000,46.711400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<55.734600,0.000000,46.711400>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<55.065200,0.000000,46.711400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.426600,0.000000,45.707300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.087800,0.000000,45.707300>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<59.087800,0.000000,45.707300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.087800,0.000000,45.707300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.426600,0.000000,47.046100>}
box{<0,0,-0.088900><1.893349,0.036000,0.088900> rotate<0,-44.997030,0> translate<59.087800,0.000000,45.707300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.426600,0.000000,47.046100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.426600,0.000000,47.380800>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<60.426600,0.000000,47.380800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.426600,0.000000,47.380800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.091900,0.000000,47.715600>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<60.091900,0.000000,47.715600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<60.091900,0.000000,47.715600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.422500,0.000000,47.715600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<59.422500,0.000000,47.715600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.422500,0.000000,47.715600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<59.087800,0.000000,47.380800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,-45.005588,0> translate<59.087800,0.000000,47.380800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.099100,0.000000,46.042000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.099100,0.000000,47.380800>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<61.099100,0.000000,47.380800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.099100,0.000000,47.380800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.433800,0.000000,47.715600>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,-45.005588,0> translate<61.099100,0.000000,47.380800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.433800,0.000000,47.715600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.103200,0.000000,47.715600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<61.433800,0.000000,47.715600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.103200,0.000000,47.715600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.437900,0.000000,47.380800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<62.103200,0.000000,47.715600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.437900,0.000000,47.380800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.437900,0.000000,46.042000>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<62.437900,0.000000,46.042000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.437900,0.000000,46.042000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.103200,0.000000,45.707300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<62.103200,0.000000,45.707300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.103200,0.000000,45.707300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.433800,0.000000,45.707300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<61.433800,0.000000,45.707300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.433800,0.000000,45.707300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.099100,0.000000,46.042000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<61.099100,0.000000,46.042000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<61.099100,0.000000,46.042000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<62.437900,0.000000,47.380800>}
box{<0,0,-0.088900><1.893349,0.036000,0.088900> rotate<0,-44.997030,0> translate<61.099100,0.000000,46.042000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.110400,0.000000,46.042000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.110400,0.000000,47.380800>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<63.110400,0.000000,47.380800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.110400,0.000000,47.380800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.445100,0.000000,47.715600>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,-45.005588,0> translate<63.110400,0.000000,47.380800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.445100,0.000000,47.715600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.114500,0.000000,47.715600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<63.445100,0.000000,47.715600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.114500,0.000000,47.715600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.449200,0.000000,47.380800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<64.114500,0.000000,47.715600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.449200,0.000000,47.380800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.449200,0.000000,46.042000>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<64.449200,0.000000,46.042000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.449200,0.000000,46.042000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.114500,0.000000,45.707300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<64.114500,0.000000,45.707300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.114500,0.000000,45.707300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.445100,0.000000,45.707300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<63.445100,0.000000,45.707300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.445100,0.000000,45.707300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.110400,0.000000,46.042000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<63.110400,0.000000,46.042000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<63.110400,0.000000,46.042000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<64.449200,0.000000,47.380800>}
box{<0,0,-0.088900><1.893349,0.036000,0.088900> rotate<0,-44.997030,0> translate<63.110400,0.000000,46.042000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.121700,0.000000,47.380800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.456400,0.000000,47.715600>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,-45.005588,0> translate<65.121700,0.000000,47.380800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.456400,0.000000,47.715600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.125800,0.000000,47.715600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<65.456400,0.000000,47.715600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.125800,0.000000,47.715600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.460500,0.000000,47.380800>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,45.005588,0> translate<66.125800,0.000000,47.715600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.460500,0.000000,47.380800>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.460500,0.000000,47.046100>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<66.460500,0.000000,47.046100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.460500,0.000000,47.046100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.125800,0.000000,46.711400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<66.125800,0.000000,46.711400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.125800,0.000000,46.711400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.460500,0.000000,46.376700>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<66.125800,0.000000,46.711400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.460500,0.000000,46.376700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.460500,0.000000,46.042000>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<66.460500,0.000000,46.042000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.460500,0.000000,46.042000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.125800,0.000000,45.707300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<66.125800,0.000000,45.707300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.125800,0.000000,45.707300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.456400,0.000000,45.707300>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<65.456400,0.000000,45.707300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.456400,0.000000,45.707300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.121700,0.000000,46.042000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<65.121700,0.000000,46.042000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.121700,0.000000,46.042000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.121700,0.000000,46.376700>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<65.121700,0.000000,46.376700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.121700,0.000000,46.376700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.456400,0.000000,46.711400>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<65.121700,0.000000,46.376700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.456400,0.000000,46.711400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.121700,0.000000,47.046100>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<65.121700,0.000000,47.046100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.121700,0.000000,47.046100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.121700,0.000000,47.380800>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<65.121700,0.000000,47.380800> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<65.456400,0.000000,46.711400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<66.125800,0.000000,46.711400>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<65.456400,0.000000,46.711400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.790900,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.960200,0.000000,57.556400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<86.790900,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.960200,0.000000,57.556400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.960200,0.000000,58.141000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<87.960200,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.960200,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.765400,0.000000,58.335900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<87.765400,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.765400,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.985800,0.000000,58.335900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<86.985800,0.000000,58.335900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.985800,0.000000,58.335900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.790900,0.000000,58.141000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<86.790900,0.000000,58.141000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.790900,0.000000,58.141000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.790900,0.000000,57.556400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<86.790900,0.000000,57.556400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.960200,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.960200,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<87.960200,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.960200,0.000000,58.920500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.790900,0.000000,58.920500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<86.790900,0.000000,58.920500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.790900,0.000000,58.725700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.790900,0.000000,59.115400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<86.790900,0.000000,59.115400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.985800,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.790900,0.000000,60.089800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<86.790900,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.790900,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.790900,0.000000,59.700000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<86.790900,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.790900,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.985800,0.000000,59.505200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<86.790900,0.000000,59.700000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.985800,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.765400,0.000000,59.505200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<86.985800,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.765400,0.000000,59.505200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.960200,0.000000,59.700000>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<87.765400,0.000000,59.505200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.960200,0.000000,59.700000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.960200,0.000000,60.089800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<87.960200,0.000000,60.089800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.960200,0.000000,60.089800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.765400,0.000000,60.284700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<87.765400,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.765400,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.375600,0.000000,60.284700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<87.375600,0.000000,60.284700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.375600,0.000000,60.284700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.375600,0.000000,59.894900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<87.375600,0.000000,59.894900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.960200,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.960200,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<87.960200,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.960200,0.000000,60.869300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.790900,0.000000,60.869300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<86.790900,0.000000,60.869300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.790900,0.000000,60.674500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.790900,0.000000,61.064200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<86.790900,0.000000,61.064200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.960200,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.960200,0.000000,62.623300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<87.960200,0.000000,62.623300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.960200,0.000000,62.623300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.180700,0.000000,63.402800>}
box{<0,0,-0.050800><1.102379,0.036000,0.050800> rotate<0,44.997030,0> translate<87.180700,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.180700,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.985800,0.000000,63.402800>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<86.985800,0.000000,63.402800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.985800,0.000000,63.402800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.790900,0.000000,63.207900>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<86.790900,0.000000,63.207900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.790900,0.000000,63.207900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.790900,0.000000,62.818100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<86.790900,0.000000,62.818100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.790900,0.000000,62.818100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.985800,0.000000,62.623300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<86.790900,0.000000,62.818100> }
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
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.836700,0.000000,23.741100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.836700,0.000000,22.961600>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<46.836700,0.000000,22.961600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.836700,0.000000,22.961600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.421400,0.000000,22.961600>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,0.000000,0> translate<46.836700,0.000000,22.961600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.421400,0.000000,22.961600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.226500,0.000000,23.351300>}
box{<0,0,-0.050800><0.435720,0.036000,0.050800> rotate<0,63.424882,0> translate<47.226500,0.000000,23.351300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.226500,0.000000,23.351300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.226500,0.000000,23.546200>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,90.000000,0> translate<47.226500,0.000000,23.546200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.226500,0.000000,23.546200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.421400,0.000000,23.741100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<47.226500,0.000000,23.546200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.421400,0.000000,23.741100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.811200,0.000000,23.741100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<47.421400,0.000000,23.741100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.811200,0.000000,23.741100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<48.006000,0.000000,23.546200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<47.811200,0.000000,23.741100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<48.006000,0.000000,23.546200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<48.006000,0.000000,23.156400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<48.006000,0.000000,23.156400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<48.006000,0.000000,23.156400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.811200,0.000000,22.961600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<47.811200,0.000000,22.961600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.836700,0.000000,24.130900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.616300,0.000000,24.130900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<46.836700,0.000000,24.130900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.616300,0.000000,24.130900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<48.006000,0.000000,24.520600>}
box{<0,0,-0.050800><0.551119,0.036000,0.050800> rotate<0,-44.997030,0> translate<47.616300,0.000000,24.130900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<48.006000,0.000000,24.520600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.616300,0.000000,24.910400>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,45.004380,0> translate<47.616300,0.000000,24.910400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<47.616300,0.000000,24.910400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<46.836700,0.000000,24.910400>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<46.836700,0.000000,24.910400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.824600,0.000000,22.834600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.629700,0.000000,23.029400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<41.629700,0.000000,23.029400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.629700,0.000000,23.029400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.629700,0.000000,23.419200>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<41.629700,0.000000,23.419200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.629700,0.000000,23.419200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.824600,0.000000,23.614100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<41.629700,0.000000,23.419200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.824600,0.000000,23.614100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.019500,0.000000,23.614100>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<41.824600,0.000000,23.614100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.019500,0.000000,23.614100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214400,0.000000,23.419200>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<42.019500,0.000000,23.614100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214400,0.000000,23.419200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214400,0.000000,23.224300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<42.214400,0.000000,23.224300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214400,0.000000,23.419200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.409300,0.000000,23.614100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<42.214400,0.000000,23.419200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.409300,0.000000,23.614100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.604200,0.000000,23.614100>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<42.409300,0.000000,23.614100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.604200,0.000000,23.614100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.799000,0.000000,23.419200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<42.604200,0.000000,23.614100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.799000,0.000000,23.419200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.799000,0.000000,23.029400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<42.799000,0.000000,23.029400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.799000,0.000000,23.029400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.604200,0.000000,22.834600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<42.604200,0.000000,22.834600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.629700,0.000000,24.003900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.409300,0.000000,24.003900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<41.629700,0.000000,24.003900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.409300,0.000000,24.003900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.799000,0.000000,24.393600>}
box{<0,0,-0.050800><0.551119,0.036000,0.050800> rotate<0,-44.997030,0> translate<42.409300,0.000000,24.003900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.799000,0.000000,24.393600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.409300,0.000000,24.783400>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,45.004380,0> translate<42.409300,0.000000,24.783400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.409300,0.000000,24.783400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.629700,0.000000,24.783400>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<41.629700,0.000000,24.783400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.824600,0.000000,25.173200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.629700,0.000000,25.368000>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<41.629700,0.000000,25.368000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.629700,0.000000,25.368000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.629700,0.000000,25.757800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<41.629700,0.000000,25.757800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.629700,0.000000,25.757800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.824600,0.000000,25.952700>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<41.629700,0.000000,25.757800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<41.824600,0.000000,25.952700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.019500,0.000000,25.952700>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<41.824600,0.000000,25.952700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.019500,0.000000,25.952700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214400,0.000000,25.757800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<42.019500,0.000000,25.952700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214400,0.000000,25.757800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214400,0.000000,25.562900>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<42.214400,0.000000,25.562900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214400,0.000000,25.757800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.409300,0.000000,25.952700>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<42.214400,0.000000,25.757800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.409300,0.000000,25.952700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.604200,0.000000,25.952700>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<42.409300,0.000000,25.952700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.604200,0.000000,25.952700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.799000,0.000000,25.757800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<42.604200,0.000000,25.952700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.799000,0.000000,25.757800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.799000,0.000000,25.368000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<42.799000,0.000000,25.368000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.799000,0.000000,25.368000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.604200,0.000000,25.173200>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<42.604200,0.000000,25.173200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.592000,0.000000,22.555200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.422700,0.000000,22.555200>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<36.422700,0.000000,22.555200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.422700,0.000000,22.555200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.422700,0.000000,23.139800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<36.422700,0.000000,23.139800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.422700,0.000000,23.139800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.617600,0.000000,23.334700>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<36.422700,0.000000,23.139800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.617600,0.000000,23.334700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007400,0.000000,23.334700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<36.617600,0.000000,23.334700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007400,0.000000,23.334700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.202300,0.000000,23.139800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<37.007400,0.000000,23.334700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.202300,0.000000,23.139800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.202300,0.000000,22.555200>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<37.202300,0.000000,22.555200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.202300,0.000000,22.944900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.592000,0.000000,23.334700>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<37.202300,0.000000,22.944900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.422700,0.000000,24.504000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.422700,0.000000,23.724500>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<36.422700,0.000000,23.724500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.422700,0.000000,23.724500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.592000,0.000000,23.724500>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<36.422700,0.000000,23.724500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.592000,0.000000,23.724500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.592000,0.000000,24.504000>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<37.592000,0.000000,24.504000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007400,0.000000,23.724500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007400,0.000000,24.114200>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<37.007400,0.000000,24.114200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.617600,0.000000,25.673300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.422700,0.000000,25.478400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<36.422700,0.000000,25.478400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.422700,0.000000,25.478400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.422700,0.000000,25.088600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<36.422700,0.000000,25.088600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.422700,0.000000,25.088600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.617600,0.000000,24.893800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<36.422700,0.000000,25.088600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.617600,0.000000,24.893800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.812500,0.000000,24.893800>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<36.617600,0.000000,24.893800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.812500,0.000000,24.893800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007400,0.000000,25.088600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<36.812500,0.000000,24.893800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007400,0.000000,25.088600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007400,0.000000,25.478400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<37.007400,0.000000,25.478400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007400,0.000000,25.478400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.202300,0.000000,25.673300>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<37.007400,0.000000,25.478400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.202300,0.000000,25.673300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.397200,0.000000,25.673300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<37.202300,0.000000,25.673300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.397200,0.000000,25.673300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.592000,0.000000,25.478400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<37.397200,0.000000,25.673300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.592000,0.000000,25.478400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.592000,0.000000,25.088600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<37.592000,0.000000,25.088600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.592000,0.000000,25.088600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.397200,0.000000,24.893800>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<37.397200,0.000000,24.893800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.422700,0.000000,26.842600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.422700,0.000000,26.063100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<36.422700,0.000000,26.063100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.422700,0.000000,26.063100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.592000,0.000000,26.063100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<36.422700,0.000000,26.063100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.592000,0.000000,26.063100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.592000,0.000000,26.842600>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<37.592000,0.000000,26.842600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007400,0.000000,26.063100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.007400,0.000000,26.452800>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<37.007400,0.000000,26.452800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.592000,0.000000,27.622100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.422700,0.000000,27.622100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<36.422700,0.000000,27.622100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.422700,0.000000,27.232400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.422700,0.000000,28.011900>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<36.422700,0.000000,28.011900> }
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
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.604100,0.000000,58.771600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.290600,0.000000,58.458100>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<83.290600,0.000000,58.458100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.290600,0.000000,58.458100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.977100,0.000000,58.458100>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<82.977100,0.000000,58.458100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.977100,0.000000,58.458100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.663500,0.000000,58.771600>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<82.663500,0.000000,58.771600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.604100,0.000000,59.081700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.663500,0.000000,59.081700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<82.663500,0.000000,59.081700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.663500,0.000000,59.081700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.663500,0.000000,59.552000>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<82.663500,0.000000,59.552000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.663500,0.000000,59.552000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.820300,0.000000,59.708700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<82.663500,0.000000,59.552000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.820300,0.000000,59.708700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.133800,0.000000,59.708700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<82.820300,0.000000,59.708700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.133800,0.000000,59.708700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.290600,0.000000,59.552000>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<83.133800,0.000000,59.708700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.290600,0.000000,59.552000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.290600,0.000000,59.081700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<83.290600,0.000000,59.081700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.663500,0.000000,60.017200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.604100,0.000000,60.017200>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<82.663500,0.000000,60.017200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.604100,0.000000,60.017200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.290600,0.000000,60.330700>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<83.290600,0.000000,60.330700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.290600,0.000000,60.330700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.604100,0.000000,60.644200>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<83.290600,0.000000,60.330700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.604100,0.000000,60.644200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.663500,0.000000,60.644200>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<82.663500,0.000000,60.644200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.604100,0.000000,60.952700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.663500,0.000000,60.952700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<82.663500,0.000000,60.952700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.663500,0.000000,60.952700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.977100,0.000000,61.266200>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<82.663500,0.000000,60.952700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.977100,0.000000,61.266200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.663500,0.000000,61.579700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<82.663500,0.000000,61.579700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.663500,0.000000,61.579700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.604100,0.000000,61.579700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<82.663500,0.000000,61.579700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.604100,0.000000,61.888200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.290600,0.000000,62.201700>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<83.290600,0.000000,62.201700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.290600,0.000000,62.201700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.977100,0.000000,62.201700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<82.977100,0.000000,62.201700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.977100,0.000000,62.201700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.663500,0.000000,61.888200>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<82.663500,0.000000,61.888200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.774300,0.000000,58.771600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.460800,0.000000,58.458100>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<73.460800,0.000000,58.458100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.460800,0.000000,58.458100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.147300,0.000000,58.458100>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<73.147300,0.000000,58.458100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.147300,0.000000,58.458100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<72.833700,0.000000,58.771600>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<72.833700,0.000000,58.771600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.774300,0.000000,59.081700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<72.833700,0.000000,59.081700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<72.833700,0.000000,59.081700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<72.833700,0.000000,59.081700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<72.833700,0.000000,59.552000>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<72.833700,0.000000,59.552000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<72.833700,0.000000,59.552000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<72.990500,0.000000,59.708700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<72.833700,0.000000,59.552000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<72.990500,0.000000,59.708700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.304000,0.000000,59.708700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<72.990500,0.000000,59.708700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.304000,0.000000,59.708700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.460800,0.000000,59.552000>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<73.304000,0.000000,59.708700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.460800,0.000000,59.552000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.460800,0.000000,59.081700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<73.460800,0.000000,59.081700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<72.833700,0.000000,60.017200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.774300,0.000000,60.017200>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<72.833700,0.000000,60.017200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.774300,0.000000,60.017200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.460800,0.000000,60.330700>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<73.460800,0.000000,60.330700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.460800,0.000000,60.330700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.774300,0.000000,60.644200>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<73.460800,0.000000,60.330700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.774300,0.000000,60.644200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<72.833700,0.000000,60.644200>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<72.833700,0.000000,60.644200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.774300,0.000000,60.952700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<72.833700,0.000000,60.952700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<72.833700,0.000000,60.952700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<72.833700,0.000000,60.952700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.147300,0.000000,61.266200>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<72.833700,0.000000,60.952700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.147300,0.000000,61.266200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<72.833700,0.000000,61.579700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<72.833700,0.000000,61.579700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<72.833700,0.000000,61.579700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.774300,0.000000,61.579700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<72.833700,0.000000,61.579700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.774300,0.000000,61.888200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.460800,0.000000,62.201700>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<73.460800,0.000000,62.201700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.460800,0.000000,62.201700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.147300,0.000000,62.201700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<73.147300,0.000000,62.201700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.147300,0.000000,62.201700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<72.833700,0.000000,61.888200>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<72.833700,0.000000,61.888200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.618100,0.000000,58.695400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.304600,0.000000,58.381900>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<68.304600,0.000000,58.381900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.304600,0.000000,58.381900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.991100,0.000000,58.381900>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<67.991100,0.000000,58.381900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.991100,0.000000,58.381900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.677500,0.000000,58.695400>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<67.677500,0.000000,58.695400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.618100,0.000000,59.005500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.677500,0.000000,59.005500>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<67.677500,0.000000,59.005500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.677500,0.000000,59.005500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.677500,0.000000,59.475800>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<67.677500,0.000000,59.475800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.677500,0.000000,59.475800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.834300,0.000000,59.632500>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<67.677500,0.000000,59.475800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.834300,0.000000,59.632500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.147800,0.000000,59.632500>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<67.834300,0.000000,59.632500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.147800,0.000000,59.632500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.304600,0.000000,59.475800>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<68.147800,0.000000,59.632500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.304600,0.000000,59.475800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.304600,0.000000,59.005500>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<68.304600,0.000000,59.005500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.677500,0.000000,59.941000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.618100,0.000000,59.941000>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<67.677500,0.000000,59.941000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.618100,0.000000,59.941000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.304600,0.000000,60.254500>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<68.304600,0.000000,60.254500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.304600,0.000000,60.254500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.618100,0.000000,60.568000>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<68.304600,0.000000,60.254500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.618100,0.000000,60.568000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.677500,0.000000,60.568000>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<67.677500,0.000000,60.568000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.618100,0.000000,60.876500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.677500,0.000000,60.876500>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<67.677500,0.000000,60.876500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.677500,0.000000,60.876500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.991100,0.000000,61.190000>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<67.677500,0.000000,60.876500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.991100,0.000000,61.190000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.677500,0.000000,61.503500>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<67.677500,0.000000,61.503500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.677500,0.000000,61.503500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.618100,0.000000,61.503500>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<67.677500,0.000000,61.503500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.618100,0.000000,61.812000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.304600,0.000000,62.125500>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<68.304600,0.000000,62.125500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.304600,0.000000,62.125500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.991100,0.000000,62.125500>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<67.991100,0.000000,62.125500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.991100,0.000000,62.125500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.677500,0.000000,61.812000>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<67.677500,0.000000,61.812000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.200300,0.000000,58.771600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.886800,0.000000,58.458100>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<52.886800,0.000000,58.458100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.886800,0.000000,58.458100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.573300,0.000000,58.458100>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<52.573300,0.000000,58.458100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.573300,0.000000,58.458100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.259700,0.000000,58.771600>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<52.259700,0.000000,58.771600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.200300,0.000000,59.081700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.259700,0.000000,59.081700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<52.259700,0.000000,59.081700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.259700,0.000000,59.081700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.259700,0.000000,59.552000>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<52.259700,0.000000,59.552000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.259700,0.000000,59.552000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.416500,0.000000,59.708700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<52.259700,0.000000,59.552000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.416500,0.000000,59.708700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.730000,0.000000,59.708700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<52.416500,0.000000,59.708700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.730000,0.000000,59.708700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.886800,0.000000,59.552000>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<52.730000,0.000000,59.708700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.886800,0.000000,59.552000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.886800,0.000000,59.081700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<52.886800,0.000000,59.081700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.259700,0.000000,60.017200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.200300,0.000000,60.017200>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<52.259700,0.000000,60.017200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.200300,0.000000,60.017200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.886800,0.000000,60.330700>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<52.886800,0.000000,60.330700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.886800,0.000000,60.330700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.200300,0.000000,60.644200>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<52.886800,0.000000,60.330700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.200300,0.000000,60.644200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.259700,0.000000,60.644200>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<52.259700,0.000000,60.644200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.200300,0.000000,60.952700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.259700,0.000000,60.952700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<52.259700,0.000000,60.952700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.259700,0.000000,60.952700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.573300,0.000000,61.266200>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<52.259700,0.000000,60.952700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.573300,0.000000,61.266200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.259700,0.000000,61.579700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<52.259700,0.000000,61.579700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.259700,0.000000,61.579700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.200300,0.000000,61.579700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<52.259700,0.000000,61.579700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.200300,0.000000,61.888200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.886800,0.000000,62.201700>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<52.886800,0.000000,62.201700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.886800,0.000000,62.201700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.573300,0.000000,62.201700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<52.573300,0.000000,62.201700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.573300,0.000000,62.201700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.259700,0.000000,61.888200>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<52.259700,0.000000,61.888200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.475900,0.000000,58.771600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.162400,0.000000,58.458100>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<48.162400,0.000000,58.458100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.162400,0.000000,58.458100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.848900,0.000000,58.458100>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<47.848900,0.000000,58.458100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.848900,0.000000,58.458100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.535300,0.000000,58.771600>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<47.535300,0.000000,58.771600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.475900,0.000000,59.081700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.535300,0.000000,59.081700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<47.535300,0.000000,59.081700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.535300,0.000000,59.081700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.535300,0.000000,59.552000>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<47.535300,0.000000,59.552000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.535300,0.000000,59.552000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.692100,0.000000,59.708700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<47.535300,0.000000,59.552000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.692100,0.000000,59.708700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.005600,0.000000,59.708700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<47.692100,0.000000,59.708700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.005600,0.000000,59.708700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.162400,0.000000,59.552000>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<48.005600,0.000000,59.708700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.162400,0.000000,59.552000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.162400,0.000000,59.081700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.162400,0.000000,59.081700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.535300,0.000000,60.017200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.475900,0.000000,60.017200>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<47.535300,0.000000,60.017200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.475900,0.000000,60.017200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.162400,0.000000,60.330700>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<48.162400,0.000000,60.330700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.162400,0.000000,60.330700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.475900,0.000000,60.644200>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<48.162400,0.000000,60.330700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.475900,0.000000,60.644200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.535300,0.000000,60.644200>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<47.535300,0.000000,60.644200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.475900,0.000000,60.952700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.535300,0.000000,60.952700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<47.535300,0.000000,60.952700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.535300,0.000000,60.952700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.848900,0.000000,61.266200>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<47.535300,0.000000,60.952700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.848900,0.000000,61.266200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.535300,0.000000,61.579700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<47.535300,0.000000,61.579700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.535300,0.000000,61.579700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.475900,0.000000,61.579700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<47.535300,0.000000,61.579700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.475900,0.000000,61.888200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.162400,0.000000,62.201700>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<48.162400,0.000000,62.201700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.162400,0.000000,62.201700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.848900,0.000000,62.201700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<47.848900,0.000000,62.201700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.848900,0.000000,62.201700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.535300,0.000000,61.888200>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<47.535300,0.000000,61.888200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.116500,0.000000,58.695400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.803000,0.000000,58.381900>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<42.803000,0.000000,58.381900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.803000,0.000000,58.381900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.489500,0.000000,58.381900>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<42.489500,0.000000,58.381900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.489500,0.000000,58.381900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.175900,0.000000,58.695400>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<42.175900,0.000000,58.695400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.116500,0.000000,59.005500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.175900,0.000000,59.005500>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<42.175900,0.000000,59.005500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.175900,0.000000,59.005500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.175900,0.000000,59.475800>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<42.175900,0.000000,59.475800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.175900,0.000000,59.475800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.332700,0.000000,59.632500>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<42.175900,0.000000,59.475800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.332700,0.000000,59.632500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.646200,0.000000,59.632500>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<42.332700,0.000000,59.632500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.646200,0.000000,59.632500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.803000,0.000000,59.475800>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<42.646200,0.000000,59.632500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.803000,0.000000,59.475800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.803000,0.000000,59.005500>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<42.803000,0.000000,59.005500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.175900,0.000000,59.941000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.116500,0.000000,59.941000>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<42.175900,0.000000,59.941000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.116500,0.000000,59.941000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.803000,0.000000,60.254500>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<42.803000,0.000000,60.254500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.803000,0.000000,60.254500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.116500,0.000000,60.568000>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<42.803000,0.000000,60.254500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.116500,0.000000,60.568000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.175900,0.000000,60.568000>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<42.175900,0.000000,60.568000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.116500,0.000000,60.876500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.175900,0.000000,60.876500>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<42.175900,0.000000,60.876500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.175900,0.000000,60.876500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.489500,0.000000,61.190000>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<42.175900,0.000000,60.876500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.489500,0.000000,61.190000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.175900,0.000000,61.503500>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<42.175900,0.000000,61.503500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.175900,0.000000,61.503500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.116500,0.000000,61.503500>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<42.175900,0.000000,61.503500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.116500,0.000000,61.812000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.803000,0.000000,62.125500>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<42.803000,0.000000,62.125500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.803000,0.000000,62.125500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.489500,0.000000,62.125500>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<42.489500,0.000000,62.125500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.489500,0.000000,62.125500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.175900,0.000000,61.812000>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<42.175900,0.000000,61.812000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<100.025200,0.000000,27.482800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.703300,0.000000,27.482800>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,0.000000,0> translate<98.703300,0.000000,27.482800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.703300,0.000000,27.482800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.703300,0.000000,28.143700>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,90.000000,0> translate<98.703300,0.000000,28.143700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.703300,0.000000,28.143700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.923600,0.000000,28.364000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<98.703300,0.000000,28.143700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.923600,0.000000,28.364000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<99.364300,0.000000,28.364000>}
box{<0,0,-0.050800><0.440700,0.036000,0.050800> rotate<0,0.000000,0> translate<98.923600,0.000000,28.364000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<99.364300,0.000000,28.364000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<99.584600,0.000000,28.143700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<99.364300,0.000000,28.364000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<99.584600,0.000000,28.143700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<99.584600,0.000000,27.482800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<99.584600,0.000000,27.482800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.703300,0.000000,29.453400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.703300,0.000000,29.012800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,-90.000000,0> translate<98.703300,0.000000,29.012800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.703300,0.000000,29.012800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.923600,0.000000,28.792500>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<98.703300,0.000000,29.012800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.923600,0.000000,28.792500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<99.804900,0.000000,28.792500>}
box{<0,0,-0.050800><0.881300,0.036000,0.050800> rotate<0,0.000000,0> translate<98.923600,0.000000,28.792500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<99.804900,0.000000,28.792500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<100.025200,0.000000,29.012800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<99.804900,0.000000,28.792500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<100.025200,0.000000,29.012800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<100.025200,0.000000,29.453400>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,90.000000,0> translate<100.025200,0.000000,29.453400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<100.025200,0.000000,29.453400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<99.804900,0.000000,29.673700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<99.804900,0.000000,29.673700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<99.804900,0.000000,29.673700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.923600,0.000000,29.673700>}
box{<0,0,-0.050800><0.881300,0.036000,0.050800> rotate<0,0.000000,0> translate<98.923600,0.000000,29.673700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.923600,0.000000,29.673700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.703300,0.000000,29.453400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<98.703300,0.000000,29.453400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.703300,0.000000,30.102200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<100.025200,0.000000,30.102200>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,0.000000,0> translate<98.703300,0.000000,30.102200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<100.025200,0.000000,30.102200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<99.584600,0.000000,30.542800>}
box{<0,0,-0.050800><0.623102,0.036000,0.050800> rotate<0,44.997030,0> translate<99.584600,0.000000,30.542800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<99.584600,0.000000,30.542800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<100.025200,0.000000,30.983400>}
box{<0,0,-0.050800><0.623102,0.036000,0.050800> rotate<0,-44.997030,0> translate<99.584600,0.000000,30.542800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<100.025200,0.000000,30.983400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.703300,0.000000,30.983400>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,0.000000,0> translate<98.703300,0.000000,30.983400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.703300,0.000000,32.293100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.703300,0.000000,31.411900>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,-90.000000,0> translate<98.703300,0.000000,31.411900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.703300,0.000000,31.411900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<100.025200,0.000000,31.411900>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,0.000000,0> translate<98.703300,0.000000,31.411900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<100.025200,0.000000,31.411900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<100.025200,0.000000,32.293100>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<100.025200,0.000000,32.293100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<99.364300,0.000000,31.411900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<99.364300,0.000000,31.852500>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,90.000000,0> translate<99.364300,0.000000,31.852500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<100.025200,0.000000,32.721600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.703300,0.000000,32.721600>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,0.000000,0> translate<98.703300,0.000000,32.721600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.703300,0.000000,32.721600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.703300,0.000000,33.382500>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,90.000000,0> translate<98.703300,0.000000,33.382500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.703300,0.000000,33.382500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.923600,0.000000,33.602800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<98.703300,0.000000,33.382500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<98.923600,0.000000,33.602800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<99.364300,0.000000,33.602800>}
box{<0,0,-0.050800><0.440700,0.036000,0.050800> rotate<0,0.000000,0> translate<98.923600,0.000000,33.602800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<99.364300,0.000000,33.602800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<99.584600,0.000000,33.382500>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<99.364300,0.000000,33.602800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<99.584600,0.000000,33.382500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<99.584600,0.000000,32.721600>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<99.584600,0.000000,32.721600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<99.584600,0.000000,33.162200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<100.025200,0.000000,33.602800>}
box{<0,0,-0.050800><0.623102,0.036000,0.050800> rotate<0,-44.997030,0> translate<99.584600,0.000000,33.162200> }
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
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.678000,0.000000,41.402000>}
box{<0,0,-0.203200><26.924000,0.036000,0.203200> rotate<0,90.000000,0> translate<90.678000,0.000000,41.402000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<90.678000,0.000000,41.402000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<85.090000,0.000000,41.402000>}
box{<0,0,-0.203200><5.588000,0.036000,0.203200> rotate<0,0.000000,0> translate<85.090000,0.000000,41.402000> }
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
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<80.010000,0.000000,41.402000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<85.090000,0.000000,41.402000>}
box{<0,0,-0.203200><5.080000,0.036000,0.203200> rotate<0,0.000000,0> translate<80.010000,0.000000,41.402000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<85.090000,0.000000,41.402000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<85.090000,0.000000,14.478000>}
box{<0,0,-0.203200><26.924000,0.036000,0.203200> rotate<0,-90.000000,0> translate<85.090000,0.000000,14.478000> }
//C1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<95.622600,0.000000,43.555400>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<95.622600,0.000000,44.190400>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<95.622600,0.000000,44.190400> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<95.622600,0.000000,44.190400>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<95.622600,0.000000,44.825400>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<95.622600,0.000000,44.825400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.622600,0.000000,44.190400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.841800,0.000000,44.190400>}
box{<0,0,-0.076200><1.219200,0.036000,0.076200> rotate<0,0.000000,0> translate<95.622600,0.000000,44.190400> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<94.987600,0.000000,43.555400>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<94.987600,0.000000,44.190400>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<94.987600,0.000000,44.190400> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<94.987600,0.000000,44.190400>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<94.987600,0.000000,44.825400>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<94.987600,0.000000,44.825400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.987600,0.000000,44.190400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.793800,0.000000,44.190400>}
box{<0,0,-0.076200><1.193800,0.036000,0.076200> rotate<0,0.000000,0> translate<93.793800,0.000000,44.190400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<99.000800,0.000000,42.920400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<99.000800,0.000000,45.460400>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,90.000000,0> translate<99.000800,0.000000,45.460400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.746800,0.000000,45.714400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.888800,0.000000,45.714400>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<91.888800,0.000000,45.714400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.634800,0.000000,45.460400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.634800,0.000000,42.920400>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,-90.000000,0> translate<91.634800,0.000000,42.920400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.888800,0.000000,42.666400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.746800,0.000000,42.666400>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<91.888800,0.000000,42.666400> }
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<91.888800,0.000000,42.920400>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<91.888800,0.000000,45.460400>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<98.746800,0.000000,45.460400>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<98.746800,0.000000,42.920400>}
//C2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.188000,0.000000,38.196000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<97.426000,0.000000,38.196000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<97.426000,0.000000,38.196000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<97.807000,0.000000,38.577000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<97.807000,0.000000,37.815000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<97.807000,0.000000,37.815000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.791000,0.000000,38.196000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.902000,0.000000,38.196000>}
box{<0,0,-0.076200><0.889000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.902000,0.000000,38.196000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.902000,0.000000,38.196000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.902000,0.000000,39.466000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<95.902000,0.000000,39.466000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.902000,0.000000,39.466000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.394000,0.000000,39.466000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.394000,0.000000,39.466000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.394000,0.000000,39.466000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.394000,0.000000,36.926000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,-90.000000,0> translate<95.394000,0.000000,36.926000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.394000,0.000000,36.926000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.902000,0.000000,36.926000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,0.000000,0> translate<95.394000,0.000000,36.926000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.902000,0.000000,36.926000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.902000,0.000000,38.196000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<95.902000,0.000000,38.196000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.505000,0.000000,38.196000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.489000,0.000000,38.196000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<93.489000,0.000000,38.196000> }
difference{
cylinder{<95.140000,0,38.196000><95.140000,0.036000,38.196000>3.505200 translate<0,0.000000,0>}
cylinder{<95.140000,-0.1,38.196000><95.140000,0.135000,38.196000>3.352800 translate<0,0.000000,0>}}
box{<-0.254000,0,-1.270000><0.254000,0.036000,1.270000> rotate<0,-180.000000,0> translate<94.632000,0.000000,38.196000>}
//D1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.012000,0.000000,19.558000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.948000,0.000000,19.558000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<91.948000,0.000000,19.558000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.012000,0.000000,19.558000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.012000,0.000000,22.098000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,90.000000,0> translate<96.012000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.948000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<96.012000,0.000000,22.098000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<91.948000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.948000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<91.948000,0.000000,19.558000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,-90.000000,0> translate<91.948000,0.000000,19.558000> }
cylinder{<0,0,0><0,0.036000,0>0.381000 translate<99.060000,0.000000,20.828000>}
cylinder{<0,0,0><0,0.036000,0>0.381000 translate<98.044000,0.000000,20.828000>}
box{<0,0,-0.381000><1.016000,0.036000,0.381000> rotate<0,0.000000,0> translate<98.044000,0.000000,20.828000> }
cylinder{<0,0,0><0,0.036000,0>0.381000 translate<88.900000,0.000000,20.828000>}
cylinder{<0,0,0><0,0.036000,0>0.381000 translate<89.916000,0.000000,20.828000>}
box{<0,0,-0.381000><1.016000,0.036000,0.381000> rotate<0,0.000000,0> translate<88.900000,0.000000,20.828000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.345000,0.000000,20.828000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.980000,0.000000,20.828000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,0.000000,0> translate<93.345000,0.000000,20.828000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.996000,0.000000,21.463000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.996000,0.000000,20.193000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<94.996000,0.000000,20.193000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.996000,0.000000,20.193000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.980000,0.000000,20.828000>}
box{<0,0,-0.076200><1.198116,0.036000,0.076200> rotate<0,32.003271,0> translate<93.980000,0.000000,20.828000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.980000,0.000000,20.828000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<95.504000,0.000000,20.828000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<93.980000,0.000000,20.828000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.980000,0.000000,20.828000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<94.996000,0.000000,21.463000>}
box{<0,0,-0.076200><1.198116,0.036000,0.076200> rotate<0,-32.003271,0> translate<93.980000,0.000000,20.828000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.980000,0.000000,21.463000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.980000,0.000000,20.828000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,-90.000000,0> translate<93.980000,0.000000,20.828000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.980000,0.000000,20.828000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<93.980000,0.000000,20.193000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,-90.000000,0> translate<93.980000,0.000000,20.193000> }
box{<-0.254000,0,-1.270000><0.254000,0.036000,1.270000> rotate<0,-0.000000,0> translate<92.583000,0.000000,20.828000>}
box{<-0.952500,0,-0.381000><0.952500,0.036000,0.381000> rotate<0,-0.000000,0> translate<96.964500,0.000000,20.828000>}
box{<-0.952500,0,-0.381000><0.952500,0.036000,0.381000> rotate<0,-0.000000,0> translate<90.995500,0.000000,20.828000>}
//H1 silk screen
object{ARC(2.159000,2.489200,180.000000,270.000000,0.036000) translate<95.783400,0.000000,10.439400>}
object{ARC(2.159000,2.489200,0.000000,90.000000,0.036000) translate<95.783400,0.000000,10.439400>}
difference{
cylinder{<95.783400,0,10.439400><95.783400,0.036000,10.439400>3.505200 translate<0,0.000000,0>}
cylinder{<95.783400,-0.1,10.439400><95.783400,0.135000,10.439400>3.352800 translate<0,0.000000,0>}}
difference{
cylinder{<95.783400,0,10.439400><95.783400,0.036000,10.439400>0.990600 translate<0,0.000000,0>}
cylinder{<95.783400,-0.1,10.439400><95.783400,0.135000,10.439400>0.533400 translate<0,0.000000,0>}}
difference{
cylinder{<95.783400,0,10.439400><95.783400,0.036000,10.439400>1.701600 translate<0,0.000000,0>}
cylinder{<95.783400,-0.1,10.439400><95.783400,0.135000,10.439400>1.498400 translate<0,0.000000,0>}}
//H2 silk screen
object{ARC(2.159000,2.489200,180.000000,270.000000,0.036000) translate<95.529400,0.000000,74.803000>}
object{ARC(2.159000,2.489200,0.000000,90.000000,0.036000) translate<95.529400,0.000000,74.803000>}
difference{
cylinder{<95.529400,0,74.803000><95.529400,0.036000,74.803000>3.505200 translate<0,0.000000,0>}
cylinder{<95.529400,-0.1,74.803000><95.529400,0.135000,74.803000>3.352800 translate<0,0.000000,0>}}
difference{
cylinder{<95.529400,0,74.803000><95.529400,0.036000,74.803000>0.990600 translate<0,0.000000,0>}
cylinder{<95.529400,-0.1,74.803000><95.529400,0.135000,74.803000>0.533400 translate<0,0.000000,0>}}
difference{
cylinder{<95.529400,0,74.803000><95.529400,0.036000,74.803000>1.701600 translate<0,0.000000,0>}
cylinder{<95.529400,-0.1,74.803000><95.529400,0.135000,74.803000>1.498400 translate<0,0.000000,0>}}
//H3 silk screen
object{ARC(2.159000,2.489200,180.000000,270.000000,0.036000) translate<23.749000,0.000000,10.287000>}
object{ARC(2.159000,2.489200,0.000000,90.000000,0.036000) translate<23.749000,0.000000,10.287000>}
difference{
cylinder{<23.749000,0,10.287000><23.749000,0.036000,10.287000>3.505200 translate<0,0.000000,0>}
cylinder{<23.749000,-0.1,10.287000><23.749000,0.135000,10.287000>3.352800 translate<0,0.000000,0>}}
difference{
cylinder{<23.749000,0,10.287000><23.749000,0.036000,10.287000>0.990600 translate<0,0.000000,0>}
cylinder{<23.749000,-0.1,10.287000><23.749000,0.135000,10.287000>0.533400 translate<0,0.000000,0>}}
difference{
cylinder{<23.749000,0,10.287000><23.749000,0.036000,10.287000>1.701600 translate<0,0.000000,0>}
cylinder{<23.749000,-0.1,10.287000><23.749000,0.135000,10.287000>1.498400 translate<0,0.000000,0>}}
//H4 silk screen
object{ARC(2.159000,2.489200,180.000000,270.000000,0.036000) translate<23.241000,0.000000,74.625200>}
object{ARC(2.159000,2.489200,0.000000,90.000000,0.036000) translate<23.241000,0.000000,74.625200>}
difference{
cylinder{<23.241000,0,74.625200><23.241000,0.036000,74.625200>3.505200 translate<0,0.000000,0>}
cylinder{<23.241000,-0.1,74.625200><23.241000,0.135000,74.625200>3.352800 translate<0,0.000000,0>}}
difference{
cylinder{<23.241000,0,74.625200><23.241000,0.036000,74.625200>0.990600 translate<0,0.000000,0>}
cylinder{<23.241000,-0.1,74.625200><23.241000,0.135000,74.625200>0.533400 translate<0,0.000000,0>}}
difference{
cylinder{<23.241000,0,74.625200><23.241000,0.036000,74.625200>1.701600 translate<0,0.000000,0>}
cylinder{<23.241000,-0.1,74.625200><23.241000,0.135000,74.625200>1.498400 translate<0,0.000000,0>}}
//LED1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.638600,0.000000,33.903400>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.828600,0.000000,33.903400>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<92.828600,0.000000,33.903400> }
object{ARC(3.175000,0.254000,126.869898,413.130102,0.036000) translate<94.733600,0.000000,31.363400>}
object{ARC(1.143000,0.152400,180.000000,270.000000,0.036000) translate<94.733600,0.000000,31.363400>}
object{ARC(1.143000,0.152400,0.000000,90.000000,0.036000) translate<94.733600,0.000000,31.363400>}
object{ARC(1.651000,0.152400,180.000000,270.000000,0.036000) translate<94.733600,0.000000,31.363400>}
object{ARC(1.651000,0.152400,0.000000,90.000000,0.036000) translate<94.733600,0.000000,31.363400>}
object{ARC(2.159000,0.152400,180.000000,270.000000,0.036000) translate<94.733600,0.000000,31.363400>}
object{ARC(2.159000,0.152400,0.000000,90.000000,0.036000) translate<94.733600,0.000000,31.363400>}
difference{
cylinder{<94.733600,0,31.363400><94.733600,0.036000,31.363400>2.616200 translate<0,0.000000,0>}
cylinder{<94.733600,-0.1,31.363400><94.733600,0.135000,31.363400>2.463800 translate<0,0.000000,0>}}
//R1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<91.558600,0.000000,25.369000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<91.939600,0.000000,25.369000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,0.000000,0> translate<91.558600,0.000000,25.369000> }
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<92.447600,0.000000,26.258000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<92.447600,0.000000,24.480000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<98.289600,0.000000,24.480000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<98.289600,0.000000,26.258000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.193600,0.000000,24.480000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.193600,0.000000,26.258000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<92.193600,0.000000,26.258000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.447600,0.000000,26.512000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.828600,0.000000,26.512000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<92.447600,0.000000,26.512000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.955600,0.000000,26.385000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.828600,0.000000,26.512000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<92.828600,0.000000,26.512000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.447600,0.000000,24.226000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.828600,0.000000,24.226000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<92.447600,0.000000,24.226000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.955600,0.000000,24.353000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.828600,0.000000,24.226000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<92.828600,0.000000,24.226000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<97.781600,0.000000,26.385000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<97.908600,0.000000,26.512000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<97.781600,0.000000,26.385000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<97.781600,0.000000,26.385000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.955600,0.000000,26.385000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<92.955600,0.000000,26.385000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<97.781600,0.000000,24.353000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<97.908600,0.000000,24.226000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<97.781600,0.000000,24.353000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<97.781600,0.000000,24.353000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<92.955600,0.000000,24.353000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<92.955600,0.000000,24.353000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.289600,0.000000,26.512000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<97.908600,0.000000,26.512000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<97.908600,0.000000,26.512000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.289600,0.000000,24.226000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<97.908600,0.000000,24.226000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<97.908600,0.000000,24.226000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.543600,0.000000,24.480000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<98.543600,0.000000,26.258000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<98.543600,0.000000,26.258000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<98.797600,0.000000,25.369000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<99.178600,0.000000,25.369000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,0.000000,0> translate<98.797600,0.000000,25.369000> }
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-0.000000,0> translate<92.066600,0.000000,25.369000>}
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-0.000000,0> translate<98.670600,0.000000,25.369000>}
//U$1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<22.682200,0.000000,68.478400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<88.468200,0.000000,68.478400>}
box{<0,0,-0.063500><65.786000,0.036000,0.063500> rotate<0,0.000000,0> translate<22.682200,0.000000,68.478400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<88.468200,0.000000,68.478400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<88.468200,0.000000,15.138400>}
box{<0,0,-0.063500><53.340000,0.036000,0.063500> rotate<0,-90.000000,0> translate<88.468200,0.000000,15.138400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<88.468200,0.000000,15.138400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<22.682200,0.000000,15.138400>}
box{<0,0,-0.063500><65.786000,0.036000,0.063500> rotate<0,0.000000,0> translate<22.682200,0.000000,15.138400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<22.682200,0.000000,15.138400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<22.682200,0.000000,68.478400>}
box{<0,0,-0.063500><53.340000,0.036000,0.063500> rotate<0,90.000000,0> translate<22.682200,0.000000,68.478400> }
//X1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.278600,0.000000,46.630000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.278600,0.000000,69.530000>}
box{<0,0,-0.101600><22.900000,0.036000,0.101600> rotate<0,90.000000,0> translate<92.278600,0.000000,69.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.278600,0.000000,69.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<98.338600,0.000000,69.530000>}
box{<0,0,-0.101600><6.060000,0.036000,0.101600> rotate<0,0.000000,0> translate<92.278600,0.000000,69.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<98.338600,0.000000,69.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<100.338600,0.000000,67.530000>}
box{<0,0,-0.101600><2.828427,0.036000,0.101600> rotate<0,44.997030,0> translate<98.338600,0.000000,69.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<100.338600,0.000000,67.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<100.338600,0.000000,48.630000>}
box{<0,0,-0.101600><18.900000,0.036000,0.101600> rotate<0,-90.000000,0> translate<100.338600,0.000000,48.630000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<100.338600,0.000000,48.630000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<98.338600,0.000000,46.630000>}
box{<0,0,-0.101600><2.828427,0.036000,0.101600> rotate<0,-44.997030,0> translate<98.338600,0.000000,46.630000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<98.338600,0.000000,46.630000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.278600,0.000000,46.630000>}
box{<0,0,-0.101600><6.060000,0.036000,0.101600> rotate<0,0.000000,0> translate<92.278600,0.000000,46.630000> }
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
object{  ARDUINO_BREAKOUT(-59.550300,0,-42.849800,pcb_rotate_x,pcb_rotate_y,pcb_rotate_z)
#if(pcb_upsidedown=on)
rotate pcb_rotdir*180
#end
}
#end


//Parts not found in 3dpack.dat or 3dusrpac.dat are:
//C2	100uF	E2,5-7
//H1	MOUNT-HOLE3.0	3,0
//H2	MOUNT-HOLE3.0	3,0
//H3	MOUNT-HOLE3.0	3,0
//H4	MOUNT-HOLE3.0	3,0
//U$1	ARDUINODIECIMILIA	ARDUINO
//X1	9090-4V	9090-4V
