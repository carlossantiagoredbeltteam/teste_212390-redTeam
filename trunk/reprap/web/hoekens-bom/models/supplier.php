<?
	class Supplier extends Model
	{
		public function __construct($id = null)
		{
			parent::__construct($id, "suppliers");
		}
		
		public static function lookupUrl($url)
		{
			$data = parse_url($url);
			$domain = $data['domain'];
			
			$id = db()->getValue("
				SELECT id
				FROM suppliers
				WHERE website LIKE '%$domain%'
				LIMIT 1
			");
			
			if ($id)
				return new Supplier($id);

			return false;
		}
		
		public static function lookupKey($key)
		{
			$id = db()->getValue("
				SELECT id
				FROM suppliers
				WHERE prefix = '$key'
				LIMIT 1
			");
			
			if ($id)
				return new Supplier($id);

			return false;
		}
	}
?>