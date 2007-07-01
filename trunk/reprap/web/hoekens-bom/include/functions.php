<?
	function getRawSheetData($id)
	{
		$url = "http://spreadsheets.google.com/pub?key=pmEMxYRcQzzATwbOb71BmGA&output=csv&gid=$id";
	
		$fp = fopen($url, "r");
		while ($ar = fgetcsv($fp))
			$data[] = $ar;
	
		return $data;
	}

	function loadModulesData()
	{
		$data = getRawSheetData(8);

		#get rid of the first two lines of human text
		array_shift($data);
		array_shift($data);

		return $data;
	}

	function loadSupplierData()
	{
		$data = getRawSheetData(12);

		#get rid of the first two lines of human text
		array_shift($data);
		array_shift($data);
	
		$corps = array();
		foreach ($data AS $row)
		{
			$corp = new Corporation;
			$corp->name = $row[0];
			$corp->key = $row[1];
			$corp->website = $row[2];
			$corp->description = $row[3];
			$corp->countries = explode(", ", $row[4]);
			$corp->buy_url = $row[5];
		
			$corps[$corp->key] = $corp;
		}

		return $corps;
	}

	function importBOMData($ids, $qty)
	{
		$bom = new BOM;
		foreach ($ids AS $id)
		{
			$bom->importSheetData($id, $qty[$id]);
	
			//for stepper and extruder, also import universal board.
			if ($id == 9 || $id == 10 || $id == 11)
				$bom->importSheetData(1, $qty[$id]);
		}
	
		return $bom;
	}
?>