//POVRay-File created by 3d41.ulp v1.05
///home/hoeken/Desktop/reprap/trunk/reprap/electronics/Arduino-Sanguino/lcd-interface/lcd-interface.brd
//10/24/08 7:25 PM

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
#local cam_y = 205;
#local cam_z = -90;
#local cam_a = 20;
#local cam_look_x = 0;
#local cam_look_y = -3;
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

#local lgt1_pos_x = 24;
#local lgt1_pos_y = 36;
#local lgt1_pos_z = 20;
#local lgt1_intense = 0.735974;
#local lgt2_pos_x = -24;
#local lgt2_pos_y = 36;
#local lgt2_pos_z = 20;
#local lgt2_intense = 0.735974;
#local lgt3_pos_x = 24;
#local lgt3_pos_y = 36;
#local lgt3_pos_z = -14;
#local lgt3_intense = 0.735974;
#local lgt4_pos_x = -24;
#local lgt4_pos_y = 36;
#local lgt4_pos_z = -14;
#local lgt4_intense = 0.735974;

//Do not change these values
#declare pcb_height = 1.500000;
#declare pcb_cuheight = 0.035000;
#declare pcb_x_size = 64.186000;
#declare pcb_y_size = 39.233000;
#declare pcb_layer1_used = 1;
#declare pcb_layer16_used = 1;
#declare inc_testmode = off;
#declare global_seed=seed(351);
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
	//translate<-32.093000,0,-19.616500>
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
<2.070000,5.339000><66.256000,5.339000>
<66.256000,5.339000><66.256000,44.572000>
<66.256000,44.572000><2.070000,44.572000>
<2.070000,44.572000><2.070000,5.339000>
texture{col_brd}}
}//End union(Platine)
//Holes(real)/Parts
cylinder{<6.096000,1,34.544000><6.096000,-5,34.544000>1.500000 texture{col_hls}}
cylinder{<6.096000,1,9.525000><6.096000,-5,9.525000>1.500000 texture{col_hls}}
cylinder{<62.230000,1,9.525000><62.230000,-5,9.525000>1.500000 texture{col_hls}}
cylinder{<62.230000,1,34.544000><62.230000,-5,34.544000>1.500000 texture{col_hls}}
//Holes(real)/Board
//Holes(real)/Vias
}//End difference(reale Bohrungen/Durchbrüche)
#end
#if(pcb_parts=on)//Parts
union{
#ifndef(pack_C1) #declare global_pack_C1=yes; object {CAP_DIS_CERAMIC_50MM_76MM("100nF",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<40.386000,0.000000,14.986000>}#end		//ceramic disc capacitator C1 100nF C050-030X075
#ifndef(pack_IC1) #declare global_pack_IC1=yes; object {IC_DIS_DIP28("MCP23S17SP","",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<34.290000,0.000000,22.479000>translate<0,3.000000,0> }#end		//DIP28 300mil IC1 MCP23S17SP DIL28-3
#ifndef(pack_IC1) object{SOCKET_DIP28()rotate<0,0.000000,0> rotate<0,0,0> translate<34.290000,0.000000,22.479000>}#end					//IC-Sockel 28Pin IC1 MCP23S17SP
#ifndef(pack_JP1) #declare global_pack_JP1=yes; object {PH_1X7()translate<0,0,0> rotate<0,0.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<33.020000,0.000000,9.398000>}#end		//Header 2,54mm Grid 7Pin 1Row (jumper.lib) JP1  1X07
#ifndef(pack_JP2) #declare global_pack_JP2=yes; object {PH_1X4()translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<49.530000,0.000000,9.525000>}#end		//Header 2,54mm Grid 4Pin 1Row (jumper.lib) JP2  1X04
#ifndef(pack_JP3) #declare global_pack_JP3=yes; object {PH_1X4()translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<16.510000,0.000000,9.525000>}#end		//Header 2,54mm Grid 4Pin 1Row (jumper.lib) JP3  1X04
#ifndef(pack_JP4) #declare global_pack_JP4=yes; object {PH_1X16()translate<0,0,0> rotate<0,0.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<44.196000,0.000000,41.910000>}#end		//Header 2,54mm Grid 16Pin 1Row (jumper.lib) JP4  1X16
#ifndef(pack_R1) #declare global_pack_R1=yes; object {RES_DIS_0207_075MM(texture{pigment{DarkBrown}finish{phong 0.2}},texture{pigment{Black}finish{phong 0.2}},texture{pigment{Orange}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-270.000000,0> rotate<0,0,0> translate<53.721000,0.000000,22.225000>}#end		//Discrete Resistor 0,3W 7,5MM Grid R1 10k 0207/7
#ifndef(pack_R5) #declare global_pack_R5=yes; object {RES_DIS_0207_075MM(texture{pigment{DarkBrown}finish{phong 0.2}},texture{pigment{Black}finish{phong 0.2}},texture{pigment{Orange}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<52.070000,0.000000,12.700000>}#end		//Discrete Resistor 0,3W 7,5MM Grid R5 10k 0207/7
#ifndef(pack_R6) #declare global_pack_R6=yes; object {RES_DIS_0207_075MM(texture{pigment{DarkBrown}finish{phong 0.2}},texture{pigment{Black}finish{phong 0.2}},texture{pigment{Orange}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<49.530000,0.000000,15.240000>}#end		//Discrete Resistor 0,3W 7,5MM Grid R6 10k 0207/7
//Parts without Macro (e.g. SMD Solderjumper)				SMD-Solder Jumper SJ1 
//Parts without Macro (e.g. SMD Solderjumper)				SMD-Solder Jumper SJ2 
//Parts without Macro (e.g. SMD Solderjumper)				SMD-Solder Jumper SJ3 
#ifndef(pack_SV1) #declare global_pack_SV1=yes; object {CON_DIS_WS6G()translate<0,0,0> rotate<0,180.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<61.722000,0.000000,21.844000>}#end		//Shrouded Header 6Pin SV1  ML6
}//End union
#end
#if(pcb_pads_smds=on)
//Pads&SMD/Parts
#ifndef(global_pack_C1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<37.846000,0,14.986000> texture{col_thl}}
#ifndef(global_pack_C1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<42.926000,0,14.986000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<17.780000,0,18.669000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<20.320000,0,18.669000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<22.860000,0,18.669000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<25.400000,0,18.669000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<27.940000,0,18.669000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<30.480000,0,18.669000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<33.020000,0,18.669000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<35.560000,0,18.669000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<38.100000,0,18.669000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<40.640000,0,18.669000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<43.180000,0,18.669000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<45.720000,0,18.669000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<48.260000,0,18.669000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<50.800000,0,18.669000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<50.800000,0,26.289000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<48.260000,0,26.289000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<45.720000,0,26.289000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<43.180000,0,26.289000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<40.640000,0,26.289000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<38.100000,0,26.289000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<35.560000,0,26.289000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<33.020000,0,26.289000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<30.480000,0,26.289000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<27.940000,0,26.289000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<25.400000,0,26.289000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<22.860000,0,26.289000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<20.320000,0,26.289000> texture{col_thl}}
#ifndef(global_pack_IC1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<17.780000,0,26.289000> texture{col_thl}}
#ifndef(global_pack_JP1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<40.640000,0,9.398000> texture{col_thl}}
#ifndef(global_pack_JP1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<38.100000,0,9.398000> texture{col_thl}}
#ifndef(global_pack_JP1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<35.560000,0,9.398000> texture{col_thl}}
#ifndef(global_pack_JP1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<33.020000,0,9.398000> texture{col_thl}}
#ifndef(global_pack_JP1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<30.480000,0,9.398000> texture{col_thl}}
#ifndef(global_pack_JP1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<27.940000,0,9.398000> texture{col_thl}}
#ifndef(global_pack_JP1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<25.400000,0,9.398000> texture{col_thl}}
#ifndef(global_pack_JP2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<45.720000,0,9.525000> texture{col_thl}}
#ifndef(global_pack_JP2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<48.260000,0,9.525000> texture{col_thl}}
#ifndef(global_pack_JP2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<50.800000,0,9.525000> texture{col_thl}}
#ifndef(global_pack_JP2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<53.340000,0,9.525000> texture{col_thl}}
#ifndef(global_pack_JP3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<12.700000,0,9.525000> texture{col_thl}}
#ifndef(global_pack_JP3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<15.240000,0,9.525000> texture{col_thl}}
#ifndef(global_pack_JP3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<17.780000,0,9.525000> texture{col_thl}}
#ifndef(global_pack_JP3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<20.320000,0,9.525000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<63.246000,0,41.910000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<60.706000,0,41.910000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<58.166000,0,41.910000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<55.626000,0,41.910000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<53.086000,0,41.910000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<50.546000,0,41.910000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<48.006000,0,41.910000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<45.466000,0,41.910000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<42.926000,0,41.910000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<40.386000,0,41.910000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<37.846000,0,41.910000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<35.306000,0,41.910000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<32.766000,0,41.910000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<30.226000,0,41.910000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<27.686000,0,41.910000> texture{col_thl}}
#ifndef(global_pack_JP4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<25.146000,0,41.910000> texture{col_thl}}
#ifndef(global_pack_R1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<53.721000,0,26.035000> texture{col_thl}}
#ifndef(global_pack_R1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<53.721000,0,18.415000> texture{col_thl}}
#ifndef(global_pack_R2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<41.275000,0,33.020000> texture{col_thl}}
#ifndef(global_pack_R2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<36.195000,0,33.020000> texture{col_thl}}
#ifndef(global_pack_R2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<38.735000,0,30.480000> texture{col_thl}}
#ifndef(global_pack_R5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<48.260000,0,12.700000> texture{col_thl}}
#ifndef(global_pack_R5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<55.880000,0,12.700000> texture{col_thl}}
#ifndef(global_pack_R6) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<45.720000,0,15.240000> texture{col_thl}}
#ifndef(global_pack_R6) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<53.340000,0,15.240000> texture{col_thl}}
object{TOOLS_PCB_SMD(1.168400,1.600200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<51.435000,0.000000,33.274000>}
object{TOOLS_PCB_SMD(1.168400,1.600200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<51.435000,0.000000,31.750000>}
object{TOOLS_PCB_SMD(1.168400,1.600200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<51.435000,0.000000,30.226000>}
object{TOOLS_PCB_SMD(1.168400,1.600200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<48.260000,0.000000,33.274000>}
object{TOOLS_PCB_SMD(1.168400,1.600200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<48.260000,0.000000,31.750000>}
object{TOOLS_PCB_SMD(1.168400,1.600200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<48.260000,0.000000,30.226000>}
object{TOOLS_PCB_SMD(1.168400,1.600200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<45.085000,0.000000,33.274000>}
object{TOOLS_PCB_SMD(1.168400,1.600200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<45.085000,0.000000,31.750000>}
object{TOOLS_PCB_SMD(1.168400,1.600200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<45.085000,0.000000,30.226000>}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<62.992000,0,19.304000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<60.452000,0,19.304000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<62.992000,0,21.844000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<60.452000,0,21.844000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<62.992000,0,24.384000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<60.452000,0,24.384000> texture{col_thl}}
//Pads/Vias
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<48.260000,0,31.750000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<54.864000,0,28.956000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<39.116000,0,34.798000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<45.720000,0,38.354000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<43.307000,0,24.257000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<42.672000,0,32.893000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<44.958000,0,23.368000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<41.656000,0,30.226000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<53.721000,0,24.638000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<48.260000,0,21.590000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<46.609000,0,22.479000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<27.559000,0,38.100000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<59.055000,0,38.227000> texture{col_thl}}
#end
#if(pcb_wires=on)
union{
//Signals
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<12.700000,-1.535000,9.525000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<13.335000,-1.535000,8.382000>}
box{<0,0,-0.127000><1.307545,0.035000,0.127000> rotate<0,60.941374,0> translate<12.700000,-1.535000,9.525000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<13.335000,-1.535000,8.382000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<14.224000,-1.535000,7.493000>}
box{<0,0,-0.127000><1.257236,0.035000,0.127000> rotate<0,44.997030,0> translate<13.335000,-1.535000,8.382000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.240000,0.000000,9.525000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.875000,0.000000,10.668000>}
box{<0,0,-0.127000><1.307545,0.035000,0.127000> rotate<0,-60.941374,0> translate<15.240000,0.000000,9.525000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<16.764000,-1.535000,11.557000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<16.764000,-1.535000,32.512000>}
box{<0,0,-0.127000><20.955000,0.035000,0.127000> rotate<0,90.000000,0> translate<16.764000,-1.535000,32.512000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<16.764000,-1.535000,11.557000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.399000,-1.535000,10.922000>}
box{<0,0,-0.127000><0.898026,0.035000,0.127000> rotate<0,44.997030,0> translate<16.764000,-1.535000,11.557000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.875000,0.000000,10.668000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.653000,0.000000,12.446000>}
box{<0,0,-0.127000><2.514472,0.035000,0.127000> rotate<0,-44.997030,0> translate<15.875000,0.000000,10.668000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.399000,-1.535000,10.922000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.780000,-1.535000,9.525000>}
box{<0,0,-0.127000><1.448023,0.035000,0.127000> rotate<0,74.739948,0> translate<17.399000,-1.535000,10.922000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.780000,-1.535000,26.289000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<18.288000,-1.535000,27.305000>}
box{<0,0,-0.127000><1.135923,0.035000,0.127000> rotate<0,-63.430762,0> translate<17.780000,-1.535000,26.289000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.780000,0.000000,9.525000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<18.415000,0.000000,10.668000>}
box{<0,0,-0.127000><1.307545,0.035000,0.127000> rotate<0,-60.941374,0> translate<17.780000,0.000000,9.525000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.780000,0.000000,18.669000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<18.415000,0.000000,19.558000>}
box{<0,0,-0.127000><1.092495,0.035000,0.127000> rotate<0,-54.458728,0> translate<17.780000,0.000000,18.669000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<18.415000,0.000000,10.668000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.177000,0.000000,11.430000>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,-44.997030,0> translate<18.415000,0.000000,10.668000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.320000,-1.535000,26.289000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.574000,-1.535000,27.559000>}
box{<0,0,-0.127000><1.295151,0.035000,0.127000> rotate<0,-78.684874,0> translate<20.320000,-1.535000,26.289000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.320000,0.000000,9.525000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.955000,0.000000,8.382000>}
box{<0,0,-0.127000><1.307545,0.035000,0.127000> rotate<0,60.941374,0> translate<20.320000,0.000000,9.525000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.320000,0.000000,18.669000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.955000,0.000000,19.558000>}
box{<0,0,-0.127000><1.092495,0.035000,0.127000> rotate<0,-54.458728,0> translate<20.320000,0.000000,18.669000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.955000,0.000000,8.382000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.844000,0.000000,7.493000>}
box{<0,0,-0.127000><1.257236,0.035000,0.127000> rotate<0,44.997030,0> translate<20.955000,0.000000,8.382000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<18.415000,0.000000,19.558000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.225000,0.000000,23.368000>}
box{<0,0,-0.127000><5.388154,0.035000,0.127000> rotate<0,-44.997030,0> translate<18.415000,0.000000,19.558000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.860000,-1.535000,26.289000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<23.114000,-1.535000,27.559000>}
box{<0,0,-0.127000><1.295151,0.035000,0.127000> rotate<0,-78.684874,0> translate<22.860000,-1.535000,26.289000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.860000,0.000000,18.669000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<23.495000,0.000000,19.558000>}
box{<0,0,-0.127000><1.092495,0.035000,0.127000> rotate<0,-54.458728,0> translate<22.860000,0.000000,18.669000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.955000,0.000000,19.558000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<23.876000,0.000000,22.479000>}
box{<0,0,-0.127000><4.130918,0.035000,0.127000> rotate<0,-44.997030,0> translate<20.955000,0.000000,19.558000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.384000,-1.535000,25.146000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.384000,-1.535000,28.067000>}
box{<0,0,-0.127000><2.921000,0.035000,0.127000> rotate<0,90.000000,0> translate<24.384000,-1.535000,28.067000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<16.764000,-1.535000,32.512000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.765000,-1.535000,40.513000>}
box{<0,0,-0.127000><11.315123,0.035000,0.127000> rotate<0,-44.997030,0> translate<16.764000,-1.535000,32.512000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.765000,-1.535000,40.513000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.146000,-1.535000,41.910000>}
box{<0,0,-0.127000><1.448023,0.035000,0.127000> rotate<0,-74.739948,0> translate<24.765000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.400000,-1.535000,9.398000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.400000,-1.535000,18.669000>}
box{<0,0,-0.127000><9.271000,0.035000,0.127000> rotate<0,90.000000,0> translate<25.400000,-1.535000,18.669000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.384000,-1.535000,25.146000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.400000,-1.535000,24.130000>}
box{<0,0,-0.127000><1.436841,0.035000,0.127000> rotate<0,44.997030,0> translate<24.384000,-1.535000,25.146000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<23.495000,0.000000,19.558000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.527000,0.000000,21.590000>}
box{<0,0,-0.127000><2.873682,0.035000,0.127000> rotate<0,-44.997030,0> translate<23.495000,0.000000,19.558000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.146000,0.000000,41.910000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.781000,0.000000,40.767000>}
box{<0,0,-0.127000><1.307545,0.035000,0.127000> rotate<0,60.941374,0> translate<25.146000,0.000000,41.910000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.400000,-1.535000,26.289000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.035000,-1.535000,25.400000>}
box{<0,0,-0.127000><1.092495,0.035000,0.127000> rotate<0,54.458728,0> translate<25.400000,-1.535000,26.289000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<24.384000,-1.535000,28.067000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.416000,-1.535000,28.067000>}
box{<0,0,-0.127000><2.032000,0.035000,0.127000> rotate<0,0.000000,0> translate<24.384000,-1.535000,28.067000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.781000,0.000000,40.767000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.543000,0.000000,40.005000>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,44.997030,0> translate<25.781000,0.000000,40.767000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.035000,-1.535000,25.400000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.924000,-1.535000,25.400000>}
box{<0,0,-0.127000><0.889000,0.035000,0.127000> rotate<0,0.000000,0> translate<26.035000,-1.535000,25.400000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.924000,-1.535000,25.146000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.924000,-1.535000,25.400000>}
box{<0,0,-0.127000><0.254000,0.035000,0.127000> rotate<0,90.000000,0> translate<26.924000,-1.535000,25.400000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.416000,-1.535000,28.067000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.305000,-1.535000,27.178000>}
box{<0,0,-0.127000><1.257236,0.035000,0.127000> rotate<0,44.997030,0> translate<26.416000,-1.535000,28.067000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.924000,-1.535000,25.146000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.432000,-1.535000,24.638000>}
box{<0,0,-0.127000><0.718420,0.035000,0.127000> rotate<0,44.997030,0> translate<26.924000,-1.535000,25.146000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.559000,-1.535000,38.100000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.559000,-1.535000,40.513000>}
box{<0,0,-0.127000><2.413000,0.035000,0.127000> rotate<0,90.000000,0> translate<27.559000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.559000,-1.535000,40.513000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.686000,-1.535000,41.910000>}
box{<0,0,-0.127000><1.402761,0.035000,0.127000> rotate<0,-84.799974,0> translate<27.559000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.940000,-1.535000,9.398000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.940000,-1.535000,18.669000>}
box{<0,0,-0.127000><9.271000,0.035000,0.127000> rotate<0,90.000000,0> translate<27.940000,-1.535000,18.669000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.305000,-1.535000,27.178000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.940000,-1.535000,26.289000>}
box{<0,0,-0.127000><1.092495,0.035000,0.127000> rotate<0,54.458728,0> translate<27.305000,-1.535000,27.178000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<18.288000,-1.535000,27.305000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<29.845000,-1.535000,38.862000>}
box{<0,0,-0.127000><16.344066,0.035000,0.127000> rotate<0,-44.997030,0> translate<18.288000,-1.535000,27.305000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<29.845000,-1.535000,38.862000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<29.845000,-1.535000,40.513000>}
box{<0,0,-0.127000><1.651000,0.035000,0.127000> rotate<0,90.000000,0> translate<29.845000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<29.845000,-1.535000,40.513000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.226000,-1.535000,41.910000>}
box{<0,0,-0.127000><1.448023,0.035000,0.127000> rotate<0,-74.739948,0> translate<29.845000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,-1.535000,9.398000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,-1.535000,18.669000>}
box{<0,0,-0.127000><9.271000,0.035000,0.127000> rotate<0,90.000000,0> translate<30.480000,-1.535000,18.669000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,0.000000,26.289000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.115000,0.000000,27.178000>}
box{<0,0,-0.127000><1.092495,0.035000,0.127000> rotate<0,-54.458728,0> translate<30.480000,0.000000,26.289000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.574000,-1.535000,27.559000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<32.385000,-1.535000,39.370000>}
box{<0,0,-0.127000><16.703276,0.035000,0.127000> rotate<0,-44.997030,0> translate<20.574000,-1.535000,27.559000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<32.385000,-1.535000,39.370000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<32.385000,-1.535000,40.513000>}
box{<0,0,-0.127000><1.143000,0.035000,0.127000> rotate<0,90.000000,0> translate<32.385000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<32.385000,-1.535000,40.513000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<32.766000,-1.535000,41.910000>}
box{<0,0,-0.127000><1.448023,0.035000,0.127000> rotate<0,-74.739948,0> translate<32.385000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.020000,-1.535000,9.398000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.020000,-1.535000,18.669000>}
box{<0,0,-0.127000><9.271000,0.035000,0.127000> rotate<0,90.000000,0> translate<33.020000,-1.535000,18.669000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.020000,0.000000,26.289000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.655000,0.000000,25.400000>}
box{<0,0,-0.127000><1.092495,0.035000,0.127000> rotate<0,54.458728,0> translate<33.020000,0.000000,26.289000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.432000,-1.535000,24.638000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.544000,-1.535000,24.638000>}
box{<0,0,-0.127000><7.112000,0.035000,0.127000> rotate<0,0.000000,0> translate<27.432000,-1.535000,24.638000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.544000,-1.535000,24.638000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.544000,-1.535000,37.592000>}
box{<0,0,-0.127000><12.954000,0.035000,0.127000> rotate<0,90.000000,0> translate<34.544000,-1.535000,37.592000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.559000,0.000000,38.100000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.671000,0.000000,33.274000>}
box{<0,0,-0.127000><8.594814,0.035000,0.127000> rotate<0,34.157440,0> translate<27.559000,0.000000,38.100000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.655000,0.000000,25.400000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.798000,0.000000,24.257000>}
box{<0,0,-0.127000><1.616446,0.035000,0.127000> rotate<0,44.997030,0> translate<33.655000,0.000000,25.400000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<23.114000,-1.535000,27.559000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.925000,-1.535000,39.370000>}
box{<0,0,-0.127000><16.703276,0.035000,0.127000> rotate<0,-44.997030,0> translate<23.114000,-1.535000,27.559000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.925000,-1.535000,39.370000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.925000,-1.535000,40.513000>}
box{<0,0,-0.127000><1.143000,0.035000,0.127000> rotate<0,90.000000,0> translate<34.925000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.925000,-1.535000,40.513000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.306000,-1.535000,41.910000>}
box{<0,0,-0.127000><1.448023,0.035000,0.127000> rotate<0,-74.739948,0> translate<34.925000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.560000,-1.535000,9.398000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.560000,-1.535000,18.669000>}
box{<0,0,-0.127000><9.271000,0.035000,0.127000> rotate<0,90.000000,0> translate<35.560000,-1.535000,18.669000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.671000,0.000000,33.274000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.560000,0.000000,33.274000>}
box{<0,0,-0.127000><0.889000,0.035000,0.127000> rotate<0,0.000000,0> translate<34.671000,0.000000,33.274000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.560000,-1.535000,26.289000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.814000,-1.535000,27.559000>}
box{<0,0,-0.127000><1.295151,0.035000,0.127000> rotate<0,-78.684874,0> translate<35.560000,-1.535000,26.289000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.115000,0.000000,27.178000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.941000,0.000000,32.004000>}
box{<0,0,-0.127000><6.824995,0.035000,0.127000> rotate<0,-44.997030,0> translate<31.115000,0.000000,27.178000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.560000,0.000000,33.274000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.195000,0.000000,33.020000>}
box{<0,0,-0.127000><0.683916,0.035000,0.127000> rotate<0,21.799971,0> translate<35.560000,0.000000,33.274000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.814000,-1.535000,27.559000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.576000,-1.535000,28.321000>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,-44.997030,0> translate<35.814000,-1.535000,27.559000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.576000,-1.535000,28.321000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.576000,-1.535000,31.877000>}
box{<0,0,-0.127000><3.556000,0.035000,0.127000> rotate<0,90.000000,0> translate<36.576000,-1.535000,31.877000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.844000,0.000000,7.493000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.703000,0.000000,7.493000>}
box{<0,0,-0.127000><14.859000,0.035000,0.127000> rotate<0,0.000000,0> translate<21.844000,0.000000,7.493000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.195000,0.000000,33.020000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.830000,0.000000,33.274000>}
box{<0,0,-0.127000><0.683916,0.035000,0.127000> rotate<0,-21.799971,0> translate<36.195000,0.000000,33.020000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.400000,-1.535000,24.130000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.084000,-1.535000,24.130000>}
box{<0,0,-0.127000><11.684000,0.035000,0.127000> rotate<0,0.000000,0> translate<25.400000,-1.535000,24.130000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.084000,-1.535000,24.130000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.084000,-1.535000,31.496000>}
box{<0,0,-0.127000><7.366000,0.035000,0.127000> rotate<0,90.000000,0> translate<37.084000,-1.535000,31.496000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.703000,0.000000,7.493000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.465000,0.000000,8.255000>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,-44.997030,0> translate<36.703000,0.000000,7.493000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.830000,0.000000,33.274000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.465000,0.000000,33.909000>}
box{<0,0,-0.127000><0.898026,0.035000,0.127000> rotate<0,-44.997030,0> translate<36.830000,0.000000,33.274000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.544000,-1.535000,37.592000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.465000,-1.535000,40.513000>}
box{<0,0,-0.127000><4.130918,0.035000,0.127000> rotate<0,-44.997030,0> translate<34.544000,-1.535000,37.592000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.719000,0.000000,27.940000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.719000,0.000000,30.988000>}
box{<0,0,-0.127000><3.048000,0.035000,0.127000> rotate<0,90.000000,0> translate<37.719000,0.000000,30.988000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.846000,-1.535000,10.795000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.846000,-1.535000,14.986000>}
box{<0,0,-0.127000><4.191000,0.035000,0.127000> rotate<0,90.000000,0> translate<37.846000,-1.535000,14.986000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.846000,0.000000,14.986000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.846000,0.000000,17.399000>}
box{<0,0,-0.127000><2.413000,0.035000,0.127000> rotate<0,90.000000,0> translate<37.846000,0.000000,17.399000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.465000,-1.535000,40.513000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.846000,-1.535000,41.910000>}
box{<0,0,-0.127000><1.448023,0.035000,0.127000> rotate<0,-74.739948,0> translate<37.465000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.465000,0.000000,8.255000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.100000,0.000000,9.398000>}
box{<0,0,-0.127000><1.307545,0.035000,0.127000> rotate<0,-60.941374,0> translate<37.465000,0.000000,8.255000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.846000,-1.535000,10.795000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.100000,-1.535000,9.398000>}
box{<0,0,-0.127000><1.419903,0.035000,0.127000> rotate<0,79.689894,0> translate<37.846000,-1.535000,10.795000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.846000,0.000000,17.399000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.100000,0.000000,18.669000>}
box{<0,0,-0.127000><1.295151,0.035000,0.127000> rotate<0,-78.684874,0> translate<37.846000,0.000000,17.399000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.719000,0.000000,30.988000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.227000,0.000000,31.496000>}
box{<0,0,-0.127000><0.718420,0.035000,0.127000> rotate<0,-44.997030,0> translate<37.719000,0.000000,30.988000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.100000,0.000000,18.669000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.735000,0.000000,17.780000>}
box{<0,0,-0.127000><1.092495,0.035000,0.127000> rotate<0,54.458728,0> translate<38.100000,0.000000,18.669000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.177000,0.000000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<39.116000,0.000000,11.430000>}
box{<0,0,-0.127000><19.939000,0.035000,0.127000> rotate<0,0.000000,0> translate<19.177000,0.000000,11.430000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.576000,-1.535000,31.877000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<39.116000,-1.535000,34.417000>}
box{<0,0,-0.127000><3.592102,0.035000,0.127000> rotate<0,-44.997030,0> translate<36.576000,-1.535000,31.877000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<39.116000,-1.535000,34.417000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<39.116000,-1.535000,34.798000>}
box{<0,0,-0.127000><0.381000,0.035000,0.127000> rotate<0,90.000000,0> translate<39.116000,-1.535000,34.798000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.735000,0.000000,30.480000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<39.370000,0.000000,30.226000>}
box{<0,0,-0.127000><0.683916,0.035000,0.127000> rotate<0,21.799971,0> translate<38.735000,0.000000,30.480000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<39.116000,0.000000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.005000,0.000000,10.541000>}
box{<0,0,-0.127000><1.257236,0.035000,0.127000> rotate<0,44.997030,0> translate<39.116000,0.000000,11.430000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.084000,-1.535000,31.496000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.005000,-1.535000,34.417000>}
box{<0,0,-0.127000><4.130918,0.035000,0.127000> rotate<0,-44.997030,0> translate<37.084000,-1.535000,31.496000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.005000,-1.535000,34.417000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.005000,-1.535000,40.513000>}
box{<0,0,-0.127000><6.096000,0.035000,0.127000> rotate<0,90.000000,0> translate<40.005000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.735000,0.000000,17.780000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.259000,0.000000,16.256000>}
box{<0,0,-0.127000><2.155261,0.035000,0.127000> rotate<0,44.997030,0> translate<38.735000,0.000000,17.780000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<39.370000,0.000000,30.226000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.386000,0.000000,29.210000>}
box{<0,0,-0.127000><1.436841,0.035000,0.127000> rotate<0,44.997030,0> translate<39.370000,0.000000,30.226000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.005000,-1.535000,40.513000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.386000,-1.535000,41.910000>}
box{<0,0,-0.127000><1.448023,0.035000,0.127000> rotate<0,-74.739948,0> translate<40.005000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.005000,0.000000,10.541000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.640000,0.000000,9.398000>}
box{<0,0,-0.127000><1.307545,0.035000,0.127000> rotate<0,60.941374,0> translate<40.005000,0.000000,10.541000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.465000,0.000000,33.909000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.640000,0.000000,33.909000>}
box{<0,0,-0.127000><3.175000,0.035000,0.127000> rotate<0,0.000000,0> translate<37.465000,0.000000,33.909000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.640000,0.000000,33.909000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.767000,0.000000,34.036000>}
box{<0,0,-0.127000><0.179605,0.035000,0.127000> rotate<0,-44.997030,0> translate<40.640000,0.000000,33.909000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.640000,-1.535000,18.669000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.894000,-1.535000,17.399000>}
box{<0,0,-0.127000><1.295151,0.035000,0.127000> rotate<0,78.684874,0> translate<40.640000,-1.535000,18.669000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.640000,-1.535000,18.669000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.894000,-1.535000,19.939000>}
box{<0,0,-0.127000><1.295151,0.035000,0.127000> rotate<0,-78.684874,0> translate<40.640000,-1.535000,18.669000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.640000,-1.535000,9.398000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.021000,-1.535000,10.795000>}
box{<0,0,-0.127000><1.448023,0.035000,0.127000> rotate<0,-74.739948,0> translate<40.640000,-1.535000,9.398000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.640000,0.000000,9.398000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.275000,0.000000,8.255000>}
box{<0,0,-0.127000><1.307545,0.035000,0.127000> rotate<0,60.941374,0> translate<40.640000,0.000000,9.398000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.275000,-1.535000,33.020000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.529000,-1.535000,32.385000>}
box{<0,0,-0.127000><0.683916,0.035000,0.127000> rotate<0,68.194090,0> translate<41.275000,-1.535000,33.020000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.894000,-1.535000,19.939000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.656000,-1.535000,20.701000>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,-44.997030,0> translate<40.894000,-1.535000,19.939000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.656000,-1.535000,20.701000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.656000,-1.535000,30.226000>}
box{<0,0,-0.127000><9.525000,0.035000,0.127000> rotate<0,90.000000,0> translate<41.656000,-1.535000,30.226000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.529000,-1.535000,32.385000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.656000,-1.535000,32.258000>}
box{<0,0,-0.127000><0.179605,0.035000,0.127000> rotate<0,44.997030,0> translate<41.529000,-1.535000,32.385000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.656000,-1.535000,30.226000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.656000,-1.535000,32.258000>}
box{<0,0,-0.127000><2.032000,0.035000,0.127000> rotate<0,90.000000,0> translate<41.656000,-1.535000,32.258000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.941000,0.000000,32.004000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.783000,0.000000,32.004000>}
box{<0,0,-0.127000><5.842000,0.035000,0.127000> rotate<0,0.000000,0> translate<35.941000,0.000000,32.004000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.275000,0.000000,8.255000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.910000,0.000000,7.620000>}
box{<0,0,-0.127000><0.898026,0.035000,0.127000> rotate<0,44.997030,0> translate<41.275000,0.000000,8.255000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.021000,-1.535000,10.795000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.672000,-1.535000,12.446000>}
box{<0,0,-0.127000><2.334867,0.035000,0.127000> rotate<0,-44.997030,0> translate<41.021000,-1.535000,10.795000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.672000,-1.535000,12.446000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.672000,-1.535000,14.351000>}
box{<0,0,-0.127000><1.905000,0.035000,0.127000> rotate<0,90.000000,0> translate<42.672000,-1.535000,14.351000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.894000,-1.535000,17.399000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.672000,-1.535000,15.621000>}
box{<0,0,-0.127000><2.514472,0.035000,0.127000> rotate<0,44.997030,0> translate<40.894000,-1.535000,17.399000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.783000,0.000000,32.004000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.672000,0.000000,32.893000>}
box{<0,0,-0.127000><1.257236,0.035000,0.127000> rotate<0,-44.997030,0> translate<41.783000,0.000000,32.004000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.672000,-1.535000,32.893000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.672000,-1.535000,40.513000>}
box{<0,0,-0.127000><7.620000,0.035000,0.127000> rotate<0,90.000000,0> translate<42.672000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.672000,-1.535000,14.351000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.926000,-1.535000,14.986000>}
box{<0,0,-0.127000><0.683916,0.035000,0.127000> rotate<0,-68.194090,0> translate<42.672000,-1.535000,14.351000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.672000,-1.535000,15.621000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.926000,-1.535000,14.986000>}
box{<0,0,-0.127000><0.683916,0.035000,0.127000> rotate<0,68.194090,0> translate<42.672000,-1.535000,15.621000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.672000,-1.535000,40.513000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<42.926000,-1.535000,41.910000>}
box{<0,0,-0.127000><1.419903,0.035000,0.127000> rotate<0,-79.689894,0> translate<42.672000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.798000,0.000000,24.257000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.307000,0.000000,24.257000>}
box{<0,0,-0.127000><8.509000,0.035000,0.127000> rotate<0,0.000000,0> translate<34.798000,0.000000,24.257000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<39.116000,0.000000,34.798000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.434000,0.000000,38.354000>}
box{<0,0,-0.127000><5.593770,0.035000,0.127000> rotate<0,-39.469855,0> translate<39.116000,0.000000,34.798000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.180000,0.000000,18.669000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.815000,0.000000,19.558000>}
box{<0,0,-0.127000><1.092495,0.035000,0.127000> rotate<0,-54.458728,0> translate<43.180000,0.000000,18.669000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.180000,0.000000,26.289000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.815000,0.000000,25.400000>}
box{<0,0,-0.127000><1.092495,0.035000,0.127000> rotate<0,54.458728,0> translate<43.180000,0.000000,26.289000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.767000,0.000000,34.036000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.069000,0.000000,34.036000>}
box{<0,0,-0.127000><3.302000,0.035000,0.127000> rotate<0,0.000000,0> translate<40.767000,0.000000,34.036000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<37.719000,0.000000,27.940000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.323000,0.000000,27.940000>}
box{<0,0,-0.127000><6.604000,0.035000,0.127000> rotate<0,0.000000,0> translate<37.719000,0.000000,27.940000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.227000,0.000000,31.496000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.323000,0.000000,31.496000>}
box{<0,0,-0.127000><6.096000,0.035000,0.127000> rotate<0,0.000000,0> translate<38.227000,0.000000,31.496000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.069000,0.000000,34.036000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.323000,0.000000,33.782000>}
box{<0,0,-0.127000><0.359210,0.035000,0.127000> rotate<0,44.997030,0> translate<44.069000,0.000000,34.036000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.815000,0.000000,25.400000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.577000,0.000000,24.638000>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,44.997030,0> translate<43.815000,0.000000,25.400000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.307000,-1.535000,24.257000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.704000,-1.535000,25.654000>}
box{<0,0,-0.127000><1.975656,0.035000,0.127000> rotate<0,-44.997030,0> translate<43.307000,-1.535000,24.257000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.704000,-1.535000,25.654000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.704000,-1.535000,40.132000>}
box{<0,0,-0.127000><14.478000,0.035000,0.127000> rotate<0,90.000000,0> translate<44.704000,-1.535000,40.132000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.815000,0.000000,19.558000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.958000,0.000000,20.701000>}
box{<0,0,-0.127000><1.616446,0.035000,0.127000> rotate<0,-44.997030,0> translate<43.815000,0.000000,19.558000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<22.225000,0.000000,23.368000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.958000,0.000000,23.368000>}
box{<0,0,-0.127000><22.733000,0.035000,0.127000> rotate<0,0.000000,0> translate<22.225000,0.000000,23.368000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<14.224000,-1.535000,7.493000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.085000,-1.535000,7.493000>}
box{<0,0,-0.127000><30.861000,0.035000,0.127000> rotate<0,0.000000,0> translate<14.224000,-1.535000,7.493000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.085000,-1.535000,7.493000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.085000,-1.535000,8.382000>}
box{<0,0,-0.127000><0.889000,0.035000,0.127000> rotate<0,90.000000,0> translate<45.085000,-1.535000,8.382000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.323000,0.000000,27.940000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.085000,0.000000,27.178000>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,44.997030,0> translate<44.323000,0.000000,27.940000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.656000,0.000000,30.226000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.085000,0.000000,30.226000>}
box{<0,0,-0.127000><3.429000,0.035000,0.127000> rotate<0,0.000000,0> translate<41.656000,0.000000,30.226000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.323000,0.000000,31.496000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.085000,0.000000,31.750000>}
box{<0,0,-0.127000><0.803219,0.035000,0.127000> rotate<0,-18.433732,0> translate<44.323000,0.000000,31.496000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.323000,0.000000,33.782000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.085000,0.000000,33.274000>}
box{<0,0,-0.127000><0.915810,0.035000,0.127000> rotate<0,33.687844,0> translate<44.323000,0.000000,33.782000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.704000,-1.535000,40.132000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.085000,-1.535000,40.513000>}
box{<0,0,-0.127000><0.538815,0.035000,0.127000> rotate<0,-44.997030,0> translate<44.704000,-1.535000,40.132000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.085000,-1.535000,40.513000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.466000,-1.535000,41.910000>}
box{<0,0,-0.127000><1.448023,0.035000,0.127000> rotate<0,-74.739948,0> translate<45.085000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.085000,-1.535000,8.382000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.720000,-1.535000,9.525000>}
box{<0,0,-0.127000><1.307545,0.035000,0.127000> rotate<0,-60.941374,0> translate<45.085000,-1.535000,8.382000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.720000,-1.535000,9.525000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.720000,-1.535000,15.240000>}
box{<0,0,-0.127000><5.715000,0.035000,0.127000> rotate<0,90.000000,0> translate<45.720000,-1.535000,15.240000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.720000,-1.535000,15.240000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.720000,-1.535000,18.669000>}
box{<0,0,-0.127000><3.429000,0.035000,0.127000> rotate<0,90.000000,0> translate<45.720000,-1.535000,18.669000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.085000,0.000000,27.178000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.720000,0.000000,26.289000>}
box{<0,0,-0.127000><1.092495,0.035000,0.127000> rotate<0,54.458728,0> translate<45.085000,0.000000,27.178000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.434000,0.000000,38.354000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.720000,0.000000,38.354000>}
box{<0,0,-0.127000><2.286000,0.035000,0.127000> rotate<0,0.000000,0> translate<43.434000,0.000000,38.354000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.720000,0.000000,15.240000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<46.355000,0.000000,14.986000>}
box{<0,0,-0.127000><0.683916,0.035000,0.127000> rotate<0,21.799971,0> translate<45.720000,0.000000,15.240000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<23.876000,0.000000,22.479000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<46.609000,0.000000,22.479000>}
box{<0,0,-0.127000><22.733000,0.035000,0.127000> rotate<0,0.000000,0> translate<23.876000,0.000000,22.479000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<46.355000,0.000000,14.986000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<47.117000,0.000000,14.224000>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,44.997030,0> translate<46.355000,0.000000,14.986000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.958000,-1.535000,23.368000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<47.244000,-1.535000,25.654000>}
box{<0,0,-0.127000><3.232892,0.035000,0.127000> rotate<0,-44.997030,0> translate<44.958000,-1.535000,23.368000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<47.244000,-1.535000,25.654000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<47.244000,-1.535000,37.592000>}
box{<0,0,-0.127000><11.938000,0.035000,0.127000> rotate<0,90.000000,0> translate<47.244000,-1.535000,37.592000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.720000,-1.535000,38.354000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<47.371000,-1.535000,40.767000>}
box{<0,0,-0.127000><2.923760,0.035000,0.127000> rotate<0,-55.615985,0> translate<45.720000,-1.535000,38.354000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.653000,0.000000,12.446000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<47.625000,0.000000,12.446000>}
box{<0,0,-0.127000><29.972000,0.035000,0.127000> rotate<0,0.000000,0> translate<17.653000,0.000000,12.446000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<47.371000,-1.535000,40.767000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.006000,-1.535000,41.910000>}
box{<0,0,-0.127000><1.307545,0.035000,0.127000> rotate<0,-60.941374,0> translate<47.371000,-1.535000,40.767000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.260000,0.000000,12.700000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.260000,0.000000,9.525000>}
box{<0,0,-0.127000><3.175000,0.035000,0.127000> rotate<0,-90.000000,0> translate<48.260000,0.000000,9.525000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<47.625000,0.000000,12.446000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.260000,0.000000,12.700000>}
box{<0,0,-0.127000><0.683916,0.035000,0.127000> rotate<0,-21.799971,0> translate<47.625000,0.000000,12.446000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.260000,-1.535000,12.700000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.260000,-1.535000,18.669000>}
box{<0,0,-0.127000><5.969000,0.035000,0.127000> rotate<0,90.000000,0> translate<48.260000,-1.535000,18.669000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<25.527000,0.000000,21.590000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.260000,0.000000,21.590000>}
box{<0,0,-0.127000><22.733000,0.035000,0.127000> rotate<0,0.000000,0> translate<25.527000,0.000000,21.590000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.085000,0.000000,30.226000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.260000,0.000000,30.226000>}
box{<0,0,-0.127000><3.175000,0.035000,0.127000> rotate<0,0.000000,0> translate<45.085000,0.000000,30.226000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.260000,-1.535000,26.289000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.260000,-1.535000,31.750000>}
box{<0,0,-0.127000><5.461000,0.035000,0.127000> rotate<0,90.000000,0> translate<48.260000,-1.535000,31.750000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.085000,0.000000,33.274000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.260000,0.000000,33.274000>}
box{<0,0,-0.127000><3.175000,0.035000,0.127000> rotate<0,0.000000,0> translate<45.085000,0.000000,33.274000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.260000,0.000000,18.669000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.895000,0.000000,19.558000>}
box{<0,0,-0.127000><1.092495,0.035000,0.127000> rotate<0,-54.458728,0> translate<48.260000,0.000000,18.669000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.958000,0.000000,20.701000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.276000,0.000000,20.701000>}
box{<0,0,-0.127000><4.318000,0.035000,0.127000> rotate<0,0.000000,0> translate<44.958000,0.000000,20.701000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<41.910000,0.000000,7.620000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.403000,0.000000,7.620000>}
box{<0,0,-0.127000><7.493000,0.035000,0.127000> rotate<0,0.000000,0> translate<41.910000,0.000000,7.620000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.895000,0.000000,19.558000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.784000,0.000000,20.447000>}
box{<0,0,-0.127000><1.257236,0.035000,0.127000> rotate<0,-44.997030,0> translate<48.895000,0.000000,19.558000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<46.609000,-1.535000,22.479000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.784000,-1.535000,25.654000>}
box{<0,0,-0.127000><4.490128,0.035000,0.127000> rotate<0,-44.997030,0> translate<46.609000,-1.535000,22.479000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.784000,-1.535000,25.654000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.784000,-1.535000,30.480000>}
box{<0,0,-0.127000><4.826000,0.035000,0.127000> rotate<0,90.000000,0> translate<49.784000,-1.535000,30.480000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.403000,0.000000,7.620000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.165000,0.000000,8.382000>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,-44.997030,0> translate<49.403000,0.000000,7.620000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<47.244000,-1.535000,37.592000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.165000,-1.535000,40.513000>}
box{<0,0,-0.127000><4.130918,0.035000,0.127000> rotate<0,-44.997030,0> translate<47.244000,-1.535000,37.592000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.165000,-1.535000,40.513000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.546000,-1.535000,41.910000>}
box{<0,0,-0.127000><1.448023,0.035000,0.127000> rotate<0,-74.739948,0> translate<50.165000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.165000,0.000000,8.382000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.800000,0.000000,9.525000>}
box{<0,0,-0.127000><1.307545,0.035000,0.127000> rotate<0,-60.941374,0> translate<50.165000,0.000000,8.382000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.800000,-1.535000,18.669000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.054000,-1.535000,17.399000>}
box{<0,0,-0.127000><1.295151,0.035000,0.127000> rotate<0,78.684874,0> translate<50.800000,-1.535000,18.669000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.800000,0.000000,26.289000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.054000,0.000000,27.559000>}
box{<0,0,-0.127000><1.295151,0.035000,0.127000> rotate<0,-78.684874,0> translate<50.800000,0.000000,26.289000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.181000,-1.535000,8.128000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.181000,-1.535000,7.620000>}
box{<0,0,-0.127000><0.508000,0.035000,0.127000> rotate<0,-90.000000,0> translate<51.181000,-1.535000,7.620000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<50.800000,-1.535000,9.525000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.181000,-1.535000,8.128000>}
box{<0,0,-0.127000><1.448023,0.035000,0.127000> rotate<0,74.739948,0> translate<50.800000,-1.535000,9.525000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.260000,0.000000,30.226000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.435000,0.000000,30.226000>}
box{<0,0,-0.127000><3.175000,0.035000,0.127000> rotate<0,0.000000,0> translate<48.260000,0.000000,30.226000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.260000,0.000000,33.274000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.435000,0.000000,33.274000>}
box{<0,0,-0.127000><3.175000,0.035000,0.127000> rotate<0,0.000000,0> translate<48.260000,0.000000,33.274000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.259000,0.000000,16.256000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.943000,0.000000,16.256000>}
box{<0,0,-0.127000><11.684000,0.035000,0.127000> rotate<0,0.000000,0> translate<40.259000,0.000000,16.256000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.435000,0.000000,31.750000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.197000,0.000000,31.242000>}
box{<0,0,-0.127000><0.915810,0.035000,0.127000> rotate<0,33.687844,0> translate<51.435000,0.000000,31.750000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.435000,0.000000,33.274000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.197000,0.000000,32.766000>}
box{<0,0,-0.127000><0.915810,0.035000,0.127000> rotate<0,33.687844,0> translate<51.435000,0.000000,33.274000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.054000,-1.535000,17.399000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.324000,-1.535000,16.129000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,44.997030,0> translate<51.054000,-1.535000,17.399000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.324000,-1.535000,14.732000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.324000,-1.535000,16.129000>}
box{<0,0,-0.127000><1.397000,0.035000,0.127000> rotate<0,90.000000,0> translate<52.324000,-1.535000,16.129000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.276000,0.000000,20.701000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.324000,0.000000,23.749000>}
box{<0,0,-0.127000><4.310523,0.035000,0.127000> rotate<0,-44.997030,0> translate<49.276000,0.000000,20.701000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.943000,0.000000,16.256000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.705000,0.000000,15.494000>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,44.997030,0> translate<51.943000,0.000000,16.256000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.260000,-1.535000,21.590000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.705000,-1.535000,26.035000>}
box{<0,0,-0.127000><6.286179,0.035000,0.127000> rotate<0,-44.997030,0> translate<48.260000,-1.535000,21.590000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.705000,-1.535000,26.035000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.705000,-1.535000,32.639000>}
box{<0,0,-0.127000><6.604000,0.035000,0.127000> rotate<0,90.000000,0> translate<52.705000,-1.535000,32.639000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.784000,-1.535000,30.480000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.705000,-1.535000,33.401000>}
box{<0,0,-0.127000><4.130918,0.035000,0.127000> rotate<0,-44.997030,0> translate<49.784000,-1.535000,30.480000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.705000,-1.535000,33.401000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.705000,-1.535000,40.513000>}
box{<0,0,-0.127000><7.112000,0.035000,0.127000> rotate<0,90.000000,0> translate<52.705000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.197000,0.000000,31.242000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.832000,0.000000,31.242000>}
box{<0,0,-0.127000><0.635000,0.035000,0.127000> rotate<0,0.000000,0> translate<52.197000,0.000000,31.242000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.705000,-1.535000,40.513000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.086000,-1.535000,41.910000>}
box{<0,0,-0.127000><1.448023,0.035000,0.127000> rotate<0,-74.739948,0> translate<52.705000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.705000,0.000000,15.494000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.340000,0.000000,15.240000>}
box{<0,0,-0.127000><0.683916,0.035000,0.127000> rotate<0,21.799971,0> translate<52.705000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.340000,-1.535000,15.240000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.594000,-1.535000,15.875000>}
box{<0,0,-0.127000><0.683916,0.035000,0.127000> rotate<0,-68.194090,0> translate<53.340000,-1.535000,15.240000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.340000,0.000000,9.525000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.721000,0.000000,10.922000>}
box{<0,0,-0.127000><1.448023,0.035000,0.127000> rotate<0,-74.739948,0> translate<53.340000,0.000000,9.525000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.721000,-1.535000,24.638000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.721000,-1.535000,18.415000>}
box{<0,0,-0.127000><6.223000,0.035000,0.127000> rotate<0,-90.000000,0> translate<53.721000,-1.535000,18.415000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.577000,0.000000,24.638000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.721000,0.000000,24.638000>}
box{<0,0,-0.127000><9.144000,0.035000,0.127000> rotate<0,0.000000,0> translate<44.577000,0.000000,24.638000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.181000,-1.535000,7.620000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.848000,-1.535000,7.620000>}
box{<0,0,-0.127000><2.667000,0.035000,0.127000> rotate<0,0.000000,0> translate<51.181000,-1.535000,7.620000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.340000,-1.535000,15.240000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.975000,-1.535000,14.986000>}
box{<0,0,-0.127000><0.683916,0.035000,0.127000> rotate<0,21.799971,0> translate<53.340000,-1.535000,15.240000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.340000,0.000000,15.240000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.975000,0.000000,15.494000>}
box{<0,0,-0.127000><0.683916,0.035000,0.127000> rotate<0,-21.799971,0> translate<53.340000,0.000000,15.240000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.721000,-1.535000,26.035000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.102000,-1.535000,25.527000>}
box{<0,0,-0.127000><0.635000,0.035000,0.127000> rotate<0,53.126596,0> translate<53.721000,-1.535000,26.035000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.721000,0.000000,26.035000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.229000,0.000000,26.416000>}
box{<0,0,-0.127000><0.635000,0.035000,0.127000> rotate<0,-36.867464,0> translate<53.721000,0.000000,26.035000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.197000,0.000000,32.766000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.356000,0.000000,32.766000>}
box{<0,0,-0.127000><2.159000,0.035000,0.127000> rotate<0,0.000000,0> translate<52.197000,0.000000,32.766000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.594000,-1.535000,15.875000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.737000,-1.535000,17.018000>}
box{<0,0,-0.127000><1.616446,0.035000,0.127000> rotate<0,-44.997030,0> translate<53.594000,-1.535000,15.875000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.102000,-1.535000,25.527000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.737000,-1.535000,24.892000>}
box{<0,0,-0.127000><0.898026,0.035000,0.127000> rotate<0,44.997030,0> translate<54.102000,-1.535000,25.527000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.737000,-1.535000,17.018000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.737000,-1.535000,24.892000>}
box{<0,0,-0.127000><7.874000,0.035000,0.127000> rotate<0,90.000000,0> translate<54.737000,-1.535000,24.892000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<40.386000,0.000000,29.210000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.864000,0.000000,28.956000>}
box{<0,0,-0.127000><14.480228,0.035000,0.127000> rotate<0,1.005020,0> translate<40.386000,0.000000,29.210000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.721000,0.000000,10.922000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.245000,0.000000,12.446000>}
box{<0,0,-0.127000><2.155261,0.035000,0.127000> rotate<0,-44.997030,0> translate<53.721000,0.000000,10.922000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.705000,-1.535000,32.639000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.245000,-1.535000,35.179000>}
box{<0,0,-0.127000><3.592102,0.035000,0.127000> rotate<0,-44.997030,0> translate<52.705000,-1.535000,32.639000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.245000,-1.535000,35.179000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.245000,-1.535000,40.513000>}
box{<0,0,-0.127000><5.334000,0.035000,0.127000> rotate<0,90.000000,0> translate<55.245000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.324000,-1.535000,14.732000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.372000,-1.535000,11.684000>}
box{<0,0,-0.127000><4.310523,0.035000,0.127000> rotate<0,44.997030,0> translate<52.324000,-1.535000,14.732000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.975000,-1.535000,14.986000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.626000,-1.535000,13.335000>}
box{<0,0,-0.127000><2.334867,0.035000,0.127000> rotate<0,44.997030,0> translate<53.975000,-1.535000,14.986000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.245000,-1.535000,40.513000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.626000,-1.535000,41.910000>}
box{<0,0,-0.127000><1.448023,0.035000,0.127000> rotate<0,-74.739948,0> translate<55.245000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<51.054000,0.000000,27.559000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.753000,0.000000,28.067000>}
box{<0,0,-0.127000><4.726380,0.035000,0.127000> rotate<0,-6.169768,0> translate<51.054000,0.000000,27.559000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.832000,0.000000,31.242000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.753000,0.000000,30.861000>}
box{<0,0,-0.127000><2.945743,0.035000,0.127000> rotate<0,7.430918,0> translate<52.832000,0.000000,31.242000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.753000,0.000000,28.067000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.753000,0.000000,30.861000>}
box{<0,0,-0.127000><2.794000,0.035000,0.127000> rotate<0,90.000000,0> translate<55.753000,0.000000,30.861000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.245000,0.000000,12.446000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.880000,0.000000,12.700000>}
box{<0,0,-0.127000><0.683916,0.035000,0.127000> rotate<0,-21.799971,0> translate<55.245000,0.000000,12.446000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.626000,-1.535000,13.335000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.880000,-1.535000,12.700000>}
box{<0,0,-0.127000><0.683916,0.035000,0.127000> rotate<0,68.194090,0> translate<55.626000,-1.535000,13.335000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.229000,0.000000,26.416000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.515000,0.000000,27.178000>}
box{<0,0,-0.127000><2.409656,0.035000,0.127000> rotate<0,-18.433732,0> translate<54.229000,0.000000,26.416000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.356000,0.000000,32.766000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.515000,0.000000,32.766000>}
box{<0,0,-0.127000><2.159000,0.035000,0.127000> rotate<0,0.000000,0> translate<54.356000,0.000000,32.766000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.515000,0.000000,27.178000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<56.515000,0.000000,32.766000>}
box{<0,0,-0.127000><5.588000,0.035000,0.127000> rotate<0,90.000000,0> translate<56.515000,0.000000,32.766000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<55.372000,-1.535000,11.684000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.150000,-1.535000,11.684000>}
box{<0,0,-0.127000><1.778000,0.035000,0.127000> rotate<0,0.000000,0> translate<55.372000,-1.535000,11.684000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.150000,-1.535000,11.684000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.150000,-1.535000,18.161000>}
box{<0,0,-0.127000><6.477000,0.035000,0.127000> rotate<0,90.000000,0> translate<57.150000,-1.535000,18.161000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.848000,-1.535000,7.620000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.658000,-1.535000,11.430000>}
box{<0,0,-0.127000><5.388154,0.035000,0.127000> rotate<0,-44.997030,0> translate<53.848000,-1.535000,7.620000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.658000,-1.535000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.658000,-1.535000,16.129000>}
box{<0,0,-0.127000><4.699000,0.035000,0.127000> rotate<0,90.000000,0> translate<57.658000,-1.535000,16.129000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.864000,-1.535000,28.956000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.785000,-1.535000,33.401000>}
box{<0,0,-0.127000><5.318859,0.035000,0.127000> rotate<0,-56.685628,0> translate<54.864000,-1.535000,28.956000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.785000,-1.535000,33.401000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.785000,-1.535000,40.513000>}
box{<0,0,-0.127000><7.112000,0.035000,0.127000> rotate<0,90.000000,0> translate<57.785000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.785000,-1.535000,40.513000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.166000,-1.535000,41.910000>}
box{<0,0,-0.127000><1.448023,0.035000,0.127000> rotate<0,-74.739948,0> translate<57.785000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<53.975000,0.000000,15.494000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.801000,0.000000,15.494000>}
box{<0,0,-0.127000><4.826000,0.035000,0.127000> rotate<0,0.000000,0> translate<53.975000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<54.356000,0.000000,32.766000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.055000,0.000000,38.227000>}
box{<0,0,-0.127000><7.204382,0.035000,0.127000> rotate<0,-49.285900,0> translate<54.356000,0.000000,32.766000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.658000,-1.535000,16.129000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.198000,-1.535000,18.669000>}
box{<0,0,-0.127000><3.592102,0.035000,0.127000> rotate<0,-44.997030,0> translate<57.658000,-1.535000,16.129000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<57.150000,-1.535000,18.161000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.198000,-1.535000,21.209000>}
box{<0,0,-0.127000><4.310523,0.035000,0.127000> rotate<0,-44.997030,0> translate<57.150000,-1.535000,18.161000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<52.324000,0.000000,23.749000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.198000,0.000000,23.749000>}
box{<0,0,-0.127000><7.874000,0.035000,0.127000> rotate<0,0.000000,0> translate<52.324000,0.000000,23.749000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<59.055000,-1.535000,38.227000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.325000,-1.535000,40.513000>}
box{<0,0,-0.127000><2.615090,0.035000,0.127000> rotate<0,-60.941374,0> translate<59.055000,-1.535000,38.227000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.198000,-1.535000,18.669000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.452000,-1.535000,19.304000>}
box{<0,0,-0.127000><0.683916,0.035000,0.127000> rotate<0,-68.194090,0> translate<60.198000,-1.535000,18.669000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.198000,-1.535000,21.209000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.452000,-1.535000,21.844000>}
box{<0,0,-0.127000><0.683916,0.035000,0.127000> rotate<0,-68.194090,0> translate<60.198000,-1.535000,21.209000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.198000,0.000000,23.749000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.452000,0.000000,24.384000>}
box{<0,0,-0.127000><0.683916,0.035000,0.127000> rotate<0,-68.194090,0> translate<60.198000,0.000000,23.749000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.325000,-1.535000,40.513000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<60.706000,-1.535000,41.910000>}
box{<0,0,-0.127000><1.448023,0.035000,0.127000> rotate<0,-74.739948,0> translate<60.325000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<49.784000,0.000000,20.447000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.214000,0.000000,20.447000>}
box{<0,0,-0.127000><11.430000,0.035000,0.127000> rotate<0,0.000000,0> translate<49.784000,0.000000,20.447000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.543000,0.000000,40.005000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.849000,0.000000,40.005000>}
box{<0,0,-0.127000><35.306000,0.035000,0.127000> rotate<0,0.000000,0> translate<26.543000,0.000000,40.005000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<58.801000,0.000000,15.494000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.357000,0.000000,19.050000>}
box{<0,0,-0.127000><5.028943,0.035000,0.127000> rotate<0,-44.997030,0> translate<58.801000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.214000,0.000000,20.447000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.357000,0.000000,21.590000>}
box{<0,0,-0.127000><1.616446,0.035000,0.127000> rotate<0,-44.997030,0> translate<61.214000,0.000000,20.447000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<61.849000,0.000000,40.005000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.611000,0.000000,40.767000>}
box{<0,0,-0.127000><1.077631,0.035000,0.127000> rotate<0,-44.997030,0> translate<61.849000,0.000000,40.005000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.357000,0.000000,19.050000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.992000,0.000000,19.304000>}
box{<0,0,-0.127000><0.683916,0.035000,0.127000> rotate<0,-21.799971,0> translate<62.357000,0.000000,19.050000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.357000,0.000000,21.590000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.992000,0.000000,21.844000>}
box{<0,0,-0.127000><0.683916,0.035000,0.127000> rotate<0,-21.799971,0> translate<62.357000,0.000000,21.590000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.992000,0.000000,24.384000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.246000,0.000000,23.749000>}
box{<0,0,-0.127000><0.683916,0.035000,0.127000> rotate<0,68.194090,0> translate<62.992000,0.000000,24.384000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<62.611000,0.000000,40.767000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.246000,0.000000,41.910000>}
box{<0,0,-0.127000><1.307545,0.035000,0.127000> rotate<0,-60.941374,0> translate<62.611000,0.000000,40.767000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<47.117000,0.000000,14.224000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.135000,0.000000,14.224000>}
box{<0,0,-0.127000><17.018000,0.035000,0.127000> rotate<0,0.000000,0> translate<47.117000,0.000000,14.224000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<63.246000,0.000000,23.749000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.135000,0.000000,22.860000>}
box{<0,0,-0.127000><1.257236,0.035000,0.127000> rotate<0,44.997030,0> translate<63.246000,0.000000,23.749000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.135000,0.000000,14.224000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<64.135000,0.000000,22.860000>}
box{<0,0,-0.127000><8.636000,0.035000,0.127000> rotate<0,90.000000,0> translate<64.135000,0.000000,22.860000> }
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
cylinder{<37.846000,0.038000,14.986000><37.846000,-1.538000,14.986000>0.406400}
cylinder{<42.926000,0.038000,14.986000><42.926000,-1.538000,14.986000>0.406400}
cylinder{<17.780000,0.038000,18.669000><17.780000,-1.538000,18.669000>0.406400}
cylinder{<20.320000,0.038000,18.669000><20.320000,-1.538000,18.669000>0.406400}
cylinder{<22.860000,0.038000,18.669000><22.860000,-1.538000,18.669000>0.406400}
cylinder{<25.400000,0.038000,18.669000><25.400000,-1.538000,18.669000>0.406400}
cylinder{<27.940000,0.038000,18.669000><27.940000,-1.538000,18.669000>0.406400}
cylinder{<30.480000,0.038000,18.669000><30.480000,-1.538000,18.669000>0.406400}
cylinder{<33.020000,0.038000,18.669000><33.020000,-1.538000,18.669000>0.406400}
cylinder{<35.560000,0.038000,18.669000><35.560000,-1.538000,18.669000>0.406400}
cylinder{<38.100000,0.038000,18.669000><38.100000,-1.538000,18.669000>0.406400}
cylinder{<40.640000,0.038000,18.669000><40.640000,-1.538000,18.669000>0.406400}
cylinder{<43.180000,0.038000,18.669000><43.180000,-1.538000,18.669000>0.406400}
cylinder{<45.720000,0.038000,18.669000><45.720000,-1.538000,18.669000>0.406400}
cylinder{<48.260000,0.038000,18.669000><48.260000,-1.538000,18.669000>0.406400}
cylinder{<50.800000,0.038000,18.669000><50.800000,-1.538000,18.669000>0.406400}
cylinder{<50.800000,0.038000,26.289000><50.800000,-1.538000,26.289000>0.406400}
cylinder{<48.260000,0.038000,26.289000><48.260000,-1.538000,26.289000>0.406400}
cylinder{<45.720000,0.038000,26.289000><45.720000,-1.538000,26.289000>0.406400}
cylinder{<43.180000,0.038000,26.289000><43.180000,-1.538000,26.289000>0.406400}
cylinder{<40.640000,0.038000,26.289000><40.640000,-1.538000,26.289000>0.406400}
cylinder{<38.100000,0.038000,26.289000><38.100000,-1.538000,26.289000>0.406400}
cylinder{<35.560000,0.038000,26.289000><35.560000,-1.538000,26.289000>0.406400}
cylinder{<33.020000,0.038000,26.289000><33.020000,-1.538000,26.289000>0.406400}
cylinder{<30.480000,0.038000,26.289000><30.480000,-1.538000,26.289000>0.406400}
cylinder{<27.940000,0.038000,26.289000><27.940000,-1.538000,26.289000>0.406400}
cylinder{<25.400000,0.038000,26.289000><25.400000,-1.538000,26.289000>0.406400}
cylinder{<22.860000,0.038000,26.289000><22.860000,-1.538000,26.289000>0.406400}
cylinder{<20.320000,0.038000,26.289000><20.320000,-1.538000,26.289000>0.406400}
cylinder{<17.780000,0.038000,26.289000><17.780000,-1.538000,26.289000>0.406400}
cylinder{<40.640000,0.038000,9.398000><40.640000,-1.538000,9.398000>0.508000}
cylinder{<38.100000,0.038000,9.398000><38.100000,-1.538000,9.398000>0.508000}
cylinder{<35.560000,0.038000,9.398000><35.560000,-1.538000,9.398000>0.508000}
cylinder{<33.020000,0.038000,9.398000><33.020000,-1.538000,9.398000>0.508000}
cylinder{<30.480000,0.038000,9.398000><30.480000,-1.538000,9.398000>0.508000}
cylinder{<27.940000,0.038000,9.398000><27.940000,-1.538000,9.398000>0.508000}
cylinder{<25.400000,0.038000,9.398000><25.400000,-1.538000,9.398000>0.508000}
cylinder{<45.720000,0.038000,9.525000><45.720000,-1.538000,9.525000>0.508000}
cylinder{<48.260000,0.038000,9.525000><48.260000,-1.538000,9.525000>0.508000}
cylinder{<50.800000,0.038000,9.525000><50.800000,-1.538000,9.525000>0.508000}
cylinder{<53.340000,0.038000,9.525000><53.340000,-1.538000,9.525000>0.508000}
cylinder{<12.700000,0.038000,9.525000><12.700000,-1.538000,9.525000>0.508000}
cylinder{<15.240000,0.038000,9.525000><15.240000,-1.538000,9.525000>0.508000}
cylinder{<17.780000,0.038000,9.525000><17.780000,-1.538000,9.525000>0.508000}
cylinder{<20.320000,0.038000,9.525000><20.320000,-1.538000,9.525000>0.508000}
cylinder{<63.246000,0.038000,41.910000><63.246000,-1.538000,41.910000>0.508000}
cylinder{<60.706000,0.038000,41.910000><60.706000,-1.538000,41.910000>0.508000}
cylinder{<58.166000,0.038000,41.910000><58.166000,-1.538000,41.910000>0.508000}
cylinder{<55.626000,0.038000,41.910000><55.626000,-1.538000,41.910000>0.508000}
cylinder{<53.086000,0.038000,41.910000><53.086000,-1.538000,41.910000>0.508000}
cylinder{<50.546000,0.038000,41.910000><50.546000,-1.538000,41.910000>0.508000}
cylinder{<48.006000,0.038000,41.910000><48.006000,-1.538000,41.910000>0.508000}
cylinder{<45.466000,0.038000,41.910000><45.466000,-1.538000,41.910000>0.508000}
cylinder{<42.926000,0.038000,41.910000><42.926000,-1.538000,41.910000>0.508000}
cylinder{<40.386000,0.038000,41.910000><40.386000,-1.538000,41.910000>0.508000}
cylinder{<37.846000,0.038000,41.910000><37.846000,-1.538000,41.910000>0.508000}
cylinder{<35.306000,0.038000,41.910000><35.306000,-1.538000,41.910000>0.508000}
cylinder{<32.766000,0.038000,41.910000><32.766000,-1.538000,41.910000>0.508000}
cylinder{<30.226000,0.038000,41.910000><30.226000,-1.538000,41.910000>0.508000}
cylinder{<27.686000,0.038000,41.910000><27.686000,-1.538000,41.910000>0.508000}
cylinder{<25.146000,0.038000,41.910000><25.146000,-1.538000,41.910000>0.508000}
cylinder{<53.721000,0.038000,26.035000><53.721000,-1.538000,26.035000>0.406400}
cylinder{<53.721000,0.038000,18.415000><53.721000,-1.538000,18.415000>0.406400}
cylinder{<41.275000,0.038000,33.020000><41.275000,-1.538000,33.020000>0.406400}
cylinder{<36.195000,0.038000,33.020000><36.195000,-1.538000,33.020000>0.406400}
cylinder{<38.735000,0.038000,30.480000><38.735000,-1.538000,30.480000>0.406400}
cylinder{<48.260000,0.038000,12.700000><48.260000,-1.538000,12.700000>0.406400}
cylinder{<55.880000,0.038000,12.700000><55.880000,-1.538000,12.700000>0.406400}
cylinder{<45.720000,0.038000,15.240000><45.720000,-1.538000,15.240000>0.406400}
cylinder{<53.340000,0.038000,15.240000><53.340000,-1.538000,15.240000>0.406400}
cylinder{<62.992000,0.038000,19.304000><62.992000,-1.538000,19.304000>0.457200}
cylinder{<60.452000,0.038000,19.304000><60.452000,-1.538000,19.304000>0.457200}
cylinder{<62.992000,0.038000,21.844000><62.992000,-1.538000,21.844000>0.457200}
cylinder{<60.452000,0.038000,21.844000><60.452000,-1.538000,21.844000>0.457200}
cylinder{<62.992000,0.038000,24.384000><62.992000,-1.538000,24.384000>0.457200}
cylinder{<60.452000,0.038000,24.384000><60.452000,-1.538000,24.384000>0.457200}
//Holes(fast)/Vias
cylinder{<48.260000,0.038000,31.750000><48.260000,-1.538000,31.750000>0.304800 }
cylinder{<54.864000,0.038000,28.956000><54.864000,-1.538000,28.956000>0.304800 }
cylinder{<39.116000,0.038000,34.798000><39.116000,-1.538000,34.798000>0.304800 }
cylinder{<45.720000,0.038000,38.354000><45.720000,-1.538000,38.354000>0.304800 }
cylinder{<43.307000,0.038000,24.257000><43.307000,-1.538000,24.257000>0.304800 }
cylinder{<42.672000,0.038000,32.893000><42.672000,-1.538000,32.893000>0.304800 }
cylinder{<44.958000,0.038000,23.368000><44.958000,-1.538000,23.368000>0.304800 }
cylinder{<41.656000,0.038000,30.226000><41.656000,-1.538000,30.226000>0.304800 }
cylinder{<53.721000,0.038000,24.638000><53.721000,-1.538000,24.638000>0.304800 }
cylinder{<48.260000,0.038000,21.590000><48.260000,-1.538000,21.590000>0.304800 }
cylinder{<46.609000,0.038000,22.479000><46.609000,-1.538000,22.479000>0.304800 }
cylinder{<27.559000,0.038000,38.100000><27.559000,-1.538000,38.100000>0.304800 }
cylinder{<59.055000,0.038000,38.227000><59.055000,-1.538000,38.227000>0.304800 }
//Holes(fast)/Board
texture{col_hls}
}
#if(pcb_silkscreen=on)
//Silk Screen
union{
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.876200,0.000000,34.891300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.876200,0.000000,35.976000>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,90.000000,0> translate<50.876200,0.000000,35.976000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.876200,0.000000,35.976000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.147300,0.000000,36.247100>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<50.876200,0.000000,35.976000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.147300,0.000000,36.247100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.689600,0.000000,36.247100>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<51.147300,0.000000,36.247100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.689600,0.000000,36.247100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.960800,0.000000,35.976000>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,44.986466,0> translate<51.689600,0.000000,36.247100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.960800,0.000000,35.976000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.960800,0.000000,34.891300>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,-90.000000,0> translate<51.960800,0.000000,34.891300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.960800,0.000000,34.891300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.689600,0.000000,34.620200>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-44.986466,0> translate<51.689600,0.000000,34.620200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.689600,0.000000,34.620200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.147300,0.000000,34.620200>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<51.147300,0.000000,34.620200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.147300,0.000000,34.620200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.876200,0.000000,34.891300>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<50.876200,0.000000,34.891300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.876200,0.000000,34.891300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.960800,0.000000,35.976000>}
box{<0,0,-0.076200><1.533927,0.036000,0.076200> rotate<0,-44.999671,0> translate<50.876200,0.000000,34.891300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.828200,0.000000,35.704800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.370500,0.000000,36.247100>}
box{<0,0,-0.076200><0.766928,0.036000,0.076200> rotate<0,-44.997030,0> translate<47.828200,0.000000,35.704800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.370500,0.000000,36.247100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.370500,0.000000,34.620200>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,-90.000000,0> translate<48.370500,0.000000,34.620200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.828200,0.000000,34.620200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.912800,0.000000,34.620200>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<47.828200,0.000000,34.620200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.610800,0.000000,34.620200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,34.620200>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<44.526200,0.000000,34.620200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,34.620200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.610800,0.000000,35.704800>}
box{<0,0,-0.076200><1.533856,0.036000,0.076200> rotate<0,-44.997030,0> translate<44.526200,0.000000,34.620200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.610800,0.000000,35.704800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.610800,0.000000,35.976000>}
box{<0,0,-0.076200><0.271200,0.036000,0.076200> rotate<0,90.000000,0> translate<45.610800,0.000000,35.976000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.610800,0.000000,35.976000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.339600,0.000000,36.247100>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,44.986466,0> translate<45.339600,0.000000,36.247100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.339600,0.000000,36.247100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.797300,0.000000,36.247100>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<44.797300,0.000000,36.247100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.797300,0.000000,36.247100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,35.976000>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<44.526200,0.000000,35.976000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.162200,0.000000,32.588200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.162200,0.000000,34.215100>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,90.000000,0> translate<53.162200,0.000000,34.215100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.162200,0.000000,33.401600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.246800,0.000000,33.401600>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<53.162200,0.000000,33.401600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.246800,0.000000,34.215100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.246800,0.000000,32.588200>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,-90.000000,0> translate<54.246800,0.000000,32.588200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.162200,0.000000,30.913100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.162200,0.000000,29.286200>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,-90.000000,0> translate<53.162200,0.000000,29.286200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.162200,0.000000,29.286200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.246800,0.000000,29.286200>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<53.162200,0.000000,29.286200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.748200,0.000000,33.672800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.290500,0.000000,34.215100>}
box{<0,0,-0.076200><0.766928,0.036000,0.076200> rotate<0,-44.997030,0> translate<42.748200,0.000000,33.672800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.290500,0.000000,34.215100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.290500,0.000000,32.588200>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,-90.000000,0> translate<43.290500,0.000000,32.588200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.748200,0.000000,32.588200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.832800,0.000000,32.588200>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<42.748200,0.000000,32.588200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.748200,0.000000,29.557300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.748200,0.000000,30.642000>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,90.000000,0> translate<42.748200,0.000000,30.642000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.748200,0.000000,30.642000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.019300,0.000000,30.913100>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<42.748200,0.000000,30.642000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.019300,0.000000,30.913100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.561600,0.000000,30.913100>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<43.019300,0.000000,30.913100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.561600,0.000000,30.913100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.832800,0.000000,30.642000>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,44.986466,0> translate<43.561600,0.000000,30.913100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.832800,0.000000,30.642000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.832800,0.000000,29.557300>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,-90.000000,0> translate<43.832800,0.000000,29.557300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.832800,0.000000,29.557300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.561600,0.000000,29.286200>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-44.986466,0> translate<43.561600,0.000000,29.286200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.561600,0.000000,29.286200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.019300,0.000000,29.286200>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<43.019300,0.000000,29.286200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.019300,0.000000,29.286200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.748200,0.000000,29.557300>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<42.748200,0.000000,29.557300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.748200,0.000000,29.557300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.832800,0.000000,30.642000>}
box{<0,0,-0.076200><1.533927,0.036000,0.076200> rotate<0,-44.999671,0> translate<42.748200,0.000000,29.557300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.542200,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.084500,0.000000,5.918200>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<45.542200,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.813300,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.813300,0.000000,7.545100>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,90.000000,0> translate<45.813300,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.542200,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.084500,0.000000,7.545100>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<45.542200,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.718200,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.633600,0.000000,5.918200>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<46.633600,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.633600,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.718200,0.000000,7.002800>}
box{<0,0,-0.076200><1.533856,0.036000,0.076200> rotate<0,-44.997030,0> translate<46.633600,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.718200,0.000000,7.002800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.718200,0.000000,7.274000>}
box{<0,0,-0.076200><0.271200,0.036000,0.076200> rotate<0,90.000000,0> translate<47.718200,0.000000,7.274000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.718200,0.000000,7.274000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.447000,0.000000,7.545100>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,44.986466,0> translate<47.447000,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.447000,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.904700,0.000000,7.545100>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<46.904700,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.904700,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.633600,0.000000,7.274000>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<46.633600,0.000000,7.274000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.355300,0.000000,7.274000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.084100,0.000000,7.545100>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,44.986466,0> translate<49.084100,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.084100,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.541800,0.000000,7.545100>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<48.541800,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.541800,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.270700,0.000000,7.274000>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<48.270700,0.000000,7.274000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.270700,0.000000,7.274000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.270700,0.000000,6.189300>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,-90.000000,0> translate<48.270700,0.000000,6.189300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.270700,0.000000,6.189300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.541800,0.000000,5.918200>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<48.270700,0.000000,6.189300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.541800,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.084100,0.000000,5.918200>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<48.541800,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.084100,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.355300,0.000000,6.189300>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-44.986466,0> translate<49.084100,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.544900,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.087200,0.000000,5.918200>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<51.544900,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.816000,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.816000,0.000000,7.545100>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,90.000000,0> translate<51.816000,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.544900,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.087200,0.000000,7.545100>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<51.544900,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.636300,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.636300,0.000000,7.545100>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,90.000000,0> translate<52.636300,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.636300,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.720900,0.000000,5.918200>}
box{<0,0,-0.076200><1.955290,0.036000,0.076200> rotate<0,56.306216,0> translate<52.636300,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.720900,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.720900,0.000000,7.545100>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,90.000000,0> translate<53.720900,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.252200,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.794500,0.000000,5.918200>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<11.252200,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.523300,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.523300,0.000000,7.545100>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,90.000000,0> translate<11.523300,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.252200,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.794500,0.000000,7.545100>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<11.252200,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.428200,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<12.343600,0.000000,5.918200>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<12.343600,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<12.343600,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.428200,0.000000,7.002800>}
box{<0,0,-0.076200><1.533856,0.036000,0.076200> rotate<0,-44.997030,0> translate<12.343600,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.428200,0.000000,7.002800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.428200,0.000000,7.274000>}
box{<0,0,-0.076200><0.271200,0.036000,0.076200> rotate<0,90.000000,0> translate<13.428200,0.000000,7.274000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.428200,0.000000,7.274000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.157000,0.000000,7.545100>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,44.986466,0> translate<13.157000,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.157000,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<12.614700,0.000000,7.545100>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<12.614700,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<12.614700,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<12.343600,0.000000,7.274000>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<12.343600,0.000000,7.274000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.065300,0.000000,7.274000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.794100,0.000000,7.545100>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,44.986466,0> translate<14.794100,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.794100,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.251800,0.000000,7.545100>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<14.251800,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.251800,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.980700,0.000000,7.274000>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<13.980700,0.000000,7.274000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.980700,0.000000,7.274000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.980700,0.000000,6.189300>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,-90.000000,0> translate<13.980700,0.000000,6.189300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.980700,0.000000,6.189300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.251800,0.000000,5.918200>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<13.980700,0.000000,6.189300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.251800,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.794100,0.000000,5.918200>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<14.251800,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.794100,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.065300,0.000000,6.189300>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-44.986466,0> translate<14.794100,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.068300,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.526000,0.000000,7.545100>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<17.526000,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.526000,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.254900,0.000000,7.274000>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<17.254900,0.000000,7.274000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.254900,0.000000,7.274000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.254900,0.000000,6.189300>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,-90.000000,0> translate<17.254900,0.000000,6.189300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.254900,0.000000,6.189300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.526000,0.000000,5.918200>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<17.254900,0.000000,6.189300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.526000,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.068300,0.000000,5.918200>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<17.526000,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.068300,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.339500,0.000000,6.189300>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-44.986466,0> translate<18.068300,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.339500,0.000000,6.189300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.339500,0.000000,7.274000>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,90.000000,0> translate<18.339500,0.000000,7.274000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.339500,0.000000,7.274000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.068300,0.000000,7.545100>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,44.986466,0> translate<18.068300,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.892000,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.892000,0.000000,6.189300>}
box{<0,0,-0.076200><1.355800,0.036000,0.076200> rotate<0,-90.000000,0> translate<18.892000,0.000000,6.189300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.892000,0.000000,6.189300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.163100,0.000000,5.918200>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<18.892000,0.000000,6.189300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.163100,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.705400,0.000000,5.918200>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<19.163100,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.705400,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.976600,0.000000,6.189300>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-44.986466,0> translate<19.705400,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.976600,0.000000,6.189300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.976600,0.000000,7.545100>}
box{<0,0,-0.076200><1.355800,0.036000,0.076200> rotate<0,90.000000,0> translate<19.976600,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.071400,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.071400,0.000000,7.545100>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,90.000000,0> translate<21.071400,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.529100,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.613700,0.000000,7.545100>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<20.529100,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.208200,0.000000,6.731600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.292800,0.000000,6.731600>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<40.208200,0.000000,6.731600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.668200,0.000000,6.731600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.752800,0.000000,6.731600>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<37.668200,0.000000,6.731600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.210500,0.000000,7.274000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.210500,0.000000,6.189300>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,-90.000000,0> translate<38.210500,0.000000,6.189300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.714200,0.000000,7.002800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<25.256500,0.000000,7.545100>}
box{<0,0,-0.076200><0.766928,0.036000,0.076200> rotate<0,-44.997030,0> translate<24.714200,0.000000,7.002800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<25.256500,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<25.256500,0.000000,5.918200>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,-90.000000,0> translate<25.256500,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.714200,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<25.798800,0.000000,5.918200>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<24.714200,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.338800,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.254200,0.000000,5.918200>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<27.254200,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.254200,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.338800,0.000000,7.002800>}
box{<0,0,-0.076200><1.533856,0.036000,0.076200> rotate<0,-44.997030,0> translate<27.254200,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.338800,0.000000,7.002800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.338800,0.000000,7.274000>}
box{<0,0,-0.076200><0.271200,0.036000,0.076200> rotate<0,90.000000,0> translate<28.338800,0.000000,7.274000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.338800,0.000000,7.274000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.067600,0.000000,7.545100>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,44.986466,0> translate<28.067600,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.067600,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.525300,0.000000,7.545100>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<27.525300,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.525300,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.254200,0.000000,7.274000>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<27.254200,0.000000,7.274000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.794200,0.000000,7.274000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.065300,0.000000,7.545100>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<29.794200,0.000000,7.274000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.065300,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.607600,0.000000,7.545100>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<30.065300,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.607600,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.878800,0.000000,7.274000>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,44.986466,0> translate<30.607600,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.878800,0.000000,7.274000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.878800,0.000000,7.002800>}
box{<0,0,-0.076200><0.271200,0.036000,0.076200> rotate<0,-90.000000,0> translate<30.878800,0.000000,7.002800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.878800,0.000000,7.002800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.607600,0.000000,6.731600>}
box{<0,0,-0.076200><0.383535,0.036000,0.076200> rotate<0,-44.997030,0> translate<30.607600,0.000000,6.731600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.607600,0.000000,6.731600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.336500,0.000000,6.731600>}
box{<0,0,-0.076200><0.271100,0.036000,0.076200> rotate<0,0.000000,0> translate<30.336500,0.000000,6.731600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.607600,0.000000,6.731600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.878800,0.000000,6.460500>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,44.986466,0> translate<30.607600,0.000000,6.731600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.878800,0.000000,6.460500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.878800,0.000000,6.189300>}
box{<0,0,-0.076200><0.271200,0.036000,0.076200> rotate<0,-90.000000,0> translate<30.878800,0.000000,6.189300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.878800,0.000000,6.189300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.607600,0.000000,5.918200>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-44.986466,0> translate<30.607600,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.607600,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.065300,0.000000,5.918200>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<30.065300,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.065300,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.794200,0.000000,6.189300>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<29.794200,0.000000,6.189300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.147600,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.147600,0.000000,7.545100>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,90.000000,0> translate<33.147600,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.147600,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.334200,0.000000,6.731600>}
box{<0,0,-0.076200><1.150392,0.036000,0.076200> rotate<0,-45.000552,0> translate<32.334200,0.000000,6.731600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.334200,0.000000,6.731600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.418800,0.000000,6.731600>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<32.334200,0.000000,6.731600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.958800,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.874200,0.000000,7.545100>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<34.874200,0.000000,7.545100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.874200,0.000000,7.545100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.874200,0.000000,6.731600>}
box{<0,0,-0.076200><0.813500,0.036000,0.076200> rotate<0,-90.000000,0> translate<34.874200,0.000000,6.731600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.874200,0.000000,6.731600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.416500,0.000000,7.002800>}
box{<0,0,-0.076200><0.606332,0.036000,0.076200> rotate<0,-26.567524,0> translate<34.874200,0.000000,6.731600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.416500,0.000000,7.002800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.687600,0.000000,7.002800>}
box{<0,0,-0.076200><0.271100,0.036000,0.076200> rotate<0,0.000000,0> translate<35.416500,0.000000,7.002800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.687600,0.000000,7.002800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.958800,0.000000,6.731600>}
box{<0,0,-0.076200><0.383535,0.036000,0.076200> rotate<0,44.997030,0> translate<35.687600,0.000000,7.002800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.958800,0.000000,6.731600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.958800,0.000000,6.189300>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,-90.000000,0> translate<35.958800,0.000000,6.189300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.958800,0.000000,6.189300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.687600,0.000000,5.918200>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-44.986466,0> translate<35.687600,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.687600,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.145300,0.000000,5.918200>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<35.145300,0.000000,5.918200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.145300,0.000000,5.918200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.874200,0.000000,6.189300>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<34.874200,0.000000,6.189300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.850800,0.000000,27.340000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.579600,0.000000,27.611100>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,44.986466,0> translate<60.579600,0.000000,27.611100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.579600,0.000000,27.611100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.037300,0.000000,27.611100>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<60.037300,0.000000,27.611100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.037300,0.000000,27.611100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.766200,0.000000,27.340000>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<59.766200,0.000000,27.340000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.766200,0.000000,27.340000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.766200,0.000000,27.068800>}
box{<0,0,-0.076200><0.271200,0.036000,0.076200> rotate<0,-90.000000,0> translate<59.766200,0.000000,27.068800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.766200,0.000000,27.068800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.037300,0.000000,26.797600>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,45.007595,0> translate<59.766200,0.000000,27.068800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.037300,0.000000,26.797600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.579600,0.000000,26.797600>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<60.037300,0.000000,26.797600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.579600,0.000000,26.797600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.850800,0.000000,26.526500>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,44.986466,0> translate<60.579600,0.000000,26.797600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.850800,0.000000,26.526500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.850800,0.000000,26.255300>}
box{<0,0,-0.076200><0.271200,0.036000,0.076200> rotate<0,-90.000000,0> translate<60.850800,0.000000,26.255300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.850800,0.000000,26.255300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.579600,0.000000,25.984200>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-44.986466,0> translate<60.579600,0.000000,25.984200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.579600,0.000000,25.984200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.037300,0.000000,25.984200>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<60.037300,0.000000,25.984200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.037300,0.000000,25.984200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.766200,0.000000,26.255300>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<59.766200,0.000000,26.255300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.403300,0.000000,25.984200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.403300,0.000000,27.611100>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,90.000000,0> translate<61.403300,0.000000,27.611100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.403300,0.000000,27.611100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.216700,0.000000,27.611100>}
box{<0,0,-0.076200><0.813400,0.036000,0.076200> rotate<0,0.000000,0> translate<61.403300,0.000000,27.611100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.216700,0.000000,27.611100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.487900,0.000000,27.340000>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,44.986466,0> translate<62.216700,0.000000,27.611100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.487900,0.000000,27.340000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.487900,0.000000,26.797600>}
box{<0,0,-0.076200><0.542400,0.036000,0.076200> rotate<0,-90.000000,0> translate<62.487900,0.000000,26.797600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.487900,0.000000,26.797600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.216700,0.000000,26.526500>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-44.986466,0> translate<62.216700,0.000000,26.526500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.216700,0.000000,26.526500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.403300,0.000000,26.526500>}
box{<0,0,-0.076200><0.813400,0.036000,0.076200> rotate<0,0.000000,0> translate<61.403300,0.000000,26.526500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<63.040400,0.000000,25.984200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<63.582700,0.000000,25.984200>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<63.040400,0.000000,25.984200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<63.311500,0.000000,25.984200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<63.311500,0.000000,27.611100>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,90.000000,0> translate<63.311500,0.000000,27.611100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<63.040400,0.000000,27.611100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<63.582700,0.000000,27.611100>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<63.040400,0.000000,27.611100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.030100,0.000000,39.781100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.343600,0.000000,40.094700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-45.006166,0> translate<63.030100,0.000000,39.781100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.343600,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.343600,0.000000,39.154100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<63.343600,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.030100,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.657100,0.000000,39.154100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<63.030100,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<60.863100,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<60.236100,0.000000,39.154100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<60.236100,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<60.236100,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<60.863100,0.000000,39.781100>}
box{<0,0,-0.038100><0.886712,0.036000,0.038100> rotate<0,-44.997030,0> translate<60.236100,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<60.863100,0.000000,39.781100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<60.863100,0.000000,39.937900>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,90.000000,0> translate<60.863100,0.000000,39.937900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<60.863100,0.000000,39.937900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<60.706400,0.000000,40.094700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<60.706400,0.000000,40.094700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<60.706400,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<60.392800,0.000000,40.094700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<60.392800,0.000000,40.094700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<60.392800,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<60.236100,0.000000,39.937900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<60.236100,0.000000,39.937900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.696100,0.000000,39.937900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.852800,0.000000,40.094700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<57.696100,0.000000,39.937900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.852800,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.166400,0.000000,40.094700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<57.852800,0.000000,40.094700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.166400,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.323100,0.000000,39.937900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<58.166400,0.000000,40.094700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.323100,0.000000,39.937900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.323100,0.000000,39.781100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<58.323100,0.000000,39.781100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.323100,0.000000,39.781100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.166400,0.000000,39.624400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<58.166400,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.166400,0.000000,39.624400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.009600,0.000000,39.624400>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<58.009600,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.166400,0.000000,39.624400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.323100,0.000000,39.467600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<58.166400,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.323100,0.000000,39.467600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.323100,0.000000,39.310800>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<58.323100,0.000000,39.310800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.323100,0.000000,39.310800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.166400,0.000000,39.154100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<58.166400,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.166400,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.852800,0.000000,39.154100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<57.852800,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.852800,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<57.696100,0.000000,39.310800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<57.696100,0.000000,39.310800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<55.626400,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<55.626400,0.000000,40.094700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<55.626400,0.000000,40.094700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<55.626400,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<55.156100,0.000000,39.624400>}
box{<0,0,-0.038100><0.665105,0.036000,0.038100> rotate<0,-44.997030,0> translate<55.156100,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<55.156100,0.000000,39.624400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<55.783100,0.000000,39.624400>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<55.156100,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.243100,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.616100,0.000000,40.094700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<52.616100,0.000000,40.094700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.616100,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.616100,0.000000,39.624400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<52.616100,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.616100,0.000000,39.624400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.929600,0.000000,39.781100>}
box{<0,0,-0.038100><0.350481,0.036000,0.038100> rotate<0,-26.555988,0> translate<52.616100,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.929600,0.000000,39.781100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.086400,0.000000,39.781100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<52.929600,0.000000,39.781100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.086400,0.000000,39.781100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.243100,0.000000,39.624400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<53.086400,0.000000,39.781100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.243100,0.000000,39.624400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.243100,0.000000,39.310800>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<53.243100,0.000000,39.310800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.243100,0.000000,39.310800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.086400,0.000000,39.154100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<53.086400,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<53.086400,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.772800,0.000000,39.154100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<52.772800,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.772800,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<52.616100,0.000000,39.310800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<52.616100,0.000000,39.310800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.703100,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.389600,0.000000,39.937900>}
box{<0,0,-0.038100><0.350526,0.036000,0.038100> rotate<0,-26.570608,0> translate<50.389600,0.000000,39.937900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.389600,0.000000,39.937900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.076100,0.000000,39.624400>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<50.076100,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.076100,0.000000,39.624400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.076100,0.000000,39.310800>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<50.076100,0.000000,39.310800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.076100,0.000000,39.310800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.232800,0.000000,39.154100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<50.076100,0.000000,39.310800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.232800,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.546400,0.000000,39.154100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<50.232800,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.546400,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.703100,0.000000,39.310800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<50.546400,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.703100,0.000000,39.310800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.703100,0.000000,39.467600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,90.000000,0> translate<50.703100,0.000000,39.467600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.703100,0.000000,39.467600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.546400,0.000000,39.624400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<50.546400,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.546400,0.000000,39.624400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<50.076100,0.000000,39.624400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<50.076100,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.536100,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.163100,0.000000,40.094700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<47.536100,0.000000,40.094700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.163100,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.163100,0.000000,39.937900>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.163100,0.000000,39.937900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.163100,0.000000,39.937900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.536100,0.000000,39.310800>}
box{<0,0,-0.038100><0.886783,0.036000,0.038100> rotate<0,-45.001599,0> translate<47.536100,0.000000,39.310800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.536100,0.000000,39.310800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.536100,0.000000,39.154100>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,-90.000000,0> translate<47.536100,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.996100,0.000000,39.937900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.152800,0.000000,40.094700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<44.996100,0.000000,39.937900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.152800,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.466400,0.000000,40.094700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<45.152800,0.000000,40.094700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.466400,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.623100,0.000000,39.937900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<45.466400,0.000000,40.094700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.623100,0.000000,39.937900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.623100,0.000000,39.781100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<45.623100,0.000000,39.781100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.623100,0.000000,39.781100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.466400,0.000000,39.624400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<45.466400,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.466400,0.000000,39.624400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.623100,0.000000,39.467600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<45.466400,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.623100,0.000000,39.467600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.623100,0.000000,39.310800>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<45.623100,0.000000,39.310800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.623100,0.000000,39.310800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.466400,0.000000,39.154100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<45.466400,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.466400,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.152800,0.000000,39.154100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<45.152800,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.152800,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.996100,0.000000,39.310800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<44.996100,0.000000,39.310800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.996100,0.000000,39.310800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.996100,0.000000,39.467600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,90.000000,0> translate<44.996100,0.000000,39.467600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.996100,0.000000,39.467600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.152800,0.000000,39.624400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<44.996100,0.000000,39.467600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.152800,0.000000,39.624400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.996100,0.000000,39.781100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<44.996100,0.000000,39.781100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.996100,0.000000,39.781100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.996100,0.000000,39.937900>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,90.000000,0> translate<44.996100,0.000000,39.937900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.152800,0.000000,39.624400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.466400,0.000000,39.624400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<45.152800,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.456100,0.000000,39.310800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.612800,0.000000,39.154100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<42.456100,0.000000,39.310800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.612800,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.926400,0.000000,39.154100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<42.612800,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.926400,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.083100,0.000000,39.310800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<42.926400,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.083100,0.000000,39.310800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.083100,0.000000,39.937900>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,90.000000,0> translate<43.083100,0.000000,39.937900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.083100,0.000000,39.937900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.926400,0.000000,40.094700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<42.926400,0.000000,40.094700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.926400,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.612800,0.000000,40.094700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<42.612800,0.000000,40.094700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.612800,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.456100,0.000000,39.937900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<42.456100,0.000000,39.937900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.456100,0.000000,39.937900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.456100,0.000000,39.781100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<42.456100,0.000000,39.781100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.456100,0.000000,39.781100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.612800,0.000000,39.624400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<42.456100,0.000000,39.781100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.612800,0.000000,39.624400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.083100,0.000000,39.624400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<42.612800,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.408100,0.000000,39.781100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.721600,0.000000,40.094700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-45.006166,0> translate<39.408100,0.000000,39.781100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.721600,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.721600,0.000000,39.154100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<39.721600,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.408100,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.035100,0.000000,39.154100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<39.408100,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.343600,0.000000,39.310800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.343600,0.000000,39.937900>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,90.000000,0> translate<40.343600,0.000000,39.937900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.343600,0.000000,39.937900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.500300,0.000000,40.094700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<40.343600,0.000000,39.937900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.500300,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.813900,0.000000,40.094700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<40.500300,0.000000,40.094700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.813900,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.970600,0.000000,39.937900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<40.813900,0.000000,40.094700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.970600,0.000000,39.937900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.970600,0.000000,39.310800>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,-90.000000,0> translate<40.970600,0.000000,39.310800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.970600,0.000000,39.310800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.813900,0.000000,39.154100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<40.813900,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.813900,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.500300,0.000000,39.154100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<40.500300,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.500300,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.343600,0.000000,39.310800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<40.343600,0.000000,39.310800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.343600,0.000000,39.310800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.970600,0.000000,39.937900>}
box{<0,0,-0.038100><0.886783,0.036000,0.038100> rotate<0,-45.001599,0> translate<40.343600,0.000000,39.310800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.868100,0.000000,39.781100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.181600,0.000000,40.094700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-45.006166,0> translate<36.868100,0.000000,39.781100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.181600,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.181600,0.000000,39.154100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<37.181600,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.868100,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.495100,0.000000,39.154100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<36.868100,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.803600,0.000000,39.781100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.117100,0.000000,40.094700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-45.006166,0> translate<37.803600,0.000000,39.781100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.117100,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.117100,0.000000,39.154100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<38.117100,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.803600,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.430600,0.000000,39.154100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<37.803600,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<34.328100,0.000000,39.781100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<34.641600,0.000000,40.094700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-45.006166,0> translate<34.328100,0.000000,39.781100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<34.641600,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<34.641600,0.000000,39.154100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<34.641600,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<34.328100,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<34.955100,0.000000,39.154100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<34.328100,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.890600,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.263600,0.000000,39.154100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<35.263600,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.263600,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.890600,0.000000,39.781100>}
box{<0,0,-0.038100><0.886712,0.036000,0.038100> rotate<0,-44.997030,0> translate<35.263600,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.890600,0.000000,39.781100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.890600,0.000000,39.937900>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,90.000000,0> translate<35.890600,0.000000,39.937900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.890600,0.000000,39.937900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.733900,0.000000,40.094700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<35.733900,0.000000,40.094700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.733900,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.420300,0.000000,40.094700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<35.420300,0.000000,40.094700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.420300,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<35.263600,0.000000,39.937900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<35.263600,0.000000,39.937900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.788100,0.000000,39.781100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.101600,0.000000,40.094700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-45.006166,0> translate<31.788100,0.000000,39.781100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.101600,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.101600,0.000000,39.154100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<32.101600,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.788100,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.415100,0.000000,39.154100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<31.788100,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.723600,0.000000,39.937900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.880300,0.000000,40.094700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<32.723600,0.000000,39.937900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.880300,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.193900,0.000000,40.094700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<32.880300,0.000000,40.094700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.193900,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.350600,0.000000,39.937900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<33.193900,0.000000,40.094700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.350600,0.000000,39.937900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.350600,0.000000,39.781100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<33.350600,0.000000,39.781100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.350600,0.000000,39.781100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.193900,0.000000,39.624400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<33.193900,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.193900,0.000000,39.624400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.037100,0.000000,39.624400>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<33.037100,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.193900,0.000000,39.624400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.350600,0.000000,39.467600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<33.193900,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.350600,0.000000,39.467600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.350600,0.000000,39.310800>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<33.350600,0.000000,39.310800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.350600,0.000000,39.310800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.193900,0.000000,39.154100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<33.193900,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<33.193900,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.880300,0.000000,39.154100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<32.880300,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.880300,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<32.723600,0.000000,39.310800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<32.723600,0.000000,39.310800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<29.248100,0.000000,39.781100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<29.561600,0.000000,40.094700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-45.006166,0> translate<29.248100,0.000000,39.781100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<29.561600,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<29.561600,0.000000,39.154100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<29.561600,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<29.248100,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<29.875100,0.000000,39.154100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<29.248100,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.653900,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.653900,0.000000,40.094700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<30.653900,0.000000,40.094700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.653900,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.183600,0.000000,39.624400>}
box{<0,0,-0.038100><0.665105,0.036000,0.038100> rotate<0,-44.997030,0> translate<30.183600,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.183600,0.000000,39.624400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<30.810600,0.000000,39.624400>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<30.183600,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<26.708100,0.000000,39.781100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.021600,0.000000,40.094700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-45.006166,0> translate<26.708100,0.000000,39.781100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.021600,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.021600,0.000000,39.154100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<27.021600,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<26.708100,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.335100,0.000000,39.154100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<26.708100,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<28.270600,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.643600,0.000000,40.094700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<27.643600,0.000000,40.094700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.643600,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.643600,0.000000,39.624400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<27.643600,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.643600,0.000000,39.624400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.957100,0.000000,39.781100>}
box{<0,0,-0.038100><0.350481,0.036000,0.038100> rotate<0,-26.555988,0> translate<27.643600,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.957100,0.000000,39.781100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<28.113900,0.000000,39.781100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<27.957100,0.000000,39.781100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<28.113900,0.000000,39.781100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<28.270600,0.000000,39.624400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<28.113900,0.000000,39.781100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<28.270600,0.000000,39.624400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<28.270600,0.000000,39.310800>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<28.270600,0.000000,39.310800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<28.270600,0.000000,39.310800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<28.113900,0.000000,39.154100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<28.113900,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<28.113900,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.800300,0.000000,39.154100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<27.800300,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.800300,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.643600,0.000000,39.310800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<27.643600,0.000000,39.310800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.168100,0.000000,39.781100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.481600,0.000000,40.094700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-45.006166,0> translate<24.168100,0.000000,39.781100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.481600,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.481600,0.000000,39.154100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<24.481600,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.168100,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.795100,0.000000,39.154100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<24.168100,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.730600,0.000000,40.094700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.417100,0.000000,39.937900>}
box{<0,0,-0.038100><0.350526,0.036000,0.038100> rotate<0,-26.570608,0> translate<25.417100,0.000000,39.937900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.417100,0.000000,39.937900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.103600,0.000000,39.624400>}
box{<0,0,-0.038100><0.443356,0.036000,0.038100> rotate<0,-44.997030,0> translate<25.103600,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.103600,0.000000,39.624400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.103600,0.000000,39.310800>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<25.103600,0.000000,39.310800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.103600,0.000000,39.310800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.260300,0.000000,39.154100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<25.103600,0.000000,39.310800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.260300,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.573900,0.000000,39.154100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<25.260300,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.573900,0.000000,39.154100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.730600,0.000000,39.310800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<25.573900,0.000000,39.154100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.730600,0.000000,39.310800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.730600,0.000000,39.467600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,90.000000,0> translate<25.730600,0.000000,39.467600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.730600,0.000000,39.467600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.573900,0.000000,39.624400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<25.573900,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.573900,0.000000,39.624400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.103600,0.000000,39.624400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<25.103600,0.000000,39.624400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.782800,0.000000,16.612700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.782800,0.000000,15.290800>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,-90.000000,0> translate<14.782800,0.000000,15.290800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.782800,0.000000,15.290800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.443700,0.000000,15.290800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<14.782800,0.000000,15.290800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.443700,0.000000,15.290800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.664000,0.000000,15.511100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<15.443700,0.000000,15.290800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.664000,0.000000,15.511100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.664000,0.000000,16.392400>}
box{<0,0,-0.050800><0.881300,0.036000,0.050800> rotate<0,90.000000,0> translate<15.664000,0.000000,16.392400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.664000,0.000000,16.392400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.443700,0.000000,16.612700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<15.443700,0.000000,16.612700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.443700,0.000000,16.612700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.782800,0.000000,16.612700>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<14.782800,0.000000,16.612700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.753400,0.000000,15.290800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.312800,0.000000,15.290800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<16.312800,0.000000,15.290800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.312800,0.000000,15.290800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.092500,0.000000,15.511100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<16.092500,0.000000,15.511100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.092500,0.000000,15.511100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.092500,0.000000,15.951700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,90.000000,0> translate<16.092500,0.000000,15.951700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.092500,0.000000,15.951700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.312800,0.000000,16.172000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<16.092500,0.000000,15.951700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.312800,0.000000,16.172000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.753400,0.000000,16.172000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<16.312800,0.000000,16.172000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.753400,0.000000,16.172000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.973700,0.000000,15.951700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<16.753400,0.000000,16.172000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.973700,0.000000,15.951700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.973700,0.000000,15.731400>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<16.973700,0.000000,15.731400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.973700,0.000000,15.731400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.092500,0.000000,15.731400>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<16.092500,0.000000,15.731400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.402200,0.000000,15.290800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.063100,0.000000,15.290800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<17.402200,0.000000,15.290800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.063100,0.000000,15.290800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.283400,0.000000,15.511100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<18.063100,0.000000,15.290800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.283400,0.000000,15.511100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.063100,0.000000,15.731400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<18.063100,0.000000,15.731400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.063100,0.000000,15.731400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.622500,0.000000,15.731400>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<17.622500,0.000000,15.731400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.622500,0.000000,15.731400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.402200,0.000000,15.951700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<17.402200,0.000000,15.951700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.402200,0.000000,15.951700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.622500,0.000000,16.172000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<17.402200,0.000000,15.951700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.622500,0.000000,16.172000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.283400,0.000000,16.172000>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<17.622500,0.000000,16.172000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.711900,0.000000,16.172000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.932200,0.000000,16.172000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<18.711900,0.000000,16.172000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.932200,0.000000,16.172000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.932200,0.000000,15.290800>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,-90.000000,0> translate<18.932200,0.000000,15.290800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.711900,0.000000,15.290800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.152500,0.000000,15.290800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<18.711900,0.000000,15.290800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.932200,0.000000,16.833000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.932200,0.000000,16.612700>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<18.932200,0.000000,16.612700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.025600,0.000000,14.850200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.245900,0.000000,14.850200>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<20.025600,0.000000,14.850200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.245900,0.000000,14.850200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.466200,0.000000,15.070500>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<20.245900,0.000000,14.850200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.466200,0.000000,15.070500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.466200,0.000000,16.172000>}
box{<0,0,-0.050800><1.101500,0.036000,0.050800> rotate<0,90.000000,0> translate<20.466200,0.000000,16.172000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.466200,0.000000,16.172000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.805300,0.000000,16.172000>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<19.805300,0.000000,16.172000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.805300,0.000000,16.172000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.585000,0.000000,15.951700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<19.585000,0.000000,15.951700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.585000,0.000000,15.951700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.585000,0.000000,15.511100>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,-90.000000,0> translate<19.585000,0.000000,15.511100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.585000,0.000000,15.511100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.805300,0.000000,15.290800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<19.585000,0.000000,15.511100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.805300,0.000000,15.290800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.466200,0.000000,15.290800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<19.805300,0.000000,15.290800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.894700,0.000000,15.290800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.894700,0.000000,16.172000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<20.894700,0.000000,16.172000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.894700,0.000000,16.172000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.555600,0.000000,16.172000>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<20.894700,0.000000,16.172000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.555600,0.000000,16.172000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.775900,0.000000,15.951700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<21.555600,0.000000,16.172000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.775900,0.000000,15.951700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.775900,0.000000,15.290800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<21.775900,0.000000,15.290800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.514100,0.000000,15.290800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.514100,0.000000,16.612700>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,90.000000,0> translate<23.514100,0.000000,16.612700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.514100,0.000000,16.612700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.175000,0.000000,16.612700>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<23.514100,0.000000,16.612700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.175000,0.000000,16.612700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.395300,0.000000,16.392400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<24.175000,0.000000,16.612700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.395300,0.000000,16.392400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.395300,0.000000,16.172000>}
box{<0,0,-0.050800><0.220400,0.036000,0.050800> rotate<0,-90.000000,0> translate<24.395300,0.000000,16.172000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.395300,0.000000,16.172000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.175000,0.000000,15.951700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<24.175000,0.000000,15.951700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.175000,0.000000,15.951700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.395300,0.000000,15.731400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<24.175000,0.000000,15.951700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.395300,0.000000,15.731400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.395300,0.000000,15.511100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<24.395300,0.000000,15.511100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.395300,0.000000,15.511100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.175000,0.000000,15.290800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<24.175000,0.000000,15.290800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.175000,0.000000,15.290800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.514100,0.000000,15.290800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<23.514100,0.000000,15.290800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.514100,0.000000,15.951700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.175000,0.000000,15.951700>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<23.514100,0.000000,15.951700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.823800,0.000000,16.172000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.823800,0.000000,15.511100>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<24.823800,0.000000,15.511100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.823800,0.000000,15.511100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.044100,0.000000,15.290800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<24.823800,0.000000,15.511100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.044100,0.000000,15.290800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.705000,0.000000,15.290800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<25.044100,0.000000,15.290800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.705000,0.000000,16.172000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.705000,0.000000,15.070500>}
box{<0,0,-0.050800><1.101500,0.036000,0.050800> rotate<0,-90.000000,0> translate<25.705000,0.000000,15.070500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.705000,0.000000,15.070500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.484700,0.000000,14.850200>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<25.484700,0.000000,14.850200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.484700,0.000000,14.850200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.264400,0.000000,14.850200>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<25.264400,0.000000,14.850200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.133500,0.000000,16.172000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.353800,0.000000,16.172000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<26.133500,0.000000,16.172000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.353800,0.000000,16.172000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.353800,0.000000,15.951700>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<26.353800,0.000000,15.951700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.353800,0.000000,15.951700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.133500,0.000000,15.951700>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<26.133500,0.000000,15.951700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.133500,0.000000,15.951700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.133500,0.000000,16.172000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,90.000000,0> translate<26.133500,0.000000,16.172000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.133500,0.000000,15.511100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.353800,0.000000,15.511100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<26.133500,0.000000,15.511100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.353800,0.000000,15.511100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.353800,0.000000,15.290800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<26.353800,0.000000,15.290800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.353800,0.000000,15.290800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.133500,0.000000,15.290800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<26.133500,0.000000,15.290800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.133500,0.000000,15.290800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.133500,0.000000,15.511100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,90.000000,0> translate<26.133500,0.000000,15.511100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.782800,0.000000,13.512800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.782800,0.000000,14.834700>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,90.000000,0> translate<14.782800,0.000000,14.834700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.782800,0.000000,14.834700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.443700,0.000000,14.834700>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<14.782800,0.000000,14.834700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.443700,0.000000,14.834700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.664000,0.000000,14.614400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<15.443700,0.000000,14.834700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.664000,0.000000,14.614400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.664000,0.000000,14.394000>}
box{<0,0,-0.050800><0.220400,0.036000,0.050800> rotate<0,-90.000000,0> translate<15.664000,0.000000,14.394000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.664000,0.000000,14.394000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.443700,0.000000,14.173700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<15.443700,0.000000,14.173700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.443700,0.000000,14.173700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.664000,0.000000,13.953400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<15.443700,0.000000,14.173700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.664000,0.000000,13.953400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.664000,0.000000,13.733100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<15.664000,0.000000,13.733100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.664000,0.000000,13.733100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.443700,0.000000,13.512800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<15.443700,0.000000,13.512800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.443700,0.000000,13.512800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.782800,0.000000,13.512800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<14.782800,0.000000,13.512800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.782800,0.000000,14.173700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.443700,0.000000,14.173700>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<14.782800,0.000000,14.173700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.092500,0.000000,13.512800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.092500,0.000000,14.394000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<16.092500,0.000000,14.394000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.092500,0.000000,13.953400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.533100,0.000000,14.394000>}
box{<0,0,-0.050800><0.623102,0.036000,0.050800> rotate<0,-44.997030,0> translate<16.092500,0.000000,13.953400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.533100,0.000000,14.394000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.753400,0.000000,14.394000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<16.533100,0.000000,14.394000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.183900,0.000000,14.394000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.183900,0.000000,13.733100>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<17.183900,0.000000,13.733100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.183900,0.000000,13.733100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.404200,0.000000,13.512800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<17.183900,0.000000,13.733100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.404200,0.000000,13.512800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.065100,0.000000,13.512800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<17.404200,0.000000,13.512800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.065100,0.000000,13.512800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.065100,0.000000,14.394000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<18.065100,0.000000,14.394000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.374800,0.000000,14.394000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.713900,0.000000,14.394000>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<18.713900,0.000000,14.394000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.713900,0.000000,14.394000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.493600,0.000000,14.173700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<18.493600,0.000000,14.173700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.493600,0.000000,14.173700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.493600,0.000000,13.733100>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,-90.000000,0> translate<18.493600,0.000000,13.733100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.493600,0.000000,13.733100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.713900,0.000000,13.512800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<18.493600,0.000000,13.733100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.713900,0.000000,13.512800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.374800,0.000000,13.512800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<18.713900,0.000000,13.512800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.464200,0.000000,13.512800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.023600,0.000000,13.512800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<20.023600,0.000000,13.512800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.023600,0.000000,13.512800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.803300,0.000000,13.733100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<19.803300,0.000000,13.733100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.803300,0.000000,13.733100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.803300,0.000000,14.173700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,90.000000,0> translate<19.803300,0.000000,14.173700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.803300,0.000000,14.173700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.023600,0.000000,14.394000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<19.803300,0.000000,14.173700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.023600,0.000000,14.394000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.464200,0.000000,14.394000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<20.023600,0.000000,14.394000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.464200,0.000000,14.394000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.684500,0.000000,14.173700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<20.464200,0.000000,14.394000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.684500,0.000000,14.173700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.684500,0.000000,13.953400>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<20.684500,0.000000,13.953400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.684500,0.000000,13.953400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.803300,0.000000,13.953400>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<19.803300,0.000000,13.953400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.422700,0.000000,14.834700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.422700,0.000000,13.512800>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,-90.000000,0> translate<22.422700,0.000000,13.512800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.422700,0.000000,13.512800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.863300,0.000000,13.953400>}
box{<0,0,-0.050800><0.623102,0.036000,0.050800> rotate<0,-44.997030,0> translate<22.422700,0.000000,13.512800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.863300,0.000000,13.953400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.303900,0.000000,13.512800>}
box{<0,0,-0.050800><0.623102,0.036000,0.050800> rotate<0,44.997030,0> translate<22.863300,0.000000,13.953400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.303900,0.000000,13.512800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.303900,0.000000,14.834700>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,90.000000,0> translate<23.303900,0.000000,14.834700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.952700,0.000000,14.394000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.393300,0.000000,14.394000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<23.952700,0.000000,14.394000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.393300,0.000000,14.394000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.613600,0.000000,14.173700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<24.393300,0.000000,14.394000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.613600,0.000000,14.173700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.613600,0.000000,13.512800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<24.613600,0.000000,13.512800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.613600,0.000000,13.512800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.952700,0.000000,13.512800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<23.952700,0.000000,13.512800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.952700,0.000000,13.512800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.732400,0.000000,13.733100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<23.732400,0.000000,13.733100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.732400,0.000000,13.733100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.952700,0.000000,13.953400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<23.732400,0.000000,13.733100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.952700,0.000000,13.953400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.613600,0.000000,13.953400>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<23.952700,0.000000,13.953400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.262400,0.000000,14.614400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.262400,0.000000,13.733100>}
box{<0,0,-0.050800><0.881300,0.036000,0.050800> rotate<0,-90.000000,0> translate<25.262400,0.000000,13.733100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.262400,0.000000,13.733100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.482700,0.000000,13.512800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<25.262400,0.000000,13.733100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.042100,0.000000,14.394000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.482700,0.000000,14.394000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<25.042100,0.000000,14.394000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.135500,0.000000,14.614400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.135500,0.000000,13.733100>}
box{<0,0,-0.050800><0.881300,0.036000,0.050800> rotate<0,-90.000000,0> translate<26.135500,0.000000,13.733100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.135500,0.000000,13.733100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.355800,0.000000,13.512800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<26.135500,0.000000,13.733100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.915200,0.000000,14.394000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.355800,0.000000,14.394000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<25.915200,0.000000,14.394000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.449200,0.000000,13.512800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.008600,0.000000,13.512800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<27.008600,0.000000,13.512800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.008600,0.000000,13.512800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.788300,0.000000,13.733100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<26.788300,0.000000,13.733100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.788300,0.000000,13.733100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.788300,0.000000,14.173700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,90.000000,0> translate<26.788300,0.000000,14.173700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.788300,0.000000,14.173700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.008600,0.000000,14.394000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<26.788300,0.000000,14.173700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.008600,0.000000,14.394000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.449200,0.000000,14.394000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<27.008600,0.000000,14.394000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.449200,0.000000,14.394000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.669500,0.000000,14.173700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<27.449200,0.000000,14.394000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.669500,0.000000,14.173700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.669500,0.000000,13.953400>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<27.669500,0.000000,13.953400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.669500,0.000000,13.953400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.788300,0.000000,13.953400>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<26.788300,0.000000,13.953400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.098000,0.000000,13.512800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.098000,0.000000,14.394000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<28.098000,0.000000,14.394000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.098000,0.000000,14.394000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.758900,0.000000,14.394000>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<28.098000,0.000000,14.394000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.758900,0.000000,14.394000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.979200,0.000000,14.173700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<28.758900,0.000000,14.394000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.979200,0.000000,14.173700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.979200,0.000000,13.512800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<28.979200,0.000000,13.512800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.288900,0.000000,14.834700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.288900,0.000000,13.512800>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,-90.000000,0> translate<30.288900,0.000000,13.512800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.288900,0.000000,13.512800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.628000,0.000000,13.512800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<29.628000,0.000000,13.512800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.628000,0.000000,13.512800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.407700,0.000000,13.733100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<29.407700,0.000000,13.733100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.407700,0.000000,13.733100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.407700,0.000000,14.173700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,90.000000,0> translate<29.407700,0.000000,14.173700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.407700,0.000000,14.173700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.628000,0.000000,14.394000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<29.407700,0.000000,14.173700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.628000,0.000000,14.394000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.288900,0.000000,14.394000>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<29.628000,0.000000,14.394000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.937700,0.000000,13.512800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.378300,0.000000,13.512800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<30.937700,0.000000,13.512800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.378300,0.000000,13.512800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.598600,0.000000,13.733100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<31.378300,0.000000,13.512800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.598600,0.000000,13.733100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.598600,0.000000,14.173700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,90.000000,0> translate<31.598600,0.000000,14.173700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.598600,0.000000,14.173700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.378300,0.000000,14.394000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<31.378300,0.000000,14.394000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.378300,0.000000,14.394000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.937700,0.000000,14.394000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<30.937700,0.000000,14.394000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.937700,0.000000,14.394000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.717400,0.000000,14.173700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<30.717400,0.000000,14.173700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.717400,0.000000,14.173700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.717400,0.000000,13.733100>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,-90.000000,0> translate<30.717400,0.000000,13.733100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.717400,0.000000,13.733100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.937700,0.000000,13.512800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<30.717400,0.000000,13.733100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.027100,0.000000,13.512800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.027100,0.000000,14.394000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<32.027100,0.000000,14.394000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.027100,0.000000,13.953400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.467700,0.000000,14.394000>}
box{<0,0,-0.050800><0.623102,0.036000,0.050800> rotate<0,-44.997030,0> translate<32.027100,0.000000,13.953400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.467700,0.000000,14.394000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.688000,0.000000,14.394000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<32.467700,0.000000,14.394000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.338800,0.000000,13.512800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.338800,0.000000,14.614400>}
box{<0,0,-0.050800><1.101600,0.036000,0.050800> rotate<0,90.000000,0> translate<33.338800,0.000000,14.614400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.338800,0.000000,14.614400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.559100,0.000000,14.834700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<33.338800,0.000000,14.614400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.118500,0.000000,14.173700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.559100,0.000000,14.173700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<33.118500,0.000000,14.173700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.782800,0.000000,13.056700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.664000,0.000000,13.056700>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<14.782800,0.000000,13.056700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.664000,0.000000,13.056700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.664000,0.000000,12.836400>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<15.664000,0.000000,12.836400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.664000,0.000000,12.836400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.782800,0.000000,11.955100>}
box{<0,0,-0.050800><1.246276,0.036000,0.050800> rotate<0,-45.000281,0> translate<14.782800,0.000000,11.955100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.782800,0.000000,11.955100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.782800,0.000000,11.734800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<14.782800,0.000000,11.734800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.782800,0.000000,11.734800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.664000,0.000000,11.734800>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<14.782800,0.000000,11.734800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.312800,0.000000,12.616000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.753400,0.000000,12.616000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<16.312800,0.000000,12.616000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.753400,0.000000,12.616000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.973700,0.000000,12.395700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<16.753400,0.000000,12.616000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.973700,0.000000,12.395700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.973700,0.000000,11.734800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<16.973700,0.000000,11.734800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.973700,0.000000,11.734800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.312800,0.000000,11.734800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<16.312800,0.000000,11.734800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.312800,0.000000,11.734800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.092500,0.000000,11.955100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<16.092500,0.000000,11.955100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.092500,0.000000,11.955100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.312800,0.000000,12.175400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<16.092500,0.000000,11.955100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.312800,0.000000,12.175400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.973700,0.000000,12.175400>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<16.312800,0.000000,12.175400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.283400,0.000000,12.616000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.622500,0.000000,12.616000>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<17.622500,0.000000,12.616000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.622500,0.000000,12.616000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.402200,0.000000,12.395700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<17.402200,0.000000,12.395700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.402200,0.000000,12.395700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.402200,0.000000,11.955100>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,-90.000000,0> translate<17.402200,0.000000,11.955100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.402200,0.000000,11.955100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.622500,0.000000,11.734800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<17.402200,0.000000,11.955100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.622500,0.000000,11.734800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.283400,0.000000,11.734800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<17.622500,0.000000,11.734800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.711900,0.000000,13.056700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.711900,0.000000,11.734800>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,-90.000000,0> translate<18.711900,0.000000,11.734800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.711900,0.000000,12.395700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.932200,0.000000,12.616000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<18.711900,0.000000,12.395700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.932200,0.000000,12.616000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.372800,0.000000,12.616000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<18.932200,0.000000,12.616000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.372800,0.000000,12.616000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.593100,0.000000,12.395700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<19.372800,0.000000,12.616000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.593100,0.000000,12.395700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.593100,0.000000,11.734800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<19.593100,0.000000,11.734800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.021600,0.000000,11.734800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.021600,0.000000,13.056700>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,90.000000,0> translate<20.021600,0.000000,13.056700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.021600,0.000000,12.395700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.902800,0.000000,12.395700>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<20.021600,0.000000,12.395700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.902800,0.000000,13.056700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.902800,0.000000,11.734800>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,-90.000000,0> translate<20.902800,0.000000,11.734800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.551600,0.000000,11.734800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.992200,0.000000,11.734800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<21.551600,0.000000,11.734800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.992200,0.000000,11.734800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.212500,0.000000,11.955100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<21.992200,0.000000,11.734800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.212500,0.000000,11.955100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.212500,0.000000,12.395700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,90.000000,0> translate<22.212500,0.000000,12.395700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.212500,0.000000,12.395700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.992200,0.000000,12.616000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<21.992200,0.000000,12.616000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.992200,0.000000,12.616000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.551600,0.000000,12.616000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<21.551600,0.000000,12.616000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.551600,0.000000,12.616000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.331300,0.000000,12.395700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<21.331300,0.000000,12.395700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.331300,0.000000,12.395700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.331300,0.000000,11.955100>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,-90.000000,0> translate<21.331300,0.000000,11.955100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.331300,0.000000,11.955100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.551600,0.000000,11.734800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<21.331300,0.000000,11.955100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.301900,0.000000,11.734800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.861300,0.000000,11.734800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<22.861300,0.000000,11.734800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.861300,0.000000,11.734800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.641000,0.000000,11.955100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<22.641000,0.000000,11.955100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.641000,0.000000,11.955100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.641000,0.000000,12.395700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,90.000000,0> translate<22.641000,0.000000,12.395700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.641000,0.000000,12.395700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.861300,0.000000,12.616000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<22.641000,0.000000,12.395700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.861300,0.000000,12.616000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.301900,0.000000,12.616000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<22.861300,0.000000,12.616000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.301900,0.000000,12.616000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.522200,0.000000,12.395700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<23.301900,0.000000,12.616000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.522200,0.000000,12.395700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.522200,0.000000,12.175400>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<23.522200,0.000000,12.175400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.522200,0.000000,12.175400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.641000,0.000000,12.175400>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<22.641000,0.000000,12.175400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.950700,0.000000,11.734800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.950700,0.000000,13.056700>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,90.000000,0> translate<23.950700,0.000000,13.056700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.611600,0.000000,11.734800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.950700,0.000000,12.175400>}
box{<0,0,-0.050800><0.794303,0.036000,0.050800> rotate<0,33.687844,0> translate<23.950700,0.000000,12.175400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.950700,0.000000,12.175400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.611600,0.000000,12.616000>}
box{<0,0,-0.050800><0.794303,0.036000,0.050800> rotate<0,-33.687844,0> translate<23.950700,0.000000,12.175400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.703000,0.000000,11.734800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.262400,0.000000,11.734800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<25.262400,0.000000,11.734800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.262400,0.000000,11.734800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.042100,0.000000,11.955100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<25.042100,0.000000,11.955100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.042100,0.000000,11.955100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.042100,0.000000,12.395700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,90.000000,0> translate<25.042100,0.000000,12.395700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.042100,0.000000,12.395700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.262400,0.000000,12.616000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<25.042100,0.000000,12.395700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.262400,0.000000,12.616000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.703000,0.000000,12.616000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<25.262400,0.000000,12.616000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.703000,0.000000,12.616000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.923300,0.000000,12.395700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<25.703000,0.000000,12.616000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.923300,0.000000,12.395700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.923300,0.000000,12.175400>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<25.923300,0.000000,12.175400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.923300,0.000000,12.175400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.042100,0.000000,12.175400>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<25.042100,0.000000,12.175400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.351800,0.000000,11.734800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.351800,0.000000,12.616000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<26.351800,0.000000,12.616000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.351800,0.000000,12.616000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.012700,0.000000,12.616000>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<26.351800,0.000000,12.616000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.012700,0.000000,12.616000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.233000,0.000000,12.395700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<27.012700,0.000000,12.616000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.233000,0.000000,12.395700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.233000,0.000000,11.734800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<27.233000,0.000000,11.734800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.661500,0.000000,11.734800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.661500,0.000000,11.955100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,90.000000,0> translate<27.661500,0.000000,11.955100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.661500,0.000000,11.955100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.881800,0.000000,11.955100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<27.661500,0.000000,11.955100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.881800,0.000000,11.955100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.881800,0.000000,11.734800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<27.881800,0.000000,11.734800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.881800,0.000000,11.734800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.661500,0.000000,11.734800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<27.661500,0.000000,11.734800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.197500,0.000000,12.616000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.536600,0.000000,12.616000>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<28.536600,0.000000,12.616000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.536600,0.000000,12.616000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.316300,0.000000,12.395700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<28.316300,0.000000,12.395700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.316300,0.000000,12.395700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.316300,0.000000,11.955100>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,-90.000000,0> translate<28.316300,0.000000,11.955100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.316300,0.000000,11.955100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.536600,0.000000,11.734800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<28.316300,0.000000,11.955100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.536600,0.000000,11.734800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.197500,0.000000,11.734800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<28.536600,0.000000,11.734800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.846300,0.000000,11.734800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.286900,0.000000,11.734800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<29.846300,0.000000,11.734800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.286900,0.000000,11.734800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.507200,0.000000,11.955100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<30.286900,0.000000,11.734800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.507200,0.000000,11.955100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.507200,0.000000,12.395700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,90.000000,0> translate<30.507200,0.000000,12.395700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.507200,0.000000,12.395700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.286900,0.000000,12.616000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<30.286900,0.000000,12.616000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.286900,0.000000,12.616000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.846300,0.000000,12.616000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<29.846300,0.000000,12.616000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.846300,0.000000,12.616000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.626000,0.000000,12.395700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<29.626000,0.000000,12.395700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.626000,0.000000,12.395700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.626000,0.000000,11.955100>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,-90.000000,0> translate<29.626000,0.000000,11.955100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.626000,0.000000,11.955100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.846300,0.000000,11.734800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<29.626000,0.000000,11.955100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.935700,0.000000,11.734800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.935700,0.000000,12.616000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<30.935700,0.000000,12.616000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.935700,0.000000,12.616000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.156000,0.000000,12.616000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<30.935700,0.000000,12.616000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.156000,0.000000,12.616000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.376300,0.000000,12.395700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<31.156000,0.000000,12.616000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.376300,0.000000,12.395700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.376300,0.000000,11.734800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<31.376300,0.000000,11.734800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.376300,0.000000,12.395700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.596600,0.000000,12.616000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<31.376300,0.000000,12.395700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.596600,0.000000,12.616000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.816900,0.000000,12.395700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<31.596600,0.000000,12.616000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.816900,0.000000,12.395700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.816900,0.000000,11.734800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<31.816900,0.000000,11.734800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.226800,0.000000,34.646700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.226800,0.000000,33.324800>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,-90.000000,0> translate<11.226800,0.000000,33.324800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.226800,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.108000,0.000000,33.324800>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<11.226800,0.000000,33.324800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.417700,0.000000,34.426400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.197400,0.000000,34.646700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<13.197400,0.000000,34.646700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.197400,0.000000,34.646700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.756800,0.000000,34.646700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<12.756800,0.000000,34.646700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.756800,0.000000,34.646700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.536500,0.000000,34.426400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<12.536500,0.000000,34.426400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.536500,0.000000,34.426400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.536500,0.000000,33.545100>}
box{<0,0,-0.050800><0.881300,0.036000,0.050800> rotate<0,-90.000000,0> translate<12.536500,0.000000,33.545100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.536500,0.000000,33.545100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.756800,0.000000,33.324800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<12.536500,0.000000,33.545100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.756800,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.197400,0.000000,33.324800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<12.756800,0.000000,33.324800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.197400,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.417700,0.000000,33.545100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<13.197400,0.000000,33.324800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.846200,0.000000,34.646700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.846200,0.000000,33.324800>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,-90.000000,0> translate<13.846200,0.000000,33.324800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.846200,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.507100,0.000000,33.324800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<13.846200,0.000000,33.324800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.507100,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.727400,0.000000,33.545100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<14.507100,0.000000,33.324800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.727400,0.000000,33.545100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.727400,0.000000,34.426400>}
box{<0,0,-0.050800><0.881300,0.036000,0.050800> rotate<0,90.000000,0> translate<14.727400,0.000000,34.426400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.727400,0.000000,34.426400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.507100,0.000000,34.646700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<14.507100,0.000000,34.646700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.507100,0.000000,34.646700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.846200,0.000000,34.646700>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<13.846200,0.000000,34.646700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.465600,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.906200,0.000000,33.324800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<16.465600,0.000000,33.324800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.685900,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.685900,0.000000,34.646700>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,90.000000,0> translate<16.685900,0.000000,34.646700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.465600,0.000000,34.646700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.906200,0.000000,34.646700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<16.465600,0.000000,34.646700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.338700,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.338700,0.000000,34.206000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<17.338700,0.000000,34.206000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.338700,0.000000,34.206000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.999600,0.000000,34.206000>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<17.338700,0.000000,34.206000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.999600,0.000000,34.206000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.219900,0.000000,33.985700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<17.999600,0.000000,34.206000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.219900,0.000000,33.985700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.219900,0.000000,33.324800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<18.219900,0.000000,33.324800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.868700,0.000000,34.426400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.868700,0.000000,33.545100>}
box{<0,0,-0.050800><0.881300,0.036000,0.050800> rotate<0,-90.000000,0> translate<18.868700,0.000000,33.545100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.868700,0.000000,33.545100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.089000,0.000000,33.324800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<18.868700,0.000000,33.545100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.648400,0.000000,34.206000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.089000,0.000000,34.206000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<18.648400,0.000000,34.206000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.182400,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.741800,0.000000,33.324800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<19.741800,0.000000,33.324800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.741800,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.521500,0.000000,33.545100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<19.521500,0.000000,33.545100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.521500,0.000000,33.545100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.521500,0.000000,33.985700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,90.000000,0> translate<19.521500,0.000000,33.985700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.521500,0.000000,33.985700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.741800,0.000000,34.206000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<19.521500,0.000000,33.985700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.741800,0.000000,34.206000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.182400,0.000000,34.206000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<19.741800,0.000000,34.206000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.182400,0.000000,34.206000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.402700,0.000000,33.985700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<20.182400,0.000000,34.206000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.402700,0.000000,33.985700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.402700,0.000000,33.765400>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<20.402700,0.000000,33.765400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.402700,0.000000,33.765400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.521500,0.000000,33.765400>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<19.521500,0.000000,33.765400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.831200,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.831200,0.000000,34.206000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<20.831200,0.000000,34.206000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.831200,0.000000,33.765400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.271800,0.000000,34.206000>}
box{<0,0,-0.050800><0.623102,0.036000,0.050800> rotate<0,-44.997030,0> translate<20.831200,0.000000,33.765400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.271800,0.000000,34.206000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.492100,0.000000,34.206000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<21.271800,0.000000,34.206000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.142900,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.142900,0.000000,34.426400>}
box{<0,0,-0.050800><1.101600,0.036000,0.050800> rotate<0,90.000000,0> translate<22.142900,0.000000,34.426400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.142900,0.000000,34.426400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.363200,0.000000,34.646700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<22.142900,0.000000,34.426400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.922600,0.000000,33.985700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.363200,0.000000,33.985700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<21.922600,0.000000,33.985700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.016000,0.000000,34.206000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.456600,0.000000,34.206000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<23.016000,0.000000,34.206000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.456600,0.000000,34.206000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.676900,0.000000,33.985700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<23.456600,0.000000,34.206000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.676900,0.000000,33.985700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.676900,0.000000,33.324800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<23.676900,0.000000,33.324800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.676900,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.016000,0.000000,33.324800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<23.016000,0.000000,33.324800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.016000,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.795700,0.000000,33.545100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<22.795700,0.000000,33.545100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.795700,0.000000,33.545100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.016000,0.000000,33.765400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<22.795700,0.000000,33.545100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.016000,0.000000,33.765400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.676900,0.000000,33.765400>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<23.016000,0.000000,33.765400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.986600,0.000000,34.206000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.325700,0.000000,34.206000>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<24.325700,0.000000,34.206000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.325700,0.000000,34.206000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.105400,0.000000,33.985700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<24.105400,0.000000,33.985700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.105400,0.000000,33.985700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.105400,0.000000,33.545100>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,-90.000000,0> translate<24.105400,0.000000,33.545100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.105400,0.000000,33.545100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.325700,0.000000,33.324800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<24.105400,0.000000,33.545100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.325700,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.986600,0.000000,33.324800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<24.325700,0.000000,33.324800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.076000,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.635400,0.000000,33.324800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<25.635400,0.000000,33.324800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.635400,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.415100,0.000000,33.545100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<25.415100,0.000000,33.545100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.415100,0.000000,33.545100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.415100,0.000000,33.985700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,90.000000,0> translate<25.415100,0.000000,33.985700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.415100,0.000000,33.985700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.635400,0.000000,34.206000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<25.415100,0.000000,33.985700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.635400,0.000000,34.206000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.076000,0.000000,34.206000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<25.635400,0.000000,34.206000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.076000,0.000000,34.206000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.296300,0.000000,33.985700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<26.076000,0.000000,34.206000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.296300,0.000000,33.985700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.296300,0.000000,33.765400>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<26.296300,0.000000,33.765400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.296300,0.000000,33.765400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.415100,0.000000,33.765400>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<25.415100,0.000000,33.765400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.034500,0.000000,34.206000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.475100,0.000000,33.324800>}
box{<0,0,-0.050800><0.985212,0.036000,0.050800> rotate<0,63.430762,0> translate<28.034500,0.000000,34.206000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.475100,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.915700,0.000000,34.206000>}
box{<0,0,-0.050800><0.985212,0.036000,0.050800> rotate<0,-63.430762,0> translate<28.475100,0.000000,33.324800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.344200,0.000000,34.206000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.784800,0.000000,34.646700>}
box{<0,0,-0.050800><0.623173,0.036000,0.050800> rotate<0,-45.003531,0> translate<29.344200,0.000000,34.206000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.784800,0.000000,34.646700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.784800,0.000000,33.324800>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,-90.000000,0> translate<29.784800,0.000000,33.324800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.344200,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.225400,0.000000,33.324800>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<29.344200,0.000000,33.324800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.653900,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.653900,0.000000,33.545100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,90.000000,0> translate<30.653900,0.000000,33.545100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.653900,0.000000,33.545100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.874200,0.000000,33.545100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<30.653900,0.000000,33.545100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.874200,0.000000,33.545100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.874200,0.000000,33.324800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<30.874200,0.000000,33.324800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.874200,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.653900,0.000000,33.324800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<30.653900,0.000000,33.324800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.308700,0.000000,33.545100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.308700,0.000000,34.426400>}
box{<0,0,-0.050800><0.881300,0.036000,0.050800> rotate<0,90.000000,0> translate<31.308700,0.000000,34.426400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.308700,0.000000,34.426400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.529000,0.000000,34.646700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<31.308700,0.000000,34.426400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.529000,0.000000,34.646700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.969600,0.000000,34.646700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<31.529000,0.000000,34.646700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.969600,0.000000,34.646700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.189900,0.000000,34.426400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<31.969600,0.000000,34.646700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.189900,0.000000,34.426400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.189900,0.000000,33.545100>}
box{<0,0,-0.050800><0.881300,0.036000,0.050800> rotate<0,-90.000000,0> translate<32.189900,0.000000,33.545100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.189900,0.000000,33.545100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.969600,0.000000,33.324800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<31.969600,0.000000,33.324800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.969600,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.529000,0.000000,33.324800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<31.529000,0.000000,33.324800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.529000,0.000000,33.324800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.308700,0.000000,33.545100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<31.308700,0.000000,33.545100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.308700,0.000000,33.545100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.189900,0.000000,34.426400>}
box{<0,0,-0.050800><1.246276,0.036000,0.050800> rotate<0,-45.000281,0> translate<31.308700,0.000000,33.545100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.226800,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.226800,0.000000,31.666000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<11.226800,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.226800,0.000000,31.666000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.447100,0.000000,31.666000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<11.226800,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.447100,0.000000,31.666000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.667400,0.000000,31.445700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<11.447100,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.667400,0.000000,31.445700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.667400,0.000000,30.784800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<11.667400,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.667400,0.000000,31.445700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887700,0.000000,31.666000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<11.667400,0.000000,31.445700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887700,0.000000,31.666000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.108000,0.000000,31.445700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<11.887700,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.108000,0.000000,31.445700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.108000,0.000000,30.784800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<12.108000,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.756800,0.000000,31.666000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.197400,0.000000,31.666000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<12.756800,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.197400,0.000000,31.666000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.417700,0.000000,31.445700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<13.197400,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.417700,0.000000,31.445700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.417700,0.000000,30.784800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<13.417700,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.417700,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.756800,0.000000,30.784800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<12.756800,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.756800,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.536500,0.000000,31.005100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<12.536500,0.000000,31.005100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.536500,0.000000,31.005100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.756800,0.000000,31.225400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<12.536500,0.000000,31.005100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.756800,0.000000,31.225400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.417700,0.000000,31.225400>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<12.756800,0.000000,31.225400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.846200,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.846200,0.000000,32.106700>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,90.000000,0> translate<13.846200,0.000000,32.106700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.507100,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.846200,0.000000,31.225400>}
box{<0,0,-0.050800><0.794303,0.036000,0.050800> rotate<0,33.687844,0> translate<13.846200,0.000000,31.225400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.846200,0.000000,31.225400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.507100,0.000000,31.666000>}
box{<0,0,-0.050800><0.794303,0.036000,0.050800> rotate<0,-33.687844,0> translate<13.846200,0.000000,31.225400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.598500,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.157900,0.000000,30.784800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<15.157900,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.157900,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.937600,0.000000,31.005100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<14.937600,0.000000,31.005100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.937600,0.000000,31.005100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.937600,0.000000,31.445700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,90.000000,0> translate<14.937600,0.000000,31.445700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.937600,0.000000,31.445700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.157900,0.000000,31.666000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<14.937600,0.000000,31.445700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.157900,0.000000,31.666000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.598500,0.000000,31.666000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<15.157900,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.598500,0.000000,31.666000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.818800,0.000000,31.445700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<15.598500,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.818800,0.000000,31.445700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.818800,0.000000,31.225400>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<15.818800,0.000000,31.225400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.818800,0.000000,31.225400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.937600,0.000000,31.225400>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<14.937600,0.000000,31.225400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.247300,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.247300,0.000000,31.005100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,90.000000,0> translate<16.247300,0.000000,31.005100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.247300,0.000000,31.005100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.467600,0.000000,31.005100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<16.247300,0.000000,31.005100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.467600,0.000000,31.005100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.467600,0.000000,30.784800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<16.467600,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.467600,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.247300,0.000000,30.784800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<16.247300,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.902100,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.902100,0.000000,31.666000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<16.902100,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.902100,0.000000,31.225400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.342700,0.000000,31.666000>}
box{<0,0,-0.050800><0.623102,0.036000,0.050800> rotate<0,-44.997030,0> translate<16.902100,0.000000,31.225400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.342700,0.000000,31.666000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.563000,0.000000,31.666000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<17.342700,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.993500,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.993500,0.000000,31.666000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<17.993500,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.993500,0.000000,31.225400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.434100,0.000000,31.666000>}
box{<0,0,-0.050800><0.623102,0.036000,0.050800> rotate<0,-44.997030,0> translate<17.993500,0.000000,31.225400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.434100,0.000000,31.666000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.654400,0.000000,31.666000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<18.434100,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.084900,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.084900,0.000000,31.666000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<19.084900,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.084900,0.000000,31.225400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.525500,0.000000,31.666000>}
box{<0,0,-0.050800><0.623102,0.036000,0.050800> rotate<0,-44.997030,0> translate<19.084900,0.000000,31.225400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.525500,0.000000,31.666000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.745800,0.000000,31.666000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<19.525500,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.396600,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.396600,0.000000,31.886400>}
box{<0,0,-0.050800><1.101600,0.036000,0.050800> rotate<0,90.000000,0> translate<20.396600,0.000000,31.886400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.396600,0.000000,31.886400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.616900,0.000000,32.106700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<20.396600,0.000000,31.886400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.176300,0.000000,31.445700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.616900,0.000000,31.445700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<20.176300,0.000000,31.445700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.049400,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.049400,0.000000,31.005100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,90.000000,0> translate<21.049400,0.000000,31.005100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.049400,0.000000,31.005100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.269700,0.000000,31.005100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<21.049400,0.000000,31.005100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.269700,0.000000,31.005100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.269700,0.000000,30.784800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<21.269700,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.269700,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.049400,0.000000,30.784800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<21.049400,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.924500,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.365100,0.000000,30.784800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<21.924500,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.365100,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.585400,0.000000,31.005100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<22.365100,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.585400,0.000000,31.005100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.585400,0.000000,31.445700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,90.000000,0> translate<22.585400,0.000000,31.445700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.585400,0.000000,31.445700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.365100,0.000000,31.666000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<22.365100,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.365100,0.000000,31.666000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.924500,0.000000,31.666000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<21.924500,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.924500,0.000000,31.666000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.704200,0.000000,31.445700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<21.704200,0.000000,31.445700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.704200,0.000000,31.445700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.704200,0.000000,31.005100>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,-90.000000,0> translate<21.704200,0.000000,31.005100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.704200,0.000000,31.005100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.924500,0.000000,30.784800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<21.704200,0.000000,31.005100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.013900,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.013900,0.000000,31.666000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<23.013900,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.013900,0.000000,31.225400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.454500,0.000000,31.666000>}
box{<0,0,-0.050800><0.623102,0.036000,0.050800> rotate<0,-44.997030,0> translate<23.013900,0.000000,31.225400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.454500,0.000000,31.666000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.674800,0.000000,31.666000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<23.454500,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.545900,0.000000,30.344200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.766200,0.000000,30.344200>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<24.545900,0.000000,30.344200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.766200,0.000000,30.344200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.986500,0.000000,30.564500>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<24.766200,0.000000,30.344200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.986500,0.000000,30.564500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.986500,0.000000,31.666000>}
box{<0,0,-0.050800><1.101500,0.036000,0.050800> rotate<0,90.000000,0> translate<24.986500,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.986500,0.000000,31.666000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.325600,0.000000,31.666000>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<24.325600,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.325600,0.000000,31.666000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.105300,0.000000,31.445700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<24.105300,0.000000,31.445700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.105300,0.000000,31.445700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.105300,0.000000,31.005100>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,-90.000000,0> translate<24.105300,0.000000,31.005100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.105300,0.000000,31.005100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.325600,0.000000,30.784800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<24.105300,0.000000,31.005100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.325600,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.986500,0.000000,30.784800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<24.325600,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.415000,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.296200,0.000000,32.106700>}
box{<0,0,-0.050800><1.588689,0.036000,0.050800> rotate<0,-56.308217,0> translate<25.415000,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.724700,0.000000,32.106700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.945000,0.000000,32.106700>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<26.724700,0.000000,32.106700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.945000,0.000000,32.106700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.945000,0.000000,30.784800>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,-90.000000,0> translate<26.945000,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.724700,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.165300,0.000000,30.784800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<26.724700,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.479000,0.000000,31.666000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.818100,0.000000,31.666000>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<27.818100,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.818100,0.000000,31.666000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.597800,0.000000,31.445700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<27.597800,0.000000,31.445700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.597800,0.000000,31.445700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.597800,0.000000,31.005100>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,-90.000000,0> translate<27.597800,0.000000,31.005100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.597800,0.000000,31.005100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.818100,0.000000,30.784800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<27.597800,0.000000,31.005100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.818100,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.479000,0.000000,30.784800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<27.818100,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.788700,0.000000,32.106700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.788700,0.000000,30.784800>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,-90.000000,0> translate<29.788700,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.788700,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.127800,0.000000,30.784800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<29.127800,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.127800,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.907500,0.000000,31.005100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<28.907500,0.000000,31.005100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.907500,0.000000,31.005100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.907500,0.000000,31.445700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,90.000000,0> translate<28.907500,0.000000,31.445700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.907500,0.000000,31.445700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.127800,0.000000,31.666000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<28.907500,0.000000,31.445700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.127800,0.000000,31.666000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.788700,0.000000,31.666000>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<29.127800,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.217200,0.000000,31.445700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.098400,0.000000,31.445700>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<30.217200,0.000000,31.445700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.526900,0.000000,31.666000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.967500,0.000000,32.106700>}
box{<0,0,-0.050800><0.623173,0.036000,0.050800> rotate<0,-45.003531,0> translate<31.526900,0.000000,31.666000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.967500,0.000000,32.106700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.967500,0.000000,30.784800>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,-90.000000,0> translate<31.967500,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.526900,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.408100,0.000000,30.784800>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<31.526900,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.836600,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.836600,0.000000,31.005100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,90.000000,0> translate<32.836600,0.000000,31.005100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.836600,0.000000,31.005100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.056900,0.000000,31.005100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<32.836600,0.000000,31.005100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.056900,0.000000,31.005100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.056900,0.000000,30.784800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<33.056900,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.056900,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.836600,0.000000,30.784800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<32.836600,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.491400,0.000000,31.005100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.491400,0.000000,31.886400>}
box{<0,0,-0.050800><0.881300,0.036000,0.050800> rotate<0,90.000000,0> translate<33.491400,0.000000,31.886400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.491400,0.000000,31.886400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.711700,0.000000,32.106700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<33.491400,0.000000,31.886400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.711700,0.000000,32.106700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.152300,0.000000,32.106700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<33.711700,0.000000,32.106700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.152300,0.000000,32.106700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.372600,0.000000,31.886400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<34.152300,0.000000,32.106700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.372600,0.000000,31.886400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.372600,0.000000,31.005100>}
box{<0,0,-0.050800><0.881300,0.036000,0.050800> rotate<0,-90.000000,0> translate<34.372600,0.000000,31.005100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.372600,0.000000,31.005100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.152300,0.000000,30.784800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<34.152300,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.152300,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.711700,0.000000,30.784800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<33.711700,0.000000,30.784800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.711700,0.000000,30.784800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.491400,0.000000,31.005100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<33.491400,0.000000,31.005100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.491400,0.000000,31.005100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.372600,0.000000,31.886400>}
box{<0,0,-0.050800><1.246276,0.036000,0.050800> rotate<0,-45.000281,0> translate<33.491400,0.000000,31.005100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.027700,0.000000,16.324300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.027700,0.000000,15.739600>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,-90.000000,0> translate<6.027700,0.000000,15.739600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.027700,0.000000,15.739600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.222600,0.000000,15.544800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<6.027700,0.000000,15.739600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.222600,0.000000,15.544800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.612400,0.000000,15.544800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<6.222600,0.000000,15.544800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.612400,0.000000,15.544800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,15.739600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<6.612400,0.000000,15.544800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,15.739600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,16.324300>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,90.000000,0> translate<6.807200,0.000000,16.324300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,17.883400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,17.883400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<5.637900,0.000000,17.883400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,17.883400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,18.468000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<5.637900,0.000000,18.468000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,18.468000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,18.662900>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<5.637900,0.000000,18.468000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,18.662900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.222600,0.000000,18.662900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<5.832800,0.000000,18.662900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.222600,0.000000,18.662900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.417500,0.000000,18.468000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<6.222600,0.000000,18.662900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.417500,0.000000,18.468000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.417500,0.000000,17.883400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<6.417500,0.000000,17.883400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.417500,0.000000,18.273100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,18.662900>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<6.417500,0.000000,18.273100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,19.052700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,19.052700>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<5.637900,0.000000,19.052700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,19.052700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,19.637300>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<5.637900,0.000000,19.637300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,19.637300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,19.832200>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<5.637900,0.000000,19.637300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,19.832200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.222600,0.000000,19.832200>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<5.832800,0.000000,19.832200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.222600,0.000000,19.832200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.417500,0.000000,19.637300>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<6.222600,0.000000,19.832200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.417500,0.000000,19.637300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.417500,0.000000,19.052700>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<6.417500,0.000000,19.052700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.417500,0.000000,19.442400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,19.832200>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<6.417500,0.000000,19.442400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,20.222000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,20.222000>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<5.637900,0.000000,20.222000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,20.222000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,20.806600>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<5.637900,0.000000,20.806600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,20.806600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,21.001500>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<5.637900,0.000000,20.806600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,21.001500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.222600,0.000000,21.001500>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<5.832800,0.000000,21.001500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.222600,0.000000,21.001500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.417500,0.000000,20.806600>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<6.222600,0.000000,21.001500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.417500,0.000000,20.806600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.417500,0.000000,20.222000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<6.417500,0.000000,20.222000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.417500,0.000000,20.611700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,21.001500>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<6.417500,0.000000,20.611700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,21.391300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,21.391300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<5.637900,0.000000,21.391300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,21.391300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,22.170800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<5.637900,0.000000,22.170800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.222600,0.000000,21.391300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.222600,0.000000,21.781000>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<6.222600,0.000000,21.781000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,24.509400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,23.729900>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<6.807200,0.000000,23.729900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,23.729900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.027700,0.000000,24.509400>}
box{<0,0,-0.050800><1.102379,0.036000,0.050800> rotate<0,44.997030,0> translate<6.027700,0.000000,24.509400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.027700,0.000000,24.509400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,24.509400>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<5.832800,0.000000,24.509400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,24.509400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,24.314500>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<5.637900,0.000000,24.314500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,24.314500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,23.924700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<5.637900,0.000000,23.924700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,23.924700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,23.729900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<5.637900,0.000000,23.924700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.612400,0.000000,24.899200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,24.899200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<5.832800,0.000000,24.899200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,24.899200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,25.094000>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<5.637900,0.000000,25.094000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,25.094000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,25.483800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<5.637900,0.000000,25.483800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,25.483800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,25.678700>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<5.637900,0.000000,25.483800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,25.678700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.612400,0.000000,25.678700>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<5.832800,0.000000,25.678700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.612400,0.000000,25.678700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,25.483800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<6.612400,0.000000,25.678700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,25.483800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,25.094000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<6.807200,0.000000,25.094000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,25.094000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.612400,0.000000,24.899200>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<6.612400,0.000000,24.899200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.612400,0.000000,24.899200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,25.678700>}
box{<0,0,-0.050800><1.102450,0.036000,0.050800> rotate<0,44.993355,0> translate<5.832800,0.000000,25.678700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.612400,0.000000,26.068500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,26.068500>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<5.832800,0.000000,26.068500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,26.068500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,26.263300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<5.637900,0.000000,26.263300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,26.263300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,26.653100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<5.637900,0.000000,26.653100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,26.653100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,26.848000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<5.637900,0.000000,26.653100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,26.848000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.612400,0.000000,26.848000>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<5.832800,0.000000,26.848000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.612400,0.000000,26.848000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,26.653100>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<6.612400,0.000000,26.848000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,26.653100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,26.263300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<6.807200,0.000000,26.263300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,26.263300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.612400,0.000000,26.068500>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<6.612400,0.000000,26.068500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.612400,0.000000,26.068500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,26.848000>}
box{<0,0,-0.050800><1.102450,0.036000,0.050800> rotate<0,44.993355,0> translate<5.832800,0.000000,26.848000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,27.237800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,27.432600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<5.637900,0.000000,27.432600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,27.432600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,27.822400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<5.637900,0.000000,27.822400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.637900,0.000000,27.822400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,28.017300>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<5.637900,0.000000,27.822400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,28.017300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.027700,0.000000,28.017300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<5.832800,0.000000,28.017300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.027700,0.000000,28.017300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.222600,0.000000,27.822400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<6.027700,0.000000,28.017300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.222600,0.000000,27.822400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.417500,0.000000,28.017300>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<6.222600,0.000000,27.822400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.417500,0.000000,28.017300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.612400,0.000000,28.017300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<6.417500,0.000000,28.017300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.612400,0.000000,28.017300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,27.822400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<6.612400,0.000000,28.017300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,27.822400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,27.432600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<6.807200,0.000000,27.432600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.807200,0.000000,27.432600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.612400,0.000000,27.237800>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<6.612400,0.000000,27.237800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.612400,0.000000,27.237800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.417500,0.000000,27.237800>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<6.417500,0.000000,27.237800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.417500,0.000000,27.237800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.222600,0.000000,27.432600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<6.222600,0.000000,27.432600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.222600,0.000000,27.432600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.027700,0.000000,27.237800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<6.027700,0.000000,27.237800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.027700,0.000000,27.237800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<5.832800,0.000000,27.237800>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<5.832800,0.000000,27.237800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.222600,0.000000,27.432600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<6.222600,0.000000,27.822400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<6.222600,0.000000,27.822400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.177900,0.000000,15.544800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,15.544800>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<8.177900,0.000000,15.544800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,15.544800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,16.324300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<9.347200,0.000000,16.324300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.567700,0.000000,16.714100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.567700,0.000000,16.908900>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,90.000000,0> translate<8.567700,0.000000,16.908900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.567700,0.000000,16.908900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,16.908900>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<8.567700,0.000000,16.908900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,16.714100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,17.103800>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<9.347200,0.000000,17.103800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<7.983000,0.000000,16.908900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.177900,0.000000,16.908900>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<7.983000,0.000000,16.908900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.567700,0.000000,18.273100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.567700,0.000000,17.688400>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,-90.000000,0> translate<8.567700,0.000000,17.688400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.567700,0.000000,17.688400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.762600,0.000000,17.493600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<8.567700,0.000000,17.688400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.762600,0.000000,17.493600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.152400,0.000000,17.493600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<8.762600,0.000000,17.493600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.152400,0.000000,17.493600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,17.688400>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<9.152400,0.000000,17.493600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,17.688400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,18.273100>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,90.000000,0> translate<9.347200,0.000000,18.273100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,19.247500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,18.857700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<9.347200,0.000000,18.857700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,18.857700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.152400,0.000000,18.662900>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<9.152400,0.000000,18.662900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.152400,0.000000,18.662900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.762600,0.000000,18.662900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<8.762600,0.000000,18.662900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.762600,0.000000,18.662900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.567700,0.000000,18.857700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<8.567700,0.000000,18.857700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.567700,0.000000,18.857700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.567700,0.000000,19.247500>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<8.567700,0.000000,19.247500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.567700,0.000000,19.247500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.762600,0.000000,19.442400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<8.567700,0.000000,19.247500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.762600,0.000000,19.442400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.957500,0.000000,19.442400>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<8.762600,0.000000,19.442400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.957500,0.000000,19.442400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.957500,0.000000,18.662900>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<8.957500,0.000000,18.662900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,19.832200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.567700,0.000000,19.832200>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<8.567700,0.000000,19.832200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.567700,0.000000,19.832200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.567700,0.000000,20.416800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<8.567700,0.000000,20.416800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.567700,0.000000,20.416800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.762600,0.000000,20.611700>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<8.567700,0.000000,20.416800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.762600,0.000000,20.611700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,20.611700>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<8.762600,0.000000,20.611700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,21.001500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,21.586100>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<9.347200,0.000000,21.586100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,21.586100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.152400,0.000000,21.781000>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<9.152400,0.000000,21.781000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.152400,0.000000,21.781000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.957500,0.000000,21.586100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<8.957500,0.000000,21.586100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.957500,0.000000,21.586100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.957500,0.000000,21.196300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<8.957500,0.000000,21.196300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.957500,0.000000,21.196300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.762600,0.000000,21.001500>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<8.762600,0.000000,21.001500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.762600,0.000000,21.001500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.567700,0.000000,21.196300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<8.567700,0.000000,21.196300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.567700,0.000000,21.196300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.567700,0.000000,21.781000>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,90.000000,0> translate<8.567700,0.000000,21.781000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,22.755400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,22.365600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<9.347200,0.000000,22.365600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,22.365600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.152400,0.000000,22.170800>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<9.152400,0.000000,22.170800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.152400,0.000000,22.170800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.762600,0.000000,22.170800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<8.762600,0.000000,22.170800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.762600,0.000000,22.170800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.567700,0.000000,22.365600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<8.567700,0.000000,22.365600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.567700,0.000000,22.365600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.567700,0.000000,22.755400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<8.567700,0.000000,22.755400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.567700,0.000000,22.755400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.762600,0.000000,22.950300>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<8.567700,0.000000,22.755400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.762600,0.000000,22.950300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.957500,0.000000,22.950300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<8.762600,0.000000,22.950300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.957500,0.000000,22.950300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.957500,0.000000,22.170800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<8.957500,0.000000,22.170800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.372800,0.000000,25.288900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.177900,0.000000,25.094000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<8.177900,0.000000,25.094000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.177900,0.000000,25.094000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.177900,0.000000,24.704200>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<8.177900,0.000000,24.704200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.177900,0.000000,24.704200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.372800,0.000000,24.509400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<8.177900,0.000000,24.704200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.372800,0.000000,24.509400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.152400,0.000000,24.509400>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<8.372800,0.000000,24.509400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.152400,0.000000,24.509400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,24.704200>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<9.152400,0.000000,24.509400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,24.704200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,25.094000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<9.347200,0.000000,25.094000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,25.094000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.152400,0.000000,25.288900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<9.152400,0.000000,25.288900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.152400,0.000000,25.288900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.762600,0.000000,25.288900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<8.762600,0.000000,25.288900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.762600,0.000000,25.288900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.762600,0.000000,24.899100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<8.762600,0.000000,24.899100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,25.678700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.177900,0.000000,25.678700>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<8.177900,0.000000,25.678700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.177900,0.000000,25.678700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.177900,0.000000,26.263300>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<8.177900,0.000000,26.263300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.177900,0.000000,26.263300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.372800,0.000000,26.458200>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<8.177900,0.000000,26.263300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.372800,0.000000,26.458200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.762600,0.000000,26.458200>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<8.372800,0.000000,26.458200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.762600,0.000000,26.458200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.957500,0.000000,26.263300>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<8.762600,0.000000,26.458200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.957500,0.000000,26.263300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.957500,0.000000,25.678700>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<8.957500,0.000000,25.678700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<8.177900,0.000000,26.848000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,26.848000>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<8.177900,0.000000,26.848000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,26.848000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<9.347200,0.000000,27.627500>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<9.347200,0.000000,27.627500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.872200,0.000000,42.597100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.872200,0.000000,40.970200>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,-90.000000,0> translate<18.872200,0.000000,40.970200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.872200,0.000000,40.970200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.956800,0.000000,40.970200>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<18.872200,0.000000,40.970200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.593900,0.000000,42.326000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.322700,0.000000,42.597100>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,44.986466,0> translate<21.322700,0.000000,42.597100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.322700,0.000000,42.597100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.780400,0.000000,42.597100>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<20.780400,0.000000,42.597100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.780400,0.000000,42.597100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.509300,0.000000,42.326000>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<20.509300,0.000000,42.326000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.509300,0.000000,42.326000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.509300,0.000000,41.241300>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,-90.000000,0> translate<20.509300,0.000000,41.241300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.509300,0.000000,41.241300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.780400,0.000000,40.970200>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<20.509300,0.000000,41.241300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.780400,0.000000,40.970200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.322700,0.000000,40.970200>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<20.780400,0.000000,40.970200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.322700,0.000000,40.970200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.593900,0.000000,41.241300>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-44.986466,0> translate<21.322700,0.000000,40.970200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.146400,0.000000,42.597100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.146400,0.000000,40.970200>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,-90.000000,0> translate<22.146400,0.000000,40.970200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.146400,0.000000,40.970200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.959800,0.000000,40.970200>}
box{<0,0,-0.076200><0.813400,0.036000,0.076200> rotate<0,0.000000,0> translate<22.146400,0.000000,40.970200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.959800,0.000000,40.970200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.231000,0.000000,41.241300>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-44.986466,0> translate<22.959800,0.000000,40.970200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.231000,0.000000,41.241300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.231000,0.000000,42.326000>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,90.000000,0> translate<23.231000,0.000000,42.326000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.231000,0.000000,42.326000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.959800,0.000000,42.597100>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,44.986466,0> translate<22.959800,0.000000,42.597100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.959800,0.000000,42.597100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.146400,0.000000,42.597100>}
box{<0,0,-0.076200><0.813400,0.036000,0.076200> rotate<0,0.000000,0> translate<22.146400,0.000000,42.597100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,13.766800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,13.766800>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,0.000000,0> translate<11.107700,0.000000,13.766800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,13.766800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,13.961600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<11.692400,0.000000,13.766800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,13.961600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,14.156500>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<11.692400,0.000000,14.156500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,14.156500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,14.351400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<11.692400,0.000000,14.156500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,14.351400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,14.546300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<11.692400,0.000000,14.546300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,14.546300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,14.546300>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,0.000000,0> translate<11.107700,0.000000,14.546300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,14.936100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,14.936100>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,0.000000,0> translate<11.107700,0.000000,14.936100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,14.936100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,15.130900>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<11.692400,0.000000,14.936100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,15.130900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,15.325800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<11.692400,0.000000,15.325800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,15.325800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,15.520700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<11.692400,0.000000,15.325800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,15.520700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,15.715600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<11.692400,0.000000,15.715600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,15.715600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,15.715600>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,0.000000,0> translate<11.107700,0.000000,15.715600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,16.105400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,16.105400>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,0.000000,0> translate<11.107700,0.000000,16.105400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,16.105400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,16.300200>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<11.692400,0.000000,16.105400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,16.300200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,16.495100>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<11.692400,0.000000,16.495100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,16.495100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,16.690000>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<11.692400,0.000000,16.495100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,16.690000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,16.884900>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<11.692400,0.000000,16.884900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,16.884900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,16.884900>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,0.000000,0> translate<11.107700,0.000000,16.884900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,17.274700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,17.274700>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<11.692400,0.000000,17.274700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,17.274700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,17.469500>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,90.000000,0> translate<11.692400,0.000000,17.469500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,17.469500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,17.469500>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<11.692400,0.000000,17.469500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,17.469500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,17.274700>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,-90.000000,0> translate<11.887200,0.000000,17.274700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,17.859300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<10.717900,0.000000,17.859300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<10.717900,0.000000,17.859300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<10.717900,0.000000,17.859300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<10.717900,0.000000,18.443900>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<10.717900,0.000000,18.443900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<10.717900,0.000000,18.443900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<10.912800,0.000000,18.638800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<10.717900,0.000000,18.443900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<10.912800,0.000000,18.638800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.302600,0.000000,18.638800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<10.912800,0.000000,18.638800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.302600,0.000000,18.638800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.497500,0.000000,18.443900>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<11.302600,0.000000,18.638800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.497500,0.000000,18.443900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.497500,0.000000,17.859300>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<11.497500,0.000000,17.859300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.497500,0.000000,18.249000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,18.638800>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<11.497500,0.000000,18.249000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,19.613200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,19.223400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<11.887200,0.000000,19.223400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,19.223400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,19.028600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<11.692400,0.000000,19.028600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,19.028600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.302600,0.000000,19.028600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<11.302600,0.000000,19.028600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.302600,0.000000,19.028600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,19.223400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<11.107700,0.000000,19.223400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,19.223400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,19.613200>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<11.107700,0.000000,19.613200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,19.613200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.302600,0.000000,19.808100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<11.107700,0.000000,19.613200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.302600,0.000000,19.808100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.497500,0.000000,19.808100>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<11.302600,0.000000,19.808100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.497500,0.000000,19.808100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.497500,0.000000,19.028600>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<11.497500,0.000000,19.028600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.276900,0.000000,20.197900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,20.197900>}
box{<0,0,-0.050800><1.169200,0.036000,0.050800> rotate<0,0.000000,0> translate<11.107700,0.000000,20.197900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,20.197900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,20.782500>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<11.107700,0.000000,20.782500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,20.782500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.302600,0.000000,20.977400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<11.107700,0.000000,20.782500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.302600,0.000000,20.977400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,20.977400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<11.302600,0.000000,20.977400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,20.977400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,20.782500>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<11.692400,0.000000,20.977400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,20.782500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,20.197900>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<11.887200,0.000000,20.197900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,21.367200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<10.717900,0.000000,21.367200>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<10.717900,0.000000,21.367200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<10.717900,0.000000,21.367200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<10.717900,0.000000,21.951800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<10.717900,0.000000,21.951800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<10.717900,0.000000,21.951800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<10.912800,0.000000,22.146700>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<10.717900,0.000000,21.951800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<10.912800,0.000000,22.146700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.302600,0.000000,22.146700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<10.912800,0.000000,22.146700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.302600,0.000000,22.146700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.497500,0.000000,21.951800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<11.302600,0.000000,22.146700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.497500,0.000000,21.951800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.497500,0.000000,21.367200>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<11.497500,0.000000,21.367200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.497500,0.000000,21.756900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,22.146700>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<11.497500,0.000000,21.756900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,22.731300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,23.121100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<11.107700,0.000000,23.121100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,23.121100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.302600,0.000000,23.316000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<11.107700,0.000000,23.121100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.302600,0.000000,23.316000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,23.316000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<11.302600,0.000000,23.316000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,23.316000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,22.731300>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,-90.000000,0> translate<11.887200,0.000000,22.731300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,22.731300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,22.536500>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<11.692400,0.000000,22.536500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,22.536500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.497500,0.000000,22.731300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<11.497500,0.000000,22.731300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.497500,0.000000,22.731300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.497500,0.000000,23.316000>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,90.000000,0> translate<11.497500,0.000000,23.316000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.276900,0.000000,23.705800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,23.705800>}
box{<0,0,-0.050800><1.169200,0.036000,0.050800> rotate<0,0.000000,0> translate<11.107700,0.000000,23.705800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,23.705800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,24.290400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<11.107700,0.000000,24.290400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,24.290400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.302600,0.000000,24.485300>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<11.107700,0.000000,24.290400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.302600,0.000000,24.485300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,24.485300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<11.302600,0.000000,24.485300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,24.485300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,24.290400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<11.692400,0.000000,24.485300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,24.290400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,23.705800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<11.887200,0.000000,23.705800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,24.875100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,24.875100>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<11.692400,0.000000,24.875100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,24.875100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,25.069900>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,90.000000,0> translate<11.692400,0.000000,25.069900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,25.069900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,25.069900>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<11.692400,0.000000,25.069900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,25.069900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,24.875100>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,-90.000000,0> translate<11.887200,0.000000,24.875100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,25.654500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,26.044300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<11.887200,0.000000,26.044300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,26.044300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,26.239200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<11.692400,0.000000,26.239200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,26.239200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.302600,0.000000,26.239200>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<11.302600,0.000000,26.239200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.302600,0.000000,26.239200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,26.044300>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<11.107700,0.000000,26.044300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,26.044300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,25.654500>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<11.107700,0.000000,25.654500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,25.654500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.302600,0.000000,25.459700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<11.107700,0.000000,25.654500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.302600,0.000000,25.459700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,25.459700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<11.302600,0.000000,25.459700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,25.459700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,25.654500>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<11.692400,0.000000,25.459700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,26.629000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,26.629000>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<11.107700,0.000000,26.629000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.497500,0.000000,26.629000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,27.018700>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,44.989680,0> translate<11.107700,0.000000,27.018700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,27.018700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,27.213600>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,90.000000,0> translate<11.107700,0.000000,27.213600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.276900,0.000000,27.993100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.276900,0.000000,28.188000>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,90.000000,0> translate<12.276900,0.000000,28.188000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.276900,0.000000,28.188000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.082000,0.000000,28.382900>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<12.082000,0.000000,28.382900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.082000,0.000000,28.382900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,28.382900>}
box{<0,0,-0.050800><0.974300,0.036000,0.050800> rotate<0,0.000000,0> translate<11.107700,0.000000,28.382900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,28.382900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,27.798200>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,-90.000000,0> translate<11.107700,0.000000,27.798200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.107700,0.000000,27.798200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.302600,0.000000,27.603400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<11.107700,0.000000,27.798200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.302600,0.000000,27.603400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,27.603400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<11.302600,0.000000,27.603400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.692400,0.000000,27.603400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,27.798200>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<11.692400,0.000000,27.603400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,27.798200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.887200,0.000000,28.382900>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,90.000000,0> translate<11.887200,0.000000,28.382900> }
difference{
cylinder{<6.426200,0,15.976600><6.426200,0.036000,15.976600>0.964400 translate<0,0.000000,0>}
cylinder{<6.426200,-0.1,15.976600><6.426200,0.135000,15.976600>0.761200 translate<0,0.000000,0>}}
//C1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<40.081200,0.000000,15.621000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<40.081200,0.000000,14.986000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<40.081200,0.000000,14.986000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<40.081200,0.000000,14.986000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<40.081200,0.000000,14.351000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<40.081200,0.000000,14.351000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.081200,0.000000,14.986000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.862000,0.000000,14.986000>}
box{<0,0,-0.076200><1.219200,0.036000,0.076200> rotate<0,0.000000,0> translate<38.862000,0.000000,14.986000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<40.716200,0.000000,15.621000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<40.716200,0.000000,14.986000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<40.716200,0.000000,14.986000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<40.716200,0.000000,14.986000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<40.716200,0.000000,14.351000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<40.716200,0.000000,14.351000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.716200,0.000000,14.986000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.910000,0.000000,14.986000>}
box{<0,0,-0.076200><1.193800,0.036000,0.076200> rotate<0,0.000000,0> translate<40.716200,0.000000,14.986000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.703000,0.000000,16.256000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.703000,0.000000,13.716000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,-90.000000,0> translate<36.703000,0.000000,13.716000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.957000,0.000000,13.462000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.815000,0.000000,13.462000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.957000,0.000000,13.462000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.069000,0.000000,13.716000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.069000,0.000000,16.256000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,90.000000,0> translate<44.069000,0.000000,16.256000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.815000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.957000,0.000000,16.510000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.957000,0.000000,16.510000> }
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<43.815000,0.000000,16.256000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<43.815000,0.000000,13.716000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<36.957000,0.000000,13.716000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<36.957000,0.000000,16.256000>}
//H1 silk screen
object{ARC(2.159000,2.489200,180.000000,270.000000,0.036000) translate<6.096000,0.000000,34.544000>}
object{ARC(2.159000,2.489200,0.000000,90.000000,0.036000) translate<6.096000,0.000000,34.544000>}
difference{
cylinder{<6.096000,0,34.544000><6.096000,0.036000,34.544000>3.505200 translate<0,0.000000,0>}
cylinder{<6.096000,-0.1,34.544000><6.096000,0.135000,34.544000>3.352800 translate<0,0.000000,0>}}
difference{
cylinder{<6.096000,0,34.544000><6.096000,0.036000,34.544000>0.990600 translate<0,0.000000,0>}
cylinder{<6.096000,-0.1,34.544000><6.096000,0.135000,34.544000>0.533400 translate<0,0.000000,0>}}
difference{
cylinder{<6.096000,0,34.544000><6.096000,0.036000,34.544000>1.701600 translate<0,0.000000,0>}
cylinder{<6.096000,-0.1,34.544000><6.096000,0.135000,34.544000>1.498400 translate<0,0.000000,0>}}
//H2 silk screen
object{ARC(2.159000,2.489200,180.000000,270.000000,0.036000) translate<6.096000,0.000000,9.525000>}
object{ARC(2.159000,2.489200,0.000000,90.000000,0.036000) translate<6.096000,0.000000,9.525000>}
difference{
cylinder{<6.096000,0,9.525000><6.096000,0.036000,9.525000>3.505200 translate<0,0.000000,0>}
cylinder{<6.096000,-0.1,9.525000><6.096000,0.135000,9.525000>3.352800 translate<0,0.000000,0>}}
difference{
cylinder{<6.096000,0,9.525000><6.096000,0.036000,9.525000>0.990600 translate<0,0.000000,0>}
cylinder{<6.096000,-0.1,9.525000><6.096000,0.135000,9.525000>0.533400 translate<0,0.000000,0>}}
difference{
cylinder{<6.096000,0,9.525000><6.096000,0.036000,9.525000>1.701600 translate<0,0.000000,0>}
cylinder{<6.096000,-0.1,9.525000><6.096000,0.135000,9.525000>1.498400 translate<0,0.000000,0>}}
//H3 silk screen
object{ARC(2.159000,2.489200,180.000000,270.000000,0.036000) translate<62.230000,0.000000,9.525000>}
object{ARC(2.159000,2.489200,0.000000,90.000000,0.036000) translate<62.230000,0.000000,9.525000>}
difference{
cylinder{<62.230000,0,9.525000><62.230000,0.036000,9.525000>3.505200 translate<0,0.000000,0>}
cylinder{<62.230000,-0.1,9.525000><62.230000,0.135000,9.525000>3.352800 translate<0,0.000000,0>}}
difference{
cylinder{<62.230000,0,9.525000><62.230000,0.036000,9.525000>0.990600 translate<0,0.000000,0>}
cylinder{<62.230000,-0.1,9.525000><62.230000,0.135000,9.525000>0.533400 translate<0,0.000000,0>}}
difference{
cylinder{<62.230000,0,9.525000><62.230000,0.036000,9.525000>1.701600 translate<0,0.000000,0>}
cylinder{<62.230000,-0.1,9.525000><62.230000,0.135000,9.525000>1.498400 translate<0,0.000000,0>}}
//H4 silk screen
object{ARC(2.159000,2.489200,180.000000,270.000000,0.036000) translate<62.230000,0.000000,34.544000>}
object{ARC(2.159000,2.489200,0.000000,90.000000,0.036000) translate<62.230000,0.000000,34.544000>}
difference{
cylinder{<62.230000,0,34.544000><62.230000,0.036000,34.544000>3.505200 translate<0,0.000000,0>}
cylinder{<62.230000,-0.1,34.544000><62.230000,0.135000,34.544000>3.352800 translate<0,0.000000,0>}}
difference{
cylinder{<62.230000,0,34.544000><62.230000,0.036000,34.544000>0.990600 translate<0,0.000000,0>}
cylinder{<62.230000,-0.1,34.544000><62.230000,0.135000,34.544000>0.533400 translate<0,0.000000,0>}}
difference{
cylinder{<62.230000,0,34.544000><62.230000,0.036000,34.544000>1.701600 translate<0,0.000000,0>}
cylinder{<62.230000,-0.1,34.544000><62.230000,0.135000,34.544000>1.498400 translate<0,0.000000,0>}}
//IC1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.510000,0.000000,21.209000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.510000,0.000000,19.939000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<16.510000,0.000000,19.939000> }
object{ARC(1.270000,0.152400,270.000000,450.000000,0.036000) translate<16.510000,0.000000,22.479000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.070000,0.000000,19.939000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.070000,0.000000,25.019000>}
box{<0,0,-0.076200><5.080000,0.036000,0.076200> rotate<0,90.000000,0> translate<52.070000,0.000000,25.019000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.510000,0.000000,25.019000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.510000,0.000000,23.749000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<16.510000,0.000000,23.749000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.510000,0.000000,25.019000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.070000,0.000000,25.019000>}
box{<0,0,-0.076200><35.560000,0.036000,0.076200> rotate<0,0.000000,0> translate<16.510000,0.000000,25.019000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.637000,0.000000,19.939000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.070000,0.000000,19.939000>}
box{<0,0,-0.076200><35.433000,0.036000,0.076200> rotate<0,0.000000,0> translate<16.637000,0.000000,19.939000> }
//JP1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.210000,0.000000,8.763000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.575000,0.000000,8.128000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<28.575000,0.000000,8.128000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.575000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.305000,0.000000,8.128000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<27.305000,0.000000,8.128000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.305000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,8.763000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<26.670000,0.000000,8.763000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,8.763000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,10.033000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<26.670000,0.000000,10.033000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,10.033000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.305000,0.000000,10.668000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<26.670000,0.000000,10.033000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.305000,0.000000,10.668000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.575000,0.000000,10.668000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<27.305000,0.000000,10.668000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.575000,0.000000,10.668000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.210000,0.000000,10.033000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<28.575000,0.000000,10.668000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.655000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.385000,0.000000,8.128000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<32.385000,0.000000,8.128000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.385000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.750000,0.000000,8.763000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<31.750000,0.000000,8.763000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.750000,0.000000,8.763000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.750000,0.000000,10.033000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<31.750000,0.000000,10.033000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.750000,0.000000,10.033000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.385000,0.000000,10.668000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<31.750000,0.000000,10.033000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.750000,0.000000,8.763000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.115000,0.000000,8.128000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<31.115000,0.000000,8.128000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.115000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.845000,0.000000,8.128000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<29.845000,0.000000,8.128000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.845000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.210000,0.000000,8.763000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<29.210000,0.000000,8.763000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.210000,0.000000,8.763000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.210000,0.000000,10.033000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<29.210000,0.000000,10.033000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.210000,0.000000,10.033000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.845000,0.000000,10.668000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<29.210000,0.000000,10.033000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.845000,0.000000,10.668000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.115000,0.000000,10.668000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<29.845000,0.000000,10.668000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.115000,0.000000,10.668000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.750000,0.000000,10.033000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<31.115000,0.000000,10.668000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.830000,0.000000,8.763000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.195000,0.000000,8.128000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<36.195000,0.000000,8.128000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.195000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.925000,0.000000,8.128000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.925000,0.000000,8.128000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.925000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.290000,0.000000,8.763000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<34.290000,0.000000,8.763000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.290000,0.000000,8.763000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.290000,0.000000,10.033000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<34.290000,0.000000,10.033000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.290000,0.000000,10.033000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.925000,0.000000,10.668000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<34.290000,0.000000,10.033000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.925000,0.000000,10.668000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.195000,0.000000,10.668000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.925000,0.000000,10.668000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.195000,0.000000,10.668000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.830000,0.000000,10.033000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<36.195000,0.000000,10.668000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.655000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.290000,0.000000,8.763000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<33.655000,0.000000,8.128000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.290000,0.000000,10.033000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.655000,0.000000,10.668000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<33.655000,0.000000,10.668000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.385000,0.000000,10.668000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.655000,0.000000,10.668000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<32.385000,0.000000,10.668000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.005000,0.000000,8.128000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<40.005000,0.000000,8.128000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.005000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.370000,0.000000,8.763000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<39.370000,0.000000,8.763000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.370000,0.000000,8.763000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.370000,0.000000,10.033000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<39.370000,0.000000,10.033000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.370000,0.000000,10.033000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.005000,0.000000,10.668000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<39.370000,0.000000,10.033000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.370000,0.000000,8.763000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.735000,0.000000,8.128000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<38.735000,0.000000,8.128000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.735000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.465000,0.000000,8.128000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<37.465000,0.000000,8.128000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.465000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.830000,0.000000,8.763000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<36.830000,0.000000,8.763000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.830000,0.000000,8.763000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.830000,0.000000,10.033000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<36.830000,0.000000,10.033000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.830000,0.000000,10.033000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.465000,0.000000,10.668000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<36.830000,0.000000,10.033000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.465000,0.000000,10.668000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.735000,0.000000,10.668000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<37.465000,0.000000,10.668000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.735000,0.000000,10.668000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.370000,0.000000,10.033000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<38.735000,0.000000,10.668000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.910000,0.000000,8.763000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.910000,0.000000,10.033000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.910000,0.000000,10.033000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.910000,0.000000,8.763000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<41.275000,0.000000,8.128000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.910000,0.000000,10.033000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,10.668000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<41.275000,0.000000,10.668000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.005000,0.000000,10.668000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,10.668000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<40.005000,0.000000,10.668000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.035000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.765000,0.000000,8.128000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<24.765000,0.000000,8.128000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.765000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,8.763000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<24.130000,0.000000,8.763000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,8.763000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,10.033000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<24.130000,0.000000,10.033000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.130000,0.000000,10.033000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.765000,0.000000,10.668000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<24.130000,0.000000,10.033000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.035000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,8.763000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<26.035000,0.000000,8.128000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.670000,0.000000,10.033000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.035000,0.000000,10.668000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<26.035000,0.000000,10.668000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.765000,0.000000,10.668000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.035000,0.000000,10.668000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<24.765000,0.000000,10.668000> }
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<27.940000,0.000000,9.398000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<30.480000,0.000000,9.398000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<33.020000,0.000000,9.398000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<35.560000,0.000000,9.398000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<38.100000,0.000000,9.398000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<40.640000,0.000000,9.398000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<25.400000,0.000000,9.398000>}
//JP2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.530000,0.000000,10.160000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.165000,0.000000,10.795000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<49.530000,0.000000,10.160000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.165000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.435000,0.000000,10.795000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<50.165000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.435000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.070000,0.000000,10.160000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<51.435000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.070000,0.000000,10.160000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.070000,0.000000,8.890000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<52.070000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.070000,0.000000,8.890000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.435000,0.000000,8.255000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<51.435000,0.000000,8.255000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.435000,0.000000,8.255000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.165000,0.000000,8.255000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<50.165000,0.000000,8.255000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.165000,0.000000,8.255000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.530000,0.000000,8.890000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<49.530000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.085000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.355000,0.000000,10.795000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<45.085000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.355000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.990000,0.000000,10.160000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<46.355000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.990000,0.000000,10.160000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.990000,0.000000,8.890000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<46.990000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.990000,0.000000,8.890000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.355000,0.000000,8.255000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<46.355000,0.000000,8.255000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.990000,0.000000,10.160000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.625000,0.000000,10.795000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<46.990000,0.000000,10.160000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.625000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.895000,0.000000,10.795000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<47.625000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.895000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.530000,0.000000,10.160000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<48.895000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.530000,0.000000,10.160000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.530000,0.000000,8.890000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<49.530000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.530000,0.000000,8.890000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.895000,0.000000,8.255000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<48.895000,0.000000,8.255000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.895000,0.000000,8.255000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.625000,0.000000,8.255000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<47.625000,0.000000,8.255000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.625000,0.000000,8.255000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.990000,0.000000,8.890000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<46.990000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.450000,0.000000,10.160000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.450000,0.000000,8.890000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<44.450000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.085000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.450000,0.000000,10.160000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<44.450000,0.000000,10.160000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.450000,0.000000,8.890000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.085000,0.000000,8.255000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<44.450000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.355000,0.000000,8.255000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.085000,0.000000,8.255000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<45.085000,0.000000,8.255000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.705000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.975000,0.000000,10.795000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<52.705000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.975000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.610000,0.000000,10.160000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<53.975000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.610000,0.000000,10.160000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.610000,0.000000,8.890000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<54.610000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.610000,0.000000,8.890000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.975000,0.000000,8.255000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<53.975000,0.000000,8.255000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.705000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.070000,0.000000,10.160000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<52.070000,0.000000,10.160000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.070000,0.000000,8.890000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.705000,0.000000,8.255000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<52.070000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.975000,0.000000,8.255000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.705000,0.000000,8.255000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<52.705000,0.000000,8.255000> }
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<50.800000,0.000000,9.525000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<48.260000,0.000000,9.525000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<45.720000,0.000000,9.525000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<53.340000,0.000000,9.525000>}
//JP3 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.510000,0.000000,10.160000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.145000,0.000000,10.795000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<16.510000,0.000000,10.160000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.145000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.415000,0.000000,10.795000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<17.145000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.415000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.050000,0.000000,10.160000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<18.415000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.050000,0.000000,10.160000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.050000,0.000000,8.890000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<19.050000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.050000,0.000000,8.890000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.415000,0.000000,8.255000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<18.415000,0.000000,8.255000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.415000,0.000000,8.255000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.145000,0.000000,8.255000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<17.145000,0.000000,8.255000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.145000,0.000000,8.255000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.510000,0.000000,8.890000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<16.510000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<12.065000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.335000,0.000000,10.795000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<12.065000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.335000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.970000,0.000000,10.160000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<13.335000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.970000,0.000000,10.160000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.970000,0.000000,8.890000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<13.970000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.970000,0.000000,8.890000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.335000,0.000000,8.255000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<13.335000,0.000000,8.255000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.970000,0.000000,10.160000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.605000,0.000000,10.795000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<13.970000,0.000000,10.160000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.605000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.875000,0.000000,10.795000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<14.605000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.875000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.510000,0.000000,10.160000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<15.875000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.510000,0.000000,10.160000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.510000,0.000000,8.890000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<16.510000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.510000,0.000000,8.890000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.875000,0.000000,8.255000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<15.875000,0.000000,8.255000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.875000,0.000000,8.255000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.605000,0.000000,8.255000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<14.605000,0.000000,8.255000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.605000,0.000000,8.255000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.970000,0.000000,8.890000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<13.970000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.430000,0.000000,10.160000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.430000,0.000000,8.890000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<11.430000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<12.065000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.430000,0.000000,10.160000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<11.430000,0.000000,10.160000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.430000,0.000000,8.890000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<12.065000,0.000000,8.255000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<11.430000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.335000,0.000000,8.255000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<12.065000,0.000000,8.255000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<12.065000,0.000000,8.255000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.685000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.955000,0.000000,10.795000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<19.685000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.955000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.590000,0.000000,10.160000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<20.955000,0.000000,10.795000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.590000,0.000000,10.160000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.590000,0.000000,8.890000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<21.590000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.590000,0.000000,8.890000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.955000,0.000000,8.255000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<20.955000,0.000000,8.255000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.685000,0.000000,10.795000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.050000,0.000000,10.160000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<19.050000,0.000000,10.160000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.050000,0.000000,8.890000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.685000,0.000000,8.255000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<19.050000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.955000,0.000000,8.255000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.685000,0.000000,8.255000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<19.685000,0.000000,8.255000> }
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<17.780000,0.000000,9.525000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<15.240000,0.000000,9.525000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<12.700000,0.000000,9.525000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<20.320000,0.000000,9.525000>}
//JP4 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.956000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.321000,0.000000,40.640000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<28.321000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.321000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.051000,0.000000,40.640000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<27.051000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.051000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.416000,0.000000,41.275000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<26.416000,0.000000,41.275000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.416000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.416000,0.000000,42.545000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<26.416000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.416000,0.000000,42.545000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.051000,0.000000,43.180000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<26.416000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.051000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.321000,0.000000,43.180000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<27.051000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.321000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.956000,0.000000,42.545000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<28.321000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.401000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.131000,0.000000,40.640000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<32.131000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.131000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.496000,0.000000,41.275000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<31.496000,0.000000,41.275000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.496000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.496000,0.000000,42.545000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<31.496000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.496000,0.000000,42.545000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.131000,0.000000,43.180000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<31.496000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.496000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.861000,0.000000,40.640000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<30.861000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.861000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.591000,0.000000,40.640000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<29.591000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.591000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.956000,0.000000,41.275000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<28.956000,0.000000,41.275000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.956000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.956000,0.000000,42.545000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<28.956000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.956000,0.000000,42.545000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.591000,0.000000,43.180000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<28.956000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.591000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.861000,0.000000,43.180000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<29.591000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.861000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.496000,0.000000,42.545000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<30.861000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.576000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.941000,0.000000,40.640000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<35.941000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.941000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.671000,0.000000,40.640000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.671000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.671000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.036000,0.000000,41.275000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<34.036000,0.000000,41.275000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.036000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.036000,0.000000,42.545000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<34.036000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.036000,0.000000,42.545000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.671000,0.000000,43.180000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<34.036000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.671000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.941000,0.000000,43.180000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.671000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.941000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.576000,0.000000,42.545000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<35.941000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.401000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.036000,0.000000,41.275000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<33.401000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.036000,0.000000,42.545000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.401000,0.000000,43.180000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<33.401000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.131000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.401000,0.000000,43.180000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<32.131000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.021000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.751000,0.000000,40.640000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<39.751000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.751000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.116000,0.000000,41.275000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<39.116000,0.000000,41.275000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.116000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.116000,0.000000,42.545000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<39.116000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.116000,0.000000,42.545000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.751000,0.000000,43.180000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<39.116000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.116000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.481000,0.000000,40.640000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<38.481000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.481000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.211000,0.000000,40.640000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<37.211000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.211000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.576000,0.000000,41.275000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<36.576000,0.000000,41.275000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.576000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.576000,0.000000,42.545000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<36.576000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.576000,0.000000,42.545000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.211000,0.000000,43.180000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<36.576000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.211000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.481000,0.000000,43.180000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<37.211000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.481000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.116000,0.000000,42.545000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<38.481000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.196000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.561000,0.000000,40.640000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<43.561000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.561000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.291000,0.000000,40.640000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<42.291000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.291000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.656000,0.000000,41.275000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<41.656000,0.000000,41.275000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.656000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.656000,0.000000,42.545000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.656000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.656000,0.000000,42.545000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.291000,0.000000,43.180000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<41.656000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.291000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.561000,0.000000,43.180000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<42.291000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.561000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.196000,0.000000,42.545000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<43.561000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.021000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.656000,0.000000,41.275000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<41.021000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.656000,0.000000,42.545000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.021000,0.000000,43.180000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<41.021000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.751000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.021000,0.000000,43.180000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<39.751000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.641000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.371000,0.000000,40.640000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<47.371000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.371000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.736000,0.000000,41.275000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<46.736000,0.000000,41.275000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.736000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.736000,0.000000,42.545000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<46.736000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.736000,0.000000,42.545000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.371000,0.000000,43.180000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<46.736000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.736000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.101000,0.000000,40.640000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<46.101000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.101000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.831000,0.000000,40.640000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<44.831000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.831000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.196000,0.000000,41.275000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<44.196000,0.000000,41.275000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.196000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.196000,0.000000,42.545000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<44.196000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.196000,0.000000,42.545000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.831000,0.000000,43.180000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<44.196000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.831000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.101000,0.000000,43.180000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<44.831000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.101000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.736000,0.000000,42.545000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<46.101000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.816000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.181000,0.000000,40.640000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<51.181000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.181000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.911000,0.000000,40.640000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<49.911000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.911000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.276000,0.000000,41.275000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<49.276000,0.000000,41.275000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.276000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.276000,0.000000,42.545000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<49.276000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.276000,0.000000,42.545000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.911000,0.000000,43.180000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<49.276000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.911000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.181000,0.000000,43.180000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<49.911000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.181000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.816000,0.000000,42.545000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<51.181000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.641000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.276000,0.000000,41.275000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<48.641000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.276000,0.000000,42.545000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.641000,0.000000,43.180000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<48.641000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.371000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.641000,0.000000,43.180000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<47.371000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.261000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.991000,0.000000,40.640000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<54.991000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.991000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.356000,0.000000,41.275000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<54.356000,0.000000,41.275000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.356000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.356000,0.000000,42.545000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<54.356000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.356000,0.000000,42.545000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.991000,0.000000,43.180000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<54.356000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.356000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.721000,0.000000,40.640000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<53.721000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.721000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.451000,0.000000,40.640000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<52.451000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.451000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.816000,0.000000,41.275000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<51.816000,0.000000,41.275000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.816000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.816000,0.000000,42.545000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<51.816000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.816000,0.000000,42.545000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.451000,0.000000,43.180000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<51.816000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.451000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.721000,0.000000,43.180000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<52.451000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.721000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.356000,0.000000,42.545000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<53.721000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.436000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.801000,0.000000,40.640000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<58.801000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.801000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.531000,0.000000,40.640000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.531000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.531000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.896000,0.000000,41.275000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<56.896000,0.000000,41.275000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.896000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.896000,0.000000,42.545000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<56.896000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.896000,0.000000,42.545000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.531000,0.000000,43.180000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<56.896000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.531000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.801000,0.000000,43.180000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.531000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.801000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.436000,0.000000,42.545000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<58.801000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.261000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.896000,0.000000,41.275000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<56.261000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.896000,0.000000,42.545000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.261000,0.000000,43.180000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<56.261000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.991000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.261000,0.000000,43.180000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<54.991000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<63.881000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.611000,0.000000,40.640000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<62.611000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.611000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.976000,0.000000,41.275000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<61.976000,0.000000,41.275000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.976000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.976000,0.000000,42.545000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<61.976000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.976000,0.000000,42.545000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.611000,0.000000,43.180000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<61.976000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.976000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.341000,0.000000,40.640000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<61.341000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.341000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.071000,0.000000,40.640000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<60.071000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.071000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.436000,0.000000,41.275000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<59.436000,0.000000,41.275000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.436000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.436000,0.000000,42.545000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<59.436000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.436000,0.000000,42.545000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.071000,0.000000,43.180000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<59.436000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.071000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.341000,0.000000,43.180000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<60.071000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.341000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.976000,0.000000,42.545000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<61.341000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.516000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.516000,0.000000,42.545000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<64.516000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<63.881000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.516000,0.000000,41.275000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<63.881000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.516000,0.000000,42.545000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<63.881000,0.000000,43.180000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<63.881000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.611000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<63.881000,0.000000,43.180000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<62.611000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.416000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<25.781000,0.000000,40.640000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<25.781000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<25.781000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.511000,0.000000,40.640000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<24.511000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.511000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.876000,0.000000,41.275000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<23.876000,0.000000,41.275000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.876000,0.000000,41.275000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.876000,0.000000,42.545000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<23.876000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.876000,0.000000,42.545000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.511000,0.000000,43.180000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<23.876000,0.000000,42.545000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.511000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<25.781000,0.000000,43.180000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<24.511000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<25.781000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.416000,0.000000,42.545000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<25.781000,0.000000,43.180000> }
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<27.686000,0.000000,41.910000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<30.226000,0.000000,41.910000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<32.766000,0.000000,41.910000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<35.306000,0.000000,41.910000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<37.846000,0.000000,41.910000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<40.386000,0.000000,41.910000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<42.926000,0.000000,41.910000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<45.466000,0.000000,41.910000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<48.006000,0.000000,41.910000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<50.546000,0.000000,41.910000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<53.086000,0.000000,41.910000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<55.626000,0.000000,41.910000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<58.166000,0.000000,41.910000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<60.706000,0.000000,41.910000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<63.246000,0.000000,41.910000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<25.146000,0.000000,41.910000>}
//R1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<53.721000,0.000000,26.035000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<53.721000,0.000000,25.654000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,-90.000000,0> translate<53.721000,0.000000,25.654000> }
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<54.610000,0.000000,25.146000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<52.832000,0.000000,25.146000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<52.832000,0.000000,19.304000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<54.610000,0.000000,19.304000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.832000,0.000000,25.400000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.610000,0.000000,25.400000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<52.832000,0.000000,25.400000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.864000,0.000000,25.146000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.864000,0.000000,24.765000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<54.864000,0.000000,24.765000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.737000,0.000000,24.638000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.864000,0.000000,24.765000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<54.737000,0.000000,24.638000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.578000,0.000000,25.146000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.578000,0.000000,24.765000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<52.578000,0.000000,24.765000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.705000,0.000000,24.638000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.578000,0.000000,24.765000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<52.578000,0.000000,24.765000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.737000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.864000,0.000000,19.685000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<54.737000,0.000000,19.812000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.737000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.737000,0.000000,24.638000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,90.000000,0> translate<54.737000,0.000000,24.638000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.705000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.578000,0.000000,19.685000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<52.578000,0.000000,19.685000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.705000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.705000,0.000000,24.638000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,90.000000,0> translate<52.705000,0.000000,24.638000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.864000,0.000000,19.304000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.864000,0.000000,19.685000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<54.864000,0.000000,19.685000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.578000,0.000000,19.304000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.578000,0.000000,19.685000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<52.578000,0.000000,19.685000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.832000,0.000000,19.050000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.610000,0.000000,19.050000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<52.832000,0.000000,19.050000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<53.721000,0.000000,18.796000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<53.721000,0.000000,18.415000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,-90.000000,0> translate<53.721000,0.000000,18.415000> }
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-270.000000,0> translate<53.721000,0.000000,25.527000>}
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-270.000000,0> translate<53.721000,0.000000,18.923000>}
//R2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.560000,0.000000,29.591000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.910000,0.000000,29.591000>}
box{<0,0,-0.076200><6.350000,0.036000,0.076200> rotate<0,0.000000,0> translate<35.560000,0.000000,29.591000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.910000,0.000000,36.449000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,36.449000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.275000,0.000000,36.449000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.560000,0.000000,29.591000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.306000,0.000000,29.845000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<35.306000,0.000000,29.845000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.560000,0.000000,36.449000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.306000,0.000000,36.195000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<35.306000,0.000000,36.195000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.306000,0.000000,36.195000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.306000,0.000000,34.544000>}
box{<0,0,-0.076200><1.651000,0.036000,0.076200> rotate<0,-90.000000,0> translate<35.306000,0.000000,34.544000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.306000,0.000000,34.544000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.306000,0.000000,33.274000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<35.306000,0.000000,33.274000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.306000,0.000000,33.274000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.306000,0.000000,29.845000>}
box{<0,0,-0.076200><3.429000,0.036000,0.076200> rotate<0,-90.000000,0> translate<35.306000,0.000000,29.845000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.910000,0.000000,36.449000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.164000,0.000000,36.195000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<41.910000,0.000000,36.449000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.910000,0.000000,29.591000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.164000,0.000000,29.845000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<41.910000,0.000000,29.591000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.164000,0.000000,29.845000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.164000,0.000000,33.274000>}
box{<0,0,-0.076200><3.429000,0.036000,0.076200> rotate<0,90.000000,0> translate<42.164000,0.000000,33.274000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.164000,0.000000,33.274000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.164000,0.000000,34.544000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<42.164000,0.000000,34.544000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.164000,0.000000,34.544000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.164000,0.000000,36.195000>}
box{<0,0,-0.076200><1.651000,0.036000,0.076200> rotate<0,90.000000,0> translate<42.164000,0.000000,36.195000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.973000,0.000000,33.020000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.211000,0.000000,33.020000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<37.211000,0.000000,33.020000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.211000,0.000000,33.020000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.211000,0.000000,32.258000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<37.211000,0.000000,32.258000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.211000,0.000000,32.258000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.973000,0.000000,32.258000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<37.211000,0.000000,32.258000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.973000,0.000000,32.258000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.354000,0.000000,31.877000>}
box{<0,0,-0.076200><0.538815,0.036000,0.076200> rotate<0,44.997030,0> translate<37.973000,0.000000,32.258000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.354000,0.000000,31.877000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.354000,0.000000,31.496000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<38.354000,0.000000,31.496000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.354000,0.000000,30.734000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.116000,0.000000,30.734000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<38.354000,0.000000,30.734000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.116000,0.000000,30.734000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.116000,0.000000,31.496000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,90.000000,0> translate<39.116000,0.000000,31.496000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.116000,0.000000,31.877000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.497000,0.000000,32.258000>}
box{<0,0,-0.076200><0.538815,0.036000,0.076200> rotate<0,-44.997030,0> translate<39.116000,0.000000,31.877000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.497000,0.000000,32.258000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.259000,0.000000,32.258000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<39.497000,0.000000,32.258000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.259000,0.000000,32.258000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.259000,0.000000,33.020000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,90.000000,0> translate<40.259000,0.000000,33.020000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.259000,0.000000,33.020000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.497000,0.000000,33.020000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<39.497000,0.000000,33.020000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.116000,0.000000,33.401000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.497000,0.000000,33.020000>}
box{<0,0,-0.076200><0.538815,0.036000,0.076200> rotate<0,44.997030,0> translate<39.116000,0.000000,33.401000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.116000,0.000000,33.401000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.116000,0.000000,33.782000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<39.116000,0.000000,33.782000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.116000,0.000000,34.544000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.354000,0.000000,34.544000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<38.354000,0.000000,34.544000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.354000,0.000000,34.544000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.354000,0.000000,33.782000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<38.354000,0.000000,33.782000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.354000,0.000000,33.401000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.973000,0.000000,33.020000>}
box{<0,0,-0.076200><0.538815,0.036000,0.076200> rotate<0,-44.997030,0> translate<37.973000,0.000000,33.020000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<40.513000,0.000000,34.417000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<40.767000,0.000000,34.671000>}
box{<0,0,-0.152400><0.359210,0.036000,0.152400> rotate<0,-44.997030,0> translate<40.513000,0.000000,34.417000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<36.957000,0.000000,34.417000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<36.703000,0.000000,34.671000>}
box{<0,0,-0.152400><0.359210,0.036000,0.152400> rotate<0,44.997030,0> translate<36.703000,0.000000,34.671000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<36.347400,0.000000,32.639000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<35.966400,0.000000,32.639000>}
box{<0,0,-0.152400><0.381000,0.036000,0.152400> rotate<0,0.000000,0> translate<35.966400,0.000000,32.639000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<36.957000,0.000000,30.988000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<36.703000,0.000000,30.734000>}
box{<0,0,-0.152400><0.359210,0.036000,0.152400> rotate<0,-44.997030,0> translate<36.703000,0.000000,30.734000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<38.735000,0.000000,30.302200>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<38.735000,0.000000,29.921200>}
box{<0,0,-0.152400><0.381000,0.036000,0.152400> rotate<0,-90.000000,0> translate<38.735000,0.000000,29.921200> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<40.640000,0.000000,30.988000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<40.894000,0.000000,30.734000>}
box{<0,0,-0.152400><0.359210,0.036000,0.152400> rotate<0,44.997030,0> translate<40.640000,0.000000,30.988000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<41.122600,0.000000,32.639000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<41.503600,0.000000,32.639000>}
box{<0,0,-0.152400><0.381000,0.036000,0.152400> rotate<0,0.000000,0> translate<41.122600,0.000000,32.639000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.354000,0.000000,31.496000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.116000,0.000000,31.496000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<38.354000,0.000000,31.496000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.354000,0.000000,31.496000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.354000,0.000000,30.734000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<38.354000,0.000000,30.734000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.116000,0.000000,31.496000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.116000,0.000000,31.877000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<39.116000,0.000000,31.877000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.354000,0.000000,33.782000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.116000,0.000000,33.782000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<38.354000,0.000000,33.782000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.354000,0.000000,33.782000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.354000,0.000000,33.401000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<38.354000,0.000000,33.401000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.116000,0.000000,33.782000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.116000,0.000000,34.544000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,90.000000,0> translate<39.116000,0.000000,34.544000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,36.068000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,36.449000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.275000,0.000000,36.449000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.751000,0.000000,36.068000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.719000,0.000000,36.068000>}
box{<0,0,-0.076200><2.032000,0.036000,0.076200> rotate<0,0.000000,0> translate<37.719000,0.000000,36.068000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.195000,0.000000,36.449000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.195000,0.000000,36.068000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<36.195000,0.000000,36.068000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,36.449000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.370000,0.000000,36.449000>}
box{<0,0,-0.076200><1.905000,0.036000,0.076200> rotate<0,0.000000,0> translate<39.370000,0.000000,36.449000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.370000,0.000000,36.449000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.100000,0.000000,36.449000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<38.100000,0.000000,36.449000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.100000,0.000000,36.449000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.195000,0.000000,36.449000>}
box{<0,0,-0.076200><1.905000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.195000,0.000000,36.449000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.195000,0.000000,36.449000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.560000,0.000000,36.449000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,0.000000,0> translate<35.560000,0.000000,36.449000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,36.068000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.751000,0.000000,36.068000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<39.751000,0.000000,36.068000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.719000,0.000000,36.068000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.195000,0.000000,36.068000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.195000,0.000000,36.068000> }
difference{
cylinder{<38.735000,0,32.639000><38.735000,0.036000,32.639000>2.108200 translate<0,0.000000,0>}
cylinder{<38.735000,-0.1,32.639000><38.735000,0.135000,32.639000>1.955800 translate<0,0.000000,0>}}
//R5 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<48.260000,0.000000,12.700000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<48.641000,0.000000,12.700000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,0.000000,0> translate<48.260000,0.000000,12.700000> }
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<49.149000,0.000000,13.589000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<49.149000,0.000000,11.811000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<54.991000,0.000000,11.811000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<54.991000,0.000000,13.589000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.895000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.895000,0.000000,13.589000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<48.895000,0.000000,13.589000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.149000,0.000000,13.843000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.530000,0.000000,13.843000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<49.149000,0.000000,13.843000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.657000,0.000000,13.716000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.530000,0.000000,13.843000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<49.530000,0.000000,13.843000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.149000,0.000000,11.557000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.530000,0.000000,11.557000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<49.149000,0.000000,11.557000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.657000,0.000000,11.684000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.530000,0.000000,11.557000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<49.530000,0.000000,11.557000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.483000,0.000000,13.716000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.610000,0.000000,13.843000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<54.483000,0.000000,13.716000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.483000,0.000000,13.716000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.657000,0.000000,13.716000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<49.657000,0.000000,13.716000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.483000,0.000000,11.684000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.610000,0.000000,11.557000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<54.483000,0.000000,11.684000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.483000,0.000000,11.684000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.657000,0.000000,11.684000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<49.657000,0.000000,11.684000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.991000,0.000000,13.843000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.610000,0.000000,13.843000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<54.610000,0.000000,13.843000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.991000,0.000000,11.557000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.610000,0.000000,11.557000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<54.610000,0.000000,11.557000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.245000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.245000,0.000000,13.589000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<55.245000,0.000000,13.589000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<55.499000,0.000000,12.700000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<55.880000,0.000000,12.700000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,0.000000,0> translate<55.499000,0.000000,12.700000> }
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-0.000000,0> translate<48.768000,0.000000,12.700000>}
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-0.000000,0> translate<55.372000,0.000000,12.700000>}
//R6 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<45.720000,0.000000,15.240000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<46.101000,0.000000,15.240000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,0.000000,0> translate<45.720000,0.000000,15.240000> }
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<46.609000,0.000000,16.129000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<46.609000,0.000000,14.351000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<52.451000,0.000000,14.351000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<52.451000,0.000000,16.129000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.355000,0.000000,14.351000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.355000,0.000000,16.129000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<46.355000,0.000000,16.129000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.609000,0.000000,16.383000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.990000,0.000000,16.383000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.609000,0.000000,16.383000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.117000,0.000000,16.256000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.990000,0.000000,16.383000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<46.990000,0.000000,16.383000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.609000,0.000000,14.097000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.990000,0.000000,14.097000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.609000,0.000000,14.097000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.117000,0.000000,14.224000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.990000,0.000000,14.097000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<46.990000,0.000000,14.097000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.943000,0.000000,16.256000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.070000,0.000000,16.383000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<51.943000,0.000000,16.256000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.943000,0.000000,16.256000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.117000,0.000000,16.256000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<47.117000,0.000000,16.256000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.943000,0.000000,14.224000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.070000,0.000000,14.097000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<51.943000,0.000000,14.224000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.943000,0.000000,14.224000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.117000,0.000000,14.224000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<47.117000,0.000000,14.224000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.451000,0.000000,16.383000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.070000,0.000000,16.383000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<52.070000,0.000000,16.383000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.451000,0.000000,14.097000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.070000,0.000000,14.097000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<52.070000,0.000000,14.097000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.705000,0.000000,14.351000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.705000,0.000000,16.129000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<52.705000,0.000000,16.129000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<52.959000,0.000000,15.240000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<53.340000,0.000000,15.240000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,0.000000,0> translate<52.959000,0.000000,15.240000> }
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-0.000000,0> translate<46.228000,0.000000,15.240000>}
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-0.000000,0> translate<52.832000,0.000000,15.240000>}
//SJ1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.419000,0.000000,29.591000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.419000,0.000000,33.909000>}
box{<0,0,-0.076200><4.318000,0.036000,0.076200> rotate<0,90.000000,0> translate<50.419000,0.000000,33.909000> }
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<52.197000,0.000000,29.591000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<52.197000,0.000000,33.909000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<50.673000,0.000000,33.909000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<50.673000,0.000000,29.591000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.673000,0.000000,29.337000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.197000,0.000000,29.337000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<50.673000,0.000000,29.337000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.673000,0.000000,34.163000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.197000,0.000000,34.163000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<50.673000,0.000000,34.163000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.451000,0.000000,33.909000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.451000,0.000000,29.591000>}
box{<0,0,-0.076200><4.318000,0.036000,0.076200> rotate<0,-90.000000,0> translate<52.451000,0.000000,29.591000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.435000,0.000000,29.972000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.435000,0.000000,29.464000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,-90.000000,0> translate<51.435000,0.000000,29.464000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.435000,0.000000,33.528000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.435000,0.000000,34.036000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,90.000000,0> translate<51.435000,0.000000,34.036000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.197000,0.000000,31.750000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.451000,0.000000,31.750000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<52.197000,0.000000,31.750000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.419000,0.000000,31.750000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.673000,0.000000,31.750000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<50.419000,0.000000,31.750000> }
object{ARC(0.127000,1.270000,180.000000,360.000000,0.036000) translate<51.435000,0.000000,30.734000>}
object{ARC(0.127000,1.270000,0.000000,180.000000,0.036000) translate<51.435000,0.000000,32.766000>}
box{<-0.508000,0,-0.762000><0.508000,0.036000,0.762000> rotate<0,-270.000000,0> translate<51.435000,0.000000,31.750000>}
//SJ2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.244000,0.000000,29.591000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.244000,0.000000,33.909000>}
box{<0,0,-0.076200><4.318000,0.036000,0.076200> rotate<0,90.000000,0> translate<47.244000,0.000000,33.909000> }
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<49.022000,0.000000,29.591000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<49.022000,0.000000,33.909000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<47.498000,0.000000,33.909000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<47.498000,0.000000,29.591000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.498000,0.000000,29.337000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.022000,0.000000,29.337000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<47.498000,0.000000,29.337000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.498000,0.000000,34.163000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.022000,0.000000,34.163000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<47.498000,0.000000,34.163000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.276000,0.000000,33.909000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.276000,0.000000,29.591000>}
box{<0,0,-0.076200><4.318000,0.036000,0.076200> rotate<0,-90.000000,0> translate<49.276000,0.000000,29.591000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.260000,0.000000,29.972000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.260000,0.000000,29.464000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,-90.000000,0> translate<48.260000,0.000000,29.464000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.260000,0.000000,33.528000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.260000,0.000000,34.036000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,90.000000,0> translate<48.260000,0.000000,34.036000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.022000,0.000000,31.750000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.276000,0.000000,31.750000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<49.022000,0.000000,31.750000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.244000,0.000000,31.750000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.498000,0.000000,31.750000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<47.244000,0.000000,31.750000> }
object{ARC(0.127000,1.270000,180.000000,360.000000,0.036000) translate<48.260000,0.000000,30.734000>}
object{ARC(0.127000,1.270000,0.000000,180.000000,0.036000) translate<48.260000,0.000000,32.766000>}
box{<-0.508000,0,-0.762000><0.508000,0.036000,0.762000> rotate<0,-270.000000,0> translate<48.260000,0.000000,31.750000>}
//SJ3 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.069000,0.000000,29.591000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.069000,0.000000,33.909000>}
box{<0,0,-0.076200><4.318000,0.036000,0.076200> rotate<0,90.000000,0> translate<44.069000,0.000000,33.909000> }
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<45.847000,0.000000,29.591000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<45.847000,0.000000,33.909000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<44.323000,0.000000,33.909000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<44.323000,0.000000,29.591000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.323000,0.000000,29.337000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.847000,0.000000,29.337000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<44.323000,0.000000,29.337000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.323000,0.000000,34.163000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.847000,0.000000,34.163000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<44.323000,0.000000,34.163000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.101000,0.000000,33.909000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.101000,0.000000,29.591000>}
box{<0,0,-0.076200><4.318000,0.036000,0.076200> rotate<0,-90.000000,0> translate<46.101000,0.000000,29.591000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.085000,0.000000,29.972000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.085000,0.000000,29.464000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,-90.000000,0> translate<45.085000,0.000000,29.464000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.085000,0.000000,33.528000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.085000,0.000000,34.036000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,90.000000,0> translate<45.085000,0.000000,34.036000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.847000,0.000000,31.750000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.101000,0.000000,31.750000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<45.847000,0.000000,31.750000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.069000,0.000000,31.750000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.323000,0.000000,31.750000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<44.069000,0.000000,31.750000> }
object{ARC(0.127000,1.270000,180.000000,360.000000,0.036000) translate<45.085000,0.000000,30.734000>}
object{ARC(0.127000,1.270000,0.000000,180.000000,0.036000) translate<45.085000,0.000000,32.766000>}
box{<-0.508000,0,-0.762000><0.508000,0.036000,0.762000> rotate<0,-270.000000,0> translate<45.085000,0.000000,31.750000>}
//SV1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.547000,0.000000,15.494000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.547000,0.000000,28.194000>}
box{<0,0,-0.076200><12.700000,0.036000,0.076200> rotate<0,90.000000,0> translate<58.547000,0.000000,28.194000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.897000,0.000000,28.194000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.547000,0.000000,28.194000>}
box{<0,0,-0.076200><6.350000,0.036000,0.076200> rotate<0,0.000000,0> translate<58.547000,0.000000,28.194000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.547000,0.000000,15.494000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.897000,0.000000,15.494000>}
box{<0,0,-0.076200><6.350000,0.036000,0.076200> rotate<0,0.000000,0> translate<58.547000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,14.224000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,15.494000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<57.277000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.167000,0.000000,29.464000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,29.464000>}
box{<0,0,-0.076200><8.890000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.277000,0.000000,29.464000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,14.224000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.167000,0.000000,14.224000>}
box{<0,0,-0.076200><8.890000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.277000,0.000000,14.224000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.135000,0.000000,23.876000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.897000,0.000000,23.876000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<64.135000,0.000000,23.876000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.135000,0.000000,23.876000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.135000,0.000000,19.812000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,-90.000000,0> translate<64.135000,0.000000,19.812000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.897000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.135000,0.000000,19.812000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<64.135000,0.000000,19.812000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.897000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.897000,0.000000,15.494000>}
box{<0,0,-0.076200><4.318000,0.036000,0.076200> rotate<0,-90.000000,0> translate<64.897000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.897000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.151000,0.000000,19.812000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<64.897000,0.000000,19.812000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,28.194000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.023000,0.000000,28.194000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.023000,0.000000,28.194000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.023000,0.000000,28.194000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.023000,0.000000,26.924000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<57.023000,0.000000,26.924000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,26.924000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.023000,0.000000,26.924000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.023000,0.000000,26.924000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,28.194000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,29.464000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<57.277000,0.000000,29.464000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.023000,0.000000,22.479000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.023000,0.000000,21.209000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<57.023000,0.000000,21.209000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.023000,0.000000,22.479000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,22.479000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.023000,0.000000,22.479000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,22.479000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,26.924000>}
box{<0,0,-0.076200><4.445000,0.036000,0.076200> rotate<0,90.000000,0> translate<57.277000,0.000000,26.924000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.023000,0.000000,21.209000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,21.209000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.023000,0.000000,21.209000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.023000,0.000000,16.764000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.023000,0.000000,15.494000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<57.023000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.023000,0.000000,15.494000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,15.494000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.023000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.023000,0.000000,16.764000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,16.764000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.023000,0.000000,16.764000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,16.764000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.277000,0.000000,21.209000>}
box{<0,0,-0.076200><4.445000,0.036000,0.076200> rotate<0,90.000000,0> translate<57.277000,0.000000,21.209000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.167000,0.000000,29.464000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.167000,0.000000,23.876000>}
box{<0,0,-0.076200><5.588000,0.036000,0.076200> rotate<0,-90.000000,0> translate<66.167000,0.000000,23.876000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.167000,0.000000,23.876000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.167000,0.000000,19.812000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,-90.000000,0> translate<66.167000,0.000000,19.812000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.897000,0.000000,28.194000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.897000,0.000000,23.876000>}
box{<0,0,-0.076200><4.318000,0.036000,0.076200> rotate<0,-90.000000,0> translate<64.897000,0.000000,23.876000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.897000,0.000000,23.876000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.151000,0.000000,23.876000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<64.897000,0.000000,23.876000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.151000,0.000000,23.876000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.167000,0.000000,23.876000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<65.151000,0.000000,23.876000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<65.151000,0.000000,23.876000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<65.151000,0.000000,28.448000>}
box{<0,0,-0.025400><4.572000,0.036000,0.025400> rotate<0,90.000000,0> translate<65.151000,0.000000,28.448000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<65.151000,0.000000,28.448000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<58.293000,0.000000,28.448000>}
box{<0,0,-0.025400><6.858000,0.036000,0.025400> rotate<0,0.000000,0> translate<58.293000,0.000000,28.448000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<58.293000,0.000000,28.448000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<58.293000,0.000000,15.240000>}
box{<0,0,-0.025400><13.208000,0.036000,0.025400> rotate<0,-90.000000,0> translate<58.293000,0.000000,15.240000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<58.293000,0.000000,15.240000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<65.151000,0.000000,15.240000>}
box{<0,0,-0.025400><6.858000,0.036000,0.025400> rotate<0,0.000000,0> translate<58.293000,0.000000,15.240000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<65.151000,0.000000,15.240000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<65.151000,0.000000,19.812000>}
box{<0,0,-0.025400><4.572000,0.036000,0.025400> rotate<0,90.000000,0> translate<65.151000,0.000000,19.812000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.151000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.167000,0.000000,19.812000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<65.151000,0.000000,19.812000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.167000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.167000,0.000000,19.304000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,-90.000000,0> translate<66.167000,0.000000,19.304000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.040000,0.000000,19.304000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.167000,0.000000,19.304000>}
box{<0,0,-0.076200><0.127000,0.036000,0.076200> rotate<0,0.000000,0> translate<66.040000,0.000000,19.304000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.040000,0.000000,19.304000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.040000,0.000000,18.034000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<66.040000,0.000000,18.034000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.167000,0.000000,18.034000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.040000,0.000000,18.034000>}
box{<0,0,-0.076200><0.127000,0.036000,0.076200> rotate<0,0.000000,0> translate<66.040000,0.000000,18.034000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.167000,0.000000,18.034000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.167000,0.000000,14.224000>}
box{<0,0,-0.076200><3.810000,0.036000,0.076200> rotate<0,-90.000000,0> translate<66.167000,0.000000,14.224000> }
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-90.000000,0> translate<60.452000,0.000000,21.844000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-90.000000,0> translate<60.452000,0.000000,19.304000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-90.000000,0> translate<60.452000,0.000000,24.384000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-90.000000,0> translate<62.992000,0.000000,21.844000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-90.000000,0> translate<62.992000,0.000000,19.304000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-90.000000,0> translate<62.992000,0.000000,24.384000>}
texture{col_slk}
}
#end
translate<mac_x_ver,mac_y_ver,mac_z_ver>
rotate<mac_x_rot,mac_y_rot,mac_z_rot>
}//End union
#end

#if(use_file_as_inc=off)
object{  LCD_INTERFACE(-34.163000,0,-24.955500,pcb_rotate_x,pcb_rotate_y,pcb_rotate_z)
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
//R2	10K	B25P
