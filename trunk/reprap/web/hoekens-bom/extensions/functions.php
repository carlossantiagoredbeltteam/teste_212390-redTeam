<?
	function getRawSheetData($id)
	{
		$url = "http://spreadsheets.google.com/pub?key=pmEMxYRcQzzATwbOb71BmGA&output=csv&gid=$id";
	
		echo "<!-- getting $url -->\n";
	
		$fp = fopen($url, "r");
		while ($ar = fgetcsv($fp))
			$data[] = $ar;
	
		return $data;
	}
?>
