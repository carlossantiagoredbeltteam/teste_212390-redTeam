<?
	require_once("include/global.php");
	drawHeader("Importing Bill of Materials");
	
	error_reporting(E_ALL);
	
	//create our structure.
	$sql = file_get_contents("sql/structure.sql");
	//DB::execute($sql);
	
	//perhaps load a 'legend sheet' that tells us what id's each sheet has?
	
	//load our suppliers
	
	//load our unique parts, as well as supplier parts
	
	//load our raw part lists
	
?>
	<p>
		Created Database Structure (<a href="#" onclick="Element.toggle('create_sql'); return false;">SQL</a>)
		<pre class="sql" id="create_sql" style="display: none; margin: 0px; padding: 0px;"><?=$sql?></pre>
	</p>

	<p>Loaded Bill of Materials from Google Spreadsheet: 
		<a href="http://spreadsheets.google.com/ccc?key=<?=RR_GOOGLE_DOC_KEY?>"><?=RR_PROJECT_NAME?></a>
	</p>
<?
	drawFooter();
	
	////////////////////////////
	// Import Functions Below //
	////////////////////////////
	
	function loadLegend()
	{
		$legend = array();
		$legend['suppliers'] = 12;
		$legend['unique_parts'] = 15;
				
		return $legend;
	}
	
	function loadSuppliers($legend)
	{
		$data = getRawSheetData($legend['suppliers']);
		
		#get rid of the first two lines of human text
		array_shift($data);
		array_shift($data);

		foreach ($data AS $row)
		{
			//create our supplier
			$supplier = new Supplier();
			$supplier->set('name', $row[0]);
			$supplier->set('key', $row[1]);
			$supplier->set('website', $row[2]);
			$supplier->set('description', $row[3]);
			$supplier->set('buy_link', $row[5]);
			$supplier->save();
			
			//add in our country relations
			$countries = explode($row[4]);
			if (count($countries))
			{
				foreach ($countries AS $short)
				{
					$country = Country::lookupShort($short);
					
					$sc = new SupplierCountry();
					$sc->set('supplier_id', $supplier->id);
					$sc->set('country_id', $country->id);
					$sc->save();
				}
			}
		}
	}
	
	function loadUniqueParts($legend)
	{
		$data = getRawSheetData($legend['unique_parts']);
		
		//junk.
		array_shift($data);
		array_shift($data);
		
		foreach ($data AS $row)
		{
			if ($row[1])
			{
				$part = new UniquePart();
				$part->set('name', $data[0]);
				$part->set('type', $data[1]);
				$part->set('description', $data[2]);
				$part->set('url', $data[3]);
				$part->set('units', $data[4]);
				$part->save();
				
				loadSuppliers($part, array_slice($data, 5));
			}
		}
	}
	
	function loadSuppliers($part, $data)
	{
		foreach ($data AS $name)
		{
			if ($name)
			{
				if (preg_match("/^http/", $name))
					$supplier = Supplier::lookupUrl($name);
				else
				{
					$key_info = explode(":", $name);
					$supplier = Supplier::lookupKey($key_info[0]);
				}
				
				if ($supplier instanceOf Supplier){
					$sp = new SuppliedPart();
					$sp->set('supplier_id', $supplier->id);
					$sp->set('part_id', $part->id);
					$sp->save();					
				}
			}
		}
	}
	
	function loadRawSheets($legend)
	{
		foreach ($legend['raw_sheets'] AS $sheet_info)
		{
			//get our initial data.
			$data = getRawSheetData($sheet_info['id']);
			$module = RawPart::lookupUnique($sheet_info['name'], 'module');
			
			//create our root node.
			$root = new RawPart();
			$root->set('part_id', $root->id);
			$root->set('raw_text', $sheet_info['name']);
			$root->set('quantity', 1);
			$root->set('parent_id',0);
			$root->save();
			
			//get rid of human junk
			array_shift($data);
			array_shift($data);
			
			//load them all.
			foreach ($data AS $row)
			{
				//get the normal data.
				$raw = new RawPart();
				$raw->set('raw_text', $row[1]);
				$raw->set('type', $row[2])''
				$raw->set('quantity', $row[3]);
				
				//who owns us?
				if (is_object($assembly))
					$raw->set('parent_id', $assembly->id);
				else
					$raw->set('parent_id', $root->id);

				//what is our unique part?
				$unique = RawPart::lookupUnique($raw->get('raw_text'), $raw->get('type'));
				$raw->set('part_id', $unique->id);
								
				//dont forget to save our model!	
				$raw->save();
				
				//if we're an assembly, then save it here.
				if ($raw->get('type') == 'assembly')
					$assembly = $raw;
			}
		}
	}
?>