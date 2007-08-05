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
			$legend = loadLegend();
			loadSuppliers($legend);
			loadUniqueParts($legend);
			loadRawSheets($legend);
			
			$this->set('content', ob_get_clean());
		}
	}
	
	function loadLegend()
	{
		$legend = array();
		$legend['suppliers'] = 12;
		$legend['unique_parts'] = 15;
		
		//add in all our modules.
		$data = getRawSheetData(8);
		foreach ($data AS $row)
		{
			if ((int)$row[3] || (int)$row[4])
			{
				//the first one is our 'main sheet'
				if (!$legend['main_sheet'])
					$legend['main_sheet'] = $row[3];
				
				//load up our keyed array.	
				$karr = array();
				$legend['raw_keys'][$row[0]] = $row[3];
			}
		}
	
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
			
			echo "Added supplier " . $supplier->get('name') . "<br/>\n";
		}
		//echo "<b>Added " . count($data) . " total suppliers.</b><br/><br/>\n";
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
				$part->set('name', $row[0]);
				$part->set('type', $row[1]);
				$part->set('description', $row[2]);
				$part->set('url', $row[3]);
				$part->set('units', $row[4]);
				$part->save();
				
				//echo "Added unique part '" . $part->get('name') . "'<br/>\n";
				
				loadSuppliedParts($part, array_slice($row, 5));
			}
		}

		echo "<b>Added " . count($data) . " total unique parts.</b><br/><br/>\n";
	}
	
	function loadSuppliedParts($part, $data)
	{
		foreach ($data AS $name)
		{
			if ($name)
			{
				if (preg_match("/^http/", $name))
				{
					$supplier = Supplier::lookupUrl($name);
					$url = $name;
				}
				else
				{
					$key_info = explode(":", $name);
					$supplier = Supplier::lookupKey($key_info[0]);
					$part_num = $key_info[1];
				}
				
				if ($supplier instanceOf Supplier)
				{
					$sp = new SupplierPart();
					$sp->set('supplier_id', $supplier->id);
					$sp->set('part_id', $part->id);
					$sp->set('part_num', $part_num);
					$sp->set('url', $url);
					$sp->set('quantity', 1);
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
	
	function loadRawSheets($legend)
	{
		if (!empty($legend['raw_keys']))
		{
			foreach ($legend['raw_keys'] AS $name => $id)
			{
				//get our initial data.
				$data = getRawSheetData($id);

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
					
					echo "<b>Added root module " . $root->get('raw_text') . "</b><br>";
					
					//get rid of human junk
					array_shift($data);
					array_shift($data);

					//load them all.
					foreach ($data AS $row)
					{
						//get the normal data.
						$raw = new RawPart();
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
			}			
		}
	}
?>