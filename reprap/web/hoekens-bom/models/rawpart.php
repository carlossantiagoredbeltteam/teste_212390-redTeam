<?
	class RawPart extends BaseObject
	{
		public function __construct($id = null)
		{
			parent::__construct($id, "raw_parts");
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
	}
?>