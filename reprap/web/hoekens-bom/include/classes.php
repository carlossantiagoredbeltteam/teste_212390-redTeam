<?
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
	
	class UniquePart
	{
		public $name;
		public $type;
		public $description;
		public $suppliers;
		
		public function __construct($data)
		{
			$this->name = $data[0];
			$this->type = $data[1];
			$this->description = $data[2];
			$this->addSuppliers(array_slice($data, 3));
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
	}

	class Part
	{
		public $id;
		public $name;
		public $type;
		public $quantity;
		public $unique_part;
		public static $unique_parts = null;
	
		public function __construct($name, $type, $quantity = 1)
		{
			$this->name = trim($name);
			$this->type = $type;
			$this->quantity = $quantity;
			
			if (count($suppliers))
				$this->addSuppliers($suppliers);
		}

	
		public function getSafeName()
		{
			$name = str_replace(" ", "_", $this->name);
			$name = str_replace('"', '', $name);
			$name = preg_replace("/[^a-zA-Z0-9_.']/", "", $name);
		
			return $name;
		}
		
		public function lookupUnique($name = null)
		{
			if ($name === null)
				$name = $this->name;
				
			if (self::$unique_parts === null)
				self::loadUniqueParts();
				
			foreach (self::$unique_parts AS $part)
			{
				if ($part->type == $this->type && strtolower($part->name) == strtolower($name))
				{
					$this->unique_part = $part;
					return true;
				}
			}
			
			#echo "Failed looking up $name<br/>\n";
			return false;
		}
		
		public static function loadUniqueParts()
		{
			$data = getRawSheetData(15);

			//junk.
			array_shift($data);
			array_shift($data);
			
			foreach ($data AS $row)
				if ($row[1])
					self::$unique_parts[] = new UniquePart($row);
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
					switch ($part->type)
					{
						case 'assembly':
							$subqty = $part->quantity * $main_qty;
							break;

						case 'belt':

							preg_match("/\((.+)\) x (\d+)/", $part->name, $matches); // match the belt type
							$part->name = "{$matches[1]} belt x $matches[2]mm";
							$part->quantity *= $subqty;
							$part->lookupUnique("{$matches[1]}");
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
		public $countries = array();
	}

	class SupplierList
	{
		private $suppliers;
	
		public function hasSupplier($part)
		{
			if ($part->key && $part->part_id)
				if (count($this->suppliers[$part->key]))
					foreach ($this->suppliers[$part->key] AS $key => $dongle)
						if ($dongle->part_id == $part->part_id)
							return $key;
		
			return false;
		}
		
		public function addSupplier($part)
		{
			/*
				$key = $this->hasSupplier($part);
				if ($key !== false)
					$this->suppliers[$part->key][$]
			*/
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