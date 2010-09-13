<?
	class Country extends Model
	{
		public function __construct($id = null)
		{
			parent::__construct($id, "countries");
		}
		
		public static function byCode($code)
		{
			$id = db()->get("
				SELECT id
				FROM countries
				WHERE code = '$code'
				LIMIT 1
			");
			
			return new Country($id);
		}
		
		public static function byGroup($group)
		{
			if ($group != 'all')
				$where = "WHERE group = '$group'";
				
			$sql = "
				SELECT id
				FROM countries
				$where
				ORDER BY name
			";
			
			return new Collection($sql, array('Country' => 'id'));
		}
	}
?>