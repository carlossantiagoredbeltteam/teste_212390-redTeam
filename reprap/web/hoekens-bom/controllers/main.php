<?
	class MainController extends Controller
	{
		public function progressbar()
		{
			$this->setArg('step');
		}
		
		public function home()
		{
			$this->set('modules', UniquePart::getModules()->getAll());
		}
		
		public function uniqueparts()
		{
			$this->set('title', 'Module Components');
			
			$module = new UniquePart($this->args('module_id'));
			if ($module->id)
				$list = $module->getUniquePartList($this->args('deep_lookup'), $this->args('quantity'));
			
			$this->set('list', $list);
			$this->set('module', $module);
		}
		
		public function part_suppliers()
		{
			$part = $this->args('part');
			
			$this->setArg('part');
			$this->set('supplied_parts', $part->getSupplierParts()->getAll());
		}
		
		public function partlist()
		{
			$args = $this->args();
			$list = new SupplierPartList();
			$module = new UniquePart($args['module_id']);
			
			//add all our used parts into the list.
			foreach ($args['use_part'] AS $key => $use)
			{
				$part = new SupplierPart($args['part_supplier'][$key]);
				$part->set('quantity', $args['quantity'][$key]);
				$list->addSupplierPart($part);
			}
			
			$this->set('module', $module);
			$this->set('list', $list);
		}
		
		public function statistics()
		{
			$this->set('unique_part_count', db()->getValue("
				SELECT count(*)
				FROM unique_parts
			"));
			$this->set('supplier_count', db()->getValue("
				SELECT count(*)
				FROM suppliers
			"));
			$this->set('part_types', db()->getArray("
				SELECT count(*) AS cnt, type
				FROM unique_parts
				GROUP BY type
				ORDER BY type
			"));
		}
	}
?>