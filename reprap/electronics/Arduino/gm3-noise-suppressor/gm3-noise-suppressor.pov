//POVRay-File created by 3d41.ulp v1.05
///home/hoeken/Desktop/reprap/trunk/reprap/electronics/Arduino/gm3-noise-suppressor/gm3-noise-suppressor.brd
//9/26/08 10:52 AM

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
#local cam_y = 136;
#local cam_z = -73;
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

#local lgt1_pos_x = 8;
#local lgt1_pos_y = 18;
#local lgt1_pos_z = 16;
#local lgt1_intense = 0.710331;
#local lgt2_pos_x = -8;
#local lgt2_pos_y = 18;
#local lgt2_pos_z = 16;
#local lgt2_intense = 0.710331;
#local lgt3_pos_x = 8;
#local lgt3_pos_y = 18;
#local lgt3_pos_z = -11;
#local lgt3_intense = 0.710331;
#local lgt4_pos_x = -8;
#local lgt4_pos_y = 18;
#local lgt4_pos_z = -11;
#local lgt4_intense = 0.710331;

//Do not change these values
#declare pcb_height = 1.500000;
#declare pcb_cuheight = 0.035000;
#declare pcb_x_size = 22.784000;
#declare pcb_y_size = 31.740000;
#declare pcb_layer1_used = 0;
#declare pcb_layer16_used = 1;
#declare inc_testmode = off;
#declare global_seed=seed(805);
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
	//translate<-11.392000,0,-15.870000>
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


