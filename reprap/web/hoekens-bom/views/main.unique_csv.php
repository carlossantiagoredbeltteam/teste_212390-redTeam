<?
	$fp = fopen('php://output', 'w');

	fputcsv($fp, array($name));
	fputcsv($fp, array("Name", "Quantity"));

	if (count($parts))
		foreach ($parts AS $part)
			fputcsv($fp, array($part->name, $part->quantity));

	fputcsv($fp, array());
	fclose($fp);
?>