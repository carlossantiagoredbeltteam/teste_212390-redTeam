<?
	class ImportController extends Controller
	{
		function home()
		{
			//run for as long as it takes.
			set_time_limit(0);
			
			//to keep the output for the view.
			ob_start();
			
			//create our structure.
			$sql = explode(";", file_get_contents(HOME_DIR . "/sql/structure.sql"));
			
			foreach ($sql AS $line)
			{
				$line = trim($line);
				if ($line){
					db()->query($line);
					if (db()->error())
						echo db()->error() . "<br/>";					
				}
			}
			echo "Database structure created.<br/><br/>";
			
			//import our data!  order is important here.
			loadCountries();
			loadSuppliers();
			loadUniqueParts();
			loadRawSheets();

			//dump our database to the file for others
			dumpDatabaseToFile();
			
			$this->set('content', ob_get_clean());
		}
	}
	
	
	function getRawSheetData($key, $id)
	{
		$url = "http://spreadsheets.google.com/pub?key={$key}&output=csv&gid={$id}";
	
		echo "<!-- getting $url -->\n";

		//open the file.
		$file = new File(TEMP_DIR);
		$fp = $file->open($url);
		while ($ar = fgetcsv($fp))
			$data[] = $ar;
	
		return $data;
	}

	function loadCountries()
	{
		global $SOURCE_DATA;

		//load all our country arrays.
		foreach ($SOURCE_DATA['countries'] AS $legend_row)
		{
			$data = getRawSheetData($legend_row[0], $legend_row[1]);
		
			array_shift($data);
			array_shift($data);
		
			foreach ($data AS $row)
			{
				$country = new Country();
				$country->set('name', $row[0]);
				$country->set('code', $row[1]);
				$country->set('group', $row[2]);
				$country->save();

				$count++;
			}
		}
		
		echo "Loaded {$count} countries.<br/><br/>\n";
	}
	
	function loadSuppliers()
	{
		global $SOURCE_DATA;

		//load all our supplier arrays.
		foreach ($SOURCE_DATA['suppliers'] AS $legend_row)
		{
			$data = getRawSheetData($legend_row[0], $legend_row[1]);
		
			#get rid of the first two lines of human text
			array_shift($data);
			array_shift($data);

			foreach ($data AS $row)
			{
				//create our supplier
				$supplier = new Supplier();
				$supplier->set('name', $row[0]);
				$supplier->set('prefix', $row[1]);
				$supplier->set('website', $row[2]);
				$supplier->set('description', $row[3]);
				$supplier->set('buy_link', $row[5]);
				$supplier->save();
			
				//add in our country relations
				/*
				$countries = explode(",", $row[4]);
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
				*/
			
				$count++;
				
				echo "Added supplier " . $supplier->get('name') . "<br/>\n";
			}
		}
		
		echo "<b>Added {$count} total suppliers.</b><br/><br/>\n";
	}
	
	function loadUniqueParts()
	{
		global $SOURCE_DATA;

		//load all our supplier arrays.
		foreach ($SOURCE_DATA['unique_parts'] AS $legend_row)
		{
			$data = getRawSheetData($legend_row[0], $legend_row[1]);
			
			//junk.
			if (!empty($data))
			{
				array_shift($data);
				array_shift($data);
			}
		
			if (!empty($data))
			{
				foreach ($data AS $row)
				{
					if ($row[1])
					{
						$count++;
						
						$part = new UniquePart();
						$part->set('name', $row[0]);
						$part->set('type', $row[1]);
						$part->set('description', $row[2]);
						$part->set('url', $row[3]);
						$part->set('units', $row[4]);
						$part->save();

						echo "Added unique part '" . $part->get('name') . "'<br/>\n";

						loadSuppliedParts($part, array_slice($row, 5));
					}
				}
			}
		}
		
		echo "<b>Added {$count} total unique parts.</b><br/><br/>\n";
	}
	
	function loadSuppliedParts($part, $data)
	{
		foreach ($data AS $name)
		{
			if ($name)
			{
				//check for quantity first
				if (preg_match("/^([A-Za-z]+):(.+)::([0-9]+)$/", $name, $matches))
				{
					$supplier = Supplier::lookupKey($matches[1]);
					$part_num = $matches[2];
					$quantity = $matches[3];
				}
				//otherwise, check for a normal 
				else if (preg_match("/^([A-Za-z]+):(.+)$/", $name, $matches))
				{
					$supplier = Supplier::lookupKey($matches[1]);
					$part_num = $matches[2];
					$quantity = 1;
				}

				if ($supplier instanceOf Supplier)
				{
					$sp = new SupplierPart();
					$sp->set('supplier_id', $supplier->id);
					$sp->set('part_id', $part->id);
					$sp->set('part_num', $part_num);
					$sp->set('url', $url);
					$sp->set('quantity', $quantity);
					$sp->save();
					
					echo db()->error();
					
					//echo "Added supplier " . $supplier->get('name') . "<br/>";
				}
				else
					echo "Couldn't find supplier for " . $part->get('name') . "!<br/>\n";
			}
		}
		//echo "<br/>\n";
	}
	
	function loadLegend()
	{
		global $SOURCE_DATA;
		
		$legend = array();

		//open our legend page with info on what sheets to use.
		foreach ($SOURCE_DATA['legend'] AS $legend_row)
		{
			$data = getRawSheetData($legend_row[0], $legend_row[1]);
			
			//discard the first two human rows.
			//array_shift($data);
			//array_shift($data);

			//get the data!
			foreach ($data AS $row)
			{
				//only add it if it has a name and number.
				if ($row[0] && (int)$row[1])
				{
					//the first one is our 'main sheet'
					if (!$legend['main_sheet'])
						$legend['main_sheet'] = $row[1];

					//load up our keyed array.	
					$legend['raw_keys'][$row[0]] = array($legend_row[0], $row[1], $row[2]);
				}
			}
		}

		return $legend;
	}
	
	function loadRawSheets()
	{
		$legend = loadLegend();
		
		if (!empty($legend['raw_keys']))
		{
			foreach ($legend['raw_keys'] AS $name => $legend_row)
			{
//				ob_end_flush();
				
				$count++;
				
				//if ($count == 2)
				//	die();
				
				//get our initial data.
				$data = getRawSheetData($legend_row[0], $legend_row[1]);

				//create our root node.
				$root = new RawPart();
				$root->set('raw_text', $name);
				$root->set('type', 'module');
				$unique = $root->lookupUnique();
				
				if ($unique instanceOf UniquePart)
				{
					$root->set('quantity', 1);
					$root->set('parent_id',0);
					$root->set('part_id', $unique->id);
					$root->save();
					
					//save it to our legend
					$legend = new LegendPart();
					$legend->set("unique_part_id", $unique->id);
					$legend->set("status", $legend_row[2]);
					$legend->save();
										
					echo "<b>Added root module " . $root->get('raw_text') . "</b><br>";
					
					//get rid of human junk
					array_shift($data);
					array_shift($data);

					//load them all.
					foreach ($data AS $row)
					{
						//get the normal data.
						$raw = new RawPart();
						$raw->set('raw_id', $row[0]);
						$raw->set('raw_text', $row[1]);
						$raw->set('quantity', $row[2]);
						$raw->set('type', $row[3]);
						
						//make sure we actually have a real row.
						if ($raw->get('raw_text') && $raw->get('type'))
						{
							//if we have an assembly set, and we're not an assembly ourselves, use the assembly as parent
							if (is_object($assembly) && $raw->get('type') != 'assembly')
								$raw->set('parent_id', $assembly->id);
							//otherwise, its the module.
							else
								$raw->set('parent_id', $root->id);

							//lookup our unique part
							$unique = $raw->lookupUnique();
							if ($unique instanceOf UniquePart)
								$raw->set('part_id', $unique->id);
							
							//dont forget to save our model!	
							$raw->save();

							echo "Added raw part " . $raw->get('raw_text') . "<br>";

							//if we're an assembly, then save it here.
							if ($raw->get('type') == 'assembly')
								$assembly = $raw;
						}
					}
					echo "<br/>\n";
					
					//forget past assemblies.
					unset($assembly);
				}

				//if ($count == 3)
				//	die();
			}			
		}
	}
	
	function dumpDatabaseToFile()
	{
		$cmd = "mysqldump -u " . RR_DB_USER . " --password=" . RR_DB_PASS . " -h " . RR_DB_HOST . " -P " . RR_DB_PORT . " " . RR_DB_NAME . " > " . WEB_DIR . "reprap-bill-of-materials.sql";
		system($cmd);
	}
?>