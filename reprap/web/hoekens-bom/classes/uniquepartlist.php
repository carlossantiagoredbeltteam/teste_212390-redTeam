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
				$this->type_list[$part->get('type')][] = $part->id;
			}
		}
		
		public function addRaw(RawPart $part)
		{
			//add in our unique part.
			$unique = new UniquePart($part->get('part_id'));
			$this->addUnique($unique);
			
			$this->raw_list[$unique->id][] = $part;
		}
		
		public function getUnique($unique_id)
		{
			return $this->uniques[$unique_id];
		}
		
		public function getUniqueQuantity($unique_id)
		{
			$total = 0;
			
			foreach ($this->raw_list[$unique_id] AS $raw)
				$total += $raw->get('quantity');
				
			return $total;
		}
	}
?>