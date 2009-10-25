$fn=30;

// example012.stl is Mblock.stl, (c) 2009 Will Langford
// licensed under the Creative Commons - GNU GPL license.
// http://www.thingiverse.com/thing:753

module extruder()
{
	base_h = 7;
	screw_inset=3;
	inner_h = 4;
	dxf_file = "rb_35_lasercut_extruder9.dxf";
	filament_dist = dxf_dim(file = dxf_file, name = "filament_dist");

	module filament()
	{
		translate([-filament_dist, 100, base_h+inner_h/2]) rotate([90, 0,0]) cylinder(h=200, r=2);
	}
	
	difference() {
		union() {
			dxf_linear_extrude(file =dxf_file, layer = "base", height = base_h, convexity = 3);
			dxf_linear_extrude(file =dxf_file, layer = "inner", height = base_h+inner_h, convexity = 3);
		}
		translate([0,0,base_h-screw_inset]) dxf_linear_extrude(file =dxf_file, layer = "holes_insets", height = 100, convexity = 3);
		translate([0,0,-10]) dxf_linear_extrude(file =dxf_file, layer = "holes", height = 100, convexity = 3);

		filament();
	}

	*translate([ -2.92, 0.5, +20 ]) rotate([180, 0, 180])
			import_stl("example012.stl", convexity = 5);
}

extruder();
