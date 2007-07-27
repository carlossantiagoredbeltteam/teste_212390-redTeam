<?
	if ($output != '')
	{
		//send it out!
		$parts = importBOMData($_POST['assembly_ids'], $_POST['assembly_qty']);
		$corps = loadSupplierData();

		if ($output == 'json')
			renderUniqueJSON($parts);
		else if ($output == 'csv')
			renderUniqueCSV($parts);
		else
			renderUniqueHTML($parts);
	}
	else
		echo "Oops, you gotta POST here bro.";
?>

