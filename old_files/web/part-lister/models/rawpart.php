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
				WHERE name = '" . db()->safe($name) . "'
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
					if (preg_match("/(\d+)mm\D+(\d+)/", $this->get('raw_text'), $matches))
						return "{$matches[1]}mm";
					if (preg_match("/M(\d+)\D+(\d+)/", $this->get('raw_text'), $matches))
						return "{$matches[1]}mm";
					break;
					
				case 'stud':
					if (preg_match("/M(\d+)\D+(\d+)/", $this->get('raw_text'), $matches))
						return "M{$matches[1]}";
					if (preg_match('|1/4"-20\D+(\d+)|', $this->get('raw_text', $matches)))
						return '1/4"-20';
					break;

				case 'wire':
					if (preg_match("/AWG/i", $this->get('raw_text')))
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
			switch ($this->get('type'))
			{
				case 'belt':
					if (preg_match("/\((.+)\) x (\d+)/", $this->get('raw_text'), $matches))
						return $matches[2] * $this->get('quantity');
					break;

				case 'rod':
				case 'stud':
					if (preg_match("/M(\d+)\D+(\d+)/", $this->get('raw_text'), $matches))
						return $matches[2] * $this->get('quantity');
					if (preg_match('|1/4"-20\D+(\d+)|', $this->get('raw_text'), $matches))
						return $matches[1] * $this->get('quantity');;
					break;
			}
			
			return $this->get('quantity');
		}
		
		public function getChildren()
		{
			$sql = "
				SELECT id
				FROM raw_parts
				WHERE parent_id = $this->id
				ORDER BY type, raw_text
			";
			
			//echo $sql;
			
			return new Collection($sql, array('RawPart' => 'id'));
		}
		
		public function getComponents($deep = false)
		{
			$data = array();
			
			//get our kids.
			$kids = $this->getChildren()->getAll();
			foreach ($kids AS $row)
			{
				$part = $row['RawPart'];
				
				//echo "Got component: " . $part->get('raw_text') . "\n";

				//assemblies are easy... raw -> raw.
				if ($part->get('type') == 'assembly')
				{
					//echo 'Getting kids for assembly.';
					$kids = $part->getComponents($deep);
					foreach ($kids AS $kid)
					{
						$kid->set('quantity', $kid->get('quantity') * $part->get('quantity'));
						$data[] = $kid;
					}
					//echo 'Done with assembly kids.';
				}
				//modules are based on the unique part... raw -> unique -> raw
				else if ($part->get('type') == 'module')
				{
					//if we're deep, load up our kids
					if ($deep)
					{
						//echo 'Getting kids for module';
						$module = new UniquePart($part->get('part_id'));
						$kids = $module->getRawComponents(true);
						foreach ($kids AS $kid)
						{
							$kid->set('quantity', $kid->get('quantity') * $part->get('quantity'));
							$data[] = $kid;
						}
						//echo 'Done with module kids.';						
					}
					//otherwise just add the part.
					else
						$data[] = $part;
				}
				//just add the part in.
				else
					$data[] = $part;
			}
			
			return $data;
		}
	}
?>