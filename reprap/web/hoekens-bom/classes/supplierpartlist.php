<?
	class SupplierPartList
	{
		public $suppliers = array();
		public $supplier_parts = array();
		
		public function addSupplierPart(SupplierPart $part)
		{
			//add in suppliers
			$supplier = new Supplier($part->get('supplier_id'));
			$this->addSupplier($supplier);
			
			//add in our part.
			$this->supplier_parts[$supplier->id] = $part;
		}
		
		public function addSupplier(Supplier $supplier)
		{
			if (!$this->getSupplier($supplier->id))
				$this->suppliers[$supplier->id] = $supplier;
		}
		
		public function getSupplier($supplier_id)
		{
			return $this->suppliers[$supplier_id];
		}
	}
?>