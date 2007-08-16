<?
	class SupplierController extends Controller
	{
		public function all()
		{	
			$sql = "
				SELECT id
				FROM suppliers
				ORDER BY name
			";
			$coll = new Collection($sql, array(
				'Supplier' => 'id'
			));
			
			$this->set('suppliers', $coll->getAll());
		}
		
		public function generic_parts_list()
		{
			$this->setArg('supplier');
			$this->setArg('parts');
		}

		public function no_supplier_parts_list()
		{
			$this->setArg('parts');
			$this->setArg('no_suppliers');
		}
				
		public function amazon_parts_list()
		{
			$this->generic_parts_list();
		}
		
		public function mouser_parts_list()
		{
			$this->generic_parts_list();
		}
		
		public function farnell_parts_list()
		{
			$this->generic_parts_list();
		}
		
		public function rs_parts_list()
		{
			$this->generic_parts_list();
		}
	}
?>