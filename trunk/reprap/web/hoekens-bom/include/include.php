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
	
	class Supplier
	{
		public $name;
		public $key;
		public $part_id;
		
		public function __construct($name)
		{
			$this->name = $name;
			$data = explode(":", $name);

			if (preg_match("/^http:/", $name))
			{
				$this->part_id = $name;
				$data = parse_url($name);
				$this->key = $data['host'];
			}
			else if(count($data) == 2)
			{
				$this->key = $data[0];
				$this->part_id = $data[1];
			}
		}
	}
	
	class Part
	{
		public $id;
		public $name;
		public $description;
		public $type;
		public $quantity;
		public $suppliers = array();
		
		public function __construct($name, $type, $quantity = 1, $suppliers = array())
		{
			$this->name = trim($name);
			$this->type = $type;
			$this->quantity = $quantity;
			$this->addSuppliers($suppliers);
		}
		
		public function addSuppliers($suppliers)
		{
			if (count($suppliers))
			{
				foreach ($suppliers AS $name)
				{
					if ($name)
					{
						$supplier = new Supplier($name);
						$this->suppliers[] = $supplier;
					}
				}
			}
		}
		
		public function getSafeName()
		{
			$name = str_replace(" ", "_", $this->name);
			preg_replace("/[^a-zA-Z0-9_]/", "", $name);
			
			return $name;
		}
	}
	
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
				return $this->parts[$type];
			else
				return $this->parts;
		}
		
		public function getTypes()
		{
			$keys = array_keys($this->parts);
			sort($keys); 
			return $keys;
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
				$part->addSuppliers(array_slice($row, 5));
				$part->description = $row[4];

				if ($part->name && $part->quantity)
				{
					switch ($part->type)
					{
						case 'assembly':
							$subqty = $part->quantity * $main_qty;
							break;

						case 'belt':
						
							if (!$beltSuppliers)
								$beltSuppliers = $part->suppliers;
							else
								$part->suppliers = $beltSuppliers;
								
							preg_match("/\d+/", $part->name, $matches); // match the length
							$part->name = "{$matches[0]}mm belt (Length 950 pitch 2.5 width 6 thick ~1.3)";
							$part->quantity *= $subqty;
							break;
							
						case 'rod':
						case 'stud':
								
							if (preg_match("/M(\d+)\D*(\d+)/", $part->name, $matches))
							{
								$length = $matches[2];
								$part->name = "M{$matches[1]} x $length $part->type";
							}
							else
							{
								preg_match("/(\d+)/", $part->name, $matches); // match the length
								$length = $matches[1];
								
								if ($part->type == 'rod')
									$part->name = "M8 x $length $part->type";
								else if ($part->type == 'stud')
									$part->name = "M5 x $length $part->type";
							}
						
							$part->quantity *= $subqty;
							break;

						case 'wire':
							if (preg_match("/(\d+)\D*(\d+)AWG/", $part->name, $matches))
								$part->name = "{$matches[1]}mm x {$matches[2]}AWG wire";
							else if (preg_match("/(\d+)/", $part->name, $matches))
								$part->name = "{$matches[1]}mm wire";
					
							$part->quantity *= $subqty;
							break;

						default:
							$part->quantity *= $subqty;
							break;
					}

					$this->addPart($part, $type);
				}
			}
		}
	}
	
	class Corporation
	{
		public $key;
		public $name;
		public $description;
		public $website;
		public $buy_url;
		public $countries;
	}
	
	class SupplierList
	{
		private $suppliers;
		
		public function addSupplier($part)
		{
			if ($part->key && $part->part_id)
			{
				if (count($this->suppliers[$part->key]))
				{
					foreach ($this->suppliers[$part->key] AS $dongle)
					{
						if ($dongle->part_id == $part->part_id)
						{
							$found = true;
							$dongle->quantity += $part->quantity;	
						}
					}
				}

			}
			if (!$found)
				$this->suppliers[$part->key][] = $part;
		}
		
		public function getParts($key = null)
		{
			if ($key === null)
				return $this->suppliers;
			else
				return $this->suppliers[$key];
		}
		
		public function getSuppliers()
		{
			$keys = array_keys($this->suppliers);
			sort($keys); 
			return $keys;
		}
	}
?>