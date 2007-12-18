#!/usr/bin/php
<?
	//our margin of acceptable skews, in microseconds.
	$margin = 5;

	//hold our output_data
	$size_data = array();
	
//	foreach ($tick_sizes AS $tick_size)
	for ($tick_size = 16; $tick_size<=100; $tick_size++)
	{
		for ($rpm=1; $rpm <= 500; $rpm++)
		{
			$delay = (60000000 / ($rpm * 400));
			$ticks = $delay / $tick_size;

			$loss = floor(abs(round($ticks) - $ticks) * $tick_size);
			$real_rpm = round(60000000 / (round($ticks) * $tick_size * 400));

			if ($loss <= $margin)
			{
				$size_data[$tick_size][$real_rpm] = 1;
				echo "rpm: $rpm real rpm: $real_rpm ticks: $ticks loss: $loss\n";
			}
		}
	}
	
	echo "\n\ntick size data:\n";
	arsort($size_data);
	foreach ($size_data AS $tick_size => $data)
	{
		echo "$tick_size: " . array_sum($data) . "\n";
	}

	foreach ($size_data[75] AS $rpm => $key)
	{
		echo "rpm: $rpm\n";
	}
?>