<?
	class LegendPart extends Model
	{
		public function __construct($id = null)
		{
			parent::__construct($id, "legend");
		}

		public static function getModules($status)
		{
			$sql = "
				SELECT id, unique_part_id
				FROM legend
				WHERE status = '{$status}'
				ORDER BY id
			";
			
			return new Collection($sql, array(
				'LegendPart' => 'id',
				'UniquePart' => 'unique_part_id'
			));
		}
	}
?>