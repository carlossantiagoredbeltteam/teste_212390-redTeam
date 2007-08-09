<?
	class SupplierController extends Controller
	{
		public function generic_parts_list()
		{
			$this->setArg('supplier');
			$this->setArg('parts');
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