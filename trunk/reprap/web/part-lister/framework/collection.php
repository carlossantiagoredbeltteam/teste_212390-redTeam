<?
	class Collection
	{
		private $query;
		private $obj_types;
		private $expiration;
		private $key;
		private $map;
	
		public function __construct($query, $obj_types, $expiration = 0, $key = null)
		{
			$this->query = $query;
			$this->obj_types = $obj_types;
			$this->expiration = $expiration;
		
			if ($key === null)
				$this->key = sha1($query);
			else
				$this->key = $key;
	
			$this->map = db()->getArray($this->query, "{$key}.collection", $expiration);
		}
	
		/**
		* @TODO: fix this to make it work
		*/
		public function implodeMap($type)
		{		 
			if (is_array($this->map))
				return implode(', ', $this->getMap($type));

			return '';
		}
	
		/**
		* @TODO: make this work as well
		*/
		public function getMap($type = null)
		{
			return $this->map;
		}
		
		public function count() 
		{
			if (is_array($this->map))
				return count($this->map);
			else
				return 0;
		}
	
		public function getAll() 
		{
			return $this->buildObjectArray();
		}
	
		public function getRange($start, $end) 
		{
			if (is_array($this->map))
				return $this->buildObjectArray(array_slice($this->map, $start, $end, false));
			else
				return array();
		}
	
		private function buildObjectArray($map = null) 
		{
			if ($map === null)
				$map = $this->map;
			
			if (!is_array($map))
				return array();

			//very simple load...  should be made more advanced.
			$data = array();
			foreach ($map AS $key => $row){
				foreach ($this->obj_types AS $type => $id){
					$data[$key][$type] = new $type($row[$id]);
				}
			}	

			return $data;
		}
	}
?>
