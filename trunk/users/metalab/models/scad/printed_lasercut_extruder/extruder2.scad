$fn=30;

module extruder()
{
	dxf_file = "rb_35_lasercut_extruder9.dxf";

	base_h = 4.5;
	screw_inset=3;
	inner_h = 4;
	convexity=4;
	
	peek_dist=dxf_dim(file = dxf_file, name = "peek_dist");
	peek_r = dxf_dim(file = dxf_file, name = "peek_r");
	peek_inner_r = dxf_dim(file = dxf_file, name = "peek_inner_r");
	peek_h = dxf_dim(file = dxf_file, name = "peek_h");


	
	filament_dist = dxf_dim(file = dxf_file, name = "filament_dist");

	module filament()
	{
		translate([-filament_dist, 100, base_h+inner_h/2]) rotate([90, 0,0]) cylinder(h=200, r=2);
	}
	
	module peek()
	{
		translate([-filament_dist, -peek_dist, base_h+inner_h/2]) rotate([90,0,0]) 
		{
			translate([-peek_inner_r,0*peek_inner_r,peek_h/2]) cube([peek_inner_r*2,peek_inner_r*2,100]);
			#cylinder(h=peek_h, r=peek_r);
			#cylinder(h=30, r=peek_inner_r);
		}
	}
	
	difference() {
		dxf_linear_extrude(file =dxf_file, layer = "frame", height = base_h+inner_h, convexity = convexity);
		
			translate([0,0,-10]) dxf_linear_extrude(file =dxf_file, layer = "base", height = 100, convexity = convexity);
			translate([0,0,base_h]) dxf_linear_extrude(file =dxf_file, layer = "inner", height = base_h+inner_h, convexity = convexity);

		translate([0,0,base_h-screw_inset]) dxf_linear_extrude(file =dxf_file, layer = "holes_insets", height = 100, convexity = convexity);
		translate([0,0,-10]) dxf_linear_extrude(file =dxf_file, layer = "holes", height = 100, convexity = convexity);

		filament();

		
		peek();
//translate([-filament_dist, -peek_dist, base_h+inner_h/2]) rotate([90,0,0]) 
//		{
//			translate([-peek_inner_r,0*peek_inner_r,peek_h/2]) cube([peek_inner_r*2,peek_inner_r*2,100]);
//			%cylinder(h=peek_h, r=peek_r);
//			%cylinder(h=30, r=peek_inner_r);
//		}
	%  translate([0,0,base_h+inner_h]) 
			dxf_linear_extrude(file =dxf_file, layer = "top", height = 3, convexity = convexity);
		}

}

extruder();
