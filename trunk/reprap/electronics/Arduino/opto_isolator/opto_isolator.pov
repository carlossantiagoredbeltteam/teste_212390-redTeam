//POVRay-File created by 3d41.ulp v1.05
///Users/zachsmith/Desktop/reprap/trunk/reprap/electronics/Arduino/opto_isolator/opto_isolator.brd
// 5/10/2008 16:51:55 

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
#local cam_y = 155;
#local cam_z = -61;
#local cam_a = 20;
#local cam_look_x = 0;
#local cam_look_y = -2;
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

#local lgt1_pos_x = 18;
#local lgt1_pos_y = 27;
#local lgt1_pos_z = 14;
#local lgt1_intense = 0.718554;
#local lgt2_pos_x = -18;
#local lgt2_pos_y = 27;
#local lgt2_pos_z = 14;
#local lgt2_intense = 0.718554;
#local lgt3_pos_x = 18;
#local lgt3_pos_y = 27;
#local lgt3_pos_z = -9;
#local lgt3_intense = 0.718554;
#local lgt4_pos_x = -18;
#local lgt4_pos_y = 27;
#local lgt4_pos_z = -9;
#local lgt4_intense = 0.718554;

//Do not change these values
#declare pcb_height = 1.500000;
#declare pcb_cuheight = 0.035000;
#declare pcb_x_size = 48.717400;
#declare pcb_y_size = 26.660000;
#declare pcb_layer1_used = 1;
#declare pcb_layer16_used = 1;
#declare inc_testmode = off;
#declare global_seed=seed(753);
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
	//translate<-24.358700,0,-13.330000>
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


