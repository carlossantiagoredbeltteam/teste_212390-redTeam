//POVRay-File created by 3d41.ulp v1.05
///home/hoeken/Desktop/reprap/trunk/reprap/electronics/Arduino/opto_endstop/opto_endstop.brd
//9/2/08 9:19 PM

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
#local cam_y = 124;
#local cam_z = -37;
#local cam_a = 20;
#local cam_look_x = 0;
#local cam_look_y = -1;
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

#local lgt1_pos_x = 14;
#local lgt1_pos_y = 22;
#local lgt1_pos_z = 8;
#local lgt1_intense = 0.709144;
#local lgt2_pos_x = -14;
#local lgt2_pos_y = 22;
#local lgt2_pos_z = 8;
#local lgt2_intense = 0.709144;
#local lgt3_pos_x = 14;
#local lgt3_pos_y = 22;
#local lgt3_pos_z = -5;
#local lgt3_intense = 0.709144;
#local lgt4_pos_x = -14;
#local lgt4_pos_y = 22;
#local lgt4_pos_z = -5;
#local lgt4_intense = 0.709144;

//Do not change these values
#declare pcb_height = 1.500000;
#declare pcb_cuheight = 0.035000;
#declare pcb_x_size = 38.913000;
#declare pcb_y_size = 16.449200;
#declare pcb_layer1_used = 1;
#declare pcb_layer16_used = 1;
#declare inc_testmode = off;
#declare global_seed=seed(535);
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
	//translate<-19.456500,0,-8.224600>
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


