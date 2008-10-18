//POVRay-File created by 3d41.ulp v1.05
//D:/Documents and Settings/Bruce Wattendorf/Desktop/reprap electronics/trunk/reprap/electronics/Arduino-Sanguino/lcd-interface/lcd-interface.brd
//10/17/2008 9:24:02 PM

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
#local cam_y = 320;
#local cam_z = -108;
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

#local lgt1_pos_x = 38;
#local lgt1_pos_y = 56;
#local lgt1_pos_z = 24;
#local lgt1_intense = 0.767114;
#local lgt2_pos_x = -38;
#local lgt2_pos_y = 56;
#local lgt2_pos_z = 24;
#local lgt2_intense = 0.767114;
#local lgt3_pos_x = 38;
#local lgt3_pos_y = 56;
#local lgt3_pos_z = -16;
#local lgt3_intense = 0.767114;
#local lgt4_pos_x = -38;
#local lgt4_pos_y = 56;
#local lgt4_pos_z = -16;
#local lgt4_intense = 0.767114;

//Do not change these values
#declare pcb_height = 1.500000;
#declare pcb_cuheight = 0.035000;
#declare pcb_x_size = 100.000000;
#declare pcb_y_size = 46.980000;
#declare pcb_layer1_used = 1;
#declare pcb_layer16_used = 1;
#declare inc_testmode = off;
#declare global_seed=seed(712);
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
	//translate<-50.000000,0,-23.490000>
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


#macro LCD_INTERFACE(mac_x_ver,mac_y_ver,mac_z_ver,mac_x_rot,mac_y_rot,mac_z_rot)
union{
#if(pcb_board = on)
difference{
union{
//Board
prism{-1.500000,0.000000,8
<-0.470000,37.470000><99.530000,37.470000>
<99.530000,37.470000><99.530000,84.450000>
<99.530000,84.450000><-0.470000,84.450000>
<-0.470000,84.450000><-0.470000,37.470000>
texture{col_brd}}
}//End union(Platine)
//Holes(real)/Parts
//Holes(real)/Board
//Holes(real)/Vias
}//End difference(reale Bohrungen/Durchbrüche)
#end
#if(pcb_parts=on)//Parts
union{
#ifndef(pack_BUTTON_INTERFACE) #declare global_pack_BUTTON_INTERFACE=yes; object {PH_1X6()translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<30.480000,0.000000,73.660000>}#end		//Header 2,54mm Grid 6Pin 1Row (jumper.lib) BUTTON_INTERFACE  1X06
#ifndef(pack_BUTTON_INTERFACE1) #declare global_pack_BUTTON_INTERFACE1=yes; object {PH_1X6()translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<54.610000,0.000000,48.260000>}#end		//Header 2,54mm Grid 6Pin 1Row (jumper.lib) BUTTON_INTERFACE1  1X06
cylinder{<0,0,0><0,7*1.000000,0>0.5 pigment{Red filter 0.2} translate<20.320000,0,60.960000>}		//unbekanntes Bauteil I2C_ADDRESS  DIP03YL
#ifndef(pack_IC1) #declare global_pack_IC1=yes; object {IC_DIS_DIP28("MCP23S17SP","",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<68.580000,0.000000,58.420000>translate<0,3.000000,0> }#end		//DIP28 300mil IC1 MCP23S17SP DIL28-3
#ifndef(pack_IC1) object{SOCKET_DIP28()rotate<0,0.000000,0> rotate<0,0,0> translate<68.580000,0.000000,58.420000>}#end					//IC-Sockel 28Pin IC1 MCP23S17SP
#ifndef(pack_JP3) #declare global_pack_JP3=yes; object {PH_1X16()translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<10.160000,0.000000,48.260000>}#end		//Header 2,54mm Grid 16Pin 1Row (jumper.lib) JP3 M16PTH 1X16
#ifndef(pack_JP4) #declare global_pack_JP4=yes; object {PH_1X16()translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<50.800000,0.000000,73.660000>}#end		//Header 2,54mm Grid 16Pin 1Row (jumper.lib) JP4 M16PTH 1X16
#ifndef(pack_JP5) #declare global_pack_JP5=yes; object {PH_1X7()translate<0,0,0> rotate<0,0.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<7.620000,0.000000,53.340000>}#end		//Header 2,54mm Grid 7Pin 1Row (jumper.lib) JP5  1X07
#ifndef(pack_JP6) #declare global_pack_JP6=yes; object {PH_1X7()translate<0,0,0> rotate<0,0.000000,0>rotate<0,-270.000000,0> rotate<0,0,0> translate<91.440000,0.000000,68.580000>}#end		//Header 2,54mm Grid 7Pin 1Row (jumper.lib) JP6  1X07
cylinder{<0,0,0><0,7*1.000000,0>0.5 pigment{Red filter 0.2} translate<19.050000,0,71.120000>}		//unbekanntes Bauteil LCD_CONTRAST POTTRIM TRIM_POT
#ifndef(pack_R1) #declare global_pack_R1=yes; object {RES_DIS_0207_10MM(texture{pigment{DarkBrown}finish{phong 0.2}},texture{pigment{Black}finish{phong 0.2}},texture{pigment{Orange}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<43.180000,0.000000,68.580000>}#end		//Discrete Resistor 0,3W 10MM Grid R1 10k 0207/10
#ifndef(pack_R3) #declare global_pack_R3=yes; object {RES_DIS_0207_10MM(texture{pigment{DarkBrown}finish{phong 0.2}},texture{pigment{Black}finish{phong 0.2}},texture{pigment{Orange}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<81.280000,0.000000,68.580000>}#end		//Discrete Resistor 0,3W 10MM Grid R3 10k 0207/10
#ifndef(pack_R4) #declare global_pack_R4=yes; object {RES_DIS_0207_10MM(texture{pigment{DarkBrown}finish{phong 0.2}},texture{pigment{Black}finish{phong 0.2}},texture{pigment{Orange}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<55.880000,0.000000,68.580000>}#end		//Discrete Resistor 0,3W 10MM Grid R4 10k 0207/10
#ifndef(pack_R5) #declare global_pack_R5=yes; object {RES_DIS_0207_10MM(texture{pigment{DarkBrown}finish{phong 0.2}},texture{pigment{Black}finish{phong 0.2}},texture{pigment{Orange}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<36.830000,0.000000,59.690000>}#end		//Discrete Resistor 0,3W 10MM Grid R5 10k 0207/10
#ifndef(pack_R6) #declare global_pack_R6=yes; object {RES_DIS_0207_10MM(texture{pigment{DarkBrown}finish{phong 0.2}},texture{pigment{Black}finish{phong 0.2}},texture{pigment{Orange}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<31.750000,0.000000,59.690000>}#end		//Discrete Resistor 0,3W 10MM Grid R6 10k 0207/10
#ifndef(pack_R7) #declare global_pack_R7=yes; object {RES_DIS_0207_10MM(texture{pigment{Yellow}finish{phong 0.2}},texture{pigment{Violet*1.2}finish{phong 0.2}},texture{pigment{DarkBrown}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<43.180000,0.000000,59.690000>}#end		//Discrete Resistor 0,3W 10MM Grid R7 470 0207/10
#ifndef(pack_R8) #declare global_pack_R8=yes; object {RES_DIS_0207_10MM(texture{pigment{DarkBrown}finish{phong 0.2}},texture{pigment{Black}finish{phong 0.2}},texture{pigment{Orange}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<68.580000,0.000000,68.580000>}#end		//Discrete Resistor 0,3W 10MM Grid R8 10k 0207/10
}//End union
#end
#if(pcb_pads_smds=on)
//Pads&SMD/Parts
#ifndef(global_pack_BUTTON_INTERFACE) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<30.480000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_BUTTON_INTERFACE) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<33.020000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_BUTTON_INTERFACE) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<35.560000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_BUTTON_INTERFACE) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<38.100000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_BUTTON_INTERFACE) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<40.640000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_BUTTON_INTERFACE) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<43.180000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_BUTTON_INTERFACE1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<54.610000,0,48.260000> texture{col_thl}}
#ifndef(global_pack_BUTTON_INTERFACE1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<57.150000,0,48.260000> texture{col_thl}}
#ifndef(global_pack_BUTTON_INTERFACE1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<59.690000,0,48.260000> texture{col_thl}}
#ifndef(global_pack_BUTTON_INTERFACE1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<62.230000,0,48.260000> texture{col_thl}}
#ifndef(global_pack_BUTTON_INTERFACE1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<64.770000,0,48.260000> texture{col_thl}}
#ifndef(global_pack_BUTTON_INTERFACE1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<67.310000,0,48.260000> texture{col_thl}}
#ifndef(global_pack_I2C_ADDRESS) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<17.780000,0,57.150000> texture{col_thl}}
#ifndef(global_pack_I2C_ADDRESS) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<20.320000,0,57.150000> texture{col_thl}}
#ifndef(global_pack_I2C_ADDRESS) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<22.860000,0,57.150000> texture{col_thl}}
#ifndef(global_pack_I2C_ADDRESS) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<22.860000,0,64.770000> texture{col_thl}}
#ifndef(global_pack_I2C_ADDRESS) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<20.320000,0,64.770000> texture{col_thl}}
#ifndef(global_pack_I2C_ADDRESS) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<17.780000,0,64.770000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<52.070000,0,54.610000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<54.610000,0,54.610000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<57.150000,0,54.610000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<59.690000,0,54.610000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<62.230000,0,54.610000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<64.770000,0,54.610000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<67.310000,0,54.610000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<69.850000,0,54.610000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<72.390000,0,54.610000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<74.930000,0,54.610000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<77.470000,0,54.610000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<80.010000,0,54.610000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<82.550000,0,54.610000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<85.090000,0,54.610000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<85.090000,0,62.230000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<82.550000,0,62.230000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<80.010000,0,62.230000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<77.470000,0,62.230000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<74.930000,0,62.230000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<72.390000,0,62.230000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<69.850000,0,62.230000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<67.310000,0,62.230000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<64.770000,0,62.230000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<62.230000,0,62.230000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<59.690000,0,62.230000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<57.150000,0,62.230000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<54.610000,0,62.230000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<52.070000,0,62.230000> texture{col_thl}}
#ifndef(global_pack_JP3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<10.160000,0,48.260000> texture{col_thl}}
#ifndef(global_pack_JP3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<12.700000,0,48.260000> texture{col_thl}}
#ifndef(global_pack_JP3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<15.240000,0,48.260000> texture{col_thl}}
#ifndef(global_pack_JP3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<17.780000,0,48.260000> texture{col_thl}}
#ifndef(global_pack_JP3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<20.320000,0,48.260000> texture{col_thl}}
#ifndef(global_pack_JP3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<22.860000,0,48.260000> texture{col_thl}}
#ifndef(global_pack_JP3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<25.400000,0,48.260000> texture{col_thl}}
#ifndef(global_pack_JP3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<27.940000,0,48.260000> texture{col_thl}}
#ifndef(global_pack_JP3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<30.480000,0,48.260000> texture{col_thl}}
#ifndef(global_pack_JP3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<33.020000,0,48.260000> texture{col_thl}}
#ifndef(global_pack_JP3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<35.560000,0,48.260000> texture{col_thl}}
#ifndef(global_pack_JP3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<38.100000,0,48.260000> texture{col_thl}}
#ifndef(global_pack_JP3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<40.640000,0,48.260000> texture{col_thl}}
#ifndef(global_pack_JP3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<43.180000,0,48.260000> texture{col_thl}}
#ifndef(global_pack_JP3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<45.720000,0,48.260000> texture{col_thl}}
#ifndef(global_pack_JP3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<48.260000,0,48.260000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<50.800000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<53.340000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<55.880000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<58.420000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<60.960000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<63.500000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<66.040000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<68.580000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<71.120000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<73.660000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<76.200000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<78.740000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<81.280000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<83.820000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<86.360000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<88.900000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_JP5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-180.000000,0>translate<7.620000,0,53.340000> texture{col_thl}}
#ifndef(global_pack_JP5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-180.000000,0>translate<7.620000,0,55.880000> texture{col_thl}}
#ifndef(global_pack_JP5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-180.000000,0>translate<7.620000,0,58.420000> texture{col_thl}}
#ifndef(global_pack_JP5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-180.000000,0>translate<7.620000,0,60.960000> texture{col_thl}}
#ifndef(global_pack_JP5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-180.000000,0>translate<7.620000,0,63.500000> texture{col_thl}}
#ifndef(global_pack_JP5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-180.000000,0>translate<7.620000,0,66.040000> texture{col_thl}}
#ifndef(global_pack_JP5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-180.000000,0>translate<7.620000,0,68.580000> texture{col_thl}}
#ifndef(global_pack_JP6) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-0.000000,0>translate<91.440000,0,68.580000> texture{col_thl}}
#ifndef(global_pack_JP6) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-0.000000,0>translate<91.440000,0,66.040000> texture{col_thl}}
#ifndef(global_pack_JP6) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-0.000000,0>translate<91.440000,0,63.500000> texture{col_thl}}
#ifndef(global_pack_JP6) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-0.000000,0>translate<91.440000,0,60.960000> texture{col_thl}}
#ifndef(global_pack_JP6) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-0.000000,0>translate<91.440000,0,58.420000> texture{col_thl}}
#ifndef(global_pack_JP6) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-0.000000,0>translate<91.440000,0,55.880000> texture{col_thl}}
#ifndef(global_pack_JP6) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,1+global_tmp,0) rotate<0,-0.000000,0>translate<91.440000,0,53.340000> texture{col_thl}}
#ifndef(global_pack_LCD_CONTRAST) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.508000,1.000000,1,16,1+global_tmp,0) rotate<0,-0.000000,0>translate<24.130000,0,71.120000> texture{col_thl}}
#ifndef(global_pack_LCD_CONTRAST) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.508000,1.000000,1,16,1+global_tmp,0) rotate<0,-0.000000,0>translate<19.050000,0,73.660000> texture{col_thl}}
#ifndef(global_pack_LCD_CONTRAST) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.508000,1.000000,1,16,1+global_tmp,0) rotate<0,-0.000000,0>translate<19.050000,0,68.580000> texture{col_thl}}
#ifndef(global_pack_R1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<38.100000,0,68.580000> texture{col_thl}}
#ifndef(global_pack_R1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<48.260000,0,68.580000> texture{col_thl}}
#ifndef(global_pack_R3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<76.200000,0,68.580000> texture{col_thl}}
#ifndef(global_pack_R3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<86.360000,0,68.580000> texture{col_thl}}
#ifndef(global_pack_R4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<50.800000,0,68.580000> texture{col_thl}}
#ifndef(global_pack_R4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<60.960000,0,68.580000> texture{col_thl}}
#ifndef(global_pack_R5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<36.830000,0,54.610000> texture{col_thl}}
#ifndef(global_pack_R5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<36.830000,0,64.770000> texture{col_thl}}
#ifndef(global_pack_R6) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<31.750000,0,54.610000> texture{col_thl}}
#ifndef(global_pack_R6) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<31.750000,0,64.770000> texture{col_thl}}
#ifndef(global_pack_R7) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<43.180000,0,54.610000> texture{col_thl}}
#ifndef(global_pack_R7) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<43.180000,0,64.770000> texture{col_thl}}
#ifndef(global_pack_R8) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<63.500000,0,68.580000> texture{col_thl}}
#ifndef(global_pack_R8) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<73.660000,0,68.580000> texture{col_thl}}
//Pads/Vias
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<42.214800,0,63.779400> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<57.454800,0,69.697600> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<42.341800,0,62.458600> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<39.852600,0,62.865000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<46.558200,0,69.570600> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<50.165000,0,60.858400> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<50.647600,0,59.690000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<57.480200,0,56.642000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<60.985400,0,58.851800> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<44.348400,0,71.882000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<59.334400,0,59.309000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<47.980600,0,55.600600> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<56.083200,0,50.749200> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<42.138600,0,50.723800> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<42.621200,0,51.892200> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<52.882800,0,51.892200> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<56.642000,0,51.892200> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<60.985400,0,51.282600> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<32.816800,0,46.329600> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<59.918600,0,52.120800> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<37.058600,0,62.026800> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<36.220400,0,59.994800> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<61.163200,0,75.590400> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<34.188400,0,60.807600> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<58.089800,0,76.123800> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<34.188400,0,62.026800> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<49.784000,0,76.123800> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<52.349400,0,69.723000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<40.436800,0,53.619400> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<35.890200,0,51.333400> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<73.355200,0,70.408800> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<62.153800,0,59.359800> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<70.967600,0,65.481200> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<63.652400,0,60.198000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<78.308200,0,56.388000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<63.322200,0,47.244000> texture{col_thl}}
#end
#if(pcb_wires=on)
union{
//Signals
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<6.527800,-1.535000,55.422800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<6.527800,-1.535000,63.957200>}
box{<0,0,-0.127000><8.534400,0.035000,0.127000> rotate<0,90.000000,0> translate<6.527800,-1.535000,63.957200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<6.527800,-1.535000,55.422800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.289800,-1.535000,54.660800>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,44.997030,0> translate<6.527800,-1.535000,55.422800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.289800,-1.535000,54.076600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.289800,-1.535000,54.660800>}
box{<0,0,-0.127000><0.584200,0.035000,0.127000> rotate<0,90.000000,0> translate<7.289800,-1.535000,54.660800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<6.527800,-1.535000,63.957200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.518400,-1.535000,64.947800>}
box{<0,0,-0.127000><1.400920,0.035000,0.127000> rotate<0,-44.997030,0> translate<6.527800,-1.535000,63.957200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.289800,-1.535000,54.076600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.620000,-1.535000,53.340000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,65.850112,0> translate<7.289800,-1.535000,54.076600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.620000,0.000000,66.040000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.950200,0.000000,65.303400>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,65.850112,0> translate<7.620000,0.000000,66.040000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.620000,-1.535000,63.500000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<8.305800,-1.535000,63.119000>}
box{<0,0,-0.127000><0.784527,0.035000,0.127000> rotate<0,29.052687,0> translate<7.620000,-1.535000,63.500000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.620000,-1.535000,55.880000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<8.356600,-1.535000,55.549800>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,24.143948,0> translate<7.620000,-1.535000,55.880000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.620000,-1.535000,58.420000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<8.356600,-1.535000,58.089800>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,24.143948,0> translate<7.620000,-1.535000,58.420000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.620000,-1.535000,60.960000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<8.356600,-1.535000,60.629800>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,24.143948,0> translate<7.620000,-1.535000,60.960000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.620000,-1.535000,66.040000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<8.356600,-1.535000,66.370200>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-24.143948,0> translate<7.620000,-1.535000,66.040000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.620000,0.000000,68.580000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<8.356600,0.000000,68.249800>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,24.143948,0> translate<7.620000,0.000000,68.580000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.950200,0.000000,65.303400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<9.829800,0.000000,63.423800>}
box{<0,0,-0.127000><2.658156,0.035000,0.127000> rotate<0,44.997030,0> translate<7.950200,0.000000,65.303400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<9.829800,0.000000,48.996600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<9.829800,0.000000,63.423800>}
box{<0,0,-0.127000><14.427200,0.035000,0.127000> rotate<0,90.000000,0> translate<9.829800,0.000000,63.423800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<9.829800,0.000000,48.996600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<10.160000,0.000000,48.260000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,65.850112,0> translate<9.829800,0.000000,48.996600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<12.700000,0.000000,48.260000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<13.030200,0.000000,48.996600>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-65.850112,0> translate<12.700000,0.000000,48.260000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<13.030200,0.000000,48.996600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<13.030200,0.000000,59.004200>}
box{<0,0,-0.127000><10.007600,0.035000,0.127000> rotate<0,90.000000,0> translate<13.030200,0.000000,59.004200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.518400,-1.535000,64.947800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<13.868400,-1.535000,64.947800>}
box{<0,0,-0.127000><6.350000,0.035000,0.127000> rotate<0,0.000000,0> translate<7.518400,-1.535000,64.947800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<8.356600,-1.535000,55.549800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<14.579600,-1.535000,55.549800>}
box{<0,0,-0.127000><6.223000,0.035000,0.127000> rotate<0,0.000000,0> translate<8.356600,-1.535000,55.549800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<8.356600,-1.535000,58.089800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<14.579600,-1.535000,58.089800>}
box{<0,0,-0.127000><6.223000,0.035000,0.127000> rotate<0,0.000000,0> translate<8.356600,-1.535000,58.089800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<8.356600,0.000000,68.249800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<14.605000,0.000000,68.249800>}
box{<0,0,-0.127000><6.248400,0.035000,0.127000> rotate<0,0.000000,0> translate<8.356600,0.000000,68.249800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<8.356600,-1.535000,66.370200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.341600,-1.535000,73.355200>}
box{<0,0,-0.127000><9.878282,0.035000,0.127000> rotate<0,-44.997030,0> translate<8.356600,-1.535000,66.370200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.240000,0.000000,48.260000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.570200,0.000000,48.996600>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-65.850112,0> translate<15.240000,0.000000,48.260000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.570200,0.000000,48.996600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.570200,0.000000,60.477400>}
box{<0,0,-0.127000><11.480800,0.035000,0.127000> rotate<0,90.000000,0> translate<15.570200,0.000000,60.477400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<14.605000,0.000000,68.249800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.145000,0.000000,65.709800>}
box{<0,0,-0.127000><3.592102,0.035000,0.127000> rotate<0,44.997030,0> translate<14.605000,0.000000,68.249800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<13.030200,0.000000,59.004200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.500600,0.000000,63.474600>}
box{<0,0,-0.127000><6.322100,0.035000,0.127000> rotate<0,-44.997030,0> translate<13.030200,0.000000,59.004200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.145000,0.000000,65.709800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.780000,0.000000,64.770000>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,55.950370,0> translate<17.145000,0.000000,65.709800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.500600,0.000000,63.474600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.780000,0.000000,64.770000>}
box{<0,0,-0.127000><1.325189,0.035000,0.127000> rotate<0,-77.823405,0> translate<17.500600,0.000000,63.474600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.957800,0.000000,68.122800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.957800,0.000000,74.117200>}
box{<0,0,-0.127000><5.994400,0.035000,0.127000> rotate<0,90.000000,0> translate<17.957800,0.000000,74.117200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.341600,-1.535000,73.355200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<18.313400,-1.535000,73.355200>}
box{<0,0,-0.127000><2.971800,0.035000,0.127000> rotate<0,0.000000,0> translate<15.341600,-1.535000,73.355200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.780000,0.000000,57.150000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<18.415000,0.000000,58.089800>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,-55.950370,0> translate<17.780000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.780000,0.000000,48.260000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<18.516600,0.000000,48.590200>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-24.143948,0> translate<17.780000,0.000000,48.260000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.570200,0.000000,60.477400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<18.770600,0.000000,63.677800>}
box{<0,0,-0.127000><4.526049,0.035000,0.127000> rotate<0,-44.997030,0> translate<15.570200,0.000000,60.477400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.957800,0.000000,68.122800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<18.770600,0.000000,67.310000>}
box{<0,0,-0.127000><1.149473,0.035000,0.127000> rotate<0,44.997030,0> translate<17.957800,0.000000,68.122800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<18.770600,0.000000,63.677800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<18.770600,0.000000,67.310000>}
box{<0,0,-0.127000><3.632200,0.035000,0.127000> rotate<0,90.000000,0> translate<18.770600,0.000000,67.310000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<18.313400,-1.535000,73.355200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.050000,-1.535000,73.660000>}
box{<0,0,-0.127000><0.797172,0.035000,0.127000> rotate<0,-22.477951,0> translate<18.313400,-1.535000,73.355200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.957800,0.000000,74.117200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.050000,0.000000,75.209400>}
box{<0,0,-0.127000><1.544604,0.035000,0.127000> rotate<0,-44.997030,0> translate<17.957800,0.000000,74.117200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<18.516600,0.000000,48.590200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.100800,0.000000,48.590200>}
box{<0,0,-0.127000><0.584200,0.035000,0.127000> rotate<0,0.000000,0> translate<18.516600,0.000000,48.590200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<18.415000,0.000000,58.089800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.177000,0.000000,58.089800>}
box{<0,0,-0.127000><0.762000,0.035000,0.127000> rotate<0,0.000000,0> translate<18.415000,0.000000,58.089800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.050000,0.000000,68.580000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.354800,0.000000,67.843400>}
box{<0,0,-0.127000><0.797172,0.035000,0.127000> rotate<0,67.516110,0> translate<19.050000,0.000000,68.580000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.354800,0.000000,66.751200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.354800,0.000000,67.843400>}
box{<0,0,-0.127000><1.092200,0.035000,0.127000> rotate<0,90.000000,0> translate<19.354800,0.000000,67.843400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.354800,0.000000,66.751200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.040600,0.000000,66.065400>}
box{<0,0,-0.127000><0.969868,0.035000,0.127000> rotate<0,44.997030,0> translate<19.354800,0.000000,66.751200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.780000,-1.535000,64.770000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.320000,-1.535000,64.770000>}
box{<0,0,-0.127000><2.540000,0.035000,0.127000> rotate<0,0.000000,0> translate<17.780000,-1.535000,64.770000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.040600,0.000000,66.065400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.320000,0.000000,64.770000>}
box{<0,0,-0.127000><1.325189,0.035000,0.127000> rotate<0,77.823405,0> translate<20.040600,0.000000,66.065400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.320000,0.000000,57.150000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.955000,0.000000,58.089800>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,-55.950370,0> translate<20.320000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.320000,0.000000,48.260000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.056600,0.000000,48.590200>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-24.143948,0> translate<20.320000,0.000000,48.260000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<8.356600,-1.535000,60.629800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.463000,-1.535000,60.629800>}
box{<0,0,-0.127000><13.106400,0.035000,0.127000> rotate<0,0.000000,0> translate<8.356600,-1.535000,60.629800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.056600,0.000000,48.590200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.640800,0.000000,48.590200>}
box{<0,0,-0.127000><0.584200,0.035000,0.127000> rotate<0,0.000000,0> translate<21.056600,0.000000,48.590200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.955000,0.000000,58.089800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.717000,0.000000,58.089800>}
box{<0,0,-0.127000><0.762000,0.035000,0.127000> rotate<0,0.000000,0> translate<20.955000,0.000000,58.089800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.767800,-1.535000,48.361600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.767800,-1.535000,47.802800>}
box{<0,0,-0.127000><0.558800,0.035000,0.127000> rotate<0,-90.000000,0> translate<21.767800,-1.535000,47.802800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<14.579600,-1.535000,55.549800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.767800,-1.535000,48.361600>}
box{<0,0,-0.127000><10.165650,0.035000,0.127000> rotate<0,44.997030,0> translate<14.579600,-1.535000,55.549800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.320000,0.000000,64.770000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.860000,0.000000,64.770000>}
box{<0,0,-0.127000><2.540000,0.035000,0.127000> rotate<0,0.000000,0> translate<20.320000,0.000000,64.770000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.860000,0.000000,57.150000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<23.495000,0.000000,58.089800>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,-55.950370,0> translate<22.860000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.860000,0.000000,48.260000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<23.596600,0.000000,47.929800>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,24.143948,0> translate<22.860000,0.000000,48.260000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<23.596600,0.000000,47.929800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.180800,0.000000,47.929800>}
box{<0,0,-0.127000><0.584200,0.035000,0.127000> rotate<0,0.000000,0> translate<23.596600,0.000000,47.929800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.307800,-1.535000,48.361600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.307800,-1.535000,47.802800>}
box{<0,0,-0.127000><0.558800,0.035000,0.127000> rotate<0,-90.000000,0> translate<24.307800,-1.535000,47.802800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<14.579600,-1.535000,58.089800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.307800,-1.535000,48.361600>}
box{<0,0,-0.127000><13.757752,0.035000,0.127000> rotate<0,44.997030,0> translate<14.579600,-1.535000,58.089800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.130000,-1.535000,71.120000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.434800,-1.535000,70.383400>}
box{<0,0,-0.127000><0.797172,0.035000,0.127000> rotate<0,67.516110,0> translate<24.130000,-1.535000,71.120000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.434800,-1.535000,68.427600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.434800,-1.535000,70.383400>}
box{<0,0,-0.127000><1.955800,0.035000,0.127000> rotate<0,90.000000,0> translate<24.434800,-1.535000,70.383400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<8.305800,-1.535000,63.119000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.663400,-1.535000,63.119000>}
box{<0,0,-0.127000><16.357600,0.035000,0.127000> rotate<0,0.000000,0> translate<8.305800,-1.535000,63.119000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.177000,0.000000,58.089800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.866600,0.000000,63.779400>}
box{<0,0,-0.127000><8.046309,0.035000,0.127000> rotate<0,-44.997030,0> translate<19.177000,0.000000,58.089800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.130000,-1.535000,71.120000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.866600,-1.535000,71.424800>}
box{<0,0,-0.127000><0.797172,0.035000,0.127000> rotate<0,-22.477951,0> translate<24.130000,-1.535000,71.120000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.180800,0.000000,47.929800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.942800,0.000000,47.167800>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,44.997030,0> translate<24.180800,0.000000,47.929800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.767800,-1.535000,47.802800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.527000,-1.535000,44.043600>}
box{<0,0,-0.127000><5.316312,0.035000,0.127000> rotate<0,44.997030,0> translate<21.767800,-1.535000,47.802800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.400000,0.000000,48.260000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.730200,0.000000,48.996600>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-65.850112,0> translate<25.400000,0.000000,48.260000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.730200,0.000000,48.996600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.730200,0.000000,50.698400>}
box{<0,0,-0.127000><1.701800,0.035000,0.127000> rotate<0,90.000000,0> translate<25.730200,0.000000,50.698400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.942800,0.000000,47.167800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.857200,0.000000,47.167800>}
box{<0,0,-0.127000><0.914400,0.035000,0.127000> rotate<0,0.000000,0> translate<24.942800,0.000000,47.167800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<13.868400,-1.535000,64.947800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.339800,-1.535000,77.419200>}
box{<0,0,-0.127000><17.637223,0.035000,0.127000> rotate<0,-44.997030,0> translate<13.868400,-1.535000,64.947800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.857200,0.000000,47.167800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.847800,0.000000,48.158400>}
box{<0,0,-0.127000><1.400920,0.035000,0.127000> rotate<0,-44.997030,0> translate<25.857200,0.000000,47.167800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.847800,0.000000,48.158400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.847800,0.000000,51.130200>}
box{<0,0,-0.127000><2.971800,0.035000,0.127000> rotate<0,90.000000,0> translate<26.847800,0.000000,51.130200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.717000,0.000000,58.089800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.949400,0.000000,63.322200>}
box{<0,0,-0.127000><7.399731,0.035000,0.127000> rotate<0,-44.997030,0> translate<21.717000,0.000000,58.089800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.463000,-1.535000,60.629800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.203400,-1.535000,54.889400>}
box{<0,0,-0.127000><8.118152,0.035000,0.127000> rotate<0,44.997030,0> translate<21.463000,-1.535000,60.629800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.307800,-1.535000,47.802800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.609800,-1.535000,44.500800>}
box{<0,0,-0.127000><4.669733,0.035000,0.127000> rotate<0,44.997030,0> translate<24.307800,-1.535000,47.802800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<23.495000,0.000000,58.089800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.940000,0.000000,58.089800>}
box{<0,0,-0.127000><4.445000,0.035000,0.127000> rotate<0,0.000000,0> translate<23.495000,0.000000,58.089800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.940000,0.000000,48.260000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<28.676600,0.000000,47.929800>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,24.143948,0> translate<27.940000,0.000000,48.260000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<28.676600,0.000000,47.929800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<29.260800,0.000000,47.929800>}
box{<0,0,-0.127000><0.584200,0.035000,0.127000> rotate<0,0.000000,0> translate<28.676600,0.000000,47.929800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<29.260800,0.000000,47.929800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.022800,0.000000,47.167800>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,44.997030,0> translate<29.260800,0.000000,47.929800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.866600,-1.535000,71.424800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.403800,-1.535000,76.962000>}
box{<0,0,-0.127000><7.830783,0.035000,0.127000> rotate<0,-44.997030,0> translate<24.866600,-1.535000,71.424800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.050000,0.000000,73.660000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,0.000000,73.660000>}
box{<0,0,-0.127000><11.430000,0.035000,0.127000> rotate<0,0.000000,0> translate<19.050000,0.000000,73.660000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.203400,-1.535000,54.889400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.115000,-1.535000,54.889400>}
box{<0,0,-0.127000><3.911600,0.035000,0.127000> rotate<0,0.000000,0> translate<27.203400,-1.535000,54.889400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,-1.535000,48.260000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.216600,-1.535000,47.929800>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,24.143948,0> translate<30.480000,-1.535000,48.260000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,0.000000,73.660000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.216600,0.000000,73.990200>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-24.143948,0> translate<30.480000,0.000000,73.660000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.115000,-1.535000,54.889400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.750000,-1.535000,54.610000>}
box{<0,0,-0.127000><0.693750,0.035000,0.127000> rotate<0,23.747927,0> translate<31.115000,-1.535000,54.889400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.860000,0.000000,64.770000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.750000,0.000000,64.770000>}
box{<0,0,-0.127000><8.890000,0.035000,0.127000> rotate<0,0.000000,0> translate<22.860000,0.000000,64.770000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.216600,0.000000,73.990200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.800800,0.000000,73.990200>}
box{<0,0,-0.127000><0.584200,0.035000,0.127000> rotate<0,0.000000,0> translate<31.216600,0.000000,73.990200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.750000,-1.535000,54.610000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<32.029400,-1.535000,53.975000>}
box{<0,0,-0.127000><0.693750,0.035000,0.127000> rotate<0,66.246133,0> translate<31.750000,-1.535000,54.610000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.100800,0.000000,48.590200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<32.537400,0.000000,62.026800>}
box{<0,0,-0.127000><19.002222,0.035000,0.127000> rotate<0,-44.997030,0> translate<19.100800,0.000000,48.590200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.800800,0.000000,73.990200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<32.562800,0.000000,74.752200>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,-44.997030,0> translate<31.800800,0.000000,73.990200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.940000,0.000000,58.089800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<32.715200,0.000000,62.865000>}
box{<0,0,-0.127000><6.753153,0.035000,0.127000> rotate<0,-44.997030,0> translate<27.940000,0.000000,58.089800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.216600,-1.535000,47.929800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<32.816800,-1.535000,46.329600>}
box{<0,0,-0.127000><2.263025,0.035000,0.127000> rotate<0,44.997030,0> translate<31.216600,-1.535000,47.929800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.663400,-1.535000,63.119000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<32.893000,-1.535000,54.889400>}
box{<0,0,-0.127000><11.638412,0.035000,0.127000> rotate<0,44.997030,0> translate<24.663400,-1.535000,63.119000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.020000,-1.535000,73.660000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.350200,-1.535000,72.923400>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,65.850112,0> translate<33.020000,-1.535000,73.660000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.350200,-1.535000,60.452000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.350200,-1.535000,72.923400>}
box{<0,0,-0.127000><12.471400,0.035000,0.127000> rotate<0,90.000000,0> translate<33.350200,-1.535000,72.923400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.020000,0.000000,48.260000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.756600,0.000000,48.590200>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-24.143948,0> translate<33.020000,0.000000,48.260000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.640800,0.000000,48.590200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.858200,0.000000,60.807600>}
box{<0,0,-0.127000><17.278013,0.035000,0.127000> rotate<0,-44.997030,0> translate<21.640800,0.000000,48.590200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.112200,-1.535000,51.892200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.112200,-1.535000,48.158400>}
box{<0,0,-0.127000><3.733800,0.035000,0.127000> rotate<0,-90.000000,0> translate<34.112200,-1.535000,48.158400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<32.029400,-1.535000,53.975000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.112200,-1.535000,51.892200>}
box{<0,0,-0.127000><2.945524,0.035000,0.127000> rotate<0,44.997030,0> translate<32.029400,-1.535000,53.975000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.858200,0.000000,60.807600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.188400,0.000000,60.807600>}
box{<0,0,-0.127000><0.330200,0.035000,0.127000> rotate<0,0.000000,0> translate<33.858200,0.000000,60.807600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<32.537400,0.000000,62.026800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.188400,0.000000,62.026800>}
box{<0,0,-0.127000><1.651000,0.035000,0.127000> rotate<0,0.000000,0> translate<32.537400,0.000000,62.026800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.188400,-1.535000,62.026800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.188400,-1.535000,63.550800>}
box{<0,0,-0.127000><1.524000,0.035000,0.127000> rotate<0,90.000000,0> translate<34.188400,-1.535000,63.550800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.756600,0.000000,48.590200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.340800,0.000000,48.590200>}
box{<0,0,-0.127000><0.584200,0.035000,0.127000> rotate<0,0.000000,0> translate<33.756600,0.000000,48.590200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.847800,0.000000,51.130200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.712400,0.000000,59.994800>}
box{<0,0,-0.127000><12.536438,0.035000,0.127000> rotate<0,-44.997030,0> translate<26.847800,0.000000,51.130200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.188400,-1.535000,60.807600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.763200,-1.535000,62.382400>}
box{<0,0,-0.127000><2.227104,0.035000,0.127000> rotate<0,-44.997030,0> translate<34.188400,-1.535000,60.807600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.763200,-1.535000,62.382400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.763200,-1.535000,62.585600>}
box{<0,0,-0.127000><0.203200,0.035000,0.127000> rotate<0,90.000000,0> translate<35.763200,-1.535000,62.585600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.560000,-1.535000,48.260000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.890200,-1.535000,48.996600>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-65.850112,0> translate<35.560000,-1.535000,48.260000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.890200,-1.535000,48.996600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.890200,-1.535000,51.333400>}
box{<0,0,-0.127000><2.336800,0.035000,0.127000> rotate<0,90.000000,0> translate<35.890200,-1.535000,51.333400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.112200,-1.535000,48.158400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.941000,-1.535000,46.329600>}
box{<0,0,-0.127000><2.586314,0.035000,0.127000> rotate<0,44.997030,0> translate<34.112200,-1.535000,48.158400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<32.893000,-1.535000,54.889400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.195000,-1.535000,54.889400>}
box{<0,0,-0.127000><3.302000,0.035000,0.127000> rotate<0,0.000000,0> translate<32.893000,-1.535000,54.889400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.712400,0.000000,59.994800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.220400,0.000000,59.994800>}
box{<0,0,-0.127000><0.508000,0.035000,0.127000> rotate<0,0.000000,0> translate<35.712400,0.000000,59.994800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.220400,-1.535000,59.994800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.220400,-1.535000,62.382400>}
box{<0,0,-0.127000><2.387600,0.035000,0.127000> rotate<0,90.000000,0> translate<36.220400,-1.535000,62.382400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.560000,-1.535000,73.660000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.296600,-1.535000,73.329800>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,24.143948,0> translate<35.560000,-1.535000,73.660000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.195000,-1.535000,54.889400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.830000,-1.535000,54.610000>}
box{<0,0,-0.127000><0.693750,0.035000,0.127000> rotate<0,23.747927,0> translate<36.195000,-1.535000,54.889400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.750000,0.000000,64.770000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.830000,0.000000,64.770000>}
box{<0,0,-0.127000><5.080000,0.035000,0.127000> rotate<0,0.000000,0> translate<31.750000,0.000000,64.770000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.296600,-1.535000,73.329800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.880800,-1.535000,73.329800>}
box{<0,0,-0.127000><0.584200,0.035000,0.127000> rotate<0,0.000000,0> translate<36.296600,-1.535000,73.329800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.763200,-1.535000,62.585600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.957000,-1.535000,63.779400>}
box{<0,0,-0.127000><1.688288,0.035000,0.127000> rotate<0,-44.997030,0> translate<35.763200,-1.535000,62.585600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.007800,-1.535000,53.975000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.007800,-1.535000,47.802800>}
box{<0,0,-0.127000><6.172200,0.035000,0.127000> rotate<0,-90.000000,0> translate<37.007800,-1.535000,47.802800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.830000,-1.535000,54.610000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.007800,-1.535000,53.975000>}
box{<0,0,-0.127000><0.659422,0.035000,0.127000> rotate<0,74.352846,0> translate<36.830000,-1.535000,54.610000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.730200,0.000000,50.698400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.058600,0.000000,62.026800>}
box{<0,0,-0.127000><16.020777,0.035000,0.127000> rotate<0,-44.997030,0> translate<25.730200,0.000000,50.698400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.220400,-1.535000,62.382400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.160200,-1.535000,63.322200>}
box{<0,0,-0.127000><1.329078,0.035000,0.127000> rotate<0,-44.997030,0> translate<36.220400,-1.535000,62.382400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.957000,-1.535000,63.779400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.566600,-1.535000,63.779400>}
box{<0,0,-0.127000><0.609600,0.035000,0.127000> rotate<0,0.000000,0> translate<36.957000,-1.535000,63.779400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.007800,-1.535000,47.802800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.642800,-1.535000,47.167800>}
box{<0,0,-0.127000><0.898026,0.035000,0.127000> rotate<0,44.997030,0> translate<37.007800,-1.535000,47.802800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.340800,0.000000,48.590200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.642800,0.000000,51.892200>}
box{<0,0,-0.127000><4.669733,0.035000,0.127000> rotate<0,-44.997030,0> translate<34.340800,0.000000,48.590200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.160200,-1.535000,63.322200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.769800,-1.535000,63.322200>}
box{<0,0,-0.127000><0.609600,0.035000,0.127000> rotate<0,0.000000,0> translate<37.160200,-1.535000,63.322200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.058600,-1.535000,62.026800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.820600,-1.535000,62.026800>}
box{<0,0,-0.127000><0.762000,0.035000,0.127000> rotate<0,0.000000,0> translate<37.058600,-1.535000,62.026800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.830000,0.000000,64.770000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.100000,0.000000,64.770000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,0.000000,0> translate<36.830000,0.000000,64.770000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.100000,0.000000,64.770000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.100000,0.000000,68.580000>}
box{<0,0,-0.127000><3.810000,0.035000,0.127000> rotate<0,90.000000,0> translate<38.100000,0.000000,68.580000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.890200,0.000000,51.333400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.176200,0.000000,53.619400>}
box{<0,0,-0.127000><3.232892,0.035000,0.127000> rotate<0,-44.997030,0> translate<35.890200,0.000000,51.333400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.350200,-1.535000,60.452000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.201600,-1.535000,55.600600>}
box{<0,0,-0.127000><6.860916,0.035000,0.127000> rotate<0,44.997030,0> translate<33.350200,-1.535000,60.452000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.188400,-1.535000,63.550800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.227000,-1.535000,67.589400>}
box{<0,0,-0.127000><5.711443,0.035000,0.127000> rotate<0,-44.997030,0> translate<34.188400,-1.535000,63.550800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.880800,-1.535000,73.329800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.328600,-1.535000,71.882000>}
box{<0,0,-0.127000><2.047498,0.035000,0.127000> rotate<0,44.997030,0> translate<36.880800,-1.535000,73.329800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.100000,0.000000,73.660000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.430200,0.000000,72.923400>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,65.850112,0> translate<38.100000,0.000000,73.660000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.430200,0.000000,70.942200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.430200,0.000000,72.923400>}
box{<0,0,-0.127000><1.981200,0.035000,0.127000> rotate<0,90.000000,0> translate<38.430200,0.000000,72.923400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.100000,-1.535000,48.260000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.836600,-1.535000,48.590200>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-24.143948,0> translate<38.100000,-1.535000,48.260000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.866600,0.000000,63.779400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.912800,0.000000,63.779400>}
box{<0,0,-0.127000><14.046200,0.035000,0.127000> rotate<0,0.000000,0> translate<24.866600,0.000000,63.779400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.949400,0.000000,63.322200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<39.116000,0.000000,63.322200>}
box{<0,0,-0.127000><12.166600,0.035000,0.127000> rotate<0,0.000000,0> translate<26.949400,0.000000,63.322200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.912800,0.000000,63.779400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<39.293800,0.000000,64.160400>}
box{<0,0,-0.127000><0.538815,0.035000,0.127000> rotate<0,-44.997030,0> translate<38.912800,0.000000,63.779400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<39.116000,0.000000,63.322200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<39.497000,0.000000,63.703200>}
box{<0,0,-0.127000><0.538815,0.035000,0.127000> rotate<0,-44.997030,0> translate<39.116000,0.000000,63.322200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<32.715200,0.000000,62.865000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<39.852600,0.000000,62.865000>}
box{<0,0,-0.127000><7.137400,0.035000,0.127000> rotate<0,0.000000,0> translate<32.715200,0.000000,62.865000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.836600,-1.535000,48.590200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.055800,-1.535000,49.809400>}
box{<0,0,-0.127000><1.724209,0.035000,0.127000> rotate<0,-44.997030,0> translate<38.836600,-1.535000,48.590200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.176200,0.000000,53.619400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.436800,0.000000,53.619400>}
box{<0,0,-0.127000><2.260600,0.035000,0.127000> rotate<0,0.000000,0> translate<38.176200,0.000000,53.619400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.566600,-1.535000,63.779400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.919400,-1.535000,67.132200>}
box{<0,0,-0.127000><4.741575,0.035000,0.127000> rotate<0,-44.997030,0> translate<37.566600,-1.535000,63.779400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.640000,0.000000,73.660000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.970200,0.000000,72.923400>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,65.850112,0> translate<40.640000,0.000000,73.660000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.970200,0.000000,69.062600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.970200,0.000000,72.923400>}
box{<0,0,-0.127000><3.860800,0.035000,0.127000> rotate<0,90.000000,0> translate<40.970200,0.000000,72.923400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<39.497000,0.000000,63.703200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.097200,0.000000,63.703200>}
box{<0,0,-0.127000><1.600200,0.035000,0.127000> rotate<0,0.000000,0> translate<39.497000,0.000000,63.703200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.769800,-1.535000,63.322200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.122600,-1.535000,66.675000>}
box{<0,0,-0.127000><4.741575,0.035000,0.127000> rotate<0,-44.997030,0> translate<37.769800,-1.535000,63.322200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.227000,-1.535000,67.589400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.249600,-1.535000,67.589400>}
box{<0,0,-0.127000><3.022600,0.035000,0.127000> rotate<0,0.000000,0> translate<38.227000,-1.535000,67.589400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.640000,-1.535000,48.260000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.376600,-1.535000,48.590200>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-24.143948,0> translate<40.640000,-1.535000,48.260000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.919400,-1.535000,67.132200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.452800,-1.535000,67.132200>}
box{<0,0,-0.127000><0.533400,0.035000,0.127000> rotate<0,0.000000,0> translate<40.919400,-1.535000,67.132200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.122600,-1.535000,66.675000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.656000,-1.535000,66.675000>}
box{<0,0,-0.127000><0.533400,0.035000,0.127000> rotate<0,0.000000,0> translate<41.122600,-1.535000,66.675000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<39.293800,0.000000,64.160400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.833800,0.000000,64.160400>}
box{<0,0,-0.127000><2.540000,0.035000,0.127000> rotate<0,0.000000,0> translate<39.293800,0.000000,64.160400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.376600,-1.535000,48.590200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.138600,-1.535000,49.352200>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,-44.997030,0> translate<41.376600,-1.535000,48.590200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.138600,0.000000,50.723800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.138600,0.000000,49.707800>}
box{<0,0,-0.127000><1.016000,0.035000,0.127000> rotate<0,-90.000000,0> translate<42.138600,0.000000,49.707800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.434800,-1.535000,68.427600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.138600,-1.535000,50.723800>}
box{<0,0,-0.127000><25.036954,0.035000,0.127000> rotate<0,44.997030,0> translate<24.434800,-1.535000,68.427600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.833800,0.000000,64.160400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.214800,0.000000,63.779400>}
box{<0,0,-0.127000><0.538815,0.035000,0.127000> rotate<0,44.997030,0> translate<41.833800,0.000000,64.160400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.097200,0.000000,63.703200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.341800,0.000000,62.458600>}
box{<0,0,-0.127000><1.760130,0.035000,0.127000> rotate<0,44.997030,0> translate<41.097200,0.000000,63.703200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.642800,0.000000,51.892200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.621200,0.000000,51.892200>}
box{<0,0,-0.127000><4.978400,0.035000,0.127000> rotate<0,0.000000,0> translate<37.642800,0.000000,51.892200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.138600,0.000000,49.707800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.849800,0.000000,48.996600>}
box{<0,0,-0.127000><1.005789,0.035000,0.127000> rotate<0,44.997030,0> translate<42.138600,0.000000,49.707800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.849800,0.000000,48.996600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.180000,0.000000,48.260000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,65.850112,0> translate<42.849800,0.000000,48.996600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.180000,0.000000,64.770000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.180000,0.000000,54.610000>}
box{<0,0,-0.127000><10.160000,0.035000,0.127000> rotate<0,-90.000000,0> translate<43.180000,0.000000,54.610000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.100000,0.000000,64.770000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.180000,0.000000,64.770000>}
box{<0,0,-0.127000><5.080000,0.035000,0.127000> rotate<0,0.000000,0> translate<38.100000,0.000000,64.770000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.459400,0.000000,53.975000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.459400,0.000000,50.927000>}
box{<0,0,-0.127000><3.048000,0.035000,0.127000> rotate<0,-90.000000,0> translate<43.459400,0.000000,50.927000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.180000,0.000000,54.610000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.459400,0.000000,53.975000>}
box{<0,0,-0.127000><0.693750,0.035000,0.127000> rotate<0,66.246133,0> translate<43.180000,0.000000,54.610000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.180000,0.000000,73.660000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.510200,0.000000,72.923400>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,65.850112,0> translate<43.180000,0.000000,73.660000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.510200,0.000000,67.513200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.510200,0.000000,72.923400>}
box{<0,0,-0.127000><5.410200,0.035000,0.127000> rotate<0,90.000000,0> translate<43.510200,0.000000,72.923400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.180000,-1.535000,64.770000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.561000,-1.535000,65.303400>}
box{<0,0,-0.127000><0.655497,0.035000,0.127000> rotate<0,-54.458728,0> translate<43.180000,-1.535000,64.770000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.436800,-1.535000,53.619400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.611800,-1.535000,53.619400>}
box{<0,0,-0.127000><3.175000,0.035000,0.127000> rotate<0,0.000000,0> translate<40.436800,-1.535000,53.619400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.611800,-1.535000,53.619400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.662600,-1.535000,53.670200>}
box{<0,0,-0.127000><0.071842,0.035000,0.127000> rotate<0,-44.997030,0> translate<43.611800,-1.535000,53.619400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.348400,0.000000,71.882000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.348400,0.000000,67.868800>}
box{<0,0,-0.127000><4.013200,0.035000,0.127000> rotate<0,-90.000000,0> translate<44.348400,0.000000,67.868800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.328600,-1.535000,71.882000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.348400,-1.535000,71.882000>}
box{<0,0,-0.127000><6.019800,0.035000,0.127000> rotate<0,0.000000,0> translate<38.328600,-1.535000,71.882000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.459400,0.000000,50.927000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.389800,0.000000,48.996600>}
box{<0,0,-0.127000><2.729998,0.035000,0.127000> rotate<0,44.997030,0> translate<43.459400,0.000000,50.927000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.389800,0.000000,48.996600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.720000,0.000000,48.260000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,65.850112,0> translate<45.389800,0.000000,48.996600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<39.852600,-1.535000,62.865000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<46.558200,-1.535000,69.570600>}
box{<0,0,-0.127000><9.483150,0.035000,0.127000> rotate<0,-44.997030,0> translate<39.852600,-1.535000,62.865000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.561000,-1.535000,65.303400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<47.828200,-1.535000,69.570600>}
box{<0,0,-0.127000><6.034732,0.035000,0.127000> rotate<0,-44.997030,0> translate<43.561000,-1.535000,65.303400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.201600,-1.535000,55.600600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<47.980600,-1.535000,55.600600>}
box{<0,0,-0.127000><9.779000,0.035000,0.127000> rotate<0,0.000000,0> translate<38.201600,-1.535000,55.600600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.820600,-1.535000,62.026800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.361600,-1.535000,72.567800>}
box{<0,0,-0.127000><14.907225,0.035000,0.127000> rotate<0,-44.997030,0> translate<37.820600,-1.535000,62.026800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.430200,0.000000,70.942200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.844200,0.000000,60.528200>}
box{<0,0,-0.127000><14.727620,0.035000,0.127000> rotate<0,44.997030,0> translate<38.430200,0.000000,70.942200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.844200,0.000000,60.299600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.844200,0.000000,60.528200>}
box{<0,0,-0.127000><0.228600,0.035000,0.127000> rotate<0,90.000000,0> translate<48.844200,0.000000,60.528200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.260000,0.000000,68.580000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.895000,0.000000,68.300600>}
box{<0,0,-0.127000><0.693750,0.035000,0.127000> rotate<0,23.747927,0> translate<48.260000,0.000000,68.580000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<47.828200,-1.535000,69.570600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.945800,-1.535000,69.570600>}
box{<0,0,-0.127000><1.117600,0.035000,0.127000> rotate<0,0.000000,0> translate<47.828200,-1.535000,69.570600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.260000,-1.535000,48.260000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.996600,-1.535000,48.590200>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-24.143948,0> translate<48.260000,-1.535000,48.260000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.970200,0.000000,69.062600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.301400,0.000000,60.731400>}
box{<0,0,-0.127000><11.782096,0.035000,0.127000> rotate<0,44.997030,0> translate<40.970200,0.000000,69.062600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.301400,0.000000,60.502800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.301400,0.000000,60.731400>}
box{<0,0,-0.127000><0.228600,0.035000,0.127000> rotate<0,90.000000,0> translate<49.301400,0.000000,60.731400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<32.562800,0.000000,74.752200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.301400,0.000000,74.752200>}
box{<0,0,-0.127000><16.738600,0.035000,0.127000> rotate<0,0.000000,0> translate<32.562800,0.000000,74.752200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<46.558200,0.000000,69.570600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.453800,0.000000,69.570600>}
box{<0,0,-0.127000><2.895600,0.035000,0.127000> rotate<0,0.000000,0> translate<46.558200,0.000000,69.570600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.452800,-1.535000,67.132200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.606200,-1.535000,75.285600>}
box{<0,0,-0.127000><11.530649,0.035000,0.127000> rotate<0,-44.997030,0> translate<41.452800,-1.535000,67.132200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.895000,0.000000,68.300600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.657000,0.000000,68.300600>}
box{<0,0,-0.127000><0.762000,0.035000,0.127000> rotate<0,0.000000,0> translate<48.895000,0.000000,68.300600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.341800,-1.535000,62.458600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.758600,-1.535000,62.458600>}
box{<0,0,-0.127000><7.416800,0.035000,0.127000> rotate<0,0.000000,0> translate<42.341800,-1.535000,62.458600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.249600,-1.535000,67.589400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.784000,-1.535000,76.123800>}
box{<0,0,-0.127000><12.069464,0.035000,0.127000> rotate<0,-44.997030,0> translate<41.249600,-1.535000,67.589400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.656000,-1.535000,66.675000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.809400,-1.535000,74.828400>}
box{<0,0,-0.127000><11.530649,0.035000,0.127000> rotate<0,-44.997030,0> translate<41.656000,-1.535000,66.675000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.301400,0.000000,74.752200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.063400,0.000000,73.990200>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,44.997030,0> translate<49.301400,0.000000,74.752200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.301400,0.000000,60.502800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.114200,0.000000,59.690000>}
box{<0,0,-0.127000><1.149473,0.035000,0.127000> rotate<0,44.997030,0> translate<49.301400,0.000000,60.502800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.510200,0.000000,67.513200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.165000,0.000000,60.858400>}
box{<0,0,-0.127000><9.411308,0.035000,0.127000> rotate<0,44.997030,0> translate<43.510200,0.000000,67.513200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.453800,0.000000,69.570600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.165000,0.000000,68.859400>}
box{<0,0,-0.127000><1.005789,0.035000,0.127000> rotate<0,44.997030,0> translate<49.453800,0.000000,69.570600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.844200,0.000000,60.299600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.292000,0.000000,58.851800>}
box{<0,0,-0.127000><2.047498,0.035000,0.127000> rotate<0,44.997030,0> translate<48.844200,0.000000,60.299600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.657000,0.000000,68.300600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.368200,0.000000,67.589400>}
box{<0,0,-0.127000><1.005789,0.035000,0.127000> rotate<0,44.997030,0> translate<49.657000,0.000000,68.300600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.114200,0.000000,59.690000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.647600,0.000000,59.690000>}
box{<0,0,-0.127000><0.533400,0.035000,0.127000> rotate<0,0.000000,0> translate<50.114200,0.000000,59.690000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.165000,-1.535000,60.858400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.698400,-1.535000,60.858400>}
box{<0,0,-0.127000><0.533400,0.035000,0.127000> rotate<0,0.000000,0> translate<50.165000,-1.535000,60.858400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.165000,0.000000,68.859400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.800000,0.000000,68.580000>}
box{<0,0,-0.127000><0.693750,0.035000,0.127000> rotate<0,23.747927,0> translate<50.165000,0.000000,68.859400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.063400,0.000000,73.990200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.800000,0.000000,73.660000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,24.143948,0> translate<50.063400,0.000000,73.990200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.800000,0.000000,68.580000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.054000,0.000000,69.215000>}
box{<0,0,-0.127000><0.683916,0.035000,0.127000> rotate<0,-68.194090,0> translate<50.800000,0.000000,68.580000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.054000,0.000000,69.215000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.054000,0.000000,70.281800>}
box{<0,0,-0.127000><1.066800,0.035000,0.127000> rotate<0,90.000000,0> translate<51.054000,0.000000,70.281800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.647600,-1.535000,59.690000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.181000,-1.535000,59.690000>}
box{<0,0,-0.127000><0.533400,0.035000,0.127000> rotate<0,0.000000,0> translate<50.647600,-1.535000,59.690000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.368200,0.000000,67.589400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.231800,0.000000,67.589400>}
box{<0,0,-0.127000><0.863600,0.035000,0.127000> rotate<0,0.000000,0> translate<50.368200,0.000000,67.589400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.361600,-1.535000,72.567800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.257200,-1.535000,72.567800>}
box{<0,0,-0.127000><2.895600,0.035000,0.127000> rotate<0,0.000000,0> translate<48.361600,-1.535000,72.567800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.662600,-1.535000,53.670200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.435000,-1.535000,53.670200>}
box{<0,0,-0.127000><7.772400,0.035000,0.127000> rotate<0,0.000000,0> translate<43.662600,-1.535000,53.670200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.511200,0.000000,69.367400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.511200,0.000000,70.078600>}
box{<0,0,-0.127000><0.711200,0.035000,0.127000> rotate<0,90.000000,0> translate<51.511200,0.000000,70.078600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.214800,-1.535000,63.779400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.536600,-1.535000,63.779400>}
box{<0,0,-0.127000><9.321800,0.035000,0.127000> rotate<0,0.000000,0> translate<42.214800,-1.535000,63.779400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.800000,0.000000,73.660000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.536600,0.000000,73.329800>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,24.143948,0> translate<50.800000,0.000000,73.660000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.758600,-1.535000,62.458600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.638200,-1.535000,60.579000>}
box{<0,0,-0.127000><2.658156,0.035000,0.127000> rotate<0,44.997030,0> translate<49.758600,-1.535000,62.458600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.231800,0.000000,67.589400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.790600,0.000000,68.148200>}
box{<0,0,-0.127000><0.790263,0.035000,0.127000> rotate<0,-44.997030,0> translate<51.231800,0.000000,67.589400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.511200,0.000000,69.367400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.790600,0.000000,69.088000>}
box{<0,0,-0.127000><0.395131,0.035000,0.127000> rotate<0,44.997030,0> translate<51.511200,0.000000,69.367400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.790600,0.000000,68.148200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.790600,0.000000,69.088000>}
box{<0,0,-0.127000><0.939800,0.035000,0.127000> rotate<0,90.000000,0> translate<51.790600,0.000000,69.088000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.054000,0.000000,70.281800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.790600,0.000000,71.018400>}
box{<0,0,-0.127000><1.041710,0.035000,0.127000> rotate<0,-44.997030,0> translate<51.054000,0.000000,70.281800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.055800,-1.535000,49.809400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.993800,-1.535000,49.809400>}
box{<0,0,-0.127000><11.938000,0.035000,0.127000> rotate<0,0.000000,0> translate<40.055800,-1.535000,49.809400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.511200,0.000000,70.078600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.993800,0.000000,70.561200>}
box{<0,0,-0.127000><0.682499,0.035000,0.127000> rotate<0,-44.997030,0> translate<51.511200,0.000000,70.078600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.435000,-1.535000,53.670200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.070000,-1.535000,54.610000>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,-55.950370,0> translate<51.435000,-1.535000,53.670200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.606200,-1.535000,75.285600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.095400,-1.535000,75.285600>}
box{<0,0,-0.127000><2.489200,0.035000,0.127000> rotate<0,0.000000,0> translate<49.606200,-1.535000,75.285600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.138600,-1.535000,49.352200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.197000,-1.535000,49.352200>}
box{<0,0,-0.127000><10.058400,0.035000,0.127000> rotate<0,0.000000,0> translate<42.138600,-1.535000,49.352200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.257200,-1.535000,72.567800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.247800,-1.535000,73.558400>}
box{<0,0,-0.127000><1.400920,0.035000,0.127000> rotate<0,-44.997030,0> translate<51.257200,-1.535000,72.567800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.247800,-1.535000,73.558400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.247800,-1.535000,74.117200>}
box{<0,0,-0.127000><0.558800,0.035000,0.127000> rotate<0,90.000000,0> translate<52.247800,-1.535000,74.117200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.809400,-1.535000,74.828400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.298600,-1.535000,74.828400>}
box{<0,0,-0.127000><2.489200,0.035000,0.127000> rotate<0,0.000000,0> translate<49.809400,-1.535000,74.828400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.070000,0.000000,62.230000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.349400,0.000000,63.525400>}
box{<0,0,-0.127000><1.325189,0.035000,0.127000> rotate<0,-77.823405,0> translate<52.070000,0.000000,62.230000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.349400,0.000000,69.723000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.349400,0.000000,63.525400>}
box{<0,0,-0.127000><6.197600,0.035000,0.127000> rotate<0,-90.000000,0> translate<52.349400,0.000000,63.525400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.945800,-1.535000,69.570600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.654200,-1.535000,73.279000>}
box{<0,0,-0.127000><5.244470,0.035000,0.127000> rotate<0,-44.997030,0> translate<48.945800,-1.535000,69.570600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.070000,0.000000,54.610000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.705000,0.000000,55.549800>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,-55.950370,0> translate<52.070000,0.000000,54.610000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.993800,0.000000,70.561200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.705000,0.000000,70.561200>}
box{<0,0,-0.127000><0.711200,0.035000,0.127000> rotate<0,0.000000,0> translate<51.993800,0.000000,70.561200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.298600,-1.535000,74.828400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.755800,-1.535000,75.285600>}
box{<0,0,-0.127000><0.646578,0.035000,0.127000> rotate<0,-44.997030,0> translate<52.298600,-1.535000,74.828400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<47.980600,0.000000,55.600600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.832000,0.000000,50.749200>}
box{<0,0,-0.127000><6.860916,0.035000,0.127000> rotate<0,44.997030,0> translate<47.980600,0.000000,55.600600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.621200,-1.535000,51.892200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.882800,-1.535000,51.892200>}
box{<0,0,-0.127000><10.261600,0.035000,0.127000> rotate<0,0.000000,0> translate<42.621200,-1.535000,51.892200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.247800,-1.535000,74.117200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.882800,-1.535000,74.752200>}
box{<0,0,-0.127000><0.898026,0.035000,0.127000> rotate<0,-44.997030,0> translate<52.247800,-1.535000,74.117200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.348400,0.000000,67.868800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.908200,0.000000,59.309000>}
box{<0,0,-0.127000><12.105385,0.035000,0.127000> rotate<0,44.997030,0> translate<44.348400,0.000000,67.868800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.790600,0.000000,71.018400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.908200,0.000000,71.018400>}
box{<0,0,-0.127000><1.117600,0.035000,0.127000> rotate<0,0.000000,0> translate<51.790600,0.000000,71.018400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.095400,-1.535000,75.285600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.933600,-1.535000,76.123800>}
box{<0,0,-0.127000><1.185394,0.035000,0.127000> rotate<0,-44.997030,0> translate<52.095400,-1.535000,75.285600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.654200,-1.535000,73.279000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.340000,-1.535000,73.660000>}
box{<0,0,-0.127000><0.784527,0.035000,0.127000> rotate<0,-29.052687,0> translate<52.654200,-1.535000,73.279000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.996600,-1.535000,48.590200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.390800,-1.535000,48.590200>}
box{<0,0,-0.127000><4.394200,0.035000,0.127000> rotate<0,0.000000,0> translate<48.996600,-1.535000,48.590200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.050000,0.000000,75.209400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.924200,0.000000,75.209400>}
box{<0,0,-0.127000><34.874200,0.035000,0.127000> rotate<0,0.000000,0> translate<19.050000,0.000000,75.209400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.698400,-1.535000,60.858400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.076600,-1.535000,57.480200>}
box{<0,0,-0.127000><4.777496,0.035000,0.127000> rotate<0,44.997030,0> translate<50.698400,-1.535000,60.858400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.340000,0.000000,73.660000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.076600,0.000000,73.329800>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,24.143948,0> translate<53.340000,0.000000,73.660000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.390800,-1.535000,48.590200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.152800,-1.535000,49.352200>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,-44.997030,0> translate<53.390800,-1.535000,48.590200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.181000,-1.535000,59.690000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.229000,-1.535000,56.642000>}
box{<0,0,-0.127000><4.310523,0.035000,0.127000> rotate<0,44.997030,0> translate<51.181000,-1.535000,59.690000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.993800,-1.535000,49.809400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.330600,-1.535000,52.146200>}
box{<0,0,-0.127000><3.304734,0.035000,0.127000> rotate<0,-44.997030,0> translate<51.993800,-1.535000,49.809400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.330600,-1.535000,52.146200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.330600,-1.535000,53.314600>}
box{<0,0,-0.127000><1.168400,0.035000,0.127000> rotate<0,90.000000,0> translate<54.330600,-1.535000,53.314600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.330600,-1.535000,53.314600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.610000,-1.535000,54.610000>}
box{<0,0,-0.127000><1.325189,0.035000,0.127000> rotate<0,-77.823405,0> translate<54.330600,-1.535000,53.314600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.076600,0.000000,73.329800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.838600,0.000000,72.567800>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,44.997030,0> translate<54.076600,0.000000,73.329800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.610000,0.000000,54.610000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.889400,0.000000,55.905400>}
box{<0,0,-0.127000><1.325189,0.035000,0.127000> rotate<0,-77.823405,0> translate<54.610000,0.000000,54.610000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.610000,-1.535000,62.230000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.889400,-1.535000,63.525400>}
box{<0,0,-0.127000><1.325189,0.035000,0.127000> rotate<0,-77.823405,0> translate<54.610000,-1.535000,62.230000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.889400,-1.535000,65.938400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.889400,-1.535000,63.525400>}
box{<0,0,-0.127000><2.413000,0.035000,0.127000> rotate<0,-90.000000,0> translate<54.889400,-1.535000,63.525400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.924200,0.000000,75.209400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.143400,0.000000,73.990200>}
box{<0,0,-0.127000><1.724209,0.035000,0.127000> rotate<0,44.997030,0> translate<53.924200,0.000000,75.209400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.610000,0.000000,48.260000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.245000,0.000000,48.691800>}
box{<0,0,-0.127000><0.767904,0.035000,0.127000> rotate<0,-34.213444,0> translate<54.610000,0.000000,48.260000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.705000,0.000000,55.549800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.549800,0.000000,58.394600>}
box{<0,0,-0.127000><4.023155,0.035000,0.127000> rotate<0,-44.997030,0> translate<52.705000,0.000000,55.549800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.349400,-1.535000,69.723000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.549800,-1.535000,72.923400>}
box{<0,0,-0.127000><4.526049,0.035000,0.127000> rotate<0,-44.997030,0> translate<52.349400,-1.535000,69.723000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.784000,0.000000,76.123800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.549800,0.000000,76.123800>}
box{<0,0,-0.127000><5.765800,0.035000,0.127000> rotate<0,0.000000,0> translate<49.784000,0.000000,76.123800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.143400,0.000000,73.990200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.880000,0.000000,73.660000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,24.143948,0> translate<55.143400,0.000000,73.990200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.549800,-1.535000,72.923400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.880000,-1.535000,73.660000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-65.850112,0> translate<55.549800,-1.535000,72.923400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.536600,0.000000,73.329800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.007000,0.000000,68.859400>}
box{<0,0,-0.127000><6.322100,0.035000,0.127000> rotate<0,44.997030,0> translate<51.536600,0.000000,73.329800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.832000,0.000000,50.749200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.083200,0.000000,50.749200>}
box{<0,0,-0.127000><3.251200,0.035000,0.127000> rotate<0,0.000000,0> translate<52.832000,0.000000,50.749200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.197000,-1.535000,49.352200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.515000,-1.535000,53.670200>}
box{<0,0,-0.127000><6.106574,0.035000,0.127000> rotate<0,-44.997030,0> translate<52.197000,-1.535000,49.352200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.882800,0.000000,51.892200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.642000,0.000000,51.892200>}
box{<0,0,-0.127000><3.759200,0.035000,0.127000> rotate<0,0.000000,0> translate<52.882800,0.000000,51.892200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.642000,0.000000,55.676800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.642000,0.000000,56.997600>}
box{<0,0,-0.127000><1.320800,0.035000,0.127000> rotate<0,90.000000,0> translate<56.642000,0.000000,56.997600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.908200,0.000000,71.018400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.794400,0.000000,67.132200>}
box{<0,0,-0.127000><5.495917,0.035000,0.127000> rotate<0,44.997030,0> translate<52.908200,0.000000,71.018400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.245000,0.000000,48.691800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.921400,0.000000,50.368200>}
box{<0,0,-0.127000><2.370788,0.035000,0.127000> rotate<0,-44.997030,0> translate<55.245000,0.000000,48.691800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.921400,0.000000,50.368200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.921400,0.000000,50.977800>}
box{<0,0,-0.127000><0.609600,0.035000,0.127000> rotate<0,90.000000,0> translate<56.921400,0.000000,50.977800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.889400,0.000000,55.905400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.921400,0.000000,57.937400>}
box{<0,0,-0.127000><2.873682,0.035000,0.127000> rotate<0,-44.997030,0> translate<54.889400,0.000000,55.905400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.705000,0.000000,70.561200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.946800,0.000000,66.319400>}
box{<0,0,-0.127000><5.998811,0.035000,0.127000> rotate<0,44.997030,0> translate<52.705000,0.000000,70.561200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.642000,0.000000,56.997600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.124600,0.000000,57.480200>}
box{<0,0,-0.127000><0.682499,0.035000,0.127000> rotate<0,-44.997030,0> translate<56.642000,0.000000,56.997600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.515000,-1.535000,53.670200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.150000,-1.535000,54.610000>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,-55.950370,0> translate<56.515000,-1.535000,53.670200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.642000,0.000000,55.676800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.150000,0.000000,54.610000>}
box{<0,0,-0.127000><1.181578,0.035000,0.127000> rotate<0,64.532396,0> translate<56.642000,0.000000,55.676800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.150000,-1.535000,62.230000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.429400,-1.535000,63.525400>}
box{<0,0,-0.127000><1.325189,0.035000,0.127000> rotate<0,-77.823405,0> translate<57.150000,-1.535000,62.230000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.429400,-1.535000,67.818000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.429400,-1.535000,63.525400>}
box{<0,0,-0.127000><4.292600,0.035000,0.127000> rotate<0,-90.000000,0> translate<57.429400,-1.535000,63.525400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.536600,-1.535000,63.779400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.454800,-1.535000,69.697600>}
box{<0,0,-0.127000><8.369599,0.035000,0.127000> rotate<0,-44.997030,0> translate<51.536600,-1.535000,63.779400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.150000,0.000000,48.260000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.480200,0.000000,48.996600>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-65.850112,0> translate<57.150000,0.000000,48.260000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.480200,0.000000,48.996600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.480200,0.000000,50.876200>}
box{<0,0,-0.127000><1.879600,0.035000,0.127000> rotate<0,90.000000,0> translate<57.480200,0.000000,50.876200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.229000,-1.535000,56.642000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.480200,-1.535000,56.642000>}
box{<0,0,-0.127000><3.251200,0.035000,0.127000> rotate<0,0.000000,0> translate<54.229000,-1.535000,56.642000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.638200,-1.535000,60.579000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.581800,-1.535000,60.579000>}
box{<0,0,-0.127000><5.943600,0.035000,0.127000> rotate<0,0.000000,0> translate<51.638200,-1.535000,60.579000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.022800,0.000000,47.167800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.607200,0.000000,47.167800>}
box{<0,0,-0.127000><27.584400,0.035000,0.127000> rotate<0,0.000000,0> translate<30.022800,0.000000,47.167800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.549800,0.000000,76.123800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.683400,0.000000,73.990200>}
box{<0,0,-0.127000><3.017366,0.035000,0.127000> rotate<0,44.997030,0> translate<55.549800,0.000000,76.123800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.076600,-1.535000,57.480200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.835800,-1.535000,57.480200>}
box{<0,0,-0.127000><3.759200,0.035000,0.127000> rotate<0,0.000000,0> translate<54.076600,-1.535000,57.480200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.124600,0.000000,57.480200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.835800,0.000000,57.480200>}
box{<0,0,-0.127000><0.711200,0.035000,0.127000> rotate<0,0.000000,0> translate<57.124600,0.000000,57.480200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.921400,0.000000,57.937400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.039000,0.000000,57.937400>}
box{<0,0,-0.127000><1.117600,0.035000,0.127000> rotate<0,0.000000,0> translate<56.921400,0.000000,57.937400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.933600,-1.535000,76.123800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.089800,-1.535000,76.123800>}
box{<0,0,-0.127000><5.156200,0.035000,0.127000> rotate<0,0.000000,0> translate<52.933600,-1.535000,76.123800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.835800,0.000000,57.480200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.216800,0.000000,57.099200>}
box{<0,0,-0.127000><0.538815,0.035000,0.127000> rotate<0,44.997030,0> translate<57.835800,0.000000,57.480200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.549800,0.000000,58.394600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.242200,0.000000,58.394600>}
box{<0,0,-0.127000><2.692400,0.035000,0.127000> rotate<0,0.000000,0> translate<55.549800,0.000000,58.394600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.889400,-1.535000,65.938400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.293000,-1.535000,69.342000>}
box{<0,0,-0.127000><4.813417,0.035000,0.127000> rotate<0,-44.997030,0> translate<54.889400,-1.535000,65.938400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.293000,-1.535000,72.923400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.293000,-1.535000,69.342000>}
box{<0,0,-0.127000><3.581400,0.035000,0.127000> rotate<0,-90.000000,0> translate<58.293000,-1.535000,69.342000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.039000,0.000000,57.937400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.420000,0.000000,57.556400>}
box{<0,0,-0.127000><0.538815,0.035000,0.127000> rotate<0,44.997030,0> translate<58.039000,0.000000,57.937400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.683400,0.000000,73.990200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.420000,0.000000,73.660000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,24.143948,0> translate<57.683400,0.000000,73.990200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.293000,-1.535000,72.923400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.420000,-1.535000,73.660000>}
box{<0,0,-0.127000><0.747468,0.035000,0.127000> rotate<0,-80.212299,0> translate<58.293000,-1.535000,72.923400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.496200,-1.535000,58.953400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.496200,-1.535000,59.664600>}
box{<0,0,-0.127000><0.711200,0.035000,0.127000> rotate<0,90.000000,0> translate<58.496200,-1.535000,59.664600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.607200,0.000000,47.167800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.597800,0.000000,48.158400>}
box{<0,0,-0.127000><1.400920,0.035000,0.127000> rotate<0,-44.997030,0> translate<57.607200,0.000000,47.167800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.597800,0.000000,48.158400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.597800,0.000000,50.800000>}
box{<0,0,-0.127000><2.641600,0.035000,0.127000> rotate<0,90.000000,0> translate<58.597800,0.000000,50.800000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.292000,0.000000,58.851800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.597800,0.000000,58.851800>}
box{<0,0,-0.127000><8.305800,0.035000,0.127000> rotate<0,0.000000,0> translate<50.292000,0.000000,58.851800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.242200,0.000000,58.394600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.623200,0.000000,58.013600>}
box{<0,0,-0.127000><0.538815,0.035000,0.127000> rotate<0,44.997030,0> translate<58.242200,0.000000,58.394600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.581800,-1.535000,60.579000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.699400,-1.535000,61.696600>}
box{<0,0,-0.127000><1.580525,0.035000,0.127000> rotate<0,-44.997030,0> translate<57.581800,-1.535000,60.579000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.699400,-1.535000,61.696600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.699400,-1.535000,63.423800>}
box{<0,0,-0.127000><1.727200,0.035000,0.127000> rotate<0,90.000000,0> translate<58.699400,-1.535000,63.423800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.642000,-1.535000,51.892200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.953400,-1.535000,51.892200>}
box{<0,0,-0.127000><2.311400,0.035000,0.127000> rotate<0,0.000000,0> translate<56.642000,-1.535000,51.892200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.597800,0.000000,58.851800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.978800,0.000000,58.470800>}
box{<0,0,-0.127000><0.538815,0.035000,0.127000> rotate<0,44.997030,0> translate<58.597800,0.000000,58.851800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<32.816800,0.000000,46.329600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.309000,0.000000,46.329600>}
box{<0,0,-0.127000><26.492200,0.035000,0.127000> rotate<0,0.000000,0> translate<32.816800,0.000000,46.329600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.921400,0.000000,50.977800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.334400,0.000000,53.390800>}
box{<0,0,-0.127000><3.412497,0.035000,0.127000> rotate<0,-44.997030,0> translate<56.921400,0.000000,50.977800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.908200,0.000000,59.309000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.334400,0.000000,59.309000>}
box{<0,0,-0.127000><6.426200,0.035000,0.127000> rotate<0,0.000000,0> translate<52.908200,0.000000,59.309000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.835800,-1.535000,57.480200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.410600,-1.535000,55.905400>}
box{<0,0,-0.127000><2.227104,0.035000,0.127000> rotate<0,44.997030,0> translate<57.835800,-1.535000,57.480200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.496200,-1.535000,59.664600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.410600,-1.535000,60.579000>}
box{<0,0,-0.127000><1.293157,0.035000,0.127000> rotate<0,-44.997030,0> translate<58.496200,-1.535000,59.664600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.953400,-1.535000,51.892200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.563000,-1.535000,51.282600>}
box{<0,0,-0.127000><0.862105,0.035000,0.127000> rotate<0,44.997030,0> translate<58.953400,-1.535000,51.892200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.480200,0.000000,50.876200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.563000,0.000000,52.959000>}
box{<0,0,-0.127000><2.945524,0.035000,0.127000> rotate<0,-44.997030,0> translate<57.480200,0.000000,50.876200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.334400,0.000000,53.390800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.690000,0.000000,54.610000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,-73.734929,0> translate<59.334400,0.000000,53.390800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.410600,-1.535000,55.905400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.690000,-1.535000,54.610000>}
box{<0,0,-0.127000><1.325189,0.035000,0.127000> rotate<0,77.823405,0> translate<59.410600,-1.535000,55.905400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.597800,0.000000,50.800000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.918600,0.000000,52.120800>}
box{<0,0,-0.127000><1.867893,0.035000,0.127000> rotate<0,-44.997030,0> translate<58.597800,0.000000,50.800000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.918600,-1.535000,52.120800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.918600,-1.535000,52.755800>}
box{<0,0,-0.127000><0.635000,0.035000,0.127000> rotate<0,90.000000,0> translate<59.918600,-1.535000,52.755800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.690000,-1.535000,62.230000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.969400,-1.535000,63.525400>}
box{<0,0,-0.127000><1.325189,0.035000,0.127000> rotate<0,-77.823405,0> translate<59.690000,-1.535000,62.230000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.969400,-1.535000,63.627000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.969400,-1.535000,63.525400>}
box{<0,0,-0.127000><0.101600,0.035000,0.127000> rotate<0,-90.000000,0> translate<59.969400,-1.535000,63.525400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.690000,0.000000,48.260000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.020200,0.000000,48.996600>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-65.850112,0> translate<59.690000,0.000000,48.260000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.563000,0.000000,52.959000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.121800,0.000000,52.959000>}
box{<0,0,-0.127000><0.558800,0.035000,0.127000> rotate<0,0.000000,0> translate<59.563000,0.000000,52.959000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.089800,0.000000,76.123800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.223400,0.000000,73.990200>}
box{<0,0,-0.127000><3.017366,0.035000,0.127000> rotate<0,44.997030,0> translate<58.089800,0.000000,76.123800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.083200,-1.535000,50.749200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.325000,-1.535000,50.749200>}
box{<0,0,-0.127000><4.241800,0.035000,0.127000> rotate<0,0.000000,0> translate<56.083200,-1.535000,50.749200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.007000,0.000000,68.859400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.325000,0.000000,68.859400>}
box{<0,0,-0.127000><4.318000,0.035000,0.127000> rotate<0,0.000000,0> translate<56.007000,0.000000,68.859400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.480200,0.000000,56.642000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.502800,0.000000,56.642000>}
box{<0,0,-0.127000><3.022600,0.035000,0.127000> rotate<0,0.000000,0> translate<57.480200,0.000000,56.642000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.978800,0.000000,58.470800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.604400,0.000000,58.470800>}
box{<0,0,-0.127000><1.625600,0.035000,0.127000> rotate<0,0.000000,0> translate<58.978800,0.000000,58.470800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.325000,-1.535000,50.749200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.629800,-1.535000,50.444400>}
box{<0,0,-0.127000><0.431052,0.035000,0.127000> rotate<0,44.997030,0> translate<60.325000,-1.535000,50.749200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.429400,-1.535000,67.818000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.629800,-1.535000,71.018400>}
box{<0,0,-0.127000><4.526049,0.035000,0.127000> rotate<0,-44.997030,0> translate<57.429400,-1.535000,67.818000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.629800,-1.535000,72.923400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.629800,-1.535000,71.018400>}
box{<0,0,-0.127000><1.905000,0.035000,0.127000> rotate<0,-90.000000,0> translate<60.629800,-1.535000,71.018400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.918600,-1.535000,52.755800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.680600,-1.535000,53.517800>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,-44.997030,0> translate<59.918600,-1.535000,52.755800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.496200,-1.535000,58.953400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.680600,-1.535000,56.769000>}
box{<0,0,-0.127000><3.089208,0.035000,0.127000> rotate<0,44.997030,0> translate<58.496200,-1.535000,58.953400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.680600,-1.535000,53.517800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.680600,-1.535000,56.769000>}
box{<0,0,-0.127000><3.251200,0.035000,0.127000> rotate<0,90.000000,0> translate<60.680600,-1.535000,56.769000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.121800,0.000000,52.959000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.833000,0.000000,53.670200>}
box{<0,0,-0.127000><1.005789,0.035000,0.127000> rotate<0,-44.997030,0> translate<60.121800,0.000000,52.959000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.755800,-1.535000,75.285600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.858400,-1.535000,75.285600>}
box{<0,0,-0.127000><8.102600,0.035000,0.127000> rotate<0,0.000000,0> translate<52.755800,-1.535000,75.285600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.325000,0.000000,68.859400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.960000,0.000000,68.580000>}
box{<0,0,-0.127000><0.693750,0.035000,0.127000> rotate<0,23.747927,0> translate<60.325000,0.000000,68.859400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.223400,0.000000,73.990200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.960000,0.000000,73.660000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,24.143948,0> translate<60.223400,0.000000,73.990200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.629800,-1.535000,72.923400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.960000,-1.535000,73.660000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-65.850112,0> translate<60.629800,-1.535000,72.923400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.563000,-1.535000,51.282600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.985400,-1.535000,51.282600>}
box{<0,0,-0.127000><1.422400,0.035000,0.127000> rotate<0,0.000000,0> translate<59.563000,-1.535000,51.282600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.604400,0.000000,58.470800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.985400,0.000000,58.851800>}
box{<0,0,-0.127000><0.538815,0.035000,0.127000> rotate<0,-44.997030,0> translate<60.604400,0.000000,58.470800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.309000,0.000000,46.329600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.137800,0.000000,48.158400>}
box{<0,0,-0.127000><2.586314,0.035000,0.127000> rotate<0,-44.997030,0> translate<59.309000,0.000000,46.329600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.137800,0.000000,48.158400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.137800,0.000000,48.895000>}
box{<0,0,-0.127000><0.736600,0.035000,0.127000> rotate<0,90.000000,0> translate<61.137800,0.000000,48.895000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.858400,-1.535000,75.285600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.163200,-1.535000,75.590400>}
box{<0,0,-0.127000><0.431052,0.035000,0.127000> rotate<0,-44.997030,0> translate<60.858400,-1.535000,75.285600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.623200,0.000000,58.013600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.341000,0.000000,58.013600>}
box{<0,0,-0.127000><2.717800,0.035000,0.127000> rotate<0,0.000000,0> translate<58.623200,0.000000,58.013600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.420000,0.000000,57.556400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.544200,0.000000,57.556400>}
box{<0,0,-0.127000><3.124200,0.035000,0.127000> rotate<0,0.000000,0> translate<58.420000,0.000000,57.556400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.833000,0.000000,53.670200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.595000,0.000000,53.670200>}
box{<0,0,-0.127000><0.762000,0.035000,0.127000> rotate<0,0.000000,0> translate<60.833000,0.000000,53.670200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.502800,0.000000,56.642000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.595000,0.000000,55.549800>}
box{<0,0,-0.127000><1.544604,0.035000,0.127000> rotate<0,44.997030,0> translate<60.502800,0.000000,56.642000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.960000,0.000000,68.580000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.595000,0.000000,68.859400>}
box{<0,0,-0.127000><0.693750,0.035000,0.127000> rotate<0,-23.747927,0> translate<60.960000,0.000000,68.580000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.216800,0.000000,57.099200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.747400,0.000000,57.099200>}
box{<0,0,-0.127000><3.530600,0.035000,0.127000> rotate<0,0.000000,0> translate<58.216800,0.000000,57.099200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.454800,0.000000,69.697600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.772800,0.000000,69.697600>}
box{<0,0,-0.127000><4.318000,0.035000,0.127000> rotate<0,0.000000,0> translate<57.454800,0.000000,69.697600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.772800,0.000000,69.697600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.103000,0.000000,70.027800>}
box{<0,0,-0.127000><0.466973,0.035000,0.127000> rotate<0,-44.997030,0> translate<61.772800,0.000000,69.697600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.341000,0.000000,58.013600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.153800,0.000000,58.826400>}
box{<0,0,-0.127000><1.149473,0.035000,0.127000> rotate<0,-44.997030,0> translate<61.341000,0.000000,58.013600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.153800,0.000000,58.826400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.153800,0.000000,59.359800>}
box{<0,0,-0.127000><0.533400,0.035000,0.127000> rotate<0,90.000000,0> translate<62.153800,0.000000,59.359800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.595000,0.000000,53.670200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.230000,0.000000,54.610000>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,-55.950370,0> translate<61.595000,0.000000,53.670200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.595000,0.000000,55.549800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.230000,0.000000,54.610000>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,55.950370,0> translate<61.595000,0.000000,55.549800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.595000,0.000000,68.859400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.357000,0.000000,68.859400>}
box{<0,0,-0.127000><0.762000,0.035000,0.127000> rotate<0,0.000000,0> translate<61.595000,0.000000,68.859400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.334400,-1.535000,59.309000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.382400,-1.535000,56.261000>}
box{<0,0,-0.127000><4.310523,0.035000,0.127000> rotate<0,44.997030,0> translate<59.334400,-1.535000,59.309000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.230000,-1.535000,62.230000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.509400,-1.535000,63.525400>}
box{<0,0,-0.127000><1.325189,0.035000,0.127000> rotate<0,-77.823405,0> translate<62.230000,-1.535000,62.230000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.509400,-1.535000,65.506600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.509400,-1.535000,63.525400>}
box{<0,0,-0.127000><1.981200,0.035000,0.127000> rotate<0,-90.000000,0> translate<62.509400,-1.535000,63.525400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.230000,0.000000,48.260000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.560200,0.000000,48.996600>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-65.850112,0> translate<62.230000,0.000000,48.260000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.382400,-1.535000,56.261000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.661800,-1.535000,56.261000>}
box{<0,0,-0.127000><0.279400,0.035000,0.127000> rotate<0,0.000000,0> translate<62.382400,-1.535000,56.261000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.642800,-1.535000,47.167800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.687200,-1.535000,47.167800>}
box{<0,0,-0.127000><25.044400,0.035000,0.127000> rotate<0,0.000000,0> translate<37.642800,-1.535000,47.167800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.687200,-1.535000,47.167800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.763400,-1.535000,47.244000>}
box{<0,0,-0.127000><0.107763,0.035000,0.127000> rotate<0,-44.997030,0> translate<62.687200,-1.535000,47.167800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.163200,0.000000,75.590400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.763400,0.000000,73.990200>}
box{<0,0,-0.127000><2.263025,0.035000,0.127000> rotate<0,44.997030,0> translate<61.163200,0.000000,75.590400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.410600,-1.535000,60.579000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.839600,-1.535000,60.579000>}
box{<0,0,-0.127000><3.429000,0.035000,0.127000> rotate<0,0.000000,0> translate<59.410600,-1.535000,60.579000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.357000,0.000000,68.859400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.068200,0.000000,69.570600>}
box{<0,0,-0.127000><1.005789,0.035000,0.127000> rotate<0,-44.997030,0> translate<62.357000,0.000000,68.859400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.699400,-1.535000,63.423800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.220600,-1.535000,67.945000>}
box{<0,0,-0.127000><6.393942,0.035000,0.127000> rotate<0,-44.997030,0> translate<58.699400,-1.535000,63.423800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.763400,-1.535000,47.244000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.322200,-1.535000,47.244000>}
box{<0,0,-0.127000><0.558800,0.035000,0.127000> rotate<0,0.000000,0> translate<62.763400,-1.535000,47.244000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.322200,0.000000,47.244000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.322200,0.000000,48.361600>}
box{<0,0,-0.127000><1.117600,0.035000,0.127000> rotate<0,90.000000,0> translate<63.322200,0.000000,48.361600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.220600,-1.535000,67.945000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.500000,-1.535000,68.580000>}
box{<0,0,-0.127000><0.693750,0.035000,0.127000> rotate<0,-66.246133,0> translate<63.220600,-1.535000,67.945000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.763400,0.000000,73.990200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.500000,0.000000,73.660000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,24.143948,0> translate<62.763400,0.000000,73.990200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.544200,0.000000,57.556400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.652400,0.000000,59.664600>}
box{<0,0,-0.127000><2.981445,0.035000,0.127000> rotate<0,-44.997030,0> translate<61.544200,0.000000,57.556400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.652400,0.000000,59.664600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.652400,0.000000,60.198000>}
box{<0,0,-0.127000><0.533400,0.035000,0.127000> rotate<0,90.000000,0> translate<63.652400,0.000000,60.198000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.779400,-1.535000,55.143400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.779400,-1.535000,53.517800>}
box{<0,0,-0.127000><1.625600,0.035000,0.127000> rotate<0,-90.000000,0> translate<63.779400,-1.535000,53.517800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.985400,0.000000,51.282600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.779400,0.000000,54.076600>}
box{<0,0,-0.127000><3.951313,0.035000,0.127000> rotate<0,-44.997030,0> translate<60.985400,0.000000,51.282600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.661800,-1.535000,56.261000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.779400,-1.535000,55.143400>}
box{<0,0,-0.127000><1.580525,0.035000,0.127000> rotate<0,44.997030,0> translate<62.661800,-1.535000,56.261000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.779400,0.000000,54.076600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.779400,0.000000,55.702200>}
box{<0,0,-0.127000><1.625600,0.035000,0.127000> rotate<0,90.000000,0> translate<63.779400,0.000000,55.702200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.500000,-1.535000,73.660000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.830200,-1.535000,72.923400>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,65.850112,0> translate<63.500000,-1.535000,73.660000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.838600,0.000000,72.567800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.957200,0.000000,72.567800>}
box{<0,0,-0.127000><9.118600,0.035000,0.127000> rotate<0,0.000000,0> translate<54.838600,0.000000,72.567800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.839600,-1.535000,60.579000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.135000,-1.535000,61.874400>}
box{<0,0,-0.127000><1.831972,0.035000,0.127000> rotate<0,-44.997030,0> translate<62.839600,-1.535000,60.579000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.500000,0.000000,68.580000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.135000,0.000000,68.300600>}
box{<0,0,-0.127000><0.693750,0.035000,0.127000> rotate<0,23.747927,0> translate<63.500000,0.000000,68.580000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.985400,-1.535000,58.851800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.211200,-1.535000,55.626000>}
box{<0,0,-0.127000><4.561970,0.035000,0.127000> rotate<0,44.997030,0> translate<60.985400,-1.535000,58.851800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.779400,-1.535000,53.517800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.338200,-1.535000,52.959000>}
box{<0,0,-0.127000><0.790263,0.035000,0.127000> rotate<0,44.997030,0> translate<63.779400,-1.535000,53.517800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.020200,0.000000,48.996600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.414400,0.000000,53.390800>}
box{<0,0,-0.127000><6.214337,0.035000,0.127000> rotate<0,-44.997030,0> translate<60.020200,0.000000,48.996600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.969400,-1.535000,63.627000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.490600,-1.535000,68.148200>}
box{<0,0,-0.127000><6.393942,0.035000,0.127000> rotate<0,-44.997030,0> translate<59.969400,-1.535000,63.627000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.490600,-1.535000,72.263000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.490600,-1.535000,68.148200>}
box{<0,0,-0.127000><4.114800,0.035000,0.127000> rotate<0,-90.000000,0> translate<64.490600,-1.535000,68.148200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.830200,-1.535000,72.923400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.490600,-1.535000,72.263000>}
box{<0,0,-0.127000><0.933947,0.035000,0.127000> rotate<0,44.997030,0> translate<63.830200,-1.535000,72.923400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.882800,-1.535000,74.752200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.541400,-1.535000,74.752200>}
box{<0,0,-0.127000><11.658600,0.035000,0.127000> rotate<0,0.000000,0> translate<52.882800,-1.535000,74.752200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.957200,0.000000,72.567800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.592200,0.000000,73.202800>}
box{<0,0,-0.127000><0.898026,0.035000,0.127000> rotate<0,-44.997030,0> translate<63.957200,0.000000,72.567800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.592200,0.000000,73.202800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.592200,0.000000,73.761600>}
box{<0,0,-0.127000><0.558800,0.035000,0.127000> rotate<0,90.000000,0> translate<64.592200,0.000000,73.761600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.211200,-1.535000,55.626000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.770000,-1.535000,54.610000>}
box{<0,0,-0.127000><1.159532,0.035000,0.127000> rotate<0,61.185168,0> translate<64.211200,-1.535000,55.626000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.414400,0.000000,53.390800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.770000,0.000000,54.610000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,-73.734929,0> translate<64.414400,0.000000,53.390800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.135000,-1.535000,61.874400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.770000,-1.535000,62.230000>}
box{<0,0,-0.127000><0.727789,0.035000,0.127000> rotate<0,-29.246896,0> translate<64.135000,-1.535000,61.874400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.135000,0.000000,68.300600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.846200,0.000000,67.589400>}
box{<0,0,-0.127000><1.005789,0.035000,0.127000> rotate<0,44.997030,0> translate<64.135000,0.000000,68.300600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.770000,-1.535000,62.230000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.049400,-1.535000,63.525400>}
box{<0,0,-0.127000><1.325189,0.035000,0.127000> rotate<0,-77.823405,0> translate<64.770000,-1.535000,62.230000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.049400,-1.535000,63.525400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.049400,-1.535000,67.386200>}
box{<0,0,-0.127000><3.860800,0.035000,0.127000> rotate<0,90.000000,0> translate<65.049400,-1.535000,67.386200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.770000,0.000000,48.260000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.100200,0.000000,48.996600>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-65.850112,0> translate<64.770000,0.000000,48.260000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.541400,-1.535000,74.752200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.303400,-1.535000,73.990200>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,44.997030,0> translate<64.541400,-1.535000,74.752200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.592200,0.000000,73.761600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.582800,0.000000,74.752200>}
box{<0,0,-0.127000><1.400920,0.035000,0.127000> rotate<0,-44.997030,0> translate<64.592200,0.000000,73.761600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.509400,-1.535000,65.506600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.709800,-1.535000,68.707000>}
box{<0,0,-0.127000><4.526049,0.035000,0.127000> rotate<0,-44.997030,0> translate<62.509400,-1.535000,65.506600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.709800,-1.535000,72.923400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.709800,-1.535000,68.707000>}
box{<0,0,-0.127000><4.216400,0.035000,0.127000> rotate<0,-90.000000,0> translate<65.709800,-1.535000,68.707000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.747400,0.000000,57.099200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.760600,0.000000,61.112400>}
box{<0,0,-0.127000><5.675522,0.035000,0.127000> rotate<0,-44.997030,0> translate<61.747400,0.000000,57.099200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.760600,0.000000,61.112400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.760600,0.000000,62.763400>}
box{<0,0,-0.127000><1.651000,0.035000,0.127000> rotate<0,90.000000,0> translate<65.760600,0.000000,62.763400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.152800,-1.535000,49.352200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.811400,-1.535000,49.352200>}
box{<0,0,-0.127000><11.658600,0.035000,0.127000> rotate<0,0.000000,0> translate<54.152800,-1.535000,49.352200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.338200,-1.535000,52.959000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.963800,-1.535000,52.959000>}
box{<0,0,-0.127000><1.625600,0.035000,0.127000> rotate<0,0.000000,0> translate<64.338200,-1.535000,52.959000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.629800,-1.535000,50.444400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.989200,-1.535000,50.444400>}
box{<0,0,-0.127000><5.359400,0.035000,0.127000> rotate<0,0.000000,0> translate<60.629800,-1.535000,50.444400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.303400,-1.535000,73.990200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<66.040000,-1.535000,73.660000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,24.143948,0> translate<65.303400,-1.535000,73.990200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.709800,-1.535000,72.923400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<66.040000,-1.535000,73.660000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-65.850112,0> translate<65.709800,-1.535000,72.923400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.137800,0.000000,48.895000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<66.319400,0.000000,54.076600>}
box{<0,0,-0.127000><7.327889,0.035000,0.127000> rotate<0,-44.997030,0> translate<61.137800,0.000000,48.895000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<66.319400,0.000000,54.076600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<66.319400,0.000000,56.616600>}
box{<0,0,-0.127000><2.540000,0.035000,0.127000> rotate<0,90.000000,0> translate<66.319400,0.000000,56.616600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.811400,-1.535000,49.352200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<66.573400,-1.535000,48.590200>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,44.997030,0> translate<65.811400,-1.535000,49.352200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.963800,-1.535000,52.959000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<66.675000,-1.535000,53.670200>}
box{<0,0,-0.127000><1.005789,0.035000,0.127000> rotate<0,-44.997030,0> translate<65.963800,-1.535000,52.959000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.560200,0.000000,48.996600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<66.954400,0.000000,53.390800>}
box{<0,0,-0.127000><6.214337,0.035000,0.127000> rotate<0,-44.997030,0> translate<62.560200,0.000000,48.996600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<66.573400,-1.535000,48.590200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<67.310000,-1.535000,48.260000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,24.143948,0> translate<66.573400,-1.535000,48.590200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<66.675000,-1.535000,53.670200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<67.310000,-1.535000,54.610000>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,-55.950370,0> translate<66.675000,-1.535000,53.670200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<66.954400,0.000000,53.390800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<67.310000,0.000000,54.610000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,-73.734929,0> translate<66.954400,0.000000,53.390800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.652400,-1.535000,60.198000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<67.360800,-1.535000,60.198000>}
box{<0,0,-0.127000><3.708400,0.035000,0.127000> rotate<0,0.000000,0> translate<63.652400,-1.535000,60.198000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<67.310000,-1.535000,62.230000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<67.589400,-1.535000,63.525400>}
box{<0,0,-0.127000><1.325189,0.035000,0.127000> rotate<0,-77.823405,0> translate<67.310000,-1.535000,62.230000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<67.589400,-1.535000,63.525400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<67.589400,-1.535000,69.265800>}
box{<0,0,-0.127000><5.740400,0.035000,0.127000> rotate<0,90.000000,0> translate<67.589400,-1.535000,69.265800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.609800,-1.535000,44.500800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<67.665600,-1.535000,44.500800>}
box{<0,0,-0.127000><40.055800,0.035000,0.127000> rotate<0,0.000000,0> translate<27.609800,-1.535000,44.500800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<67.310000,0.000000,62.230000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<67.945000,0.000000,63.169800>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,-55.950370,0> translate<67.310000,0.000000,62.230000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<67.310000,-1.535000,48.260000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<68.046600,-1.535000,48.183800>}
box{<0,0,-0.127000><0.740531,0.035000,0.127000> rotate<0,5.905751,0> translate<67.310000,-1.535000,48.260000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.049400,-1.535000,67.386200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<68.249800,-1.535000,70.586600>}
box{<0,0,-0.127000><4.526049,0.035000,0.127000> rotate<0,-44.997030,0> translate<65.049400,-1.535000,67.386200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<68.249800,-1.535000,70.586600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<68.249800,-1.535000,72.923400>}
box{<0,0,-0.127000><2.336800,0.035000,0.127000> rotate<0,90.000000,0> translate<68.249800,-1.535000,72.923400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.322200,0.000000,48.361600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<68.300600,0.000000,53.340000>}
box{<0,0,-0.127000><7.040521,0.035000,0.127000> rotate<0,-44.997030,0> translate<63.322200,0.000000,48.361600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<68.300600,0.000000,53.340000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<68.300600,0.000000,55.143400>}
box{<0,0,-0.127000><1.803400,0.035000,0.127000> rotate<0,90.000000,0> translate<68.300600,0.000000,55.143400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<67.360800,-1.535000,60.198000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<68.300600,-1.535000,61.137800>}
box{<0,0,-0.127000><1.329078,0.035000,0.127000> rotate<0,-44.997030,0> translate<67.360800,-1.535000,60.198000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<68.300600,-1.535000,61.137800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<68.300600,-1.535000,68.554600>}
box{<0,0,-0.127000><7.416800,0.035000,0.127000> rotate<0,90.000000,0> translate<68.300600,-1.535000,68.554600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.760600,0.000000,62.763400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<68.478400,0.000000,65.481200>}
box{<0,0,-0.127000><3.843550,0.035000,0.127000> rotate<0,-44.997030,0> translate<65.760600,0.000000,62.763400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<68.249800,-1.535000,72.923400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<68.580000,-1.535000,73.660000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-65.850112,0> translate<68.249800,-1.535000,72.923400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<67.945000,0.000000,63.169800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<68.656200,0.000000,63.881000>}
box{<0,0,-0.127000><1.005789,0.035000,0.127000> rotate<0,-44.997030,0> translate<67.945000,0.000000,63.169800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.941000,-1.535000,46.329600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<68.732400,-1.535000,46.329600>}
box{<0,0,-0.127000><32.791400,0.035000,0.127000> rotate<0,0.000000,0> translate<35.941000,-1.535000,46.329600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.153800,-1.535000,59.359800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<69.062600,-1.535000,59.359800>}
box{<0,0,-0.127000><6.908800,0.035000,0.127000> rotate<0,0.000000,0> translate<62.153800,-1.535000,59.359800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.989200,-1.535000,50.444400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<69.215000,-1.535000,53.670200>}
box{<0,0,-0.127000><4.561970,0.035000,0.127000> rotate<0,-44.997030,0> translate<65.989200,-1.535000,50.444400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.779400,0.000000,55.702200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<69.291200,0.000000,61.214000>}
box{<0,0,-0.127000><7.794862,0.035000,0.127000> rotate<0,-44.997030,0> translate<63.779400,0.000000,55.702200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.100200,0.000000,48.996600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<69.494400,0.000000,53.390800>}
box{<0,0,-0.127000><6.214337,0.035000,0.127000> rotate<0,-44.997030,0> translate<65.100200,0.000000,48.996600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<69.215000,-1.535000,53.670200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<69.850000,-1.535000,54.610000>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,-55.950370,0> translate<69.215000,-1.535000,53.670200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<69.494400,0.000000,53.390800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<69.850000,0.000000,54.610000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,-73.734929,0> translate<69.494400,0.000000,53.390800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<69.291200,0.000000,61.214000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<69.850000,0.000000,62.230000>}
box{<0,0,-0.127000><1.159532,0.035000,0.127000> rotate<0,-61.185168,0> translate<69.291200,0.000000,61.214000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<69.850000,-1.535000,62.230000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<70.129400,-1.535000,63.525400>}
box{<0,0,-0.127000><1.325189,0.035000,0.127000> rotate<0,-77.823405,0> translate<69.850000,-1.535000,62.230000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<70.129400,-1.535000,63.525400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<70.129400,-1.535000,69.723000>}
box{<0,0,-0.127000><6.197600,0.035000,0.127000> rotate<0,90.000000,0> translate<70.129400,-1.535000,69.723000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<68.656200,0.000000,63.881000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<70.281800,0.000000,63.881000>}
box{<0,0,-0.127000><1.625600,0.035000,0.127000> rotate<0,0.000000,0> translate<68.656200,0.000000,63.881000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<68.300600,0.000000,55.143400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<70.383400,0.000000,57.226200>}
box{<0,0,-0.127000><2.945524,0.035000,0.127000> rotate<0,-44.997030,0> translate<68.300600,0.000000,55.143400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<66.319400,0.000000,56.616600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<70.840600,0.000000,61.137800>}
box{<0,0,-0.127000><6.393942,0.035000,0.127000> rotate<0,-44.997030,0> translate<66.319400,0.000000,56.616600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<69.062600,-1.535000,59.359800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<70.840600,-1.535000,61.137800>}
box{<0,0,-0.127000><2.514472,0.035000,0.127000> rotate<0,-44.997030,0> translate<69.062600,-1.535000,59.359800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<70.840600,-1.535000,61.137800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<70.840600,-1.535000,62.763400>}
box{<0,0,-0.127000><1.625600,0.035000,0.127000> rotate<0,90.000000,0> translate<70.840600,-1.535000,62.763400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<70.281800,0.000000,63.881000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<70.840600,0.000000,63.322200>}
box{<0,0,-0.127000><0.790263,0.035000,0.127000> rotate<0,44.997030,0> translate<70.281800,0.000000,63.881000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<70.840600,0.000000,61.137800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<70.840600,0.000000,63.322200>}
box{<0,0,-0.127000><2.184400,0.035000,0.127000> rotate<0,90.000000,0> translate<70.840600,0.000000,63.322200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<68.478400,0.000000,65.481200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<70.967600,0.000000,65.481200>}
box{<0,0,-0.127000><2.489200,0.035000,0.127000> rotate<0,0.000000,0> translate<68.478400,0.000000,65.481200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<70.967600,-1.535000,65.481200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<70.967600,-1.535000,69.215000>}
box{<0,0,-0.127000><3.733800,0.035000,0.127000> rotate<0,90.000000,0> translate<70.967600,-1.535000,69.215000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<67.589400,-1.535000,69.265800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<71.247000,-1.535000,72.923400>}
box{<0,0,-0.127000><5.172628,0.035000,0.127000> rotate<0,-44.997030,0> translate<67.589400,-1.535000,69.265800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<71.120000,-1.535000,73.660000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<71.247000,-1.535000,72.923400>}
box{<0,0,-0.127000><0.747468,0.035000,0.127000> rotate<0,80.212299,0> translate<71.120000,-1.535000,73.660000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<70.840600,-1.535000,62.763400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<71.805800,-1.535000,63.728600>}
box{<0,0,-0.127000><1.364999,0.035000,0.127000> rotate<0,-44.997030,0> translate<70.840600,-1.535000,62.763400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<71.805800,-1.535000,63.728600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<71.805800,-1.535000,68.148200>}
box{<0,0,-0.127000><4.419600,0.035000,0.127000> rotate<0,90.000000,0> translate<71.805800,-1.535000,68.148200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<68.300600,-1.535000,68.554600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<72.212200,-1.535000,72.466200>}
box{<0,0,-0.127000><5.531838,0.035000,0.127000> rotate<0,-44.997030,0> translate<68.300600,-1.535000,68.554600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<72.212200,-1.535000,72.466200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<72.212200,-1.535000,73.761600>}
box{<0,0,-0.127000><1.295400,0.035000,0.127000> rotate<0,90.000000,0> translate<72.212200,-1.535000,73.761600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.068200,0.000000,69.570600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<72.313800,0.000000,69.570600>}
box{<0,0,-0.127000><9.245600,0.035000,0.127000> rotate<0,0.000000,0> translate<63.068200,0.000000,69.570600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.103000,0.000000,70.027800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<72.542400,0.000000,70.027800>}
box{<0,0,-0.127000><10.439400,0.035000,0.127000> rotate<0,0.000000,0> translate<62.103000,0.000000,70.027800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<72.542400,0.000000,70.027800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<72.999600,0.000000,69.570600>}
box{<0,0,-0.127000><0.646578,0.035000,0.127000> rotate<0,44.997030,0> translate<72.542400,0.000000,70.027800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<70.967600,-1.535000,69.215000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<72.999600,-1.535000,71.247000>}
box{<0,0,-0.127000><2.873682,0.035000,0.127000> rotate<0,-44.997030,0> translate<70.967600,-1.535000,69.215000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<72.390000,0.000000,54.610000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.025000,0.000000,53.670200>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,55.950370,0> translate<72.390000,0.000000,54.610000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<72.313800,0.000000,69.570600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.025000,0.000000,68.859400>}
box{<0,0,-0.127000><1.005789,0.035000,0.127000> rotate<0,44.997030,0> translate<72.313800,0.000000,69.570600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<72.212200,-1.535000,73.761600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.202800,-1.535000,74.752200>}
box{<0,0,-0.127000><1.400920,0.035000,0.127000> rotate<0,-44.997030,0> translate<72.212200,-1.535000,73.761600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<70.129400,-1.535000,69.723000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.329800,-1.535000,72.923400>}
box{<0,0,-0.127000><4.526049,0.035000,0.127000> rotate<0,-44.997030,0> translate<70.129400,-1.535000,69.723000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<71.805800,-1.535000,68.148200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.355200,-1.535000,69.697600>}
box{<0,0,-0.127000><2.191182,0.035000,0.127000> rotate<0,-44.997030,0> translate<71.805800,-1.535000,68.148200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.355200,-1.535000,69.697600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.355200,-1.535000,70.408800>}
box{<0,0,-0.127000><0.711200,0.035000,0.127000> rotate<0,90.000000,0> translate<73.355200,-1.535000,70.408800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<68.046600,-1.535000,48.183800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.533000,-1.535000,53.670200>}
box{<0,0,-0.127000><7.758941,0.035000,0.127000> rotate<0,-44.997030,0> translate<68.046600,-1.535000,48.183800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.025000,0.000000,68.859400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.660000,0.000000,68.580000>}
box{<0,0,-0.127000><0.693750,0.035000,0.127000> rotate<0,23.747927,0> translate<73.025000,0.000000,68.859400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.329800,-1.535000,72.923400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.660000,-1.535000,73.660000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-65.850112,0> translate<73.329800,-1.535000,72.923400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.946800,0.000000,66.319400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.685400,0.000000,66.319400>}
box{<0,0,-0.127000><16.738600,0.035000,0.127000> rotate<0,0.000000,0> translate<56.946800,0.000000,66.319400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.025000,0.000000,53.670200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.787000,0.000000,53.670200>}
box{<0,0,-0.127000><0.762000,0.035000,0.127000> rotate<0,0.000000,0> translate<73.025000,0.000000,53.670200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.939400,-1.535000,67.589400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.939400,-1.535000,56.616600>}
box{<0,0,-0.127000><10.972800,0.035000,0.127000> rotate<0,-90.000000,0> translate<73.939400,-1.535000,56.616600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.939400,-1.535000,67.945000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.939400,-1.535000,67.589400>}
box{<0,0,-0.127000><0.355600,0.035000,0.127000> rotate<0,-90.000000,0> translate<73.939400,-1.535000,67.589400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.660000,-1.535000,68.580000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.939400,-1.535000,67.945000>}
box{<0,0,-0.127000><0.693750,0.035000,0.127000> rotate<0,66.246133,0> translate<73.660000,-1.535000,68.580000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.533000,-1.535000,53.670200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<74.295000,-1.535000,53.670200>}
box{<0,0,-0.127000><0.762000,0.035000,0.127000> rotate<0,0.000000,0> translate<73.533000,-1.535000,53.670200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.787000,0.000000,53.670200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<74.498200,0.000000,52.959000>}
box{<0,0,-0.127000><1.005789,0.035000,0.127000> rotate<0,44.997030,0> translate<73.787000,0.000000,53.670200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.939400,-1.535000,56.616600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<74.650600,-1.535000,55.905400>}
box{<0,0,-0.127000><1.005789,0.035000,0.127000> rotate<0,44.997030,0> translate<73.939400,-1.535000,56.616600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.794400,0.000000,67.132200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<74.650600,0.000000,67.132200>}
box{<0,0,-0.127000><17.856200,0.035000,0.127000> rotate<0,0.000000,0> translate<56.794400,0.000000,67.132200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.527000,-1.535000,44.043600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<74.828400,-1.535000,44.043600>}
box{<0,0,-0.127000><49.301400,0.035000,0.127000> rotate<0,0.000000,0> translate<25.527000,-1.535000,44.043600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<72.999600,0.000000,69.570600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<74.853800,0.000000,69.570600>}
box{<0,0,-0.127000><1.854200,0.035000,0.127000> rotate<0,0.000000,0> translate<72.999600,0.000000,69.570600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<74.295000,-1.535000,53.670200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<74.930000,-1.535000,54.610000>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,-55.950370,0> translate<74.295000,-1.535000,53.670200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<74.650600,-1.535000,55.905400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<74.930000,-1.535000,54.610000>}
box{<0,0,-0.127000><1.325189,0.035000,0.127000> rotate<0,77.823405,0> translate<74.650600,-1.535000,55.905400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<74.930000,-1.535000,62.230000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<75.565000,-1.535000,63.169800>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,-55.950370,0> translate<74.930000,-1.535000,62.230000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<74.853800,0.000000,69.570600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<75.565000,0.000000,68.859400>}
box{<0,0,-0.127000><1.005789,0.035000,0.127000> rotate<0,44.997030,0> translate<74.853800,0.000000,69.570600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.355200,0.000000,70.408800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<75.869800,0.000000,72.923400>}
box{<0,0,-0.127000><3.556181,0.035000,0.127000> rotate<0,-44.997030,0> translate<73.355200,0.000000,70.408800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<68.732400,-1.535000,46.329600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<75.920600,-1.535000,53.517800>}
box{<0,0,-0.127000><10.165650,0.035000,0.127000> rotate<0,-44.997030,0> translate<68.732400,-1.535000,46.329600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<75.920600,-1.535000,53.517800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<75.920600,-1.535000,55.143400>}
box{<0,0,-0.127000><1.625600,0.035000,0.127000> rotate<0,90.000000,0> translate<75.920600,-1.535000,55.143400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<75.565000,0.000000,68.859400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<76.200000,0.000000,68.580000>}
box{<0,0,-0.127000><0.693750,0.035000,0.127000> rotate<0,23.747927,0> translate<75.565000,0.000000,68.859400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<75.869800,0.000000,72.923400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<76.200000,0.000000,73.660000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-65.850112,0> translate<75.869800,0.000000,72.923400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<75.565000,-1.535000,63.169800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<76.327000,-1.535000,63.169800>}
box{<0,0,-0.127000><0.762000,0.035000,0.127000> rotate<0,0.000000,0> translate<75.565000,-1.535000,63.169800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.939400,-1.535000,67.589400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<76.631800,-1.535000,67.589400>}
box{<0,0,-0.127000><2.692400,0.035000,0.127000> rotate<0,0.000000,0> translate<73.939400,-1.535000,67.589400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.202800,-1.535000,74.752200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<76.657200,-1.535000,74.752200>}
box{<0,0,-0.127000><3.454400,0.035000,0.127000> rotate<0,0.000000,0> translate<73.202800,-1.535000,74.752200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.846200,0.000000,67.589400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<76.733400,0.000000,67.589400>}
box{<0,0,-0.127000><11.887200,0.035000,0.127000> rotate<0,0.000000,0> translate<64.846200,0.000000,67.589400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<67.665600,-1.535000,44.500800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<76.835000,-1.535000,53.670200>}
box{<0,0,-0.127000><12.967490,0.035000,0.127000> rotate<0,-44.997030,0> translate<67.665600,-1.535000,44.500800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<73.685400,0.000000,66.319400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<76.835000,0.000000,63.169800>}
box{<0,0,-0.127000><4.454207,0.035000,0.127000> rotate<0,44.997030,0> translate<73.685400,0.000000,66.319400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<76.200000,0.000000,68.580000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<76.835000,0.000000,68.300600>}
box{<0,0,-0.127000><0.693750,0.035000,0.127000> rotate<0,23.747927,0> translate<76.200000,0.000000,68.580000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<75.920600,-1.535000,55.143400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<77.165200,-1.535000,56.388000>}
box{<0,0,-0.127000><1.760130,0.035000,0.127000> rotate<0,-44.997030,0> translate<75.920600,-1.535000,55.143400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<76.631800,-1.535000,67.589400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<77.343000,-1.535000,68.300600>}
box{<0,0,-0.127000><1.005789,0.035000,0.127000> rotate<0,-44.997030,0> translate<76.631800,-1.535000,67.589400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<76.657200,-1.535000,74.752200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<77.419200,-1.535000,73.990200>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,44.997030,0> translate<76.657200,-1.535000,74.752200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<76.835000,-1.535000,53.670200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<77.470000,-1.535000,54.610000>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,-55.950370,0> translate<76.835000,-1.535000,53.670200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<76.835000,0.000000,63.169800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<77.470000,0.000000,62.230000>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,55.950370,0> translate<76.835000,0.000000,63.169800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<72.999600,-1.535000,71.247000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<77.876400,-1.535000,71.247000>}
box{<0,0,-0.127000><4.876800,0.035000,0.127000> rotate<0,0.000000,0> translate<72.999600,-1.535000,71.247000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<77.419200,-1.535000,73.990200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<78.003400,-1.535000,73.990200>}
box{<0,0,-0.127000><0.584200,0.035000,0.127000> rotate<0,0.000000,0> translate<77.419200,-1.535000,73.990200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<77.470000,-1.535000,54.610000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<78.105000,-1.535000,55.549800>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,-55.950370,0> translate<77.470000,-1.535000,54.610000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<77.165200,-1.535000,56.388000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<78.308200,-1.535000,56.388000>}
box{<0,0,-0.127000><1.143000,0.035000,0.127000> rotate<0,0.000000,0> translate<77.165200,-1.535000,56.388000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<76.835000,0.000000,68.300600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<78.562200,0.000000,68.300600>}
box{<0,0,-0.127000><1.727200,0.035000,0.127000> rotate<0,0.000000,0> translate<76.835000,0.000000,68.300600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<74.650600,0.000000,67.132200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<78.613000,0.000000,63.169800>}
box{<0,0,-0.127000><5.603680,0.035000,0.127000> rotate<0,44.997030,0> translate<74.650600,0.000000,67.132200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<78.003400,-1.535000,73.990200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<78.740000,-1.535000,73.660000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,24.143948,0> translate<78.003400,-1.535000,73.990200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<78.105000,-1.535000,55.549800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<78.867000,-1.535000,55.549800>}
box{<0,0,-0.127000><0.762000,0.035000,0.127000> rotate<0,0.000000,0> translate<78.105000,-1.535000,55.549800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<78.308200,0.000000,56.388000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<79.146400,0.000000,55.549800>}
box{<0,0,-0.127000><1.185394,0.035000,0.127000> rotate<0,44.997030,0> translate<78.308200,0.000000,56.388000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<79.146400,0.000000,55.549800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<79.375000,0.000000,55.549800>}
box{<0,0,-0.127000><0.228600,0.035000,0.127000> rotate<0,0.000000,0> translate<79.146400,0.000000,55.549800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<78.613000,0.000000,63.169800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<79.375000,0.000000,63.169800>}
box{<0,0,-0.127000><0.762000,0.035000,0.127000> rotate<0,0.000000,0> translate<78.613000,0.000000,63.169800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<70.383400,0.000000,57.226200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<79.476600,0.000000,57.226200>}
box{<0,0,-0.127000><9.093200,0.035000,0.127000> rotate<0,0.000000,0> translate<70.383400,0.000000,57.226200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.403800,-1.535000,76.962000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<79.527400,-1.535000,76.962000>}
box{<0,0,-0.127000><49.123600,0.035000,0.127000> rotate<0,0.000000,0> translate<30.403800,-1.535000,76.962000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<77.876400,-1.535000,71.247000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<79.959200,-1.535000,73.329800>}
box{<0,0,-0.127000><2.945524,0.035000,0.127000> rotate<0,-44.997030,0> translate<77.876400,-1.535000,71.247000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<79.375000,0.000000,55.549800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<80.010000,0.000000,54.610000>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,55.950370,0> translate<79.375000,0.000000,55.549800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<79.375000,0.000000,63.169800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<80.010000,0.000000,62.230000>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,55.950370,0> translate<79.375000,0.000000,63.169800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<79.959200,-1.535000,73.329800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<80.543400,-1.535000,73.329800>}
box{<0,0,-0.127000><0.584200,0.035000,0.127000> rotate<0,0.000000,0> translate<79.959200,-1.535000,73.329800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<80.010000,-1.535000,54.610000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<80.645000,-1.535000,55.549800>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,-55.950370,0> translate<80.010000,-1.535000,54.610000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<76.327000,-1.535000,63.169800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<80.746600,-1.535000,67.589400>}
box{<0,0,-0.127000><6.250258,0.035000,0.127000> rotate<0,-44.997030,0> translate<76.327000,-1.535000,63.169800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<79.476600,0.000000,57.226200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<81.153000,0.000000,55.549800>}
box{<0,0,-0.127000><2.370788,0.035000,0.127000> rotate<0,44.997030,0> translate<79.476600,0.000000,57.226200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<76.733400,0.000000,67.589400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<81.153000,0.000000,63.169800>}
box{<0,0,-0.127000><6.250258,0.035000,0.127000> rotate<0,44.997030,0> translate<76.733400,0.000000,67.589400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<80.543400,-1.535000,73.329800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<81.280000,-1.535000,73.660000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-24.143948,0> translate<80.543400,-1.535000,73.329800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<80.645000,-1.535000,55.549800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<81.407000,-1.535000,55.549800>}
box{<0,0,-0.127000><0.762000,0.035000,0.127000> rotate<0,0.000000,0> translate<80.645000,-1.535000,55.549800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.339800,-1.535000,77.419200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<81.610200,-1.535000,77.419200>}
box{<0,0,-0.127000><55.270400,0.035000,0.127000> rotate<0,0.000000,0> translate<26.339800,-1.535000,77.419200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<81.153000,0.000000,55.549800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<81.915000,0.000000,55.549800>}
box{<0,0,-0.127000><0.762000,0.035000,0.127000> rotate<0,0.000000,0> translate<81.153000,0.000000,55.549800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<81.153000,0.000000,63.169800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<81.915000,0.000000,63.169800>}
box{<0,0,-0.127000><0.762000,0.035000,0.127000> rotate<0,0.000000,0> translate<81.153000,0.000000,63.169800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<79.527400,-1.535000,76.962000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<82.499200,-1.535000,73.990200>}
box{<0,0,-0.127000><4.202760,0.035000,0.127000> rotate<0,44.997030,0> translate<79.527400,-1.535000,76.962000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<81.915000,0.000000,55.549800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<82.550000,0.000000,54.610000>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,55.950370,0> translate<81.915000,0.000000,55.549800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<81.915000,0.000000,63.169800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<82.550000,0.000000,62.230000>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,55.950370,0> translate<81.915000,0.000000,63.169800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<82.499200,-1.535000,73.990200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<83.083400,-1.535000,73.990200>}
box{<0,0,-0.127000><0.584200,0.035000,0.127000> rotate<0,0.000000,0> translate<82.499200,-1.535000,73.990200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<82.550000,-1.535000,54.610000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<83.185000,-1.535000,55.549800>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,-55.950370,0> translate<82.550000,-1.535000,54.610000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<78.562200,0.000000,68.300600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<83.693000,0.000000,63.169800>}
box{<0,0,-0.127000><7.256047,0.035000,0.127000> rotate<0,44.997030,0> translate<78.562200,0.000000,68.300600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<83.083400,-1.535000,73.990200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<83.820000,-1.535000,73.660000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,24.143948,0> translate<83.083400,-1.535000,73.990200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<78.867000,-1.535000,55.549800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<83.896200,-1.535000,60.579000>}
box{<0,0,-0.127000><7.112363,0.035000,0.127000> rotate<0,-44.997030,0> translate<78.867000,-1.535000,55.549800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<83.185000,-1.535000,55.549800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<83.947000,-1.535000,55.549800>}
box{<0,0,-0.127000><0.762000,0.035000,0.127000> rotate<0,0.000000,0> translate<83.185000,-1.535000,55.549800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<65.582800,0.000000,74.752200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<84.277200,0.000000,74.752200>}
box{<0,0,-0.127000><18.694400,0.035000,0.127000> rotate<0,0.000000,0> translate<65.582800,0.000000,74.752200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<74.828400,-1.535000,44.043600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<84.455000,-1.535000,53.670200>}
box{<0,0,-0.127000><13.614068,0.035000,0.127000> rotate<0,-44.997030,0> translate<74.828400,-1.535000,44.043600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<83.693000,0.000000,63.169800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<84.455000,0.000000,63.169800>}
box{<0,0,-0.127000><0.762000,0.035000,0.127000> rotate<0,0.000000,0> translate<83.693000,0.000000,63.169800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<84.277200,0.000000,74.752200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<85.039200,0.000000,73.990200>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,44.997030,0> translate<84.277200,0.000000,74.752200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<84.455000,-1.535000,53.670200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<85.090000,-1.535000,54.610000>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,-55.950370,0> translate<84.455000,-1.535000,53.670200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<84.455000,0.000000,63.169800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<85.090000,0.000000,62.230000>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,55.950370,0> translate<84.455000,0.000000,63.169800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<85.267800,-1.535000,73.761600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<85.267800,-1.535000,71.094600>}
box{<0,0,-0.127000><2.667000,0.035000,0.127000> rotate<0,-90.000000,0> translate<85.267800,-1.535000,71.094600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<81.610200,-1.535000,77.419200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<85.267800,-1.535000,73.761600>}
box{<0,0,-0.127000><5.172628,0.035000,0.127000> rotate<0,44.997030,0> translate<81.610200,-1.535000,77.419200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<85.369400,0.000000,69.011800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<85.369400,0.000000,64.033400>}
box{<0,0,-0.127000><4.978400,0.035000,0.127000> rotate<0,-90.000000,0> translate<85.369400,0.000000,64.033400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<85.039200,0.000000,73.990200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<85.623400,0.000000,73.990200>}
box{<0,0,-0.127000><0.584200,0.035000,0.127000> rotate<0,0.000000,0> translate<85.039200,0.000000,73.990200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<85.090000,-1.535000,54.610000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<85.725000,-1.535000,55.549800>}
box{<0,0,-0.127000><1.134217,0.035000,0.127000> rotate<0,-55.950370,0> translate<85.090000,-1.535000,54.610000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<77.343000,-1.535000,68.300600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<85.725000,-1.535000,68.300600>}
box{<0,0,-0.127000><8.382000,0.035000,0.127000> rotate<0,0.000000,0> translate<77.343000,-1.535000,68.300600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<81.407000,-1.535000,55.549800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<85.979000,-1.535000,60.121800>}
box{<0,0,-0.127000><6.465784,0.035000,0.127000> rotate<0,-44.997030,0> translate<81.407000,-1.535000,55.549800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<85.369400,0.000000,69.011800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.029800,0.000000,69.672200>}
box{<0,0,-0.127000><0.933947,0.035000,0.127000> rotate<0,-44.997030,0> translate<85.369400,0.000000,69.011800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.029800,0.000000,72.923400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.029800,0.000000,69.672200>}
box{<0,0,-0.127000><3.251200,0.035000,0.127000> rotate<0,-90.000000,0> translate<86.029800,0.000000,69.672200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<74.498200,0.000000,52.959000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.080600,0.000000,52.959000>}
box{<0,0,-0.127000><11.582400,0.035000,0.127000> rotate<0,0.000000,0> translate<74.498200,0.000000,52.959000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.080600,0.000000,63.322200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.080600,0.000000,52.959000>}
box{<0,0,-0.127000><10.363200,0.035000,0.127000> rotate<0,-90.000000,0> translate<86.080600,0.000000,52.959000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<85.369400,0.000000,64.033400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.080600,0.000000,63.322200>}
box{<0,0,-0.127000><1.005789,0.035000,0.127000> rotate<0,44.997030,0> translate<85.369400,0.000000,64.033400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<85.725000,-1.535000,68.300600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.360000,-1.535000,68.580000>}
box{<0,0,-0.127000><0.693750,0.035000,0.127000> rotate<0,-23.747927,0> translate<85.725000,-1.535000,68.300600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<85.623400,0.000000,73.990200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.360000,0.000000,73.660000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,24.143948,0> translate<85.623400,0.000000,73.990200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.029800,0.000000,72.923400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.360000,0.000000,73.660000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-65.850112,0> translate<86.029800,0.000000,72.923400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<83.947000,-1.535000,55.549800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.487000,-1.535000,58.089800>}
box{<0,0,-0.127000><3.592102,0.035000,0.127000> rotate<0,-44.997030,0> translate<83.947000,-1.535000,55.549800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.639400,0.000000,67.945000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.639400,0.000000,61.671200>}
box{<0,0,-0.127000><6.273800,0.035000,0.127000> rotate<0,-90.000000,0> translate<86.639400,0.000000,61.671200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.360000,0.000000,68.580000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.639400,0.000000,67.945000>}
box{<0,0,-0.127000><0.693750,0.035000,0.127000> rotate<0,66.246133,0> translate<86.360000,0.000000,68.580000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.360000,0.000000,68.580000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.639400,0.000000,69.215000>}
box{<0,0,-0.127000><0.693750,0.035000,0.127000> rotate<0,-66.246133,0> translate<86.360000,0.000000,68.580000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.639400,0.000000,69.215000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.639400,0.000000,70.993000>}
box{<0,0,-0.127000><1.778000,0.035000,0.127000> rotate<0,90.000000,0> translate<86.639400,0.000000,70.993000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<80.746600,-1.535000,67.589400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<87.350600,-1.535000,67.589400>}
box{<0,0,-0.127000><6.604000,0.035000,0.127000> rotate<0,0.000000,0> translate<80.746600,-1.535000,67.589400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<87.350600,-1.535000,69.011800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<87.350600,-1.535000,67.589400>}
box{<0,0,-0.127000><1.422400,0.035000,0.127000> rotate<0,-90.000000,0> translate<87.350600,-1.535000,67.589400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<85.267800,-1.535000,71.094600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<87.350600,-1.535000,69.011800>}
box{<0,0,-0.127000><2.945524,0.035000,0.127000> rotate<0,44.997030,0> translate<85.267800,-1.535000,71.094600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<83.896200,-1.535000,60.579000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<88.112600,-1.535000,60.579000>}
box{<0,0,-0.127000><4.216400,0.035000,0.127000> rotate<0,0.000000,0> translate<83.896200,-1.535000,60.579000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.639400,0.000000,70.993000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<88.569800,0.000000,72.923400>}
box{<0,0,-0.127000><2.729998,0.035000,0.127000> rotate<0,-44.997030,0> translate<86.639400,0.000000,70.993000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<88.569800,0.000000,72.923400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<88.900000,0.000000,73.660000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-65.850112,0> translate<88.569800,0.000000,72.923400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<85.725000,-1.535000,55.549800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<89.560400,-1.535000,55.549800>}
box{<0,0,-0.127000><3.835400,0.035000,0.127000> rotate<0,0.000000,0> translate<85.725000,-1.535000,55.549800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<87.350600,-1.535000,67.589400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<90.043000,-1.535000,67.589400>}
box{<0,0,-0.127000><2.692400,0.035000,0.127000> rotate<0,0.000000,0> translate<87.350600,-1.535000,67.589400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<85.979000,-1.535000,60.121800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<90.195400,-1.535000,60.121800>}
box{<0,0,-0.127000><4.216400,0.035000,0.127000> rotate<0,0.000000,0> translate<85.979000,-1.535000,60.121800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.487000,-1.535000,58.089800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<90.703400,-1.535000,58.089800>}
box{<0,0,-0.127000><4.216400,0.035000,0.127000> rotate<0,0.000000,0> translate<86.487000,-1.535000,58.089800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<90.195400,-1.535000,60.121800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<90.703400,-1.535000,60.629800>}
box{<0,0,-0.127000><0.718420,0.035000,0.127000> rotate<0,-44.997030,0> translate<90.195400,-1.535000,60.121800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<88.112600,-1.535000,60.579000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<90.703400,-1.535000,63.169800>}
box{<0,0,-0.127000><3.663944,0.035000,0.127000> rotate<0,-44.997030,0> translate<88.112600,-1.535000,60.579000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<90.043000,-1.535000,67.589400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<90.703400,-1.535000,68.249800>}
box{<0,0,-0.127000><0.933947,0.035000,0.127000> rotate<0,-44.997030,0> translate<90.043000,-1.535000,67.589400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.080600,0.000000,52.959000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<90.754200,0.000000,52.959000>}
box{<0,0,-0.127000><4.673600,0.035000,0.127000> rotate<0,0.000000,0> translate<86.080600,0.000000,52.959000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<91.109800,0.000000,57.200800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<91.109800,0.000000,56.616600>}
box{<0,0,-0.127000><0.584200,0.035000,0.127000> rotate<0,-90.000000,0> translate<91.109800,0.000000,56.616600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<86.639400,0.000000,61.671200>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<91.109800,0.000000,57.200800>}
box{<0,0,-0.127000><6.322100,0.035000,0.127000> rotate<0,44.997030,0> translate<86.639400,0.000000,61.671200> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<89.560400,-1.535000,55.549800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<91.338400,-1.535000,57.327800>}
box{<0,0,-0.127000><2.514472,0.035000,0.127000> rotate<0,-44.997030,0> translate<89.560400,-1.535000,55.549800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<90.754200,0.000000,52.959000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<91.440000,0.000000,53.340000>}
box{<0,0,-0.127000><0.784527,0.035000,0.127000> rotate<0,-29.052687,0> translate<90.754200,0.000000,52.959000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<91.109800,0.000000,56.616600>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<91.440000,0.000000,55.880000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,65.850112,0> translate<91.109800,0.000000,56.616600> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<90.703400,-1.535000,58.089800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<91.440000,-1.535000,58.420000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-24.143948,0> translate<90.703400,-1.535000,58.089800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<90.703400,-1.535000,60.629800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<91.440000,-1.535000,60.960000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-24.143948,0> translate<90.703400,-1.535000,60.629800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<90.703400,-1.535000,63.169800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<91.440000,-1.535000,63.500000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-24.143948,0> translate<90.703400,-1.535000,63.169800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<90.703400,-1.535000,68.249800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<91.440000,-1.535000,68.580000>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,-24.143948,0> translate<90.703400,-1.535000,68.249800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<91.440000,-1.535000,66.040000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<91.770200,-1.535000,65.303400>}
box{<0,0,-0.127000><0.807225,0.035000,0.127000> rotate<0,65.850112,0> translate<91.440000,-1.535000,66.040000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<91.338400,-1.535000,57.327800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<91.897200,-1.535000,57.327800>}
box{<0,0,-0.127000><0.558800,0.035000,0.127000> rotate<0,0.000000,0> translate<91.338400,-1.535000,57.327800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<91.897200,-1.535000,57.327800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<92.532200,-1.535000,57.962800>}
box{<0,0,-0.127000><0.898026,0.035000,0.127000> rotate<0,-44.997030,0> translate<91.897200,-1.535000,57.327800> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<91.770200,-1.535000,65.303400>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<92.532200,-1.535000,64.541400>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,44.997030,0> translate<91.770200,-1.535000,65.303400> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<92.532200,-1.535000,57.962800>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<92.532200,-1.535000,64.541400>}
box{<0,0,-0.127000><6.578600,0.035000,0.127000> rotate<0,90.000000,0> translate<92.532200,-1.535000,64.541400> }
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
cylinder{<30.480000,0.038000,73.660000><30.480000,-1.538000,73.660000>0.508000}
cylinder{<33.020000,0.038000,73.660000><33.020000,-1.538000,73.660000>0.508000}
cylinder{<35.560000,0.038000,73.660000><35.560000,-1.538000,73.660000>0.508000}
cylinder{<38.100000,0.038000,73.660000><38.100000,-1.538000,73.660000>0.508000}
cylinder{<40.640000,0.038000,73.660000><40.640000,-1.538000,73.660000>0.508000}
cylinder{<43.180000,0.038000,73.660000><43.180000,-1.538000,73.660000>0.508000}
cylinder{<54.610000,0.038000,48.260000><54.610000,-1.538000,48.260000>0.508000}
cylinder{<57.150000,0.038000,48.260000><57.150000,-1.538000,48.260000>0.508000}
cylinder{<59.690000,0.038000,48.260000><59.690000,-1.538000,48.260000>0.508000}
cylinder{<62.230000,0.038000,48.260000><62.230000,-1.538000,48.260000>0.508000}
cylinder{<64.770000,0.038000,48.260000><64.770000,-1.538000,48.260000>0.508000}
cylinder{<67.310000,0.038000,48.260000><67.310000,-1.538000,48.260000>0.508000}
cylinder{<17.780000,0.038000,57.150000><17.780000,-1.538000,57.150000>0.406400}
cylinder{<20.320000,0.038000,57.150000><20.320000,-1.538000,57.150000>0.406400}
cylinder{<22.860000,0.038000,57.150000><22.860000,-1.538000,57.150000>0.406400}
cylinder{<22.860000,0.038000,64.770000><22.860000,-1.538000,64.770000>0.406400}
cylinder{<20.320000,0.038000,64.770000><20.320000,-1.538000,64.770000>0.406400}
cylinder{<17.780000,0.038000,64.770000><17.780000,-1.538000,64.770000>0.406400}
cylinder{<52.070000,0.038000,54.610000><52.070000,-1.538000,54.610000>0.406400}
cylinder{<54.610000,0.038000,54.610000><54.610000,-1.538000,54.610000>0.406400}
cylinder{<57.150000,0.038000,54.610000><57.150000,-1.538000,54.610000>0.406400}
cylinder{<59.690000,0.038000,54.610000><59.690000,-1.538000,54.610000>0.406400}
cylinder{<62.230000,0.038000,54.610000><62.230000,-1.538000,54.610000>0.406400}
cylinder{<64.770000,0.038000,54.610000><64.770000,-1.538000,54.610000>0.406400}
cylinder{<67.310000,0.038000,54.610000><67.310000,-1.538000,54.610000>0.406400}
cylinder{<69.850000,0.038000,54.610000><69.850000,-1.538000,54.610000>0.406400}
cylinder{<72.390000,0.038000,54.610000><72.390000,-1.538000,54.610000>0.406400}
cylinder{<74.930000,0.038000,54.610000><74.930000,-1.538000,54.610000>0.406400}
cylinder{<77.470000,0.038000,54.610000><77.470000,-1.538000,54.610000>0.406400}
cylinder{<80.010000,0.038000,54.610000><80.010000,-1.538000,54.610000>0.406400}
cylinder{<82.550000,0.038000,54.610000><82.550000,-1.538000,54.610000>0.406400}
cylinder{<85.090000,0.038000,54.610000><85.090000,-1.538000,54.610000>0.406400}
cylinder{<85.090000,0.038000,62.230000><85.090000,-1.538000,62.230000>0.406400}
cylinder{<82.550000,0.038000,62.230000><82.550000,-1.538000,62.230000>0.406400}
cylinder{<80.010000,0.038000,62.230000><80.010000,-1.538000,62.230000>0.406400}
cylinder{<77.470000,0.038000,62.230000><77.470000,-1.538000,62.230000>0.406400}
cylinder{<74.930000,0.038000,62.230000><74.930000,-1.538000,62.230000>0.406400}
cylinder{<72.390000,0.038000,62.230000><72.390000,-1.538000,62.230000>0.406400}
cylinder{<69.850000,0.038000,62.230000><69.850000,-1.538000,62.230000>0.406400}
cylinder{<67.310000,0.038000,62.230000><67.310000,-1.538000,62.230000>0.406400}
cylinder{<64.770000,0.038000,62.230000><64.770000,-1.538000,62.230000>0.406400}
cylinder{<62.230000,0.038000,62.230000><62.230000,-1.538000,62.230000>0.406400}
cylinder{<59.690000,0.038000,62.230000><59.690000,-1.538000,62.230000>0.406400}
cylinder{<57.150000,0.038000,62.230000><57.150000,-1.538000,62.230000>0.406400}
cylinder{<54.610000,0.038000,62.230000><54.610000,-1.538000,62.230000>0.406400}
cylinder{<52.070000,0.038000,62.230000><52.070000,-1.538000,62.230000>0.406400}
cylinder{<10.160000,0.038000,48.260000><10.160000,-1.538000,48.260000>0.508000}
cylinder{<12.700000,0.038000,48.260000><12.700000,-1.538000,48.260000>0.508000}
cylinder{<15.240000,0.038000,48.260000><15.240000,-1.538000,48.260000>0.508000}
cylinder{<17.780000,0.038000,48.260000><17.780000,-1.538000,48.260000>0.508000}
cylinder{<20.320000,0.038000,48.260000><20.320000,-1.538000,48.260000>0.508000}
cylinder{<22.860000,0.038000,48.260000><22.860000,-1.538000,48.260000>0.508000}
cylinder{<25.400000,0.038000,48.260000><25.400000,-1.538000,48.260000>0.508000}
cylinder{<27.940000,0.038000,48.260000><27.940000,-1.538000,48.260000>0.508000}
cylinder{<30.480000,0.038000,48.260000><30.480000,-1.538000,48.260000>0.508000}
cylinder{<33.020000,0.038000,48.260000><33.020000,-1.538000,48.260000>0.508000}
cylinder{<35.560000,0.038000,48.260000><35.560000,-1.538000,48.260000>0.508000}
cylinder{<38.100000,0.038000,48.260000><38.100000,-1.538000,48.260000>0.508000}
cylinder{<40.640000,0.038000,48.260000><40.640000,-1.538000,48.260000>0.508000}
cylinder{<43.180000,0.038000,48.260000><43.180000,-1.538000,48.260000>0.508000}
cylinder{<45.720000,0.038000,48.260000><45.720000,-1.538000,48.260000>0.508000}
cylinder{<48.260000,0.038000,48.260000><48.260000,-1.538000,48.260000>0.508000}
cylinder{<50.800000,0.038000,73.660000><50.800000,-1.538000,73.660000>0.508000}
cylinder{<53.340000,0.038000,73.660000><53.340000,-1.538000,73.660000>0.508000}
cylinder{<55.880000,0.038000,73.660000><55.880000,-1.538000,73.660000>0.508000}
cylinder{<58.420000,0.038000,73.660000><58.420000,-1.538000,73.660000>0.508000}
cylinder{<60.960000,0.038000,73.660000><60.960000,-1.538000,73.660000>0.508000}
cylinder{<63.500000,0.038000,73.660000><63.500000,-1.538000,73.660000>0.508000}
cylinder{<66.040000,0.038000,73.660000><66.040000,-1.538000,73.660000>0.508000}
cylinder{<68.580000,0.038000,73.660000><68.580000,-1.538000,73.660000>0.508000}
cylinder{<71.120000,0.038000,73.660000><71.120000,-1.538000,73.660000>0.508000}
cylinder{<73.660000,0.038000,73.660000><73.660000,-1.538000,73.660000>0.508000}
cylinder{<76.200000,0.038000,73.660000><76.200000,-1.538000,73.660000>0.508000}
cylinder{<78.740000,0.038000,73.660000><78.740000,-1.538000,73.660000>0.508000}
cylinder{<81.280000,0.038000,73.660000><81.280000,-1.538000,73.660000>0.508000}
cylinder{<83.820000,0.038000,73.660000><83.820000,-1.538000,73.660000>0.508000}
cylinder{<86.360000,0.038000,73.660000><86.360000,-1.538000,73.660000>0.508000}
cylinder{<88.900000,0.038000,73.660000><88.900000,-1.538000,73.660000>0.508000}
cylinder{<7.620000,0.038000,53.340000><7.620000,-1.538000,53.340000>0.508000}
cylinder{<7.620000,0.038000,55.880000><7.620000,-1.538000,55.880000>0.508000}
cylinder{<7.620000,0.038000,58.420000><7.620000,-1.538000,58.420000>0.508000}
cylinder{<7.620000,0.038000,60.960000><7.620000,-1.538000,60.960000>0.508000}
cylinder{<7.620000,0.038000,63.500000><7.620000,-1.538000,63.500000>0.508000}
cylinder{<7.620000,0.038000,66.040000><7.620000,-1.538000,66.040000>0.508000}
cylinder{<7.620000,0.038000,68.580000><7.620000,-1.538000,68.580000>0.508000}
cylinder{<91.440000,0.038000,68.580000><91.440000,-1.538000,68.580000>0.508000}
cylinder{<91.440000,0.038000,66.040000><91.440000,-1.538000,66.040000>0.508000}
cylinder{<91.440000,0.038000,63.500000><91.440000,-1.538000,63.500000>0.508000}
cylinder{<91.440000,0.038000,60.960000><91.440000,-1.538000,60.960000>0.508000}
cylinder{<91.440000,0.038000,58.420000><91.440000,-1.538000,58.420000>0.508000}
cylinder{<91.440000,0.038000,55.880000><91.440000,-1.538000,55.880000>0.508000}
cylinder{<91.440000,0.038000,53.340000><91.440000,-1.538000,53.340000>0.508000}
cylinder{<24.130000,0.038000,71.120000><24.130000,-1.538000,71.120000>0.500000}
cylinder{<19.050000,0.038000,73.660000><19.050000,-1.538000,73.660000>0.500000}
cylinder{<19.050000,0.038000,68.580000><19.050000,-1.538000,68.580000>0.500000}
cylinder{<38.100000,0.038000,68.580000><38.100000,-1.538000,68.580000>0.406400}
cylinder{<48.260000,0.038000,68.580000><48.260000,-1.538000,68.580000>0.406400}
cylinder{<76.200000,0.038000,68.580000><76.200000,-1.538000,68.580000>0.406400}
cylinder{<86.360000,0.038000,68.580000><86.360000,-1.538000,68.580000>0.406400}
cylinder{<50.800000,0.038000,68.580000><50.800000,-1.538000,68.580000>0.406400}
cylinder{<60.960000,0.038000,68.580000><60.960000,-1.538000,68.580000>0.406400}
cylinder{<36.830000,0.038000,54.610000><36.830000,-1.538000,54.610000>0.406400}
cylinder{<36.830000,0.038000,64.770000><36.830000,-1.538000,64.770000>0.406400}
cylinder{<31.750000,0.038000,54.610000><31.750000,-1.538000,54.610000>0.406400}
cylinder{<31.750000,0.038000,64.770000><31.750000,-1.538000,64.770000>0.406400}
cylinder{<43.180000,0.038000,54.610000><43.180000,-1.538000,54.610000>0.406400}
cylinder{<43.180000,0.038000,64.770000><43.180000,-1.538000,64.770000>0.406400}
cylinder{<63.500000,0.038000,68.580000><63.500000,-1.538000,68.580000>0.406400}
cylinder{<73.660000,0.038000,68.580000><73.660000,-1.538000,68.580000>0.406400}
//Holes(fast)/Vias
cylinder{<42.214800,0.038000,63.779400><42.214800,-1.538000,63.779400>0.304800 }
cylinder{<57.454800,0.038000,69.697600><57.454800,-1.538000,69.697600>0.304800 }
cylinder{<42.341800,0.038000,62.458600><42.341800,-1.538000,62.458600>0.304800 }
cylinder{<39.852600,0.038000,62.865000><39.852600,-1.538000,62.865000>0.304800 }
cylinder{<46.558200,0.038000,69.570600><46.558200,-1.538000,69.570600>0.304800 }
cylinder{<50.165000,0.038000,60.858400><50.165000,-1.538000,60.858400>0.304800 }
cylinder{<50.647600,0.038000,59.690000><50.647600,-1.538000,59.690000>0.304800 }
cylinder{<57.480200,0.038000,56.642000><57.480200,-1.538000,56.642000>0.304800 }
cylinder{<60.985400,0.038000,58.851800><60.985400,-1.538000,58.851800>0.304800 }
cylinder{<44.348400,0.038000,71.882000><44.348400,-1.538000,71.882000>0.304800 }
cylinder{<59.334400,0.038000,59.309000><59.334400,-1.538000,59.309000>0.304800 }
cylinder{<47.980600,0.038000,55.600600><47.980600,-1.538000,55.600600>0.304800 }
cylinder{<56.083200,0.038000,50.749200><56.083200,-1.538000,50.749200>0.304800 }
cylinder{<42.138600,0.038000,50.723800><42.138600,-1.538000,50.723800>0.304800 }
cylinder{<42.621200,0.038000,51.892200><42.621200,-1.538000,51.892200>0.304800 }
cylinder{<52.882800,0.038000,51.892200><52.882800,-1.538000,51.892200>0.304800 }
cylinder{<56.642000,0.038000,51.892200><56.642000,-1.538000,51.892200>0.304800 }
cylinder{<60.985400,0.038000,51.282600><60.985400,-1.538000,51.282600>0.304800 }
cylinder{<32.816800,0.038000,46.329600><32.816800,-1.538000,46.329600>0.304800 }
cylinder{<59.918600,0.038000,52.120800><59.918600,-1.538000,52.120800>0.304800 }
cylinder{<37.058600,0.038000,62.026800><37.058600,-1.538000,62.026800>0.304800 }
cylinder{<36.220400,0.038000,59.994800><36.220400,-1.538000,59.994800>0.304800 }
cylinder{<61.163200,0.038000,75.590400><61.163200,-1.538000,75.590400>0.304800 }
cylinder{<34.188400,0.038000,60.807600><34.188400,-1.538000,60.807600>0.304800 }
cylinder{<58.089800,0.038000,76.123800><58.089800,-1.538000,76.123800>0.304800 }
cylinder{<34.188400,0.038000,62.026800><34.188400,-1.538000,62.026800>0.304800 }
cylinder{<49.784000,0.038000,76.123800><49.784000,-1.538000,76.123800>0.304800 }
cylinder{<52.349400,0.038000,69.723000><52.349400,-1.538000,69.723000>0.304800 }
cylinder{<40.436800,0.038000,53.619400><40.436800,-1.538000,53.619400>0.304800 }
cylinder{<35.890200,0.038000,51.333400><35.890200,-1.538000,51.333400>0.304800 }
cylinder{<73.355200,0.038000,70.408800><73.355200,-1.538000,70.408800>0.304800 }
cylinder{<62.153800,0.038000,59.359800><62.153800,-1.538000,59.359800>0.304800 }
cylinder{<70.967600,0.038000,65.481200><70.967600,-1.538000,65.481200>0.304800 }
cylinder{<63.652400,0.038000,60.198000><63.652400,-1.538000,60.198000>0.304800 }
cylinder{<78.308200,0.038000,56.388000><78.308200,-1.538000,56.388000>0.304800 }
cylinder{<63.322200,0.038000,47.244000><63.322200,-1.538000,47.244000>0.304800 }
//Holes(fast)/Board
texture{col_hls}
}
#if(pcb_silkscreen=on)
//Silk Screen
union{
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,53.378100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,53.691600>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,90.000000,0> translate<10.121900,0.000000,53.691600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,53.534800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,53.534800>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<9.181300,0.000000,53.534800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,53.378100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,53.691600>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,90.000000,0> translate<9.181300,0.000000,53.691600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,54.628700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,54.001700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<10.121900,0.000000,54.001700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,54.001700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.494900,0.000000,54.628700>}
box{<0,0,-0.038100><0.886712,0.036000,0.038100> rotate<0,44.997030,0> translate<9.494900,0.000000,54.628700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.494900,0.000000,54.628700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.338100,0.000000,54.628700>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<9.338100,0.000000,54.628700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.338100,0.000000,54.628700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,54.472000>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<9.181300,0.000000,54.472000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,54.472000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,54.158400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<9.181300,0.000000,54.158400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,54.158400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.338100,0.000000,54.001700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<9.181300,0.000000,54.158400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.338100,0.000000,55.564200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,55.407500>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<9.181300,0.000000,55.407500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,55.407500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,55.093900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<9.181300,0.000000,55.093900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,55.093900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.338100,0.000000,54.937200>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<9.181300,0.000000,55.093900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.338100,0.000000,54.937200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.965200,0.000000,54.937200>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<9.338100,0.000000,54.937200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.965200,0.000000,54.937200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,55.093900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<9.965200,0.000000,54.937200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,55.093900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,55.407500>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<10.121900,0.000000,55.407500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,55.407500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.965200,0.000000,55.564200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<9.965200,0.000000,55.564200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,55.872700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,56.499700>}
box{<0,0,-0.038100><1.130424,0.036000,0.038100> rotate<0,33.685033,0> translate<9.181300,0.000000,56.499700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.338100,0.000000,57.435200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,57.278500>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<9.181300,0.000000,57.278500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,57.278500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,56.964900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<9.181300,0.000000,56.964900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,56.964900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.338100,0.000000,56.808200>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<9.181300,0.000000,56.964900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.338100,0.000000,56.808200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.494900,0.000000,56.808200>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<9.338100,0.000000,56.808200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.494900,0.000000,56.808200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.651600,0.000000,56.964900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<9.494900,0.000000,56.808200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.651600,0.000000,56.964900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.651600,0.000000,57.278500>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<9.651600,0.000000,57.278500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.651600,0.000000,57.278500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.808400,0.000000,57.435200>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<9.651600,0.000000,57.278500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.808400,0.000000,57.435200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.965200,0.000000,57.435200>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<9.808400,0.000000,57.435200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.965200,0.000000,57.435200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,57.278500>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<9.965200,0.000000,57.435200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,57.278500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,56.964900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<10.121900,0.000000,56.964900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,56.964900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.965200,0.000000,56.808200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<9.965200,0.000000,56.808200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,58.370700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,57.743700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<9.181300,0.000000,57.743700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,57.743700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,57.743700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<9.181300,0.000000,57.743700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,57.743700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,58.370700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<10.121900,0.000000,58.370700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.651600,0.000000,57.743700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.651600,0.000000,58.057200>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,90.000000,0> translate<9.651600,0.000000,58.057200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,58.679200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,58.679200>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<9.181300,0.000000,58.679200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,58.679200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,59.149500>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<9.181300,0.000000,59.149500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,59.149500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.338100,0.000000,59.306200>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<9.181300,0.000000,59.149500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.338100,0.000000,59.306200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.651600,0.000000,59.306200>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<9.338100,0.000000,59.306200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.651600,0.000000,59.306200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.808400,0.000000,59.149500>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<9.651600,0.000000,59.306200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.808400,0.000000,59.149500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.808400,0.000000,58.679200>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<9.808400,0.000000,58.679200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.808400,0.000000,58.992700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,59.306200>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<9.808400,0.000000,58.992700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,59.614700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,59.928200>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,90.000000,0> translate<10.121900,0.000000,59.928200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,59.771400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,59.771400>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<9.181300,0.000000,59.771400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,59.614700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,59.928200>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,90.000000,0> translate<9.181300,0.000000,59.928200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,60.238300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.494900,0.000000,60.238300>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<9.494900,0.000000,60.238300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.494900,0.000000,60.238300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,60.551800>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<9.181300,0.000000,60.551800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,60.551800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.494900,0.000000,60.865300>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<9.181300,0.000000,60.551800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.494900,0.000000,60.865300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,60.865300>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<9.494900,0.000000,60.865300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.651600,0.000000,60.238300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.651600,0.000000,60.865300>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<9.651600,0.000000,60.865300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,61.173800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,61.173800>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<9.181300,0.000000,61.173800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,61.173800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,61.800800>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<10.121900,0.000000,61.800800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,63.044800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,63.358300>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,90.000000,0> translate<10.121900,0.000000,63.358300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,63.201500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,63.201500>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<9.181300,0.000000,63.201500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,63.044800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,63.358300>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,90.000000,0> translate<9.181300,0.000000,63.358300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,63.668400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,63.668400>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<9.181300,0.000000,63.668400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,63.668400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,64.295400>}
box{<0,0,-0.038100><1.130424,0.036000,0.038100> rotate<0,-33.685033,0> translate<9.181300,0.000000,63.668400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,64.295400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,64.295400>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<9.181300,0.000000,64.295400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,64.603900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,64.603900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<9.181300,0.000000,64.603900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,64.603900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,65.074200>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<9.181300,0.000000,65.074200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,65.074200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.338100,0.000000,65.230900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<9.181300,0.000000,65.074200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.338100,0.000000,65.230900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.651600,0.000000,65.230900>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<9.338100,0.000000,65.230900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.651600,0.000000,65.230900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.808400,0.000000,65.074200>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<9.651600,0.000000,65.230900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.808400,0.000000,65.074200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.808400,0.000000,64.603900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<9.808400,0.000000,64.603900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,65.539400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.965200,0.000000,65.539400>}
box{<0,0,-0.038100><0.783900,0.036000,0.038100> rotate<0,0.000000,0> translate<9.181300,0.000000,65.539400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.965200,0.000000,65.539400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,65.696100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<9.965200,0.000000,65.539400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,65.696100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,66.009700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<10.121900,0.000000,66.009700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,66.009700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.965200,0.000000,66.166400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<9.965200,0.000000,66.166400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.965200,0.000000,66.166400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,66.166400>}
box{<0,0,-0.038100><0.783900,0.036000,0.038100> rotate<0,0.000000,0> translate<9.181300,0.000000,66.166400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,66.788400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,66.788400>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<9.181300,0.000000,66.788400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,66.474900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,67.101900>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<9.181300,0.000000,67.101900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,68.541900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,68.228400>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,-90.000000,0> translate<88.938100,0.000000,68.228400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,68.385200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,68.385200>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<88.938100,0.000000,68.385200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,68.541900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,68.228400>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,-90.000000,0> translate<89.878700,0.000000,68.228400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,67.291300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,67.918300>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<88.938100,0.000000,67.918300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,67.918300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.565100,0.000000,67.291300>}
box{<0,0,-0.038100><0.886712,0.036000,0.038100> rotate<0,44.997030,0> translate<88.938100,0.000000,67.918300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.565100,0.000000,67.291300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,67.291300>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<89.565100,0.000000,67.291300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,67.291300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,67.448000>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<89.721900,0.000000,67.291300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,67.448000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,67.761600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<89.878700,0.000000,67.761600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,67.761600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,67.918300>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<89.721900,0.000000,67.918300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,66.355800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,66.512500>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<89.721900,0.000000,66.355800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,66.512500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,66.826100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<89.878700,0.000000,66.826100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,66.826100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,66.982800>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<89.721900,0.000000,66.982800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,66.982800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,66.982800>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<89.094800,0.000000,66.982800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,66.982800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,66.826100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<88.938100,0.000000,66.826100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,66.826100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,66.512500>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<88.938100,0.000000,66.512500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,66.512500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,66.355800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<88.938100,0.000000,66.512500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,66.047300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,65.420300>}
box{<0,0,-0.038100><1.130424,0.036000,0.038100> rotate<0,33.685033,0> translate<88.938100,0.000000,66.047300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,64.484800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,64.641500>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<89.721900,0.000000,64.484800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,64.641500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,64.955100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<89.878700,0.000000,64.955100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,64.955100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,65.111800>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<89.721900,0.000000,65.111800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,65.111800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.565100,0.000000,65.111800>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<89.565100,0.000000,65.111800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.565100,0.000000,65.111800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.408400,0.000000,64.955100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<89.408400,0.000000,64.955100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.408400,0.000000,64.955100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.408400,0.000000,64.641500>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<89.408400,0.000000,64.641500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.408400,0.000000,64.641500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.251600,0.000000,64.484800>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<89.251600,0.000000,64.484800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.251600,0.000000,64.484800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,64.484800>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<89.094800,0.000000,64.484800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,64.484800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,64.641500>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<88.938100,0.000000,64.641500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,64.641500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,64.955100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<88.938100,0.000000,64.955100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,64.955100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,65.111800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<88.938100,0.000000,64.955100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,63.549300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,64.176300>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<89.878700,0.000000,64.176300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,64.176300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,64.176300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<88.938100,0.000000,64.176300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,64.176300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,63.549300>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<88.938100,0.000000,63.549300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.408400,0.000000,64.176300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.408400,0.000000,63.862800>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,-90.000000,0> translate<89.408400,0.000000,63.862800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,63.240800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,63.240800>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<88.938100,0.000000,63.240800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,63.240800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,62.770500>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<89.878700,0.000000,62.770500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,62.770500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,62.613800>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<89.721900,0.000000,62.613800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,62.613800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.408400,0.000000,62.613800>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<89.408400,0.000000,62.613800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.408400,0.000000,62.613800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.251600,0.000000,62.770500>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<89.251600,0.000000,62.770500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.251600,0.000000,62.770500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.251600,0.000000,63.240800>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<89.251600,0.000000,63.240800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.251600,0.000000,62.927300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,62.613800>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<88.938100,0.000000,62.613800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,62.305300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,61.991800>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,-90.000000,0> translate<88.938100,0.000000,61.991800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,62.148600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,62.148600>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<88.938100,0.000000,62.148600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,62.305300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,61.991800>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,-90.000000,0> translate<89.878700,0.000000,61.991800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,61.681700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.565100,0.000000,61.681700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<88.938100,0.000000,61.681700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.565100,0.000000,61.681700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,61.368200>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<89.565100,0.000000,61.681700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,61.368200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.565100,0.000000,61.054700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<89.565100,0.000000,61.054700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.565100,0.000000,61.054700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,61.054700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<88.938100,0.000000,61.054700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.408400,0.000000,61.681700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.408400,0.000000,61.054700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<89.408400,0.000000,61.054700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,60.746200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,60.746200>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<88.938100,0.000000,60.746200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,60.746200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,60.119200>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<88.938100,0.000000,60.119200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,58.404900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,58.718500>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<89.878700,0.000000,58.718500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,58.718500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,58.875200>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<89.721900,0.000000,58.875200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,58.875200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,58.875200>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<89.094800,0.000000,58.875200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,58.875200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,58.718500>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<88.938100,0.000000,58.718500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,58.718500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,58.404900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<88.938100,0.000000,58.404900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,58.404900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,58.248200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<88.938100,0.000000,58.404900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,58.248200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,58.248200>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<89.094800,0.000000,58.248200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,58.248200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,58.404900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<89.721900,0.000000,58.248200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,57.939700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,57.939700>}
box{<0,0,-0.038100><0.783900,0.036000,0.038100> rotate<0,0.000000,0> translate<89.094800,0.000000,57.939700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,57.939700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,57.783000>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<88.938100,0.000000,57.783000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,57.783000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,57.469400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<88.938100,0.000000,57.469400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,57.469400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,57.312700>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<88.938100,0.000000,57.469400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,57.312700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,57.312700>}
box{<0,0,-0.038100><0.783900,0.036000,0.038100> rotate<0,0.000000,0> translate<89.094800,0.000000,57.312700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,56.690700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,56.690700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<88.938100,0.000000,56.690700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,57.004200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,56.377200>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<89.878700,0.000000,56.377200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,56.068700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,56.068700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<88.938100,0.000000,56.068700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,56.068700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,55.598400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<89.878700,0.000000,55.598400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,55.598400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,55.441700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<89.721900,0.000000,55.441700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,55.441700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.408400,0.000000,55.441700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<89.408400,0.000000,55.441700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.408400,0.000000,55.441700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.251600,0.000000,55.598400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<89.251600,0.000000,55.598400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.251600,0.000000,55.598400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.251600,0.000000,56.068700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<89.251600,0.000000,56.068700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,55.133200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,55.133200>}
box{<0,0,-0.038100><0.783900,0.036000,0.038100> rotate<0,0.000000,0> translate<89.094800,0.000000,55.133200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,55.133200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,54.976500>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<88.938100,0.000000,54.976500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,54.976500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,54.662900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<88.938100,0.000000,54.662900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,54.662900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,54.506200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<88.938100,0.000000,54.662900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,54.506200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,54.506200>}
box{<0,0,-0.038100><0.783900,0.036000,0.038100> rotate<0,0.000000,0> translate<89.094800,0.000000,54.506200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,53.884200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,53.884200>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<88.938100,0.000000,53.884200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,54.197700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,53.570700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<89.878700,0.000000,53.570700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.378100,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.378100,0.000000,51.778700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<53.378100,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.378100,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.848400,0.000000,51.778700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<53.378100,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.848400,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.005100,0.000000,51.621900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<53.848400,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.005100,0.000000,51.621900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.005100,0.000000,51.465100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<54.005100,0.000000,51.465100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.005100,0.000000,51.465100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.848400,0.000000,51.308400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<53.848400,0.000000,51.308400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.848400,0.000000,51.308400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.005100,0.000000,51.151600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<53.848400,0.000000,51.308400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.005100,0.000000,51.151600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.005100,0.000000,50.994800>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<54.005100,0.000000,50.994800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.005100,0.000000,50.994800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.848400,0.000000,50.838100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<53.848400,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.848400,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.378100,0.000000,50.838100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<53.378100,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.378100,0.000000,51.308400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.848400,0.000000,51.308400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<53.378100,0.000000,51.308400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.313600,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.313600,0.000000,50.994800>}
box{<0,0,-0.038100><0.783900,0.036000,0.038100> rotate<0,-90.000000,0> translate<54.313600,0.000000,50.994800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.313600,0.000000,50.994800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.470300,0.000000,50.838100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<54.313600,0.000000,50.994800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.470300,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.783900,0.000000,50.838100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<54.470300,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.783900,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.940600,0.000000,50.994800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<54.783900,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.940600,0.000000,50.994800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.940600,0.000000,51.778700>}
box{<0,0,-0.038100><0.783900,0.036000,0.038100> rotate<0,90.000000,0> translate<54.940600,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<55.562600,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<55.562600,0.000000,51.778700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<55.562600,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<55.249100,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<55.876100,0.000000,51.778700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<55.249100,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.498100,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.498100,0.000000,51.778700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<56.498100,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.184600,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.811600,0.000000,51.778700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<56.184600,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.590400,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.276800,0.000000,51.778700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<57.276800,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.276800,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.120100,0.000000,51.621900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<57.120100,0.000000,51.621900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.120100,0.000000,51.621900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.120100,0.000000,50.994800>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,-90.000000,0> translate<57.120100,0.000000,50.994800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.120100,0.000000,50.994800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.276800,0.000000,50.838100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<57.120100,0.000000,50.994800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.276800,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.590400,0.000000,50.838100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<57.276800,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.590400,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.747100,0.000000,50.994800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<57.590400,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.747100,0.000000,50.994800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.747100,0.000000,51.621900>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,90.000000,0> translate<57.747100,0.000000,51.621900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.747100,0.000000,51.621900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.590400,0.000000,51.778700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<57.590400,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.055600,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.055600,0.000000,51.778700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<58.055600,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.055600,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.682600,0.000000,50.838100>}
box{<0,0,-0.038100><1.130424,0.036000,0.038100> rotate<0,56.309028,0> translate<58.055600,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.682600,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.682600,0.000000,51.778700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<58.682600,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.926600,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<60.240100,0.000000,50.838100>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<59.926600,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<60.083300,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<60.083300,0.000000,51.778700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<60.083300,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.926600,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<60.240100,0.000000,51.778700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<59.926600,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<60.550200,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<60.550200,0.000000,51.778700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<60.550200,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<60.550200,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.177200,0.000000,50.838100>}
box{<0,0,-0.038100><1.130424,0.036000,0.038100> rotate<0,56.309028,0> translate<60.550200,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.177200,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.177200,0.000000,51.778700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<61.177200,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.799200,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.799200,0.000000,51.778700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<61.799200,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.485700,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.112700,0.000000,51.778700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<61.485700,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.048200,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.421200,0.000000,51.778700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<62.421200,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.421200,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.421200,0.000000,50.838100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<62.421200,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.421200,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.048200,0.000000,50.838100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<62.421200,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.421200,0.000000,51.308400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.734700,0.000000,51.308400>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<62.421200,0.000000,51.308400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.356700,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.356700,0.000000,51.778700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<63.356700,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.356700,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.827000,0.000000,51.778700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<63.356700,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.827000,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.983700,0.000000,51.621900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<63.827000,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.983700,0.000000,51.621900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.983700,0.000000,51.308400>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,-90.000000,0> translate<63.983700,0.000000,51.308400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.983700,0.000000,51.308400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.827000,0.000000,51.151600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<63.827000,0.000000,51.151600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.827000,0.000000,51.151600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.356700,0.000000,51.151600>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<63.356700,0.000000,51.151600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.670200,0.000000,51.151600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.983700,0.000000,50.838100>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<63.670200,0.000000,51.151600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.292200,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.292200,0.000000,51.778700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<64.292200,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.292200,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.919200,0.000000,51.778700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<64.292200,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.292200,0.000000,51.308400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.605700,0.000000,51.308400>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<64.292200,0.000000,51.308400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<65.227700,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<65.227700,0.000000,51.465100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<65.227700,0.000000,51.465100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<65.227700,0.000000,51.465100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<65.541200,0.000000,51.778700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-45.006166,0> translate<65.227700,0.000000,51.465100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<65.541200,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<65.854700,0.000000,51.465100>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,45.006166,0> translate<65.541200,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<65.854700,0.000000,51.465100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<65.854700,0.000000,50.838100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<65.854700,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<65.227700,0.000000,51.308400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<65.854700,0.000000,51.308400>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<65.227700,0.000000,51.308400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.790200,0.000000,51.621900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.633500,0.000000,51.778700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<66.633500,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.633500,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.319900,0.000000,51.778700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<66.319900,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.319900,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.163200,0.000000,51.621900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<66.163200,0.000000,51.621900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.163200,0.000000,51.621900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.163200,0.000000,50.994800>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,-90.000000,0> translate<66.163200,0.000000,50.994800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.163200,0.000000,50.994800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.319900,0.000000,50.838100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<66.163200,0.000000,50.994800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.319900,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.633500,0.000000,50.838100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<66.319900,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.633500,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.790200,0.000000,50.994800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<66.633500,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.725700,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.098700,0.000000,51.778700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<67.098700,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.098700,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.098700,0.000000,50.838100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<67.098700,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.098700,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.725700,0.000000,50.838100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<67.098700,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.098700,0.000000,51.308400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.412200,0.000000,51.308400>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<67.098700,0.000000,51.308400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.411900,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.411900,0.000000,70.141300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<44.411900,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.411900,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.941600,0.000000,70.141300>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<43.941600,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.941600,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.784900,0.000000,70.298100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<43.784900,0.000000,70.298100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.784900,0.000000,70.298100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.784900,0.000000,70.454900>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,90.000000,0> translate<43.784900,0.000000,70.454900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.784900,0.000000,70.454900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.941600,0.000000,70.611600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<43.784900,0.000000,70.454900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.941600,0.000000,70.611600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.784900,0.000000,70.768400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<43.784900,0.000000,70.768400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.784900,0.000000,70.768400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.784900,0.000000,70.925200>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,90.000000,0> translate<43.784900,0.000000,70.925200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.784900,0.000000,70.925200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.941600,0.000000,71.081900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<43.784900,0.000000,70.925200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.941600,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.411900,0.000000,71.081900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<43.941600,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.411900,0.000000,70.611600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.941600,0.000000,70.611600>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<43.941600,0.000000,70.611600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.476400,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.476400,0.000000,70.925200>}
box{<0,0,-0.038100><0.783900,0.036000,0.038100> rotate<0,90.000000,0> translate<43.476400,0.000000,70.925200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.476400,0.000000,70.925200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.319700,0.000000,71.081900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<43.319700,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.319700,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.006100,0.000000,71.081900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<43.006100,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.006100,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.849400,0.000000,70.925200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<42.849400,0.000000,70.925200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.849400,0.000000,70.925200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.849400,0.000000,70.141300>}
box{<0,0,-0.038100><0.783900,0.036000,0.038100> rotate<0,-90.000000,0> translate<42.849400,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.227400,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.227400,0.000000,70.141300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<42.227400,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.540900,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.913900,0.000000,70.141300>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<41.913900,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.291900,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.291900,0.000000,70.141300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<41.291900,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.605400,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.978400,0.000000,70.141300>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<40.978400,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.199600,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.513200,0.000000,70.141300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<40.199600,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.513200,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.669900,0.000000,70.298100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<40.513200,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.669900,0.000000,70.298100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.669900,0.000000,70.925200>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,90.000000,0> translate<40.669900,0.000000,70.925200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.669900,0.000000,70.925200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.513200,0.000000,71.081900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<40.513200,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.513200,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.199600,0.000000,71.081900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<40.199600,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.199600,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.042900,0.000000,70.925200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<40.042900,0.000000,70.925200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.042900,0.000000,70.925200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.042900,0.000000,70.298100>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,-90.000000,0> translate<40.042900,0.000000,70.298100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.042900,0.000000,70.298100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.199600,0.000000,70.141300>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<40.042900,0.000000,70.298100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.734400,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.734400,0.000000,70.141300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<39.734400,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.734400,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.107400,0.000000,71.081900>}
box{<0,0,-0.038100><1.130424,0.036000,0.038100> rotate<0,56.309028,0> translate<39.107400,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.107400,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.107400,0.000000,70.141300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<39.107400,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.863400,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.549900,0.000000,71.081900>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<37.549900,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.706700,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.706700,0.000000,70.141300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<37.706700,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.863400,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.549900,0.000000,70.141300>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<37.549900,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.239800,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.239800,0.000000,70.141300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<37.239800,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.239800,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.612800,0.000000,71.081900>}
box{<0,0,-0.038100><1.130424,0.036000,0.038100> rotate<0,56.309028,0> translate<36.612800,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.612800,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.612800,0.000000,70.141300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<36.612800,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.990800,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.990800,0.000000,70.141300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<35.990800,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.304300,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.677300,0.000000,70.141300>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<35.677300,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<34.741800,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.368800,0.000000,70.141300>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<34.741800,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.368800,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.368800,0.000000,71.081900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<35.368800,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.368800,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<34.741800,0.000000,71.081900>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<34.741800,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.368800,0.000000,70.611600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.055300,0.000000,70.611600>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<35.055300,0.000000,70.611600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<34.433300,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<34.433300,0.000000,70.141300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<34.433300,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<34.433300,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.963000,0.000000,70.141300>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<33.963000,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.963000,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.806300,0.000000,70.298100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<33.806300,0.000000,70.298100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.806300,0.000000,70.298100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.806300,0.000000,70.611600>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,90.000000,0> translate<33.806300,0.000000,70.611600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.806300,0.000000,70.611600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.963000,0.000000,70.768400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<33.806300,0.000000,70.611600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.963000,0.000000,70.768400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<34.433300,0.000000,70.768400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<33.963000,0.000000,70.768400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<34.119800,0.000000,70.768400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.806300,0.000000,71.081900>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<33.806300,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.497800,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.497800,0.000000,70.141300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<33.497800,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.497800,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.870800,0.000000,70.141300>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<32.870800,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.497800,0.000000,70.611600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.184300,0.000000,70.611600>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<33.184300,0.000000,70.611600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.562300,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.562300,0.000000,70.454900>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<32.562300,0.000000,70.454900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.562300,0.000000,70.454900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.248800,0.000000,70.141300>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-45.006166,0> translate<32.248800,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.248800,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.935300,0.000000,70.454900>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,45.006166,0> translate<31.935300,0.000000,70.454900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.935300,0.000000,70.454900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.935300,0.000000,71.081900>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<31.935300,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.562300,0.000000,70.611600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.935300,0.000000,70.611600>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<31.935300,0.000000,70.611600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.999800,0.000000,70.298100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.156500,0.000000,70.141300>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<30.999800,0.000000,70.298100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.156500,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.470100,0.000000,70.141300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<31.156500,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.470100,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.626800,0.000000,70.298100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<31.470100,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.626800,0.000000,70.298100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.626800,0.000000,70.925200>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,90.000000,0> translate<31.626800,0.000000,70.925200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.626800,0.000000,70.925200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.470100,0.000000,71.081900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<31.470100,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.470100,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.156500,0.000000,71.081900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<31.156500,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.156500,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.999800,0.000000,70.925200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<30.999800,0.000000,70.925200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.064300,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.691300,0.000000,70.141300>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<30.064300,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.691300,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.691300,0.000000,71.081900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<30.691300,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.691300,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.064300,0.000000,71.081900>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<30.064300,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.691300,0.000000,70.611600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.377800,0.000000,70.611600>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<30.377800,0.000000,70.611600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.898100,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.898100,0.000000,50.838100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<22.898100,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.898100,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.525100,0.000000,50.838100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<22.898100,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.460600,0.000000,51.621900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.303900,0.000000,51.778700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<24.303900,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.303900,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.990300,0.000000,51.778700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<23.990300,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.990300,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.833600,0.000000,51.621900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<23.833600,0.000000,51.621900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.833600,0.000000,51.621900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.833600,0.000000,50.994800>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,-90.000000,0> translate<23.833600,0.000000,50.994800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.833600,0.000000,50.994800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.990300,0.000000,50.838100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<23.833600,0.000000,50.994800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.990300,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.303900,0.000000,50.838100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<23.990300,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.303900,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.460600,0.000000,50.994800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<24.303900,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.769100,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.769100,0.000000,50.838100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<24.769100,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.769100,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.239400,0.000000,50.838100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<24.769100,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.239400,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.396100,0.000000,50.994800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<25.239400,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.396100,0.000000,50.994800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.396100,0.000000,51.621900>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,90.000000,0> translate<25.396100,0.000000,51.621900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.396100,0.000000,51.621900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.239400,0.000000,51.778700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<25.239400,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.239400,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.769100,0.000000,51.778700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<24.769100,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<26.640100,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<26.953600,0.000000,50.838100>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<26.640100,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<26.796800,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<26.796800,0.000000,51.778700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<26.796800,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<26.640100,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<26.953600,0.000000,51.778700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<26.640100,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.263700,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.263700,0.000000,51.778700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<27.263700,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.263700,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.890700,0.000000,50.838100>}
box{<0,0,-0.038100><1.130424,0.036000,0.038100> rotate<0,56.309028,0> translate<27.263700,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.890700,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.890700,0.000000,51.778700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<27.890700,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<28.512700,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<28.512700,0.000000,51.778700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<28.512700,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<28.199200,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<28.826200,0.000000,51.778700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<28.199200,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<29.761700,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<29.134700,0.000000,51.778700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<29.134700,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<29.134700,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<29.134700,0.000000,50.838100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<29.134700,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<29.134700,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<29.761700,0.000000,50.838100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<29.134700,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<29.134700,0.000000,51.308400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<29.448200,0.000000,51.308400>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<29.134700,0.000000,51.308400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.070200,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.070200,0.000000,51.778700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<30.070200,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.070200,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.540500,0.000000,51.778700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<30.070200,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.540500,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.697200,0.000000,51.621900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<30.540500,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.697200,0.000000,51.621900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.697200,0.000000,51.308400>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,-90.000000,0> translate<30.697200,0.000000,51.308400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.697200,0.000000,51.308400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.540500,0.000000,51.151600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<30.540500,0.000000,51.151600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.540500,0.000000,51.151600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.070200,0.000000,51.151600>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<30.070200,0.000000,51.151600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.383700,0.000000,51.151600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.697200,0.000000,50.838100>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<30.383700,0.000000,51.151600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.005700,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.005700,0.000000,51.778700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<31.005700,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.005700,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.632700,0.000000,51.778700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<31.005700,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.005700,0.000000,51.308400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.319200,0.000000,51.308400>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<31.005700,0.000000,51.308400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.941200,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.941200,0.000000,51.465100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<31.941200,0.000000,51.465100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.941200,0.000000,51.465100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.254700,0.000000,51.778700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-45.006166,0> translate<31.941200,0.000000,51.465100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.254700,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.568200,0.000000,51.465100>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,45.006166,0> translate<32.254700,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.568200,0.000000,51.465100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.568200,0.000000,50.838100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<32.568200,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.941200,0.000000,51.308400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.568200,0.000000,51.308400>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<31.941200,0.000000,51.308400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.503700,0.000000,51.621900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.347000,0.000000,51.778700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<33.347000,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.347000,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.033400,0.000000,51.778700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<33.033400,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.033400,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.876700,0.000000,51.621900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<32.876700,0.000000,51.621900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.876700,0.000000,51.621900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.876700,0.000000,50.994800>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,-90.000000,0> translate<32.876700,0.000000,50.994800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.876700,0.000000,50.994800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.033400,0.000000,50.838100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<32.876700,0.000000,50.994800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.033400,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.347000,0.000000,50.838100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<33.033400,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.347000,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.503700,0.000000,50.994800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<33.347000,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<34.439200,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.812200,0.000000,51.778700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<33.812200,0.000000,51.778700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.812200,0.000000,51.778700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.812200,0.000000,50.838100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<33.812200,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.812200,0.000000,50.838100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<34.439200,0.000000,50.838100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<33.812200,0.000000,50.838100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.812200,0.000000,51.308400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<34.125700,0.000000,51.308400>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<33.812200,0.000000,51.308400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.891900,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.891900,0.000000,71.081900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<74.891900,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.891900,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<74.264900,0.000000,71.081900>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<74.264900,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.329400,0.000000,70.298100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.486100,0.000000,70.141300>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<73.329400,0.000000,70.298100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.486100,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.799700,0.000000,70.141300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<73.486100,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.799700,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.956400,0.000000,70.298100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<73.799700,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.956400,0.000000,70.298100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.956400,0.000000,70.925200>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,90.000000,0> translate<73.956400,0.000000,70.925200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.956400,0.000000,70.925200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.799700,0.000000,71.081900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<73.799700,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.799700,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.486100,0.000000,71.081900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<73.486100,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.486100,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.329400,0.000000,70.925200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<73.329400,0.000000,70.925200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.020900,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.020900,0.000000,71.081900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<73.020900,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.020900,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<72.550600,0.000000,71.081900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<72.550600,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<72.550600,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<72.393900,0.000000,70.925200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<72.393900,0.000000,70.925200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<72.393900,0.000000,70.925200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<72.393900,0.000000,70.298100>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,-90.000000,0> translate<72.393900,0.000000,70.298100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<72.393900,0.000000,70.298100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<72.550600,0.000000,70.141300>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<72.393900,0.000000,70.298100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<72.550600,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<73.020900,0.000000,70.141300>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<72.550600,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<71.149900,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<70.836400,0.000000,71.081900>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<70.836400,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<70.993200,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<70.993200,0.000000,70.141300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<70.993200,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<71.149900,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<70.836400,0.000000,70.141300>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<70.836400,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<70.526300,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<70.526300,0.000000,70.141300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<70.526300,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<70.526300,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<69.899300,0.000000,71.081900>}
box{<0,0,-0.038100><1.130424,0.036000,0.038100> rotate<0,56.309028,0> translate<69.899300,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<69.899300,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<69.899300,0.000000,70.141300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<69.899300,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<69.277300,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<69.277300,0.000000,70.141300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<69.277300,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<69.590800,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.963800,0.000000,70.141300>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<68.963800,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.028300,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.655300,0.000000,70.141300>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<68.028300,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.655300,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.655300,0.000000,71.081900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<68.655300,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.655300,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.028300,0.000000,71.081900>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<68.028300,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.655300,0.000000,70.611600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<68.341800,0.000000,70.611600>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<68.341800,0.000000,70.611600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.719800,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.719800,0.000000,70.141300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<67.719800,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.719800,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.249500,0.000000,70.141300>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<67.249500,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.249500,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.092800,0.000000,70.298100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<67.092800,0.000000,70.298100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.092800,0.000000,70.298100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.092800,0.000000,70.611600>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,90.000000,0> translate<67.092800,0.000000,70.611600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.092800,0.000000,70.611600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.249500,0.000000,70.768400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<67.092800,0.000000,70.611600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.249500,0.000000,70.768400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.719800,0.000000,70.768400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<67.249500,0.000000,70.768400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.406300,0.000000,70.768400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.092800,0.000000,71.081900>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<67.092800,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.784300,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.784300,0.000000,70.141300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<66.784300,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.784300,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.157300,0.000000,70.141300>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<66.157300,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.784300,0.000000,70.611600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.470800,0.000000,70.611600>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<66.470800,0.000000,70.611600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<65.848800,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<65.848800,0.000000,70.454900>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<65.848800,0.000000,70.454900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<65.848800,0.000000,70.454900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<65.535300,0.000000,70.141300>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-45.006166,0> translate<65.535300,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<65.535300,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<65.221800,0.000000,70.454900>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,45.006166,0> translate<65.221800,0.000000,70.454900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<65.221800,0.000000,70.454900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<65.221800,0.000000,71.081900>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<65.221800,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<65.848800,0.000000,70.611600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<65.221800,0.000000,70.611600>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<65.221800,0.000000,70.611600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.286300,0.000000,70.298100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.443000,0.000000,70.141300>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<64.286300,0.000000,70.298100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.443000,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.756600,0.000000,70.141300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<64.443000,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.756600,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.913300,0.000000,70.298100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<64.756600,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.913300,0.000000,70.298100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.913300,0.000000,70.925200>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,90.000000,0> translate<64.913300,0.000000,70.925200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.913300,0.000000,70.925200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.756600,0.000000,71.081900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<64.756600,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.756600,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.443000,0.000000,71.081900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<64.443000,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.443000,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.286300,0.000000,70.925200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<64.286300,0.000000,70.925200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.350800,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.977800,0.000000,70.141300>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<63.350800,0.000000,70.141300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.977800,0.000000,70.141300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.977800,0.000000,71.081900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<63.977800,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.977800,0.000000,71.081900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.350800,0.000000,71.081900>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<63.350800,0.000000,71.081900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.977800,0.000000,70.611600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.664300,0.000000,70.611600>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<63.664300,0.000000,70.611600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,69.558700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,68.931600>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,-90.000000,0> translate<2.578100,0.000000,68.931600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,68.931600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.891600,0.000000,68.618100>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<2.578100,0.000000,68.931600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.891600,0.000000,68.618100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,68.931600>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<2.891600,0.000000,68.618100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,68.931600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,69.558700>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,90.000000,0> translate<3.205100,0.000000,69.558700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.140600,0.000000,69.401900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.983900,0.000000,69.558700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<3.983900,0.000000,69.558700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.983900,0.000000,69.558700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.670300,0.000000,69.558700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<3.670300,0.000000,69.558700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.670300,0.000000,69.558700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,69.401900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<3.513600,0.000000,69.401900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,69.401900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,68.774800>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,-90.000000,0> translate<3.513600,0.000000,68.774800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,68.774800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.670300,0.000000,68.618100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<3.513600,0.000000,68.774800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.670300,0.000000,68.618100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.983900,0.000000,68.618100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<3.670300,0.000000,68.618100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.983900,0.000000,68.618100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.140600,0.000000,68.774800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<3.983900,0.000000,68.618100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.076100,0.000000,69.401900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.919400,0.000000,69.558700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<4.919400,0.000000,69.558700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.919400,0.000000,69.558700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.605800,0.000000,69.558700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<4.605800,0.000000,69.558700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.605800,0.000000,69.558700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.449100,0.000000,69.401900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<4.449100,0.000000,69.401900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.449100,0.000000,69.401900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.449100,0.000000,68.774800>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,-90.000000,0> translate<4.449100,0.000000,68.774800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.449100,0.000000,68.774800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.605800,0.000000,68.618100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<4.449100,0.000000,68.774800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.605800,0.000000,68.618100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.919400,0.000000,68.618100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<4.605800,0.000000,68.618100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.919400,0.000000,68.618100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.076100,0.000000,68.774800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<4.919400,0.000000,68.618100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,52.361300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,52.988400>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,90.000000,0> translate<96.481900,0.000000,52.988400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,52.988400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.168400,0.000000,53.301900>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<96.168400,0.000000,53.301900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.168400,0.000000,53.301900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,52.988400>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<95.854900,0.000000,52.988400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,52.988400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,52.361300>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,-90.000000,0> translate<95.854900,0.000000,52.361300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.919400,0.000000,52.518100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.076100,0.000000,52.361300>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<94.919400,0.000000,52.518100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.076100,0.000000,52.361300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.389700,0.000000,52.361300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<95.076100,0.000000,52.361300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.389700,0.000000,52.361300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.546400,0.000000,52.518100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<95.389700,0.000000,52.361300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.546400,0.000000,52.518100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.546400,0.000000,53.145200>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,90.000000,0> translate<95.546400,0.000000,53.145200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.546400,0.000000,53.145200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.389700,0.000000,53.301900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<95.389700,0.000000,53.301900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.389700,0.000000,53.301900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.076100,0.000000,53.301900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<95.076100,0.000000,53.301900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.076100,0.000000,53.301900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.919400,0.000000,53.145200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<94.919400,0.000000,53.145200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.983900,0.000000,52.518100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.140600,0.000000,52.361300>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<93.983900,0.000000,52.518100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.140600,0.000000,52.361300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.454200,0.000000,52.361300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<94.140600,0.000000,52.361300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.454200,0.000000,52.361300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.610900,0.000000,52.518100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<94.454200,0.000000,52.361300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.610900,0.000000,52.518100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.610900,0.000000,53.145200>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,90.000000,0> translate<94.610900,0.000000,53.145200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.610900,0.000000,53.145200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.454200,0.000000,53.301900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<94.454200,0.000000,53.301900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.454200,0.000000,53.301900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.140600,0.000000,53.301900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<94.140600,0.000000,53.301900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.140600,0.000000,53.301900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.983900,0.000000,53.145200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<93.983900,0.000000,53.145200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.281300,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.908400,0.000000,41.948100>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<47.281300,0.000000,41.948100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.908400,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.221900,0.000000,42.261600>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<47.908400,0.000000,41.948100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.221900,0.000000,42.261600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.908400,0.000000,42.575100>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<47.908400,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.908400,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.281300,0.000000,42.575100>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<47.281300,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.438100,0.000000,43.510600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.281300,0.000000,43.353900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<47.281300,0.000000,43.353900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.281300,0.000000,43.353900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.281300,0.000000,43.040300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<47.281300,0.000000,43.040300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.281300,0.000000,43.040300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.438100,0.000000,42.883600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<47.281300,0.000000,43.040300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.438100,0.000000,42.883600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.065200,0.000000,42.883600>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<47.438100,0.000000,42.883600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.065200,0.000000,42.883600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.221900,0.000000,43.040300>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<48.065200,0.000000,42.883600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.221900,0.000000,43.040300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.221900,0.000000,43.353900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<48.221900,0.000000,43.353900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.221900,0.000000,43.353900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.065200,0.000000,43.510600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<48.065200,0.000000,43.510600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.438100,0.000000,44.446100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.281300,0.000000,44.289400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<47.281300,0.000000,44.289400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.281300,0.000000,44.289400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.281300,0.000000,43.975800>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<47.281300,0.000000,43.975800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.281300,0.000000,43.975800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.438100,0.000000,43.819100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<47.281300,0.000000,43.975800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.438100,0.000000,43.819100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.065200,0.000000,43.819100>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<47.438100,0.000000,43.819100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.065200,0.000000,43.819100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.221900,0.000000,43.975800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<48.065200,0.000000,43.819100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.221900,0.000000,43.975800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.221900,0.000000,44.289400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<48.221900,0.000000,44.289400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.221900,0.000000,44.289400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.065200,0.000000,44.446100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<48.065200,0.000000,44.446100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.721300,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.348400,0.000000,41.948100>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<11.721300,0.000000,41.948100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.348400,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.661900,0.000000,42.261600>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<12.348400,0.000000,41.948100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.661900,0.000000,42.261600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.348400,0.000000,42.575100>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<12.348400,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.348400,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.721300,0.000000,42.575100>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<11.721300,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.878100,0.000000,43.510600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.721300,0.000000,43.353900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<11.721300,0.000000,43.353900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.721300,0.000000,43.353900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.721300,0.000000,43.040300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<11.721300,0.000000,43.040300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.721300,0.000000,43.040300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.878100,0.000000,42.883600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<11.721300,0.000000,43.040300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.878100,0.000000,42.883600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.505200,0.000000,42.883600>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<11.878100,0.000000,42.883600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.505200,0.000000,42.883600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.661900,0.000000,43.040300>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<12.505200,0.000000,42.883600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.661900,0.000000,43.040300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.661900,0.000000,43.353900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<12.661900,0.000000,43.353900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.661900,0.000000,43.353900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.505200,0.000000,43.510600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<12.505200,0.000000,43.510600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.878100,0.000000,44.446100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.721300,0.000000,44.289400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<11.721300,0.000000,44.289400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.721300,0.000000,44.289400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.721300,0.000000,43.975800>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<11.721300,0.000000,43.975800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.721300,0.000000,43.975800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.878100,0.000000,43.819100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<11.721300,0.000000,43.975800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.878100,0.000000,43.819100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.505200,0.000000,43.819100>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<11.878100,0.000000,43.819100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.505200,0.000000,43.819100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.661900,0.000000,43.975800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<12.505200,0.000000,43.819100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.661900,0.000000,43.975800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.661900,0.000000,44.289400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<12.661900,0.000000,44.289400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.661900,0.000000,44.289400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.505200,0.000000,44.446100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<12.505200,0.000000,44.446100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,66.861900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,67.018700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<3.048400,0.000000,67.018700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,67.018700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,67.018700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<2.734800,0.000000,67.018700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,67.018700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,66.861900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<2.578100,0.000000,66.861900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,66.861900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,66.234800>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,-90.000000,0> translate<2.578100,0.000000,66.234800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,66.234800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,66.078100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<2.578100,0.000000,66.234800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,66.078100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,66.078100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<2.734800,0.000000,66.078100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,66.078100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,66.234800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<3.048400,0.000000,66.078100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,66.234800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,66.548400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<3.205100,0.000000,66.548400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,66.548400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.891600,0.000000,66.548400>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<2.891600,0.000000,66.548400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,66.078100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,67.018700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<3.513600,0.000000,67.018700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,67.018700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.140600,0.000000,66.078100>}
box{<0,0,-0.038100><1.130424,0.036000,0.038100> rotate<0,56.309028,0> translate<3.513600,0.000000,67.018700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.140600,0.000000,66.078100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.140600,0.000000,67.018700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<4.140600,0.000000,67.018700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.449100,0.000000,67.018700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.449100,0.000000,66.078100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<4.449100,0.000000,66.078100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.449100,0.000000,66.078100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.919400,0.000000,66.078100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<4.449100,0.000000,66.078100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.919400,0.000000,66.078100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.076100,0.000000,66.234800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<4.919400,0.000000,66.078100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.076100,0.000000,66.234800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.076100,0.000000,66.861900>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,90.000000,0> translate<5.076100,0.000000,66.861900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.076100,0.000000,66.861900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.919400,0.000000,67.018700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<4.919400,0.000000,67.018700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.919400,0.000000,67.018700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.449100,0.000000,67.018700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<4.449100,0.000000,67.018700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,55.058100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.011600,0.000000,54.901300>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<95.854900,0.000000,55.058100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.011600,0.000000,54.901300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.325200,0.000000,54.901300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<96.011600,0.000000,54.901300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.325200,0.000000,54.901300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,55.058100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<96.325200,0.000000,54.901300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,55.058100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,55.685200>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,90.000000,0> translate<96.481900,0.000000,55.685200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,55.685200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.325200,0.000000,55.841900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<96.325200,0.000000,55.841900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.325200,0.000000,55.841900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.011600,0.000000,55.841900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<96.011600,0.000000,55.841900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.011600,0.000000,55.841900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,55.685200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<95.854900,0.000000,55.685200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,55.685200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,55.371600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<95.854900,0.000000,55.371600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,55.371600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.168400,0.000000,55.371600>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<95.854900,0.000000,55.371600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.546400,0.000000,55.841900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.546400,0.000000,54.901300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<95.546400,0.000000,54.901300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.546400,0.000000,54.901300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.919400,0.000000,55.841900>}
box{<0,0,-0.038100><1.130424,0.036000,0.038100> rotate<0,56.309028,0> translate<94.919400,0.000000,55.841900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.919400,0.000000,55.841900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.919400,0.000000,54.901300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<94.919400,0.000000,54.901300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.610900,0.000000,54.901300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.610900,0.000000,55.841900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<94.610900,0.000000,55.841900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.610900,0.000000,55.841900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.140600,0.000000,55.841900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<94.140600,0.000000,55.841900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.140600,0.000000,55.841900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.983900,0.000000,55.685200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<93.983900,0.000000,55.685200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.983900,0.000000,55.685200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.983900,0.000000,55.058100>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,-90.000000,0> translate<93.983900,0.000000,55.058100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.983900,0.000000,55.058100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.140600,0.000000,54.901300>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<93.983900,0.000000,55.058100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.140600,0.000000,54.901300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.610900,0.000000,54.901300>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<94.140600,0.000000,54.901300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.898100,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.741300,0.000000,42.418400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<44.741300,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.741300,0.000000,42.418400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.741300,0.000000,42.104800>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<44.741300,0.000000,42.104800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.741300,0.000000,42.104800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.898100,0.000000,41.948100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<44.741300,0.000000,42.104800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.898100,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.525200,0.000000,41.948100>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<44.898100,0.000000,41.948100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.525200,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.681900,0.000000,42.104800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<45.525200,0.000000,41.948100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.681900,0.000000,42.104800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.681900,0.000000,42.418400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<45.681900,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.681900,0.000000,42.418400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.525200,0.000000,42.575100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<45.525200,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.525200,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.211600,0.000000,42.575100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<45.211600,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.211600,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.211600,0.000000,42.261600>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,-90.000000,0> translate<45.211600,0.000000,42.261600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.681900,0.000000,42.883600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.741300,0.000000,42.883600>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<44.741300,0.000000,42.883600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.741300,0.000000,42.883600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.681900,0.000000,43.510600>}
box{<0,0,-0.038100><1.130424,0.036000,0.038100> rotate<0,-33.685033,0> translate<44.741300,0.000000,42.883600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.681900,0.000000,43.510600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.741300,0.000000,43.510600>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<44.741300,0.000000,43.510600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.741300,0.000000,43.819100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.681900,0.000000,43.819100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<44.741300,0.000000,43.819100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.681900,0.000000,43.819100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.681900,0.000000,44.289400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<45.681900,0.000000,44.289400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.681900,0.000000,44.289400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.525200,0.000000,44.446100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<45.525200,0.000000,44.446100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.525200,0.000000,44.446100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.898100,0.000000,44.446100>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<44.898100,0.000000,44.446100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.898100,0.000000,44.446100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.741300,0.000000,44.289400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<44.741300,0.000000,44.289400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.741300,0.000000,44.289400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.741300,0.000000,43.819100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<44.741300,0.000000,43.819100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.338100,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,42.418400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<9.181300,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,42.418400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,42.104800>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<9.181300,0.000000,42.104800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,42.104800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.338100,0.000000,41.948100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<9.181300,0.000000,42.104800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.338100,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.965200,0.000000,41.948100>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<9.338100,0.000000,41.948100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.965200,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,42.104800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<9.965200,0.000000,41.948100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,42.104800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,42.418400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<10.121900,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,42.418400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.965200,0.000000,42.575100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<9.965200,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.965200,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.651600,0.000000,42.575100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<9.651600,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.651600,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.651600,0.000000,42.261600>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,-90.000000,0> translate<9.651600,0.000000,42.261600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,42.883600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,42.883600>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<9.181300,0.000000,42.883600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,42.883600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,43.510600>}
box{<0,0,-0.038100><1.130424,0.036000,0.038100> rotate<0,-33.685033,0> translate<9.181300,0.000000,42.883600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,43.510600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,43.510600>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<9.181300,0.000000,43.510600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,43.819100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,43.819100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<9.181300,0.000000,43.819100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,43.819100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,44.289400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<10.121900,0.000000,44.289400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.121900,0.000000,44.289400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.965200,0.000000,44.446100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<9.965200,0.000000,44.446100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.965200,0.000000,44.446100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.338100,0.000000,44.446100>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<9.338100,0.000000,44.446100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.338100,0.000000,44.446100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,44.289400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<9.181300,0.000000,44.289400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,44.289400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.181300,0.000000,43.819100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<9.181300,0.000000,43.819100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.488100,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.331300,0.000000,42.418400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<66.331300,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.331300,0.000000,42.418400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.331300,0.000000,42.104800>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<66.331300,0.000000,42.104800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.331300,0.000000,42.104800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.488100,0.000000,41.948100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<66.331300,0.000000,42.104800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.488100,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.115200,0.000000,41.948100>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<66.488100,0.000000,41.948100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.115200,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.271900,0.000000,42.104800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<67.115200,0.000000,41.948100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.271900,0.000000,42.104800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.271900,0.000000,42.418400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<67.271900,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.271900,0.000000,42.418400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.115200,0.000000,42.575100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<67.115200,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.115200,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.801600,0.000000,42.575100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<66.801600,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.801600,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.801600,0.000000,42.261600>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,-90.000000,0> translate<66.801600,0.000000,42.261600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.271900,0.000000,42.883600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.331300,0.000000,42.883600>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<66.331300,0.000000,42.883600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.331300,0.000000,42.883600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.271900,0.000000,43.510600>}
box{<0,0,-0.038100><1.130424,0.036000,0.038100> rotate<0,-33.685033,0> translate<66.331300,0.000000,42.883600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.271900,0.000000,43.510600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.331300,0.000000,43.510600>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<66.331300,0.000000,43.510600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.331300,0.000000,43.819100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.271900,0.000000,43.819100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<66.331300,0.000000,43.819100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.271900,0.000000,43.819100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.271900,0.000000,44.289400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<67.271900,0.000000,44.289400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.271900,0.000000,44.289400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.115200,0.000000,44.446100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<67.115200,0.000000,44.446100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<67.115200,0.000000,44.446100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.488100,0.000000,44.446100>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<66.488100,0.000000,44.446100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.488100,0.000000,44.446100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.331300,0.000000,44.289400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<66.331300,0.000000,44.289400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.331300,0.000000,44.289400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<66.331300,0.000000,43.819100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<66.331300,0.000000,43.819100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.301900,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.458700,0.000000,78.231600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<31.301900,0.000000,78.074900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.458700,0.000000,78.231600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.458700,0.000000,78.545200>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<31.458700,0.000000,78.545200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.458700,0.000000,78.545200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.301900,0.000000,78.701900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<31.301900,0.000000,78.701900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.301900,0.000000,78.701900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.674800,0.000000,78.701900>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<30.674800,0.000000,78.701900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.674800,0.000000,78.701900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.518100,0.000000,78.545200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<30.518100,0.000000,78.545200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.518100,0.000000,78.545200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.518100,0.000000,78.231600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<30.518100,0.000000,78.231600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.518100,0.000000,78.231600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.674800,0.000000,78.074900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<30.518100,0.000000,78.231600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.674800,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.988400,0.000000,78.074900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<30.674800,0.000000,78.074900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.988400,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.988400,0.000000,78.388400>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,90.000000,0> translate<30.988400,0.000000,78.388400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.518100,0.000000,77.766400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.458700,0.000000,77.766400>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<30.518100,0.000000,77.766400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.458700,0.000000,77.766400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.518100,0.000000,77.139400>}
box{<0,0,-0.038100><1.130424,0.036000,0.038100> rotate<0,-33.685033,0> translate<30.518100,0.000000,77.139400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.518100,0.000000,77.139400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.458700,0.000000,77.139400>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<30.518100,0.000000,77.139400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.458700,0.000000,76.830900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.518100,0.000000,76.830900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<30.518100,0.000000,76.830900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.518100,0.000000,76.830900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.518100,0.000000,76.360600>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<30.518100,0.000000,76.360600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.518100,0.000000,76.360600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.674800,0.000000,76.203900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<30.518100,0.000000,76.360600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.674800,0.000000,76.203900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.301900,0.000000,76.203900>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<30.674800,0.000000,76.203900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.301900,0.000000,76.203900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.458700,0.000000,76.360600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<31.301900,0.000000,76.203900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.458700,0.000000,76.360600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.458700,0.000000,76.830900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<31.458700,0.000000,76.830900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.621900,0.000000,79.344900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.778700,0.000000,79.501600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<51.621900,0.000000,79.344900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.778700,0.000000,79.501600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.778700,0.000000,79.815200>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<51.778700,0.000000,79.815200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.778700,0.000000,79.815200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.621900,0.000000,79.971900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<51.621900,0.000000,79.971900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.621900,0.000000,79.971900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.994800,0.000000,79.971900>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<50.994800,0.000000,79.971900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.994800,0.000000,79.971900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.838100,0.000000,79.815200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<50.838100,0.000000,79.815200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.838100,0.000000,79.815200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.838100,0.000000,79.501600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<50.838100,0.000000,79.501600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.838100,0.000000,79.501600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.994800,0.000000,79.344900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<50.838100,0.000000,79.501600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.994800,0.000000,79.344900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.308400,0.000000,79.344900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<50.994800,0.000000,79.344900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.308400,0.000000,79.344900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.308400,0.000000,79.658400>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,90.000000,0> translate<51.308400,0.000000,79.658400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.838100,0.000000,79.036400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.778700,0.000000,79.036400>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<50.838100,0.000000,79.036400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.778700,0.000000,79.036400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.838100,0.000000,78.409400>}
box{<0,0,-0.038100><1.130424,0.036000,0.038100> rotate<0,-33.685033,0> translate<50.838100,0.000000,78.409400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.838100,0.000000,78.409400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.778700,0.000000,78.409400>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<50.838100,0.000000,78.409400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.778700,0.000000,78.100900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.838100,0.000000,78.100900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<50.838100,0.000000,78.100900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.838100,0.000000,78.100900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.838100,0.000000,77.630600>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<50.838100,0.000000,77.630600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.838100,0.000000,77.630600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.994800,0.000000,77.473900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<50.838100,0.000000,77.630600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.994800,0.000000,77.473900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.621900,0.000000,77.473900>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<50.994800,0.000000,77.473900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.621900,0.000000,77.473900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.778700,0.000000,77.630600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<51.621900,0.000000,77.473900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.778700,0.000000,77.630600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<51.778700,0.000000,78.100900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<51.778700,0.000000,78.100900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,64.321900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,64.478700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<3.048400,0.000000,64.478700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,64.478700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,64.478700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<2.734800,0.000000,64.478700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,64.478700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,64.321900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<2.578100,0.000000,64.321900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,64.321900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,64.165100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<2.578100,0.000000,64.165100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,64.165100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,64.008400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<2.578100,0.000000,64.165100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,64.008400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,64.008400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<2.734800,0.000000,64.008400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,64.008400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,63.851600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<3.048400,0.000000,64.008400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,63.851600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,63.694800>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<3.205100,0.000000,63.694800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,63.694800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,63.538100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<3.048400,0.000000,63.538100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,63.538100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,63.538100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<2.734800,0.000000,63.538100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,63.538100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,63.694800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<2.578100,0.000000,63.694800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,64.478700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,63.538100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<3.513600,0.000000,63.538100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,63.538100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.983900,0.000000,63.538100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<3.513600,0.000000,63.538100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.983900,0.000000,63.538100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.140600,0.000000,63.694800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<3.983900,0.000000,63.538100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.140600,0.000000,63.694800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.140600,0.000000,64.321900>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,90.000000,0> translate<4.140600,0.000000,64.321900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.140600,0.000000,64.321900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.983900,0.000000,64.478700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<3.983900,0.000000,64.478700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.983900,0.000000,64.478700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,64.478700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<3.513600,0.000000,64.478700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.449100,0.000000,63.538100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.449100,0.000000,64.165100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<4.449100,0.000000,64.165100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.449100,0.000000,64.165100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.762600,0.000000,64.478700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-45.006166,0> translate<4.449100,0.000000,64.165100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.762600,0.000000,64.478700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.076100,0.000000,64.165100>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,45.006166,0> translate<4.762600,0.000000,64.478700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.076100,0.000000,64.165100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.076100,0.000000,63.538100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<5.076100,0.000000,63.538100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.449100,0.000000,64.008400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.076100,0.000000,64.008400>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<4.449100,0.000000,64.008400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,57.598100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.011600,0.000000,57.441300>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<95.854900,0.000000,57.598100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.011600,0.000000,57.441300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.325200,0.000000,57.441300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<96.011600,0.000000,57.441300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.325200,0.000000,57.441300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,57.598100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<96.325200,0.000000,57.441300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,57.598100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,57.754900>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,90.000000,0> translate<96.481900,0.000000,57.754900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,57.754900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.325200,0.000000,57.911600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<96.325200,0.000000,57.911600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.325200,0.000000,57.911600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.011600,0.000000,57.911600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<96.011600,0.000000,57.911600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.011600,0.000000,57.911600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,58.068400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<95.854900,0.000000,58.068400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,58.068400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,58.225200>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,90.000000,0> translate<95.854900,0.000000,58.225200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,58.225200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.011600,0.000000,58.381900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<95.854900,0.000000,58.225200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.011600,0.000000,58.381900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.325200,0.000000,58.381900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<96.011600,0.000000,58.381900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.325200,0.000000,58.381900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,58.225200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<96.325200,0.000000,58.381900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.546400,0.000000,57.441300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.546400,0.000000,58.381900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<95.546400,0.000000,58.381900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.546400,0.000000,58.381900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.076100,0.000000,58.381900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<95.076100,0.000000,58.381900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.076100,0.000000,58.381900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.919400,0.000000,58.225200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<94.919400,0.000000,58.225200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.919400,0.000000,58.225200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.919400,0.000000,57.598100>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,-90.000000,0> translate<94.919400,0.000000,57.598100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.919400,0.000000,57.598100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.076100,0.000000,57.441300>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<94.919400,0.000000,57.598100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.076100,0.000000,57.441300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.546400,0.000000,57.441300>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<95.076100,0.000000,57.441300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.610900,0.000000,58.381900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.610900,0.000000,57.754900>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<94.610900,0.000000,57.754900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.610900,0.000000,57.754900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.297400,0.000000,57.441300>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-45.006166,0> translate<94.297400,0.000000,57.441300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.297400,0.000000,57.441300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.983900,0.000000,57.754900>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,45.006166,0> translate<93.983900,0.000000,57.754900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.983900,0.000000,57.754900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.983900,0.000000,58.381900>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<93.983900,0.000000,58.381900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.610900,0.000000,57.911600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.983900,0.000000,57.911600>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<93.983900,0.000000,57.911600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,61.781900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,61.938700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<3.048400,0.000000,61.938700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,61.938700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,61.938700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<2.734800,0.000000,61.938700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,61.938700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,61.781900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<2.578100,0.000000,61.781900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,61.781900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,61.625100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<2.578100,0.000000,61.625100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,61.625100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,61.468400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<2.578100,0.000000,61.625100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,61.468400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,61.468400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<2.734800,0.000000,61.468400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,61.468400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,61.311600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<3.048400,0.000000,61.468400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,61.311600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,61.154800>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<3.205100,0.000000,61.154800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,61.154800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,60.998100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<3.048400,0.000000,60.998100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,60.998100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,60.998100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<2.734800,0.000000,60.998100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,60.998100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,61.154800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<2.578100,0.000000,61.154800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.140600,0.000000,61.781900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.983900,0.000000,61.938700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<3.983900,0.000000,61.938700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.983900,0.000000,61.938700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.670300,0.000000,61.938700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<3.670300,0.000000,61.938700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.670300,0.000000,61.938700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,61.781900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<3.513600,0.000000,61.781900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,61.781900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,61.154800>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,-90.000000,0> translate<3.513600,0.000000,61.154800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,61.154800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.670300,0.000000,60.998100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<3.513600,0.000000,61.154800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.670300,0.000000,60.998100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.983900,0.000000,60.998100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<3.670300,0.000000,60.998100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.983900,0.000000,60.998100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.140600,0.000000,61.154800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<3.983900,0.000000,60.998100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.449100,0.000000,61.938700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.449100,0.000000,60.998100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<4.449100,0.000000,60.998100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.449100,0.000000,60.998100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.076100,0.000000,60.998100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<4.449100,0.000000,60.998100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,60.138100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.011600,0.000000,59.981300>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<95.854900,0.000000,60.138100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.011600,0.000000,59.981300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.325200,0.000000,59.981300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<96.011600,0.000000,59.981300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.325200,0.000000,59.981300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,60.138100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<96.325200,0.000000,59.981300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,60.138100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,60.294900>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,90.000000,0> translate<96.481900,0.000000,60.294900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,60.294900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.325200,0.000000,60.451600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<96.325200,0.000000,60.451600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.325200,0.000000,60.451600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.011600,0.000000,60.451600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<96.011600,0.000000,60.451600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.011600,0.000000,60.451600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,60.608400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<95.854900,0.000000,60.608400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,60.608400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,60.765200>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,90.000000,0> translate<95.854900,0.000000,60.765200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,60.765200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.011600,0.000000,60.921900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<95.854900,0.000000,60.765200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.011600,0.000000,60.921900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.325200,0.000000,60.921900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<96.011600,0.000000,60.921900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.325200,0.000000,60.921900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,60.765200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<96.325200,0.000000,60.921900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.919400,0.000000,60.138100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.076100,0.000000,59.981300>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<94.919400,0.000000,60.138100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.076100,0.000000,59.981300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.389700,0.000000,59.981300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<95.076100,0.000000,59.981300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.389700,0.000000,59.981300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.546400,0.000000,60.138100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<95.389700,0.000000,59.981300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.546400,0.000000,60.138100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.546400,0.000000,60.765200>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,90.000000,0> translate<95.546400,0.000000,60.765200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.546400,0.000000,60.765200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.389700,0.000000,60.921900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<95.389700,0.000000,60.921900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.389700,0.000000,60.921900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.076100,0.000000,60.921900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<95.076100,0.000000,60.921900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.076100,0.000000,60.921900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.919400,0.000000,60.765200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<94.919400,0.000000,60.765200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.610900,0.000000,59.981300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.610900,0.000000,60.921900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<94.610900,0.000000,60.921900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.610900,0.000000,60.921900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.983900,0.000000,60.921900>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<93.983900,0.000000,60.921900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,59.241900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,59.398700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<3.048400,0.000000,59.398700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,59.398700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,59.398700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<2.734800,0.000000,59.398700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,59.398700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,59.241900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<2.578100,0.000000,59.241900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,59.241900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,58.614800>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,-90.000000,0> translate<2.578100,0.000000,58.614800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,58.614800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,58.458100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<2.578100,0.000000,58.614800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,58.458100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,58.458100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<2.734800,0.000000,58.458100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,58.458100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,58.614800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<3.048400,0.000000,58.458100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.140600,0.000000,59.241900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.983900,0.000000,59.398700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<3.983900,0.000000,59.398700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.983900,0.000000,59.398700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.670300,0.000000,59.398700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<3.670300,0.000000,59.398700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.670300,0.000000,59.398700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,59.241900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<3.513600,0.000000,59.241900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,59.241900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,59.085100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<3.513600,0.000000,59.085100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,59.085100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.670300,0.000000,58.928400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<3.513600,0.000000,59.085100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.670300,0.000000,58.928400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.983900,0.000000,58.928400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<3.670300,0.000000,58.928400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.983900,0.000000,58.928400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.140600,0.000000,58.771600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<3.983900,0.000000,58.928400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.140600,0.000000,58.771600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.140600,0.000000,58.614800>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<4.140600,0.000000,58.614800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.140600,0.000000,58.614800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.983900,0.000000,58.458100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<3.983900,0.000000,58.458100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.983900,0.000000,58.458100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.670300,0.000000,58.458100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<3.670300,0.000000,58.458100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.670300,0.000000,58.458100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,58.614800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<3.513600,0.000000,58.614800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,62.678100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.011600,0.000000,62.521300>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<95.854900,0.000000,62.678100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.011600,0.000000,62.521300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.325200,0.000000,62.521300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<96.011600,0.000000,62.521300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.325200,0.000000,62.521300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,62.678100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<96.325200,0.000000,62.521300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,62.678100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,63.305200>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,90.000000,0> translate<96.481900,0.000000,63.305200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,63.305200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.325200,0.000000,63.461900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<96.325200,0.000000,63.461900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.325200,0.000000,63.461900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.011600,0.000000,63.461900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<96.011600,0.000000,63.461900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.011600,0.000000,63.461900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,63.305200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<95.854900,0.000000,63.305200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.919400,0.000000,62.678100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.076100,0.000000,62.521300>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<94.919400,0.000000,62.678100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.076100,0.000000,62.521300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.389700,0.000000,62.521300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<95.076100,0.000000,62.521300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.389700,0.000000,62.521300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.546400,0.000000,62.678100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<95.389700,0.000000,62.521300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.546400,0.000000,62.678100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.546400,0.000000,62.834900>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,90.000000,0> translate<95.546400,0.000000,62.834900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.546400,0.000000,62.834900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.389700,0.000000,62.991600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<95.389700,0.000000,62.991600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.389700,0.000000,62.991600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.076100,0.000000,62.991600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<95.076100,0.000000,62.991600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.076100,0.000000,62.991600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.919400,0.000000,63.148400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<94.919400,0.000000,63.148400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.919400,0.000000,63.148400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.919400,0.000000,63.305200>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,90.000000,0> translate<94.919400,0.000000,63.305200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.919400,0.000000,63.305200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.076100,0.000000,63.461900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<94.919400,0.000000,63.305200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.076100,0.000000,63.461900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.389700,0.000000,63.461900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<95.076100,0.000000,63.461900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.389700,0.000000,63.461900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.546400,0.000000,63.305200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<95.389700,0.000000,63.461900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,55.918100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,56.858700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<2.578100,0.000000,56.858700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,56.858700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.891600,0.000000,56.545100>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,45.006166,0> translate<2.578100,0.000000,56.858700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.891600,0.000000,56.545100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,56.858700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-45.006166,0> translate<2.891600,0.000000,56.545100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,56.858700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,55.918100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<3.205100,0.000000,55.918100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,55.918100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.827100,0.000000,55.918100>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<3.513600,0.000000,55.918100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.670300,0.000000,55.918100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.670300,0.000000,56.858700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<3.670300,0.000000,56.858700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,56.858700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.827100,0.000000,56.858700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<3.513600,0.000000,56.858700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.764200,0.000000,56.701900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.607500,0.000000,56.858700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<4.607500,0.000000,56.858700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.607500,0.000000,56.858700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.293900,0.000000,56.858700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<4.293900,0.000000,56.858700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.293900,0.000000,56.858700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.137200,0.000000,56.701900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<4.137200,0.000000,56.701900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.137200,0.000000,56.701900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.137200,0.000000,56.545100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<4.137200,0.000000,56.545100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.137200,0.000000,56.545100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.293900,0.000000,56.388400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<4.137200,0.000000,56.545100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.293900,0.000000,56.388400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.607500,0.000000,56.388400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<4.293900,0.000000,56.388400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.607500,0.000000,56.388400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.764200,0.000000,56.231600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<4.607500,0.000000,56.388400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.764200,0.000000,56.231600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.764200,0.000000,56.074800>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<4.764200,0.000000,56.074800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.764200,0.000000,56.074800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.607500,0.000000,55.918100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<4.607500,0.000000,55.918100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.607500,0.000000,55.918100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.293900,0.000000,55.918100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<4.293900,0.000000,55.918100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.293900,0.000000,55.918100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.137200,0.000000,56.074800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<4.137200,0.000000,56.074800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.543000,0.000000,56.858700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.229400,0.000000,56.858700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<5.229400,0.000000,56.858700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.229400,0.000000,56.858700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.072700,0.000000,56.701900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<5.072700,0.000000,56.701900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.072700,0.000000,56.701900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.072700,0.000000,56.074800>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,-90.000000,0> translate<5.072700,0.000000,56.074800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.072700,0.000000,56.074800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.229400,0.000000,55.918100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<5.072700,0.000000,56.074800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.229400,0.000000,55.918100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.543000,0.000000,55.918100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<5.229400,0.000000,55.918100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.543000,0.000000,55.918100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.699700,0.000000,56.074800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<5.543000,0.000000,55.918100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.699700,0.000000,56.074800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.699700,0.000000,56.701900>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,90.000000,0> translate<5.699700,0.000000,56.701900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.699700,0.000000,56.701900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.543000,0.000000,56.858700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<5.543000,0.000000,56.858700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,66.001900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,65.061300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<96.481900,0.000000,65.061300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,65.061300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.168400,0.000000,65.374900>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,45.006166,0> translate<96.168400,0.000000,65.374900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.168400,0.000000,65.374900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,65.061300>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-45.006166,0> translate<95.854900,0.000000,65.061300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,65.061300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.854900,0.000000,66.001900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<95.854900,0.000000,66.001900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.546400,0.000000,66.001900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.232900,0.000000,66.001900>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<95.232900,0.000000,66.001900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.389700,0.000000,66.001900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.389700,0.000000,65.061300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<95.389700,0.000000,65.061300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.546400,0.000000,65.061300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.232900,0.000000,65.061300>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<95.232900,0.000000,65.061300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.295800,0.000000,65.218100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.452500,0.000000,65.061300>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<94.295800,0.000000,65.218100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.452500,0.000000,65.061300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.766100,0.000000,65.061300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<94.452500,0.000000,65.061300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.766100,0.000000,65.061300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.922800,0.000000,65.218100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<94.766100,0.000000,65.061300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.922800,0.000000,65.218100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.922800,0.000000,65.374900>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,90.000000,0> translate<94.922800,0.000000,65.374900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.922800,0.000000,65.374900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.766100,0.000000,65.531600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<94.766100,0.000000,65.531600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.766100,0.000000,65.531600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.452500,0.000000,65.531600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<94.452500,0.000000,65.531600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.452500,0.000000,65.531600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.295800,0.000000,65.688400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<94.295800,0.000000,65.688400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.295800,0.000000,65.688400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.295800,0.000000,65.845200>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,90.000000,0> translate<94.295800,0.000000,65.845200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.295800,0.000000,65.845200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.452500,0.000000,66.001900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<94.295800,0.000000,65.845200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.452500,0.000000,66.001900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.766100,0.000000,66.001900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<94.452500,0.000000,66.001900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.766100,0.000000,66.001900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.922800,0.000000,65.845200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<94.766100,0.000000,66.001900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.517000,0.000000,65.061300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.830600,0.000000,65.061300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<93.517000,0.000000,65.061300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.830600,0.000000,65.061300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.987300,0.000000,65.218100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<93.830600,0.000000,65.061300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.987300,0.000000,65.218100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.987300,0.000000,65.845200>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,90.000000,0> translate<93.987300,0.000000,65.845200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.987300,0.000000,65.845200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.830600,0.000000,66.001900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<93.830600,0.000000,66.001900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.830600,0.000000,66.001900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.517000,0.000000,66.001900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<93.517000,0.000000,66.001900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.517000,0.000000,66.001900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.360300,0.000000,65.845200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<93.360300,0.000000,65.845200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.360300,0.000000,65.845200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.360300,0.000000,65.218100>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,-90.000000,0> translate<93.360300,0.000000,65.218100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.360300,0.000000,65.218100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<93.517000,0.000000,65.061300>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<93.360300,0.000000,65.218100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,53.378100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.891600,0.000000,53.378100>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<2.578100,0.000000,53.378100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,53.378100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,54.318700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<2.734800,0.000000,54.318700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,54.318700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.891600,0.000000,54.318700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<2.578100,0.000000,54.318700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.201700,0.000000,53.378100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.201700,0.000000,54.318700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<3.201700,0.000000,54.318700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.201700,0.000000,54.318700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.828700,0.000000,53.378100>}
box{<0,0,-0.038100><1.130424,0.036000,0.038100> rotate<0,56.309028,0> translate<3.201700,0.000000,54.318700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.828700,0.000000,53.378100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.828700,0.000000,54.318700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<3.828700,0.000000,54.318700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.450700,0.000000,53.378100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.450700,0.000000,54.318700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<4.450700,0.000000,54.318700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.137200,0.000000,54.318700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.764200,0.000000,54.318700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<4.137200,0.000000,54.318700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,53.378100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.891600,0.000000,53.378100>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<2.578100,0.000000,53.378100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,53.378100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.734800,0.000000,54.318700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<2.734800,0.000000,54.318700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,54.318700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.891600,0.000000,54.318700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<2.578100,0.000000,54.318700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.201700,0.000000,53.378100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.201700,0.000000,54.318700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<3.201700,0.000000,54.318700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.201700,0.000000,54.318700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.828700,0.000000,53.378100>}
box{<0,0,-0.038100><1.130424,0.036000,0.038100> rotate<0,56.309028,0> translate<3.201700,0.000000,54.318700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.828700,0.000000,53.378100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.828700,0.000000,54.318700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<3.828700,0.000000,54.318700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.450700,0.000000,53.378100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.450700,0.000000,54.318700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<4.450700,0.000000,54.318700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.137200,0.000000,54.318700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.764200,0.000000,54.318700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<4.137200,0.000000,54.318700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,68.541900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.168400,0.000000,68.541900>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<96.168400,0.000000,68.541900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.325200,0.000000,68.541900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.325200,0.000000,67.601300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<96.325200,0.000000,67.601300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.481900,0.000000,67.601300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<96.168400,0.000000,67.601300>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<96.168400,0.000000,67.601300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.858300,0.000000,68.541900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.858300,0.000000,67.601300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<95.858300,0.000000,67.601300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.858300,0.000000,67.601300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.231300,0.000000,68.541900>}
box{<0,0,-0.038100><1.130424,0.036000,0.038100> rotate<0,56.309028,0> translate<95.231300,0.000000,68.541900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.231300,0.000000,68.541900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<95.231300,0.000000,67.601300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<95.231300,0.000000,67.601300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.609300,0.000000,68.541900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.609300,0.000000,67.601300>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<94.609300,0.000000,67.601300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.922800,0.000000,67.601300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<94.295800,0.000000,67.601300>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<94.295800,0.000000,67.601300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.818100,0.000000,55.275100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.131600,0.000000,55.588700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-45.006166,0> translate<17.818100,0.000000,55.275100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.131600,0.000000,55.588700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.131600,0.000000,54.648100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<18.131600,0.000000,54.648100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.818100,0.000000,54.648100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.445100,0.000000,54.648100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<17.818100,0.000000,54.648100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.985100,0.000000,54.648100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.358100,0.000000,54.648100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<20.358100,0.000000,54.648100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.358100,0.000000,54.648100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.985100,0.000000,55.275100>}
box{<0,0,-0.038100><0.886712,0.036000,0.038100> rotate<0,-44.997030,0> translate<20.358100,0.000000,54.648100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.985100,0.000000,55.275100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.985100,0.000000,55.431900>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,90.000000,0> translate<20.985100,0.000000,55.431900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.985100,0.000000,55.431900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.828400,0.000000,55.588700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<20.828400,0.000000,55.588700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.828400,0.000000,55.588700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.514800,0.000000,55.588700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<20.514800,0.000000,55.588700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.514800,0.000000,55.588700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.358100,0.000000,55.431900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<20.358100,0.000000,55.431900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.898100,0.000000,55.431900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.054800,0.000000,55.588700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<22.898100,0.000000,55.431900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.054800,0.000000,55.588700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.368400,0.000000,55.588700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<23.054800,0.000000,55.588700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.368400,0.000000,55.588700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.525100,0.000000,55.431900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<23.368400,0.000000,55.588700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.525100,0.000000,55.431900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.525100,0.000000,55.275100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<23.525100,0.000000,55.275100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.525100,0.000000,55.275100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.368400,0.000000,55.118400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<23.368400,0.000000,55.118400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.368400,0.000000,55.118400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.211600,0.000000,55.118400>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<23.211600,0.000000,55.118400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.368400,0.000000,55.118400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.525100,0.000000,54.961600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<23.368400,0.000000,55.118400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.525100,0.000000,54.961600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.525100,0.000000,54.804800>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<23.525100,0.000000,54.804800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.525100,0.000000,54.804800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.368400,0.000000,54.648100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<23.368400,0.000000,54.648100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.368400,0.000000,54.648100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.054800,0.000000,54.648100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<23.054800,0.000000,54.648100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.054800,0.000000,54.648100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.898100,0.000000,54.804800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<22.898100,0.000000,54.804800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.731900,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.791300,0.000000,41.948100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<63.791300,0.000000,41.948100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.791300,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.791300,0.000000,42.418400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<63.791300,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.791300,0.000000,42.418400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.948100,0.000000,42.575100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<63.791300,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.948100,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.104900,0.000000,42.575100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<63.948100,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.104900,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.261600,0.000000,42.418400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<64.104900,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.261600,0.000000,42.418400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.418400,0.000000,42.575100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<64.261600,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.418400,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.575200,0.000000,42.575100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<64.418400,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.575200,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.731900,0.000000,42.418400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<64.575200,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.731900,0.000000,42.418400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.731900,0.000000,41.948100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<64.731900,0.000000,41.948100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.261600,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.261600,0.000000,42.418400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<64.261600,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.791300,0.000000,43.510600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.791300,0.000000,42.883600>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<63.791300,0.000000,42.883600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.791300,0.000000,42.883600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.261600,0.000000,42.883600>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<63.791300,0.000000,42.883600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.261600,0.000000,42.883600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.104900,0.000000,43.197100>}
box{<0,0,-0.038100><0.350481,0.036000,0.038100> rotate<0,63.438073,0> translate<64.104900,0.000000,43.197100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.104900,0.000000,43.197100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.104900,0.000000,43.353900>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,90.000000,0> translate<64.104900,0.000000,43.353900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.104900,0.000000,43.353900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.261600,0.000000,43.510600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<64.104900,0.000000,43.353900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.261600,0.000000,43.510600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.575200,0.000000,43.510600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<64.261600,0.000000,43.510600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.575200,0.000000,43.510600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.731900,0.000000,43.353900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<64.575200,0.000000,43.510600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.731900,0.000000,43.353900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.731900,0.000000,43.040300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<64.731900,0.000000,43.040300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.731900,0.000000,43.040300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<64.575200,0.000000,42.883600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<64.575200,0.000000,42.883600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.058100,0.000000,78.701900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.998700,0.000000,78.701900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<33.058100,0.000000,78.701900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.998700,0.000000,78.701900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.998700,0.000000,78.231600>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<33.998700,0.000000,78.231600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.998700,0.000000,78.231600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.841900,0.000000,78.074900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<33.841900,0.000000,78.074900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.841900,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.685100,0.000000,78.074900>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<33.685100,0.000000,78.074900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.685100,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.528400,0.000000,78.231600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<33.528400,0.000000,78.231600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.528400,0.000000,78.231600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.371600,0.000000,78.074900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<33.371600,0.000000,78.074900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.371600,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.214800,0.000000,78.074900>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<33.214800,0.000000,78.074900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.214800,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.058100,0.000000,78.231600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<33.058100,0.000000,78.231600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.058100,0.000000,78.231600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.058100,0.000000,78.701900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<33.058100,0.000000,78.701900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.528400,0.000000,78.701900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.528400,0.000000,78.231600>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<33.528400,0.000000,78.231600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.998700,0.000000,77.139400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.998700,0.000000,77.766400>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<33.998700,0.000000,77.766400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.998700,0.000000,77.766400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.528400,0.000000,77.766400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<33.528400,0.000000,77.766400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.528400,0.000000,77.766400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.685100,0.000000,77.452900>}
box{<0,0,-0.038100><0.350481,0.036000,0.038100> rotate<0,63.438073,0> translate<33.528400,0.000000,77.766400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.685100,0.000000,77.452900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.685100,0.000000,77.296100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<33.685100,0.000000,77.296100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.685100,0.000000,77.296100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.528400,0.000000,77.139400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<33.528400,0.000000,77.139400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.528400,0.000000,77.139400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.214800,0.000000,77.139400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<33.214800,0.000000,77.139400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.214800,0.000000,77.139400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.058100,0.000000,77.296100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<33.058100,0.000000,77.296100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.058100,0.000000,77.296100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.058100,0.000000,77.609700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<33.058100,0.000000,77.609700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.058100,0.000000,77.609700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.214800,0.000000,77.766400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<33.058100,0.000000,77.609700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.598100,0.000000,78.701900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.538700,0.000000,78.701900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<35.598100,0.000000,78.701900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.538700,0.000000,78.701900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.538700,0.000000,78.231600>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<36.538700,0.000000,78.231600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.538700,0.000000,78.231600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.381900,0.000000,78.074900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<36.381900,0.000000,78.074900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.381900,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.225100,0.000000,78.074900>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<36.225100,0.000000,78.074900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.225100,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.068400,0.000000,78.231600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<36.068400,0.000000,78.231600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.068400,0.000000,78.231600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.911600,0.000000,78.074900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<35.911600,0.000000,78.074900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.911600,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.754800,0.000000,78.074900>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<35.754800,0.000000,78.074900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.754800,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.598100,0.000000,78.231600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<35.598100,0.000000,78.231600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.598100,0.000000,78.231600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.598100,0.000000,78.701900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<35.598100,0.000000,78.701900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.068400,0.000000,78.701900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.068400,0.000000,78.231600>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<36.068400,0.000000,78.231600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.598100,0.000000,77.296100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.538700,0.000000,77.296100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<35.598100,0.000000,77.296100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.538700,0.000000,77.296100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.068400,0.000000,77.766400>}
box{<0,0,-0.038100><0.665105,0.036000,0.038100> rotate<0,44.997030,0> translate<36.068400,0.000000,77.766400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.068400,0.000000,77.766400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.068400,0.000000,77.139400>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<36.068400,0.000000,77.139400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.138100,0.000000,78.701900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.078700,0.000000,78.701900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<38.138100,0.000000,78.701900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.078700,0.000000,78.701900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.078700,0.000000,78.231600>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<39.078700,0.000000,78.231600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.078700,0.000000,78.231600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.921900,0.000000,78.074900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<38.921900,0.000000,78.074900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.921900,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.765100,0.000000,78.074900>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<38.765100,0.000000,78.074900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.765100,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.608400,0.000000,78.231600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<38.608400,0.000000,78.231600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.608400,0.000000,78.231600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.451600,0.000000,78.074900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<38.451600,0.000000,78.074900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.451600,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.294800,0.000000,78.074900>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<38.294800,0.000000,78.074900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.294800,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.138100,0.000000,78.231600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<38.138100,0.000000,78.231600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.138100,0.000000,78.231600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.138100,0.000000,78.701900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<38.138100,0.000000,78.701900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.608400,0.000000,78.701900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.608400,0.000000,78.231600>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<38.608400,0.000000,78.231600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.921900,0.000000,77.766400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.078700,0.000000,77.609700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<38.921900,0.000000,77.766400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.078700,0.000000,77.609700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.078700,0.000000,77.296100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<39.078700,0.000000,77.296100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.078700,0.000000,77.296100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.921900,0.000000,77.139400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<38.921900,0.000000,77.139400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.921900,0.000000,77.139400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.765100,0.000000,77.139400>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<38.765100,0.000000,77.139400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.765100,0.000000,77.139400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.608400,0.000000,77.296100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<38.608400,0.000000,77.296100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.608400,0.000000,77.296100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.608400,0.000000,77.452900>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,90.000000,0> translate<38.608400,0.000000,77.452900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.608400,0.000000,77.296100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.451600,0.000000,77.139400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<38.451600,0.000000,77.139400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.451600,0.000000,77.139400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.294800,0.000000,77.139400>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<38.294800,0.000000,77.139400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.294800,0.000000,77.139400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.138100,0.000000,77.296100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<38.138100,0.000000,77.296100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.138100,0.000000,77.296100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.138100,0.000000,77.609700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<38.138100,0.000000,77.609700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.138100,0.000000,77.609700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.294800,0.000000,77.766400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<38.138100,0.000000,77.609700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.678100,0.000000,78.701900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.618700,0.000000,78.701900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<40.678100,0.000000,78.701900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.618700,0.000000,78.701900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.618700,0.000000,78.231600>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<41.618700,0.000000,78.231600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.618700,0.000000,78.231600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.461900,0.000000,78.074900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<41.461900,0.000000,78.074900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.461900,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.305100,0.000000,78.074900>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<41.305100,0.000000,78.074900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.305100,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.148400,0.000000,78.231600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<41.148400,0.000000,78.231600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.148400,0.000000,78.231600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.991600,0.000000,78.074900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<40.991600,0.000000,78.074900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.991600,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.834800,0.000000,78.074900>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<40.834800,0.000000,78.074900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.834800,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.678100,0.000000,78.231600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<40.678100,0.000000,78.231600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.678100,0.000000,78.231600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.678100,0.000000,78.701900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<40.678100,0.000000,78.701900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.148400,0.000000,78.701900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.148400,0.000000,78.231600>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<41.148400,0.000000,78.231600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.678100,0.000000,77.139400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.678100,0.000000,77.766400>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<40.678100,0.000000,77.766400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.678100,0.000000,77.766400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.305100,0.000000,77.139400>}
box{<0,0,-0.038100><0.886712,0.036000,0.038100> rotate<0,44.997030,0> translate<40.678100,0.000000,77.766400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.305100,0.000000,77.139400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.461900,0.000000,77.139400>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<41.305100,0.000000,77.139400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.461900,0.000000,77.139400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.618700,0.000000,77.296100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<41.461900,0.000000,77.139400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.618700,0.000000,77.296100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.618700,0.000000,77.609700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<41.618700,0.000000,77.609700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.618700,0.000000,77.609700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.461900,0.000000,77.766400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<41.461900,0.000000,77.766400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.218100,0.000000,78.701900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.158700,0.000000,78.701900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<43.218100,0.000000,78.701900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.158700,0.000000,78.701900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.158700,0.000000,78.231600>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<44.158700,0.000000,78.231600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.158700,0.000000,78.231600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.001900,0.000000,78.074900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<44.001900,0.000000,78.074900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.001900,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.845100,0.000000,78.074900>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<43.845100,0.000000,78.074900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.845100,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.688400,0.000000,78.231600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<43.688400,0.000000,78.231600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.688400,0.000000,78.231600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.531600,0.000000,78.074900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<43.531600,0.000000,78.074900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.531600,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.374800,0.000000,78.074900>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<43.374800,0.000000,78.074900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.374800,0.000000,78.074900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.218100,0.000000,78.231600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<43.218100,0.000000,78.231600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.218100,0.000000,78.231600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.218100,0.000000,78.701900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<43.218100,0.000000,78.701900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.688400,0.000000,78.701900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.688400,0.000000,78.231600>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<43.688400,0.000000,78.231600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.845100,0.000000,77.766400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.158700,0.000000,77.452900>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<43.845100,0.000000,77.766400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.158700,0.000000,77.452900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.218100,0.000000,77.452900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<43.218100,0.000000,77.452900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.218100,0.000000,77.766400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.218100,0.000000,77.139400>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<43.218100,0.000000,77.139400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.571900,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.631300,0.000000,41.948100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<53.631300,0.000000,41.948100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.631300,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.631300,0.000000,42.418400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<53.631300,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.631300,0.000000,42.418400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.788100,0.000000,42.575100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<53.631300,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.788100,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.944900,0.000000,42.575100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<53.788100,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.944900,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.101600,0.000000,42.418400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<53.944900,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.101600,0.000000,42.418400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.258400,0.000000,42.575100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<54.101600,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.258400,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.415200,0.000000,42.575100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<54.258400,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.415200,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.571900,0.000000,42.418400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<54.415200,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.571900,0.000000,42.418400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.571900,0.000000,41.948100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<54.571900,0.000000,41.948100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.101600,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.101600,0.000000,42.418400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<54.101600,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.944900,0.000000,42.883600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.631300,0.000000,43.197100>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<53.631300,0.000000,43.197100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.631300,0.000000,43.197100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.571900,0.000000,43.197100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<53.631300,0.000000,43.197100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.571900,0.000000,42.883600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.571900,0.000000,43.510600>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<54.571900,0.000000,43.510600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.111900,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.171300,0.000000,41.948100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<56.171300,0.000000,41.948100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.171300,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.171300,0.000000,42.418400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<56.171300,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.171300,0.000000,42.418400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.328100,0.000000,42.575100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<56.171300,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.328100,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.484900,0.000000,42.575100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<56.328100,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.484900,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.641600,0.000000,42.418400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<56.484900,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.641600,0.000000,42.418400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.798400,0.000000,42.575100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<56.641600,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.798400,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.955200,0.000000,42.575100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<56.798400,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.955200,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.111900,0.000000,42.418400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<56.955200,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.111900,0.000000,42.418400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.111900,0.000000,41.948100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<57.111900,0.000000,41.948100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.641600,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.641600,0.000000,42.418400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<56.641600,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.111900,0.000000,43.510600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.111900,0.000000,42.883600>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<57.111900,0.000000,42.883600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.111900,0.000000,42.883600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.484900,0.000000,43.510600>}
box{<0,0,-0.038100><0.886712,0.036000,0.038100> rotate<0,44.997030,0> translate<56.484900,0.000000,43.510600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.484900,0.000000,43.510600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.328100,0.000000,43.510600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<56.328100,0.000000,43.510600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.328100,0.000000,43.510600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.171300,0.000000,43.353900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<56.171300,0.000000,43.353900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.171300,0.000000,43.353900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.171300,0.000000,43.040300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<56.171300,0.000000,43.040300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.171300,0.000000,43.040300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<56.328100,0.000000,42.883600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<56.171300,0.000000,43.040300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.651900,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.711300,0.000000,41.948100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<58.711300,0.000000,41.948100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.711300,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.711300,0.000000,42.418400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<58.711300,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.711300,0.000000,42.418400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.868100,0.000000,42.575100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<58.711300,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.868100,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.024900,0.000000,42.575100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<58.868100,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.024900,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.181600,0.000000,42.418400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<59.024900,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.181600,0.000000,42.418400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.338400,0.000000,42.575100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<59.181600,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.338400,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.495200,0.000000,42.575100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<59.338400,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.495200,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.651900,0.000000,42.418400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<59.495200,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.651900,0.000000,42.418400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.651900,0.000000,41.948100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<59.651900,0.000000,41.948100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.181600,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.181600,0.000000,42.418400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<59.181600,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.868100,0.000000,42.883600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.711300,0.000000,43.040300>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<58.711300,0.000000,43.040300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.711300,0.000000,43.040300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.711300,0.000000,43.353900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<58.711300,0.000000,43.353900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.711300,0.000000,43.353900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.868100,0.000000,43.510600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<58.711300,0.000000,43.353900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.868100,0.000000,43.510600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.024900,0.000000,43.510600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<58.868100,0.000000,43.510600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.024900,0.000000,43.510600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.181600,0.000000,43.353900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<59.024900,0.000000,43.510600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.181600,0.000000,43.353900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.181600,0.000000,43.197100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<59.181600,0.000000,43.197100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.181600,0.000000,43.353900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.338400,0.000000,43.510600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<59.181600,0.000000,43.353900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.338400,0.000000,43.510600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.495200,0.000000,43.510600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<59.338400,0.000000,43.510600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.495200,0.000000,43.510600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.651900,0.000000,43.353900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<59.495200,0.000000,43.510600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.651900,0.000000,43.353900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.651900,0.000000,43.040300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<59.651900,0.000000,43.040300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.651900,0.000000,43.040300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.495200,0.000000,42.883600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<59.495200,0.000000,42.883600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.191900,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.251300,0.000000,41.948100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<61.251300,0.000000,41.948100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.251300,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.251300,0.000000,42.418400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<61.251300,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.251300,0.000000,42.418400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.408100,0.000000,42.575100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<61.251300,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.408100,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.564900,0.000000,42.575100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<61.408100,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.564900,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.721600,0.000000,42.418400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<61.564900,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.721600,0.000000,42.418400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.878400,0.000000,42.575100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<61.721600,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.878400,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.035200,0.000000,42.575100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<61.878400,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.035200,0.000000,42.575100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.191900,0.000000,42.418400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<62.035200,0.000000,42.575100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.191900,0.000000,42.418400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.191900,0.000000,41.948100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<62.191900,0.000000,41.948100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.721600,0.000000,41.948100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.721600,0.000000,42.418400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<61.721600,0.000000,42.418400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.191900,0.000000,43.353900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.251300,0.000000,43.353900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<61.251300,0.000000,43.353900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.251300,0.000000,43.353900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.721600,0.000000,42.883600>}
box{<0,0,-0.038100><0.665105,0.036000,0.038100> rotate<0,44.997030,0> translate<61.251300,0.000000,43.353900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.721600,0.000000,42.883600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<61.721600,0.000000,43.510600>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<61.721600,0.000000,43.510600> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<57.213500,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<57.213500,0.000000,59.627400>}
box{<0,0,-0.063500><1.143900,0.036000,0.063500> rotate<0,90.000000,0> translate<57.213500,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<57.213500,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<57.594800,0.000000,59.246100>}
box{<0,0,-0.063500><0.539240,0.036000,0.063500> rotate<0,44.997030,0> translate<57.213500,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<57.594800,0.000000,59.246100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<57.976100,0.000000,59.627400>}
box{<0,0,-0.063500><0.539240,0.036000,0.063500> rotate<0,-44.997030,0> translate<57.594800,0.000000,59.246100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<57.976100,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<57.976100,0.000000,58.483500>}
box{<0,0,-0.063500><1.143900,0.036000,0.063500> rotate<0,-90.000000,0> translate<57.976100,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<59.145400,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<58.954700,0.000000,59.627400>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,44.982005,0> translate<58.954700,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<58.954700,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<58.573400,0.000000,59.627400>}
box{<0,0,-0.063500><0.381300,0.036000,0.063500> rotate<0,0.000000,0> translate<58.573400,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<58.573400,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<58.382800,0.000000,59.436800>}
box{<0,0,-0.063500><0.269549,0.036000,0.063500> rotate<0,-44.997030,0> translate<58.382800,0.000000,59.436800> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<58.382800,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<58.382800,0.000000,58.674100>}
box{<0,0,-0.063500><0.762700,0.036000,0.063500> rotate<0,-90.000000,0> translate<58.382800,0.000000,58.674100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<58.382800,0.000000,58.674100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<58.573400,0.000000,58.483500>}
box{<0,0,-0.063500><0.269549,0.036000,0.063500> rotate<0,44.997030,0> translate<58.382800,0.000000,58.674100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<58.573400,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<58.954700,0.000000,58.483500>}
box{<0,0,-0.063500><0.381300,0.036000,0.063500> rotate<0,0.000000,0> translate<58.573400,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<58.954700,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<59.145400,0.000000,58.674100>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,-44.982005,0> translate<58.954700,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<59.552100,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<59.552100,0.000000,59.627400>}
box{<0,0,-0.063500><1.143900,0.036000,0.063500> rotate<0,90.000000,0> translate<59.552100,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<59.552100,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<60.124000,0.000000,59.627400>}
box{<0,0,-0.063500><0.571900,0.036000,0.063500> rotate<0,0.000000,0> translate<59.552100,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<60.124000,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<60.314700,0.000000,59.436800>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,44.982005,0> translate<60.124000,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<60.314700,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<60.314700,0.000000,59.055400>}
box{<0,0,-0.063500><0.381400,0.036000,0.063500> rotate<0,-90.000000,0> translate<60.314700,0.000000,59.055400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<60.314700,0.000000,59.055400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<60.124000,0.000000,58.864800>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,-44.982005,0> translate<60.124000,0.000000,58.864800> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<60.124000,0.000000,58.864800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<59.552100,0.000000,58.864800>}
box{<0,0,-0.063500><0.571900,0.036000,0.063500> rotate<0,0.000000,0> translate<59.552100,0.000000,58.864800> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<61.484000,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<60.721400,0.000000,58.483500>}
box{<0,0,-0.063500><0.762600,0.036000,0.063500> rotate<0,0.000000,0> translate<60.721400,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<60.721400,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<61.484000,0.000000,59.246100>}
box{<0,0,-0.063500><1.078479,0.036000,0.063500> rotate<0,-44.997030,0> translate<60.721400,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<61.484000,0.000000,59.246100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<61.484000,0.000000,59.436800>}
box{<0,0,-0.063500><0.190700,0.036000,0.063500> rotate<0,90.000000,0> translate<61.484000,0.000000,59.436800> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<61.484000,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<61.293300,0.000000,59.627400>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,44.982005,0> translate<61.293300,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<61.293300,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<60.912000,0.000000,59.627400>}
box{<0,0,-0.063500><0.381300,0.036000,0.063500> rotate<0,0.000000,0> translate<60.912000,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<60.912000,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<60.721400,0.000000,59.436800>}
box{<0,0,-0.063500><0.269549,0.036000,0.063500> rotate<0,-44.997030,0> translate<60.721400,0.000000,59.436800> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<61.890700,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<62.081300,0.000000,59.627400>}
box{<0,0,-0.063500><0.269549,0.036000,0.063500> rotate<0,-44.997030,0> translate<61.890700,0.000000,59.436800> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<62.081300,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<62.462600,0.000000,59.627400>}
box{<0,0,-0.063500><0.381300,0.036000,0.063500> rotate<0,0.000000,0> translate<62.081300,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<62.462600,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<62.653300,0.000000,59.436800>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,44.982005,0> translate<62.462600,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<62.653300,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<62.653300,0.000000,59.246100>}
box{<0,0,-0.063500><0.190700,0.036000,0.063500> rotate<0,-90.000000,0> translate<62.653300,0.000000,59.246100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<62.653300,0.000000,59.246100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<62.462600,0.000000,59.055400>}
box{<0,0,-0.063500><0.269691,0.036000,0.063500> rotate<0,-44.997030,0> translate<62.462600,0.000000,59.055400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<62.462600,0.000000,59.055400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<62.272000,0.000000,59.055400>}
box{<0,0,-0.063500><0.190600,0.036000,0.063500> rotate<0,0.000000,0> translate<62.272000,0.000000,59.055400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<62.462600,0.000000,59.055400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<62.653300,0.000000,58.864800>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,44.982005,0> translate<62.462600,0.000000,59.055400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<62.653300,0.000000,58.864800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<62.653300,0.000000,58.674100>}
box{<0,0,-0.063500><0.190700,0.036000,0.063500> rotate<0,-90.000000,0> translate<62.653300,0.000000,58.674100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<62.653300,0.000000,58.674100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<62.462600,0.000000,58.483500>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,-44.982005,0> translate<62.462600,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<62.462600,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<62.081300,0.000000,58.483500>}
box{<0,0,-0.063500><0.381300,0.036000,0.063500> rotate<0,0.000000,0> translate<62.081300,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<62.081300,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<61.890700,0.000000,58.674100>}
box{<0,0,-0.063500><0.269549,0.036000,0.063500> rotate<0,44.997030,0> translate<61.890700,0.000000,58.674100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<63.822600,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<63.631900,0.000000,59.627400>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,44.982005,0> translate<63.631900,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<63.631900,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<63.250600,0.000000,59.627400>}
box{<0,0,-0.063500><0.381300,0.036000,0.063500> rotate<0,0.000000,0> translate<63.250600,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<63.250600,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<63.060000,0.000000,59.436800>}
box{<0,0,-0.063500><0.269549,0.036000,0.063500> rotate<0,-44.997030,0> translate<63.060000,0.000000,59.436800> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<63.060000,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<63.060000,0.000000,59.246100>}
box{<0,0,-0.063500><0.190700,0.036000,0.063500> rotate<0,-90.000000,0> translate<63.060000,0.000000,59.246100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<63.060000,0.000000,59.246100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<63.250600,0.000000,59.055400>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,45.012056,0> translate<63.060000,0.000000,59.246100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<63.250600,0.000000,59.055400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<63.631900,0.000000,59.055400>}
box{<0,0,-0.063500><0.381300,0.036000,0.063500> rotate<0,0.000000,0> translate<63.250600,0.000000,59.055400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<63.631900,0.000000,59.055400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<63.822600,0.000000,58.864800>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,44.982005,0> translate<63.631900,0.000000,59.055400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<63.822600,0.000000,58.864800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<63.822600,0.000000,58.674100>}
box{<0,0,-0.063500><0.190700,0.036000,0.063500> rotate<0,-90.000000,0> translate<63.822600,0.000000,58.674100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<63.822600,0.000000,58.674100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<63.631900,0.000000,58.483500>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,-44.982005,0> translate<63.631900,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<63.631900,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<63.250600,0.000000,58.483500>}
box{<0,0,-0.063500><0.381300,0.036000,0.063500> rotate<0,0.000000,0> translate<63.250600,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<63.250600,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<63.060000,0.000000,58.674100>}
box{<0,0,-0.063500><0.269549,0.036000,0.063500> rotate<0,44.997030,0> translate<63.060000,0.000000,58.674100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<64.229300,0.000000,59.246100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<64.610600,0.000000,59.627400>}
box{<0,0,-0.063500><0.539240,0.036000,0.063500> rotate<0,-44.997030,0> translate<64.229300,0.000000,59.246100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<64.610600,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<64.610600,0.000000,58.483500>}
box{<0,0,-0.063500><1.143900,0.036000,0.063500> rotate<0,-90.000000,0> translate<64.610600,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<64.229300,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<64.991900,0.000000,58.483500>}
box{<0,0,-0.063500><0.762600,0.036000,0.063500> rotate<0,0.000000,0> translate<64.229300,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<65.398600,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<66.161200,0.000000,59.627400>}
box{<0,0,-0.063500><0.762600,0.036000,0.063500> rotate<0,0.000000,0> translate<65.398600,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<66.161200,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<66.161200,0.000000,59.436800>}
box{<0,0,-0.063500><0.190600,0.036000,0.063500> rotate<0,-90.000000,0> translate<66.161200,0.000000,59.436800> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<66.161200,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<65.398600,0.000000,58.674100>}
box{<0,0,-0.063500><1.078550,0.036000,0.063500> rotate<0,-45.000786,0> translate<65.398600,0.000000,58.674100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<65.398600,0.000000,58.674100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<65.398600,0.000000,58.483500>}
box{<0,0,-0.063500><0.190600,0.036000,0.063500> rotate<0,-90.000000,0> translate<65.398600,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<67.330500,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<67.139800,0.000000,59.627400>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,44.982005,0> translate<67.139800,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<67.139800,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<66.758500,0.000000,59.627400>}
box{<0,0,-0.063500><0.381300,0.036000,0.063500> rotate<0,0.000000,0> translate<66.758500,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<66.758500,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<66.567900,0.000000,59.436800>}
box{<0,0,-0.063500><0.269549,0.036000,0.063500> rotate<0,-44.997030,0> translate<66.567900,0.000000,59.436800> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<66.567900,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<66.567900,0.000000,59.246100>}
box{<0,0,-0.063500><0.190700,0.036000,0.063500> rotate<0,-90.000000,0> translate<66.567900,0.000000,59.246100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<66.567900,0.000000,59.246100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<66.758500,0.000000,59.055400>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,45.012056,0> translate<66.567900,0.000000,59.246100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<66.758500,0.000000,59.055400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<67.139800,0.000000,59.055400>}
box{<0,0,-0.063500><0.381300,0.036000,0.063500> rotate<0,0.000000,0> translate<66.758500,0.000000,59.055400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<67.139800,0.000000,59.055400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<67.330500,0.000000,58.864800>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,44.982005,0> translate<67.139800,0.000000,59.055400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<67.330500,0.000000,58.864800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<67.330500,0.000000,58.674100>}
box{<0,0,-0.063500><0.190700,0.036000,0.063500> rotate<0,-90.000000,0> translate<67.330500,0.000000,58.674100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<67.330500,0.000000,58.674100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<67.139800,0.000000,58.483500>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,-44.982005,0> translate<67.139800,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<67.139800,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<66.758500,0.000000,58.483500>}
box{<0,0,-0.063500><0.381300,0.036000,0.063500> rotate<0,0.000000,0> translate<66.758500,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<66.758500,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<66.567900,0.000000,58.674100>}
box{<0,0,-0.063500><0.269549,0.036000,0.063500> rotate<0,44.997030,0> translate<66.567900,0.000000,58.674100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<67.737200,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<67.737200,0.000000,59.627400>}
box{<0,0,-0.063500><1.143900,0.036000,0.063500> rotate<0,90.000000,0> translate<67.737200,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<67.737200,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<68.309100,0.000000,59.627400>}
box{<0,0,-0.063500><0.571900,0.036000,0.063500> rotate<0,0.000000,0> translate<67.737200,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<68.309100,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<68.499800,0.000000,59.436800>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,44.982005,0> translate<68.309100,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<68.499800,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<68.499800,0.000000,59.055400>}
box{<0,0,-0.063500><0.381400,0.036000,0.063500> rotate<0,-90.000000,0> translate<68.499800,0.000000,59.055400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<68.499800,0.000000,59.055400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<68.309100,0.000000,58.864800>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,-44.982005,0> translate<68.309100,0.000000,58.864800> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<68.309100,0.000000,58.864800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<67.737200,0.000000,58.864800>}
box{<0,0,-0.063500><0.571900,0.036000,0.063500> rotate<0,0.000000,0> translate<67.737200,0.000000,58.864800> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<68.906500,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<69.669100,0.000000,59.627400>}
box{<0,0,-0.063500><1.374797,0.036000,0.063500> rotate<0,-56.306216,0> translate<68.906500,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<70.075800,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<70.075800,0.000000,59.627400>}
box{<0,0,-0.063500><1.143900,0.036000,0.063500> rotate<0,90.000000,0> translate<70.075800,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<70.075800,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<70.457100,0.000000,59.246100>}
box{<0,0,-0.063500><0.539240,0.036000,0.063500> rotate<0,44.997030,0> translate<70.075800,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<70.457100,0.000000,59.246100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<70.838400,0.000000,59.627400>}
box{<0,0,-0.063500><0.539240,0.036000,0.063500> rotate<0,-44.997030,0> translate<70.457100,0.000000,59.246100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<70.838400,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<70.838400,0.000000,58.483500>}
box{<0,0,-0.063500><1.143900,0.036000,0.063500> rotate<0,-90.000000,0> translate<70.838400,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<72.007700,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<71.817000,0.000000,59.627400>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,44.982005,0> translate<71.817000,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<71.817000,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<71.435700,0.000000,59.627400>}
box{<0,0,-0.063500><0.381300,0.036000,0.063500> rotate<0,0.000000,0> translate<71.435700,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<71.435700,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<71.245100,0.000000,59.436800>}
box{<0,0,-0.063500><0.269549,0.036000,0.063500> rotate<0,-44.997030,0> translate<71.245100,0.000000,59.436800> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<71.245100,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<71.245100,0.000000,58.674100>}
box{<0,0,-0.063500><0.762700,0.036000,0.063500> rotate<0,-90.000000,0> translate<71.245100,0.000000,58.674100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<71.245100,0.000000,58.674100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<71.435700,0.000000,58.483500>}
box{<0,0,-0.063500><0.269549,0.036000,0.063500> rotate<0,44.997030,0> translate<71.245100,0.000000,58.674100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<71.435700,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<71.817000,0.000000,58.483500>}
box{<0,0,-0.063500><0.381300,0.036000,0.063500> rotate<0,0.000000,0> translate<71.435700,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<71.817000,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<72.007700,0.000000,58.674100>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,-44.982005,0> translate<71.817000,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<72.414400,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<72.414400,0.000000,59.627400>}
box{<0,0,-0.063500><1.143900,0.036000,0.063500> rotate<0,90.000000,0> translate<72.414400,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<72.414400,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<72.986300,0.000000,59.627400>}
box{<0,0,-0.063500><0.571900,0.036000,0.063500> rotate<0,0.000000,0> translate<72.414400,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<72.986300,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<73.177000,0.000000,59.436800>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,44.982005,0> translate<72.986300,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<73.177000,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<73.177000,0.000000,59.055400>}
box{<0,0,-0.063500><0.381400,0.036000,0.063500> rotate<0,-90.000000,0> translate<73.177000,0.000000,59.055400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<73.177000,0.000000,59.055400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<72.986300,0.000000,58.864800>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,-44.982005,0> translate<72.986300,0.000000,58.864800> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<72.986300,0.000000,58.864800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<72.414400,0.000000,58.864800>}
box{<0,0,-0.063500><0.571900,0.036000,0.063500> rotate<0,0.000000,0> translate<72.414400,0.000000,58.864800> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<74.346300,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<73.583700,0.000000,58.483500>}
box{<0,0,-0.063500><0.762600,0.036000,0.063500> rotate<0,0.000000,0> translate<73.583700,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<73.583700,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<74.346300,0.000000,59.246100>}
box{<0,0,-0.063500><1.078479,0.036000,0.063500> rotate<0,-44.997030,0> translate<73.583700,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<74.346300,0.000000,59.246100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<74.346300,0.000000,59.436800>}
box{<0,0,-0.063500><0.190700,0.036000,0.063500> rotate<0,90.000000,0> translate<74.346300,0.000000,59.436800> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<74.346300,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<74.155600,0.000000,59.627400>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,44.982005,0> translate<74.155600,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<74.155600,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<73.774300,0.000000,59.627400>}
box{<0,0,-0.063500><0.381300,0.036000,0.063500> rotate<0,0.000000,0> translate<73.774300,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<73.774300,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<73.583700,0.000000,59.436800>}
box{<0,0,-0.063500><0.269549,0.036000,0.063500> rotate<0,-44.997030,0> translate<73.583700,0.000000,59.436800> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<74.753000,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<74.943600,0.000000,59.627400>}
box{<0,0,-0.063500><0.269549,0.036000,0.063500> rotate<0,-44.997030,0> translate<74.753000,0.000000,59.436800> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<74.943600,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<75.324900,0.000000,59.627400>}
box{<0,0,-0.063500><0.381300,0.036000,0.063500> rotate<0,0.000000,0> translate<74.943600,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<75.324900,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<75.515600,0.000000,59.436800>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,44.982005,0> translate<75.324900,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<75.515600,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<75.515600,0.000000,59.246100>}
box{<0,0,-0.063500><0.190700,0.036000,0.063500> rotate<0,-90.000000,0> translate<75.515600,0.000000,59.246100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<75.515600,0.000000,59.246100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<75.324900,0.000000,59.055400>}
box{<0,0,-0.063500><0.269691,0.036000,0.063500> rotate<0,-44.997030,0> translate<75.324900,0.000000,59.055400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<75.324900,0.000000,59.055400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<75.134300,0.000000,59.055400>}
box{<0,0,-0.063500><0.190600,0.036000,0.063500> rotate<0,0.000000,0> translate<75.134300,0.000000,59.055400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<75.324900,0.000000,59.055400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<75.515600,0.000000,58.864800>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,44.982005,0> translate<75.324900,0.000000,59.055400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<75.515600,0.000000,58.864800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<75.515600,0.000000,58.674100>}
box{<0,0,-0.063500><0.190700,0.036000,0.063500> rotate<0,-90.000000,0> translate<75.515600,0.000000,58.674100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<75.515600,0.000000,58.674100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<75.324900,0.000000,58.483500>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,-44.982005,0> translate<75.324900,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<75.324900,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<74.943600,0.000000,58.483500>}
box{<0,0,-0.063500><0.381300,0.036000,0.063500> rotate<0,0.000000,0> translate<74.943600,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<74.943600,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<74.753000,0.000000,58.674100>}
box{<0,0,-0.063500><0.269549,0.036000,0.063500> rotate<0,44.997030,0> translate<74.753000,0.000000,58.674100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<75.922300,0.000000,58.674100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<75.922300,0.000000,59.436800>}
box{<0,0,-0.063500><0.762700,0.036000,0.063500> rotate<0,90.000000,0> translate<75.922300,0.000000,59.436800> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<75.922300,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<76.112900,0.000000,59.627400>}
box{<0,0,-0.063500><0.269549,0.036000,0.063500> rotate<0,-44.997030,0> translate<75.922300,0.000000,59.436800> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<76.112900,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<76.494200,0.000000,59.627400>}
box{<0,0,-0.063500><0.381300,0.036000,0.063500> rotate<0,0.000000,0> translate<76.112900,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<76.494200,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<76.684900,0.000000,59.436800>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,44.982005,0> translate<76.494200,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<76.684900,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<76.684900,0.000000,58.674100>}
box{<0,0,-0.063500><0.762700,0.036000,0.063500> rotate<0,-90.000000,0> translate<76.684900,0.000000,58.674100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<76.684900,0.000000,58.674100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<76.494200,0.000000,58.483500>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,-44.982005,0> translate<76.494200,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<76.494200,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<76.112900,0.000000,58.483500>}
box{<0,0,-0.063500><0.381300,0.036000,0.063500> rotate<0,0.000000,0> translate<76.112900,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<76.112900,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<75.922300,0.000000,58.674100>}
box{<0,0,-0.063500><0.269549,0.036000,0.063500> rotate<0,44.997030,0> translate<75.922300,0.000000,58.674100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<75.922300,0.000000,58.674100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<76.684900,0.000000,59.436800>}
box{<0,0,-0.063500><1.078550,0.036000,0.063500> rotate<0,-45.000786,0> translate<75.922300,0.000000,58.674100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<77.091600,0.000000,59.246100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<77.472900,0.000000,59.627400>}
box{<0,0,-0.063500><0.539240,0.036000,0.063500> rotate<0,-44.997030,0> translate<77.091600,0.000000,59.246100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<77.472900,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<77.472900,0.000000,58.483500>}
box{<0,0,-0.063500><1.143900,0.036000,0.063500> rotate<0,-90.000000,0> translate<77.472900,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<77.091600,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<77.854200,0.000000,58.483500>}
box{<0,0,-0.063500><0.762600,0.036000,0.063500> rotate<0,0.000000,0> translate<77.091600,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<78.260900,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<79.023500,0.000000,59.627400>}
box{<0,0,-0.063500><0.762600,0.036000,0.063500> rotate<0,0.000000,0> translate<78.260900,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<79.023500,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<79.023500,0.000000,59.436800>}
box{<0,0,-0.063500><0.190600,0.036000,0.063500> rotate<0,-90.000000,0> translate<79.023500,0.000000,59.436800> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<79.023500,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<78.260900,0.000000,58.674100>}
box{<0,0,-0.063500><1.078550,0.036000,0.063500> rotate<0,-45.000786,0> translate<78.260900,0.000000,58.674100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<78.260900,0.000000,58.674100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<78.260900,0.000000,58.483500>}
box{<0,0,-0.063500><0.190600,0.036000,0.063500> rotate<0,-90.000000,0> translate<78.260900,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<80.192800,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<80.002100,0.000000,59.627400>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,44.982005,0> translate<80.002100,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<80.002100,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<79.620800,0.000000,59.627400>}
box{<0,0,-0.063500><0.381300,0.036000,0.063500> rotate<0,0.000000,0> translate<79.620800,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<79.620800,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<79.430200,0.000000,59.436800>}
box{<0,0,-0.063500><0.269549,0.036000,0.063500> rotate<0,-44.997030,0> translate<79.430200,0.000000,59.436800> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<79.430200,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<79.430200,0.000000,59.246100>}
box{<0,0,-0.063500><0.190700,0.036000,0.063500> rotate<0,-90.000000,0> translate<79.430200,0.000000,59.246100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<79.430200,0.000000,59.246100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<79.620800,0.000000,59.055400>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,45.012056,0> translate<79.430200,0.000000,59.246100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<79.620800,0.000000,59.055400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<80.002100,0.000000,59.055400>}
box{<0,0,-0.063500><0.381300,0.036000,0.063500> rotate<0,0.000000,0> translate<79.620800,0.000000,59.055400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<80.002100,0.000000,59.055400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<80.192800,0.000000,58.864800>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,44.982005,0> translate<80.002100,0.000000,59.055400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<80.192800,0.000000,58.864800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<80.192800,0.000000,58.674100>}
box{<0,0,-0.063500><0.190700,0.036000,0.063500> rotate<0,-90.000000,0> translate<80.192800,0.000000,58.674100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<80.192800,0.000000,58.674100>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<80.002100,0.000000,58.483500>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,-44.982005,0> translate<80.002100,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<80.002100,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<79.620800,0.000000,58.483500>}
box{<0,0,-0.063500><0.381300,0.036000,0.063500> rotate<0,0.000000,0> translate<79.620800,0.000000,58.483500> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<79.620800,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<79.430200,0.000000,58.674100>}
box{<0,0,-0.063500><0.269549,0.036000,0.063500> rotate<0,44.997030,0> translate<79.430200,0.000000,58.674100> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<80.599500,0.000000,58.483500>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<80.599500,0.000000,59.627400>}
box{<0,0,-0.063500><1.143900,0.036000,0.063500> rotate<0,90.000000,0> translate<80.599500,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<80.599500,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<81.171400,0.000000,59.627400>}
box{<0,0,-0.063500><0.571900,0.036000,0.063500> rotate<0,0.000000,0> translate<80.599500,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<81.171400,0.000000,59.627400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<81.362100,0.000000,59.436800>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,44.982005,0> translate<81.171400,0.000000,59.627400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<81.362100,0.000000,59.436800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<81.362100,0.000000,59.055400>}
box{<0,0,-0.063500><0.381400,0.036000,0.063500> rotate<0,-90.000000,0> translate<81.362100,0.000000,59.055400> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<81.362100,0.000000,59.055400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<81.171400,0.000000,58.864800>}
box{<0,0,-0.063500><0.269620,0.036000,0.063500> rotate<0,-44.982005,0> translate<81.171400,0.000000,58.864800> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<81.171400,0.000000,58.864800>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<80.599500,0.000000,58.864800>}
box{<0,0,-0.063500><0.571900,0.036000,0.063500> rotate<0,0.000000,0> translate<80.599500,0.000000,58.864800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.274100,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.189200,0.000000,41.960800>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<14.274100,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.189200,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.189200,0.000000,42.418300>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<15.189200,0.000000,42.418300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.189200,0.000000,42.418300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.036700,0.000000,42.570900>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<15.036700,0.000000,42.570900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.036700,0.000000,42.570900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.426600,0.000000,42.570900>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<14.426600,0.000000,42.570900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.426600,0.000000,42.570900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.274100,0.000000,42.418300>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<14.274100,0.000000,42.418300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.274100,0.000000,42.418300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.274100,0.000000,41.960800>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<14.274100,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.274100,0.000000,42.896300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.274100,0.000000,43.506400>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,90.000000,0> translate<14.274100,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.274100,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.426600,0.000000,43.506400>}
box{<0,0,-0.050800><0.152500,0.036000,0.050800> rotate<0,0.000000,0> translate<14.274100,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.426600,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.036700,0.000000,42.896300>}
box{<0,0,-0.050800><0.862812,0.036000,0.050800> rotate<0,44.997030,0> translate<14.426600,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.036700,0.000000,42.896300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.189200,0.000000,42.896300>}
box{<0,0,-0.050800><0.152500,0.036000,0.050800> rotate<0,0.000000,0> translate<15.036700,0.000000,42.896300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.814100,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.729200,0.000000,41.960800>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<16.814100,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.729200,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.729200,0.000000,42.418300>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<17.729200,0.000000,42.418300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.729200,0.000000,42.418300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.576700,0.000000,42.570900>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<17.576700,0.000000,42.570900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.576700,0.000000,42.570900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.966600,0.000000,42.570900>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<16.966600,0.000000,42.570900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.966600,0.000000,42.570900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.814100,0.000000,42.418300>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<16.814100,0.000000,42.418300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.814100,0.000000,42.418300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.814100,0.000000,41.960800>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<16.814100,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.814100,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.966600,0.000000,43.201300>}
box{<0,0,-0.050800><0.341090,0.036000,0.050800> rotate<0,63.438274,0> translate<16.814100,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.966600,0.000000,43.201300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.271700,0.000000,42.896300>}
box{<0,0,-0.050800><0.431406,0.036000,0.050800> rotate<0,44.987640,0> translate<16.966600,0.000000,43.201300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.271700,0.000000,42.896300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.576700,0.000000,42.896300>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,0.000000,0> translate<17.271700,0.000000,42.896300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.576700,0.000000,42.896300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.729200,0.000000,43.048800>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,-44.997030,0> translate<17.576700,0.000000,42.896300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.729200,0.000000,43.048800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.729200,0.000000,43.353800>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,90.000000,0> translate<17.729200,0.000000,43.353800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.729200,0.000000,43.353800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.576700,0.000000,43.506400>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<17.576700,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.576700,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.424200,0.000000,43.506400>}
box{<0,0,-0.050800><0.152500,0.036000,0.050800> rotate<0,0.000000,0> translate<17.424200,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.424200,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.271700,0.000000,43.353800>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<17.271700,0.000000,43.353800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.271700,0.000000,43.353800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.271700,0.000000,42.896300>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<17.271700,0.000000,42.896300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.354100,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.269200,0.000000,41.960800>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<19.354100,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.269200,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.269200,0.000000,42.418300>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<20.269200,0.000000,42.418300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.269200,0.000000,42.418300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.116700,0.000000,42.570900>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<20.116700,0.000000,42.570900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.116700,0.000000,42.570900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.506600,0.000000,42.570900>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<19.506600,0.000000,42.570900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.506600,0.000000,42.570900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.354100,0.000000,42.418300>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<19.354100,0.000000,42.418300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.354100,0.000000,42.418300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.354100,0.000000,41.960800>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<19.354100,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.354100,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.354100,0.000000,42.896300>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,-90.000000,0> translate<19.354100,0.000000,42.896300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.354100,0.000000,42.896300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.811700,0.000000,42.896300>}
box{<0,0,-0.050800><0.457600,0.036000,0.050800> rotate<0,0.000000,0> translate<19.354100,0.000000,42.896300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.811700,0.000000,42.896300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.659100,0.000000,43.201300>}
box{<0,0,-0.050800><0.341045,0.036000,0.050800> rotate<0,63.415737,0> translate<19.659100,0.000000,43.201300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.659100,0.000000,43.201300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.659100,0.000000,43.353800>}
box{<0,0,-0.050800><0.152500,0.036000,0.050800> rotate<0,90.000000,0> translate<19.659100,0.000000,43.353800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.659100,0.000000,43.353800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.811700,0.000000,43.506400>}
box{<0,0,-0.050800><0.215809,0.036000,0.050800> rotate<0,-44.997030,0> translate<19.659100,0.000000,43.353800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.811700,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.116700,0.000000,43.506400>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,0.000000,0> translate<19.811700,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.116700,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.269200,0.000000,43.353800>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<20.116700,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.269200,0.000000,43.353800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.269200,0.000000,43.048800>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,-90.000000,0> translate<20.269200,0.000000,43.048800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.269200,0.000000,43.048800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.116700,0.000000,42.896300>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,-44.997030,0> translate<20.116700,0.000000,42.896300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.894100,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.809200,0.000000,41.960800>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<21.894100,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.809200,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.809200,0.000000,42.418300>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<22.809200,0.000000,42.418300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.809200,0.000000,42.418300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.656700,0.000000,42.570900>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<22.656700,0.000000,42.570900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.656700,0.000000,42.570900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.046600,0.000000,42.570900>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<22.046600,0.000000,42.570900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.046600,0.000000,42.570900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.894100,0.000000,42.418300>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<21.894100,0.000000,42.418300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.894100,0.000000,42.418300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.894100,0.000000,41.960800>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<21.894100,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.809200,0.000000,43.353800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.894100,0.000000,43.353800>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<21.894100,0.000000,43.353800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.894100,0.000000,43.353800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.351700,0.000000,42.896300>}
box{<0,0,-0.050800><0.647073,0.036000,0.050800> rotate<0,44.990769,0> translate<21.894100,0.000000,43.353800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.351700,0.000000,42.896300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.351700,0.000000,43.506400>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,90.000000,0> translate<22.351700,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.434100,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.349200,0.000000,41.960800>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<24.434100,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.349200,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.349200,0.000000,42.418300>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<25.349200,0.000000,42.418300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.349200,0.000000,42.418300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.196700,0.000000,42.570900>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<25.196700,0.000000,42.570900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.196700,0.000000,42.570900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.586600,0.000000,42.570900>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<24.586600,0.000000,42.570900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.586600,0.000000,42.570900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.434100,0.000000,42.418300>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<24.434100,0.000000,42.418300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.434100,0.000000,42.418300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.434100,0.000000,41.960800>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<24.434100,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.586600,0.000000,42.896300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.434100,0.000000,43.048800>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,44.997030,0> translate<24.434100,0.000000,43.048800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.434100,0.000000,43.048800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.434100,0.000000,43.353800>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,90.000000,0> translate<24.434100,0.000000,43.353800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.434100,0.000000,43.353800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.586600,0.000000,43.506400>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<24.434100,0.000000,43.353800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.586600,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.739100,0.000000,43.506400>}
box{<0,0,-0.050800><0.152500,0.036000,0.050800> rotate<0,0.000000,0> translate<24.586600,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.739100,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.891700,0.000000,43.353800>}
box{<0,0,-0.050800><0.215809,0.036000,0.050800> rotate<0,44.997030,0> translate<24.739100,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.891700,0.000000,43.353800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.891700,0.000000,43.201300>}
box{<0,0,-0.050800><0.152500,0.036000,0.050800> rotate<0,-90.000000,0> translate<24.891700,0.000000,43.201300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.891700,0.000000,43.353800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.044200,0.000000,43.506400>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<24.891700,0.000000,43.353800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.044200,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.196700,0.000000,43.506400>}
box{<0,0,-0.050800><0.152500,0.036000,0.050800> rotate<0,0.000000,0> translate<25.044200,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.196700,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.349200,0.000000,43.353800>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<25.196700,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.349200,0.000000,43.353800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.349200,0.000000,43.048800>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,-90.000000,0> translate<25.349200,0.000000,43.048800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.349200,0.000000,43.048800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.196700,0.000000,42.896300>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,-44.997030,0> translate<25.196700,0.000000,42.896300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.974100,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.889200,0.000000,41.960800>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<26.974100,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.889200,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.889200,0.000000,42.418300>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<27.889200,0.000000,42.418300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.889200,0.000000,42.418300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.736700,0.000000,42.570900>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<27.736700,0.000000,42.570900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.736700,0.000000,42.570900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.126600,0.000000,42.570900>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<27.126600,0.000000,42.570900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.126600,0.000000,42.570900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.974100,0.000000,42.418300>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<26.974100,0.000000,42.418300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.974100,0.000000,42.418300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.974100,0.000000,41.960800>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<26.974100,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.889200,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.889200,0.000000,42.896300>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,-90.000000,0> translate<27.889200,0.000000,42.896300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.889200,0.000000,42.896300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.279100,0.000000,43.506400>}
box{<0,0,-0.050800><0.862812,0.036000,0.050800> rotate<0,44.997030,0> translate<27.279100,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.279100,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.126600,0.000000,43.506400>}
box{<0,0,-0.050800><0.152500,0.036000,0.050800> rotate<0,0.000000,0> translate<27.126600,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.126600,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.974100,0.000000,43.353800>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<26.974100,0.000000,43.353800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.974100,0.000000,43.353800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.974100,0.000000,43.048800>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,-90.000000,0> translate<26.974100,0.000000,43.048800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.974100,0.000000,43.048800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.126600,0.000000,42.896300>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,44.997030,0> translate<26.974100,0.000000,43.048800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.514100,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.429200,0.000000,41.960800>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<29.514100,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.429200,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.429200,0.000000,42.418300>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<30.429200,0.000000,42.418300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.429200,0.000000,42.418300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.276700,0.000000,42.570900>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<30.276700,0.000000,42.570900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.276700,0.000000,42.570900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.666600,0.000000,42.570900>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<29.666600,0.000000,42.570900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.666600,0.000000,42.570900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.514100,0.000000,42.418300>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<29.514100,0.000000,42.418300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.514100,0.000000,42.418300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.514100,0.000000,41.960800>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<29.514100,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.819100,0.000000,42.896300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.514100,0.000000,43.201300>}
box{<0,0,-0.050800><0.431335,0.036000,0.050800> rotate<0,44.997030,0> translate<29.514100,0.000000,43.201300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.514100,0.000000,43.201300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.429200,0.000000,43.201300>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<29.514100,0.000000,43.201300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.429200,0.000000,42.896300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.429200,0.000000,43.506400>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,90.000000,0> translate<30.429200,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.054100,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.969200,0.000000,41.960800>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<32.054100,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.969200,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.969200,0.000000,42.418300>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<32.969200,0.000000,42.418300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.969200,0.000000,42.418300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.816700,0.000000,42.570900>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<32.816700,0.000000,42.570900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.816700,0.000000,42.570900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.206600,0.000000,42.570900>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<32.206600,0.000000,42.570900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.206600,0.000000,42.570900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.054100,0.000000,42.418300>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<32.054100,0.000000,42.418300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.054100,0.000000,42.418300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.054100,0.000000,41.960800>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<32.054100,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.816700,0.000000,42.896300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.206600,0.000000,42.896300>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<32.206600,0.000000,42.896300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.206600,0.000000,42.896300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.054100,0.000000,43.048800>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,44.997030,0> translate<32.054100,0.000000,43.048800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.054100,0.000000,43.048800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.054100,0.000000,43.353800>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,90.000000,0> translate<32.054100,0.000000,43.353800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.054100,0.000000,43.353800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.206600,0.000000,43.506400>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<32.054100,0.000000,43.353800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.206600,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.816700,0.000000,43.506400>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<32.206600,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.816700,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.969200,0.000000,43.353800>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<32.816700,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.969200,0.000000,43.353800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.969200,0.000000,43.048800>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,-90.000000,0> translate<32.969200,0.000000,43.048800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.969200,0.000000,43.048800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.816700,0.000000,42.896300>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,-44.997030,0> translate<32.816700,0.000000,42.896300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.816700,0.000000,42.896300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.206600,0.000000,43.506400>}
box{<0,0,-0.050800><0.862812,0.036000,0.050800> rotate<0,44.997030,0> translate<32.206600,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.594100,0.000000,42.570900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.594100,0.000000,41.960800>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,-90.000000,0> translate<34.594100,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.594100,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.509200,0.000000,41.960800>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<34.594100,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.509200,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.509200,0.000000,42.570900>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,90.000000,0> translate<35.509200,0.000000,42.570900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.051700,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.051700,0.000000,42.265800>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,90.000000,0> translate<35.051700,0.000000,42.265800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<38.049200,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.134100,0.000000,41.960800>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<37.134100,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.134100,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.134100,0.000000,42.418300>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<37.134100,0.000000,42.418300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.134100,0.000000,42.418300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.286600,0.000000,42.570900>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<37.134100,0.000000,42.418300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.286600,0.000000,42.570900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.591700,0.000000,42.570900>}
box{<0,0,-0.050800><0.305100,0.036000,0.050800> rotate<0,0.000000,0> translate<37.286600,0.000000,42.570900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.591700,0.000000,42.570900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.744200,0.000000,42.418300>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<37.591700,0.000000,42.570900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.744200,0.000000,42.418300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.744200,0.000000,41.960800>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<37.744200,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.744200,0.000000,42.265800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<38.049200,0.000000,42.570900>}
box{<0,0,-0.050800><0.431406,0.036000,0.050800> rotate<0,-45.006421,0> translate<37.744200,0.000000,42.265800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.134100,0.000000,42.896300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<38.049200,0.000000,42.896300>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<37.134100,0.000000,42.896300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<38.049200,0.000000,42.896300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.744200,0.000000,43.201300>}
box{<0,0,-0.050800><0.431335,0.036000,0.050800> rotate<0,44.997030,0> translate<37.744200,0.000000,43.201300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.744200,0.000000,43.201300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<38.049200,0.000000,43.506400>}
box{<0,0,-0.050800><0.431406,0.036000,0.050800> rotate<0,-45.006421,0> translate<37.744200,0.000000,43.201300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<38.049200,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.134100,0.000000,43.506400>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<37.134100,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.589200,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.674100,0.000000,41.960800>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<39.674100,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.674100,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.674100,0.000000,42.418300>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<39.674100,0.000000,42.418300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.674100,0.000000,42.418300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.826600,0.000000,42.570900>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<39.674100,0.000000,42.418300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.826600,0.000000,42.570900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.131700,0.000000,42.570900>}
box{<0,0,-0.050800><0.305100,0.036000,0.050800> rotate<0,0.000000,0> translate<39.826600,0.000000,42.570900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.131700,0.000000,42.570900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.284200,0.000000,42.418300>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<40.131700,0.000000,42.570900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.284200,0.000000,42.418300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.284200,0.000000,41.960800>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<40.284200,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.284200,0.000000,42.265800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.589200,0.000000,42.570900>}
box{<0,0,-0.050800><0.431406,0.036000,0.050800> rotate<0,-45.006421,0> translate<40.284200,0.000000,42.265800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.826600,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.674100,0.000000,43.353800>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<39.674100,0.000000,43.353800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.674100,0.000000,43.353800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.674100,0.000000,43.048800>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,-90.000000,0> translate<39.674100,0.000000,43.048800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.674100,0.000000,43.048800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.826600,0.000000,42.896300>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,44.997030,0> translate<39.674100,0.000000,43.048800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.826600,0.000000,42.896300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.979100,0.000000,42.896300>}
box{<0,0,-0.050800><0.152500,0.036000,0.050800> rotate<0,0.000000,0> translate<39.826600,0.000000,42.896300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<39.979100,0.000000,42.896300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.131700,0.000000,43.048800>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-44.978252,0> translate<39.979100,0.000000,42.896300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.131700,0.000000,43.048800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.131700,0.000000,43.353800>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,90.000000,0> translate<40.131700,0.000000,43.353800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.131700,0.000000,43.353800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.284200,0.000000,43.506400>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<40.131700,0.000000,43.353800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.284200,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.436700,0.000000,43.506400>}
box{<0,0,-0.050800><0.152500,0.036000,0.050800> rotate<0,0.000000,0> translate<40.284200,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.436700,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.589200,0.000000,43.353800>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<40.436700,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.589200,0.000000,43.353800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.589200,0.000000,43.048800>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,-90.000000,0> translate<40.589200,0.000000,43.048800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.589200,0.000000,43.048800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<40.436700,0.000000,42.896300>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,-44.997030,0> translate<40.436700,0.000000,42.896300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.366600,0.000000,42.570900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214100,0.000000,42.418300>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<42.214100,0.000000,42.418300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214100,0.000000,42.418300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214100,0.000000,42.113300>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,-90.000000,0> translate<42.214100,0.000000,42.113300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214100,0.000000,42.113300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.366600,0.000000,41.960800>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,44.997030,0> translate<42.214100,0.000000,42.113300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.366600,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.976700,0.000000,41.960800>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<42.366600,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.976700,0.000000,41.960800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.129200,0.000000,42.113300>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,-44.997030,0> translate<42.976700,0.000000,41.960800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.129200,0.000000,42.113300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.129200,0.000000,42.418300>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,90.000000,0> translate<43.129200,0.000000,42.418300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.129200,0.000000,42.418300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.976700,0.000000,42.570900>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<42.976700,0.000000,42.570900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214100,0.000000,43.353800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214100,0.000000,43.048800>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,-90.000000,0> translate<42.214100,0.000000,43.048800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214100,0.000000,43.048800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.366600,0.000000,42.896300>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,44.997030,0> translate<42.214100,0.000000,43.048800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.366600,0.000000,42.896300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.976700,0.000000,42.896300>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<42.366600,0.000000,42.896300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.976700,0.000000,42.896300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.129200,0.000000,43.048800>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,-44.997030,0> translate<42.976700,0.000000,42.896300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.129200,0.000000,43.048800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.129200,0.000000,43.353800>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,90.000000,0> translate<43.129200,0.000000,43.353800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.129200,0.000000,43.353800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.976700,0.000000,43.506400>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<42.976700,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.976700,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.366600,0.000000,43.506400>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<42.366600,0.000000,43.506400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.366600,0.000000,43.506400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214100,0.000000,43.353800>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<42.214100,0.000000,43.353800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.129200,0.000000,43.831800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214100,0.000000,43.831800>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<42.214100,0.000000,43.831800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214100,0.000000,43.831800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.129200,0.000000,44.441900>}
box{<0,0,-0.050800><1.099832,0.036000,0.050800> rotate<0,-33.689289,0> translate<42.214100,0.000000,43.831800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.129200,0.000000,44.441900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214100,0.000000,44.441900>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<42.214100,0.000000,44.441900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.129200,0.000000,45.072300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214100,0.000000,45.072300>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<42.214100,0.000000,45.072300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214100,0.000000,44.767300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214100,0.000000,45.377400>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,90.000000,0> translate<42.214100,0.000000,45.377400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.129200,0.000000,45.702800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214100,0.000000,45.702800>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<42.214100,0.000000,45.702800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214100,0.000000,45.702800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214100,0.000000,46.160300>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<42.214100,0.000000,46.160300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.214100,0.000000,46.160300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.366600,0.000000,46.312900>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<42.214100,0.000000,46.160300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.366600,0.000000,46.312900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.671700,0.000000,46.312900>}
box{<0,0,-0.050800><0.305100,0.036000,0.050800> rotate<0,0.000000,0> translate<42.366600,0.000000,46.312900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.671700,0.000000,46.312900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.824200,0.000000,46.160300>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<42.671700,0.000000,46.312900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.824200,0.000000,46.160300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.824200,0.000000,45.702800>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<42.824200,0.000000,45.702800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<42.824200,0.000000,46.007800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<43.129200,0.000000,46.312900>}
box{<0,0,-0.050800><0.431406,0.036000,0.050800> rotate<0,-45.006421,0> translate<42.824200,0.000000,46.007800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.318700,0.000000,79.971900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.691600,0.000000,79.971900>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<53.691600,0.000000,79.971900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.691600,0.000000,79.971900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.378100,0.000000,79.658400>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<53.378100,0.000000,79.658400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.378100,0.000000,79.658400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.691600,0.000000,79.344900>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<53.378100,0.000000,79.658400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.691600,0.000000,79.344900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.318700,0.000000,79.344900>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<53.691600,0.000000,79.344900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.161900,0.000000,78.409400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.318700,0.000000,78.566100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<54.161900,0.000000,78.409400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.318700,0.000000,78.566100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.318700,0.000000,78.879700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<54.318700,0.000000,78.879700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.318700,0.000000,78.879700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.161900,0.000000,79.036400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<54.161900,0.000000,79.036400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.161900,0.000000,79.036400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.534800,0.000000,79.036400>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<53.534800,0.000000,79.036400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.534800,0.000000,79.036400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.378100,0.000000,78.879700>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<53.378100,0.000000,78.879700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.378100,0.000000,78.879700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.378100,0.000000,78.566100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<53.378100,0.000000,78.566100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.378100,0.000000,78.566100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.534800,0.000000,78.409400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<53.378100,0.000000,78.566100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.161900,0.000000,77.473900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.318700,0.000000,77.630600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<54.161900,0.000000,77.473900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.318700,0.000000,77.630600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.318700,0.000000,77.944200>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<54.318700,0.000000,77.944200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.318700,0.000000,77.944200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.161900,0.000000,78.100900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<54.161900,0.000000,78.100900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<54.161900,0.000000,78.100900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.534800,0.000000,78.100900>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<53.534800,0.000000,78.100900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.534800,0.000000,78.100900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.378100,0.000000,77.944200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<53.378100,0.000000,77.944200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.378100,0.000000,77.944200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.378100,0.000000,77.630600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<53.378100,0.000000,77.630600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.378100,0.000000,77.630600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.534800,0.000000,77.473900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<53.378100,0.000000,77.630600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.845900,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.930800,0.000000,79.959200>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<55.930800,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.930800,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.930800,0.000000,79.501700>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<55.930800,0.000000,79.501700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.930800,0.000000,79.501700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.083300,0.000000,79.349100>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<55.930800,0.000000,79.501700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.083300,0.000000,79.349100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.693400,0.000000,79.349100>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<56.083300,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.693400,0.000000,79.349100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.845900,0.000000,79.501700>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<56.693400,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.845900,0.000000,79.501700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.845900,0.000000,79.959200>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<56.845900,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.845900,0.000000,79.023700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.845900,0.000000,78.413600>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,-90.000000,0> translate<56.845900,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.845900,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.693400,0.000000,78.413600>}
box{<0,0,-0.050800><0.152500,0.036000,0.050800> rotate<0,0.000000,0> translate<56.693400,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.693400,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.083300,0.000000,79.023700>}
box{<0,0,-0.050800><0.862812,0.036000,0.050800> rotate<0,44.997030,0> translate<56.083300,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.083300,0.000000,79.023700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.930800,0.000000,79.023700>}
box{<0,0,-0.050800><0.152500,0.036000,0.050800> rotate<0,0.000000,0> translate<55.930800,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.385900,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.470800,0.000000,79.959200>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<58.470800,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.470800,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.470800,0.000000,79.501700>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<58.470800,0.000000,79.501700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.470800,0.000000,79.501700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.623300,0.000000,79.349100>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<58.470800,0.000000,79.501700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.623300,0.000000,79.349100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.233400,0.000000,79.349100>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<58.623300,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.233400,0.000000,79.349100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.385900,0.000000,79.501700>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<59.233400,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.385900,0.000000,79.501700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.385900,0.000000,79.959200>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<59.385900,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.385900,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.233400,0.000000,78.718700>}
box{<0,0,-0.050800><0.341090,0.036000,0.050800> rotate<0,63.438274,0> translate<59.233400,0.000000,78.718700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.233400,0.000000,78.718700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.928300,0.000000,79.023700>}
box{<0,0,-0.050800><0.431406,0.036000,0.050800> rotate<0,44.987640,0> translate<58.928300,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.928300,0.000000,79.023700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.623300,0.000000,79.023700>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,0.000000,0> translate<58.623300,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.623300,0.000000,79.023700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.470800,0.000000,78.871200>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,-44.997030,0> translate<58.470800,0.000000,78.871200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.470800,0.000000,78.871200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.470800,0.000000,78.566200>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,-90.000000,0> translate<58.470800,0.000000,78.566200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.470800,0.000000,78.566200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.623300,0.000000,78.413600>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<58.470800,0.000000,78.566200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.623300,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.775800,0.000000,78.413600>}
box{<0,0,-0.050800><0.152500,0.036000,0.050800> rotate<0,0.000000,0> translate<58.623300,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.775800,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.928300,0.000000,78.566200>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<58.775800,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.928300,0.000000,78.566200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.928300,0.000000,79.023700>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<58.928300,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.925900,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.010800,0.000000,79.959200>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<61.010800,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.010800,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.010800,0.000000,79.501700>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<61.010800,0.000000,79.501700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.010800,0.000000,79.501700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.163300,0.000000,79.349100>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<61.010800,0.000000,79.501700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.163300,0.000000,79.349100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.773400,0.000000,79.349100>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<61.163300,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.773400,0.000000,79.349100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.925900,0.000000,79.501700>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<61.773400,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.925900,0.000000,79.501700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.925900,0.000000,79.959200>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<61.925900,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.925900,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.925900,0.000000,79.023700>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,90.000000,0> translate<61.925900,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.925900,0.000000,79.023700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.468300,0.000000,79.023700>}
box{<0,0,-0.050800><0.457600,0.036000,0.050800> rotate<0,0.000000,0> translate<61.468300,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.468300,0.000000,79.023700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.620900,0.000000,78.718700>}
box{<0,0,-0.050800><0.341045,0.036000,0.050800> rotate<0,63.415737,0> translate<61.468300,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.620900,0.000000,78.718700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.620900,0.000000,78.566200>}
box{<0,0,-0.050800><0.152500,0.036000,0.050800> rotate<0,-90.000000,0> translate<61.620900,0.000000,78.566200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.620900,0.000000,78.566200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.468300,0.000000,78.413600>}
box{<0,0,-0.050800><0.215809,0.036000,0.050800> rotate<0,-44.997030,0> translate<61.468300,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.468300,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.163300,0.000000,78.413600>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,0.000000,0> translate<61.163300,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.163300,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.010800,0.000000,78.566200>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<61.010800,0.000000,78.566200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.010800,0.000000,78.566200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.010800,0.000000,78.871200>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,90.000000,0> translate<61.010800,0.000000,78.871200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.010800,0.000000,78.871200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.163300,0.000000,79.023700>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,-44.997030,0> translate<61.010800,0.000000,78.871200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.465900,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.550800,0.000000,79.959200>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<63.550800,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.550800,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.550800,0.000000,79.501700>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<63.550800,0.000000,79.501700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.550800,0.000000,79.501700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.703300,0.000000,79.349100>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<63.550800,0.000000,79.501700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.703300,0.000000,79.349100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.313400,0.000000,79.349100>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<63.703300,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.313400,0.000000,79.349100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.465900,0.000000,79.501700>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<64.313400,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.465900,0.000000,79.501700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.465900,0.000000,79.959200>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<64.465900,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.550800,0.000000,78.566200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.465900,0.000000,78.566200>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<63.550800,0.000000,78.566200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.465900,0.000000,78.566200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.008300,0.000000,79.023700>}
box{<0,0,-0.050800><0.647073,0.036000,0.050800> rotate<0,44.990769,0> translate<64.008300,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.008300,0.000000,79.023700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.008300,0.000000,78.413600>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,-90.000000,0> translate<64.008300,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.005900,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.090800,0.000000,79.959200>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<66.090800,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.090800,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.090800,0.000000,79.501700>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<66.090800,0.000000,79.501700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.090800,0.000000,79.501700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.243300,0.000000,79.349100>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<66.090800,0.000000,79.501700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.243300,0.000000,79.349100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.853400,0.000000,79.349100>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<66.243300,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.853400,0.000000,79.349100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.005900,0.000000,79.501700>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<66.853400,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.005900,0.000000,79.501700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.005900,0.000000,79.959200>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<67.005900,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.853400,0.000000,79.023700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.005900,0.000000,78.871200>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,44.997030,0> translate<66.853400,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.005900,0.000000,78.871200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.005900,0.000000,78.566200>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,-90.000000,0> translate<67.005900,0.000000,78.566200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.005900,0.000000,78.566200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.853400,0.000000,78.413600>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<66.853400,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.853400,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.700900,0.000000,78.413600>}
box{<0,0,-0.050800><0.152500,0.036000,0.050800> rotate<0,0.000000,0> translate<66.700900,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.700900,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.548300,0.000000,78.566200>}
box{<0,0,-0.050800><0.215809,0.036000,0.050800> rotate<0,44.997030,0> translate<66.548300,0.000000,78.566200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.548300,0.000000,78.566200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.548300,0.000000,78.718700>}
box{<0,0,-0.050800><0.152500,0.036000,0.050800> rotate<0,90.000000,0> translate<66.548300,0.000000,78.718700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.548300,0.000000,78.566200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.395800,0.000000,78.413600>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<66.395800,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.395800,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.243300,0.000000,78.413600>}
box{<0,0,-0.050800><0.152500,0.036000,0.050800> rotate<0,0.000000,0> translate<66.243300,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.243300,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.090800,0.000000,78.566200>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<66.090800,0.000000,78.566200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.090800,0.000000,78.566200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.090800,0.000000,78.871200>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,90.000000,0> translate<66.090800,0.000000,78.871200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.090800,0.000000,78.871200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.243300,0.000000,79.023700>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,-44.997030,0> translate<66.090800,0.000000,78.871200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.545900,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.630800,0.000000,79.959200>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<68.630800,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.630800,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.630800,0.000000,79.501700>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<68.630800,0.000000,79.501700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.630800,0.000000,79.501700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.783300,0.000000,79.349100>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<68.630800,0.000000,79.501700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.783300,0.000000,79.349100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.393400,0.000000,79.349100>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<68.783300,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.393400,0.000000,79.349100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.545900,0.000000,79.501700>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<69.393400,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.545900,0.000000,79.501700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.545900,0.000000,79.959200>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<69.545900,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.630800,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.630800,0.000000,79.023700>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,90.000000,0> translate<68.630800,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.630800,0.000000,79.023700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.240900,0.000000,78.413600>}
box{<0,0,-0.050800><0.862812,0.036000,0.050800> rotate<0,44.997030,0> translate<68.630800,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.240900,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.393400,0.000000,78.413600>}
box{<0,0,-0.050800><0.152500,0.036000,0.050800> rotate<0,0.000000,0> translate<69.240900,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.393400,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.545900,0.000000,78.566200>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<69.393400,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.545900,0.000000,78.566200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.545900,0.000000,78.871200>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,90.000000,0> translate<69.545900,0.000000,78.871200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.545900,0.000000,78.871200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.393400,0.000000,79.023700>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,44.997030,0> translate<69.393400,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.085900,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.170800,0.000000,79.959200>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<71.170800,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.170800,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.170800,0.000000,79.501700>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<71.170800,0.000000,79.501700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.170800,0.000000,79.501700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.323300,0.000000,79.349100>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<71.170800,0.000000,79.501700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.323300,0.000000,79.349100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.933400,0.000000,79.349100>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<71.323300,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.933400,0.000000,79.349100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.085900,0.000000,79.501700>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<71.933400,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.085900,0.000000,79.501700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.085900,0.000000,79.959200>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<72.085900,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.780900,0.000000,79.023700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.085900,0.000000,78.718700>}
box{<0,0,-0.050800><0.431335,0.036000,0.050800> rotate<0,44.997030,0> translate<71.780900,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.085900,0.000000,78.718700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.170800,0.000000,78.718700>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<71.170800,0.000000,78.718700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.170800,0.000000,79.023700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.170800,0.000000,78.413600>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,-90.000000,0> translate<71.170800,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.625900,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.710800,0.000000,79.959200>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<73.710800,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.710800,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.710800,0.000000,79.501700>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<73.710800,0.000000,79.501700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.710800,0.000000,79.501700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.863300,0.000000,79.349100>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<73.710800,0.000000,79.501700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.863300,0.000000,79.349100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.473400,0.000000,79.349100>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<73.863300,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.473400,0.000000,79.349100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.625900,0.000000,79.501700>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<74.473400,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.625900,0.000000,79.501700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.625900,0.000000,79.959200>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<74.625900,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.863300,0.000000,79.023700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.473400,0.000000,79.023700>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<73.863300,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.473400,0.000000,79.023700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.625900,0.000000,78.871200>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,44.997030,0> translate<74.473400,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.625900,0.000000,78.871200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.625900,0.000000,78.566200>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,-90.000000,0> translate<74.625900,0.000000,78.566200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.625900,0.000000,78.566200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.473400,0.000000,78.413600>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<74.473400,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.473400,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.863300,0.000000,78.413600>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<73.863300,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.863300,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.710800,0.000000,78.566200>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<73.710800,0.000000,78.566200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.710800,0.000000,78.566200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.710800,0.000000,78.871200>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,90.000000,0> translate<73.710800,0.000000,78.871200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.710800,0.000000,78.871200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.863300,0.000000,79.023700>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,-44.997030,0> translate<73.710800,0.000000,78.871200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.863300,0.000000,79.023700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.473400,0.000000,78.413600>}
box{<0,0,-0.050800><0.862812,0.036000,0.050800> rotate<0,44.997030,0> translate<73.863300,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165900,0.000000,79.349100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165900,0.000000,79.959200>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,90.000000,0> translate<77.165900,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165900,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.250800,0.000000,79.959200>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<76.250800,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.250800,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.250800,0.000000,79.349100>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,-90.000000,0> translate<76.250800,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.708300,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.708300,0.000000,79.654200>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,-90.000000,0> translate<76.708300,0.000000,79.654200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.790800,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.705900,0.000000,79.959200>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<78.790800,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.705900,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.705900,0.000000,79.501700>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<79.705900,0.000000,79.501700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.705900,0.000000,79.501700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.553400,0.000000,79.349100>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<79.553400,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.553400,0.000000,79.349100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.248300,0.000000,79.349100>}
box{<0,0,-0.050800><0.305100,0.036000,0.050800> rotate<0,0.000000,0> translate<79.248300,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.248300,0.000000,79.349100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.095800,0.000000,79.501700>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<79.095800,0.000000,79.501700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.095800,0.000000,79.501700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.095800,0.000000,79.959200>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<79.095800,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.095800,0.000000,79.654200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.790800,0.000000,79.349100>}
box{<0,0,-0.050800><0.431406,0.036000,0.050800> rotate<0,-45.006421,0> translate<78.790800,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.705900,0.000000,79.023700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.790800,0.000000,79.023700>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<78.790800,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.790800,0.000000,79.023700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.095800,0.000000,78.718700>}
box{<0,0,-0.050800><0.431335,0.036000,0.050800> rotate<0,44.997030,0> translate<78.790800,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.095800,0.000000,78.718700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.790800,0.000000,78.413600>}
box{<0,0,-0.050800><0.431406,0.036000,0.050800> rotate<0,-45.006421,0> translate<78.790800,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.790800,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.705900,0.000000,78.413600>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<78.790800,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.330800,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245900,0.000000,79.959200>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<81.330800,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245900,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245900,0.000000,79.501700>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<82.245900,0.000000,79.501700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245900,0.000000,79.501700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.093400,0.000000,79.349100>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<82.093400,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.093400,0.000000,79.349100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.788300,0.000000,79.349100>}
box{<0,0,-0.050800><0.305100,0.036000,0.050800> rotate<0,0.000000,0> translate<81.788300,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.788300,0.000000,79.349100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.635800,0.000000,79.501700>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<81.635800,0.000000,79.501700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.635800,0.000000,79.501700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.635800,0.000000,79.959200>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<81.635800,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.635800,0.000000,79.654200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.330800,0.000000,79.349100>}
box{<0,0,-0.050800><0.431406,0.036000,0.050800> rotate<0,-45.006421,0> translate<81.330800,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.093400,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245900,0.000000,78.566200>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<82.093400,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245900,0.000000,78.566200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245900,0.000000,78.871200>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,90.000000,0> translate<82.245900,0.000000,78.871200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.245900,0.000000,78.871200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.093400,0.000000,79.023700>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,44.997030,0> translate<82.093400,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<82.093400,0.000000,79.023700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.940900,0.000000,79.023700>}
box{<0,0,-0.050800><0.152500,0.036000,0.050800> rotate<0,0.000000,0> translate<81.940900,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.940900,0.000000,79.023700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.788300,0.000000,78.871200>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-44.978252,0> translate<81.788300,0.000000,78.871200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.788300,0.000000,78.871200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.788300,0.000000,78.566200>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,-90.000000,0> translate<81.788300,0.000000,78.566200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.788300,0.000000,78.566200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.635800,0.000000,78.413600>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<81.635800,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.635800,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.483300,0.000000,78.413600>}
box{<0,0,-0.050800><0.152500,0.036000,0.050800> rotate<0,0.000000,0> translate<81.483300,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.483300,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.330800,0.000000,78.566200>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<81.330800,0.000000,78.566200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.330800,0.000000,78.566200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.330800,0.000000,78.871200>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,90.000000,0> translate<81.330800,0.000000,78.871200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.330800,0.000000,78.871200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.483300,0.000000,79.023700>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,-44.997030,0> translate<81.330800,0.000000,78.871200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.633400,0.000000,79.349100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.785900,0.000000,79.501700>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<84.633400,0.000000,79.349100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.785900,0.000000,79.501700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.785900,0.000000,79.806700>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,90.000000,0> translate<84.785900,0.000000,79.806700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.785900,0.000000,79.806700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.633400,0.000000,79.959200>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,44.997030,0> translate<84.633400,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.633400,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.023300,0.000000,79.959200>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<84.023300,0.000000,79.959200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.023300,0.000000,79.959200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.870800,0.000000,79.806700>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,-44.997030,0> translate<83.870800,0.000000,79.806700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.870800,0.000000,79.806700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.870800,0.000000,79.501700>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,-90.000000,0> translate<83.870800,0.000000,79.501700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.870800,0.000000,79.501700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.023300,0.000000,79.349100>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<83.870800,0.000000,79.501700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.785900,0.000000,78.566200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.785900,0.000000,78.871200>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,90.000000,0> translate<84.785900,0.000000,78.871200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.785900,0.000000,78.871200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.633400,0.000000,79.023700>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,44.997030,0> translate<84.633400,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.633400,0.000000,79.023700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.023300,0.000000,79.023700>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<84.023300,0.000000,79.023700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.023300,0.000000,79.023700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.870800,0.000000,78.871200>}
box{<0,0,-0.050800><0.215668,0.036000,0.050800> rotate<0,-44.997030,0> translate<83.870800,0.000000,78.871200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.870800,0.000000,78.871200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.870800,0.000000,78.566200>}
box{<0,0,-0.050800><0.305000,0.036000,0.050800> rotate<0,-90.000000,0> translate<83.870800,0.000000,78.566200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.870800,0.000000,78.566200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.023300,0.000000,78.413600>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<83.870800,0.000000,78.566200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.023300,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.633400,0.000000,78.413600>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,0.000000,0> translate<84.023300,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.633400,0.000000,78.413600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.785900,0.000000,78.566200>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<84.633400,0.000000,78.413600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.870800,0.000000,78.088200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.785900,0.000000,78.088200>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<83.870800,0.000000,78.088200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.785900,0.000000,78.088200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.870800,0.000000,77.478100>}
box{<0,0,-0.050800><1.099832,0.036000,0.050800> rotate<0,-33.689289,0> translate<83.870800,0.000000,77.478100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.870800,0.000000,77.478100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.785900,0.000000,77.478100>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<83.870800,0.000000,77.478100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.870800,0.000000,76.847700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.785900,0.000000,76.847700>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<83.870800,0.000000,76.847700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.785900,0.000000,77.152700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.785900,0.000000,76.542600>}
box{<0,0,-0.050800><0.610100,0.036000,0.050800> rotate<0,-90.000000,0> translate<84.785900,0.000000,76.542600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.870800,0.000000,76.217200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.785900,0.000000,76.217200>}
box{<0,0,-0.050800><0.915100,0.036000,0.050800> rotate<0,0.000000,0> translate<83.870800,0.000000,76.217200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.785900,0.000000,76.217200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.785900,0.000000,75.759700>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,-90.000000,0> translate<84.785900,0.000000,75.759700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.785900,0.000000,75.759700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.633400,0.000000,75.607100>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,-45.015808,0> translate<84.633400,0.000000,75.607100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.633400,0.000000,75.607100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.328300,0.000000,75.607100>}
box{<0,0,-0.050800><0.305100,0.036000,0.050800> rotate<0,0.000000,0> translate<84.328300,0.000000,75.607100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.328300,0.000000,75.607100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.175800,0.000000,75.759700>}
box{<0,0,-0.050800><0.215738,0.036000,0.050800> rotate<0,45.015808,0> translate<84.175800,0.000000,75.759700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.175800,0.000000,75.759700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.175800,0.000000,76.217200>}
box{<0,0,-0.050800><0.457500,0.036000,0.050800> rotate<0,90.000000,0> translate<84.175800,0.000000,76.217200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.175800,0.000000,75.912200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.870800,0.000000,75.607100>}
box{<0,0,-0.050800><0.431406,0.036000,0.050800> rotate<0,-45.006421,0> translate<83.870800,0.000000,75.607100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.181900,0.000000,79.344900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.338700,0.000000,79.501600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<87.181900,0.000000,79.344900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.338700,0.000000,79.501600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.338700,0.000000,79.815200>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<87.338700,0.000000,79.815200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.338700,0.000000,79.815200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.181900,0.000000,79.971900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<87.181900,0.000000,79.971900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.181900,0.000000,79.971900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.554800,0.000000,79.971900>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<86.554800,0.000000,79.971900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.554800,0.000000,79.971900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.398100,0.000000,79.815200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<86.398100,0.000000,79.815200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.398100,0.000000,79.815200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.398100,0.000000,79.501600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<86.398100,0.000000,79.501600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.398100,0.000000,79.501600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.554800,0.000000,79.344900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<86.398100,0.000000,79.501600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.554800,0.000000,79.344900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.868400,0.000000,79.344900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<86.554800,0.000000,79.344900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.868400,0.000000,79.344900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.868400,0.000000,79.658400>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,90.000000,0> translate<86.868400,0.000000,79.658400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.398100,0.000000,79.036400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.338700,0.000000,79.036400>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<86.398100,0.000000,79.036400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.338700,0.000000,79.036400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.398100,0.000000,78.409400>}
box{<0,0,-0.038100><1.130424,0.036000,0.038100> rotate<0,-33.685033,0> translate<86.398100,0.000000,78.409400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.398100,0.000000,78.409400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.338700,0.000000,78.409400>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<86.398100,0.000000,78.409400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.338700,0.000000,78.100900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.398100,0.000000,78.100900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<86.398100,0.000000,78.100900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.398100,0.000000,78.100900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.398100,0.000000,77.630600>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<86.398100,0.000000,77.630600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.398100,0.000000,77.630600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.554800,0.000000,77.473900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<86.398100,0.000000,77.630600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.554800,0.000000,77.473900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.181900,0.000000,77.473900>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<86.554800,0.000000,77.473900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.181900,0.000000,77.473900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.338700,0.000000,77.630600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<87.181900,0.000000,77.473900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.338700,0.000000,77.630600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.338700,0.000000,78.100900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,90.000000,0> translate<87.338700,0.000000,78.100900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,79.971900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.251600,0.000000,79.971900>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<89.251600,0.000000,79.971900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.251600,0.000000,79.971900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,79.658400>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<88.938100,0.000000,79.658400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,79.658400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.251600,0.000000,79.344900>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<88.938100,0.000000,79.658400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.251600,0.000000,79.344900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,79.344900>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<89.251600,0.000000,79.344900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,78.409400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,78.566100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<89.721900,0.000000,78.409400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,78.566100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,78.879700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<89.878700,0.000000,78.879700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,78.879700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,79.036400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<89.721900,0.000000,79.036400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,79.036400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,79.036400>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<89.094800,0.000000,79.036400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,79.036400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,78.879700>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<88.938100,0.000000,78.879700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,78.879700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,78.566100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<88.938100,0.000000,78.566100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,78.566100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,78.409400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<88.938100,0.000000,78.566100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,77.473900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,77.630600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<89.721900,0.000000,77.473900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,77.630600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,77.944200>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<89.878700,0.000000,77.944200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.878700,0.000000,77.944200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,78.100900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<89.721900,0.000000,78.100900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.721900,0.000000,78.100900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,78.100900>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,0.000000,0> translate<89.094800,0.000000,78.100900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,78.100900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,77.944200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<88.938100,0.000000,77.944200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,77.944200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,77.630600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<88.938100,0.000000,77.630600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.938100,0.000000,77.630600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.094800,0.000000,77.473900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<88.938100,0.000000,77.630600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.170800,0.000000,44.400100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.170800,0.000000,43.230800>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,-90.000000,0> translate<71.170800,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.170800,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.950300,0.000000,43.230800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<71.170800,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.119600,0.000000,44.205200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.924700,0.000000,44.400100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<72.924700,0.000000,44.400100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.924700,0.000000,44.400100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.534900,0.000000,44.400100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<72.534900,0.000000,44.400100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.534900,0.000000,44.400100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.340100,0.000000,44.205200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<72.340100,0.000000,44.205200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.340100,0.000000,44.205200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.340100,0.000000,43.425600>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,-90.000000,0> translate<72.340100,0.000000,43.425600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.340100,0.000000,43.425600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.534900,0.000000,43.230800>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<72.340100,0.000000,43.425600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.534900,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.924700,0.000000,43.230800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<72.534900,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.924700,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.119600,0.000000,43.425600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<72.924700,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.509400,0.000000,44.400100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.509400,0.000000,43.230800>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,-90.000000,0> translate<73.509400,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.509400,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.094000,0.000000,43.230800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<73.509400,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.094000,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.288900,0.000000,43.425600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<74.094000,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.288900,0.000000,43.425600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.288900,0.000000,44.205200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,90.000000,0> translate<74.288900,0.000000,44.205200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.288900,0.000000,44.205200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.094000,0.000000,44.400100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<74.094000,0.000000,44.400100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<74.094000,0.000000,44.400100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.509400,0.000000,44.400100>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<73.509400,0.000000,44.400100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.848000,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.848000,0.000000,44.400100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,90.000000,0> translate<75.848000,0.000000,44.400100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.848000,0.000000,44.400100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.432600,0.000000,44.400100>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<75.848000,0.000000,44.400100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.432600,0.000000,44.400100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.627500,0.000000,44.205200>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<76.432600,0.000000,44.400100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.627500,0.000000,44.205200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.627500,0.000000,44.010300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<76.627500,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.627500,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.432600,0.000000,43.815400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<76.432600,0.000000,43.815400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.432600,0.000000,43.815400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.627500,0.000000,43.620500>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<76.432600,0.000000,43.815400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.627500,0.000000,43.620500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.627500,0.000000,43.425600>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<76.627500,0.000000,43.425600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.627500,0.000000,43.425600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.432600,0.000000,43.230800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<76.432600,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.432600,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.848000,0.000000,43.230800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<75.848000,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.848000,0.000000,43.815400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.432600,0.000000,43.815400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<75.848000,0.000000,43.815400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.017300,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.017300,0.000000,43.425600>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,-90.000000,0> translate<77.017300,0.000000,43.425600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.017300,0.000000,43.425600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.212100,0.000000,43.230800>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<77.017300,0.000000,43.425600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.212100,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.796800,0.000000,43.230800>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,0.000000,0> translate<77.212100,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.796800,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.796800,0.000000,44.010300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<77.796800,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.381400,0.000000,44.205200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.381400,0.000000,43.425600>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,-90.000000,0> translate<78.381400,0.000000,43.425600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.381400,0.000000,43.425600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.576300,0.000000,43.230800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<78.381400,0.000000,43.425600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.186600,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.576300,0.000000,44.010300>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,0.000000,0> translate<78.186600,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.160900,0.000000,44.205200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.160900,0.000000,43.425600>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,-90.000000,0> translate<79.160900,0.000000,43.425600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.160900,0.000000,43.425600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.355800,0.000000,43.230800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<79.160900,0.000000,43.425600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.966100,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.355800,0.000000,44.010300>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,0.000000,0> translate<78.966100,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.940400,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<80.330200,0.000000,43.230800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<79.940400,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<80.330200,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<80.525100,0.000000,43.425600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<80.330200,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<80.525100,0.000000,43.425600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<80.525100,0.000000,43.815400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<80.525100,0.000000,43.815400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<80.525100,0.000000,43.815400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<80.330200,0.000000,44.010300>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<80.330200,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<80.330200,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.940400,0.000000,44.010300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<79.940400,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.940400,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.745600,0.000000,43.815400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<79.745600,0.000000,43.815400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.745600,0.000000,43.815400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.745600,0.000000,43.425600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<79.745600,0.000000,43.425600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.745600,0.000000,43.425600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.940400,0.000000,43.230800>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<79.745600,0.000000,43.425600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<80.914900,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<80.914900,0.000000,44.010300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<80.914900,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<80.914900,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.499500,0.000000,44.010300>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<80.914900,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.499500,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.694400,0.000000,43.815400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<81.499500,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.694400,0.000000,43.815400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<81.694400,0.000000,43.230800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<81.694400,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.253500,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.448300,0.000000,44.010300>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<83.253500,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.448300,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.448300,0.000000,43.230800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<83.448300,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.253500,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.643200,0.000000,43.230800>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,0.000000,0> translate<83.253500,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.448300,0.000000,44.595000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<83.448300,0.000000,44.400100>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<83.448300,0.000000,44.400100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.033000,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.033000,0.000000,44.010300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<84.033000,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.033000,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.617600,0.000000,44.010300>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<84.033000,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.617600,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.812500,0.000000,43.815400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<84.617600,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.812500,0.000000,43.815400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<84.812500,0.000000,43.230800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<84.812500,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.397100,0.000000,44.205200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.397100,0.000000,43.425600>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,-90.000000,0> translate<85.397100,0.000000,43.425600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.397100,0.000000,43.425600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.592000,0.000000,43.230800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<85.397100,0.000000,43.425600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.202300,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.592000,0.000000,44.010300>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,0.000000,0> translate<85.202300,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.566400,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.176600,0.000000,43.230800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<86.176600,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.176600,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.981800,0.000000,43.425600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<85.981800,0.000000,43.425600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.981800,0.000000,43.425600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.981800,0.000000,43.815400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<85.981800,0.000000,43.815400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.981800,0.000000,43.815400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.176600,0.000000,44.010300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<85.981800,0.000000,43.815400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.176600,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.566400,0.000000,44.010300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<86.176600,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.566400,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.761300,0.000000,43.815400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<86.566400,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.761300,0.000000,43.815400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.761300,0.000000,43.620500>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<86.761300,0.000000,43.620500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<86.761300,0.000000,43.620500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<85.981800,0.000000,43.620500>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<85.981800,0.000000,43.620500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.151100,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.151100,0.000000,44.010300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<87.151100,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.151100,0.000000,43.620500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.540800,0.000000,44.010300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<87.151100,0.000000,43.620500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.540800,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<87.735700,0.000000,44.010300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<87.540800,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.320300,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.320300,0.000000,44.205200>}
box{<0,0,-0.050800><0.974400,0.036000,0.050800> rotate<0,90.000000,0> translate<88.320300,0.000000,44.205200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.320300,0.000000,44.205200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.515200,0.000000,44.400100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<88.320300,0.000000,44.205200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.125500,0.000000,43.815400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.515200,0.000000,43.815400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,0.000000,0> translate<88.125500,0.000000,43.815400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.099800,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.489600,0.000000,44.010300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<89.099800,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.489600,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.684500,0.000000,43.815400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<89.489600,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.684500,0.000000,43.815400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.684500,0.000000,43.230800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<89.684500,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.684500,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.099800,0.000000,43.230800>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,0.000000,0> translate<89.099800,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.099800,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.905000,0.000000,43.425600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<88.905000,0.000000,43.425600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<88.905000,0.000000,43.425600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.099800,0.000000,43.620500>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<88.905000,0.000000,43.425600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.099800,0.000000,43.620500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<89.684500,0.000000,43.620500>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,0.000000,0> translate<89.099800,0.000000,43.620500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<90.853800,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<90.269100,0.000000,44.010300>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,0.000000,0> translate<90.269100,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<90.269100,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<90.074300,0.000000,43.815400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<90.074300,0.000000,43.815400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<90.074300,0.000000,43.815400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<90.074300,0.000000,43.425600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<90.074300,0.000000,43.425600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<90.074300,0.000000,43.425600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<90.269100,0.000000,43.230800>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<90.074300,0.000000,43.425600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<90.269100,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<90.853800,0.000000,43.230800>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,0.000000,0> translate<90.269100,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<91.828200,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<91.438400,0.000000,43.230800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<91.438400,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<91.438400,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<91.243600,0.000000,43.425600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<91.243600,0.000000,43.425600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<91.243600,0.000000,43.425600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<91.243600,0.000000,43.815400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<91.243600,0.000000,43.815400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<91.243600,0.000000,43.815400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<91.438400,0.000000,44.010300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<91.243600,0.000000,43.815400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<91.438400,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<91.828200,0.000000,44.010300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<91.438400,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<91.828200,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<92.023100,0.000000,43.815400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<91.828200,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<92.023100,0.000000,43.815400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<92.023100,0.000000,43.620500>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<92.023100,0.000000,43.620500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<92.023100,0.000000,43.620500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<91.243600,0.000000,43.620500>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<91.243600,0.000000,43.620500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<93.582200,0.000000,44.400100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<93.582200,0.000000,43.620500>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,-90.000000,0> translate<93.582200,0.000000,43.620500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<93.582200,0.000000,43.620500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<93.971900,0.000000,43.230800>}
box{<0,0,-0.050800><0.551119,0.036000,0.050800> rotate<0,44.997030,0> translate<93.582200,0.000000,43.620500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<93.971900,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<94.361700,0.000000,43.620500>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-44.989680,0> translate<93.971900,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<94.361700,0.000000,43.620500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<94.361700,0.000000,44.400100>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,90.000000,0> translate<94.361700,0.000000,44.400100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<94.751500,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<95.141200,0.000000,44.400100>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<94.751500,0.000000,44.010300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<95.141200,0.000000,44.400100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<95.141200,0.000000,43.230800>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,-90.000000,0> translate<95.141200,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<94.751500,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<95.531000,0.000000,43.230800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<94.751500,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<95.920800,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<95.920800,0.000000,43.425600>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,90.000000,0> translate<95.920800,0.000000,43.425600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<95.920800,0.000000,43.425600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<96.115600,0.000000,43.425600>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<95.920800,0.000000,43.425600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<96.115600,0.000000,43.425600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<96.115600,0.000000,43.230800>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,-90.000000,0> translate<96.115600,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<96.115600,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<95.920800,0.000000,43.230800>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<95.920800,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<97.284900,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<96.505400,0.000000,43.230800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<96.505400,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<96.505400,0.000000,43.230800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<97.284900,0.000000,44.010300>}
box{<0,0,-0.050800><1.102379,0.036000,0.050800> rotate<0,-44.997030,0> translate<96.505400,0.000000,43.230800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<97.284900,0.000000,44.010300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<97.284900,0.000000,44.205200>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,90.000000,0> translate<97.284900,0.000000,44.205200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<97.284900,0.000000,44.205200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<97.090000,0.000000,44.400100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<97.090000,0.000000,44.400100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<97.090000,0.000000,44.400100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<96.700200,0.000000,44.400100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<96.700200,0.000000,44.400100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<96.700200,0.000000,44.400100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<96.505400,0.000000,44.205200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<96.505400,0.000000,44.205200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.689500,0.000000,71.772400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.566700,0.000000,71.895300>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<10.566700,0.000000,71.895300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.566700,0.000000,71.895300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.320900,0.000000,71.895300>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<10.320900,0.000000,71.895300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.320900,0.000000,71.895300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.198100,0.000000,71.772400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<10.198100,0.000000,71.772400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.198100,0.000000,71.772400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.198100,0.000000,71.280900>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,-90.000000,0> translate<10.198100,0.000000,71.280900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.198100,0.000000,71.280900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.320900,0.000000,71.158100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<10.198100,0.000000,71.280900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.320900,0.000000,71.158100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.566700,0.000000,71.158100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<10.320900,0.000000,71.158100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.566700,0.000000,71.158100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.689500,0.000000,71.280900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<10.566700,0.000000,71.158100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.069300,0.000000,71.158100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.315100,0.000000,71.158100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<11.069300,0.000000,71.158100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.315100,0.000000,71.158100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.437900,0.000000,71.280900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<11.315100,0.000000,71.158100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.437900,0.000000,71.280900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.437900,0.000000,71.526700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<11.437900,0.000000,71.526700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.437900,0.000000,71.526700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.315100,0.000000,71.649500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<11.315100,0.000000,71.649500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.315100,0.000000,71.649500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.069300,0.000000,71.649500>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<11.069300,0.000000,71.649500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.069300,0.000000,71.649500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.946500,0.000000,71.526700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<10.946500,0.000000,71.526700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.946500,0.000000,71.526700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.946500,0.000000,71.280900>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<10.946500,0.000000,71.280900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.946500,0.000000,71.280900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.069300,0.000000,71.158100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<10.946500,0.000000,71.280900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.694900,0.000000,71.158100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.694900,0.000000,71.649500>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,90.000000,0> translate<11.694900,0.000000,71.649500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.694900,0.000000,71.649500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.063500,0.000000,71.649500>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<11.694900,0.000000,71.649500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.063500,0.000000,71.649500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.186300,0.000000,71.526700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<12.063500,0.000000,71.649500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.186300,0.000000,71.526700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.186300,0.000000,71.158100>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,-90.000000,0> translate<12.186300,0.000000,71.158100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.566100,0.000000,71.772400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.566100,0.000000,71.280900>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,-90.000000,0> translate<12.566100,0.000000,71.280900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.566100,0.000000,71.280900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.689000,0.000000,71.158100>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,44.973712,0> translate<12.566100,0.000000,71.280900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.443300,0.000000,71.649500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.689000,0.000000,71.649500>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,0.000000,0> translate<12.443300,0.000000,71.649500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.942200,0.000000,71.158100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.942200,0.000000,71.649500>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,90.000000,0> translate<12.942200,0.000000,71.649500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.942200,0.000000,71.403800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.187900,0.000000,71.649500>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,-44.997030,0> translate<12.942200,0.000000,71.403800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.187900,0.000000,71.649500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.310800,0.000000,71.649500>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,0.000000,0> translate<13.187900,0.000000,71.649500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.688600,0.000000,71.649500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.934400,0.000000,71.649500>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<13.688600,0.000000,71.649500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.934400,0.000000,71.649500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.057200,0.000000,71.526700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<13.934400,0.000000,71.649500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.057200,0.000000,71.526700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.057200,0.000000,71.158100>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,-90.000000,0> translate<14.057200,0.000000,71.158100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.057200,0.000000,71.158100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.688600,0.000000,71.158100>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<13.688600,0.000000,71.158100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.688600,0.000000,71.158100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.565800,0.000000,71.280900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<13.565800,0.000000,71.280900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.565800,0.000000,71.280900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.688600,0.000000,71.403800>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<13.565800,0.000000,71.280900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.688600,0.000000,71.403800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.057200,0.000000,71.403800>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<13.688600,0.000000,71.403800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.314200,0.000000,71.158100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.682800,0.000000,71.158100>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<14.314200,0.000000,71.158100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.682800,0.000000,71.158100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.805600,0.000000,71.280900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<14.682800,0.000000,71.158100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.805600,0.000000,71.280900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.682800,0.000000,71.403800>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<14.682800,0.000000,71.403800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.682800,0.000000,71.403800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.437000,0.000000,71.403800>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<14.437000,0.000000,71.403800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.437000,0.000000,71.403800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.314200,0.000000,71.526700>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<14.314200,0.000000,71.526700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.314200,0.000000,71.526700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.437000,0.000000,71.649500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<14.314200,0.000000,71.526700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.437000,0.000000,71.649500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.805600,0.000000,71.649500>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<14.437000,0.000000,71.649500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.185400,0.000000,71.772400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.185400,0.000000,71.280900>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,-90.000000,0> translate<15.185400,0.000000,71.280900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.185400,0.000000,71.280900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.308300,0.000000,71.158100>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,44.973712,0> translate<15.185400,0.000000,71.280900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.062600,0.000000,71.649500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.308300,0.000000,71.649500>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,0.000000,0> translate<15.062600,0.000000,71.649500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<2.628900,0.000000,80.167700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<2.628900,0.000000,79.163600>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<2.628900,0.000000,79.163600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<2.628900,0.000000,79.163600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<2.963600,0.000000,78.828900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<2.628900,0.000000,79.163600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<2.963600,0.000000,78.828900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<3.298300,0.000000,79.163600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<2.963600,0.000000,78.828900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<3.298300,0.000000,79.163600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<3.633000,0.000000,78.828900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<3.298300,0.000000,79.163600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<3.633000,0.000000,78.828900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<3.967700,0.000000,79.163600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<3.633000,0.000000,78.828900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<3.967700,0.000000,79.163600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<3.967700,0.000000,80.167700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,90.000000,0> translate<3.967700,0.000000,80.167700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<4.640200,0.000000,80.167700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<4.640200,0.000000,79.163600>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<4.640200,0.000000,79.163600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<4.640200,0.000000,79.163600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<4.974900,0.000000,78.828900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<4.640200,0.000000,79.163600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<4.974900,0.000000,78.828900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<5.309600,0.000000,79.163600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<4.974900,0.000000,78.828900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<5.309600,0.000000,79.163600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<5.644300,0.000000,78.828900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<5.309600,0.000000,79.163600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<5.644300,0.000000,78.828900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<5.979000,0.000000,79.163600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<5.644300,0.000000,78.828900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<5.979000,0.000000,79.163600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<5.979000,0.000000,80.167700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,90.000000,0> translate<5.979000,0.000000,80.167700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<6.651500,0.000000,80.167700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<6.651500,0.000000,79.163600>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<6.651500,0.000000,79.163600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<6.651500,0.000000,79.163600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<6.986200,0.000000,78.828900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<6.651500,0.000000,79.163600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<6.986200,0.000000,78.828900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<7.320900,0.000000,79.163600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<6.986200,0.000000,78.828900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<7.320900,0.000000,79.163600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<7.655600,0.000000,78.828900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<7.320900,0.000000,79.163600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<7.655600,0.000000,78.828900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<7.990300,0.000000,79.163600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<7.655600,0.000000,78.828900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<7.990300,0.000000,79.163600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<7.990300,0.000000,80.167700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,90.000000,0> translate<7.990300,0.000000,80.167700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<8.662800,0.000000,78.828900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<8.662800,0.000000,79.163600>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<8.662800,0.000000,79.163600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<8.662800,0.000000,79.163600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<8.997500,0.000000,79.163600>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<8.662800,0.000000,79.163600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<8.997500,0.000000,79.163600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<8.997500,0.000000,78.828900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<8.997500,0.000000,78.828900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<8.997500,0.000000,78.828900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<8.662800,0.000000,78.828900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<8.662800,0.000000,78.828900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<9.668400,0.000000,78.828900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<9.668400,0.000000,80.167700>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<9.668400,0.000000,80.167700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<9.668400,0.000000,79.498300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<10.337800,0.000000,80.167700>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<9.668400,0.000000,79.498300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<10.337800,0.000000,80.167700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<10.672500,0.000000,80.167700>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<10.337800,0.000000,80.167700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<11.344500,0.000000,78.828900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<11.344500,0.000000,80.167700>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<11.344500,0.000000,80.167700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<11.344500,0.000000,79.498300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<12.013900,0.000000,80.167700>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<11.344500,0.000000,79.498300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<12.013900,0.000000,80.167700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<12.348600,0.000000,80.167700>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<12.013900,0.000000,80.167700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<13.020600,0.000000,78.828900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<13.020600,0.000000,80.167700>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<13.020600,0.000000,80.167700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<13.020600,0.000000,79.498300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<13.690000,0.000000,80.167700>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<13.020600,0.000000,79.498300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<13.690000,0.000000,80.167700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<14.024700,0.000000,80.167700>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<13.690000,0.000000,80.167700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<15.031400,0.000000,78.828900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<15.031400,0.000000,80.502400>}
box{<0,0,-0.088900><1.673500,0.036000,0.088900> rotate<0,90.000000,0> translate<15.031400,0.000000,80.502400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<15.031400,0.000000,80.502400>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<15.366100,0.000000,80.837200>}
box{<0,0,-0.088900><0.473408,0.036000,0.088900> rotate<0,-45.005588,0> translate<15.031400,0.000000,80.502400> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<14.696700,0.000000,79.833000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<15.366100,0.000000,79.833000>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<14.696700,0.000000,79.833000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<16.037600,0.000000,78.828900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<16.037600,0.000000,79.163600>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<16.037600,0.000000,79.163600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<16.037600,0.000000,79.163600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<16.372300,0.000000,79.163600>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<16.037600,0.000000,79.163600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<16.372300,0.000000,79.163600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<16.372300,0.000000,78.828900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<16.372300,0.000000,78.828900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<16.372300,0.000000,78.828900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<16.037600,0.000000,78.828900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<16.037600,0.000000,78.828900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<18.382000,0.000000,80.167700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<17.377900,0.000000,80.167700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<17.377900,0.000000,80.167700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<17.377900,0.000000,80.167700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<17.043200,0.000000,79.833000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<17.043200,0.000000,79.833000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<17.043200,0.000000,79.833000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<17.043200,0.000000,79.163600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<17.043200,0.000000,79.163600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<17.043200,0.000000,79.163600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<17.377900,0.000000,78.828900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<17.043200,0.000000,79.163600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<17.377900,0.000000,78.828900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<18.382000,0.000000,78.828900>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<17.377900,0.000000,78.828900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<19.389200,0.000000,78.828900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<20.058600,0.000000,78.828900>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<19.389200,0.000000,78.828900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<20.058600,0.000000,78.828900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<20.393300,0.000000,79.163600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<20.058600,0.000000,78.828900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<20.393300,0.000000,79.163600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<20.393300,0.000000,79.833000>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<20.393300,0.000000,79.833000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<20.393300,0.000000,79.833000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<20.058600,0.000000,80.167700>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<20.058600,0.000000,80.167700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<20.058600,0.000000,80.167700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<19.389200,0.000000,80.167700>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<19.389200,0.000000,80.167700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<19.389200,0.000000,80.167700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<19.054500,0.000000,79.833000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<19.054500,0.000000,79.833000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<19.054500,0.000000,79.833000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<19.054500,0.000000,79.163600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<19.054500,0.000000,79.163600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<19.054500,0.000000,79.163600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<19.389200,0.000000,78.828900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<19.054500,0.000000,79.163600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<21.065800,0.000000,78.828900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<21.065800,0.000000,80.167700>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<21.065800,0.000000,80.167700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<21.065800,0.000000,80.167700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<21.400500,0.000000,80.167700>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<21.065800,0.000000,80.167700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<21.400500,0.000000,80.167700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<21.735200,0.000000,79.833000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<21.400500,0.000000,80.167700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<21.735200,0.000000,79.833000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<21.735200,0.000000,78.828900>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<21.735200,0.000000,78.828900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<21.735200,0.000000,79.833000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<22.069900,0.000000,80.167700>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<21.735200,0.000000,79.833000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<22.069900,0.000000,80.167700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<22.404600,0.000000,79.833000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<22.069900,0.000000,80.167700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<22.404600,0.000000,79.833000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<22.404600,0.000000,78.828900>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<22.404600,0.000000,78.828900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<71.208900,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<71.208900,0.000000,41.063600>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<71.208900,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<71.208900,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<71.543600,0.000000,40.728900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<71.208900,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<71.543600,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<71.878300,0.000000,41.063600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<71.543600,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<71.878300,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<72.213000,0.000000,40.728900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<71.878300,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<72.213000,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<72.547700,0.000000,41.063600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<72.213000,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<72.547700,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<72.547700,0.000000,42.067700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,90.000000,0> translate<72.547700,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<73.220200,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<73.220200,0.000000,41.063600>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<73.220200,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<73.220200,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<73.554900,0.000000,40.728900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<73.220200,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<73.554900,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<73.889600,0.000000,41.063600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<73.554900,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<73.889600,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<74.224300,0.000000,40.728900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<73.889600,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<74.224300,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<74.559000,0.000000,41.063600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<74.224300,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<74.559000,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<74.559000,0.000000,42.067700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,90.000000,0> translate<74.559000,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<75.231500,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<75.231500,0.000000,41.063600>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<75.231500,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<75.231500,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<75.566200,0.000000,40.728900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<75.231500,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<75.566200,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<75.900900,0.000000,41.063600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<75.566200,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<75.900900,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<76.235600,0.000000,40.728900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<75.900900,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<76.235600,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<76.570300,0.000000,41.063600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<76.235600,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<76.570300,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<76.570300,0.000000,42.067700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,90.000000,0> translate<76.570300,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<77.242800,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<77.242800,0.000000,41.063600>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<77.242800,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<77.242800,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<77.577500,0.000000,41.063600>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<77.242800,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<77.577500,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<77.577500,0.000000,40.728900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<77.577500,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<77.577500,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<77.242800,0.000000,40.728900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<77.242800,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<78.248400,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<78.248400,0.000000,42.067700>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<78.248400,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<78.248400,0.000000,41.398300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<78.917800,0.000000,42.067700>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<78.248400,0.000000,41.398300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<78.917800,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<79.252500,0.000000,42.067700>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<78.917800,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<80.928600,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<80.259200,0.000000,40.728900>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<80.259200,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<80.259200,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<79.924500,0.000000,41.063600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<79.924500,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<79.924500,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<79.924500,0.000000,41.733000>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<79.924500,0.000000,41.733000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<79.924500,0.000000,41.733000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<80.259200,0.000000,42.067700>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<79.924500,0.000000,41.733000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<80.259200,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<80.928600,0.000000,42.067700>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<80.259200,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<80.928600,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<81.263300,0.000000,41.733000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<80.928600,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<81.263300,0.000000,41.733000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<81.263300,0.000000,41.398300>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<81.263300,0.000000,41.398300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<81.263300,0.000000,41.398300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<79.924500,0.000000,41.398300>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<79.924500,0.000000,41.398300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<81.935800,0.000000,40.059500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<81.935800,0.000000,42.067700>}
box{<0,0,-0.088900><2.008200,0.036000,0.088900> rotate<0,90.000000,0> translate<81.935800,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<81.935800,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<82.939900,0.000000,42.067700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<81.935800,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<82.939900,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<83.274600,0.000000,41.733000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<82.939900,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<83.274600,0.000000,41.733000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<83.274600,0.000000,41.063600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<83.274600,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<83.274600,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<82.939900,0.000000,40.728900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<82.939900,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<82.939900,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<81.935800,0.000000,40.728900>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<81.935800,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<83.947100,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<83.947100,0.000000,42.067700>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<83.947100,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<83.947100,0.000000,41.398300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<84.616500,0.000000,42.067700>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<83.947100,0.000000,41.398300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<84.616500,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<84.951200,0.000000,42.067700>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<84.616500,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<85.623200,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<85.623200,0.000000,42.067700>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<85.623200,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<85.623200,0.000000,41.398300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<86.292600,0.000000,42.067700>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<85.623200,0.000000,41.398300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<86.292600,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<86.627300,0.000000,42.067700>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<86.292600,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<87.634000,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<88.303400,0.000000,42.067700>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<87.634000,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<88.303400,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<88.638100,0.000000,41.733000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<88.303400,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<88.638100,0.000000,41.733000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<88.638100,0.000000,40.728900>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<88.638100,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<88.638100,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<87.634000,0.000000,40.728900>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<87.634000,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<87.634000,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<87.299300,0.000000,41.063600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<87.299300,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<87.299300,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<87.634000,0.000000,41.398300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<87.299300,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<87.634000,0.000000,41.398300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<88.638100,0.000000,41.398300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<87.634000,0.000000,41.398300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<89.310600,0.000000,40.059500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<89.310600,0.000000,42.067700>}
box{<0,0,-0.088900><2.008200,0.036000,0.088900> rotate<0,90.000000,0> translate<89.310600,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<89.310600,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<90.314700,0.000000,42.067700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<89.310600,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<90.314700,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<90.649400,0.000000,41.733000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<90.314700,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<90.649400,0.000000,41.733000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<90.649400,0.000000,41.063600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<90.649400,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<90.649400,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<90.314700,0.000000,40.728900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<90.314700,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<90.314700,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<89.310600,0.000000,40.728900>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<89.310600,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<91.321900,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<91.321900,0.000000,41.063600>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<91.321900,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<91.321900,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<91.656600,0.000000,41.063600>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<91.321900,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<91.656600,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<91.656600,0.000000,40.728900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<91.656600,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<91.656600,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<91.321900,0.000000,40.728900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<91.321900,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<92.662200,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<93.331600,0.000000,40.728900>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<92.662200,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<93.331600,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<93.666300,0.000000,41.063600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<93.331600,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<93.666300,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<93.666300,0.000000,41.733000>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<93.666300,0.000000,41.733000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<93.666300,0.000000,41.733000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<93.331600,0.000000,42.067700>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<93.331600,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<93.331600,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<92.662200,0.000000,42.067700>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<92.662200,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<92.662200,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<92.327500,0.000000,41.733000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<92.327500,0.000000,41.733000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<92.327500,0.000000,41.733000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<92.327500,0.000000,41.063600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<92.327500,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<92.327500,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<92.662200,0.000000,40.728900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<92.327500,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<94.338800,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<94.338800,0.000000,42.067700>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<94.338800,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<94.338800,0.000000,41.398300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<95.008200,0.000000,42.067700>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<94.338800,0.000000,41.398300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<95.008200,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<95.342900,0.000000,42.067700>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<95.008200,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<96.684300,0.000000,40.059500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<97.019000,0.000000,40.059500>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<96.684300,0.000000,40.059500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<97.019000,0.000000,40.059500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<97.353700,0.000000,40.394200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<97.019000,0.000000,40.059500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<97.353700,0.000000,40.394200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<97.353700,0.000000,42.067700>}
box{<0,0,-0.088900><1.673500,0.036000,0.088900> rotate<0,90.000000,0> translate<97.353700,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<97.353700,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<96.349600,0.000000,42.067700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<96.349600,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<96.349600,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<96.014900,0.000000,41.733000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<96.014900,0.000000,41.733000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<96.014900,0.000000,41.733000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<96.014900,0.000000,41.063600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<96.014900,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<96.014900,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<96.349600,0.000000,40.728900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<96.014900,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<96.349600,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<97.353700,0.000000,40.728900>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<96.349600,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<71.208900,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<71.208900,0.000000,41.063600>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<71.208900,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<71.208900,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<71.543600,0.000000,40.728900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<71.208900,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<71.543600,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<71.878300,0.000000,41.063600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<71.543600,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<71.878300,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<72.213000,0.000000,40.728900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<71.878300,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<72.213000,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<72.547700,0.000000,41.063600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<72.213000,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<72.547700,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<72.547700,0.000000,42.067700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,90.000000,0> translate<72.547700,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<73.220200,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<73.220200,0.000000,41.063600>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<73.220200,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<73.220200,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<73.554900,0.000000,40.728900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<73.220200,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<73.554900,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<73.889600,0.000000,41.063600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<73.554900,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<73.889600,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<74.224300,0.000000,40.728900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<73.889600,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<74.224300,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<74.559000,0.000000,41.063600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<74.224300,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<74.559000,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<74.559000,0.000000,42.067700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,90.000000,0> translate<74.559000,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<75.231500,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<75.231500,0.000000,41.063600>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<75.231500,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<75.231500,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<75.566200,0.000000,40.728900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<75.231500,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<75.566200,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<75.900900,0.000000,41.063600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<75.566200,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<75.900900,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<76.235600,0.000000,40.728900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<75.900900,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<76.235600,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<76.570300,0.000000,41.063600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<76.235600,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<76.570300,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<76.570300,0.000000,42.067700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,90.000000,0> translate<76.570300,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<77.242800,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<77.242800,0.000000,41.063600>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<77.242800,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<77.242800,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<77.577500,0.000000,41.063600>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<77.242800,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<77.577500,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<77.577500,0.000000,40.728900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<77.577500,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<77.577500,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<77.242800,0.000000,40.728900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<77.242800,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<78.248400,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<78.248400,0.000000,42.067700>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<78.248400,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<78.248400,0.000000,41.398300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<78.917800,0.000000,42.067700>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<78.248400,0.000000,41.398300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<78.917800,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<79.252500,0.000000,42.067700>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<78.917800,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<80.928600,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<80.259200,0.000000,40.728900>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<80.259200,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<80.259200,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<79.924500,0.000000,41.063600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<79.924500,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<79.924500,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<79.924500,0.000000,41.733000>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<79.924500,0.000000,41.733000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<79.924500,0.000000,41.733000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<80.259200,0.000000,42.067700>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<79.924500,0.000000,41.733000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<80.259200,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<80.928600,0.000000,42.067700>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<80.259200,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<80.928600,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<81.263300,0.000000,41.733000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<80.928600,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<81.263300,0.000000,41.733000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<81.263300,0.000000,41.398300>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<81.263300,0.000000,41.398300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<81.263300,0.000000,41.398300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<79.924500,0.000000,41.398300>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<79.924500,0.000000,41.398300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<81.935800,0.000000,40.059500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<81.935800,0.000000,42.067700>}
box{<0,0,-0.088900><2.008200,0.036000,0.088900> rotate<0,90.000000,0> translate<81.935800,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<81.935800,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<82.939900,0.000000,42.067700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<81.935800,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<82.939900,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<83.274600,0.000000,41.733000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<82.939900,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<83.274600,0.000000,41.733000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<83.274600,0.000000,41.063600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<83.274600,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<83.274600,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<82.939900,0.000000,40.728900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<82.939900,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<82.939900,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<81.935800,0.000000,40.728900>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<81.935800,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<83.947100,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<83.947100,0.000000,42.067700>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<83.947100,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<83.947100,0.000000,41.398300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<84.616500,0.000000,42.067700>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<83.947100,0.000000,41.398300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<84.616500,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<84.951200,0.000000,42.067700>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<84.616500,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<85.623200,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<85.623200,0.000000,42.067700>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<85.623200,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<85.623200,0.000000,41.398300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<86.292600,0.000000,42.067700>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<85.623200,0.000000,41.398300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<86.292600,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<86.627300,0.000000,42.067700>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<86.292600,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<87.634000,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<88.303400,0.000000,42.067700>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<87.634000,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<88.303400,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<88.638100,0.000000,41.733000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<88.303400,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<88.638100,0.000000,41.733000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<88.638100,0.000000,40.728900>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,-90.000000,0> translate<88.638100,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<88.638100,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<87.634000,0.000000,40.728900>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<87.634000,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<87.634000,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<87.299300,0.000000,41.063600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<87.299300,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<87.299300,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<87.634000,0.000000,41.398300>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<87.299300,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<87.634000,0.000000,41.398300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<88.638100,0.000000,41.398300>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<87.634000,0.000000,41.398300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<89.310600,0.000000,40.059500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<89.310600,0.000000,42.067700>}
box{<0,0,-0.088900><2.008200,0.036000,0.088900> rotate<0,90.000000,0> translate<89.310600,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<89.310600,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<90.314700,0.000000,42.067700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<89.310600,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<90.314700,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<90.649400,0.000000,41.733000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<90.314700,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<90.649400,0.000000,41.733000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<90.649400,0.000000,41.063600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<90.649400,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<90.649400,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<90.314700,0.000000,40.728900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<90.314700,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<90.314700,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<89.310600,0.000000,40.728900>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<89.310600,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<91.321900,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<91.321900,0.000000,41.063600>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,90.000000,0> translate<91.321900,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<91.321900,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<91.656600,0.000000,41.063600>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<91.321900,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<91.656600,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<91.656600,0.000000,40.728900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,-90.000000,0> translate<91.656600,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<91.656600,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<91.321900,0.000000,40.728900>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<91.321900,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<92.662200,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<93.331600,0.000000,40.728900>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<92.662200,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<93.331600,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<93.666300,0.000000,41.063600>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<93.331600,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<93.666300,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<93.666300,0.000000,41.733000>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<93.666300,0.000000,41.733000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<93.666300,0.000000,41.733000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<93.331600,0.000000,42.067700>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<93.331600,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<93.331600,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<92.662200,0.000000,42.067700>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,0.000000,0> translate<92.662200,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<92.662200,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<92.327500,0.000000,41.733000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<92.327500,0.000000,41.733000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<92.327500,0.000000,41.733000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<92.327500,0.000000,41.063600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<92.327500,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<92.327500,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<92.662200,0.000000,40.728900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<92.327500,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<94.338800,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<94.338800,0.000000,42.067700>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<94.338800,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<94.338800,0.000000,41.398300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<95.008200,0.000000,42.067700>}
box{<0,0,-0.088900><0.946675,0.036000,0.088900> rotate<0,-44.997030,0> translate<94.338800,0.000000,41.398300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<95.008200,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<95.342900,0.000000,42.067700>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<95.008200,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<96.684300,0.000000,40.059500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<97.019000,0.000000,40.059500>}
box{<0,0,-0.088900><0.334700,0.036000,0.088900> rotate<0,0.000000,0> translate<96.684300,0.000000,40.059500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<97.019000,0.000000,40.059500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<97.353700,0.000000,40.394200>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<97.019000,0.000000,40.059500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<97.353700,0.000000,40.394200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<97.353700,0.000000,42.067700>}
box{<0,0,-0.088900><1.673500,0.036000,0.088900> rotate<0,90.000000,0> translate<97.353700,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<97.353700,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<96.349600,0.000000,42.067700>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<96.349600,0.000000,42.067700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<96.349600,0.000000,42.067700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<96.014900,0.000000,41.733000>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,-44.997030,0> translate<96.014900,0.000000,41.733000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<96.014900,0.000000,41.733000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<96.014900,0.000000,41.063600>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,-90.000000,0> translate<96.014900,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<96.014900,0.000000,41.063600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<96.349600,0.000000,40.728900>}
box{<0,0,-0.088900><0.473337,0.036000,0.088900> rotate<0,44.997030,0> translate<96.014900,0.000000,41.063600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<96.349600,0.000000,40.728900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<97.353700,0.000000,40.728900>}
box{<0,0,-0.088900><1.004100,0.036000,0.088900> rotate<0,0.000000,0> translate<96.349600,0.000000,40.728900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,77.178700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,76.238100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<2.578100,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,76.238100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<2.578100,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,76.394800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<3.048400,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,76.394800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,77.021900>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,90.000000,0> translate<3.205100,0.000000,77.021900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.205100,0.000000,77.021900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,77.178700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<3.048400,0.000000,77.178700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.048400,0.000000,77.178700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<2.578100,0.000000,77.178700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<2.578100,0.000000,77.178700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.983900,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.670300,0.000000,76.238100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<3.670300,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.670300,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,76.394800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<3.513600,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,76.394800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,76.708400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<3.513600,0.000000,76.708400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,76.708400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.670300,0.000000,76.865100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<3.513600,0.000000,76.708400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.670300,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.983900,0.000000,76.865100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<3.670300,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.983900,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.140600,0.000000,76.708400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<3.983900,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.140600,0.000000,76.708400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.140600,0.000000,76.551600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<4.140600,0.000000,76.551600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.140600,0.000000,76.551600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<3.513600,0.000000,76.551600>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<3.513600,0.000000,76.551600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.449100,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.919400,0.000000,76.238100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<4.449100,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.919400,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.076100,0.000000,76.394800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<4.919400,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.076100,0.000000,76.394800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.919400,0.000000,76.551600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<4.919400,0.000000,76.551600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.919400,0.000000,76.551600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.605800,0.000000,76.551600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<4.605800,0.000000,76.551600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.605800,0.000000,76.551600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.449100,0.000000,76.708400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<4.449100,0.000000,76.708400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.449100,0.000000,76.708400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.605800,0.000000,76.865100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<4.449100,0.000000,76.708400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<4.605800,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.076100,0.000000,76.865100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<4.605800,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.384600,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.541300,0.000000,76.865100>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<5.384600,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.541300,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.541300,0.000000,76.238100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<5.541300,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.384600,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.698100,0.000000,76.238100>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<5.384600,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.541300,0.000000,77.335400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.541300,0.000000,77.178700>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,-90.000000,0> translate<5.541300,0.000000,77.178700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.321700,0.000000,75.924600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.478500,0.000000,75.924600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<6.321700,0.000000,75.924600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.478500,0.000000,75.924600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.635200,0.000000,76.081400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<6.478500,0.000000,75.924600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.635200,0.000000,76.081400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.635200,0.000000,76.865100>}
box{<0,0,-0.038100><0.783700,0.036000,0.038100> rotate<0,90.000000,0> translate<6.635200,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.635200,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.164900,0.000000,76.865100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<6.164900,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.164900,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.008200,0.000000,76.708400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<6.008200,0.000000,76.708400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.008200,0.000000,76.708400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.008200,0.000000,76.394800>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<6.008200,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.008200,0.000000,76.394800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.164900,0.000000,76.238100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<6.008200,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.164900,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.635200,0.000000,76.238100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<6.164900,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.943700,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.943700,0.000000,76.865100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<6.943700,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.943700,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.414000,0.000000,76.865100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<6.943700,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.414000,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.570700,0.000000,76.708400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<7.414000,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.570700,0.000000,76.708400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.570700,0.000000,76.238100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<7.570700,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.814700,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.814700,0.000000,77.178700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<8.814700,0.000000,77.178700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.814700,0.000000,77.178700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.285000,0.000000,77.178700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<8.814700,0.000000,77.178700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.285000,0.000000,77.178700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.441700,0.000000,77.021900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<9.285000,0.000000,77.178700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.441700,0.000000,77.021900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.441700,0.000000,76.865100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<9.441700,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.441700,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.285000,0.000000,76.708400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<9.285000,0.000000,76.708400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.285000,0.000000,76.708400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.441700,0.000000,76.551600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<9.285000,0.000000,76.708400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.441700,0.000000,76.551600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.441700,0.000000,76.394800>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<9.441700,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.441700,0.000000,76.394800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.285000,0.000000,76.238100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<9.285000,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.285000,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.814700,0.000000,76.238100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<8.814700,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.814700,0.000000,76.708400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.285000,0.000000,76.708400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<8.814700,0.000000,76.708400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.750200,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.750200,0.000000,76.394800>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<9.750200,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.750200,0.000000,76.394800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.906900,0.000000,76.238100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<9.750200,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.906900,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.377200,0.000000,76.238100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<9.906900,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.377200,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.377200,0.000000,76.081400>}
box{<0,0,-0.038100><0.783700,0.036000,0.038100> rotate<0,-90.000000,0> translate<10.377200,0.000000,76.081400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.377200,0.000000,76.081400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.220500,0.000000,75.924600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<10.220500,0.000000,75.924600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.220500,0.000000,75.924600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.063700,0.000000,75.924600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<10.063700,0.000000,75.924600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.685700,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.842400,0.000000,76.865100>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<10.685700,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.842400,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.842400,0.000000,76.708400>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,-90.000000,0> translate<10.842400,0.000000,76.708400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.842400,0.000000,76.708400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.685700,0.000000,76.708400>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<10.685700,0.000000,76.708400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.685700,0.000000,76.708400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.685700,0.000000,76.865100>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,90.000000,0> translate<10.685700,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.685700,0.000000,76.394800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.842400,0.000000,76.394800>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<10.685700,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.842400,0.000000,76.394800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.842400,0.000000,76.238100>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,-90.000000,0> translate<10.842400,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.842400,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.685700,0.000000,76.238100>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<10.685700,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.685700,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.685700,0.000000,76.394800>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,90.000000,0> translate<10.685700,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.088900,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.088900,0.000000,77.178700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<12.088900,0.000000,77.178700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.088900,0.000000,77.178700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.559200,0.000000,77.178700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<12.088900,0.000000,77.178700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.559200,0.000000,77.178700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.715900,0.000000,77.021900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<12.559200,0.000000,77.178700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.715900,0.000000,77.021900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.715900,0.000000,76.865100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<12.715900,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.715900,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.559200,0.000000,76.708400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<12.559200,0.000000,76.708400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.559200,0.000000,76.708400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.715900,0.000000,76.551600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<12.559200,0.000000,76.708400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.715900,0.000000,76.551600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.715900,0.000000,76.394800>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<12.715900,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.715900,0.000000,76.394800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.559200,0.000000,76.238100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<12.559200,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.559200,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.088900,0.000000,76.238100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<12.088900,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.088900,0.000000,76.708400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.559200,0.000000,76.708400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<12.088900,0.000000,76.708400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.024400,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.024400,0.000000,76.865100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<13.024400,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.024400,0.000000,76.551600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.337900,0.000000,76.865100>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<13.024400,0.000000,76.551600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.337900,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.494700,0.000000,76.865100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<13.337900,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.803900,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.803900,0.000000,76.394800>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<13.803900,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.803900,0.000000,76.394800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.960600,0.000000,76.238100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<13.803900,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.960600,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.430900,0.000000,76.238100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<13.960600,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.430900,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.430900,0.000000,76.865100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<14.430900,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.366400,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.896100,0.000000,76.865100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<14.896100,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.896100,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.739400,0.000000,76.708400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<14.739400,0.000000,76.708400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.739400,0.000000,76.708400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.739400,0.000000,76.394800>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<14.739400,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.739400,0.000000,76.394800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.896100,0.000000,76.238100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<14.739400,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.896100,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.366400,0.000000,76.238100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<14.896100,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.145200,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.831600,0.000000,76.238100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<15.831600,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.831600,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.674900,0.000000,76.394800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<15.674900,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.674900,0.000000,76.394800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.674900,0.000000,76.708400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<15.674900,0.000000,76.708400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.674900,0.000000,76.708400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.831600,0.000000,76.865100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<15.674900,0.000000,76.708400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.831600,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.145200,0.000000,76.865100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<15.831600,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.145200,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.301900,0.000000,76.708400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<16.145200,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.301900,0.000000,76.708400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.301900,0.000000,76.551600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<16.301900,0.000000,76.551600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.301900,0.000000,76.551600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.674900,0.000000,76.551600>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<15.674900,0.000000,76.551600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.545900,0.000000,77.178700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.545900,0.000000,76.238100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<17.545900,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.545900,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.859400,0.000000,76.551600>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<17.545900,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.859400,0.000000,76.551600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.172900,0.000000,76.238100>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,44.997030,0> translate<17.859400,0.000000,76.551600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.172900,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.172900,0.000000,77.178700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<18.172900,0.000000,77.178700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.638100,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.951700,0.000000,76.865100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<18.638100,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.951700,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.108400,0.000000,76.708400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<18.951700,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.108400,0.000000,76.708400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.108400,0.000000,76.238100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<19.108400,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.108400,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.638100,0.000000,76.238100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<18.638100,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.638100,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.481400,0.000000,76.394800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<18.481400,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.481400,0.000000,76.394800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.638100,0.000000,76.551600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<18.481400,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.638100,0.000000,76.551600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.108400,0.000000,76.551600>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<18.638100,0.000000,76.551600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.573600,0.000000,77.021900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.573600,0.000000,76.394800>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,-90.000000,0> translate<19.573600,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.573600,0.000000,76.394800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.730400,0.000000,76.238100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<19.573600,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.416900,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.730400,0.000000,76.865100>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<19.416900,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.197200,0.000000,77.021900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.197200,0.000000,76.394800>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,-90.000000,0> translate<20.197200,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.197200,0.000000,76.394800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.354000,0.000000,76.238100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<20.197200,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.040500,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.354000,0.000000,76.865100>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<20.040500,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<21.134400,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.820800,0.000000,76.238100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<20.820800,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.820800,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.664100,0.000000,76.394800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<20.664100,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.664100,0.000000,76.394800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.664100,0.000000,76.708400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<20.664100,0.000000,76.708400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.664100,0.000000,76.708400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.820800,0.000000,76.865100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<20.664100,0.000000,76.708400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.820800,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<21.134400,0.000000,76.865100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<20.820800,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<21.134400,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<21.291100,0.000000,76.708400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<21.134400,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<21.291100,0.000000,76.708400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<21.291100,0.000000,76.551600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<21.291100,0.000000,76.551600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<21.291100,0.000000,76.551600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<20.664100,0.000000,76.551600>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<20.664100,0.000000,76.551600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<21.599600,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<21.599600,0.000000,76.865100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<21.599600,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<21.599600,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.069900,0.000000,76.865100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<21.599600,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.069900,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.226600,0.000000,76.708400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<22.069900,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.226600,0.000000,76.708400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.226600,0.000000,76.238100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<22.226600,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.162100,0.000000,77.178700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.162100,0.000000,76.238100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<23.162100,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.162100,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.691800,0.000000,76.238100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<22.691800,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.691800,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.535100,0.000000,76.394800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<22.535100,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.535100,0.000000,76.394800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.535100,0.000000,76.708400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<22.535100,0.000000,76.708400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.535100,0.000000,76.708400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.691800,0.000000,76.865100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<22.535100,0.000000,76.708400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.691800,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.162100,0.000000,76.865100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<22.691800,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.627300,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.940900,0.000000,76.238100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<23.627300,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.940900,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.097600,0.000000,76.394800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<23.940900,0.000000,76.238100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.097600,0.000000,76.394800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.097600,0.000000,76.708400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<24.097600,0.000000,76.708400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.097600,0.000000,76.708400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.940900,0.000000,76.865100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<23.940900,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.940900,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.627300,0.000000,76.865100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<23.627300,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.627300,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.470600,0.000000,76.708400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<23.470600,0.000000,76.708400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.470600,0.000000,76.708400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.470600,0.000000,76.394800>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<23.470600,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.470600,0.000000,76.394800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.627300,0.000000,76.238100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<23.470600,0.000000,76.394800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.406100,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.406100,0.000000,76.865100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<24.406100,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.406100,0.000000,76.551600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.719600,0.000000,76.865100>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<24.406100,0.000000,76.551600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.719600,0.000000,76.865100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.876400,0.000000,76.865100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<24.719600,0.000000,76.865100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.342300,0.000000,76.238100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.342300,0.000000,77.021900>}
box{<0,0,-0.038100><0.783800,0.036000,0.038100> rotate<0,90.000000,0> translate<25.342300,0.000000,77.021900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.342300,0.000000,77.021900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.499100,0.000000,77.178700>}
box{<0,0,-0.038100><0.221749,0.036000,0.038100> rotate<0,-44.997030,0> translate<25.342300,0.000000,77.021900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.185600,0.000000,76.708400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.499100,0.000000,76.708400>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<25.185600,0.000000,76.708400> }
//BUTTON_INTERFACE silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<41.910000,0.000000,74.295000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<42.545000,0.000000,74.930000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<41.910000,0.000000,74.295000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<42.545000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<43.815000,0.000000,74.930000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<42.545000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<43.815000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<44.450000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<43.815000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<44.450000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<43.815000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<43.815000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<43.815000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<42.545000,0.000000,72.390000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<42.545000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<42.545000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<41.910000,0.000000,73.025000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<41.910000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<37.465000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<38.735000,0.000000,74.930000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<37.465000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<38.735000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<39.370000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<38.735000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<39.370000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<38.735000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<38.735000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<39.370000,0.000000,74.295000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<40.005000,0.000000,74.930000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<39.370000,0.000000,74.295000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<40.005000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<41.275000,0.000000,74.930000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<40.005000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<41.275000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<41.910000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<41.275000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<41.910000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<41.275000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<41.275000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<41.275000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<40.005000,0.000000,72.390000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<40.005000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<40.005000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<39.370000,0.000000,73.025000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<39.370000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.290000,0.000000,74.295000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.925000,0.000000,74.930000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<34.290000,0.000000,74.295000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.925000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<36.195000,0.000000,74.930000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<34.925000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<36.195000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<36.830000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<36.195000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<36.830000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<36.195000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<36.195000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<36.195000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.925000,0.000000,72.390000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<34.925000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.925000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.290000,0.000000,73.025000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<34.290000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<37.465000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<36.830000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<36.830000,0.000000,74.295000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<36.830000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<37.465000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<36.830000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<38.735000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<37.465000,0.000000,72.390000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<37.465000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.845000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.115000,0.000000,74.930000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<29.845000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.115000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.750000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<31.115000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.750000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.115000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<31.115000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.750000,0.000000,74.295000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<32.385000,0.000000,74.930000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<31.750000,0.000000,74.295000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<32.385000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<33.655000,0.000000,74.930000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<32.385000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<33.655000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.290000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<33.655000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.290000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<33.655000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<33.655000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<33.655000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<32.385000,0.000000,72.390000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<32.385000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<32.385000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.750000,0.000000,73.025000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<31.750000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.210000,0.000000,74.295000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.210000,0.000000,73.025000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,-90.000000,0> translate<29.210000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.845000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.210000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<29.210000,0.000000,74.295000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.210000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.845000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<29.210000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.115000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.845000,0.000000,72.390000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<29.845000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<44.450000,0.000000,74.295000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<44.450000,0.000000,73.025000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,-90.000000,0> translate<44.450000,0.000000,73.025000> }
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<43.180000,0.000000,73.660000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<40.640000,0.000000,73.660000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<38.100000,0.000000,73.660000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<35.560000,0.000000,73.660000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<33.020000,0.000000,73.660000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<30.480000,0.000000,73.660000>}
//BUTTON_INTERFACE1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<66.040000,0.000000,48.895000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<66.675000,0.000000,49.530000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<66.040000,0.000000,48.895000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<66.675000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<67.945000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<66.675000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<67.945000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<68.580000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<67.945000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<68.580000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<67.945000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<67.945000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<67.945000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<66.675000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<66.675000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<66.675000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<66.040000,0.000000,47.625000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<66.040000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<61.595000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<62.865000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<61.595000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<62.865000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<63.500000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<62.865000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<63.500000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<62.865000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<62.865000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<63.500000,0.000000,48.895000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<64.135000,0.000000,49.530000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<63.500000,0.000000,48.895000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<64.135000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<65.405000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<64.135000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<65.405000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<66.040000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<65.405000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<66.040000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<65.405000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<65.405000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<65.405000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<64.135000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<64.135000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<64.135000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<63.500000,0.000000,47.625000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<63.500000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<58.420000,0.000000,48.895000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<59.055000,0.000000,49.530000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<58.420000,0.000000,48.895000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<59.055000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<60.325000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<59.055000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<60.325000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<60.960000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<60.325000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<60.960000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<60.325000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<60.325000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<60.325000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<59.055000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<59.055000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<59.055000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<58.420000,0.000000,47.625000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<58.420000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<61.595000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<60.960000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<60.960000,0.000000,48.895000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<60.960000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<61.595000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<60.960000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<62.865000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<61.595000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<61.595000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.975000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.245000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<53.975000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.245000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.880000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<55.245000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.880000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.245000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<55.245000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.880000,0.000000,48.895000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<56.515000,0.000000,49.530000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<55.880000,0.000000,48.895000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<56.515000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<57.785000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<56.515000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<57.785000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<58.420000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<57.785000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<58.420000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<57.785000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<57.785000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<57.785000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<56.515000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<56.515000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<56.515000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.880000,0.000000,47.625000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<55.880000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.340000,0.000000,48.895000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.340000,0.000000,47.625000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,-90.000000,0> translate<53.340000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.975000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.340000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<53.340000,0.000000,48.895000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.340000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.975000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<53.340000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.245000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.975000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<53.975000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<68.580000,0.000000,48.895000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<68.580000,0.000000,47.625000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,-90.000000,0> translate<68.580000,0.000000,47.625000> }
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<67.310000,0.000000,48.260000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<64.770000,0.000000,48.260000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<62.230000,0.000000,48.260000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<59.690000,0.000000,48.260000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<57.150000,0.000000,48.260000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<54.610000,0.000000,48.260000>}
//I2C_ADDRESS silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<25.400000,0.000000,57.150000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<25.400000,0.000000,64.770000>}
box{<0,0,-0.076200><7.620000,0.036000,0.076200> rotate<0,90.000000,0> translate<25.400000,0.000000,64.770000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.240000,0.000000,64.770000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.240000,0.000000,57.150000>}
box{<0,0,-0.076200><7.620000,0.036000,0.076200> rotate<0,-90.000000,0> translate<15.240000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<17.145000,0.000000,59.690000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<18.415000,0.000000,59.690000>}
box{<0,0,-0.127000><1.270000,0.036000,0.127000> rotate<0,0.000000,0> translate<17.145000,0.000000,59.690000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<18.415000,0.000000,59.690000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<18.415000,0.000000,60.020200>}
box{<0,0,-0.127000><0.330200,0.036000,0.127000> rotate<0,90.000000,0> translate<18.415000,0.000000,60.020200> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<18.415000,0.000000,62.230000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<17.145000,0.000000,62.230000>}
box{<0,0,-0.127000><1.270000,0.036000,0.127000> rotate<0,0.000000,0> translate<17.145000,0.000000,62.230000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<17.145000,0.000000,62.230000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<17.145000,0.000000,60.325000>}
box{<0,0,-0.127000><1.905000,0.036000,0.127000> rotate<0,-90.000000,0> translate<17.145000,0.000000,60.325000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<19.685000,0.000000,59.690000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<20.955000,0.000000,59.690000>}
box{<0,0,-0.127000><1.270000,0.036000,0.127000> rotate<0,0.000000,0> translate<19.685000,0.000000,59.690000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<20.955000,0.000000,59.690000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<20.955000,0.000000,60.020200>}
box{<0,0,-0.127000><0.330200,0.036000,0.127000> rotate<0,90.000000,0> translate<20.955000,0.000000,60.020200> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<20.955000,0.000000,62.230000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<19.685000,0.000000,62.230000>}
box{<0,0,-0.127000><1.270000,0.036000,0.127000> rotate<0,0.000000,0> translate<19.685000,0.000000,62.230000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<19.685000,0.000000,62.230000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<19.685000,0.000000,60.325000>}
box{<0,0,-0.127000><1.905000,0.036000,0.127000> rotate<0,-90.000000,0> translate<19.685000,0.000000,60.325000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<22.225000,0.000000,59.690000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<23.495000,0.000000,59.690000>}
box{<0,0,-0.127000><1.270000,0.036000,0.127000> rotate<0,0.000000,0> translate<22.225000,0.000000,59.690000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<23.495000,0.000000,59.690000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<23.495000,0.000000,60.020200>}
box{<0,0,-0.127000><0.330200,0.036000,0.127000> rotate<0,90.000000,0> translate<23.495000,0.000000,60.020200> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<23.495000,0.000000,62.230000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<22.225000,0.000000,62.230000>}
box{<0,0,-0.127000><1.270000,0.036000,0.127000> rotate<0,0.000000,0> translate<22.225000,0.000000,62.230000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<22.225000,0.000000,62.230000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<22.225000,0.000000,60.325000>}
box{<0,0,-0.127000><1.905000,0.036000,0.127000> rotate<0,-90.000000,0> translate<22.225000,0.000000,60.325000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<17.145000,0.000000,60.020200>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<18.415000,0.000000,60.020200>}
box{<0,0,-0.127000><1.270000,0.036000,0.127000> rotate<0,0.000000,0> translate<17.145000,0.000000,60.020200> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<17.145000,0.000000,60.020200>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<17.145000,0.000000,59.690000>}
box{<0,0,-0.127000><0.330200,0.036000,0.127000> rotate<0,-90.000000,0> translate<17.145000,0.000000,59.690000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<18.415000,0.000000,60.020200>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<18.415000,0.000000,60.325000>}
box{<0,0,-0.127000><0.304800,0.036000,0.127000> rotate<0,90.000000,0> translate<18.415000,0.000000,60.325000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<17.145000,0.000000,60.325000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<18.415000,0.000000,60.325000>}
box{<0,0,-0.127000><1.270000,0.036000,0.127000> rotate<0,0.000000,0> translate<17.145000,0.000000,60.325000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<17.145000,0.000000,60.325000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<17.145000,0.000000,60.020200>}
box{<0,0,-0.127000><0.304800,0.036000,0.127000> rotate<0,-90.000000,0> translate<17.145000,0.000000,60.020200> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<18.415000,0.000000,60.325000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<18.415000,0.000000,62.230000>}
box{<0,0,-0.127000><1.905000,0.036000,0.127000> rotate<0,90.000000,0> translate<18.415000,0.000000,62.230000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<19.685000,0.000000,60.020200>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<20.955000,0.000000,60.020200>}
box{<0,0,-0.127000><1.270000,0.036000,0.127000> rotate<0,0.000000,0> translate<19.685000,0.000000,60.020200> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<19.685000,0.000000,60.020200>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<19.685000,0.000000,59.690000>}
box{<0,0,-0.127000><0.330200,0.036000,0.127000> rotate<0,-90.000000,0> translate<19.685000,0.000000,59.690000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<20.955000,0.000000,60.020200>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<20.955000,0.000000,60.325000>}
box{<0,0,-0.127000><0.304800,0.036000,0.127000> rotate<0,90.000000,0> translate<20.955000,0.000000,60.325000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<19.685000,0.000000,60.325000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<20.955000,0.000000,60.325000>}
box{<0,0,-0.127000><1.270000,0.036000,0.127000> rotate<0,0.000000,0> translate<19.685000,0.000000,60.325000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<19.685000,0.000000,60.325000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<19.685000,0.000000,60.020200>}
box{<0,0,-0.127000><0.304800,0.036000,0.127000> rotate<0,-90.000000,0> translate<19.685000,0.000000,60.020200> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<20.955000,0.000000,60.325000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<20.955000,0.000000,62.230000>}
box{<0,0,-0.127000><1.905000,0.036000,0.127000> rotate<0,90.000000,0> translate<20.955000,0.000000,62.230000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<22.225000,0.000000,60.020200>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<23.495000,0.000000,60.020200>}
box{<0,0,-0.127000><1.270000,0.036000,0.127000> rotate<0,0.000000,0> translate<22.225000,0.000000,60.020200> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<22.225000,0.000000,60.020200>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<22.225000,0.000000,59.690000>}
box{<0,0,-0.127000><0.330200,0.036000,0.127000> rotate<0,-90.000000,0> translate<22.225000,0.000000,59.690000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<23.495000,0.000000,60.020200>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<23.495000,0.000000,60.325000>}
box{<0,0,-0.127000><0.304800,0.036000,0.127000> rotate<0,90.000000,0> translate<23.495000,0.000000,60.325000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<22.225000,0.000000,60.325000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<23.495000,0.000000,60.325000>}
box{<0,0,-0.127000><1.270000,0.036000,0.127000> rotate<0,0.000000,0> translate<22.225000,0.000000,60.325000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<22.225000,0.000000,60.325000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<22.225000,0.000000,60.020200>}
box{<0,0,-0.127000><0.304800,0.036000,0.127000> rotate<0,-90.000000,0> translate<22.225000,0.000000,60.020200> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<23.495000,0.000000,60.325000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<23.495000,0.000000,62.230000>}
box{<0,0,-0.127000><1.905000,0.036000,0.127000> rotate<0,90.000000,0> translate<23.495000,0.000000,62.230000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<25.400000,0.000000,57.150000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.622000,0.000000,57.150000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<23.622000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.240000,0.000000,57.150000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.018000,0.000000,57.150000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<15.240000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.240000,0.000000,64.770000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.018000,0.000000,64.770000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<15.240000,0.000000,64.770000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<25.400000,0.000000,64.770000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.622000,0.000000,64.770000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<23.622000,0.000000,64.770000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.018000,0.000000,57.150000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.542000,0.000000,57.150000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<17.018000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.542000,0.000000,57.150000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.558000,0.000000,57.150000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<18.542000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.558000,0.000000,57.150000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.082000,0.000000,57.150000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<19.558000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.082000,0.000000,57.150000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.098000,0.000000,57.150000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<21.082000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.098000,0.000000,57.150000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.622000,0.000000,57.150000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<22.098000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.622000,0.000000,64.770000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.098000,0.000000,64.770000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<22.098000,0.000000,64.770000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.098000,0.000000,64.770000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.082000,0.000000,64.770000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<21.082000,0.000000,64.770000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.082000,0.000000,64.770000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.558000,0.000000,64.770000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<19.558000,0.000000,64.770000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.558000,0.000000,64.770000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.542000,0.000000,64.770000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<18.542000,0.000000,64.770000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.542000,0.000000,64.770000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.018000,0.000000,64.770000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<17.018000,0.000000,64.770000> }
difference{
cylinder{<16.256000,0,58.166000><16.256000,0.036000,58.166000>0.330200 translate<0,0.000000,0>}
cylinder{<16.256000,-0.1,58.166000><16.256000,0.135000,58.166000>0.177800 translate<0,0.000000,0>}}
//IC1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.800000,0.000000,57.150000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.800000,0.000000,55.880000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<50.800000,0.000000,55.880000> }
object{ARC(1.270000,0.152400,270.000000,450.000000,0.036000) translate<50.800000,0.000000,58.420000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.360000,0.000000,55.880000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.360000,0.000000,60.960000>}
box{<0,0,-0.076200><5.080000,0.036000,0.076200> rotate<0,90.000000,0> translate<86.360000,0.000000,60.960000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.800000,0.000000,60.960000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.800000,0.000000,59.690000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<50.800000,0.000000,59.690000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.800000,0.000000,60.960000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.360000,0.000000,60.960000>}
box{<0,0,-0.076200><35.560000,0.036000,0.076200> rotate<0,0.000000,0> translate<50.800000,0.000000,60.960000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.927000,0.000000,55.880000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.360000,0.000000,55.880000>}
box{<0,0,-0.076200><35.433000,0.036000,0.076200> rotate<0,0.000000,0> translate<50.927000,0.000000,55.880000> }
//JP3 silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<24.765000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<26.035000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<24.765000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<26.035000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<26.670000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<26.035000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<26.670000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<26.035000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<26.035000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<21.590000,0.000000,48.895000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<22.225000,0.000000,49.530000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<21.590000,0.000000,48.895000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<22.225000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<23.495000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<22.225000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<23.495000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<24.130000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<23.495000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<24.130000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<23.495000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<23.495000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<23.495000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<22.225000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<22.225000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<22.225000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<21.590000,0.000000,47.625000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<21.590000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<24.765000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<24.130000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<24.130000,0.000000,48.895000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<24.130000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<24.765000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<24.130000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<26.035000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<24.765000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<24.765000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<17.145000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<18.415000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<17.145000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<18.415000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<19.050000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<18.415000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<19.050000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<18.415000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<18.415000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<19.050000,0.000000,48.895000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<19.685000,0.000000,49.530000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<19.050000,0.000000,48.895000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<19.685000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<20.955000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<19.685000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<20.955000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<21.590000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<20.955000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<21.590000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<20.955000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<20.955000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<20.955000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<19.685000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<19.685000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<19.685000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<19.050000,0.000000,47.625000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<19.050000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<13.970000,0.000000,48.895000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<14.605000,0.000000,49.530000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<13.970000,0.000000,48.895000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<14.605000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<15.875000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<14.605000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<15.875000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<16.510000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<15.875000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<16.510000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<15.875000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<15.875000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<15.875000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<14.605000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<14.605000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<14.605000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<13.970000,0.000000,47.625000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<13.970000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<17.145000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<16.510000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<16.510000,0.000000,48.895000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<16.510000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<17.145000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<16.510000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<18.415000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<17.145000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<17.145000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<9.525000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<10.795000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<9.525000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<10.795000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<11.430000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<10.795000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<11.430000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<10.795000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<10.795000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<11.430000,0.000000,48.895000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<12.065000,0.000000,49.530000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<11.430000,0.000000,48.895000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<12.065000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<13.335000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<12.065000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<13.335000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<13.970000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<13.335000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<13.970000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<13.335000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<13.335000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<13.335000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<12.065000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<12.065000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<12.065000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<11.430000,0.000000,47.625000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<11.430000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,48.895000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,47.625000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,-90.000000,0> translate<8.890000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<9.525000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<8.890000,0.000000,48.895000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<9.525000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<8.890000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<10.795000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<9.525000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<9.525000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<42.545000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<43.815000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<42.545000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<43.815000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<44.450000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<43.815000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<44.450000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<43.815000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<43.815000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<39.370000,0.000000,48.895000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<40.005000,0.000000,49.530000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<39.370000,0.000000,48.895000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<40.005000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<41.275000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<40.005000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<41.275000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<41.910000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<41.275000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<41.910000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<41.275000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<41.275000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<41.275000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<40.005000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<40.005000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<40.005000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<39.370000,0.000000,47.625000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<39.370000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<42.545000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<41.910000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<41.910000,0.000000,48.895000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<41.910000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<42.545000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<41.910000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<43.815000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<42.545000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<42.545000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.925000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<36.195000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<34.925000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<36.195000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<36.830000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<36.195000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<36.830000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<36.195000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<36.195000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<36.830000,0.000000,48.895000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<37.465000,0.000000,49.530000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<36.830000,0.000000,48.895000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<37.465000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<38.735000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<37.465000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<38.735000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<39.370000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<38.735000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<39.370000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<38.735000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<38.735000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<38.735000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<37.465000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<37.465000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<37.465000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<36.830000,0.000000,47.625000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<36.830000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.750000,0.000000,48.895000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<32.385000,0.000000,49.530000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<31.750000,0.000000,48.895000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<32.385000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<33.655000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<32.385000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<33.655000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.290000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<33.655000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.290000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<33.655000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<33.655000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<33.655000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<32.385000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<32.385000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<32.385000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.750000,0.000000,47.625000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<31.750000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.925000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.290000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<34.290000,0.000000,48.895000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.290000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.925000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<34.290000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<36.195000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.925000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<34.925000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.305000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<28.575000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<27.305000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<28.575000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.210000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<28.575000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.210000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<28.575000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<28.575000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.210000,0.000000,48.895000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.845000,0.000000,49.530000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<29.210000,0.000000,48.895000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.845000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.115000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<29.845000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.115000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.750000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<31.115000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.750000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.115000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<31.115000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.115000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.845000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<29.845000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.845000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.210000,0.000000,47.625000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<29.210000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.305000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<26.670000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<26.670000,0.000000,48.895000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<26.670000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.305000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<26.670000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<28.575000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.305000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<27.305000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<45.085000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<44.450000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<44.450000,0.000000,48.895000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<45.085000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<46.355000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<45.085000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<46.355000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<46.990000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<46.355000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<46.990000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<46.355000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<46.355000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<46.355000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<45.085000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<45.085000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<44.450000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<45.085000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<44.450000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<47.625000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<46.990000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<46.990000,0.000000,48.895000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<47.625000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<48.895000,0.000000,49.530000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<47.625000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<48.895000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<49.530000,0.000000,48.895000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<48.895000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<49.530000,0.000000,48.895000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<49.530000,0.000000,47.625000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,-90.000000,0> translate<49.530000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<49.530000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<48.895000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<48.895000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<48.895000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<47.625000,0.000000,46.990000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<47.625000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<46.990000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<47.625000,0.000000,46.990000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<46.990000,0.000000,47.625000> }
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<25.400000,0.000000,48.260000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<22.860000,0.000000,48.260000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<20.320000,0.000000,48.260000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<17.780000,0.000000,48.260000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<15.240000,0.000000,48.260000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<12.700000,0.000000,48.260000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<10.160000,0.000000,48.260000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<43.180000,0.000000,48.260000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<40.640000,0.000000,48.260000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<38.100000,0.000000,48.260000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<35.560000,0.000000,48.260000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<33.020000,0.000000,48.260000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<30.480000,0.000000,48.260000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<27.940000,0.000000,48.260000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<45.720000,0.000000,48.260000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<48.260000,0.000000,48.260000>}
//JP4 silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<65.405000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<66.675000,0.000000,74.930000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<65.405000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<66.675000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<67.310000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<66.675000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<67.310000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<66.675000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<66.675000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<62.230000,0.000000,74.295000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<62.865000,0.000000,74.930000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<62.230000,0.000000,74.295000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<62.865000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<64.135000,0.000000,74.930000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<62.865000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<64.135000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<64.770000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<64.135000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<64.770000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<64.135000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<64.135000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<64.135000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<62.865000,0.000000,72.390000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<62.865000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<62.865000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<62.230000,0.000000,73.025000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<62.230000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<65.405000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<64.770000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<64.770000,0.000000,74.295000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<64.770000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<65.405000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<64.770000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<66.675000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<65.405000,0.000000,72.390000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<65.405000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<57.785000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<59.055000,0.000000,74.930000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<57.785000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<59.055000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<59.690000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<59.055000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<59.690000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<59.055000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<59.055000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<59.690000,0.000000,74.295000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<60.325000,0.000000,74.930000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<59.690000,0.000000,74.295000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<60.325000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<61.595000,0.000000,74.930000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<60.325000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<61.595000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<62.230000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<61.595000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<62.230000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<61.595000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<61.595000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<61.595000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<60.325000,0.000000,72.390000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<60.325000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<60.325000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<59.690000,0.000000,73.025000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<59.690000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<54.610000,0.000000,74.295000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.245000,0.000000,74.930000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<54.610000,0.000000,74.295000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.245000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<56.515000,0.000000,74.930000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<55.245000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<56.515000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<57.150000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<56.515000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<57.150000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<56.515000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<56.515000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<56.515000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.245000,0.000000,72.390000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<55.245000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<55.245000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<54.610000,0.000000,73.025000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<54.610000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<57.785000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<57.150000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<57.150000,0.000000,74.295000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<57.150000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<57.785000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<57.150000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<59.055000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<57.785000,0.000000,72.390000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<57.785000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<50.165000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.435000,0.000000,74.930000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<50.165000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.435000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<52.070000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<51.435000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<52.070000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.435000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<51.435000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<52.070000,0.000000,74.295000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<52.705000,0.000000,74.930000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<52.070000,0.000000,74.295000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<52.705000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.975000,0.000000,74.930000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<52.705000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.975000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<54.610000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<53.975000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<54.610000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.975000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<53.975000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<53.975000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<52.705000,0.000000,72.390000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<52.705000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<52.705000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<52.070000,0.000000,73.025000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<52.070000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<49.530000,0.000000,74.295000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<49.530000,0.000000,73.025000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,-90.000000,0> translate<49.530000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<50.165000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<49.530000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<49.530000,0.000000,74.295000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<49.530000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<50.165000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<49.530000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<51.435000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<50.165000,0.000000,72.390000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<50.165000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<83.185000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<84.455000,0.000000,74.930000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<83.185000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<84.455000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.090000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<84.455000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.090000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<84.455000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<84.455000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<80.010000,0.000000,74.295000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<80.645000,0.000000,74.930000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<80.010000,0.000000,74.295000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<80.645000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<81.915000,0.000000,74.930000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<80.645000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<81.915000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<82.550000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<81.915000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<82.550000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<81.915000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<81.915000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<81.915000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<80.645000,0.000000,72.390000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<80.645000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<80.645000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<80.010000,0.000000,73.025000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<80.010000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<83.185000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<82.550000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<82.550000,0.000000,74.295000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<82.550000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<83.185000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<82.550000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<84.455000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<83.185000,0.000000,72.390000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<83.185000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<75.565000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<76.835000,0.000000,74.930000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<75.565000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<76.835000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<77.470000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<76.835000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<77.470000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<76.835000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<76.835000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<77.470000,0.000000,74.295000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<78.105000,0.000000,74.930000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<77.470000,0.000000,74.295000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<78.105000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<79.375000,0.000000,74.930000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<78.105000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<79.375000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<80.010000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<79.375000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<80.010000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<79.375000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<79.375000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<79.375000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<78.105000,0.000000,72.390000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<78.105000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<78.105000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<77.470000,0.000000,73.025000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<77.470000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<72.390000,0.000000,74.295000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<73.025000,0.000000,74.930000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<72.390000,0.000000,74.295000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<73.025000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<74.295000,0.000000,74.930000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<73.025000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<74.295000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<74.930000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<74.295000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<74.930000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<74.295000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<74.295000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<74.295000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<73.025000,0.000000,72.390000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<73.025000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<73.025000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<72.390000,0.000000,73.025000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<72.390000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<75.565000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<74.930000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<74.930000,0.000000,74.295000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<74.930000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<75.565000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<74.930000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<76.835000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<75.565000,0.000000,72.390000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<75.565000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<67.945000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<69.215000,0.000000,74.930000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<67.945000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<69.215000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<69.850000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<69.215000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<69.850000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<69.215000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<69.215000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<69.850000,0.000000,74.295000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<70.485000,0.000000,74.930000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<69.850000,0.000000,74.295000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<70.485000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<71.755000,0.000000,74.930000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<70.485000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<71.755000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<72.390000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<71.755000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<72.390000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<71.755000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<71.755000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<71.755000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<70.485000,0.000000,72.390000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<70.485000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<70.485000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<69.850000,0.000000,73.025000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<69.850000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<67.945000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<67.310000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<67.310000,0.000000,74.295000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<67.310000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<67.945000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<67.310000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<69.215000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<67.945000,0.000000,72.390000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<67.945000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.725000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.090000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<85.090000,0.000000,74.295000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.725000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<86.995000,0.000000,74.930000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<85.725000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<86.995000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<87.630000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<86.995000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<87.630000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<86.995000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<86.995000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<86.995000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.725000,0.000000,72.390000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<85.725000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.090000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.725000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<85.090000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<88.265000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<87.630000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<87.630000,0.000000,74.295000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<88.265000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<89.535000,0.000000,74.930000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<88.265000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<89.535000,0.000000,74.930000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,74.295000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<89.535000,0.000000,74.930000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,74.295000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,73.025000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,-90.000000,0> translate<90.170000,0.000000,73.025000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<89.535000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<89.535000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<89.535000,0.000000,72.390000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<88.265000,0.000000,72.390000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<88.265000,0.000000,72.390000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<87.630000,0.000000,73.025000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<88.265000,0.000000,72.390000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<87.630000,0.000000,73.025000> }
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<66.040000,0.000000,73.660000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<63.500000,0.000000,73.660000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<60.960000,0.000000,73.660000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<58.420000,0.000000,73.660000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<55.880000,0.000000,73.660000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<53.340000,0.000000,73.660000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<50.800000,0.000000,73.660000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<83.820000,0.000000,73.660000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<81.280000,0.000000,73.660000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<78.740000,0.000000,73.660000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<76.200000,0.000000,73.660000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<73.660000,0.000000,73.660000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<71.120000,0.000000,73.660000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<68.580000,0.000000,73.660000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<86.360000,0.000000,73.660000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<88.900000,0.000000,73.660000>}
//JP5 silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,67.945000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,69.215000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,90.000000,0> translate<6.350000,0.000000,69.215000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,69.215000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.985000,0.000000,69.850000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<6.350000,0.000000,69.215000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.255000,0.000000,69.850000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,69.215000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<8.255000,0.000000,69.850000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.985000,0.000000,64.770000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,65.405000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<6.350000,0.000000,65.405000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,65.405000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,66.675000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,90.000000,0> translate<6.350000,0.000000,66.675000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,66.675000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.985000,0.000000,67.310000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<6.350000,0.000000,66.675000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.255000,0.000000,67.310000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,66.675000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<8.255000,0.000000,67.310000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,66.675000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,65.405000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,-90.000000,0> translate<8.890000,0.000000,65.405000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,65.405000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.255000,0.000000,64.770000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<8.255000,0.000000,64.770000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,67.945000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.985000,0.000000,67.310000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<6.350000,0.000000,67.945000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.255000,0.000000,67.310000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,67.945000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<8.255000,0.000000,67.310000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,69.215000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,67.945000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,-90.000000,0> translate<8.890000,0.000000,67.945000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,60.325000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,61.595000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,90.000000,0> translate<6.350000,0.000000,61.595000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,61.595000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.985000,0.000000,62.230000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<6.350000,0.000000,61.595000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.255000,0.000000,62.230000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,61.595000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<8.255000,0.000000,62.230000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.985000,0.000000,62.230000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,62.865000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<6.350000,0.000000,62.865000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,62.865000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,64.135000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,90.000000,0> translate<6.350000,0.000000,64.135000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,64.135000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.985000,0.000000,64.770000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<6.350000,0.000000,64.135000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.255000,0.000000,64.770000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,64.135000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<8.255000,0.000000,64.770000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,64.135000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,62.865000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,-90.000000,0> translate<8.890000,0.000000,62.865000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,62.865000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.255000,0.000000,62.230000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<8.255000,0.000000,62.230000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.985000,0.000000,57.150000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,57.785000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<6.350000,0.000000,57.785000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,57.785000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,59.055000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,90.000000,0> translate<6.350000,0.000000,59.055000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,59.055000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.985000,0.000000,59.690000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<6.350000,0.000000,59.055000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.255000,0.000000,59.690000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,59.055000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<8.255000,0.000000,59.690000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,59.055000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,57.785000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,-90.000000,0> translate<8.890000,0.000000,57.785000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,57.785000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.255000,0.000000,57.150000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<8.255000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,60.325000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.985000,0.000000,59.690000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<6.350000,0.000000,60.325000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.255000,0.000000,59.690000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,60.325000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<8.255000,0.000000,59.690000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,61.595000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,60.325000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,-90.000000,0> translate<8.890000,0.000000,60.325000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,52.705000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,53.975000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,90.000000,0> translate<6.350000,0.000000,53.975000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,53.975000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.985000,0.000000,54.610000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<6.350000,0.000000,53.975000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.255000,0.000000,54.610000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,53.975000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<8.255000,0.000000,54.610000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.985000,0.000000,54.610000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,55.245000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<6.350000,0.000000,55.245000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,55.245000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,56.515000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,90.000000,0> translate<6.350000,0.000000,56.515000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,56.515000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.985000,0.000000,57.150000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<6.350000,0.000000,56.515000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.255000,0.000000,57.150000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,56.515000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<8.255000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,56.515000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,55.245000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,-90.000000,0> translate<8.890000,0.000000,55.245000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,55.245000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.255000,0.000000,54.610000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<8.255000,0.000000,54.610000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.985000,0.000000,52.070000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.255000,0.000000,52.070000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<6.985000,0.000000,52.070000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.350000,0.000000,52.705000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.985000,0.000000,52.070000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<6.350000,0.000000,52.705000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.255000,0.000000,52.070000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,52.705000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<8.255000,0.000000,52.070000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,53.975000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.890000,0.000000,52.705000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,-90.000000,0> translate<8.890000,0.000000,52.705000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.985000,0.000000,69.850000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<8.255000,0.000000,69.850000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<6.985000,0.000000,69.850000> }
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-90.000000,0> translate<7.620000,0.000000,68.580000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-90.000000,0> translate<7.620000,0.000000,66.040000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-90.000000,0> translate<7.620000,0.000000,63.500000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-90.000000,0> translate<7.620000,0.000000,60.960000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-90.000000,0> translate<7.620000,0.000000,58.420000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-90.000000,0> translate<7.620000,0.000000,55.880000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-90.000000,0> translate<7.620000,0.000000,53.340000>}
//JP6 silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,53.975000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,52.705000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,-90.000000,0> translate<92.710000,0.000000,52.705000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,52.705000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.075000,0.000000,52.070000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<92.075000,0.000000,52.070000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.805000,0.000000,52.070000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,52.705000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<90.170000,0.000000,52.705000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.075000,0.000000,57.150000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,56.515000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<92.075000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,56.515000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,55.245000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,-90.000000,0> translate<92.710000,0.000000,55.245000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,55.245000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.075000,0.000000,54.610000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<92.075000,0.000000,54.610000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.805000,0.000000,54.610000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,55.245000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<90.170000,0.000000,55.245000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,55.245000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,56.515000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,90.000000,0> translate<90.170000,0.000000,56.515000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,56.515000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.805000,0.000000,57.150000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<90.170000,0.000000,56.515000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,53.975000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.075000,0.000000,54.610000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<92.075000,0.000000,54.610000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.805000,0.000000,54.610000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,53.975000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<90.170000,0.000000,53.975000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,52.705000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,53.975000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,90.000000,0> translate<90.170000,0.000000,53.975000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,61.595000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,60.325000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,-90.000000,0> translate<92.710000,0.000000,60.325000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,60.325000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.075000,0.000000,59.690000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<92.075000,0.000000,59.690000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.805000,0.000000,59.690000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,60.325000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<90.170000,0.000000,60.325000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.075000,0.000000,59.690000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,59.055000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<92.075000,0.000000,59.690000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,59.055000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,57.785000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,-90.000000,0> translate<92.710000,0.000000,57.785000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,57.785000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.075000,0.000000,57.150000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<92.075000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.805000,0.000000,57.150000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,57.785000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<90.170000,0.000000,57.785000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,57.785000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,59.055000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,90.000000,0> translate<90.170000,0.000000,59.055000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,59.055000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.805000,0.000000,59.690000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<90.170000,0.000000,59.055000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.075000,0.000000,64.770000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,64.135000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<92.075000,0.000000,64.770000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,64.135000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,62.865000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,-90.000000,0> translate<92.710000,0.000000,62.865000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,62.865000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.075000,0.000000,62.230000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<92.075000,0.000000,62.230000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.805000,0.000000,62.230000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,62.865000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<90.170000,0.000000,62.865000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,62.865000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,64.135000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,90.000000,0> translate<90.170000,0.000000,64.135000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,64.135000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.805000,0.000000,64.770000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<90.170000,0.000000,64.135000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,61.595000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.075000,0.000000,62.230000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<92.075000,0.000000,62.230000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.805000,0.000000,62.230000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,61.595000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<90.170000,0.000000,61.595000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,60.325000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,61.595000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,90.000000,0> translate<90.170000,0.000000,61.595000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,69.215000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,67.945000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,-90.000000,0> translate<92.710000,0.000000,67.945000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,67.945000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.075000,0.000000,67.310000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<92.075000,0.000000,67.310000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.805000,0.000000,67.310000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,67.945000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<90.170000,0.000000,67.945000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.075000,0.000000,67.310000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,66.675000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<92.075000,0.000000,67.310000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,66.675000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,65.405000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,-90.000000,0> translate<92.710000,0.000000,65.405000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,65.405000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.075000,0.000000,64.770000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<92.075000,0.000000,64.770000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.805000,0.000000,64.770000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,65.405000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<90.170000,0.000000,65.405000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,65.405000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,66.675000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,90.000000,0> translate<90.170000,0.000000,66.675000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,66.675000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.805000,0.000000,67.310000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<90.170000,0.000000,66.675000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.075000,0.000000,69.850000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.805000,0.000000,69.850000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<90.805000,0.000000,69.850000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.710000,0.000000,69.215000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.075000,0.000000,69.850000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,44.997030,0> translate<92.075000,0.000000,69.850000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.805000,0.000000,69.850000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,69.215000>}
box{<0,0,-0.101600><0.898026,0.036000,0.101600> rotate<0,-44.997030,0> translate<90.170000,0.000000,69.215000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,67.945000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.170000,0.000000,69.215000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,90.000000,0> translate<90.170000,0.000000,69.215000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<92.075000,0.000000,52.070000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.805000,0.000000,52.070000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<90.805000,0.000000,52.070000> }
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-270.000000,0> translate<91.440000,0.000000,53.340000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-270.000000,0> translate<91.440000,0.000000,55.880000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-270.000000,0> translate<91.440000,0.000000,58.420000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-270.000000,0> translate<91.440000,0.000000,60.960000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-270.000000,0> translate<91.440000,0.000000,63.500000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-270.000000,0> translate<91.440000,0.000000,66.040000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-270.000000,0> translate<91.440000,0.000000,68.580000>}
//LCD_CONTRAST silk screen
//R1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<48.260000,0.000000,68.580000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<47.244000,0.000000,68.580000>}
box{<0,0,-0.304800><1.016000,0.036000,0.304800> rotate<0,0.000000,0> translate<47.244000,0.000000,68.580000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<38.100000,0.000000,68.580000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<39.116000,0.000000,68.580000>}
box{<0,0,-0.304800><1.016000,0.036000,0.304800> rotate<0,0.000000,0> translate<38.100000,0.000000,68.580000> }
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<40.259000,0.000000,69.469000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<40.259000,0.000000,67.691000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<46.101000,0.000000,67.691000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<46.101000,0.000000,69.469000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.005000,0.000000,67.691000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.005000,0.000000,69.469000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<40.005000,0.000000,69.469000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.259000,0.000000,69.723000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.640000,0.000000,69.723000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<40.259000,0.000000,69.723000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.767000,0.000000,69.596000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.640000,0.000000,69.723000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<40.640000,0.000000,69.723000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.259000,0.000000,67.437000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.640000,0.000000,67.437000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<40.259000,0.000000,67.437000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.767000,0.000000,67.564000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.640000,0.000000,67.437000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<40.640000,0.000000,67.437000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.593000,0.000000,69.596000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.720000,0.000000,69.723000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<45.593000,0.000000,69.596000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.593000,0.000000,69.596000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.767000,0.000000,69.596000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<40.767000,0.000000,69.596000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.593000,0.000000,67.564000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.720000,0.000000,67.437000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<45.593000,0.000000,67.564000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.593000,0.000000,67.564000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.767000,0.000000,67.564000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<40.767000,0.000000,67.564000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.101000,0.000000,69.723000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.720000,0.000000,69.723000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<45.720000,0.000000,69.723000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.101000,0.000000,67.437000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.720000,0.000000,67.437000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<45.720000,0.000000,67.437000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.355000,0.000000,67.691000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.355000,0.000000,69.469000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<46.355000,0.000000,69.469000> }
box{<-0.431800,0,-0.304800><0.431800,0.036000,0.304800> rotate<0,-0.000000,0> translate<46.786800,0.000000,68.580000>}
box{<-0.431800,0,-0.304800><0.431800,0.036000,0.304800> rotate<0,-0.000000,0> translate<39.573200,0.000000,68.580000>}
//R3 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<86.360000,0.000000,68.580000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<85.344000,0.000000,68.580000>}
box{<0,0,-0.304800><1.016000,0.036000,0.304800> rotate<0,0.000000,0> translate<85.344000,0.000000,68.580000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<76.200000,0.000000,68.580000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<77.216000,0.000000,68.580000>}
box{<0,0,-0.304800><1.016000,0.036000,0.304800> rotate<0,0.000000,0> translate<76.200000,0.000000,68.580000> }
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<78.359000,0.000000,69.469000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<78.359000,0.000000,67.691000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<84.201000,0.000000,67.691000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<84.201000,0.000000,69.469000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.105000,0.000000,67.691000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.105000,0.000000,69.469000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<78.105000,0.000000,69.469000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.359000,0.000000,69.723000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.740000,0.000000,69.723000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<78.359000,0.000000,69.723000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.867000,0.000000,69.596000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.740000,0.000000,69.723000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<78.740000,0.000000,69.723000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.359000,0.000000,67.437000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.740000,0.000000,67.437000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<78.359000,0.000000,67.437000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.867000,0.000000,67.564000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.740000,0.000000,67.437000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<78.740000,0.000000,67.437000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.693000,0.000000,69.596000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.820000,0.000000,69.723000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<83.693000,0.000000,69.596000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.693000,0.000000,69.596000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.867000,0.000000,69.596000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<78.867000,0.000000,69.596000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.693000,0.000000,67.564000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.820000,0.000000,67.437000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<83.693000,0.000000,67.564000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.693000,0.000000,67.564000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.867000,0.000000,67.564000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<78.867000,0.000000,67.564000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<84.201000,0.000000,69.723000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.820000,0.000000,69.723000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<83.820000,0.000000,69.723000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<84.201000,0.000000,67.437000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<83.820000,0.000000,67.437000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<83.820000,0.000000,67.437000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<84.455000,0.000000,67.691000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<84.455000,0.000000,69.469000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<84.455000,0.000000,69.469000> }
box{<-0.431800,0,-0.304800><0.431800,0.036000,0.304800> rotate<0,-0.000000,0> translate<84.886800,0.000000,68.580000>}
box{<-0.431800,0,-0.304800><0.431800,0.036000,0.304800> rotate<0,-0.000000,0> translate<77.673200,0.000000,68.580000>}
//R4 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<60.960000,0.000000,68.580000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<59.944000,0.000000,68.580000>}
box{<0,0,-0.304800><1.016000,0.036000,0.304800> rotate<0,0.000000,0> translate<59.944000,0.000000,68.580000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<50.800000,0.000000,68.580000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<51.816000,0.000000,68.580000>}
box{<0,0,-0.304800><1.016000,0.036000,0.304800> rotate<0,0.000000,0> translate<50.800000,0.000000,68.580000> }
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<52.959000,0.000000,69.469000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<52.959000,0.000000,67.691000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<58.801000,0.000000,67.691000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<58.801000,0.000000,69.469000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.705000,0.000000,67.691000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.705000,0.000000,69.469000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<52.705000,0.000000,69.469000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.959000,0.000000,69.723000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.340000,0.000000,69.723000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<52.959000,0.000000,69.723000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.467000,0.000000,69.596000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.340000,0.000000,69.723000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<53.340000,0.000000,69.723000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.959000,0.000000,67.437000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.340000,0.000000,67.437000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<52.959000,0.000000,67.437000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.467000,0.000000,67.564000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.340000,0.000000,67.437000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<53.340000,0.000000,67.437000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.293000,0.000000,69.596000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.420000,0.000000,69.723000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<58.293000,0.000000,69.596000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.293000,0.000000,69.596000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.467000,0.000000,69.596000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<53.467000,0.000000,69.596000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.293000,0.000000,67.564000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.420000,0.000000,67.437000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<58.293000,0.000000,67.564000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.293000,0.000000,67.564000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.467000,0.000000,67.564000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<53.467000,0.000000,67.564000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.801000,0.000000,69.723000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.420000,0.000000,69.723000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<58.420000,0.000000,69.723000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.801000,0.000000,67.437000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.420000,0.000000,67.437000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<58.420000,0.000000,67.437000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.055000,0.000000,67.691000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.055000,0.000000,69.469000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<59.055000,0.000000,69.469000> }
box{<-0.431800,0,-0.304800><0.431800,0.036000,0.304800> rotate<0,-0.000000,0> translate<59.486800,0.000000,68.580000>}
box{<-0.431800,0,-0.304800><0.431800,0.036000,0.304800> rotate<0,-0.000000,0> translate<52.273200,0.000000,68.580000>}
//R5 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<36.830000,0.000000,64.770000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<36.830000,0.000000,63.754000>}
box{<0,0,-0.304800><1.016000,0.036000,0.304800> rotate<0,-90.000000,0> translate<36.830000,0.000000,63.754000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<36.830000,0.000000,54.610000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<36.830000,0.000000,55.626000>}
box{<0,0,-0.304800><1.016000,0.036000,0.304800> rotate<0,90.000000,0> translate<36.830000,0.000000,55.626000> }
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<35.941000,0.000000,56.769000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<37.719000,0.000000,56.769000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<37.719000,0.000000,62.611000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<35.941000,0.000000,62.611000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.719000,0.000000,56.515000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.941000,0.000000,56.515000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<35.941000,0.000000,56.515000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.687000,0.000000,56.769000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.687000,0.000000,57.150000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<35.687000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.814000,0.000000,57.277000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.687000,0.000000,57.150000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<35.687000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.973000,0.000000,56.769000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.973000,0.000000,57.150000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<37.973000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.846000,0.000000,57.277000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.973000,0.000000,57.150000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<37.846000,0.000000,57.277000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.814000,0.000000,62.103000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.687000,0.000000,62.230000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<35.687000,0.000000,62.230000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.814000,0.000000,62.103000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.814000,0.000000,57.277000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,-90.000000,0> translate<35.814000,0.000000,57.277000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.846000,0.000000,62.103000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.973000,0.000000,62.230000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<37.846000,0.000000,62.103000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.846000,0.000000,62.103000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.846000,0.000000,57.277000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,-90.000000,0> translate<37.846000,0.000000,57.277000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.687000,0.000000,62.611000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.687000,0.000000,62.230000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<35.687000,0.000000,62.230000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.973000,0.000000,62.611000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.973000,0.000000,62.230000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<37.973000,0.000000,62.230000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.719000,0.000000,62.865000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.941000,0.000000,62.865000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<35.941000,0.000000,62.865000> }
box{<-0.431800,0,-0.304800><0.431800,0.036000,0.304800> rotate<0,-90.000000,0> translate<36.830000,0.000000,63.296800>}
box{<-0.431800,0,-0.304800><0.431800,0.036000,0.304800> rotate<0,-90.000000,0> translate<36.830000,0.000000,56.083200>}
//R6 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<31.750000,0.000000,64.770000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<31.750000,0.000000,63.754000>}
box{<0,0,-0.304800><1.016000,0.036000,0.304800> rotate<0,-90.000000,0> translate<31.750000,0.000000,63.754000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<31.750000,0.000000,54.610000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<31.750000,0.000000,55.626000>}
box{<0,0,-0.304800><1.016000,0.036000,0.304800> rotate<0,90.000000,0> translate<31.750000,0.000000,55.626000> }
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<30.861000,0.000000,56.769000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<32.639000,0.000000,56.769000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<32.639000,0.000000,62.611000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<30.861000,0.000000,62.611000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.639000,0.000000,56.515000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.861000,0.000000,56.515000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<30.861000,0.000000,56.515000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.607000,0.000000,56.769000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.607000,0.000000,57.150000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<30.607000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.734000,0.000000,57.277000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.607000,0.000000,57.150000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<30.607000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.893000,0.000000,56.769000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.893000,0.000000,57.150000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<32.893000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.766000,0.000000,57.277000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.893000,0.000000,57.150000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<32.766000,0.000000,57.277000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.734000,0.000000,62.103000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.607000,0.000000,62.230000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<30.607000,0.000000,62.230000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.734000,0.000000,62.103000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.734000,0.000000,57.277000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,-90.000000,0> translate<30.734000,0.000000,57.277000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.766000,0.000000,62.103000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.893000,0.000000,62.230000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<32.766000,0.000000,62.103000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.766000,0.000000,62.103000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.766000,0.000000,57.277000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,-90.000000,0> translate<32.766000,0.000000,57.277000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.607000,0.000000,62.611000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.607000,0.000000,62.230000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<30.607000,0.000000,62.230000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.893000,0.000000,62.611000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.893000,0.000000,62.230000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<32.893000,0.000000,62.230000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.639000,0.000000,62.865000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.861000,0.000000,62.865000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<30.861000,0.000000,62.865000> }
box{<-0.431800,0,-0.304800><0.431800,0.036000,0.304800> rotate<0,-90.000000,0> translate<31.750000,0.000000,63.296800>}
box{<-0.431800,0,-0.304800><0.431800,0.036000,0.304800> rotate<0,-90.000000,0> translate<31.750000,0.000000,56.083200>}
//R7 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<43.180000,0.000000,64.770000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<43.180000,0.000000,63.754000>}
box{<0,0,-0.304800><1.016000,0.036000,0.304800> rotate<0,-90.000000,0> translate<43.180000,0.000000,63.754000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<43.180000,0.000000,54.610000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<43.180000,0.000000,55.626000>}
box{<0,0,-0.304800><1.016000,0.036000,0.304800> rotate<0,90.000000,0> translate<43.180000,0.000000,55.626000> }
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<42.291000,0.000000,56.769000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<44.069000,0.000000,56.769000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<44.069000,0.000000,62.611000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<42.291000,0.000000,62.611000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.069000,0.000000,56.515000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.291000,0.000000,56.515000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<42.291000,0.000000,56.515000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.037000,0.000000,56.769000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.037000,0.000000,57.150000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<42.037000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.164000,0.000000,57.277000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.037000,0.000000,57.150000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<42.037000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.323000,0.000000,56.769000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.323000,0.000000,57.150000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<44.323000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.196000,0.000000,57.277000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.323000,0.000000,57.150000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<44.196000,0.000000,57.277000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.164000,0.000000,62.103000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.037000,0.000000,62.230000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<42.037000,0.000000,62.230000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.164000,0.000000,62.103000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.164000,0.000000,57.277000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,-90.000000,0> translate<42.164000,0.000000,57.277000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.196000,0.000000,62.103000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.323000,0.000000,62.230000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<44.196000,0.000000,62.103000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.196000,0.000000,62.103000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.196000,0.000000,57.277000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,-90.000000,0> translate<44.196000,0.000000,57.277000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.037000,0.000000,62.611000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.037000,0.000000,62.230000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<42.037000,0.000000,62.230000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.323000,0.000000,62.611000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.323000,0.000000,62.230000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<44.323000,0.000000,62.230000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.069000,0.000000,62.865000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.291000,0.000000,62.865000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<42.291000,0.000000,62.865000> }
box{<-0.431800,0,-0.304800><0.431800,0.036000,0.304800> rotate<0,-90.000000,0> translate<43.180000,0.000000,63.296800>}
box{<-0.431800,0,-0.304800><0.431800,0.036000,0.304800> rotate<0,-90.000000,0> translate<43.180000,0.000000,56.083200>}
//R8 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<73.660000,0.000000,68.580000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<72.644000,0.000000,68.580000>}
box{<0,0,-0.304800><1.016000,0.036000,0.304800> rotate<0,0.000000,0> translate<72.644000,0.000000,68.580000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<63.500000,0.000000,68.580000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<64.516000,0.000000,68.580000>}
box{<0,0,-0.304800><1.016000,0.036000,0.304800> rotate<0,0.000000,0> translate<63.500000,0.000000,68.580000> }
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<65.659000,0.000000,69.469000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<65.659000,0.000000,67.691000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<71.501000,0.000000,67.691000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<71.501000,0.000000,69.469000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.405000,0.000000,67.691000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.405000,0.000000,69.469000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<65.405000,0.000000,69.469000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.659000,0.000000,69.723000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.040000,0.000000,69.723000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<65.659000,0.000000,69.723000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.167000,0.000000,69.596000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.040000,0.000000,69.723000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<66.040000,0.000000,69.723000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.659000,0.000000,67.437000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.040000,0.000000,67.437000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<65.659000,0.000000,67.437000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.167000,0.000000,67.564000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.040000,0.000000,67.437000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<66.040000,0.000000,67.437000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.993000,0.000000,69.596000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.120000,0.000000,69.723000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<70.993000,0.000000,69.596000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.993000,0.000000,69.596000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.167000,0.000000,69.596000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<66.167000,0.000000,69.596000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.993000,0.000000,67.564000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.120000,0.000000,67.437000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<70.993000,0.000000,67.564000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.993000,0.000000,67.564000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.167000,0.000000,67.564000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<66.167000,0.000000,67.564000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.501000,0.000000,69.723000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.120000,0.000000,69.723000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<71.120000,0.000000,69.723000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.501000,0.000000,67.437000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.120000,0.000000,67.437000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<71.120000,0.000000,67.437000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.755000,0.000000,67.691000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.755000,0.000000,69.469000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<71.755000,0.000000,69.469000> }
box{<-0.431800,0,-0.304800><0.431800,0.036000,0.304800> rotate<0,-0.000000,0> translate<72.186800,0.000000,68.580000>}
box{<-0.431800,0,-0.304800><0.431800,0.036000,0.304800> rotate<0,-0.000000,0> translate<64.973200,0.000000,68.580000>}
texture{col_slk}
}
#end
translate<mac_x_ver,mac_y_ver,mac_z_ver>
rotate<mac_x_rot,mac_y_rot,mac_z_rot>
}//End union
#end

#if(use_file_as_inc=off)
object{  LCD_INTERFACE(-49.530000,0,-60.960000,pcb_rotate_x,pcb_rotate_y,pcb_rotate_z)
#if(pcb_upsidedown=on)
rotate pcb_rotdir*180
#end
}
#end


//Parts not found in 3dpack.dat or 3dusrpac.dat are:
//I2C_ADDRESS		DIP03YL
//LCD_CONTRAST	POTTRIM	TRIM_POT
