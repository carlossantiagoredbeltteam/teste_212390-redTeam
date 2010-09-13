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
			$this->supplier_parts[$supplier->id][] = $part;
		}
		
		public function addSupplier(Supplier $supplier)
		{
			$this->suppliers[$supplier->get('name') . $supplier->id] = $supplier;
			ksort($this->suppliers);
		}
		
		public function getSupplierParts($id)
		{
			return $this->supplier_parts[$id];
		}
	}
?>