#macro OPTO_ISOLATOR(mac_x_ver,mac_y_ver,mac_z_ver,mac_x_rot,mac_y_rot,mac_z_rot)
union{
#if(pcb_board = on)
difference{
union{
//Board
prism{-1.500000,0.000000,8
<1.790600,-0.630000><50.508000,-0.630000>
<50.508000,-0.630000><50.508000,26.030000>
<50.508000,26.030000><1.790600,26.030000>
<1.790600,26.030000><1.790600,-0.630000>
texture{col_brd}}
}//End union(Platine)
//Holes(real)/Parts
//Holes(real)/Board
//Holes(real)/Vias
}//End difference(reale Bohrungen/Durchbrüche)
#end
#if(pcb_parts=on)//Parts
union{
#ifndef(pack_C1) #declare global_pack_C1=yes; object {CAP_DIS_CERAMIC_50MM_76MM("100nF",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<36.830000,-0.000000,3.810000>}#end		//ceramic disc capacitator C1 100nF C050-035X075
#ifndef(pack_C2) #declare global_pack_C2=yes; object {CAP_DIS_CERAMIC_50MM_76MM("100nF",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-0.000000,0> rotate<0,0,0> translate<36.830000,-0.000000,21.590000>}#end		//ceramic disc capacitator C2 100nF C050-035X075
#ifndef(pack_C3) #declare global_pack_C3=yes; object {CAP_DIS_CERAMIC_50MM_76MM("100nF",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<15.240000,-0.000000,3.810000>}#end		//ceramic disc capacitator C3 100nF C050-035X075
#ifndef(pack_C4) #declare global_pack_C4=yes; object {CAP_DIS_CERAMIC_50MM_76MM("100nF",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<15.240000,-0.000000,21.590000>}#end		//ceramic disc capacitator C4 100nF C050-035X075
#ifndef(pack_OK1) #declare global_pack_OK1=yes; object {IC_DIS_DIP8("HCPL2630","",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-270.000000,0> rotate<0,0,0> translate<25.400000,-0.000000,7.620000>translate<0,3.000000,0> }#end		//DIP8 OK1 HCPL2630 DIL08
#ifndef(pack_OK1) object{SOCKET_DIP8()rotate<0,-270.000000,0> rotate<0,0,0> translate<25.400000,-0.000000,7.620000>}#end					//IC-Sockel 8Pin OK1 HCPL2630
#ifndef(pack_OK2) #declare global_pack_OK2=yes; object {IC_DIS_DIP8("HCPL2630","",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-270.000000,0> rotate<0,0,0> translate<25.400000,-0.000000,17.780000>translate<0,3.000000,0> }#end		//DIP8 OK2 HCPL2630 DIL08
#ifndef(pack_OK2) object{SOCKET_DIP8()rotate<0,-270.000000,0> rotate<0,0,0> translate<25.400000,-0.000000,17.780000>}#end					//IC-Sockel 8Pin OK2 HCPL2630
#ifndef(pack_R1) #declare global_pack_R1=yes; object {RES_DIS_0207_025MMV(texture{pigment{Red*0.7}finish{phong 0.2}},texture{pigment{Red*0.7}finish{phong 0.2}},texture{pigment{DarkBrown}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-0.000000,0> rotate<0,0,0> translate<15.240000,-0.000000,11.430000>}#end		//Discrete Resistor 0,25W Vertical 100mil R1 220 0207/2V
#ifndef(pack_R2) #declare global_pack_R2=yes; object {RES_DIS_0207_025MMV(texture{pigment{Red*0.7}finish{phong 0.2}},texture{pigment{Red*0.7}finish{phong 0.2}},texture{pigment{DarkBrown}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-0.000000,0> rotate<0,0,0> translate<15.240000,-0.000000,8.890000>}#end		//Discrete Resistor 0,25W Vertical 100mil R2 220 0207/2V
#ifndef(pack_R3) #declare global_pack_R3=yes; object {RES_DIS_0207_025MMV(texture{pigment{Orange}finish{phong 0.2}},texture{pigment{Orange}finish{phong 0.2}},texture{pigment{Red*0.7}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-0.000000,0> rotate<0,0,0> translate<35.560000,-0.000000,11.430000>}#end		//Discrete Resistor 0,25W Vertical 100mil R3 3.3K 0207/2V
#ifndef(pack_R4) #declare global_pack_R4=yes; object {RES_DIS_0207_025MMV(texture{pigment{Orange}finish{phong 0.2}},texture{pigment{Orange}finish{phong 0.2}},texture{pigment{Red*0.7}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-0.000000,0> rotate<0,0,0> translate<35.560000,-0.000000,8.890000>}#end		//Discrete Resistor 0,25W Vertical 100mil R4 3.3K 0207/2V
#ifndef(pack_R5) #declare global_pack_R5=yes; object {RES_DIS_0207_025MMV(texture{pigment{Red*0.7}finish{phong 0.2}},texture{pigment{Red*0.7}finish{phong 0.2}},texture{pigment{DarkBrown}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-0.000000,0> rotate<0,0,0> translate<15.240000,-0.000000,16.510000>}#end		//Discrete Resistor 0,25W Vertical 100mil R5 220 0207/2V
#ifndef(pack_R6) #declare global_pack_R6=yes; object {RES_DIS_0207_025MMV(texture{pigment{Red*0.7}finish{phong 0.2}},texture{pigment{Red*0.7}finish{phong 0.2}},texture{pigment{DarkBrown}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-0.000000,0> rotate<0,0,0> translate<15.240000,-0.000000,13.970000>}#end		//Discrete Resistor 0,25W Vertical 100mil R6 220 0207/2V
#ifndef(pack_R7) #declare global_pack_R7=yes; object {RES_DIS_0207_025MMV(texture{pigment{Orange}finish{phong 0.2}},texture{pigment{Orange}finish{phong 0.2}},texture{pigment{Red*0.7}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-0.000000,0> rotate<0,0,0> translate<35.560000,-0.000000,16.510000>}#end		//Discrete Resistor 0,25W Vertical 100mil R7 3.3K 0207/2V
#ifndef(pack_R8) #declare global_pack_R8=yes; object {RES_DIS_0207_025MMV(texture{pigment{Orange}finish{phong 0.2}},texture{pigment{Orange}finish{phong 0.2}},texture{pigment{Red*0.7}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-0.000000,0> rotate<0,0,0> translate<35.560000,-0.000000,13.970000>}#end		//Discrete Resistor 0,25W Vertical 100mil R8 3.3K 0207/2V
#ifndef(pack_SV1) #declare global_pack_SV1=yes; object {CON_DIS_WS6G()translate<0,0,0> rotate<0,180.000000,0>rotate<0,-270.000000,0> rotate<0,0,0> translate<45.720000,-0.000000,12.446000>}#end		//Shrouded Header 6Pin SV1  ML6
#ifndef(pack_SV2) #declare global_pack_SV2=yes; object {CON_DIS_WS6G()translate<0,0,0> rotate<0,180.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<6.604000,-0.000000,12.446000>}#end		//Shrouded Header 6Pin SV2  ML6
}//End union
#end
#if(pcb_pads_smds=on)
//Pads&SMD/Parts
#ifndef(global_pack_C1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<39.370000,0,3.810000> texture{col_thl}}
#ifndef(global_pack_C1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<34.290000,0,3.810000> texture{col_thl}}
#ifndef(global_pack_C2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<34.290000,0,21.590000> texture{col_thl}}
#ifndef(global_pack_C2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<39.370000,0,21.590000> texture{col_thl}}
#ifndef(global_pack_C3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<17.780000,0,3.810000> texture{col_thl}}
#ifndef(global_pack_C3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<12.700000,0,3.810000> texture{col_thl}}
#ifndef(global_pack_C4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<17.780000,0,21.590000> texture{col_thl}}
#ifndef(global_pack_C4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<12.700000,0,21.590000> texture{col_thl}}
#ifndef(global_pack_OK1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<21.590000,0,11.430000> texture{col_thl}}
#ifndef(global_pack_OK1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<21.590000,0,8.890000> texture{col_thl}}
#ifndef(global_pack_OK1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<21.590000,0,6.350000> texture{col_thl}}
#ifndef(global_pack_OK1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<21.590000,0,3.810000> texture{col_thl}}
#ifndef(global_pack_OK1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<29.210000,0,3.810000> texture{col_thl}}
#ifndef(global_pack_OK1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<29.210000,0,6.350000> texture{col_thl}}
#ifndef(global_pack_OK1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<29.210000,0,8.890000> texture{col_thl}}
#ifndef(global_pack_OK1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<29.210000,0,11.430000> texture{col_thl}}
#ifndef(global_pack_OK2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<21.590000,0,21.590000> texture{col_thl}}
#ifndef(global_pack_OK2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<21.590000,0,19.050000> texture{col_thl}}
#ifndef(global_pack_OK2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<21.590000,0,16.510000> texture{col_thl}}
#ifndef(global_pack_OK2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<21.590000,0,13.970000> texture{col_thl}}
#ifndef(global_pack_OK2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<29.210000,0,13.970000> texture{col_thl}}
#ifndef(global_pack_OK2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<29.210000,0,16.510000> texture{col_thl}}
#ifndef(global_pack_OK2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<29.210000,0,19.050000> texture{col_thl}}
#ifndef(global_pack_OK2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<29.210000,0,21.590000> texture{col_thl}}
#ifndef(global_pack_R1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<13.970000,0,11.430000> texture{col_thl}}
#ifndef(global_pack_R1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<16.510000,0,11.430000> texture{col_thl}}
#ifndef(global_pack_R2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<13.970000,0,8.890000> texture{col_thl}}
#ifndef(global_pack_R2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<16.510000,0,8.890000> texture{col_thl}}
#ifndef(global_pack_R3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<34.290000,0,11.430000> texture{col_thl}}
#ifndef(global_pack_R3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<36.830000,0,11.430000> texture{col_thl}}
#ifndef(global_pack_R4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<34.290000,0,8.890000> texture{col_thl}}
#ifndef(global_pack_R4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<36.830000,0,8.890000> texture{col_thl}}
#ifndef(global_pack_R5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<13.970000,0,16.510000> texture{col_thl}}
#ifndef(global_pack_R5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<16.510000,0,16.510000> texture{col_thl}}
#ifndef(global_pack_R6) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<13.970000,0,13.970000> texture{col_thl}}
#ifndef(global_pack_R6) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<16.510000,0,13.970000> texture{col_thl}}
#ifndef(global_pack_R7) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<34.290000,0,16.510000> texture{col_thl}}
#ifndef(global_pack_R7) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<36.830000,0,16.510000> texture{col_thl}}
#ifndef(global_pack_R8) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<34.290000,0,13.970000> texture{col_thl}}
#ifndef(global_pack_R8) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<36.830000,0,13.970000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<44.450000,0,14.986000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<46.990000,0,14.986000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<44.450000,0,12.446000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<46.990000,0,12.446000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<44.450000,0,9.906000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<46.990000,0,9.906000> texture{col_thl}}
#ifndef(global_pack_SV2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<7.874000,0,9.906000> texture{col_thl}}
#ifndef(global_pack_SV2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<5.334000,0,9.906000> texture{col_thl}}
#ifndef(global_pack_SV2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<7.874000,0,12.446000> texture{col_thl}}
#ifndef(global_pack_SV2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<5.334000,0,12.446000> texture{col_thl}}
#ifndef(global_pack_SV2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<7.874000,0,14.986000> texture{col_thl}}
#ifndef(global_pack_SV2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<5.334000,0,14.986000> texture{col_thl}}
//Pads/Vias
#end
#if(pcb_wires=on)
union{
//Signals
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<3.810000,-1.535000,12.700000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<3.810000,-1.535000,16.510000>}
box{<0,0,-0.127000><3.810000,0.035000,0.127000> rotate<0,90.000000,0> translate<3.810000,-1.535000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<3.810000,-1.535000,12.700000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<5.080000,-1.535000,12.700000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,0.000000,0> translate<3.810000,-1.535000,12.700000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<5.080000,-1.535000,10.160000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<5.334000,-1.535000,9.906000>}
box{<0,0,-0.127000><0.359210,0.035000,0.127000> rotate<0,44.997030,0> translate<5.080000,-1.535000,10.160000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<5.080000,-1.535000,12.700000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<5.334000,-1.535000,12.446000>}
box{<0,0,-0.127000><0.359210,0.035000,0.127000> rotate<0,44.997030,0> translate<5.080000,-1.535000,12.700000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<5.080000,-0.000000,15.240000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<5.334000,-0.000000,14.986000>}
box{<0,0,-0.127000><0.359210,0.035000,0.127000> rotate<0,44.997030,0> translate<5.080000,-0.000000,15.240000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<5.080000,-0.000000,15.240000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<6.350000,-0.000000,16.510000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,-44.997030,0> translate<5.080000,-0.000000,15.240000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<5.334000,-1.535000,9.906000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.620000,-1.535000,7.620000>}
box{<0,0,-0.127000><3.232892,0.035000,0.127000> rotate<0,44.997030,0> translate<5.334000,-1.535000,9.906000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.620000,-0.000000,10.160000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.874000,-0.000000,9.906000>}
box{<0,0,-0.127000><0.359210,0.035000,0.127000> rotate<0,44.997030,0> translate<7.620000,-0.000000,10.160000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.620000,-1.535000,12.700000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.874000,-1.535000,12.446000>}
box{<0,0,-0.127000><0.359210,0.035000,0.127000> rotate<0,44.997030,0> translate<7.620000,-1.535000,12.700000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.620000,-1.535000,15.240000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.874000,-1.535000,14.986000>}
box{<0,0,-0.127000><0.359210,0.035000,0.127000> rotate<0,44.997030,0> translate<7.620000,-1.535000,15.240000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.620000,-1.535000,7.620000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<10.160000,-1.535000,7.620000>}
box{<0,0,-0.127000><2.540000,0.035000,0.127000> rotate<0,0.000000,0> translate<7.620000,-1.535000,7.620000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.874000,-0.000000,9.906000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<11.430000,-0.000000,6.350000>}
box{<0,0,-0.127000><5.028943,0.035000,0.127000> rotate<0,44.997030,0> translate<7.874000,-0.000000,9.906000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<11.430000,-0.000000,2.540000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<11.430000,-0.000000,6.350000>}
box{<0,0,-0.127000><3.810000,0.035000,0.127000> rotate<0,90.000000,0> translate<11.430000,-0.000000,6.350000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.620000,-1.535000,15.240000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<12.700000,-1.535000,15.240000>}
box{<0,0,-0.127000><5.080000,0.035000,0.127000> rotate<0,0.000000,0> translate<7.620000,-1.535000,15.240000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<6.350000,-0.000000,16.510000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<12.700000,-0.000000,16.510000>}
box{<0,0,-0.127000><6.350000,0.035000,0.127000> rotate<0,0.000000,0> translate<6.350000,-0.000000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<12.700000,-0.000000,3.810000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<12.700000,-0.000000,16.510000>}
box{<0,0,-0.127000><12.700000,0.035000,0.127000> rotate<0,90.000000,0> translate<12.700000,-0.000000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<12.700000,-0.000000,16.510000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<12.700000,-0.000000,21.590000>}
box{<0,0,-0.127000><5.080000,0.035000,0.127000> rotate<0,90.000000,0> translate<12.700000,-0.000000,21.590000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<10.160000,-1.535000,7.620000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<13.970000,-1.535000,11.430000>}
box{<0,0,-0.127000><5.388154,0.035000,0.127000> rotate<0,-44.997030,0> translate<10.160000,-1.535000,7.620000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<12.700000,-1.535000,15.240000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<13.970000,-1.535000,13.970000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,44.997030,0> translate<12.700000,-1.535000,15.240000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<3.810000,-1.535000,16.510000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<13.970000,-1.535000,16.510000>}
box{<0,0,-0.127000><10.160000,0.035000,0.127000> rotate<0,0.000000,0> translate<3.810000,-1.535000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<13.970000,-1.535000,8.890000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.240000,-1.535000,10.160000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,-44.997030,0> translate<13.970000,-1.535000,8.890000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.240000,-1.535000,12.700000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.240000,-1.535000,10.160000>}
box{<0,0,-0.127000><2.540000,0.035000,0.127000> rotate<0,-90.000000,0> translate<15.240000,-1.535000,10.160000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<7.620000,-1.535000,12.700000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<15.240000,-1.535000,12.700000>}
box{<0,0,-0.127000><7.620000,0.035000,0.127000> rotate<0,0.000000,0> translate<7.620000,-1.535000,12.700000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<11.430000,-0.000000,2.540000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.780000,-0.000000,2.540000>}
box{<0,0,-0.127000><6.350000,0.035000,0.127000> rotate<0,0.000000,0> translate<11.430000,-0.000000,2.540000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.780000,-0.000000,2.540000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.780000,-0.000000,3.810000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,90.000000,0> translate<17.780000,-0.000000,3.810000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.780000,-0.000000,3.810000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.050000,-0.000000,3.810000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,0.000000,0> translate<17.780000,-0.000000,3.810000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<16.510000,-1.535000,8.890000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.050000,-1.535000,6.350000>}
box{<0,0,-0.127000><3.592102,0.035000,0.127000> rotate<0,44.997030,0> translate<16.510000,-1.535000,8.890000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<16.510000,-1.535000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.050000,-1.535000,8.890000>}
box{<0,0,-0.127000><3.592102,0.035000,0.127000> rotate<0,44.997030,0> translate<16.510000,-1.535000,11.430000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.050000,-0.000000,3.810000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.050000,-0.000000,10.160000>}
box{<0,0,-0.127000><6.350000,0.035000,0.127000> rotate<0,90.000000,0> translate<19.050000,-0.000000,10.160000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<16.510000,-1.535000,13.970000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.050000,-1.535000,16.510000>}
box{<0,0,-0.127000><3.592102,0.035000,0.127000> rotate<0,-44.997030,0> translate<16.510000,-1.535000,13.970000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<16.510000,-1.535000,16.510000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.050000,-1.535000,19.050000>}
box{<0,0,-0.127000><3.592102,0.035000,0.127000> rotate<0,-44.997030,0> translate<16.510000,-1.535000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<17.780000,-0.000000,21.590000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.050000,-0.000000,21.590000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,0.000000,0> translate<17.780000,-0.000000,21.590000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.050000,-0.000000,10.160000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.050000,-0.000000,21.590000>}
box{<0,0,-0.127000><11.430000,0.035000,0.127000> rotate<0,90.000000,0> translate<19.050000,-0.000000,21.590000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.050000,-0.000000,10.160000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.320000,-0.000000,11.430000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,-44.997030,0> translate<19.050000,-0.000000,10.160000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.050000,-0.000000,3.810000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.590000,-0.000000,3.810000>}
box{<0,0,-0.127000><2.540000,0.035000,0.127000> rotate<0,0.000000,0> translate<19.050000,-0.000000,3.810000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.050000,-1.535000,6.350000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.590000,-1.535000,6.350000>}
box{<0,0,-0.127000><2.540000,0.035000,0.127000> rotate<0,0.000000,0> translate<19.050000,-1.535000,6.350000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.050000,-1.535000,8.890000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.590000,-1.535000,8.890000>}
box{<0,0,-0.127000><2.540000,0.035000,0.127000> rotate<0,0.000000,0> translate<19.050000,-1.535000,8.890000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<20.320000,-0.000000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.590000,-0.000000,11.430000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,0.000000,0> translate<20.320000,-0.000000,11.430000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.590000,-0.000000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.590000,-0.000000,13.970000>}
box{<0,0,-0.127000><2.540000,0.035000,0.127000> rotate<0,90.000000,0> translate<21.590000,-0.000000,13.970000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.050000,-1.535000,16.510000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.590000,-1.535000,16.510000>}
box{<0,0,-0.127000><2.540000,0.035000,0.127000> rotate<0,0.000000,0> translate<19.050000,-1.535000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.050000,-1.535000,19.050000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.590000,-1.535000,19.050000>}
box{<0,0,-0.127000><2.540000,0.035000,0.127000> rotate<0,0.000000,0> translate<19.050000,-1.535000,19.050000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<19.050000,-0.000000,21.590000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<21.590000,-0.000000,21.590000>}
box{<0,0,-0.127000><2.540000,0.035000,0.127000> rotate<0,0.000000,0> translate<19.050000,-0.000000,21.590000> }
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<25.400000,-0.000000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<25.400000,-0.000000,22.352000>}
box{<0,0,-0.152400><5.588000,0.035000,0.152400> rotate<0,90.000000,0> translate<25.400000,-0.000000,22.352000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.670000,-0.000000,5.080000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.670000,-0.000000,12.700000>}
box{<0,0,-0.127000><7.620000,0.035000,0.127000> rotate<0,90.000000,0> translate<26.670000,-0.000000,12.700000> }
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<25.400000,-0.000000,22.352000>}
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<26.670000,-0.000000,23.622000>}
box{<0,0,-0.152400><1.796051,0.035000,0.152400> rotate<0,-44.997030,0> translate<25.400000,-0.000000,22.352000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.670000,-0.000000,5.080000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.940000,-0.000000,3.810000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,44.997030,0> translate<26.670000,-0.000000,5.080000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<26.670000,-0.000000,12.700000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.940000,-0.000000,13.970000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,-44.997030,0> translate<26.670000,-0.000000,12.700000> }
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<25.400000,-0.000000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<28.194000,-0.000000,13.970000>}
box{<0,0,-0.152400><3.951313,0.035000,0.152400> rotate<0,44.997030,0> translate<25.400000,-0.000000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.940000,-0.000000,13.970000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<28.194000,-0.000000,13.970000>}
box{<0,0,-0.127000><0.254000,0.035000,0.127000> rotate<0,0.000000,0> translate<27.940000,-0.000000,13.970000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<27.940000,-0.000000,3.810000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<29.210000,-0.000000,3.810000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,0.000000,0> translate<27.940000,-0.000000,3.810000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<28.194000,-0.000000,13.970000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<29.210000,-0.000000,13.970000>}
box{<0,0,-0.127000><1.016000,0.035000,0.127000> rotate<0,0.000000,0> translate<28.194000,-0.000000,13.970000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<29.210000,-0.000000,3.810000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,-0.000000,2.540000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,44.997030,0> translate<29.210000,-0.000000,3.810000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<29.210000,-1.535000,6.350000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,-1.535000,6.350000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,0.000000,0> translate<29.210000,-1.535000,6.350000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<29.210000,-1.535000,8.890000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,-1.535000,8.890000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,0.000000,0> translate<29.210000,-1.535000,8.890000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<29.210000,-0.000000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,-0.000000,11.430000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,0.000000,0> translate<29.210000,-0.000000,11.430000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<29.210000,-1.535000,16.510000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,-1.535000,16.510000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,0.000000,0> translate<29.210000,-1.535000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<29.210000,-1.535000,19.050000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,-1.535000,19.050000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,0.000000,0> translate<29.210000,-1.535000,19.050000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<29.210000,-0.000000,21.590000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,-0.000000,21.590000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,0.000000,0> translate<29.210000,-0.000000,21.590000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,-1.535000,6.350000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.750000,-1.535000,7.620000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,-44.997030,0> translate<30.480000,-1.535000,6.350000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,-0.000000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.750000,-0.000000,12.700000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,-44.997030,0> translate<30.480000,-0.000000,11.430000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.750000,-0.000000,12.700000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.750000,-0.000000,19.050000>}
box{<0,0,-0.127000><6.350000,0.035000,0.127000> rotate<0,90.000000,0> translate<31.750000,-0.000000,19.050000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,-0.000000,21.590000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.750000,-0.000000,20.320000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,44.997030,0> translate<30.480000,-0.000000,21.590000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.750000,-0.000000,19.050000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.750000,-0.000000,20.320000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,90.000000,0> translate<31.750000,-0.000000,20.320000> }
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<32.004000,-0.000000,9.906000>}
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<32.004000,-0.000000,7.874000>}
box{<0,0,-0.152400><2.032000,0.035000,0.152400> rotate<0,-90.000000,0> translate<32.004000,-0.000000,7.874000> }
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<30.480000,-0.000000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<32.004000,-0.000000,9.906000>}
box{<0,0,-0.152400><2.155261,0.035000,0.152400> rotate<0,44.997030,0> translate<30.480000,-0.000000,11.430000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.750000,-1.535000,7.620000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.020000,-1.535000,8.890000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,-44.997030,0> translate<31.750000,-1.535000,7.620000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,-1.535000,8.890000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.020000,-1.535000,11.430000>}
box{<0,0,-0.127000><3.592102,0.035000,0.127000> rotate<0,-44.997030,0> translate<30.480000,-1.535000,8.890000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,-0.000000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.020000,-0.000000,11.430000>}
box{<0,0,-0.127000><2.540000,0.035000,0.127000> rotate<0,0.000000,0> translate<30.480000,-0.000000,11.430000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.020000,-0.000000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.020000,-0.000000,12.700000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,90.000000,0> translate<33.020000,-0.000000,12.700000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,-1.535000,16.510000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.020000,-1.535000,13.970000>}
box{<0,0,-0.127000><3.592102,0.035000,0.127000> rotate<0,44.997030,0> translate<30.480000,-1.535000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,-1.535000,19.050000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.020000,-1.535000,16.510000>}
box{<0,0,-0.127000><3.592102,0.035000,0.127000> rotate<0,44.997030,0> translate<30.480000,-1.535000,19.050000> }
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<32.004000,-0.000000,7.874000>}
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<33.782000,-0.000000,6.096000>}
box{<0,0,-0.152400><2.514472,0.035000,0.152400> rotate<0,44.997030,0> translate<32.004000,-0.000000,7.874000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<29.210000,-0.000000,3.810000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.290000,-0.000000,3.810000>}
box{<0,0,-0.127000><5.080000,0.035000,0.127000> rotate<0,0.000000,0> translate<29.210000,-0.000000,3.810000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.020000,-1.535000,8.890000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.290000,-1.535000,8.890000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,0.000000,0> translate<33.020000,-1.535000,8.890000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.020000,-1.535000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.290000,-1.535000,11.430000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,0.000000,0> translate<33.020000,-1.535000,11.430000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.020000,-1.535000,13.970000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.290000,-1.535000,13.970000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,0.000000,0> translate<33.020000,-1.535000,13.970000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.020000,-1.535000,16.510000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.290000,-1.535000,16.510000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,0.000000,0> translate<33.020000,-1.535000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.750000,-0.000000,19.050000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.290000,-0.000000,21.590000>}
box{<0,0,-0.127000><3.592102,0.035000,0.127000> rotate<0,-44.997030,0> translate<31.750000,-0.000000,19.050000> }
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<33.782000,-0.000000,6.096000>}
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<35.560000,-0.000000,6.096000>}
box{<0,0,-0.152400><1.778000,0.035000,0.152400> rotate<0,0.000000,0> translate<33.782000,-0.000000,6.096000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.290000,-1.535000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.560000,-1.535000,11.430000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,0.000000,0> translate<34.290000,-1.535000,11.430000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<34.290000,-0.000000,13.970000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.560000,-0.000000,15.240000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,-44.997030,0> translate<34.290000,-0.000000,13.970000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.560000,-1.535000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.560000,-1.535000,17.780000>}
box{<0,0,-0.127000><6.350000,0.035000,0.127000> rotate<0,90.000000,0> translate<35.560000,-1.535000,17.780000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.560000,-0.000000,15.240000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.560000,-0.000000,17.780000>}
box{<0,0,-0.127000><2.540000,0.035000,0.127000> rotate<0,90.000000,0> translate<35.560000,-0.000000,17.780000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.830000,-0.000000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.830000,-0.000000,8.890000>}
box{<0,0,-0.127000><2.540000,0.035000,0.127000> rotate<0,-90.000000,0> translate<36.830000,-0.000000,8.890000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.830000,-0.000000,12.700000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.830000,-0.000000,11.430000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,-90.000000,0> translate<36.830000,-0.000000,11.430000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<33.020000,-0.000000,12.700000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.830000,-0.000000,12.700000>}
box{<0,0,-0.127000><3.810000,0.035000,0.127000> rotate<0,0.000000,0> translate<33.020000,-0.000000,12.700000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.830000,-0.000000,12.700000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.830000,-0.000000,13.970000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,90.000000,0> translate<36.830000,-0.000000,13.970000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.830000,-0.000000,13.970000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.830000,-0.000000,16.510000>}
box{<0,0,-0.127000><2.540000,0.035000,0.127000> rotate<0,90.000000,0> translate<36.830000,-0.000000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<35.560000,-0.000000,6.096000>}
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<37.846000,-0.000000,3.810000>}
box{<0,0,-0.152400><3.232892,0.035000,0.152400> rotate<0,44.997030,0> translate<35.560000,-0.000000,6.096000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.100000,-0.000000,17.780000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.100000,-0.000000,16.510000>}
box{<0,0,-0.127000><1.270000,0.035000,0.127000> rotate<0,-90.000000,0> translate<38.100000,-0.000000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.560000,-0.000000,17.780000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.100000,-0.000000,17.780000>}
box{<0,0,-0.127000><2.540000,0.035000,0.127000> rotate<0,0.000000,0> translate<35.560000,-0.000000,17.780000> }
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<26.670000,-0.000000,23.622000>}
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<38.608000,-0.000000,23.622000>}
box{<0,0,-0.152400><11.938000,0.035000,0.152400> rotate<0,0.000000,0> translate<26.670000,-0.000000,23.622000> }
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<37.846000,-0.000000,3.810000>}
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<39.370000,-0.000000,3.810000>}
box{<0,0,-0.152400><1.524000,0.035000,0.152400> rotate<0,0.000000,0> translate<37.846000,-0.000000,3.810000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<31.750000,-1.535000,7.620000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<39.370000,-1.535000,7.620000>}
box{<0,0,-0.127000><7.620000,0.035000,0.127000> rotate<0,0.000000,0> translate<31.750000,-1.535000,7.620000> }
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<39.370000,-0.000000,22.860000>}
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<39.370000,-0.000000,21.590000>}
box{<0,0,-0.152400><1.270000,0.035000,0.152400> rotate<0,-90.000000,0> translate<39.370000,-0.000000,21.590000> }
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<38.608000,-0.000000,23.622000>}
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<39.370000,-0.000000,22.860000>}
box{<0,0,-0.152400><1.077631,0.035000,0.152400> rotate<0,44.997030,0> translate<38.608000,-0.000000,23.622000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<36.830000,-1.535000,16.510000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.180000,-1.535000,16.510000>}
box{<0,0,-0.127000><6.350000,0.035000,0.127000> rotate<0,0.000000,0> translate<36.830000,-1.535000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.450000,-0.000000,10.160000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.450000,-0.000000,9.906000>}
box{<0,0,-0.127000><0.254000,0.035000,0.127000> rotate<0,-90.000000,0> translate<44.450000,-0.000000,9.906000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<38.100000,-0.000000,16.510000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.450000,-0.000000,10.160000>}
box{<0,0,-0.127000><8.980256,0.035000,0.127000> rotate<0,44.997030,0> translate<38.100000,-0.000000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.450000,-1.535000,12.700000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.450000,-1.535000,12.446000>}
box{<0,0,-0.127000><0.254000,0.035000,0.127000> rotate<0,-90.000000,0> translate<44.450000,-1.535000,12.446000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<39.370000,-1.535000,7.620000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.450000,-1.535000,12.700000>}
box{<0,0,-0.127000><7.184205,0.035000,0.127000> rotate<0,-44.997030,0> translate<39.370000,-1.535000,7.620000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.450000,-1.535000,15.240000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.450000,-1.535000,14.986000>}
box{<0,0,-0.127000><0.254000,0.035000,0.127000> rotate<0,-90.000000,0> translate<44.450000,-1.535000,14.986000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<43.180000,-1.535000,16.510000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.450000,-1.535000,15.240000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,44.997030,0> translate<43.180000,-1.535000,16.510000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<35.560000,-1.535000,17.780000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.450000,-1.535000,17.780000>}
box{<0,0,-0.127000><8.890000,0.035000,0.127000> rotate<0,0.000000,0> translate<35.560000,-1.535000,17.780000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,-0.000000,2.540000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.720000,-0.000000,2.540000>}
box{<0,0,-0.127000><15.240000,0.035000,0.127000> rotate<0,0.000000,0> translate<30.480000,-0.000000,2.540000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.720000,-0.000000,2.540000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<45.720000,-0.000000,8.890000>}
box{<0,0,-0.127000><6.350000,0.035000,0.127000> rotate<0,90.000000,0> translate<45.720000,-0.000000,8.890000> }
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<45.720000,-0.000000,8.890000>}
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<45.974000,-0.000000,8.890000>}
box{<0,0,-0.152400><0.254000,0.035000,0.152400> rotate<0,0.000000,0> translate<45.720000,-0.000000,8.890000> }
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<45.974000,-0.000000,8.890000>}
cylinder{<0,0,0><0,0.035000,0>0.152400 translate<46.990000,-0.000000,9.906000>}
box{<0,0,-0.152400><1.436841,0.035000,0.152400> rotate<0,-44.997030,0> translate<45.974000,-0.000000,8.890000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<46.990000,-1.535000,12.700000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<46.990000,-1.535000,12.446000>}
box{<0,0,-0.127000><0.254000,0.035000,0.127000> rotate<0,-90.000000,0> translate<46.990000,-1.535000,12.446000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<46.990000,-1.535000,15.240000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<46.990000,-1.535000,14.986000>}
box{<0,0,-0.127000><0.254000,0.035000,0.127000> rotate<0,-90.000000,0> translate<46.990000,-1.535000,14.986000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<44.450000,-1.535000,17.780000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<46.990000,-1.535000,15.240000>}
box{<0,0,-0.127000><3.592102,0.035000,0.127000> rotate<0,44.997030,0> translate<44.450000,-1.535000,17.780000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<46.990000,-1.535000,12.700000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.260000,-1.535000,13.970000>}
box{<0,0,-0.127000><1.796051,0.035000,0.127000> rotate<0,-44.997030,0> translate<46.990000,-1.535000,12.700000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.260000,-1.535000,19.050000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.260000,-1.535000,13.970000>}
box{<0,0,-0.127000><5.080000,0.035000,0.127000> rotate<0,-90.000000,0> translate<48.260000,-1.535000,13.970000> }
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<30.480000,-1.535000,19.050000>}
cylinder{<0,0,0><0,0.035000,0>0.127000 translate<48.260000,-1.535000,19.050000>}
box{<0,0,-0.127000><17.780000,0.035000,0.127000> rotate<0,0.000000,0> translate<30.480000,-1.535000,19.050000> }
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
cylinder{<39.370000,0.038000,3.810000><39.370000,-1.538000,3.810000>0.406400}
cylinder{<34.290000,0.038000,3.810000><34.290000,-1.538000,3.810000>0.406400}
cylinder{<34.290000,0.038000,21.590000><34.290000,-1.538000,21.590000>0.406400}
cylinder{<39.370000,0.038000,21.590000><39.370000,-1.538000,21.590000>0.406400}
cylinder{<17.780000,0.038000,3.810000><17.780000,-1.538000,3.810000>0.406400}
cylinder{<12.700000,0.038000,3.810000><12.700000,-1.538000,3.810000>0.406400}
cylinder{<17.780000,0.038000,21.590000><17.780000,-1.538000,21.590000>0.406400}
cylinder{<12.700000,0.038000,21.590000><12.700000,-1.538000,21.590000>0.406400}
cylinder{<21.590000,0.038000,11.430000><21.590000,-1.538000,11.430000>0.406400}
cylinder{<21.590000,0.038000,8.890000><21.590000,-1.538000,8.890000>0.406400}
cylinder{<21.590000,0.038000,6.350000><21.590000,-1.538000,6.350000>0.406400}
cylinder{<21.590000,0.038000,3.810000><21.590000,-1.538000,3.810000>0.406400}
cylinder{<29.210000,0.038000,3.810000><29.210000,-1.538000,3.810000>0.406400}
cylinder{<29.210000,0.038000,6.350000><29.210000,-1.538000,6.350000>0.406400}
cylinder{<29.210000,0.038000,8.890000><29.210000,-1.538000,8.890000>0.406400}
cylinder{<29.210000,0.038000,11.430000><29.210000,-1.538000,11.430000>0.406400}
cylinder{<21.590000,0.038000,21.590000><21.590000,-1.538000,21.590000>0.406400}
cylinder{<21.590000,0.038000,19.050000><21.590000,-1.538000,19.050000>0.406400}
cylinder{<21.590000,0.038000,16.510000><21.590000,-1.538000,16.510000>0.406400}
cylinder{<21.590000,0.038000,13.970000><21.590000,-1.538000,13.970000>0.406400}
cylinder{<29.210000,0.038000,13.970000><29.210000,-1.538000,13.970000>0.406400}
cylinder{<29.210000,0.038000,16.510000><29.210000,-1.538000,16.510000>0.406400}
cylinder{<29.210000,0.038000,19.050000><29.210000,-1.538000,19.050000>0.406400}
cylinder{<29.210000,0.038000,21.590000><29.210000,-1.538000,21.590000>0.406400}
cylinder{<13.970000,0.038000,11.430000><13.970000,-1.538000,11.430000>0.406400}
cylinder{<16.510000,0.038000,11.430000><16.510000,-1.538000,11.430000>0.406400}
cylinder{<13.970000,0.038000,8.890000><13.970000,-1.538000,8.890000>0.406400}
cylinder{<16.510000,0.038000,8.890000><16.510000,-1.538000,8.890000>0.406400}
cylinder{<34.290000,0.038000,11.430000><34.290000,-1.538000,11.430000>0.406400}
cylinder{<36.830000,0.038000,11.430000><36.830000,-1.538000,11.430000>0.406400}
cylinder{<34.290000,0.038000,8.890000><34.290000,-1.538000,8.890000>0.406400}
cylinder{<36.830000,0.038000,8.890000><36.830000,-1.538000,8.890000>0.406400}
cylinder{<13.970000,0.038000,16.510000><13.970000,-1.538000,16.510000>0.406400}
cylinder{<16.510000,0.038000,16.510000><16.510000,-1.538000,16.510000>0.406400}
cylinder{<13.970000,0.038000,13.970000><13.970000,-1.538000,13.970000>0.406400}
cylinder{<16.510000,0.038000,13.970000><16.510000,-1.538000,13.970000>0.406400}
cylinder{<34.290000,0.038000,16.510000><34.290000,-1.538000,16.510000>0.406400}
cylinder{<36.830000,0.038000,16.510000><36.830000,-1.538000,16.510000>0.406400}
cylinder{<34.290000,0.038000,13.970000><34.290000,-1.538000,13.970000>0.406400}
cylinder{<36.830000,0.038000,13.970000><36.830000,-1.538000,13.970000>0.406400}
cylinder{<44.450000,0.038000,14.986000><44.450000,-1.538000,14.986000>0.457200}
cylinder{<46.990000,0.038000,14.986000><46.990000,-1.538000,14.986000>0.457200}
cylinder{<44.450000,0.038000,12.446000><44.450000,-1.538000,12.446000>0.457200}
cylinder{<46.990000,0.038000,12.446000><46.990000,-1.538000,12.446000>0.457200}
cylinder{<44.450000,0.038000,9.906000><44.450000,-1.538000,9.906000>0.457200}
cylinder{<46.990000,0.038000,9.906000><46.990000,-1.538000,9.906000>0.457200}
cylinder{<7.874000,0.038000,9.906000><7.874000,-1.538000,9.906000>0.457200}
cylinder{<5.334000,0.038000,9.906000><5.334000,-1.538000,9.906000>0.457200}
cylinder{<7.874000,0.038000,12.446000><7.874000,-1.538000,12.446000>0.457200}
cylinder{<5.334000,0.038000,12.446000><5.334000,-1.538000,12.446000>0.457200}
cylinder{<7.874000,0.038000,14.986000><7.874000,-1.538000,14.986000>0.457200}
cylinder{<5.334000,0.038000,14.986000><5.334000,-1.538000,14.986000>0.457200}
//Holes(fast)/Vias
//Holes(fast)/Board
texture{col_hls}
}
#if(pcb_silkscreen=on)
//Silk Screen
union{
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<3.403600,0.000000,0.355600>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<4.183100,0.000000,0.355600>}
box{<0,0,-0.101600><0.779500,0.036000,0.101600> rotate<0,0.000000,0> translate<3.403600,0.000000,0.355600> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<3.793300,0.000000,0.355600>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<3.793300,0.000000,2.694300>}
box{<0,0,-0.101600><2.338700,0.036000,0.101600> rotate<0,90.000000,0> translate<3.793300,0.000000,2.694300> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<3.403600,0.000000,2.694300>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<4.183100,0.000000,2.694300>}
box{<0,0,-0.101600><0.779500,0.036000,0.101600> rotate<0,0.000000,0> translate<3.403600,0.000000,2.694300> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<4.962700,0.000000,0.355600>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<4.962700,0.000000,2.694300>}
box{<0,0,-0.101600><2.338700,0.036000,0.101600> rotate<0,90.000000,0> translate<4.962700,0.000000,2.694300> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<4.962700,0.000000,2.694300>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.521800,0.000000,0.355600>}
box{<0,0,-0.101600><2.810749,0.036000,0.101600> rotate<0,56.306782,0> translate<4.962700,0.000000,2.694300> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.521800,0.000000,0.355600>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<6.521800,0.000000,2.694300>}
box{<0,0,-0.101600><2.338700,0.036000,0.101600> rotate<0,90.000000,0> translate<6.521800,0.000000,2.694300> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<43.942900,0.000000,2.694300>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<43.163300,0.000000,2.694300>}
box{<0,0,-0.101600><0.779600,0.036000,0.101600> rotate<0,0.000000,0> translate<43.163300,0.000000,2.694300> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<43.163300,0.000000,2.694300>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<42.773600,0.000000,2.304500>}
box{<0,0,-0.101600><0.551190,0.036000,0.101600> rotate<0,-45.004380,0> translate<42.773600,0.000000,2.304500> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<42.773600,0.000000,2.304500>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<42.773600,0.000000,0.745300>}
box{<0,0,-0.101600><1.559200,0.036000,0.101600> rotate<0,-90.000000,0> translate<42.773600,0.000000,0.745300> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<42.773600,0.000000,0.745300>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<43.163300,0.000000,0.355600>}
box{<0,0,-0.101600><0.551119,0.036000,0.101600> rotate<0,44.997030,0> translate<42.773600,0.000000,0.745300> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<43.163300,0.000000,0.355600>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<43.942900,0.000000,0.355600>}
box{<0,0,-0.101600><0.779600,0.036000,0.101600> rotate<0,0.000000,0> translate<43.163300,0.000000,0.355600> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<43.942900,0.000000,0.355600>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<44.332700,0.000000,0.745300>}
box{<0,0,-0.101600><0.551190,0.036000,0.101600> rotate<0,-44.989680,0> translate<43.942900,0.000000,0.355600> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<44.332700,0.000000,0.745300>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<44.332700,0.000000,2.304500>}
box{<0,0,-0.101600><1.559200,0.036000,0.101600> rotate<0,90.000000,0> translate<44.332700,0.000000,2.304500> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<44.332700,0.000000,2.304500>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<43.942900,0.000000,2.694300>}
box{<0,0,-0.101600><0.551260,0.036000,0.101600> rotate<0,44.997030,0> translate<43.942900,0.000000,2.694300> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<45.112300,0.000000,2.694300>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<45.112300,0.000000,0.745300>}
box{<0,0,-0.101600><1.949000,0.036000,0.101600> rotate<0,-90.000000,0> translate<45.112300,0.000000,0.745300> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<45.112300,0.000000,0.745300>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<45.502000,0.000000,0.355600>}
box{<0,0,-0.101600><0.551119,0.036000,0.101600> rotate<0,44.997030,0> translate<45.112300,0.000000,0.745300> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<45.502000,0.000000,0.355600>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<46.281600,0.000000,0.355600>}
box{<0,0,-0.101600><0.779600,0.036000,0.101600> rotate<0,0.000000,0> translate<45.502000,0.000000,0.355600> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<46.281600,0.000000,0.355600>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<46.671400,0.000000,0.745300>}
box{<0,0,-0.101600><0.551190,0.036000,0.101600> rotate<0,-44.989680,0> translate<46.281600,0.000000,0.355600> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<46.671400,0.000000,0.745300>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<46.671400,0.000000,2.694300>}
box{<0,0,-0.101600><1.949000,0.036000,0.101600> rotate<0,90.000000,0> translate<46.671400,0.000000,2.694300> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<48.230500,0.000000,0.355600>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<48.230500,0.000000,2.694300>}
box{<0,0,-0.101600><2.338700,0.036000,0.101600> rotate<0,90.000000,0> translate<48.230500,0.000000,2.694300> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<47.451000,0.000000,2.694300>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<49.010100,0.000000,2.694300>}
box{<0,0,-0.101600><1.559100,0.036000,0.101600> rotate<0,0.000000,0> translate<47.451000,0.000000,2.694300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.734400,0.000000,25.553700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.192100,0.000000,25.553700>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<3.192100,0.000000,25.553700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.192100,0.000000,25.553700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<2.921000,0.000000,25.282600>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<2.921000,0.000000,25.282600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<2.921000,0.000000,25.282600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<2.921000,0.000000,24.197900>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,-90.000000,0> translate<2.921000,0.000000,24.197900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<2.921000,0.000000,24.197900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.192100,0.000000,23.926800>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<2.921000,0.000000,24.197900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.192100,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.734400,0.000000,23.926800>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<3.192100,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.734400,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<4.005600,0.000000,24.197900>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-44.986466,0> translate<3.734400,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<4.005600,0.000000,24.197900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<4.005600,0.000000,25.282600>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,90.000000,0> translate<4.005600,0.000000,25.282600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<4.005600,0.000000,25.282600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.734400,0.000000,25.553700>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,44.986466,0> translate<3.734400,0.000000,25.553700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<4.558100,0.000000,23.384500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<4.558100,0.000000,25.011400>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,90.000000,0> translate<4.558100,0.000000,25.011400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<4.558100,0.000000,25.011400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<5.371500,0.000000,25.011400>}
box{<0,0,-0.076200><0.813400,0.036000,0.076200> rotate<0,0.000000,0> translate<4.558100,0.000000,25.011400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<5.371500,0.000000,25.011400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<5.642700,0.000000,24.740200>}
box{<0,0,-0.076200><0.383535,0.036000,0.076200> rotate<0,44.997030,0> translate<5.371500,0.000000,25.011400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<5.642700,0.000000,24.740200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<5.642700,0.000000,24.197900>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,-90.000000,0> translate<5.642700,0.000000,24.197900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<5.642700,0.000000,24.197900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<5.371500,0.000000,23.926800>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-44.986466,0> translate<5.371500,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<5.371500,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<4.558100,0.000000,23.926800>}
box{<0,0,-0.076200><0.813400,0.036000,0.076200> rotate<0,0.000000,0> translate<4.558100,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.466300,0.000000,25.282600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.466300,0.000000,24.197900>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,-90.000000,0> translate<6.466300,0.000000,24.197900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.466300,0.000000,24.197900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.737500,0.000000,23.926800>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,44.986466,0> translate<6.466300,0.000000,24.197900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.195200,0.000000,25.011400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<6.737500,0.000000,25.011400>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<6.195200,0.000000,25.011400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.557700,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.100000,0.000000,23.926800>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<7.557700,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.100000,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.371200,0.000000,24.197900>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-44.986466,0> translate<8.100000,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.371200,0.000000,24.197900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.371200,0.000000,24.740200>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,90.000000,0> translate<8.371200,0.000000,24.740200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.371200,0.000000,24.740200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.100000,0.000000,25.011400>}
box{<0,0,-0.076200><0.383535,0.036000,0.076200> rotate<0,44.997030,0> translate<8.100000,0.000000,25.011400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<8.100000,0.000000,25.011400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.557700,0.000000,25.011400>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<7.557700,0.000000,25.011400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.557700,0.000000,25.011400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.286600,0.000000,24.740200>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-45.007595,0> translate<7.286600,0.000000,24.740200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.286600,0.000000,24.740200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.286600,0.000000,24.197900>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,-90.000000,0> translate<7.286600,0.000000,24.197900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.286600,0.000000,24.197900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<7.557700,0.000000,23.926800>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<7.286600,0.000000,24.197900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.560800,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.103100,0.000000,23.926800>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<10.560800,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.831900,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.831900,0.000000,25.553700>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,90.000000,0> translate<10.831900,0.000000,25.553700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.560800,0.000000,25.553700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.103100,0.000000,25.553700>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<10.560800,0.000000,25.553700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.652200,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<12.465600,0.000000,23.926800>}
box{<0,0,-0.076200><0.813400,0.036000,0.076200> rotate<0,0.000000,0> translate<11.652200,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<12.465600,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<12.736800,0.000000,24.197900>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-44.986466,0> translate<12.465600,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<12.736800,0.000000,24.197900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<12.465600,0.000000,24.469100>}
box{<0,0,-0.076200><0.383535,0.036000,0.076200> rotate<0,44.997030,0> translate<12.465600,0.000000,24.469100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<12.465600,0.000000,24.469100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.923300,0.000000,24.469100>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<11.923300,0.000000,24.469100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.923300,0.000000,24.469100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.652200,0.000000,24.740200>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<11.652200,0.000000,24.740200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.652200,0.000000,24.740200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.923300,0.000000,25.011400>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-45.007595,0> translate<11.652200,0.000000,24.740200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.923300,0.000000,25.011400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<12.736800,0.000000,25.011400>}
box{<0,0,-0.076200><0.813500,0.036000,0.076200> rotate<0,0.000000,0> translate<11.923300,0.000000,25.011400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.560400,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.102700,0.000000,23.926800>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<13.560400,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.102700,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.373900,0.000000,24.197900>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-44.986466,0> translate<14.102700,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.373900,0.000000,24.197900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.373900,0.000000,24.740200>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,90.000000,0> translate<14.373900,0.000000,24.740200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.373900,0.000000,24.740200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.102700,0.000000,25.011400>}
box{<0,0,-0.076200><0.383535,0.036000,0.076200> rotate<0,44.997030,0> translate<14.102700,0.000000,25.011400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.102700,0.000000,25.011400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.560400,0.000000,25.011400>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<13.560400,0.000000,25.011400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.560400,0.000000,25.011400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.289300,0.000000,24.740200>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-45.007595,0> translate<13.289300,0.000000,24.740200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.289300,0.000000,24.740200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.289300,0.000000,24.197900>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,-90.000000,0> translate<13.289300,0.000000,24.197900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.289300,0.000000,24.197900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.560400,0.000000,23.926800>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<13.289300,0.000000,24.197900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.926400,0.000000,25.553700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.197500,0.000000,25.553700>}
box{<0,0,-0.076200><0.271100,0.036000,0.076200> rotate<0,0.000000,0> translate<14.926400,0.000000,25.553700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.197500,0.000000,25.553700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.197500,0.000000,23.926800>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,-90.000000,0> translate<15.197500,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.926400,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.468700,0.000000,23.926800>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<14.926400,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.288900,0.000000,25.011400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.831200,0.000000,25.011400>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<16.288900,0.000000,25.011400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.831200,0.000000,25.011400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.102400,0.000000,24.740200>}
box{<0,0,-0.076200><0.383535,0.036000,0.076200> rotate<0,44.997030,0> translate<16.831200,0.000000,25.011400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.102400,0.000000,24.740200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.102400,0.000000,23.926800>}
box{<0,0,-0.076200><0.813400,0.036000,0.076200> rotate<0,-90.000000,0> translate<17.102400,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.102400,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.288900,0.000000,23.926800>}
box{<0,0,-0.076200><0.813500,0.036000,0.076200> rotate<0,0.000000,0> translate<16.288900,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.288900,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.017800,0.000000,24.197900>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<16.017800,0.000000,24.197900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.017800,0.000000,24.197900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.288900,0.000000,24.469100>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-45.007595,0> translate<16.017800,0.000000,24.197900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.288900,0.000000,24.469100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.102400,0.000000,24.469100>}
box{<0,0,-0.076200><0.813500,0.036000,0.076200> rotate<0,0.000000,0> translate<16.288900,0.000000,24.469100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.926000,0.000000,25.282600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.926000,0.000000,24.197900>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,-90.000000,0> translate<17.926000,0.000000,24.197900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.926000,0.000000,24.197900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.197200,0.000000,23.926800>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,44.986466,0> translate<17.926000,0.000000,24.197900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<17.654900,0.000000,25.011400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.197200,0.000000,25.011400>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<17.654900,0.000000,25.011400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.017400,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.559700,0.000000,23.926800>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<19.017400,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.559700,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.830900,0.000000,24.197900>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-44.986466,0> translate<19.559700,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.830900,0.000000,24.197900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.830900,0.000000,24.740200>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,90.000000,0> translate<19.830900,0.000000,24.740200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.830900,0.000000,24.740200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.559700,0.000000,25.011400>}
box{<0,0,-0.076200><0.383535,0.036000,0.076200> rotate<0,44.997030,0> translate<19.559700,0.000000,25.011400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.559700,0.000000,25.011400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.017400,0.000000,25.011400>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<19.017400,0.000000,25.011400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.017400,0.000000,25.011400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.746300,0.000000,24.740200>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-45.007595,0> translate<18.746300,0.000000,24.740200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.746300,0.000000,24.740200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.746300,0.000000,24.197900>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,-90.000000,0> translate<18.746300,0.000000,24.197900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.746300,0.000000,24.197900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<19.017400,0.000000,23.926800>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<18.746300,0.000000,24.197900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.383400,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.383400,0.000000,25.011400>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,90.000000,0> translate<20.383400,0.000000,25.011400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.383400,0.000000,24.469100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.925700,0.000000,25.011400>}
box{<0,0,-0.076200><0.766928,0.036000,0.076200> rotate<0,-44.997030,0> translate<20.383400,0.000000,24.469100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.925700,0.000000,25.011400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.196800,0.000000,25.011400>}
box{<0,0,-0.076200><0.271100,0.036000,0.076200> rotate<0,0.000000,0> translate<20.925700,0.000000,25.011400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.384700,0.000000,25.011400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.927000,0.000000,23.926800>}
box{<0,0,-0.076200><1.212620,0.036000,0.076200> rotate<0,63.430762,0> translate<23.384700,0.000000,25.011400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.927000,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.469300,0.000000,25.011400>}
box{<0,0,-0.076200><1.212620,0.036000,0.076200> rotate<0,-63.430762,0> translate<23.927000,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<25.021800,0.000000,25.011400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<25.564100,0.000000,25.553700>}
box{<0,0,-0.076200><0.766928,0.036000,0.076200> rotate<0,-44.997030,0> translate<25.021800,0.000000,25.011400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<25.564100,0.000000,25.553700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<25.564100,0.000000,23.926800>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,-90.000000,0> translate<25.564100,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<25.021800,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.106400,0.000000,23.926800>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<25.021800,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.658900,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.658900,0.000000,24.197900>}
box{<0,0,-0.076200><0.271100,0.036000,0.076200> rotate<0,90.000000,0> translate<26.658900,0.000000,24.197900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.658900,0.000000,24.197900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.930000,0.000000,24.197900>}
box{<0,0,-0.076200><0.271100,0.036000,0.076200> rotate<0,0.000000,0> translate<26.658900,0.000000,24.197900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.930000,0.000000,24.197900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.930000,0.000000,23.926800>}
box{<0,0,-0.076200><0.271100,0.036000,0.076200> rotate<0,-90.000000,0> translate<26.930000,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.930000,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.658900,0.000000,23.926800>}
box{<0,0,-0.076200><0.271100,0.036000,0.076200> rotate<0,0.000000,0> translate<26.658900,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.477400,0.000000,24.197900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.477400,0.000000,25.282600>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,90.000000,0> translate<27.477400,0.000000,25.282600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.477400,0.000000,25.282600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.748500,0.000000,25.553700>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<27.477400,0.000000,25.282600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.748500,0.000000,25.553700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.290800,0.000000,25.553700>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<27.748500,0.000000,25.553700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.290800,0.000000,25.553700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.562000,0.000000,25.282600>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,44.986466,0> translate<28.290800,0.000000,25.553700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.562000,0.000000,25.282600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.562000,0.000000,24.197900>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,-90.000000,0> translate<28.562000,0.000000,24.197900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.562000,0.000000,24.197900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.290800,0.000000,23.926800>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-44.986466,0> translate<28.290800,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.290800,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.748500,0.000000,23.926800>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<27.748500,0.000000,23.926800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.748500,0.000000,23.926800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.477400,0.000000,24.197900>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<27.477400,0.000000,24.197900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.477400,0.000000,24.197900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.562000,0.000000,25.282600>}
box{<0,0,-0.076200><1.533927,0.036000,0.076200> rotate<0,-44.999671,0> translate<27.477400,0.000000,24.197900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<10.718800,0.000000,1.474100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<10.718800,0.000000,0.304800>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,-90.000000,0> translate<10.718800,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<10.718800,0.000000,0.889400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<10.913600,0.000000,1.084300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<10.718800,0.000000,0.889400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<10.913600,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.303400,0.000000,1.084300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<10.913600,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.303400,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.498300,0.000000,0.889400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<11.303400,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.498300,0.000000,0.889400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.498300,0.000000,0.304800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<11.498300,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.082900,0.000000,1.279200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.082900,0.000000,0.499600>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,-90.000000,0> translate<12.082900,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.082900,0.000000,0.499600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.277800,0.000000,0.304800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<12.082900,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<11.888100,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.277800,0.000000,1.084300>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,0.000000,0> translate<11.888100,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.862400,0.000000,1.279200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.862400,0.000000,0.499600>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,-90.000000,0> translate<12.862400,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.862400,0.000000,0.499600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.057300,0.000000,0.304800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<12.862400,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<12.667600,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.057300,0.000000,1.084300>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,0.000000,0> translate<12.667600,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.447100,0.000000,-0.084900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.447100,0.000000,1.084300>}
box{<0,0,-0.050800><1.169200,0.036000,0.050800> rotate<0,90.000000,0> translate<13.447100,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.447100,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.031700,0.000000,1.084300>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<13.447100,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.031700,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.226600,0.000000,0.889400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<14.031700,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.226600,0.000000,0.889400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.226600,0.000000,0.499600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<14.226600,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.226600,0.000000,0.499600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.031700,0.000000,0.304800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<14.031700,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.031700,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<13.447100,0.000000,0.304800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<13.447100,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.616400,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.811200,0.000000,1.084300>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<14.616400,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.811200,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.811200,0.000000,0.889400>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<14.811200,0.000000,0.889400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.811200,0.000000,0.889400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.616400,0.000000,0.889400>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<14.616400,0.000000,0.889400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.616400,0.000000,0.889400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.616400,0.000000,1.084300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,90.000000,0> translate<14.616400,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.616400,0.000000,0.499600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.811200,0.000000,0.499600>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<14.616400,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.811200,0.000000,0.499600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.811200,0.000000,0.304800>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,-90.000000,0> translate<14.811200,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.811200,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.616400,0.000000,0.304800>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<14.616400,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.616400,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<14.616400,0.000000,0.499600>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,90.000000,0> translate<14.616400,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.201000,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<15.980500,0.000000,1.474100>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,-56.307347,0> translate<15.201000,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<16.370300,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.149800,0.000000,1.474100>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,-56.307347,0> translate<16.370300,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.539600,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.539600,0.000000,1.084300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<17.539600,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.539600,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.734400,0.000000,1.084300>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<17.539600,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.734400,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.929300,0.000000,0.889400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<17.734400,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.929300,0.000000,0.889400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.929300,0.000000,0.304800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<17.929300,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<17.929300,0.000000,0.889400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.124200,0.000000,1.084300>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<17.929300,0.000000,0.889400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.124200,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.319100,0.000000,0.889400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<18.124200,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.319100,0.000000,0.889400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.319100,0.000000,0.304800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<18.319100,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.903700,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.293500,0.000000,1.084300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<18.903700,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.293500,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.488400,0.000000,0.889400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<19.293500,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.488400,0.000000,0.889400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.488400,0.000000,0.304800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<19.488400,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.488400,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.903700,0.000000,0.304800>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,0.000000,0> translate<18.903700,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.903700,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.708900,0.000000,0.499600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<18.708900,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.708900,0.000000,0.499600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.903700,0.000000,0.694500>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<18.708900,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<18.903700,0.000000,0.694500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.488400,0.000000,0.694500>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,0.000000,0> translate<18.903700,0.000000,0.694500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.878200,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.878200,0.000000,1.474100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,90.000000,0> translate<19.878200,0.000000,1.474100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.462800,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.878200,0.000000,0.694500>}
box{<0,0,-0.050800><0.702583,0.036000,0.050800> rotate<0,33.685582,0> translate<19.878200,0.000000,0.694500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<19.878200,0.000000,0.694500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.462800,0.000000,1.084300>}
box{<0,0,-0.050800><0.702639,0.036000,0.050800> rotate<0,-33.692367,0> translate<19.878200,0.000000,0.694500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.437200,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.047400,0.000000,0.304800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<21.047400,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.047400,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.852600,0.000000,0.499600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<20.852600,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.852600,0.000000,0.499600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.852600,0.000000,0.889400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<20.852600,0.000000,0.889400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.852600,0.000000,0.889400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.047400,0.000000,1.084300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<20.852600,0.000000,0.889400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.047400,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.437200,0.000000,1.084300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<21.047400,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.437200,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.632100,0.000000,0.889400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<21.437200,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.632100,0.000000,0.889400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.632100,0.000000,0.694500>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<21.632100,0.000000,0.694500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<21.632100,0.000000,0.694500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<20.852600,0.000000,0.694500>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<20.852600,0.000000,0.694500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.021900,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.021900,0.000000,0.499600>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,90.000000,0> translate<22.021900,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.021900,0.000000,0.499600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.216700,0.000000,0.499600>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<22.021900,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.216700,0.000000,0.499600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.216700,0.000000,0.304800>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,-90.000000,0> translate<22.216700,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.216700,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.021900,0.000000,0.304800>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<22.021900,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.606500,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.606500,0.000000,1.084300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<22.606500,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.606500,0.000000,0.694500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.996200,0.000000,1.084300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<22.606500,0.000000,0.694500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<22.996200,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.191100,0.000000,1.084300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<22.996200,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.580900,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.580900,0.000000,1.084300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<23.580900,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.580900,0.000000,0.694500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.970600,0.000000,1.084300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<23.580900,0.000000,0.694500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<23.970600,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.165500,0.000000,1.084300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<23.970600,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.555300,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.555300,0.000000,1.084300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<24.555300,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.555300,0.000000,0.694500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.945000,0.000000,1.084300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<24.555300,0.000000,0.694500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<24.945000,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.139900,0.000000,1.084300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<24.945000,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.724500,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.724500,0.000000,1.279200>}
box{<0,0,-0.050800><0.974400,0.036000,0.050800> rotate<0,90.000000,0> translate<25.724500,0.000000,1.279200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.724500,0.000000,1.279200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.919400,0.000000,1.474100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<25.724500,0.000000,1.279200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.529700,0.000000,0.889400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<25.919400,0.000000,0.889400>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,0.000000,0> translate<25.529700,0.000000,0.889400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.309200,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.309200,0.000000,0.499600>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,90.000000,0> translate<26.309200,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.309200,0.000000,0.499600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.504000,0.000000,0.499600>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<26.309200,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.504000,0.000000,0.499600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.504000,0.000000,0.304800>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,-90.000000,0> translate<26.504000,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.504000,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.309200,0.000000,0.304800>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<26.309200,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.088600,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.478400,0.000000,0.304800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<27.088600,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.478400,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.673300,0.000000,0.499600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<27.478400,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.673300,0.000000,0.499600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.673300,0.000000,0.889400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<27.673300,0.000000,0.889400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.673300,0.000000,0.889400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.478400,0.000000,1.084300>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<27.478400,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.478400,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.088600,0.000000,1.084300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<27.088600,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.088600,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.893800,0.000000,0.889400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<26.893800,0.000000,0.889400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.893800,0.000000,0.889400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.893800,0.000000,0.499600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<26.893800,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<26.893800,0.000000,0.499600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<27.088600,0.000000,0.304800>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<26.893800,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.063100,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.063100,0.000000,1.084300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<28.063100,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.063100,0.000000,0.694500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.452800,0.000000,1.084300>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<28.063100,0.000000,0.694500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.452800,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<28.647700,0.000000,1.084300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<28.452800,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.427200,0.000000,-0.084900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.622100,0.000000,-0.084900>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<29.427200,0.000000,-0.084900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.622100,0.000000,-0.084900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.817000,0.000000,0.110000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<29.622100,0.000000,-0.084900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.817000,0.000000,0.110000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.817000,0.000000,1.084300>}
box{<0,0,-0.050800><0.974300,0.036000,0.050800> rotate<0,90.000000,0> translate<29.817000,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.817000,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.232300,0.000000,1.084300>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,0.000000,0> translate<29.232300,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.232300,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.037500,0.000000,0.889400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<29.037500,0.000000,0.889400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.037500,0.000000,0.889400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.037500,0.000000,0.499600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<29.037500,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.037500,0.000000,0.499600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.232300,0.000000,0.304800>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<29.037500,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.232300,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<29.817000,0.000000,0.304800>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,0.000000,0> translate<29.232300,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.206800,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<30.986300,0.000000,1.474100>}
box{<0,0,-0.050800><1.405305,0.036000,0.050800> rotate<0,-56.307347,0> translate<30.206800,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.570900,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.960700,0.000000,0.304800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<31.570900,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.960700,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.155600,0.000000,0.499600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<31.960700,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.155600,0.000000,0.499600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.155600,0.000000,0.889400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<32.155600,0.000000,0.889400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.155600,0.000000,0.889400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.960700,0.000000,1.084300>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<31.960700,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.960700,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.570900,0.000000,1.084300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<31.570900,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.570900,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.376100,0.000000,0.889400>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<31.376100,0.000000,0.889400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.376100,0.000000,0.889400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.376100,0.000000,0.499600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<31.376100,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.376100,0.000000,0.499600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<31.570900,0.000000,0.304800>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<31.376100,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.545400,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.740200,0.000000,1.084300>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<32.545400,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.740200,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.740200,0.000000,0.304800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<32.740200,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.545400,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.935100,0.000000,0.304800>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,0.000000,0> translate<32.545400,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.740200,0.000000,1.669000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<32.740200,0.000000,1.474100>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,-90.000000,0> translate<32.740200,0.000000,1.474100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<33.324900,0.000000,0.889400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.104400,0.000000,0.889400>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<33.324900,0.000000,0.889400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.494200,0.000000,1.084300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.883900,0.000000,1.474100>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<34.494200,0.000000,1.084300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.883900,0.000000,1.474100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.883900,0.000000,0.304800>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,-90.000000,0> translate<34.883900,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<34.494200,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.273700,0.000000,0.304800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<34.494200,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.663500,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.663500,0.000000,0.499600>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,90.000000,0> translate<35.663500,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.663500,0.000000,0.499600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.858300,0.000000,0.499600>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<35.663500,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.858300,0.000000,0.499600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.858300,0.000000,0.304800>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,-90.000000,0> translate<35.858300,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.858300,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<35.663500,0.000000,0.304800>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<35.663500,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.248100,0.000000,0.499600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.248100,0.000000,1.279200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,90.000000,0> translate<36.248100,0.000000,1.279200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.248100,0.000000,1.279200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.442900,0.000000,1.474100>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-45.011732,0> translate<36.248100,0.000000,1.279200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.442900,0.000000,1.474100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.832700,0.000000,1.474100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<36.442900,0.000000,1.474100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.832700,0.000000,1.474100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.027600,0.000000,1.279200>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<36.832700,0.000000,1.474100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.027600,0.000000,1.279200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.027600,0.000000,0.499600>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,-90.000000,0> translate<37.027600,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.027600,0.000000,0.499600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.832700,0.000000,0.304800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<36.832700,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.832700,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.442900,0.000000,0.304800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<36.442900,0.000000,0.304800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.442900,0.000000,0.304800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.248100,0.000000,0.499600>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,44.997030,0> translate<36.248100,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<36.248100,0.000000,0.499600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<37.027600,0.000000,1.279200>}
box{<0,0,-0.050800><1.102450,0.036000,0.050800> rotate<0,-45.000705,0> translate<36.248100,0.000000,0.499600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.931500,0.000000,21.357500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.562900,0.000000,21.357500>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<41.562900,0.000000,21.357500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.562900,0.000000,21.357500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.440100,0.000000,21.234700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<41.440100,0.000000,21.234700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.440100,0.000000,21.234700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.440100,0.000000,20.988900>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<41.440100,0.000000,20.988900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.440100,0.000000,20.988900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.562900,0.000000,20.866100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<41.440100,0.000000,20.988900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.562900,0.000000,20.866100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.931500,0.000000,20.866100>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<41.562900,0.000000,20.866100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.936900,0.000000,20.866100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.936900,0.000000,21.603300>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,90.000000,0> translate<42.936900,0.000000,21.603300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.936900,0.000000,21.603300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.305500,0.000000,21.603300>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<42.936900,0.000000,21.603300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.305500,0.000000,21.603300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.428300,0.000000,21.480400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<43.305500,0.000000,21.603300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.428300,0.000000,21.480400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.428300,0.000000,21.234700>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,-90.000000,0> translate<43.428300,0.000000,21.234700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.428300,0.000000,21.234700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.305500,0.000000,21.111800>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<43.305500,0.000000,21.111800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.305500,0.000000,21.111800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.936900,0.000000,21.111800>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<42.936900,0.000000,21.111800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.182600,0.000000,21.111800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.428300,0.000000,20.866100>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,44.997030,0> translate<43.182600,0.000000,21.111800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.685300,0.000000,20.866100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.685300,0.000000,21.603300>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,90.000000,0> translate<43.685300,0.000000,21.603300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.685300,0.000000,21.603300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.053900,0.000000,21.603300>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<43.685300,0.000000,21.603300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.053900,0.000000,21.603300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.176700,0.000000,21.480400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<44.053900,0.000000,21.603300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.176700,0.000000,21.480400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.176700,0.000000,21.234700>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,-90.000000,0> translate<44.176700,0.000000,21.234700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.176700,0.000000,21.234700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.053900,0.000000,21.111800>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<44.053900,0.000000,21.111800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.053900,0.000000,21.111800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.685300,0.000000,21.111800>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<43.685300,0.000000,21.111800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.931000,0.000000,21.111800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.176700,0.000000,20.866100>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,44.997030,0> translate<43.931000,0.000000,21.111800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.433700,0.000000,20.866100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.433700,0.000000,21.603300>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,90.000000,0> translate<44.433700,0.000000,21.603300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.433700,0.000000,21.603300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.802300,0.000000,21.603300>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<44.433700,0.000000,21.603300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.802300,0.000000,21.603300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.925100,0.000000,21.480400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<44.802300,0.000000,21.603300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.925100,0.000000,21.480400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.925100,0.000000,21.234700>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,-90.000000,0> translate<44.925100,0.000000,21.234700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.925100,0.000000,21.234700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.802300,0.000000,21.111800>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<44.802300,0.000000,21.111800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.802300,0.000000,21.111800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.433700,0.000000,21.111800>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<44.433700,0.000000,21.111800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.679400,0.000000,21.111800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.925100,0.000000,20.866100>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,44.997030,0> translate<44.679400,0.000000,21.111800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.182100,0.000000,20.866100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.182100,0.000000,21.603300>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,90.000000,0> translate<45.182100,0.000000,21.603300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.182100,0.000000,21.603300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.673500,0.000000,21.603300>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<45.182100,0.000000,21.603300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.182100,0.000000,21.234700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.427800,0.000000,21.234700>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,0.000000,0> translate<45.182100,0.000000,21.234700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.170300,0.000000,20.866100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.678900,0.000000,20.866100>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<46.678900,0.000000,20.866100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.678900,0.000000,20.866100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.170300,0.000000,21.357500>}
box{<0,0,-0.038100><0.694945,0.036000,0.038100> rotate<0,-44.997030,0> translate<46.678900,0.000000,20.866100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.170300,0.000000,21.357500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.170300,0.000000,21.480400>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,90.000000,0> translate<47.170300,0.000000,21.480400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.170300,0.000000,21.480400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.047500,0.000000,21.603300>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<47.047500,0.000000,21.603300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.047500,0.000000,21.603300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.801700,0.000000,21.603300>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<46.801700,0.000000,21.603300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.801700,0.000000,21.603300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.678900,0.000000,21.480400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<46.678900,0.000000,21.480400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.427300,0.000000,20.988900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.427300,0.000000,21.480400>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,90.000000,0> translate<47.427300,0.000000,21.480400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.427300,0.000000,21.480400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.550100,0.000000,21.603300>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<47.427300,0.000000,21.480400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.550100,0.000000,21.603300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.795900,0.000000,21.603300>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<47.550100,0.000000,21.603300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.795900,0.000000,21.603300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.918700,0.000000,21.480400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<47.795900,0.000000,21.603300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.918700,0.000000,21.480400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.918700,0.000000,20.988900>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,-90.000000,0> translate<47.918700,0.000000,20.988900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.918700,0.000000,20.988900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.795900,0.000000,20.866100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<47.795900,0.000000,20.866100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.795900,0.000000,20.866100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.550100,0.000000,20.866100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<47.550100,0.000000,20.866100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.550100,0.000000,20.866100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.427300,0.000000,20.988900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<47.427300,0.000000,20.988900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.427300,0.000000,20.988900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.918700,0.000000,21.480400>}
box{<0,0,-0.038100><0.695015,0.036000,0.038100> rotate<0,-45.002859,0> translate<47.427300,0.000000,20.988900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.175700,0.000000,20.988900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.175700,0.000000,21.480400>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,90.000000,0> translate<48.175700,0.000000,21.480400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.175700,0.000000,21.480400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.298500,0.000000,21.603300>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<48.175700,0.000000,21.480400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.298500,0.000000,21.603300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.544300,0.000000,21.603300>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<48.298500,0.000000,21.603300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.544300,0.000000,21.603300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.667100,0.000000,21.480400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<48.544300,0.000000,21.603300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.667100,0.000000,21.480400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.667100,0.000000,20.988900>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.667100,0.000000,20.988900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.667100,0.000000,20.988900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.544300,0.000000,20.866100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<48.544300,0.000000,20.866100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.544300,0.000000,20.866100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.298500,0.000000,20.866100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<48.298500,0.000000,20.866100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.298500,0.000000,20.866100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.175700,0.000000,20.988900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<48.175700,0.000000,20.988900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.175700,0.000000,20.988900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.667100,0.000000,21.480400>}
box{<0,0,-0.038100><0.695015,0.036000,0.038100> rotate<0,-45.002859,0> translate<48.175700,0.000000,20.988900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.924100,0.000000,21.480400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.046900,0.000000,21.603300>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<48.924100,0.000000,21.480400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.046900,0.000000,21.603300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.292700,0.000000,21.603300>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<49.046900,0.000000,21.603300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.292700,0.000000,21.603300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.415500,0.000000,21.480400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<49.292700,0.000000,21.603300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.415500,0.000000,21.480400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.415500,0.000000,21.357500>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,-90.000000,0> translate<49.415500,0.000000,21.357500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.415500,0.000000,21.357500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.292700,0.000000,21.234700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<49.292700,0.000000,21.234700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.292700,0.000000,21.234700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.415500,0.000000,21.111800>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<49.292700,0.000000,21.234700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.415500,0.000000,21.111800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.415500,0.000000,20.988900>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,-90.000000,0> translate<49.415500,0.000000,20.988900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.415500,0.000000,20.988900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.292700,0.000000,20.866100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<49.292700,0.000000,20.866100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.292700,0.000000,20.866100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.046900,0.000000,20.866100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<49.046900,0.000000,20.866100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.046900,0.000000,20.866100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.924100,0.000000,20.988900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<48.924100,0.000000,20.988900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.924100,0.000000,20.988900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.924100,0.000000,21.111800>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,90.000000,0> translate<48.924100,0.000000,21.111800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.924100,0.000000,21.111800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.046900,0.000000,21.234700>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<48.924100,0.000000,21.111800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.046900,0.000000,21.234700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.924100,0.000000,21.357500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<48.924100,0.000000,21.357500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.924100,0.000000,21.357500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.924100,0.000000,21.480400>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,90.000000,0> translate<48.924100,0.000000,21.480400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.046900,0.000000,21.234700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.292700,0.000000,21.234700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<49.046900,0.000000,21.234700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.440100,0.000000,22.619300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.440100,0.000000,21.882100>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,-90.000000,0> translate<41.440100,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.440100,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.931500,0.000000,21.882100>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<41.440100,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.188500,0.000000,22.373500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.311300,0.000000,22.373500>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,0.000000,0> translate<42.188500,0.000000,22.373500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.311300,0.000000,22.373500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.311300,0.000000,21.882100>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,-90.000000,0> translate<42.311300,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.188500,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.434200,0.000000,21.882100>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,0.000000,0> translate<42.188500,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.311300,0.000000,22.742200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.311300,0.000000,22.619300>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,-90.000000,0> translate<42.311300,0.000000,22.619300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.178800,0.000000,22.373500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.810200,0.000000,22.373500>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<42.810200,0.000000,22.373500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.810200,0.000000,22.373500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.687400,0.000000,22.250700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<42.687400,0.000000,22.250700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.687400,0.000000,22.250700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.687400,0.000000,22.004900>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<42.687400,0.000000,22.004900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.687400,0.000000,22.004900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.810200,0.000000,21.882100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<42.687400,0.000000,22.004900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.810200,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.178800,0.000000,21.882100>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<42.810200,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.804400,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.558600,0.000000,21.882100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<43.558600,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.558600,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.435800,0.000000,22.004900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<43.435800,0.000000,22.004900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.435800,0.000000,22.004900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.435800,0.000000,22.250700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<43.435800,0.000000,22.250700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.435800,0.000000,22.250700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.558600,0.000000,22.373500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<43.435800,0.000000,22.250700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.558600,0.000000,22.373500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.804400,0.000000,22.373500>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<43.558600,0.000000,22.373500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.804400,0.000000,22.373500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.927200,0.000000,22.250700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<43.804400,0.000000,22.373500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.927200,0.000000,22.250700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.927200,0.000000,22.127800>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,-90.000000,0> translate<43.927200,0.000000,22.127800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.927200,0.000000,22.127800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.435800,0.000000,22.127800>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<43.435800,0.000000,22.127800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.184200,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.184200,0.000000,22.373500>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,90.000000,0> translate<44.184200,0.000000,22.373500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.184200,0.000000,22.373500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.552800,0.000000,22.373500>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<44.184200,0.000000,22.373500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.552800,0.000000,22.373500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.675600,0.000000,22.250700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<44.552800,0.000000,22.373500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.675600,0.000000,22.250700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.675600,0.000000,21.882100>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,-90.000000,0> translate<44.675600,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.932600,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.301200,0.000000,21.882100>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<44.932600,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.301200,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.424000,0.000000,22.004900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<45.301200,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.424000,0.000000,22.004900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.301200,0.000000,22.127800>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<45.301200,0.000000,22.127800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.301200,0.000000,22.127800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.055400,0.000000,22.127800>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<45.055400,0.000000,22.127800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.055400,0.000000,22.127800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.932600,0.000000,22.250700>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<44.932600,0.000000,22.250700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.932600,0.000000,22.250700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.055400,0.000000,22.373500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<44.932600,0.000000,22.250700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.055400,0.000000,22.373500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.424000,0.000000,22.373500>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<45.055400,0.000000,22.373500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.049600,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.803800,0.000000,21.882100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<45.803800,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.803800,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.681000,0.000000,22.004900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<45.681000,0.000000,22.004900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.681000,0.000000,22.004900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.681000,0.000000,22.250700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<45.681000,0.000000,22.250700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.681000,0.000000,22.250700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.803800,0.000000,22.373500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<45.681000,0.000000,22.250700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.803800,0.000000,22.373500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.049600,0.000000,22.373500>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<45.803800,0.000000,22.373500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.049600,0.000000,22.373500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.172400,0.000000,22.250700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<46.049600,0.000000,22.373500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.172400,0.000000,22.250700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.172400,0.000000,22.127800>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,-90.000000,0> translate<46.172400,0.000000,22.127800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.172400,0.000000,22.127800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.681000,0.000000,22.127800>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<45.681000,0.000000,22.127800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.669200,0.000000,22.496400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.546400,0.000000,22.619300>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<47.546400,0.000000,22.619300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.546400,0.000000,22.619300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.300600,0.000000,22.619300>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<47.300600,0.000000,22.619300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.300600,0.000000,22.619300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.177800,0.000000,22.496400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<47.177800,0.000000,22.496400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.177800,0.000000,22.496400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.177800,0.000000,22.004900>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,-90.000000,0> translate<47.177800,0.000000,22.004900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.177800,0.000000,22.004900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.300600,0.000000,21.882100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<47.177800,0.000000,22.004900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.300600,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.546400,0.000000,21.882100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<47.300600,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.546400,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.669200,0.000000,22.004900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<47.546400,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.669200,0.000000,22.004900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.669200,0.000000,22.250700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<47.669200,0.000000,22.250700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.669200,0.000000,22.250700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.423500,0.000000,22.250700>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,0.000000,0> translate<47.423500,0.000000,22.250700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.926200,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.926200,0.000000,22.619300>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,90.000000,0> translate<47.926200,0.000000,22.619300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.926200,0.000000,22.619300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.294800,0.000000,22.619300>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<47.926200,0.000000,22.619300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.294800,0.000000,22.619300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.417600,0.000000,22.496400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<48.294800,0.000000,22.619300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.417600,0.000000,22.496400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.417600,0.000000,22.250700>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.417600,0.000000,22.250700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.417600,0.000000,22.250700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.294800,0.000000,22.127800>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<48.294800,0.000000,22.127800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.294800,0.000000,22.127800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.926200,0.000000,22.127800>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<47.926200,0.000000,22.127800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.674600,0.000000,22.619300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.674600,0.000000,21.882100>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.674600,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.674600,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.166000,0.000000,21.882100>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<48.674600,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.914400,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.423000,0.000000,21.882100>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<49.423000,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.423000,0.000000,21.882100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.914400,0.000000,22.373500>}
box{<0,0,-0.038100><0.694945,0.036000,0.038100> rotate<0,-44.997030,0> translate<49.423000,0.000000,21.882100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.914400,0.000000,22.373500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.914400,0.000000,22.496400>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,90.000000,0> translate<49.914400,0.000000,22.496400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.914400,0.000000,22.496400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.791600,0.000000,22.619300>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<49.791600,0.000000,22.619300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.791600,0.000000,22.619300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.545800,0.000000,22.619300>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<49.545800,0.000000,22.619300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.545800,0.000000,22.619300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.423000,0.000000,22.496400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<49.423000,0.000000,22.496400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.440100,0.000000,25.413300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.440100,0.000000,24.676100>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,-90.000000,0> translate<41.440100,0.000000,24.676100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.440100,0.000000,24.676100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.808700,0.000000,24.676100>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<41.440100,0.000000,24.676100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.808700,0.000000,24.676100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.931500,0.000000,24.798900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<41.808700,0.000000,24.676100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.931500,0.000000,24.798900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.931500,0.000000,25.290400>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,90.000000,0> translate<41.931500,0.000000,25.290400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.931500,0.000000,25.290400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.808700,0.000000,25.413300>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<41.808700,0.000000,25.413300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.808700,0.000000,25.413300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.440100,0.000000,25.413300>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<41.440100,0.000000,25.413300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.557100,0.000000,24.676100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.311300,0.000000,24.676100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<42.311300,0.000000,24.676100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.311300,0.000000,24.676100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.188500,0.000000,24.798900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<42.188500,0.000000,24.798900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.188500,0.000000,24.798900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.188500,0.000000,25.044700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<42.188500,0.000000,25.044700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.188500,0.000000,25.044700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.311300,0.000000,25.167500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<42.188500,0.000000,25.044700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.311300,0.000000,25.167500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.557100,0.000000,25.167500>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<42.311300,0.000000,25.167500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.557100,0.000000,25.167500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.679900,0.000000,25.044700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<42.557100,0.000000,25.167500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.679900,0.000000,25.044700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.679900,0.000000,24.921800>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,-90.000000,0> translate<42.679900,0.000000,24.921800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.679900,0.000000,24.921800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.188500,0.000000,24.921800>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<42.188500,0.000000,24.921800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.936900,0.000000,24.676100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.305500,0.000000,24.676100>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<42.936900,0.000000,24.676100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.305500,0.000000,24.676100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.428300,0.000000,24.798900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<43.305500,0.000000,24.676100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.428300,0.000000,24.798900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.305500,0.000000,24.921800>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<43.305500,0.000000,24.921800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.305500,0.000000,24.921800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.059700,0.000000,24.921800>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<43.059700,0.000000,24.921800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.059700,0.000000,24.921800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.936900,0.000000,25.044700>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,45.020348,0> translate<42.936900,0.000000,25.044700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.936900,0.000000,25.044700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.059700,0.000000,25.167500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<42.936900,0.000000,25.044700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.059700,0.000000,25.167500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.428300,0.000000,25.167500>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<43.059700,0.000000,25.167500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.685300,0.000000,25.167500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.808100,0.000000,25.167500>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,0.000000,0> translate<43.685300,0.000000,25.167500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.808100,0.000000,25.167500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.808100,0.000000,24.676100>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,-90.000000,0> translate<43.808100,0.000000,24.676100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.685300,0.000000,24.676100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.931000,0.000000,24.676100>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,0.000000,0> translate<43.685300,0.000000,24.676100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.808100,0.000000,25.536200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.808100,0.000000,25.413300>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,-90.000000,0> translate<43.808100,0.000000,25.413300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.429900,0.000000,24.430400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.552800,0.000000,24.430400>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,0.000000,0> translate<44.429900,0.000000,24.430400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.552800,0.000000,24.430400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.675600,0.000000,24.553300>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<44.552800,0.000000,24.430400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.675600,0.000000,24.553300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.675600,0.000000,25.167500>}
box{<0,0,-0.038100><0.614200,0.036000,0.038100> rotate<0,90.000000,0> translate<44.675600,0.000000,25.167500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.675600,0.000000,25.167500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.307000,0.000000,25.167500>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<44.307000,0.000000,25.167500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.307000,0.000000,25.167500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.184200,0.000000,25.044700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<44.184200,0.000000,25.044700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.184200,0.000000,25.044700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.184200,0.000000,24.798900>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<44.184200,0.000000,24.798900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.184200,0.000000,24.798900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.307000,0.000000,24.676100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<44.184200,0.000000,24.798900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.307000,0.000000,24.676100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.675600,0.000000,24.676100>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<44.307000,0.000000,24.676100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.932600,0.000000,24.676100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.932600,0.000000,25.167500>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,90.000000,0> translate<44.932600,0.000000,25.167500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.932600,0.000000,25.167500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.301200,0.000000,25.167500>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<44.932600,0.000000,25.167500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.301200,0.000000,25.167500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.424000,0.000000,25.044700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<45.301200,0.000000,25.167500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.424000,0.000000,25.044700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.424000,0.000000,24.676100>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,-90.000000,0> translate<45.424000,0.000000,24.676100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.049600,0.000000,24.676100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.803800,0.000000,24.676100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<45.803800,0.000000,24.676100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.803800,0.000000,24.676100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.681000,0.000000,24.798900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<45.681000,0.000000,24.798900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.681000,0.000000,24.798900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.681000,0.000000,25.044700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<45.681000,0.000000,25.044700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.681000,0.000000,25.044700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.803800,0.000000,25.167500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<45.681000,0.000000,25.044700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.803800,0.000000,25.167500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.049600,0.000000,25.167500>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<45.803800,0.000000,25.167500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.049600,0.000000,25.167500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.172400,0.000000,25.044700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<46.049600,0.000000,25.167500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.172400,0.000000,25.044700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.172400,0.000000,24.921800>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,-90.000000,0> translate<46.172400,0.000000,24.921800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.172400,0.000000,24.921800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.681000,0.000000,24.921800>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<45.681000,0.000000,24.921800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.920800,0.000000,25.413300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.920800,0.000000,24.676100>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,-90.000000,0> translate<46.920800,0.000000,24.676100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.920800,0.000000,24.676100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.552200,0.000000,24.676100>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<46.552200,0.000000,24.676100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.552200,0.000000,24.676100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.429400,0.000000,24.798900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<46.429400,0.000000,24.798900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.429400,0.000000,24.798900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.429400,0.000000,25.044700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<46.429400,0.000000,25.044700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.429400,0.000000,25.044700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.552200,0.000000,25.167500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<46.429400,0.000000,25.044700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.552200,0.000000,25.167500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.920800,0.000000,25.167500>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<46.552200,0.000000,25.167500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.926200,0.000000,25.413300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.926200,0.000000,24.676100>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,-90.000000,0> translate<47.926200,0.000000,24.676100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.926200,0.000000,24.676100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.294800,0.000000,24.676100>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<47.926200,0.000000,24.676100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.294800,0.000000,24.676100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.417600,0.000000,24.798900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<48.294800,0.000000,24.676100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.417600,0.000000,24.798900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.417600,0.000000,25.044700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<48.417600,0.000000,25.044700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.417600,0.000000,25.044700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.294800,0.000000,25.167500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<48.294800,0.000000,25.167500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.294800,0.000000,25.167500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.926200,0.000000,25.167500>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<47.926200,0.000000,25.167500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.674600,0.000000,25.167500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.674600,0.000000,24.798900>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.674600,0.000000,24.798900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.674600,0.000000,24.798900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.797400,0.000000,24.676100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<48.674600,0.000000,24.798900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.797400,0.000000,24.676100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.166000,0.000000,24.676100>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<48.797400,0.000000,24.676100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.166000,0.000000,25.167500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.166000,0.000000,24.553300>}
box{<0,0,-0.038100><0.614200,0.036000,0.038100> rotate<0,-90.000000,0> translate<49.166000,0.000000,24.553300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.166000,0.000000,24.553300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.043200,0.000000,24.430400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<49.043200,0.000000,24.430400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.043200,0.000000,24.430400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.920300,0.000000,24.430400>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,0.000000,0> translate<48.920300,0.000000,24.430400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.423000,0.000000,25.167500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.545800,0.000000,25.167500>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,0.000000,0> translate<49.423000,0.000000,25.167500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.545800,0.000000,25.167500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.545800,0.000000,25.044700>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,-90.000000,0> translate<49.545800,0.000000,25.044700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.545800,0.000000,25.044700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.423000,0.000000,25.044700>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,0.000000,0> translate<49.423000,0.000000,25.044700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.423000,0.000000,25.044700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.423000,0.000000,25.167500>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,90.000000,0> translate<49.423000,0.000000,25.167500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.423000,0.000000,24.798900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.545800,0.000000,24.798900>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,0.000000,0> translate<49.423000,0.000000,24.798900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.545800,0.000000,24.798900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.545800,0.000000,24.676100>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,-90.000000,0> translate<49.545800,0.000000,24.676100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.545800,0.000000,24.676100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.423000,0.000000,24.676100>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,0.000000,0> translate<49.423000,0.000000,24.676100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.423000,0.000000,24.676100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.423000,0.000000,24.798900>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,90.000000,0> translate<49.423000,0.000000,24.798900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.440100,0.000000,24.143300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.931500,0.000000,24.143300>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<41.440100,0.000000,24.143300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.931500,0.000000,24.143300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.931500,0.000000,24.020400>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,-90.000000,0> translate<41.931500,0.000000,24.020400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.931500,0.000000,24.020400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.440100,0.000000,23.528900>}
box{<0,0,-0.038100><0.695015,0.036000,0.038100> rotate<0,-45.002859,0> translate<41.440100,0.000000,23.528900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.440100,0.000000,23.528900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.440100,0.000000,23.406100>}
box{<0,0,-0.038100><0.122800,0.036000,0.038100> rotate<0,-90.000000,0> translate<41.440100,0.000000,23.406100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.440100,0.000000,23.406100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<41.931500,0.000000,23.406100>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<41.440100,0.000000,23.406100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.311300,0.000000,23.897500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.557100,0.000000,23.897500>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<42.311300,0.000000,23.897500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.557100,0.000000,23.897500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.679900,0.000000,23.774700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<42.557100,0.000000,23.897500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.679900,0.000000,23.774700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.679900,0.000000,23.406100>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,-90.000000,0> translate<42.679900,0.000000,23.406100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.679900,0.000000,23.406100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.311300,0.000000,23.406100>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<42.311300,0.000000,23.406100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.311300,0.000000,23.406100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.188500,0.000000,23.528900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<42.188500,0.000000,23.528900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.188500,0.000000,23.528900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.311300,0.000000,23.651800>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-45.020348,0> translate<42.188500,0.000000,23.528900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.311300,0.000000,23.651800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.679900,0.000000,23.651800>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<42.311300,0.000000,23.651800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.428300,0.000000,23.897500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.059700,0.000000,23.897500>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<43.059700,0.000000,23.897500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.059700,0.000000,23.897500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.936900,0.000000,23.774700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<42.936900,0.000000,23.774700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.936900,0.000000,23.774700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.936900,0.000000,23.528900>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<42.936900,0.000000,23.528900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.936900,0.000000,23.528900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.059700,0.000000,23.406100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<42.936900,0.000000,23.528900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.059700,0.000000,23.406100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.428300,0.000000,23.406100>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<43.059700,0.000000,23.406100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.685300,0.000000,24.143300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.685300,0.000000,23.406100>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,-90.000000,0> translate<43.685300,0.000000,23.406100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.685300,0.000000,23.774700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.808100,0.000000,23.897500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<43.685300,0.000000,23.774700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.808100,0.000000,23.897500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.053900,0.000000,23.897500>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<43.808100,0.000000,23.897500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.053900,0.000000,23.897500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.176700,0.000000,23.774700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<44.053900,0.000000,23.897500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.176700,0.000000,23.774700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<44.176700,0.000000,23.406100>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,-90.000000,0> translate<44.176700,0.000000,23.406100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.182100,0.000000,23.406100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.182100,0.000000,24.143300>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,90.000000,0> translate<45.182100,0.000000,24.143300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.182100,0.000000,23.774700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.673500,0.000000,23.774700>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<45.182100,0.000000,23.774700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.673500,0.000000,24.143300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.673500,0.000000,23.406100>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,-90.000000,0> translate<45.673500,0.000000,23.406100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.053300,0.000000,23.406100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.299100,0.000000,23.406100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<46.053300,0.000000,23.406100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.299100,0.000000,23.406100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.421900,0.000000,23.528900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<46.299100,0.000000,23.406100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.421900,0.000000,23.528900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.421900,0.000000,23.774700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<46.421900,0.000000,23.774700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.421900,0.000000,23.774700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.299100,0.000000,23.897500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<46.299100,0.000000,23.897500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.299100,0.000000,23.897500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.053300,0.000000,23.897500>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<46.053300,0.000000,23.897500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.053300,0.000000,23.897500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.930500,0.000000,23.774700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<45.930500,0.000000,23.774700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.930500,0.000000,23.774700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.930500,0.000000,23.528900>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<45.930500,0.000000,23.528900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<45.930500,0.000000,23.528900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.053300,0.000000,23.406100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<45.930500,0.000000,23.528900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.047500,0.000000,23.406100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.801700,0.000000,23.406100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<46.801700,0.000000,23.406100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.801700,0.000000,23.406100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.678900,0.000000,23.528900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<46.678900,0.000000,23.528900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.678900,0.000000,23.528900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.678900,0.000000,23.774700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<46.678900,0.000000,23.774700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.678900,0.000000,23.774700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.801700,0.000000,23.897500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<46.678900,0.000000,23.774700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.801700,0.000000,23.897500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.047500,0.000000,23.897500>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<46.801700,0.000000,23.897500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.047500,0.000000,23.897500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.170300,0.000000,23.774700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<47.047500,0.000000,23.897500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.170300,0.000000,23.774700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.170300,0.000000,23.651800>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,-90.000000,0> translate<47.170300,0.000000,23.651800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.170300,0.000000,23.651800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<46.678900,0.000000,23.651800>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<46.678900,0.000000,23.651800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.427300,0.000000,23.406100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.427300,0.000000,24.143300>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,90.000000,0> translate<47.427300,0.000000,24.143300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.795900,0.000000,23.406100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.427300,0.000000,23.651800>}
box{<0,0,-0.038100><0.442984,0.036000,0.038100> rotate<0,33.684257,0> translate<47.427300,0.000000,23.651800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.427300,0.000000,23.651800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<47.795900,0.000000,23.897500>}
box{<0,0,-0.038100><0.442984,0.036000,0.038100> rotate<0,-33.684257,0> translate<47.427300,0.000000,23.651800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.419500,0.000000,23.406100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.173700,0.000000,23.406100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<48.173700,0.000000,23.406100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.173700,0.000000,23.406100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.050900,0.000000,23.528900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<48.050900,0.000000,23.528900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.050900,0.000000,23.528900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.050900,0.000000,23.774700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<48.050900,0.000000,23.774700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.050900,0.000000,23.774700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.173700,0.000000,23.897500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<48.050900,0.000000,23.774700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.173700,0.000000,23.897500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.419500,0.000000,23.897500>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<48.173700,0.000000,23.897500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.419500,0.000000,23.897500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.542300,0.000000,23.774700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<48.419500,0.000000,23.897500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.542300,0.000000,23.774700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.542300,0.000000,23.651800>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,-90.000000,0> translate<48.542300,0.000000,23.651800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.542300,0.000000,23.651800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.050900,0.000000,23.651800>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,0.000000,0> translate<48.050900,0.000000,23.651800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.799300,0.000000,23.406100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.799300,0.000000,23.897500>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,90.000000,0> translate<48.799300,0.000000,23.897500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<48.799300,0.000000,23.897500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.167900,0.000000,23.897500>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,0.000000,0> translate<48.799300,0.000000,23.897500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.167900,0.000000,23.897500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.290700,0.000000,23.774700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<49.167900,0.000000,23.897500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.290700,0.000000,23.774700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<49.290700,0.000000,23.406100>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,-90.000000,0> translate<49.290700,0.000000,23.406100> }
difference{
cylinder{<41.706800,0,21.107400><41.706800,0.036000,21.107400>0.566300 translate<0,0.000000,0>}
cylinder{<41.706800,-0.1,21.107400><41.706800,0.135000,21.107400>0.439300 translate<0,0.000000,0>}}
//C1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.134800,0.000000,3.175000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.134800,0.000000,3.810000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<37.134800,0.000000,3.810000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.134800,0.000000,3.810000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.134800,0.000000,4.445000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<37.134800,0.000000,4.445000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.134800,0.000000,3.810000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.354000,0.000000,3.810000>}
box{<0,0,-0.076200><1.219200,0.036000,0.076200> rotate<0,0.000000,0> translate<37.134800,0.000000,3.810000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<36.499800,0.000000,3.175000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<36.499800,0.000000,3.810000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<36.499800,0.000000,3.810000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<36.499800,0.000000,3.810000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<36.499800,0.000000,4.445000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<36.499800,0.000000,4.445000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.499800,0.000000,3.810000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.306000,0.000000,3.810000>}
box{<0,0,-0.076200><1.193800,0.036000,0.076200> rotate<0,0.000000,0> translate<35.306000,0.000000,3.810000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.513000,0.000000,2.286000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.513000,0.000000,5.334000>}
box{<0,0,-0.076200><3.048000,0.036000,0.076200> rotate<0,90.000000,0> translate<40.513000,0.000000,5.334000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.259000,0.000000,5.588000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.401000,0.000000,5.588000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<33.401000,0.000000,5.588000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.147000,0.000000,5.334000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.147000,0.000000,2.286000>}
box{<0,0,-0.076200><3.048000,0.036000,0.076200> rotate<0,-90.000000,0> translate<33.147000,0.000000,2.286000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.401000,0.000000,2.032000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.259000,0.000000,2.032000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<33.401000,0.000000,2.032000> }
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<33.401000,0.000000,2.286000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<33.401000,0.000000,5.334000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<40.259000,0.000000,5.334000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<40.259000,0.000000,2.286000>}
//C2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<36.525200,0.000000,22.225000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<36.525200,0.000000,21.590000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<36.525200,0.000000,21.590000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<36.525200,0.000000,21.590000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<36.525200,0.000000,20.955000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<36.525200,0.000000,20.955000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.525200,0.000000,21.590000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.306000,0.000000,21.590000>}
box{<0,0,-0.076200><1.219200,0.036000,0.076200> rotate<0,0.000000,0> translate<35.306000,0.000000,21.590000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.160200,0.000000,22.225000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.160200,0.000000,21.590000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<37.160200,0.000000,21.590000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.160200,0.000000,21.590000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.160200,0.000000,20.955000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<37.160200,0.000000,20.955000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.160200,0.000000,21.590000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.354000,0.000000,21.590000>}
box{<0,0,-0.076200><1.193800,0.036000,0.076200> rotate<0,0.000000,0> translate<37.160200,0.000000,21.590000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.147000,0.000000,23.114000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.147000,0.000000,20.066000>}
box{<0,0,-0.076200><3.048000,0.036000,0.076200> rotate<0,-90.000000,0> translate<33.147000,0.000000,20.066000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.401000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.259000,0.000000,19.812000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<33.401000,0.000000,19.812000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.513000,0.000000,20.066000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.513000,0.000000,23.114000>}
box{<0,0,-0.076200><3.048000,0.036000,0.076200> rotate<0,90.000000,0> translate<40.513000,0.000000,23.114000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.259000,0.000000,23.368000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.401000,0.000000,23.368000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<33.401000,0.000000,23.368000> }
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<40.259000,0.000000,23.114000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<40.259000,0.000000,20.066000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<33.401000,0.000000,20.066000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<33.401000,0.000000,23.114000>}
//C3 silk screen
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<15.544800,0.000000,3.175000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<15.544800,0.000000,3.810000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<15.544800,0.000000,3.810000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<15.544800,0.000000,3.810000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<15.544800,0.000000,4.445000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<15.544800,0.000000,4.445000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.544800,0.000000,3.810000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.764000,0.000000,3.810000>}
box{<0,0,-0.076200><1.219200,0.036000,0.076200> rotate<0,0.000000,0> translate<15.544800,0.000000,3.810000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<14.909800,0.000000,3.175000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<14.909800,0.000000,3.810000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<14.909800,0.000000,3.810000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<14.909800,0.000000,3.810000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<14.909800,0.000000,4.445000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<14.909800,0.000000,4.445000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.909800,0.000000,3.810000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.716000,0.000000,3.810000>}
box{<0,0,-0.076200><1.193800,0.036000,0.076200> rotate<0,0.000000,0> translate<13.716000,0.000000,3.810000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.923000,0.000000,2.286000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.923000,0.000000,5.334000>}
box{<0,0,-0.076200><3.048000,0.036000,0.076200> rotate<0,90.000000,0> translate<18.923000,0.000000,5.334000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.669000,0.000000,5.588000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.811000,0.000000,5.588000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<11.811000,0.000000,5.588000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.557000,0.000000,5.334000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.557000,0.000000,2.286000>}
box{<0,0,-0.076200><3.048000,0.036000,0.076200> rotate<0,-90.000000,0> translate<11.557000,0.000000,2.286000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.811000,0.000000,2.032000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.669000,0.000000,2.032000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<11.811000,0.000000,2.032000> }
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<11.811000,0.000000,2.286000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<11.811000,0.000000,5.334000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<18.669000,0.000000,5.334000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<18.669000,0.000000,2.286000>}
//C4 silk screen
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<15.544800,0.000000,20.955000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<15.544800,0.000000,21.590000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<15.544800,0.000000,21.590000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<15.544800,0.000000,21.590000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<15.544800,0.000000,22.225000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<15.544800,0.000000,22.225000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<15.544800,0.000000,21.590000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<16.764000,0.000000,21.590000>}
box{<0,0,-0.076200><1.219200,0.036000,0.076200> rotate<0,0.000000,0> translate<15.544800,0.000000,21.590000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<14.909800,0.000000,20.955000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<14.909800,0.000000,21.590000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<14.909800,0.000000,21.590000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<14.909800,0.000000,21.590000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<14.909800,0.000000,22.225000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<14.909800,0.000000,22.225000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<14.909800,0.000000,21.590000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<13.716000,0.000000,21.590000>}
box{<0,0,-0.076200><1.193800,0.036000,0.076200> rotate<0,0.000000,0> translate<13.716000,0.000000,21.590000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.923000,0.000000,20.066000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.923000,0.000000,23.114000>}
box{<0,0,-0.076200><3.048000,0.036000,0.076200> rotate<0,90.000000,0> translate<18.923000,0.000000,23.114000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.669000,0.000000,23.368000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.811000,0.000000,23.368000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<11.811000,0.000000,23.368000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.557000,0.000000,23.114000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.557000,0.000000,20.066000>}
box{<0,0,-0.076200><3.048000,0.036000,0.076200> rotate<0,-90.000000,0> translate<11.557000,0.000000,20.066000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.811000,0.000000,19.812000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<18.669000,0.000000,19.812000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<11.811000,0.000000,19.812000> }
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<11.811000,0.000000,20.066000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<11.811000,0.000000,23.114000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<18.669000,0.000000,23.114000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<18.669000,0.000000,20.066000>}
//OK1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.321000,0.000000,2.540000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.321000,0.000000,12.700000>}
box{<0,0,-0.076200><10.160000,0.036000,0.076200> rotate<0,90.000000,0> translate<28.321000,0.000000,12.700000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.479000,0.000000,12.700000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.479000,0.000000,2.540000>}
box{<0,0,-0.076200><10.160000,0.036000,0.076200> rotate<0,-90.000000,0> translate<22.479000,0.000000,2.540000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.321000,0.000000,2.540000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.479000,0.000000,2.540000>}
box{<0,0,-0.076200><5.842000,0.036000,0.076200> rotate<0,0.000000,0> translate<22.479000,0.000000,2.540000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.321000,0.000000,12.700000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.416000,0.000000,12.700000>}
box{<0,0,-0.076200><1.905000,0.036000,0.076200> rotate<0,0.000000,0> translate<26.416000,0.000000,12.700000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.479000,0.000000,12.700000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.384000,0.000000,12.700000>}
box{<0,0,-0.076200><1.905000,0.036000,0.076200> rotate<0,0.000000,0> translate<22.479000,0.000000,12.700000> }
object{ARC(1.016000,0.152400,180.000000,360.000000,0.036000) translate<25.400000,0.000000,12.700000>}
//OK2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.321000,0.000000,12.700000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.321000,0.000000,22.860000>}
box{<0,0,-0.076200><10.160000,0.036000,0.076200> rotate<0,90.000000,0> translate<28.321000,0.000000,22.860000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.479000,0.000000,22.860000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.479000,0.000000,12.700000>}
box{<0,0,-0.076200><10.160000,0.036000,0.076200> rotate<0,-90.000000,0> translate<22.479000,0.000000,12.700000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.321000,0.000000,12.700000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.479000,0.000000,12.700000>}
box{<0,0,-0.076200><5.842000,0.036000,0.076200> rotate<0,0.000000,0> translate<22.479000,0.000000,12.700000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.321000,0.000000,22.860000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.416000,0.000000,22.860000>}
box{<0,0,-0.076200><1.905000,0.036000,0.076200> rotate<0,0.000000,0> translate<26.416000,0.000000,22.860000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.479000,0.000000,22.860000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.384000,0.000000,22.860000>}
box{<0,0,-0.076200><1.905000,0.036000,0.076200> rotate<0,0.000000,0> translate<22.479000,0.000000,22.860000> }
object{ARC(1.016000,0.152400,180.000000,360.000000,0.036000) translate<25.400000,0.000000,22.860000>}
//R1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<13.970000,0.000000,11.430000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<14.859000,0.000000,11.430000>}
box{<0,0,-0.304800><0.889000,0.036000,0.304800> rotate<0,0.000000,0> translate<13.970000,0.000000,11.430000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<14.986000,0.000000,11.430000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<15.494000,0.000000,11.430000>}
box{<0,0,-0.304800><0.508000,0.036000,0.304800> rotate<0,0.000000,0> translate<14.986000,0.000000,11.430000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<15.621000,0.000000,11.430000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<16.510000,0.000000,11.430000>}
box{<0,0,-0.304800><0.889000,0.036000,0.304800> rotate<0,0.000000,0> translate<15.621000,0.000000,11.430000> }
difference{
cylinder{<13.970000,0,11.430000><13.970000,0.036000,11.430000>1.346200 translate<0,0.000000,0>}
cylinder{<13.970000,-0.1,11.430000><13.970000,0.135000,11.430000>1.193800 translate<0,0.000000,0>}}
difference{
cylinder{<13.970000,0,11.430000><13.970000,0.036000,11.430000>1.092200 translate<0,0.000000,0>}
cylinder{<13.970000,-0.1,11.430000><13.970000,0.135000,11.430000>0.939800 translate<0,0.000000,0>}}
//R2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<13.970000,0.000000,8.890000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<14.859000,0.000000,8.890000>}
box{<0,0,-0.304800><0.889000,0.036000,0.304800> rotate<0,0.000000,0> translate<13.970000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<14.986000,0.000000,8.890000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<15.494000,0.000000,8.890000>}
box{<0,0,-0.304800><0.508000,0.036000,0.304800> rotate<0,0.000000,0> translate<14.986000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<15.621000,0.000000,8.890000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<16.510000,0.000000,8.890000>}
box{<0,0,-0.304800><0.889000,0.036000,0.304800> rotate<0,0.000000,0> translate<15.621000,0.000000,8.890000> }
difference{
cylinder{<13.970000,0,8.890000><13.970000,0.036000,8.890000>1.346200 translate<0,0.000000,0>}
cylinder{<13.970000,-0.1,8.890000><13.970000,0.135000,8.890000>1.193800 translate<0,0.000000,0>}}
difference{
cylinder{<13.970000,0,8.890000><13.970000,0.036000,8.890000>1.092200 translate<0,0.000000,0>}
cylinder{<13.970000,-0.1,8.890000><13.970000,0.135000,8.890000>0.939800 translate<0,0.000000,0>}}
//R3 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<34.290000,0.000000,11.430000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<35.179000,0.000000,11.430000>}
box{<0,0,-0.304800><0.889000,0.036000,0.304800> rotate<0,0.000000,0> translate<34.290000,0.000000,11.430000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<35.306000,0.000000,11.430000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<35.814000,0.000000,11.430000>}
box{<0,0,-0.304800><0.508000,0.036000,0.304800> rotate<0,0.000000,0> translate<35.306000,0.000000,11.430000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<35.941000,0.000000,11.430000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<36.830000,0.000000,11.430000>}
box{<0,0,-0.304800><0.889000,0.036000,0.304800> rotate<0,0.000000,0> translate<35.941000,0.000000,11.430000> }
difference{
cylinder{<34.290000,0,11.430000><34.290000,0.036000,11.430000>1.346200 translate<0,0.000000,0>}
cylinder{<34.290000,-0.1,11.430000><34.290000,0.135000,11.430000>1.193800 translate<0,0.000000,0>}}
difference{
cylinder{<34.290000,0,11.430000><34.290000,0.036000,11.430000>1.092200 translate<0,0.000000,0>}
cylinder{<34.290000,-0.1,11.430000><34.290000,0.135000,11.430000>0.939800 translate<0,0.000000,0>}}
//R4 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<34.290000,0.000000,8.890000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<35.179000,0.000000,8.890000>}
box{<0,0,-0.304800><0.889000,0.036000,0.304800> rotate<0,0.000000,0> translate<34.290000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<35.306000,0.000000,8.890000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<35.814000,0.000000,8.890000>}
box{<0,0,-0.304800><0.508000,0.036000,0.304800> rotate<0,0.000000,0> translate<35.306000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<35.941000,0.000000,8.890000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<36.830000,0.000000,8.890000>}
box{<0,0,-0.304800><0.889000,0.036000,0.304800> rotate<0,0.000000,0> translate<35.941000,0.000000,8.890000> }
difference{
cylinder{<34.290000,0,8.890000><34.290000,0.036000,8.890000>1.346200 translate<0,0.000000,0>}
cylinder{<34.290000,-0.1,8.890000><34.290000,0.135000,8.890000>1.193800 translate<0,0.000000,0>}}
difference{
cylinder{<34.290000,0,8.890000><34.290000,0.036000,8.890000>1.092200 translate<0,0.000000,0>}
cylinder{<34.290000,-0.1,8.890000><34.290000,0.135000,8.890000>0.939800 translate<0,0.000000,0>}}
//R5 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<13.970000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<14.859000,0.000000,16.510000>}
box{<0,0,-0.304800><0.889000,0.036000,0.304800> rotate<0,0.000000,0> translate<13.970000,0.000000,16.510000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<14.986000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<15.494000,0.000000,16.510000>}
box{<0,0,-0.304800><0.508000,0.036000,0.304800> rotate<0,0.000000,0> translate<14.986000,0.000000,16.510000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<15.621000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<16.510000,0.000000,16.510000>}
box{<0,0,-0.304800><0.889000,0.036000,0.304800> rotate<0,0.000000,0> translate<15.621000,0.000000,16.510000> }
difference{
cylinder{<13.970000,0,16.510000><13.970000,0.036000,16.510000>1.346200 translate<0,0.000000,0>}
cylinder{<13.970000,-0.1,16.510000><13.970000,0.135000,16.510000>1.193800 translate<0,0.000000,0>}}
difference{
cylinder{<13.970000,0,16.510000><13.970000,0.036000,16.510000>1.092200 translate<0,0.000000,0>}
cylinder{<13.970000,-0.1,16.510000><13.970000,0.135000,16.510000>0.939800 translate<0,0.000000,0>}}
//R6 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<13.970000,0.000000,13.970000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<14.859000,0.000000,13.970000>}
box{<0,0,-0.304800><0.889000,0.036000,0.304800> rotate<0,0.000000,0> translate<13.970000,0.000000,13.970000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<14.986000,0.000000,13.970000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<15.494000,0.000000,13.970000>}
box{<0,0,-0.304800><0.508000,0.036000,0.304800> rotate<0,0.000000,0> translate<14.986000,0.000000,13.970000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<15.621000,0.000000,13.970000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<16.510000,0.000000,13.970000>}
box{<0,0,-0.304800><0.889000,0.036000,0.304800> rotate<0,0.000000,0> translate<15.621000,0.000000,13.970000> }
difference{
cylinder{<13.970000,0,13.970000><13.970000,0.036000,13.970000>1.346200 translate<0,0.000000,0>}
cylinder{<13.970000,-0.1,13.970000><13.970000,0.135000,13.970000>1.193800 translate<0,0.000000,0>}}
difference{
cylinder{<13.970000,0,13.970000><13.970000,0.036000,13.970000>1.092200 translate<0,0.000000,0>}
cylinder{<13.970000,-0.1,13.970000><13.970000,0.135000,13.970000>0.939800 translate<0,0.000000,0>}}
//R7 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<34.290000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<35.179000,0.000000,16.510000>}
box{<0,0,-0.304800><0.889000,0.036000,0.304800> rotate<0,0.000000,0> translate<34.290000,0.000000,16.510000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<35.306000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<35.814000,0.000000,16.510000>}
box{<0,0,-0.304800><0.508000,0.036000,0.304800> rotate<0,0.000000,0> translate<35.306000,0.000000,16.510000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<35.941000,0.000000,16.510000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<36.830000,0.000000,16.510000>}
box{<0,0,-0.304800><0.889000,0.036000,0.304800> rotate<0,0.000000,0> translate<35.941000,0.000000,16.510000> }
difference{
cylinder{<34.290000,0,16.510000><34.290000,0.036000,16.510000>1.346200 translate<0,0.000000,0>}
cylinder{<34.290000,-0.1,16.510000><34.290000,0.135000,16.510000>1.193800 translate<0,0.000000,0>}}
difference{
cylinder{<34.290000,0,16.510000><34.290000,0.036000,16.510000>1.092200 translate<0,0.000000,0>}
cylinder{<34.290000,-0.1,16.510000><34.290000,0.135000,16.510000>0.939800 translate<0,0.000000,0>}}
//R8 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<34.290000,0.000000,13.970000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<35.179000,0.000000,13.970000>}
box{<0,0,-0.304800><0.889000,0.036000,0.304800> rotate<0,0.000000,0> translate<34.290000,0.000000,13.970000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<35.306000,0.000000,13.970000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<35.814000,0.000000,13.970000>}
box{<0,0,-0.304800><0.508000,0.036000,0.304800> rotate<0,0.000000,0> translate<35.306000,0.000000,13.970000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<35.941000,0.000000,13.970000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<36.830000,0.000000,13.970000>}
box{<0,0,-0.304800><0.889000,0.036000,0.304800> rotate<0,0.000000,0> translate<35.941000,0.000000,13.970000> }
difference{
cylinder{<34.290000,0,13.970000><34.290000,0.036000,13.970000>1.346200 translate<0,0.000000,0>}
cylinder{<34.290000,-0.1,13.970000><34.290000,0.135000,13.970000>1.193800 translate<0,0.000000,0>}}
difference{
cylinder{<34.290000,0,13.970000><34.290000,0.036000,13.970000>1.092200 translate<0,0.000000,0>}
cylinder{<34.290000,-0.1,13.970000><34.290000,0.135000,13.970000>0.939800 translate<0,0.000000,0>}}
//SV1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.895000,0.000000,18.796000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.895000,0.000000,6.096000>}
box{<0,0,-0.076200><12.700000,0.036000,0.076200> rotate<0,-90.000000,0> translate<48.895000,0.000000,6.096000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.545000,0.000000,6.096000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.895000,0.000000,6.096000>}
box{<0,0,-0.076200><6.350000,0.036000,0.076200> rotate<0,0.000000,0> translate<42.545000,0.000000,6.096000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.895000,0.000000,18.796000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.545000,0.000000,18.796000>}
box{<0,0,-0.076200><6.350000,0.036000,0.076200> rotate<0,0.000000,0> translate<42.545000,0.000000,18.796000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.165000,0.000000,20.066000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.165000,0.000000,18.796000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<50.165000,0.000000,18.796000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,4.826000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.165000,0.000000,4.826000>}
box{<0,0,-0.076200><8.890000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.275000,0.000000,4.826000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.165000,0.000000,20.066000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,20.066000>}
box{<0,0,-0.076200><8.890000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.275000,0.000000,20.066000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.307000,0.000000,10.414000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.545000,0.000000,10.414000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<42.545000,0.000000,10.414000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.307000,0.000000,10.414000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.307000,0.000000,14.478000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<43.307000,0.000000,14.478000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.545000,0.000000,14.478000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.307000,0.000000,14.478000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<42.545000,0.000000,14.478000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.545000,0.000000,14.478000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.545000,0.000000,18.796000>}
box{<0,0,-0.076200><4.318000,0.036000,0.076200> rotate<0,90.000000,0> translate<42.545000,0.000000,18.796000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.545000,0.000000,14.478000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.291000,0.000000,14.478000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<42.291000,0.000000,14.478000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.165000,0.000000,6.096000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.419000,0.000000,6.096000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<50.165000,0.000000,6.096000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.419000,0.000000,6.096000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.419000,0.000000,7.366000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<50.419000,0.000000,7.366000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.165000,0.000000,7.366000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.419000,0.000000,7.366000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<50.165000,0.000000,7.366000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.165000,0.000000,6.096000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.165000,0.000000,4.826000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<50.165000,0.000000,4.826000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.419000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.419000,0.000000,13.081000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<50.419000,0.000000,13.081000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.419000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.165000,0.000000,11.811000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<50.165000,0.000000,11.811000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.165000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.165000,0.000000,7.366000>}
box{<0,0,-0.076200><4.445000,0.036000,0.076200> rotate<0,-90.000000,0> translate<50.165000,0.000000,7.366000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.419000,0.000000,13.081000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.165000,0.000000,13.081000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<50.165000,0.000000,13.081000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.419000,0.000000,17.526000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.419000,0.000000,18.796000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<50.419000,0.000000,18.796000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.419000,0.000000,18.796000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.165000,0.000000,18.796000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<50.165000,0.000000,18.796000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.419000,0.000000,17.526000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.165000,0.000000,17.526000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<50.165000,0.000000,17.526000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.165000,0.000000,17.526000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.165000,0.000000,13.081000>}
box{<0,0,-0.076200><4.445000,0.036000,0.076200> rotate<0,-90.000000,0> translate<50.165000,0.000000,13.081000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,4.826000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,10.414000>}
box{<0,0,-0.076200><5.588000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.275000,0.000000,10.414000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,10.414000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,14.478000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.275000,0.000000,14.478000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.545000,0.000000,6.096000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.545000,0.000000,10.414000>}
box{<0,0,-0.076200><4.318000,0.036000,0.076200> rotate<0,90.000000,0> translate<42.545000,0.000000,10.414000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.545000,0.000000,10.414000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.291000,0.000000,10.414000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<42.291000,0.000000,10.414000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.291000,0.000000,10.414000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,10.414000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.275000,0.000000,10.414000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<42.291000,0.000000,10.414000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<42.291000,0.000000,5.842000>}
box{<0,0,-0.025400><4.572000,0.036000,0.025400> rotate<0,-90.000000,0> translate<42.291000,0.000000,5.842000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<42.291000,0.000000,5.842000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<49.149000,0.000000,5.842000>}
box{<0,0,-0.025400><6.858000,0.036000,0.025400> rotate<0,0.000000,0> translate<42.291000,0.000000,5.842000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<49.149000,0.000000,5.842000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<49.149000,0.000000,19.050000>}
box{<0,0,-0.025400><13.208000,0.036000,0.025400> rotate<0,90.000000,0> translate<49.149000,0.000000,19.050000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<49.149000,0.000000,19.050000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<42.291000,0.000000,19.050000>}
box{<0,0,-0.025400><6.858000,0.036000,0.025400> rotate<0,0.000000,0> translate<42.291000,0.000000,19.050000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<42.291000,0.000000,19.050000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<42.291000,0.000000,14.478000>}
box{<0,0,-0.025400><4.572000,0.036000,0.025400> rotate<0,-90.000000,0> translate<42.291000,0.000000,14.478000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.291000,0.000000,14.478000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,14.478000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.275000,0.000000,14.478000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,14.478000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,14.986000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.275000,0.000000,14.986000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,14.986000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,14.986000>}
box{<0,0,-0.076200><0.127000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.275000,0.000000,14.986000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,14.986000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,16.256000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.402000,0.000000,16.256000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,16.256000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,16.256000>}
box{<0,0,-0.076200><0.127000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.275000,0.000000,16.256000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,16.256000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.275000,0.000000,20.066000>}
box{<0,0,-0.076200><3.810000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.275000,0.000000,20.066000> }
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-270.000000,0> translate<46.990000,0.000000,12.446000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-270.000000,0> translate<46.990000,0.000000,14.986000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-270.000000,0> translate<46.990000,0.000000,9.906000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-270.000000,0> translate<44.450000,0.000000,12.446000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-270.000000,0> translate<44.450000,0.000000,14.986000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-270.000000,0> translate<44.450000,0.000000,9.906000>}
//SV2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.429000,0.000000,6.096000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.429000,0.000000,18.796000>}
box{<0,0,-0.076200><12.700000,0.036000,0.076200> rotate<0,90.000000,0> translate<3.429000,0.000000,18.796000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.779000,0.000000,18.796000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.429000,0.000000,18.796000>}
box{<0,0,-0.076200><6.350000,0.036000,0.076200> rotate<0,0.000000,0> translate<3.429000,0.000000,18.796000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<3.429000,0.000000,6.096000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.779000,0.000000,6.096000>}
box{<0,0,-0.076200><6.350000,0.036000,0.076200> rotate<0,0.000000,0> translate<3.429000,0.000000,6.096000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<2.159000,0.000000,4.826000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<2.159000,0.000000,6.096000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<2.159000,0.000000,6.096000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.049000,0.000000,20.066000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<2.159000,0.000000,20.066000>}
box{<0,0,-0.076200><8.890000,0.036000,0.076200> rotate<0,0.000000,0> translate<2.159000,0.000000,20.066000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<2.159000,0.000000,4.826000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.049000,0.000000,4.826000>}
box{<0,0,-0.076200><8.890000,0.036000,0.076200> rotate<0,0.000000,0> translate<2.159000,0.000000,4.826000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.017000,0.000000,14.478000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.779000,0.000000,14.478000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<9.017000,0.000000,14.478000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.017000,0.000000,14.478000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.017000,0.000000,10.414000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,-90.000000,0> translate<9.017000,0.000000,10.414000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.779000,0.000000,10.414000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.017000,0.000000,10.414000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<9.017000,0.000000,10.414000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.779000,0.000000,10.414000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.779000,0.000000,6.096000>}
box{<0,0,-0.076200><4.318000,0.036000,0.076200> rotate<0,-90.000000,0> translate<9.779000,0.000000,6.096000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.779000,0.000000,10.414000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.033000,0.000000,10.414000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<9.779000,0.000000,10.414000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<2.159000,0.000000,18.796000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<1.905000,0.000000,18.796000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<1.905000,0.000000,18.796000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<1.905000,0.000000,18.796000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<1.905000,0.000000,17.526000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<1.905000,0.000000,17.526000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<2.159000,0.000000,17.526000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<1.905000,0.000000,17.526000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<1.905000,0.000000,17.526000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<2.159000,0.000000,18.796000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<2.159000,0.000000,20.066000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<2.159000,0.000000,20.066000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<1.905000,0.000000,13.081000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<1.905000,0.000000,11.811000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<1.905000,0.000000,11.811000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<1.905000,0.000000,13.081000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<2.159000,0.000000,13.081000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<1.905000,0.000000,13.081000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<2.159000,0.000000,13.081000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<2.159000,0.000000,17.526000>}
box{<0,0,-0.076200><4.445000,0.036000,0.076200> rotate<0,90.000000,0> translate<2.159000,0.000000,17.526000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<1.905000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<2.159000,0.000000,11.811000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<1.905000,0.000000,11.811000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<1.905000,0.000000,7.366000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<1.905000,0.000000,6.096000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<1.905000,0.000000,6.096000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<1.905000,0.000000,6.096000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<2.159000,0.000000,6.096000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<1.905000,0.000000,6.096000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<1.905000,0.000000,7.366000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<2.159000,0.000000,7.366000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<1.905000,0.000000,7.366000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<2.159000,0.000000,7.366000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<2.159000,0.000000,11.811000>}
box{<0,0,-0.076200><4.445000,0.036000,0.076200> rotate<0,90.000000,0> translate<2.159000,0.000000,11.811000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.049000,0.000000,20.066000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.049000,0.000000,14.478000>}
box{<0,0,-0.076200><5.588000,0.036000,0.076200> rotate<0,-90.000000,0> translate<11.049000,0.000000,14.478000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.049000,0.000000,14.478000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.049000,0.000000,10.414000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,-90.000000,0> translate<11.049000,0.000000,10.414000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.779000,0.000000,18.796000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.779000,0.000000,14.478000>}
box{<0,0,-0.076200><4.318000,0.036000,0.076200> rotate<0,-90.000000,0> translate<9.779000,0.000000,14.478000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<9.779000,0.000000,14.478000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.033000,0.000000,14.478000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<9.779000,0.000000,14.478000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.033000,0.000000,14.478000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.049000,0.000000,14.478000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<10.033000,0.000000,14.478000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.033000,0.000000,14.478000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.033000,0.000000,19.050000>}
box{<0,0,-0.025400><4.572000,0.036000,0.025400> rotate<0,90.000000,0> translate<10.033000,0.000000,19.050000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.033000,0.000000,19.050000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<3.175000,0.000000,19.050000>}
box{<0,0,-0.025400><6.858000,0.036000,0.025400> rotate<0,0.000000,0> translate<3.175000,0.000000,19.050000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<3.175000,0.000000,19.050000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<3.175000,0.000000,5.842000>}
box{<0,0,-0.025400><13.208000,0.036000,0.025400> rotate<0,-90.000000,0> translate<3.175000,0.000000,5.842000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<3.175000,0.000000,5.842000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.033000,0.000000,5.842000>}
box{<0,0,-0.025400><6.858000,0.036000,0.025400> rotate<0,0.000000,0> translate<3.175000,0.000000,5.842000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.033000,0.000000,5.842000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.033000,0.000000,10.414000>}
box{<0,0,-0.025400><4.572000,0.036000,0.025400> rotate<0,90.000000,0> translate<10.033000,0.000000,10.414000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.033000,0.000000,10.414000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.049000,0.000000,10.414000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<10.033000,0.000000,10.414000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.049000,0.000000,10.414000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.049000,0.000000,9.906000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,-90.000000,0> translate<11.049000,0.000000,9.906000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.922000,0.000000,9.906000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.049000,0.000000,9.906000>}
box{<0,0,-0.076200><0.127000,0.036000,0.076200> rotate<0,0.000000,0> translate<10.922000,0.000000,9.906000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.922000,0.000000,9.906000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.922000,0.000000,8.636000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<10.922000,0.000000,8.636000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.049000,0.000000,8.636000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<10.922000,0.000000,8.636000>}
box{<0,0,-0.076200><0.127000,0.036000,0.076200> rotate<0,0.000000,0> translate<10.922000,0.000000,8.636000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.049000,0.000000,8.636000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<11.049000,0.000000,4.826000>}
box{<0,0,-0.076200><3.810000,0.036000,0.076200> rotate<0,-90.000000,0> translate<11.049000,0.000000,4.826000> }
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-90.000000,0> translate<5.334000,0.000000,12.446000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-90.000000,0> translate<5.334000,0.000000,9.906000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-90.000000,0> translate<5.334000,0.000000,14.986000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-90.000000,0> translate<7.874000,0.000000,12.446000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-90.000000,0> translate<7.874000,0.000000,9.906000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-90.000000,0> translate<7.874000,0.000000,14.986000>}
texture{col_slk}
}
#end
translate<mac_x_ver,mac_y_ver,mac_z_ver>
rotate<mac_x_rot,mac_y_rot,mac_z_rot>
}//End union
#end

#if(use_file_as_inc=off)
object{  OPTO_ISOLATOR(-26.149300,0,-12.700000,pcb_rotate_x,pcb_rotate_y,pcb_rotate_z)
#if(pcb_upsidedown=on)
rotate pcb_rotdir*180
#end
}
#end


//Parts not found in 3dpack.dat or 3dusrpac.dat are:
