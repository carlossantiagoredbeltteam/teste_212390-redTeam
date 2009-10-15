#!/usr/bin/perl -w

use File::Basename;

#get all the files in our current directory.
@files = <*.stl>;

#get all the files in subdirectories.
@dir_files = <*/*.stl>;

#did we get any?
$count = @files;
if ($count > 0)
{
	#make the dir.
	if (!-d "povray/")
	{
		mkdir "povray/";
	}

	#make the files.
	foreach $file (@files)
	{
		$to_name = $file;
		$to_name =~ s/stl$/inc/;
		$to_path = "povray/$to_name";

		$cmd = "./stl2pov $file > $to_path";
		print $cmd . "\n";
		print `$cmd` . "\n";
		
		create_scene_file($to_path);
	}
}

#did we get any?
$count = @dir_files;
if ($count > 0)
{
	#make the files.
	foreach $file (@dir_files)
	{
		$real_name = `basename $file`;
		$real_dir = `dirname $file`;
		chomp $real_dir;
		chomp $real_name;

		#make the dir
		if (!-d "$real_dir/povray/")
		{
			mkdir "$real_dir/povray/";
		}

		$to_name = $real_name;
		$to_name =~ s/stl$/inc/;
		$to_path = "$real_dir/povray/$to_name";
	
		$cmd = "stl2pov $file > $to_path";
		print $cmd . "\n";
		print `$cmd` . "\n";
		
		create_scene_file($to_path);
		
		$scene_path = $to_path;
		$scene_path =~ s/inc$/pov/;
		render_scene_file($scene_path);
	}
}

sub create_scene_file
{
	#create our filenames
	my $inc_file = shift;
	chomp $inc_file;
	my $scene_file = $inc_file;
	$scene_file =~ s/inc$/pov/;
	
	#open our files.
	open (INC_FP, $inc_file);
	open (SCENE_FP, "> $scene_file");
	
	#figure out our object name
	my $line = <INC_FP>;
	chomp $line;
	if ($line =~ m/\/\/ Name of the solid: (.*)/)
	{
		my $firstLoop = 1;

		my $max_x;
		my $max_y;
		my $max_z;

		my $min_x;
		my $min_y;
		my $min_z;

		#figoure out the max dimensions
		while ($new_line = <INC_FP>)
		{
			#if ($new_line =~ m/([0-9]?.[0-9]?), ([0-9]?.[0-9]?), ([0-9]?.[0-9]?)/)
			if ($new_line =~ m/(\d*\.?\d*), (\d*\.?\d*), (\d*\.?\d*)/)
			{
				chomp $new_line;
				my $x = $1;
				my $y = $2;
				my $z = $3;

				if ($firstLoop)
				{
					$max_x = $x;
					$max_y = $y;
					$max_z = $z;
					
					$min_x = $x;
					$min_y = $y;
					$min_z = $z;
					
					$firstLoop = 0;
				}
				else
				{
					if ($x > $max_x)
					{
						$max_x = $x;
					}
					if ($y > $max_y)
					{
						$max_y = $y;
					}
					if ($z > $max_z)
					{
						$max_z = $z;
					}

					if ($x < $min_x)
					{
						$min_x = $x;
					}
					if ($y < $min_y)
					{
						$min_y = $y;
					}
					if ($z < $min_z)
					{
						$min_z = $z;
					}
				}
			}
		}
		print "min: $min_x, $min_y, $min_z\n";
		print "max: $max_x, $max_y, $max_z\n";
		
		my $obj_name = $1;
		chomp $obj_name;
		$obj_name = "m_" . $obj_name;
		
		my $cam_x = $max_x * 2;
		my $cam_y = $max_y * 2;
		my $cam_z = $max_z * 2;

		my $look_x = ($max_x - $min_x)/2;
		my $look_y = ($max_y - $min_y)/2;
		my $look_z = ($max_z - $min_z)/2;

#		my $light_x = ($max_x+1) / 2;
#		my $light_y = ($max_y+1) / 2;
#		my $light_z = $max_z * 2;

# interesting - makes object appear to glow.
#		my $light_x = $look_x;
#		my $light_y = $look_y;
#		my $light_z = $look_z;

		my $light_x = $cam_x;
		my $light_y = $cam_y;
		my $light_z = $cam_z;

		#create the .pov scene file.
		print SCENE_FP "//$scene_file\n\n";
		print SCENE_FP "#include \"$inc_file\"\n\n";
		print SCENE_FP "#include \"axes_macro.inc\"\n\n";
		print SCENE_FP "background {color rgb <0.9, 0.9, 0.9>}\n\n";
		print SCENE_FP "light_source { <$light_x, $light_y, $light_z> color rgb 2 }\n\n";
		print SCENE_FP "light_source { <-$light_x, -$light_y, -$light_z> color rgb 2 }\n\n";
		print SCENE_FP "camera {\n";
		print SCENE_FP "\tperspective\n";
		print SCENE_FP "\tlocation <$cam_x, $cam_y, $cam_z>\n";
		print SCENE_FP "\tlook_at <$look_x, $look_y, $look_z>\n";
		print SCENE_FP "\t";
		print SCENE_FP "}\n";
		print SCENE_FP "\/\/ the coordinate grid and axes\n";
		print SCENE_FP "Axes_Macro\n";
		print SCENE_FP "(\n";
		print SCENE_FP "\t100,	\/\/ Axes_axesSize,	The distance from the origin to one of the grid's edges.	(float)\n";
		print SCENE_FP "\t50,	\/\/ Axes_majUnit,	The size of each large-unit square.	(float)\n";
		print SCENE_FP "\t10,	\/\/ Axes_minUnit,	The number of small-unit squares that make up a large-unit square.	(integer)\n";
		print SCENE_FP "\t0.005,	\/\/ Axes_thickRatio,	The thickness of the grid lines (as a factor of axesSize).	(float)\n";
		print SCENE_FP "\ton,	\/\/ Axes_aBool,		Turns the axes on\/off. (boolian)\n";
		print SCENE_FP "\ton,	\/\/ Axes_mBool,		Turns the minor units on\/off. (boolian)\n";
		print SCENE_FP "\toff,	\/\/ Axes_xBool,		Turns the plane perpendicular to the x-axis on\/off.	(boolian)\n";
		print SCENE_FP "\ton,	\/\/ Axes_yBool,		Turns the plane perpendicular to the y-axis on\/off.	(boolian)\n";
		print SCENE_FP "\toff	\/\/ Axes_zBool,		Turns the plane perpendicular to the z-axis on\/off.	(boolian)\n";
		print SCENE_FP ")\n";
		print SCENE_FP "\n";
		print SCENE_FP "object\n";
		print SCENE_FP "{\n";
		print SCENE_FP "\tAxes_Object\n";
		print SCENE_FP "\t}\n";
		print SCENE_FP "object { $obj_name\n\n";
		#print SCENE_FP "\trotate 90*x\n";
		print SCENE_FP "\trotate 90*y\n";
		print SCENE_FP "\ttexture {\n";
		print SCENE_FP "\t\tpigment {color rgb <0.1, 0.6, 0.1> }\n";
		print SCENE_FP "\t\tfinish {\n";
		print SCENE_FP "\t\t\tambient 0.15\n";
		print SCENE_FP "\t\t\tdiffuse 0.85\n";
		print SCENE_FP "\t\t\tspecular 0.3\n";
		print SCENE_FP "\t\t}\n";
		print SCENE_FP "\t}\n\n";
		print SCENE_FP "}\n\n";
	}
	
	close(INC_FP);
	close(SCENE_FP);
}

sub render_scene_file
{
	my $scene_file = shift;
	chomp $scene_file;
	
	my $basename = `basename $scene_file`;
	chomp $basename;
	
	my $dirname = `dirname $scene_file`;
	chomp $dirname;
	
	my $render_dir = "$dirname/renders";
	my $render_name = "$render_dir/$basename";
	$render_name =~ s/pov$/png/;
	chomp $render_name;
	
	if (!-d $render_dir)
	{
		mkdir $render_dir;
	}
	
	$cmd = "povray +I$scene_file +Otemp.png +FN +W1200 +H1024 +Q9 +A +AM2 -D -V +WL0";
	print $cmd . "\n";
	print `$cmd` . "\n";
	`cp temp.png $render_name`;
}
