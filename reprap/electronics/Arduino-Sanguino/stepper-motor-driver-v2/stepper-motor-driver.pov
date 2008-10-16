//POVRay-File created by 3d41.ulp v1.05
///home/jenowajenowa/Desktop/reprap/trunk/reprap/electronics/Arduino/stepper-motor-driver-v2/stepper-motor-driver.brd
//10/5/08 1:17 PM

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
#local cam_y = 263;
#local cam_z = -112;
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

#local lgt1_pos_x = 31;
#local lgt1_pos_y = 47;
#local lgt1_pos_z = 25;
#local lgt1_intense = 0.757447;
#local lgt2_pos_x = -31;
#local lgt2_pos_y = 47;
#local lgt2_pos_z = 25;
#local lgt2_intense = 0.757447;
#local lgt3_pos_x = 31;
#local lgt3_pos_y = 47;
#local lgt3_pos_z = -17;
#local lgt3_intense = 0.757447;
#local lgt4_pos_x = -31;
#local lgt4_pos_y = 47;
#local lgt4_pos_z = -17;
#local lgt4_intense = 0.757447;

//Do not change these values
#declare pcb_height = 1.500000;
#declare pcb_cuheight = 0.035000;
#declare pcb_x_size = 82.474000;
#declare pcb_y_size = 48.758000;
#declare pcb_layer1_used = 1;
#declare pcb_layer16_used = 1;
#declare inc_testmode = off;
#declare global_seed=seed(687);
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
	//translate<-41.237000,0,-24.379000>
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
<16.421000,10.673000><98.895000,10.673000>
<98.895000,10.673000><98.895000,59.431000>
<98.895000,59.431000><16.421000,59.431000>
<16.421000,59.431000><16.421000,10.673000>
texture{col_brd}}
}//End union(Platine)
//Holes(real)/Parts
cylinder{<18.034000,1,48.133000><18.034000,-5,48.133000>1.625600 texture{col_hls}}
cylinder{<18.034000,1,36.703000><18.034000,-5,36.703000>1.625600 texture{col_hls}}
cylinder{<18.034000,1,32.512000><18.034000,-5,32.512000>1.625600 texture{col_hls}}
cylinder{<18.034000,1,21.082000><18.034000,-5,21.082000>1.625600 texture{col_hls}}
cylinder{<20.447000,1,55.245000><20.447000,-5,55.245000>1.500000 texture{col_hls}}
cylinder{<94.869000,1,55.499000><94.869000,-5,55.499000>1.500000 texture{col_hls}}
cylinder{<20.447000,1,14.605000><20.447000,-5,14.605000>1.500000 texture{col_hls}}
cylinder{<94.869000,1,14.605000><94.869000,-5,14.605000>1.500000 texture{col_hls}}
//Holes(real)/Board
//Holes(real)/Vias
}//End difference(reale Bohrungen/Durchbrüche)
#end
#if(pcb_parts=on)//Parts
union{
#ifndef(pack_C1) #declare global_pack_C1=yes; object {CAP_DIS_CERAMIC_50MM_76MM(".22uF",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<37.338000,0.000000,28.956000>}#end		//ceramic disc capacitator C1 .22uF C050-030X075
#ifndef(pack_C2) #declare global_pack_C2=yes; object {CAP_DIS_CERAMIC_50MM_76MM("1nF",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<37.338000,0.000000,39.624000>}#end		//ceramic disc capacitator C2 1nF C050-030X075
#ifndef(pack_C3) #declare global_pack_C3=yes; object {CAP_DIS_CERAMIC_50MM_76MM(".22uF",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<37.338000,0.000000,32.512000>}#end		//ceramic disc capacitator C3 .22uF C050-030X075
#ifndef(pack_C4) #declare global_pack_C4=yes; object {CAP_DIS_CERAMIC_50MM_76MM("680pF",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<69.342000,0.000000,29.210000>}#end		//ceramic disc capacitator C4 680pF C050-030X075
#ifndef(pack_C5) #declare global_pack_C5=yes; object {CAP_DIS_CERAMIC_50MM_76MM("680pF",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<69.342000,0.000000,37.592000>}#end		//ceramic disc capacitator C5 680pF C050-030X075
#ifndef(pack_C6) #declare global_pack_C6=yes; object {CAP_DIS_CERAMIC_50MM_76MM("100nF",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<27.178000,0.000000,14.986000>}#end		//ceramic disc capacitator C6 100nF C050-030X075
#ifndef(pack_C7) #declare global_pack_C7=yes; object {CAP_DIS_CERAMIC_50MM_76MM(".22uF",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<37.338000,0.000000,36.068000>}#end		//ceramic disc capacitator C7 .22uF C050-030X075
#ifndef(pack_C8) #declare global_pack_C8=yes; object {CAP_DIS_CERAMIC_50MM_76MM("100nF",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<80.518000,0.000000,14.732000>}#end		//ceramic disc capacitator C8 100nF C050-030X075
#ifndef(pack_C10) #declare global_pack_C10=yes; object {CAP_DIS_ELKO_5MM_12MM5("470uF",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<36.068000,0.000000,17.526000>}#end		//Elko 5mm Pitch, 12,5mm  Diameter, 22,5mm High C10 470uF E5-13
#ifndef(pack_C11) #declare global_pack_C11=yes; object {CAP_DIS_ELKO_3MM5_8MM("100uF",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<74.422000,0.000000,14.986000>}#end		//Elko 3,5mm Pitch, 8mm  Diameter, 11,5mm High C11 100uF E3,5-8
#ifndef(pack_DRIVER) #declare global_pack_DRIVER=yes; object {IC_SMD_PLCC44("A3977",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<54.229000,0.000000,33.401000>translate<0,0.035000,0> }#end		//SMD-PLCC 44Pin DRIVER A3977 PLCC44
#ifndef(pack_JP1) #declare global_pack_JP1=yes; object {PH_2X1J(2,)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<68.326000,0.000000,14.224000>}#end		//Jumper 2,54mm Grid 2Pin 1Row (jumper.lib) JP1  JP1
#ifndef(pack_LED1) #declare global_pack_LED1=yes; object {DIODE_DIS_LED_5MM(Green,0.500000,0.000000,)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<86.995000,0.000000,14.478000>}#end		//Diskrete 5MM LED LED1  LED5MM
#ifndef(pack_LED2) #declare global_pack_LED2=yes; object {DIODE_DIS_LED_5MM(Green,0.500000,0.000000,)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<95.504000,0.000000,24.638000>}#end		//Diskrete 5MM LED LED2  LED5MM
#ifndef(pack_LED3) #declare global_pack_LED3=yes; object {DIODE_DIS_LED_5MM(Red,0.500000,0.000000,)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-270.000000,0> rotate<0,0,0> translate<88.900000,0.000000,24.638000>}#end		//Diskrete 5MM LED LED3  LED5MM
#ifndef(pack_LED4) #declare global_pack_LED4=yes; object {DIODE_DIS_LED_5MM(Green,0.500000,0.000000,)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-270.000000,0> rotate<0,0,0> translate<95.504000,0.000000,47.625000>}#end		//Diskrete 5MM LED LED4  LED5MM
#ifndef(pack_LED5) #declare global_pack_LED5=yes; object {DIODE_DIS_LED_5MM(Red,0.500000,0.000000,)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<88.646000,0.000000,47.879000>}#end		//Diskrete 5MM LED LED5  LED5MM
#ifndef(pack_R1) #declare global_pack_R1=yes; object {RES_DIS_0207_075MM(texture{pigment{Red*0.7}finish{phong 0.2}},texture{pigment{Red*0.7}finish{phong 0.2}},texture{pigment{Orange}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<69.850000,0.000000,32.131000>}#end		//Discrete Resistor 0,3W 7,5MM Grid R1 22K 0207/7
#ifndef(pack_R2) #declare global_pack_R2=yes; object {RES_DIS_0207_075MM(texture{pigment{Red*0.7}finish{phong 0.2}},texture{pigment{Red*0.7}finish{phong 0.2}},texture{pigment{Orange}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<69.850000,0.000000,34.671000>}#end		//Discrete Resistor 0,3W 7,5MM Grid R2 22K 0207/7
#ifndef(pack_R3) #declare global_pack_R3=yes; object {RES_DIS_0309_12MM(texture{pigment{Violet*1.2}finish{phong 0.2}},texture{pigment{Green*0.7}finish{phong 0.2}},texture {T_Silver_5E finish{reflection 0.1}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<50.165000,0.000000,20.828000>}#end		//Discrete Resistor 0,35W 500mil R3 0.75 0309/12
#ifndef(pack_R4) #declare global_pack_R4=yes; object {RES_DIS_0207_075MM(texture{pigment{Red*0.7}finish{phong 0.2}},texture{pigment{Red*0.7}finish{phong 0.2}},texture{pigment{Orange}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<37.338000,0.000000,25.908000>}#end		//Discrete Resistor 0,3W 7,5MM Grid R4 22K 0207/7
#ifndef(pack_R5) #declare global_pack_R5=yes; object {RES_DIS_0207_075MM(texture{pigment{DarkBrown}finish{phong 0.2}},texture{pigment{Black}finish{phong 0.2}},texture{pigment{Red*0.7}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-270.000000,0> rotate<0,0,0> translate<81.280000,0.000000,26.670000>}#end		//Discrete Resistor 0,3W 7,5MM Grid R5 1K 0207/7
#ifndef(pack_R7) #declare global_pack_R7=yes; object {RES_DIS_0207_075MM(texture{pigment{DarkBrown}finish{phong 0.2}},texture{pigment{Black}finish{phong 0.2}},texture{pigment{Red*0.7}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<87.376000,0.000000,19.050000>}#end		//Discrete Resistor 0,3W 7,5MM Grid R7 1K 0207/7
#ifndef(pack_R8) #declare global_pack_R8=yes; object {RES_DIS_0207_075MM(texture{pigment{DarkBrown}finish{phong 0.2}},texture{pigment{Black}finish{phong 0.2}},texture{pigment{Red*0.7}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-90.000000,0> rotate<0,0,0> translate<81.407000,0.000000,46.101000>}#end		//Discrete Resistor 0,3W 7,5MM Grid R8 1K 0207/7
#ifndef(pack_R16) #declare global_pack_R16=yes; object {RES_DIS_0309_12MM(texture{pigment{Violet*1.2}finish{phong 0.2}},texture{pigment{Green*0.7}finish{phong 0.2}},texture {T_Silver_5E finish{reflection 0.1}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<50.292000,0.000000,46.863000>}#end		//Discrete Resistor 0,35W 500mil R16 0.75 0309/12
#ifndef(pack_R17) #declare global_pack_R17=yes; object {RES_DIS_0207_075MM(texture{pigment{DarkBrown}finish{phong 0.2}},texture{pigment{Black}finish{phong 0.2}},texture{pigment{Red*0.7}finish{phong 0.2}},texture {T_Gold_5C finish{reflection 0.1}},)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<37.211000,0.000000,42.926000>}#end		//Discrete Resistor 0,3W 7,5MM Grid R17 1K 0207/7
//Parts without Macro (e.g. SMD Solderjumper)				SMD-Solder Jumper SJ1 
//Parts without Macro (e.g. SMD Solderjumper)				SMD-Solder Jumper SJ2 
#ifndef(pack_SV1) #declare global_pack_SV1=yes; object {CON_DIS_WS10G()translate<0,0,0> rotate<0,180.000000,0>rotate<0,-180.000000,0> rotate<0,0,0> translate<39.370000,0.000000,54.737000>}#end		//Shrouded Header 10Pin SV1  ML10
}//End union
#end
#if(pcb_pads_smds=on)
//Pads&SMD/Parts
#ifndef(global_pack_C1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<34.798000,0,28.956000> texture{col_thl}}
#ifndef(global_pack_C1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<39.878000,0,28.956000> texture{col_thl}}
#ifndef(global_pack_C2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<34.798000,0,39.624000> texture{col_thl}}
#ifndef(global_pack_C2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<39.878000,0,39.624000> texture{col_thl}}
#ifndef(global_pack_C3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<39.878000,0,32.512000> texture{col_thl}}
#ifndef(global_pack_C3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<34.798000,0,32.512000> texture{col_thl}}
#ifndef(global_pack_C4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<71.882000,0,29.210000> texture{col_thl}}
#ifndef(global_pack_C4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<66.802000,0,29.210000> texture{col_thl}}
#ifndef(global_pack_C5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<71.882000,0,37.592000> texture{col_thl}}
#ifndef(global_pack_C5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<66.802000,0,37.592000> texture{col_thl}}
#ifndef(global_pack_C6) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<27.178000,0,12.446000> texture{col_thl}}
#ifndef(global_pack_C6) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<27.178000,0,17.526000> texture{col_thl}}
#ifndef(global_pack_C7) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<39.878000,0,36.068000> texture{col_thl}}
#ifndef(global_pack_C7) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<34.798000,0,36.068000> texture{col_thl}}
#ifndef(global_pack_C8) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<80.518000,0,12.192000> texture{col_thl}}
#ifndef(global_pack_C8) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<80.518000,0,17.272000> texture{col_thl}}
#ifndef(global_pack_C10) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.540000,1.016000,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<36.068000,0,14.986000> texture{col_thl}}
#ifndef(global_pack_C10) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.540000,1.016000,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<36.068000,0,20.066000> texture{col_thl}}
#ifndef(global_pack_C11) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.600200,0.812800,1,16,1+global_tmp,0) rotate<0,-90.000000,0>translate<74.422000,0,13.208000> texture{col_thl}}
#ifndef(global_pack_C11) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.600200,0.812800,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<74.422000,0,16.764000> texture{col_thl}}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<54.229000,0.000000,25.301000>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<55.499000,0.000000,25.301000>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<56.769000,0.000000,25.301000>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<58.039000,0.000000,25.301000>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<59.309000,0.000000,25.301000>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<60.579000,0.000000,25.301000>}
object{TOOLS_PCB_SMD(2.200000,0.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<62.329000,0.000000,27.051000>}
object{TOOLS_PCB_SMD(2.200000,0.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<62.329000,0.000000,28.321000>}
object{TOOLS_PCB_SMD(2.200000,0.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<62.329000,0.000000,29.591000>}
object{TOOLS_PCB_SMD(2.200000,0.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<62.329000,0.000000,30.861000>}
object{TOOLS_PCB_SMD(2.200000,0.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<62.329000,0.000000,32.131000>}
object{TOOLS_PCB_SMD(2.200000,0.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<62.329000,0.000000,33.401000>}
object{TOOLS_PCB_SMD(2.200000,0.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<62.329000,0.000000,34.671000>}
object{TOOLS_PCB_SMD(2.200000,0.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<62.329000,0.000000,35.941000>}
object{TOOLS_PCB_SMD(2.200000,0.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<62.329000,0.000000,37.211000>}
object{TOOLS_PCB_SMD(2.200000,0.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<62.329000,0.000000,38.481000>}
object{TOOLS_PCB_SMD(2.200000,0.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<62.329000,0.000000,39.751000>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<60.579000,0.000000,41.501000>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<59.309000,0.000000,41.501000>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<58.039000,0.000000,41.501000>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<56.769000,0.000000,41.501000>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<55.499000,0.000000,41.501000>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<54.229000,0.000000,41.501000>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<52.959000,0.000000,41.501000>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<51.689000,0.000000,41.501000>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<50.419000,0.000000,41.501000>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<49.149000,0.000000,41.501000>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<47.879000,0.000000,41.501000>}
object{TOOLS_PCB_SMD(2.200000,0.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<46.129000,0.000000,39.751000>}
object{TOOLS_PCB_SMD(2.200000,0.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<46.129000,0.000000,38.481000>}
object{TOOLS_PCB_SMD(2.200000,0.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<46.129000,0.000000,37.211000>}
object{TOOLS_PCB_SMD(2.200000,0.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<46.129000,0.000000,35.941000>}
object{TOOLS_PCB_SMD(2.200000,0.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<46.129000,0.000000,34.671000>}
object{TOOLS_PCB_SMD(2.200000,0.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<46.129000,0.000000,33.401000>}
object{TOOLS_PCB_SMD(2.200000,0.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<46.129000,0.000000,32.131000>}
object{TOOLS_PCB_SMD(2.200000,0.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<46.129000,0.000000,30.861000>}
object{TOOLS_PCB_SMD(2.200000,0.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<46.129000,0.000000,29.591000>}
object{TOOLS_PCB_SMD(2.200000,0.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<46.129000,0.000000,28.321000>}
object{TOOLS_PCB_SMD(2.200000,0.600000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<46.129000,0.000000,27.051000>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<47.879000,0.000000,25.301000>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<49.149000,0.000000,25.301000>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<50.419000,0.000000,25.301000>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<51.689000,0.000000,25.301000>}
object{TOOLS_PCB_SMD(0.600000,2.200000,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<52.959000,0.000000,25.301000>}
#ifndef(global_pack_IC2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<70.231000,0,20.320000> texture{col_thl}}
#ifndef(global_pack_IC2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<68.326000,0,19.050000> texture{col_thl}}
#ifndef(global_pack_IC2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<68.326000,0,21.590000> texture{col_thl}}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<24.384000,0,46.863000> texture{col_thl}}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<26.924000,0,45.593000> texture{col_thl}}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<24.384000,0,44.323000> texture{col_thl}}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<26.924000,0,43.053000> texture{col_thl}}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<24.384000,0,41.783000> texture{col_thl}}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<26.924000,0,40.513000> texture{col_thl}}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<24.384000,0,39.243000> texture{col_thl}}
#ifndef(global_pack_J1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<26.924000,0,37.973000> texture{col_thl}}
#ifndef(global_pack_J2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<24.384000,0,31.242000> texture{col_thl}}
#ifndef(global_pack_J2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<26.924000,0,29.972000> texture{col_thl}}
#ifndef(global_pack_J2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<24.384000,0,28.702000> texture{col_thl}}
#ifndef(global_pack_J2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<26.924000,0,27.432000> texture{col_thl}}
#ifndef(global_pack_J2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<24.384000,0,26.162000> texture{col_thl}}
#ifndef(global_pack_J2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<26.924000,0,24.892000> texture{col_thl}}
#ifndef(global_pack_J2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<24.384000,0,23.622000> texture{col_thl}}
#ifndef(global_pack_J2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.397000,0.889000,1,16,1+global_tmp,0) rotate<0,-270.000000,0>translate<26.924000,0,22.352000> texture{col_thl}}
#ifndef(global_pack_JP1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<68.326000,0,15.494000> texture{col_thl}}
#ifndef(global_pack_JP1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<68.326000,0,12.954000> texture{col_thl}}
#ifndef(global_pack_LED1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<85.725000,0,14.478000> texture{col_thl}}
#ifndef(global_pack_LED1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<88.265000,0,14.478000> texture{col_thl}}
#ifndef(global_pack_LED2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<95.504000,0,23.368000> texture{col_thl}}
#ifndef(global_pack_LED2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<95.504000,0,25.908000> texture{col_thl}}
#ifndef(global_pack_LED3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<88.900000,0,25.908000> texture{col_thl}}
#ifndef(global_pack_LED3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<88.900000,0,23.368000> texture{col_thl}}
#ifndef(global_pack_LED4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<95.504000,0,48.895000> texture{col_thl}}
#ifndef(global_pack_LED4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<95.504000,0,46.355000> texture{col_thl}}
#ifndef(global_pack_LED5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<88.646000,0,46.609000> texture{col_thl}}
#ifndef(global_pack_LED5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<88.646000,0,49.149000> texture{col_thl}}
#ifndef(global_pack_PAD1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.600200,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<56.642000,0,35.991800> texture{col_thl}}
#ifndef(global_pack_PAD2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.600200,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<49.301400,0,30.734000> texture{col_thl}}
#ifndef(global_pack_PAD3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.600200,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<49.784000,0,37.211000> texture{col_thl}}
#ifndef(global_pack_POWER) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.600000,1.600000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<62.230000,0,14.732000> texture{col_thl}}
#ifndef(global_pack_POWER) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.600000,1.600000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<57.150000,0,14.732000> texture{col_thl}}
#ifndef(global_pack_POWER) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.600000,1.600000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<52.070000,0,14.732000> texture{col_thl}}
#ifndef(global_pack_POWER) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.600000,1.600000,1,16,3+global_tmp,100) rotate<0,-270.000000,0>translate<46.990000,0,14.732000> texture{col_thl}}
#ifndef(global_pack_R1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<73.660000,0,32.131000> texture{col_thl}}
#ifndef(global_pack_R1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<66.040000,0,32.131000> texture{col_thl}}
#ifndef(global_pack_R2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<73.660000,0,34.671000> texture{col_thl}}
#ifndef(global_pack_R2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<66.040000,0,34.671000> texture{col_thl}}
#ifndef(global_pack_R3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<56.515000,0,20.828000> texture{col_thl}}
#ifndef(global_pack_R3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<43.815000,0,20.828000> texture{col_thl}}
#ifndef(global_pack_R4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<33.528000,0,25.908000> texture{col_thl}}
#ifndef(global_pack_R4) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<41.148000,0,25.908000> texture{col_thl}}
#ifndef(global_pack_R5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<81.280000,0,30.480000> texture{col_thl}}
#ifndef(global_pack_R5) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-270.000000,0>translate<81.280000,0,22.860000> texture{col_thl}}
#ifndef(global_pack_R7) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<83.566000,0,19.050000> texture{col_thl}}
#ifndef(global_pack_R7) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<91.186000,0,19.050000> texture{col_thl}}
#ifndef(global_pack_R8) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<81.407000,0,42.291000> texture{col_thl}}
#ifndef(global_pack_R8) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-90.000000,0>translate<81.407000,0,49.911000> texture{col_thl}}
#ifndef(global_pack_R15) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<72.644000,0,49.022000> texture{col_thl}}
#ifndef(global_pack_R15) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<67.564000,0,49.022000> texture{col_thl}}
#ifndef(global_pack_R15) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<70.104000,0,46.482000> texture{col_thl}}
#ifndef(global_pack_R16) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<56.642000,0,46.863000> texture{col_thl}}
#ifndef(global_pack_R16) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<43.942000,0,46.863000> texture{col_thl}}
#ifndef(global_pack_R17) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<33.401000,0,42.926000> texture{col_thl}}
#ifndef(global_pack_R17) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<41.021000,0,42.926000> texture{col_thl}}
object{TOOLS_PCB_SMD(1.168400,1.600200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<59.436000,0.000000,49.530000>}
object{TOOLS_PCB_SMD(1.168400,1.600200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<59.436000,0.000000,48.006000>}
object{TOOLS_PCB_SMD(1.168400,1.600200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<59.436000,0.000000,46.482000>}
object{TOOLS_PCB_SMD(1.168400,1.600200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<63.246000,0.000000,49.530000>}
object{TOOLS_PCB_SMD(1.168400,1.600200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<63.246000,0.000000,48.006000>}
object{TOOLS_PCB_SMD(1.168400,1.600200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<63.246000,0.000000,46.482000>}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<44.450000,0,56.007000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<44.450000,0,53.467000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<41.910000,0,56.007000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<41.910000,0,53.467000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<39.370000,0,56.007000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<39.370000,0,53.467000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<36.830000,0,56.007000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<36.830000,0,53.467000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<34.290000,0,56.007000> texture{col_thl}}
#ifndef(global_pack_SV1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.422400,0.914400,1,16,2+global_tmp,0) rotate<0,-180.000000,0>translate<34.290000,0,53.467000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.550000,1.700000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<90.424000,0,30.382000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.550000,1.700000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<90.424000,0,34.342000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.550000,1.700000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<90.424000,0,38.302000> texture{col_thl}}
#ifndef(global_pack_X1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.550000,1.700000,1,16,3+global_tmp,100) rotate<0,-180.000000,0>translate<90.424000,0,42.262000> texture{col_thl}}
#ifndef(global_pack_X2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.508000,1.000000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<19.939000,0,44.958000> texture{col_thl}}
#ifndef(global_pack_X2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.508000,1.000000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<19.939000,0,42.418000> texture{col_thl}}
#ifndef(global_pack_X2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.508000,1.000000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<19.939000,0,39.878000> texture{col_thl}}
#ifndef(global_pack_X3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.508000,1.000000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<19.939000,0,29.337000> texture{col_thl}}
#ifndef(global_pack_X3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.508000,1.000000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<19.939000,0,26.797000> texture{col_thl}}
#ifndef(global_pack_X3) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.508000,1.000000,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<19.939000,0,24.257000> texture{col_thl}}
//Pads/Vias
object{TOOLS_PCB_VIA(1.106400,0.700000,1,16,0,0) translate<46.228000,0,25.146000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.006400,0.600000,1,16,0,0) translate<84.074000,0,27.914600> texture{col_thl}}
object{TOOLS_PCB_VIA(1.006400,0.600000,1,16,1,0) translate<84.201000,0,39.801800> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<55.549800,0,29.870400> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<44.297600,0,39.852600> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<49.834800,0,43.484800> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<54.635400,0,20.396200> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<47.777400,0,20.396200> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<36.322000,0,50.038000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<61.722000,0,47.472600> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<61.722000,0,45.364400> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<59.588400,0,39.674800> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<50.266600,0,23.469600> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<60.502800,0,30.607000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<60.502800,0,38.100000> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<49.022000,0,39.471600> texture{col_thl}}
object{TOOLS_PCB_VIA(1.016000,0.609600,1,16,1,0) translate<50.266600,0,27.127200> texture{col_thl}}
#end
#if(pcb_wires=on)
union{
//Signals
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.939000,-1.535000,29.337000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.005800,-1.535000,30.073600>}
box{<0,0,-0.203200><1.296396,0.035000,0.203200> rotate<0,-34.621870,0> translate<19.939000,-1.535000,29.337000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.005800,-1.535000,30.073600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.005800,-1.535000,37.998400>}
box{<0,0,-0.203200><7.924800,0.035000,0.203200> rotate<0,90.000000,0> translate<21.005800,-1.535000,37.998400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<19.939000,0.000000,24.257000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<21.437600,0.000000,23.952200>}
box{<0,0,-0.406400><1.529283,0.035000,0.406400> rotate<0,11.495804,0> translate<19.939000,0.000000,24.257000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.939000,0.000000,26.797000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.437600,0.000000,26.492200>}
box{<0,0,-0.203200><1.529283,0.035000,0.203200> rotate<0,11.495804,0> translate<19.939000,0.000000,26.797000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.939000,0.000000,29.337000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.437600,0.000000,29.032200>}
box{<0,0,-0.203200><1.529283,0.035000,0.203200> rotate<0,11.495804,0> translate<19.939000,0.000000,29.337000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<19.939000,0.000000,39.878000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<21.437600,0.000000,39.573200>}
box{<0,0,-0.406400><1.529283,0.035000,0.406400> rotate<0,11.495804,0> translate<19.939000,0.000000,39.878000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.939000,0.000000,42.418000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.437600,0.000000,42.113200>}
box{<0,0,-0.203200><1.529283,0.035000,0.203200> rotate<0,11.495804,0> translate<19.939000,0.000000,42.418000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<19.939000,0.000000,44.958000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.437600,0.000000,44.653200>}
box{<0,0,-0.203200><1.529283,0.035000,0.203200> rotate<0,11.495804,0> translate<19.939000,0.000000,44.958000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.437600,0.000000,26.492200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.885400,0.000000,25.044400>}
box{<0,0,-0.203200><2.047498,0.035000,0.203200> rotate<0,44.997030,0> translate<21.437600,0.000000,26.492200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.437600,0.000000,42.113200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.885400,0.000000,40.665400>}
box{<0,0,-0.203200><2.047498,0.035000,0.203200> rotate<0,44.997030,0> translate<21.437600,0.000000,42.113200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<21.437600,0.000000,23.952200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<23.749000,0.000000,23.952200>}
box{<0,0,-0.406400><2.311400,0.035000,0.406400> rotate<0,0.000000,0> translate<21.437600,0.000000,23.952200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<21.437600,0.000000,39.573200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<23.749000,0.000000,39.573200>}
box{<0,0,-0.406400><2.311400,0.035000,0.406400> rotate<0,0.000000,0> translate<21.437600,0.000000,39.573200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.437600,0.000000,29.032200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.876000,0.000000,26.593800>}
box{<0,0,-0.203200><3.448418,0.035000,0.203200> rotate<0,44.997030,0> translate<21.437600,0.000000,29.032200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.437600,0.000000,44.653200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.876000,0.000000,42.214800>}
box{<0,0,-0.203200><3.448418,0.035000,0.203200> rotate<0,44.997030,0> translate<21.437600,0.000000,44.653200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<21.005800,-1.535000,37.998400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.104600,-1.535000,41.097200>}
box{<0,0,-0.203200><4.382365,0.035000,0.203200> rotate<0,-44.997030,0> translate<21.005800,-1.535000,37.998400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<23.749000,0.000000,23.952200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<24.384000,0.000000,23.622000>}
box{<0,0,-0.406400><0.715721,0.035000,0.406400> rotate<0,27.472618,0> translate<23.749000,0.000000,23.952200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.876000,0.000000,26.593800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.384000,0.000000,26.162000>}
box{<0,0,-0.203200><0.666720,0.035000,0.203200> rotate<0,40.361873,0> translate<23.876000,0.000000,26.593800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<23.749000,0.000000,39.573200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<24.384000,0.000000,39.243000>}
box{<0,0,-0.406400><0.715721,0.035000,0.406400> rotate<0,27.472618,0> translate<23.749000,0.000000,39.573200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<23.876000,0.000000,42.214800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.384000,0.000000,41.783000>}
box{<0,0,-0.203200><0.666720,0.035000,0.203200> rotate<0,40.361873,0> translate<23.876000,0.000000,42.214800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.104600,-1.535000,41.097200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.384000,-1.535000,41.783000>}
box{<0,0,-0.203200><0.740531,0.035000,0.203200> rotate<0,-67.829177,0> translate<24.104600,-1.535000,41.097200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<24.384000,0.000000,23.622000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<25.069800,0.000000,23.342600>}
box{<0,0,-0.406400><0.740531,0.035000,0.406400> rotate<0,22.164883,0> translate<24.384000,0.000000,23.622000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.384000,0.000000,26.162000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<25.069800,0.000000,26.441400>}
box{<0,0,-0.203200><0.740531,0.035000,0.203200> rotate<0,-22.164883,0> translate<24.384000,0.000000,26.162000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<24.384000,0.000000,39.243000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<25.069800,0.000000,38.963600>}
box{<0,0,-0.406400><0.740531,0.035000,0.406400> rotate<0,22.164883,0> translate<24.384000,0.000000,39.243000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<24.384000,0.000000,41.783000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<25.069800,0.000000,42.062400>}
box{<0,0,-0.203200><0.740531,0.035000,0.203200> rotate<0,-22.164883,0> translate<24.384000,0.000000,41.783000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<25.069800,0.000000,23.342600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<26.238200,0.000000,22.174200>}
box{<0,0,-0.406400><1.652367,0.035000,0.406400> rotate<0,44.997030,0> translate<25.069800,0.000000,23.342600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.885400,0.000000,25.044400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.238200,0.000000,25.044400>}
box{<0,0,-0.203200><3.352800,0.035000,0.203200> rotate<0,0.000000,0> translate<22.885400,0.000000,25.044400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<25.069800,0.000000,26.441400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.238200,0.000000,27.609800>}
box{<0,0,-0.203200><1.652367,0.035000,0.203200> rotate<0,-44.997030,0> translate<25.069800,0.000000,26.441400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<25.069800,0.000000,38.963600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<26.238200,0.000000,37.795200>}
box{<0,0,-0.406400><1.652367,0.035000,0.406400> rotate<0,44.997030,0> translate<25.069800,0.000000,38.963600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<22.885400,0.000000,40.665400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.238200,0.000000,40.665400>}
box{<0,0,-0.203200><3.352800,0.035000,0.203200> rotate<0,0.000000,0> translate<22.885400,0.000000,40.665400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<25.069800,0.000000,42.062400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.238200,0.000000,43.230800>}
box{<0,0,-0.203200><1.652367,0.035000,0.203200> rotate<0,-44.997030,0> translate<25.069800,0.000000,42.062400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<26.238200,0.000000,22.174200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<26.924000,0.000000,22.352000>}
box{<0,0,-0.406400><0.708473,0.035000,0.406400> rotate<0,-14.533496,0> translate<26.238200,0.000000,22.174200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.238200,0.000000,25.044400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.924000,0.000000,24.892000>}
box{<0,0,-0.203200><0.702529,0.035000,0.203200> rotate<0,12.527981,0> translate<26.238200,0.000000,25.044400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.238200,0.000000,27.609800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.924000,0.000000,27.432000>}
box{<0,0,-0.203200><0.708473,0.035000,0.203200> rotate<0,14.533496,0> translate<26.238200,0.000000,27.609800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<26.238200,0.000000,37.795200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<26.924000,0.000000,37.973000>}
box{<0,0,-0.406400><0.708473,0.035000,0.406400> rotate<0,-14.533496,0> translate<26.238200,0.000000,37.795200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.238200,0.000000,40.665400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.924000,0.000000,40.513000>}
box{<0,0,-0.203200><0.702529,0.035000,0.203200> rotate<0,12.527981,0> translate<26.238200,0.000000,40.665400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.238200,0.000000,43.230800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.924000,0.000000,43.053000>}
box{<0,0,-0.203200><0.708473,0.035000,0.203200> rotate<0,14.533496,0> translate<26.238200,0.000000,43.230800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<26.924000,0.000000,22.352000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<27.178000,0.000000,21.666200>}
box{<0,0,-0.406400><0.731326,0.035000,0.406400> rotate<0,69.672265,0> translate<26.924000,0.000000,22.352000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<27.178000,0.000000,17.526000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<27.178000,0.000000,21.666200>}
box{<0,0,-0.406400><4.140200,0.035000,0.406400> rotate<0,90.000000,0> translate<27.178000,0.000000,21.666200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.924000,-1.535000,24.892000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<27.203400,-1.535000,25.577800>}
box{<0,0,-0.203200><0.740531,0.035000,0.203200> rotate<0,-67.829177,0> translate<26.924000,-1.535000,24.892000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.924000,-1.535000,40.513000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<27.203400,-1.535000,41.198800>}
box{<0,0,-0.203200><0.740531,0.035000,0.203200> rotate<0,-67.829177,0> translate<26.924000,-1.535000,40.513000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<26.924000,0.000000,22.352000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<27.609800,0.000000,22.631400>}
box{<0,0,-0.406400><0.740531,0.035000,0.406400> rotate<0,-22.164883,0> translate<26.924000,0.000000,22.352000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<26.924000,0.000000,37.973000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<27.609800,0.000000,37.693600>}
box{<0,0,-0.406400><0.740531,0.035000,0.406400> rotate<0,22.164883,0> translate<26.924000,0.000000,37.973000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<26.924000,0.000000,43.053000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<27.609800,0.000000,42.773600>}
box{<0,0,-0.203200><0.740531,0.035000,0.203200> rotate<0,22.164883,0> translate<26.924000,0.000000,43.053000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<27.178000,0.000000,12.446000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<27.813000,0.000000,12.725400>}
box{<0,0,-0.406400><0.693750,0.035000,0.406400> rotate<0,-23.747927,0> translate<27.178000,0.000000,12.446000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<27.203400,-1.535000,25.577800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.041600,-1.535000,26.416000>}
box{<0,0,-0.203200><1.185394,0.035000,0.203200> rotate<0,-44.997030,0> translate<27.203400,-1.535000,25.577800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.041600,-1.535000,26.416000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.041600,-1.535000,35.255200>}
box{<0,0,-0.203200><8.839200,0.035000,0.203200> rotate<0,90.000000,0> translate<28.041600,-1.535000,35.255200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<27.609800,0.000000,37.693600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<28.956000,0.000000,36.347400>}
box{<0,0,-0.406400><1.903814,0.035000,0.406400> rotate<0,44.997030,0> translate<27.609800,0.000000,37.693600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<27.609800,0.000000,42.773600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.480000,0.000000,39.903400>}
box{<0,0,-0.203200><4.059076,0.035000,0.203200> rotate<0,44.997030,0> translate<27.609800,0.000000,42.773600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<27.813000,0.000000,12.725400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<33.096200,0.000000,12.725400>}
box{<0,0,-0.406400><5.283200,0.035000,0.406400> rotate<0,0.000000,0> translate<27.813000,0.000000,12.725400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<28.956000,0.000000,36.347400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<33.248600,0.000000,36.347400>}
box{<0,0,-0.406400><4.292600,0.035000,0.406400> rotate<0,0.000000,0> translate<28.956000,0.000000,36.347400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<33.248600,0.000000,26.543000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<33.248600,0.000000,36.347400>}
box{<0,0,-0.406400><9.804400,0.035000,0.406400> rotate<0,90.000000,0> translate<33.248600,0.000000,36.347400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<33.248600,0.000000,26.543000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<33.528000,0.000000,25.908000>}
box{<0,0,-0.406400><0.693750,0.035000,0.406400> rotate<0,66.246133,0> translate<33.248600,0.000000,26.543000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.528000,-1.535000,31.978600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.528000,-1.535000,39.878000>}
box{<0,0,-0.203200><7.899400,0.035000,0.203200> rotate<0,90.000000,0> translate<33.528000,-1.535000,39.878000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<27.609800,0.000000,22.631400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<33.655000,0.000000,22.631400>}
box{<0,0,-0.406400><6.045200,0.035000,0.406400> rotate<0,0.000000,0> translate<27.609800,0.000000,22.631400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.401000,0.000000,42.926000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.680400,0.000000,43.561000>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,-66.246133,0> translate<33.401000,0.000000,42.926000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.680400,0.000000,43.561000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.680400,0.000000,46.101000>}
box{<0,0,-0.203200><2.540000,0.035000,0.203200> rotate<0,90.000000,0> translate<33.680400,0.000000,46.101000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<33.528000,0.000000,25.908000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<33.807400,0.000000,25.273000>}
box{<0,0,-0.406400><0.693750,0.035000,0.406400> rotate<0,66.246133,0> translate<33.528000,0.000000,25.908000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<33.807400,0.000000,23.037800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<33.807400,0.000000,25.273000>}
box{<0,0,-0.406400><2.235200,0.035000,0.406400> rotate<0,90.000000,0> translate<33.807400,0.000000,25.273000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<33.655000,0.000000,22.631400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<33.934400,0.000000,22.910800>}
box{<0,0,-0.406400><0.395131,0.035000,0.406400> rotate<0,-44.997030,0> translate<33.655000,0.000000,22.631400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<33.807400,0.000000,23.037800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<33.934400,0.000000,22.910800>}
box{<0,0,-0.406400><0.179605,0.035000,0.406400> rotate<0,44.997030,0> translate<33.807400,0.000000,23.037800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<33.248600,0.000000,36.347400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<34.163000,0.000000,36.347400>}
box{<0,0,-0.406400><0.914400,0.035000,0.406400> rotate<0,0.000000,0> translate<33.248600,0.000000,36.347400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<30.480000,0.000000,39.903400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.163000,0.000000,39.903400>}
box{<0,0,-0.203200><3.683000,0.035000,0.203200> rotate<0,0.000000,0> translate<30.480000,0.000000,39.903400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<34.163000,0.000000,36.347400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<34.798000,0.000000,36.068000>}
box{<0,0,-0.406400><0.693750,0.035000,0.406400> rotate<0,23.747927,0> translate<34.163000,0.000000,36.347400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.163000,0.000000,39.903400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.798000,0.000000,39.624000>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,23.747927,0> translate<34.163000,0.000000,39.903400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<33.096200,0.000000,12.725400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<34.823400,0.000000,14.452600>}
box{<0,0,-0.406400><2.442630,0.035000,0.406400> rotate<0,-44.997030,0> translate<33.096200,0.000000,12.725400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<27.203400,-1.535000,41.198800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.407600,-1.535000,49.403000>}
box{<0,0,-0.203200><11.602491,0.035000,0.203200> rotate<0,-44.997030,0> translate<27.203400,-1.535000,41.198800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.407600,-1.535000,49.403000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.407600,-1.535000,53.644800>}
box{<0,0,-0.203200><4.241800,0.035000,0.203200> rotate<0,90.000000,0> translate<35.407600,-1.535000,53.644800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.798000,0.000000,28.956000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.433000,0.000000,29.235400>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,-23.747927,0> translate<34.798000,0.000000,28.956000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<34.798000,-1.535000,32.512000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<35.433000,-1.535000,32.232600>}
box{<0,0,-0.406400><0.693750,0.035000,0.406400> rotate<0,23.747927,0> translate<34.798000,-1.535000,32.512000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<34.798000,0.000000,36.068000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<35.433000,0.000000,35.788600>}
box{<0,0,-0.406400><0.693750,0.035000,0.406400> rotate<0,23.747927,0> translate<34.798000,0.000000,36.068000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<34.798000,-1.535000,39.624000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.433000,-1.535000,39.903400>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,-23.747927,0> translate<34.798000,-1.535000,39.624000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<33.934400,0.000000,22.910800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<35.534600,0.000000,21.310600>}
box{<0,0,-0.406400><2.263025,0.035000,0.406400> rotate<0,44.997030,0> translate<33.934400,0.000000,22.910800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<34.823400,0.000000,14.452600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<36.068000,0.000000,14.986000>}
box{<0,0,-0.406400><1.354084,0.035000,0.406400> rotate<0,-23.197059,0> translate<34.823400,0.000000,14.452600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<35.534600,0.000000,21.310600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<36.068000,0.000000,20.066000>}
box{<0,0,-0.406400><1.354084,0.035000,0.406400> rotate<0,66.797001,0> translate<35.534600,0.000000,21.310600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.433000,0.000000,29.235400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.220400,0.000000,30.022800>}
box{<0,0,-0.203200><1.113552,0.035000,0.203200> rotate<0,-44.997030,0> translate<35.433000,0.000000,29.235400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<28.041600,-1.535000,35.255200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.322000,-1.535000,43.535600>}
box{<0,0,-0.203200><11.710254,0.035000,0.203200> rotate<0,-44.997030,0> translate<28.041600,-1.535000,35.255200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.322000,-1.535000,43.535600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.322000,-1.535000,50.038000>}
box{<0,0,-0.203200><6.502400,0.035000,0.203200> rotate<0,90.000000,0> translate<36.322000,-1.535000,50.038000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.407600,-1.535000,53.644800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.525200,-1.535000,54.762400>}
box{<0,0,-0.203200><1.580525,0.035000,0.203200> rotate<0,-44.997030,0> translate<35.407600,-1.535000,53.644800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.525200,-1.535000,54.762400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.525200,-1.535000,55.321200>}
box{<0,0,-0.203200><0.558800,0.035000,0.203200> rotate<0,90.000000,0> translate<36.525200,-1.535000,55.321200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.525200,-1.535000,55.321200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.830000,-1.535000,56.007000>}
box{<0,0,-0.203200><0.750483,0.035000,0.203200> rotate<0,-66.033153,0> translate<36.525200,-1.535000,55.321200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<36.068000,0.000000,20.066000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<37.312600,0.000000,20.599400>}
box{<0,0,-0.406400><1.354084,0.035000,0.406400> rotate<0,-23.197059,0> translate<36.068000,0.000000,20.066000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.528000,-1.535000,39.878000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.947600,-1.535000,44.297600>}
box{<0,0,-0.203200><6.250258,0.035000,0.203200> rotate<0,-44.997030,0> translate<33.528000,-1.535000,39.878000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.947600,-1.535000,44.297600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.947600,-1.535000,53.644800>}
box{<0,0,-0.203200><9.347200,0.035000,0.203200> rotate<0,90.000000,0> translate<37.947600,-1.535000,53.644800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<35.433000,-1.535000,32.232600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<38.049200,-1.535000,32.232600>}
box{<0,0,-0.406400><2.616200,0.035000,0.406400> rotate<0,0.000000,0> translate<35.433000,-1.535000,32.232600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<35.433000,0.000000,35.788600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<38.049200,0.000000,35.788600>}
box{<0,0,-0.406400><2.616200,0.035000,0.406400> rotate<0,0.000000,0> translate<35.433000,0.000000,35.788600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<35.433000,-1.535000,39.903400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.633400,-1.535000,39.903400>}
box{<0,0,-0.203200><3.200400,0.035000,0.203200> rotate<0,0.000000,0> translate<35.433000,-1.535000,39.903400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.322000,0.000000,50.038000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.065200,0.000000,52.781200>}
box{<0,0,-0.203200><3.879471,0.035000,0.203200> rotate<0,-44.997030,0> translate<36.322000,0.000000,50.038000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<37.947600,-1.535000,53.644800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.065200,-1.535000,54.762400>}
box{<0,0,-0.203200><1.580525,0.035000,0.203200> rotate<0,-44.997030,0> translate<37.947600,-1.535000,53.644800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.065200,-1.535000,54.762400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.065200,-1.535000,55.321200>}
box{<0,0,-0.203200><0.558800,0.035000,0.203200> rotate<0,90.000000,0> translate<39.065200,-1.535000,55.321200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<38.049200,0.000000,35.788600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<39.243000,0.000000,34.594800>}
box{<0,0,-0.406400><1.688288,0.035000,0.406400> rotate<0,44.997030,0> translate<38.049200,0.000000,35.788600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.528000,-1.535000,31.978600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.319200,-1.535000,26.187400>}
box{<0,0,-0.203200><8.189994,0.035000,0.203200> rotate<0,44.997030,0> translate<33.528000,-1.535000,31.978600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.065200,0.000000,52.781200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.370000,0.000000,53.467000>}
box{<0,0,-0.203200><0.750483,0.035000,0.203200> rotate<0,-66.033153,0> translate<39.065200,0.000000,52.781200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.065200,-1.535000,55.321200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.370000,-1.535000,56.007000>}
box{<0,0,-0.203200><0.750483,0.035000,0.203200> rotate<0,-66.033153,0> translate<39.065200,-1.535000,55.321200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<38.633400,-1.535000,39.903400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.497000,-1.535000,40.767000>}
box{<0,0,-0.203200><1.221315,0.035000,0.203200> rotate<0,-44.997030,0> translate<38.633400,-1.535000,39.903400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<38.049200,-1.535000,32.232600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<39.852600,-1.535000,30.429200>}
box{<0,0,-0.406400><2.550393,0.035000,0.406400> rotate<0,44.997030,0> translate<38.049200,-1.535000,32.232600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.878000,0.000000,39.624000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.157400,0.000000,40.259000>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,-66.246133,0> translate<39.878000,0.000000,39.624000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<36.220400,0.000000,30.022800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.335200,0.000000,30.022800>}
box{<0,0,-0.203200><4.114800,0.035000,0.203200> rotate<0,0.000000,0> translate<36.220400,0.000000,30.022800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.878000,0.000000,28.956000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.436800,0.000000,28.600400>}
box{<0,0,-0.203200><0.662351,0.035000,0.203200> rotate<0,32.469049,0> translate<39.878000,0.000000,28.956000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.335200,0.000000,30.022800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.487600,0.000000,29.870400>}
box{<0,0,-0.203200><0.215526,0.035000,0.203200> rotate<0,44.997030,0> translate<40.335200,0.000000,30.022800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.319200,-1.535000,26.187400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.513000,-1.535000,26.187400>}
box{<0,0,-0.203200><1.193800,0.035000,0.203200> rotate<0,0.000000,0> translate<39.319200,-1.535000,26.187400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<39.852600,-1.535000,30.429200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<40.513000,-1.535000,30.429200>}
box{<0,0,-0.406400><0.660400,0.035000,0.406400> rotate<0,0.000000,0> translate<39.852600,-1.535000,30.429200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<39.878000,0.000000,32.512000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<40.513000,0.000000,32.232600>}
box{<0,0,-0.406400><0.693750,0.035000,0.406400> rotate<0,23.747927,0> translate<39.878000,0.000000,32.512000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.878000,0.000000,36.068000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.513000,0.000000,35.941000>}
box{<0,0,-0.203200><0.647575,0.035000,0.203200> rotate<0,11.309186,0> translate<39.878000,0.000000,36.068000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.878000,0.000000,39.624000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.513000,0.000000,39.344600>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,23.747927,0> translate<39.878000,0.000000,39.624000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.157400,0.000000,40.259000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.741600,0.000000,40.843200>}
box{<0,0,-0.203200><0.826184,0.035000,0.203200> rotate<0,-44.997030,0> translate<40.157400,0.000000,40.259000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.741600,0.000000,40.843200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.741600,0.000000,42.291000>}
box{<0,0,-0.203200><1.447800,0.035000,0.203200> rotate<0,90.000000,0> translate<40.741600,0.000000,42.291000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<33.680400,0.000000,46.101000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.792400,0.000000,53.213000>}
box{<0,0,-0.203200><10.057887,0.035000,0.203200> rotate<0,-44.997030,0> translate<33.680400,0.000000,46.101000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.792400,0.000000,53.213000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.792400,0.000000,54.508400>}
box{<0,0,-0.203200><1.295400,0.035000,0.203200> rotate<0,90.000000,0> translate<40.792400,0.000000,54.508400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.741600,0.000000,42.291000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.021000,0.000000,42.926000>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,-66.246133,0> translate<40.741600,0.000000,42.291000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.513000,-1.535000,26.187400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.148000,-1.535000,25.908000>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,23.747927,0> translate<40.513000,-1.535000,26.187400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.792400,0.000000,54.508400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.605200,0.000000,55.321200>}
box{<0,0,-0.203200><1.149473,0.035000,0.203200> rotate<0,-44.997030,0> translate<40.792400,0.000000,54.508400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<40.513000,0.000000,32.232600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<41.732200,0.000000,31.013400>}
box{<0,0,-0.406400><1.724209,0.035000,0.406400> rotate<0,44.997030,0> translate<40.513000,0.000000,32.232600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.148000,0.000000,25.908000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.783000,0.000000,25.628600>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,23.747927,0> translate<41.148000,0.000000,25.908000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.605200,0.000000,55.321200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.910000,0.000000,56.007000>}
box{<0,0,-0.203200><0.750483,0.035000,0.203200> rotate<0,-66.033153,0> translate<41.605200,0.000000,55.321200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.910000,0.000000,53.467000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.214800,0.000000,52.781200>}
box{<0,0,-0.203200><0.750483,0.035000,0.203200> rotate<0,66.033153,0> translate<41.910000,0.000000,53.467000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.214800,0.000000,46.786800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.214800,0.000000,52.781200>}
box{<0,0,-0.203200><5.994400,0.035000,0.203200> rotate<0,90.000000,0> translate<42.214800,0.000000,52.781200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.513000,0.000000,39.344600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.367200,0.000000,37.490400>}
box{<0,0,-0.203200><2.622235,0.035000,0.203200> rotate<0,44.997030,0> translate<40.513000,0.000000,39.344600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<37.312600,0.000000,20.599400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<43.180000,0.000000,20.599400>}
box{<0,0,-0.406400><5.867400,0.035000,0.406400> rotate<0,0.000000,0> translate<37.312600,0.000000,20.599400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<43.180000,0.000000,20.599400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<43.815000,0.000000,20.828000>}
box{<0,0,-0.406400><0.674895,0.035000,0.406400> rotate<0,-19.797570,0> translate<43.180000,0.000000,20.599400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<41.783000,0.000000,25.628600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<43.840400,0.000000,23.571200>}
box{<0,0,-0.203200><2.909603,0.035000,0.203200> rotate<0,44.997030,0> translate<41.783000,0.000000,25.628600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<43.942000,0.000000,46.863000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<44.145200,0.000000,47.498000>}
box{<0,0,-0.406400><0.666720,0.035000,0.406400> rotate<0,-72.250560,0> translate<43.942000,0.000000,46.863000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<44.145200,0.000000,47.498000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<44.145200,0.000000,52.781200>}
box{<0,0,-0.406400><5.283200,0.035000,0.406400> rotate<0,90.000000,0> translate<44.145200,0.000000,52.781200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<43.815000,0.000000,20.828000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<44.297600,0.000000,20.396200>}
box{<0,0,-0.406400><0.647575,0.035000,0.406400> rotate<0,41.817410,0> translate<43.815000,0.000000,20.828000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.214800,0.000000,46.786800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<44.297600,0.000000,44.704000>}
box{<0,0,-0.203200><2.945524,0.035000,0.203200> rotate<0,44.997030,0> translate<42.214800,0.000000,46.786800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<44.297600,0.000000,39.852600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<44.297600,0.000000,44.704000>}
box{<0,0,-0.203200><4.851400,0.035000,0.203200> rotate<0,90.000000,0> translate<44.297600,0.000000,44.704000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<44.145200,0.000000,52.781200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<44.450000,0.000000,53.467000>}
box{<0,0,-0.406400><0.750483,0.035000,0.406400> rotate<0,-66.033153,0> translate<44.145200,0.000000,52.781200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<43.942000,-1.535000,46.863000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<44.577000,-1.535000,46.583600>}
box{<0,0,-0.406400><0.693750,0.035000,0.406400> rotate<0,23.747927,0> translate<43.942000,-1.535000,46.863000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<40.513000,-1.535000,30.429200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<44.907200,-1.535000,26.035000>}
box{<0,0,-0.406400><6.214337,0.035000,0.406400> rotate<0,44.997030,0> translate<40.513000,-1.535000,30.429200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<44.907200,-1.535000,21.844000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<44.907200,-1.535000,26.035000>}
box{<0,0,-0.406400><4.191000,0.035000,0.406400> rotate<0,90.000000,0> translate<44.907200,-1.535000,26.035000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.436800,0.000000,28.600400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<45.034200,0.000000,28.600400>}
box{<0,0,-0.203200><4.597400,0.035000,0.203200> rotate<0,0.000000,0> translate<40.436800,0.000000,28.600400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.487600,0.000000,29.870400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<45.034200,0.000000,29.870400>}
box{<0,0,-0.203200><4.546600,0.035000,0.203200> rotate<0,0.000000,0> translate<40.487600,0.000000,29.870400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<41.732200,0.000000,31.013400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<45.034200,0.000000,31.013400>}
box{<0,0,-0.406400><3.302000,0.035000,0.406400> rotate<0,0.000000,0> translate<41.732200,0.000000,31.013400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<39.243000,0.000000,34.594800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<45.034200,0.000000,34.594800>}
box{<0,0,-0.406400><5.791200,0.035000,0.406400> rotate<0,0.000000,0> translate<39.243000,0.000000,34.594800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<42.367200,0.000000,37.490400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<45.034200,0.000000,37.490400>}
box{<0,0,-0.203200><2.667000,0.035000,0.203200> rotate<0,0.000000,0> translate<42.367200,0.000000,37.490400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<36.068000,0.000000,14.986000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<45.694600,0.000000,14.986000>}
box{<0,0,-0.406400><9.626600,0.035000,0.406400> rotate<0,0.000000,0> translate<36.068000,0.000000,14.986000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.101000,0.000000,34.391600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.101000,0.000000,33.807400>}
box{<0,0,-0.406400><0.584200,0.035000,0.406400> rotate<0,-90.000000,0> translate<46.101000,0.000000,33.807400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.126400,0.000000,33.121600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.126400,0.000000,32.410400>}
box{<0,0,-0.406400><0.711200,0.035000,0.406400> rotate<0,-90.000000,0> translate<46.126400,0.000000,32.410400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<45.034200,0.000000,28.600400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<46.129000,0.000000,28.321000>}
box{<0,0,-0.203200><1.129890,0.035000,0.203200> rotate<0,14.315712,0> translate<45.034200,0.000000,28.600400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<45.034200,0.000000,29.870400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<46.129000,0.000000,29.591000>}
box{<0,0,-0.203200><1.129890,0.035000,0.203200> rotate<0,14.315712,0> translate<45.034200,0.000000,29.870400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<45.034200,0.000000,31.013400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.129000,0.000000,30.861000>}
box{<0,0,-0.406400><1.105356,0.035000,0.406400> rotate<0,7.924324,0> translate<45.034200,0.000000,31.013400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.126400,0.000000,32.410400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.129000,0.000000,32.131000>}
box{<0,0,-0.406400><0.279412,0.035000,0.406400> rotate<0,89.460936,0> translate<46.126400,0.000000,32.410400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.101000,0.000000,33.807400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.129000,0.000000,33.401000>}
box{<0,0,-0.406400><0.407363,0.035000,0.406400> rotate<0,86.053005,0> translate<46.101000,0.000000,33.807400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.126400,0.000000,33.121600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.129000,0.000000,33.401000>}
box{<0,0,-0.406400><0.279412,0.035000,0.406400> rotate<0,-89.460936,0> translate<46.126400,0.000000,33.121600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<45.034200,0.000000,34.594800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.129000,0.000000,34.671000>}
box{<0,0,-0.406400><1.097449,0.035000,0.406400> rotate<0,-3.981203,0> translate<45.034200,0.000000,34.594800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.101000,0.000000,34.391600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.129000,0.000000,34.671000>}
box{<0,0,-0.406400><0.280800,0.035000,0.406400> rotate<0,-84.271663,0> translate<46.101000,0.000000,34.391600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<40.513000,0.000000,35.941000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<46.129000,0.000000,35.941000>}
box{<0,0,-0.203200><5.616000,0.035000,0.203200> rotate<0,0.000000,0> translate<40.513000,0.000000,35.941000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<45.034200,0.000000,37.490400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<46.129000,0.000000,37.211000>}
box{<0,0,-0.203200><1.129890,0.035000,0.203200> rotate<0,14.315712,0> translate<45.034200,0.000000,37.490400> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<46.228000,0.000000,25.146000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<46.383000,0.000000,25.301000>}
box{<0,0,-0.508000><0.219203,0.035000,0.508000> rotate<0,-44.997030,0> translate<46.228000,0.000000,25.146000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<44.907200,-1.535000,21.844000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.456600,-1.535000,20.294600>}
box{<0,0,-0.406400><2.191182,0.035000,0.406400> rotate<0,44.997030,0> translate<44.907200,-1.535000,21.844000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.456600,-1.535000,17.322800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.456600,-1.535000,20.294600>}
box{<0,0,-0.406400><2.971800,0.035000,0.406400> rotate<0,90.000000,0> translate<46.456600,-1.535000,20.294600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<44.577000,-1.535000,46.583600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.736000,-1.535000,46.583600>}
box{<0,0,-0.406400><2.159000,0.035000,0.406400> rotate<0,0.000000,0> translate<44.577000,-1.535000,46.583600> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<46.990000,0.000000,14.732000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<46.990000,0.000000,14.605000>}
box{<0,0,-0.508000><0.127000,0.035000,0.508000> rotate<0,-90.000000,0> translate<46.990000,0.000000,14.605000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<45.694600,0.000000,14.986000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.990000,0.000000,14.732000>}
box{<0,0,-0.406400><1.320067,0.035000,0.406400> rotate<0,11.092991,0> translate<45.694600,0.000000,14.986000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.456600,-1.535000,17.322800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.990000,-1.535000,14.732000>}
box{<0,0,-0.406400><2.645139,0.035000,0.406400> rotate<0,78.361194,0> translate<46.456600,-1.535000,17.322800> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<46.990000,0.000000,14.605000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<47.015400,0.000000,14.579600>}
box{<0,0,-0.508000><0.035921,0.035000,0.508000> rotate<0,44.997030,0> translate<46.990000,0.000000,14.605000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<47.015400,0.000000,14.579600>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<47.015400,0.000000,17.602200>}
box{<0,0,-0.508000><3.022600,0.035000,0.508000> rotate<0,90.000000,0> translate<47.015400,0.000000,17.602200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.129000,0.000000,34.671000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<47.218600,0.000000,34.823400>}
box{<0,0,-0.406400><1.100206,0.035000,0.406400> rotate<0,-7.961658,0> translate<46.129000,0.000000,34.671000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<47.218600,0.000000,34.823400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<47.574200,0.000000,34.823400>}
box{<0,0,-0.406400><0.355600,0.035000,0.406400> rotate<0,0.000000,0> translate<47.218600,0.000000,34.823400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<39.497000,-1.535000,40.767000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<47.701200,-1.535000,40.767000>}
box{<0,0,-0.203200><8.204200,0.035000,0.203200> rotate<0,0.000000,0> translate<39.497000,-1.535000,40.767000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<44.297600,0.000000,20.396200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<47.777400,0.000000,20.396200>}
box{<0,0,-0.406400><3.479800,0.035000,0.406400> rotate<0,0.000000,0> translate<44.297600,0.000000,20.396200> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<46.383000,0.000000,25.301000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<47.879000,0.000000,25.301000>}
box{<0,0,-0.508000><1.496000,0.035000,0.508000> rotate<0,0.000000,0> translate<46.383000,0.000000,25.301000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<47.879000,0.000000,41.501000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<47.879000,0.000000,45.847000>}
box{<0,0,-0.508000><4.346000,0.035000,0.508000> rotate<0,90.000000,0> translate<47.879000,0.000000,45.847000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.990000,-1.535000,14.732000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<48.285400,-1.535000,16.560800>}
box{<0,0,-0.406400><2.241109,0.035000,0.406400> rotate<0,-54.685177,0> translate<46.990000,-1.535000,14.732000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<43.840400,0.000000,23.571200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<48.412400,0.000000,23.571200>}
box{<0,0,-0.203200><4.572000,0.035000,0.203200> rotate<0,0.000000,0> translate<43.840400,0.000000,23.571200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<47.701200,-1.535000,40.767000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<48.564800,-1.535000,39.903400>}
box{<0,0,-0.203200><1.221315,0.035000,0.203200> rotate<0,44.997030,0> translate<47.701200,-1.535000,40.767000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<48.412400,0.000000,23.571200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<48.869600,0.000000,24.028400>}
box{<0,0,-0.203200><0.646578,0.035000,0.203200> rotate<0,-44.997030,0> translate<48.412400,0.000000,23.571200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<48.869600,0.000000,24.028400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<48.869600,0.000000,24.206200>}
box{<0,0,-0.203200><0.177800,0.035000,0.203200> rotate<0,90.000000,0> translate<48.869600,0.000000,24.206200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<48.564800,-1.535000,39.903400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<49.022000,-1.535000,39.471600>}
box{<0,0,-0.203200><0.628874,0.035000,0.203200> rotate<0,43.360561,0> translate<48.564800,-1.535000,39.903400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<49.022000,0.000000,39.471600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<49.047400,0.000000,40.411400>}
box{<0,0,-0.203200><0.940143,0.035000,0.203200> rotate<0,-88.446005,0> translate<49.022000,0.000000,39.471600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<48.869600,0.000000,24.206200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<49.149000,0.000000,25.301000>}
box{<0,0,-0.203200><1.129890,0.035000,0.203200> rotate<0,-75.678348,0> translate<48.869600,0.000000,24.206200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<49.047400,0.000000,40.411400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<49.149000,0.000000,41.501000>}
box{<0,0,-0.203200><1.094327,0.035000,0.203200> rotate<0,-84.667258,0> translate<49.047400,0.000000,40.411400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.736000,-1.535000,46.583600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<49.834800,-1.535000,43.484800>}
box{<0,0,-0.406400><4.382365,0.035000,0.406400> rotate<0,44.997030,0> translate<46.736000,-1.535000,46.583600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<49.834800,0.000000,43.484800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<50.190400,0.000000,43.129200>}
box{<0,0,-0.406400><0.502894,0.035000,0.406400> rotate<0,44.997030,0> translate<49.834800,0.000000,43.484800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<50.266600,0.000000,24.206200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<50.266600,0.000000,23.469600>}
box{<0,0,-0.203200><0.736600,0.035000,0.203200> rotate<0,-90.000000,0> translate<50.266600,0.000000,23.469600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<50.266600,0.000000,27.127200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<50.266600,0.000000,26.390600>}
box{<0,0,-0.203200><0.736600,0.035000,0.203200> rotate<0,-90.000000,0> translate<50.266600,0.000000,26.390600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<47.574200,0.000000,34.823400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<50.368200,0.000000,37.617400>}
box{<0,0,-0.406400><3.951313,0.035000,0.406400> rotate<0,-44.997030,0> translate<47.574200,0.000000,34.823400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<50.266600,0.000000,24.206200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<50.419000,0.000000,25.301000>}
box{<0,0,-0.203200><1.105356,0.035000,0.203200> rotate<0,-82.069736,0> translate<50.266600,0.000000,24.206200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<50.266600,0.000000,26.390600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<50.419000,0.000000,25.301000>}
box{<0,0,-0.203200><1.100206,0.035000,0.203200> rotate<0,82.032402,0> translate<50.266600,0.000000,26.390600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<50.368200,0.000000,37.617400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<50.419000,0.000000,40.411400>}
box{<0,0,-0.406400><2.794462,0.035000,0.406400> rotate<0,-88.952502,0> translate<50.368200,0.000000,37.617400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<50.419000,0.000000,40.411400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<50.419000,0.000000,41.501000>}
box{<0,0,-0.406400><1.089600,0.035000,0.406400> rotate<0,90.000000,0> translate<50.419000,0.000000,41.501000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<50.419000,0.000000,41.501000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<50.419000,0.000000,42.595800>}
box{<0,0,-0.406400><1.094800,0.035000,0.406400> rotate<0,90.000000,0> translate<50.419000,0.000000,42.595800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<48.285400,-1.535000,16.560800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<50.495200,-1.535000,18.770600>}
box{<0,0,-0.406400><3.125129,0.035000,0.406400> rotate<0,-44.997030,0> translate<48.285400,-1.535000,16.560800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<50.190400,0.000000,43.129200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<50.571400,0.000000,42.951400>}
box{<0,0,-0.406400><0.420445,0.035000,0.406400> rotate<0,25.015242,0> translate<50.190400,0.000000,43.129200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<50.419000,0.000000,42.595800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<50.571400,0.000000,42.951400>}
box{<0,0,-0.406400><0.386881,0.035000,0.406400> rotate<0,-66.797001,0> translate<50.419000,0.000000,42.595800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<50.571400,0.000000,42.951400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<51.054000,0.000000,43.434000>}
box{<0,0,-0.406400><0.682499,0.035000,0.406400> rotate<0,-44.997030,0> translate<50.571400,0.000000,42.951400> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<47.015400,0.000000,17.602200>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<51.689000,0.000000,22.275800>}
box{<0,0,-0.508000><6.609469,0.035000,0.508000> rotate<0,-44.997030,0> translate<47.015400,0.000000,17.602200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<51.689000,0.000000,22.275800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<51.689000,0.000000,25.044400>}
box{<0,0,-0.406400><2.768600,0.035000,0.406400> rotate<0,90.000000,0> translate<51.689000,0.000000,25.044400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<51.689000,0.000000,25.044400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<51.689000,0.000000,25.301000>}
box{<0,0,-0.406400><0.256600,0.035000,0.406400> rotate<0,90.000000,0> translate<51.689000,0.000000,25.301000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<51.689000,0.000000,25.044400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<51.689000,0.000000,41.501000>}
box{<0,0,-0.406400><16.456600,0.035000,0.406400> rotate<0,90.000000,0> translate<51.689000,0.000000,41.501000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<51.054000,0.000000,43.434000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.324000,0.000000,43.434000>}
box{<0,0,-0.406400><1.270000,0.035000,0.406400> rotate<0,0.000000,0> translate<51.054000,0.000000,43.434000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.324000,0.000000,43.434000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.501800,0.000000,43.815000>}
box{<0,0,-0.406400><0.420445,0.035000,0.406400> rotate<0,-64.978818,0> translate<52.324000,0.000000,43.434000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.501800,0.000000,43.815000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.501800,0.000000,44.831000>}
box{<0,0,-0.406400><1.016000,0.035000,0.406400> rotate<0,90.000000,0> translate<52.501800,0.000000,44.831000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.070000,0.000000,14.732000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.603400,0.000000,17.322800>}
box{<0,0,-0.406400><2.645139,0.035000,0.406400> rotate<0,-78.361194,0> translate<52.070000,0.000000,14.732000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.603400,0.000000,17.322800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.603400,0.000000,21.310600>}
box{<0,0,-0.406400><3.987800,0.035000,0.406400> rotate<0,90.000000,0> translate<52.603400,0.000000,21.310600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.603400,0.000000,21.310600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<53.009800,0.000000,21.717000>}
box{<0,0,-0.406400><0.574736,0.035000,0.406400> rotate<0,-44.997030,0> translate<52.603400,0.000000,21.310600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.959000,0.000000,25.301000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<53.009800,0.000000,24.206200>}
box{<0,0,-0.406400><1.095978,0.035000,0.406400> rotate<0,87.337550,0> translate<52.959000,0.000000,25.301000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<53.009800,0.000000,21.717000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<53.009800,0.000000,24.206200>}
box{<0,0,-0.406400><2.489200,0.035000,0.406400> rotate<0,90.000000,0> translate<53.009800,0.000000,24.206200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.324000,0.000000,43.434000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<53.162200,0.000000,42.595800>}
box{<0,0,-0.406400><1.185394,0.035000,0.406400> rotate<0,44.997030,0> translate<52.324000,0.000000,43.434000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.959000,0.000000,41.501000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<53.162200,0.000000,42.595800>}
box{<0,0,-0.406400><1.113498,0.035000,0.406400> rotate<0,-79.480041,0> translate<52.959000,0.000000,41.501000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.959000,0.000000,25.301000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<53.238400,0.000000,25.298400>}
box{<0,0,-0.406400><0.279412,0.035000,0.406400> rotate<0,0.533124,0> translate<52.959000,0.000000,25.301000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<53.162200,0.000000,42.595800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<53.568600,0.000000,42.570400>}
box{<0,0,-0.406400><0.407193,0.035000,0.406400> rotate<0,3.576098,0> translate<53.162200,0.000000,42.595800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<53.238400,0.000000,25.298400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<53.949600,0.000000,25.298400>}
box{<0,0,-0.406400><0.711200,0.035000,0.406400> rotate<0,0.000000,0> translate<53.238400,0.000000,25.298400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<53.568600,0.000000,42.570400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<53.949600,0.000000,42.570400>}
box{<0,0,-0.406400><0.381000,0.035000,0.406400> rotate<0,0.000000,0> translate<53.568600,0.000000,42.570400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<53.949600,0.000000,25.298400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<54.229000,0.000000,25.301000>}
box{<0,0,-0.406400><0.279412,0.035000,0.406400> rotate<0,-0.533124,0> translate<53.949600,0.000000,25.298400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<54.229000,0.000000,25.301000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<54.229000,0.000000,32.334200>}
box{<0,0,-0.406400><7.033200,0.035000,0.406400> rotate<0,90.000000,0> translate<54.229000,0.000000,32.334200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<53.949600,0.000000,42.570400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<54.229000,0.000000,41.501000>}
box{<0,0,-0.406400><1.105297,0.035000,0.406400> rotate<0,75.352781,0> translate<53.949600,0.000000,42.570400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<44.297600,-1.535000,39.852600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<54.279800,-1.535000,29.870400>}
box{<0,0,-0.203200><14.116963,0.035000,0.203200> rotate<0,44.997030,0> translate<44.297600,-1.535000,39.852600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<47.777400,-1.535000,20.396200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<54.635400,-1.535000,20.396200>}
box{<0,0,-0.406400><6.858000,0.035000,0.406400> rotate<0,0.000000,0> translate<47.777400,-1.535000,20.396200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<54.229000,0.000000,25.301000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<54.635400,0.000000,25.273000>}
box{<0,0,-0.406400><0.407363,0.035000,0.406400> rotate<0,3.941055,0> translate<54.229000,0.000000,25.301000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<54.229000,0.000000,41.501000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<54.660800,0.000000,41.452800>}
box{<0,0,-0.406400><0.434482,0.035000,0.406400> rotate<0,6.368897,0> translate<54.229000,0.000000,41.501000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<54.635400,0.000000,25.273000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<55.219600,0.000000,25.273000>}
box{<0,0,-0.406400><0.584200,0.035000,0.406400> rotate<0,0.000000,0> translate<54.635400,0.000000,25.273000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<54.660800,0.000000,41.452800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<55.219600,0.000000,41.452800>}
box{<0,0,-0.406400><0.558800,0.035000,0.406400> rotate<0,0.000000,0> translate<54.660800,0.000000,41.452800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<55.219600,0.000000,25.273000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<55.499000,0.000000,25.301000>}
box{<0,0,-0.406400><0.280800,0.035000,0.406400> rotate<0,-5.722397,0> translate<55.219600,0.000000,25.273000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<55.219600,0.000000,41.452800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<55.499000,0.000000,41.501000>}
box{<0,0,-0.406400><0.283527,0.035000,0.406400> rotate<0,-9.787255,0> translate<55.219600,0.000000,41.452800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<54.279800,-1.535000,29.870400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<55.549800,-1.535000,29.870400>}
box{<0,0,-0.203200><1.270000,0.035000,0.203200> rotate<0,0.000000,0> translate<54.279800,-1.535000,29.870400> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<47.879000,0.000000,45.847000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<56.388000,0.000000,54.356000>}
box{<0,0,-0.508000><12.033543,0.035000,0.508000> rotate<0,-44.997030,0> translate<47.879000,0.000000,45.847000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<56.515000,0.000000,20.828000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<56.769000,0.000000,21.463000>}
box{<0,0,-0.406400><0.683916,0.035000,0.406400> rotate<0,-68.194090,0> translate<56.515000,0.000000,20.828000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<56.769000,0.000000,21.463000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<56.769000,0.000000,25.301000>}
box{<0,0,-0.406400><3.838000,0.035000,0.406400> rotate<0,90.000000,0> translate<56.769000,0.000000,25.301000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<50.266600,-1.535000,27.127200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<56.769000,-1.535000,27.127200>}
box{<0,0,-0.203200><6.502400,0.035000,0.203200> rotate<0,0.000000,0> translate<50.266600,-1.535000,27.127200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<56.642000,0.000000,46.863000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<56.769000,0.000000,46.228000>}
box{<0,0,-0.406400><0.647575,0.035000,0.406400> rotate<0,78.684874,0> translate<56.642000,0.000000,46.863000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<56.769000,0.000000,41.501000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<56.769000,0.000000,46.228000>}
box{<0,0,-0.406400><4.727000,0.035000,0.406400> rotate<0,90.000000,0> translate<56.769000,0.000000,46.228000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.501800,0.000000,44.831000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<57.073800,0.000000,49.403000>}
box{<0,0,-0.406400><6.465784,0.035000,0.406400> rotate<0,-44.997030,0> translate<52.501800,0.000000,44.831000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<52.070000,0.000000,14.732000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<57.150000,0.000000,14.732000>}
box{<0,0,-0.406400><5.080000,0.035000,0.406400> rotate<0,0.000000,0> translate<52.070000,0.000000,14.732000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<54.635400,0.000000,20.396200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<58.166000,0.000000,16.865600>}
box{<0,0,-0.406400><4.993022,0.035000,0.406400> rotate<0,44.997030,0> translate<54.635400,0.000000,20.396200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<58.039000,0.000000,41.501000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<58.216800,0.000000,42.595800>}
box{<0,0,-0.203200><1.109144,0.035000,0.203200> rotate<0,-80.770137,0> translate<58.039000,0.000000,41.501000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<58.216800,0.000000,42.595800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<58.216800,0.000000,47.244000>}
box{<0,0,-0.203200><4.648200,0.035000,0.203200> rotate<0,90.000000,0> translate<58.216800,0.000000,47.244000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<49.022000,-1.535000,39.471600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<58.267600,-1.535000,39.471600>}
box{<0,0,-0.203200><9.245600,0.035000,0.203200> rotate<0,0.000000,0> translate<49.022000,-1.535000,39.471600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<57.150000,0.000000,14.732000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<58.445400,0.000000,16.560800>}
box{<0,0,-0.406400><2.241109,0.035000,0.406400> rotate<0,-54.685177,0> translate<57.150000,0.000000,14.732000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<58.166000,0.000000,16.865600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<58.445400,0.000000,16.560800>}
box{<0,0,-0.406400><0.413482,0.035000,0.406400> rotate<0,47.486419,0> translate<58.166000,0.000000,16.865600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<58.216800,0.000000,47.244000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<58.445400,0.000000,47.472600>}
box{<0,0,-0.203200><0.323289,0.035000,0.203200> rotate<0,-44.997030,0> translate<58.216800,0.000000,47.244000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<58.445400,0.000000,47.472600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<58.648600,0.000000,47.472600>}
box{<0,0,-0.203200><0.203200,0.035000,0.203200> rotate<0,0.000000,0> translate<58.445400,0.000000,47.472600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<57.073800,0.000000,49.403000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<58.648600,0.000000,49.403000>}
box{<0,0,-0.406400><1.574800,0.035000,0.406400> rotate<0,0.000000,0> translate<57.073800,0.000000,49.403000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<55.549800,0.000000,29.870400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<59.029600,0.000000,26.390600>}
box{<0,0,-0.203200><4.921180,0.035000,0.203200> rotate<0,44.997030,0> translate<55.549800,0.000000,29.870400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<59.029600,0.000000,26.390600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<59.309000,0.000000,25.301000>}
box{<0,0,-0.203200><1.124852,0.035000,0.203200> rotate<0,75.612856,0> translate<59.029600,0.000000,26.390600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<59.309000,0.000000,41.501000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<59.410600,0.000000,42.595800>}
box{<0,0,-0.203200><1.099504,0.035000,0.203200> rotate<0,-84.692414,0> translate<59.309000,0.000000,41.501000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<58.648600,0.000000,47.472600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<59.436000,0.000000,48.006000>}
box{<0,0,-0.203200><0.951060,0.035000,0.203200> rotate<0,-34.112222,0> translate<58.648600,0.000000,47.472600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<58.648600,0.000000,49.403000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<59.436000,0.000000,49.530000>}
box{<0,0,-0.406400><0.797576,0.035000,0.406400> rotate<0,-9.161742,0> translate<58.648600,0.000000,49.403000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<59.588400,0.000000,37.719000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<59.588400,0.000000,39.674800>}
box{<0,0,-0.203200><1.955800,0.035000,0.203200> rotate<0,90.000000,0> translate<59.588400,0.000000,39.674800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<59.588400,-1.535000,39.674800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<59.588400,-1.535000,41.935400>}
box{<0,0,-0.203200><2.260600,0.035000,0.203200> rotate<0,90.000000,0> translate<59.588400,-1.535000,41.935400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<56.769000,-1.535000,27.127200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<60.020200,-1.535000,30.378400>}
box{<0,0,-0.203200><4.597891,0.035000,0.203200> rotate<0,-44.997030,0> translate<56.769000,-1.535000,27.127200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<58.267600,-1.535000,39.471600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<60.020200,-1.535000,37.947600>}
box{<0,0,-0.203200><2.322538,0.035000,0.203200> rotate<0,41.006380,0> translate<58.267600,-1.535000,39.471600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<60.020200,-1.535000,30.378400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<60.502800,-1.535000,30.607000>}
box{<0,0,-0.203200><0.534004,0.035000,0.203200> rotate<0,-25.344503,0> translate<60.020200,-1.535000,30.378400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<60.502800,-1.535000,38.100000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<60.502800,-1.535000,30.607000>}
box{<0,0,-0.203200><7.493000,0.035000,0.203200> rotate<0,-90.000000,0> translate<60.502800,-1.535000,30.607000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<60.020200,-1.535000,37.947600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<60.502800,-1.535000,38.100000>}
box{<0,0,-0.203200><0.506091,0.035000,0.203200> rotate<0,-17.524412,0> translate<60.020200,-1.535000,37.947600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<60.502800,-1.535000,38.100000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<60.731400,-1.535000,38.582600>}
box{<0,0,-0.203200><0.534004,0.035000,0.203200> rotate<0,-64.649557,0> translate<60.502800,-1.535000,38.100000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<59.588400,0.000000,37.719000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<61.087000,0.000000,36.220400>}
box{<0,0,-0.203200><2.119340,0.035000,0.203200> rotate<0,44.997030,0> translate<59.588400,0.000000,37.719000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<60.502800,0.000000,38.100000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<61.137800,0.000000,38.100000>}
box{<0,0,-0.203200><0.635000,0.035000,0.203200> rotate<0,0.000000,0> translate<60.502800,0.000000,38.100000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<60.502800,0.000000,30.607000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<61.239400,0.000000,29.870400>}
box{<0,0,-0.203200><1.041710,0.035000,0.203200> rotate<0,44.997030,0> translate<60.502800,0.000000,30.607000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<61.087000,0.000000,36.220400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<61.239400,0.000000,36.220400>}
box{<0,0,-0.203200><0.152400,0.035000,0.203200> rotate<0,0.000000,0> translate<61.087000,0.000000,36.220400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<61.137800,0.000000,38.100000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<61.239400,0.000000,38.201600>}
box{<0,0,-0.203200><0.143684,0.035000,0.203200> rotate<0,-44.997030,0> translate<61.137800,0.000000,38.100000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<59.410600,0.000000,42.595800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<61.722000,0.000000,44.907200>}
box{<0,0,-0.203200><3.268813,0.035000,0.203200> rotate<0,-44.997030,0> translate<59.410600,0.000000,42.595800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<61.722000,0.000000,44.907200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<61.722000,0.000000,45.364400>}
box{<0,0,-0.203200><0.457200,0.035000,0.203200> rotate<0,90.000000,0> translate<61.722000,0.000000,45.364400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<61.722000,-1.535000,45.364400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<61.722000,-1.535000,47.472600>}
box{<0,0,-0.203200><2.108200,0.035000,0.203200> rotate<0,90.000000,0> translate<61.722000,-1.535000,47.472600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<61.239400,0.000000,29.870400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<62.329000,0.000000,29.591000>}
box{<0,0,-0.203200><1.124852,0.035000,0.203200> rotate<0,14.381205,0> translate<61.239400,0.000000,29.870400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<61.239400,0.000000,36.220400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<62.329000,0.000000,35.941000>}
box{<0,0,-0.203200><1.124852,0.035000,0.203200> rotate<0,14.381205,0> translate<61.239400,0.000000,36.220400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<61.239400,0.000000,38.201600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<62.329000,0.000000,38.481000>}
box{<0,0,-0.203200><1.124852,0.035000,0.203200> rotate<0,-14.381205,0> translate<61.239400,0.000000,38.201600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.329000,0.000000,32.131000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.331600,0.000000,32.410400>}
box{<0,0,-0.406400><0.279412,0.035000,0.406400> rotate<0,-89.460936,0> translate<62.329000,0.000000,32.131000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.329000,0.000000,33.401000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.331600,0.000000,33.121600>}
box{<0,0,-0.406400><0.279412,0.035000,0.406400> rotate<0,89.460936,0> translate<62.329000,0.000000,33.401000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.331600,0.000000,32.410400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.331600,0.000000,33.121600>}
box{<0,0,-0.406400><0.711200,0.035000,0.406400> rotate<0,90.000000,0> translate<62.331600,0.000000,33.121600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.329000,0.000000,33.401000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.357000,0.000000,33.807400>}
box{<0,0,-0.406400><0.407363,0.035000,0.406400> rotate<0,-86.053005,0> translate<62.329000,0.000000,33.401000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.329000,0.000000,34.671000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.357000,0.000000,34.391600>}
box{<0,0,-0.406400><0.280800,0.035000,0.406400> rotate<0,84.271663,0> translate<62.329000,0.000000,34.671000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.357000,0.000000,33.807400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.357000,0.000000,34.391600>}
box{<0,0,-0.406400><0.584200,0.035000,0.406400> rotate<0,90.000000,0> translate<62.357000,0.000000,34.391600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<61.722000,0.000000,47.472600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<62.458600,0.000000,47.472600>}
box{<0,0,-0.203200><0.736600,0.035000,0.203200> rotate<0,0.000000,0> translate<61.722000,0.000000,47.472600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<59.436000,0.000000,46.482000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<63.246000,0.000000,46.482000>}
box{<0,0,-0.203200><3.810000,0.035000,0.203200> rotate<0,0.000000,0> translate<59.436000,0.000000,46.482000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<62.458600,0.000000,47.472600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<63.246000,0.000000,48.006000>}
box{<0,0,-0.203200><0.951060,0.035000,0.203200> rotate<0,-34.112222,0> translate<62.458600,0.000000,47.472600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<59.436000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<63.246000,0.000000,49.530000>}
box{<0,0,-0.406400><3.810000,0.035000,0.406400> rotate<0,0.000000,0> translate<59.436000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<62.329000,0.000000,30.861000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<63.423800,0.000000,30.581600>}
box{<0,0,-0.203200><1.129890,0.035000,0.203200> rotate<0,14.315712,0> translate<62.329000,0.000000,30.861000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.329000,0.000000,32.131000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<63.423800,0.000000,32.334200>}
box{<0,0,-0.406400><1.113498,0.035000,0.406400> rotate<0,-10.514020,0> translate<62.329000,0.000000,32.131000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<62.329000,0.000000,34.671000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<63.423800,0.000000,34.467800>}
box{<0,0,-0.406400><1.113498,0.035000,0.406400> rotate<0,10.514020,0> translate<62.329000,0.000000,34.671000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<62.329000,0.000000,37.211000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<63.423800,0.000000,37.490400>}
box{<0,0,-0.203200><1.129890,0.035000,0.203200> rotate<0,-14.315712,0> translate<62.329000,0.000000,37.211000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<62.230000,0.000000,14.732000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<63.525400,0.000000,12.954000>}
box{<0,0,-0.203200><2.199851,0.035000,0.203200> rotate<0,53.920430,0> translate<62.230000,0.000000,14.732000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<63.423800,0.000000,30.581600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<63.627000,0.000000,30.581600>}
box{<0,0,-0.203200><0.203200,0.035000,0.203200> rotate<0,0.000000,0> translate<63.423800,0.000000,30.581600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<63.246000,0.000000,46.482000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<64.033400,0.000000,46.812200>}
box{<0,0,-0.203200><0.853833,0.035000,0.203200> rotate<0,-22.749475,0> translate<63.246000,0.000000,46.482000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<63.246000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.033400,0.000000,50.088800>}
box{<0,0,-0.406400><0.965534,0.035000,0.406400> rotate<0,-35.360128,0> translate<63.246000,0.000000,49.530000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.033400,0.000000,50.088800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.439800,0.000000,50.495200>}
box{<0,0,-0.406400><0.574736,0.035000,0.406400> rotate<0,-44.997030,0> translate<64.033400,0.000000,50.088800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<63.423800,0.000000,37.490400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<64.897000,0.000000,37.490400>}
box{<0,0,-0.203200><1.473200,0.035000,0.203200> rotate<0,0.000000,0> translate<63.423800,0.000000,37.490400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<58.445400,0.000000,16.560800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.947800,0.000000,23.063200>}
box{<0,0,-0.406400><9.195782,0.035000,0.406400> rotate<0,-44.997030,0> translate<58.445400,0.000000,16.560800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<64.033400,0.000000,46.812200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<65.963800,0.000000,48.742600>}
box{<0,0,-0.203200><2.729998,0.035000,0.203200> rotate<0,-44.997030,0> translate<64.033400,0.000000,46.812200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<50.266600,-1.535000,23.469600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<66.090800,-1.535000,23.469600>}
box{<0,0,-0.203200><15.824200,0.035000,0.203200> rotate<0,0.000000,0> translate<50.266600,-1.535000,23.469600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<63.423800,0.000000,32.334200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<66.217800,0.000000,29.540200>}
box{<0,0,-0.406400><3.951313,0.035000,0.406400> rotate<0,44.997030,0> translate<63.423800,0.000000,32.334200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<63.423800,0.000000,34.467800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<66.217800,0.000000,37.261800>}
box{<0,0,-0.406400><3.951313,0.035000,0.406400> rotate<0,-44.997030,0> translate<63.423800,0.000000,34.467800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<63.627000,0.000000,30.581600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<66.268600,0.000000,27.940000>}
box{<0,0,-0.203200><3.735787,0.035000,0.203200> rotate<0,44.997030,0> translate<63.627000,0.000000,30.581600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<64.897000,0.000000,37.490400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<66.268600,0.000000,38.862000>}
box{<0,0,-0.203200><1.939735,0.035000,0.203200> rotate<0,-44.997030,0> translate<64.897000,0.000000,37.490400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<66.040000,0.000000,34.671000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<66.319400,0.000000,35.306000>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,-66.246133,0> translate<66.040000,0.000000,34.671000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<59.588400,-1.535000,41.935400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<66.497200,-1.535000,48.844200>}
box{<0,0,-0.203200><9.770519,0.035000,0.203200> rotate<0,-44.997030,0> translate<59.588400,-1.535000,41.935400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<66.497200,-1.535000,48.844200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<66.497200,-1.535000,49.479200>}
box{<0,0,-0.203200><0.635000,0.035000,0.203200> rotate<0,90.000000,0> translate<66.497200,-1.535000,49.479200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<66.040000,-1.535000,32.131000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<66.675000,-1.535000,31.851600>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,23.747927,0> translate<66.040000,-1.535000,32.131000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<66.217800,0.000000,29.540200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<66.802000,0.000000,29.210000>}
box{<0,0,-0.406400><0.671060,0.035000,0.406400> rotate<0,29.473944,0> translate<66.217800,0.000000,29.540200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<66.217800,0.000000,37.261800>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<66.802000,0.000000,37.592000>}
box{<0,0,-0.406400><0.671060,0.035000,0.406400> rotate<0,-29.473944,0> translate<66.217800,0.000000,37.261800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<65.963800,0.000000,48.742600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<66.929000,0.000000,48.742600>}
box{<0,0,-0.203200><0.965200,0.035000,0.203200> rotate<0,0.000000,0> translate<65.963800,0.000000,48.742600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<67.056000,0.000000,19.583400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<67.056000,0.000000,15.925800>}
box{<0,0,-0.203200><3.657600,0.035000,0.203200> rotate<0,-90.000000,0> translate<67.056000,0.000000,15.925800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<66.497200,-1.535000,49.479200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<67.106800,-1.535000,50.088800>}
box{<0,0,-0.203200><0.862105,0.035000,0.203200> rotate<0,-44.997030,0> translate<66.497200,-1.535000,49.479200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<60.731400,-1.535000,38.582600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<67.284600,-1.535000,45.135800>}
box{<0,0,-0.203200><9.267624,0.035000,0.203200> rotate<0,-44.997030,0> translate<60.731400,-1.535000,38.582600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<67.284600,-1.535000,45.135800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<67.284600,-1.535000,48.387000>}
box{<0,0,-0.203200><3.251200,0.035000,0.203200> rotate<0,90.000000,0> translate<67.284600,-1.535000,48.387000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<66.802000,0.000000,29.210000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<67.437000,0.000000,29.489400>}
box{<0,0,-0.406400><0.693750,0.035000,0.406400> rotate<0,-23.747927,0> translate<66.802000,0.000000,29.210000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<66.929000,0.000000,48.742600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<67.564000,0.000000,49.022000>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,-23.747927,0> translate<66.929000,0.000000,48.742600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<67.284600,-1.535000,48.387000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<67.564000,-1.535000,49.022000>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,-66.246133,0> translate<67.284600,-1.535000,48.387000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<50.495200,-1.535000,18.770600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<67.691000,-1.535000,18.770600>}
box{<0,0,-0.406400><17.195800,0.035000,0.406400> rotate<0,0.000000,0> translate<50.495200,-1.535000,18.770600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<66.090800,-1.535000,23.469600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<67.691000,-1.535000,21.869400>}
box{<0,0,-0.203200><2.263025,0.035000,0.203200> rotate<0,44.997030,0> translate<66.090800,-1.535000,23.469600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<67.106800,-1.535000,50.088800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.021200,-1.535000,50.088800>}
box{<0,0,-0.203200><0.914400,0.035000,0.203200> rotate<0,0.000000,0> translate<67.106800,-1.535000,50.088800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<67.056000,0.000000,19.583400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.046600,0.000000,20.574000>}
box{<0,0,-0.203200><1.400920,0.035000,0.203200> rotate<0,-44.997030,0> translate<67.056000,0.000000,19.583400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.046600,0.000000,20.955000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.046600,0.000000,20.574000>}
box{<0,0,-0.203200><0.381000,0.035000,0.203200> rotate<0,-90.000000,0> translate<68.046600,0.000000,20.574000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<66.319400,0.000000,35.306000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.072000,0.000000,37.058600>}
box{<0,0,-0.203200><2.478551,0.035000,0.203200> rotate<0,-44.997030,0> translate<66.319400,0.000000,35.306000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.072000,0.000000,38.862000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.072000,0.000000,37.058600>}
box{<0,0,-0.203200><1.803400,0.035000,0.203200> rotate<0,-90.000000,0> translate<68.072000,0.000000,37.058600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<66.268600,0.000000,38.862000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.072000,0.000000,38.862000>}
box{<0,0,-0.203200><1.803400,0.035000,0.203200> rotate<0,0.000000,0> translate<66.268600,0.000000,38.862000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.439800,0.000000,50.495200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<68.199000,0.000000,50.495200>}
box{<0,0,-0.406400><3.759200,0.035000,0.406400> rotate<0,0.000000,0> translate<64.439800,0.000000,50.495200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<63.525400,0.000000,12.954000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.326000,0.000000,12.954000>}
box{<0,0,-0.203200><4.800600,0.035000,0.203200> rotate<0,0.000000,0> translate<63.525400,0.000000,12.954000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<67.056000,0.000000,15.925800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.326000,0.000000,15.494000>}
box{<0,0,-0.203200><1.341399,0.035000,0.203200> rotate<0,18.776794,0> translate<67.056000,0.000000,15.925800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<67.691000,-1.535000,18.770600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<68.326000,-1.535000,19.050000>}
box{<0,0,-0.406400><0.693750,0.035000,0.406400> rotate<0,-23.747927,0> translate<67.691000,-1.535000,18.770600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<67.691000,-1.535000,21.869400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.326000,-1.535000,21.590000>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,23.747927,0> translate<67.691000,-1.535000,21.869400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.046600,0.000000,20.955000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.326000,0.000000,21.590000>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,-66.246133,0> translate<68.046600,0.000000,20.955000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<66.675000,-1.535000,31.851600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.884800,-1.535000,31.851600>}
box{<0,0,-0.203200><2.209800,0.035000,0.203200> rotate<0,0.000000,0> translate<66.675000,-1.535000,31.851600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<64.947800,0.000000,23.063200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<68.961000,0.000000,23.063200>}
box{<0,0,-0.406400><4.013200,0.035000,0.406400> rotate<0,0.000000,0> translate<64.947800,0.000000,23.063200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<68.199000,0.000000,50.495200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.392800,0.000000,49.301400>}
box{<0,0,-0.406400><1.688288,0.035000,0.406400> rotate<0,44.997030,0> translate<68.199000,0.000000,50.495200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.326000,0.000000,15.494000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<69.723000,0.000000,15.189200>}
box{<0,0,-0.203200><1.429864,0.035000,0.203200> rotate<0,12.307204,0> translate<68.326000,0.000000,15.494000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<67.437000,0.000000,29.489400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.799200,0.000000,31.851600>}
box{<0,0,-0.406400><3.340655,0.035000,0.406400> rotate<0,-44.997030,0> translate<67.437000,0.000000,29.489400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<69.824600,-1.535000,48.285400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<69.824600,-1.535000,47.117000>}
box{<0,0,-0.203200><1.168400,0.035000,0.203200> rotate<0,-90.000000,0> translate<69.824600,-1.535000,47.117000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.021200,-1.535000,50.088800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<69.824600,-1.535000,48.285400>}
box{<0,0,-0.203200><2.550393,0.035000,0.203200> rotate<0,44.997030,0> translate<68.021200,-1.535000,50.088800> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.951600,0.000000,22.072600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.951600,0.000000,20.955000>}
box{<0,0,-0.406400><1.117600,0.035000,0.406400> rotate<0,-90.000000,0> translate<69.951600,0.000000,20.955000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<68.961000,0.000000,23.063200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.951600,0.000000,22.072600>}
box{<0,0,-0.406400><1.400920,0.035000,0.406400> rotate<0,44.997030,0> translate<68.961000,0.000000,23.063200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<69.824600,-1.535000,47.117000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<70.104000,-1.535000,46.482000>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,66.246133,0> translate<69.824600,-1.535000,47.117000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.951600,0.000000,20.955000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<70.231000,0.000000,20.320000>}
box{<0,0,-0.406400><0.693750,0.035000,0.406400> rotate<0,66.246133,0> translate<69.951600,0.000000,20.955000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<66.268600,0.000000,27.940000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<70.256400,0.000000,27.940000>}
box{<0,0,-0.203200><3.987800,0.035000,0.203200> rotate<0,0.000000,0> translate<66.268600,0.000000,27.940000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.072000,0.000000,38.862000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<70.256400,0.000000,38.862000>}
box{<0,0,-0.203200><2.184400,0.035000,0.203200> rotate<0,0.000000,0> translate<68.072000,0.000000,38.862000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<70.231000,0.000000,20.320000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<70.866000,0.000000,20.040600>}
box{<0,0,-0.406400><0.693750,0.035000,0.406400> rotate<0,23.747927,0> translate<70.231000,0.000000,20.320000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<70.256400,0.000000,27.940000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.247000,0.000000,28.930600>}
box{<0,0,-0.203200><1.400920,0.035000,0.203200> rotate<0,-44.997030,0> translate<70.256400,0.000000,27.940000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<68.884800,-1.535000,31.851600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.247000,-1.535000,29.489400>}
box{<0,0,-0.203200><3.340655,0.035000,0.203200> rotate<0,44.997030,0> translate<68.884800,-1.535000,31.851600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<70.256400,0.000000,38.862000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.247000,0.000000,37.871400>}
box{<0,0,-0.203200><1.400920,0.035000,0.203200> rotate<0,44.997030,0> translate<70.256400,0.000000,38.862000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.247000,0.000000,28.930600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.882000,0.000000,29.210000>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,-23.747927,0> translate<71.247000,0.000000,28.930600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.247000,-1.535000,29.489400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.882000,-1.535000,29.210000>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,23.747927,0> translate<71.247000,-1.535000,29.489400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.247000,0.000000,37.871400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.882000,0.000000,37.592000>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,23.747927,0> translate<71.247000,0.000000,37.871400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<69.723000,0.000000,15.189200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.983600,0.000000,15.189200>}
box{<0,0,-0.203200><2.260600,0.035000,0.203200> rotate<0,0.000000,0> translate<69.723000,0.000000,15.189200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.392800,0.000000,49.301400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<72.009000,0.000000,49.301400>}
box{<0,0,-0.406400><2.616200,0.035000,0.406400> rotate<0,0.000000,0> translate<69.392800,0.000000,49.301400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<46.228000,-1.535000,25.146000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<72.644000,-1.535000,25.146000>}
box{<0,0,-0.406400><26.416000,0.035000,0.406400> rotate<0,0.000000,0> translate<46.228000,-1.535000,25.146000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<72.009000,0.000000,49.301400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<72.644000,0.000000,49.022000>}
box{<0,0,-0.406400><0.693750,0.035000,0.406400> rotate<0,23.747927,0> translate<72.009000,0.000000,49.301400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<69.799200,0.000000,31.851600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<73.025000,0.000000,31.851600>}
box{<0,0,-0.406400><3.225800,0.035000,0.406400> rotate<0,0.000000,0> translate<69.799200,0.000000,31.851600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<71.983600,0.000000,15.189200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<73.634600,0.000000,13.538200>}
box{<0,0,-0.203200><2.334867,0.035000,0.203200> rotate<0,44.997030,0> translate<71.983600,0.000000,15.189200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<73.025000,0.000000,31.851600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<73.660000,0.000000,32.131000>}
box{<0,0,-0.406400><0.693750,0.035000,0.406400> rotate<0,-23.747927,0> translate<73.025000,0.000000,31.851600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<73.660000,0.000000,32.131000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<73.660000,0.000000,34.671000>}
box{<0,0,-0.406400><2.540000,0.035000,0.406400> rotate<0,90.000000,0> translate<73.660000,0.000000,34.671000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<70.866000,0.000000,20.040600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<73.736200,0.000000,17.170400>}
box{<0,0,-0.406400><4.059076,0.035000,0.406400> rotate<0,44.997030,0> translate<70.866000,0.000000,20.040600> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<56.388000,0.000000,54.356000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<73.914000,0.000000,54.356000>}
box{<0,0,-0.508000><17.526000,0.035000,0.508000> rotate<0,0.000000,0> translate<56.388000,0.000000,54.356000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<60.579000,0.000000,25.301000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<74.069000,0.000000,25.301000>}
box{<0,0,-0.508000><13.490000,0.035000,0.508000> rotate<0,0.000000,0> translate<60.579000,0.000000,25.301000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<73.634600,0.000000,13.538200>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<74.422000,0.000000,13.208000>}
box{<0,0,-0.203200><0.853833,0.035000,0.203200> rotate<0,22.749475,0> translate<73.634600,0.000000,13.538200> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<73.736200,0.000000,17.170400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.422000,0.000000,16.764000>}
box{<0,0,-0.406400><0.797172,0.035000,0.406400> rotate<0,30.648645,0> translate<73.736200,0.000000,17.170400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<74.422000,0.000000,13.208000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<74.803000,0.000000,12.471400>}
box{<0,0,-0.203200><0.829301,0.035000,0.203200> rotate<0,62.645990,0> translate<74.422000,0.000000,13.208000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<74.422000,0.000000,16.764000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.209400,0.000000,17.094200>}
box{<0,0,-0.406400><0.853833,0.035000,0.406400> rotate<0,-22.749475,0> translate<74.422000,0.000000,16.764000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<77.470000,0.000000,50.800000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<77.470000,0.000000,46.228000>}
box{<0,0,-0.508000><4.572000,0.035000,0.508000> rotate<0,-90.000000,0> translate<77.470000,0.000000,46.228000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<73.914000,0.000000,54.356000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<77.470000,0.000000,50.800000>}
box{<0,0,-0.508000><5.028943,0.035000,0.508000> rotate<0,44.997030,0> translate<73.914000,0.000000,54.356000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<60.579000,0.000000,41.501000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<78.133000,0.000000,41.501000>}
box{<0,0,-0.508000><17.554000,0.035000,0.508000> rotate<0,0.000000,0> translate<60.579000,0.000000,41.501000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<74.069000,0.000000,25.301000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<79.248000,0.000000,30.480000>}
box{<0,0,-0.508000><7.324212,0.035000,0.508000> rotate<0,-44.997030,0> translate<74.069000,0.000000,25.301000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<74.803000,0.000000,12.471400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<79.883000,0.000000,12.471400>}
box{<0,0,-0.203200><5.080000,0.035000,0.203200> rotate<0,0.000000,0> translate<74.803000,0.000000,12.471400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<75.209400,0.000000,17.094200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<79.883000,0.000000,17.094200>}
box{<0,0,-0.406400><4.673600,0.035000,0.406400> rotate<0,0.000000,0> translate<75.209400,0.000000,17.094200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<79.883000,0.000000,12.471400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<80.518000,0.000000,12.192000>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,23.747927,0> translate<79.883000,0.000000,12.471400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<79.883000,0.000000,17.094200>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.518000,0.000000,17.272000>}
box{<0,0,-0.406400><0.659422,0.035000,0.406400> rotate<0,-15.641214,0> translate<79.883000,0.000000,17.094200> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<80.518000,0.000000,12.192000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<81.153000,0.000000,12.471400>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,-23.747927,0> translate<80.518000,0.000000,12.192000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<80.518000,0.000000,17.272000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.153000,0.000000,17.551400>}
box{<0,0,-0.406400><0.693750,0.035000,0.406400> rotate<0,-23.747927,0> translate<80.518000,0.000000,17.272000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<79.248000,0.000000,30.480000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<81.280000,0.000000,30.480000>}
box{<0,0,-0.508000><2.032000,0.035000,0.508000> rotate<0,0.000000,0> translate<79.248000,0.000000,30.480000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<77.470000,0.000000,46.228000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<81.407000,0.000000,42.291000>}
box{<0,0,-0.508000><5.567759,0.035000,0.508000> rotate<0,44.997030,0> translate<77.470000,0.000000,46.228000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<78.133000,0.000000,41.501000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<81.534000,0.000000,38.100000>}
box{<0,0,-0.508000><4.809740,0.035000,0.508000> rotate<0,44.997030,0> translate<78.133000,0.000000,41.501000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<81.407000,0.000000,42.291000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<81.534000,0.000000,42.164000>}
box{<0,0,-0.508000><0.179605,0.035000,0.508000> rotate<0,44.997030,0> translate<81.407000,0.000000,42.291000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<72.644000,-1.535000,25.146000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<81.788000,-1.535000,34.290000>}
box{<0,0,-0.508000><12.931569,0.035000,0.508000> rotate<0,-44.997030,0> translate<72.644000,-1.535000,25.146000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<81.280000,0.000000,22.860000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<81.915000,0.000000,23.088600>}
box{<0,0,-0.508000><0.674895,0.035000,0.508000> rotate<0,-19.797570,0> translate<81.280000,0.000000,22.860000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.407000,0.000000,49.911000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<82.042000,0.000000,49.631600>}
box{<0,0,-0.406400><0.693750,0.035000,0.406400> rotate<0,23.747927,0> translate<81.407000,0.000000,49.911000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<81.153000,0.000000,12.471400>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<82.880200,0.000000,14.198600>}
box{<0,0,-0.203200><2.442630,0.035000,0.203200> rotate<0,-44.997030,0> translate<81.153000,0.000000,12.471400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<81.153000,0.000000,17.551400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<82.931000,0.000000,19.329400>}
box{<0,0,-0.406400><2.514472,0.035000,0.406400> rotate<0,-44.997030,0> translate<81.153000,0.000000,17.551400> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<82.931000,0.000000,19.329400>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<83.566000,0.000000,19.050000>}
box{<0,0,-0.406400><0.693750,0.035000,0.406400> rotate<0,23.747927,0> translate<82.931000,0.000000,19.329400> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<81.534000,0.000000,38.100000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<83.743800,0.000000,38.100000>}
box{<0,0,-0.508000><2.209800,0.035000,0.508000> rotate<0,0.000000,0> translate<81.534000,0.000000,38.100000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<83.743800,0.000000,38.100000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<83.743800,0.000000,38.125400>}
box{<0,0,-0.508000><0.025400,0.035000,0.508000> rotate<0,90.000000,0> translate<83.743800,0.000000,38.125400> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<83.743800,0.000000,38.100000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<83.820000,0.000000,38.100000>}
box{<0,0,-0.508000><0.076200,0.035000,0.508000> rotate<0,0.000000,0> translate<83.743800,0.000000,38.100000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<83.743800,0.000000,38.125400>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<83.845400,0.000000,38.227000>}
box{<0,0,-0.508000><0.143684,0.035000,0.508000> rotate<0,-44.997030,0> translate<83.743800,0.000000,38.125400> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<84.074000,-1.535000,34.213800>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<84.074000,-1.535000,27.914600>}
box{<0,0,-0.508000><6.299200,0.035000,0.508000> rotate<0,-90.000000,0> translate<84.074000,-1.535000,27.914600> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<83.820000,0.000000,38.100000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<84.074000,0.000000,38.354000>}
box{<0,0,-0.508000><0.359210,0.035000,0.508000> rotate<0,-44.997030,0> translate<83.820000,0.000000,38.100000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<84.099400,0.000000,38.227000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<84.099400,0.000000,38.176200>}
box{<0,0,-0.508000><0.050800,0.035000,0.508000> rotate<0,-90.000000,0> translate<84.099400,0.000000,38.176200> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<83.845400,0.000000,38.227000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<84.099400,0.000000,38.227000>}
box{<0,0,-0.508000><0.254000,0.035000,0.508000> rotate<0,0.000000,0> translate<83.845400,0.000000,38.227000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<81.788000,-1.535000,34.290000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<84.150200,-1.535000,34.290000>}
box{<0,0,-0.508000><2.362200,0.035000,0.508000> rotate<0,0.000000,0> translate<81.788000,-1.535000,34.290000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<84.074000,-1.535000,34.213800>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<84.150200,-1.535000,34.290000>}
box{<0,0,-0.508000><0.107763,0.035000,0.508000> rotate<0,-44.997030,0> translate<84.074000,-1.535000,34.213800> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<84.099400,0.000000,38.176200>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<84.201000,0.000000,38.277800>}
box{<0,0,-0.508000><0.143684,0.035000,0.508000> rotate<0,-44.997030,0> translate<84.099400,0.000000,38.176200> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<84.201000,0.000000,38.277800>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<84.201000,0.000000,39.801800>}
box{<0,0,-0.508000><1.524000,0.035000,0.508000> rotate<0,90.000000,0> translate<84.201000,0.000000,39.801800> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<84.201000,-1.535000,39.801800>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<84.226400,-1.535000,39.827200>}
box{<0,0,-0.508000><0.035921,0.035000,0.508000> rotate<0,-44.997030,0> translate<84.201000,-1.535000,39.801800> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<84.226400,-1.535000,39.827200>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<84.226400,-1.535000,45.110400>}
box{<0,0,-0.508000><5.283200,0.035000,0.508000> rotate<0,90.000000,0> translate<84.226400,-1.535000,45.110400> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<82.880200,0.000000,14.198600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<85.090000,0.000000,14.198600>}
box{<0,0,-0.203200><2.209800,0.035000,0.203200> rotate<0,0.000000,0> translate<82.880200,0.000000,14.198600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<85.090000,0.000000,14.198600>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<85.725000,0.000000,14.478000>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,-23.747927,0> translate<85.090000,0.000000,14.198600> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<84.226400,-1.535000,45.110400>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<85.725000,-1.535000,46.609000>}
box{<0,0,-0.508000><2.119340,0.035000,0.508000> rotate<0,-44.997030,0> translate<84.226400,-1.535000,45.110400> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<84.074000,0.000000,27.914600>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<86.080600,0.000000,25.908000>}
box{<0,0,-0.508000><2.837761,0.035000,0.508000> rotate<0,44.997030,0> translate<84.074000,0.000000,27.914600> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<82.042000,0.000000,49.631600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<88.214200,0.000000,49.631600>}
box{<0,0,-0.406400><6.172200,0.035000,0.406400> rotate<0,0.000000,0> translate<82.042000,0.000000,49.631600> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<81.915000,0.000000,23.088600>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<88.265000,0.000000,23.088600>}
box{<0,0,-0.508000><6.350000,0.035000,0.508000> rotate<0,0.000000,0> translate<81.915000,0.000000,23.088600> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<88.265000,0.000000,14.478000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<88.544400,0.000000,15.113000>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,-66.246133,0> translate<88.265000,0.000000,14.478000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<88.544400,0.000000,15.113000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<88.544400,0.000000,16.052800>}
box{<0,0,-0.203200><0.939800,0.035000,0.203200> rotate<0,90.000000,0> translate<88.544400,0.000000,16.052800> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<85.725000,-1.535000,46.609000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<88.646000,-1.535000,46.609000>}
box{<0,0,-0.508000><2.921000,0.035000,0.508000> rotate<0,0.000000,0> translate<85.725000,-1.535000,46.609000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<88.214200,0.000000,49.631600>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<88.646000,0.000000,49.149000>}
box{<0,0,-0.406400><0.647575,0.035000,0.406400> rotate<0,48.176650,0> translate<88.214200,0.000000,49.631600> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<88.265000,0.000000,23.088600>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<88.900000,0.000000,23.368000>}
box{<0,0,-0.508000><0.693750,0.035000,0.508000> rotate<0,-23.747927,0> translate<88.265000,0.000000,23.088600> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<86.080600,0.000000,25.908000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<88.900000,0.000000,25.908000>}
box{<0,0,-0.508000><2.819400,0.035000,0.508000> rotate<0,0.000000,0> translate<86.080600,0.000000,25.908000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<88.646000,0.000000,46.609000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<89.281000,0.000000,46.355000>}
box{<0,0,-0.508000><0.683916,0.035000,0.508000> rotate<0,21.799971,0> translate<88.646000,0.000000,46.609000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<88.646000,0.000000,49.149000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<89.281000,0.000000,48.895000>}
box{<0,0,-0.406400><0.683916,0.035000,0.406400> rotate<0,21.799971,0> translate<88.646000,0.000000,49.149000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<84.099400,0.000000,38.227000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<90.297000,0.000000,38.227000>}
box{<0,0,-0.508000><6.197600,0.035000,0.508000> rotate<0,0.000000,0> translate<84.099400,0.000000,38.227000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<81.407000,0.000000,42.291000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<90.297000,0.000000,42.291000>}
box{<0,0,-0.508000><8.890000,0.035000,0.508000> rotate<0,0.000000,0> translate<81.407000,0.000000,42.291000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<84.150200,-1.535000,34.290000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<90.322400,-1.535000,34.290000>}
box{<0,0,-0.508000><6.172200,0.035000,0.508000> rotate<0,0.000000,0> translate<84.150200,-1.535000,34.290000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<90.424000,0.000000,30.480000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<90.424000,0.000000,30.382000>}
box{<0,0,-0.508000><0.098000,0.035000,0.508000> rotate<0,-90.000000,0> translate<90.424000,0.000000,30.382000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<81.280000,0.000000,30.480000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<90.424000,0.000000,30.480000>}
box{<0,0,-0.508000><9.144000,0.035000,0.508000> rotate<0,0.000000,0> translate<81.280000,0.000000,30.480000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<90.322400,-1.535000,34.290000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<90.424000,-1.535000,34.188400>}
box{<0,0,-0.508000><0.143684,0.035000,0.508000> rotate<0,44.997030,0> translate<90.322400,-1.535000,34.290000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<90.424000,-1.535000,34.342000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<90.424000,-1.535000,34.290000>}
box{<0,0,-0.508000><0.052000,0.035000,0.508000> rotate<0,-90.000000,0> translate<90.424000,-1.535000,34.290000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<90.424000,-1.535000,34.188400>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<90.424000,-1.535000,34.342000>}
box{<0,0,-0.508000><0.153600,0.035000,0.508000> rotate<0,90.000000,0> translate<90.424000,-1.535000,34.342000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<90.424000,0.000000,38.354000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<90.424000,0.000000,38.302000>}
box{<0,0,-0.508000><0.052000,0.035000,0.508000> rotate<0,-90.000000,0> translate<90.424000,0.000000,38.302000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<90.297000,0.000000,38.227000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<90.424000,0.000000,38.354000>}
box{<0,0,-0.508000><0.179605,0.035000,0.508000> rotate<0,-44.997030,0> translate<90.297000,0.000000,38.227000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<90.297000,0.000000,42.291000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<90.424000,0.000000,42.164000>}
box{<0,0,-0.508000><0.179605,0.035000,0.508000> rotate<0,44.997030,0> translate<90.297000,0.000000,42.291000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<90.424000,0.000000,42.164000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<90.424000,0.000000,42.262000>}
box{<0,0,-0.508000><0.098000,0.035000,0.508000> rotate<0,90.000000,0> translate<90.424000,0.000000,42.262000> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<88.544400,0.000000,16.052800>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<90.906600,0.000000,18.415000>}
box{<0,0,-0.203200><3.340655,0.035000,0.203200> rotate<0,-44.997030,0> translate<88.544400,0.000000,16.052800> }
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<90.906600,0.000000,18.415000>}
cylinder{<0,0,0><0,0.035000,0>0.203200 translate<91.186000,0.000000,19.050000>}
box{<0,0,-0.203200><0.693750,0.035000,0.203200> rotate<0,-66.246133,0> translate<90.906600,0.000000,18.415000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<88.900000,0.000000,23.368000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<95.504000,0.000000,23.368000>}
box{<0,0,-0.508000><6.604000,0.035000,0.508000> rotate<0,0.000000,0> translate<88.900000,0.000000,23.368000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<88.900000,0.000000,25.908000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<95.504000,0.000000,25.908000>}
box{<0,0,-0.406400><6.604000,0.035000,0.406400> rotate<0,0.000000,0> translate<88.900000,0.000000,25.908000> }
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<89.281000,0.000000,46.355000>}
cylinder{<0,0,0><0,0.035000,0>0.508000 translate<95.504000,0.000000,46.355000>}
box{<0,0,-0.508000><6.223000,0.035000,0.508000> rotate<0,0.000000,0> translate<89.281000,0.000000,46.355000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<89.281000,0.000000,48.895000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<95.504000,0.000000,48.895000>}
box{<0,0,-0.406400><6.223000,0.035000,0.406400> rotate<0,0.000000,0> translate<89.281000,0.000000,48.895000> }
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
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<15.240000,0.000000,7.620000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<15.240000,0.000000,60.960000>}
box{<0,0,-0.406400><53.340000,0.035000,0.406400> rotate<0,90.000000,0> translate<15.240000,0.000000,60.960000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<15.240000,0.000000,7.620000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<100.330000,0.000000,7.620000>}
box{<0,0,-0.406400><85.090000,0.035000,0.406400> rotate<0,0.000000,0> translate<15.240000,0.000000,7.620000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<15.240000,-1.535000,8.890000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<15.240000,-1.535000,60.960000>}
box{<0,0,-0.406400><52.070000,0.035000,0.406400> rotate<0,90.000000,0> translate<15.240000,-1.535000,60.960000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<15.240000,-1.535000,8.890000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<100.330000,-1.535000,8.890000>}
box{<0,0,-0.406400><85.090000,0.035000,0.406400> rotate<0,0.000000,0> translate<15.240000,-1.535000,8.890000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<15.240000,0.000000,60.960000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<100.330000,0.000000,60.960000>}
box{<0,0,-0.406400><85.090000,0.035000,0.406400> rotate<0,0.000000,0> translate<15.240000,0.000000,60.960000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<15.240000,-1.535000,60.960000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<100.330000,-1.535000,60.960000>}
box{<0,0,-0.406400><85.090000,0.035000,0.406400> rotate<0,0.000000,0> translate<15.240000,-1.535000,60.960000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<100.330000,0.000000,60.960000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<100.330000,0.000000,7.620000>}
box{<0,0,-0.406400><53.340000,0.035000,0.406400> rotate<0,-90.000000,0> translate<100.330000,0.000000,7.620000> }
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<100.330000,-1.535000,60.960000>}
cylinder{<0,0,0><0,0.035000,0>0.406400 translate<100.330000,-1.535000,8.890000>}
box{<0,0,-0.406400><52.070000,0.035000,0.406400> rotate<0,-90.000000,0> translate<100.330000,-1.535000,8.890000> }
texture{col_pol}
}
#end
union{
cylinder{<34.798000,0.038000,28.956000><34.798000,-1.538000,28.956000>0.406400}
cylinder{<39.878000,0.038000,28.956000><39.878000,-1.538000,28.956000>0.406400}
cylinder{<34.798000,0.038000,39.624000><34.798000,-1.538000,39.624000>0.406400}
cylinder{<39.878000,0.038000,39.624000><39.878000,-1.538000,39.624000>0.406400}
cylinder{<39.878000,0.038000,32.512000><39.878000,-1.538000,32.512000>0.406400}
cylinder{<34.798000,0.038000,32.512000><34.798000,-1.538000,32.512000>0.406400}
cylinder{<71.882000,0.038000,29.210000><71.882000,-1.538000,29.210000>0.406400}
cylinder{<66.802000,0.038000,29.210000><66.802000,-1.538000,29.210000>0.406400}
cylinder{<71.882000,0.038000,37.592000><71.882000,-1.538000,37.592000>0.406400}
cylinder{<66.802000,0.038000,37.592000><66.802000,-1.538000,37.592000>0.406400}
cylinder{<27.178000,0.038000,12.446000><27.178000,-1.538000,12.446000>0.406400}
cylinder{<27.178000,0.038000,17.526000><27.178000,-1.538000,17.526000>0.406400}
cylinder{<39.878000,0.038000,36.068000><39.878000,-1.538000,36.068000>0.406400}
cylinder{<34.798000,0.038000,36.068000><34.798000,-1.538000,36.068000>0.406400}
cylinder{<80.518000,0.038000,12.192000><80.518000,-1.538000,12.192000>0.406400}
cylinder{<80.518000,0.038000,17.272000><80.518000,-1.538000,17.272000>0.406400}
cylinder{<36.068000,0.038000,14.986000><36.068000,-1.538000,14.986000>0.508000}
cylinder{<36.068000,0.038000,20.066000><36.068000,-1.538000,20.066000>0.508000}
cylinder{<74.422000,0.038000,13.208000><74.422000,-1.538000,13.208000>0.406400}
cylinder{<74.422000,0.038000,16.764000><74.422000,-1.538000,16.764000>0.406400}
cylinder{<70.231000,0.038000,20.320000><70.231000,-1.538000,20.320000>0.406400}
cylinder{<68.326000,0.038000,19.050000><68.326000,-1.538000,19.050000>0.406400}
cylinder{<68.326000,0.038000,21.590000><68.326000,-1.538000,21.590000>0.406400}
cylinder{<24.384000,0.038000,46.863000><24.384000,-1.538000,46.863000>0.444500}
cylinder{<26.924000,0.038000,45.593000><26.924000,-1.538000,45.593000>0.444500}
cylinder{<24.384000,0.038000,44.323000><24.384000,-1.538000,44.323000>0.444500}
cylinder{<26.924000,0.038000,43.053000><26.924000,-1.538000,43.053000>0.444500}
cylinder{<24.384000,0.038000,41.783000><24.384000,-1.538000,41.783000>0.444500}
cylinder{<26.924000,0.038000,40.513000><26.924000,-1.538000,40.513000>0.444500}
cylinder{<24.384000,0.038000,39.243000><24.384000,-1.538000,39.243000>0.444500}
cylinder{<26.924000,0.038000,37.973000><26.924000,-1.538000,37.973000>0.444500}
cylinder{<24.384000,0.038000,31.242000><24.384000,-1.538000,31.242000>0.444500}
cylinder{<26.924000,0.038000,29.972000><26.924000,-1.538000,29.972000>0.444500}
cylinder{<24.384000,0.038000,28.702000><24.384000,-1.538000,28.702000>0.444500}
cylinder{<26.924000,0.038000,27.432000><26.924000,-1.538000,27.432000>0.444500}
cylinder{<24.384000,0.038000,26.162000><24.384000,-1.538000,26.162000>0.444500}
cylinder{<26.924000,0.038000,24.892000><26.924000,-1.538000,24.892000>0.444500}
cylinder{<24.384000,0.038000,23.622000><24.384000,-1.538000,23.622000>0.444500}
cylinder{<26.924000,0.038000,22.352000><26.924000,-1.538000,22.352000>0.444500}
cylinder{<68.326000,0.038000,15.494000><68.326000,-1.538000,15.494000>0.457200}
cylinder{<68.326000,0.038000,12.954000><68.326000,-1.538000,12.954000>0.457200}
cylinder{<85.725000,0.038000,14.478000><85.725000,-1.538000,14.478000>0.406400}
cylinder{<88.265000,0.038000,14.478000><88.265000,-1.538000,14.478000>0.406400}
cylinder{<95.504000,0.038000,23.368000><95.504000,-1.538000,23.368000>0.406400}
cylinder{<95.504000,0.038000,25.908000><95.504000,-1.538000,25.908000>0.406400}
cylinder{<88.900000,0.038000,25.908000><88.900000,-1.538000,25.908000>0.406400}
cylinder{<88.900000,0.038000,23.368000><88.900000,-1.538000,23.368000>0.406400}
cylinder{<95.504000,0.038000,48.895000><95.504000,-1.538000,48.895000>0.406400}
cylinder{<95.504000,0.038000,46.355000><95.504000,-1.538000,46.355000>0.406400}
cylinder{<88.646000,0.038000,46.609000><88.646000,-1.538000,46.609000>0.406400}
cylinder{<88.646000,0.038000,49.149000><88.646000,-1.538000,49.149000>0.406400}
cylinder{<56.642000,0.038000,35.991800><56.642000,-1.538000,35.991800>0.406400}
cylinder{<49.301400,0.038000,30.734000><49.301400,-1.538000,30.734000>0.406400}
cylinder{<49.784000,0.038000,37.211000><49.784000,-1.538000,37.211000>0.406400}
cylinder{<62.230000,0.038000,14.732000><62.230000,-1.538000,14.732000>0.800000}
cylinder{<57.150000,0.038000,14.732000><57.150000,-1.538000,14.732000>0.800000}
cylinder{<52.070000,0.038000,14.732000><52.070000,-1.538000,14.732000>0.800000}
cylinder{<46.990000,0.038000,14.732000><46.990000,-1.538000,14.732000>0.800000}
cylinder{<73.660000,0.038000,32.131000><73.660000,-1.538000,32.131000>0.406400}
cylinder{<66.040000,0.038000,32.131000><66.040000,-1.538000,32.131000>0.406400}
cylinder{<73.660000,0.038000,34.671000><73.660000,-1.538000,34.671000>0.406400}
cylinder{<66.040000,0.038000,34.671000><66.040000,-1.538000,34.671000>0.406400}
cylinder{<56.515000,0.038000,20.828000><56.515000,-1.538000,20.828000>0.406400}
cylinder{<43.815000,0.038000,20.828000><43.815000,-1.538000,20.828000>0.406400}
cylinder{<33.528000,0.038000,25.908000><33.528000,-1.538000,25.908000>0.406400}
cylinder{<41.148000,0.038000,25.908000><41.148000,-1.538000,25.908000>0.406400}
cylinder{<81.280000,0.038000,30.480000><81.280000,-1.538000,30.480000>0.406400}
cylinder{<81.280000,0.038000,22.860000><81.280000,-1.538000,22.860000>0.406400}
cylinder{<83.566000,0.038000,19.050000><83.566000,-1.538000,19.050000>0.406400}
cylinder{<91.186000,0.038000,19.050000><91.186000,-1.538000,19.050000>0.406400}
cylinder{<81.407000,0.038000,42.291000><81.407000,-1.538000,42.291000>0.406400}
cylinder{<81.407000,0.038000,49.911000><81.407000,-1.538000,49.911000>0.406400}
cylinder{<72.644000,0.038000,49.022000><72.644000,-1.538000,49.022000>0.406400}
cylinder{<67.564000,0.038000,49.022000><67.564000,-1.538000,49.022000>0.406400}
cylinder{<70.104000,0.038000,46.482000><70.104000,-1.538000,46.482000>0.406400}
cylinder{<56.642000,0.038000,46.863000><56.642000,-1.538000,46.863000>0.406400}
cylinder{<43.942000,0.038000,46.863000><43.942000,-1.538000,46.863000>0.406400}
cylinder{<33.401000,0.038000,42.926000><33.401000,-1.538000,42.926000>0.406400}
cylinder{<41.021000,0.038000,42.926000><41.021000,-1.538000,42.926000>0.406400}
cylinder{<44.450000,0.038000,56.007000><44.450000,-1.538000,56.007000>0.457200}
cylinder{<44.450000,0.038000,53.467000><44.450000,-1.538000,53.467000>0.457200}
cylinder{<41.910000,0.038000,56.007000><41.910000,-1.538000,56.007000>0.457200}
cylinder{<41.910000,0.038000,53.467000><41.910000,-1.538000,53.467000>0.457200}
cylinder{<39.370000,0.038000,56.007000><39.370000,-1.538000,56.007000>0.457200}
cylinder{<39.370000,0.038000,53.467000><39.370000,-1.538000,53.467000>0.457200}
cylinder{<36.830000,0.038000,56.007000><36.830000,-1.538000,56.007000>0.457200}
cylinder{<36.830000,0.038000,53.467000><36.830000,-1.538000,53.467000>0.457200}
cylinder{<34.290000,0.038000,56.007000><34.290000,-1.538000,56.007000>0.457200}
cylinder{<34.290000,0.038000,53.467000><34.290000,-1.538000,53.467000>0.457200}
cylinder{<90.424000,0.038000,30.382000><90.424000,-1.538000,30.382000>0.850000}
cylinder{<90.424000,0.038000,34.342000><90.424000,-1.538000,34.342000>0.850000}
cylinder{<90.424000,0.038000,38.302000><90.424000,-1.538000,38.302000>0.850000}
cylinder{<90.424000,0.038000,42.262000><90.424000,-1.538000,42.262000>0.850000}
cylinder{<19.939000,0.038000,44.958000><19.939000,-1.538000,44.958000>0.500000}
cylinder{<19.939000,0.038000,42.418000><19.939000,-1.538000,42.418000>0.500000}
cylinder{<19.939000,0.038000,39.878000><19.939000,-1.538000,39.878000>0.500000}
cylinder{<19.939000,0.038000,29.337000><19.939000,-1.538000,29.337000>0.500000}
cylinder{<19.939000,0.038000,26.797000><19.939000,-1.538000,26.797000>0.500000}
cylinder{<19.939000,0.038000,24.257000><19.939000,-1.538000,24.257000>0.500000}
//Holes(fast)/Vias
cylinder{<46.228000,0.038000,25.146000><46.228000,-1.538000,25.146000>0.350000 }
cylinder{<84.074000,0.038000,27.914600><84.074000,-1.538000,27.914600>0.300000 }
cylinder{<84.201000,0.038000,39.801800><84.201000,-1.538000,39.801800>0.300000 }
cylinder{<55.549800,0.038000,29.870400><55.549800,-1.538000,29.870400>0.304800 }
cylinder{<44.297600,0.038000,39.852600><44.297600,-1.538000,39.852600>0.304800 }
cylinder{<49.834800,0.038000,43.484800><49.834800,-1.538000,43.484800>0.304800 }
cylinder{<54.635400,0.038000,20.396200><54.635400,-1.538000,20.396200>0.304800 }
cylinder{<47.777400,0.038000,20.396200><47.777400,-1.538000,20.396200>0.304800 }
cylinder{<36.322000,0.038000,50.038000><36.322000,-1.538000,50.038000>0.304800 }
cylinder{<61.722000,0.038000,47.472600><61.722000,-1.538000,47.472600>0.304800 }
cylinder{<61.722000,0.038000,45.364400><61.722000,-1.538000,45.364400>0.304800 }
cylinder{<59.588400,0.038000,39.674800><59.588400,-1.538000,39.674800>0.304800 }
cylinder{<50.266600,0.038000,23.469600><50.266600,-1.538000,23.469600>0.304800 }
cylinder{<60.502800,0.038000,30.607000><60.502800,-1.538000,30.607000>0.304800 }
cylinder{<60.502800,0.038000,38.100000><60.502800,-1.538000,38.100000>0.304800 }
cylinder{<49.022000,0.038000,39.471600><49.022000,-1.538000,39.471600>0.304800 }
cylinder{<50.266600,0.038000,27.127200><50.266600,-1.538000,27.127200>0.304800 }
//Holes(fast)/Board
texture{col_hls}
}
#if(pcb_silkscreen=on)
//Silk Screen
union{
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.173500,0.000000,57.820100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.876900,0.000000,58.116700>}
box{<0,0,-0.076200><0.419456,0.036000,0.076200> rotate<0,44.997030,0> translate<50.876900,0.000000,58.116700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.876900,0.000000,58.116700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.283700,0.000000,58.116700>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,0.000000,0> translate<50.283700,0.000000,58.116700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.283700,0.000000,58.116700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.987200,0.000000,57.820100>}
box{<0,0,-0.076200><0.419385,0.036000,0.076200> rotate<0,-45.006690,0> translate<49.987200,0.000000,57.820100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.987200,0.000000,57.820100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.987200,0.000000,57.523500>}
box{<0,0,-0.076200><0.296600,0.036000,0.076200> rotate<0,-90.000000,0> translate<49.987200,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.987200,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.283700,0.000000,57.226900>}
box{<0,0,-0.076200><0.419385,0.036000,0.076200> rotate<0,45.006690,0> translate<49.987200,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.283700,0.000000,57.226900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.876900,0.000000,57.226900>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,0.000000,0> translate<50.283700,0.000000,57.226900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.876900,0.000000,57.226900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.173500,0.000000,56.930300>}
box{<0,0,-0.076200><0.419456,0.036000,0.076200> rotate<0,44.997030,0> translate<50.876900,0.000000,57.226900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.173500,0.000000,56.930300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.173500,0.000000,56.633700>}
box{<0,0,-0.076200><0.296600,0.036000,0.076200> rotate<0,-90.000000,0> translate<51.173500,0.000000,56.633700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.173500,0.000000,56.633700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.876900,0.000000,56.337200>}
box{<0,0,-0.076200><0.419385,0.036000,0.076200> rotate<0,-44.987370,0> translate<50.876900,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.876900,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.283700,0.000000,56.337200>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,0.000000,0> translate<50.283700,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.283700,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.987200,0.000000,56.633700>}
box{<0,0,-0.076200><0.419314,0.036000,0.076200> rotate<0,44.997030,0> translate<49.987200,0.000000,56.633700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.061100,0.000000,57.820100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.061100,0.000000,56.633700>}
box{<0,0,-0.076200><1.186400,0.036000,0.076200> rotate<0,-90.000000,0> translate<52.061100,0.000000,56.633700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.061100,0.000000,56.633700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.357700,0.000000,56.337200>}
box{<0,0,-0.076200><0.419385,0.036000,0.076200> rotate<0,44.987370,0> translate<52.061100,0.000000,56.633700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.764600,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.357700,0.000000,57.523500>}
box{<0,0,-0.076200><0.593100,0.036000,0.076200> rotate<0,0.000000,0> translate<51.764600,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.839200,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.246000,0.000000,56.337200>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,0.000000,0> translate<53.246000,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.246000,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.949500,0.000000,56.633700>}
box{<0,0,-0.076200><0.419314,0.036000,0.076200> rotate<0,44.997030,0> translate<52.949500,0.000000,56.633700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.949500,0.000000,56.633700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.949500,0.000000,57.226900>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,90.000000,0> translate<52.949500,0.000000,57.226900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.949500,0.000000,57.226900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.246000,0.000000,57.523500>}
box{<0,0,-0.076200><0.419385,0.036000,0.076200> rotate<0,-45.006690,0> translate<52.949500,0.000000,57.226900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.246000,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.839200,0.000000,57.523500>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,0.000000,0> translate<53.246000,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.839200,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.135800,0.000000,57.226900>}
box{<0,0,-0.076200><0.419456,0.036000,0.076200> rotate<0,44.997030,0> translate<53.839200,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.135800,0.000000,57.226900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.135800,0.000000,56.930300>}
box{<0,0,-0.076200><0.296600,0.036000,0.076200> rotate<0,-90.000000,0> translate<54.135800,0.000000,56.930300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.135800,0.000000,56.930300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.949500,0.000000,56.930300>}
box{<0,0,-0.076200><1.186300,0.036000,0.076200> rotate<0,0.000000,0> translate<52.949500,0.000000,56.930300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.726900,0.000000,55.744100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.726900,0.000000,57.523500>}
box{<0,0,-0.076200><1.779400,0.036000,0.076200> rotate<0,90.000000,0> translate<54.726900,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.726900,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.616600,0.000000,57.523500>}
box{<0,0,-0.076200><0.889700,0.036000,0.076200> rotate<0,0.000000,0> translate<54.726900,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.616600,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.913200,0.000000,57.226900>}
box{<0,0,-0.076200><0.419456,0.036000,0.076200> rotate<0,44.997030,0> translate<55.616600,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.913200,0.000000,57.226900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.913200,0.000000,56.633700>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,-90.000000,0> translate<55.913200,0.000000,56.633700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.913200,0.000000,56.633700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.616600,0.000000,56.337200>}
box{<0,0,-0.076200><0.419385,0.036000,0.076200> rotate<0,-44.987370,0> translate<55.616600,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.616600,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.726900,0.000000,56.337200>}
box{<0,0,-0.076200><0.889700,0.036000,0.076200> rotate<0,0.000000,0> translate<54.726900,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.504300,0.000000,55.744100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.504300,0.000000,57.523500>}
box{<0,0,-0.076200><1.779400,0.036000,0.076200> rotate<0,90.000000,0> translate<56.504300,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.504300,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.394000,0.000000,57.523500>}
box{<0,0,-0.076200><0.889700,0.036000,0.076200> rotate<0,0.000000,0> translate<56.504300,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.394000,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.690600,0.000000,57.226900>}
box{<0,0,-0.076200><0.419456,0.036000,0.076200> rotate<0,44.997030,0> translate<57.394000,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.690600,0.000000,57.226900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.690600,0.000000,56.633700>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,-90.000000,0> translate<57.690600,0.000000,56.633700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.690600,0.000000,56.633700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.394000,0.000000,56.337200>}
box{<0,0,-0.076200><0.419385,0.036000,0.076200> rotate<0,-44.987370,0> translate<57.394000,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.394000,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.504300,0.000000,56.337200>}
box{<0,0,-0.076200><0.889700,0.036000,0.076200> rotate<0,0.000000,0> translate<56.504300,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.171400,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.578200,0.000000,56.337200>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,0.000000,0> translate<58.578200,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.578200,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.281700,0.000000,56.633700>}
box{<0,0,-0.076200><0.419314,0.036000,0.076200> rotate<0,44.997030,0> translate<58.281700,0.000000,56.633700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.281700,0.000000,56.633700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.281700,0.000000,57.226900>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,90.000000,0> translate<58.281700,0.000000,57.226900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.281700,0.000000,57.226900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.578200,0.000000,57.523500>}
box{<0,0,-0.076200><0.419385,0.036000,0.076200> rotate<0,-45.006690,0> translate<58.281700,0.000000,57.226900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.578200,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.171400,0.000000,57.523500>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,0.000000,0> translate<58.578200,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.171400,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.468000,0.000000,57.226900>}
box{<0,0,-0.076200><0.419456,0.036000,0.076200> rotate<0,44.997030,0> translate<59.171400,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.468000,0.000000,57.226900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.468000,0.000000,56.930300>}
box{<0,0,-0.076200><0.296600,0.036000,0.076200> rotate<0,-90.000000,0> translate<59.468000,0.000000,56.930300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.468000,0.000000,56.930300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.281700,0.000000,56.930300>}
box{<0,0,-0.076200><1.186300,0.036000,0.076200> rotate<0,0.000000,0> translate<58.281700,0.000000,56.930300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.059100,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.059100,0.000000,57.523500>}
box{<0,0,-0.076200><1.186300,0.036000,0.076200> rotate<0,90.000000,0> translate<60.059100,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.059100,0.000000,56.930300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.652200,0.000000,57.523500>}
box{<0,0,-0.076200><0.838841,0.036000,0.076200> rotate<0,-45.001860,0> translate<60.059100,0.000000,56.930300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.652200,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.948800,0.000000,57.523500>}
box{<0,0,-0.076200><0.296600,0.036000,0.076200> rotate<0,0.000000,0> translate<60.652200,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<63.317700,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<63.317700,0.000000,58.116700>}
box{<0,0,-0.076200><1.779500,0.036000,0.076200> rotate<0,90.000000,0> translate<63.317700,0.000000,58.116700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<63.317700,0.000000,58.116700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<63.910800,0.000000,57.523500>}
box{<0,0,-0.076200><0.838841,0.036000,0.076200> rotate<0,45.001860,0> translate<63.317700,0.000000,58.116700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<63.910800,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.504000,0.000000,58.116700>}
box{<0,0,-0.076200><0.838911,0.036000,0.076200> rotate<0,-44.997030,0> translate<63.910800,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.504000,0.000000,58.116700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.504000,0.000000,56.337200>}
box{<0,0,-0.076200><1.779500,0.036000,0.076200> rotate<0,-90.000000,0> translate<64.504000,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.391600,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.984800,0.000000,56.337200>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,0.000000,0> translate<65.391600,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.984800,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.281400,0.000000,56.633700>}
box{<0,0,-0.076200><0.419385,0.036000,0.076200> rotate<0,-44.987370,0> translate<65.984800,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.281400,0.000000,56.633700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.281400,0.000000,57.226900>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,90.000000,0> translate<66.281400,0.000000,57.226900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.281400,0.000000,57.226900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.984800,0.000000,57.523500>}
box{<0,0,-0.076200><0.419456,0.036000,0.076200> rotate<0,44.997030,0> translate<65.984800,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.984800,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.391600,0.000000,57.523500>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,0.000000,0> translate<65.391600,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.391600,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.095100,0.000000,57.226900>}
box{<0,0,-0.076200><0.419385,0.036000,0.076200> rotate<0,-45.006690,0> translate<65.095100,0.000000,57.226900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.095100,0.000000,57.226900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.095100,0.000000,56.633700>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,-90.000000,0> translate<65.095100,0.000000,56.633700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.095100,0.000000,56.633700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.391600,0.000000,56.337200>}
box{<0,0,-0.076200><0.419314,0.036000,0.076200> rotate<0,44.997030,0> translate<65.095100,0.000000,56.633700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.169000,0.000000,57.820100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.169000,0.000000,56.633700>}
box{<0,0,-0.076200><1.186400,0.036000,0.076200> rotate<0,-90.000000,0> translate<67.169000,0.000000,56.633700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.169000,0.000000,56.633700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.465600,0.000000,56.337200>}
box{<0,0,-0.076200><0.419385,0.036000,0.076200> rotate<0,44.987370,0> translate<67.169000,0.000000,56.633700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.872500,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.465600,0.000000,57.523500>}
box{<0,0,-0.076200><0.593100,0.036000,0.076200> rotate<0,0.000000,0> translate<66.872500,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.353900,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.947100,0.000000,56.337200>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,0.000000,0> translate<68.353900,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.947100,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.243700,0.000000,56.633700>}
box{<0,0,-0.076200><0.419385,0.036000,0.076200> rotate<0,-44.987370,0> translate<68.947100,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.243700,0.000000,56.633700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.243700,0.000000,57.226900>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,90.000000,0> translate<69.243700,0.000000,57.226900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.243700,0.000000,57.226900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.947100,0.000000,57.523500>}
box{<0,0,-0.076200><0.419456,0.036000,0.076200> rotate<0,44.997030,0> translate<68.947100,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.947100,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.353900,0.000000,57.523500>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,0.000000,0> translate<68.353900,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.353900,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.057400,0.000000,57.226900>}
box{<0,0,-0.076200><0.419385,0.036000,0.076200> rotate<0,-45.006690,0> translate<68.057400,0.000000,57.226900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.057400,0.000000,57.226900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.057400,0.000000,56.633700>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,-90.000000,0> translate<68.057400,0.000000,56.633700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.057400,0.000000,56.633700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.353900,0.000000,56.337200>}
box{<0,0,-0.076200><0.419314,0.036000,0.076200> rotate<0,44.997030,0> translate<68.057400,0.000000,56.633700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.834800,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.834800,0.000000,57.523500>}
box{<0,0,-0.076200><1.186300,0.036000,0.076200> rotate<0,90.000000,0> translate<69.834800,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.834800,0.000000,56.930300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.427900,0.000000,57.523500>}
box{<0,0,-0.076200><0.838841,0.036000,0.076200> rotate<0,-45.001860,0> translate<69.834800,0.000000,56.930300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.427900,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.724500,0.000000,57.523500>}
box{<0,0,-0.076200><0.296600,0.036000,0.076200> rotate<0,0.000000,0> translate<70.427900,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.093400,0.000000,58.116700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.093400,0.000000,56.337200>}
box{<0,0,-0.076200><1.779500,0.036000,0.076200> rotate<0,-90.000000,0> translate<73.093400,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.093400,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.983100,0.000000,56.337200>}
box{<0,0,-0.076200><0.889700,0.036000,0.076200> rotate<0,0.000000,0> translate<73.093400,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.983100,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<74.279700,0.000000,56.633700>}
box{<0,0,-0.076200><0.419385,0.036000,0.076200> rotate<0,-44.987370,0> translate<73.983100,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<74.279700,0.000000,56.633700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<74.279700,0.000000,57.820100>}
box{<0,0,-0.076200><1.186400,0.036000,0.076200> rotate<0,90.000000,0> translate<74.279700,0.000000,57.820100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<74.279700,0.000000,57.820100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.983100,0.000000,58.116700>}
box{<0,0,-0.076200><0.419456,0.036000,0.076200> rotate<0,44.997030,0> translate<73.983100,0.000000,58.116700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.983100,0.000000,58.116700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.093400,0.000000,58.116700>}
box{<0,0,-0.076200><0.889700,0.036000,0.076200> rotate<0,0.000000,0> translate<73.093400,0.000000,58.116700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<74.870800,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<74.870800,0.000000,57.523500>}
box{<0,0,-0.076200><1.186300,0.036000,0.076200> rotate<0,90.000000,0> translate<74.870800,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<74.870800,0.000000,56.930300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<75.463900,0.000000,57.523500>}
box{<0,0,-0.076200><0.838841,0.036000,0.076200> rotate<0,-45.001860,0> translate<74.870800,0.000000,56.930300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<75.463900,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<75.760500,0.000000,57.523500>}
box{<0,0,-0.076200><0.296600,0.036000,0.076200> rotate<0,0.000000,0> translate<75.463900,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.352000,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.648500,0.000000,57.523500>}
box{<0,0,-0.076200><0.296500,0.036000,0.076200> rotate<0,0.000000,0> translate<76.352000,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.648500,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.648500,0.000000,56.337200>}
box{<0,0,-0.076200><1.186300,0.036000,0.076200> rotate<0,-90.000000,0> translate<76.648500,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.352000,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.945100,0.000000,56.337200>}
box{<0,0,-0.076200><0.593100,0.036000,0.076200> rotate<0,0.000000,0> translate<76.352000,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.648500,0.000000,58.413300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<76.648500,0.000000,58.116700>}
box{<0,0,-0.076200><0.296600,0.036000,0.076200> rotate<0,-90.000000,0> translate<76.648500,0.000000,58.116700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<77.536900,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.130000,0.000000,56.337200>}
box{<0,0,-0.076200><1.326301,0.036000,0.076200> rotate<0,63.432694,0> translate<77.536900,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.130000,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.723200,0.000000,57.523500>}
box{<0,0,-0.076200><1.326346,0.036000,0.076200> rotate<0,-63.428831,0> translate<78.130000,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.204000,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<79.610800,0.000000,56.337200>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,0.000000,0> translate<79.610800,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<79.610800,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<79.314300,0.000000,56.633700>}
box{<0,0,-0.076200><0.419314,0.036000,0.076200> rotate<0,44.997030,0> translate<79.314300,0.000000,56.633700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<79.314300,0.000000,56.633700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<79.314300,0.000000,57.226900>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,90.000000,0> translate<79.314300,0.000000,57.226900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<79.314300,0.000000,57.226900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<79.610800,0.000000,57.523500>}
box{<0,0,-0.076200><0.419385,0.036000,0.076200> rotate<0,-45.006690,0> translate<79.314300,0.000000,57.226900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<79.610800,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.204000,0.000000,57.523500>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,0.000000,0> translate<79.610800,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.204000,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.500600,0.000000,57.226900>}
box{<0,0,-0.076200><0.419456,0.036000,0.076200> rotate<0,44.997030,0> translate<80.204000,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.500600,0.000000,57.226900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.500600,0.000000,56.930300>}
box{<0,0,-0.076200><0.296600,0.036000,0.076200> rotate<0,-90.000000,0> translate<80.500600,0.000000,56.930300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.500600,0.000000,56.930300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<79.314300,0.000000,56.930300>}
box{<0,0,-0.076200><1.186300,0.036000,0.076200> rotate<0,0.000000,0> translate<79.314300,0.000000,56.930300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.091700,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.091700,0.000000,57.523500>}
box{<0,0,-0.076200><1.186300,0.036000,0.076200> rotate<0,90.000000,0> translate<81.091700,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.091700,0.000000,56.930300>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.684800,0.000000,57.523500>}
box{<0,0,-0.076200><0.838841,0.036000,0.076200> rotate<0,-45.001860,0> translate<81.091700,0.000000,56.930300> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.684800,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.981400,0.000000,57.523500>}
box{<0,0,-0.076200><0.296600,0.036000,0.076200> rotate<0,0.000000,0> translate<81.684800,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<84.350300,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<84.943400,0.000000,56.337200>}
box{<0,0,-0.076200><1.326301,0.036000,0.076200> rotate<0,63.432694,0> translate<84.350300,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<84.943400,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<85.536600,0.000000,57.523500>}
box{<0,0,-0.076200><1.326346,0.036000,0.076200> rotate<0,-63.428831,0> translate<84.943400,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.314000,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.127700,0.000000,56.337200>}
box{<0,0,-0.076200><1.186300,0.036000,0.076200> rotate<0,0.000000,0> translate<86.127700,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.127700,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.314000,0.000000,57.523500>}
box{<0,0,-0.076200><1.677682,0.036000,0.076200> rotate<0,-44.997030,0> translate<86.127700,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.314000,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.314000,0.000000,57.820100>}
box{<0,0,-0.076200><0.296600,0.036000,0.076200> rotate<0,90.000000,0> translate<87.314000,0.000000,57.820100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.314000,0.000000,57.820100>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.017400,0.000000,58.116700>}
box{<0,0,-0.076200><0.419456,0.036000,0.076200> rotate<0,44.997030,0> translate<87.017400,0.000000,58.116700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.017400,0.000000,58.116700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.424200,0.000000,58.116700>}
box{<0,0,-0.076200><0.593200,0.036000,0.076200> rotate<0,0.000000,0> translate<86.424200,0.000000,58.116700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.424200,0.000000,58.116700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<86.127700,0.000000,57.820100>}
box{<0,0,-0.076200><0.419385,0.036000,0.076200> rotate<0,-45.006690,0> translate<86.127700,0.000000,57.820100> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.905100,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.905100,0.000000,56.633700>}
box{<0,0,-0.076200><0.296500,0.036000,0.076200> rotate<0,90.000000,0> translate<87.905100,0.000000,56.633700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.905100,0.000000,56.633700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.201600,0.000000,56.633700>}
box{<0,0,-0.076200><0.296500,0.036000,0.076200> rotate<0,0.000000,0> translate<87.905100,0.000000,56.633700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.201600,0.000000,56.633700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.201600,0.000000,56.337200>}
box{<0,0,-0.076200><0.296500,0.036000,0.076200> rotate<0,-90.000000,0> translate<88.201600,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.201600,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<87.905100,0.000000,56.337200>}
box{<0,0,-0.076200><0.296500,0.036000,0.076200> rotate<0,0.000000,0> translate<87.905100,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.793800,0.000000,57.523500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<89.386900,0.000000,58.116700>}
box{<0,0,-0.076200><0.838841,0.036000,0.076200> rotate<0,-45.001860,0> translate<88.793800,0.000000,57.523500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<89.386900,0.000000,58.116700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<89.386900,0.000000,56.337200>}
box{<0,0,-0.076200><1.779500,0.036000,0.076200> rotate<0,-90.000000,0> translate<89.386900,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<88.793800,0.000000,56.337200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<89.980100,0.000000,56.337200>}
box{<0,0,-0.076200><1.186300,0.036000,0.076200> rotate<0,0.000000,0> translate<88.793800,0.000000,56.337200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.385700,0.000000,28.861000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.385700,0.000000,28.276300>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,-90.000000,0> translate<76.385700,0.000000,28.276300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.385700,0.000000,28.276300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.580600,0.000000,28.081500>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<76.385700,0.000000,28.276300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.580600,0.000000,28.081500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.970400,0.000000,28.081500>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<76.580600,0.000000,28.081500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.970400,0.000000,28.081500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,28.276300>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<76.970400,0.000000,28.081500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,28.276300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,28.861000>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,90.000000,0> translate<77.165200,0.000000,28.861000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,30.420100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,30.420100>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<75.995900,0.000000,30.420100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,30.420100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,31.004700>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<75.995900,0.000000,31.004700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,31.004700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,31.199600>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<75.995900,0.000000,31.004700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,31.199600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.580600,0.000000,31.199600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<76.190800,0.000000,31.199600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.580600,0.000000,31.199600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.775500,0.000000,31.004700>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<76.580600,0.000000,31.199600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.775500,0.000000,31.004700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.775500,0.000000,30.420100>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<76.775500,0.000000,30.420100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.775500,0.000000,30.809800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,31.199600>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<76.775500,0.000000,30.809800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,31.589400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,31.589400>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<75.995900,0.000000,31.589400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,31.589400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,32.174000>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<75.995900,0.000000,32.174000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,32.174000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,32.368900>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<75.995900,0.000000,32.174000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,32.368900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.580600,0.000000,32.368900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<76.190800,0.000000,32.368900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.580600,0.000000,32.368900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.775500,0.000000,32.174000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<76.580600,0.000000,32.368900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.775500,0.000000,32.174000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.775500,0.000000,31.589400>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<76.775500,0.000000,31.589400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.775500,0.000000,31.979100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,32.368900>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<76.775500,0.000000,31.979100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,32.758700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,32.758700>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<75.995900,0.000000,32.758700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,32.758700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,33.343300>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<75.995900,0.000000,33.343300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,33.343300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,33.538200>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<75.995900,0.000000,33.343300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,33.538200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.580600,0.000000,33.538200>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<76.190800,0.000000,33.538200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.580600,0.000000,33.538200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.775500,0.000000,33.343300>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<76.580600,0.000000,33.538200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.775500,0.000000,33.343300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.775500,0.000000,32.758700>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<76.775500,0.000000,32.758700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.775500,0.000000,33.148400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,33.538200>}
box{<0,0,-0.050800><0.551190,0.036000,0.050800> rotate<0,-45.004380,0> translate<76.775500,0.000000,33.148400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,33.928000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,33.928000>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<75.995900,0.000000,33.928000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,33.928000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,34.707500>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<75.995900,0.000000,34.707500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.580600,0.000000,33.928000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.580600,0.000000,34.317700>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<76.580600,0.000000,34.317700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,37.046100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,36.266600>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<77.165200,0.000000,36.266600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,36.266600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.385700,0.000000,37.046100>}
box{<0,0,-0.050800><1.102379,0.036000,0.050800> rotate<0,44.997030,0> translate<76.385700,0.000000,37.046100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.385700,0.000000,37.046100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,37.046100>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<76.190800,0.000000,37.046100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,37.046100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,36.851200>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<75.995900,0.000000,36.851200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,36.851200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,36.461400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<75.995900,0.000000,36.461400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,36.461400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,36.266600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<75.995900,0.000000,36.461400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.970400,0.000000,37.435900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,37.435900>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<76.190800,0.000000,37.435900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,37.435900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,37.630700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<75.995900,0.000000,37.630700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,37.630700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,38.020500>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<75.995900,0.000000,38.020500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,38.020500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,38.215400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<75.995900,0.000000,38.020500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,38.215400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.970400,0.000000,38.215400>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<76.190800,0.000000,38.215400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.970400,0.000000,38.215400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,38.020500>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<76.970400,0.000000,38.215400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,38.020500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,37.630700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<77.165200,0.000000,37.630700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,37.630700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.970400,0.000000,37.435900>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<76.970400,0.000000,37.435900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.970400,0.000000,37.435900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,38.215400>}
box{<0,0,-0.050800><1.102450,0.036000,0.050800> rotate<0,44.993355,0> translate<76.190800,0.000000,38.215400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.970400,0.000000,38.605200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,38.605200>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<76.190800,0.000000,38.605200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,38.605200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,38.800000>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<75.995900,0.000000,38.800000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,38.800000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,39.189800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<75.995900,0.000000,39.189800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,39.189800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,39.384700>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<75.995900,0.000000,39.189800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,39.384700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.970400,0.000000,39.384700>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<76.190800,0.000000,39.384700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.970400,0.000000,39.384700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,39.189800>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<76.970400,0.000000,39.384700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,39.189800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,38.800000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<77.165200,0.000000,38.800000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,38.800000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.970400,0.000000,38.605200>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<76.970400,0.000000,38.605200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.970400,0.000000,38.605200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,39.384700>}
box{<0,0,-0.050800><1.102450,0.036000,0.050800> rotate<0,44.993355,0> translate<76.190800,0.000000,39.384700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,39.774500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,39.969300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<75.995900,0.000000,39.969300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,39.969300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,40.359100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<75.995900,0.000000,40.359100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<75.995900,0.000000,40.359100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,40.554000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<75.995900,0.000000,40.359100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,40.554000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.385700,0.000000,40.554000>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<76.190800,0.000000,40.554000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.385700,0.000000,40.554000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.580600,0.000000,40.359100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<76.385700,0.000000,40.554000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.580600,0.000000,40.359100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.775500,0.000000,40.554000>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<76.580600,0.000000,40.359100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.775500,0.000000,40.554000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.970400,0.000000,40.554000>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<76.775500,0.000000,40.554000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.970400,0.000000,40.554000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,40.359100>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<76.970400,0.000000,40.554000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,40.359100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,39.969300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<77.165200,0.000000,39.969300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.165200,0.000000,39.969300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.970400,0.000000,39.774500>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<76.970400,0.000000,39.774500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.970400,0.000000,39.774500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.775500,0.000000,39.774500>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<76.775500,0.000000,39.774500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.775500,0.000000,39.774500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.580600,0.000000,39.969300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<76.580600,0.000000,39.969300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.580600,0.000000,39.969300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.385700,0.000000,39.774500>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<76.385700,0.000000,39.774500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.385700,0.000000,39.774500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.190800,0.000000,39.774500>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<76.190800,0.000000,39.774500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.580600,0.000000,39.969300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<76.580600,0.000000,40.359100>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<76.580600,0.000000,40.359100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.900900,0.000000,26.182800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,26.182800>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<77.900900,0.000000,26.182800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,26.182800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,26.962300>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<79.070200,0.000000,26.962300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,27.352100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,27.546900>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,90.000000,0> translate<78.290700,0.000000,27.546900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,27.546900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,27.546900>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<78.290700,0.000000,27.546900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,27.352100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,27.741800>}
box{<0,0,-0.050800><0.389700,0.036000,0.050800> rotate<0,90.000000,0> translate<79.070200,0.000000,27.741800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.706000,0.000000,27.546900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.900900,0.000000,27.546900>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<77.706000,0.000000,27.546900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,28.911100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,28.326400>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,-90.000000,0> translate<78.290700,0.000000,28.326400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,28.326400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,28.131600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<78.290700,0.000000,28.326400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,28.131600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.875400,0.000000,28.131600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<78.485600,0.000000,28.131600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.875400,0.000000,28.131600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,28.326400>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<78.875400,0.000000,28.131600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,28.326400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,28.911100>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,90.000000,0> translate<79.070200,0.000000,28.911100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,29.885500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,29.495700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<79.070200,0.000000,29.495700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,29.495700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.875400,0.000000,29.300900>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<78.875400,0.000000,29.300900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.875400,0.000000,29.300900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,29.300900>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<78.485600,0.000000,29.300900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,29.300900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,29.495700>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<78.290700,0.000000,29.495700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,29.495700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,29.885500>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<78.290700,0.000000,29.885500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,29.885500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,30.080400>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<78.290700,0.000000,29.885500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,30.080400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.680500,0.000000,30.080400>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<78.485600,0.000000,30.080400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.680500,0.000000,30.080400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.680500,0.000000,29.300900>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<78.680500,0.000000,29.300900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,30.470200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,30.470200>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,0.000000,0> translate<78.290700,0.000000,30.470200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,30.470200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,31.054800>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<78.290700,0.000000,31.054800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,31.054800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,31.249700>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<78.290700,0.000000,31.054800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,31.249700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,31.249700>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,0.000000,0> translate<78.485600,0.000000,31.249700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,31.639500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,32.224100>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<79.070200,0.000000,32.224100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,32.224100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.875400,0.000000,32.419000>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<78.875400,0.000000,32.419000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.875400,0.000000,32.419000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.680500,0.000000,32.224100>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<78.680500,0.000000,32.224100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.680500,0.000000,32.224100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.680500,0.000000,31.834300>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<78.680500,0.000000,31.834300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.680500,0.000000,31.834300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,31.639500>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,-44.982329,0> translate<78.485600,0.000000,31.639500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,31.639500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,31.834300>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<78.290700,0.000000,31.834300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,31.834300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,32.419000>}
box{<0,0,-0.050800><0.584700,0.036000,0.050800> rotate<0,90.000000,0> translate<78.290700,0.000000,32.419000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,33.393400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,33.003600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<79.070200,0.000000,33.003600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,33.003600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.875400,0.000000,32.808800>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<78.875400,0.000000,32.808800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.875400,0.000000,32.808800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,32.808800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<78.485600,0.000000,32.808800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,32.808800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,33.003600>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<78.290700,0.000000,33.003600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,33.003600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,33.393400>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<78.290700,0.000000,33.393400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,33.393400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,33.588300>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<78.290700,0.000000,33.393400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,33.588300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.680500,0.000000,33.588300>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<78.485600,0.000000,33.588300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.680500,0.000000,33.588300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.680500,0.000000,32.808800>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<78.680500,0.000000,32.808800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,33.978100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,34.172900>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,90.000000,0> translate<78.290700,0.000000,34.172900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,34.172900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,34.172900>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<78.290700,0.000000,34.172900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,34.172900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,33.978100>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,-90.000000,0> translate<78.485600,0.000000,33.978100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,33.978100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,33.978100>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<78.290700,0.000000,33.978100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.875400,0.000000,33.978100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.875400,0.000000,34.172900>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,90.000000,0> translate<78.875400,0.000000,34.172900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.875400,0.000000,34.172900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,34.172900>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<78.875400,0.000000,34.172900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,34.172900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,33.978100>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,-90.000000,0> translate<79.070200,0.000000,33.978100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,33.978100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.875400,0.000000,33.978100>}
box{<0,0,-0.050800><0.194800,0.036000,0.050800> rotate<0,0.000000,0> translate<78.875400,0.000000,33.978100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.095800,0.000000,36.511500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.900900,0.000000,36.316600>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<77.900900,0.000000,36.316600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.900900,0.000000,36.316600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.900900,0.000000,35.926800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<77.900900,0.000000,35.926800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.900900,0.000000,35.926800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.095800,0.000000,35.732000>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<77.900900,0.000000,35.926800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.095800,0.000000,35.732000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.875400,0.000000,35.732000>}
box{<0,0,-0.050800><0.779600,0.036000,0.050800> rotate<0,0.000000,0> translate<78.095800,0.000000,35.732000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.875400,0.000000,35.732000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,35.926800>}
box{<0,0,-0.050800><0.275489,0.036000,0.050800> rotate<0,-44.997030,0> translate<78.875400,0.000000,35.732000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,35.926800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,36.316600>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,90.000000,0> translate<79.070200,0.000000,36.316600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,36.316600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.875400,0.000000,36.511500>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,45.011732,0> translate<78.875400,0.000000,36.511500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.875400,0.000000,36.511500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,36.511500>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<78.485600,0.000000,36.511500> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,36.511500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,36.121700>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<78.485600,0.000000,36.121700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,36.901300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.900900,0.000000,36.901300>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<77.900900,0.000000,36.901300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.900900,0.000000,36.901300>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.900900,0.000000,37.485900>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,90.000000,0> translate<77.900900,0.000000,37.485900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.900900,0.000000,37.485900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.095800,0.000000,37.680800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<77.900900,0.000000,37.485900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.095800,0.000000,37.680800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,37.680800>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,0.000000,0> translate<78.095800,0.000000,37.680800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.485600,0.000000,37.680800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.680500,0.000000,37.485900>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,44.997030,0> translate<78.485600,0.000000,37.680800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.680500,0.000000,37.485900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.680500,0.000000,36.901300>}
box{<0,0,-0.050800><0.584600,0.036000,0.050800> rotate<0,-90.000000,0> translate<78.680500,0.000000,36.901300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.900900,0.000000,38.070600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,38.070600>}
box{<0,0,-0.050800><1.169300,0.036000,0.050800> rotate<0,0.000000,0> translate<77.900900,0.000000,38.070600> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,38.070600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,38.850100>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,90.000000,0> translate<79.070200,0.000000,38.850100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,39.239900>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,39.629600>}
box{<0,0,-0.050800><0.871485,0.036000,0.050800> rotate<0,-26.560358,0> translate<78.290700,0.000000,39.239900> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,39.629600>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,40.019400>}
box{<0,0,-0.050800><0.871530,0.036000,0.050800> rotate<0,26.566238,0> translate<78.290700,0.000000,40.019400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,41.188700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,40.409200>}
box{<0,0,-0.050800><0.779500,0.036000,0.050800> rotate<0,-90.000000,0> translate<79.070200,0.000000,40.409200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<79.070200,0.000000,40.409200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,41.188700>}
box{<0,0,-0.050800><1.102379,0.036000,0.050800> rotate<0,44.997030,0> translate<78.290700,0.000000,41.188700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.290700,0.000000,41.188700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.095800,0.000000,41.188700>}
box{<0,0,-0.050800><0.194900,0.036000,0.050800> rotate<0,0.000000,0> translate<78.095800,0.000000,41.188700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.095800,0.000000,41.188700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.900900,0.000000,40.993800>}
box{<0,0,-0.050800><0.275630,0.036000,0.050800> rotate<0,-44.997030,0> translate<77.900900,0.000000,40.993800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.900900,0.000000,40.993800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.900900,0.000000,40.604000>}
box{<0,0,-0.050800><0.389800,0.036000,0.050800> rotate<0,-90.000000,0> translate<77.900900,0.000000,40.604000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<77.900900,0.000000,40.604000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<78.095800,0.000000,40.409200>}
box{<0,0,-0.050800><0.275560,0.036000,0.050800> rotate<0,44.982329,0> translate<77.900900,0.000000,40.604000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<77.635100,0.000000,55.334700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<77.635100,0.000000,54.394100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<77.635100,0.000000,54.394100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<77.635100,0.000000,54.394100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.105400,0.000000,54.394100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<77.635100,0.000000,54.394100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.105400,0.000000,54.394100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.262100,0.000000,54.550800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<78.105400,0.000000,54.394100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.262100,0.000000,54.550800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.262100,0.000000,55.177900>}
box{<0,0,-0.038100><0.627100,0.036000,0.038100> rotate<0,90.000000,0> translate<78.262100,0.000000,55.177900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.262100,0.000000,55.177900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.105400,0.000000,55.334700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<78.105400,0.000000,55.334700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.105400,0.000000,55.334700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<77.635100,0.000000,55.334700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<77.635100,0.000000,55.334700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.040900,0.000000,54.394100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.727300,0.000000,54.394100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<78.727300,0.000000,54.394100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.727300,0.000000,54.394100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.570600,0.000000,54.550800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<78.570600,0.000000,54.550800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.570600,0.000000,54.550800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.570600,0.000000,54.864400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<78.570600,0.000000,54.864400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.570600,0.000000,54.864400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.727300,0.000000,55.021100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<78.570600,0.000000,54.864400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.727300,0.000000,55.021100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.040900,0.000000,55.021100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<78.727300,0.000000,55.021100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.040900,0.000000,55.021100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.197600,0.000000,54.864400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<79.040900,0.000000,55.021100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.197600,0.000000,54.864400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.197600,0.000000,54.707600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<79.197600,0.000000,54.707600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.197600,0.000000,54.707600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.570600,0.000000,54.707600>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<78.570600,0.000000,54.707600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.506100,0.000000,54.394100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.976400,0.000000,54.394100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<79.506100,0.000000,54.394100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.976400,0.000000,54.394100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.133100,0.000000,54.550800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<79.976400,0.000000,54.394100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.133100,0.000000,54.550800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.976400,0.000000,54.707600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<79.976400,0.000000,54.707600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.976400,0.000000,54.707600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.662800,0.000000,54.707600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<79.662800,0.000000,54.707600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.662800,0.000000,54.707600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.506100,0.000000,54.864400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<79.506100,0.000000,54.864400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.506100,0.000000,54.864400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.662800,0.000000,55.021100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<79.506100,0.000000,54.864400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.662800,0.000000,55.021100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.133100,0.000000,55.021100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<79.662800,0.000000,55.021100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.441600,0.000000,55.021100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.598300,0.000000,55.021100>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<80.441600,0.000000,55.021100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.598300,0.000000,55.021100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.598300,0.000000,54.394100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<80.598300,0.000000,54.394100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.441600,0.000000,54.394100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.755100,0.000000,54.394100>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<80.441600,0.000000,54.394100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.598300,0.000000,55.491400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.598300,0.000000,55.334700>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,-90.000000,0> translate<80.598300,0.000000,55.334700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.378700,0.000000,54.080600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.535500,0.000000,54.080600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<81.378700,0.000000,54.080600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.535500,0.000000,54.080600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.692200,0.000000,54.237400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<81.535500,0.000000,54.080600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.692200,0.000000,54.237400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.692200,0.000000,55.021100>}
box{<0,0,-0.038100><0.783700,0.036000,0.038100> rotate<0,90.000000,0> translate<81.692200,0.000000,55.021100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.692200,0.000000,55.021100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.221900,0.000000,55.021100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<81.221900,0.000000,55.021100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.221900,0.000000,55.021100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.065200,0.000000,54.864400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<81.065200,0.000000,54.864400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.065200,0.000000,54.864400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.065200,0.000000,54.550800>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<81.065200,0.000000,54.550800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.065200,0.000000,54.550800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.221900,0.000000,54.394100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<81.065200,0.000000,54.550800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.221900,0.000000,54.394100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.692200,0.000000,54.394100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<81.221900,0.000000,54.394100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.000700,0.000000,54.394100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.000700,0.000000,55.021100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<82.000700,0.000000,55.021100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.000700,0.000000,55.021100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.471000,0.000000,55.021100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<82.000700,0.000000,55.021100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.471000,0.000000,55.021100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.627700,0.000000,54.864400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<82.471000,0.000000,55.021100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.627700,0.000000,54.864400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.627700,0.000000,54.394100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<82.627700,0.000000,54.394100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.406500,0.000000,54.394100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.092900,0.000000,54.394100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<83.092900,0.000000,54.394100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.092900,0.000000,54.394100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.936200,0.000000,54.550800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<82.936200,0.000000,54.550800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.936200,0.000000,54.550800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.936200,0.000000,54.864400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<82.936200,0.000000,54.864400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.936200,0.000000,54.864400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.092900,0.000000,55.021100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<82.936200,0.000000,54.864400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.092900,0.000000,55.021100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.406500,0.000000,55.021100>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<83.092900,0.000000,55.021100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.406500,0.000000,55.021100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.563200,0.000000,54.864400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<83.406500,0.000000,55.021100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.563200,0.000000,54.864400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.563200,0.000000,54.707600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<83.563200,0.000000,54.707600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.563200,0.000000,54.707600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.936200,0.000000,54.707600>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<82.936200,0.000000,54.707600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.498700,0.000000,55.334700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.498700,0.000000,54.394100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<84.498700,0.000000,54.394100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.498700,0.000000,54.394100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.028400,0.000000,54.394100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<84.028400,0.000000,54.394100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.028400,0.000000,54.394100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.871700,0.000000,54.550800>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<83.871700,0.000000,54.550800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.871700,0.000000,54.550800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.871700,0.000000,54.864400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<83.871700,0.000000,54.864400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.871700,0.000000,54.864400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.028400,0.000000,55.021100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<83.871700,0.000000,54.864400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.028400,0.000000,55.021100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.498700,0.000000,55.021100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<84.028400,0.000000,55.021100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.742700,0.000000,54.394100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.742700,0.000000,55.334700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<85.742700,0.000000,55.334700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.742700,0.000000,55.334700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.213000,0.000000,55.334700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<85.742700,0.000000,55.334700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.213000,0.000000,55.334700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.369700,0.000000,55.177900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<86.213000,0.000000,55.334700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.369700,0.000000,55.177900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.369700,0.000000,55.021100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<86.369700,0.000000,55.021100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.369700,0.000000,55.021100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.213000,0.000000,54.864400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<86.213000,0.000000,54.864400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.213000,0.000000,54.864400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.369700,0.000000,54.707600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,45.015305,0> translate<86.213000,0.000000,54.864400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.369700,0.000000,54.707600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.369700,0.000000,54.550800>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<86.369700,0.000000,54.550800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.369700,0.000000,54.550800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.213000,0.000000,54.394100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<86.213000,0.000000,54.394100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.213000,0.000000,54.394100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.742700,0.000000,54.394100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<85.742700,0.000000,54.394100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.742700,0.000000,54.864400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.213000,0.000000,54.864400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<85.742700,0.000000,54.864400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.678200,0.000000,55.021100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.678200,0.000000,54.550800>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<86.678200,0.000000,54.550800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.678200,0.000000,54.550800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.834900,0.000000,54.394100>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<86.678200,0.000000,54.550800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.834900,0.000000,54.394100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.305200,0.000000,54.394100>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<86.834900,0.000000,54.394100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.305200,0.000000,55.021100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.305200,0.000000,54.237400>}
box{<0,0,-0.038100><0.783700,0.036000,0.038100> rotate<0,-90.000000,0> translate<87.305200,0.000000,54.237400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.305200,0.000000,54.237400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.148500,0.000000,54.080600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<87.148500,0.000000,54.080600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.148500,0.000000,54.080600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.991700,0.000000,54.080600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<86.991700,0.000000,54.080600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.613700,0.000000,55.021100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.770400,0.000000,55.021100>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<87.613700,0.000000,55.021100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.770400,0.000000,55.021100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.770400,0.000000,54.864400>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,-90.000000,0> translate<87.770400,0.000000,54.864400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.770400,0.000000,54.864400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.613700,0.000000,54.864400>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<87.613700,0.000000,54.864400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.613700,0.000000,54.864400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.613700,0.000000,55.021100>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,90.000000,0> translate<87.613700,0.000000,55.021100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.613700,0.000000,54.550800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.770400,0.000000,54.550800>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<87.613700,0.000000,54.550800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.770400,0.000000,54.550800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.770400,0.000000,54.394100>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,-90.000000,0> translate<87.770400,0.000000,54.394100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.770400,0.000000,54.394100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.613700,0.000000,54.394100>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<87.613700,0.000000,54.394100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.613700,0.000000,54.394100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.613700,0.000000,54.550800>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,90.000000,0> translate<87.613700,0.000000,54.550800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<77.635100,0.000000,53.912300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<77.635100,0.000000,52.971700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<77.635100,0.000000,52.971700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<77.635100,0.000000,52.971700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.262100,0.000000,52.971700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<77.635100,0.000000,52.971700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.727300,0.000000,52.971700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.040900,0.000000,52.971700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<78.727300,0.000000,52.971700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.040900,0.000000,52.971700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.197600,0.000000,53.128400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<79.040900,0.000000,52.971700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.197600,0.000000,53.128400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.197600,0.000000,53.442000>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<79.197600,0.000000,53.442000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.197600,0.000000,53.442000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.040900,0.000000,53.598700>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<79.040900,0.000000,53.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.040900,0.000000,53.598700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.727300,0.000000,53.598700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<78.727300,0.000000,53.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.727300,0.000000,53.598700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.570600,0.000000,53.442000>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<78.570600,0.000000,53.442000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.570600,0.000000,53.442000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.570600,0.000000,53.128400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<78.570600,0.000000,53.128400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.570600,0.000000,53.128400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.727300,0.000000,52.971700>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<78.570600,0.000000,53.128400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.506100,0.000000,53.598700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.506100,0.000000,53.128400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<79.506100,0.000000,53.128400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.506100,0.000000,53.128400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.662800,0.000000,52.971700>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<79.506100,0.000000,53.128400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.662800,0.000000,52.971700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.133100,0.000000,52.971700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<79.662800,0.000000,52.971700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.133100,0.000000,52.971700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.133100,0.000000,53.598700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<80.133100,0.000000,53.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.377100,0.000000,52.971700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.377100,0.000000,53.598700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<81.377100,0.000000,53.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.377100,0.000000,53.598700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.690600,0.000000,53.912300>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-45.006166,0> translate<81.377100,0.000000,53.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.690600,0.000000,53.912300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.004100,0.000000,53.598700>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,45.006166,0> translate<81.690600,0.000000,53.912300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.004100,0.000000,53.598700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.004100,0.000000,52.971700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<82.004100,0.000000,52.971700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.377100,0.000000,53.442000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.004100,0.000000,53.442000>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<81.377100,0.000000,53.442000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.312600,0.000000,52.971700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.312600,0.000000,53.598700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<82.312600,0.000000,53.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.312600,0.000000,53.598700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.469300,0.000000,53.598700>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<82.312600,0.000000,53.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.469300,0.000000,53.598700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.626100,0.000000,53.442000>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<82.469300,0.000000,53.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.626100,0.000000,53.442000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.626100,0.000000,52.971700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<82.626100,0.000000,52.971700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.626100,0.000000,53.442000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.782900,0.000000,53.598700>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<82.626100,0.000000,53.442000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.782900,0.000000,53.598700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.939600,0.000000,53.442000>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<82.782900,0.000000,53.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.939600,0.000000,53.442000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.939600,0.000000,52.971700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<82.939600,0.000000,52.971700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.404800,0.000000,53.598700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.718400,0.000000,53.598700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<83.404800,0.000000,53.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.718400,0.000000,53.598700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.875100,0.000000,53.442000>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<83.718400,0.000000,53.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.875100,0.000000,53.442000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.875100,0.000000,52.971700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<83.875100,0.000000,52.971700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.875100,0.000000,52.971700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.404800,0.000000,52.971700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<83.404800,0.000000,52.971700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.404800,0.000000,52.971700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.248100,0.000000,53.128400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<83.248100,0.000000,53.128400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.248100,0.000000,53.128400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.404800,0.000000,53.285200>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<83.248100,0.000000,53.128400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.404800,0.000000,53.285200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.875100,0.000000,53.285200>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<83.404800,0.000000,53.285200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.810600,0.000000,53.912300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.810600,0.000000,52.971700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<84.810600,0.000000,52.971700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.810600,0.000000,52.971700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.340300,0.000000,52.971700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<84.340300,0.000000,52.971700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.340300,0.000000,52.971700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.183600,0.000000,53.128400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<84.183600,0.000000,53.128400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.183600,0.000000,53.128400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.183600,0.000000,53.442000>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<84.183600,0.000000,53.442000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.183600,0.000000,53.442000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.340300,0.000000,53.598700>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<84.183600,0.000000,53.442000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.340300,0.000000,53.598700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.810600,0.000000,53.598700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<84.340300,0.000000,53.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.119100,0.000000,53.598700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.275800,0.000000,53.598700>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<85.119100,0.000000,53.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.275800,0.000000,53.598700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.275800,0.000000,52.971700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<85.275800,0.000000,52.971700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.119100,0.000000,52.971700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.432600,0.000000,52.971700>}
box{<0,0,-0.038100><0.313500,0.036000,0.038100> rotate<0,0.000000,0> translate<85.119100,0.000000,52.971700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.275800,0.000000,54.069000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.275800,0.000000,53.912300>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,-90.000000,0> translate<85.275800,0.000000,53.912300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.899400,0.000000,52.971700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.213000,0.000000,52.971700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<85.899400,0.000000,52.971700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.213000,0.000000,52.971700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.369700,0.000000,53.128400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<86.213000,0.000000,52.971700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.369700,0.000000,53.128400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.369700,0.000000,53.442000>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<86.369700,0.000000,53.442000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.369700,0.000000,53.442000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.213000,0.000000,53.598700>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<86.213000,0.000000,53.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.213000,0.000000,53.598700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.899400,0.000000,53.598700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<85.899400,0.000000,53.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.899400,0.000000,53.598700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.742700,0.000000,53.442000>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<85.742700,0.000000,53.442000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.742700,0.000000,53.442000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.742700,0.000000,53.128400>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<85.742700,0.000000,53.128400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.742700,0.000000,53.128400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.899400,0.000000,52.971700>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<85.742700,0.000000,53.128400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.770400,0.000000,53.598700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.084000,0.000000,53.598700>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<87.770400,0.000000,53.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.084000,0.000000,53.598700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.240700,0.000000,53.442000>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<88.084000,0.000000,53.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.240700,0.000000,53.442000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.240700,0.000000,52.971700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<88.240700,0.000000,52.971700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.240700,0.000000,52.971700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.770400,0.000000,52.971700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<87.770400,0.000000,52.971700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.770400,0.000000,52.971700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.613700,0.000000,53.128400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<87.613700,0.000000,53.128400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.613700,0.000000,53.128400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.770400,0.000000,53.285200>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<87.613700,0.000000,53.128400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.770400,0.000000,53.285200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.240700,0.000000,53.285200>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<87.770400,0.000000,53.285200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.549200,0.000000,52.971700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.549200,0.000000,53.598700>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<88.549200,0.000000,53.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.549200,0.000000,53.598700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.019500,0.000000,53.598700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<88.549200,0.000000,53.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.019500,0.000000,53.598700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.176200,0.000000,53.442000>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<89.019500,0.000000,53.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.176200,0.000000,53.442000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.176200,0.000000,52.971700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<89.176200,0.000000,52.971700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.111700,0.000000,53.912300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.111700,0.000000,52.971700>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<90.111700,0.000000,52.971700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.111700,0.000000,52.971700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.641400,0.000000,52.971700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<89.641400,0.000000,52.971700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.641400,0.000000,52.971700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.484700,0.000000,53.128400>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<89.484700,0.000000,53.128400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.484700,0.000000,53.128400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.484700,0.000000,53.442000>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<89.484700,0.000000,53.442000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.484700,0.000000,53.442000>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.641400,0.000000,53.598700>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<89.484700,0.000000,53.442000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.641400,0.000000,53.598700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.111700,0.000000,53.598700>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<89.641400,0.000000,53.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<77.635100,0.000000,52.464500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.262100,0.000000,52.464500>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<77.635100,0.000000,52.464500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.262100,0.000000,52.464500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.262100,0.000000,52.307700>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<78.262100,0.000000,52.307700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.262100,0.000000,52.307700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<77.635100,0.000000,51.680600>}
box{<0,0,-0.038100><0.886783,0.036000,0.038100> rotate<0,-45.001599,0> translate<77.635100,0.000000,51.680600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<77.635100,0.000000,51.680600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<77.635100,0.000000,51.523900>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,-90.000000,0> translate<77.635100,0.000000,51.523900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<77.635100,0.000000,51.523900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.262100,0.000000,51.523900>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<77.635100,0.000000,51.523900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.727300,0.000000,52.150900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.040900,0.000000,52.150900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<78.727300,0.000000,52.150900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.040900,0.000000,52.150900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.197600,0.000000,51.994200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<79.040900,0.000000,52.150900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.197600,0.000000,51.994200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.197600,0.000000,51.523900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<79.197600,0.000000,51.523900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.197600,0.000000,51.523900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.727300,0.000000,51.523900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<78.727300,0.000000,51.523900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.727300,0.000000,51.523900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.570600,0.000000,51.680600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<78.570600,0.000000,51.680600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.570600,0.000000,51.680600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.727300,0.000000,51.837400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-45.015305,0> translate<78.570600,0.000000,51.680600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<78.727300,0.000000,51.837400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.197600,0.000000,51.837400>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<78.727300,0.000000,51.837400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.133100,0.000000,52.150900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.662800,0.000000,52.150900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<79.662800,0.000000,52.150900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.662800,0.000000,52.150900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.506100,0.000000,51.994200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<79.506100,0.000000,51.994200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.506100,0.000000,51.994200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.506100,0.000000,51.680600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<79.506100,0.000000,51.680600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.506100,0.000000,51.680600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.662800,0.000000,51.523900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<79.506100,0.000000,51.680600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<79.662800,0.000000,51.523900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.133100,0.000000,51.523900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<79.662800,0.000000,51.523900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.441600,0.000000,52.464500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.441600,0.000000,51.523900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<80.441600,0.000000,51.523900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.441600,0.000000,51.994200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.598300,0.000000,52.150900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<80.441600,0.000000,51.994200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.598300,0.000000,52.150900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.911900,0.000000,52.150900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<80.598300,0.000000,52.150900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<80.911900,0.000000,52.150900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.068600,0.000000,51.994200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<80.911900,0.000000,52.150900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.068600,0.000000,51.994200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.068600,0.000000,51.523900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<81.068600,0.000000,51.523900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.377100,0.000000,51.523900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.377100,0.000000,52.464500>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<81.377100,0.000000,52.464500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<81.377100,0.000000,51.994200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.004100,0.000000,51.994200>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<81.377100,0.000000,51.994200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.004100,0.000000,52.464500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.004100,0.000000,51.523900>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,-90.000000,0> translate<82.004100,0.000000,51.523900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.469300,0.000000,51.523900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.782900,0.000000,51.523900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<82.469300,0.000000,51.523900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.782900,0.000000,51.523900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.939600,0.000000,51.680600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<82.782900,0.000000,51.523900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.939600,0.000000,51.680600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.939600,0.000000,51.994200>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<82.939600,0.000000,51.994200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.939600,0.000000,51.994200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.782900,0.000000,52.150900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<82.782900,0.000000,52.150900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.782900,0.000000,52.150900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.469300,0.000000,52.150900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<82.469300,0.000000,52.150900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.469300,0.000000,52.150900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.312600,0.000000,51.994200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<82.312600,0.000000,51.994200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.312600,0.000000,51.994200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.312600,0.000000,51.680600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<82.312600,0.000000,51.680600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.312600,0.000000,51.680600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<82.469300,0.000000,51.523900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<82.312600,0.000000,51.680600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.718400,0.000000,51.523900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.404800,0.000000,51.523900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<83.404800,0.000000,51.523900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.404800,0.000000,51.523900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.248100,0.000000,51.680600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<83.248100,0.000000,51.680600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.248100,0.000000,51.680600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.248100,0.000000,51.994200>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<83.248100,0.000000,51.994200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.248100,0.000000,51.994200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.404800,0.000000,52.150900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<83.248100,0.000000,51.994200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.404800,0.000000,52.150900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.718400,0.000000,52.150900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<83.404800,0.000000,52.150900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.718400,0.000000,52.150900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.875100,0.000000,51.994200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<83.718400,0.000000,52.150900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.875100,0.000000,51.994200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.875100,0.000000,51.837400>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<83.875100,0.000000,51.837400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.875100,0.000000,51.837400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<83.248100,0.000000,51.837400>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<83.248100,0.000000,51.837400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.183600,0.000000,51.523900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.183600,0.000000,52.464500>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,90.000000,0> translate<84.183600,0.000000,52.464500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.653900,0.000000,51.523900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.183600,0.000000,51.837400>}
box{<0,0,-0.038100><0.565212,0.036000,0.038100> rotate<0,33.685033,0> translate<84.183600,0.000000,51.837400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.183600,0.000000,51.837400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.653900,0.000000,52.150900>}
box{<0,0,-0.038100><0.565212,0.036000,0.038100> rotate<0,-33.685033,0> translate<84.183600,0.000000,51.837400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.433400,0.000000,51.523900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.119800,0.000000,51.523900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<85.119800,0.000000,51.523900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.119800,0.000000,51.523900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.963100,0.000000,51.680600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<84.963100,0.000000,51.680600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.963100,0.000000,51.680600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.963100,0.000000,51.994200>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<84.963100,0.000000,51.994200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.963100,0.000000,51.994200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.119800,0.000000,52.150900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<84.963100,0.000000,51.994200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.119800,0.000000,52.150900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.433400,0.000000,52.150900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<85.119800,0.000000,52.150900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.433400,0.000000,52.150900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.590100,0.000000,51.994200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<85.433400,0.000000,52.150900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.590100,0.000000,51.994200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.590100,0.000000,51.837400>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,-90.000000,0> translate<85.590100,0.000000,51.837400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.590100,0.000000,51.837400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<84.963100,0.000000,51.837400>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,0.000000,0> translate<84.963100,0.000000,51.837400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.898600,0.000000,51.523900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.898600,0.000000,52.150900>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<85.898600,0.000000,52.150900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<85.898600,0.000000,52.150900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.368900,0.000000,52.150900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<85.898600,0.000000,52.150900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.368900,0.000000,52.150900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.525600,0.000000,51.994200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<86.368900,0.000000,52.150900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.525600,0.000000,51.994200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.525600,0.000000,51.523900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<86.525600,0.000000,51.523900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.834100,0.000000,51.523900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.834100,0.000000,51.680600>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,90.000000,0> translate<86.834100,0.000000,51.680600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.834100,0.000000,51.680600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.990800,0.000000,51.680600>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<86.834100,0.000000,51.680600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.990800,0.000000,51.680600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.990800,0.000000,51.523900>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,-90.000000,0> translate<86.990800,0.000000,51.523900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.990800,0.000000,51.523900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<86.834100,0.000000,51.523900>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<86.834100,0.000000,51.523900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.928800,0.000000,52.150900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.458500,0.000000,52.150900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<87.458500,0.000000,52.150900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.458500,0.000000,52.150900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.301800,0.000000,51.994200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<87.301800,0.000000,51.994200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.301800,0.000000,51.994200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.301800,0.000000,51.680600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<87.301800,0.000000,51.680600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.301800,0.000000,51.680600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.458500,0.000000,51.523900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<87.301800,0.000000,51.680600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.458500,0.000000,51.523900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<87.928800,0.000000,51.523900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,0.000000,0> translate<87.458500,0.000000,51.523900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.394000,0.000000,51.523900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.707600,0.000000,51.523900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<88.394000,0.000000,51.523900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.707600,0.000000,51.523900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.864300,0.000000,51.680600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<88.707600,0.000000,51.523900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.864300,0.000000,51.680600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.864300,0.000000,51.994200>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<88.864300,0.000000,51.994200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.864300,0.000000,51.994200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.707600,0.000000,52.150900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<88.707600,0.000000,52.150900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.707600,0.000000,52.150900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.394000,0.000000,52.150900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,0.000000,0> translate<88.394000,0.000000,52.150900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.394000,0.000000,52.150900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.237300,0.000000,51.994200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<88.237300,0.000000,51.994200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.237300,0.000000,51.994200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.237300,0.000000,51.680600>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<88.237300,0.000000,51.680600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.237300,0.000000,51.680600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<88.394000,0.000000,51.523900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<88.237300,0.000000,51.680600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.172800,0.000000,51.523900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.172800,0.000000,52.150900>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<89.172800,0.000000,52.150900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.172800,0.000000,52.150900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.329500,0.000000,52.150900>}
box{<0,0,-0.038100><0.156700,0.036000,0.038100> rotate<0,0.000000,0> translate<89.172800,0.000000,52.150900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.329500,0.000000,52.150900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.486300,0.000000,51.994200>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<89.329500,0.000000,52.150900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.486300,0.000000,51.994200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.486300,0.000000,51.523900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<89.486300,0.000000,51.523900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.486300,0.000000,51.994200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.643100,0.000000,52.150900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<89.486300,0.000000,51.994200> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.643100,0.000000,52.150900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.799800,0.000000,51.994200>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<89.643100,0.000000,52.150900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.799800,0.000000,51.994200>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.799800,0.000000,51.523900>}
box{<0,0,-0.038100><0.470300,0.036000,0.038100> rotate<0,-90.000000,0> translate<89.799800,0.000000,51.523900> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<98.196400,0.000000,29.438600>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.637300,0.000000,29.438600>}
box{<0,0,-0.101600><1.559100,0.036000,0.101600> rotate<0,0.000000,0> translate<96.637300,0.000000,29.438600> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.637300,0.000000,29.438600>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.857700,0.000000,30.218100>}
box{<0,0,-0.101600><1.102450,0.036000,0.101600> rotate<0,44.993355,0> translate<95.857700,0.000000,30.218100> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.857700,0.000000,30.218100>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.637300,0.000000,30.997700>}
box{<0,0,-0.101600><1.102521,0.036000,0.101600> rotate<0,-44.997030,0> translate<95.857700,0.000000,30.218100> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.637300,0.000000,30.997700>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<98.196400,0.000000,30.997700>}
box{<0,0,-0.101600><1.559100,0.036000,0.101600> rotate<0,0.000000,0> translate<96.637300,0.000000,30.997700> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.027100,0.000000,29.438600>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.027100,0.000000,30.997700>}
box{<0,0,-0.101600><1.559100,0.036000,0.101600> rotate<0,90.000000,0> translate<97.027100,0.000000,30.997700> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<98.196400,0.000000,33.248600>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.857700,0.000000,33.248600>}
box{<0,0,-0.101600><2.338700,0.036000,0.101600> rotate<0,0.000000,0> translate<95.857700,0.000000,33.248600> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.857700,0.000000,33.248600>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.857700,0.000000,34.417900>}
box{<0,0,-0.101600><1.169300,0.036000,0.101600> rotate<0,90.000000,0> translate<95.857700,0.000000,34.417900> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.857700,0.000000,34.417900>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.247500,0.000000,34.807700>}
box{<0,0,-0.101600><0.551260,0.036000,0.101600> rotate<0,-44.997030,0> translate<95.857700,0.000000,34.417900> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.247500,0.000000,34.807700>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.637300,0.000000,34.807700>}
box{<0,0,-0.101600><0.389800,0.036000,0.101600> rotate<0,0.000000,0> translate<96.247500,0.000000,34.807700> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.637300,0.000000,34.807700>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.027100,0.000000,34.417900>}
box{<0,0,-0.101600><0.551260,0.036000,0.101600> rotate<0,44.997030,0> translate<96.637300,0.000000,34.807700> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.027100,0.000000,34.417900>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.416900,0.000000,34.807700>}
box{<0,0,-0.101600><0.551260,0.036000,0.101600> rotate<0,-44.997030,0> translate<97.027100,0.000000,34.417900> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.416900,0.000000,34.807700>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.806700,0.000000,34.807700>}
box{<0,0,-0.101600><0.389800,0.036000,0.101600> rotate<0,0.000000,0> translate<97.416900,0.000000,34.807700> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.806700,0.000000,34.807700>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<98.196400,0.000000,34.417900>}
box{<0,0,-0.101600><0.551190,0.036000,0.101600> rotate<0,45.004380,0> translate<97.806700,0.000000,34.807700> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<98.196400,0.000000,34.417900>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<98.196400,0.000000,33.248600>}
box{<0,0,-0.101600><1.169300,0.036000,0.101600> rotate<0,-90.000000,0> translate<98.196400,0.000000,33.248600> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.027100,0.000000,33.248600>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.027100,0.000000,34.417900>}
box{<0,0,-0.101600><1.169300,0.036000,0.101600> rotate<0,90.000000,0> translate<97.027100,0.000000,34.417900> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.247500,0.000000,39.252700>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.857700,0.000000,38.862900>}
box{<0,0,-0.101600><0.551260,0.036000,0.101600> rotate<0,-44.997030,0> translate<95.857700,0.000000,38.862900> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.857700,0.000000,38.862900>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.857700,0.000000,38.083300>}
box{<0,0,-0.101600><0.779600,0.036000,0.101600> rotate<0,-90.000000,0> translate<95.857700,0.000000,38.083300> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.857700,0.000000,38.083300>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.247500,0.000000,37.693600>}
box{<0,0,-0.101600><0.551190,0.036000,0.101600> rotate<0,44.989680,0> translate<95.857700,0.000000,38.083300> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.247500,0.000000,37.693600>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.806700,0.000000,37.693600>}
box{<0,0,-0.101600><1.559200,0.036000,0.101600> rotate<0,0.000000,0> translate<96.247500,0.000000,37.693600> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.806700,0.000000,37.693600>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<98.196400,0.000000,38.083300>}
box{<0,0,-0.101600><0.551119,0.036000,0.101600> rotate<0,-44.997030,0> translate<97.806700,0.000000,37.693600> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<98.196400,0.000000,38.083300>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<98.196400,0.000000,38.862900>}
box{<0,0,-0.101600><0.779600,0.036000,0.101600> rotate<0,90.000000,0> translate<98.196400,0.000000,38.862900> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<98.196400,0.000000,38.862900>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.806700,0.000000,39.252700>}
box{<0,0,-0.101600><0.551190,0.036000,0.101600> rotate<0,45.004380,0> translate<97.806700,0.000000,39.252700> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.857700,0.000000,41.503600>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<98.196400,0.000000,41.503600>}
box{<0,0,-0.101600><2.338700,0.036000,0.101600> rotate<0,0.000000,0> translate<95.857700,0.000000,41.503600> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<98.196400,0.000000,41.503600>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<98.196400,0.000000,42.672900>}
box{<0,0,-0.101600><1.169300,0.036000,0.101600> rotate<0,90.000000,0> translate<98.196400,0.000000,42.672900> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<98.196400,0.000000,42.672900>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.806700,0.000000,43.062700>}
box{<0,0,-0.101600><0.551190,0.036000,0.101600> rotate<0,45.004380,0> translate<97.806700,0.000000,43.062700> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.806700,0.000000,43.062700>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.247500,0.000000,43.062700>}
box{<0,0,-0.101600><1.559200,0.036000,0.101600> rotate<0,0.000000,0> translate<96.247500,0.000000,43.062700> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<96.247500,0.000000,43.062700>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.857700,0.000000,42.672900>}
box{<0,0,-0.101600><0.551260,0.036000,0.101600> rotate<0,-44.997030,0> translate<95.857700,0.000000,42.672900> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.857700,0.000000,42.672900>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.857700,0.000000,41.503600>}
box{<0,0,-0.101600><1.169300,0.036000,0.101600> rotate<0,-90.000000,0> translate<95.857700,0.000000,41.503600> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<22.821900,0.000000,50.126900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<22.821900,0.000000,52.135200>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,90.000000,0> translate<22.821900,0.000000,52.135200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<22.821900,0.000000,52.135200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<23.491300,0.000000,51.465700>}
box{<0,0,-0.088900><0.946745,0.036000,0.088900> rotate<0,45.001309,0> translate<22.821900,0.000000,52.135200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<23.491300,0.000000,51.465700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<24.160700,0.000000,52.135200>}
box{<0,0,-0.088900><0.946745,0.036000,0.088900> rotate<0,-45.001309,0> translate<23.491300,0.000000,51.465700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<24.160700,0.000000,52.135200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<24.160700,0.000000,50.126900>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,-90.000000,0> translate<24.160700,0.000000,50.126900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<24.833200,0.000000,50.126900>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<24.833200,0.000000,51.465700>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,90.000000,0> translate<24.833200,0.000000,51.465700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<24.833200,0.000000,51.465700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<25.502600,0.000000,52.135200>}
box{<0,0,-0.088900><0.946745,0.036000,0.088900> rotate<0,-45.001309,0> translate<24.833200,0.000000,51.465700> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<25.502600,0.000000,52.135200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<26.172000,0.000000,51.465700>}
box{<0,0,-0.088900><0.946745,0.036000,0.088900> rotate<0,45.001309,0> translate<25.502600,0.000000,52.135200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<26.172000,0.000000,51.465700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<26.172000,0.000000,50.126900>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,-90.000000,0> translate<26.172000,0.000000,50.126900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<24.833200,0.000000,51.131000>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<26.172000,0.000000,51.131000>}
box{<0,0,-0.088900><1.338800,0.036000,0.088900> rotate<0,0.000000,0> translate<24.833200,0.000000,51.131000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<26.844500,0.000000,52.135200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<28.183300,0.000000,50.126900>}
box{<0,0,-0.088900><2.413639,0.036000,0.088900> rotate<0,56.307533,0> translate<26.844500,0.000000,52.135200> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<28.183300,0.000000,52.135200>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<26.844500,0.000000,50.126900>}
box{<0,0,-0.088900><2.413639,0.036000,0.088900> rotate<0,-56.307533,0> translate<26.844500,0.000000,50.126900> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.559500,0.000000,24.316300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.551200,0.000000,24.316300>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,0.000000,0> translate<29.551200,0.000000,24.316300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.551200,0.000000,24.316300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.220700,0.000000,24.985700>}
box{<0,0,-0.088900><0.946745,0.036000,0.088900> rotate<0,-44.992751,0> translate<29.551200,0.000000,24.316300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<30.220700,0.000000,24.985700>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.551200,0.000000,25.655100>}
box{<0,0,-0.088900><0.946745,0.036000,0.088900> rotate<0,44.992751,0> translate<29.551200,0.000000,25.655100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.551200,0.000000,25.655100>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.559500,0.000000,25.655100>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,0.000000,0> translate<29.551200,0.000000,25.655100> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.559500,0.000000,26.327600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.559500,0.000000,26.997000>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<31.559500,0.000000,26.997000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.559500,0.000000,26.662300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.551200,0.000000,26.662300>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,0.000000,0> translate<29.551200,0.000000,26.662300> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.551200,0.000000,26.327600>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.551200,0.000000,26.997000>}
box{<0,0,-0.088900><0.669400,0.036000,0.088900> rotate<0,90.000000,0> translate<29.551200,0.000000,26.997000> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.559500,0.000000,27.668500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.551200,0.000000,27.668500>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,0.000000,0> translate<29.551200,0.000000,27.668500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.551200,0.000000,27.668500>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.559500,0.000000,29.007300>}
box{<0,0,-0.088900><2.413639,0.036000,0.088900> rotate<0,-33.686527,0> translate<29.551200,0.000000,27.668500> }
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<31.559500,0.000000,29.007300>}
cylinder{<0,0,0><0,0.036000,0>0.088900 translate<29.551200,0.000000,29.007300>}
box{<0,0,-0.088900><2.008300,0.036000,0.088900> rotate<0,0.000000,0> translate<29.551200,0.000000,29.007300> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.088800,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.088800,0.000000,55.415000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<50.088800,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.088800,0.000000,55.415000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.309100,0.000000,55.415000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<50.088800,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.309100,0.000000,55.415000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.529400,0.000000,55.194700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<50.309100,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.529400,0.000000,55.194700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.529400,0.000000,54.533800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<50.529400,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.529400,0.000000,55.194700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.749700,0.000000,55.415000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<50.529400,0.000000,55.194700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.749700,0.000000,55.415000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.970000,0.000000,55.194700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<50.749700,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.970000,0.000000,55.194700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<50.970000,0.000000,54.533800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<50.970000,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.618800,0.000000,55.415000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.059400,0.000000,55.415000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<51.618800,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.059400,0.000000,55.415000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.279700,0.000000,55.194700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<52.059400,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.279700,0.000000,55.194700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.279700,0.000000,54.533800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<52.279700,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.279700,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.618800,0.000000,54.533800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<51.618800,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.618800,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.398500,0.000000,54.754100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<51.398500,0.000000,54.754100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.398500,0.000000,54.754100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.618800,0.000000,54.974400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<51.398500,0.000000,54.754100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<51.618800,0.000000,54.974400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.279700,0.000000,54.974400>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<51.618800,0.000000,54.974400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.708200,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.708200,0.000000,55.855700>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,90.000000,0> translate<52.708200,0.000000,55.855700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.369100,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.708200,0.000000,54.974400>}
box{<0,0,-0.050800><0.794303,0.036000,0.050800> rotate<0,33.687844,0> translate<52.708200,0.000000,54.974400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<52.708200,0.000000,54.974400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.369100,0.000000,55.415000>}
box{<0,0,-0.050800><0.794303,0.036000,0.050800> rotate<0,-33.687844,0> translate<52.708200,0.000000,54.974400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.460500,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.019900,0.000000,54.533800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<54.019900,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.019900,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.799600,0.000000,54.754100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<53.799600,0.000000,54.754100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.799600,0.000000,54.754100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.799600,0.000000,55.194700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,90.000000,0> translate<53.799600,0.000000,55.194700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.799600,0.000000,55.194700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.019900,0.000000,55.415000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<53.799600,0.000000,55.194700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.019900,0.000000,55.415000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.460500,0.000000,55.415000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<54.019900,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.460500,0.000000,55.415000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.680800,0.000000,55.194700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<54.460500,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.680800,0.000000,55.194700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.680800,0.000000,54.974400>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<54.680800,0.000000,54.974400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<54.680800,0.000000,54.974400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<53.799600,0.000000,54.974400>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<53.799600,0.000000,54.974400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.109300,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.109300,0.000000,54.754100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,90.000000,0> translate<55.109300,0.000000,54.754100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.109300,0.000000,54.754100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.329600,0.000000,54.754100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<55.109300,0.000000,54.754100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.329600,0.000000,54.754100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.329600,0.000000,54.533800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<55.329600,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.329600,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.109300,0.000000,54.533800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<55.109300,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.764100,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.764100,0.000000,55.415000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<55.764100,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<55.764100,0.000000,54.974400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.204700,0.000000,55.415000>}
box{<0,0,-0.050800><0.623102,0.036000,0.050800> rotate<0,-44.997030,0> translate<55.764100,0.000000,54.974400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.204700,0.000000,55.415000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.425000,0.000000,55.415000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<56.204700,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.855500,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.855500,0.000000,55.415000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<56.855500,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.855500,0.000000,54.974400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.296100,0.000000,55.415000>}
box{<0,0,-0.050800><0.623102,0.036000,0.050800> rotate<0,-44.997030,0> translate<56.855500,0.000000,54.974400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.296100,0.000000,55.415000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.516400,0.000000,55.415000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<57.296100,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.946900,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.946900,0.000000,55.415000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<57.946900,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.946900,0.000000,54.974400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.387500,0.000000,55.415000>}
box{<0,0,-0.050800><0.623102,0.036000,0.050800> rotate<0,-44.997030,0> translate<57.946900,0.000000,54.974400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.387500,0.000000,55.415000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.607800,0.000000,55.415000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<58.387500,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.258600,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.258600,0.000000,55.635400>}
box{<0,0,-0.050800><1.101600,0.036000,0.050800> rotate<0,90.000000,0> translate<59.258600,0.000000,55.635400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.258600,0.000000,55.635400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.478900,0.000000,55.855700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<59.258600,0.000000,55.635400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.038300,0.000000,55.194700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.478900,0.000000,55.194700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<59.038300,0.000000,55.194700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.911400,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.911400,0.000000,54.754100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,90.000000,0> translate<59.911400,0.000000,54.754100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.911400,0.000000,54.754100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.131700,0.000000,54.754100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<59.911400,0.000000,54.754100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.131700,0.000000,54.754100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.131700,0.000000,54.533800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<60.131700,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.131700,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<59.911400,0.000000,54.533800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<59.911400,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.786500,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.227100,0.000000,54.533800>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<60.786500,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.227100,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.447400,0.000000,54.754100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<61.227100,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.447400,0.000000,54.754100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.447400,0.000000,55.194700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,90.000000,0> translate<61.447400,0.000000,55.194700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.447400,0.000000,55.194700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.227100,0.000000,55.415000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<61.227100,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.227100,0.000000,55.415000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.786500,0.000000,55.415000>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<60.786500,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.786500,0.000000,55.415000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.566200,0.000000,55.194700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<60.566200,0.000000,55.194700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.566200,0.000000,55.194700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.566200,0.000000,54.754100>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,-90.000000,0> translate<60.566200,0.000000,54.754100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.566200,0.000000,54.754100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<60.786500,0.000000,54.533800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<60.566200,0.000000,54.754100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.875900,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.875900,0.000000,55.415000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<61.875900,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<61.875900,0.000000,54.974400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.316500,0.000000,55.415000>}
box{<0,0,-0.050800><0.623102,0.036000,0.050800> rotate<0,-44.997030,0> translate<61.875900,0.000000,54.974400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.316500,0.000000,55.415000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.536800,0.000000,55.415000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<62.316500,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.407900,0.000000,54.093200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.628200,0.000000,54.093200>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<63.407900,0.000000,54.093200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.628200,0.000000,54.093200>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.848500,0.000000,54.313500>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<63.628200,0.000000,54.093200> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.848500,0.000000,54.313500>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.848500,0.000000,55.415000>}
box{<0,0,-0.050800><1.101500,0.036000,0.050800> rotate<0,90.000000,0> translate<63.848500,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.848500,0.000000,55.415000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.187600,0.000000,55.415000>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<63.187600,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.187600,0.000000,55.415000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.967300,0.000000,55.194700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<62.967300,0.000000,55.194700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.967300,0.000000,55.194700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.967300,0.000000,54.754100>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,-90.000000,0> translate<62.967300,0.000000,54.754100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<62.967300,0.000000,54.754100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.187600,0.000000,54.533800>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<62.967300,0.000000,54.754100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.187600,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<63.848500,0.000000,54.533800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<63.187600,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.277000,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.158200,0.000000,55.855700>}
box{<0,0,-0.050800><1.588689,0.036000,0.050800> rotate<0,-56.308217,0> translate<64.277000,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.586700,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.247600,0.000000,54.533800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<65.586700,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.247600,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.467900,0.000000,54.754100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<66.247600,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.467900,0.000000,54.754100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.247600,0.000000,54.974400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<66.247600,0.000000,54.974400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.247600,0.000000,54.974400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.807000,0.000000,54.974400>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<65.807000,0.000000,54.974400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.807000,0.000000,54.974400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.586700,0.000000,55.194700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<65.586700,0.000000,55.194700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.586700,0.000000,55.194700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.807000,0.000000,55.415000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<65.586700,0.000000,55.194700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.807000,0.000000,55.415000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.467900,0.000000,55.415000>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<65.807000,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.896400,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.896400,0.000000,55.415000>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,90.000000,0> translate<66.896400,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.896400,0.000000,55.415000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.116700,0.000000,55.415000>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<66.896400,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.116700,0.000000,55.415000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.337000,0.000000,55.194700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<67.116700,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.337000,0.000000,55.194700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.337000,0.000000,54.533800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<67.337000,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.337000,0.000000,55.194700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.557300,0.000000,55.415000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<67.337000,0.000000,55.194700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.557300,0.000000,55.415000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.777600,0.000000,55.194700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<67.557300,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.777600,0.000000,55.194700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.777600,0.000000,54.533800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,-90.000000,0> translate<67.777600,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.087300,0.000000,55.855700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.087300,0.000000,54.533800>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,-90.000000,0> translate<69.087300,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.087300,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.426400,0.000000,54.533800>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<68.426400,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.426400,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.206100,0.000000,54.754100>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<68.206100,0.000000,54.754100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.206100,0.000000,54.754100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.206100,0.000000,55.194700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,90.000000,0> translate<68.206100,0.000000,55.194700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.206100,0.000000,55.194700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.426400,0.000000,55.415000>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<68.206100,0.000000,55.194700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<68.426400,0.000000,55.415000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.087300,0.000000,55.415000>}
box{<0,0,-0.050800><0.660900,0.036000,0.050800> rotate<0,0.000000,0> translate<68.426400,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<69.515800,0.000000,55.194700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<70.397000,0.000000,55.194700>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<69.515800,0.000000,55.194700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.706700,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<70.825500,0.000000,54.533800>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<70.825500,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<70.825500,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.706700,0.000000,55.415000>}
box{<0,0,-0.050800><1.246205,0.036000,0.050800> rotate<0,-44.997030,0> translate<70.825500,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.706700,0.000000,55.415000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.706700,0.000000,55.635400>}
box{<0,0,-0.050800><0.220400,0.036000,0.050800> rotate<0,90.000000,0> translate<71.706700,0.000000,55.635400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.706700,0.000000,55.635400>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.486400,0.000000,55.855700>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,44.997030,0> translate<71.486400,0.000000,55.855700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.486400,0.000000,55.855700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.045800,0.000000,55.855700>}
box{<0,0,-0.050800><0.440600,0.036000,0.050800> rotate<0,0.000000,0> translate<71.045800,0.000000,55.855700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<71.045800,0.000000,55.855700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<70.825500,0.000000,55.635400>}
box{<0,0,-0.050800><0.311551,0.036000,0.050800> rotate<0,-44.997030,0> translate<70.825500,0.000000,55.635400> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.135200,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.135200,0.000000,54.754100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,90.000000,0> translate<72.135200,0.000000,54.754100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.135200,0.000000,54.754100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.355500,0.000000,54.754100>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<72.135200,0.000000,54.754100> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.355500,0.000000,54.754100>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.355500,0.000000,54.533800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,-90.000000,0> translate<72.355500,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.355500,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.135200,0.000000,54.533800>}
box{<0,0,-0.050800><0.220300,0.036000,0.050800> rotate<0,0.000000,0> translate<72.135200,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.790000,0.000000,55.415000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.230600,0.000000,55.855700>}
box{<0,0,-0.050800><0.623173,0.036000,0.050800> rotate<0,-45.003531,0> translate<72.790000,0.000000,55.415000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.230600,0.000000,55.855700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.230600,0.000000,54.533800>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,-90.000000,0> translate<73.230600,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<72.790000,0.000000,54.533800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<73.671200,0.000000,54.533800>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<72.790000,0.000000,54.533800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.512900,0.000000,12.230100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.775700,0.000000,12.230100>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,0.000000,0> translate<89.775700,0.000000,12.230100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.775700,0.000000,12.230100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.775700,0.000000,12.598700>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<89.775700,0.000000,12.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.775700,0.000000,12.598700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.898600,0.000000,12.721500>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<89.775700,0.000000,12.598700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.898600,0.000000,12.721500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.144300,0.000000,12.721500>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,0.000000,0> translate<89.898600,0.000000,12.721500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.144300,0.000000,12.721500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.267200,0.000000,12.598700>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,44.973712,0> translate<90.144300,0.000000,12.721500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.267200,0.000000,12.598700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.267200,0.000000,12.230100>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,-90.000000,0> translate<90.267200,0.000000,12.230100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.775700,0.000000,13.347100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.775700,0.000000,13.101300>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,-90.000000,0> translate<89.775700,0.000000,13.101300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.775700,0.000000,13.101300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.898600,0.000000,12.978500>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,44.973712,0> translate<89.775700,0.000000,13.101300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.898600,0.000000,12.978500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.390100,0.000000,12.978500>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,0.000000,0> translate<89.898600,0.000000,12.978500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.390100,0.000000,12.978500>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.512900,0.000000,13.101300>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,-44.997030,0> translate<90.390100,0.000000,12.978500> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.512900,0.000000,13.101300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.512900,0.000000,13.347100>}
box{<0,0,-0.038100><0.245800,0.036000,0.038100> rotate<0,90.000000,0> translate<90.512900,0.000000,13.347100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.512900,0.000000,13.347100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.390100,0.000000,13.469900>}
box{<0,0,-0.038100><0.173665,0.036000,0.038100> rotate<0,44.997030,0> translate<90.390100,0.000000,13.469900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.390100,0.000000,13.469900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.898600,0.000000,13.469900>}
box{<0,0,-0.038100><0.491500,0.036000,0.038100> rotate<0,0.000000,0> translate<89.898600,0.000000,13.469900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.898600,0.000000,13.469900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.775700,0.000000,13.347100>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<89.775700,0.000000,13.347100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.775700,0.000000,13.726900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.512900,0.000000,13.726900>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,0.000000,0> translate<89.775700,0.000000,13.726900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.512900,0.000000,13.726900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.267200,0.000000,13.972600>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,44.997030,0> translate<90.267200,0.000000,13.972600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.267200,0.000000,13.972600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.512900,0.000000,14.218300>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,-44.997030,0> translate<90.267200,0.000000,13.972600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.512900,0.000000,14.218300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.775700,0.000000,14.218300>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,0.000000,0> translate<89.775700,0.000000,14.218300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.775700,0.000000,14.966700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.775700,0.000000,14.475300>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,-90.000000,0> translate<89.775700,0.000000,14.475300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.775700,0.000000,14.475300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.512900,0.000000,14.475300>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,0.000000,0> translate<89.775700,0.000000,14.475300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.512900,0.000000,14.475300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.512900,0.000000,14.966700>}
box{<0,0,-0.038100><0.491400,0.036000,0.038100> rotate<0,90.000000,0> translate<90.512900,0.000000,14.966700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.144300,0.000000,14.475300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.144300,0.000000,14.721000>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,90.000000,0> translate<90.144300,0.000000,14.721000> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.512900,0.000000,15.223700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.775700,0.000000,15.223700>}
box{<0,0,-0.038100><0.737200,0.036000,0.038100> rotate<0,0.000000,0> translate<89.775700,0.000000,15.223700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.775700,0.000000,15.223700>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.775700,0.000000,15.592300>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,90.000000,0> translate<89.775700,0.000000,15.592300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.775700,0.000000,15.592300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.898600,0.000000,15.715100>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,-44.973712,0> translate<89.775700,0.000000,15.592300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<89.898600,0.000000,15.715100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.144300,0.000000,15.715100>}
box{<0,0,-0.038100><0.245700,0.036000,0.038100> rotate<0,0.000000,0> translate<89.898600,0.000000,15.715100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.144300,0.000000,15.715100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.267200,0.000000,15.592300>}
box{<0,0,-0.038100><0.173736,0.036000,0.038100> rotate<0,44.973712,0> translate<90.144300,0.000000,15.715100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.267200,0.000000,15.592300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.267200,0.000000,15.223700>}
box{<0,0,-0.038100><0.368600,0.036000,0.038100> rotate<0,-90.000000,0> translate<90.267200,0.000000,15.223700> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.267200,0.000000,15.469400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<90.512900,0.000000,15.715100>}
box{<0,0,-0.038100><0.347472,0.036000,0.038100> rotate<0,-44.997030,0> translate<90.267200,0.000000,15.469400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.897800,0.000000,49.961800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.355500,0.000000,49.961800>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<45.355500,0.000000,49.961800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.626700,0.000000,49.961800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.626700,0.000000,48.334900>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,-90.000000,0> translate<45.626700,0.000000,48.334900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.897800,0.000000,48.334900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.355500,0.000000,48.334900>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<45.355500,0.000000,48.334900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.806400,0.000000,49.961800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.806400,0.000000,48.334900>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,-90.000000,0> translate<44.806400,0.000000,48.334900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.806400,0.000000,48.334900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.721800,0.000000,49.961800>}
box{<0,0,-0.076200><1.955290,0.036000,0.076200> rotate<0,56.306216,0> translate<43.721800,0.000000,49.961800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.721800,0.000000,49.961800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.721800,0.000000,48.334900>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,-90.000000,0> translate<43.721800,0.000000,48.334900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.627000,0.000000,49.961800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.627000,0.000000,48.334900>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,-90.000000,0> translate<42.627000,0.000000,48.334900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.169300,0.000000,48.334900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.084700,0.000000,48.334900>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<42.084700,0.000000,48.334900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.447600,0.000000,48.334900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.532200,0.000000,48.334900>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<40.447600,0.000000,48.334900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.532200,0.000000,48.334900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.532200,0.000000,49.961800>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,90.000000,0> translate<41.532200,0.000000,49.961800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.532200,0.000000,49.961800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.447600,0.000000,49.961800>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<40.447600,0.000000,49.961800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.532200,0.000000,49.148400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.989900,0.000000,49.148400>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<40.989900,0.000000,49.148400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.895100,0.000000,49.961800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.895100,0.000000,48.334900>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,-90.000000,0> translate<39.895100,0.000000,48.334900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.895100,0.000000,48.334900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.081700,0.000000,48.334900>}
box{<0,0,-0.076200><0.813400,0.036000,0.076200> rotate<0,0.000000,0> translate<39.081700,0.000000,48.334900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.081700,0.000000,48.334900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.810500,0.000000,48.606000>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,44.986466,0> translate<38.810500,0.000000,48.606000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.810500,0.000000,48.606000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.810500,0.000000,49.148400>}
box{<0,0,-0.076200><0.542400,0.036000,0.076200> rotate<0,90.000000,0> translate<38.810500,0.000000,49.148400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.810500,0.000000,49.148400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.081700,0.000000,49.419500>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-44.986466,0> translate<38.810500,0.000000,49.148400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.081700,0.000000,49.419500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.895100,0.000000,49.419500>}
box{<0,0,-0.076200><0.813400,0.036000,0.076200> rotate<0,0.000000,0> translate<39.081700,0.000000,49.419500> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.352800,0.000000,49.419500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.810500,0.000000,49.961800>}
box{<0,0,-0.076200><0.766928,0.036000,0.076200> rotate<0,44.997030,0> translate<38.810500,0.000000,49.961800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.258000,0.000000,49.961800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.258000,0.000000,48.334900>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,-90.000000,0> translate<38.258000,0.000000,48.334900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.258000,0.000000,48.334900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.173400,0.000000,48.334900>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<37.173400,0.000000,48.334900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.258000,0.000000,49.148400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.715700,0.000000,49.148400>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<37.715700,0.000000,49.148400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.620900,0.000000,49.961800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.620900,0.000000,48.877200>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,-90.000000,0> translate<36.620900,0.000000,48.877200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.620900,0.000000,48.877200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.078600,0.000000,48.334900>}
box{<0,0,-0.076200><0.766928,0.036000,0.076200> rotate<0,-44.997030,0> translate<36.078600,0.000000,48.334900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.078600,0.000000,48.334900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.536300,0.000000,48.877200>}
box{<0,0,-0.076200><0.766928,0.036000,0.076200> rotate<0,44.997030,0> translate<35.536300,0.000000,48.877200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.536300,0.000000,48.877200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.536300,0.000000,49.961800>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,90.000000,0> translate<35.536300,0.000000,49.961800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.620900,0.000000,49.148400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.536300,0.000000,49.148400>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<35.536300,0.000000,49.148400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.899200,0.000000,48.606000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.170400,0.000000,48.334900>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,44.986466,0> translate<33.899200,0.000000,48.606000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.170400,0.000000,48.334900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.712700,0.000000,48.334900>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<34.170400,0.000000,48.334900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.712700,0.000000,48.334900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.983800,0.000000,48.606000>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,-44.997030,0> translate<34.712700,0.000000,48.334900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.983800,0.000000,48.606000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.983800,0.000000,49.690700>}
box{<0,0,-0.076200><1.084700,0.036000,0.076200> rotate<0,90.000000,0> translate<34.983800,0.000000,49.690700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.983800,0.000000,49.690700>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.712700,0.000000,49.961800>}
box{<0,0,-0.076200><0.383393,0.036000,0.076200> rotate<0,44.997030,0> translate<34.712700,0.000000,49.961800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.712700,0.000000,49.961800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.170400,0.000000,49.961800>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<34.170400,0.000000,49.961800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.170400,0.000000,49.961800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.899200,0.000000,49.690700>}
box{<0,0,-0.076200><0.383464,0.036000,0.076200> rotate<0,-44.986466,0> translate<33.899200,0.000000,49.690700> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.262100,0.000000,48.334900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.346700,0.000000,48.334900>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<32.262100,0.000000,48.334900> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.346700,0.000000,48.334900>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.346700,0.000000,49.961800>}
box{<0,0,-0.076200><1.626900,0.036000,0.076200> rotate<0,90.000000,0> translate<33.346700,0.000000,49.961800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.346700,0.000000,49.961800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.262100,0.000000,49.961800>}
box{<0,0,-0.076200><1.084600,0.036000,0.076200> rotate<0,0.000000,0> translate<32.262100,0.000000,49.961800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.346700,0.000000,49.148400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<32.804400,0.000000,49.148400>}
box{<0,0,-0.076200><0.542300,0.036000,0.076200> rotate<0,0.000000,0> translate<32.804400,0.000000,49.148400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.905900,0.000000,50.711100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.965300,0.000000,50.711100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<58.965300,0.000000,50.711100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.965300,0.000000,50.711100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.278900,0.000000,51.024600>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<58.965300,0.000000,50.711100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.278900,0.000000,51.024600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.965300,0.000000,51.338100>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<58.965300,0.000000,51.338100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.965300,0.000000,51.338100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.905900,0.000000,51.338100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<58.965300,0.000000,51.338100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.122100,0.000000,52.273600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.965300,0.000000,52.116900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<58.965300,0.000000,52.116900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.965300,0.000000,52.116900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.965300,0.000000,51.803300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<58.965300,0.000000,51.803300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.965300,0.000000,51.803300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.122100,0.000000,51.646600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<58.965300,0.000000,51.803300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.122100,0.000000,51.646600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.278900,0.000000,51.646600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<59.122100,0.000000,51.646600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.278900,0.000000,51.646600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.435600,0.000000,51.803300>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<59.278900,0.000000,51.646600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.435600,0.000000,51.803300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.435600,0.000000,52.116900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<59.435600,0.000000,52.116900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.435600,0.000000,52.116900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.592400,0.000000,52.273600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<59.435600,0.000000,52.116900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.592400,0.000000,52.273600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.749200,0.000000,52.273600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<59.592400,0.000000,52.273600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.749200,0.000000,52.273600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.905900,0.000000,52.116900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<59.749200,0.000000,52.273600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.905900,0.000000,52.116900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.905900,0.000000,51.803300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<59.905900,0.000000,51.803300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.905900,0.000000,51.803300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.749200,0.000000,51.646600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<59.749200,0.000000,51.646600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.278900,0.000000,52.582100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.965300,0.000000,52.895600>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<58.965300,0.000000,52.895600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<58.965300,0.000000,52.895600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.905900,0.000000,52.895600>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<58.965300,0.000000,52.895600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.905900,0.000000,52.582100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<59.905900,0.000000,53.209100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,90.000000,0> translate<59.905900,0.000000,53.209100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.715900,0.000000,50.711100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.775300,0.000000,50.711100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<62.775300,0.000000,50.711100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.775300,0.000000,50.711100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.088900,0.000000,51.024600>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,-44.987894,0> translate<62.775300,0.000000,50.711100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.088900,0.000000,51.024600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.775300,0.000000,51.338100>}
box{<0,0,-0.038100><0.443427,0.036000,0.038100> rotate<0,44.987894,0> translate<62.775300,0.000000,51.338100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.775300,0.000000,51.338100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.715900,0.000000,51.338100>}
box{<0,0,-0.038100><0.940600,0.036000,0.038100> rotate<0,0.000000,0> translate<62.775300,0.000000,51.338100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.932100,0.000000,52.273600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.775300,0.000000,52.116900>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<62.775300,0.000000,52.116900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.775300,0.000000,52.116900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.775300,0.000000,51.803300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<62.775300,0.000000,51.803300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.775300,0.000000,51.803300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.932100,0.000000,51.646600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<62.775300,0.000000,51.803300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.932100,0.000000,51.646600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.088900,0.000000,51.646600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<62.932100,0.000000,51.646600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.088900,0.000000,51.646600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.245600,0.000000,51.803300>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<63.088900,0.000000,51.646600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.245600,0.000000,51.803300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.245600,0.000000,52.116900>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,90.000000,0> translate<63.245600,0.000000,52.116900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.245600,0.000000,52.116900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.402400,0.000000,52.273600>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<63.245600,0.000000,52.116900> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.402400,0.000000,52.273600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.559200,0.000000,52.273600>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<63.402400,0.000000,52.273600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.559200,0.000000,52.273600>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.715900,0.000000,52.116900>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,44.997030,0> translate<63.559200,0.000000,52.273600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.715900,0.000000,52.116900>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.715900,0.000000,51.803300>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<63.715900,0.000000,51.803300> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.715900,0.000000,51.803300>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.559200,0.000000,51.646600>}
box{<0,0,-0.038100><0.221607,0.036000,0.038100> rotate<0,-44.997030,0> translate<63.559200,0.000000,51.646600> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.715900,0.000000,53.209100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.715900,0.000000,52.582100>}
box{<0,0,-0.038100><0.627000,0.036000,0.038100> rotate<0,-90.000000,0> translate<63.715900,0.000000,52.582100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.715900,0.000000,52.582100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.088900,0.000000,53.209100>}
box{<0,0,-0.038100><0.886712,0.036000,0.038100> rotate<0,44.997030,0> translate<63.088900,0.000000,53.209100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<63.088900,0.000000,53.209100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.932100,0.000000,53.209100>}
box{<0,0,-0.038100><0.156800,0.036000,0.038100> rotate<0,0.000000,0> translate<62.932100,0.000000,53.209100> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.932100,0.000000,53.209100>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.775300,0.000000,53.052400>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,-44.978755,0> translate<62.775300,0.000000,53.052400> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.775300,0.000000,53.052400>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.775300,0.000000,52.738800>}
box{<0,0,-0.038100><0.313600,0.036000,0.038100> rotate<0,-90.000000,0> translate<62.775300,0.000000,52.738800> }
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.775300,0.000000,52.738800>}
cylinder{<0,0,0><0,0.036000,0>0.038100 translate<62.932100,0.000000,52.582100>}
box{<0,0,-0.038100><0.221678,0.036000,0.038100> rotate<0,44.978755,0> translate<62.775300,0.000000,52.738800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.566800,0.000000,45.643800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.566800,0.000000,46.965700>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,90.000000,0> translate<64.566800,0.000000,46.965700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.566800,0.000000,46.304700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.448000,0.000000,46.304700>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<64.566800,0.000000,46.304700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.448000,0.000000,46.965700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.448000,0.000000,45.643800>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,-90.000000,0> translate<65.448000,0.000000,45.643800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.946800,0.000000,45.516800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.946800,0.000000,46.838700>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,90.000000,0> translate<56.946800,0.000000,46.838700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.946800,0.000000,46.177700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.828000,0.000000,46.177700>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<56.946800,0.000000,46.177700> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.828000,0.000000,46.838700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.828000,0.000000,45.516800>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,-90.000000,0> translate<57.828000,0.000000,45.516800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.946800,0.000000,50.013700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.946800,0.000000,48.691800>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,-90.000000,0> translate<56.946800,0.000000,48.691800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<56.946800,0.000000,48.691800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<57.828000,0.000000,48.691800>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<56.946800,0.000000,48.691800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.566800,0.000000,50.140700>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.566800,0.000000,48.818800>}
box{<0,0,-0.050800><1.321900,0.036000,0.050800> rotate<0,-90.000000,0> translate<64.566800,0.000000,48.818800> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<64.566800,0.000000,48.818800>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<65.448000,0.000000,48.818800>}
box{<0,0,-0.050800><0.881200,0.036000,0.050800> rotate<0,0.000000,0> translate<64.566800,0.000000,48.818800> }
difference{
cylinder{<76.779800,0,30.605000><76.779800,0.036000,30.605000>0.904400 translate<0,0.000000,0>}
cylinder{<76.779800,-0.1,30.605000><76.779800,0.135000,30.605000>0.777400 translate<0,0.000000,0>}}
//C1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.033200,0.000000,29.591000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.033200,0.000000,28.956000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<37.033200,0.000000,28.956000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.033200,0.000000,28.956000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.033200,0.000000,28.321000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<37.033200,0.000000,28.321000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.033200,0.000000,28.956000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.814000,0.000000,28.956000>}
box{<0,0,-0.076200><1.219200,0.036000,0.076200> rotate<0,0.000000,0> translate<35.814000,0.000000,28.956000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.668200,0.000000,29.591000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.668200,0.000000,28.956000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<37.668200,0.000000,28.956000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.668200,0.000000,28.956000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.668200,0.000000,28.321000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<37.668200,0.000000,28.321000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.668200,0.000000,28.956000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.862000,0.000000,28.956000>}
box{<0,0,-0.076200><1.193800,0.036000,0.076200> rotate<0,0.000000,0> translate<37.668200,0.000000,28.956000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.655000,0.000000,30.226000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.655000,0.000000,27.686000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,-90.000000,0> translate<33.655000,0.000000,27.686000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.909000,0.000000,27.432000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.767000,0.000000,27.432000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<33.909000,0.000000,27.432000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.021000,0.000000,27.686000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.021000,0.000000,30.226000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.021000,0.000000,30.226000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.767000,0.000000,30.480000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.909000,0.000000,30.480000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<33.909000,0.000000,30.480000> }
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<40.767000,0.000000,30.226000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<40.767000,0.000000,27.686000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<33.909000,0.000000,27.686000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<33.909000,0.000000,30.226000>}
//C2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.033200,0.000000,40.259000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.033200,0.000000,39.624000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<37.033200,0.000000,39.624000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.033200,0.000000,39.624000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.033200,0.000000,38.989000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<37.033200,0.000000,38.989000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.033200,0.000000,39.624000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.814000,0.000000,39.624000>}
box{<0,0,-0.076200><1.219200,0.036000,0.076200> rotate<0,0.000000,0> translate<35.814000,0.000000,39.624000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.668200,0.000000,40.259000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.668200,0.000000,39.624000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<37.668200,0.000000,39.624000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.668200,0.000000,39.624000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.668200,0.000000,38.989000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,-90.000000,0> translate<37.668200,0.000000,38.989000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.668200,0.000000,39.624000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.862000,0.000000,39.624000>}
box{<0,0,-0.076200><1.193800,0.036000,0.076200> rotate<0,0.000000,0> translate<37.668200,0.000000,39.624000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.655000,0.000000,40.894000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.655000,0.000000,38.354000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,-90.000000,0> translate<33.655000,0.000000,38.354000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.909000,0.000000,38.100000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.767000,0.000000,38.100000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<33.909000,0.000000,38.100000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.021000,0.000000,38.354000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.021000,0.000000,40.894000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.021000,0.000000,40.894000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.767000,0.000000,41.148000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.909000,0.000000,41.148000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<33.909000,0.000000,41.148000> }
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<40.767000,0.000000,40.894000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<40.767000,0.000000,38.354000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<33.909000,0.000000,38.354000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<33.909000,0.000000,40.894000>}
//C3 silk screen
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.642800,0.000000,31.877000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.642800,0.000000,32.512000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<37.642800,0.000000,32.512000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.642800,0.000000,32.512000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.642800,0.000000,33.147000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<37.642800,0.000000,33.147000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.642800,0.000000,32.512000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.862000,0.000000,32.512000>}
box{<0,0,-0.076200><1.219200,0.036000,0.076200> rotate<0,0.000000,0> translate<37.642800,0.000000,32.512000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.007800,0.000000,31.877000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.007800,0.000000,32.512000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<37.007800,0.000000,32.512000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.007800,0.000000,32.512000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.007800,0.000000,33.147000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<37.007800,0.000000,33.147000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.007800,0.000000,32.512000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.814000,0.000000,32.512000>}
box{<0,0,-0.076200><1.193800,0.036000,0.076200> rotate<0,0.000000,0> translate<35.814000,0.000000,32.512000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.021000,0.000000,31.242000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.021000,0.000000,33.782000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.021000,0.000000,33.782000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.767000,0.000000,34.036000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.909000,0.000000,34.036000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<33.909000,0.000000,34.036000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.655000,0.000000,33.782000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.655000,0.000000,31.242000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,-90.000000,0> translate<33.655000,0.000000,31.242000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.909000,0.000000,30.988000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.767000,0.000000,30.988000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<33.909000,0.000000,30.988000> }
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<33.909000,0.000000,31.242000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<33.909000,0.000000,33.782000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<40.767000,0.000000,33.782000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<40.767000,0.000000,31.242000>}
//C4 silk screen
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<69.646800,0.000000,28.575000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<69.646800,0.000000,29.210000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<69.646800,0.000000,29.210000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<69.646800,0.000000,29.210000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<69.646800,0.000000,29.845000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<69.646800,0.000000,29.845000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.646800,0.000000,29.210000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.866000,0.000000,29.210000>}
box{<0,0,-0.076200><1.219200,0.036000,0.076200> rotate<0,0.000000,0> translate<69.646800,0.000000,29.210000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<69.011800,0.000000,28.575000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<69.011800,0.000000,29.210000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<69.011800,0.000000,29.210000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<69.011800,0.000000,29.210000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<69.011800,0.000000,29.845000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<69.011800,0.000000,29.845000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.011800,0.000000,29.210000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.818000,0.000000,29.210000>}
box{<0,0,-0.076200><1.193800,0.036000,0.076200> rotate<0,0.000000,0> translate<67.818000,0.000000,29.210000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.025000,0.000000,27.940000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.025000,0.000000,30.480000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,90.000000,0> translate<73.025000,0.000000,30.480000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.771000,0.000000,30.734000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.913000,0.000000,30.734000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<65.913000,0.000000,30.734000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.659000,0.000000,30.480000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.659000,0.000000,27.940000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,-90.000000,0> translate<65.659000,0.000000,27.940000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.913000,0.000000,27.686000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.771000,0.000000,27.686000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<65.913000,0.000000,27.686000> }
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<65.913000,0.000000,27.940000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<65.913000,0.000000,30.480000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<72.771000,0.000000,30.480000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<72.771000,0.000000,27.940000>}
//C5 silk screen
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<69.646800,0.000000,36.957000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<69.646800,0.000000,37.592000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<69.646800,0.000000,37.592000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<69.646800,0.000000,37.592000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<69.646800,0.000000,38.227000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<69.646800,0.000000,38.227000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.646800,0.000000,37.592000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.866000,0.000000,37.592000>}
box{<0,0,-0.076200><1.219200,0.036000,0.076200> rotate<0,0.000000,0> translate<69.646800,0.000000,37.592000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<69.011800,0.000000,36.957000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<69.011800,0.000000,37.592000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<69.011800,0.000000,37.592000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<69.011800,0.000000,37.592000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<69.011800,0.000000,38.227000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<69.011800,0.000000,38.227000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.011800,0.000000,37.592000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.818000,0.000000,37.592000>}
box{<0,0,-0.076200><1.193800,0.036000,0.076200> rotate<0,0.000000,0> translate<67.818000,0.000000,37.592000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.025000,0.000000,36.322000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.025000,0.000000,38.862000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,90.000000,0> translate<73.025000,0.000000,38.862000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.771000,0.000000,39.116000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.913000,0.000000,39.116000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<65.913000,0.000000,39.116000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.659000,0.000000,38.862000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.659000,0.000000,36.322000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,-90.000000,0> translate<65.659000,0.000000,36.322000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<65.913000,0.000000,36.068000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.771000,0.000000,36.068000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<65.913000,0.000000,36.068000> }
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<65.913000,0.000000,36.322000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<65.913000,0.000000,38.862000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<72.771000,0.000000,38.862000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<72.771000,0.000000,36.322000>}
//C6 silk screen
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<26.543000,0.000000,14.681200>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<27.178000,0.000000,14.681200>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,0.000000,0> translate<26.543000,0.000000,14.681200> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<27.178000,0.000000,14.681200>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<27.813000,0.000000,14.681200>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,0.000000,0> translate<27.178000,0.000000,14.681200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.178000,0.000000,14.681200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.178000,0.000000,13.462000>}
box{<0,0,-0.076200><1.219200,0.036000,0.076200> rotate<0,-90.000000,0> translate<27.178000,0.000000,13.462000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<26.543000,0.000000,15.316200>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<27.178000,0.000000,15.316200>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,0.000000,0> translate<26.543000,0.000000,15.316200> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<27.178000,0.000000,15.316200>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<27.813000,0.000000,15.316200>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,0.000000,0> translate<27.178000,0.000000,15.316200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.178000,0.000000,15.316200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<27.178000,0.000000,16.510000>}
box{<0,0,-0.076200><1.193800,0.036000,0.076200> rotate<0,90.000000,0> translate<27.178000,0.000000,16.510000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<25.908000,0.000000,11.303000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,11.303000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,0.000000,0> translate<25.908000,0.000000,11.303000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.702000,0.000000,11.557000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.702000,0.000000,18.415000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,90.000000,0> translate<28.702000,0.000000,18.415000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<28.448000,0.000000,18.669000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<25.908000,0.000000,18.669000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,0.000000,0> translate<25.908000,0.000000,18.669000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<25.654000,0.000000,18.415000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<25.654000,0.000000,11.557000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,-90.000000,0> translate<25.654000,0.000000,11.557000> }
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<25.908000,0.000000,18.415000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<28.448000,0.000000,18.415000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<28.448000,0.000000,11.557000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<25.908000,0.000000,11.557000>}
//C7 silk screen
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.642800,0.000000,35.433000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.642800,0.000000,36.068000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<37.642800,0.000000,36.068000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.642800,0.000000,36.068000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.642800,0.000000,36.703000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<37.642800,0.000000,36.703000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.642800,0.000000,36.068000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.862000,0.000000,36.068000>}
box{<0,0,-0.076200><1.219200,0.036000,0.076200> rotate<0,0.000000,0> translate<37.642800,0.000000,36.068000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.007800,0.000000,35.433000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.007800,0.000000,36.068000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<37.007800,0.000000,36.068000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.007800,0.000000,36.068000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<37.007800,0.000000,36.703000>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,90.000000,0> translate<37.007800,0.000000,36.703000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.007800,0.000000,36.068000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.814000,0.000000,36.068000>}
box{<0,0,-0.076200><1.193800,0.036000,0.076200> rotate<0,0.000000,0> translate<35.814000,0.000000,36.068000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.021000,0.000000,34.798000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.021000,0.000000,37.338000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.021000,0.000000,37.338000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.767000,0.000000,37.592000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.909000,0.000000,37.592000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<33.909000,0.000000,37.592000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.655000,0.000000,37.338000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.655000,0.000000,34.798000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,-90.000000,0> translate<33.655000,0.000000,34.798000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.909000,0.000000,34.544000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.767000,0.000000,34.544000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<33.909000,0.000000,34.544000> }
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<33.909000,0.000000,34.798000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<33.909000,0.000000,37.338000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<40.767000,0.000000,37.338000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<40.767000,0.000000,34.798000>}
//C8 silk screen
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<79.883000,0.000000,14.427200>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<80.518000,0.000000,14.427200>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,0.000000,0> translate<79.883000,0.000000,14.427200> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<80.518000,0.000000,14.427200>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<81.153000,0.000000,14.427200>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,0.000000,0> translate<80.518000,0.000000,14.427200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.518000,0.000000,14.427200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.518000,0.000000,13.208000>}
box{<0,0,-0.076200><1.219200,0.036000,0.076200> rotate<0,-90.000000,0> translate<80.518000,0.000000,13.208000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<79.883000,0.000000,15.062200>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<80.518000,0.000000,15.062200>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,0.000000,0> translate<79.883000,0.000000,15.062200> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<80.518000,0.000000,15.062200>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<81.153000,0.000000,15.062200>}
box{<0,0,-0.152400><0.635000,0.036000,0.152400> rotate<0,0.000000,0> translate<80.518000,0.000000,15.062200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.518000,0.000000,15.062200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.518000,0.000000,16.256000>}
box{<0,0,-0.076200><1.193800,0.036000,0.076200> rotate<0,90.000000,0> translate<80.518000,0.000000,16.256000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<79.248000,0.000000,11.049000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.788000,0.000000,11.049000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,0.000000,0> translate<79.248000,0.000000,11.049000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.042000,0.000000,11.303000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.042000,0.000000,18.161000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,90.000000,0> translate<82.042000,0.000000,18.161000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<81.788000,0.000000,18.415000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<79.248000,0.000000,18.415000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,0.000000,0> translate<79.248000,0.000000,18.415000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.994000,0.000000,18.161000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<78.994000,0.000000,11.303000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,-90.000000,0> translate<78.994000,0.000000,11.303000> }
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<79.248000,0.000000,18.161000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<81.788000,0.000000,18.161000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<81.788000,0.000000,11.303000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<79.248000,0.000000,11.303000>}
//C10 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,16.383000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,16.637000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<36.068000,0.000000,16.637000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,16.637000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.338000,0.000000,16.637000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.068000,0.000000,16.637000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.338000,0.000000,16.637000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.338000,0.000000,17.272000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,90.000000,0> translate<37.338000,0.000000,17.272000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.338000,0.000000,17.272000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,17.272000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.798000,0.000000,17.272000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,17.272000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,16.637000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,-90.000000,0> translate<34.798000,0.000000,16.637000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,16.637000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,16.637000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.798000,0.000000,16.637000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,18.161000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,18.669000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,90.000000,0> translate<36.068000,0.000000,18.669000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,11.811000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,13.081000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<36.068000,0.000000,13.081000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.703000,0.000000,12.446000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.433000,0.000000,12.446000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<35.433000,0.000000,12.446000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,18.542000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,19.050000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,90.000000,0> translate<36.068000,0.000000,19.050000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,15.875000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,16.383000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,90.000000,0> translate<36.068000,0.000000,16.383000> }
difference{
cylinder{<36.068000,0,17.526000><36.068000,0.036000,17.526000>7.061200 translate<0,0.000000,0>}
cylinder{<36.068000,-0.1,17.526000><36.068000,0.135000,17.526000>6.908800 translate<0,0.000000,0>}}
box{<-0.317500,0,-1.270000><0.317500,0.036000,1.270000> rotate<0,-90.000000,0> translate<36.068000,0.000000,18.097500>}
//C11 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.279000,0.000000,11.557000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.279000,0.000000,12.319000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,90.000000,0> translate<73.279000,0.000000,12.319000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.660000,0.000000,11.938000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.898000,0.000000,11.938000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<72.898000,0.000000,11.938000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<74.422000,0.000000,13.335000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<74.422000,0.000000,14.224000>}
box{<0,0,-0.076200><0.889000,0.036000,0.076200> rotate<0,90.000000,0> translate<74.422000,0.000000,14.224000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<74.422000,0.000000,14.224000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<75.692000,0.000000,14.224000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<74.422000,0.000000,14.224000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<75.692000,0.000000,14.224000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<75.692000,0.000000,14.732000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,90.000000,0> translate<75.692000,0.000000,14.732000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<75.692000,0.000000,14.732000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.152000,0.000000,14.732000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,0.000000,0> translate<73.152000,0.000000,14.732000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.152000,0.000000,14.732000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.152000,0.000000,14.224000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,-90.000000,0> translate<73.152000,0.000000,14.224000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.152000,0.000000,14.224000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<74.422000,0.000000,14.224000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<73.152000,0.000000,14.224000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<74.422000,0.000000,15.621000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<74.422000,0.000000,16.637000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<74.422000,0.000000,16.637000> }
difference{
cylinder{<74.422000,0,14.986000><74.422000,0.036000,14.986000>4.140200 translate<0,0.000000,0>}
cylinder{<74.422000,-0.1,14.986000><74.422000,0.135000,14.986000>3.987800 translate<0,0.000000,0>}}
box{<-0.254000,0,-1.270000><0.254000,0.036000,1.270000> rotate<0,-90.000000,0> translate<74.422000,0.000000,15.494000>}
//DRIVER silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<45.529000,0.000000,24.701000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<60.694000,0.000000,24.701000>}
box{<0,0,-0.101600><15.165000,0.036000,0.101600> rotate<0,0.000000,0> translate<45.529000,0.000000,24.701000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<62.929000,0.000000,26.936000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<62.929000,0.000000,42.101000>}
box{<0,0,-0.101600><15.165000,0.036000,0.101600> rotate<0,90.000000,0> translate<62.929000,0.000000,42.101000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<62.929000,0.000000,42.101000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<45.529000,0.000000,42.101000>}
box{<0,0,-0.101600><17.400000,0.036000,0.101600> rotate<0,0.000000,0> translate<45.529000,0.000000,42.101000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<45.529000,0.000000,42.101000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<45.529000,0.000000,24.701000>}
box{<0,0,-0.101600><17.400000,0.036000,0.101600> rotate<0,-90.000000,0> translate<45.529000,0.000000,24.701000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<60.694000,0.000000,24.701000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<62.929000,0.000000,26.936000>}
box{<0,0,-0.101600><3.160767,0.036000,0.101600> rotate<0,-44.997030,0> translate<60.694000,0.000000,24.701000> }
difference{
cylinder{<54.229000,0,25.801000><54.229000,0.036000,25.801000>0.604800 translate<0,0.000000,0>}
cylinder{<54.229000,-0.1,25.801000><54.229000,0.135000,25.801000>0.000000 translate<0,0.000000,0>}}
box{<-0.260000,0,-0.225000><0.260000,0.036000,0.225000> rotate<0,-180.000000,0> translate<54.229000,0.000000,24.426000>}
box{<-0.260000,0,-0.225000><0.260000,0.036000,0.225000> rotate<0,-180.000000,0> translate<55.499000,0.000000,24.426000>}
box{<-0.260000,0,-0.225000><0.260000,0.036000,0.225000> rotate<0,-180.000000,0> translate<56.769000,0.000000,24.426000>}
box{<-0.260000,0,-0.225000><0.260000,0.036000,0.225000> rotate<0,-180.000000,0> translate<58.039000,0.000000,24.426000>}
box{<-0.260000,0,-0.225000><0.260000,0.036000,0.225000> rotate<0,-180.000000,0> translate<59.309000,0.000000,24.426000>}
box{<-0.260000,0,-0.225000><0.260000,0.036000,0.225000> rotate<0,-180.000000,0> translate<60.579000,0.000000,24.426000>}
box{<-0.225000,0,-0.260000><0.225000,0.036000,0.260000> rotate<0,-180.000000,0> translate<63.204000,0.000000,27.051000>}
box{<-0.225000,0,-0.260000><0.225000,0.036000,0.260000> rotate<0,-180.000000,0> translate<63.204000,0.000000,28.321000>}
box{<-0.225000,0,-0.260000><0.225000,0.036000,0.260000> rotate<0,-180.000000,0> translate<63.204000,0.000000,29.591000>}
box{<-0.225000,0,-0.260000><0.225000,0.036000,0.260000> rotate<0,-180.000000,0> translate<63.204000,0.000000,30.861000>}
box{<-0.225000,0,-0.260000><0.225000,0.036000,0.260000> rotate<0,-180.000000,0> translate<63.204000,0.000000,32.131000>}
box{<-0.225000,0,-0.260000><0.225000,0.036000,0.260000> rotate<0,-180.000000,0> translate<63.204000,0.000000,33.401000>}
box{<-0.225000,0,-0.260000><0.225000,0.036000,0.260000> rotate<0,-180.000000,0> translate<63.204000,0.000000,34.671000>}
box{<-0.225000,0,-0.260000><0.225000,0.036000,0.260000> rotate<0,-180.000000,0> translate<63.204000,0.000000,35.941000>}
box{<-0.225000,0,-0.260000><0.225000,0.036000,0.260000> rotate<0,-180.000000,0> translate<63.204000,0.000000,37.211000>}
box{<-0.225000,0,-0.260000><0.225000,0.036000,0.260000> rotate<0,-180.000000,0> translate<63.204000,0.000000,38.481000>}
box{<-0.225000,0,-0.260000><0.225000,0.036000,0.260000> rotate<0,-180.000000,0> translate<63.204000,0.000000,39.751000>}
box{<-0.260000,0,-0.225000><0.260000,0.036000,0.225000> rotate<0,-180.000000,0> translate<60.579000,0.000000,42.376000>}
box{<-0.260000,0,-0.225000><0.260000,0.036000,0.225000> rotate<0,-180.000000,0> translate<59.309000,0.000000,42.376000>}
box{<-0.260000,0,-0.225000><0.260000,0.036000,0.225000> rotate<0,-180.000000,0> translate<58.039000,0.000000,42.376000>}
box{<-0.260000,0,-0.225000><0.260000,0.036000,0.225000> rotate<0,-180.000000,0> translate<56.769000,0.000000,42.376000>}
box{<-0.260000,0,-0.225000><0.260000,0.036000,0.225000> rotate<0,-180.000000,0> translate<55.499000,0.000000,42.376000>}
box{<-0.260000,0,-0.225000><0.260000,0.036000,0.225000> rotate<0,-180.000000,0> translate<54.229000,0.000000,42.376000>}
box{<-0.260000,0,-0.225000><0.260000,0.036000,0.225000> rotate<0,-180.000000,0> translate<52.959000,0.000000,42.376000>}
box{<-0.260000,0,-0.225000><0.260000,0.036000,0.225000> rotate<0,-180.000000,0> translate<51.689000,0.000000,42.376000>}
box{<-0.260000,0,-0.225000><0.260000,0.036000,0.225000> rotate<0,-180.000000,0> translate<50.419000,0.000000,42.376000>}
box{<-0.260000,0,-0.225000><0.260000,0.036000,0.225000> rotate<0,-180.000000,0> translate<49.149000,0.000000,42.376000>}
box{<-0.260000,0,-0.225000><0.260000,0.036000,0.225000> rotate<0,-180.000000,0> translate<47.879000,0.000000,42.376000>}
box{<-0.225000,0,-0.260000><0.225000,0.036000,0.260000> rotate<0,-180.000000,0> translate<45.254000,0.000000,39.751000>}
box{<-0.225000,0,-0.260000><0.225000,0.036000,0.260000> rotate<0,-180.000000,0> translate<45.254000,0.000000,38.481000>}
box{<-0.225000,0,-0.260000><0.225000,0.036000,0.260000> rotate<0,-180.000000,0> translate<45.254000,0.000000,37.211000>}
box{<-0.225000,0,-0.260000><0.225000,0.036000,0.260000> rotate<0,-180.000000,0> translate<45.254000,0.000000,35.941000>}
box{<-0.225000,0,-0.260000><0.225000,0.036000,0.260000> rotate<0,-180.000000,0> translate<45.254000,0.000000,34.671000>}
box{<-0.225000,0,-0.260000><0.225000,0.036000,0.260000> rotate<0,-180.000000,0> translate<45.254000,0.000000,33.401000>}
box{<-0.225000,0,-0.260000><0.225000,0.036000,0.260000> rotate<0,-180.000000,0> translate<45.254000,0.000000,32.131000>}
box{<-0.225000,0,-0.260000><0.225000,0.036000,0.260000> rotate<0,-180.000000,0> translate<45.254000,0.000000,30.861000>}
box{<-0.225000,0,-0.260000><0.225000,0.036000,0.260000> rotate<0,-180.000000,0> translate<45.254000,0.000000,29.591000>}
box{<-0.225000,0,-0.260000><0.225000,0.036000,0.260000> rotate<0,-180.000000,0> translate<45.254000,0.000000,28.321000>}
box{<-0.225000,0,-0.260000><0.225000,0.036000,0.260000> rotate<0,-180.000000,0> translate<45.254000,0.000000,27.051000>}
box{<-0.260000,0,-0.225000><0.260000,0.036000,0.225000> rotate<0,-180.000000,0> translate<47.879000,0.000000,24.426000>}
box{<-0.260000,0,-0.225000><0.260000,0.036000,0.225000> rotate<0,-180.000000,0> translate<49.149000,0.000000,24.426000>}
box{<-0.260000,0,-0.225000><0.260000,0.036000,0.225000> rotate<0,-180.000000,0> translate<50.419000,0.000000,24.426000>}
box{<-0.260000,0,-0.225000><0.260000,0.036000,0.225000> rotate<0,-180.000000,0> translate<51.689000,0.000000,24.426000>}
box{<-0.260000,0,-0.225000><0.260000,0.036000,0.225000> rotate<0,-180.000000,0> translate<52.959000,0.000000,24.426000>}
//IC2 silk screen
object{ARC(2.667000,0.152400,17.146796,128.245791,0.036000) translate<68.326000,0.000000,20.320000>}
object{ARC(2.666900,0.152400,231.752879,342.852571,0.036000) translate<68.326000,0.000000,20.319500>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.675000,0.000000,22.415000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.675000,0.000000,18.225000>}
box{<0,0,-0.076200><4.190000,0.036000,0.076200> rotate<0,-90.000000,0> translate<66.675000,0.000000,18.225000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.072000,0.000000,22.975000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.072000,0.000000,22.574000>}
box{<0,0,-0.076200><0.401000,0.036000,0.076200> rotate<0,-90.000000,0> translate<68.072000,0.000000,22.574000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.072000,0.000000,18.066000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.072000,0.000000,17.665000>}
box{<0,0,-0.076200><0.401000,0.036000,0.076200> rotate<0,-90.000000,0> translate<68.072000,0.000000,17.665000> }
object{ARC(2.667000,0.152400,342.853204,377.146796,0.036000) translate<68.326000,0.000000,20.320000>}
//J1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,49.996000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,47.117000>}
box{<0,0,-0.101600><2.879004,0.036000,0.101600> rotate<0,89.894561,0> translate<29.078000,0.000000,49.996000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,46.609000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,45.847000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-90.000000,0> translate<29.078000,0.000000,45.847000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,45.339000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,44.577000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-90.000000,0> translate<29.083000,0.000000,44.577000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,44.069000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,43.307000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-90.000000,0> translate<29.083000,0.000000,43.307000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,42.799000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,42.037000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-90.000000,0> translate<29.083000,0.000000,42.037000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,41.529000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.077900,0.000000,40.767000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-89.986542,0> translate<29.077900,0.000000,40.767000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,40.259000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,39.497000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-90.000000,0> translate<29.083000,0.000000,39.497000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,38.989000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083100,0.000000,38.227000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,89.986542,0> translate<29.083000,0.000000,38.989000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.077900,0.000000,37.719000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,34.840000>}
box{<0,0,-0.101600><2.879000,0.036000,0.101600> rotate<0,89.992070,0> translate<29.077900,0.000000,37.719000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,45.847000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,45.339000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<27.813000,0.000000,45.339000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,44.577000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,44.069000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<25.273000,0.000000,44.069000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,43.307000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,42.799000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<27.813000,0.000000,42.799000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,45.847000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,45.847000>}
box{<0,0,-0.101600><0.005000,0.036000,0.101600> rotate<0,0.000000,0> translate<29.078000,0.000000,45.847000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,45.847000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,45.847000>}
box{<0,0,-0.101600><1.265000,0.036000,0.101600> rotate<0,0.000000,0> translate<27.813000,0.000000,45.847000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,44.577000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,44.577000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<25.273000,0.000000,44.577000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,45.339000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,45.339000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<27.813000,0.000000,45.339000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,43.307000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,43.307000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<27.813000,0.000000,43.307000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,44.069000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,44.069000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<25.273000,0.000000,44.069000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,42.037000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,42.037000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<25.273000,0.000000,42.037000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,42.799000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,42.799000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<27.813000,0.000000,42.799000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,42.037000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,41.529000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<25.273000,0.000000,41.529000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,41.529000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,41.529000>}
box{<0,0,-0.101600><0.005000,0.036000,0.101600> rotate<0,0.000000,0> translate<29.078000,0.000000,41.529000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,41.529000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,41.529000>}
box{<0,0,-0.101600><3.805000,0.036000,0.101600> rotate<0,0.000000,0> translate<25.273000,0.000000,41.529000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,47.117000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,46.609000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<25.273000,0.000000,46.609000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,47.117000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,47.117000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<25.273000,0.000000,47.117000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,46.609000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,46.609000>}
box{<0,0,-0.101600><0.005000,0.036000,0.101600> rotate<0,0.000000,0> translate<29.078000,0.000000,46.609000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,46.609000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,46.609000>}
box{<0,0,-0.101600><3.805000,0.036000,0.101600> rotate<0,0.000000,0> translate<25.273000,0.000000,46.609000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,40.767000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,40.259000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<27.813000,0.000000,40.259000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083100,0.000000,40.767000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,40.767000>}
box{<0,0,-0.101600><1.270100,0.036000,0.101600> rotate<0,0.000000,0> translate<27.813000,0.000000,40.767000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,40.259000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,40.259000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<27.813000,0.000000,40.259000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,38.989000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.077900,0.000000,38.227000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-89.986542,0> translate<29.077900,0.000000,38.227000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,39.497000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,39.497000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<25.273000,0.000000,39.497000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,39.497000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,38.989000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<25.273000,0.000000,38.989000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,38.989000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,38.989000>}
box{<0,0,-0.101600><3.805000,0.036000,0.101600> rotate<0,0.000000,0> translate<25.273000,0.000000,38.989000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,38.227000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,37.719000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<27.813000,0.000000,37.719000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083100,0.000000,38.227000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,38.227000>}
box{<0,0,-0.101600><1.270100,0.036000,0.101600> rotate<0,0.000000,0> translate<27.813000,0.000000,38.227000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083100,0.000000,37.719000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.077900,0.000000,37.719000>}
box{<0,0,-0.101600><0.005200,0.036000,0.101600> rotate<0,0.000000,0> translate<29.077900,0.000000,37.719000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.077900,0.000000,37.719000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,37.719000>}
box{<0,0,-0.101600><1.264900,0.036000,0.101600> rotate<0,0.000000,0> translate<27.813000,0.000000,37.719000> }
//J2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,34.375000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,31.496000>}
box{<0,0,-0.101600><2.879004,0.036000,0.101600> rotate<0,89.894561,0> translate<29.078000,0.000000,34.375000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,30.988000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,30.226000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-90.000000,0> translate<29.078000,0.000000,30.226000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,29.718000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,28.956000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-90.000000,0> translate<29.083000,0.000000,28.956000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,28.448000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,27.686000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-90.000000,0> translate<29.083000,0.000000,27.686000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,27.178000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,26.416000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-90.000000,0> translate<29.083000,0.000000,26.416000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,25.908000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.077900,0.000000,25.146000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-89.986542,0> translate<29.077900,0.000000,25.146000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,24.638000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,23.876000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-90.000000,0> translate<29.083000,0.000000,23.876000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,23.368000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083100,0.000000,22.606000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,89.986542,0> translate<29.083000,0.000000,23.368000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.077900,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,19.219000>}
box{<0,0,-0.101600><2.879000,0.036000,0.101600> rotate<0,89.992070,0> translate<29.077900,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,30.226000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,29.718000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<27.813000,0.000000,29.718000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,28.956000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,28.448000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<25.273000,0.000000,28.448000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,27.686000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,27.178000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<27.813000,0.000000,27.178000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,30.226000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,30.226000>}
box{<0,0,-0.101600><0.005000,0.036000,0.101600> rotate<0,0.000000,0> translate<29.078000,0.000000,30.226000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,30.226000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,30.226000>}
box{<0,0,-0.101600><1.265000,0.036000,0.101600> rotate<0,0.000000,0> translate<27.813000,0.000000,30.226000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,28.956000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,28.956000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<25.273000,0.000000,28.956000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,29.718000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,29.718000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<27.813000,0.000000,29.718000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,27.686000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,27.686000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<27.813000,0.000000,27.686000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,28.448000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,28.448000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<25.273000,0.000000,28.448000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,26.416000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,26.416000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<25.273000,0.000000,26.416000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,27.178000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,27.178000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<27.813000,0.000000,27.178000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,26.416000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,25.908000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<25.273000,0.000000,25.908000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,25.908000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,25.908000>}
box{<0,0,-0.101600><0.005000,0.036000,0.101600> rotate<0,0.000000,0> translate<29.078000,0.000000,25.908000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,25.908000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,25.908000>}
box{<0,0,-0.101600><3.805000,0.036000,0.101600> rotate<0,0.000000,0> translate<25.273000,0.000000,25.908000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,31.496000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,30.988000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<25.273000,0.000000,30.988000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,31.496000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,31.496000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<25.273000,0.000000,31.496000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,30.988000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,30.988000>}
box{<0,0,-0.101600><0.005000,0.036000,0.101600> rotate<0,0.000000,0> translate<29.078000,0.000000,30.988000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,30.988000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,30.988000>}
box{<0,0,-0.101600><3.805000,0.036000,0.101600> rotate<0,0.000000,0> translate<25.273000,0.000000,30.988000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,25.146000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,24.638000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<27.813000,0.000000,24.638000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083100,0.000000,25.146000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,25.146000>}
box{<0,0,-0.101600><1.270100,0.036000,0.101600> rotate<0,0.000000,0> translate<27.813000,0.000000,25.146000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,24.638000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,24.638000>}
box{<0,0,-0.101600><1.270000,0.036000,0.101600> rotate<0,0.000000,0> translate<27.813000,0.000000,24.638000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,23.368000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.077900,0.000000,22.606000>}
box{<0,0,-0.101600><0.762000,0.036000,0.101600> rotate<0,-89.986542,0> translate<29.077900,0.000000,22.606000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083000,0.000000,23.876000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,23.876000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<25.273000,0.000000,23.876000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,23.876000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,23.368000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<25.273000,0.000000,23.368000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.078000,0.000000,23.368000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<25.273000,0.000000,23.368000>}
box{<0,0,-0.101600><3.805000,0.036000,0.101600> rotate<0,0.000000,0> translate<25.273000,0.000000,23.368000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,22.606000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,22.098000>}
box{<0,0,-0.101600><0.508000,0.036000,0.101600> rotate<0,-90.000000,0> translate<27.813000,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083100,0.000000,22.606000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,22.606000>}
box{<0,0,-0.101600><1.270100,0.036000,0.101600> rotate<0,0.000000,0> translate<27.813000,0.000000,22.606000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.083100,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.077900,0.000000,22.098000>}
box{<0,0,-0.101600><0.005200,0.036000,0.101600> rotate<0,0.000000,0> translate<29.077900,0.000000,22.098000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<29.077900,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<27.813000,0.000000,22.098000>}
box{<0,0,-0.101600><1.264900,0.036000,0.101600> rotate<0,0.000000,0> translate<27.813000,0.000000,22.098000> }
//JP1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.342000,0.000000,14.224000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.596000,0.000000,13.970000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<69.342000,0.000000,14.224000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.342000,0.000000,14.224000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.596000,0.000000,14.478000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<69.342000,0.000000,14.224000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.310000,0.000000,14.224000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.056000,0.000000,13.970000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<67.056000,0.000000,13.970000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.310000,0.000000,14.224000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.056000,0.000000,14.478000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<67.056000,0.000000,14.478000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.056000,0.000000,14.478000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.056000,0.000000,16.510000>}
box{<0,0,-0.076200><2.032000,0.036000,0.076200> rotate<0,90.000000,0> translate<67.056000,0.000000,16.510000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.310000,0.000000,16.764000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.056000,0.000000,16.510000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<67.056000,0.000000,16.510000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.056000,0.000000,11.938000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.310000,0.000000,11.684000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<67.056000,0.000000,11.938000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.056000,0.000000,11.938000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.056000,0.000000,13.970000>}
box{<0,0,-0.076200><2.032000,0.036000,0.076200> rotate<0,90.000000,0> translate<67.056000,0.000000,13.970000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.310000,0.000000,11.684000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.342000,0.000000,11.684000>}
box{<0,0,-0.076200><2.032000,0.036000,0.076200> rotate<0,0.000000,0> translate<67.310000,0.000000,11.684000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.596000,0.000000,11.938000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.342000,0.000000,11.684000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<69.342000,0.000000,11.684000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.596000,0.000000,11.938000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.596000,0.000000,13.970000>}
box{<0,0,-0.076200><2.032000,0.036000,0.076200> rotate<0,90.000000,0> translate<69.596000,0.000000,13.970000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.596000,0.000000,14.478000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.596000,0.000000,16.510000>}
box{<0,0,-0.076200><2.032000,0.036000,0.076200> rotate<0,90.000000,0> translate<69.596000,0.000000,16.510000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.342000,0.000000,16.764000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.596000,0.000000,16.510000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<69.342000,0.000000,16.764000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.342000,0.000000,16.764000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.310000,0.000000,16.764000>}
box{<0,0,-0.076200><2.032000,0.036000,0.076200> rotate<0,0.000000,0> translate<67.310000,0.000000,16.764000> }
box{<-0.304800,0,-0.304800><0.304800,0.036000,0.304800> rotate<0,-180.000000,0> translate<68.326000,0.000000,12.954000>}
box{<-0.304800,0,-0.304800><0.304800,0.036000,0.304800> rotate<0,-180.000000,0> translate<68.326000,0.000000,15.494000>}
//LED1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<89.535000,0.000000,12.573000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<89.535000,0.000000,16.383000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,90.000000,0> translate<89.535000,0.000000,16.383000> }
object{ARC(3.175000,0.254000,36.869898,323.130102,0.036000) translate<86.995000,0.000000,14.478000>}
object{ARC(1.143000,0.152400,90.000000,180.000000,0.036000) translate<86.995000,0.000000,14.478000>}
object{ARC(1.143000,0.152400,270.000000,360.000000,0.036000) translate<86.995000,0.000000,14.478000>}
object{ARC(1.651000,0.152400,90.000000,180.000000,0.036000) translate<86.995000,0.000000,14.478000>}
object{ARC(1.651000,0.152400,270.000000,360.000000,0.036000) translate<86.995000,0.000000,14.478000>}
object{ARC(2.159000,0.152400,90.000000,180.000000,0.036000) translate<86.995000,0.000000,14.478000>}
object{ARC(2.159000,0.152400,270.000000,360.000000,0.036000) translate<86.995000,0.000000,14.478000>}
difference{
cylinder{<86.995000,0,14.478000><86.995000,0.036000,14.478000>2.616200 translate<0,0.000000,0>}
cylinder{<86.995000,-0.1,14.478000><86.995000,0.135000,14.478000>2.463800 translate<0,0.000000,0>}}
//LED2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.409000,0.000000,27.178000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<93.599000,0.000000,27.178000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<93.599000,0.000000,27.178000> }
object{ARC(3.175000,0.254000,126.869898,413.130102,0.036000) translate<95.504000,0.000000,24.638000>}
object{ARC(1.143000,0.152400,180.000000,270.000000,0.036000) translate<95.504000,0.000000,24.638000>}
object{ARC(1.143000,0.152400,0.000000,90.000000,0.036000) translate<95.504000,0.000000,24.638000>}
object{ARC(1.651000,0.152400,180.000000,270.000000,0.036000) translate<95.504000,0.000000,24.638000>}
object{ARC(1.651000,0.152400,0.000000,90.000000,0.036000) translate<95.504000,0.000000,24.638000>}
object{ARC(2.159000,0.152400,180.000000,270.000000,0.036000) translate<95.504000,0.000000,24.638000>}
object{ARC(2.159000,0.152400,0.000000,90.000000,0.036000) translate<95.504000,0.000000,24.638000>}
difference{
cylinder{<95.504000,0,24.638000><95.504000,0.036000,24.638000>2.616200 translate<0,0.000000,0>}
cylinder{<95.504000,-0.1,24.638000><95.504000,0.135000,24.638000>2.463800 translate<0,0.000000,0>}}
//LED3 silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<86.995000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.805000,0.000000,22.098000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<86.995000,0.000000,22.098000> }
object{ARC(3.175000,0.254000,306.869898,593.130102,0.036000) translate<88.900000,0.000000,24.638000>}
object{ARC(1.143000,0.152400,0.000000,90.000000,0.036000) translate<88.900000,0.000000,24.638000>}
object{ARC(1.143000,0.152400,180.000000,270.000000,0.036000) translate<88.900000,0.000000,24.638000>}
object{ARC(1.651000,0.152400,0.000000,90.000000,0.036000) translate<88.900000,0.000000,24.638000>}
object{ARC(1.651000,0.152400,180.000000,270.000000,0.036000) translate<88.900000,0.000000,24.638000>}
object{ARC(2.159000,0.152400,0.000000,90.000000,0.036000) translate<88.900000,0.000000,24.638000>}
object{ARC(2.159000,0.152400,180.000000,270.000000,0.036000) translate<88.900000,0.000000,24.638000>}
difference{
cylinder{<88.900000,0,24.638000><88.900000,0.036000,24.638000>2.616200 translate<0,0.000000,0>}
cylinder{<88.900000,-0.1,24.638000><88.900000,0.135000,24.638000>2.463800 translate<0,0.000000,0>}}
//LED4 silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<93.599000,0.000000,45.085000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<97.409000,0.000000,45.085000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<93.599000,0.000000,45.085000> }
object{ARC(3.175000,0.254000,306.869898,593.130102,0.036000) translate<95.504000,0.000000,47.625000>}
object{ARC(1.143000,0.152400,0.000000,90.000000,0.036000) translate<95.504000,0.000000,47.625000>}
object{ARC(1.143000,0.152400,180.000000,270.000000,0.036000) translate<95.504000,0.000000,47.625000>}
object{ARC(1.651000,0.152400,0.000000,90.000000,0.036000) translate<95.504000,0.000000,47.625000>}
object{ARC(1.651000,0.152400,180.000000,270.000000,0.036000) translate<95.504000,0.000000,47.625000>}
object{ARC(2.159000,0.152400,0.000000,90.000000,0.036000) translate<95.504000,0.000000,47.625000>}
object{ARC(2.159000,0.152400,180.000000,270.000000,0.036000) translate<95.504000,0.000000,47.625000>}
difference{
cylinder{<95.504000,0,47.625000><95.504000,0.036000,47.625000>2.616200 translate<0,0.000000,0>}
cylinder{<95.504000,-0.1,47.625000><95.504000,0.135000,47.625000>2.463800 translate<0,0.000000,0>}}
//LED5 silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<90.551000,0.000000,50.419000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<86.741000,0.000000,50.419000>}
box{<0,0,-0.101600><3.810000,0.036000,0.101600> rotate<0,0.000000,0> translate<86.741000,0.000000,50.419000> }
object{ARC(3.175000,0.254000,126.869898,413.130102,0.036000) translate<88.646000,0.000000,47.879000>}
object{ARC(1.143000,0.152400,180.000000,270.000000,0.036000) translate<88.646000,0.000000,47.879000>}
object{ARC(1.143000,0.152400,0.000000,90.000000,0.036000) translate<88.646000,0.000000,47.879000>}
object{ARC(1.651000,0.152400,180.000000,270.000000,0.036000) translate<88.646000,0.000000,47.879000>}
object{ARC(1.651000,0.152400,0.000000,90.000000,0.036000) translate<88.646000,0.000000,47.879000>}
object{ARC(2.159000,0.152400,180.000000,270.000000,0.036000) translate<88.646000,0.000000,47.879000>}
object{ARC(2.159000,0.152400,0.000000,90.000000,0.036000) translate<88.646000,0.000000,47.879000>}
difference{
cylinder{<88.646000,0,47.879000><88.646000,0.036000,47.879000>2.616200 translate<0,0.000000,0>}
cylinder{<88.646000,-0.1,47.879000><88.646000,0.135000,47.879000>2.463800 translate<0,0.000000,0>}}
//PAD1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.880000,0.000000,36.753800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.134000,0.000000,36.753800>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<55.880000,0.000000,36.753800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.880000,0.000000,36.753800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.880000,0.000000,36.499800>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<55.880000,0.000000,36.499800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.404000,0.000000,36.753800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.404000,0.000000,36.499800>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<57.404000,0.000000,36.499800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.404000,0.000000,36.753800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.150000,0.000000,36.753800>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.150000,0.000000,36.753800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.404000,0.000000,35.483800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.404000,0.000000,35.229800>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<57.404000,0.000000,35.229800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.404000,0.000000,35.229800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.150000,0.000000,35.229800>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.150000,0.000000,35.229800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.134000,0.000000,35.229800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.880000,0.000000,35.229800>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<55.880000,0.000000,35.229800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.880000,0.000000,35.229800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.880000,0.000000,35.483800>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<55.880000,0.000000,35.483800> }
difference{
cylinder{<56.642000,0,35.991800><56.642000,0.036000,35.991800>0.711200 translate<0,0.000000,0>}
cylinder{<56.642000,-0.1,35.991800><56.642000,0.135000,35.991800>0.558800 translate<0,0.000000,0>}}
//PAD2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.539400,0.000000,31.496000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.793400,0.000000,31.496000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<48.539400,0.000000,31.496000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.539400,0.000000,31.496000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.539400,0.000000,31.242000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<48.539400,0.000000,31.242000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.063400,0.000000,31.496000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.063400,0.000000,31.242000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<50.063400,0.000000,31.242000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.063400,0.000000,31.496000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.809400,0.000000,31.496000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<49.809400,0.000000,31.496000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.063400,0.000000,30.226000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.063400,0.000000,29.972000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<50.063400,0.000000,29.972000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.063400,0.000000,29.972000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.809400,0.000000,29.972000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<49.809400,0.000000,29.972000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.793400,0.000000,29.972000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.539400,0.000000,29.972000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<48.539400,0.000000,29.972000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.539400,0.000000,29.972000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.539400,0.000000,30.226000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<48.539400,0.000000,30.226000> }
difference{
cylinder{<49.301400,0,30.734000><49.301400,0.036000,30.734000>0.711200 translate<0,0.000000,0>}
cylinder{<49.301400,-0.1,30.734000><49.301400,0.135000,30.734000>0.558800 translate<0,0.000000,0>}}
//PAD3 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.022000,0.000000,37.973000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.276000,0.000000,37.973000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<49.022000,0.000000,37.973000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.022000,0.000000,37.973000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.022000,0.000000,37.719000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<49.022000,0.000000,37.719000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.546000,0.000000,37.973000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.546000,0.000000,37.719000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<50.546000,0.000000,37.719000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.546000,0.000000,37.973000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.292000,0.000000,37.973000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<50.292000,0.000000,37.973000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.546000,0.000000,36.703000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.546000,0.000000,36.449000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<50.546000,0.000000,36.449000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.546000,0.000000,36.449000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.292000,0.000000,36.449000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<50.292000,0.000000,36.449000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.276000,0.000000,36.449000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.022000,0.000000,36.449000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<49.022000,0.000000,36.449000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.022000,0.000000,36.449000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.022000,0.000000,36.703000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<49.022000,0.000000,36.703000> }
difference{
cylinder{<49.784000,0,37.211000><49.784000,0.036000,37.211000>0.711200 translate<0,0.000000,0>}
cylinder{<49.784000,-0.1,37.211000><49.784000,0.135000,37.211000>0.558800 translate<0,0.000000,0>}}
//POWER silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<43.160000,0.000000,18.762000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<66.060000,0.000000,18.762000>}
box{<0,0,-0.101600><22.900000,0.036000,0.101600> rotate<0,0.000000,0> translate<43.160000,0.000000,18.762000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<66.060000,0.000000,18.762000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<66.060000,0.000000,12.702000>}
box{<0,0,-0.101600><6.060000,0.036000,0.101600> rotate<0,-90.000000,0> translate<66.060000,0.000000,12.702000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<66.060000,0.000000,12.702000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<64.060000,0.000000,10.702000>}
box{<0,0,-0.101600><2.828427,0.036000,0.101600> rotate<0,-44.997030,0> translate<64.060000,0.000000,10.702000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<64.060000,0.000000,10.702000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<45.160000,0.000000,10.702000>}
box{<0,0,-0.101600><18.900000,0.036000,0.101600> rotate<0,0.000000,0> translate<45.160000,0.000000,10.702000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<45.160000,0.000000,10.702000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<43.160000,0.000000,12.702000>}
box{<0,0,-0.101600><2.828427,0.036000,0.101600> rotate<0,44.997030,0> translate<43.160000,0.000000,12.702000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<43.160000,0.000000,12.702000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<43.160000,0.000000,18.762000>}
box{<0,0,-0.101600><6.060000,0.036000,0.101600> rotate<0,90.000000,0> translate<43.160000,0.000000,18.762000> }
//R1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<73.660000,0.000000,32.131000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<73.279000,0.000000,32.131000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,0.000000,0> translate<73.279000,0.000000,32.131000> }
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<72.771000,0.000000,31.242000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<72.771000,0.000000,33.020000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<66.929000,0.000000,33.020000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<66.929000,0.000000,31.242000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.025000,0.000000,33.020000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.025000,0.000000,31.242000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<73.025000,0.000000,31.242000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.771000,0.000000,30.988000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.390000,0.000000,30.988000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<72.390000,0.000000,30.988000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.263000,0.000000,31.115000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.390000,0.000000,30.988000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<72.263000,0.000000,31.115000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.771000,0.000000,33.274000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.390000,0.000000,33.274000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<72.390000,0.000000,33.274000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.263000,0.000000,33.147000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.390000,0.000000,33.274000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<72.263000,0.000000,33.147000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.437000,0.000000,31.115000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.310000,0.000000,30.988000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<67.310000,0.000000,30.988000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.437000,0.000000,31.115000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.263000,0.000000,31.115000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<67.437000,0.000000,31.115000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.437000,0.000000,33.147000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.310000,0.000000,33.274000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<67.310000,0.000000,33.274000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.437000,0.000000,33.147000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.263000,0.000000,33.147000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<67.437000,0.000000,33.147000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.929000,0.000000,30.988000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.310000,0.000000,30.988000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<66.929000,0.000000,30.988000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.929000,0.000000,33.274000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.310000,0.000000,33.274000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<66.929000,0.000000,33.274000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.675000,0.000000,33.020000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.675000,0.000000,31.242000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<66.675000,0.000000,31.242000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<66.421000,0.000000,32.131000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<66.040000,0.000000,32.131000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,0.000000,0> translate<66.040000,0.000000,32.131000> }
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-180.000000,0> translate<73.152000,0.000000,32.131000>}
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-180.000000,0> translate<66.548000,0.000000,32.131000>}
//R2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<73.660000,0.000000,34.671000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<73.279000,0.000000,34.671000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,0.000000,0> translate<73.279000,0.000000,34.671000> }
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<72.771000,0.000000,33.782000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<72.771000,0.000000,35.560000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<66.929000,0.000000,35.560000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<66.929000,0.000000,33.782000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.025000,0.000000,35.560000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.025000,0.000000,33.782000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<73.025000,0.000000,33.782000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.771000,0.000000,33.528000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.390000,0.000000,33.528000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<72.390000,0.000000,33.528000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.263000,0.000000,33.655000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.390000,0.000000,33.528000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<72.263000,0.000000,33.655000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.771000,0.000000,35.814000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.390000,0.000000,35.814000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<72.390000,0.000000,35.814000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.263000,0.000000,35.687000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.390000,0.000000,35.814000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<72.263000,0.000000,35.687000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.437000,0.000000,33.655000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.310000,0.000000,33.528000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<67.310000,0.000000,33.528000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.437000,0.000000,33.655000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.263000,0.000000,33.655000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<67.437000,0.000000,33.655000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.437000,0.000000,35.687000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.310000,0.000000,35.814000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<67.310000,0.000000,35.814000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.437000,0.000000,35.687000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.263000,0.000000,35.687000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<67.437000,0.000000,35.687000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.929000,0.000000,33.528000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.310000,0.000000,33.528000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<66.929000,0.000000,33.528000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.929000,0.000000,35.814000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.310000,0.000000,35.814000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<66.929000,0.000000,35.814000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.675000,0.000000,35.560000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.675000,0.000000,33.782000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<66.675000,0.000000,33.782000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<66.421000,0.000000,34.671000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<66.040000,0.000000,34.671000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,0.000000,0> translate<66.040000,0.000000,34.671000> }
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-180.000000,0> translate<73.152000,0.000000,34.671000>}
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-180.000000,0> translate<66.548000,0.000000,34.671000>}
//R3 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<43.815000,0.000000,20.828000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<45.085000,0.000000,20.828000>}
box{<0,0,-0.304800><1.270000,0.036000,0.304800> rotate<0,0.000000,0> translate<43.815000,0.000000,20.828000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<56.515000,0.000000,20.828000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<55.245000,0.000000,20.828000>}
box{<0,0,-0.304800><1.270000,0.036000,0.304800> rotate<0,0.000000,0> translate<55.245000,0.000000,20.828000> }
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<54.229000,0.000000,19.558000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<54.229000,0.000000,22.098000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<46.101000,0.000000,22.098000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<46.101000,0.000000,19.558000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.483000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.483000,0.000000,19.558000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,-90.000000,0> translate<54.483000,0.000000,19.558000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.229000,0.000000,19.304000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.594000,0.000000,19.304000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,0.000000,0> translate<53.594000,0.000000,19.304000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.467000,0.000000,19.431000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.594000,0.000000,19.304000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<53.467000,0.000000,19.431000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.229000,0.000000,22.352000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.594000,0.000000,22.352000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,0.000000,0> translate<53.594000,0.000000,22.352000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.467000,0.000000,22.225000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.594000,0.000000,22.352000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<53.467000,0.000000,22.225000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.863000,0.000000,19.431000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.736000,0.000000,19.304000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<46.736000,0.000000,19.304000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.863000,0.000000,19.431000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.467000,0.000000,19.431000>}
box{<0,0,-0.076200><6.604000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.863000,0.000000,19.431000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.863000,0.000000,22.225000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.736000,0.000000,22.352000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<46.736000,0.000000,22.352000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.863000,0.000000,22.225000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.467000,0.000000,22.225000>}
box{<0,0,-0.076200><6.604000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.863000,0.000000,22.225000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.101000,0.000000,19.304000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.736000,0.000000,19.304000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.101000,0.000000,19.304000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.101000,0.000000,22.352000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.736000,0.000000,22.352000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.101000,0.000000,22.352000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.847000,0.000000,22.098000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.847000,0.000000,19.558000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,-90.000000,0> translate<45.847000,0.000000,19.558000> }
box{<-0.431800,0,-0.304800><0.431800,0.036000,0.304800> rotate<0,-180.000000,0> translate<45.415200,0.000000,20.828000>}
box{<-0.431800,0,-0.304800><0.431800,0.036000,0.304800> rotate<0,-180.000000,0> translate<54.914800,0.000000,20.828000>}
//R4 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<33.528000,0.000000,25.908000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<33.909000,0.000000,25.908000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,0.000000,0> translate<33.528000,0.000000,25.908000> }
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<34.417000,0.000000,26.797000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<34.417000,0.000000,25.019000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<40.259000,0.000000,25.019000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<40.259000,0.000000,26.797000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.163000,0.000000,25.019000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.163000,0.000000,26.797000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<34.163000,0.000000,26.797000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.417000,0.000000,27.051000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,27.051000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.417000,0.000000,27.051000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.925000,0.000000,26.924000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,27.051000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<34.798000,0.000000,27.051000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.417000,0.000000,24.765000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,24.765000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.417000,0.000000,24.765000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.925000,0.000000,24.892000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,24.765000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<34.798000,0.000000,24.765000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.751000,0.000000,26.924000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.878000,0.000000,27.051000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<39.751000,0.000000,26.924000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.751000,0.000000,26.924000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.925000,0.000000,26.924000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.925000,0.000000,26.924000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.751000,0.000000,24.892000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.878000,0.000000,24.765000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<39.751000,0.000000,24.892000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.751000,0.000000,24.892000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.925000,0.000000,24.892000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.925000,0.000000,24.892000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.259000,0.000000,27.051000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.878000,0.000000,27.051000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<39.878000,0.000000,27.051000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.259000,0.000000,24.765000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.878000,0.000000,24.765000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<39.878000,0.000000,24.765000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.513000,0.000000,25.019000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.513000,0.000000,26.797000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<40.513000,0.000000,26.797000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<40.767000,0.000000,25.908000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<41.148000,0.000000,25.908000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,0.000000,0> translate<40.767000,0.000000,25.908000> }
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-0.000000,0> translate<34.036000,0.000000,25.908000>}
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-0.000000,0> translate<40.640000,0.000000,25.908000>}
//R5 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<81.280000,0.000000,30.480000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<81.280000,0.000000,30.099000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,-90.000000,0> translate<81.280000,0.000000,30.099000> }
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<82.169000,0.000000,29.591000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<80.391000,0.000000,29.591000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<80.391000,0.000000,23.749000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<82.169000,0.000000,23.749000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.391000,0.000000,29.845000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.169000,0.000000,29.845000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<80.391000,0.000000,29.845000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.423000,0.000000,29.591000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.423000,0.000000,29.210000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<82.423000,0.000000,29.210000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.296000,0.000000,29.083000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.423000,0.000000,29.210000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<82.296000,0.000000,29.083000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.137000,0.000000,29.591000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.137000,0.000000,29.210000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<80.137000,0.000000,29.210000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.264000,0.000000,29.083000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.137000,0.000000,29.210000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<80.137000,0.000000,29.210000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.296000,0.000000,24.257000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.423000,0.000000,24.130000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<82.296000,0.000000,24.257000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.296000,0.000000,24.257000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.296000,0.000000,29.083000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,90.000000,0> translate<82.296000,0.000000,29.083000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.264000,0.000000,24.257000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.137000,0.000000,24.130000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<80.137000,0.000000,24.130000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.264000,0.000000,24.257000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.264000,0.000000,29.083000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,90.000000,0> translate<80.264000,0.000000,29.083000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.423000,0.000000,23.749000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.423000,0.000000,24.130000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<82.423000,0.000000,24.130000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.137000,0.000000,23.749000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.137000,0.000000,24.130000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<80.137000,0.000000,24.130000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.391000,0.000000,23.495000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.169000,0.000000,23.495000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<80.391000,0.000000,23.495000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<81.280000,0.000000,23.241000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<81.280000,0.000000,22.860000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,-90.000000,0> translate<81.280000,0.000000,22.860000> }
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-270.000000,0> translate<81.280000,0.000000,29.972000>}
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-270.000000,0> translate<81.280000,0.000000,23.368000>}
//R7 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<83.566000,0.000000,19.050000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<83.947000,0.000000,19.050000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,0.000000,0> translate<83.566000,0.000000,19.050000> }
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<84.455000,0.000000,19.939000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<84.455000,0.000000,18.161000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<90.297000,0.000000,18.161000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<90.297000,0.000000,19.939000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<84.201000,0.000000,18.161000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<84.201000,0.000000,19.939000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<84.201000,0.000000,19.939000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<84.455000,0.000000,20.193000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<84.836000,0.000000,20.193000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<84.455000,0.000000,20.193000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<84.963000,0.000000,20.066000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<84.836000,0.000000,20.193000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<84.836000,0.000000,20.193000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<84.455000,0.000000,17.907000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<84.836000,0.000000,17.907000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<84.455000,0.000000,17.907000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<84.963000,0.000000,18.034000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<84.836000,0.000000,17.907000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<84.836000,0.000000,17.907000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<89.789000,0.000000,20.066000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<89.916000,0.000000,20.193000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<89.789000,0.000000,20.066000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<89.789000,0.000000,20.066000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<84.963000,0.000000,20.066000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<84.963000,0.000000,20.066000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<89.789000,0.000000,18.034000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<89.916000,0.000000,17.907000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<89.789000,0.000000,18.034000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<89.789000,0.000000,18.034000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<84.963000,0.000000,18.034000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<84.963000,0.000000,18.034000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<90.297000,0.000000,20.193000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<89.916000,0.000000,20.193000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<89.916000,0.000000,20.193000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<90.297000,0.000000,17.907000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<89.916000,0.000000,17.907000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<89.916000,0.000000,17.907000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<90.551000,0.000000,18.161000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<90.551000,0.000000,19.939000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<90.551000,0.000000,19.939000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<90.805000,0.000000,19.050000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<91.186000,0.000000,19.050000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,0.000000,0> translate<90.805000,0.000000,19.050000> }
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-0.000000,0> translate<84.074000,0.000000,19.050000>}
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-0.000000,0> translate<90.678000,0.000000,19.050000>}
//R8 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<81.407000,0.000000,42.291000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<81.407000,0.000000,42.672000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,90.000000,0> translate<81.407000,0.000000,42.672000> }
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<80.518000,0.000000,43.180000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<82.296000,0.000000,43.180000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<82.296000,0.000000,49.022000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<80.518000,0.000000,49.022000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.296000,0.000000,42.926000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.518000,0.000000,42.926000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<80.518000,0.000000,42.926000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.264000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.264000,0.000000,43.561000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<80.264000,0.000000,43.561000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.391000,0.000000,43.688000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.264000,0.000000,43.561000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<80.264000,0.000000,43.561000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.550000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.550000,0.000000,43.561000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<82.550000,0.000000,43.561000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.423000,0.000000,43.688000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.550000,0.000000,43.561000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<82.423000,0.000000,43.688000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.391000,0.000000,48.514000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.264000,0.000000,48.641000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<80.264000,0.000000,48.641000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.391000,0.000000,48.514000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.391000,0.000000,43.688000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,-90.000000,0> translate<80.391000,0.000000,43.688000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.423000,0.000000,48.514000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.550000,0.000000,48.641000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<82.423000,0.000000,48.514000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.423000,0.000000,48.514000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.423000,0.000000,43.688000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,-90.000000,0> translate<82.423000,0.000000,43.688000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.264000,0.000000,49.022000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.264000,0.000000,48.641000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<80.264000,0.000000,48.641000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.550000,0.000000,49.022000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.550000,0.000000,48.641000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<82.550000,0.000000,48.641000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<82.296000,0.000000,49.276000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<80.518000,0.000000,49.276000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<80.518000,0.000000,49.276000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<81.407000,0.000000,49.530000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<81.407000,0.000000,49.911000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,90.000000,0> translate<81.407000,0.000000,49.911000> }
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-90.000000,0> translate<81.407000,0.000000,42.799000>}
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-90.000000,0> translate<81.407000,0.000000,49.403000>}
//R15 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.929000,0.000000,45.593000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.279000,0.000000,45.593000>}
box{<0,0,-0.076200><6.350000,0.036000,0.076200> rotate<0,0.000000,0> translate<66.929000,0.000000,45.593000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.279000,0.000000,52.451000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.644000,0.000000,52.451000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,0.000000,0> translate<72.644000,0.000000,52.451000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.929000,0.000000,45.593000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.675000,0.000000,45.847000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<66.675000,0.000000,45.847000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.929000,0.000000,52.451000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.675000,0.000000,52.197000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<66.675000,0.000000,52.197000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.675000,0.000000,52.197000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.675000,0.000000,50.546000>}
box{<0,0,-0.076200><1.651000,0.036000,0.076200> rotate<0,-90.000000,0> translate<66.675000,0.000000,50.546000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.675000,0.000000,50.546000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.675000,0.000000,49.276000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,-90.000000,0> translate<66.675000,0.000000,49.276000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.675000,0.000000,49.276000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.675000,0.000000,45.847000>}
box{<0,0,-0.076200><3.429000,0.036000,0.076200> rotate<0,-90.000000,0> translate<66.675000,0.000000,45.847000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.279000,0.000000,52.451000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.533000,0.000000,52.197000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,44.997030,0> translate<73.279000,0.000000,52.451000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.279000,0.000000,45.593000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.533000,0.000000,45.847000>}
box{<0,0,-0.076200><0.359210,0.036000,0.076200> rotate<0,-44.997030,0> translate<73.279000,0.000000,45.593000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.533000,0.000000,45.847000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.533000,0.000000,49.276000>}
box{<0,0,-0.076200><3.429000,0.036000,0.076200> rotate<0,90.000000,0> translate<73.533000,0.000000,49.276000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.533000,0.000000,49.276000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.533000,0.000000,50.546000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,90.000000,0> translate<73.533000,0.000000,50.546000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.533000,0.000000,50.546000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<73.533000,0.000000,52.197000>}
box{<0,0,-0.076200><1.651000,0.036000,0.076200> rotate<0,90.000000,0> translate<73.533000,0.000000,52.197000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.342000,0.000000,49.022000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.580000,0.000000,49.022000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<68.580000,0.000000,49.022000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.580000,0.000000,49.022000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.580000,0.000000,48.260000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<68.580000,0.000000,48.260000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<68.580000,0.000000,48.260000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.342000,0.000000,48.260000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<68.580000,0.000000,48.260000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.342000,0.000000,48.260000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.723000,0.000000,47.879000>}
box{<0,0,-0.076200><0.538815,0.036000,0.076200> rotate<0,44.997030,0> translate<69.342000,0.000000,48.260000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.723000,0.000000,47.879000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.723000,0.000000,47.498000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<69.723000,0.000000,47.498000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.723000,0.000000,46.736000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.485000,0.000000,46.736000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<69.723000,0.000000,46.736000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.485000,0.000000,46.736000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.485000,0.000000,47.498000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,90.000000,0> translate<70.485000,0.000000,47.498000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.485000,0.000000,47.879000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.866000,0.000000,48.260000>}
box{<0,0,-0.076200><0.538815,0.036000,0.076200> rotate<0,-44.997030,0> translate<70.485000,0.000000,47.879000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.866000,0.000000,48.260000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.628000,0.000000,48.260000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<70.866000,0.000000,48.260000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.628000,0.000000,48.260000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.628000,0.000000,49.022000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,90.000000,0> translate<71.628000,0.000000,49.022000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.628000,0.000000,49.022000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.866000,0.000000,49.022000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<70.866000,0.000000,49.022000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.485000,0.000000,49.403000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.866000,0.000000,49.022000>}
box{<0,0,-0.076200><0.538815,0.036000,0.076200> rotate<0,44.997030,0> translate<70.485000,0.000000,49.403000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.485000,0.000000,49.403000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.485000,0.000000,49.784000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<70.485000,0.000000,49.784000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.485000,0.000000,50.546000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.723000,0.000000,50.546000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<69.723000,0.000000,50.546000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.723000,0.000000,50.546000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.723000,0.000000,49.784000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<69.723000,0.000000,49.784000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.723000,0.000000,49.403000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.342000,0.000000,49.022000>}
box{<0,0,-0.076200><0.538815,0.036000,0.076200> rotate<0,-44.997030,0> translate<69.342000,0.000000,49.022000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<71.882000,0.000000,50.419000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<72.136000,0.000000,50.673000>}
box{<0,0,-0.152400><0.359210,0.036000,0.152400> rotate<0,-44.997030,0> translate<71.882000,0.000000,50.419000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<68.326000,0.000000,50.419000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<68.072000,0.000000,50.673000>}
box{<0,0,-0.152400><0.359210,0.036000,0.152400> rotate<0,44.997030,0> translate<68.072000,0.000000,50.673000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<67.716400,0.000000,48.641000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<67.335400,0.000000,48.641000>}
box{<0,0,-0.152400><0.381000,0.036000,0.152400> rotate<0,0.000000,0> translate<67.335400,0.000000,48.641000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<68.326000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<68.072000,0.000000,46.736000>}
box{<0,0,-0.152400><0.359210,0.036000,0.152400> rotate<0,-44.997030,0> translate<68.072000,0.000000,46.736000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<70.104000,0.000000,46.304200>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<70.104000,0.000000,45.923200>}
box{<0,0,-0.152400><0.381000,0.036000,0.152400> rotate<0,-90.000000,0> translate<70.104000,0.000000,45.923200> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<72.009000,0.000000,46.990000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<72.263000,0.000000,46.736000>}
box{<0,0,-0.152400><0.359210,0.036000,0.152400> rotate<0,44.997030,0> translate<72.009000,0.000000,46.990000> }
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<72.491600,0.000000,48.641000>}
cylinder{<0,0,0><0,0.036000,0>0.152400 translate<72.872600,0.000000,48.641000>}
box{<0,0,-0.152400><0.381000,0.036000,0.152400> rotate<0,0.000000,0> translate<72.491600,0.000000,48.641000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.723000,0.000000,47.498000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.485000,0.000000,47.498000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<69.723000,0.000000,47.498000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.723000,0.000000,47.498000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.723000,0.000000,46.736000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<69.723000,0.000000,46.736000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.485000,0.000000,47.498000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.485000,0.000000,47.879000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<70.485000,0.000000,47.879000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.723000,0.000000,49.784000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.485000,0.000000,49.784000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,0.000000,0> translate<69.723000,0.000000,49.784000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.723000,0.000000,49.784000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.723000,0.000000,49.403000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<69.723000,0.000000,49.403000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.485000,0.000000,49.784000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.485000,0.000000,50.546000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,90.000000,0> translate<70.485000,0.000000,50.546000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.644000,0.000000,52.070000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.644000,0.000000,52.451000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<72.644000,0.000000,52.451000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.120000,0.000000,52.070000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.088000,0.000000,52.070000>}
box{<0,0,-0.076200><2.032000,0.036000,0.076200> rotate<0,0.000000,0> translate<69.088000,0.000000,52.070000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.564000,0.000000,52.451000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.564000,0.000000,52.070000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<67.564000,0.000000,52.070000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.644000,0.000000,52.451000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.739000,0.000000,52.451000>}
box{<0,0,-0.076200><1.905000,0.036000,0.076200> rotate<0,0.000000,0> translate<70.739000,0.000000,52.451000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<70.739000,0.000000,52.451000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.469000,0.000000,52.451000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<69.469000,0.000000,52.451000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.469000,0.000000,52.451000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.564000,0.000000,52.451000>}
box{<0,0,-0.076200><1.905000,0.036000,0.076200> rotate<0,0.000000,0> translate<67.564000,0.000000,52.451000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.564000,0.000000,52.451000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.929000,0.000000,52.451000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,0.000000,0> translate<66.929000,0.000000,52.451000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<72.644000,0.000000,52.070000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<71.120000,0.000000,52.070000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<71.120000,0.000000,52.070000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<69.088000,0.000000,52.070000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<67.564000,0.000000,52.070000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<67.564000,0.000000,52.070000> }
difference{
cylinder{<70.104000,0,48.641000><70.104000,0.036000,48.641000>2.108200 translate<0,0.000000,0>}
cylinder{<70.104000,-0.1,48.641000><70.104000,0.135000,48.641000>1.955800 translate<0,0.000000,0>}}
//R16 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<43.942000,0.000000,46.863000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<45.212000,0.000000,46.863000>}
box{<0,0,-0.304800><1.270000,0.036000,0.304800> rotate<0,0.000000,0> translate<43.942000,0.000000,46.863000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<56.642000,0.000000,46.863000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<55.372000,0.000000,46.863000>}
box{<0,0,-0.304800><1.270000,0.036000,0.304800> rotate<0,0.000000,0> translate<55.372000,0.000000,46.863000> }
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<54.356000,0.000000,45.593000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<54.356000,0.000000,48.133000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<46.228000,0.000000,48.133000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<46.228000,0.000000,45.593000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.610000,0.000000,48.133000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.610000,0.000000,45.593000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,-90.000000,0> translate<54.610000,0.000000,45.593000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.356000,0.000000,45.339000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.721000,0.000000,45.339000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,0.000000,0> translate<53.721000,0.000000,45.339000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.594000,0.000000,45.466000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.721000,0.000000,45.339000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<53.594000,0.000000,45.466000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.356000,0.000000,48.387000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.721000,0.000000,48.387000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,0.000000,0> translate<53.721000,0.000000,48.387000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.594000,0.000000,48.260000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.721000,0.000000,48.387000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<53.594000,0.000000,48.260000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.990000,0.000000,45.466000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.863000,0.000000,45.339000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<46.863000,0.000000,45.339000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.990000,0.000000,45.466000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.594000,0.000000,45.466000>}
box{<0,0,-0.076200><6.604000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.990000,0.000000,45.466000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.990000,0.000000,48.260000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.863000,0.000000,48.387000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<46.863000,0.000000,48.387000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.990000,0.000000,48.260000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.594000,0.000000,48.260000>}
box{<0,0,-0.076200><6.604000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.990000,0.000000,48.260000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.228000,0.000000,45.339000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.863000,0.000000,45.339000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.228000,0.000000,45.339000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.228000,0.000000,48.387000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.863000,0.000000,48.387000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.228000,0.000000,48.387000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.974000,0.000000,48.133000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.974000,0.000000,45.593000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,-90.000000,0> translate<45.974000,0.000000,45.593000> }
box{<-0.431800,0,-0.304800><0.431800,0.036000,0.304800> rotate<0,-180.000000,0> translate<45.542200,0.000000,46.863000>}
box{<-0.431800,0,-0.304800><0.431800,0.036000,0.304800> rotate<0,-180.000000,0> translate<55.041800,0.000000,46.863000>}
//R17 silk screen
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<33.401000,0.000000,42.926000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<33.782000,0.000000,42.926000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,0.000000,0> translate<33.401000,0.000000,42.926000> }
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<34.290000,0.000000,43.815000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<34.290000,0.000000,42.037000>}
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<40.132000,0.000000,42.037000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<40.132000,0.000000,43.815000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.036000,0.000000,42.037000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.036000,0.000000,43.815000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<34.036000,0.000000,43.815000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.290000,0.000000,44.069000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.671000,0.000000,44.069000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.290000,0.000000,44.069000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,43.942000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.671000,0.000000,44.069000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<34.671000,0.000000,44.069000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.290000,0.000000,41.783000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.671000,0.000000,41.783000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.290000,0.000000,41.783000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,41.910000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.671000,0.000000,41.783000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<34.671000,0.000000,41.783000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.624000,0.000000,43.942000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.751000,0.000000,44.069000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,-44.997030,0> translate<39.624000,0.000000,43.942000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.624000,0.000000,43.942000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,43.942000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.798000,0.000000,43.942000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.624000,0.000000,41.910000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.751000,0.000000,41.783000>}
box{<0,0,-0.076200><0.179605,0.036000,0.076200> rotate<0,44.997030,0> translate<39.624000,0.000000,41.910000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.624000,0.000000,41.910000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,41.910000>}
box{<0,0,-0.076200><4.826000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.798000,0.000000,41.910000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.132000,0.000000,44.069000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.751000,0.000000,44.069000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<39.751000,0.000000,44.069000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.132000,0.000000,41.783000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<39.751000,0.000000,41.783000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<39.751000,0.000000,41.783000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.386000,0.000000,42.037000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.386000,0.000000,43.815000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<40.386000,0.000000,43.815000> }
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<40.640000,0.000000,42.926000>}
cylinder{<0,0,0><0,0.036000,0>0.304800 translate<41.021000,0.000000,42.926000>}
box{<0,0,-0.304800><0.381000,0.036000,0.304800> rotate<0,0.000000,0> translate<40.640000,0.000000,42.926000> }
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-0.000000,0> translate<33.909000,0.000000,42.926000>}
box{<-0.127000,0,-0.304800><0.127000,0.036000,0.304800> rotate<0,-0.000000,0> translate<40.513000,0.000000,42.926000>}
//SJ1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.420000,0.000000,45.847000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.420000,0.000000,50.165000>}
box{<0,0,-0.076200><4.318000,0.036000,0.076200> rotate<0,90.000000,0> translate<58.420000,0.000000,50.165000> }
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<60.198000,0.000000,45.847000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<60.198000,0.000000,50.165000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<58.674000,0.000000,50.165000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<58.674000,0.000000,45.847000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.674000,0.000000,45.593000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.198000,0.000000,45.593000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<58.674000,0.000000,45.593000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.674000,0.000000,50.419000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.198000,0.000000,50.419000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<58.674000,0.000000,50.419000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.452000,0.000000,50.165000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.452000,0.000000,45.847000>}
box{<0,0,-0.076200><4.318000,0.036000,0.076200> rotate<0,-90.000000,0> translate<60.452000,0.000000,45.847000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.436000,0.000000,46.228000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.436000,0.000000,45.720000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,-90.000000,0> translate<59.436000,0.000000,45.720000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.436000,0.000000,49.784000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<59.436000,0.000000,50.292000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,90.000000,0> translate<59.436000,0.000000,50.292000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.198000,0.000000,48.006000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.452000,0.000000,48.006000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<60.198000,0.000000,48.006000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.420000,0.000000,48.006000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<58.674000,0.000000,48.006000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<58.420000,0.000000,48.006000> }
object{ARC(0.127000,1.270000,180.000000,360.000000,0.036000) translate<59.436000,0.000000,46.990000>}
object{ARC(0.127000,1.270000,0.000000,180.000000,0.036000) translate<59.436000,0.000000,49.022000>}
box{<-0.508000,0,-0.762000><0.508000,0.036000,0.762000> rotate<0,-270.000000,0> translate<59.436000,0.000000,48.006000>}
//SJ2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.230000,0.000000,45.847000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.230000,0.000000,50.165000>}
box{<0,0,-0.076200><4.318000,0.036000,0.076200> rotate<0,90.000000,0> translate<62.230000,0.000000,50.165000> }
object{ARC(0.254000,0.152400,270.000000,360.000000,0.036000) translate<64.008000,0.000000,45.847000>}
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<64.008000,0.000000,50.165000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<62.484000,0.000000,50.165000>}
object{ARC(0.254000,0.152400,180.000000,270.000000,0.036000) translate<62.484000,0.000000,45.847000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.484000,0.000000,45.593000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.008000,0.000000,45.593000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<62.484000,0.000000,45.593000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.484000,0.000000,50.419000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.008000,0.000000,50.419000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<62.484000,0.000000,50.419000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.262000,0.000000,50.165000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.262000,0.000000,45.847000>}
box{<0,0,-0.076200><4.318000,0.036000,0.076200> rotate<0,-90.000000,0> translate<64.262000,0.000000,45.847000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<63.246000,0.000000,46.228000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<63.246000,0.000000,45.720000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,-90.000000,0> translate<63.246000,0.000000,45.720000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<63.246000,0.000000,49.784000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<63.246000,0.000000,50.292000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,90.000000,0> translate<63.246000,0.000000,50.292000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.008000,0.000000,48.006000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<64.262000,0.000000,48.006000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<64.008000,0.000000,48.006000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.230000,0.000000,48.006000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.484000,0.000000,48.006000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<62.230000,0.000000,48.006000> }
object{ARC(0.127000,1.270000,180.000000,360.000000,0.036000) translate<63.246000,0.000000,46.990000>}
object{ARC(0.127000,1.270000,0.000000,180.000000,0.036000) translate<63.246000,0.000000,49.022000>}
box{<-0.508000,0,-0.762000><0.508000,0.036000,0.762000> rotate<0,-270.000000,0> translate<63.246000,0.000000,48.006000>}
//SV1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.260000,0.000000,51.562000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.480000,0.000000,51.562000>}
box{<0,0,-0.076200><17.780000,0.036000,0.076200> rotate<0,0.000000,0> translate<30.480000,0.000000,51.562000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.480000,0.000000,57.912000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.480000,0.000000,51.562000>}
box{<0,0,-0.076200><6.350000,0.036000,0.076200> rotate<0,-90.000000,0> translate<30.480000,0.000000,51.562000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.260000,0.000000,51.562000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.260000,0.000000,57.912000>}
box{<0,0,-0.076200><6.350000,0.036000,0.076200> rotate<0,90.000000,0> translate<48.260000,0.000000,57.912000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.530000,0.000000,50.292000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.260000,0.000000,50.292000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<48.260000,0.000000,50.292000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.210000,0.000000,59.182000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.909000,0.000000,59.182000>}
box{<0,0,-0.076200><4.699000,0.036000,0.076200> rotate<0,0.000000,0> translate<29.210000,0.000000,59.182000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.210000,0.000000,59.182000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.210000,0.000000,50.292000>}
box{<0,0,-0.076200><8.890000,0.036000,0.076200> rotate<0,-90.000000,0> translate<29.210000,0.000000,50.292000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.530000,0.000000,50.292000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.530000,0.000000,59.182000>}
box{<0,0,-0.076200><8.890000,0.036000,0.076200> rotate<0,90.000000,0> translate<49.530000,0.000000,59.182000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.480000,0.000000,57.912000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,57.912000>}
box{<0,0,-0.076200><4.318000,0.036000,0.076200> rotate<0,0.000000,0> translate<30.480000,0.000000,57.912000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.338000,0.000000,57.150000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,57.150000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<37.338000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,57.912000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,57.150000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,-90.000000,0> translate<41.402000,0.000000,57.150000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,57.912000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.260000,0.000000,57.912000>}
box{<0,0,-0.076200><6.858000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.402000,0.000000,57.912000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,57.912000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,58.166000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.402000,0.000000,58.166000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.338000,0.000000,57.150000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.338000,0.000000,57.912000>}
box{<0,0,-0.076200><0.762000,0.036000,0.076200> rotate<0,90.000000,0> translate<37.338000,0.000000,57.912000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.338000,0.000000,57.912000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.338000,0.000000,58.166000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<37.338000,0.000000,58.166000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.480000,0.000000,50.292000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.480000,0.000000,50.038000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<30.480000,0.000000,50.038000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.480000,0.000000,50.038000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.750000,0.000000,50.038000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<30.480000,0.000000,50.038000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.750000,0.000000,50.292000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.750000,0.000000,50.038000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<31.750000,0.000000,50.038000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<30.480000,0.000000,50.292000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<29.210000,0.000000,50.292000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<29.210000,0.000000,50.292000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.735000,0.000000,50.038000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.005000,0.000000,50.038000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<38.735000,0.000000,50.038000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.735000,0.000000,50.038000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.735000,0.000000,50.292000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<38.735000,0.000000,50.292000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<38.735000,0.000000,50.292000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<31.750000,0.000000,50.292000>}
box{<0,0,-0.076200><6.985000,0.036000,0.076200> rotate<0,0.000000,0> translate<31.750000,0.000000,50.292000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.005000,0.000000,50.038000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.005000,0.000000,50.292000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<40.005000,0.000000,50.292000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.990000,0.000000,50.038000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.260000,0.000000,50.038000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.990000,0.000000,50.038000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.260000,0.000000,50.038000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.260000,0.000000,50.292000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<48.260000,0.000000,50.292000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.990000,0.000000,50.038000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.990000,0.000000,50.292000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<46.990000,0.000000,50.292000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.990000,0.000000,50.292000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<40.005000,0.000000,50.292000>}
box{<0,0,-0.076200><6.985000,0.036000,0.076200> rotate<0,0.000000,0> translate<40.005000,0.000000,50.292000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.211000,0.000000,59.182000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.338000,0.000000,59.182000>}
box{<0,0,-0.076200><0.127000,0.036000,0.076200> rotate<0,0.000000,0> translate<37.211000,0.000000,59.182000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.338000,0.000000,59.182000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,59.182000>}
box{<0,0,-0.076200><4.064000,0.036000,0.076200> rotate<0,0.000000,0> translate<37.338000,0.000000,59.182000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.322000,0.000000,57.912000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.322000,0.000000,58.166000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<36.322000,0.000000,58.166000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.322000,0.000000,57.912000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.338000,0.000000,57.912000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.322000,0.000000,57.912000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,57.912000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,58.166000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<34.798000,0.000000,58.166000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,57.912000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.322000,0.000000,57.912000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.798000,0.000000,57.912000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.211000,0.000000,59.182000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.830000,0.000000,58.674000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,-53.126596,0> translate<36.830000,0.000000,58.674000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.290000,0.000000,58.674000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<33.909000,0.000000,59.182000>}
box{<0,0,-0.076200><0.635000,0.036000,0.076200> rotate<0,53.126596,0> translate<33.909000,0.000000,59.182000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.290000,0.000000,58.674000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,58.674000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.290000,0.000000,58.674000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<36.322000,0.000000,58.166000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<37.338000,0.000000,58.166000>}
box{<0,0,-0.025400><1.016000,0.036000,0.025400> rotate<0,0.000000,0> translate<36.322000,0.000000,58.166000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.338000,0.000000,58.166000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<37.338000,0.000000,59.182000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<37.338000,0.000000,59.182000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<34.798000,0.000000,58.166000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<30.226000,0.000000,58.166000>}
box{<0,0,-0.025400><4.572000,0.036000,0.025400> rotate<0,0.000000,0> translate<30.226000,0.000000,58.166000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<30.226000,0.000000,58.166000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<30.226000,0.000000,51.308000>}
box{<0,0,-0.025400><6.858000,0.036000,0.025400> rotate<0,-90.000000,0> translate<30.226000,0.000000,51.308000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<30.226000,0.000000,51.308000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<48.514000,0.000000,51.308000>}
box{<0,0,-0.025400><18.288000,0.036000,0.025400> rotate<0,0.000000,0> translate<30.226000,0.000000,51.308000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<48.514000,0.000000,51.308000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<48.514000,0.000000,58.166000>}
box{<0,0,-0.025400><6.858000,0.036000,0.025400> rotate<0,90.000000,0> translate<48.514000,0.000000,58.166000> }
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<48.514000,0.000000,58.166000>}
cylinder{<0,0,0><0,0.036000,0>0.025400 translate<41.402000,0.000000,58.166000>}
box{<0,0,-0.025400><7.112000,0.036000,0.025400> rotate<0,0.000000,0> translate<41.402000,0.000000,58.166000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,58.166000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,59.182000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,90.000000,0> translate<41.402000,0.000000,59.182000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.322000,0.000000,58.166000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.322000,0.000000,58.674000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,90.000000,0> translate<36.322000,0.000000,58.674000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.322000,0.000000,58.674000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.830000,0.000000,58.674000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.322000,0.000000,58.674000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,58.166000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,58.674000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,90.000000,0> translate<34.798000,0.000000,58.674000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,58.674000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.322000,0.000000,58.674000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.798000,0.000000,58.674000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.402000,0.000000,59.182000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.815000,0.000000,59.182000>}
box{<0,0,-0.076200><2.413000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.402000,0.000000,59.182000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.815000,0.000000,59.055000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.815000,0.000000,59.182000>}
box{<0,0,-0.076200><0.127000,0.036000,0.076200> rotate<0,90.000000,0> translate<43.815000,0.000000,59.182000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.815000,0.000000,59.055000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.085000,0.000000,59.055000>}
box{<0,0,-0.076200><1.270000,0.036000,0.076200> rotate<0,0.000000,0> translate<43.815000,0.000000,59.055000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.085000,0.000000,59.182000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.085000,0.000000,59.055000>}
box{<0,0,-0.076200><0.127000,0.036000,0.076200> rotate<0,-90.000000,0> translate<45.085000,0.000000,59.055000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.085000,0.000000,59.182000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.530000,0.000000,59.182000>}
box{<0,0,-0.076200><4.445000,0.036000,0.076200> rotate<0,0.000000,0> translate<45.085000,0.000000,59.182000> }
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<41.910000,0.000000,53.467000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<44.450000,0.000000,53.467000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<39.370000,0.000000,53.467000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<34.290000,0.000000,53.467000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<36.830000,0.000000,53.467000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<41.910000,0.000000,56.007000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<44.450000,0.000000,56.007000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<39.370000,0.000000,56.007000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<34.290000,0.000000,56.007000>}
box{<-0.254000,0,-0.254000><0.254000,0.036000,0.254000> rotate<0,-180.000000,0> translate<36.830000,0.000000,56.007000>}
//U$1 silk screen
object{ARC(2.159000,2.489200,180.000000,270.000000,0.036000) translate<20.447000,0.000000,55.245000>}
object{ARC(2.159000,2.489200,0.000000,90.000000,0.036000) translate<20.447000,0.000000,55.245000>}
difference{
cylinder{<20.447000,0,55.245000><20.447000,0.036000,55.245000>3.505200 translate<0,0.000000,0>}
cylinder{<20.447000,-0.1,55.245000><20.447000,0.135000,55.245000>3.352800 translate<0,0.000000,0>}}
difference{
cylinder{<20.447000,0,55.245000><20.447000,0.036000,55.245000>0.990600 translate<0,0.000000,0>}
cylinder{<20.447000,-0.1,55.245000><20.447000,0.135000,55.245000>0.533400 translate<0,0.000000,0>}}
difference{
cylinder{<20.447000,0,55.245000><20.447000,0.036000,55.245000>1.701600 translate<0,0.000000,0>}
cylinder{<20.447000,-0.1,55.245000><20.447000,0.135000,55.245000>1.498400 translate<0,0.000000,0>}}
//U$2 silk screen
object{ARC(2.159000,2.489200,180.000000,270.000000,0.036000) translate<94.869000,0.000000,55.499000>}
object{ARC(2.159000,2.489200,0.000000,90.000000,0.036000) translate<94.869000,0.000000,55.499000>}
difference{
cylinder{<94.869000,0,55.499000><94.869000,0.036000,55.499000>3.505200 translate<0,0.000000,0>}
cylinder{<94.869000,-0.1,55.499000><94.869000,0.135000,55.499000>3.352800 translate<0,0.000000,0>}}
difference{
cylinder{<94.869000,0,55.499000><94.869000,0.036000,55.499000>0.990600 translate<0,0.000000,0>}
cylinder{<94.869000,-0.1,55.499000><94.869000,0.135000,55.499000>0.533400 translate<0,0.000000,0>}}
difference{
cylinder{<94.869000,0,55.499000><94.869000,0.036000,55.499000>1.701600 translate<0,0.000000,0>}
cylinder{<94.869000,-0.1,55.499000><94.869000,0.135000,55.499000>1.498400 translate<0,0.000000,0>}}
//U$3 silk screen
object{ARC(2.159000,2.489200,180.000000,270.000000,0.036000) translate<20.447000,0.000000,14.605000>}
object{ARC(2.159000,2.489200,0.000000,90.000000,0.036000) translate<20.447000,0.000000,14.605000>}
difference{
cylinder{<20.447000,0,14.605000><20.447000,0.036000,14.605000>3.505200 translate<0,0.000000,0>}
cylinder{<20.447000,-0.1,14.605000><20.447000,0.135000,14.605000>3.352800 translate<0,0.000000,0>}}
difference{
cylinder{<20.447000,0,14.605000><20.447000,0.036000,14.605000>0.990600 translate<0,0.000000,0>}
cylinder{<20.447000,-0.1,14.605000><20.447000,0.135000,14.605000>0.533400 translate<0,0.000000,0>}}
difference{
cylinder{<20.447000,0,14.605000><20.447000,0.036000,14.605000>1.701600 translate<0,0.000000,0>}
cylinder{<20.447000,-0.1,14.605000><20.447000,0.135000,14.605000>1.498400 translate<0,0.000000,0>}}
//U$4 silk screen
object{ARC(2.159000,2.489200,180.000000,270.000000,0.036000) translate<94.869000,0.000000,14.605000>}
object{ARC(2.159000,2.489200,0.000000,90.000000,0.036000) translate<94.869000,0.000000,14.605000>}
difference{
cylinder{<94.869000,0,14.605000><94.869000,0.036000,14.605000>3.505200 translate<0,0.000000,0>}
cylinder{<94.869000,-0.1,14.605000><94.869000,0.135000,14.605000>3.352800 translate<0,0.000000,0>}}
difference{
cylinder{<94.869000,0,14.605000><94.869000,0.036000,14.605000>0.990600 translate<0,0.000000,0>}
cylinder{<94.869000,-0.1,14.605000><94.869000,0.135000,14.605000>0.533400 translate<0,0.000000,0>}}
difference{
cylinder{<94.869000,0,14.605000><94.869000,0.036000,14.605000>1.701600 translate<0,0.000000,0>}
cylinder{<94.869000,-0.1,14.605000><94.869000,0.135000,14.605000>1.498400 translate<0,0.000000,0>}}
//X1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.474000,0.000000,44.092000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.474000,0.000000,42.292000>}
box{<0,0,-0.101600><1.800000,0.036000,0.101600> rotate<0,-90.000000,0> translate<85.474000,0.000000,42.292000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.474000,0.000000,42.292000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.474000,0.000000,30.377000>}
box{<0,0,-0.101600><11.915000,0.036000,0.101600> rotate<0,-90.000000,0> translate<85.474000,0.000000,30.377000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.474000,0.000000,30.377000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.474000,0.000000,28.577000>}
box{<0,0,-0.101600><1.800000,0.036000,0.101600> rotate<0,-90.000000,0> translate<85.474000,0.000000,28.577000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.474000,0.000000,28.577000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.249000,0.000000,28.577000>}
box{<0,0,-0.101600><9.775000,0.036000,0.101600> rotate<0,0.000000,0> translate<85.474000,0.000000,28.577000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.249000,0.000000,28.577000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.249000,0.000000,44.092000>}
box{<0,0,-0.101600><15.515000,0.036000,0.101600> rotate<0,90.000000,0> translate<95.249000,0.000000,44.092000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<95.249000,0.000000,44.092000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.474000,0.000000,44.092000>}
box{<0,0,-0.101600><9.775000,0.036000,0.101600> rotate<0,0.000000,0> translate<85.474000,0.000000,44.092000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<87.899000,0.000000,30.377000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<87.899000,0.000000,42.292000>}
box{<0,0,-0.101600><11.915000,0.036000,0.101600> rotate<0,90.000000,0> translate<87.899000,0.000000,42.292000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<87.899000,0.000000,42.292000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.474000,0.000000,42.292000>}
box{<0,0,-0.101600><2.425000,0.036000,0.101600> rotate<0,0.000000,0> translate<85.474000,0.000000,42.292000> }
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<87.899000,0.000000,30.377000>}
cylinder{<0,0,0><0,0.036000,0>0.101600 translate<85.474000,0.000000,30.377000>}
box{<0,0,-0.101600><2.425000,0.036000,0.101600> rotate<0,0.000000,0> translate<85.474000,0.000000,30.377000> }
//X2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<23.114000,0.000000,46.228000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<23.114000,0.000000,38.608000>}
box{<0,0,-0.127000><7.620000,0.036000,0.127000> rotate<0,-90.000000,0> translate<23.114000,0.000000,38.608000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<23.114000,0.000000,38.608000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<21.209000,0.000000,38.608000>}
box{<0,0,-0.127000><1.905000,0.036000,0.127000> rotate<0,0.000000,0> translate<21.209000,0.000000,38.608000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<21.209000,0.000000,38.608000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<16.764000,0.000000,38.608000>}
box{<0,0,-0.127000><4.445000,0.036000,0.127000> rotate<0,0.000000,0> translate<16.764000,0.000000,38.608000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<16.764000,0.000000,38.608000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<16.764000,0.000000,46.228000>}
box{<0,0,-0.127000><7.620000,0.036000,0.127000> rotate<0,90.000000,0> translate<16.764000,0.000000,46.228000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<16.764000,0.000000,46.228000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<21.209000,0.000000,46.228000>}
box{<0,0,-0.127000><4.445000,0.036000,0.127000> rotate<0,0.000000,0> translate<16.764000,0.000000,46.228000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<21.209000,0.000000,46.228000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<23.114000,0.000000,46.228000>}
box{<0,0,-0.127000><1.905000,0.036000,0.127000> rotate<0,0.000000,0> translate<21.209000,0.000000,46.228000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<21.209000,0.000000,46.228000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<21.209000,0.000000,38.608000>}
box{<0,0,-0.127000><7.620000,0.036000,0.127000> rotate<0,-90.000000,0> translate<21.209000,0.000000,38.608000> }
//X3 silk screen
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<23.114000,0.000000,30.607000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<23.114000,0.000000,22.987000>}
box{<0,0,-0.127000><7.620000,0.036000,0.127000> rotate<0,-90.000000,0> translate<23.114000,0.000000,22.987000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<23.114000,0.000000,22.987000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<21.209000,0.000000,22.987000>}
box{<0,0,-0.127000><1.905000,0.036000,0.127000> rotate<0,0.000000,0> translate<21.209000,0.000000,22.987000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<21.209000,0.000000,22.987000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<16.764000,0.000000,22.987000>}
box{<0,0,-0.127000><4.445000,0.036000,0.127000> rotate<0,0.000000,0> translate<16.764000,0.000000,22.987000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<16.764000,0.000000,22.987000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<16.764000,0.000000,30.607000>}
box{<0,0,-0.127000><7.620000,0.036000,0.127000> rotate<0,90.000000,0> translate<16.764000,0.000000,30.607000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<16.764000,0.000000,30.607000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<21.209000,0.000000,30.607000>}
box{<0,0,-0.127000><4.445000,0.036000,0.127000> rotate<0,0.000000,0> translate<16.764000,0.000000,30.607000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<21.209000,0.000000,30.607000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<23.114000,0.000000,30.607000>}
box{<0,0,-0.127000><1.905000,0.036000,0.127000> rotate<0,0.000000,0> translate<21.209000,0.000000,30.607000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<21.209000,0.000000,30.607000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<21.209000,0.000000,22.987000>}
box{<0,0,-0.127000><7.620000,0.036000,0.127000> rotate<0,-90.000000,0> translate<21.209000,0.000000,22.987000> }
texture{col_slk}
}
#end
translate<mac_x_ver,mac_y_ver,mac_z_ver>
rotate<mac_x_rot,mac_y_rot,mac_z_rot>
}//End union
#end

#if(use_file_as_inc=off)
object{  STEPPER_MOTOR_DRIVER(-57.658000,0,-35.052000,pcb_rotate_x,pcb_rotate_y,pcb_rotate_z)
#if(pcb_upsidedown=on)
rotate pcb_rotdir*180
#end
}
#end


//Parts not found in 3dpack.dat or 3dusrpac.dat are:
//IC2	78L05	78LXX
//J1		520426-4
//J2		520426-4
//PAD1		1,6/0,8
//PAD2		1,6/0,8
//PAD3		1,6/0,8
//POWER	9090-4V	9090-4V
//R15	10K	B25P
//U$1		3,0
//U$2		3,0
//U$3		3,0
//U$4		3,0
//X1		KK-156-4
//X2	22-23-2031	22-23-2031
//X3	22-23-2031	22-23-2031
