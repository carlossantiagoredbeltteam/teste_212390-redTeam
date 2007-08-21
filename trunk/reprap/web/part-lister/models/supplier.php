<?
	class Supplier extends Model
	{
		public function __construct($id = null)
		{
			parent::__construct($id, "suppliers");
		}
		
		public static function byName($name)
		{
			$id = db()->getValue("
				SELECT id
				FROM suppliers
				WHERE name = '$name'
				LIMIT 1
			");
			
			if ($id)
				return new Supplier($id);
			
			return false;
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
		
		public function getViewUrl()
		{
			return "/supplier/" . urlencode($this->get('name'));
		}
		
		public function getHost()
		{
			$data = parse_url($this->get('website'));
			
			return $data['host'];
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
		
		public function getSuppliedParts()
		{
			$sql = "
				SELECT sp.id, sp.part_id
				FROM supplier_parts sp
				INNER JOIN unique_parts u
					ON u.id = sp.part_id
				WHERE sp.supplier_id = '$this->id'
				ORDER BY u.name
			";
			
			return new Collection($sql, array(
				'SupplierPart' => 'id',
				'UniquePart' => 'part_id'
			));
		}
	}
?>