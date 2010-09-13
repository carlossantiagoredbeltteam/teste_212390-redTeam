<?
	class UniquePartList
	{
		public $uniques = array();
		public $type_list = array();
		public $raw_list = array();
	
		public function addUnique(UniquePart $part)
		{
			//only add the part in if its the first instance.
			if (!$this->getUnique($part->id))
			{
				$this->uniques[$part->id] = $part;
				$this->type_list[$part->get('type')][$part->get('name')] = $part->id;
				ksort($this->type_list);
			}
		}
		
		public function addRaw(RawPart $part)
		{
			//add in our unique part.
			$unique = new UniquePart($part->get('part_id'));
			
			//is it legit?
			if ($unique->id)
			{
				$this->addUnique($unique);
				$this->raw_list[$unique->id][] = $part;
			}
		}
		
		public function getUnique($unique_id)
		{
			return $this->uniques[$unique_id];
		}
		
		public function getUniqueQuantity($unique_id)
		{
			$total = 0;
			
			foreach ($this->raw_list[$unique_id] AS $raw)
				$total += $raw->getRealQuantity();
				
			return $total;
		}
		
		public function getTypeList($type)
		{
			$sql = "
				SELECT id
				FROM unique_parts
				WHERE id IN (" . implode(",", $this->type_list[$type]) . ")
				ORDER BY name
			";
			return new Collection($sql, array('UniquePart' => id));
		}
		
		public function getSupplierList()
		{
			$sql = "
				SELECT distinct(s.id)
				FROM supplier_parts sp
				INNER JOIN suppliers s
					ON s.id = sp.supplier_id
				WHERE sp.part_id IN (" . implode(",", array_keys($this->uniques)) . ")
				ORDER BY s.name
			";
			
			return new Collection ($sql, array('Supplier' => 'id'));
		}
	}
?>