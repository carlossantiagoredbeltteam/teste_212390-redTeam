<?
	class UniquePart extends Model
	{
		public function __construct($id = null)
		{
			parent::__construct($id, "unique_parts");
		}
		
		public static function byName($name, $type)
		{
			$name = db()->safe($name);
			
			$sql = "
				SELECT id
				FROM unique_parts
				WHERE name = '$name'
					AND type = '$type'
			";
			
			return new UniquePart(db()->getValue($sql));
		}

		public static function getModules()
		{
			$sql = "
				SELECT id
				FROM unique_parts
				WHERE type = 'module'
				ORDER BY id
			";
			
			return new Collection($sql, array(
				'UniquePart' => 'id',
			));
		}

		public function getEmbedUrl()
		{
			return "http://" . SITE_HOSTNAME . "/embed/" . $this->get('type') . "/" . urlencode($this->get('name'));
		}
		
		public function getViewUrl()
		{
			return "/part/" . $this->get('type') . "/" . urlencode($this->get('name'));
		}
		
		public function lookupRawPart()
		{
			//get a top level part that corresponds to this one.
			$sql = "
				SELECT id
				FROM raw_parts
				WHERE part_id = '$this->id'
					AND parent_id = 0
			";
			$id = db()->getValue($sql);
			
			return new RawPart($id);
		}
		
		public function getRawComponents($deep = false)
		{
			//find our root node.
			$raw = $this->lookupRawPart();

			//merge it up!
			$components = array();
			if ($raw->id)
				$components = array_merge($components, $raw->getComponents($deep));
			
			return $components;
		}
		
		public function getUniquePartList($deep = false, $quantity = 1)
		{
			$components = $this->getRawComponents($deep);
			
			$list = new UniquePartList();
			foreach ($components AS $part)
			{
				$part->set('quantity', $part->get('quantity') * $quantity);
				$list->addRaw($part, $quantity);
			}
				
			return $list;
		}
		
		public function getUniqueComponents($deep = false)
		{
			$raw_comps = $this->getRawComponents($deep);
			$data = array();
			
			foreach ($raw_comps AS $raw)
			{
				$unique = new UniquePart($raw->get('part_id'));
			
				//do we already have this unique part?
				if ($data[$raw->get('type')][$unique->id] instanceOf UniquePart)
				{
					//simply add the quantity in...
					$qty = $data[$raw->get('type')][$unique->id]->get('quantity') + $raw->get('quantity');
					$data[$raw->get('type')][$unique->id]->set('quantity', $qty);
				}
				//nope, make a new entry.
				else
				{
					//use the initial quantity from our raw part.
					$unique->set('quantity', $raw->get('quantity'));
					$data[$raw->get('type')][$unique->id] = $unique;
				}
			}
			
			return $data;
		}
		
		public function getSupplierParts()
		{
			$sql = "
				SELECT id, supplier_id
				FROM supplier_parts
				WHERE part_id = '$this->id'
			";
			
			return new Collection($sql, array(
				'SupplierPart' => 'id',
				'Supplier' => 'supplier_id'
			));
		}
		
		public function getParentModules()
		{
			$sql = "
				SELECT p.id, p.part_id
				FROM raw_parts c
				INNER JOIN raw_parts p
					ON c.parent_id = p.id
				LEFT OUTER JOIN unique_parts u
					ON u.id = p.part_id
				WHERE c.part_id = '$this->id'
				ORDER BY u.name
			";
			
			return new Collection($sql, array(
				'UniquePart' => 'part_id',
				'RawPart' => 'id'
			));
		}
		
		public static function byType($type)
		{
			$sql = "
				SELECT id
				FROM unique_parts
				WHERE type = '$type'
				ORDER BY name
			";
			
			return new Collection($sql, array(
				'UniquePart' => 'id',
			));
		}
		
		public static function typeToEnglish($type)
		{
			switch ($type)
			{
				case 'belt':
					return 'Toothed Belt';
				
				case 'component':
					return 'Electronic Component';
				
				case 'fast':
					return 'Fastener';
					
				case 'machined':
					return 'Machined Part';
					
				case 'misc':
					return 'Miscellaneous';
					
				case 'module':
					return 'System Module';
					
				case 'motor':
					return 'Electric Motor';
					
				case 'pcb':
					return 'Printed Circuit Board';
					
				case 'pulley':
					return 'Pulley';
					
				case 'rp':
					return 'Printed Part';
					
				case 'rod':
					return 'Smooth Rod';
					
				case 'stud':
					return 'Threaded Rod';
					
				case 'tool':
					return 'Tool';
					
				case 'wire':
					return 'Wire';
					
				default:
					return ucfirst($type);
			}
		}
	}
?>