<?
	class RawPart extends Model
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
		
		public function lookupUnique($name = null, $type = null)
		{
			if ($name === null)
				$name = $this->getLookupName();
			if ($type === null)
				$type = $this->get('type');

			$sql = "
				SELECT id
				FROM unique_parts
				WHERE name = '$name'
					AND type = '$type'
			";
			$partId = db()->getValue($sql);
			
			if ($partId)
				return new UniquePart($partId);
				
			if ($type != 'assembly')
				echo "<b>Couldn't find unique part for $name ($type)</b><br/>";
			
			return false;
		}
		
		public function getLookupName()
		{
			switch ($this->get('type'))
			{
				case 'belt':
					if (preg_match("/\((.+)\) x (\d+)/", $this->get('raw_text'), $matches))
						return $matches[1];
					break;
					
				case 'rp':
					return "Printing Service";
					break;

				case 'rod':
				case 'stud':
					if (preg_match("/M(\d+)\D+(\d+)/", $this->get('raw_text'), $matches))
						return "M{$matches[1]}";
					break;

				case 'wire':
					if (!preg_match("/^Nichrome/i", $this->get('raw_text')))
					{
						if (preg_match("/(\d+) AWG/", $this->get('raw_text'), $matches))
								return "$matches[1] AWG";
						if (preg_match("/(\d+)/", $this->get('raw_text'), $matches))
								return '22 AWG';
					}
					break;
			}
			
			return $this->get('raw_text');
		}
		
		public function getDisplayName()
		{
			
		}
		
		public function getRealQuantity()
		{
			
		}
	}
?>