#macro GM3_NOISE_SUPPRESSOR(mac_x_ver,mac_y_ver,mac_z_ver,mac_x_rot,mac_y_rot,mac_z_rot)
union{
#if(pcb_board = on)
difference{
union{
//Board
prism{-1.500000,0.000000,8
<26.708000,8.768000><49.492000,8.768000>
<49.492000,8.768000><49.492000,40.508000>
<49.492000,40.508000><26.708000,40.508000>
<26.708000,40.508000><26.708000,8.768000>
texture{col_brd}}
}//End union(Platine)
//Holes(real)/Parts
cylinder{<31.242000,1,35.814000><31.242000,-5,35.814000>2.050000 texture{col_hls}}
cylinder{<44.958000,1,35.814000><44.958000,-5,35.814000>2.050000 texture{col_hls}}
//Holes(real)/Board
//Holes(real)/Vias
cylinder{<33.020000,0.095000,24.130000><33.020000,-1.595000,24.130000>1.400000 texture{col_hls}}
cylinder{<43.180000,0.095000,24.130000><43.180000,-1.595000,24.130000>1.400000 texture{col_hls}}
}//End difference(reale Bohrungen/Durchbrüche)
#end
#if(pcb_parts=on)//Parts
union{
#ifndef(pack_C1) #declare global_pack_C1=yes; object {CAP_DIS_CERAMIC_50MM_76MM("10nF",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<38.100000,0.000000,20.066000>}#end		//ceramic disc capacitator C1 10nF C050-030X075
#ifndef(pack_C2) #declare global_pack_C2=yes; object {CAP_DIS_CERAMIC_50MM_76MM("1nF",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<38.100000,0.000000,27.940000>}#end		//ceramic disc capacitator C2 1nF C050-030X075
#ifndef(pack_C3) #declare global_pack_C3=yes; object {CAP_DIS_CERAMIC_50MM_76MM("1nF",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<30.480000,0.000000,29.210000>}#end		//ceramic disc capacitator C3 1nF C050-030X075
#ifndef(pack_C4) #declare global_pack_C4=yes; object {CAP_DIS_CERAMIC_50MM_76MM("1nF",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<45.720000,0.000000,29.210000>}#end		//ceramic disc capacitator C4 1nF C050-030X075
#ifndef(pack_JP1) #declare global_pack_JP1=yes; object {PH_1X2()translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<38.100000,0.000000,16.764000>}#end		//Header 2,54mm Grid 2Pin 1Row (jumper.lib) JP1  1X02
#ifndef(pack_JP2) #declare global_pack_JP2=yes; object {PH_1X2()translate<0,0,0> rotate<0,0.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<29.464000,0.000000,16.256000>}#end		//Header 2,54mm Grid 2Pin 1Row (jumper.lib) JP2  1X02
#ifndef(pack_JP3) #declare global_pack_JP3=yes; object {PH_1X2()translate<0,0,0> rotate<0,0.000000,0>rotate<0,-270.000000,0> rotate<0,0,0> translate<46.482000,0.000000,16.002000>}#end		//Header 2,54mm Grid 2Pin 1Row (jumper.lib) JP3  1X02
#ifndef(pack_X1) #declare global_pack_X1=yes; object {CON_PHOENIX_508_MSTBV_2()translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<38.100000,0.000000,12.446000>}#end		//Connector PHOENIX type MSTBV vertical 2 pins X1 MSTBV2 MSTBV2
}//End union
#end
#if(pcb_pads_smds=on)
//Pads&SMD/Parts
#ifndef(global_pack_C1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<40.640000,0,20.066000> texture{col_thl}}
#ifndef(global_pack_C1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<35.560000,0,20.066000> texture{col_thl}}
#ifndef(global_pack_C2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<40.640000,0,27.940000> texture{col_thl}}
#ifndef(global_pack_C2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<35.560000,0,27.940000> texture{col_thl}}
#ifndef(global_pack_C3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<27.940000,0,29.210000> texture{col_thl}}
#ifndef(global_pack_C3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<33.020000,0,29.210000> texture{col_thl}}
#ifndef(global_pack_C4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<43.180000,0,29.210000> texture{col_thl}}
#ifndef(global_pack_C4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<48.260000,0,29.210000> texture{col_thl}}
#ifndef(global_pack_H1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(5.334000,2.800000,1,16,1+global_tmp,0) rotate<0,-0.000000,0>translate<33.020000,0,24.130000> texture{col_thl}}
#ifndef(global_pack_H2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(5.334000,2.800000,1,16,1+global_tmp,0) rotate<0,-0.000000,0>translate<43.180000,0,24.130000> texture{col_thl}}
#ifndef(global_pack_JP1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<36.830000,0,16.764000> texture{col_thl}}
#ifndef(global_pack_JP1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<39.370000,0,16.764000> texture{col_thl}}
#ifndef(global_pack_JP2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<29.464000,0,14.986000> texture{col_thl}}
#ifndef(global_pack_JP2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<29.464000,0,17.526000> texture{col_thl}}
#ifndef(global_pack_JP3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<46.482000,0,17.272000> texture{col_thl}}
#ifndef(global_pack_JP3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.524000,1.016000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<46.482000,0,14.732000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<35.560000,0,12.446000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.095600,1.397000,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<40.640000,0,12.446000> texture{col_thl}}
//Pads/Vias
#end
#if(pcb_wires=on)
union{
//Signals
difference{union{
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<33.020000,-1.535000,24.130000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<33.020000,-1.535000,25.400000>}
box{<0,0,-0.838200><1.270000,0.035000,0.838200> rotate<0,90.000000,0> translate<33.020000,-1.535000,25.400000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<33.020000,-1.535000,25.400000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<35.560000,-1.535000,27.940000>}
box{<0,0,-0.838200><3.592102,0.035000,0.838200> rotate<0,-44.997030,0> translate<33.020000,-1.535000,25.400000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<29.464000,-1.535000,20.574000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<33.020000,-1.535000,24.130000>}
box{<0,0,-0.838200><5.028943,0.035000,0.838200> rotate<0,-44.997030,0> translate<29.464000,-1.535000,20.574000> }
}cylinder{<33.020000,1,24.130000><33.020000,-2.500000,24.130000>1.400000 texture{col_thl}}}
difference{union{
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<43.180000,-1.535000,24.130000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<43.180000,-1.535000,25.400000>}
box{<0,0,-0.838200><1.270000,0.035000,0.838200> rotate<0,90.000000,0> translate<43.180000,-1.535000,25.400000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<43.180000,-1.535000,24.130000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<46.482000,-1.535000,20.828000>}
box{<0,0,-0.838200><4.669733,0.035000,0.838200> rotate<0,44.997030,0> translate<43.180000,-1.535000,24.130000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<40.640000,-1.535000,27.940000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<43.180000,-1.535000,25.400000>}
box{<0,0,-0.838200><3.592102,0.035000,0.838200> rotate<0,44.997030,0> translate<40.640000,-1.535000,27.940000> }
}cylinder{<43.180000,1,24.130000><43.180000,-2.500000,24.130000>1.400000 texture{col_thl}}}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<29.464000,-1.535000,17.526000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<29.464000,-1.535000,20.574000>}
box{<0,0,-0.838200><3.048000,0.035000,0.838200> rotate<0,90.000000,0> translate<29.464000,-1.535000,20.574000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<29.464000,-1.535000,14.986000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<31.242000,-1.535000,14.986000>}
box{<0,0,-0.838200><1.778000,0.035000,0.838200> rotate<0,0.000000,0> translate<29.464000,-1.535000,14.986000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<31.242000,-1.535000,14.986000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<33.528000,-1.535000,17.272000>}
box{<0,0,-0.838200><3.232892,0.035000,0.838200> rotate<0,-44.997030,0> translate<31.242000,-1.535000,14.986000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<33.528000,-1.535000,17.272000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<33.528000,-1.535000,18.034000>}
box{<0,0,-0.838200><0.762000,0.035000,0.838200> rotate<0,90.000000,0> translate<33.528000,-1.535000,18.034000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<33.020000,-1.535000,29.210000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<34.290000,-1.535000,27.940000>}
box{<0,0,-0.838200><1.796051,0.035000,0.838200> rotate<0,44.997030,0> translate<33.020000,-1.535000,29.210000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<35.560000,-1.535000,15.494000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<35.560000,-1.535000,12.446000>}
box{<0,0,-0.838200><3.048000,0.035000,0.838200> rotate<0,-90.000000,0> translate<35.560000,-1.535000,12.446000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<33.528000,-1.535000,18.034000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<35.560000,-1.535000,20.066000>}
box{<0,0,-0.838200><2.873682,0.035000,0.838200> rotate<0,-44.997030,0> translate<33.528000,-1.535000,18.034000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<34.290000,-1.535000,27.940000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<35.560000,-1.535000,27.940000>}
box{<0,0,-0.838200><1.270000,0.035000,0.838200> rotate<0,0.000000,0> translate<34.290000,-1.535000,27.940000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<35.560000,-1.535000,15.494000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<36.830000,-1.535000,16.764000>}
box{<0,0,-0.838200><1.796051,0.035000,0.838200> rotate<0,-44.997030,0> translate<35.560000,-1.535000,15.494000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<36.830000,-1.535000,18.796000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<36.830000,-1.535000,16.764000>}
box{<0,0,-0.838200><2.032000,0.035000,0.838200> rotate<0,-90.000000,0> translate<36.830000,-1.535000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<35.560000,-1.535000,20.066000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<36.830000,-1.535000,18.796000>}
box{<0,0,-0.838200><1.796051,0.035000,0.838200> rotate<0,44.997030,0> translate<35.560000,-1.535000,20.066000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<39.370000,-1.535000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<39.370000,-1.535000,18.796000>}
box{<0,0,-0.838200><2.032000,0.035000,0.838200> rotate<0,90.000000,0> translate<39.370000,-1.535000,18.796000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<39.370000,-1.535000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<40.640000,-1.535000,15.494000>}
box{<0,0,-0.838200><1.796051,0.035000,0.838200> rotate<0,44.997030,0> translate<39.370000,-1.535000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<40.640000,-1.535000,12.446000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<40.640000,-1.535000,15.494000>}
box{<0,0,-0.838200><3.048000,0.035000,0.838200> rotate<0,90.000000,0> translate<40.640000,-1.535000,15.494000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<39.370000,-1.535000,18.796000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<40.640000,-1.535000,20.066000>}
box{<0,0,-0.838200><1.796051,0.035000,0.838200> rotate<0,-44.997030,0> translate<39.370000,-1.535000,18.796000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<40.640000,-1.535000,27.940000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<41.910000,-1.535000,27.940000>}
box{<0,0,-0.838200><1.270000,0.035000,0.838200> rotate<0,0.000000,0> translate<40.640000,-1.535000,27.940000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<42.926000,-1.535000,17.780000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<42.926000,-1.535000,16.764000>}
box{<0,0,-0.838200><1.016000,0.035000,0.838200> rotate<0,-90.000000,0> translate<42.926000,-1.535000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<40.640000,-1.535000,20.066000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<42.926000,-1.535000,17.780000>}
box{<0,0,-0.838200><3.232892,0.035000,0.838200> rotate<0,44.997030,0> translate<40.640000,-1.535000,20.066000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<41.910000,-1.535000,27.940000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<43.180000,-1.535000,29.210000>}
box{<0,0,-0.838200><1.796051,0.035000,0.838200> rotate<0,-44.997030,0> translate<41.910000,-1.535000,27.940000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<42.926000,-1.535000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<44.958000,-1.535000,14.732000>}
box{<0,0,-0.838200><2.873682,0.035000,0.838200> rotate<0,44.997030,0> translate<42.926000,-1.535000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<44.958000,-1.535000,14.732000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<46.482000,-1.535000,14.732000>}
box{<0,0,-0.838200><1.524000,0.035000,0.838200> rotate<0,0.000000,0> translate<44.958000,-1.535000,14.732000> }
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<46.482000,-1.535000,17.272000>}
cylinder{<0,0,0><0,0.035000,0>0.838200 translate<46.482000,-1.535000,20.828000>}
box{<0,0,-0.838200><3.556000,0.035000,0.838200> rotate<0,90.000000,0> translate<46.482000,-1.535000,20.828000> }
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
cylinder{<40.640000,0.038000,20.066000><40.640000,-1.538000,20.066000>0.406400}
cylinder{<35.560000,0.038000,20.066000><35.560000,-1.538000,20.066000>0.406400}
cylinder{<40.640000,0.038000,27.940000><40.640000,-1.538000,27.940000>0.406400}
cylinder{<35.560000,0.038000,27.940000><35.560000,-1.538000,27.940000>0.406400}
cylinder{<27.940000,0.038000,29.210000><27.940000,-1.538000,29.210000>0.406400}
cylinder{<33.020000,0.038000,29.210000><33.020000,-1.538000,29.210000>0.406400}
cylinder{<43.180000,0.038000,29.210000><43.180000,-1.538000,29.210000>0.406400}
cylinder{<48.260000,0.038000,29.210000><48.260000,-1.538000,29.210000>0.406400}
cylinder{<36.830000,0.038000,16.764000><36.830000,-1.538000,16.764000>0.508000}
cylinder{<39.370000,0.038000,16.764000><39.370000,-1.538000,16.764000>0.508000}
cylinder{<29.464000,0.038000,14.986000><29.464000,-1.538000,14.986000>0.508000}
cylinder{<29.464000,0.038000,17.526000><29.464000,-1.538000,17.526000>0.508000}
cylinder{<46.482000,0.038000,17.272000><46.482000,-1.538000,17.272000>0.508000}
cylinder{<46.482000,0.038000,14.732000><46.482000,-1.538000,14.732000>0.508000}
cylinder{<35.560000,0.038000,12.446000><35.560000,-1.538000,12.446000>0.698500}
cylinder{<40.640000,0.038000,12.446000><40.640000,-1.538000,12.446000>0.698500}
//Holes(fast)/Vias
//Holes(fast)/Board
texture{col_hls}
}
#if(pcb_silkscreen=on)
//Silk Screen
union{
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.965900,0.000000,14.008100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.965900,0.000000,14.253800>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,90.000000,0> translate<31.965900,0.000000,14.253800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.965900,0.000000,14.130900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.228700,0.000000,14.130900>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,0.000000,0> translate<31.228700,0.000000,14.130900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.228700,0.000000,14.008100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.228700,0.000000,14.253800>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,90.000000,0> translate<31.228700,0.000000,14.253800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.965900,0.000000,14.507000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.474500,0.000000,14.507000>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<31.474500,0.000000,14.507000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.474500,0.000000,14.507000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.474500,0.000000,14.875600>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<31.474500,0.000000,14.875600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.474500,0.000000,14.875600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.597300,0.000000,14.998400>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<31.474500,0.000000,14.875600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.597300,0.000000,14.998400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.965900,0.000000,14.998400>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<31.597300,0.000000,14.998400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.228700,0.000000,15.746800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.965900,0.000000,15.746800>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,0.000000,0> translate<31.228700,0.000000,15.746800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.965900,0.000000,15.746800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.965900,0.000000,15.378200>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,-90.000000,0> translate<31.965900,0.000000,15.378200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.965900,0.000000,15.378200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.843100,0.000000,15.255400>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<31.843100,0.000000,15.255400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.843100,0.000000,15.255400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.597300,0.000000,15.255400>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<31.597300,0.000000,15.255400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.597300,0.000000,15.255400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.474500,0.000000,15.378200>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<31.474500,0.000000,15.378200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.474500,0.000000,15.378200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.474500,0.000000,15.746800>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<31.474500,0.000000,15.746800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.474500,0.000000,16.003800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.843100,0.000000,16.003800>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<31.474500,0.000000,16.003800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.843100,0.000000,16.003800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.965900,0.000000,16.126600>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<31.843100,0.000000,16.003800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.965900,0.000000,16.126600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.965900,0.000000,16.495200>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<31.965900,0.000000,16.495200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.965900,0.000000,16.495200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.474500,0.000000,16.495200>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<31.474500,0.000000,16.495200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.474500,0.000000,17.243600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.474500,0.000000,16.875000>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,-90.000000,0> translate<31.474500,0.000000,16.875000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.474500,0.000000,16.875000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.597300,0.000000,16.752200>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<31.474500,0.000000,16.875000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.597300,0.000000,16.752200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.843100,0.000000,16.752200>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<31.597300,0.000000,16.752200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.843100,0.000000,16.752200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.965900,0.000000,16.875000>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<31.843100,0.000000,16.752200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.965900,0.000000,16.875000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.965900,0.000000,17.243600>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<31.965900,0.000000,17.243600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.351600,0.000000,17.623400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.843100,0.000000,17.623400>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,0.000000,0> translate<31.351600,0.000000,17.623400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.843100,0.000000,17.623400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.965900,0.000000,17.746300>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<31.843100,0.000000,17.623400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.474500,0.000000,17.500600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.474500,0.000000,17.746300>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,90.000000,0> translate<31.474500,0.000000,17.746300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.965900,0.000000,18.122300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.965900,0.000000,18.368100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<31.965900,0.000000,18.368100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.965900,0.000000,18.368100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.843100,0.000000,18.490900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<31.843100,0.000000,18.490900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.843100,0.000000,18.490900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.597300,0.000000,18.490900>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<31.597300,0.000000,18.490900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.597300,0.000000,18.490900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.474500,0.000000,18.368100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<31.474500,0.000000,18.368100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.474500,0.000000,18.368100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.474500,0.000000,18.122300>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<31.474500,0.000000,18.122300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.474500,0.000000,18.122300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.597300,0.000000,17.999500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<31.474500,0.000000,18.122300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.597300,0.000000,17.999500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.843100,0.000000,17.999500>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<31.597300,0.000000,17.999500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.843100,0.000000,17.999500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.965900,0.000000,18.122300>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<31.843100,0.000000,17.999500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.965900,0.000000,18.747900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.474500,0.000000,18.747900>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<31.474500,0.000000,18.747900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.720200,0.000000,18.747900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.474500,0.000000,18.993600>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,44.997030,0> translate<31.474500,0.000000,18.993600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.474500,0.000000,18.993600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<31.474500,0.000000,19.116500>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,90.000000,0> translate<31.474500,0.000000,19.116500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.665900,0.000000,13.754100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.665900,0.000000,13.999800>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,90.000000,0> translate<44.665900,0.000000,13.999800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.665900,0.000000,13.876900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.928700,0.000000,13.876900>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,0.000000,0> translate<43.928700,0.000000,13.876900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.928700,0.000000,13.754100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.928700,0.000000,13.999800>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,90.000000,0> translate<43.928700,0.000000,13.999800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.665900,0.000000,14.253000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.174500,0.000000,14.253000>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<44.174500,0.000000,14.253000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.174500,0.000000,14.253000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.174500,0.000000,14.621600>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<44.174500,0.000000,14.621600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.174500,0.000000,14.621600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.297300,0.000000,14.744400>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<44.174500,0.000000,14.621600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.297300,0.000000,14.744400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.665900,0.000000,14.744400>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<44.297300,0.000000,14.744400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.928700,0.000000,15.492800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.665900,0.000000,15.492800>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,0.000000,0> translate<43.928700,0.000000,15.492800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.665900,0.000000,15.492800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.665900,0.000000,15.124200>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,-90.000000,0> translate<44.665900,0.000000,15.124200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.665900,0.000000,15.124200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.543100,0.000000,15.001400>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<44.543100,0.000000,15.001400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.543100,0.000000,15.001400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.297300,0.000000,15.001400>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<44.297300,0.000000,15.001400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.297300,0.000000,15.001400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.174500,0.000000,15.124200>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<44.174500,0.000000,15.124200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.174500,0.000000,15.124200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.174500,0.000000,15.492800>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<44.174500,0.000000,15.492800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.174500,0.000000,15.749800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.543100,0.000000,15.749800>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<44.174500,0.000000,15.749800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.543100,0.000000,15.749800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.665900,0.000000,15.872600>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<44.543100,0.000000,15.749800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.665900,0.000000,15.872600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.665900,0.000000,16.241200>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<44.665900,0.000000,16.241200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.665900,0.000000,16.241200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.174500,0.000000,16.241200>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<44.174500,0.000000,16.241200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.174500,0.000000,16.989600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.174500,0.000000,16.621000>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,-90.000000,0> translate<44.174500,0.000000,16.621000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.174500,0.000000,16.621000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.297300,0.000000,16.498200>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<44.174500,0.000000,16.621000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.297300,0.000000,16.498200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.543100,0.000000,16.498200>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<44.297300,0.000000,16.498200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.543100,0.000000,16.498200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.665900,0.000000,16.621000>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<44.543100,0.000000,16.498200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.665900,0.000000,16.621000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.665900,0.000000,16.989600>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<44.665900,0.000000,16.989600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.051600,0.000000,17.369400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.543100,0.000000,17.369400>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,0.000000,0> translate<44.051600,0.000000,17.369400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.543100,0.000000,17.369400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.665900,0.000000,17.492300>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<44.543100,0.000000,17.369400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.174500,0.000000,17.246600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.174500,0.000000,17.492300>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,90.000000,0> translate<44.174500,0.000000,17.492300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.665900,0.000000,17.868300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.665900,0.000000,18.114100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<44.665900,0.000000,18.114100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.665900,0.000000,18.114100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.543100,0.000000,18.236900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<44.543100,0.000000,18.236900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.543100,0.000000,18.236900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.297300,0.000000,18.236900>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<44.297300,0.000000,18.236900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.297300,0.000000,18.236900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.174500,0.000000,18.114100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<44.174500,0.000000,18.114100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.174500,0.000000,18.114100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.174500,0.000000,17.868300>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<44.174500,0.000000,17.868300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.174500,0.000000,17.868300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.297300,0.000000,17.745500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<44.174500,0.000000,17.868300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.297300,0.000000,17.745500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.543100,0.000000,17.745500>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<44.297300,0.000000,17.745500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.543100,0.000000,17.745500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.665900,0.000000,17.868300>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<44.543100,0.000000,17.745500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.665900,0.000000,18.493900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.174500,0.000000,18.493900>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<44.174500,0.000000,18.493900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.420200,0.000000,18.493900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.174500,0.000000,18.739600>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,44.997030,0> translate<44.174500,0.000000,18.739600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.174500,0.000000,18.739600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.174500,0.000000,18.862500>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,90.000000,0> translate<44.174500,0.000000,18.862500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.287600,0.000000,11.705500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,11.582700>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<27.164700,0.000000,11.582700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,11.582700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,11.336900>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<27.164700,0.000000,11.336900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,11.336900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.287600,0.000000,11.214100>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,44.973712,0> translate<27.164700,0.000000,11.336900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.287600,0.000000,11.214100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,11.214100>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,0.000000,0> translate<27.287600,0.000000,11.214100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,11.214100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,11.336900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<27.779100,0.000000,11.214100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,11.336900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,11.582700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<27.901900,0.000000,11.582700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,11.582700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,11.705500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<27.779100,0.000000,11.705500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,11.705500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,11.705500>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<27.533300,0.000000,11.705500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,11.705500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,11.459800>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,-90.000000,0> translate<27.533300,0.000000,11.459800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,11.962500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,11.962500>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,0.000000,0> translate<27.164700,0.000000,11.962500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,11.962500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,12.208200>}
box{<0,0,-0.038100><0.347543,0.036000,0.038100> rotate<0,-44.985374,0> translate<27.164700,0.000000,11.962500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,12.208200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,12.453900>}
box{<0,0,-0.038100><0.347543,0.036000,0.038100> rotate<0,44.985374,0> translate<27.164700,0.000000,12.453900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,12.453900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,12.453900>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,0.000000,0> translate<27.164700,0.000000,12.453900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.287600,0.000000,12.710900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,12.833700>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,44.973712,0> translate<27.164700,0.000000,12.833700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,12.833700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,13.079500>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<27.164700,0.000000,13.079500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,13.079500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.287600,0.000000,13.202300>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<27.164700,0.000000,13.079500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.287600,0.000000,13.202300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,13.202300>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,0.000000,0> translate<27.287600,0.000000,13.202300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,13.202300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,13.079500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<27.410500,0.000000,13.202300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,13.079500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,12.956600>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,-90.000000,0> translate<27.533300,0.000000,12.956600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,13.079500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,13.202300>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<27.533300,0.000000,13.079500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,13.202300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,13.202300>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,0.000000,0> translate<27.656200,0.000000,13.202300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,13.202300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,13.079500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<27.779100,0.000000,13.202300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,13.079500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,12.833700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<27.901900,0.000000,12.833700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,12.833700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,12.710900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<27.779100,0.000000,12.710900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,14.207700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,14.207700>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,0.000000,0> translate<27.164700,0.000000,14.207700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,14.207700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,14.699100>}
box{<0,0,-0.038100><0.885967,0.036000,0.038100> rotate<0,-33.684257,0> translate<27.164700,0.000000,14.207700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,14.699100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,14.699100>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,0.000000,0> translate<27.164700,0.000000,14.699100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,15.078900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,15.324700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<27.901900,0.000000,15.324700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,15.324700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,15.447500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<27.779100,0.000000,15.447500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,15.447500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,15.447500>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<27.533300,0.000000,15.447500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,15.447500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,15.324700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<27.410500,0.000000,15.324700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,15.324700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,15.078900>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<27.410500,0.000000,15.078900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,15.078900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,14.956100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<27.410500,0.000000,15.078900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,14.956100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,14.956100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<27.533300,0.000000,14.956100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,14.956100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,15.078900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<27.779100,0.000000,14.956100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,15.704500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,15.827300>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,90.000000,0> translate<27.410500,0.000000,15.827300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,15.827300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,15.827300>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<27.410500,0.000000,15.827300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,15.704500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,15.950200>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,90.000000,0> translate<27.901900,0.000000,15.950200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.041800,0.000000,15.827300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,15.827300>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,0.000000,0> translate<27.041800,0.000000,15.827300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,16.203400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,16.572000>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<27.901900,0.000000,16.572000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,16.572000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,16.694800>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<27.779100,0.000000,16.694800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,16.694800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,16.572000>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<27.656200,0.000000,16.572000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,16.572000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,16.326200>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<27.656200,0.000000,16.326200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,16.326200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,16.203400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<27.533300,0.000000,16.203400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,16.203400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,16.326200>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<27.410500,0.000000,16.326200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,16.326200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,16.694800>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<27.410500,0.000000,16.694800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,17.320400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,17.074600>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<27.901900,0.000000,17.074600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,17.074600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,16.951800>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<27.779100,0.000000,16.951800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,16.951800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,16.951800>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<27.533300,0.000000,16.951800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,16.951800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,17.074600>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<27.410500,0.000000,17.074600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,17.074600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,17.320400>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<27.410500,0.000000,17.320400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,17.320400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,17.443200>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<27.410500,0.000000,17.320400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,17.443200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,17.443200>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,0.000000,0> translate<27.533300,0.000000,17.443200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,17.443200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,16.951800>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,-90.000000,0> translate<27.656200,0.000000,16.951800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.287600,0.000000,18.940000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,18.817200>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<27.164700,0.000000,18.817200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,18.817200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,18.571400>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<27.164700,0.000000,18.571400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,18.571400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.287600,0.000000,18.448600>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,44.973712,0> translate<27.164700,0.000000,18.571400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.287600,0.000000,18.448600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,18.448600>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,0.000000,0> translate<27.287600,0.000000,18.448600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,18.448600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,18.571400>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<27.410500,0.000000,18.448600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,18.571400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,18.817200>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<27.533300,0.000000,18.817200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,18.817200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,18.940000>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<27.533300,0.000000,18.817200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,18.940000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,18.940000>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,0.000000,0> translate<27.656200,0.000000,18.940000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,18.940000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,18.817200>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<27.779100,0.000000,18.940000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,18.817200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,18.571400>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<27.901900,0.000000,18.571400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,18.571400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,18.448600>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<27.779100,0.000000,18.448600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,19.197000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,19.197000>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<27.410500,0.000000,19.197000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,19.197000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,19.319800>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<27.779100,0.000000,19.197000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,19.319800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,19.688400>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<27.901900,0.000000,19.688400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,19.688400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,19.688400>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<27.410500,0.000000,19.688400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<28.147600,0.000000,19.945400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,19.945400>}
box{<0,0,-0.038100><0.737100,0.036000,0.038100> rotate<0,0.000000,0> translate<27.410500,0.000000,19.945400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,19.945400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,20.314000>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<27.410500,0.000000,20.314000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,20.314000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,20.436800>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<27.410500,0.000000,20.314000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,20.436800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,20.436800>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<27.533300,0.000000,20.436800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,20.436800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,20.314000>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<27.779100,0.000000,20.436800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,20.314000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,19.945400>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,-90.000000,0> translate<27.901900,0.000000,19.945400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<28.147600,0.000000,20.693800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,20.693800>}
box{<0,0,-0.038100><0.737100,0.036000,0.038100> rotate<0,0.000000,0> translate<27.410500,0.000000,20.693800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,20.693800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,21.062400>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<27.410500,0.000000,21.062400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,21.062400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,21.185200>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<27.410500,0.000000,21.062400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,21.185200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,21.185200>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<27.533300,0.000000,21.185200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,21.185200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,21.062400>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<27.779100,0.000000,21.185200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,21.062400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,20.693800>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,-90.000000,0> translate<27.901900,0.000000,20.693800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,21.442200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,21.442200>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<27.410500,0.000000,21.442200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,21.442200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,21.687900>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,44.997030,0> translate<27.410500,0.000000,21.687900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,21.687900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,21.810800>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,90.000000,0> translate<27.410500,0.000000,21.810800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,22.434400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,22.188600>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<27.901900,0.000000,22.188600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,22.188600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,22.065800>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<27.779100,0.000000,22.065800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,22.065800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,22.065800>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<27.533300,0.000000,22.065800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,22.065800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,22.188600>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<27.410500,0.000000,22.188600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,22.188600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,22.434400>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<27.410500,0.000000,22.434400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,22.434400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,22.557200>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<27.410500,0.000000,22.434400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,22.557200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,22.557200>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,0.000000,0> translate<27.533300,0.000000,22.557200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,22.557200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,22.065800>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,-90.000000,0> translate<27.656200,0.000000,22.065800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,22.814200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,23.182800>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<27.901900,0.000000,23.182800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,23.182800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,23.305600>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<27.779100,0.000000,23.305600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,23.305600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,23.182800>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<27.656200,0.000000,23.182800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,23.182800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,22.937000>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<27.656200,0.000000,22.937000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,22.937000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,22.814200>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<27.533300,0.000000,22.814200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,22.814200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,22.937000>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<27.410500,0.000000,22.937000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,22.937000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,23.305600>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<27.410500,0.000000,23.305600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,23.562600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,23.931200>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<27.901900,0.000000,23.931200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,23.931200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,24.054000>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<27.779100,0.000000,24.054000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,24.054000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,23.931200>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<27.656200,0.000000,23.931200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,23.931200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,23.685400>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<27.656200,0.000000,23.685400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,23.685400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,23.562600>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<27.533300,0.000000,23.562600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,23.562600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,23.685400>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<27.410500,0.000000,23.685400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,23.685400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,24.054000>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<27.410500,0.000000,24.054000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,24.433800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,24.679600>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<27.901900,0.000000,24.679600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,24.679600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,24.802400>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<27.779100,0.000000,24.802400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,24.802400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,24.802400>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<27.533300,0.000000,24.802400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,24.802400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,24.679600>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<27.410500,0.000000,24.679600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,24.679600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,24.433800>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<27.410500,0.000000,24.433800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,24.433800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,24.311000>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<27.410500,0.000000,24.433800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.533300,0.000000,24.311000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,24.311000>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<27.533300,0.000000,24.311000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,24.311000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,24.433800>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<27.779100,0.000000,24.311000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,25.059400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,25.059400>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<27.410500,0.000000,25.059400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.656200,0.000000,25.059400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,25.305100>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,44.997030,0> translate<27.410500,0.000000,25.305100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,25.305100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,25.428000>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,90.000000,0> translate<27.410500,0.000000,25.428000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,26.431400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,26.677100>}
box{<0,0,-0.038100><0.549402,0.036000,0.038100> rotate<0,-26.563298,0> translate<27.410500,0.000000,26.431400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,26.677100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,26.922800>}
box{<0,0,-0.038100><0.549402,0.036000,0.038100> rotate<0,26.563298,0> translate<27.410500,0.000000,26.922800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.410500,0.000000,27.179800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,27.425500>}
box{<0,0,-0.038100><0.347543,0.036000,0.038100> rotate<0,44.985374,0> translate<27.164700,0.000000,27.425500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,27.425500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,27.425500>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,0.000000,0> translate<27.164700,0.000000,27.425500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,27.179800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,27.671200>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,90.000000,0> translate<27.901900,0.000000,27.671200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,27.928200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,27.928200>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,0.000000,0> translate<27.779100,0.000000,27.928200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,27.928200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,28.051000>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,90.000000,0> translate<27.779100,0.000000,28.051000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,28.051000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,28.051000>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,0.000000,0> translate<27.779100,0.000000,28.051000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,28.051000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,27.928200>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,-90.000000,0> translate<27.901900,0.000000,27.928200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,28.302400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.287600,0.000000,28.302400>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,0.000000,0> translate<27.287600,0.000000,28.302400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.287600,0.000000,28.302400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,28.425200>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,44.973712,0> translate<27.164700,0.000000,28.425200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,28.425200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,28.671000>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<27.164700,0.000000,28.671000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.164700,0.000000,28.671000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.287600,0.000000,28.793800>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<27.164700,0.000000,28.671000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.287600,0.000000,28.793800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,28.793800>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,0.000000,0> translate<27.287600,0.000000,28.793800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,28.793800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,28.671000>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<27.779100,0.000000,28.793800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,28.671000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,28.425200>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<27.901900,0.000000,28.425200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.901900,0.000000,28.425200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,28.302400>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<27.779100,0.000000,28.302400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.779100,0.000000,28.302400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<27.287600,0.000000,28.793800>}
box{<0,0,-0.038100><0.695015,0.036000,0.038100> rotate<0,44.991201,0> translate<27.287600,0.000000,28.793800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.992700,0.000000,11.722100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,11.722100>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,0.000000,0> translate<47.992700,0.000000,11.722100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,11.722100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,11.844900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<48.238500,0.000000,11.844900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,11.844900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,12.090700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<48.238500,0.000000,12.090700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,12.090700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,12.213500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<48.238500,0.000000,12.090700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,12.213500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,12.213500>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<48.361300,0.000000,12.213500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.115600,0.000000,12.593300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,12.593300>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,0.000000,0> translate<48.115600,0.000000,12.593300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,12.593300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,12.716200>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<48.607100,0.000000,12.593300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,12.470500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,12.716200>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,90.000000,0> translate<48.238500,0.000000,12.716200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.115600,0.000000,13.092200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,13.092200>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,0.000000,0> translate<48.115600,0.000000,13.092200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,13.092200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,13.215100>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<48.607100,0.000000,13.092200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,12.969400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,13.215100>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,90.000000,0> translate<48.238500,0.000000,13.215100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.975600,0.000000,13.468300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,13.468300>}
box{<0,0,-0.038100><0.737100,0.036000,0.038100> rotate<0,0.000000,0> translate<48.238500,0.000000,13.468300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,13.468300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,13.836900>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<48.238500,0.000000,13.836900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,13.836900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,13.959700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<48.238500,0.000000,13.836900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,13.959700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,13.959700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<48.361300,0.000000,13.959700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,13.959700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,13.836900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<48.607100,0.000000,13.959700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,13.836900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,13.468300>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.729900,0.000000,13.468300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,14.216700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,14.339500>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,90.000000,0> translate<48.238500,0.000000,14.339500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,14.339500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,14.339500>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,0.000000,0> translate<48.238500,0.000000,14.339500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,14.339500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,14.216700>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.361300,0.000000,14.216700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,14.216700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,14.216700>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,0.000000,0> translate<48.238500,0.000000,14.216700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,14.216700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,14.339500>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,90.000000,0> translate<48.607100,0.000000,14.339500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,14.339500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,14.339500>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,0.000000,0> translate<48.607100,0.000000,14.339500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,14.339500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,14.216700>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.729900,0.000000,14.216700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,14.216700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,14.216700>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,0.000000,0> translate<48.607100,0.000000,14.216700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,14.590900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.992700,0.000000,15.082300>}
box{<0,0,-0.038100><0.885967,0.036000,0.038100> rotate<0,33.684257,0> translate<47.992700,0.000000,15.082300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,15.339300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.992700,0.000000,15.830700>}
box{<0,0,-0.038100><0.885967,0.036000,0.038100> rotate<0,33.684257,0> translate<47.992700,0.000000,15.830700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,16.087700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,16.087700>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<48.238500,0.000000,16.087700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,16.087700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,16.210500>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,90.000000,0> translate<48.238500,0.000000,16.210500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,16.210500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,16.333400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<48.238500,0.000000,16.210500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,16.333400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,16.333400>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<48.361300,0.000000,16.333400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,16.333400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,16.456300>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<48.238500,0.000000,16.456300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,16.456300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,16.579100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<48.238500,0.000000,16.456300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,16.579100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,16.579100>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<48.361300,0.000000,16.579100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,16.958900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,17.204700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<48.238500,0.000000,17.204700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,17.204700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,17.327500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<48.238500,0.000000,17.204700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,17.327500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,17.327500>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<48.361300,0.000000,17.327500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,17.327500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,16.958900>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.729900,0.000000,16.958900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,16.958900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,16.836100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<48.607100,0.000000,16.836100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,16.836100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.484200,0.000000,16.958900>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,44.973712,0> translate<48.484200,0.000000,16.958900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.484200,0.000000,16.958900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.484200,0.000000,17.327500>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<48.484200,0.000000,17.327500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,17.584500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.992700,0.000000,17.584500>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,0.000000,0> translate<47.992700,0.000000,17.584500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,17.953100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.484200,0.000000,17.584500>}
box{<0,0,-0.038100><0.442984,0.036000,0.038100> rotate<0,-56.309803,0> translate<48.484200,0.000000,17.584500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.484200,0.000000,17.584500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,17.953100>}
box{<0,0,-0.038100><0.442984,0.036000,0.038100> rotate<0,56.309803,0> translate<48.238500,0.000000,17.953100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,18.576700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,18.330900>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.729900,0.000000,18.330900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,18.330900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,18.208100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<48.607100,0.000000,18.208100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,18.208100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,18.208100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<48.361300,0.000000,18.208100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,18.208100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,18.330900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<48.238500,0.000000,18.330900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,18.330900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,18.576700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<48.238500,0.000000,18.576700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,18.576700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,18.699500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<48.238500,0.000000,18.576700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,18.699500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.484200,0.000000,18.699500>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,0.000000,0> translate<48.361300,0.000000,18.699500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.484200,0.000000,18.699500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.484200,0.000000,18.208100>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.484200,0.000000,18.208100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,18.956500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,18.956500>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,0.000000,0> translate<48.607100,0.000000,18.956500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,18.956500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,19.079300>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,90.000000,0> translate<48.607100,0.000000,19.079300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,19.079300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,19.079300>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,0.000000,0> translate<48.607100,0.000000,19.079300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,19.079300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,18.956500>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.729900,0.000000,18.956500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,19.330700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,19.330700>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<48.238500,0.000000,19.330700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.484200,0.000000,19.330700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,19.576400>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,44.997030,0> translate<48.238500,0.000000,19.576400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,19.576400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,19.699300>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,90.000000,0> translate<48.238500,0.000000,19.699300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,19.954300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,19.954300>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<48.238500,0.000000,19.954300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.484200,0.000000,19.954300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,20.200000>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,44.997030,0> translate<48.238500,0.000000,20.200000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,20.200000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,20.322900>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,90.000000,0> translate<48.238500,0.000000,20.322900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,20.577900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,20.577900>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<48.238500,0.000000,20.577900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.484200,0.000000,20.577900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,20.823600>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,44.997030,0> translate<48.238500,0.000000,20.823600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,20.823600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,20.946500>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,90.000000,0> translate<48.238500,0.000000,20.946500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,21.324300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.115600,0.000000,21.324300>}
box{<0,0,-0.038100><0.614300,0.036000,0.038100> rotate<0,0.000000,0> translate<48.115600,0.000000,21.324300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.115600,0.000000,21.324300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.992700,0.000000,21.447200>}
box{<0,0,-0.038100><0.173807,0.036000,0.038100> rotate<0,44.997030,0> translate<47.992700,0.000000,21.447200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,21.201500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,21.447200>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,90.000000,0> translate<48.361300,0.000000,21.447200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,21.700400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,21.700400>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,0.000000,0> translate<48.607100,0.000000,21.700400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,21.700400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,21.823200>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,90.000000,0> translate<48.607100,0.000000,21.823200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,21.823200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,21.823200>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,0.000000,0> translate<48.607100,0.000000,21.823200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,21.823200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,21.700400>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.729900,0.000000,21.700400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,22.197400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,22.443200>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<48.729900,0.000000,22.443200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,22.443200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,22.566000>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<48.607100,0.000000,22.566000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,22.566000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,22.566000>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<48.361300,0.000000,22.566000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,22.566000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,22.443200>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<48.238500,0.000000,22.443200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,22.443200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,22.197400>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.238500,0.000000,22.197400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,22.197400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,22.074600>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<48.238500,0.000000,22.197400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,22.074600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,22.074600>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<48.361300,0.000000,22.074600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,22.074600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,22.197400>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<48.607100,0.000000,22.074600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,22.823000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,22.823000>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<48.238500,0.000000,22.823000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.484200,0.000000,22.823000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,23.068700>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,44.997030,0> translate<48.238500,0.000000,23.068700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,23.068700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,23.191600>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,90.000000,0> translate<48.238500,0.000000,23.191600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.975600,0.000000,23.692300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.975600,0.000000,23.815200>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,90.000000,0> translate<48.975600,0.000000,23.815200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.975600,0.000000,23.815200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.852700,0.000000,23.938000>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,44.973712,0> translate<48.852700,0.000000,23.938000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.852700,0.000000,23.938000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,23.938000>}
box{<0,0,-0.038100><0.614200,0.036000,0.038100> rotate<0,0.000000,0> translate<48.238500,0.000000,23.938000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,23.938000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,23.569400>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.238500,0.000000,23.569400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,23.569400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,23.446600>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<48.238500,0.000000,23.569400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,23.446600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,23.446600>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<48.361300,0.000000,23.446600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,23.446600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,23.569400>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<48.607100,0.000000,23.446600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,23.569400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,23.938000>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<48.729900,0.000000,23.938000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,24.195000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.992700,0.000000,24.686400>}
box{<0,0,-0.038100><0.885967,0.036000,0.038100> rotate<0,33.684257,0> translate<47.992700,0.000000,24.686400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.975600,0.000000,25.189100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.975600,0.000000,25.312000>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,90.000000,0> translate<48.975600,0.000000,25.312000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.975600,0.000000,25.312000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.852700,0.000000,25.434800>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,44.973712,0> translate<48.852700,0.000000,25.434800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.852700,0.000000,25.434800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,25.434800>}
box{<0,0,-0.038100><0.614200,0.036000,0.038100> rotate<0,0.000000,0> translate<48.238500,0.000000,25.434800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,25.434800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,25.066200>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.238500,0.000000,25.066200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,25.066200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,24.943400>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<48.238500,0.000000,25.066200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,24.943400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,24.943400>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<48.361300,0.000000,24.943400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,24.943400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,25.066200>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<48.607100,0.000000,24.943400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,25.066200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,25.434800>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<48.729900,0.000000,25.434800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,25.691800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,25.691800>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<48.238500,0.000000,25.691800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,25.691800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,26.060400>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<48.238500,0.000000,26.060400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,26.060400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,26.183200>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<48.238500,0.000000,26.060400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,26.183200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,26.183200>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<48.361300,0.000000,26.183200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,26.440200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,26.808800>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<48.729900,0.000000,26.808800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,26.808800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,26.931600>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<48.607100,0.000000,26.931600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,26.931600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.484200,0.000000,26.808800>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<48.484200,0.000000,26.808800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.484200,0.000000,26.808800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.484200,0.000000,26.563000>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.484200,0.000000,26.563000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.484200,0.000000,26.563000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,26.440200>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<48.361300,0.000000,26.440200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,26.440200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,26.563000>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<48.238500,0.000000,26.563000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,26.563000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,26.931600>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<48.238500,0.000000,26.931600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,27.188600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.361300,0.000000,27.680000>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,90.000000,0> translate<48.361300,0.000000,27.680000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.238500,0.000000,27.937000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.992700,0.000000,28.182700>}
box{<0,0,-0.038100><0.347543,0.036000,0.038100> rotate<0,44.985374,0> translate<47.992700,0.000000,28.182700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.992700,0.000000,28.182700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,28.182700>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,0.000000,0> translate<47.992700,0.000000,28.182700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,27.937000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,28.428400>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,90.000000,0> translate<48.729900,0.000000,28.428400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,28.685400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,28.685400>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,0.000000,0> translate<48.607100,0.000000,28.685400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,28.685400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,28.808200>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,90.000000,0> translate<48.607100,0.000000,28.808200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,28.808200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,28.808200>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,0.000000,0> translate<48.607100,0.000000,28.808200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,28.808200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,28.685400>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.729900,0.000000,28.685400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,29.059600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.115600,0.000000,29.059600>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,0.000000,0> translate<48.115600,0.000000,29.059600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.115600,0.000000,29.059600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.992700,0.000000,29.182400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,44.973712,0> translate<47.992700,0.000000,29.182400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.992700,0.000000,29.182400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.992700,0.000000,29.428200>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<47.992700,0.000000,29.428200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.992700,0.000000,29.428200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.115600,0.000000,29.551000>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<47.992700,0.000000,29.428200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.115600,0.000000,29.551000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,29.551000>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,0.000000,0> translate<48.115600,0.000000,29.551000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,29.551000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,29.428200>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<48.607100,0.000000,29.551000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,29.428200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,29.182400>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.729900,0.000000,29.182400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.729900,0.000000,29.182400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,29.059600>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<48.607100,0.000000,29.059600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.607100,0.000000,29.059600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.115600,0.000000,29.551000>}
box{<0,0,-0.038100><0.695015,0.036000,0.038100> rotate<0,44.991201,0> translate<48.115600,0.000000,29.551000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.851500,0.000000,39.514400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.728700,0.000000,39.637300>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<36.728700,0.000000,39.637300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.728700,0.000000,39.637300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.482900,0.000000,39.637300>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<36.482900,0.000000,39.637300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.482900,0.000000,39.637300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.360100,0.000000,39.514400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<36.360100,0.000000,39.514400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.360100,0.000000,39.514400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.360100,0.000000,39.022900>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,-90.000000,0> translate<36.360100,0.000000,39.022900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.360100,0.000000,39.022900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.482900,0.000000,38.900100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<36.360100,0.000000,39.022900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.482900,0.000000,38.900100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.728700,0.000000,38.900100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<36.482900,0.000000,38.900100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.728700,0.000000,38.900100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.851500,0.000000,39.022900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<36.728700,0.000000,38.900100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.348300,0.000000,38.900100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.856900,0.000000,38.900100>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<37.856900,0.000000,38.900100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.856900,0.000000,38.900100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.348300,0.000000,39.391500>}
box{<0,0,-0.038100><0.694945,0.036000,0.038100> rotate<0,-44.997030,0> translate<37.856900,0.000000,38.900100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.348300,0.000000,39.391500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.348300,0.000000,39.514400>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,90.000000,0> translate<38.348300,0.000000,39.514400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.348300,0.000000,39.514400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.225500,0.000000,39.637300>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<38.225500,0.000000,39.637300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.225500,0.000000,39.637300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.979700,0.000000,39.637300>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<37.979700,0.000000,39.637300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.979700,0.000000,39.637300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.856900,0.000000,39.514400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<37.856900,0.000000,39.514400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.605300,0.000000,39.022900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.605300,0.000000,39.514400>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,90.000000,0> translate<38.605300,0.000000,39.514400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.605300,0.000000,39.514400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.728100,0.000000,39.637300>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<38.605300,0.000000,39.514400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.728100,0.000000,39.637300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.973900,0.000000,39.637300>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<38.728100,0.000000,39.637300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.973900,0.000000,39.637300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.096700,0.000000,39.514400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<38.973900,0.000000,39.637300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.096700,0.000000,39.514400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.096700,0.000000,39.022900>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,-90.000000,0> translate<39.096700,0.000000,39.022900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.096700,0.000000,39.022900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.973900,0.000000,38.900100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<38.973900,0.000000,38.900100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.973900,0.000000,38.900100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.728100,0.000000,38.900100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<38.728100,0.000000,38.900100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.728100,0.000000,38.900100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.605300,0.000000,39.022900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<38.605300,0.000000,39.022900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.605300,0.000000,39.022900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.096700,0.000000,39.514400>}
box{<0,0,-0.038100><0.695015,0.036000,0.038100> rotate<0,-45.002859,0> translate<38.605300,0.000000,39.022900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.353700,0.000000,39.022900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.353700,0.000000,39.514400>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,90.000000,0> translate<39.353700,0.000000,39.514400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.353700,0.000000,39.514400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.476500,0.000000,39.637300>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<39.353700,0.000000,39.514400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.476500,0.000000,39.637300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.722300,0.000000,39.637300>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<39.476500,0.000000,39.637300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.722300,0.000000,39.637300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.845100,0.000000,39.514400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<39.722300,0.000000,39.637300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.845100,0.000000,39.514400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.845100,0.000000,39.022900>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,-90.000000,0> translate<39.845100,0.000000,39.022900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.845100,0.000000,39.022900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.722300,0.000000,38.900100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<39.722300,0.000000,38.900100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.722300,0.000000,38.900100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.476500,0.000000,38.900100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<39.476500,0.000000,38.900100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.476500,0.000000,38.900100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.353700,0.000000,39.022900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<39.353700,0.000000,39.022900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.353700,0.000000,39.022900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.845100,0.000000,39.514400>}
box{<0,0,-0.038100><0.695015,0.036000,0.038100> rotate<0,-45.002859,0> translate<39.353700,0.000000,39.022900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.102100,0.000000,39.514400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.224900,0.000000,39.637300>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<40.102100,0.000000,39.514400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.224900,0.000000,39.637300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.470700,0.000000,39.637300>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<40.224900,0.000000,39.637300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.470700,0.000000,39.637300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.593500,0.000000,39.514400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<40.470700,0.000000,39.637300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.593500,0.000000,39.514400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.593500,0.000000,39.391500>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,-90.000000,0> translate<40.593500,0.000000,39.391500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.593500,0.000000,39.391500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.470700,0.000000,39.268700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<40.470700,0.000000,39.268700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.470700,0.000000,39.268700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.593500,0.000000,39.145800>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<40.470700,0.000000,39.268700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.593500,0.000000,39.145800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.593500,0.000000,39.022900>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,-90.000000,0> translate<40.593500,0.000000,39.022900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.593500,0.000000,39.022900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.470700,0.000000,38.900100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<40.470700,0.000000,38.900100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.470700,0.000000,38.900100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.224900,0.000000,38.900100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<40.224900,0.000000,38.900100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.224900,0.000000,38.900100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.102100,0.000000,39.022900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<40.102100,0.000000,39.022900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.102100,0.000000,39.022900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.102100,0.000000,39.145800>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,90.000000,0> translate<40.102100,0.000000,39.145800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.102100,0.000000,39.145800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.224900,0.000000,39.268700>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<40.102100,0.000000,39.145800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.224900,0.000000,39.268700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.102100,0.000000,39.391500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<40.102100,0.000000,39.391500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.102100,0.000000,39.391500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.102100,0.000000,39.514400>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,90.000000,0> translate<40.102100,0.000000,39.514400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.224900,0.000000,39.268700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<40.470700,0.000000,39.268700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<40.224900,0.000000,39.268700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.614100,0.000000,37.630100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.614100,0.000000,38.367300>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,90.000000,0> translate<36.614100,0.000000,38.367300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.614100,0.000000,38.367300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.982700,0.000000,38.367300>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<36.614100,0.000000,38.367300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.982700,0.000000,38.367300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.105500,0.000000,38.244400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<36.982700,0.000000,38.367300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.105500,0.000000,38.244400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.105500,0.000000,37.998700>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,-90.000000,0> translate<37.105500,0.000000,37.998700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.105500,0.000000,37.998700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.982700,0.000000,37.875800>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<36.982700,0.000000,37.875800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.982700,0.000000,37.875800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.614100,0.000000,37.875800>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<36.614100,0.000000,37.875800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<36.859800,0.000000,37.875800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.105500,0.000000,37.630100>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,44.997030,0> translate<36.859800,0.000000,37.875800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.362500,0.000000,37.630100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.362500,0.000000,38.367300>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,90.000000,0> translate<37.362500,0.000000,38.367300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.362500,0.000000,38.367300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.731100,0.000000,38.367300>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<37.362500,0.000000,38.367300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.731100,0.000000,38.367300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.853900,0.000000,38.244400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<37.731100,0.000000,38.367300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.853900,0.000000,38.244400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.853900,0.000000,37.998700>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,-90.000000,0> translate<37.853900,0.000000,37.998700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.853900,0.000000,37.998700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.731100,0.000000,37.875800>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<37.731100,0.000000,37.875800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.731100,0.000000,37.875800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.362500,0.000000,37.875800>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<37.362500,0.000000,37.875800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.608200,0.000000,37.875800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<37.853900,0.000000,37.630100>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,44.997030,0> translate<37.608200,0.000000,37.875800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.110900,0.000000,37.630100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.110900,0.000000,38.367300>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,90.000000,0> translate<38.110900,0.000000,38.367300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.110900,0.000000,38.367300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.479500,0.000000,38.367300>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<38.110900,0.000000,38.367300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.479500,0.000000,38.367300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.602300,0.000000,38.244400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<38.479500,0.000000,38.367300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.602300,0.000000,38.244400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.602300,0.000000,37.998700>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,-90.000000,0> translate<38.602300,0.000000,37.998700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.602300,0.000000,37.998700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.479500,0.000000,37.875800>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<38.479500,0.000000,37.875800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.479500,0.000000,37.875800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.110900,0.000000,37.875800>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<38.110900,0.000000,37.875800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.356600,0.000000,37.875800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.602300,0.000000,37.630100>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,44.997030,0> translate<38.356600,0.000000,37.875800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.859300,0.000000,37.630100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.859300,0.000000,38.367300>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,90.000000,0> translate<38.859300,0.000000,38.367300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.859300,0.000000,38.367300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.350700,0.000000,38.367300>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<38.859300,0.000000,38.367300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<38.859300,0.000000,37.998700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<39.105000,0.000000,37.998700>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,0.000000,0> translate<38.859300,0.000000,37.998700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.753400,0.000000,32.029400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,32.029400>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,0.000000,0> translate<36.753400,0.000000,32.029400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,32.029400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,32.309000>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,90.000000,0> translate<37.312600,0.000000,32.309000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,32.309000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.219400,0.000000,32.402200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<37.219400,0.000000,32.402200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.219400,0.000000,32.402200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.846600,0.000000,32.402200>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<36.846600,0.000000,32.402200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.846600,0.000000,32.402200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.753400,0.000000,32.309000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<36.753400,0.000000,32.309000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.753400,0.000000,32.309000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.753400,0.000000,32.029400>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,-90.000000,0> translate<36.753400,0.000000,32.029400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,32.870300>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,32.683900>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<37.312600,0.000000,32.683900> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,32.683900>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.219400,0.000000,32.590700>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<37.219400,0.000000,32.590700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.219400,0.000000,32.590700>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.033000,0.000000,32.590700>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<37.033000,0.000000,32.590700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.033000,0.000000,32.590700>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,32.683900>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<36.939800,0.000000,32.683900> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,32.683900>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,32.870300>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<36.939800,0.000000,32.870300> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,32.870300>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.033000,0.000000,32.963500>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<36.939800,0.000000,32.870300> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.033000,0.000000,32.963500>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.126200,0.000000,32.963500>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<37.033000,0.000000,32.963500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.126200,0.000000,32.963500>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.126200,0.000000,32.590700>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,-90.000000,0> translate<37.126200,0.000000,32.590700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,33.152000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,33.431600>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,90.000000,0> translate<37.312600,0.000000,33.431600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,33.431600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.219400,0.000000,33.524800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<37.219400,0.000000,33.524800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.219400,0.000000,33.524800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.126200,0.000000,33.431600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<37.126200,0.000000,33.431600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.126200,0.000000,33.431600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.126200,0.000000,33.245200>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<37.126200,0.000000,33.245200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.126200,0.000000,33.245200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.033000,0.000000,33.152000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<37.033000,0.000000,33.152000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.033000,0.000000,33.152000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,33.245200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<36.939800,0.000000,33.245200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,33.245200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,33.524800>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,90.000000,0> translate<36.939800,0.000000,33.524800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,33.713300>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,33.806500>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,90.000000,0> translate<36.939800,0.000000,33.806500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,33.806500>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,33.806500>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<36.939800,0.000000,33.806500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,33.713300>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,33.899700>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<37.312600,0.000000,33.899700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.660200,0.000000,33.806500>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.753400,0.000000,33.806500>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<36.660200,0.000000,33.806500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.499000,0.000000,34.273900>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.499000,0.000000,34.367100>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,90.000000,0> translate<37.499000,0.000000,34.367100> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.499000,0.000000,34.367100>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.405800,0.000000,34.460300>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<37.405800,0.000000,34.460300> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.405800,0.000000,34.460300>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,34.460300>}
box{<0,0,-0.025400><0.466000,0.036000,0.025400> rotate<0,0.000000,0> translate<36.939800,0.000000,34.460300> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,34.460300>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,34.180700>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,-90.000000,0> translate<36.939800,0.000000,34.180700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,34.180700>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.033000,0.000000,34.087500>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<36.939800,0.000000,34.180700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.033000,0.000000,34.087500>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.219400,0.000000,34.087500>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<37.033000,0.000000,34.087500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.219400,0.000000,34.087500>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,34.180700>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<37.219400,0.000000,34.087500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,34.180700>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,34.460300>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,90.000000,0> translate<37.312600,0.000000,34.460300> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,34.648800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,34.648800>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<36.939800,0.000000,34.648800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,34.648800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,34.928400>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,90.000000,0> translate<36.939800,0.000000,34.928400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,34.928400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.033000,0.000000,35.021600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<36.939800,0.000000,34.928400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.033000,0.000000,35.021600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,35.021600>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<37.033000,0.000000,35.021600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,35.771400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.753400,0.000000,35.771400>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,0.000000,0> translate<36.753400,0.000000,35.771400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.753400,0.000000,35.771400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.753400,0.000000,36.051000>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,90.000000,0> translate<36.753400,0.000000,36.051000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.753400,0.000000,36.051000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.846600,0.000000,36.144200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<36.753400,0.000000,36.051000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.846600,0.000000,36.144200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,36.144200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<36.846600,0.000000,36.144200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,36.144200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.033000,0.000000,36.051000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<36.939800,0.000000,36.144200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.033000,0.000000,36.051000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.126200,0.000000,36.144200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<37.033000,0.000000,36.051000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.126200,0.000000,36.144200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.219400,0.000000,36.144200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<37.126200,0.000000,36.144200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.219400,0.000000,36.144200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,36.051000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<37.219400,0.000000,36.144200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,36.051000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,35.771400>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,-90.000000,0> translate<37.312600,0.000000,35.771400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.033000,0.000000,35.771400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.033000,0.000000,36.051000>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,90.000000,0> translate<37.033000,0.000000,36.051000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,36.332700>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.219400,0.000000,36.332700>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<36.939800,0.000000,36.332700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.219400,0.000000,36.332700>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,36.425900>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<37.219400,0.000000,36.332700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,36.425900>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,36.705500>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,90.000000,0> translate<37.312600,0.000000,36.705500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,36.705500>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.405800,0.000000,36.705500>}
box{<0,0,-0.025400><0.466000,0.036000,0.025400> rotate<0,0.000000,0> translate<36.939800,0.000000,36.705500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.405800,0.000000,36.705500>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.499000,0.000000,36.612300>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<37.405800,0.000000,36.705500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.499000,0.000000,36.612300>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.499000,0.000000,36.519100>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<37.499000,0.000000,36.519100> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,36.894000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,36.987200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,90.000000,0> translate<36.939800,0.000000,36.987200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,36.987200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.033000,0.000000,36.987200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<36.939800,0.000000,36.987200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.033000,0.000000,36.987200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.033000,0.000000,36.894000>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<37.033000,0.000000,36.894000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.033000,0.000000,36.894000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.939800,0.000000,36.894000>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<36.939800,0.000000,36.894000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.219400,0.000000,36.894000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.219400,0.000000,36.987200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,90.000000,0> translate<37.219400,0.000000,36.987200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.219400,0.000000,36.987200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,36.987200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<37.219400,0.000000,36.987200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,36.987200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,36.894000>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<37.312600,0.000000,36.894000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.312600,0.000000,36.894000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.219400,0.000000,36.894000>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<37.219400,0.000000,36.894000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,32.029400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.769400,0.000000,32.029400>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,0.000000,0> translate<37.769400,0.000000,32.029400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.769400,0.000000,32.029400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,32.402200>}
box{<0,0,-0.025400><0.672075,0.036000,0.025400> rotate<0,-33.687844,0> translate<37.769400,0.000000,32.029400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,32.402200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.769400,0.000000,32.402200>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,0.000000,0> translate<37.769400,0.000000,32.402200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,32.683900>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,32.870300>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<38.328600,0.000000,32.870300> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,32.870300>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.235400,0.000000,32.963500>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<38.235400,0.000000,32.963500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.235400,0.000000,32.963500>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.049000,0.000000,32.963500>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<38.049000,0.000000,32.963500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.049000,0.000000,32.963500>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.955800,0.000000,32.870300>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<37.955800,0.000000,32.870300> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.955800,0.000000,32.870300>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.955800,0.000000,32.683900>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<37.955800,0.000000,32.683900> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.955800,0.000000,32.683900>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.049000,0.000000,32.590700>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<37.955800,0.000000,32.683900> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.049000,0.000000,32.590700>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.235400,0.000000,32.590700>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<38.049000,0.000000,32.590700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.235400,0.000000,32.590700>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,32.683900>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<38.235400,0.000000,32.590700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.515000,0.000000,33.152000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.955800,0.000000,33.152000>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,0.000000,0> translate<37.955800,0.000000,33.152000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.955800,0.000000,33.152000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.955800,0.000000,33.431600>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,90.000000,0> translate<37.955800,0.000000,33.431600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.955800,0.000000,33.431600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.049000,0.000000,33.524800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<37.955800,0.000000,33.431600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.049000,0.000000,33.524800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.235400,0.000000,33.524800>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<38.049000,0.000000,33.524800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.235400,0.000000,33.524800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,33.431600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<38.235400,0.000000,33.524800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,33.431600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,33.152000>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,-90.000000,0> translate<38.328600,0.000000,33.152000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,33.713300>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.769400,0.000000,33.713300>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,0.000000,0> translate<37.769400,0.000000,33.713300> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.049000,0.000000,33.713300>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.049000,0.000000,34.086100>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<38.049000,0.000000,34.086100> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.769400,0.000000,34.086100>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,34.086100>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,0.000000,0> translate<37.769400,0.000000,34.086100> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,34.554200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,34.367800>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<38.328600,0.000000,34.367800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,34.367800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.235400,0.000000,34.274600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<38.235400,0.000000,34.274600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.235400,0.000000,34.274600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.049000,0.000000,34.274600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<38.049000,0.000000,34.274600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.049000,0.000000,34.274600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.955800,0.000000,34.367800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<37.955800,0.000000,34.367800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.955800,0.000000,34.367800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.955800,0.000000,34.554200>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<37.955800,0.000000,34.554200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.955800,0.000000,34.554200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.049000,0.000000,34.647400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<37.955800,0.000000,34.554200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.049000,0.000000,34.647400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.142200,0.000000,34.647400>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<38.049000,0.000000,34.647400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.142200,0.000000,34.647400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.142200,0.000000,34.274600>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,-90.000000,0> translate<38.142200,0.000000,34.274600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.955800,0.000000,34.929100>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.955800,0.000000,35.115500>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<37.955800,0.000000,35.115500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.955800,0.000000,35.115500>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.049000,0.000000,35.208700>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<37.955800,0.000000,35.115500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.049000,0.000000,35.208700>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,35.208700>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<38.049000,0.000000,35.208700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,35.208700>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,34.929100>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,-90.000000,0> translate<38.328600,0.000000,34.929100> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,34.929100>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.235400,0.000000,34.835900>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<38.235400,0.000000,34.835900> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.235400,0.000000,34.835900>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.142200,0.000000,34.929100>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<38.142200,0.000000,34.929100> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.142200,0.000000,34.929100>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.142200,0.000000,35.208700>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,90.000000,0> translate<38.142200,0.000000,35.208700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.769400,0.000000,35.770000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,35.770000>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,0.000000,0> translate<37.769400,0.000000,35.770000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,35.770000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,35.490400>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,-90.000000,0> translate<38.328600,0.000000,35.490400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,35.490400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.235400,0.000000,35.397200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<38.235400,0.000000,35.397200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.235400,0.000000,35.397200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.049000,0.000000,35.397200>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<38.049000,0.000000,35.397200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.049000,0.000000,35.397200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.955800,0.000000,35.490400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<37.955800,0.000000,35.490400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.955800,0.000000,35.490400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.955800,0.000000,35.770000>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,90.000000,0> translate<37.955800,0.000000,35.770000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.142200,0.000000,36.892600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,36.706200>}
box{<0,0,-0.025400><0.263609,0.036000,0.025400> rotate<0,44.997030,0> translate<38.142200,0.000000,36.892600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,36.706200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,36.613000>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<38.328600,0.000000,36.613000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,36.613000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.235400,0.000000,36.519800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<38.235400,0.000000,36.519800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.235400,0.000000,36.519800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.142200,0.000000,36.519800>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<38.142200,0.000000,36.519800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.142200,0.000000,36.519800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.955800,0.000000,36.706200>}
box{<0,0,-0.025400><0.263609,0.036000,0.025400> rotate<0,44.997030,0> translate<37.955800,0.000000,36.706200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.955800,0.000000,36.706200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.862600,0.000000,36.706200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<37.862600,0.000000,36.706200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.862600,0.000000,36.706200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.769400,0.000000,36.613000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<37.769400,0.000000,36.613000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.769400,0.000000,36.613000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.862600,0.000000,36.519800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<37.769400,0.000000,36.613000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.862600,0.000000,36.519800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.955800,0.000000,36.519800>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<37.862600,0.000000,36.519800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.955800,0.000000,36.519800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.328600,0.000000,36.892600>}
box{<0,0,-0.025400><0.527219,0.036000,0.025400> rotate<0,-44.997030,0> translate<37.955800,0.000000,36.519800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.785400,0.000000,32.029400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.785400,0.000000,32.402200>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<38.785400,0.000000,32.402200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.785400,0.000000,32.402200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.878600,0.000000,32.402200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<38.785400,0.000000,32.402200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.878600,0.000000,32.402200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.251400,0.000000,32.029400>}
box{<0,0,-0.025400><0.527219,0.036000,0.025400> rotate<0,44.997030,0> translate<38.878600,0.000000,32.402200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.251400,0.000000,32.029400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,32.029400>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<39.251400,0.000000,32.029400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,32.029400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,32.402200>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<39.344600,0.000000,32.402200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,32.683900>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,32.870300>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<38.971800,0.000000,32.870300> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,32.870300>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,32.963500>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<38.971800,0.000000,32.870300> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,32.963500>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,32.963500>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<39.065000,0.000000,32.963500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,32.963500>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,32.683900>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,-90.000000,0> translate<39.344600,0.000000,32.683900> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,32.683900>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.251400,0.000000,32.590700>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<39.251400,0.000000,32.590700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.251400,0.000000,32.590700>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.158200,0.000000,32.683900>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<39.158200,0.000000,32.683900> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.158200,0.000000,32.683900>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.158200,0.000000,32.963500>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,90.000000,0> translate<39.158200,0.000000,32.963500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,33.524800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,33.245200>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,-90.000000,0> translate<38.971800,0.000000,33.245200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,33.245200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,33.152000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<38.971800,0.000000,33.245200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,33.152000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.251400,0.000000,33.152000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<39.065000,0.000000,33.152000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.251400,0.000000,33.152000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,33.245200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<39.251400,0.000000,33.152000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,33.245200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,33.524800>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,90.000000,0> translate<39.344600,0.000000,33.524800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.785400,0.000000,33.713300>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,33.713300>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,0.000000,0> translate<38.785400,0.000000,33.713300> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,33.713300>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,33.806500>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<38.971800,0.000000,33.806500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,33.806500>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,33.992900>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<38.971800,0.000000,33.992900> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,33.992900>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,34.086100>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<38.971800,0.000000,33.992900> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,34.086100>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,34.086100>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<39.065000,0.000000,34.086100> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,34.835900>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.785400,0.000000,34.835900>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,0.000000,0> translate<38.785400,0.000000,34.835900> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,34.835900>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,35.208700>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<39.065000,0.000000,35.208700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.785400,0.000000,35.208700>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,35.208700>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,0.000000,0> translate<38.785400,0.000000,35.208700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,35.490400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,35.676800>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<39.344600,0.000000,35.676800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,35.676800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.251400,0.000000,35.770000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<39.251400,0.000000,35.770000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.251400,0.000000,35.770000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,35.770000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<39.065000,0.000000,35.770000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,35.770000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,35.676800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<38.971800,0.000000,35.676800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,35.676800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,35.490400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<38.971800,0.000000,35.490400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,35.490400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,35.397200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<38.971800,0.000000,35.490400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,35.397200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.251400,0.000000,35.397200>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<39.065000,0.000000,35.397200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.251400,0.000000,35.397200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,35.490400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<39.251400,0.000000,35.397200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,36.238100>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,36.051700>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<39.344600,0.000000,36.051700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,36.051700>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.251400,0.000000,35.958500>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<39.251400,0.000000,35.958500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.251400,0.000000,35.958500>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,35.958500>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<39.065000,0.000000,35.958500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,35.958500>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,36.051700>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<38.971800,0.000000,36.051700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,36.051700>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,36.238100>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<38.971800,0.000000,36.238100> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,36.238100>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,36.331300>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<38.971800,0.000000,36.238100> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,36.331300>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.158200,0.000000,36.331300>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<39.065000,0.000000,36.331300> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.158200,0.000000,36.331300>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.158200,0.000000,35.958500>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,-90.000000,0> translate<39.158200,0.000000,35.958500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,36.519800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.785400,0.000000,36.519800>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,0.000000,0> translate<38.785400,0.000000,36.519800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,36.799400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.158200,0.000000,36.519800>}
box{<0,0,-0.025400><0.336037,0.036000,0.025400> rotate<0,-56.306216,0> translate<39.158200,0.000000,36.519800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.158200,0.000000,36.519800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,36.799400>}
box{<0,0,-0.025400><0.336037,0.036000,0.025400> rotate<0,56.306216,0> translate<38.971800,0.000000,36.799400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,37.267100>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,37.080700>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<39.344600,0.000000,37.080700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,37.080700>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.251400,0.000000,36.987500>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<39.251400,0.000000,36.987500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.251400,0.000000,36.987500>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,36.987500>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<39.065000,0.000000,36.987500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,36.987500>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,37.080700>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<38.971800,0.000000,37.080700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,37.080700>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,37.267100>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<38.971800,0.000000,37.267100> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,37.267100>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,37.360300>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<38.971800,0.000000,37.267100> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,37.360300>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.158200,0.000000,37.360300>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<39.065000,0.000000,37.360300> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.158200,0.000000,37.360300>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.158200,0.000000,36.987500>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,-90.000000,0> translate<39.158200,0.000000,36.987500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,37.548800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,37.548800>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<38.971800,0.000000,37.548800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,37.548800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,37.828400>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,90.000000,0> translate<38.971800,0.000000,37.828400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<38.971800,0.000000,37.828400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,37.921600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<38.971800,0.000000,37.828400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.065000,0.000000,37.921600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<39.344600,0.000000,37.921600>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<39.065000,0.000000,37.921600> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<36.474400,0.000000,31.902400>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<36.474400,0.000000,37.312600>}
box{<0,0,-0.063500><5.410200,0.036000,0.063500> rotate<0,90.000000,0> translate<36.474400,0.000000,37.312600> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<36.474400,0.000000,37.312600>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<39.776400,0.000000,37.312600>}
box{<0,0,-0.063500><3.302000,0.036000,0.063500> rotate<0,0.000000,0> translate<36.474400,0.000000,37.312600> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<39.776400,0.000000,37.312600>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<39.776400,0.000000,31.826200>}
box{<0,0,-0.063500><5.486400,0.036000,0.063500> rotate<0,-90.000000,0> translate<39.776400,0.000000,31.826200> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<39.776400,0.000000,31.826200>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<36.474400,0.000000,31.826200>}
box{<0,0,-0.063500><3.302000,0.036000,0.063500> rotate<0,0.000000,0> translate<36.474400,0.000000,31.826200> }
difference{
cylinder{<36.703000,0,39.217600><36.703000,0.036000,39.217600>0.622300 translate<0,0.000000,0>}
cylinder{<36.703000,-0.1,39.217600><36.703000,0.135000,39.217600>0.495300 translate<0,0.000000,0>}}
//C1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<38.404800,0.000000,19.431000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<38.404800,0.000000,20.066000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<38.404800,0.000000,20.066000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<38.404800,0.000000,20.066000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<38.404800,0.000000,20.701000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<38.404800,0.000000,20.701000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.404800,0.000000,20.066000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.624000,0.000000,20.066000>}
box{<0,0,-0.076200><1.219200,0.036000,0.076200> rotate<0,0.000000,0> translate<38.404800,0.000000,20.066000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.769800,0.000000,19.431000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.769800,0.000000,20.066000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<37.769800,0.000000,20.066000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.769800,0.000000,20.066000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.769800,0.000000,20.701000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<37.769800,0.000000,20.701000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.769800,0.000000,20.066000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.576000,0.000000,20.066000>}
box{<0,0,-0.076200><1.193800,0.036000,0.076200> rotate<0,0.000000,0> translate<36.576000,0.000000,20.066000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.783000,0.000000,18.796000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.783000,0.000000,21.336000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.783000,0.000000,21.336000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.529000,0.000000,21.590000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.671000,0.000000,21.590000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.671000,0.000000,21.590000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.417000,0.000000,21.336000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.417000,0.000000,18.796000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,-90.000000,0> translate<34.417000,0.000000,18.796000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.671000,0.000000,18.542000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.529000,0.000000,18.542000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.671000,0.000000,18.542000> }
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<34.671000,0.000000,18.796000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<34.671000,0.000000,21.336000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<41.529000,0.000000,21.336000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<41.529000,0.000000,18.796000>}
//C2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<38.404800,0.000000,27.305000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<38.404800,0.000000,27.940000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<38.404800,0.000000,27.940000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<38.404800,0.000000,27.940000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<38.404800,0.000000,28.575000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<38.404800,0.000000,28.575000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.404800,0.000000,27.940000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.624000,0.000000,27.940000>}
box{<0,0,-0.076200><1.219200,0.036000,0.076200> rotate<0,0.000000,0> translate<38.404800,0.000000,27.940000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.769800,0.000000,27.305000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.769800,0.000000,27.940000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<37.769800,0.000000,27.940000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.769800,0.000000,27.940000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.769800,0.000000,28.575000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<37.769800,0.000000,28.575000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.769800,0.000000,27.940000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.576000,0.000000,27.940000>}
box{<0,0,-0.076200><1.193800,0.036000,0.076200> rotate<0,0.000000,0> translate<36.576000,0.000000,27.940000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.783000,0.000000,26.670000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.783000,0.000000,29.210000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.783000,0.000000,29.210000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.529000,0.000000,29.464000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.671000,0.000000,29.464000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.671000,0.000000,29.464000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.417000,0.000000,29.210000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.417000,0.000000,26.670000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,-90.000000,0> translate<34.417000,0.000000,26.670000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.671000,0.000000,26.416000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.529000,0.000000,26.416000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.671000,0.000000,26.416000> }
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<34.671000,0.000000,26.670000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<34.671000,0.000000,29.210000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<41.529000,0.000000,29.210000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<41.529000,0.000000,26.670000>}
//C3 silk screen
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<30.175200,0.000000,29.845000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<30.175200,0.000000,29.210000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<30.175200,0.000000,29.210000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<30.175200,0.000000,29.210000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<30.175200,0.000000,28.575000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<30.175200,0.000000,28.575000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.175200,0.000000,29.210000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.956000,0.000000,29.210000>}
box{<0,0,-0.076200><1.219200,0.036000,0.076200> rotate<0,0.000000,0> translate<28.956000,0.000000,29.210000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<30.810200,0.000000,29.845000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<30.810200,0.000000,29.210000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<30.810200,0.000000,29.210000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<30.810200,0.000000,29.210000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<30.810200,0.000000,28.575000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<30.810200,0.000000,28.575000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.810200,0.000000,29.210000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.004000,0.000000,29.210000>}
box{<0,0,-0.076200><1.193800,0.036000,0.076200> rotate<0,0.000000,0> translate<30.810200,0.000000,29.210000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.797000,0.000000,30.480000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.797000,0.000000,27.940000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,-90.000000,0> translate<26.797000,0.000000,27.940000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.051000,0.000000,27.686000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.909000,0.000000,27.686000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<27.051000,0.000000,27.686000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.163000,0.000000,27.940000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.163000,0.000000,30.480000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,90.000000,0> translate<34.163000,0.000000,30.480000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.909000,0.000000,30.734000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.051000,0.000000,30.734000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<27.051000,0.000000,30.734000> }
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<33.909000,0.000000,30.480000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<33.909000,0.000000,27.940000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<27.051000,0.000000,27.940000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<27.051000,0.000000,30.480000>}
//C4 silk screen
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<45.415200,0.000000,29.845000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<45.415200,0.000000,29.210000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<45.415200,0.000000,29.210000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<45.415200,0.000000,29.210000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<45.415200,0.000000,28.575000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<45.415200,0.000000,28.575000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.415200,0.000000,29.210000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.196000,0.000000,29.210000>}
box{<0,0,-0.076200><1.219200,0.036000,0.076200> rotate<0,0.000000,0> translate<44.196000,0.000000,29.210000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<46.050200,0.000000,29.845000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<46.050200,0.000000,29.210000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<46.050200,0.000000,29.210000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<46.050200,0.000000,29.210000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<46.050200,0.000000,28.575000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<46.050200,0.000000,28.575000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.050200,0.000000,29.210000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.244000,0.000000,29.210000>}
box{<0,0,-0.076200><1.193800,0.036000,0.076200> rotate<0,0.000000,0> translate<46.050200,0.000000,29.210000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.037000,0.000000,30.480000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.037000,0.000000,27.940000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,-90.000000,0> translate<42.037000,0.000000,27.940000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.291000,0.000000,27.686000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.149000,0.000000,27.686000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<42.291000,0.000000,27.686000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.403000,0.000000,27.940000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.403000,0.000000,30.480000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,90.000000,0> translate<49.403000,0.000000,30.480000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.149000,0.000000,30.734000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.291000,0.000000,30.734000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<42.291000,0.000000,30.734000> }
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<49.149000,0.000000,30.480000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<49.149000,0.000000,27.940000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<42.291000,0.000000,27.940000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<42.291000,0.000000,30.480000>}
//H1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<33.020000,0.000000,27.051000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<33.020000,0.000000,26.797000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,-90.000000,0> translate<33.020000,0.000000,26.797000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<33.020000,0.000000,21.463000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<33.020000,0.000000,21.209000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,-90.000000,0> translate<33.020000,0.000000,21.209000> }
object{ARC(1.778000,2.286000,180.000000,270.000000,0.036000) translate<33.020000,0.000000,24.130000>}
object{ARC(1.778000,2.286000,0.000000,90.000000,0.036000) translate<33.020000,0.000000,24.130000>}
difference{
cylinder{<33.020000,0,24.130000><33.020000,0.036000,24.130000>0.863600 translate<0,0.000000,0>}
cylinder{<33.020000,-0.1,24.130000><33.020000,0.135000,24.130000>0.406400 translate<0,0.000000,0>}}
difference{
cylinder{<33.020000,0,24.130000><33.020000,0.036000,24.130000>2.997200 translate<0,0.000000,0>}
cylinder{<33.020000,-0.1,24.130000><33.020000,0.135000,24.130000>2.844800 translate<0,0.000000,0>}}
difference{
cylinder{<33.020000,0,24.130000><33.020000,0.036000,24.130000>1.601600 translate<0,0.000000,0>}
cylinder{<33.020000,-0.1,24.130000><33.020000,0.135000,24.130000>1.398400 translate<0,0.000000,0>}}
//H2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<43.180000,0.000000,27.051000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<43.180000,0.000000,26.797000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,-90.000000,0> translate<43.180000,0.000000,26.797000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<43.180000,0.000000,21.463000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<43.180000,0.000000,21.209000>}
box{<0,0,-0.025400><0.254000,0.036000,0.025400> rotate<0,-90.000000,0> translate<43.180000,0.000000,21.209000> }
object{ARC(1.778000,2.286000,180.000000,270.000000,0.036000) translate<43.180000,0.000000,24.130000>}
object{ARC(1.778000,2.286000,0.000000,90.000000,0.036000) translate<43.180000,0.000000,24.130000>}
difference{
cylinder{<43.180000,0,24.130000><43.180000,0.036000,24.130000>0.863600 translate<0,0.000000,0>}
cylinder{<43.180000,-0.1,24.130000><43.180000,0.135000,24.130000>0.406400 translate<0,0.000000,0>}}
difference{
cylinder{<43.180000,0,24.130000><43.180000,0.036000,24.130000>2.997200 translate<0,0.000000,0>}
cylinder{<43.180000,-0.1,24.130000><43.180000,0.135000,24.130000>2.844800 translate<0,0.000000,0>}}
difference{
cylinder{<43.180000,0,24.130000><43.180000,0.036000,24.130000>1.601600 translate<0,0.000000,0>}
cylinder{<43.180000,-0.1,24.130000><43.180000,0.135000,24.130000>1.398400 translate<0,0.000000,0>}}
//H3 silk screen
object{ARC(2.540000,3.911600,180.000000,270.000000,0.036000) translate<31.242000,0.000000,35.814000>}
object{ARC(2.540000,3.911600,0.000000,90.000000,0.036000) translate<31.242000,0.000000,35.814000>}
difference{
cylinder{<31.242000,0,35.814000><31.242000,0.036000,35.814000>4.572000 translate<0,0.000000,0>}
cylinder{<31.242000,-0.1,35.814000><31.242000,0.135000,35.814000>4.419600 translate<0,0.000000,0>}}
difference{
cylinder{<31.242000,0,35.814000><31.242000,0.036000,35.814000>0.990600 translate<0,0.000000,0>}
cylinder{<31.242000,-0.1,35.814000><31.242000,0.135000,35.814000>0.533400 translate<0,0.000000,0>}}
difference{
cylinder{<31.242000,0,35.814000><31.242000,0.036000,35.814000>2.226200 translate<0,0.000000,0>}
cylinder{<31.242000,-0.1,35.814000><31.242000,0.135000,35.814000>2.073800 translate<0,0.000000,0>}}
//H4 silk screen
object{ARC(2.540000,3.911600,180.000000,270.000000,0.036000) translate<44.958000,0.000000,35.814000>}
object{ARC(2.540000,3.911600,0.000000,90.000000,0.036000) translate<44.958000,0.000000,35.814000>}
difference{
cylinder{<44.958000,0,35.814000><44.958000,0.036000,35.814000>4.572000 translate<0,0.000000,0>}
cylinder{<44.958000,-0.1,35.814000><44.958000,0.135000,35.814000>4.419600 translate<0,0.000000,0>}}
difference{
cylinder{<44.958000,0,35.814000><44.958000,0.036000,35.814000>0.990600 translate<0,0.000000,0>}
cylinder{<44.958000,-0.1,35.814000><44.958000,0.135000,35.814000>0.533400 translate<0,0.000000,0>}}
difference{
cylinder{<44.958000,0,35.814000><44.958000,0.036000,35.814000>2.226200 translate<0,0.000000,0>}
cylinder{<44.958000,-0.1,35.814000><44.958000,0.135000,35.814000>2.073800 translate<0,0.000000,0>}}
//JP1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.195000,0.000000,18.034000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.465000,0.000000,18.034000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.195000,0.000000,18.034000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.465000,0.000000,18.034000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.100000,0.000000,17.399000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<37.465000,0.000000,18.034000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.100000,0.000000,17.399000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.100000,0.000000,16.129000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<38.100000,0.000000,16.129000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.100000,0.000000,16.129000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.465000,0.000000,15.494000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<37.465000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.560000,0.000000,17.399000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.560000,0.000000,16.129000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<35.560000,0.000000,16.129000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.195000,0.000000,18.034000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.560000,0.000000,17.399000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<35.560000,0.000000,17.399000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.560000,0.000000,16.129000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.195000,0.000000,15.494000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<35.560000,0.000000,16.129000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.465000,0.000000,15.494000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.195000,0.000000,15.494000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.195000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.100000,0.000000,17.399000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.735000,0.000000,18.034000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<38.100000,0.000000,17.399000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.735000,0.000000,18.034000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.005000,0.000000,18.034000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<38.735000,0.000000,18.034000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.005000,0.000000,18.034000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.640000,0.000000,17.399000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<40.005000,0.000000,18.034000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.640000,0.000000,17.399000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.640000,0.000000,16.129000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<40.640000,0.000000,16.129000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.640000,0.000000,16.129000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.005000,0.000000,15.494000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<40.005000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.005000,0.000000,15.494000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.735000,0.000000,15.494000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<38.735000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.735000,0.000000,15.494000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.100000,0.000000,16.129000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<38.100000,0.000000,16.129000> }
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<36.830000,0.000000,16.764000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-0.000000,0> translate<39.370000,0.000000,16.764000>}
//JP2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.194000,0.000000,14.351000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.194000,0.000000,15.621000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<28.194000,0.000000,15.621000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.194000,0.000000,15.621000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.829000,0.000000,16.256000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<28.194000,0.000000,15.621000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.829000,0.000000,16.256000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.099000,0.000000,16.256000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<28.829000,0.000000,16.256000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.099000,0.000000,16.256000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.734000,0.000000,15.621000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<30.099000,0.000000,16.256000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.829000,0.000000,13.716000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.099000,0.000000,13.716000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<28.829000,0.000000,13.716000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.194000,0.000000,14.351000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.829000,0.000000,13.716000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<28.194000,0.000000,14.351000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.099000,0.000000,13.716000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.734000,0.000000,14.351000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<30.099000,0.000000,13.716000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.734000,0.000000,15.621000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.734000,0.000000,14.351000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<30.734000,0.000000,14.351000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.829000,0.000000,16.256000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.194000,0.000000,16.891000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<28.194000,0.000000,16.891000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.194000,0.000000,16.891000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.194000,0.000000,18.161000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<28.194000,0.000000,18.161000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.194000,0.000000,18.161000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.829000,0.000000,18.796000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<28.194000,0.000000,18.161000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.829000,0.000000,18.796000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.099000,0.000000,18.796000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<28.829000,0.000000,18.796000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.099000,0.000000,18.796000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.734000,0.000000,18.161000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<30.099000,0.000000,18.796000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.734000,0.000000,18.161000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.734000,0.000000,16.891000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<30.734000,0.000000,16.891000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.734000,0.000000,16.891000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.099000,0.000000,16.256000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<30.099000,0.000000,16.256000> }
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-90.000000,0> translate<29.464000,0.000000,14.986000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-90.000000,0> translate<29.464000,0.000000,17.526000>}
//JP3 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.752000,0.000000,17.907000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.752000,0.000000,16.637000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<47.752000,0.000000,16.637000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.752000,0.000000,16.637000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.117000,0.000000,16.002000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<47.117000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.117000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.847000,0.000000,16.002000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<45.847000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.847000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.212000,0.000000,16.637000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<45.212000,0.000000,16.637000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.117000,0.000000,18.542000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.847000,0.000000,18.542000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<45.847000,0.000000,18.542000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.752000,0.000000,17.907000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.117000,0.000000,18.542000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<47.117000,0.000000,18.542000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.847000,0.000000,18.542000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.212000,0.000000,17.907000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<45.212000,0.000000,17.907000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.212000,0.000000,16.637000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.212000,0.000000,17.907000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<45.212000,0.000000,17.907000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.117000,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.752000,0.000000,15.367000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<47.117000,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.752000,0.000000,15.367000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.752000,0.000000,14.097000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<47.752000,0.000000,14.097000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.752000,0.000000,14.097000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.117000,0.000000,13.462000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<47.117000,0.000000,13.462000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.117000,0.000000,13.462000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.847000,0.000000,13.462000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<45.847000,0.000000,13.462000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.847000,0.000000,13.462000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.212000,0.000000,14.097000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,44.997030,0> translate<45.212000,0.000000,14.097000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.212000,0.000000,14.097000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.212000,0.000000,15.367000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<45.212000,0.000000,15.367000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.212000,0.000000,15.367000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.847000,0.000000,16.002000>}
box{<0,0,-0.076200><0.898026,0.036000,0.076200> rotate<0,-44.997030,0> translate<45.212000,0.000000,15.367000> }
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-270.000000,0> translate<46.482000,0.000000,17.272000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-270.000000,0> translate<46.482000,0.000000,14.732000>}
//X1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.925000,0.000000,13.081000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.925000,0.000000,11.811000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<34.925000,0.000000,11.811000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.925000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.195000,0.000000,11.811000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.925000,0.000000,11.811000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.195000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.195000,0.000000,13.081000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<36.195000,0.000000,13.081000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.195000,0.000000,13.081000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.925000,0.000000,13.081000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.925000,0.000000,13.081000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.925000,0.000000,13.081000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.195000,0.000000,11.811000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<34.925000,0.000000,13.081000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.925000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.195000,0.000000,13.081000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<34.925000,0.000000,11.811000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.815000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.815000,0.000000,17.018000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,90.000000,0> translate<43.815000,0.000000,17.018000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.385000,0.000000,17.018000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.385000,0.000000,16.510000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,-90.000000,0> translate<32.385000,0.000000,16.510000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.020000,0.000000,9.906000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.020000,0.000000,15.240000>}
box{<0,0,-0.076200><5.334000,0.036000,0.076200> rotate<0,90.000000,0> translate<33.020000,0.000000,15.240000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.020000,0.000000,15.240000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.020000,0.000000,15.494000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<33.020000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.180000,0.000000,15.494000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.180000,0.000000,15.240000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<43.180000,0.000000,15.240000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.180000,0.000000,15.240000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.180000,0.000000,9.906000>}
box{<0,0,-0.076200><5.334000,0.036000,0.076200> rotate<0,-90.000000,0> translate<43.180000,0.000000,9.906000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.005000,0.000000,13.081000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.005000,0.000000,11.811000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<40.005000,0.000000,11.811000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.005000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,11.811000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<40.005000,0.000000,11.811000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,13.081000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.275000,0.000000,13.081000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,13.081000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.005000,0.000000,13.081000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<40.005000,0.000000,13.081000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.005000,0.000000,13.081000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,11.811000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,44.997030,0> translate<40.005000,0.000000,13.081000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.005000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,13.081000>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<40.005000,0.000000,11.811000> }
object{ARC(2.667000,0.152400,216.869898,270.000000,0.036000) translate<35.560000,0.000000,11.557000>}
object{ARC(2.667000,0.152400,270.000000,323.130102,0.036000) translate<35.560000,0.000000,11.557000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.719000,0.000000,9.906000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.481000,0.000000,9.906000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<37.719000,0.000000,9.906000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.020000,0.000000,9.906000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.451800,0.000000,9.906000>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<33.020000,0.000000,9.906000> }
object{ARC(2.667000,0.152400,216.869898,270.000000,0.036000) translate<40.640000,0.000000,11.557000>}
object{ARC(2.667000,0.152400,270.000000,323.130102,0.036000) translate<40.640000,0.000000,11.557000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.748200,0.000000,9.906000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.180000,0.000000,9.906000>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<42.748200,0.000000,9.906000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.020000,0.000000,15.240000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,15.240000>}
box{<0,0,-0.076200><2.032000,0.036000,0.076200> rotate<0,0.000000,0> translate<33.020000,0.000000,15.240000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,15.240000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,15.240000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<35.052000,0.000000,15.240000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,15.240000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.132000,0.000000,15.240000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.068000,0.000000,15.240000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.132000,0.000000,15.240000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.148000,0.000000,15.240000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<40.132000,0.000000,15.240000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.148000,0.000000,15.240000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.180000,0.000000,15.240000>}
box{<0,0,-0.076200><2.032000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.148000,0.000000,15.240000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.385000,0.000000,17.018000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,17.018000>}
box{<0,0,-0.076200><2.667000,0.036000,0.076200> rotate<0,0.000000,0> translate<32.385000,0.000000,17.018000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,17.018000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,17.018000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<35.052000,0.000000,17.018000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,17.018000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.132000,0.000000,17.018000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.068000,0.000000,17.018000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.132000,0.000000,17.018000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.148000,0.000000,17.018000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<40.132000,0.000000,17.018000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.148000,0.000000,17.018000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.815000,0.000000,17.018000>}
box{<0,0,-0.076200><2.667000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.148000,0.000000,17.018000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.132000,0.000000,15.240000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.132000,0.000000,17.018000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<40.132000,0.000000,17.018000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.148000,0.000000,15.240000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.148000,0.000000,17.018000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.148000,0.000000,17.018000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.385000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,16.510000>}
box{<0,0,-0.076200><2.413000,0.036000,0.076200> rotate<0,0.000000,0> translate<32.385000,0.000000,16.510000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.322000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.878000,0.000000,16.510000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.322000,0.000000,16.510000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.878000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.132000,0.000000,17.018000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<39.878000,0.000000,16.510000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.878000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.878000,0.000000,15.494000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<39.878000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.878000,0.000000,15.494000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.132000,0.000000,15.240000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<39.878000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.878000,0.000000,15.494000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.322000,0.000000,15.494000>}
box{<0,0,-0.076200><3.556000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.322000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,15.494000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.020000,0.000000,15.494000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<33.020000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.148000,0.000000,17.018000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,16.510000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<41.148000,0.000000,17.018000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.815000,0.000000,16.510000>}
box{<0,0,-0.076200><2.413000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.402000,0.000000,16.510000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,15.494000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<41.402000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,15.494000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.148000,0.000000,15.240000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<41.148000,0.000000,15.240000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,15.494000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.180000,0.000000,15.494000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.402000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,15.240000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,17.018000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<36.068000,0.000000,17.018000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,15.240000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,17.018000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<35.052000,0.000000,17.018000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,15.494000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<34.798000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.322000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.322000,0.000000,15.494000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,-90.000000,0> translate<36.322000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,17.018000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.322000,0.000000,16.510000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,63.430762,0> translate<36.068000,0.000000,17.018000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,17.018000>}
box{<0,0,-0.076200><0.567961,0.036000,0.076200> rotate<0,-63.430762,0> translate<34.798000,0.000000,16.510000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,15.494000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,15.240000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<34.798000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.322000,0.000000,15.494000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,15.240000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<36.068000,0.000000,15.240000> }
texture{col_slk}
}
#end
translate<mac_x_ver,mac_y_ver,mac_z_ver>
rotate<mac_x_rot,mac_y_rot,mac_z_rot>
}//End union
#end

#if(use_file_as_inc=off)
object{  GM3_NOISE_SUPPRESSOR(-38.100000,0,-24.638000,pcb_rotate_x,pcb_rotate_y,pcb_rotate_z)
#if(pcb_upsidedown=on)
rotate pcb_rotdir*180
#end
}
#end


//Parts not found in 3dpack.dat or 3dusrpac.dat are:
//H1	MOUNT-PAD-ROUND2.8	2,8-PAD
//H2	MOUNT-PAD-ROUND2.8	2,8-PAD
//H3	MOUNT-HOLE4.1	4,1
//H4	MOUNT-HOLE4.1	4,1
