#!/usr/bin/perl -w

use File::Basename;

#get all the files in our current directory.
@files = <*.stl>;
$count = @files;

#did we get any?
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
		$to_name =~ s/stl$/pov/;

		$cmd = "stl2pov $file > povray/$to_name";
		print $cmd . "\n";
		print `stl2pov $file > povray/$file.pov`;
	}
}


#get all the files in subdirectories.
@dir_files = <*/*.stl>;
$count = @dir_files;

#did we get any?
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
		$to_name =~ s/stl$/pov/;
	
		$cmd = "stl2pov $file > $real_dir/povray/$to_name";
		print $cmd . "\n";
		print `stl2pov $file > povray/$file.pov`;
	}
}