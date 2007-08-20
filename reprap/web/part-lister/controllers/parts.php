<?
	class PartsController extends Controller
	{
		public function bysupplier()
		{
			$supplier = new Supplier($this->args('id'));
			$parts = $supplier->getSuppliedParts()->getAll();
			
			$this->set('parts', $parts);
			$this->set('supplier', $supplier);
		}
		
		public function bytype()
		{
			$type = $this->args('type');
			$collection = UniquePart::byType($type);
			
			$this->set('type', $type);
			$this->set('collection', $collection);
		}
		
		public function uniquedetail()
		{
			if ($this->args('id'))
				$part = new UniquePart($this->args('id'));
			else if ($this->args('name'))
				$part = UniquePart::byName($this->args('name'));
			else
				$this->set('error', "You didn't pass in the right parameters.");
				
			if ($part->id)
			{
				$list = $part->getUniquePartList();
				$suppliers = $part->getSupplierParts()->getAll();
				$modules = $part->getParentModules()->getAll();
			
				$this->set('list', $list);
				$this->set('suppliers', $suppliers);
				$this->set('part', $part);
				$this->set('modules', $modules);
			}
			else
				$this->set('error', "We could not find the part you are looking for.");

		}
		
		public function all()
		{
			$sql = "
				SELECT id
				FROM unique_parts
				ORDER BY type, name
			";
			$coll = new Collection($sql, array(
				'UniquePart' => 'id'
			));
			
			$this->set('parts', $coll->getAll());
		}
	}
?>