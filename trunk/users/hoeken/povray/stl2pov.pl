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

		$cmd = "stl2pov $file > $to_path";
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
		my $include = `basename $inc_file`;
		chomp $include;
		
		my $obj_name = $1;
		chomp $obj_name;
		
		#create the .pov scene file.
		print SCENE_FP "//$scene_file\n\n";
		print SCENE_FP "#include $include\n\n";
		print SCENE_FP "background{color rgb 1}\n\n";
		print SCENE_FP "object{ $obj_name\n\n";
		print SCENE_FP "\trotate 90*x\n";
		print SCENE_FP "\ttexture {\n";
		print SCENE_FP "\t\tpigment {color rgb <1,0.5,0> }\n";
		print SCENE_FP "\t\tfinish {\n";
		print SCENE_FP "\t\t\tambient 0.15\n";
		print SCENE_FP "\t\t\tdiffuse 0.85\n";
		print SCENE_FP "\t\t\tspecular 0.3\n";
		print SCENE_FP "\t\t}\n";
		print SCENE_FP "\t}\n\n";
		print SCENE_FP "}\n\n";
		print SCENE_FP "light_source { <-20, 100, 20> color rgb 2 }\n\n";
		print SCENE_FP "camera {\n";
		print SCENE_FP "\tperspective\n";
		print SCENE_FP "\tangle 35\n";
		print SCENE_FP "\tright x*image_width/image_height\n";
		print SCENE_FP "\tlocation <-3,7,15>\n";
		print SCENE_FP "\t";
		print SCENE_FP "}\n";
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
	
	$cmd = "povray +I$scene_file +O$render_name +FN +W1200 +H1024 +Q9 +A +AM2 -D -V +WL0";
	print `$cmd` . "\n";
}