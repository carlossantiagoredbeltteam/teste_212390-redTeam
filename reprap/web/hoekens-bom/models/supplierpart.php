<?
	class SupplierPart extends Model
	{
		public function __construct($id = null)
		{
			parent::__construct($id, "supplier_parts");
		}
		
		public function getBuyUrl()
		{
			$supplier = new Supplier($this->get('supplier_id'));
			
			//do we have a url?
			if ($supplier->get('buy_link'))
				return str_replace("%%PARTID%%", $this->get('part_num'), $supplier->get('buy_link'));
			
			return false;
		}
	}
?>