#macro OPTO_ENDSTOP(mac_x_ver,mac_y_ver,mac_z_ver,mac_x_rot,mac_y_rot,mac_z_rot)
union{
#if(pcb_board = on)
difference{
union{
//Board
prism{-1.500000,0.000000,8
<5.016400,0.182800><43.929400,0.182800>
<43.929400,0.182800><43.929400,16.632000>
<43.929400,16.632000><5.016400,16.632000>
<5.016400,16.632000><5.016400,0.182800>
texture{col_brd}}
}//End union(Platine)
//Holes(real)/Parts
cylinder{<41.402000,1,2.667000><41.402000,-5,2.667000>1.625600 texture{col_hls}}
cylinder{<41.402000,1,14.097000><41.402000,-5,14.097000>1.625600 texture{col_hls}}
cylinder{<7.823200,1,3.429000><7.823200,-5,3.429000>1.689100 texture{col_hls}}
cylinder{<27.025600,1,3.429000><27.025600,-5,3.429000>1.689100 texture{col_hls}}
//Holes(real)/Board
//Holes(real)/Vias
}//End difference(reale Bohrungen/Durchbrüche)
#end
#if(pcb_parts=on)//Parts
union{
#ifndef(pack_LED1) #declare global_pack_LED1=yes; object {DIODE_DIS_LED_3MM(Red,0.500000,0.000000,)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<7.620000,0.000000,9.398000>}#end		//Diskrete 3MM LED LED1  LED3MM
#ifndef(pack_R1) #declare global_pack_R1=yes; object {RES_DIS_0207_075MM(texture{pigment{DarkBrown}finish{phong 0.2}},texture{pigment{Black}finish{phong 0.2}},texture{pigment{Orange}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-270.000000,0> rotate<0,0,0> translate<28.143200,0.000000,11.455400>}#end		//Discrete Resistor 0,3W 7,5MM Grid R1 10K 0207/7
#ifndef(pack_R2) #declare global_pack_R2=yes; object {RES_DIS_0207_075MM(texture{pigment{Red*0.7}finish{phong 0.2}},texture{pigment{Red*0.7}finish{phong 0.2}},texture{pigment{DarkBrown}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-270.000000,0> rotate<0,0,0> translate<25.171400,0.000000,11.430000>}#end		//Discrete Resistor 0,3W 7,5MM Grid R2 220 0207/7
#ifndef(pack_R3) #declare global_pack_R3=yes; object {RES_DIS_0207_075MM(texture{pigment{DarkBrown}finish{phong 0.2}},texture{pigment{Black}finish{phong 0.2}},texture{pigment{Red*0.7}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-270.000000,0> rotate<0,0,0> translate<22.098000,0.000000,11.430000>}#end		//Discrete Resistor 0,3W 7,5MM Grid R3 1K 0207/7
}//End union
#end
#if(pcb_pads_smds=on)
//Pads&SMD/Parts
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<35.052000,0,3.937000> texture{col_thl}}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<32.512000,0,5.207000> texture{col_thl}}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<35.052000,0,6.477000> texture{col_thl}}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<32.512000,0,7.747000> texture{col_thl}}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<35.052000,0,9.017000> texture{col_thl}}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<32.512000,0,10.287000> texture{col_thl}}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<35.052000,0,11.557000> texture{col_thl}}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<32.512000,0,12.827000> texture{col_thl}}
#ifndef(global_pack_LED1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<7.620000,0,8.128000> texture{col_thl}}
#ifndef(global_pack_LED1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<7.620000,0,10.668000> texture{col_thl}}
#ifndef(global_pack_R1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<28.143200,0,15.265400> texture{col_thl}}
#ifndef(global_pack_R1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<28.143200,0,7.645400> texture{col_thl}}
#ifndef(global_pack_R2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<25.171400,0,15.240000> texture{col_thl}}
#ifndef(global_pack_R2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<25.171400,0,7.620000> texture{col_thl}}
#ifndef(global_pack_R3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<22.098000,0,15.240000> texture{col_thl}}
#ifndef(global_pack_R3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<22.098000,0,7.620000> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<14.249400,0,4.826000> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<14.249400,0,2.032000> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<20.599400,0,2.032000> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<21.996400,0,3.429000> texture{col_thl}}
#ifndef(global_pack_U_1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.308000,0.800000,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<20.599400,0,4.826000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.508000,1.000000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<39.116000,0,5.842000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.508000,1.000000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<39.116000,0,8.382000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.508000,1.000000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<39.116000,0,10.922000> texture{col_thl}}
//Pads/Vias
object{TOOLS_PCB_VIA(0.906400,0.500000,1,16,1,0) translate<24.130000,0,3.429000> texture{col_thl}}
#end
#if(pcb_wires=on)
union{
//Signals
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<7.620000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.128000,0.000000,7.874000>}
box{<0,0,-0.203200><0.567961,0.035000,0.203200> rotate<0,26.563298,0> translate<7.620000,0.000000,8.128000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<7.620000,-1.535000,10.668000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.128000,-1.535000,10.922000>}
box{<0,0,-0.203200><0.567961,0.035000,0.203200> rotate<0,-26.563298,0> translate<7.620000,-1.535000,10.668000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.128000,0.000000,7.874000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.478000,0.000000,7.874000>}
box{<0,0,-0.203200><6.350000,0.035000,0.203200> rotate<0,0.000000,0> translate<8.128000,0.000000,7.874000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.249400,-1.535000,2.032000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.732000,-1.535000,2.286000>}
box{<0,0,-0.203200><0.545361,0.035000,0.203200> rotate<0,-27.756709,0> translate<14.249400,-1.535000,2.032000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.249400,-1.535000,4.826000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.732000,-1.535000,5.080000>}
box{<0,0,-0.203200><0.545361,0.035000,0.203200> rotate<0,-27.756709,0> translate<14.249400,-1.535000,4.826000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.128000,-1.535000,10.922000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<17.526000,-1.535000,10.922000>}
box{<0,0,-0.203200><9.398000,0.035000,0.203200> rotate<0,0.000000,0> translate<8.128000,-1.535000,10.922000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.732000,-1.535000,2.286000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<17.780000,-1.535000,2.286000>}
box{<0,0,-0.203200><3.048000,0.035000,0.203200> rotate<0,0.000000,0> translate<14.732000,-1.535000,2.286000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.478000,0.000000,7.874000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.066000,0.000000,2.286000>}
box{<0,0,-0.203200><7.902625,0.035000,0.203200> rotate<0,44.997030,0> translate<14.478000,0.000000,7.874000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<17.780000,-1.535000,2.286000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.066000,-1.535000,4.572000>}
box{<0,0,-0.203200><3.232892,0.035000,0.203200> rotate<0,-44.997030,0> translate<17.780000,-1.535000,2.286000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.066000,0.000000,2.286000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.599400,0.000000,2.032000>}
box{<0,0,-0.203200><0.590789,0.035000,0.203200> rotate<0,25.461665,0> translate<20.066000,0.000000,2.286000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.066000,-1.535000,4.572000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.599400,-1.535000,4.826000>}
box{<0,0,-0.203200><0.590789,0.035000,0.203200> rotate<0,-25.461665,0> translate<20.066000,-1.535000,4.572000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.599400,-1.535000,4.826000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.828000,-1.535000,5.334000>}
box{<0,0,-0.203200><0.557065,0.035000,0.203200> rotate<0,-65.767914,0> translate<20.599400,-1.535000,4.826000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.828000,-1.535000,5.334000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.828000,-1.535000,8.382000>}
box{<0,0,-0.203200><3.048000,0.035000,0.203200> rotate<0,90.000000,0> translate<20.828000,-1.535000,8.382000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<17.526000,-1.535000,10.922000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.590000,-1.535000,14.986000>}
box{<0,0,-0.203200><5.747364,0.035000,0.203200> rotate<0,-44.997030,0> translate<17.526000,-1.535000,10.922000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.996400,0.000000,3.429000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.098000,0.000000,4.064000>}
box{<0,0,-0.203200><0.643077,0.035000,0.203200> rotate<0,-80.904383,0> translate<21.996400,0.000000,3.429000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.098000,0.000000,4.064000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.098000,0.000000,7.620000>}
box{<0,0,-0.203200><3.556000,0.035000,0.203200> rotate<0,90.000000,0> translate<22.098000,0.000000,7.620000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.590000,-1.535000,14.986000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.098000,-1.535000,15.240000>}
box{<0,0,-0.203200><0.567961,0.035000,0.203200> rotate<0,-26.563298,0> translate<21.590000,-1.535000,14.986000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.599400,0.000000,2.032000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.606000,0.000000,2.032000>}
box{<0,0,-0.203200><2.006600,0.035000,0.203200> rotate<0,0.000000,0> translate<20.599400,0.000000,2.032000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.098000,0.000000,7.620000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.606000,0.000000,7.874000>}
box{<0,0,-0.203200><0.567961,0.035000,0.203200> rotate<0,-26.563298,0> translate<22.098000,0.000000,7.620000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.606000,0.000000,2.032000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.130000,0.000000,3.302000>}
box{<0,0,-0.203200><1.983803,0.035000,0.203200> rotate<0,-39.802944,0> translate<22.606000,0.000000,2.032000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.130000,0.000000,3.302000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.130000,0.000000,3.429000>}
box{<0,0,-0.203200><0.127000,0.035000,0.203200> rotate<0,90.000000,0> translate<24.130000,0.000000,3.429000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.130000,0.000000,3.429000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.130000,0.000000,6.096000>}
box{<0,0,-0.203200><2.667000,0.035000,0.203200> rotate<0,90.000000,0> translate<24.130000,0.000000,6.096000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.732000,-1.535000,5.080000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.638000,-1.535000,14.986000>}
box{<0,0,-0.203200><14.009200,0.035000,0.203200> rotate<0,-44.997030,0> translate<14.732000,-1.535000,5.080000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.130000,0.000000,6.096000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.892000,0.000000,7.112000>}
box{<0,0,-0.203200><1.270000,0.035000,0.203200> rotate<0,-53.126596,0> translate<24.130000,0.000000,6.096000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.828000,-1.535000,8.382000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.892000,-1.535000,12.446000>}
box{<0,0,-0.203200><5.747364,0.035000,0.203200> rotate<0,-44.997030,0> translate<20.828000,-1.535000,8.382000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.892000,0.000000,7.112000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<25.171400,0.000000,7.620000>}
box{<0,0,-0.203200><0.579766,0.035000,0.203200> rotate<0,-61.185168,0> translate<24.892000,0.000000,7.112000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.638000,-1.535000,14.986000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<25.171400,-1.535000,15.240000>}
box{<0,0,-0.203200><0.590789,0.035000,0.203200> rotate<0,-25.461665,0> translate<24.638000,-1.535000,14.986000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<25.171400,0.000000,7.620000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<27.686000,0.000000,7.620000>}
box{<0,0,-0.203200><2.514600,0.035000,0.203200> rotate<0,0.000000,0> translate<25.171400,0.000000,7.620000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<27.686000,0.000000,7.620000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.143200,0.000000,7.645400>}
box{<0,0,-0.203200><0.457905,0.035000,0.203200> rotate<0,-3.179620,0> translate<27.686000,0.000000,7.620000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.143200,0.000000,15.265400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.448000,0.000000,14.732000>}
box{<0,0,-0.203200><0.614344,0.035000,0.203200> rotate<0,60.251142,0> translate<28.143200,0.000000,15.265400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.143200,0.000000,7.645400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.702000,0.000000,7.874000>}
box{<0,0,-0.203200><0.603751,0.035000,0.203200> rotate<0,-22.247555,0> translate<28.143200,0.000000,7.645400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.606000,0.000000,7.874000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.956000,0.000000,14.224000>}
box{<0,0,-0.203200><8.980256,0.035000,0.203200> rotate<0,-44.997030,0> translate<22.606000,0.000000,7.874000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.448000,0.000000,14.732000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.956000,0.000000,14.224000>}
box{<0,0,-0.203200><0.718420,0.035000,0.203200> rotate<0,44.997030,0> translate<28.448000,0.000000,14.732000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.702000,0.000000,7.874000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.004000,0.000000,7.874000>}
box{<0,0,-0.203200><3.302000,0.035000,0.203200> rotate<0,0.000000,0> translate<28.702000,0.000000,7.874000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.892000,-1.535000,12.446000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.004000,-1.535000,12.446000>}
box{<0,0,-0.203200><7.112000,0.035000,0.203200> rotate<0,0.000000,0> translate<24.892000,-1.535000,12.446000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.956000,0.000000,14.224000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.258000,0.000000,10.922000>}
box{<0,0,-0.203200><4.669733,0.035000,0.203200> rotate<0,44.997030,0> translate<28.956000,0.000000,14.224000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.004000,0.000000,7.874000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.512000,0.000000,7.747000>}
box{<0,0,-0.203200><0.523634,0.035000,0.203200> rotate<0,14.035317,0> translate<32.004000,0.000000,7.874000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.258000,0.000000,10.922000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.512000,0.000000,10.287000>}
box{<0,0,-0.203200><0.683916,0.035000,0.203200> rotate<0,68.194090,0> translate<32.258000,0.000000,10.922000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.512000,0.000000,10.287000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.512000,0.000000,10.922000>}
box{<0,0,-0.203200><0.635000,0.035000,0.203200> rotate<0,90.000000,0> translate<32.512000,0.000000,10.922000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.004000,-1.535000,12.446000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.512000,-1.535000,12.827000>}
box{<0,0,-0.203200><0.635000,0.035000,0.203200> rotate<0,-36.867464,0> translate<32.004000,-1.535000,12.446000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.512000,0.000000,7.747000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.020000,0.000000,8.128000>}
box{<0,0,-0.203200><0.635000,0.035000,0.203200> rotate<0,-36.867464,0> translate<32.512000,0.000000,7.747000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.512000,-1.535000,12.827000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.020000,-1.535000,12.446000>}
box{<0,0,-0.203200><0.635000,0.035000,0.203200> rotate<0,36.867464,0> translate<32.512000,-1.535000,12.827000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.020000,0.000000,8.128000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.528000,0.000000,8.636000>}
box{<0,0,-0.203200><0.718420,0.035000,0.203200> rotate<0,-44.997030,0> translate<33.020000,0.000000,8.128000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.020000,-1.535000,12.446000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.036000,-1.535000,12.446000>}
box{<0,0,-0.203200><1.016000,0.035000,0.203200> rotate<0,0.000000,0> translate<33.020000,-1.535000,12.446000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.528000,0.000000,8.636000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.544000,0.000000,8.636000>}
box{<0,0,-0.203200><1.016000,0.035000,0.203200> rotate<0,0.000000,0> translate<33.528000,0.000000,8.636000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.036000,-1.535000,12.446000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.544000,-1.535000,11.938000>}
box{<0,0,-0.203200><0.718420,0.035000,0.203200> rotate<0,44.997030,0> translate<34.036000,-1.535000,12.446000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.512000,0.000000,10.922000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.544000,0.000000,12.954000>}
box{<0,0,-0.203200><2.873682,0.035000,0.203200> rotate<0,-44.997030,0> translate<32.512000,0.000000,10.922000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.544000,0.000000,8.636000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.052000,0.000000,9.017000>}
box{<0,0,-0.203200><0.635000,0.035000,0.203200> rotate<0,-36.867464,0> translate<34.544000,0.000000,8.636000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.544000,-1.535000,11.938000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.052000,-1.535000,11.557000>}
box{<0,0,-0.203200><0.635000,0.035000,0.203200> rotate<0,36.867464,0> translate<34.544000,-1.535000,11.938000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.052000,0.000000,9.017000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.560000,0.000000,8.636000>}
box{<0,0,-0.203200><0.635000,0.035000,0.203200> rotate<0,36.867464,0> translate<35.052000,0.000000,9.017000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.052000,-1.535000,11.557000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.560000,-1.535000,11.430000>}
box{<0,0,-0.203200><0.523634,0.035000,0.203200> rotate<0,14.035317,0> translate<35.052000,-1.535000,11.557000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.544000,0.000000,12.954000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.560000,0.000000,12.954000>}
box{<0,0,-0.203200><1.016000,0.035000,0.203200> rotate<0,0.000000,0> translate<34.544000,0.000000,12.954000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.576000,0.000000,11.938000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.576000,0.000000,10.668000>}
box{<0,0,-0.203200><1.270000,0.035000,0.203200> rotate<0,-90.000000,0> translate<36.576000,0.000000,10.668000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.560000,0.000000,12.954000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.576000,0.000000,11.938000>}
box{<0,0,-0.203200><1.436841,0.035000,0.203200> rotate<0,44.997030,0> translate<35.560000,0.000000,12.954000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.560000,0.000000,8.636000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.846000,0.000000,6.350000>}
box{<0,0,-0.203200><3.232892,0.035000,0.203200> rotate<0,44.997030,0> translate<35.560000,0.000000,8.636000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.846000,0.000000,9.398000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.846000,0.000000,8.890000>}
box{<0,0,-0.203200><0.508000,0.035000,0.203200> rotate<0,-90.000000,0> translate<37.846000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.576000,0.000000,10.668000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.846000,0.000000,9.398000>}
box{<0,0,-0.203200><1.796051,0.035000,0.203200> rotate<0,44.997030,0> translate<36.576000,0.000000,10.668000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.560000,-1.535000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.846000,-1.535000,11.430000>}
box{<0,0,-0.203200><2.286000,0.035000,0.203200> rotate<0,0.000000,0> translate<35.560000,-1.535000,11.430000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.846000,0.000000,6.350000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.116000,0.000000,5.842000>}
box{<0,0,-0.203200><1.367832,0.035000,0.203200> rotate<0,21.799971,0> translate<37.846000,0.000000,6.350000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.846000,0.000000,8.890000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.116000,0.000000,8.382000>}
box{<0,0,-0.203200><1.367832,0.035000,0.203200> rotate<0,21.799971,0> translate<37.846000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.846000,-1.535000,11.430000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.116000,-1.535000,10.922000>}
box{<0,0,-0.203200><1.367832,0.035000,0.203200> rotate<0,21.799971,0> translate<37.846000,-1.535000,11.430000> }
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
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,6.858900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,15.412800>}
box{<0,0,-0.203200><8.553900,0.035000,0.203200> rotate<0,90.000000,0> translate<6.235500,-1.535000,15.412800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,6.858900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.641400,-1.535000,7.065800>}
box{<0,0,-0.203200><0.455590,0.035000,0.203200> rotate<0,-27.007587,0> translate<6.235500,-1.535000,6.858900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,6.908800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.333400,-1.535000,6.908800>}
box{<0,0,-0.203200><0.097900,0.035000,0.203200> rotate<0,0.000000,0> translate<6.235500,-1.535000,6.908800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,7.315200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.636700,-1.535000,7.315200>}
box{<0,0,-0.203200><0.401200,0.035000,0.203200> rotate<0,0.000000,0> translate<6.235500,-1.535000,7.315200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,7.721600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.350000,-1.535000,7.721600>}
box{<0,0,-0.203200><0.114500,0.035000,0.203200> rotate<0,0.000000,0> translate<6.235500,-1.535000,7.721600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,8.128000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.350000,-1.535000,8.128000>}
box{<0,0,-0.203200><0.114500,0.035000,0.203200> rotate<0,0.000000,0> translate<6.235500,-1.535000,8.128000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,8.534400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.350000,-1.535000,8.534400>}
box{<0,0,-0.203200><0.114500,0.035000,0.203200> rotate<0,0.000000,0> translate<6.235500,-1.535000,8.534400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,8.940800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.636800,-1.535000,8.940800>}
box{<0,0,-0.203200><0.401300,0.035000,0.203200> rotate<0,0.000000,0> translate<6.235500,-1.535000,8.940800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,9.347200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<7.043200,-1.535000,9.347200>}
box{<0,0,-0.203200><0.807700,0.035000,0.203200> rotate<0,0.000000,0> translate<6.235500,-1.535000,9.347200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,9.753600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.738300,-1.535000,9.753600>}
box{<0,0,-0.203200><0.502800,0.035000,0.203200> rotate<0,0.000000,0> translate<6.235500,-1.535000,9.753600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,10.160000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.350000,-1.535000,10.160000>}
box{<0,0,-0.203200><0.114500,0.035000,0.203200> rotate<0,0.000000,0> translate<6.235500,-1.535000,10.160000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,10.566400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.350000,-1.535000,10.566400>}
box{<0,0,-0.203200><0.114500,0.035000,0.203200> rotate<0,0.000000,0> translate<6.235500,-1.535000,10.566400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,10.972800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.350000,-1.535000,10.972800>}
box{<0,0,-0.203200><0.114500,0.035000,0.203200> rotate<0,0.000000,0> translate<6.235500,-1.535000,10.972800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,11.379200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.535200,-1.535000,11.379200>}
box{<0,0,-0.203200><0.299700,0.035000,0.203200> rotate<0,0.000000,0> translate<6.235500,-1.535000,11.379200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,11.785600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.941600,-1.535000,11.785600>}
box{<0,0,-0.203200><0.706100,0.035000,0.203200> rotate<0,0.000000,0> translate<6.235500,-1.535000,11.785600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<17.646500,-1.535000,12.192000>}
box{<0,0,-0.203200><11.411000,0.035000,0.203200> rotate<0,0.000000,0> translate<6.235500,-1.535000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,12.598400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<18.052900,-1.535000,12.598400>}
box{<0,0,-0.203200><11.817400,0.035000,0.203200> rotate<0,0.000000,0> translate<6.235500,-1.535000,12.598400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,13.004800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<18.459300,-1.535000,13.004800>}
box{<0,0,-0.203200><12.223800,0.035000,0.203200> rotate<0,0.000000,0> translate<6.235500,-1.535000,13.004800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,13.411200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<18.865700,-1.535000,13.411200>}
box{<0,0,-0.203200><12.630200,0.035000,0.203200> rotate<0,0.000000,0> translate<6.235500,-1.535000,13.411200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,13.817600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.272100,-1.535000,13.817600>}
box{<0,0,-0.203200><13.036600,0.035000,0.203200> rotate<0,0.000000,0> translate<6.235500,-1.535000,13.817600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,14.224000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.678500,-1.535000,14.224000>}
box{<0,0,-0.203200><13.443000,0.035000,0.203200> rotate<0,0.000000,0> translate<6.235500,-1.535000,14.224000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,14.630400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.084900,-1.535000,14.630400>}
box{<0,0,-0.203200><13.849400,0.035000,0.203200> rotate<0,0.000000,0> translate<6.235500,-1.535000,14.630400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,15.036800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.491300,-1.535000,15.036800>}
box{<0,0,-0.203200><14.255800,0.035000,0.203200> rotate<0,0.000000,0> translate<6.235500,-1.535000,15.036800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.235500,-1.535000,15.412800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.828000,-1.535000,15.412800>}
box{<0,0,-0.203200><14.592500,0.035000,0.203200> rotate<0,0.000000,0> translate<6.235500,-1.535000,15.412800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.350000,-1.535000,7.601900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.852700,-1.535000,7.099200>}
box{<0,0,-0.203200><0.710925,0.035000,0.203200> rotate<0,44.997030,0> translate<6.350000,-1.535000,7.601900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.350000,-1.535000,8.654000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.350000,-1.535000,7.601900>}
box{<0,0,-0.203200><1.052100,0.035000,0.203200> rotate<0,-90.000000,0> translate<6.350000,-1.535000,7.601900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.350000,-1.535000,8.654000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<7.093900,-1.535000,9.397900>}
box{<0,0,-0.203200><1.052033,0.035000,0.203200> rotate<0,-44.997030,0> translate<6.350000,-1.535000,8.654000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.350000,-1.535000,10.141900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<7.093900,-1.535000,9.398000>}
box{<0,0,-0.203200><1.052033,0.035000,0.203200> rotate<0,44.997030,0> translate<6.350000,-1.535000,10.141900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.350000,-1.535000,11.194000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.350000,-1.535000,10.141900>}
box{<0,0,-0.203200><1.052100,0.035000,0.203200> rotate<0,-90.000000,0> translate<6.350000,-1.535000,10.141900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.350000,-1.535000,11.194000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<7.093900,-1.535000,11.937900>}
box{<0,0,-0.203200><1.052033,0.035000,0.203200> rotate<0,-44.997030,0> translate<6.350000,-1.535000,11.194000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.641400,-1.535000,7.065800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.641500,-1.535000,7.065800>}
box{<0,0,-0.203200><0.000100,0.035000,0.203200> rotate<0,0.000000,0> translate<6.641400,-1.535000,7.065800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.641500,-1.535000,7.065800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<6.852700,-1.535000,7.099200>}
box{<0,0,-0.203200><0.213825,0.035000,0.203200> rotate<0,-8.985964,0> translate<6.641500,-1.535000,7.065800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<7.093900,-1.535000,9.397900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.146000,-1.535000,9.397900>}
box{<0,0,-0.203200><1.052100,0.035000,0.203200> rotate<0,0.000000,0> translate<7.093900,-1.535000,9.397900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<7.093900,-1.535000,9.398000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.146000,-1.535000,9.398000>}
box{<0,0,-0.203200><1.052100,0.035000,0.203200> rotate<0,0.000000,0> translate<7.093900,-1.535000,9.398000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<7.093900,-1.535000,11.937900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.146000,-1.535000,11.937900>}
box{<0,0,-0.203200><1.052100,0.035000,0.203200> rotate<0,0.000000,0> translate<7.093900,-1.535000,11.937900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.146000,-1.535000,9.397900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.889900,-1.535000,8.654000>}
box{<0,0,-0.203200><1.052033,0.035000,0.203200> rotate<0,44.997030,0> translate<8.146000,-1.535000,9.397900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.146000,-1.535000,9.398000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.857100,-1.535000,10.109200>}
box{<0,0,-0.203200><1.005718,0.035000,0.203200> rotate<0,-45.001058,0> translate<8.146000,-1.535000,9.398000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.146000,-1.535000,11.937900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.349100,-1.535000,11.734700>}
box{<0,0,-0.203200><0.287297,0.035000,0.203200> rotate<0,45.011131,0> translate<8.146000,-1.535000,11.937900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.196700,-1.535000,9.347200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<17.849800,-1.535000,9.347200>}
box{<0,0,-0.203200><9.653100,0.035000,0.203200> rotate<0,0.000000,0> translate<8.196700,-1.535000,9.347200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.298300,-1.535000,11.785600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<17.240100,-1.535000,11.785600>}
box{<0,0,-0.203200><8.941800,0.035000,0.203200> rotate<0,0.000000,0> translate<8.298300,-1.535000,11.785600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.349100,-1.535000,11.734700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<17.189200,-1.535000,11.734700>}
box{<0,0,-0.203200><8.840100,0.035000,0.203200> rotate<0,0.000000,0> translate<8.349100,-1.535000,11.734700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.442700,-1.535000,7.154800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.889900,-1.535000,7.601900>}
box{<0,0,-0.203200><0.632366,0.035000,0.203200> rotate<0,-44.990624,0> translate<8.442700,-1.535000,7.154800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.442700,-1.535000,7.154800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<9.004800,-1.535000,7.065800>}
box{<0,0,-0.203200><0.569102,0.035000,0.203200> rotate<0,8.996633,0> translate<8.442700,-1.535000,7.154800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.501500,-1.535000,9.753600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<18.256200,-1.535000,9.753600>}
box{<0,0,-0.203200><9.754700,0.035000,0.203200> rotate<0,0.000000,0> translate<8.501500,-1.535000,9.753600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.603100,-1.535000,7.315200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.817800,-1.535000,7.315200>}
box{<0,0,-0.203200><7.214700,0.035000,0.203200> rotate<0,0.000000,0> translate<8.603100,-1.535000,7.315200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.603100,-1.535000,8.940800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<17.443400,-1.535000,8.940800>}
box{<0,0,-0.203200><8.840300,0.035000,0.203200> rotate<0,0.000000,0> translate<8.603100,-1.535000,8.940800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.857100,-1.535000,10.109200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<17.364200,-1.535000,10.109200>}
box{<0,0,-0.203200><8.507100,0.035000,0.203200> rotate<0,0.000000,0> translate<8.857100,-1.535000,10.109200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.889900,-1.535000,7.601900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.889900,-1.535000,8.654000>}
box{<0,0,-0.203200><1.052100,0.035000,0.203200> rotate<0,90.000000,0> translate<8.889900,-1.535000,8.654000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.889900,-1.535000,7.721600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<16.224200,-1.535000,7.721600>}
box{<0,0,-0.203200><7.334300,0.035000,0.203200> rotate<0,0.000000,0> translate<8.889900,-1.535000,7.721600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.889900,-1.535000,8.128000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<16.630600,-1.535000,8.128000>}
box{<0,0,-0.203200><7.740700,0.035000,0.203200> rotate<0,0.000000,0> translate<8.889900,-1.535000,8.128000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<8.889900,-1.535000,8.534400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<17.037000,-1.535000,8.534400>}
box{<0,0,-0.203200><8.147100,0.035000,0.203200> rotate<0,0.000000,0> translate<8.889900,-1.535000,8.534400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<9.004800,-1.535000,7.065800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<9.004900,-1.535000,7.065800>}
box{<0,0,-0.203200><0.000100,0.035000,0.203200> rotate<0,0.000000,0> translate<9.004800,-1.535000,7.065800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<9.004900,-1.535000,7.065800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<10.070800,-1.535000,6.522700>}
box{<0,0,-0.203200><1.196286,0.035000,0.203200> rotate<0,26.998083,0> translate<9.004900,-1.535000,7.065800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<9.313100,-1.535000,6.908800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.411400,-1.535000,6.908800>}
box{<0,0,-0.203200><6.098300,0.035000,0.203200> rotate<0,0.000000,0> translate<9.313100,-1.535000,6.908800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<10.070800,-1.535000,6.522700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<10.070900,-1.535000,6.522700>}
box{<0,0,-0.203200><0.000100,0.035000,0.203200> rotate<0,0.000000,0> translate<10.070800,-1.535000,6.522700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<10.070900,-1.535000,6.522700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<10.916900,-1.535000,5.676700>}
box{<0,0,-0.203200><1.196425,0.035000,0.203200> rotate<0,44.997030,0> translate<10.070900,-1.535000,6.522700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<10.091200,-1.535000,6.502400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.005000,-1.535000,6.502400>}
box{<0,0,-0.203200><4.913800,0.035000,0.203200> rotate<0,0.000000,0> translate<10.091200,-1.535000,6.502400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<10.497600,-1.535000,6.096000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.598600,-1.535000,6.096000>}
box{<0,0,-0.203200><4.101000,0.035000,0.203200> rotate<0,0.000000,0> translate<10.497600,-1.535000,6.096000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<10.904000,-1.535000,5.689600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<13.326100,-1.535000,5.689600>}
box{<0,0,-0.203200><2.422100,0.035000,0.203200> rotate<0,0.000000,0> translate<10.904000,-1.535000,5.689600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<10.916900,-1.535000,5.676600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<10.916900,-1.535000,5.676700>}
box{<0,0,-0.203200><0.000100,0.035000,0.203200> rotate<0,90.000000,0> translate<10.916900,-1.535000,5.676700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<10.916900,-1.535000,5.676600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<11.460000,-1.535000,4.610700>}
box{<0,0,-0.203200><1.196286,0.035000,0.203200> rotate<0,62.995978,0> translate<10.916900,-1.535000,5.676600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<11.029200,-1.535000,1.401900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<11.460000,-1.535000,2.247200>}
box{<0,0,-0.203200><0.948747,0.035000,0.203200> rotate<0,-62.990562,0> translate<11.029200,-1.535000,1.401900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<11.029200,-1.535000,1.401900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<13.308100,-1.535000,1.401900>}
box{<0,0,-0.203200><2.278900,0.035000,0.203200> rotate<0,0.000000,0> translate<11.029200,-1.535000,1.401900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<11.117400,-1.535000,5.283200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<12.985800,-1.535000,5.283200>}
box{<0,0,-0.203200><1.868400,0.035000,0.203200> rotate<0,0.000000,0> translate<11.117400,-1.535000,5.283200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<11.143200,-1.535000,1.625600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<13.138200,-1.535000,1.625600>}
box{<0,0,-0.203200><1.995000,0.035000,0.203200> rotate<0,0.000000,0> translate<11.143200,-1.535000,1.625600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<11.324500,-1.535000,4.876800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<12.985800,-1.535000,4.876800>}
box{<0,0,-0.203200><1.661300,0.035000,0.203200> rotate<0,0.000000,0> translate<11.324500,-1.535000,4.876800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<11.350300,-1.535000,2.032000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.248300,-1.535000,2.032000>}
box{<0,0,-0.203200><2.898000,0.035000,0.203200> rotate<0,0.000000,0> translate<11.350300,-1.535000,2.032000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<11.460000,-1.535000,2.247200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<11.460000,-1.535000,2.247300>}
box{<0,0,-0.203200><0.000100,0.035000,0.203200> rotate<0,90.000000,0> translate<11.460000,-1.535000,2.247300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<11.460000,-1.535000,2.247300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<11.647200,-1.535000,3.428900>}
box{<0,0,-0.203200><1.196337,0.035000,0.203200> rotate<0,-80.992150,0> translate<11.460000,-1.535000,2.247300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<11.460000,-1.535000,4.610600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<11.460000,-1.535000,4.610700>}
box{<0,0,-0.203200><0.000100,0.035000,0.203200> rotate<0,90.000000,0> translate<11.460000,-1.535000,4.610700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<11.460000,-1.535000,4.610600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<11.647200,-1.535000,3.428900>}
box{<0,0,-0.203200><1.196436,0.035000,0.203200> rotate<0,80.992899,0> translate<11.460000,-1.535000,4.610600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<11.482300,-1.535000,4.470400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<12.985800,-1.535000,4.470400>}
box{<0,0,-0.203200><1.503500,0.035000,0.203200> rotate<0,0.000000,0> translate<11.482300,-1.535000,4.470400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<11.490200,-1.535000,2.438400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<13.138200,-1.535000,2.438400>}
box{<0,0,-0.203200><1.648000,0.035000,0.203200> rotate<0,0.000000,0> translate<11.490200,-1.535000,2.438400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<11.546600,-1.535000,4.064000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<13.224400,-1.535000,4.064000>}
box{<0,0,-0.203200><1.677800,0.035000,0.203200> rotate<0,0.000000,0> translate<11.546600,-1.535000,4.064000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<11.554600,-1.535000,2.844800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<13.490800,-1.535000,2.844800>}
box{<0,0,-0.203200><1.936200,0.035000,0.203200> rotate<0,0.000000,0> translate<11.554600,-1.535000,2.844800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<11.611000,-1.535000,3.657600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<13.630800,-1.535000,3.657600>}
box{<0,0,-0.203200><2.019800,0.035000,0.203200> rotate<0,0.000000,0> translate<11.611000,-1.535000,3.657600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<11.619000,-1.535000,3.251200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.031700,-1.535000,3.251200>}
box{<0,0,-0.203200><8.412700,0.035000,0.203200> rotate<0,0.000000,0> translate<11.619000,-1.535000,3.251200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<12.985800,-1.535000,4.302600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<13.726000,-1.535000,3.562400>}
box{<0,0,-0.203200><1.046801,0.035000,0.203200> rotate<0,44.997030,0> translate<12.985800,-1.535000,4.302600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<12.985800,-1.535000,5.349300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<12.985800,-1.535000,4.302600>}
box{<0,0,-0.203200><1.046700,0.035000,0.203200> rotate<0,-90.000000,0> translate<12.985800,-1.535000,4.302600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<12.985800,-1.535000,5.349300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<13.726000,-1.535000,6.089500>}
box{<0,0,-0.203200><1.046801,0.035000,0.203200> rotate<0,-44.997030,0> translate<12.985800,-1.535000,5.349300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<13.138200,-1.535000,1.571700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<13.308100,-1.535000,1.401900>}
box{<0,0,-0.203200><0.240204,0.035000,0.203200> rotate<0,44.980165,0> translate<13.138200,-1.535000,1.571700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<13.138200,-1.535000,2.031400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<13.138200,-1.535000,1.571700>}
box{<0,0,-0.203200><0.459700,0.035000,0.203200> rotate<0,-90.000000,0> translate<13.138200,-1.535000,1.571700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<13.138200,-1.535000,2.031400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.248300,-1.535000,2.031400>}
box{<0,0,-0.203200><1.110100,0.035000,0.203200> rotate<0,0.000000,0> translate<13.138200,-1.535000,2.031400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<13.138200,-1.535000,2.032400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.248300,-1.535000,2.032400>}
box{<0,0,-0.203200><1.110100,0.035000,0.203200> rotate<0,0.000000,0> translate<13.138200,-1.535000,2.032400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<13.138200,-1.535000,2.492200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<13.138200,-1.535000,2.032400>}
box{<0,0,-0.203200><0.459800,0.035000,0.203200> rotate<0,-90.000000,0> translate<13.138200,-1.535000,2.032400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<13.138200,-1.535000,2.492200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<13.789100,-1.535000,3.143100>}
box{<0,0,-0.203200><0.920512,0.035000,0.203200> rotate<0,-44.997030,0> translate<13.138200,-1.535000,2.492200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<13.726000,-1.535000,3.562400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.772700,-1.535000,3.562400>}
box{<0,0,-0.203200><1.046700,0.035000,0.203200> rotate<0,0.000000,0> translate<13.726000,-1.535000,3.562400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<13.726000,-1.535000,6.089500>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.592100,-1.535000,6.089500>}
box{<0,0,-0.203200><0.866100,0.035000,0.203200> rotate<0,0.000000,0> translate<13.726000,-1.535000,6.089500> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<13.789100,-1.535000,3.143100>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.248800,-1.535000,3.143100>}
box{<0,0,-0.203200><0.459700,0.035000,0.203200> rotate<0,0.000000,0> translate<13.789100,-1.535000,3.143100> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.248300,-1.535000,2.032400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.248300,-1.535000,2.031400>}
box{<0,0,-0.203200><0.001000,0.035000,0.203200> rotate<0,-90.000000,0> translate<14.248300,-1.535000,2.031400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.248800,-1.535000,2.033000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.248800,-1.535000,3.143100>}
box{<0,0,-0.203200><1.110100,0.035000,0.203200> rotate<0,90.000000,0> translate<14.248800,-1.535000,3.143100> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.248800,-1.535000,2.033000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.249800,-1.535000,2.033000>}
box{<0,0,-0.203200><0.001000,0.035000,0.203200> rotate<0,0.000000,0> translate<14.248800,-1.535000,2.033000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.248800,-1.535000,2.438400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.249800,-1.535000,2.438400>}
box{<0,0,-0.203200><0.001000,0.035000,0.203200> rotate<0,0.000000,0> translate<14.248800,-1.535000,2.438400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.248800,-1.535000,2.844800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.249800,-1.535000,2.844800>}
box{<0,0,-0.203200><0.001000,0.035000,0.203200> rotate<0,0.000000,0> translate<14.248800,-1.535000,2.844800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.249800,-1.535000,3.143100>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.249800,-1.535000,2.033000>}
box{<0,0,-0.203200><1.110100,0.035000,0.203200> rotate<0,-90.000000,0> translate<14.249800,-1.535000,2.033000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.249800,-1.535000,3.143100>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.709600,-1.535000,3.143100>}
box{<0,0,-0.203200><0.459800,0.035000,0.203200> rotate<0,0.000000,0> translate<14.249800,-1.535000,3.143100> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.250400,-1.535000,2.031400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.250400,-1.535000,2.032400>}
box{<0,0,-0.203200><0.001000,0.035000,0.203200> rotate<0,90.000000,0> translate<14.250400,-1.535000,2.032400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.250400,-1.535000,2.031400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.360500,-1.535000,2.031400>}
box{<0,0,-0.203200><1.110100,0.035000,0.203200> rotate<0,0.000000,0> translate<14.250400,-1.535000,2.031400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.250400,-1.535000,2.032000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.335800,-1.535000,2.032000>}
box{<0,0,-0.203200><5.085400,0.035000,0.203200> rotate<0,0.000000,0> translate<14.250400,-1.535000,2.032000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.250400,-1.535000,2.032400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.360500,-1.535000,2.032400>}
box{<0,0,-0.203200><1.110100,0.035000,0.203200> rotate<0,0.000000,0> translate<14.250400,-1.535000,2.032400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.592100,-1.535000,6.089500>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.472600,-1.535000,13.970000>}
box{<0,0,-0.203200><11.144710,0.035000,0.203200> rotate<0,-44.997030,0> translate<14.592100,-1.535000,6.089500> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.709600,-1.535000,3.143100>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.360500,-1.535000,2.492200>}
box{<0,0,-0.203200><0.920512,0.035000,0.203200> rotate<0,44.997030,0> translate<14.709600,-1.535000,3.143100> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.772700,-1.535000,3.562400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.512900,-1.535000,4.302600>}
box{<0,0,-0.203200><1.046801,0.035000,0.203200> rotate<0,-44.997030,0> translate<14.772700,-1.535000,3.562400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<14.867900,-1.535000,3.657600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.732800,-1.535000,3.657600>}
box{<0,0,-0.203200><5.864900,0.035000,0.203200> rotate<0,0.000000,0> translate<14.867900,-1.535000,3.657600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.007900,-1.535000,2.844800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.625300,-1.535000,2.844800>}
box{<0,0,-0.203200><4.617400,0.035000,0.203200> rotate<0,0.000000,0> translate<15.007900,-1.535000,2.844800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.190600,-1.535000,1.401900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.360500,-1.535000,1.571700>}
box{<0,0,-0.203200><0.240204,0.035000,0.203200> rotate<0,-44.980165,0> translate<15.190600,-1.535000,1.401900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.190600,-1.535000,1.401900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.442600,-1.535000,1.401900>}
box{<0,0,-0.203200><4.252000,0.035000,0.203200> rotate<0,0.000000,0> translate<15.190600,-1.535000,1.401900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.274300,-1.535000,4.064000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.789900,-1.535000,4.064000>}
box{<0,0,-0.203200><4.515600,0.035000,0.203200> rotate<0,0.000000,0> translate<15.274300,-1.535000,4.064000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.360500,-1.535000,1.571700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.360500,-1.535000,2.031400>}
box{<0,0,-0.203200><0.459700,0.035000,0.203200> rotate<0,90.000000,0> translate<15.360500,-1.535000,2.031400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.360500,-1.535000,1.625600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.335800,-1.535000,1.625600>}
box{<0,0,-0.203200><3.975300,0.035000,0.203200> rotate<0,0.000000,0> translate<15.360500,-1.535000,1.625600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.360500,-1.535000,2.032400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.360500,-1.535000,2.492200>}
box{<0,0,-0.203200><0.459800,0.035000,0.203200> rotate<0,90.000000,0> translate<15.360500,-1.535000,2.492200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.360500,-1.535000,2.438400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.335800,-1.535000,2.438400>}
box{<0,0,-0.203200><3.975300,0.035000,0.203200> rotate<0,0.000000,0> translate<15.360500,-1.535000,2.438400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.512900,-1.535000,4.302600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.512900,-1.535000,4.711500>}
box{<0,0,-0.203200><0.408900,0.035000,0.203200> rotate<0,90.000000,0> translate<15.512900,-1.535000,4.711500> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.512900,-1.535000,4.470400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.488200,-1.535000,4.470400>}
box{<0,0,-0.203200><3.975300,0.035000,0.203200> rotate<0,0.000000,0> translate<15.512900,-1.535000,4.470400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.512900,-1.535000,4.711500>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.771500,-1.535000,13.970000>}
box{<0,0,-0.203200><13.093567,0.035000,0.203200> rotate<0,-44.996721,0> translate<15.512900,-1.535000,4.711500> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<15.678200,-1.535000,4.876800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.488200,-1.535000,4.876800>}
box{<0,0,-0.203200><3.810000,0.035000,0.203200> rotate<0,0.000000,0> translate<15.678200,-1.535000,4.876800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<16.084600,-1.535000,5.283200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.488200,-1.535000,5.283200>}
box{<0,0,-0.203200><3.403600,0.035000,0.203200> rotate<0,0.000000,0> translate<16.084600,-1.535000,5.283200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<16.491000,-1.535000,5.689600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.891600,-1.535000,5.689600>}
box{<0,0,-0.203200><3.400600,0.035000,0.203200> rotate<0,0.000000,0> translate<16.491000,-1.535000,5.689600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<16.897400,-1.535000,6.096000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.353200,-1.535000,6.096000>}
box{<0,0,-0.203200><7.455800,0.035000,0.203200> rotate<0,0.000000,0> translate<16.897400,-1.535000,6.096000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<17.189200,-1.535000,11.734700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.828000,-1.535000,15.373500>}
box{<0,0,-0.203200><5.146040,0.035000,0.203200> rotate<0,-44.997030,0> translate<17.189200,-1.535000,11.734700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<17.303800,-1.535000,6.502400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.419500,-1.535000,6.502400>}
box{<0,0,-0.203200><4.115700,0.035000,0.203200> rotate<0,0.000000,0> translate<17.303800,-1.535000,6.502400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<17.364200,-1.535000,10.109200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<17.687700,-1.535000,10.109200>}
box{<0,0,-0.203200><0.323500,0.035000,0.203200> rotate<0,0.000000,0> translate<17.364200,-1.535000,10.109200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<17.687700,-1.535000,10.109200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<17.986400,-1.535000,10.232900>}
box{<0,0,-0.203200><0.323301,0.035000,0.203200> rotate<0,-22.494325,0> translate<17.687700,-1.535000,10.109200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<17.710200,-1.535000,6.908800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.013100,-1.535000,6.908800>}
box{<0,0,-0.203200><3.302900,0.035000,0.203200> rotate<0,0.000000,0> translate<17.710200,-1.535000,6.908800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<17.810300,-1.535000,10.160000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<18.662600,-1.535000,10.160000>}
box{<0,0,-0.203200><0.852300,0.035000,0.203200> rotate<0,0.000000,0> translate<17.810300,-1.535000,10.160000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<17.986400,-1.535000,10.232900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.723500,-1.535000,13.970000>}
box{<0,0,-0.203200><5.285058,0.035000,0.203200> rotate<0,-44.997030,0> translate<17.986400,-1.535000,10.232900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<18.116600,-1.535000,7.315200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.828000,-1.535000,7.315200>}
box{<0,0,-0.203200><2.711400,0.035000,0.203200> rotate<0,0.000000,0> translate<18.116600,-1.535000,7.315200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<18.319900,-1.535000,10.566400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.069000,-1.535000,10.566400>}
box{<0,0,-0.203200><0.749100,0.035000,0.203200> rotate<0,0.000000,0> translate<18.319900,-1.535000,10.566400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<18.523000,-1.535000,7.721600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.828000,-1.535000,7.721600>}
box{<0,0,-0.203200><2.305000,0.035000,0.203200> rotate<0,0.000000,0> translate<18.523000,-1.535000,7.721600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<18.726300,-1.535000,10.972800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.475400,-1.535000,10.972800>}
box{<0,0,-0.203200><0.749100,0.035000,0.203200> rotate<0,0.000000,0> translate<18.726300,-1.535000,10.972800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<18.929400,-1.535000,8.128000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.828000,-1.535000,8.128000>}
box{<0,0,-0.203200><1.898600,0.035000,0.203200> rotate<0,0.000000,0> translate<18.929400,-1.535000,8.128000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.132700,-1.535000,11.379200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.881800,-1.535000,11.379200>}
box{<0,0,-0.203200><0.749100,0.035000,0.203200> rotate<0,0.000000,0> translate<19.132700,-1.535000,11.379200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.335800,-1.535000,1.508600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.442600,-1.535000,1.401900>}
box{<0,0,-0.203200><0.150967,0.035000,0.203200> rotate<0,44.970196,0> translate<19.335800,-1.535000,1.508600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.335800,-1.535000,2.555300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.335800,-1.535000,1.508600>}
box{<0,0,-0.203200><1.046700,0.035000,0.203200> rotate<0,-90.000000,0> translate<19.335800,-1.535000,1.508600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.335800,-1.535000,2.555300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.076000,-1.535000,3.295500>}
box{<0,0,-0.203200><1.046801,0.035000,0.203200> rotate<0,-44.997030,0> translate<19.335800,-1.535000,2.555300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.335800,-1.535000,8.534400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.216400,-1.535000,8.534400>}
box{<0,0,-0.203200><1.880600,0.035000,0.203200> rotate<0,0.000000,0> translate<19.335800,-1.535000,8.534400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.488200,-1.535000,4.365700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.139100,-1.535000,3.714800>}
box{<0,0,-0.203200><0.920512,0.035000,0.203200> rotate<0,44.997030,0> translate<19.488200,-1.535000,4.365700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.488200,-1.535000,4.825400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.488200,-1.535000,4.365700>}
box{<0,0,-0.203200><0.459700,0.035000,0.203200> rotate<0,-90.000000,0> translate<19.488200,-1.535000,4.365700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.488200,-1.535000,4.825400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.598300,-1.535000,4.825400>}
box{<0,0,-0.203200><1.110100,0.035000,0.203200> rotate<0,0.000000,0> translate<19.488200,-1.535000,4.825400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.488200,-1.535000,4.826400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.598300,-1.535000,4.826400>}
box{<0,0,-0.203200><1.110100,0.035000,0.203200> rotate<0,0.000000,0> translate<19.488200,-1.535000,4.826400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.488200,-1.535000,5.286200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.488200,-1.535000,4.826400>}
box{<0,0,-0.203200><0.459800,0.035000,0.203200> rotate<0,-90.000000,0> translate<19.488200,-1.535000,4.826400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.488200,-1.535000,5.286200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.139100,-1.535000,5.937100>}
box{<0,0,-0.203200><0.920512,0.035000,0.203200> rotate<0,-44.997030,0> translate<19.488200,-1.535000,5.286200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.539100,-1.535000,11.785600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.288200,-1.535000,11.785600>}
box{<0,0,-0.203200><0.749100,0.035000,0.203200> rotate<0,0.000000,0> translate<19.539100,-1.535000,11.785600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.742200,-1.535000,8.940800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.976200,-1.535000,8.940800>}
box{<0,0,-0.203200><12.234000,0.035000,0.203200> rotate<0,0.000000,0> translate<19.742200,-1.535000,8.940800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.945500,-1.535000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.694600,-1.535000,12.192000>}
box{<0,0,-0.203200><0.749100,0.035000,0.203200> rotate<0,0.000000,0> translate<19.945500,-1.535000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.076000,-1.535000,3.295500>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.732800,-1.535000,3.295500>}
box{<0,0,-0.203200><0.656800,0.035000,0.203200> rotate<0,0.000000,0> translate<20.076000,-1.535000,3.295500> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.139100,-1.535000,3.714800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.598800,-1.535000,3.714800>}
box{<0,0,-0.203200><0.459700,0.035000,0.203200> rotate<0,0.000000,0> translate<20.139100,-1.535000,3.714800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.139100,-1.535000,5.937100>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.598800,-1.535000,5.937100>}
box{<0,0,-0.203200><0.459700,0.035000,0.203200> rotate<0,0.000000,0> translate<20.139100,-1.535000,5.937100> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.148600,-1.535000,9.347200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.601800,-1.535000,9.347200>}
box{<0,0,-0.203200><11.453200,0.035000,0.203200> rotate<0,0.000000,0> translate<20.148600,-1.535000,9.347200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.351900,-1.535000,12.598400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.101000,-1.535000,12.598400>}
box{<0,0,-0.203200><0.749100,0.035000,0.203200> rotate<0,0.000000,0> translate<20.351900,-1.535000,12.598400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.555000,-1.535000,9.753600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.317000,-1.535000,9.753600>}
box{<0,0,-0.203200><10.762000,0.035000,0.203200> rotate<0,0.000000,0> translate<20.555000,-1.535000,9.753600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.598300,-1.535000,4.826400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.598300,-1.535000,4.825400>}
box{<0,0,-0.203200><0.001000,0.035000,0.203200> rotate<0,-90.000000,0> translate<20.598300,-1.535000,4.825400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.598800,-1.535000,3.714800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.598800,-1.535000,4.824900>}
box{<0,0,-0.203200><1.110100,0.035000,0.203200> rotate<0,90.000000,0> translate<20.598800,-1.535000,4.824900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.598800,-1.535000,4.064000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.599800,-1.535000,4.064000>}
box{<0,0,-0.203200><0.001000,0.035000,0.203200> rotate<0,0.000000,0> translate<20.598800,-1.535000,4.064000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.598800,-1.535000,4.470400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.599800,-1.535000,4.470400>}
box{<0,0,-0.203200><0.001000,0.035000,0.203200> rotate<0,0.000000,0> translate<20.598800,-1.535000,4.470400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.598800,-1.535000,4.824900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.599800,-1.535000,4.824900>}
box{<0,0,-0.203200><0.001000,0.035000,0.203200> rotate<0,0.000000,0> translate<20.598800,-1.535000,4.824900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.598800,-1.535000,4.827000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.598800,-1.535000,5.937100>}
box{<0,0,-0.203200><1.110100,0.035000,0.203200> rotate<0,90.000000,0> translate<20.598800,-1.535000,5.937100> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.598800,-1.535000,4.827000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.599800,-1.535000,4.827000>}
box{<0,0,-0.203200><0.001000,0.035000,0.203200> rotate<0,0.000000,0> translate<20.598800,-1.535000,4.827000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.598800,-1.535000,4.876800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.599800,-1.535000,4.876800>}
box{<0,0,-0.203200><0.001000,0.035000,0.203200> rotate<0,0.000000,0> translate<20.598800,-1.535000,4.876800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.598800,-1.535000,5.283200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.599800,-1.535000,5.283200>}
box{<0,0,-0.203200><0.001000,0.035000,0.203200> rotate<0,0.000000,0> translate<20.598800,-1.535000,5.283200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.598800,-1.535000,5.689600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.599800,-1.535000,5.689600>}
box{<0,0,-0.203200><0.001000,0.035000,0.203200> rotate<0,0.000000,0> translate<20.598800,-1.535000,5.689600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.599800,-1.535000,3.714800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.732800,-1.535000,3.714800>}
box{<0,0,-0.203200><0.133000,0.035000,0.203200> rotate<0,0.000000,0> translate<20.599800,-1.535000,3.714800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.599800,-1.535000,4.824900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.599800,-1.535000,3.714800>}
box{<0,0,-0.203200><1.110100,0.035000,0.203200> rotate<0,-90.000000,0> translate<20.599800,-1.535000,3.714800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.599800,-1.535000,5.937100>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.599800,-1.535000,4.827000>}
box{<0,0,-0.203200><1.110100,0.035000,0.203200> rotate<0,-90.000000,0> translate<20.599800,-1.535000,4.827000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.599800,-1.535000,5.937100>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.059600,-1.535000,5.937100>}
box{<0,0,-0.203200><0.459800,0.035000,0.203200> rotate<0,0.000000,0> translate<20.599800,-1.535000,5.937100> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.600400,-1.535000,4.825400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.600400,-1.535000,4.826400>}
box{<0,0,-0.203200><0.001000,0.035000,0.203200> rotate<0,90.000000,0> translate<20.600400,-1.535000,4.826400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.600400,-1.535000,4.825400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.710500,-1.535000,4.825400>}
box{<0,0,-0.203200><1.110100,0.035000,0.203200> rotate<0,0.000000,0> translate<20.600400,-1.535000,4.825400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.600400,-1.535000,4.826400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.710500,-1.535000,4.826400>}
box{<0,0,-0.203200><1.110100,0.035000,0.203200> rotate<0,0.000000,0> translate<20.600400,-1.535000,4.826400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.732800,-1.535000,3.714800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.732800,-1.535000,3.295500>}
box{<0,0,-0.203200><0.419300,0.035000,0.203200> rotate<0,-90.000000,0> translate<20.732800,-1.535000,3.295500> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.758300,-1.535000,13.004800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.507400,-1.535000,13.004800>}
box{<0,0,-0.203200><0.749100,0.035000,0.203200> rotate<0,0.000000,0> translate<20.758300,-1.535000,13.004800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.828000,-1.535000,7.093900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.571900,-1.535000,6.350000>}
box{<0,0,-0.203200><1.052033,0.035000,0.203200> rotate<0,44.997030,0> translate<20.828000,-1.535000,7.093900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.828000,-1.535000,8.146000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.828000,-1.535000,7.093900>}
box{<0,0,-0.203200><1.052100,0.035000,0.203200> rotate<0,-90.000000,0> translate<20.828000,-1.535000,7.093900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.828000,-1.535000,8.146000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.571900,-1.535000,8.889900>}
box{<0,0,-0.203200><1.052033,0.035000,0.203200> rotate<0,-44.997030,0> translate<20.828000,-1.535000,8.146000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.828000,-1.535000,15.412800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.828000,-1.535000,15.373500>}
box{<0,0,-0.203200><0.039300,0.035000,0.203200> rotate<0,-90.000000,0> translate<20.828000,-1.535000,15.373500> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<20.961400,-1.535000,10.160000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.203900,-1.535000,10.160000>}
box{<0,0,-0.203200><10.242500,0.035000,0.203200> rotate<0,0.000000,0> translate<20.961400,-1.535000,10.160000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.059600,-1.535000,5.937100>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.710500,-1.535000,5.286200>}
box{<0,0,-0.203200><0.920512,0.035000,0.203200> rotate<0,44.997030,0> translate<21.059600,-1.535000,5.937100> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.164700,-1.535000,13.411200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.913800,-1.535000,13.411200>}
box{<0,0,-0.203200><0.749100,0.035000,0.203200> rotate<0,0.000000,0> translate<21.164700,-1.535000,13.411200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.307100,-1.535000,5.689600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.946800,-1.535000,5.689600>}
box{<0,0,-0.203200><2.639700,0.035000,0.203200> rotate<0,0.000000,0> translate<21.307100,-1.535000,5.689600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.367800,-1.535000,10.566400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.211900,-1.535000,10.566400>}
box{<0,0,-0.203200><9.844100,0.035000,0.203200> rotate<0,0.000000,0> translate<21.367800,-1.535000,10.566400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.571100,-1.535000,13.817600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.320200,-1.535000,13.817600>}
box{<0,0,-0.203200><0.749100,0.035000,0.203200> rotate<0,0.000000,0> translate<21.571100,-1.535000,13.817600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.571900,-1.535000,6.350000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.624000,-1.535000,6.350000>}
box{<0,0,-0.203200><1.052100,0.035000,0.203200> rotate<0,0.000000,0> translate<21.571900,-1.535000,6.350000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.571900,-1.535000,8.889900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.624000,-1.535000,8.889900>}
box{<0,0,-0.203200><1.052100,0.035000,0.203200> rotate<0,0.000000,0> translate<21.571900,-1.535000,8.889900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.710500,-1.535000,4.692500>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.710500,-1.535000,4.825400>}
box{<0,0,-0.203200><0.132900,0.035000,0.203200> rotate<0,90.000000,0> translate<21.710500,-1.535000,4.825400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.710500,-1.535000,4.692500>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.519700,-1.535000,4.692500>}
box{<0,0,-0.203200><0.809200,0.035000,0.203200> rotate<0,0.000000,0> translate<21.710500,-1.535000,4.692500> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.710500,-1.535000,4.826400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.710500,-1.535000,5.286200>}
box{<0,0,-0.203200><0.459800,0.035000,0.203200> rotate<0,90.000000,0> translate<21.710500,-1.535000,5.286200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.710500,-1.535000,4.876800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.525900,-1.535000,4.876800>}
box{<0,0,-0.203200><1.815400,0.035000,0.203200> rotate<0,0.000000,0> translate<21.710500,-1.535000,4.876800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.710500,-1.535000,5.283200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.733000,-1.535000,5.283200>}
box{<0,0,-0.203200><2.022500,0.035000,0.203200> rotate<0,0.000000,0> translate<21.710500,-1.535000,5.283200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.723500,-1.535000,13.970000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.472600,-1.535000,13.970000>}
box{<0,0,-0.203200><0.749100,0.035000,0.203200> rotate<0,0.000000,0> translate<21.723500,-1.535000,13.970000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.774200,-1.535000,10.972800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.380200,-1.535000,10.972800>}
box{<0,0,-0.203200><9.606000,0.035000,0.203200> rotate<0,0.000000,0> translate<21.774200,-1.535000,10.972800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.180600,-1.535000,11.379200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.754300,-1.535000,11.379200>}
box{<0,0,-0.203200><9.573700,0.035000,0.203200> rotate<0,0.000000,0> translate<22.180600,-1.535000,11.379200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.519700,-1.535000,4.692500>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.215000,-1.535000,3.997100>}
box{<0,0,-0.203200><0.983373,0.035000,0.203200> rotate<0,45.001150,0> translate<22.519700,-1.535000,4.692500> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.587000,-1.535000,11.785600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.006000,-1.535000,11.785600>}
box{<0,0,-0.203200><9.419000,0.035000,0.203200> rotate<0,0.000000,0> translate<22.587000,-1.535000,11.785600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.624000,-1.535000,6.350000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.367900,-1.535000,7.093900>}
box{<0,0,-0.203200><1.052033,0.035000,0.203200> rotate<0,-44.997030,0> translate<22.624000,-1.535000,6.350000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.624000,-1.535000,8.889900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.367900,-1.535000,8.146000>}
box{<0,0,-0.203200><1.052033,0.035000,0.203200> rotate<0,44.997030,0> translate<22.624000,-1.535000,8.889900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.741800,-1.535000,4.470400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.367900,-1.535000,4.470400>}
box{<0,0,-0.203200><0.626100,0.035000,0.203200> rotate<0,0.000000,0> translate<22.741800,-1.535000,4.470400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.776400,-1.535000,6.502400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.492900,-1.535000,6.502400>}
box{<0,0,-0.203200><1.716500,0.035000,0.203200> rotate<0,0.000000,0> translate<22.776400,-1.535000,6.502400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.979500,-1.535000,8.534400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.289800,-1.535000,8.534400>}
box{<0,0,-0.203200><1.310300,0.035000,0.203200> rotate<0,0.000000,0> translate<22.979500,-1.535000,8.534400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.993400,-1.535000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.524000,-1.535000,12.192000>}
box{<0,0,-0.203200><8.530600,0.035000,0.203200> rotate<0,0.000000,0> translate<22.993400,-1.535000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.148200,-1.535000,4.064000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.262000,-1.535000,4.064000>}
box{<0,0,-0.203200><0.113800,0.035000,0.203200> rotate<0,0.000000,0> translate<23.148200,-1.535000,4.064000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.182800,-1.535000,6.908800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.086500,-1.535000,6.908800>}
box{<0,0,-0.203200><0.903700,0.035000,0.203200> rotate<0,0.000000,0> translate<23.182800,-1.535000,6.908800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.215000,-1.535000,3.997100>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.229000,-1.535000,4.031000>}
box{<0,0,-0.203200><0.036677,0.035000,0.203200> rotate<0,-67.555927,0> translate<23.215000,-1.535000,3.997100> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.229000,-1.535000,4.031000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.311300,-1.535000,4.113300>}
box{<0,0,-0.203200><0.116390,0.035000,0.203200> rotate<0,-44.997030,0> translate<23.229000,-1.535000,4.031000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.311300,-1.535000,4.113300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.390000,-1.535000,4.610100>}
box{<0,0,-0.203200><0.502995,0.035000,0.203200> rotate<0,-80.993011,0> translate<23.311300,-1.535000,4.113300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.367900,-1.535000,7.093900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.367900,-1.535000,8.146000>}
box{<0,0,-0.203200><1.052100,0.035000,0.203200> rotate<0,90.000000,0> translate<23.367900,-1.535000,8.146000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.367900,-1.535000,7.315200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.901400,-1.535000,7.315200>}
box{<0,0,-0.203200><0.533500,0.035000,0.203200> rotate<0,0.000000,0> translate<23.367900,-1.535000,7.315200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.367900,-1.535000,7.721600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.901400,-1.535000,7.721600>}
box{<0,0,-0.203200><0.533500,0.035000,0.203200> rotate<0,0.000000,0> translate<23.367900,-1.535000,7.721600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.367900,-1.535000,8.128000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.901400,-1.535000,8.128000>}
box{<0,0,-0.203200><0.533500,0.035000,0.203200> rotate<0,0.000000,0> translate<23.367900,-1.535000,8.128000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.390000,-1.535000,4.610100>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.933000,-1.535000,5.675800>}
box{<0,0,-0.203200><1.196062,0.035000,0.203200> rotate<0,-62.995897,0> translate<23.390000,-1.535000,4.610100> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.399800,-1.535000,12.598400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.356300,-1.535000,12.598400>}
box{<0,0,-0.203200><7.956500,0.035000,0.203200> rotate<0,0.000000,0> translate<23.399800,-1.535000,12.598400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.806200,-1.535000,13.004800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.356300,-1.535000,13.004800>}
box{<0,0,-0.203200><7.550100,0.035000,0.203200> rotate<0,0.000000,0> translate<23.806200,-1.535000,13.004800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.901400,-1.535000,7.093900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.626300,-1.535000,6.369100>}
box{<0,0,-0.203200><1.025093,0.035000,0.203200> rotate<0,44.993078,0> translate<23.901400,-1.535000,7.093900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.901400,-1.535000,8.146000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.901400,-1.535000,7.093900>}
box{<0,0,-0.203200><1.052100,0.035000,0.203200> rotate<0,-90.000000,0> translate<23.901400,-1.535000,7.093900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.901400,-1.535000,8.146000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.645300,-1.535000,8.889900>}
box{<0,0,-0.203200><1.052033,0.035000,0.203200> rotate<0,-44.997030,0> translate<23.901400,-1.535000,8.146000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.933000,-1.535000,5.675900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.933000,-1.535000,5.675800>}
box{<0,0,-0.203200><0.000100,0.035000,0.203200> rotate<0,-90.000000,0> translate<23.933000,-1.535000,5.675800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.933000,-1.535000,5.675900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.626300,-1.535000,6.369100>}
box{<0,0,-0.203200><0.980404,0.035000,0.203200> rotate<0,-44.992898,0> translate<23.933000,-1.535000,5.675900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.212600,-1.535000,13.411200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.503100,-1.535000,13.411200>}
box{<0,0,-0.203200><7.290500,0.035000,0.203200> rotate<0,0.000000,0> translate<24.212600,-1.535000,13.411200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.619000,-1.535000,13.817600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.883700,-1.535000,13.817600>}
box{<0,0,-0.203200><7.264700,0.035000,0.203200> rotate<0,0.000000,0> translate<24.619000,-1.535000,13.817600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.645300,-1.535000,8.889900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<25.697400,-1.535000,8.889900>}
box{<0,0,-0.203200><1.052100,0.035000,0.203200> rotate<0,0.000000,0> translate<24.645300,-1.535000,8.889900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.771500,-1.535000,13.970000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<25.697400,-1.535000,13.970000>}
box{<0,0,-0.203200><0.925900,0.035000,0.203200> rotate<0,0.000000,0> translate<24.771500,-1.535000,13.970000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<25.697400,-1.535000,8.889900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.441300,-1.535000,8.146000>}
box{<0,0,-0.203200><1.052033,0.035000,0.203200> rotate<0,44.997030,0> translate<25.697400,-1.535000,8.889900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<25.697400,-1.535000,13.970000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.441300,-1.535000,14.713900>}
box{<0,0,-0.203200><1.052033,0.035000,0.203200> rotate<0,-44.997030,0> translate<25.697400,-1.535000,13.970000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<25.951400,-1.535000,14.224000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<27.388500,-1.535000,14.224000>}
box{<0,0,-0.203200><1.437100,0.035000,0.203200> rotate<0,0.000000,0> translate<25.951400,-1.535000,14.224000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.052900,-1.535000,8.534400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<27.236200,-1.535000,8.534400>}
box{<0,0,-0.203200><1.183300,0.035000,0.203200> rotate<0,0.000000,0> translate<26.052900,-1.535000,8.534400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.357800,-1.535000,14.630400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.982100,-1.535000,14.630400>}
box{<0,0,-0.203200><0.624300,0.035000,0.203200> rotate<0,0.000000,0> translate<26.357800,-1.535000,14.630400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.441300,-1.535000,7.159000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.441300,-1.535000,8.146000>}
box{<0,0,-0.203200><0.987000,0.035000,0.203200> rotate<0,90.000000,0> translate<26.441300,-1.535000,8.146000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.441300,-1.535000,7.159000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.873200,-1.535000,7.227400>}
box{<0,0,-0.203200><0.437283,0.035000,0.203200> rotate<0,-8.998599,0> translate<26.441300,-1.535000,7.159000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.441300,-1.535000,7.315200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.873200,-1.535000,7.315200>}
box{<0,0,-0.203200><0.431900,0.035000,0.203200> rotate<0,0.000000,0> translate<26.441300,-1.535000,7.315200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.441300,-1.535000,7.721600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.873200,-1.535000,7.721600>}
box{<0,0,-0.203200><0.431900,0.035000,0.203200> rotate<0,0.000000,0> translate<26.441300,-1.535000,7.721600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.441300,-1.535000,8.128000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.873200,-1.535000,8.128000>}
box{<0,0,-0.203200><0.431900,0.035000,0.203200> rotate<0,0.000000,0> translate<26.441300,-1.535000,8.128000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.441300,-1.535000,14.713900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.441300,-1.535000,15.412800>}
box{<0,0,-0.203200><0.698900,0.035000,0.203200> rotate<0,90.000000,0> translate<26.441300,-1.535000,15.412800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.441300,-1.535000,15.036800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.873200,-1.535000,15.036800>}
box{<0,0,-0.203200><0.431900,0.035000,0.203200> rotate<0,0.000000,0> translate<26.441300,-1.535000,15.036800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.441300,-1.535000,15.412800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.873200,-1.535000,15.412800>}
box{<0,0,-0.203200><0.431900,0.035000,0.203200> rotate<0,0.000000,0> translate<26.441300,-1.535000,15.412800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.873200,-1.535000,8.171400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.873200,-1.535000,7.227400>}
box{<0,0,-0.203200><0.944000,0.035000,0.203200> rotate<0,-90.000000,0> translate<26.873200,-1.535000,7.227400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.873200,-1.535000,8.171400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<27.617100,-1.535000,8.915300>}
box{<0,0,-0.203200><1.052033,0.035000,0.203200> rotate<0,-44.997030,0> translate<26.873200,-1.535000,8.171400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.873200,-1.535000,14.739300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<27.617100,-1.535000,13.995400>}
box{<0,0,-0.203200><1.052033,0.035000,0.203200> rotate<0,44.997030,0> translate<26.873200,-1.535000,14.739300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.873200,-1.535000,15.412800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.873200,-1.535000,14.739300>}
box{<0,0,-0.203200><0.673500,0.035000,0.203200> rotate<0,-90.000000,0> translate<26.873200,-1.535000,14.739300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<27.617100,-1.535000,8.915300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.669200,-1.535000,8.915300>}
box{<0,0,-0.203200><1.052100,0.035000,0.203200> rotate<0,0.000000,0> translate<27.617100,-1.535000,8.915300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<27.617100,-1.535000,13.995400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.669200,-1.535000,13.995400>}
box{<0,0,-0.203200><1.052100,0.035000,0.203200> rotate<0,0.000000,0> translate<27.617100,-1.535000,13.995400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.669200,-1.535000,8.915300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<29.413100,-1.535000,8.171400>}
box{<0,0,-0.203200><1.052033,0.035000,0.203200> rotate<0,44.997030,0> translate<28.669200,-1.535000,8.915300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.669200,-1.535000,13.995400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<29.413100,-1.535000,14.739300>}
box{<0,0,-0.203200><1.052033,0.035000,0.203200> rotate<0,-44.997030,0> translate<28.669200,-1.535000,13.995400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.897800,-1.535000,14.224000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.557200,-1.535000,14.224000>}
box{<0,0,-0.203200><9.659400,0.035000,0.203200> rotate<0,0.000000,0> translate<28.897800,-1.535000,14.224000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.969500,-1.535000,6.675800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<29.272400,-1.535000,6.521500>}
box{<0,0,-0.203200><0.339937,0.035000,0.203200> rotate<0,26.992923,0> translate<28.969500,-1.535000,6.675800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.969500,-1.535000,6.675800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<29.413100,-1.535000,7.119300>}
box{<0,0,-0.203200><0.627274,0.035000,0.203200> rotate<0,-44.990572,0> translate<28.969500,-1.535000,6.675800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<29.050100,-1.535000,8.534400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.449500,-1.535000,8.534400>}
box{<0,0,-0.203200><2.399400,0.035000,0.203200> rotate<0,0.000000,0> translate<29.050100,-1.535000,8.534400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<29.202500,-1.535000,6.908800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.500200,-1.535000,6.908800>}
box{<0,0,-0.203200><2.297700,0.035000,0.203200> rotate<0,0.000000,0> translate<29.202500,-1.535000,6.908800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<29.272400,-1.535000,6.521500>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<29.272500,-1.535000,6.521500>}
box{<0,0,-0.203200><0.000100,0.035000,0.203200> rotate<0,0.000000,0> translate<29.272400,-1.535000,6.521500> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<29.272500,-1.535000,6.521500>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.118100,-1.535000,5.675900>}
box{<0,0,-0.203200><1.195859,0.035000,0.203200> rotate<0,44.997030,0> translate<29.272500,-1.535000,6.521500> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<29.291600,-1.535000,6.502400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.098600,-1.535000,6.502400>}
box{<0,0,-0.203200><2.807000,0.035000,0.203200> rotate<0,0.000000,0> translate<29.291600,-1.535000,6.502400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<29.304200,-1.535000,14.630400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.599800,-1.535000,14.630400>}
box{<0,0,-0.203200><9.295600,0.035000,0.203200> rotate<0,0.000000,0> translate<29.304200,-1.535000,14.630400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<29.413100,-1.535000,7.119300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<29.413100,-1.535000,8.171400>}
box{<0,0,-0.203200><1.052100,0.035000,0.203200> rotate<0,90.000000,0> translate<29.413100,-1.535000,8.171400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<29.413100,-1.535000,7.315200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.274900,-1.535000,7.315200>}
box{<0,0,-0.203200><1.861800,0.035000,0.203200> rotate<0,0.000000,0> translate<29.413100,-1.535000,7.315200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<29.413100,-1.535000,7.721600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.203900,-1.535000,7.721600>}
box{<0,0,-0.203200><1.790800,0.035000,0.203200> rotate<0,0.000000,0> translate<29.413100,-1.535000,7.721600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<29.413100,-1.535000,8.128000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.254000,-1.535000,8.128000>}
box{<0,0,-0.203200><1.840900,0.035000,0.203200> rotate<0,0.000000,0> translate<29.413100,-1.535000,8.128000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<29.413100,-1.535000,14.739300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<29.413100,-1.535000,15.412800>}
box{<0,0,-0.203200><0.673500,0.035000,0.203200> rotate<0,90.000000,0> translate<29.413100,-1.535000,15.412800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<29.413100,-1.535000,15.036800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.708800,-1.535000,15.036800>}
box{<0,0,-0.203200><9.295700,0.035000,0.203200> rotate<0,0.000000,0> translate<29.413100,-1.535000,15.036800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<29.413100,-1.535000,15.412800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.876900,-1.535000,15.412800>}
box{<0,0,-0.203200><9.463800,0.035000,0.203200> rotate<0,0.000000,0> translate<29.413100,-1.535000,15.412800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<29.698000,-1.535000,6.096000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.551100,-1.535000,6.096000>}
box{<0,0,-0.203200><1.853100,0.035000,0.203200> rotate<0,0.000000,0> translate<29.698000,-1.535000,6.096000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.104400,-1.535000,5.689600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.296100,-1.535000,5.689600>}
box{<0,0,-0.203200><1.191700,0.035000,0.203200> rotate<0,0.000000,0> translate<30.104400,-1.535000,5.689600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.118100,-1.535000,5.675800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.118100,-1.535000,5.675900>}
box{<0,0,-0.203200><0.000100,0.035000,0.203200> rotate<0,90.000000,0> translate<30.118100,-1.535000,5.675900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.118100,-1.535000,5.675800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.661100,-1.535000,4.610200>}
box{<0,0,-0.203200><1.195973,0.035000,0.203200> rotate<0,62.993722,0> translate<30.118100,-1.535000,5.675800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.230100,-1.535000,1.401900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.661100,-1.535000,2.247700>}
box{<0,0,-0.203200><0.949283,0.035000,0.203200> rotate<0,-62.993510,0> translate<30.230100,-1.535000,1.401900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.230100,-1.535000,1.401900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.847600,-1.535000,1.401900>}
box{<0,0,-0.203200><8.617500,0.035000,0.203200> rotate<0,0.000000,0> translate<30.230100,-1.535000,1.401900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.318200,-1.535000,5.283200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.203900,-1.535000,5.283200>}
box{<0,0,-0.203200><0.885700,0.035000,0.203200> rotate<0,0.000000,0> translate<30.318200,-1.535000,5.283200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.344000,-1.535000,1.625600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.735900,-1.535000,1.625600>}
box{<0,0,-0.203200><8.391900,0.035000,0.203200> rotate<0,0.000000,0> translate<30.344000,-1.535000,1.625600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.525300,-1.535000,4.876800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.232800,-1.535000,4.876800>}
box{<0,0,-0.203200><0.707500,0.035000,0.203200> rotate<0,0.000000,0> translate<30.525300,-1.535000,4.876800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.551100,-1.535000,2.032000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.626900,-1.535000,2.032000>}
box{<0,0,-0.203200><8.075800,0.035000,0.203200> rotate<0,0.000000,0> translate<30.551100,-1.535000,2.032000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.661100,-1.535000,2.247700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.661100,-1.535000,2.247800>}
box{<0,0,-0.203200><0.000100,0.035000,0.203200> rotate<0,90.000000,0> translate<30.661100,-1.535000,2.247800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.661100,-1.535000,2.247800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.848200,-1.535000,3.429000>}
box{<0,0,-0.203200><1.195926,0.035000,0.203200> rotate<0,-80.993883,0> translate<30.661100,-1.535000,2.247800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.661100,-1.535000,4.610100>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.661100,-1.535000,4.610200>}
box{<0,0,-0.203200><0.000100,0.035000,0.203200> rotate<0,90.000000,0> translate<30.661100,-1.535000,4.610200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.661100,-1.535000,4.610100>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.848200,-1.535000,3.429000>}
box{<0,0,-0.203200><1.195828,0.035000,0.203200> rotate<0,80.993134,0> translate<30.661100,-1.535000,4.610100> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.683300,-1.535000,4.470400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.401100,-1.535000,4.470400>}
box{<0,0,-0.203200><0.717800,0.035000,0.203200> rotate<0,0.000000,0> translate<30.683300,-1.535000,4.470400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.691200,-1.535000,2.438400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.557200,-1.535000,2.438400>}
box{<0,0,-0.203200><7.866000,0.035000,0.203200> rotate<0,0.000000,0> translate<30.691200,-1.535000,2.438400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.747700,-1.535000,4.064000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.853000,-1.535000,4.064000>}
box{<0,0,-0.203200><1.105300,0.035000,0.203200> rotate<0,0.000000,0> translate<30.747700,-1.535000,4.064000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.755600,-1.535000,2.844800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.294200,-1.535000,2.844800>}
box{<0,0,-0.203200><3.538600,0.035000,0.203200> rotate<0,0.000000,0> translate<30.755600,-1.535000,2.844800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.812000,-1.535000,3.657600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.751800,-1.535000,3.657600>}
box{<0,0,-0.203200><2.939800,0.035000,0.203200> rotate<0,0.000000,0> translate<30.812000,-1.535000,3.657600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.820000,-1.535000,3.251200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.920100,-1.535000,3.251200>}
box{<0,0,-0.203200><3.100100,0.035000,0.203200> rotate<0,0.000000,0> translate<30.820000,-1.535000,3.251200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.203900,-1.535000,4.946700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.403000,-1.535000,4.466000>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,67.496813,0> translate<31.203900,-1.535000,4.946700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.203900,-1.535000,5.467200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.203900,-1.535000,4.946700>}
box{<0,0,-0.203200><0.520500,0.035000,0.203200> rotate<0,-90.000000,0> translate<31.203900,-1.535000,4.946700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.203900,-1.535000,5.467200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.403000,-1.535000,5.947900>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,-67.496813,0> translate<31.203900,-1.535000,5.467200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.203900,-1.535000,7.486700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.403000,-1.535000,7.006000>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,67.496813,0> translate<31.203900,-1.535000,7.486700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.203900,-1.535000,8.007200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.203900,-1.535000,7.486700>}
box{<0,0,-0.203200><0.520500,0.035000,0.203200> rotate<0,-90.000000,0> translate<31.203900,-1.535000,7.486700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.203900,-1.535000,8.007200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.403000,-1.535000,8.487900>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,-67.496813,0> translate<31.203900,-1.535000,8.007200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.203900,-1.535000,10.026700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.403000,-1.535000,9.546000>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,67.496813,0> translate<31.203900,-1.535000,10.026700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.203900,-1.535000,10.547200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.203900,-1.535000,10.026700>}
box{<0,0,-0.203200><0.520500,0.035000,0.203200> rotate<0,-90.000000,0> translate<31.203900,-1.535000,10.026700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.203900,-1.535000,10.547200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.403000,-1.535000,11.027900>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,-67.496813,0> translate<31.203900,-1.535000,10.547200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.356300,-1.535000,12.597000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.532200,-1.535000,12.172300>}
box{<0,0,-0.203200><0.459686,0.035000,0.203200> rotate<0,67.497445,0> translate<31.356300,-1.535000,12.597000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.356300,-1.535000,12.807800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.356300,-1.535000,12.597000>}
box{<0,0,-0.203200><0.210800,0.035000,0.203200> rotate<0,-90.000000,0> translate<31.356300,-1.535000,12.597000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.356300,-1.535000,12.807800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.492300,-1.535000,12.807800>}
box{<0,0,-0.203200><1.136000,0.035000,0.203200> rotate<0,0.000000,0> translate<31.356300,-1.535000,12.807800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.356300,-1.535000,12.846000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.492300,-1.535000,12.846000>}
box{<0,0,-0.203200><1.136000,0.035000,0.203200> rotate<0,0.000000,0> translate<31.356300,-1.535000,12.846000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.356300,-1.535000,13.056900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.356300,-1.535000,12.846000>}
box{<0,0,-0.203200><0.210900,0.035000,0.203200> rotate<0,-90.000000,0> translate<31.356300,-1.535000,12.846000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.356300,-1.535000,13.056900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.532200,-1.535000,13.481600>}
box{<0,0,-0.203200><0.459686,0.035000,0.203200> rotate<0,-67.497445,0> translate<31.356300,-1.535000,13.056900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.403000,-1.535000,4.466000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.771000,-1.535000,4.098000>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,44.997030,0> translate<31.403000,-1.535000,4.466000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.403000,-1.535000,5.947900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.771000,-1.535000,6.315900>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,-44.997030,0> translate<31.403000,-1.535000,5.947900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.403000,-1.535000,7.006000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.771000,-1.535000,6.638000>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,44.997030,0> translate<31.403000,-1.535000,7.006000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.403000,-1.535000,8.487900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.771000,-1.535000,8.855900>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,-44.997030,0> translate<31.403000,-1.535000,8.487900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.403000,-1.535000,9.546000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.771000,-1.535000,9.178000>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,44.997030,0> translate<31.403000,-1.535000,9.546000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.403000,-1.535000,11.027900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.771000,-1.535000,11.395900>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,-44.997030,0> translate<31.403000,-1.535000,11.027900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.532200,-1.535000,12.172300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.857300,-1.535000,11.847200>}
box{<0,0,-0.203200><0.459761,0.035000,0.203200> rotate<0,44.997030,0> translate<31.532200,-1.535000,12.172300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.532200,-1.535000,13.481600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.857300,-1.535000,13.806700>}
box{<0,0,-0.203200><0.459761,0.035000,0.203200> rotate<0,-44.997030,0> translate<31.532200,-1.535000,13.481600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.771000,-1.535000,4.098000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.251700,-1.535000,3.898900>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,22.497248,0> translate<31.771000,-1.535000,4.098000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.771000,-1.535000,6.315900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.160000,-1.535000,6.477000>}
box{<0,0,-0.203200><0.421039,0.035000,0.203200> rotate<0,-22.494860,0> translate<31.771000,-1.535000,6.315900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.771000,-1.535000,6.638000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.160000,-1.535000,6.477000>}
box{<0,0,-0.203200><0.421001,0.035000,0.203200> rotate<0,22.482287,0> translate<31.771000,-1.535000,6.638000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.771000,-1.535000,8.855900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.160000,-1.535000,9.016900>}
box{<0,0,-0.203200><0.421001,0.035000,0.203200> rotate<0,-22.482287,0> translate<31.771000,-1.535000,8.855900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.771000,-1.535000,9.178000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.160000,-1.535000,9.016900>}
box{<0,0,-0.203200><0.421039,0.035000,0.203200> rotate<0,22.494860,0> translate<31.771000,-1.535000,9.178000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.771000,-1.535000,11.395900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.251700,-1.535000,11.595000>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,-22.497248,0> translate<31.771000,-1.535000,11.395900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.857300,-1.535000,11.847200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.282000,-1.535000,11.671300>}
box{<0,0,-0.203200><0.459686,0.035000,0.203200> rotate<0,22.496615,0> translate<31.857300,-1.535000,11.847200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<31.857300,-1.535000,13.806700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.282000,-1.535000,13.982600>}
box{<0,0,-0.203200><0.459686,0.035000,0.203200> rotate<0,-22.496615,0> translate<31.857300,-1.535000,13.806700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.251700,-1.535000,3.898900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.772200,-1.535000,3.898900>}
box{<0,0,-0.203200><0.520500,0.035000,0.203200> rotate<0,0.000000,0> translate<32.251700,-1.535000,3.898900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.251700,-1.535000,11.595000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.772200,-1.535000,11.595000>}
box{<0,0,-0.203200><0.520500,0.035000,0.203200> rotate<0,0.000000,0> translate<32.251700,-1.535000,11.595000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.282000,-1.535000,11.671300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.492800,-1.535000,11.671300>}
box{<0,0,-0.203200><0.210800,0.035000,0.203200> rotate<0,0.000000,0> translate<32.282000,-1.535000,11.671300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.282000,-1.535000,13.982600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.492800,-1.535000,13.982600>}
box{<0,0,-0.203200><0.210800,0.035000,0.203200> rotate<0,0.000000,0> translate<32.282000,-1.535000,13.982600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.492300,-1.535000,12.846000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.492300,-1.535000,12.807800>}
box{<0,0,-0.203200><0.038200,0.035000,0.203200> rotate<0,-90.000000,0> translate<32.492300,-1.535000,12.807800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.492800,-1.535000,11.671300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.492800,-1.535000,12.807300>}
box{<0,0,-0.203200><1.136000,0.035000,0.203200> rotate<0,90.000000,0> translate<32.492800,-1.535000,12.807300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.492800,-1.535000,11.785600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.531000,-1.535000,11.785600>}
box{<0,0,-0.203200><0.038200,0.035000,0.203200> rotate<0,0.000000,0> translate<32.492800,-1.535000,11.785600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.492800,-1.535000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.531000,-1.535000,12.192000>}
box{<0,0,-0.203200><0.038200,0.035000,0.203200> rotate<0,0.000000,0> translate<32.492800,-1.535000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.492800,-1.535000,12.598400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.531000,-1.535000,12.598400>}
box{<0,0,-0.203200><0.038200,0.035000,0.203200> rotate<0,0.000000,0> translate<32.492800,-1.535000,12.598400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.492800,-1.535000,12.807300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.531000,-1.535000,12.807300>}
box{<0,0,-0.203200><0.038200,0.035000,0.203200> rotate<0,0.000000,0> translate<32.492800,-1.535000,12.807300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.492800,-1.535000,12.846600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.492800,-1.535000,13.982600>}
box{<0,0,-0.203200><1.136000,0.035000,0.203200> rotate<0,90.000000,0> translate<32.492800,-1.535000,13.982600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.492800,-1.535000,12.846600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.531000,-1.535000,12.846600>}
box{<0,0,-0.203200><0.038200,0.035000,0.203200> rotate<0,0.000000,0> translate<32.492800,-1.535000,12.846600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.492800,-1.535000,13.004800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.531000,-1.535000,13.004800>}
box{<0,0,-0.203200><0.038200,0.035000,0.203200> rotate<0,0.000000,0> translate<32.492800,-1.535000,13.004800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.492800,-1.535000,13.411200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.531000,-1.535000,13.411200>}
box{<0,0,-0.203200><0.038200,0.035000,0.203200> rotate<0,0.000000,0> translate<32.492800,-1.535000,13.411200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.492800,-1.535000,13.817600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.531000,-1.535000,13.817600>}
box{<0,0,-0.203200><0.038200,0.035000,0.203200> rotate<0,0.000000,0> translate<32.492800,-1.535000,13.817600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.531000,-1.535000,11.671300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.741900,-1.535000,11.671300>}
box{<0,0,-0.203200><0.210900,0.035000,0.203200> rotate<0,0.000000,0> translate<32.531000,-1.535000,11.671300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.531000,-1.535000,12.807300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.531000,-1.535000,11.671300>}
box{<0,0,-0.203200><1.136000,0.035000,0.203200> rotate<0,-90.000000,0> translate<32.531000,-1.535000,11.671300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.531000,-1.535000,13.982600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.531000,-1.535000,12.846600>}
box{<0,0,-0.203200><1.136000,0.035000,0.203200> rotate<0,-90.000000,0> translate<32.531000,-1.535000,12.846600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.531000,-1.535000,13.982600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.741900,-1.535000,13.982600>}
box{<0,0,-0.203200><0.210900,0.035000,0.203200> rotate<0,0.000000,0> translate<32.531000,-1.535000,13.982600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.531600,-1.535000,12.807800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.531600,-1.535000,12.846000>}
box{<0,0,-0.203200><0.038200,0.035000,0.203200> rotate<0,90.000000,0> translate<32.531600,-1.535000,12.846000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.531600,-1.535000,12.807800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.667600,-1.535000,12.807800>}
box{<0,0,-0.203200><1.136000,0.035000,0.203200> rotate<0,0.000000,0> translate<32.531600,-1.535000,12.807800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.531600,-1.535000,12.846000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.667600,-1.535000,12.846000>}
box{<0,0,-0.203200><1.136000,0.035000,0.203200> rotate<0,0.000000,0> translate<32.531600,-1.535000,12.846000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.741900,-1.535000,11.671300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.166600,-1.535000,11.847200>}
box{<0,0,-0.203200><0.459686,0.035000,0.203200> rotate<0,-22.496615,0> translate<32.741900,-1.535000,11.671300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.741900,-1.535000,13.982600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.166600,-1.535000,13.806700>}
box{<0,0,-0.203200><0.459686,0.035000,0.203200> rotate<0,22.496615,0> translate<32.741900,-1.535000,13.982600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.772200,-1.535000,3.898900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.252900,-1.535000,4.098000>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,-22.497248,0> translate<32.772200,-1.535000,3.898900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.772200,-1.535000,11.595000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.252900,-1.535000,11.395900>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,22.497248,0> translate<32.772200,-1.535000,11.595000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.863900,-1.535000,6.477000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.252900,-1.535000,6.315900>}
box{<0,0,-0.203200><0.421039,0.035000,0.203200> rotate<0,22.494860,0> translate<32.863900,-1.535000,6.477000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.863900,-1.535000,6.477000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.252900,-1.535000,6.638000>}
box{<0,0,-0.203200><0.421001,0.035000,0.203200> rotate<0,-22.482287,0> translate<32.863900,-1.535000,6.477000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.863900,-1.535000,9.016900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.252900,-1.535000,8.855900>}
box{<0,0,-0.203200><0.421001,0.035000,0.203200> rotate<0,22.482287,0> translate<32.863900,-1.535000,9.016900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.863900,-1.535000,9.016900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.252900,-1.535000,9.178000>}
box{<0,0,-0.203200><0.421039,0.035000,0.203200> rotate<0,-22.494860,0> translate<32.863900,-1.535000,9.016900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<32.925200,-1.535000,6.502400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.743900,-1.535000,6.502400>}
box{<0,0,-0.203200><0.818700,0.035000,0.203200> rotate<0,0.000000,0> translate<32.925200,-1.535000,6.502400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.017800,-1.535000,11.785600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.896300,-1.535000,11.785600>}
box{<0,0,-0.203200><0.878500,0.035000,0.203200> rotate<0,0.000000,0> translate<33.017800,-1.535000,11.785600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.047800,-1.535000,8.940800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.743900,-1.535000,8.940800>}
box{<0,0,-0.203200><0.696100,0.035000,0.203200> rotate<0,0.000000,0> translate<33.047800,-1.535000,8.940800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.140300,-1.535000,13.817600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.557200,-1.535000,13.817600>}
box{<0,0,-0.203200><5.416900,0.035000,0.203200> rotate<0,0.000000,0> translate<33.140300,-1.535000,13.817600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.166600,-1.535000,11.847200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.491700,-1.535000,12.172300>}
box{<0,0,-0.203200><0.459761,0.035000,0.203200> rotate<0,-44.997030,0> translate<33.166600,-1.535000,11.847200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.166600,-1.535000,13.806700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.491700,-1.535000,13.481600>}
box{<0,0,-0.203200><0.459761,0.035000,0.203200> rotate<0,44.997030,0> translate<33.166600,-1.535000,13.806700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.170800,-1.535000,4.064000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.743900,-1.535000,4.064000>}
box{<0,0,-0.203200><0.573100,0.035000,0.203200> rotate<0,0.000000,0> translate<33.170800,-1.535000,4.064000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.252900,-1.535000,4.098000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.620900,-1.535000,4.466000>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,-44.997030,0> translate<33.252900,-1.535000,4.098000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.252900,-1.535000,6.315900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.620900,-1.535000,5.947900>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,44.997030,0> translate<33.252900,-1.535000,6.315900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.252900,-1.535000,6.638000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.620900,-1.535000,7.006000>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,-44.997030,0> translate<33.252900,-1.535000,6.638000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.252900,-1.535000,8.855900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.620900,-1.535000,8.487900>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,44.997030,0> translate<33.252900,-1.535000,8.855900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.252900,-1.535000,9.178000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.620900,-1.535000,9.546000>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,-44.997030,0> translate<33.252900,-1.535000,9.178000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.252900,-1.535000,11.395900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.620900,-1.535000,11.027900>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,44.997030,0> translate<33.252900,-1.535000,11.395900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.269600,-1.535000,11.379200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.896300,-1.535000,11.379200>}
box{<0,0,-0.203200><0.626700,0.035000,0.203200> rotate<0,0.000000,0> translate<33.269600,-1.535000,11.379200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.422100,-1.535000,9.347200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.772900,-1.535000,9.347200>}
box{<0,0,-0.203200><0.350800,0.035000,0.203200> rotate<0,0.000000,0> translate<33.422100,-1.535000,9.347200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.472800,-1.535000,6.096000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.793800,-1.535000,6.096000>}
box{<0,0,-0.203200><0.321000,0.035000,0.203200> rotate<0,0.000000,0> translate<33.472800,-1.535000,6.096000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.491700,-1.535000,12.172300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.667600,-1.535000,12.597000>}
box{<0,0,-0.203200><0.459686,0.035000,0.203200> rotate<0,-67.497445,0> translate<33.491700,-1.535000,12.172300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.491700,-1.535000,13.481600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.667600,-1.535000,13.056900>}
box{<0,0,-0.203200><0.459686,0.035000,0.203200> rotate<0,67.497445,0> translate<33.491700,-1.535000,13.481600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.499800,-1.535000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.064100,-1.535000,12.192000>}
box{<0,0,-0.203200><0.564300,0.035000,0.203200> rotate<0,0.000000,0> translate<33.499800,-1.535000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.520900,-1.535000,13.411200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.640600,-1.535000,13.411200>}
box{<0,0,-0.203200><5.119700,0.035000,0.203200> rotate<0,0.000000,0> translate<33.520900,-1.535000,13.411200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.523700,-1.535000,6.908800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.815000,-1.535000,6.908800>}
box{<0,0,-0.203200><0.291300,0.035000,0.203200> rotate<0,0.000000,0> translate<33.523700,-1.535000,6.908800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.574400,-1.535000,8.534400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.835900,-1.535000,8.534400>}
box{<0,0,-0.203200><0.261500,0.035000,0.203200> rotate<0,0.000000,0> translate<33.574400,-1.535000,8.534400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.620900,-1.535000,4.466000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.820000,-1.535000,4.946700>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,-67.496813,0> translate<33.620900,-1.535000,4.466000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.620900,-1.535000,5.947900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.820000,-1.535000,5.467200>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,67.496813,0> translate<33.620900,-1.535000,5.947900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.620900,-1.535000,7.006000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.820000,-1.535000,7.486700>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,-67.496813,0> translate<33.620900,-1.535000,7.006000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.620900,-1.535000,8.487900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.820000,-1.535000,8.007200>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,67.496813,0> translate<33.620900,-1.535000,8.487900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.620900,-1.535000,9.546000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.820000,-1.535000,10.026700>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,-67.496813,0> translate<33.620900,-1.535000,9.546000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.620900,-1.535000,11.027900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.820000,-1.535000,10.547200>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,67.496813,0> translate<33.620900,-1.535000,11.027900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.622700,-1.535000,4.470400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.857100,-1.535000,4.470400>}
box{<0,0,-0.203200><0.234400,0.035000,0.203200> rotate<0,0.000000,0> translate<33.622700,-1.535000,4.470400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.643800,-1.535000,10.972800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.043000,-1.535000,10.972800>}
box{<0,0,-0.203200><0.399200,0.035000,0.203200> rotate<0,0.000000,0> translate<33.643800,-1.535000,10.972800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.667600,-1.535000,12.597000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.667600,-1.535000,12.807800>}
box{<0,0,-0.203200><0.210800,0.035000,0.203200> rotate<0,90.000000,0> translate<33.667600,-1.535000,12.807800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.667600,-1.535000,12.598400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.546300,-1.535000,12.598400>}
box{<0,0,-0.203200><0.878700,0.035000,0.203200> rotate<0,0.000000,0> translate<33.667600,-1.535000,12.598400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.667600,-1.535000,12.846000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.667600,-1.535000,13.056900>}
box{<0,0,-0.203200><0.210900,0.035000,0.203200> rotate<0,90.000000,0> translate<33.667600,-1.535000,13.056900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.667600,-1.535000,13.004800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.749500,-1.535000,13.004800>}
box{<0,0,-0.203200><5.081900,0.035000,0.203200> rotate<0,0.000000,0> translate<33.667600,-1.535000,13.004800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.706800,-1.535000,9.753600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.941300,-1.535000,9.753600>}
box{<0,0,-0.203200><0.234500,0.035000,0.203200> rotate<0,0.000000,0> translate<33.706800,-1.535000,9.753600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.727900,-1.535000,5.689600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.989400,-1.535000,5.689600>}
box{<0,0,-0.203200><0.261500,0.035000,0.203200> rotate<0,0.000000,0> translate<33.727900,-1.535000,5.689600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.743900,-1.535000,3.676700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.943000,-1.535000,3.196000>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,67.496813,0> translate<33.743900,-1.535000,3.676700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.743900,-1.535000,4.197200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.743900,-1.535000,3.676700>}
box{<0,0,-0.203200><0.520500,0.035000,0.203200> rotate<0,-90.000000,0> translate<33.743900,-1.535000,3.676700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.743900,-1.535000,4.197200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.943000,-1.535000,4.677900>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,-67.496813,0> translate<33.743900,-1.535000,4.197200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.743900,-1.535000,6.216700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.943000,-1.535000,5.736000>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,67.496813,0> translate<33.743900,-1.535000,6.216700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.743900,-1.535000,6.737200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.743900,-1.535000,6.216700>}
box{<0,0,-0.203200><0.520500,0.035000,0.203200> rotate<0,-90.000000,0> translate<33.743900,-1.535000,6.216700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.743900,-1.535000,6.737200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.943000,-1.535000,7.217900>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,-67.496813,0> translate<33.743900,-1.535000,6.737200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.743900,-1.535000,8.756700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.943000,-1.535000,8.276000>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,67.496813,0> translate<33.743900,-1.535000,8.756700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.743900,-1.535000,9.277200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.743900,-1.535000,8.756700>}
box{<0,0,-0.203200><0.520500,0.035000,0.203200> rotate<0,-90.000000,0> translate<33.743900,-1.535000,8.756700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.743900,-1.535000,9.277200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.943000,-1.535000,9.757900>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,-67.496813,0> translate<33.743900,-1.535000,9.277200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.748900,-1.535000,7.315200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.040300,-1.535000,7.315200>}
box{<0,0,-0.203200><0.291400,0.035000,0.203200> rotate<0,0.000000,0> translate<33.748900,-1.535000,7.315200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.770000,-1.535000,8.128000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.091000,-1.535000,8.128000>}
box{<0,0,-0.203200><0.321000,0.035000,0.203200> rotate<0,0.000000,0> translate<33.770000,-1.535000,8.128000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.791000,-1.535000,4.876800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.141900,-1.535000,4.876800>}
box{<0,0,-0.203200><0.350900,0.035000,0.203200> rotate<0,0.000000,0> translate<33.791000,-1.535000,4.876800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.812100,-1.535000,10.566400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.423300,-1.535000,10.566400>}
box{<0,0,-0.203200><0.611200,0.035000,0.203200> rotate<0,0.000000,0> translate<33.812100,-1.535000,10.566400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.820000,-1.535000,4.946700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.820000,-1.535000,5.467200>}
box{<0,0,-0.203200><0.520500,0.035000,0.203200> rotate<0,90.000000,0> translate<33.820000,-1.535000,5.467200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.820000,-1.535000,5.283200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.515800,-1.535000,5.283200>}
box{<0,0,-0.203200><0.695800,0.035000,0.203200> rotate<0,0.000000,0> translate<33.820000,-1.535000,5.283200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.820000,-1.535000,7.486700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.820000,-1.535000,8.007200>}
box{<0,0,-0.203200><0.520500,0.035000,0.203200> rotate<0,90.000000,0> translate<33.820000,-1.535000,8.007200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.820000,-1.535000,7.721600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.638900,-1.535000,7.721600>}
box{<0,0,-0.203200><0.818900,0.035000,0.203200> rotate<0,0.000000,0> translate<33.820000,-1.535000,7.721600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.820000,-1.535000,10.026700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.820000,-1.535000,10.547200>}
box{<0,0,-0.203200><0.520500,0.035000,0.203200> rotate<0,90.000000,0> translate<33.820000,-1.535000,10.547200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.820000,-1.535000,10.160000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.393400,-1.535000,10.160000>}
box{<0,0,-0.203200><0.573400,0.035000,0.203200> rotate<0,0.000000,0> translate<33.820000,-1.535000,10.160000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.896300,-1.535000,11.327000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.072200,-1.535000,10.902300>}
box{<0,0,-0.203200><0.459686,0.035000,0.203200> rotate<0,67.497445,0> translate<33.896300,-1.535000,11.327000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.896300,-1.535000,11.537800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.896300,-1.535000,11.327000>}
box{<0,0,-0.203200><0.210800,0.035000,0.203200> rotate<0,-90.000000,0> translate<33.896300,-1.535000,11.327000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.896300,-1.535000,11.537800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.032300,-1.535000,11.537800>}
box{<0,0,-0.203200><1.136000,0.035000,0.203200> rotate<0,0.000000,0> translate<33.896300,-1.535000,11.537800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.896300,-1.535000,11.576000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.032300,-1.535000,11.576000>}
box{<0,0,-0.203200><1.136000,0.035000,0.203200> rotate<0,0.000000,0> translate<33.896300,-1.535000,11.576000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.896300,-1.535000,11.786900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.896300,-1.535000,11.576000>}
box{<0,0,-0.203200><0.210900,0.035000,0.203200> rotate<0,-90.000000,0> translate<33.896300,-1.535000,11.576000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.896300,-1.535000,11.786900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.072200,-1.535000,12.211600>}
box{<0,0,-0.203200><0.459686,0.035000,0.203200> rotate<0,-67.497445,0> translate<33.896300,-1.535000,11.786900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.943000,-1.535000,3.196000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.311000,-1.535000,2.828000>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,44.997030,0> translate<33.943000,-1.535000,3.196000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.943000,-1.535000,4.677900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.311000,-1.535000,5.045900>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,-44.997030,0> translate<33.943000,-1.535000,4.677900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.943000,-1.535000,5.736000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.311000,-1.535000,5.368000>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,44.997030,0> translate<33.943000,-1.535000,5.736000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.943000,-1.535000,7.217900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.311000,-1.535000,7.585900>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,-44.997030,0> translate<33.943000,-1.535000,7.217900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.943000,-1.535000,8.276000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.311000,-1.535000,7.908000>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,44.997030,0> translate<33.943000,-1.535000,8.276000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.943000,-1.535000,9.757900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.311000,-1.535000,10.125900>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,-44.997030,0> translate<33.943000,-1.535000,9.757900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.072200,-1.535000,10.902300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.397300,-1.535000,10.577200>}
box{<0,0,-0.203200><0.459761,0.035000,0.203200> rotate<0,44.997030,0> translate<34.072200,-1.535000,10.902300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.072200,-1.535000,12.211600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.397300,-1.535000,12.536700>}
box{<0,0,-0.203200><0.459761,0.035000,0.203200> rotate<0,-44.997030,0> translate<34.072200,-1.535000,12.211600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.311000,-1.535000,2.828000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.791700,-1.535000,2.628900>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,22.497248,0> translate<34.311000,-1.535000,2.828000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.311000,-1.535000,5.045900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.700000,-1.535000,5.207000>}
box{<0,0,-0.203200><0.421039,0.035000,0.203200> rotate<0,-22.494860,0> translate<34.311000,-1.535000,5.045900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.311000,-1.535000,5.368000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.700000,-1.535000,5.207000>}
box{<0,0,-0.203200><0.421001,0.035000,0.203200> rotate<0,22.482287,0> translate<34.311000,-1.535000,5.368000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.311000,-1.535000,7.585900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.700000,-1.535000,7.746900>}
box{<0,0,-0.203200><0.421001,0.035000,0.203200> rotate<0,-22.482287,0> translate<34.311000,-1.535000,7.585900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.311000,-1.535000,7.908000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.700000,-1.535000,7.746900>}
box{<0,0,-0.203200><0.421039,0.035000,0.203200> rotate<0,22.494860,0> translate<34.311000,-1.535000,7.908000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.311000,-1.535000,10.125900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.791700,-1.535000,10.325000>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,-22.497248,0> translate<34.311000,-1.535000,10.125900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.397300,-1.535000,10.577200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.822000,-1.535000,10.401300>}
box{<0,0,-0.203200><0.459686,0.035000,0.203200> rotate<0,22.496615,0> translate<34.397300,-1.535000,10.577200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.397300,-1.535000,12.536700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.822000,-1.535000,12.712600>}
box{<0,0,-0.203200><0.459686,0.035000,0.203200> rotate<0,-22.496615,0> translate<34.397300,-1.535000,12.536700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.791700,-1.535000,2.628900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.312200,-1.535000,2.628900>}
box{<0,0,-0.203200><0.520500,0.035000,0.203200> rotate<0,0.000000,0> translate<34.791700,-1.535000,2.628900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.791700,-1.535000,10.325000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.312200,-1.535000,10.325000>}
box{<0,0,-0.203200><0.520500,0.035000,0.203200> rotate<0,0.000000,0> translate<34.791700,-1.535000,10.325000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.822000,-1.535000,10.401300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.032800,-1.535000,10.401300>}
box{<0,0,-0.203200><0.210800,0.035000,0.203200> rotate<0,0.000000,0> translate<34.822000,-1.535000,10.401300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.822000,-1.535000,12.712600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.032800,-1.535000,12.712600>}
box{<0,0,-0.203200><0.210800,0.035000,0.203200> rotate<0,0.000000,0> translate<34.822000,-1.535000,12.712600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.032300,-1.535000,11.576000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.032300,-1.535000,11.537800>}
box{<0,0,-0.203200><0.038200,0.035000,0.203200> rotate<0,-90.000000,0> translate<35.032300,-1.535000,11.537800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.032800,-1.535000,10.401300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.032800,-1.535000,11.537300>}
box{<0,0,-0.203200><1.136000,0.035000,0.203200> rotate<0,90.000000,0> translate<35.032800,-1.535000,11.537300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.032800,-1.535000,10.566400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.071000,-1.535000,10.566400>}
box{<0,0,-0.203200><0.038200,0.035000,0.203200> rotate<0,0.000000,0> translate<35.032800,-1.535000,10.566400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.032800,-1.535000,10.972800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.071000,-1.535000,10.972800>}
box{<0,0,-0.203200><0.038200,0.035000,0.203200> rotate<0,0.000000,0> translate<35.032800,-1.535000,10.972800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.032800,-1.535000,11.379200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.071000,-1.535000,11.379200>}
box{<0,0,-0.203200><0.038200,0.035000,0.203200> rotate<0,0.000000,0> translate<35.032800,-1.535000,11.379200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.032800,-1.535000,11.537300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.071000,-1.535000,11.537300>}
box{<0,0,-0.203200><0.038200,0.035000,0.203200> rotate<0,0.000000,0> translate<35.032800,-1.535000,11.537300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.032800,-1.535000,11.576600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.032800,-1.535000,12.712600>}
box{<0,0,-0.203200><1.136000,0.035000,0.203200> rotate<0,90.000000,0> translate<35.032800,-1.535000,12.712600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.032800,-1.535000,11.576600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.071000,-1.535000,11.576600>}
box{<0,0,-0.203200><0.038200,0.035000,0.203200> rotate<0,0.000000,0> translate<35.032800,-1.535000,11.576600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.032800,-1.535000,11.785600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.071000,-1.535000,11.785600>}
box{<0,0,-0.203200><0.038200,0.035000,0.203200> rotate<0,0.000000,0> translate<35.032800,-1.535000,11.785600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.032800,-1.535000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.071000,-1.535000,12.192000>}
box{<0,0,-0.203200><0.038200,0.035000,0.203200> rotate<0,0.000000,0> translate<35.032800,-1.535000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.032800,-1.535000,12.598400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.071000,-1.535000,12.598400>}
box{<0,0,-0.203200><0.038200,0.035000,0.203200> rotate<0,0.000000,0> translate<35.032800,-1.535000,12.598400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.071000,-1.535000,10.401300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.281900,-1.535000,10.401300>}
box{<0,0,-0.203200><0.210900,0.035000,0.203200> rotate<0,0.000000,0> translate<35.071000,-1.535000,10.401300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.071000,-1.535000,11.537300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.071000,-1.535000,10.401300>}
box{<0,0,-0.203200><1.136000,0.035000,0.203200> rotate<0,-90.000000,0> translate<35.071000,-1.535000,10.401300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.071000,-1.535000,12.712600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.071000,-1.535000,11.576600>}
box{<0,0,-0.203200><1.136000,0.035000,0.203200> rotate<0,-90.000000,0> translate<35.071000,-1.535000,11.576600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.071000,-1.535000,12.712600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.281900,-1.535000,12.712600>}
box{<0,0,-0.203200><0.210900,0.035000,0.203200> rotate<0,0.000000,0> translate<35.071000,-1.535000,12.712600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.071600,-1.535000,11.537800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.071600,-1.535000,11.576000>}
box{<0,0,-0.203200><0.038200,0.035000,0.203200> rotate<0,90.000000,0> translate<35.071600,-1.535000,11.576000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.071600,-1.535000,11.537800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.207600,-1.535000,11.537800>}
box{<0,0,-0.203200><1.136000,0.035000,0.203200> rotate<0,0.000000,0> translate<35.071600,-1.535000,11.537800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.071600,-1.535000,11.576000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.207600,-1.535000,11.576000>}
box{<0,0,-0.203200><1.136000,0.035000,0.203200> rotate<0,0.000000,0> translate<35.071600,-1.535000,11.576000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.281900,-1.535000,10.401300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.706600,-1.535000,10.577200>}
box{<0,0,-0.203200><0.459686,0.035000,0.203200> rotate<0,-22.496615,0> translate<35.281900,-1.535000,10.401300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.281900,-1.535000,12.712600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.706600,-1.535000,12.536700>}
box{<0,0,-0.203200><0.459686,0.035000,0.203200> rotate<0,22.496615,0> translate<35.281900,-1.535000,12.712600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.312200,-1.535000,2.628900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.792900,-1.535000,2.828000>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,-22.497248,0> translate<35.312200,-1.535000,2.628900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.312200,-1.535000,10.325000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.792900,-1.535000,10.125900>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,22.497248,0> translate<35.312200,-1.535000,10.325000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.403900,-1.535000,5.207000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.792900,-1.535000,5.045900>}
box{<0,0,-0.203200><0.421039,0.035000,0.203200> rotate<0,22.494860,0> translate<35.403900,-1.535000,5.207000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.403900,-1.535000,5.207000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.792900,-1.535000,5.368000>}
box{<0,0,-0.203200><0.421001,0.035000,0.203200> rotate<0,-22.482287,0> translate<35.403900,-1.535000,5.207000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.403900,-1.535000,7.746900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.792900,-1.535000,7.585900>}
box{<0,0,-0.203200><0.421001,0.035000,0.203200> rotate<0,22.482287,0> translate<35.403900,-1.535000,7.746900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.403900,-1.535000,7.746900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.792900,-1.535000,7.908000>}
box{<0,0,-0.203200><0.421039,0.035000,0.203200> rotate<0,-22.494860,0> translate<35.403900,-1.535000,7.746900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.465100,-1.535000,7.721600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.159500,-1.535000,7.721600>}
box{<0,0,-0.203200><1.694400,0.035000,0.203200> rotate<0,0.000000,0> translate<35.465100,-1.535000,7.721600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.557700,-1.535000,12.598400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.982300,-1.535000,12.598400>}
box{<0,0,-0.203200><3.424600,0.035000,0.203200> rotate<0,0.000000,0> translate<35.557700,-1.535000,12.598400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.588000,-1.535000,5.283200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.117400,-1.535000,5.283200>}
box{<0,0,-0.203200><1.529400,0.035000,0.203200> rotate<0,0.000000,0> translate<35.588000,-1.535000,5.283200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.680500,-1.535000,10.566400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.198200,-1.535000,10.566400>}
box{<0,0,-0.203200><1.517700,0.035000,0.203200> rotate<0,0.000000,0> translate<35.680500,-1.535000,10.566400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.706600,-1.535000,10.577200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.031700,-1.535000,10.902300>}
box{<0,0,-0.203200><0.459761,0.035000,0.203200> rotate<0,-44.997030,0> translate<35.706600,-1.535000,10.577200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.706600,-1.535000,12.536700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.031700,-1.535000,12.211600>}
box{<0,0,-0.203200><0.459761,0.035000,0.203200> rotate<0,44.997030,0> translate<35.706600,-1.535000,12.536700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.710600,-1.535000,10.160000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.411100,-1.535000,10.160000>}
box{<0,0,-0.203200><1.700500,0.035000,0.203200> rotate<0,0.000000,0> translate<35.710600,-1.535000,10.160000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.792900,-1.535000,2.828000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.160900,-1.535000,3.196000>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,-44.997030,0> translate<35.792900,-1.535000,2.828000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.792900,-1.535000,5.045900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.160900,-1.535000,4.677900>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,44.997030,0> translate<35.792900,-1.535000,5.045900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.792900,-1.535000,5.368000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.160900,-1.535000,5.736000>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,-44.997030,0> translate<35.792900,-1.535000,5.368000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.792900,-1.535000,7.585900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.160900,-1.535000,7.217900>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,44.997030,0> translate<35.792900,-1.535000,7.585900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.792900,-1.535000,7.908000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.160900,-1.535000,8.276000>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,-44.997030,0> translate<35.792900,-1.535000,7.908000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.792900,-1.535000,10.125900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.160900,-1.535000,9.757900>}
box{<0,0,-0.203200><0.520431,0.035000,0.203200> rotate<0,44.997030,0> translate<35.792900,-1.535000,10.125900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.809700,-1.535000,2.844800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.557200,-1.535000,2.844800>}
box{<0,0,-0.203200><2.747500,0.035000,0.203200> rotate<0,0.000000,0> translate<35.809700,-1.535000,2.844800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.962000,-1.535000,4.876800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.398700,-1.535000,4.876800>}
box{<0,0,-0.203200><1.436700,0.035000,0.203200> rotate<0,0.000000,0> translate<35.962000,-1.535000,4.876800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.012900,-1.535000,8.128000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.998400,-1.535000,8.128000>}
box{<0,0,-0.203200><0.985500,0.035000,0.203200> rotate<0,0.000000,0> translate<36.012900,-1.535000,8.128000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.031700,-1.535000,10.902300>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.207600,-1.535000,11.327000>}
box{<0,0,-0.203200><0.459686,0.035000,0.203200> rotate<0,-67.497445,0> translate<36.031700,-1.535000,10.902300> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.031700,-1.535000,12.211600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.207600,-1.535000,11.786900>}
box{<0,0,-0.203200><0.459686,0.035000,0.203200> rotate<0,67.497445,0> translate<36.031700,-1.535000,12.211600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.039900,-1.535000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.283800,-1.535000,12.192000>}
box{<0,0,-0.203200><3.243900,0.035000,0.203200> rotate<0,0.000000,0> translate<36.039900,-1.535000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.060800,-1.535000,10.972800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.150800,-1.535000,10.972800>}
box{<0,0,-0.203200><1.090000,0.035000,0.203200> rotate<0,0.000000,0> translate<36.060800,-1.535000,10.972800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.063600,-1.535000,7.315200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.500300,-1.535000,7.315200>}
box{<0,0,-0.203200><1.436700,0.035000,0.203200> rotate<0,0.000000,0> translate<36.063600,-1.535000,7.315200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.114500,-1.535000,5.689600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.998400,-1.535000,5.689600>}
box{<0,0,-0.203200><0.883900,0.035000,0.203200> rotate<0,0.000000,0> translate<36.114500,-1.535000,5.689600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.160900,-1.535000,3.196000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.360000,-1.535000,3.676700>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,-67.496813,0> translate<36.160900,-1.535000,3.196000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.160900,-1.535000,4.677900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.360000,-1.535000,4.197200>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,67.496813,0> translate<36.160900,-1.535000,4.677900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.160900,-1.535000,5.736000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.360000,-1.535000,6.216700>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,-67.496813,0> translate<36.160900,-1.535000,5.736000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.160900,-1.535000,7.217900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.360000,-1.535000,6.737200>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,67.496813,0> translate<36.160900,-1.535000,7.217900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.160900,-1.535000,8.276000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.360000,-1.535000,8.756700>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,-67.496813,0> translate<36.160900,-1.535000,8.276000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.160900,-1.535000,9.757900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.360000,-1.535000,9.277200>}
box{<0,0,-0.203200><0.520301,0.035000,0.203200> rotate<0,67.496813,0> translate<36.160900,-1.535000,9.757900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.162700,-1.535000,9.753600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.017700,-1.535000,9.753600>}
box{<0,0,-0.203200><1.855000,0.035000,0.203200> rotate<0,0.000000,0> translate<36.162700,-1.535000,9.753600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.183700,-1.535000,3.251200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.613500,-1.535000,3.251200>}
box{<0,0,-0.203200><2.429800,0.035000,0.203200> rotate<0,0.000000,0> translate<36.183700,-1.535000,3.251200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.207600,-1.535000,11.327000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.207600,-1.535000,11.537800>}
box{<0,0,-0.203200><0.210800,0.035000,0.203200> rotate<0,90.000000,0> translate<36.207600,-1.535000,11.537800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.207600,-1.535000,11.379200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.240500,-1.535000,11.379200>}
box{<0,0,-0.203200><1.032900,0.035000,0.203200> rotate<0,0.000000,0> translate<36.207600,-1.535000,11.379200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.207600,-1.535000,11.576000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.207600,-1.535000,11.786900>}
box{<0,0,-0.203200><0.210900,0.035000,0.203200> rotate<0,90.000000,0> translate<36.207600,-1.535000,11.786900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.207600,-1.535000,11.785600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.512800,-1.535000,11.785600>}
box{<0,0,-0.203200><1.305200,0.035000,0.203200> rotate<0,0.000000,0> translate<36.207600,-1.535000,11.785600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.246900,-1.535000,4.470400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.182400,-1.535000,4.470400>}
box{<0,0,-0.203200><2.935500,0.035000,0.203200> rotate<0,0.000000,0> translate<36.246900,-1.535000,4.470400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.267900,-1.535000,8.534400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.998400,-1.535000,8.534400>}
box{<0,0,-0.203200><0.730500,0.035000,0.203200> rotate<0,0.000000,0> translate<36.267900,-1.535000,8.534400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.289000,-1.535000,6.908800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.500400,-1.535000,6.908800>}
box{<0,0,-0.203200><1.211400,0.035000,0.203200> rotate<0,0.000000,0> translate<36.289000,-1.535000,6.908800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.310000,-1.535000,6.096000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.998400,-1.535000,6.096000>}
box{<0,0,-0.203200><0.688400,0.035000,0.203200> rotate<0,0.000000,0> translate<36.310000,-1.535000,6.096000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.331100,-1.535000,9.347200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.398800,-1.535000,9.347200>}
box{<0,0,-0.203200><1.067700,0.035000,0.203200> rotate<0,0.000000,0> translate<36.331100,-1.535000,9.347200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.352000,-1.535000,3.657600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.722400,-1.535000,3.657600>}
box{<0,0,-0.203200><2.370400,0.035000,0.203200> rotate<0,0.000000,0> translate<36.352000,-1.535000,3.657600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.360000,-1.535000,3.676700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.360000,-1.535000,4.197200>}
box{<0,0,-0.203200><0.520500,0.035000,0.203200> rotate<0,90.000000,0> translate<36.360000,-1.535000,4.197200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.360000,-1.535000,4.064000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.923800,-1.535000,4.064000>}
box{<0,0,-0.203200><2.563800,0.035000,0.203200> rotate<0,0.000000,0> translate<36.360000,-1.535000,4.064000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.360000,-1.535000,6.216700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.360000,-1.535000,6.737200>}
box{<0,0,-0.203200><0.520500,0.035000,0.203200> rotate<0,90.000000,0> translate<36.360000,-1.535000,6.737200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.360000,-1.535000,6.502400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.159700,-1.535000,6.502400>}
box{<0,0,-0.203200><0.799700,0.035000,0.203200> rotate<0,0.000000,0> translate<36.360000,-1.535000,6.502400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.360000,-1.535000,8.756700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.360000,-1.535000,9.277200>}
box{<0,0,-0.203200><0.520500,0.035000,0.203200> rotate<0,90.000000,0> translate<36.360000,-1.535000,9.277200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.360000,-1.535000,8.940800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.117600,-1.535000,8.940800>}
box{<0,0,-0.203200><0.757600,0.035000,0.203200> rotate<0,0.000000,0> translate<36.360000,-1.535000,8.940800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.998400,-1.535000,5.570700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.206000,-1.535000,5.069500>}
box{<0,0,-0.203200><0.542494,0.035000,0.203200> rotate<0,67.495920,0> translate<36.998400,-1.535000,5.570700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.998400,-1.535000,6.113200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.998400,-1.535000,5.570700>}
box{<0,0,-0.203200><0.542500,0.035000,0.203200> rotate<0,-90.000000,0> translate<36.998400,-1.535000,5.570700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.998400,-1.535000,6.113200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.206000,-1.535000,6.614400>}
box{<0,0,-0.203200><0.542494,0.035000,0.203200> rotate<0,-67.495920,0> translate<36.998400,-1.535000,6.113200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.998400,-1.535000,8.110700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.206000,-1.535000,7.609500>}
box{<0,0,-0.203200><0.542494,0.035000,0.203200> rotate<0,67.495920,0> translate<36.998400,-1.535000,8.110700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.998400,-1.535000,8.653200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.998400,-1.535000,8.110700>}
box{<0,0,-0.203200><0.542500,0.035000,0.203200> rotate<0,-90.000000,0> translate<36.998400,-1.535000,8.110700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.998400,-1.535000,8.653200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.206000,-1.535000,9.154400>}
box{<0,0,-0.203200><0.542494,0.035000,0.203200> rotate<0,-67.495920,0> translate<36.998400,-1.535000,8.653200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.150800,-1.535000,10.681000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.335200,-1.535000,10.235900>}
box{<0,0,-0.203200><0.481786,0.035000,0.203200> rotate<0,67.491860,0> translate<37.150800,-1.535000,10.681000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.150800,-1.535000,10.875000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.150800,-1.535000,10.681000>}
box{<0,0,-0.203200><0.194000,0.035000,0.203200> rotate<0,-90.000000,0> translate<37.150800,-1.535000,10.681000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.150800,-1.535000,10.875000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.068500,-1.535000,10.875000>}
box{<0,0,-0.203200><1.917700,0.035000,0.203200> rotate<0,0.000000,0> translate<37.150800,-1.535000,10.875000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.150800,-1.535000,10.968800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.068500,-1.535000,10.968800>}
box{<0,0,-0.203200><1.917700,0.035000,0.203200> rotate<0,0.000000,0> translate<37.150800,-1.535000,10.968800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.150800,-1.535000,11.162900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.150800,-1.535000,10.968800>}
box{<0,0,-0.203200><0.194100,0.035000,0.203200> rotate<0,-90.000000,0> translate<37.150800,-1.535000,10.968800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.150800,-1.535000,11.162900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.335200,-1.535000,11.608000>}
box{<0,0,-0.203200><0.481786,0.035000,0.203200> rotate<0,-67.491860,0> translate<37.150800,-1.535000,11.162900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.206000,-1.535000,5.069500>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.589500,-1.535000,4.686000>}
box{<0,0,-0.203200><0.542351,0.035000,0.203200> rotate<0,44.997030,0> translate<37.206000,-1.535000,5.069500> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.206000,-1.535000,6.614400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.589500,-1.535000,6.997900>}
box{<0,0,-0.203200><0.542351,0.035000,0.203200> rotate<0,-44.997030,0> translate<37.206000,-1.535000,6.614400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.206000,-1.535000,7.609500>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.589500,-1.535000,7.226000>}
box{<0,0,-0.203200><0.542351,0.035000,0.203200> rotate<0,44.997030,0> translate<37.206000,-1.535000,7.609500> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.206000,-1.535000,9.154400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.589500,-1.535000,9.537900>}
box{<0,0,-0.203200><0.542351,0.035000,0.203200> rotate<0,-44.997030,0> translate<37.206000,-1.535000,9.154400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.335200,-1.535000,10.235900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.675900,-1.535000,9.895200>}
box{<0,0,-0.203200><0.481823,0.035000,0.203200> rotate<0,44.997030,0> translate<37.335200,-1.535000,10.235900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.335200,-1.535000,11.608000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.675900,-1.535000,11.948700>}
box{<0,0,-0.203200><0.481823,0.035000,0.203200> rotate<0,-44.997030,0> translate<37.335200,-1.535000,11.608000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.589500,-1.535000,4.686000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.090700,-1.535000,4.478400>}
box{<0,0,-0.203200><0.542494,0.035000,0.203200> rotate<0,22.498141,0> translate<37.589500,-1.535000,4.686000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.589500,-1.535000,6.997900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.865000,-1.535000,7.111900>}
box{<0,0,-0.203200><0.298155,0.035000,0.203200> rotate<0,-22.477951,0> translate<37.589500,-1.535000,6.997900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.589500,-1.535000,7.226000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.865000,-1.535000,7.111900>}
box{<0,0,-0.203200><0.298193,0.035000,0.203200> rotate<0,22.495704,0> translate<37.589500,-1.535000,7.226000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.589500,-1.535000,9.537900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.064100,-1.535000,9.734400>}
box{<0,0,-0.203200><0.513671,0.035000,0.203200> rotate<0,-22.489678,0> translate<37.589500,-1.535000,9.537900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.675900,-1.535000,9.895200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.064100,-1.535000,9.734400>}
box{<0,0,-0.203200><0.420186,0.035000,0.203200> rotate<0,22.498804,0> translate<37.675900,-1.535000,9.895200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.675900,-1.535000,11.948700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.121000,-1.535000,12.133100>}
box{<0,0,-0.203200><0.481786,0.035000,0.203200> rotate<0,-22.502200,0> translate<37.675900,-1.535000,11.948700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.090700,-1.535000,4.478400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.190400,-1.535000,4.478400>}
box{<0,0,-0.203200><1.099700,0.035000,0.203200> rotate<0,0.000000,0> translate<38.090700,-1.535000,4.478400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.121000,-1.535000,12.133100>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.069000,-1.535000,12.133100>}
box{<0,0,-0.203200><0.948000,0.035000,0.203200> rotate<0,0.000000,0> translate<38.121000,-1.535000,12.133100> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.557200,-1.535000,2.292400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.751100,-1.535000,1.568900>}
box{<0,0,-0.203200><0.749032,0.035000,0.203200> rotate<0,74.992187,0> translate<38.557200,-1.535000,2.292400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.557200,-1.535000,3.041500>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.557200,-1.535000,2.292400>}
box{<0,0,-0.203200><0.749100,0.035000,0.203200> rotate<0,-90.000000,0> translate<38.557200,-1.535000,2.292400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.557200,-1.535000,3.041500>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.751100,-1.535000,3.765000>}
box{<0,0,-0.203200><0.749032,0.035000,0.203200> rotate<0,-74.992187,0> translate<38.557200,-1.535000,3.041500> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.557200,-1.535000,13.722400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.751100,-1.535000,12.998900>}
box{<0,0,-0.203200><0.749032,0.035000,0.203200> rotate<0,74.992187,0> translate<38.557200,-1.535000,13.722400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.557200,-1.535000,14.471500>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.557200,-1.535000,13.722400>}
box{<0,0,-0.203200><0.749100,0.035000,0.203200> rotate<0,-90.000000,0> translate<38.557200,-1.535000,13.722400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.557200,-1.535000,14.471500>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.751100,-1.535000,15.195000>}
box{<0,0,-0.203200><0.749032,0.035000,0.203200> rotate<0,-74.992187,0> translate<38.557200,-1.535000,14.471500> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.751100,-1.535000,1.568900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.847600,-1.535000,1.401900>}
box{<0,0,-0.203200><0.192876,0.035000,0.203200> rotate<0,59.974816,0> translate<38.751100,-1.535000,1.568900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.751100,-1.535000,3.765000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.125600,-1.535000,4.413700>}
box{<0,0,-0.203200><0.749041,0.035000,0.203200> rotate<0,-59.997837,0> translate<38.751100,-1.535000,3.765000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.751100,-1.535000,12.998900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.125600,-1.535000,12.350200>}
box{<0,0,-0.203200><0.749041,0.035000,0.203200> rotate<0,59.997837,0> translate<38.751100,-1.535000,12.998900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.751100,-1.535000,15.195000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.876900,-1.535000,15.412800>}
box{<0,0,-0.203200><0.251520,0.035000,0.203200> rotate<0,-59.985563,0> translate<38.751100,-1.535000,15.195000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.068500,-1.535000,10.968800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.068500,-1.535000,10.875000>}
box{<0,0,-0.203200><0.093800,0.035000,0.203200> rotate<0,-90.000000,0> translate<39.068500,-1.535000,10.875000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.069000,-1.535000,10.969400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.069000,-1.535000,12.133100>}
box{<0,0,-0.203200><1.163700,0.035000,0.203200> rotate<0,90.000000,0> translate<39.069000,-1.535000,12.133100> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.069000,-1.535000,10.969400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.162800,-1.535000,10.969400>}
box{<0,0,-0.203200><0.093800,0.035000,0.203200> rotate<0,0.000000,0> translate<39.069000,-1.535000,10.969400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.069000,-1.535000,10.972800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.162800,-1.535000,10.972800>}
box{<0,0,-0.203200><0.093800,0.035000,0.203200> rotate<0,0.000000,0> translate<39.069000,-1.535000,10.972800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.069000,-1.535000,11.379200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.162800,-1.535000,11.379200>}
box{<0,0,-0.203200><0.093800,0.035000,0.203200> rotate<0,0.000000,0> translate<39.069000,-1.535000,11.379200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.069000,-1.535000,11.785600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.162800,-1.535000,11.785600>}
box{<0,0,-0.203200><0.093800,0.035000,0.203200> rotate<0,0.000000,0> translate<39.069000,-1.535000,11.785600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.125600,-1.535000,4.413700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.190400,-1.535000,4.478400>}
box{<0,0,-0.203200><0.091570,0.035000,0.203200> rotate<0,-44.952789,0> translate<39.125600,-1.535000,4.413700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.125600,-1.535000,12.350200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.342800,-1.535000,12.133100>}
box{<0,0,-0.203200><0.307096,0.035000,0.203200> rotate<0,44.983838,0> translate<39.125600,-1.535000,12.350200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.162800,-1.535000,12.133100>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.162800,-1.535000,10.969400>}
box{<0,0,-0.203200><1.163700,0.035000,0.203200> rotate<0,-90.000000,0> translate<39.162800,-1.535000,10.969400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.162800,-1.535000,12.133100>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.342800,-1.535000,12.133100>}
box{<0,0,-0.203200><0.180000,0.035000,0.203200> rotate<0,0.000000,0> translate<39.162800,-1.535000,12.133100> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.163400,-1.535000,10.875000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.163400,-1.535000,10.968800>}
box{<0,0,-0.203200><0.093800,0.035000,0.203200> rotate<0,90.000000,0> translate<39.163400,-1.535000,10.968800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.163400,-1.535000,10.875000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.081100,-1.535000,10.875000>}
box{<0,0,-0.203200><1.917700,0.035000,0.203200> rotate<0,0.000000,0> translate<39.163400,-1.535000,10.875000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.163400,-1.535000,10.968800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.081100,-1.535000,10.968800>}
box{<0,0,-0.203200><1.917700,0.035000,0.203200> rotate<0,0.000000,0> translate<39.163400,-1.535000,10.968800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.167800,-1.535000,9.734400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.556000,-1.535000,9.895200>}
box{<0,0,-0.203200><0.420186,0.035000,0.203200> rotate<0,-22.498804,0> translate<40.167800,-1.535000,9.734400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.167800,-1.535000,9.734400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.642400,-1.535000,9.537900>}
box{<0,0,-0.203200><0.513671,0.035000,0.203200> rotate<0,22.489678,0> translate<40.167800,-1.535000,9.734400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.214100,-1.535000,9.753600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.710200,-1.535000,9.753600>}
box{<0,0,-0.203200><2.496100,0.035000,0.203200> rotate<0,0.000000,0> translate<40.214100,-1.535000,9.753600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.366900,-1.535000,7.111900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.642400,-1.535000,6.997900>}
box{<0,0,-0.203200><0.298155,0.035000,0.203200> rotate<0,22.477951,0> translate<40.366900,-1.535000,7.111900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.366900,-1.535000,7.111900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.642400,-1.535000,7.226000>}
box{<0,0,-0.203200><0.298193,0.035000,0.203200> rotate<0,-22.495704,0> translate<40.366900,-1.535000,7.111900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.556000,-1.535000,9.895200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.896700,-1.535000,10.235900>}
box{<0,0,-0.203200><0.481823,0.035000,0.203200> rotate<0,-44.997030,0> translate<40.556000,-1.535000,9.895200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.642400,-1.535000,6.997900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.025900,-1.535000,6.614400>}
box{<0,0,-0.203200><0.542351,0.035000,0.203200> rotate<0,44.997030,0> translate<40.642400,-1.535000,6.997900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.642400,-1.535000,7.226000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.025900,-1.535000,7.609500>}
box{<0,0,-0.203200><0.542351,0.035000,0.203200> rotate<0,-44.997030,0> translate<40.642400,-1.535000,7.226000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.642400,-1.535000,9.537900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.025900,-1.535000,9.154400>}
box{<0,0,-0.203200><0.542351,0.035000,0.203200> rotate<0,44.997030,0> translate<40.642400,-1.535000,9.537900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.731500,-1.535000,6.908800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.710200,-1.535000,6.908800>}
box{<0,0,-0.203200><1.978700,0.035000,0.203200> rotate<0,0.000000,0> translate<40.731500,-1.535000,6.908800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.731600,-1.535000,7.315200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.710200,-1.535000,7.315200>}
box{<0,0,-0.203200><1.978600,0.035000,0.203200> rotate<0,0.000000,0> translate<40.731600,-1.535000,7.315200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.820800,-1.535000,10.160000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.710200,-1.535000,10.160000>}
box{<0,0,-0.203200><1.889400,0.035000,0.203200> rotate<0,0.000000,0> translate<40.820800,-1.535000,10.160000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.833100,-1.535000,9.347200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.710200,-1.535000,9.347200>}
box{<0,0,-0.203200><1.877100,0.035000,0.203200> rotate<0,0.000000,0> translate<40.833100,-1.535000,9.347200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.896700,-1.535000,10.235900>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.081100,-1.535000,10.681000>}
box{<0,0,-0.203200><0.481786,0.035000,0.203200> rotate<0,-67.491860,0> translate<40.896700,-1.535000,10.235900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.025900,-1.535000,6.614400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.233500,-1.535000,6.113200>}
box{<0,0,-0.203200><0.542494,0.035000,0.203200> rotate<0,67.495920,0> translate<41.025900,-1.535000,6.614400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.025900,-1.535000,7.609500>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.233500,-1.535000,8.110700>}
box{<0,0,-0.203200><0.542494,0.035000,0.203200> rotate<0,-67.495920,0> translate<41.025900,-1.535000,7.609500> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.025900,-1.535000,9.154400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.233500,-1.535000,8.653200>}
box{<0,0,-0.203200><0.542494,0.035000,0.203200> rotate<0,67.495920,0> translate<41.025900,-1.535000,9.154400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.033600,-1.535000,10.566400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.710200,-1.535000,10.566400>}
box{<0,0,-0.203200><1.676600,0.035000,0.203200> rotate<0,0.000000,0> translate<41.033600,-1.535000,10.566400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.044000,-1.535000,11.252200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.081100,-1.535000,11.162900>}
box{<0,0,-0.203200><0.096700,0.035000,0.203200> rotate<0,67.434935,0> translate<41.044000,-1.535000,11.252200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.044000,-1.535000,11.252200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.776500,-1.535000,11.252200>}
box{<0,0,-0.203200><0.732500,0.035000,0.203200> rotate<0,0.000000,0> translate<41.044000,-1.535000,11.252200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.072300,-1.535000,6.502400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.710200,-1.535000,6.502400>}
box{<0,0,-0.203200><1.637900,0.035000,0.203200> rotate<0,0.000000,0> translate<41.072300,-1.535000,6.502400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.072300,-1.535000,7.721600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.710200,-1.535000,7.721600>}
box{<0,0,-0.203200><1.637900,0.035000,0.203200> rotate<0,0.000000,0> translate<41.072300,-1.535000,7.721600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.081100,-1.535000,10.681000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.081100,-1.535000,10.875000>}
box{<0,0,-0.203200><0.194000,0.035000,0.203200> rotate<0,90.000000,0> translate<41.081100,-1.535000,10.875000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.081100,-1.535000,10.968800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.081100,-1.535000,11.162900>}
box{<0,0,-0.203200><0.194100,0.035000,0.203200> rotate<0,90.000000,0> translate<41.081100,-1.535000,11.162900> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.081100,-1.535000,10.972800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.710200,-1.535000,10.972800>}
box{<0,0,-0.203200><1.629100,0.035000,0.203200> rotate<0,0.000000,0> translate<41.081100,-1.535000,10.972800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.114400,-1.535000,8.940800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.710200,-1.535000,8.940800>}
box{<0,0,-0.203200><1.595800,0.035000,0.203200> rotate<0,0.000000,0> translate<41.114400,-1.535000,8.940800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.209000,-1.535000,5.511700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.233500,-1.535000,5.570700>}
box{<0,0,-0.203200><0.063885,0.035000,0.203200> rotate<0,-67.444673,0> translate<41.209000,-1.535000,5.511700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.209000,-1.535000,5.511700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.776500,-1.535000,5.511700>}
box{<0,0,-0.203200><0.567500,0.035000,0.203200> rotate<0,0.000000,0> translate<41.209000,-1.535000,5.511700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.233500,-1.535000,5.570700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.233500,-1.535000,6.113200>}
box{<0,0,-0.203200><0.542500,0.035000,0.203200> rotate<0,90.000000,0> translate<41.233500,-1.535000,6.113200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.233500,-1.535000,5.689600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.710200,-1.535000,5.689600>}
box{<0,0,-0.203200><1.476700,0.035000,0.203200> rotate<0,0.000000,0> translate<41.233500,-1.535000,5.689600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.233500,-1.535000,6.096000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.710200,-1.535000,6.096000>}
box{<0,0,-0.203200><1.476700,0.035000,0.203200> rotate<0,0.000000,0> translate<41.233500,-1.535000,6.096000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.233500,-1.535000,8.110700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.233500,-1.535000,8.653200>}
box{<0,0,-0.203200><0.542500,0.035000,0.203200> rotate<0,90.000000,0> translate<41.233500,-1.535000,8.653200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.233500,-1.535000,8.128000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.710200,-1.535000,8.128000>}
box{<0,0,-0.203200><1.476700,0.035000,0.203200> rotate<0,0.000000,0> translate<41.233500,-1.535000,8.128000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.233500,-1.535000,8.534400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.710200,-1.535000,8.534400>}
box{<0,0,-0.203200><1.476700,0.035000,0.203200> rotate<0,0.000000,0> translate<41.233500,-1.535000,8.534400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.776500,-1.535000,5.511700>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.500000,-1.535000,5.317800>}
box{<0,0,-0.203200><0.749032,0.035000,0.203200> rotate<0,15.001874,0> translate<41.776500,-1.535000,5.511700> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.776500,-1.535000,11.252200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.500000,-1.535000,11.446100>}
box{<0,0,-0.203200><0.749032,0.035000,0.203200> rotate<0,-15.001874,0> translate<41.776500,-1.535000,11.252200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.250300,-1.535000,11.379200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.710200,-1.535000,11.379200>}
box{<0,0,-0.203200><0.459900,0.035000,0.203200> rotate<0,0.000000,0> translate<42.250300,-1.535000,11.379200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.500000,-1.535000,5.317800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.710200,-1.535000,5.196400>}
box{<0,0,-0.203200><0.242739,0.035000,0.203200> rotate<0,30.006395,0> translate<42.500000,-1.535000,5.317800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.500000,-1.535000,11.446100>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.710200,-1.535000,11.567500>}
box{<0,0,-0.203200><0.242739,0.035000,0.203200> rotate<0,-30.006395,0> translate<42.500000,-1.535000,11.446100> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.560000,-1.535000,5.283200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.710200,-1.535000,5.283200>}
box{<0,0,-0.203200><0.150200,0.035000,0.203200> rotate<0,0.000000,0> translate<42.560000,-1.535000,5.283200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.710200,-1.535000,11.567500>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.710200,-1.535000,5.196400>}
box{<0,0,-0.203200><6.371100,0.035000,0.203200> rotate<0,-90.000000,0> translate<42.710200,-1.535000,5.196400> }
texture{col_pol}
}
#end
union{
cylinder{<35.052000,0.038000,3.937000><35.052000,-1.538000,3.937000>0.444500}
cylinder{<32.512000,0.038000,5.207000><32.512000,-1.538000,5.207000>0.444500}
cylinder{<35.052000,0.038000,6.477000><35.052000,-1.538000,6.477000>0.444500}
cylinder{<32.512000,0.038000,7.747000><32.512000,-1.538000,7.747000>0.444500}
cylinder{<35.052000,0.038000,9.017000><35.052000,-1.538000,9.017000>0.444500}
cylinder{<32.512000,0.038000,10.287000><32.512000,-1.538000,10.287000>0.444500}
cylinder{<35.052000,0.038000,11.557000><35.052000,-1.538000,11.557000>0.444500}
cylinder{<32.512000,0.038000,12.827000><32.512000,-1.538000,12.827000>0.444500}
cylinder{<7.620000,0.038000,8.128000><7.620000,-1.538000,8.128000>0.406400}
cylinder{<7.620000,0.038000,10.668000><7.620000,-1.538000,10.668000>0.406400}
cylinder{<28.143200,0.038000,15.265400><28.143200,-1.538000,15.265400>0.406400}
cylinder{<28.143200,0.038000,7.645400><28.143200,-1.538000,7.645400>0.406400}
cylinder{<25.171400,0.038000,15.240000><25.171400,-1.538000,15.240000>0.406400}
cylinder{<25.171400,0.038000,7.620000><25.171400,-1.538000,7.620000>0.406400}
cylinder{<22.098000,0.038000,15.240000><22.098000,-1.538000,15.240000>0.406400}
cylinder{<22.098000,0.038000,7.620000><22.098000,-1.538000,7.620000>0.406400}
cylinder{<14.249400,0.038000,4.826000><14.249400,-1.538000,4.826000>0.400000}
cylinder{<14.249400,0.038000,2.032000><14.249400,-1.538000,2.032000>0.400000}
cylinder{<20.599400,0.038000,2.032000><20.599400,-1.538000,2.032000>0.400000}
cylinder{<21.996400,0.038000,3.429000><21.996400,-1.538000,3.429000>0.400000}
cylinder{<20.599400,0.038000,4.826000><20.599400,-1.538000,4.826000>0.400000}
cylinder{<39.116000,0.038000,5.842000><39.116000,-1.538000,5.842000>0.500000}
cylinder{<39.116000,0.038000,8.382000><39.116000,-1.538000,8.382000>0.500000}
cylinder{<39.116000,0.038000,10.922000><39.116000,-1.538000,10.922000>0.500000}
//Holes(fast)/Vias
cylinder{<24.130000,0.038000,3.429000><24.130000,-1.538000,3.429000>0.250000 }
//Holes(fast)/Board
texture{col_hls}
}
#if(pcb_silkscreen=on)
//Silk Screen
union{
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.274100,0.000000,16.015400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.977500,0.000000,16.015400>}
box{<0,0,-0.038100><0.296600,0.036000,0.038100> rotate<0,0.000000,0> translate<5.977500,0.000000,16.015400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.977500,0.000000,16.015400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.829300,0.000000,15.867100>}
box{<0,0,-0.038100><0.209657,0.036000,0.038100> rotate<0,-45.016353,0> translate<5.829300,0.000000,15.867100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.829300,0.000000,15.867100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.829300,0.000000,15.273900>}
box{<0,0,-0.038100><0.593200,0.036000,0.038100> rotate<0,-90.000000,0> translate<5.829300,0.000000,15.273900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.829300,0.000000,15.273900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.977500,0.000000,15.125700>}
box{<0,0,-0.038100><0.209586,0.036000,0.038100> rotate<0,44.997030,0> translate<5.829300,0.000000,15.273900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.977500,0.000000,15.125700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.274100,0.000000,15.125700>}
box{<0,0,-0.038100><0.296600,0.036000,0.038100> rotate<0,0.000000,0> translate<5.977500,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.274100,0.000000,15.125700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.422400,0.000000,15.273900>}
box{<0,0,-0.038100><0.209657,0.036000,0.038100> rotate<0,-44.977707,0> translate<6.274100,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.422400,0.000000,15.273900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.422400,0.000000,15.867100>}
box{<0,0,-0.038100><0.593200,0.036000,0.038100> rotate<0,90.000000,0> translate<6.422400,0.000000,15.867100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.422400,0.000000,15.867100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.274100,0.000000,16.015400>}
box{<0,0,-0.038100><0.209728,0.036000,0.038100> rotate<0,44.997030,0> translate<6.274100,0.000000,16.015400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.718000,0.000000,14.829200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.718000,0.000000,15.718800>}
box{<0,0,-0.038100><0.889600,0.036000,0.038100> rotate<0,90.000000,0> translate<6.718000,0.000000,15.718800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.718000,0.000000,15.718800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.162800,0.000000,15.718800>}
box{<0,0,-0.038100><0.444800,0.036000,0.038100> rotate<0,0.000000,0> translate<6.718000,0.000000,15.718800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.162800,0.000000,15.718800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.311100,0.000000,15.570500>}
box{<0,0,-0.038100><0.209728,0.036000,0.038100> rotate<0,44.997030,0> translate<7.162800,0.000000,15.718800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.311100,0.000000,15.570500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.311100,0.000000,15.273900>}
box{<0,0,-0.038100><0.296600,0.036000,0.038100> rotate<0,-90.000000,0> translate<7.311100,0.000000,15.273900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.311100,0.000000,15.273900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.162800,0.000000,15.125700>}
box{<0,0,-0.038100><0.209657,0.036000,0.038100> rotate<0,-44.977707,0> translate<7.162800,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.162800,0.000000,15.125700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.718000,0.000000,15.125700>}
box{<0,0,-0.038100><0.444800,0.036000,0.038100> rotate<0,0.000000,0> translate<6.718000,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.754900,0.000000,15.867100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.754900,0.000000,15.273900>}
box{<0,0,-0.038100><0.593200,0.036000,0.038100> rotate<0,-90.000000,0> translate<7.754900,0.000000,15.273900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.754900,0.000000,15.273900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.903200,0.000000,15.125700>}
box{<0,0,-0.038100><0.209657,0.036000,0.038100> rotate<0,44.977707,0> translate<7.754900,0.000000,15.273900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.606700,0.000000,15.718800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.903200,0.000000,15.718800>}
box{<0,0,-0.038100><0.296500,0.036000,0.038100> rotate<0,0.000000,0> translate<7.606700,0.000000,15.718800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.347300,0.000000,15.125700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.643900,0.000000,15.125700>}
box{<0,0,-0.038100><0.296600,0.036000,0.038100> rotate<0,0.000000,0> translate<8.347300,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.643900,0.000000,15.125700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.792200,0.000000,15.273900>}
box{<0,0,-0.038100><0.209657,0.036000,0.038100> rotate<0,-44.977707,0> translate<8.643900,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.792200,0.000000,15.273900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.792200,0.000000,15.570500>}
box{<0,0,-0.038100><0.296600,0.036000,0.038100> rotate<0,90.000000,0> translate<8.792200,0.000000,15.570500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.792200,0.000000,15.570500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.643900,0.000000,15.718800>}
box{<0,0,-0.038100><0.209728,0.036000,0.038100> rotate<0,44.997030,0> translate<8.643900,0.000000,15.718800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.643900,0.000000,15.718800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.347300,0.000000,15.718800>}
box{<0,0,-0.038100><0.296600,0.036000,0.038100> rotate<0,0.000000,0> translate<8.347300,0.000000,15.718800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.347300,0.000000,15.718800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.199100,0.000000,15.570500>}
box{<0,0,-0.038100><0.209657,0.036000,0.038100> rotate<0,-45.016353,0> translate<8.199100,0.000000,15.570500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.199100,0.000000,15.570500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.199100,0.000000,15.273900>}
box{<0,0,-0.038100><0.296600,0.036000,0.038100> rotate<0,-90.000000,0> translate<8.199100,0.000000,15.273900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.199100,0.000000,15.273900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.347300,0.000000,15.125700>}
box{<0,0,-0.038100><0.209586,0.036000,0.038100> rotate<0,44.997030,0> translate<8.199100,0.000000,15.273900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.569600,0.000000,16.015400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.976500,0.000000,16.015400>}
box{<0,0,-0.038100><0.593100,0.036000,0.038100> rotate<0,0.000000,0> translate<9.976500,0.000000,16.015400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.976500,0.000000,16.015400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.976500,0.000000,15.125700>}
box{<0,0,-0.038100><0.889700,0.036000,0.038100> rotate<0,-90.000000,0> translate<9.976500,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.976500,0.000000,15.125700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.569600,0.000000,15.125700>}
box{<0,0,-0.038100><0.593100,0.036000,0.038100> rotate<0,0.000000,0> translate<9.976500,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.976500,0.000000,15.570500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.273000,0.000000,15.570500>}
box{<0,0,-0.038100><0.296500,0.036000,0.038100> rotate<0,0.000000,0> translate<9.976500,0.000000,15.570500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.865200,0.000000,15.125700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.865200,0.000000,15.718800>}
box{<0,0,-0.038100><0.593100,0.036000,0.038100> rotate<0,90.000000,0> translate<10.865200,0.000000,15.718800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.865200,0.000000,15.718800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.310000,0.000000,15.718800>}
box{<0,0,-0.038100><0.444800,0.036000,0.038100> rotate<0,0.000000,0> translate<10.865200,0.000000,15.718800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.310000,0.000000,15.718800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.458300,0.000000,15.570500>}
box{<0,0,-0.038100><0.209728,0.036000,0.038100> rotate<0,44.997030,0> translate<11.310000,0.000000,15.718800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.458300,0.000000,15.570500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.458300,0.000000,15.125700>}
box{<0,0,-0.038100><0.444800,0.036000,0.038100> rotate<0,-90.000000,0> translate<11.458300,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.347000,0.000000,16.015400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.347000,0.000000,15.125700>}
box{<0,0,-0.038100><0.889700,0.036000,0.038100> rotate<0,-90.000000,0> translate<12.347000,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.347000,0.000000,15.125700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.902100,0.000000,15.125700>}
box{<0,0,-0.038100><0.444900,0.036000,0.038100> rotate<0,0.000000,0> translate<11.902100,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.902100,0.000000,15.125700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.753900,0.000000,15.273900>}
box{<0,0,-0.038100><0.209586,0.036000,0.038100> rotate<0,44.997030,0> translate<11.753900,0.000000,15.273900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.753900,0.000000,15.273900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.753900,0.000000,15.570500>}
box{<0,0,-0.038100><0.296600,0.036000,0.038100> rotate<0,90.000000,0> translate<11.753900,0.000000,15.570500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.753900,0.000000,15.570500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.902100,0.000000,15.718800>}
box{<0,0,-0.038100><0.209657,0.036000,0.038100> rotate<0,-45.016353,0> translate<11.753900,0.000000,15.570500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.902100,0.000000,15.718800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.347000,0.000000,15.718800>}
box{<0,0,-0.038100><0.444900,0.036000,0.038100> rotate<0,0.000000,0> translate<11.902100,0.000000,15.718800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.642600,0.000000,15.125700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.087400,0.000000,15.125700>}
box{<0,0,-0.038100><0.444800,0.036000,0.038100> rotate<0,0.000000,0> translate<12.642600,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.087400,0.000000,15.125700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.235700,0.000000,15.273900>}
box{<0,0,-0.038100><0.209657,0.036000,0.038100> rotate<0,-44.977707,0> translate<13.087400,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.235700,0.000000,15.273900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.087400,0.000000,15.422200>}
box{<0,0,-0.038100><0.209728,0.036000,0.038100> rotate<0,44.997030,0> translate<13.087400,0.000000,15.422200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.087400,0.000000,15.422200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.790800,0.000000,15.422200>}
box{<0,0,-0.038100><0.296600,0.036000,0.038100> rotate<0,0.000000,0> translate<12.790800,0.000000,15.422200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.790800,0.000000,15.422200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.642600,0.000000,15.570500>}
box{<0,0,-0.038100><0.209657,0.036000,0.038100> rotate<0,45.016353,0> translate<12.642600,0.000000,15.570500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.642600,0.000000,15.570500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.790800,0.000000,15.718800>}
box{<0,0,-0.038100><0.209657,0.036000,0.038100> rotate<0,-45.016353,0> translate<12.642600,0.000000,15.570500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.790800,0.000000,15.718800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.235700,0.000000,15.718800>}
box{<0,0,-0.038100><0.444900,0.036000,0.038100> rotate<0,0.000000,0> translate<12.790800,0.000000,15.718800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.679500,0.000000,15.867100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.679500,0.000000,15.273900>}
box{<0,0,-0.038100><0.593200,0.036000,0.038100> rotate<0,-90.000000,0> translate<13.679500,0.000000,15.273900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.679500,0.000000,15.273900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.827800,0.000000,15.125700>}
box{<0,0,-0.038100><0.209657,0.036000,0.038100> rotate<0,44.977707,0> translate<13.679500,0.000000,15.273900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.531300,0.000000,15.718800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.827800,0.000000,15.718800>}
box{<0,0,-0.038100><0.296500,0.036000,0.038100> rotate<0,0.000000,0> translate<13.531300,0.000000,15.718800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.271900,0.000000,15.125700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.568500,0.000000,15.125700>}
box{<0,0,-0.038100><0.296600,0.036000,0.038100> rotate<0,0.000000,0> translate<14.271900,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.568500,0.000000,15.125700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.716800,0.000000,15.273900>}
box{<0,0,-0.038100><0.209657,0.036000,0.038100> rotate<0,-44.977707,0> translate<14.568500,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.716800,0.000000,15.273900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.716800,0.000000,15.570500>}
box{<0,0,-0.038100><0.296600,0.036000,0.038100> rotate<0,90.000000,0> translate<14.716800,0.000000,15.570500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.716800,0.000000,15.570500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.568500,0.000000,15.718800>}
box{<0,0,-0.038100><0.209728,0.036000,0.038100> rotate<0,44.997030,0> translate<14.568500,0.000000,15.718800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.568500,0.000000,15.718800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.271900,0.000000,15.718800>}
box{<0,0,-0.038100><0.296600,0.036000,0.038100> rotate<0,0.000000,0> translate<14.271900,0.000000,15.718800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.271900,0.000000,15.718800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.123700,0.000000,15.570500>}
box{<0,0,-0.038100><0.209657,0.036000,0.038100> rotate<0,-45.016353,0> translate<14.123700,0.000000,15.570500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.123700,0.000000,15.570500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.123700,0.000000,15.273900>}
box{<0,0,-0.038100><0.296600,0.036000,0.038100> rotate<0,-90.000000,0> translate<14.123700,0.000000,15.273900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.123700,0.000000,15.273900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.271900,0.000000,15.125700>}
box{<0,0,-0.038100><0.209586,0.036000,0.038100> rotate<0,44.997030,0> translate<14.123700,0.000000,15.273900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.012400,0.000000,14.829200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.012400,0.000000,15.718800>}
box{<0,0,-0.038100><0.889600,0.036000,0.038100> rotate<0,90.000000,0> translate<15.012400,0.000000,15.718800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.012400,0.000000,15.718800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.457200,0.000000,15.718800>}
box{<0,0,-0.038100><0.444800,0.036000,0.038100> rotate<0,0.000000,0> translate<15.012400,0.000000,15.718800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.457200,0.000000,15.718800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.605500,0.000000,15.570500>}
box{<0,0,-0.038100><0.209728,0.036000,0.038100> rotate<0,44.997030,0> translate<15.457200,0.000000,15.718800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.605500,0.000000,15.570500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.605500,0.000000,15.273900>}
box{<0,0,-0.038100><0.296600,0.036000,0.038100> rotate<0,-90.000000,0> translate<15.605500,0.000000,15.273900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.605500,0.000000,15.273900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.457200,0.000000,15.125700>}
box{<0,0,-0.038100><0.209657,0.036000,0.038100> rotate<0,-44.977707,0> translate<15.457200,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.457200,0.000000,15.125700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.012400,0.000000,15.125700>}
box{<0,0,-0.038100><0.444800,0.036000,0.038100> rotate<0,0.000000,0> translate<15.012400,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.789800,0.000000,15.718800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.086300,0.000000,15.125700>}
box{<0,0,-0.038100><0.663084,0.036000,0.038100> rotate<0,63.434626,0> translate<16.789800,0.000000,15.718800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.086300,0.000000,15.125700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.382900,0.000000,15.718800>}
box{<0,0,-0.038100><0.663128,0.036000,0.038100> rotate<0,-63.426899,0> translate<17.086300,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.271600,0.000000,15.125700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.678500,0.000000,15.125700>}
box{<0,0,-0.038100><0.593100,0.036000,0.038100> rotate<0,0.000000,0> translate<17.678500,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.678500,0.000000,15.125700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.271600,0.000000,15.718800>}
box{<0,0,-0.038100><0.838770,0.036000,0.038100> rotate<0,-44.997030,0> translate<17.678500,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.271600,0.000000,15.718800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.271600,0.000000,15.867100>}
box{<0,0,-0.038100><0.148300,0.036000,0.038100> rotate<0,90.000000,0> translate<18.271600,0.000000,15.867100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.271600,0.000000,15.867100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.123300,0.000000,16.015400>}
box{<0,0,-0.038100><0.209728,0.036000,0.038100> rotate<0,44.997030,0> translate<18.123300,0.000000,16.015400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.123300,0.000000,16.015400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.826700,0.000000,16.015400>}
box{<0,0,-0.038100><0.296600,0.036000,0.038100> rotate<0,0.000000,0> translate<17.826700,0.000000,16.015400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.826700,0.000000,16.015400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.678500,0.000000,15.867100>}
box{<0,0,-0.038100><0.209657,0.036000,0.038100> rotate<0,-45.016353,0> translate<17.678500,0.000000,15.867100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.567200,0.000000,15.125700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.567200,0.000000,15.273900>}
box{<0,0,-0.038100><0.148200,0.036000,0.038100> rotate<0,90.000000,0> translate<18.567200,0.000000,15.273900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.567200,0.000000,15.273900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.715400,0.000000,15.273900>}
box{<0,0,-0.038100><0.148200,0.036000,0.038100> rotate<0,0.000000,0> translate<18.567200,0.000000,15.273900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.715400,0.000000,15.273900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.715400,0.000000,15.125700>}
box{<0,0,-0.038100><0.148200,0.036000,0.038100> rotate<0,-90.000000,0> translate<18.715400,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.715400,0.000000,15.125700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.567200,0.000000,15.125700>}
box{<0,0,-0.038100><0.148200,0.036000,0.038100> rotate<0,0.000000,0> translate<18.567200,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.011500,0.000000,15.718800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.308000,0.000000,16.015400>}
box{<0,0,-0.038100><0.419385,0.036000,0.038100> rotate<0,-45.006690,0> translate<19.011500,0.000000,15.718800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.308000,0.000000,16.015400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.308000,0.000000,15.125700>}
box{<0,0,-0.038100><0.889700,0.036000,0.038100> rotate<0,-90.000000,0> translate<19.308000,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.011500,0.000000,15.125700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.604600,0.000000,15.125700>}
box{<0,0,-0.038100><0.593100,0.036000,0.038100> rotate<0,0.000000,0> translate<19.011500,0.000000,15.125700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.930900,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.930900,0.000000,14.144000>}
box{<0,0,-0.038100><0.542300,0.036000,0.038100> rotate<0,90.000000,0> translate<5.930900,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<5.930900,0.000000,14.144000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.066400,0.000000,14.144000>}
box{<0,0,-0.038100><0.135500,0.036000,0.038100> rotate<0,0.000000,0> translate<5.930900,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.066400,0.000000,14.144000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.202000,0.000000,14.008400>}
box{<0,0,-0.038100><0.191767,0.036000,0.038100> rotate<0,44.997030,0> translate<6.066400,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.202000,0.000000,14.008400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.202000,0.000000,13.601700>}
box{<0,0,-0.038100><0.406700,0.036000,0.038100> rotate<0,-90.000000,0> translate<6.202000,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.202000,0.000000,14.008400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.337600,0.000000,14.144000>}
box{<0,0,-0.038100><0.191767,0.036000,0.038100> rotate<0,-44.997030,0> translate<6.202000,0.000000,14.008400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.337600,0.000000,14.144000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.473200,0.000000,14.008400>}
box{<0,0,-0.038100><0.191767,0.036000,0.038100> rotate<0,44.997030,0> translate<6.337600,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.473200,0.000000,14.008400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.473200,0.000000,13.601700>}
box{<0,0,-0.038100><0.406700,0.036000,0.038100> rotate<0,-90.000000,0> translate<6.473200,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.884900,0.000000,14.144000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.156100,0.000000,14.144000>}
box{<0,0,-0.038100><0.271200,0.036000,0.038100> rotate<0,0.000000,0> translate<6.884900,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.156100,0.000000,14.144000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.291700,0.000000,14.008400>}
box{<0,0,-0.038100><0.191767,0.036000,0.038100> rotate<0,44.997030,0> translate<7.156100,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.291700,0.000000,14.008400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.291700,0.000000,13.601700>}
box{<0,0,-0.038100><0.406700,0.036000,0.038100> rotate<0,-90.000000,0> translate<7.291700,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.291700,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.884900,0.000000,13.601700>}
box{<0,0,-0.038100><0.406800,0.036000,0.038100> rotate<0,0.000000,0> translate<6.884900,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.884900,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.749400,0.000000,13.737200>}
box{<0,0,-0.038100><0.191626,0.036000,0.038100> rotate<0,44.997030,0> translate<6.749400,0.000000,13.737200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.749400,0.000000,13.737200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.884900,0.000000,13.872800>}
box{<0,0,-0.038100><0.191697,0.036000,0.038100> rotate<0,-45.018163,0> translate<6.749400,0.000000,13.737200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<6.884900,0.000000,13.872800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.291700,0.000000,13.872800>}
box{<0,0,-0.038100><0.406800,0.036000,0.038100> rotate<0,0.000000,0> translate<6.884900,0.000000,13.872800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.567900,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.567900,0.000000,14.415100>}
box{<0,0,-0.038100><0.813400,0.036000,0.038100> rotate<0,90.000000,0> translate<7.567900,0.000000,14.415100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.974600,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.567900,0.000000,13.872800>}
box{<0,0,-0.038100><0.488774,0.036000,0.038100> rotate<0,33.684593,0> translate<7.567900,0.000000,13.872800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.567900,0.000000,13.872800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<7.974600,0.000000,14.144000>}
box{<0,0,-0.038100><0.488830,0.036000,0.038100> rotate<0,-33.694345,0> translate<7.567900,0.000000,13.872800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.656700,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.385500,0.000000,13.601700>}
box{<0,0,-0.038100><0.271200,0.036000,0.038100> rotate<0,0.000000,0> translate<8.385500,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.385500,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.250000,0.000000,13.737200>}
box{<0,0,-0.038100><0.191626,0.036000,0.038100> rotate<0,44.997030,0> translate<8.250000,0.000000,13.737200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.250000,0.000000,13.737200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.250000,0.000000,14.008400>}
box{<0,0,-0.038100><0.271200,0.036000,0.038100> rotate<0,90.000000,0> translate<8.250000,0.000000,14.008400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.250000,0.000000,14.008400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.385500,0.000000,14.144000>}
box{<0,0,-0.038100><0.191697,0.036000,0.038100> rotate<0,-45.018163,0> translate<8.250000,0.000000,14.008400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.385500,0.000000,14.144000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.656700,0.000000,14.144000>}
box{<0,0,-0.038100><0.271200,0.036000,0.038100> rotate<0,0.000000,0> translate<8.385500,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.656700,0.000000,14.144000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.792300,0.000000,14.008400>}
box{<0,0,-0.038100><0.191767,0.036000,0.038100> rotate<0,44.997030,0> translate<8.656700,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.792300,0.000000,14.008400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.792300,0.000000,13.872800>}
box{<0,0,-0.038100><0.135600,0.036000,0.038100> rotate<0,-90.000000,0> translate<8.792300,0.000000,13.872800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.792300,0.000000,13.872800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<8.250000,0.000000,13.872800>}
box{<0,0,-0.038100><0.542300,0.036000,0.038100> rotate<0,0.000000,0> translate<8.250000,0.000000,13.872800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.068500,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.068500,0.000000,13.737200>}
box{<0,0,-0.038100><0.135500,0.036000,0.038100> rotate<0,90.000000,0> translate<9.068500,0.000000,13.737200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.068500,0.000000,13.737200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.204000,0.000000,13.737200>}
box{<0,0,-0.038100><0.135500,0.036000,0.038100> rotate<0,0.000000,0> translate<9.068500,0.000000,13.737200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.204000,0.000000,13.737200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.204000,0.000000,13.601700>}
box{<0,0,-0.038100><0.135500,0.036000,0.038100> rotate<0,-90.000000,0> translate<9.204000,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.204000,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.068500,0.000000,13.601700>}
box{<0,0,-0.038100><0.135500,0.036000,0.038100> rotate<0,0.000000,0> translate<9.068500,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.477700,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.477700,0.000000,14.144000>}
box{<0,0,-0.038100><0.542300,0.036000,0.038100> rotate<0,90.000000,0> translate<9.477700,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.477700,0.000000,13.872800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.748800,0.000000,14.144000>}
box{<0,0,-0.038100><0.383464,0.036000,0.038100> rotate<0,-45.007595,0> translate<9.477700,0.000000,13.872800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.748800,0.000000,14.144000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<9.884400,0.000000,14.144000>}
box{<0,0,-0.038100><0.135600,0.036000,0.038100> rotate<0,0.000000,0> translate<9.748800,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.159800,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.159800,0.000000,14.144000>}
box{<0,0,-0.038100><0.542300,0.036000,0.038100> rotate<0,90.000000,0> translate<10.159800,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.159800,0.000000,13.872800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.430900,0.000000,14.144000>}
box{<0,0,-0.038100><0.383464,0.036000,0.038100> rotate<0,-45.007595,0> translate<10.159800,0.000000,13.872800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.430900,0.000000,14.144000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.566500,0.000000,14.144000>}
box{<0,0,-0.038100><0.135600,0.036000,0.038100> rotate<0,0.000000,0> translate<10.430900,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.841900,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.841900,0.000000,14.144000>}
box{<0,0,-0.038100><0.542300,0.036000,0.038100> rotate<0,90.000000,0> translate<10.841900,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<10.841900,0.000000,13.872800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.113000,0.000000,14.144000>}
box{<0,0,-0.038100><0.383464,0.036000,0.038100> rotate<0,-45.007595,0> translate<10.841900,0.000000,13.872800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.113000,0.000000,14.144000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.248600,0.000000,14.144000>}
box{<0,0,-0.038100><0.135600,0.036000,0.038100> rotate<0,0.000000,0> translate<11.113000,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.659500,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.659500,0.000000,14.279600>}
box{<0,0,-0.038100><0.677900,0.036000,0.038100> rotate<0,90.000000,0> translate<11.659500,0.000000,14.279600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.659500,0.000000,14.279600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.795100,0.000000,14.415100>}
box{<0,0,-0.038100><0.191697,0.036000,0.038100> rotate<0,-44.975897,0> translate<11.659500,0.000000,14.279600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.524000,0.000000,14.008400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<11.795100,0.000000,14.008400>}
box{<0,0,-0.038100><0.271100,0.036000,0.038100> rotate<0,0.000000,0> translate<11.524000,0.000000,14.008400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.069700,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.069700,0.000000,13.737200>}
box{<0,0,-0.038100><0.135500,0.036000,0.038100> rotate<0,90.000000,0> translate<12.069700,0.000000,13.737200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.069700,0.000000,13.737200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.205200,0.000000,13.737200>}
box{<0,0,-0.038100><0.135500,0.036000,0.038100> rotate<0,0.000000,0> translate<12.069700,0.000000,13.737200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.205200,0.000000,13.737200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.205200,0.000000,13.601700>}
box{<0,0,-0.038100><0.135500,0.036000,0.038100> rotate<0,-90.000000,0> translate<12.205200,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.205200,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.069700,0.000000,13.601700>}
box{<0,0,-0.038100><0.135500,0.036000,0.038100> rotate<0,0.000000,0> translate<12.069700,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.614400,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.885600,0.000000,13.601700>}
box{<0,0,-0.038100><0.271200,0.036000,0.038100> rotate<0,0.000000,0> translate<12.614400,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.885600,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.021200,0.000000,13.737200>}
box{<0,0,-0.038100><0.191697,0.036000,0.038100> rotate<0,-44.975897,0> translate<12.885600,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.021200,0.000000,13.737200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.021200,0.000000,14.008400>}
box{<0,0,-0.038100><0.271200,0.036000,0.038100> rotate<0,90.000000,0> translate<13.021200,0.000000,14.008400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.021200,0.000000,14.008400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.885600,0.000000,14.144000>}
box{<0,0,-0.038100><0.191767,0.036000,0.038100> rotate<0,44.997030,0> translate<12.885600,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.885600,0.000000,14.144000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.614400,0.000000,14.144000>}
box{<0,0,-0.038100><0.271200,0.036000,0.038100> rotate<0,0.000000,0> translate<12.614400,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.614400,0.000000,14.144000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.478900,0.000000,14.008400>}
box{<0,0,-0.038100><0.191697,0.036000,0.038100> rotate<0,-45.018163,0> translate<12.478900,0.000000,14.008400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.478900,0.000000,14.008400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.478900,0.000000,13.737200>}
box{<0,0,-0.038100><0.271200,0.036000,0.038100> rotate<0,-90.000000,0> translate<12.478900,0.000000,13.737200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.478900,0.000000,13.737200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<12.614400,0.000000,13.601700>}
box{<0,0,-0.038100><0.191626,0.036000,0.038100> rotate<0,44.997030,0> translate<12.478900,0.000000,13.737200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.297400,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.297400,0.000000,14.144000>}
box{<0,0,-0.038100><0.542300,0.036000,0.038100> rotate<0,90.000000,0> translate<13.297400,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.297400,0.000000,13.872800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.568500,0.000000,14.144000>}
box{<0,0,-0.038100><0.383464,0.036000,0.038100> rotate<0,-45.007595,0> translate<13.297400,0.000000,13.872800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.568500,0.000000,14.144000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.704100,0.000000,14.144000>}
box{<0,0,-0.038100><0.135600,0.036000,0.038100> rotate<0,0.000000,0> translate<13.568500,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.250600,0.000000,13.330600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.386200,0.000000,13.330600>}
box{<0,0,-0.038100><0.135600,0.036000,0.038100> rotate<0,0.000000,0> translate<14.250600,0.000000,13.330600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.386200,0.000000,13.330600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.521800,0.000000,13.466200>}
box{<0,0,-0.038100><0.191767,0.036000,0.038100> rotate<0,-44.997030,0> translate<14.386200,0.000000,13.330600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.521800,0.000000,13.466200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.521800,0.000000,14.144000>}
box{<0,0,-0.038100><0.677800,0.036000,0.038100> rotate<0,90.000000,0> translate<14.521800,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.521800,0.000000,14.144000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.115000,0.000000,14.144000>}
box{<0,0,-0.038100><0.406800,0.036000,0.038100> rotate<0,0.000000,0> translate<14.115000,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.115000,0.000000,14.144000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.979500,0.000000,14.008400>}
box{<0,0,-0.038100><0.191697,0.036000,0.038100> rotate<0,-45.018163,0> translate<13.979500,0.000000,14.008400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.979500,0.000000,14.008400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.979500,0.000000,13.737200>}
box{<0,0,-0.038100><0.271200,0.036000,0.038100> rotate<0,-90.000000,0> translate<13.979500,0.000000,13.737200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<13.979500,0.000000,13.737200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.115000,0.000000,13.601700>}
box{<0,0,-0.038100><0.191626,0.036000,0.038100> rotate<0,44.997030,0> translate<13.979500,0.000000,13.737200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.115000,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.521800,0.000000,13.601700>}
box{<0,0,-0.038100><0.406800,0.036000,0.038100> rotate<0,0.000000,0> translate<14.115000,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<14.798000,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.340300,0.000000,14.415100>}
box{<0,0,-0.038100><0.977604,0.036000,0.038100> rotate<0,-56.304591,0> translate<14.798000,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.752000,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.023200,0.000000,13.601700>}
box{<0,0,-0.038100><0.271200,0.036000,0.038100> rotate<0,0.000000,0> translate<15.752000,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.023200,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.158800,0.000000,13.737200>}
box{<0,0,-0.038100><0.191697,0.036000,0.038100> rotate<0,-44.975897,0> translate<16.023200,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.158800,0.000000,13.737200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.158800,0.000000,14.008400>}
box{<0,0,-0.038100><0.271200,0.036000,0.038100> rotate<0,90.000000,0> translate<16.158800,0.000000,14.008400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.158800,0.000000,14.008400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.023200,0.000000,14.144000>}
box{<0,0,-0.038100><0.191767,0.036000,0.038100> rotate<0,44.997030,0> translate<16.023200,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.023200,0.000000,14.144000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.752000,0.000000,14.144000>}
box{<0,0,-0.038100><0.271200,0.036000,0.038100> rotate<0,0.000000,0> translate<15.752000,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.752000,0.000000,14.144000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.616500,0.000000,14.008400>}
box{<0,0,-0.038100><0.191697,0.036000,0.038100> rotate<0,-45.018163,0> translate<15.616500,0.000000,14.008400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.616500,0.000000,14.008400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.616500,0.000000,13.737200>}
box{<0,0,-0.038100><0.271200,0.036000,0.038100> rotate<0,-90.000000,0> translate<15.616500,0.000000,13.737200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.616500,0.000000,13.737200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<15.752000,0.000000,13.601700>}
box{<0,0,-0.038100><0.191626,0.036000,0.038100> rotate<0,44.997030,0> translate<15.616500,0.000000,13.737200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.841700,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.570500,0.000000,13.601700>}
box{<0,0,-0.038100><0.271200,0.036000,0.038100> rotate<0,0.000000,0> translate<16.570500,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.570500,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.435000,0.000000,13.737200>}
box{<0,0,-0.038100><0.191626,0.036000,0.038100> rotate<0,44.997030,0> translate<16.435000,0.000000,13.737200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.435000,0.000000,13.737200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.435000,0.000000,14.008400>}
box{<0,0,-0.038100><0.271200,0.036000,0.038100> rotate<0,90.000000,0> translate<16.435000,0.000000,14.008400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.435000,0.000000,14.008400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.570500,0.000000,14.144000>}
box{<0,0,-0.038100><0.191697,0.036000,0.038100> rotate<0,-45.018163,0> translate<16.435000,0.000000,14.008400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.570500,0.000000,14.144000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.841700,0.000000,14.144000>}
box{<0,0,-0.038100><0.271200,0.036000,0.038100> rotate<0,0.000000,0> translate<16.570500,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.841700,0.000000,14.144000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.977300,0.000000,14.008400>}
box{<0,0,-0.038100><0.191767,0.036000,0.038100> rotate<0,44.997030,0> translate<16.841700,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.977300,0.000000,14.008400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.977300,0.000000,13.872800>}
box{<0,0,-0.038100><0.135600,0.036000,0.038100> rotate<0,-90.000000,0> translate<16.977300,0.000000,13.872800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.977300,0.000000,13.872800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<16.435000,0.000000,13.872800>}
box{<0,0,-0.038100><0.542300,0.036000,0.038100> rotate<0,0.000000,0> translate<16.435000,0.000000,13.872800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.253500,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.660200,0.000000,13.601700>}
box{<0,0,-0.038100><0.406700,0.036000,0.038100> rotate<0,0.000000,0> translate<17.253500,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.660200,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.795800,0.000000,13.737200>}
box{<0,0,-0.038100><0.191697,0.036000,0.038100> rotate<0,-44.975897,0> translate<17.660200,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.795800,0.000000,13.737200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.660200,0.000000,13.872800>}
box{<0,0,-0.038100><0.191767,0.036000,0.038100> rotate<0,44.997030,0> translate<17.660200,0.000000,13.872800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.660200,0.000000,13.872800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.389000,0.000000,13.872800>}
box{<0,0,-0.038100><0.271200,0.036000,0.038100> rotate<0,0.000000,0> translate<17.389000,0.000000,13.872800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.389000,0.000000,13.872800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.253500,0.000000,14.008400>}
box{<0,0,-0.038100><0.191697,0.036000,0.038100> rotate<0,45.018163,0> translate<17.253500,0.000000,14.008400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.253500,0.000000,14.008400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.389000,0.000000,14.144000>}
box{<0,0,-0.038100><0.191697,0.036000,0.038100> rotate<0,-45.018163,0> translate<17.253500,0.000000,14.008400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.389000,0.000000,14.144000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<17.795800,0.000000,14.144000>}
box{<0,0,-0.038100><0.406800,0.036000,0.038100> rotate<0,0.000000,0> translate<17.389000,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.614300,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.072000,0.000000,13.601700>}
box{<0,0,-0.038100><0.542300,0.036000,0.038100> rotate<0,0.000000,0> translate<18.072000,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.072000,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.614300,0.000000,14.144000>}
box{<0,0,-0.038100><0.766928,0.036000,0.038100> rotate<0,-44.997030,0> translate<18.072000,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.614300,0.000000,14.144000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.614300,0.000000,14.279600>}
box{<0,0,-0.038100><0.135600,0.036000,0.038100> rotate<0,90.000000,0> translate<18.614300,0.000000,14.279600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.614300,0.000000,14.279600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.478700,0.000000,14.415100>}
box{<0,0,-0.038100><0.191697,0.036000,0.038100> rotate<0,44.975897,0> translate<18.478700,0.000000,14.415100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.478700,0.000000,14.415100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.207500,0.000000,14.415100>}
box{<0,0,-0.038100><0.271200,0.036000,0.038100> rotate<0,0.000000,0> translate<18.207500,0.000000,14.415100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.207500,0.000000,14.415100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.072000,0.000000,14.279600>}
box{<0,0,-0.038100><0.191626,0.036000,0.038100> rotate<0,-44.997030,0> translate<18.072000,0.000000,14.279600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.890500,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.890500,0.000000,13.737200>}
box{<0,0,-0.038100><0.135500,0.036000,0.038100> rotate<0,90.000000,0> translate<18.890500,0.000000,13.737200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.890500,0.000000,13.737200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.026000,0.000000,13.737200>}
box{<0,0,-0.038100><0.135500,0.036000,0.038100> rotate<0,0.000000,0> translate<18.890500,0.000000,13.737200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.026000,0.000000,13.737200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.026000,0.000000,13.601700>}
box{<0,0,-0.038100><0.135500,0.036000,0.038100> rotate<0,-90.000000,0> translate<19.026000,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.026000,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<18.890500,0.000000,13.601700>}
box{<0,0,-0.038100><0.135500,0.036000,0.038100> rotate<0,0.000000,0> translate<18.890500,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.299700,0.000000,14.144000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.570800,0.000000,14.415100>}
box{<0,0,-0.038100><0.383393,0.036000,0.038100> rotate<0,-44.997030,0> translate<19.299700,0.000000,14.144000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.570800,0.000000,14.415100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.570800,0.000000,13.601700>}
box{<0,0,-0.038100><0.813400,0.036000,0.038100> rotate<0,-90.000000,0> translate<19.570800,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.299700,0.000000,13.601700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<19.842000,0.000000,13.601700>}
box{<0,0,-0.038100><0.542300,0.036000,0.038100> rotate<0,0.000000,0> translate<19.299700,0.000000,13.601700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.400200,0.000000,8.238400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.307000,0.000000,8.331600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<16.307000,0.000000,8.331600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.307000,0.000000,8.331600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.120600,0.000000,8.331600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<16.120600,0.000000,8.331600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.120600,0.000000,8.331600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.027400,0.000000,8.238400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<16.027400,0.000000,8.238400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.027400,0.000000,8.238400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.027400,0.000000,7.865600>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,-90.000000,0> translate<16.027400,0.000000,7.865600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.027400,0.000000,7.865600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.120600,0.000000,7.772400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<16.027400,0.000000,7.865600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.120600,0.000000,7.772400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.307000,0.000000,7.772400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<16.120600,0.000000,7.772400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.307000,0.000000,7.772400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.400200,0.000000,7.865600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<16.307000,0.000000,7.772400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.400200,0.000000,7.865600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.400200,0.000000,8.052000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<16.400200,0.000000,8.052000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.400200,0.000000,8.052000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.213800,0.000000,8.052000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<16.213800,0.000000,8.052000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.588700,0.000000,7.772400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.588700,0.000000,8.331600>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,90.000000,0> translate<16.588700,0.000000,8.331600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.588700,0.000000,8.331600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.868300,0.000000,8.331600>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<16.588700,0.000000,8.331600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.868300,0.000000,8.331600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.961500,0.000000,8.238400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<16.868300,0.000000,8.331600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.961500,0.000000,8.238400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.961500,0.000000,8.052000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<16.961500,0.000000,8.052000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.961500,0.000000,8.052000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.868300,0.000000,7.958800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<16.868300,0.000000,7.958800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.868300,0.000000,7.958800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.588700,0.000000,7.958800>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<16.588700,0.000000,7.958800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.150000,0.000000,8.331600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.150000,0.000000,7.772400>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,-90.000000,0> translate<17.150000,0.000000,7.772400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.150000,0.000000,7.772400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.522800,0.000000,7.772400>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<17.150000,0.000000,7.772400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.272600,0.000000,8.145200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.459000,0.000000,7.772400>}
box{<0,0,-0.025400><0.416803,0.036000,0.025400> rotate<0,63.430762,0> translate<18.272600,0.000000,8.145200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.459000,0.000000,7.772400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.645400,0.000000,8.145200>}
box{<0,0,-0.025400><0.416803,0.036000,0.025400> rotate<0,-63.430762,0> translate<18.459000,0.000000,7.772400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.206700,0.000000,7.772400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.833900,0.000000,7.772400>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<18.833900,0.000000,7.772400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.833900,0.000000,7.772400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.206700,0.000000,8.145200>}
box{<0,0,-0.025400><0.527219,0.036000,0.025400> rotate<0,-44.997030,0> translate<18.833900,0.000000,7.772400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.206700,0.000000,8.145200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.206700,0.000000,8.238400>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,90.000000,0> translate<19.206700,0.000000,8.238400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.206700,0.000000,8.238400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.113500,0.000000,8.331600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<19.113500,0.000000,8.331600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.113500,0.000000,8.331600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.927100,0.000000,8.331600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<18.927100,0.000000,8.331600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.927100,0.000000,8.331600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.833900,0.000000,8.238400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<18.833900,0.000000,8.238400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.395200,0.000000,7.772400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.395200,0.000000,7.865600>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,90.000000,0> translate<19.395200,0.000000,7.865600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.395200,0.000000,7.865600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.488400,0.000000,7.865600>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<19.395200,0.000000,7.865600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.488400,0.000000,7.865600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.488400,0.000000,7.772400>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<19.488400,0.000000,7.772400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.488400,0.000000,7.772400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.395200,0.000000,7.772400>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<19.395200,0.000000,7.772400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.675800,0.000000,7.865600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.675800,0.000000,8.238400>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<19.675800,0.000000,8.238400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.675800,0.000000,8.238400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.769000,0.000000,8.331600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<19.675800,0.000000,8.238400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.769000,0.000000,8.331600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.955400,0.000000,8.331600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<19.769000,0.000000,8.331600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.955400,0.000000,8.331600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.048600,0.000000,8.238400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<19.955400,0.000000,8.331600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.048600,0.000000,8.238400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.048600,0.000000,7.865600>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,-90.000000,0> translate<20.048600,0.000000,7.865600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.048600,0.000000,7.865600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.955400,0.000000,7.772400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<19.955400,0.000000,7.772400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.955400,0.000000,7.772400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.769000,0.000000,7.772400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<19.769000,0.000000,7.772400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.769000,0.000000,7.772400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.675800,0.000000,7.865600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<19.675800,0.000000,7.865600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.675800,0.000000,7.865600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.048600,0.000000,8.238400>}
box{<0,0,-0.025400><0.527219,0.036000,0.025400> rotate<0,-44.997030,0> translate<19.675800,0.000000,7.865600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.590200,0.000000,9.000400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.497000,0.000000,9.093600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<12.497000,0.000000,9.093600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.497000,0.000000,9.093600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.310600,0.000000,9.093600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<12.310600,0.000000,9.093600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.310600,0.000000,9.093600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.217400,0.000000,9.000400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<12.217400,0.000000,9.000400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.217400,0.000000,9.000400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.217400,0.000000,8.627600>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,-90.000000,0> translate<12.217400,0.000000,8.627600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.217400,0.000000,8.627600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.310600,0.000000,8.534400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<12.217400,0.000000,8.627600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.310600,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.497000,0.000000,8.534400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<12.310600,0.000000,8.534400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.497000,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.590200,0.000000,8.627600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<12.497000,0.000000,8.534400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.340000,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.340000,0.000000,9.093600>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,90.000000,0> translate<13.340000,0.000000,9.093600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.340000,0.000000,9.093600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.619600,0.000000,9.093600>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<13.340000,0.000000,9.093600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.619600,0.000000,9.093600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.712800,0.000000,9.000400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<13.619600,0.000000,9.093600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.712800,0.000000,9.000400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.712800,0.000000,8.814000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<13.712800,0.000000,8.814000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.712800,0.000000,8.814000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.619600,0.000000,8.720800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<13.619600,0.000000,8.720800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.619600,0.000000,8.720800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.340000,0.000000,8.720800>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<13.340000,0.000000,8.720800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.526400,0.000000,8.720800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.712800,0.000000,8.534400>}
box{<0,0,-0.025400><0.263609,0.036000,0.025400> rotate<0,44.997030,0> translate<13.526400,0.000000,8.720800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.901300,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.901300,0.000000,9.093600>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,90.000000,0> translate<13.901300,0.000000,9.093600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.901300,0.000000,9.093600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.180900,0.000000,9.093600>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<13.901300,0.000000,9.093600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.180900,0.000000,9.093600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.274100,0.000000,9.000400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<14.180900,0.000000,9.093600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.274100,0.000000,9.000400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.274100,0.000000,8.814000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<14.274100,0.000000,8.814000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.274100,0.000000,8.814000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.180900,0.000000,8.720800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<14.180900,0.000000,8.720800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.180900,0.000000,8.720800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.901300,0.000000,8.720800>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<13.901300,0.000000,8.720800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.087700,0.000000,8.720800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.274100,0.000000,8.534400>}
box{<0,0,-0.025400><0.263609,0.036000,0.025400> rotate<0,44.997030,0> translate<14.087700,0.000000,8.720800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.462600,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.462600,0.000000,9.093600>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,90.000000,0> translate<14.462600,0.000000,9.093600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.462600,0.000000,9.093600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.742200,0.000000,9.093600>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<14.462600,0.000000,9.093600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.742200,0.000000,9.093600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.835400,0.000000,9.000400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<14.742200,0.000000,9.093600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.835400,0.000000,9.000400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.835400,0.000000,8.814000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<14.835400,0.000000,8.814000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.835400,0.000000,8.814000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.742200,0.000000,8.720800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<14.742200,0.000000,8.720800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.742200,0.000000,8.720800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.462600,0.000000,8.720800>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<14.462600,0.000000,8.720800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.649000,0.000000,8.720800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.835400,0.000000,8.534400>}
box{<0,0,-0.025400><0.263609,0.036000,0.025400> rotate<0,44.997030,0> translate<14.649000,0.000000,8.720800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.023900,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.023900,0.000000,9.093600>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,90.000000,0> translate<15.023900,0.000000,9.093600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.023900,0.000000,9.093600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.396700,0.000000,9.093600>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<15.023900,0.000000,9.093600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.023900,0.000000,8.814000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.210300,0.000000,8.814000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<15.023900,0.000000,8.814000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.585200,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.585200,0.000000,8.627600>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,90.000000,0> translate<15.585200,0.000000,8.627600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.585200,0.000000,8.627600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.678400,0.000000,8.627600>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<15.585200,0.000000,8.627600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.678400,0.000000,8.627600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.678400,0.000000,8.534400>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<15.678400,0.000000,8.534400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.678400,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.585200,0.000000,8.534400>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<15.585200,0.000000,8.534400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.959000,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.145400,0.000000,8.534400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<15.959000,0.000000,8.534400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.145400,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.238600,0.000000,8.627600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<16.145400,0.000000,8.534400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.238600,0.000000,8.627600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.238600,0.000000,8.814000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<16.238600,0.000000,8.814000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.238600,0.000000,8.814000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.145400,0.000000,8.907200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<16.145400,0.000000,8.907200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.145400,0.000000,8.907200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.959000,0.000000,8.907200>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<15.959000,0.000000,8.907200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.959000,0.000000,8.907200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.865800,0.000000,8.814000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<15.865800,0.000000,8.814000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.865800,0.000000,8.814000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.865800,0.000000,8.627600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<15.865800,0.000000,8.627600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.865800,0.000000,8.627600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.959000,0.000000,8.534400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<15.865800,0.000000,8.627600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.427100,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.427100,0.000000,8.907200>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<16.427100,0.000000,8.907200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.427100,0.000000,8.720800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.613500,0.000000,8.907200>}
box{<0,0,-0.025400><0.263609,0.036000,0.025400> rotate<0,-44.997030,0> translate<16.427100,0.000000,8.720800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.613500,0.000000,8.907200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.706700,0.000000,8.907200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<16.613500,0.000000,8.907200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.081200,0.000000,8.348000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.174400,0.000000,8.348000>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<17.081200,0.000000,8.348000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.174400,0.000000,8.348000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.267600,0.000000,8.441200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<17.174400,0.000000,8.348000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.267600,0.000000,8.441200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.267600,0.000000,8.907200>}
box{<0,0,-0.025400><0.466000,0.036000,0.025400> rotate<0,90.000000,0> translate<17.267600,0.000000,8.907200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.267600,0.000000,8.907200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.988000,0.000000,8.907200>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<16.988000,0.000000,8.907200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.988000,0.000000,8.907200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.894800,0.000000,8.814000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<16.894800,0.000000,8.814000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.894800,0.000000,8.814000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.894800,0.000000,8.627600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<16.894800,0.000000,8.627600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.894800,0.000000,8.627600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.988000,0.000000,8.534400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<16.894800,0.000000,8.627600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.988000,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.267600,0.000000,8.534400>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<16.988000,0.000000,8.534400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.390200,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.017400,0.000000,8.534400>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<18.017400,0.000000,8.534400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.017400,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.390200,0.000000,8.907200>}
box{<0,0,-0.025400><0.527219,0.036000,0.025400> rotate<0,-44.997030,0> translate<18.017400,0.000000,8.534400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.390200,0.000000,8.907200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.390200,0.000000,9.000400>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,90.000000,0> translate<18.390200,0.000000,9.000400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.390200,0.000000,9.000400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.297000,0.000000,9.093600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<18.297000,0.000000,9.093600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.297000,0.000000,9.093600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.110600,0.000000,9.093600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<18.110600,0.000000,9.093600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.110600,0.000000,9.093600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.017400,0.000000,9.000400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<18.017400,0.000000,9.000400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.578700,0.000000,8.627600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.578700,0.000000,9.000400>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<18.578700,0.000000,9.000400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.578700,0.000000,9.000400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.671900,0.000000,9.093600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<18.578700,0.000000,9.000400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.671900,0.000000,9.093600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.858300,0.000000,9.093600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<18.671900,0.000000,9.093600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.858300,0.000000,9.093600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.951500,0.000000,9.000400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<18.858300,0.000000,9.093600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.951500,0.000000,9.000400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.951500,0.000000,8.627600>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,-90.000000,0> translate<18.951500,0.000000,8.627600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.951500,0.000000,8.627600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.858300,0.000000,8.534400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<18.858300,0.000000,8.534400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.858300,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.671900,0.000000,8.534400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<18.671900,0.000000,8.534400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.671900,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.578700,0.000000,8.627600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<18.578700,0.000000,8.627600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.578700,0.000000,8.627600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.951500,0.000000,9.000400>}
box{<0,0,-0.025400><0.527219,0.036000,0.025400> rotate<0,-44.997030,0> translate<18.578700,0.000000,8.627600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.140000,0.000000,8.627600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.140000,0.000000,9.000400>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<19.140000,0.000000,9.000400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.140000,0.000000,9.000400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.233200,0.000000,9.093600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<19.140000,0.000000,9.000400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.233200,0.000000,9.093600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.419600,0.000000,9.093600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<19.233200,0.000000,9.093600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.419600,0.000000,9.093600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.512800,0.000000,9.000400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<19.419600,0.000000,9.093600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.512800,0.000000,9.000400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.512800,0.000000,8.627600>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,-90.000000,0> translate<19.512800,0.000000,8.627600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.512800,0.000000,8.627600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.419600,0.000000,8.534400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<19.419600,0.000000,8.534400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.419600,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.233200,0.000000,8.534400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<19.233200,0.000000,8.534400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.233200,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.140000,0.000000,8.627600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<19.140000,0.000000,8.627600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.140000,0.000000,8.627600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.512800,0.000000,9.000400>}
box{<0,0,-0.025400><0.527219,0.036000,0.025400> rotate<0,-44.997030,0> translate<19.140000,0.000000,8.627600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.701300,0.000000,9.000400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.794500,0.000000,9.093600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<19.701300,0.000000,9.000400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.794500,0.000000,9.093600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.980900,0.000000,9.093600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<19.794500,0.000000,9.093600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.980900,0.000000,9.093600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.074100,0.000000,9.000400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<19.980900,0.000000,9.093600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.074100,0.000000,9.000400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.074100,0.000000,8.907200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<20.074100,0.000000,8.907200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.074100,0.000000,8.907200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.980900,0.000000,8.814000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<19.980900,0.000000,8.814000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.980900,0.000000,8.814000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.074100,0.000000,8.720800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<19.980900,0.000000,8.814000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.074100,0.000000,8.720800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.074100,0.000000,8.627600>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<20.074100,0.000000,8.627600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.074100,0.000000,8.627600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.980900,0.000000,8.534400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<19.980900,0.000000,8.534400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.980900,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.794500,0.000000,8.534400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<19.794500,0.000000,8.534400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.794500,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.701300,0.000000,8.627600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<19.701300,0.000000,8.627600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.701300,0.000000,8.627600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.701300,0.000000,8.720800>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,90.000000,0> translate<19.701300,0.000000,8.720800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.701300,0.000000,8.720800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.794500,0.000000,8.814000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<19.701300,0.000000,8.720800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.794500,0.000000,8.814000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.701300,0.000000,8.907200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<19.701300,0.000000,8.907200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.701300,0.000000,8.907200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.701300,0.000000,9.000400>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,90.000000,0> translate<19.701300,0.000000,9.000400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.794500,0.000000,8.814000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.980900,0.000000,8.814000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<19.794500,0.000000,8.814000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<5.994400,0.000000,12.802000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<5.994400,0.000000,12.242800>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,-90.000000,0> translate<5.994400,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<5.994400,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.274000,0.000000,12.242800>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<5.994400,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.274000,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.367200,0.000000,12.336000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<6.274000,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.367200,0.000000,12.336000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.367200,0.000000,12.708800>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<6.367200,0.000000,12.708800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.367200,0.000000,12.708800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.274000,0.000000,12.802000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<6.274000,0.000000,12.802000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.274000,0.000000,12.802000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<5.994400,0.000000,12.802000>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<5.994400,0.000000,12.802000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.835300,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.648900,0.000000,12.242800>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<6.648900,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.648900,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.555700,0.000000,12.336000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<6.555700,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.555700,0.000000,12.336000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.555700,0.000000,12.522400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<6.555700,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.555700,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.648900,0.000000,12.615600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<6.555700,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.648900,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.835300,0.000000,12.615600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<6.648900,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.835300,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.928500,0.000000,12.522400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<6.835300,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.928500,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.928500,0.000000,12.429200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<6.928500,0.000000,12.429200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.928500,0.000000,12.429200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<6.555700,0.000000,12.429200>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<6.555700,0.000000,12.429200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<7.117000,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<7.396600,0.000000,12.242800>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<7.117000,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<7.396600,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<7.489800,0.000000,12.336000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<7.396600,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<7.489800,0.000000,12.336000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<7.396600,0.000000,12.429200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<7.396600,0.000000,12.429200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<7.396600,0.000000,12.429200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<7.210200,0.000000,12.429200>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<7.210200,0.000000,12.429200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<7.210200,0.000000,12.429200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<7.117000,0.000000,12.522400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<7.117000,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<7.117000,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<7.210200,0.000000,12.615600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<7.117000,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<7.210200,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<7.489800,0.000000,12.615600>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<7.210200,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<7.678300,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<7.771500,0.000000,12.615600>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<7.678300,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<7.771500,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<7.771500,0.000000,12.242800>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,-90.000000,0> translate<7.771500,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<7.678300,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<7.864700,0.000000,12.242800>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<7.678300,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<7.771500,0.000000,12.895200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<7.771500,0.000000,12.802000>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<7.771500,0.000000,12.802000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.238900,0.000000,12.056400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.332100,0.000000,12.056400>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<8.238900,0.000000,12.056400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.332100,0.000000,12.056400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.425300,0.000000,12.149600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<8.332100,0.000000,12.056400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.425300,0.000000,12.149600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.425300,0.000000,12.615600>}
box{<0,0,-0.025400><0.466000,0.036000,0.025400> rotate<0,90.000000,0> translate<8.425300,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.425300,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.145700,0.000000,12.615600>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<8.145700,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.145700,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.052500,0.000000,12.522400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<8.052500,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.052500,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.052500,0.000000,12.336000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<8.052500,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.052500,0.000000,12.336000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.145700,0.000000,12.242800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<8.052500,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.145700,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.425300,0.000000,12.242800>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<8.145700,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.613800,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.613800,0.000000,12.615600>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<8.613800,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.613800,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.893400,0.000000,12.615600>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<8.613800,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.893400,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.986600,0.000000,12.522400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<8.893400,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.986600,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<8.986600,0.000000,12.242800>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,-90.000000,0> translate<8.986600,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<9.736400,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<9.736400,0.000000,12.802000>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,90.000000,0> translate<9.736400,0.000000,12.802000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<9.736400,0.000000,12.802000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.016000,0.000000,12.802000>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<9.736400,0.000000,12.802000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.016000,0.000000,12.802000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.109200,0.000000,12.708800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<10.016000,0.000000,12.802000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.109200,0.000000,12.708800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.109200,0.000000,12.615600>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<10.109200,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.109200,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.016000,0.000000,12.522400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<10.016000,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.016000,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.109200,0.000000,12.429200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<10.016000,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.109200,0.000000,12.429200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.109200,0.000000,12.336000>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<10.109200,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.109200,0.000000,12.336000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.016000,0.000000,12.242800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<10.016000,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.016000,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<9.736400,0.000000,12.242800>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<9.736400,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<9.736400,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.016000,0.000000,12.522400>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<9.736400,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.297700,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.297700,0.000000,12.336000>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,-90.000000,0> translate<10.297700,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.297700,0.000000,12.336000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.390900,0.000000,12.242800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<10.297700,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.390900,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.670500,0.000000,12.242800>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<10.390900,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.670500,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.670500,0.000000,12.149600>}
box{<0,0,-0.025400><0.466000,0.036000,0.025400> rotate<0,-90.000000,0> translate<10.670500,0.000000,12.149600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.670500,0.000000,12.149600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.577300,0.000000,12.056400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<10.577300,0.000000,12.056400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.577300,0.000000,12.056400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.484100,0.000000,12.056400>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<10.484100,0.000000,12.056400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.859000,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.952200,0.000000,12.615600>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<10.859000,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.952200,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.952200,0.000000,12.522400>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<10.952200,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.952200,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.859000,0.000000,12.522400>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<10.859000,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.859000,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.859000,0.000000,12.615600>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,90.000000,0> translate<10.859000,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.859000,0.000000,12.336000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.952200,0.000000,12.336000>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<10.859000,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.952200,0.000000,12.336000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.952200,0.000000,12.242800>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<10.952200,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.952200,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.859000,0.000000,12.242800>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<10.859000,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.859000,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.859000,0.000000,12.336000>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,90.000000,0> translate<10.859000,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.700900,0.000000,12.802000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.073700,0.000000,12.802000>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<11.700900,0.000000,12.802000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.073700,0.000000,12.802000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.073700,0.000000,12.708800>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<12.073700,0.000000,12.708800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.073700,0.000000,12.708800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.700900,0.000000,12.336000>}
box{<0,0,-0.025400><0.527219,0.036000,0.025400> rotate<0,-44.997030,0> translate<11.700900,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.700900,0.000000,12.336000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.700900,0.000000,12.242800>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<11.700900,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.700900,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.073700,0.000000,12.242800>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<11.700900,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.355400,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.541800,0.000000,12.615600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<12.355400,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.541800,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.635000,0.000000,12.522400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<12.541800,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.635000,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.635000,0.000000,12.242800>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,-90.000000,0> translate<12.635000,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.635000,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.355400,0.000000,12.242800>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<12.355400,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.355400,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.262200,0.000000,12.336000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<12.262200,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.262200,0.000000,12.336000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.355400,0.000000,12.429200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<12.262200,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.355400,0.000000,12.429200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.635000,0.000000,12.429200>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<12.355400,0.000000,12.429200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.196300,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.916700,0.000000,12.615600>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<12.916700,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.916700,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.823500,0.000000,12.522400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<12.823500,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.823500,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.823500,0.000000,12.336000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<12.823500,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.823500,0.000000,12.336000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.916700,0.000000,12.242800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<12.823500,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.916700,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.196300,0.000000,12.242800>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<12.916700,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.384800,0.000000,12.802000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.384800,0.000000,12.242800>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,-90.000000,0> translate<13.384800,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.384800,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.478000,0.000000,12.615600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<13.384800,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.478000,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.664400,0.000000,12.615600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<13.478000,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.664400,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.757600,0.000000,12.522400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<13.664400,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.757600,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.757600,0.000000,12.242800>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,-90.000000,0> translate<13.757600,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.946100,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.946100,0.000000,12.802000>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,90.000000,0> translate<13.946100,0.000000,12.802000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.946100,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.318900,0.000000,12.522400>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<13.946100,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.318900,0.000000,12.802000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.318900,0.000000,12.242800>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,-90.000000,0> translate<14.318900,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.600600,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.787000,0.000000,12.242800>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<14.600600,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.787000,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.880200,0.000000,12.336000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<14.787000,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.880200,0.000000,12.336000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.880200,0.000000,12.522400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<14.880200,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.880200,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.787000,0.000000,12.615600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<14.787000,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.787000,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.600600,0.000000,12.615600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<14.600600,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.600600,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.507400,0.000000,12.522400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<14.507400,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.507400,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.507400,0.000000,12.336000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<14.507400,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.507400,0.000000,12.336000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.600600,0.000000,12.242800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<14.507400,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.348300,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.161900,0.000000,12.242800>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<15.161900,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.161900,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.068700,0.000000,12.336000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<15.068700,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.068700,0.000000,12.336000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.068700,0.000000,12.522400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<15.068700,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.068700,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.161900,0.000000,12.615600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<15.068700,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.161900,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.348300,0.000000,12.615600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<15.161900,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.348300,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.441500,0.000000,12.522400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<15.348300,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.441500,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.441500,0.000000,12.429200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<15.441500,0.000000,12.429200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.441500,0.000000,12.429200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.068700,0.000000,12.429200>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<15.068700,0.000000,12.429200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.630000,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.630000,0.000000,12.802000>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,90.000000,0> translate<15.630000,0.000000,12.802000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.909600,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.630000,0.000000,12.429200>}
box{<0,0,-0.025400><0.336037,0.036000,0.025400> rotate<0,33.687844,0> translate<15.630000,0.000000,12.429200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.630000,0.000000,12.429200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.909600,0.000000,12.615600>}
box{<0,0,-0.025400><0.336037,0.036000,0.025400> rotate<0,-33.687844,0> translate<15.630000,0.000000,12.429200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.377300,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.190900,0.000000,12.242800>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<16.190900,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.190900,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.097700,0.000000,12.336000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<16.097700,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.097700,0.000000,12.336000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.097700,0.000000,12.522400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<16.097700,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.097700,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.190900,0.000000,12.615600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<16.097700,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.190900,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.377300,0.000000,12.615600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<16.190900,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.377300,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.470500,0.000000,12.522400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<16.377300,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.470500,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.470500,0.000000,12.429200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<16.470500,0.000000,12.429200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.470500,0.000000,12.429200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.097700,0.000000,12.429200>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<16.097700,0.000000,12.429200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.659000,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.659000,0.000000,12.615600>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<16.659000,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.659000,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.938600,0.000000,12.615600>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<16.659000,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.938600,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.031800,0.000000,12.522400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<16.938600,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.031800,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.031800,0.000000,12.242800>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,-90.000000,0> translate<17.031800,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.220300,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.220300,0.000000,12.336000>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,90.000000,0> translate<17.220300,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.220300,0.000000,12.336000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.313500,0.000000,12.336000>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<17.220300,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.313500,0.000000,12.336000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.313500,0.000000,12.242800>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<17.313500,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.313500,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.220300,0.000000,12.242800>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<17.220300,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.873700,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.594100,0.000000,12.615600>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<17.594100,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.594100,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.500900,0.000000,12.522400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<17.500900,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.500900,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.500900,0.000000,12.336000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<17.500900,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.500900,0.000000,12.336000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.594100,0.000000,12.242800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<17.500900,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.594100,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.873700,0.000000,12.242800>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<17.594100,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.155400,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.341800,0.000000,12.242800>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<18.155400,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.341800,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.435000,0.000000,12.336000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<18.341800,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.435000,0.000000,12.336000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.435000,0.000000,12.522400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<18.435000,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.435000,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.341800,0.000000,12.615600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<18.341800,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.341800,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.155400,0.000000,12.615600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<18.155400,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.155400,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.062200,0.000000,12.522400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<18.062200,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.062200,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.062200,0.000000,12.336000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<18.062200,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.062200,0.000000,12.336000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.155400,0.000000,12.242800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<18.062200,0.000000,12.336000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.623500,0.000000,12.242800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.623500,0.000000,12.615600>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<18.623500,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.623500,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.716700,0.000000,12.615600>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<18.623500,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.716700,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.809900,0.000000,12.522400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<18.716700,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.809900,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.809900,0.000000,12.242800>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,-90.000000,0> translate<18.809900,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.809900,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.903100,0.000000,12.615600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<18.809900,0.000000,12.522400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.903100,0.000000,12.615600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.996300,0.000000,12.522400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<18.903100,0.000000,12.615600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.996300,0.000000,12.522400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.996300,0.000000,12.242800>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,-90.000000,0> translate<18.996300,0.000000,12.242800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.908600,0.000000,10.562500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,10.439700>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<42.785700,0.000000,10.439700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,10.439700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,10.193900>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<42.785700,0.000000,10.193900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,10.193900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.908600,0.000000,10.071100>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,44.973712,0> translate<42.785700,0.000000,10.193900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.908600,0.000000,10.071100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.400100,0.000000,10.071100>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,0.000000,0> translate<42.908600,0.000000,10.071100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.400100,0.000000,10.071100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,10.193900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<43.400100,0.000000,10.071100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,10.193900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,10.439700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<43.522900,0.000000,10.439700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,10.439700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.400100,0.000000,10.562500>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<43.400100,0.000000,10.562500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.400100,0.000000,10.562500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.154300,0.000000,10.562500>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<43.154300,0.000000,10.562500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.154300,0.000000,10.562500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.154300,0.000000,10.316800>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,-90.000000,0> translate<43.154300,0.000000,10.316800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,10.819500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,10.819500>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,0.000000,0> translate<42.785700,0.000000,10.819500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,10.819500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,11.310900>}
box{<0,0,-0.038100><0.885967,0.036000,0.038100> rotate<0,-33.684257,0> translate<42.785700,0.000000,10.819500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,11.310900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,11.310900>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,0.000000,0> translate<42.785700,0.000000,11.310900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,11.567900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,11.567900>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,0.000000,0> translate<42.785700,0.000000,11.567900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,11.567900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,11.936500>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<43.522900,0.000000,11.936500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,11.936500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.400100,0.000000,12.059300>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<43.400100,0.000000,12.059300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.400100,0.000000,12.059300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.908600,0.000000,12.059300>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,0.000000,0> translate<42.908600,0.000000,12.059300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.908600,0.000000,12.059300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,11.936500>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<42.785700,0.000000,11.936500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,11.936500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,11.567900>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,-90.000000,0> translate<42.785700,0.000000,11.567900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.908600,0.000000,8.022500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,7.899700>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<42.785700,0.000000,7.899700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,7.899700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,7.653900>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<42.785700,0.000000,7.653900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,7.653900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.908600,0.000000,7.531100>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,44.973712,0> translate<42.785700,0.000000,7.653900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.908600,0.000000,7.531100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.031500,0.000000,7.531100>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,0.000000,0> translate<42.908600,0.000000,7.531100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.031500,0.000000,7.531100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.154300,0.000000,7.653900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<43.031500,0.000000,7.531100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.154300,0.000000,7.653900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.154300,0.000000,7.899700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<43.154300,0.000000,7.899700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.154300,0.000000,7.899700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.277200,0.000000,8.022500>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<43.154300,0.000000,7.899700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.277200,0.000000,8.022500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.400100,0.000000,8.022500>}
box{<0,0,-0.038100><0.122900,0.036000,0.038100> rotate<0,0.000000,0> translate<43.277200,0.000000,8.022500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.400100,0.000000,8.022500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,7.899700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<43.400100,0.000000,8.022500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,7.899700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,7.653900>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<43.522900,0.000000,7.653900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,7.653900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.400100,0.000000,7.531100>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<43.400100,0.000000,7.531100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,8.279500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,8.525200>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,90.000000,0> translate<43.522900,0.000000,8.525200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,8.402300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,8.402300>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,0.000000,0> translate<42.785700,0.000000,8.402300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,8.279500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,8.525200>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,90.000000,0> translate<42.785700,0.000000,8.525200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.908600,0.000000,9.269800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,9.147000>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<42.785700,0.000000,9.147000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,9.147000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,8.901200>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<42.785700,0.000000,8.901200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,8.901200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.908600,0.000000,8.778400>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,44.973712,0> translate<42.785700,0.000000,8.901200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.908600,0.000000,8.778400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.400100,0.000000,8.778400>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,0.000000,0> translate<42.908600,0.000000,8.778400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.400100,0.000000,8.778400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,8.901200>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<43.400100,0.000000,8.778400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,8.901200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,9.147000>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<43.522900,0.000000,9.147000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,9.147000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.400100,0.000000,9.269800>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<43.400100,0.000000,9.269800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.400100,0.000000,9.269800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.154300,0.000000,9.269800>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,0.000000,0> translate<43.154300,0.000000,9.269800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.154300,0.000000,9.269800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.154300,0.000000,9.024100>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,-90.000000,0> translate<43.154300,0.000000,9.024100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,4.610100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.277200,0.000000,4.610100>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,0.000000,0> translate<42.785700,0.000000,4.610100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.277200,0.000000,4.610100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,4.855800>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,-44.997030,0> translate<43.277200,0.000000,4.610100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,4.855800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.277200,0.000000,5.101500>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,44.997030,0> translate<43.277200,0.000000,5.101500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.277200,0.000000,5.101500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,5.101500>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,0.000000,0> translate<42.785700,0.000000,5.101500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.908600,0.000000,5.849900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,5.727100>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<42.785700,0.000000,5.727100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,5.727100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,5.481300>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<42.785700,0.000000,5.481300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,5.481300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.908600,0.000000,5.358500>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,44.973712,0> translate<42.785700,0.000000,5.481300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.908600,0.000000,5.358500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.400100,0.000000,5.358500>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,0.000000,0> translate<42.908600,0.000000,5.358500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.400100,0.000000,5.358500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,5.481300>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<43.400100,0.000000,5.358500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,5.481300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,5.727100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<43.522900,0.000000,5.727100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,5.727100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.400100,0.000000,5.849900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<43.400100,0.000000,5.849900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.908600,0.000000,6.598300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,6.475500>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<42.785700,0.000000,6.475500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,6.475500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,6.229700>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<42.785700,0.000000,6.229700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.785700,0.000000,6.229700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.908600,0.000000,6.106900>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,44.973712,0> translate<42.785700,0.000000,6.229700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<42.908600,0.000000,6.106900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.400100,0.000000,6.106900>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,0.000000,0> translate<42.908600,0.000000,6.106900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.400100,0.000000,6.106900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,6.229700>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<43.400100,0.000000,6.106900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,6.229700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,6.475500>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<43.522900,0.000000,6.475500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.522900,0.000000,6.475500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<43.400100,0.000000,6.598300>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<43.400100,0.000000,6.598300> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,7.645400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.083400,0.000000,7.645400>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,0.000000,0> translate<10.083400,0.000000,7.645400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.083400,0.000000,7.645400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.083400,0.000000,7.925000>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,90.000000,0> translate<10.083400,0.000000,7.925000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.083400,0.000000,7.925000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.176600,0.000000,8.018200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<10.083400,0.000000,7.925000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.176600,0.000000,8.018200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.269800,0.000000,8.018200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<10.176600,0.000000,8.018200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.269800,0.000000,8.018200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.363000,0.000000,7.925000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<10.269800,0.000000,8.018200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.363000,0.000000,7.925000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.456200,0.000000,8.018200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<10.363000,0.000000,7.925000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.456200,0.000000,8.018200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.549400,0.000000,8.018200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<10.456200,0.000000,8.018200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.549400,0.000000,8.018200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,7.925000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<10.549400,0.000000,8.018200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,7.925000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,7.645400>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,-90.000000,0> translate<10.642600,0.000000,7.645400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.363000,0.000000,7.645400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.363000,0.000000,7.925000>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,90.000000,0> translate<10.363000,0.000000,7.925000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.083400,0.000000,8.206700>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,8.206700>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,0.000000,0> translate<10.083400,0.000000,8.206700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,8.206700>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,8.579500>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<10.642600,0.000000,8.579500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.083400,0.000000,9.047600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.083400,0.000000,8.861200>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<10.083400,0.000000,8.861200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.083400,0.000000,8.861200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.176600,0.000000,8.768000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<10.083400,0.000000,8.861200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.176600,0.000000,8.768000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.549400,0.000000,8.768000>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<10.176600,0.000000,8.768000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.549400,0.000000,8.768000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,8.861200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<10.549400,0.000000,8.768000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,8.861200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,9.047600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<10.642600,0.000000,9.047600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,9.047600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.549400,0.000000,9.140800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<10.549400,0.000000,9.140800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.549400,0.000000,9.140800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.176600,0.000000,9.140800>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<10.176600,0.000000,9.140800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.176600,0.000000,9.140800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.083400,0.000000,9.047600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<10.083400,0.000000,9.047600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.176600,0.000000,9.702100>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.083400,0.000000,9.608900>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<10.083400,0.000000,9.608900> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.083400,0.000000,9.608900>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.083400,0.000000,9.422500>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<10.083400,0.000000,9.422500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.083400,0.000000,9.422500>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.176600,0.000000,9.329300>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<10.083400,0.000000,9.422500> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.176600,0.000000,9.329300>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.549400,0.000000,9.329300>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<10.176600,0.000000,9.329300> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.549400,0.000000,9.329300>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,9.422500>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<10.549400,0.000000,9.329300> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,9.422500>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,9.608900>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<10.642600,0.000000,9.608900> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,9.608900>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.549400,0.000000,9.702100>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<10.549400,0.000000,9.702100> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.083400,0.000000,9.890600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,9.890600>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,0.000000,0> translate<10.083400,0.000000,9.890600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.456200,0.000000,9.890600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.083400,0.000000,10.263400>}
box{<0,0,-0.025400><0.527219,0.036000,0.025400> rotate<0,44.997030,0> translate<10.083400,0.000000,10.263400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.363000,0.000000,9.983800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,10.263400>}
box{<0,0,-0.025400><0.395414,0.036000,0.025400> rotate<0,-44.997030,0> translate<10.363000,0.000000,9.983800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.083400,0.000000,10.824700>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.083400,0.000000,10.451900>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,-90.000000,0> translate<10.083400,0.000000,10.451900> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.083400,0.000000,10.451900>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,10.451900>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,0.000000,0> translate<10.083400,0.000000,10.451900> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,10.451900>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,10.824700>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<10.642600,0.000000,10.824700> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.363000,0.000000,10.451900>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.363000,0.000000,10.638300>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<10.363000,0.000000,10.638300> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.083400,0.000000,11.013200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,11.013200>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,0.000000,0> translate<10.083400,0.000000,11.013200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,11.013200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,11.292800>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,90.000000,0> translate<10.642600,0.000000,11.292800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.642600,0.000000,11.292800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.549400,0.000000,11.386000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<10.549400,0.000000,11.386000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.549400,0.000000,11.386000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.176600,0.000000,11.386000>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<10.176600,0.000000,11.386000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.176600,0.000000,11.386000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.083400,0.000000,11.292800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<10.083400,0.000000,11.292800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.083400,0.000000,11.292800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.083400,0.000000,11.013200>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,-90.000000,0> translate<10.083400,0.000000,11.013200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<9.169400,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<9.169400,0.000000,6.299600>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,90.000000,0> translate<9.169400,0.000000,6.299600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<9.169400,0.000000,6.299600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<9.542200,0.000000,6.299600>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<9.169400,0.000000,6.299600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<9.169400,0.000000,6.020000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<9.355800,0.000000,6.020000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<9.169400,0.000000,6.020000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<9.823900,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.010300,0.000000,5.740400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<9.823900,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.010300,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.103500,0.000000,5.833600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<10.010300,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.103500,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.103500,0.000000,6.020000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<10.103500,0.000000,6.020000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.103500,0.000000,6.020000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.010300,0.000000,6.113200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<10.010300,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.010300,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<9.823900,0.000000,6.113200>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<9.823900,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<9.823900,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<9.730700,0.000000,6.020000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<9.730700,0.000000,6.020000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<9.730700,0.000000,6.020000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<9.730700,0.000000,5.833600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<9.730700,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<9.730700,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<9.823900,0.000000,5.740400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<9.730700,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.292000,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.292000,0.000000,6.113200>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<10.292000,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.292000,0.000000,5.926800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.478400,0.000000,6.113200>}
box{<0,0,-0.025400><0.263609,0.036000,0.025400> rotate<0,-44.997030,0> translate<10.292000,0.000000,5.926800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.478400,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<10.571600,0.000000,6.113200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<10.478400,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.321000,0.000000,6.299600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.693800,0.000000,6.299600>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<11.321000,0.000000,6.299600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.693800,0.000000,6.299600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.693800,0.000000,6.206400>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<11.693800,0.000000,6.206400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.693800,0.000000,6.206400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.321000,0.000000,5.833600>}
box{<0,0,-0.025400><0.527219,0.036000,0.025400> rotate<0,-44.997030,0> translate<11.321000,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.321000,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.321000,0.000000,5.740400>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<11.321000,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.321000,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.693800,0.000000,5.740400>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<11.321000,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.882300,0.000000,6.299600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.882300,0.000000,5.740400>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,-90.000000,0> translate<11.882300,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.882300,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.161900,0.000000,5.740400>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<11.882300,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.161900,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.255100,0.000000,5.833600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<12.161900,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.255100,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.255100,0.000000,6.206400>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<12.255100,0.000000,6.206400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.255100,0.000000,6.206400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.161900,0.000000,6.299600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<12.161900,0.000000,6.299600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.161900,0.000000,6.299600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.882300,0.000000,6.299600>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<11.882300,0.000000,6.299600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.443600,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.630000,0.000000,6.299600>}
box{<0,0,-0.025400><0.263609,0.036000,0.025400> rotate<0,-44.997030,0> translate<12.443600,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.630000,0.000000,6.299600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.630000,0.000000,5.740400>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,-90.000000,0> translate<12.630000,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.443600,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.816400,0.000000,5.740400>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<12.443600,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.004900,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.098100,0.000000,5.740400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<13.004900,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.098100,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.284500,0.000000,5.740400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<13.098100,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.284500,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.377700,0.000000,5.833600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<13.284500,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.377700,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.377700,0.000000,6.206400>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<13.377700,0.000000,6.206400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.377700,0.000000,6.206400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.284500,0.000000,6.299600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<13.284500,0.000000,6.299600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.284500,0.000000,6.299600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.098100,0.000000,6.299600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<13.098100,0.000000,6.299600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.098100,0.000000,6.299600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.004900,0.000000,6.206400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<13.004900,0.000000,6.206400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.004900,0.000000,6.206400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.004900,0.000000,6.113200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<13.004900,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.004900,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.098100,0.000000,6.020000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<13.004900,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.098100,0.000000,6.020000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.377700,0.000000,6.020000>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<13.098100,0.000000,6.020000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.566200,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.566200,0.000000,6.206400>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<13.566200,0.000000,6.206400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.566200,0.000000,6.206400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.659400,0.000000,6.299600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<13.566200,0.000000,6.206400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.659400,0.000000,6.299600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.845800,0.000000,6.299600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<13.659400,0.000000,6.299600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.845800,0.000000,6.299600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.939000,0.000000,6.206400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<13.845800,0.000000,6.299600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.939000,0.000000,6.206400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.939000,0.000000,5.833600>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,-90.000000,0> translate<13.939000,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.939000,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.845800,0.000000,5.740400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<13.845800,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.845800,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.659400,0.000000,5.740400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<13.659400,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.659400,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.566200,0.000000,5.833600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<13.566200,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.566200,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.939000,0.000000,6.206400>}
box{<0,0,-0.025400><0.527219,0.036000,0.025400> rotate<0,-44.997030,0> translate<13.566200,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.127500,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.313900,0.000000,6.299600>}
box{<0,0,-0.025400><0.263609,0.036000,0.025400> rotate<0,-44.997030,0> translate<14.127500,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.313900,0.000000,6.299600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.313900,0.000000,5.740400>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,-90.000000,0> translate<14.313900,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.127500,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.500300,0.000000,5.740400>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<14.127500,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.688800,0.000000,5.554000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.875200,0.000000,5.740400>}
box{<0,0,-0.025400><0.263609,0.036000,0.025400> rotate<0,-44.997030,0> translate<14.688800,0.000000,5.554000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.875200,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.875200,0.000000,5.833600>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,90.000000,0> translate<14.875200,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.875200,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.782000,0.000000,5.833600>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<14.782000,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.782000,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.782000,0.000000,5.740400>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<14.782000,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.782000,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.875200,0.000000,5.740400>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<14.782000,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.903900,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.717500,0.000000,5.740400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<15.717500,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.717500,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.624300,0.000000,5.833600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<15.624300,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.624300,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.624300,0.000000,6.020000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<15.624300,0.000000,6.020000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.624300,0.000000,6.020000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.717500,0.000000,6.113200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<15.624300,0.000000,6.020000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.717500,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.903900,0.000000,6.113200>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<15.717500,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.903900,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.997100,0.000000,6.020000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<15.903900,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.997100,0.000000,6.020000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.997100,0.000000,5.926800>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<15.997100,0.000000,5.926800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.997100,0.000000,5.926800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.624300,0.000000,5.926800>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<15.624300,0.000000,5.926800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.278800,0.000000,6.206400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.278800,0.000000,5.833600>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,-90.000000,0> translate<16.278800,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.278800,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.372000,0.000000,5.740400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<16.278800,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.185600,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.372000,0.000000,6.113200>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<16.185600,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.932600,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.653000,0.000000,6.113200>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<16.653000,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.653000,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.559800,0.000000,6.020000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<16.559800,0.000000,6.020000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.559800,0.000000,6.020000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.559800,0.000000,5.833600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<16.559800,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.559800,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.653000,0.000000,5.740400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<16.559800,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.653000,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.932600,0.000000,5.740400>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<16.653000,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.121100,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.214300,0.000000,6.113200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<17.121100,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.214300,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.214300,0.000000,6.020000>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<17.214300,0.000000,6.020000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.214300,0.000000,6.020000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.121100,0.000000,6.020000>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<17.121100,0.000000,6.020000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.121100,0.000000,6.020000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.121100,0.000000,6.113200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,90.000000,0> translate<17.121100,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.121100,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.214300,0.000000,5.833600>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<17.121100,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.214300,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.214300,0.000000,5.740400>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<17.214300,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.214300,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.121100,0.000000,5.740400>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<17.121100,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.121100,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.121100,0.000000,5.833600>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,90.000000,0> translate<17.121100,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.335800,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.056200,0.000000,6.113200>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<18.056200,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.056200,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.963000,0.000000,6.020000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<17.963000,0.000000,6.020000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.963000,0.000000,6.020000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.963000,0.000000,5.833600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<17.963000,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.963000,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.056200,0.000000,5.740400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<17.963000,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.056200,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.335800,0.000000,5.740400>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<18.056200,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.524300,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.524300,0.000000,5.833600>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,-90.000000,0> translate<18.524300,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.524300,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.617500,0.000000,5.740400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<18.524300,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.617500,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.897100,0.000000,5.740400>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<18.617500,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.897100,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.897100,0.000000,6.113200>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<18.897100,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.178800,0.000000,6.206400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.178800,0.000000,5.833600>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,-90.000000,0> translate<19.178800,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.178800,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.272000,0.000000,5.740400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<19.178800,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.085600,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<19.272000,0.000000,6.113200>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<19.085600,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.021100,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.021100,0.000000,6.113200>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<20.021100,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.021100,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.207500,0.000000,6.299600>}
box{<0,0,-0.025400><0.263609,0.036000,0.025400> rotate<0,-44.997030,0> translate<20.021100,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.207500,0.000000,6.299600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.393900,0.000000,6.113200>}
box{<0,0,-0.025400><0.263609,0.036000,0.025400> rotate<0,44.997030,0> translate<20.207500,0.000000,6.299600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.393900,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.393900,0.000000,5.740400>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,-90.000000,0> translate<20.393900,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.021100,0.000000,6.020000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.393900,0.000000,6.020000>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<20.021100,0.000000,6.020000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.582400,0.000000,5.554000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.768800,0.000000,5.740400>}
box{<0,0,-0.025400><0.263609,0.036000,0.025400> rotate<0,-44.997030,0> translate<20.582400,0.000000,5.554000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.768800,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.768800,0.000000,5.833600>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,90.000000,0> translate<20.768800,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.768800,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.675600,0.000000,5.833600>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<20.675600,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.675600,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.675600,0.000000,5.740400>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<20.675600,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.675600,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<20.768800,0.000000,5.740400>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<20.675600,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<21.517900,0.000000,5.554000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<21.611100,0.000000,5.554000>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<21.517900,0.000000,5.554000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<21.611100,0.000000,5.554000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<21.704300,0.000000,5.647200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<21.611100,0.000000,5.554000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<21.704300,0.000000,5.647200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<21.704300,0.000000,6.113200>}
box{<0,0,-0.025400><0.466000,0.036000,0.025400> rotate<0,90.000000,0> translate<21.704300,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<21.704300,0.000000,6.392800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<21.704300,0.000000,6.299600>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<21.704300,0.000000,6.299600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<21.892100,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<21.892100,0.000000,5.833600>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,-90.000000,0> translate<21.892100,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<21.892100,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<21.985300,0.000000,5.740400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<21.892100,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<21.985300,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<22.264900,0.000000,5.740400>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<21.985300,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<22.264900,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<22.264900,0.000000,6.113200>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<22.264900,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<22.453400,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<22.453400,0.000000,6.113200>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<22.453400,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<22.453400,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<22.546600,0.000000,6.113200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<22.453400,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<22.546600,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<22.639800,0.000000,6.020000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<22.546600,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<22.639800,0.000000,6.020000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<22.639800,0.000000,5.740400>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,-90.000000,0> translate<22.639800,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<22.639800,0.000000,6.020000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<22.733000,0.000000,6.113200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<22.639800,0.000000,6.020000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<22.733000,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<22.826200,0.000000,6.020000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<22.733000,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<22.826200,0.000000,6.020000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<22.826200,0.000000,5.740400>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,-90.000000,0> translate<22.826200,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.014700,0.000000,5.554000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.014700,0.000000,6.113200>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,90.000000,0> translate<23.014700,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.014700,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.294300,0.000000,6.113200>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<23.014700,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.294300,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.387500,0.000000,6.020000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<23.294300,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.387500,0.000000,6.020000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.387500,0.000000,5.833600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<23.387500,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.387500,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.294300,0.000000,5.740400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<23.294300,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.294300,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.014700,0.000000,5.740400>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<23.014700,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.855600,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.669200,0.000000,5.740400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<23.669200,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.669200,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.576000,0.000000,5.833600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<23.576000,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.576000,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.576000,0.000000,6.020000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<23.576000,0.000000,6.020000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.576000,0.000000,6.020000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.669200,0.000000,6.113200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<23.576000,0.000000,6.020000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.669200,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.855600,0.000000,6.113200>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<23.669200,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.855600,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.948800,0.000000,6.020000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<23.855600,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.948800,0.000000,6.020000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.948800,0.000000,5.926800>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<23.948800,0.000000,5.926800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.948800,0.000000,5.926800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<23.576000,0.000000,5.926800>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<23.576000,0.000000,5.926800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.137300,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.137300,0.000000,6.113200>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<24.137300,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.137300,0.000000,5.926800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.323700,0.000000,6.113200>}
box{<0,0,-0.025400><0.263609,0.036000,0.025400> rotate<0,-44.997030,0> translate<24.137300,0.000000,5.926800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.323700,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<24.416900,0.000000,6.113200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<24.323700,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<25.166300,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<25.166300,0.000000,6.299600>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,90.000000,0> translate<25.166300,0.000000,6.299600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<25.166300,0.000000,6.299600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<25.445900,0.000000,6.299600>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<25.166300,0.000000,6.299600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<25.445900,0.000000,6.299600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<25.539100,0.000000,6.206400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<25.445900,0.000000,6.299600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<25.539100,0.000000,6.206400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<25.539100,0.000000,6.113200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<25.539100,0.000000,6.113200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<25.539100,0.000000,6.113200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<25.445900,0.000000,6.020000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<25.445900,0.000000,6.020000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<25.445900,0.000000,6.020000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<25.539100,0.000000,5.926800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<25.445900,0.000000,6.020000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<25.539100,0.000000,5.926800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<25.539100,0.000000,5.833600>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<25.539100,0.000000,5.833600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<25.539100,0.000000,5.833600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<25.445900,0.000000,5.740400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<25.445900,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<25.445900,0.000000,5.740400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<25.166300,0.000000,5.740400>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<25.166300,0.000000,5.740400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<25.166300,0.000000,6.020000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<25.445900,0.000000,6.020000>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<25.166300,0.000000,6.020000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.549100,0.000000,4.356100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.549100,0.000000,4.983100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<24.549100,0.000000,4.983100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.549100,0.000000,4.983100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.862600,0.000000,5.296700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-45.006166,0> translate<24.549100,0.000000,4.983100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.862600,0.000000,5.296700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.176100,0.000000,4.983100>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,45.006166,0> translate<24.862600,0.000000,5.296700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.176100,0.000000,4.983100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.176100,0.000000,4.356100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<25.176100,0.000000,4.356100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<24.549100,0.000000,4.826400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<25.176100,0.000000,4.826400>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<24.549100,0.000000,4.826400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.898100,0.000000,3.594100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.898100,0.000000,4.534700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<22.898100,0.000000,4.534700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.898100,0.000000,4.534700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.368400,0.000000,4.534700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<22.898100,0.000000,4.534700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.368400,0.000000,4.534700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.525100,0.000000,4.377900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<23.368400,0.000000,4.534700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.525100,0.000000,4.377900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.525100,0.000000,4.221100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<23.525100,0.000000,4.221100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.525100,0.000000,4.221100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.368400,0.000000,4.064400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<23.368400,0.000000,4.064400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.368400,0.000000,4.064400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.525100,0.000000,3.907600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<23.368400,0.000000,4.064400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.525100,0.000000,3.907600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.525100,0.000000,3.750800>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<23.525100,0.000000,3.750800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.525100,0.000000,3.750800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.368400,0.000000,3.594100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<23.368400,0.000000,3.594100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.368400,0.000000,3.594100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.898100,0.000000,3.594100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<22.898100,0.000000,3.594100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<22.898100,0.000000,4.064400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<23.368400,0.000000,4.064400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<22.898100,0.000000,4.064400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.082200,0.000000,11.667400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.989000,0.000000,11.760600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<11.989000,0.000000,11.760600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.989000,0.000000,11.760600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.802600,0.000000,11.760600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<11.802600,0.000000,11.760600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.802600,0.000000,11.760600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.709400,0.000000,11.667400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<11.709400,0.000000,11.667400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.709400,0.000000,11.667400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.709400,0.000000,11.574200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<11.709400,0.000000,11.574200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.709400,0.000000,11.574200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.802600,0.000000,11.481000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<11.709400,0.000000,11.574200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.802600,0.000000,11.481000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.989000,0.000000,11.481000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<11.802600,0.000000,11.481000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.989000,0.000000,11.481000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.082200,0.000000,11.387800>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<11.989000,0.000000,11.481000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.082200,0.000000,11.387800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.082200,0.000000,11.294600>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<12.082200,0.000000,11.294600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.082200,0.000000,11.294600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.989000,0.000000,11.201400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<11.989000,0.000000,11.201400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.989000,0.000000,11.201400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.802600,0.000000,11.201400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<11.802600,0.000000,11.201400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.802600,0.000000,11.201400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<11.709400,0.000000,11.294600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<11.709400,0.000000,11.294600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.363900,0.000000,11.667400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.363900,0.000000,11.294600>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,-90.000000,0> translate<12.363900,0.000000,11.294600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.363900,0.000000,11.294600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.457100,0.000000,11.201400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<12.363900,0.000000,11.294600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.270700,0.000000,11.574200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.457100,0.000000,11.574200>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<12.270700,0.000000,11.574200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.924500,0.000000,11.201400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.738100,0.000000,11.201400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<12.738100,0.000000,11.201400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.738100,0.000000,11.201400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.644900,0.000000,11.294600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<12.644900,0.000000,11.294600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.644900,0.000000,11.294600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.644900,0.000000,11.481000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<12.644900,0.000000,11.481000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.644900,0.000000,11.481000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.738100,0.000000,11.574200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<12.644900,0.000000,11.481000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.738100,0.000000,11.574200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.924500,0.000000,11.574200>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<12.738100,0.000000,11.574200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.924500,0.000000,11.574200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.017700,0.000000,11.481000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<12.924500,0.000000,11.574200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.017700,0.000000,11.481000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.017700,0.000000,11.387800>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<13.017700,0.000000,11.387800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.017700,0.000000,11.387800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<12.644900,0.000000,11.387800>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<12.644900,0.000000,11.387800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.206200,0.000000,11.574200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.392600,0.000000,11.201400>}
box{<0,0,-0.025400><0.416803,0.036000,0.025400> rotate<0,63.430762,0> translate<13.206200,0.000000,11.574200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.392600,0.000000,11.201400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.579000,0.000000,11.574200>}
box{<0,0,-0.025400><0.416803,0.036000,0.025400> rotate<0,-63.430762,0> translate<13.392600,0.000000,11.201400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.047100,0.000000,11.201400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.860700,0.000000,11.201400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<13.860700,0.000000,11.201400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.860700,0.000000,11.201400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.767500,0.000000,11.294600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<13.767500,0.000000,11.294600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.767500,0.000000,11.294600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.767500,0.000000,11.481000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<13.767500,0.000000,11.481000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.767500,0.000000,11.481000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.860700,0.000000,11.574200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<13.767500,0.000000,11.481000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.860700,0.000000,11.574200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.047100,0.000000,11.574200>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<13.860700,0.000000,11.574200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.047100,0.000000,11.574200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.140300,0.000000,11.481000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<14.047100,0.000000,11.574200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.140300,0.000000,11.481000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.140300,0.000000,11.387800>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<14.140300,0.000000,11.387800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.140300,0.000000,11.387800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<13.767500,0.000000,11.387800>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<13.767500,0.000000,11.387800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.890100,0.000000,11.760600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.890100,0.000000,11.201400>}
box{<0,0,-0.025400><0.559200,0.036000,0.025400> rotate<0,-90.000000,0> translate<14.890100,0.000000,11.201400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.890100,0.000000,11.201400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.169700,0.000000,11.201400>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<14.890100,0.000000,11.201400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.169700,0.000000,11.201400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.262900,0.000000,11.294600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<15.169700,0.000000,11.201400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.262900,0.000000,11.294600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.262900,0.000000,11.667400>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<15.262900,0.000000,11.667400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.262900,0.000000,11.667400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.169700,0.000000,11.760600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<15.169700,0.000000,11.760600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.169700,0.000000,11.760600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<14.890100,0.000000,11.760600>}
box{<0,0,-0.025400><0.279600,0.036000,0.025400> rotate<0,0.000000,0> translate<14.890100,0.000000,11.760600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.731000,0.000000,11.201400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.544600,0.000000,11.201400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<15.544600,0.000000,11.201400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.544600,0.000000,11.201400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.451400,0.000000,11.294600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<15.451400,0.000000,11.294600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.451400,0.000000,11.294600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.451400,0.000000,11.481000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<15.451400,0.000000,11.481000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.451400,0.000000,11.481000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.544600,0.000000,11.574200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<15.451400,0.000000,11.481000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.544600,0.000000,11.574200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.731000,0.000000,11.574200>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<15.544600,0.000000,11.574200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.731000,0.000000,11.574200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.824200,0.000000,11.481000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<15.731000,0.000000,11.574200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.824200,0.000000,11.481000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.824200,0.000000,11.387800>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,-90.000000,0> translate<15.824200,0.000000,11.387800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.824200,0.000000,11.387800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<15.451400,0.000000,11.387800>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,0.000000,0> translate<15.451400,0.000000,11.387800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.385500,0.000000,11.667400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.292300,0.000000,11.760600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<16.292300,0.000000,11.760600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.292300,0.000000,11.760600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.105900,0.000000,11.760600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<16.105900,0.000000,11.760600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.105900,0.000000,11.760600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.012700,0.000000,11.667400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<16.012700,0.000000,11.667400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.012700,0.000000,11.667400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.012700,0.000000,11.294600>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,-90.000000,0> translate<16.012700,0.000000,11.294600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.012700,0.000000,11.294600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.105900,0.000000,11.201400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<16.012700,0.000000,11.294600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.105900,0.000000,11.201400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.292300,0.000000,11.201400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<16.105900,0.000000,11.201400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.292300,0.000000,11.201400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.385500,0.000000,11.294600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<16.292300,0.000000,11.201400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.385500,0.000000,11.294600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.385500,0.000000,11.481000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<16.385500,0.000000,11.481000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.385500,0.000000,11.481000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.199100,0.000000,11.481000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<16.199100,0.000000,11.481000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.574000,0.000000,11.201400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.574000,0.000000,11.574200>}
box{<0,0,-0.025400><0.372800,0.036000,0.025400> rotate<0,90.000000,0> translate<16.574000,0.000000,11.574200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.574000,0.000000,11.387800>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.760400,0.000000,11.574200>}
box{<0,0,-0.025400><0.263609,0.036000,0.025400> rotate<0,-44.997030,0> translate<16.574000,0.000000,11.387800> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.760400,0.000000,11.574200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<16.853600,0.000000,11.574200>}
box{<0,0,-0.025400><0.093200,0.036000,0.025400> rotate<0,0.000000,0> translate<16.760400,0.000000,11.574200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.134900,0.000000,11.201400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.321300,0.000000,11.201400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<17.134900,0.000000,11.201400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.321300,0.000000,11.201400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.414500,0.000000,11.294600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<17.321300,0.000000,11.201400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.414500,0.000000,11.294600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.414500,0.000000,11.481000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<17.414500,0.000000,11.481000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.414500,0.000000,11.481000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.321300,0.000000,11.574200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<17.321300,0.000000,11.574200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.321300,0.000000,11.574200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.134900,0.000000,11.574200>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<17.134900,0.000000,11.574200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.134900,0.000000,11.574200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.041700,0.000000,11.481000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<17.041700,0.000000,11.481000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.041700,0.000000,11.481000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.041700,0.000000,11.294600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<17.041700,0.000000,11.294600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.041700,0.000000,11.294600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.134900,0.000000,11.201400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<17.041700,0.000000,11.294600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.696200,0.000000,11.201400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.882600,0.000000,11.201400>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<17.696200,0.000000,11.201400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.882600,0.000000,11.201400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.975800,0.000000,11.294600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<17.882600,0.000000,11.201400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.975800,0.000000,11.294600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.975800,0.000000,11.481000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,90.000000,0> translate<17.975800,0.000000,11.481000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.975800,0.000000,11.481000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.882600,0.000000,11.574200>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<17.882600,0.000000,11.574200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.882600,0.000000,11.574200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.696200,0.000000,11.574200>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<17.696200,0.000000,11.574200> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.696200,0.000000,11.574200>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.603000,0.000000,11.481000>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<17.603000,0.000000,11.481000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.603000,0.000000,11.481000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.603000,0.000000,11.294600>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,-90.000000,0> translate<17.603000,0.000000,11.294600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.603000,0.000000,11.294600>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<17.696200,0.000000,11.201400>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,44.997030,0> translate<17.603000,0.000000,11.294600> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.257500,0.000000,11.201400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.257500,0.000000,11.667400>}
box{<0,0,-0.025400><0.466000,0.036000,0.025400> rotate<0,90.000000,0> translate<18.257500,0.000000,11.667400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.257500,0.000000,11.667400>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.350700,0.000000,11.760600>}
box{<0,0,-0.025400><0.131805,0.036000,0.025400> rotate<0,-44.997030,0> translate<18.257500,0.000000,11.667400> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.164300,0.000000,11.481000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<18.350700,0.000000,11.481000>}
box{<0,0,-0.025400><0.186400,0.036000,0.025400> rotate<0,0.000000,0> translate<18.164300,0.000000,11.481000> }
cylinder{<0,0,0><0,0.036000,0>0.012700 translate<24.384000,0.000000,4.826000>}
cylinder{<0,0,0><0,0.036000,0>0.012700 translate<23.876000,0.000000,4.826000>}
box{<0,0,-0.012700><0.508000,0.036000,0.012700> rotate<0,0.000000,0> translate<23.876000,0.000000,4.826000> }
cylinder{<0,0,0><0,0.036000,0>0.012700 translate<23.622000,0.000000,3.175000>}
cylinder{<0,0,0><0,0.036000,0>0.012700 translate<22.733000,0.000000,3.175000>}
box{<0,0,-0.012700><0.889000,0.036000,0.012700> rotate<0,0.000000,0> translate<22.733000,0.000000,3.175000> }
cylinder{<0,0,0><0,0.036000,0>0.012700 translate<22.733000,0.000000,3.175000>}
cylinder{<0,0,0><0,0.036000,0>0.012700 translate<22.860000,0.000000,3.048000>}
box{<0,0,-0.012700><0.179605,0.036000,0.012700> rotate<0,44.997030,0> translate<22.733000,0.000000,3.175000> }
cylinder{<0,0,0><0,0.036000,0>0.012700 translate<22.733000,0.000000,3.175000>}
cylinder{<0,0,0><0,0.036000,0>0.012700 translate<22.860000,0.000000,3.302000>}
box{<0,0,-0.012700><0.179605,0.036000,0.012700> rotate<0,-44.997030,0> translate<22.733000,0.000000,3.175000> }
cylinder{<0,0,0><0,0.036000,0>0.012700 translate<23.622000,0.000000,3.175000>}
cylinder{<0,0,0><0,0.036000,0>0.012700 translate<23.495000,0.000000,3.302000>}
box{<0,0,-0.012700><0.179605,0.036000,0.012700> rotate<0,44.997030,0> translate<23.495000,0.000000,3.302000> }
cylinder{<0,0,0><0,0.036000,0>0.012700 translate<23.622000,0.000000,3.175000>}
cylinder{<0,0,0><0,0.036000,0>0.012700 translate<23.495000,0.000000,3.048000>}
box{<0,0,-0.012700><0.179605,0.036000,0.012700> rotate<0,-44.997030,0> translate<23.495000,0.000000,3.048000> }
difference{
cylinder{<12.420600,0,8.813800><12.420600,0.036000,8.813800>0.406700 translate<0,0.000000,0>}
cylinder{<12.420600,-0.1,8.813800><12.420600,0.135000,8.813800>0.343300 translate<0,0.000000,0>}}
//J1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.358000,0.000000,0.804000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.353000,0.000000,3.683000>}
box{<0,0,-0.101600><2.879004,0.036000,0.101600> rotate<0,89.894561,0> translate<30.353000,0.000000,3.683000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.358000,0.000000,4.191000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.358000,0.000000,4.953000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,90.000000,0> translate<30.358000,0.000000,4.953000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.353000,0.000000,5.461000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.353000,0.000000,6.223000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,90.000000,0> translate<30.353000,0.000000,6.223000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.353000,0.000000,6.731000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.353000,0.000000,7.493000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,90.000000,0> translate<30.353000,0.000000,7.493000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.353000,0.000000,8.001000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.353000,0.000000,8.763000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,90.000000,0> translate<30.353000,0.000000,8.763000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.358000,0.000000,9.271000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.358100,0.000000,10.033000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-89.986542,0> translate<30.358000,0.000000,9.271000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.353000,0.000000,10.541000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.353000,0.000000,11.303000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,90.000000,0> translate<30.353000,0.000000,11.303000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.353000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.352900,0.000000,12.573000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,89.986542,0> translate<30.352900,0.000000,12.573000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.358100,0.000000,13.081000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.358000,0.000000,15.960000>}
box{<0,0,-0.101600><2.879000,0.036000,0.101600> rotate<0,89.992070,0> translate<30.358000,0.000000,15.960000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.623000,0.000000,4.953000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.623000,0.000000,5.461000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,90.000000,0> translate<31.623000,0.000000,5.461000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.163000,0.000000,6.223000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.163000,0.000000,6.731000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,90.000000,0> translate<34.163000,0.000000,6.731000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.623000,0.000000,7.493000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.623000,0.000000,8.001000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,90.000000,0> translate<31.623000,0.000000,8.001000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.353000,0.000000,4.953000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.358000,0.000000,4.953000>}
box{<0,0,-0.101600><0.005000,0.036000,0.101600> rotate<0,0.000000,0> translate<30.353000,0.000000,4.953000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.358000,0.000000,4.953000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.623000,0.000000,4.953000>}
box{<0,0,-0.101600><1.265000,0.036000,0.101600> rotate<0,0.000000,0> translate<30.358000,0.000000,4.953000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.353000,0.000000,6.223000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.163000,0.000000,6.223000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<30.353000,0.000000,6.223000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.353000,0.000000,5.461000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.623000,0.000000,5.461000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<30.353000,0.000000,5.461000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.353000,0.000000,7.493000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.623000,0.000000,7.493000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<30.353000,0.000000,7.493000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.353000,0.000000,6.731000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.163000,0.000000,6.731000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<30.353000,0.000000,6.731000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.353000,0.000000,8.763000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.163000,0.000000,8.763000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<30.353000,0.000000,8.763000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.353000,0.000000,8.001000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.623000,0.000000,8.001000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<30.353000,0.000000,8.001000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.163000,0.000000,8.763000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.163000,0.000000,9.271000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,90.000000,0> translate<34.163000,0.000000,9.271000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.353000,0.000000,9.271000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.358000,0.000000,9.271000>}
box{<0,0,-0.101600><0.005000,0.036000,0.101600> rotate<0,0.000000,0> translate<30.353000,0.000000,9.271000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.358000,0.000000,9.271000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.163000,0.000000,9.271000>}
box{<0,0,-0.101600><3.805000,0.036000,0.101600> rotate<0,0.000000,0> translate<30.358000,0.000000,9.271000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.163000,0.000000,3.683000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.163000,0.000000,4.191000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,90.000000,0> translate<34.163000,0.000000,4.191000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.353000,0.000000,3.683000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.163000,0.000000,3.683000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<30.353000,0.000000,3.683000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.353000,0.000000,4.191000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.358000,0.000000,4.191000>}
box{<0,0,-0.101600><0.005000,0.036000,0.101600> rotate<0,0.000000,0> translate<30.353000,0.000000,4.191000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.358000,0.000000,4.191000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.163000,0.000000,4.191000>}
box{<0,0,-0.101600><3.805000,0.036000,0.101600> rotate<0,0.000000,0> translate<30.358000,0.000000,4.191000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.623000,0.000000,10.033000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.623000,0.000000,10.541000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,90.000000,0> translate<31.623000,0.000000,10.541000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.352900,0.000000,10.033000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.623000,0.000000,10.033000>}
box{<0,0,-0.101600><1.270100,0.036000,0.101600> rotate<0,0.000000,0> translate<30.352900,0.000000,10.033000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.353000,0.000000,10.541000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.623000,0.000000,10.541000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<30.353000,0.000000,10.541000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.358000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.358100,0.000000,12.573000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-89.986542,0> translate<30.358000,0.000000,11.811000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.353000,0.000000,11.303000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.163000,0.000000,11.303000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<30.353000,0.000000,11.303000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.163000,0.000000,11.303000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.163000,0.000000,11.811000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,90.000000,0> translate<34.163000,0.000000,11.811000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.358000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<34.163000,0.000000,11.811000>}
box{<0,0,-0.101600><3.805000,0.036000,0.101600> rotate<0,0.000000,0> translate<30.358000,0.000000,11.811000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.623000,0.000000,12.573000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.623000,0.000000,13.081000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,90.000000,0> translate<31.623000,0.000000,13.081000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.352900,0.000000,12.573000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.623000,0.000000,12.573000>}
box{<0,0,-0.101600><1.270100,0.036000,0.101600> rotate<0,0.000000,0> translate<30.352900,0.000000,12.573000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.352900,0.000000,13.081000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.358100,0.000000,13.081000>}
box{<0,0,-0.101600><0.005200,0.036000,0.101600> rotate<0,0.000000,0> translate<30.352900,0.000000,13.081000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<30.358100,0.000000,13.081000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<31.623000,0.000000,13.081000>}
box{<0,0,-0.101600><1.264900,0.036000,0.101600> rotate<0,0.000000,0> translate<30.358100,0.000000,13.081000> }
//LED1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<8.890000,0.000000,10.972800>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<6.350000,0.000000,10.972800>}
box{<0,0,-0.127000><2.540000,0.036000,0.127000> rotate<0,0.000000,0> translate<6.350000,0.000000,10.972800> }
object{ARC(1.524000,0.152400,230.196354,270.000000,0.036000) translate<7.620000,0.000000,9.398000>}
object{ARC(1.524000,0.152400,269.996240,311.629793,0.036000) translate<7.620100,0.000000,9.398000>}
object{ARC(1.524000,0.152400,90.000000,130.601295,0.036000) translate<7.620000,0.000000,9.398000>}
object{ARC(1.524000,0.152400,50.196354,90.000000,0.036000) translate<7.620000,0.000000,9.398000>}
object{ARC(1.524000,0.152400,125.538115,180.000000,0.036000) translate<7.620000,0.000000,9.398000>}
object{ARC(1.524000,0.152400,180.000000,233.130102,0.036000) translate<7.620000,0.000000,9.398000>}
object{ARC(1.524000,0.152400,0.000000,52.126995,0.036000) translate<7.620000,0.000000,9.398000>}
object{ARC(1.524000,0.152400,307.873005,360.000000,0.036000) translate<7.620000,0.000000,9.398000>}
object{ARC(0.635000,0.152400,180.000000,270.000000,0.036000) translate<7.620000,0.000000,9.398000>}
object{ARC(1.016000,0.152400,180.000000,270.000000,0.036000) translate<7.620000,0.000000,9.398000>}
object{ARC(0.635000,0.152400,0.000000,90.000000,0.036000) translate<7.620000,0.000000,9.398000>}
object{ARC(1.016000,0.152400,0.000000,90.000000,0.036000) translate<7.620000,0.000000,9.398000>}
object{ARC(2.032000,0.254000,129.807015,180.000000,0.036000) translate<7.620000,0.000000,9.398000>}
object{ARC(2.032000,0.254000,180.002820,241.929172,0.036000) translate<7.620000,0.000000,9.398100>}
object{ARC(2.032000,0.254000,0.000000,49.762648,0.036000) translate<7.620000,0.000000,9.398000>}
object{ARC(2.032000,0.254000,299.746980,360.002820,0.036000) translate<7.620000,0.000000,9.397900>}
object{ARC(2.032000,0.254000,241.698289,270.000000,0.036000) translate<7.620000,0.000000,9.398000>}
object{ARC(2.032000,0.254000,269.997180,301.605470,0.036000) translate<7.620100,0.000000,9.398000>}
//R1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<28.143200,0.000000,15.265400>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<28.143200,0.000000,14.884400>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,-90.000000,0> translate<28.143200,0.000000,14.884400> }
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<29.032200,0.000000,14.376400>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<27.254200,0.000000,14.376400>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<27.254200,0.000000,8.534400>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<29.032200,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.254200,0.000000,14.630400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.032200,0.000000,14.630400>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<27.254200,0.000000,14.630400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.286200,0.000000,14.376400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.286200,0.000000,13.995400>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<29.286200,0.000000,13.995400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.159200,0.000000,13.868400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.286200,0.000000,13.995400>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<29.159200,0.000000,13.868400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.000200,0.000000,14.376400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.000200,0.000000,13.995400>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<27.000200,0.000000,13.995400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.127200,0.000000,13.868400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.000200,0.000000,13.995400>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<27.000200,0.000000,13.995400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.159200,0.000000,9.042400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.286200,0.000000,8.915400>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<29.159200,0.000000,9.042400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.159200,0.000000,9.042400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.159200,0.000000,13.868400>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,90.000000,0> translate<29.159200,0.000000,13.868400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.127200,0.000000,9.042400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.000200,0.000000,8.915400>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<27.000200,0.000000,8.915400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.127200,0.000000,9.042400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.127200,0.000000,13.868400>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,90.000000,0> translate<27.127200,0.000000,13.868400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.286200,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.286200,0.000000,8.915400>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<29.286200,0.000000,8.915400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.000200,0.000000,8.534400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.000200,0.000000,8.915400>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<27.000200,0.000000,8.915400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.254200,0.000000,8.280400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.032200,0.000000,8.280400>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<27.254200,0.000000,8.280400> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<28.143200,0.000000,8.026400>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<28.143200,0.000000,7.645400>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,-90.000000,0> translate<28.143200,0.000000,7.645400> }
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-270.000000,0> translate<28.143200,0.000000,14.757400>}
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-270.000000,0> translate<28.143200,0.000000,8.153400>}
//R2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<25.171400,0.000000,15.240000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<25.171400,0.000000,14.859000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,-90.000000,0> translate<25.171400,0.000000,14.859000> }
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<26.060400,0.000000,14.351000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<24.282400,0.000000,14.351000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<24.282400,0.000000,8.509000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<26.060400,0.000000,8.509000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.282400,0.000000,14.605000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.060400,0.000000,14.605000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<24.282400,0.000000,14.605000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.314400,0.000000,14.351000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.314400,0.000000,13.970000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<26.314400,0.000000,13.970000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.187400,0.000000,13.843000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.314400,0.000000,13.970000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<26.187400,0.000000,13.843000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.028400,0.000000,14.351000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.028400,0.000000,13.970000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<24.028400,0.000000,13.970000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.155400,0.000000,13.843000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.028400,0.000000,13.970000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<24.028400,0.000000,13.970000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.187400,0.000000,9.017000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.314400,0.000000,8.890000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<26.187400,0.000000,9.017000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.187400,0.000000,9.017000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.187400,0.000000,13.843000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,90.000000,0> translate<26.187400,0.000000,13.843000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.155400,0.000000,9.017000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.028400,0.000000,8.890000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<24.028400,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.155400,0.000000,9.017000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.155400,0.000000,13.843000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,90.000000,0> translate<24.155400,0.000000,13.843000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.314400,0.000000,8.509000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.314400,0.000000,8.890000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<26.314400,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.028400,0.000000,8.509000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.028400,0.000000,8.890000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<24.028400,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<24.282400,0.000000,8.255000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<26.060400,0.000000,8.255000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<24.282400,0.000000,8.255000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<25.171400,0.000000,8.001000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<25.171400,0.000000,7.620000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,-90.000000,0> translate<25.171400,0.000000,7.620000> }
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-270.000000,0> translate<25.171400,0.000000,14.732000>}
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-270.000000,0> translate<25.171400,0.000000,8.128000>}
//R3 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<22.098000,0.000000,15.240000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<22.098000,0.000000,14.859000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,-90.000000,0> translate<22.098000,0.000000,14.859000> }
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<22.987000,0.000000,14.351000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<21.209000,0.000000,14.351000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<21.209000,0.000000,8.509000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<22.987000,0.000000,8.509000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.209000,0.000000,14.605000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.987000,0.000000,14.605000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<21.209000,0.000000,14.605000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.241000,0.000000,14.351000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.241000,0.000000,13.970000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<23.241000,0.000000,13.970000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.114000,0.000000,13.843000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.241000,0.000000,13.970000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<23.114000,0.000000,13.843000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.955000,0.000000,14.351000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.955000,0.000000,13.970000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<20.955000,0.000000,13.970000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.082000,0.000000,13.843000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.955000,0.000000,13.970000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<20.955000,0.000000,13.970000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.114000,0.000000,9.017000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.241000,0.000000,8.890000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<23.114000,0.000000,9.017000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.114000,0.000000,9.017000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.114000,0.000000,13.843000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,90.000000,0> translate<23.114000,0.000000,13.843000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.082000,0.000000,9.017000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.955000,0.000000,8.890000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<20.955000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.082000,0.000000,9.017000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.082000,0.000000,13.843000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,90.000000,0> translate<21.082000,0.000000,13.843000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.241000,0.000000,8.509000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<23.241000,0.000000,8.890000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<23.241000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.955000,0.000000,8.509000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<20.955000,0.000000,8.890000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<20.955000,0.000000,8.890000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<21.209000,0.000000,8.255000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<22.987000,0.000000,8.255000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<21.209000,0.000000,8.255000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<22.098000,0.000000,8.001000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<22.098000,0.000000,7.620000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,-90.000000,0> translate<22.098000,0.000000,7.620000> }
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-270.000000,0> translate<22.098000,0.000000,14.732000>}
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-270.000000,0> translate<22.098000,0.000000,8.128000>}
//U$1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<5.080000,0.000000,0.254000>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<17.424400,0.000000,0.254000>}
box{<0,0,-0.063500><12.344400,0.036000,0.063500> rotate<0,0.000000,0> translate<5.080000,0.000000,0.254000> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<17.424400,0.000000,0.254000>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<29.768800,0.000000,0.254000>}
box{<0,0,-0.063500><12.344400,0.036000,0.063500> rotate<0,0.000000,0> translate<17.424400,0.000000,0.254000> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<29.768800,0.000000,0.254000>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<29.768800,0.000000,3.429000>}
box{<0,0,-0.063500><3.175000,0.036000,0.063500> rotate<0,90.000000,0> translate<29.768800,0.000000,3.429000> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<29.768800,0.000000,3.429000>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<29.768800,0.000000,6.578600>}
box{<0,0,-0.063500><3.149600,0.036000,0.063500> rotate<0,90.000000,0> translate<29.768800,0.000000,6.578600> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<29.768800,0.000000,6.578600>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<17.424400,0.000000,6.578600>}
box{<0,0,-0.063500><12.344400,0.036000,0.063500> rotate<0,0.000000,0> translate<17.424400,0.000000,6.578600> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<17.424400,0.000000,6.578600>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<5.080000,0.000000,6.578600>}
box{<0,0,-0.063500><12.344400,0.036000,0.063500> rotate<0,0.000000,0> translate<5.080000,0.000000,6.578600> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<5.080000,0.000000,6.578600>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<5.080000,0.000000,3.429000>}
box{<0,0,-0.063500><3.149600,0.036000,0.063500> rotate<0,-90.000000,0> translate<5.080000,0.000000,3.429000> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<5.080000,0.000000,3.429000>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<5.080000,0.000000,0.254000>}
box{<0,0,-0.063500><3.175000,0.036000,0.063500> rotate<0,-90.000000,0> translate<5.080000,0.000000,0.254000> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<17.424400,0.000000,0.254000>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<17.424400,0.000000,3.429000>}
box{<0,0,-0.063500><3.175000,0.036000,0.063500> rotate<0,90.000000,0> translate<17.424400,0.000000,3.429000> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<17.424400,0.000000,3.429000>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<17.424400,0.000000,6.578600>}
box{<0,0,-0.063500><3.149600,0.036000,0.063500> rotate<0,90.000000,0> translate<17.424400,0.000000,6.578600> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<5.080000,0.000000,3.429000>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<17.424400,0.000000,3.429000>}
box{<0,0,-0.063500><12.344400,0.036000,0.063500> rotate<0,0.000000,0> translate<5.080000,0.000000,3.429000> }
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<17.424400,0.000000,3.429000>}
cylinder{<0,0,0><0,0.036000,0>0.063500 translate<29.768800,0.000000,3.429000>}
box{<0,0,-0.063500><12.344400,0.036000,0.063500> rotate<0,0.000000,0> translate<17.424400,0.000000,3.429000> }
//X1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<35.941000,0.000000,4.572000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<35.941000,0.000000,12.192000>}
box{<0,0,-0.127000><7.620000,0.036000,0.127000> rotate<0,90.000000,0> translate<35.941000,0.000000,12.192000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<35.941000,0.000000,12.192000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<37.846000,0.000000,12.192000>}
box{<0,0,-0.127000><1.905000,0.036000,0.127000> rotate<0,0.000000,0> translate<35.941000,0.000000,12.192000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<37.846000,0.000000,12.192000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<42.291000,0.000000,12.192000>}
box{<0,0,-0.127000><4.445000,0.036000,0.127000> rotate<0,0.000000,0> translate<37.846000,0.000000,12.192000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<42.291000,0.000000,12.192000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<42.291000,0.000000,4.572000>}
box{<0,0,-0.127000><7.620000,0.036000,0.127000> rotate<0,-90.000000,0> translate<42.291000,0.000000,4.572000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<42.291000,0.000000,4.572000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<37.846000,0.000000,4.572000>}
box{<0,0,-0.127000><4.445000,0.036000,0.127000> rotate<0,0.000000,0> translate<37.846000,0.000000,4.572000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<37.846000,0.000000,4.572000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<35.941000,0.000000,4.572000>}
box{<0,0,-0.127000><1.905000,0.036000,0.127000> rotate<0,0.000000,0> translate<35.941000,0.000000,4.572000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<37.846000,0.000000,4.572000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<37.846000,0.000000,12.192000>}
box{<0,0,-0.127000><7.620000,0.036000,0.127000> rotate<0,90.000000,0> translate<37.846000,0.000000,12.192000> }
texture{col_slk}
}
#end
translate<mac_x_ver,mac_y_ver,mac_z_ver>
rotate<mac_x_rot,mac_y_rot,mac_z_rot>
}//End union
#end

#if(use_file_as_inc=off)
object{  OPTO_ENDSTOP(-24.472900,0,-8.407400,pcb_rotate_x,pcb_rotate_y,pcb_rotate_z)
#if(pcb_upsidedown=on)
rotate pcb_rotdir*180
#end
}
#end


//Parts not found in 3dpack.dat or 3dusrpac.dat are:
//J1		520426-4
//U$1	H21LOB	H21
//X1	22-23-2031	22-23-2031
