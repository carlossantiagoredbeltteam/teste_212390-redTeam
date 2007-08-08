<?
	class UniquePart extends Model
	{
		public function __construct($id = null)
		{
			parent::__construct($id, "unique_parts");
		}
		
		public static function getModules()
		{
			$sql = "
				SELECT id
				FROM unique_parts
				WHERE type = 'module'
				ORDER BY id
			";
			return new Collection($sql, array('UniquePart' => id));
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
					$qty = $data[$raw->get('type')][$unique->id]->get('quantity') + $unique->get('quantity');
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
	}
?>