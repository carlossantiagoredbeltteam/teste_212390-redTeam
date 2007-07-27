<?
	class BOM
	{
		private $parts;

		public function hasPart($part)
		{
			if ($part->name)
			{
				$parts = $this->getParts($part->type);
	
				//loop thru our parts and bail if we find it!
				if (count($parts))
					foreach ($parts AS $key => $unique)
						if ($unique->name == $part->name)
							return $key;
			}
	
			//bummer, no part.
			return false;
		}

		public function addPart($part)
		{
			//do we already have it?
			$key = $this->hasPart($part);
	
			//if we found it, simply add more quantity in.
			if ($key !== false)
				$this->parts[$part->type][$key]->quantity += $part->quantity;
			//otherwise, just add our part itself.
			else
				$this->parts[$part->type][] = $part;
		}

		public function getParts($type = null)
		{
			if ($type !== null)
			{
				if (is_array($this->parts[$type]))
					sort($this->parts[$type]);
				return $this->parts[$type];
			}
			else
				return $this->parts;
		}

		public function getTypes()
		{
			$keys = array_keys($this->parts);
			sort($keys); 
			return $keys;
		}
	
		public function getUniqueSuppliers()
		{
			$suppliers = array();
			$parts = $this->getParts();
					
			//mega loop.  stupid if statements.
			if (count($parts))
				foreach ($parts AS $type => $type_parts)
					if (count($type_parts))
						foreach ($type_parts AS $part)
							if ($part->unique_part instanceof UniquePart)
								if (count($part->unique_part->suppliers))
									foreach ($part->unique_part->suppliers AS $supplier)
										$suppliers[] = $supplier->key;

			//make it special
			$unique = array_unique($suppliers);
		
			//get our objects...
			$corps = loadSupplierData();
			foreach ($unique AS $key)
				$unique_corps[] = $corps[$key];
			
			return $unique_corps;
		}

		public function importSheetData($id, $main_qty)
		{
			$data = getRawSheetData($id);

			//get our initial info
			$first = array_shift($data);
			$headers = array_shift($data); //get rid of table headers.

			//default to one if theres no assembly.
			$subqty = 1 * $main_qty;

			//get all our data.
			foreach ($data AS $row)
			{
				//get our data
				$part = new Part($row[1], $row[3]);
				$part->quantity = $row[2];
				$part->id = $row[0];
				$part->description = $row[4];
				$part->lookupUnique();

				if ($part->name && $part->quantity)
				{
					$doAdd = true;
				
					switch ($part->type)
					{
						case 'assembly':
							$subqty = $part->quantity * $main_qty;
							break;

						case 'belt':

							preg_match("/\((.+)\) x (\d+)/", $part->name, $matches); // match the belt type
							$part->name = "{$matches[1]} belt";
							$part->quantity *= $subqty * $matches[2];
							$part->lookupUnique("{$matches[1]}");
							break;
						
						case 'module':
							$doAdd = false;
							break;
						
						case 'rp':
							$part->lookupUnique("Printing Service");
							break;
					
						case 'rod':
						case 'stud':
						
							if (preg_match("/M(\d+)\D*(\d+)/", $part->name, $matches))
							{
								$length = $matches[2];
								$part->name = "M{$matches[1]} x $length $part->type";
							}
				
							$part->lookupUnique("M{$matches[1]}");
							$part->quantity *= $subqty;
							break;

						case 'wire':
							if (!preg_match("/^Nichrome/i", $part->name))
							{
								if (preg_match("/(\d+) AWG/", $part->name, $matches)){
										$part->name = "{$matches[1]} AWG wire";
										$part->lookupUnique("$matches[1] AWG");
								}
								else if (preg_match("/(\d+)/", $part->name, $matches)){
										$part->name = "22 AWG wire";
										$part->lookupUnique('22 AWG');
								}							
							}

						
							$part->quantity *= $subqty * $matches[1];
							break;

						default:
							$part->quantity *= $subqty;
							break;
					}

					if ($doAdd)
						$this->addPart($part, $type);
				}
			}
		}
	}
?>