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
			$module = new UniquePart($this->args('module_id'));
			if ($module->id)
				$list = $module->getUniquePartList($this->args('deep_lookup'), $this->args('quantity'));
			
			$this->set('list', $list);
			$this->set('module', $module);
		}
		
		public function global_suppliers()
		{
			$this->set('suppliers', $this->args('suppliers')->getAll());
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
				$part->set('total_quantity', $args['quantity'][$key]);
				$list->addSupplierPart($part);
			}
			
			$this->set('module', $module);
			$this->set('list', $list);
			$this->setArg('no_suppliers');
		}
		
		public function statistics()
		{
			$this->set('supplier_count', db()->getValue("
				SELECT count(*)
				FROM suppliers
			"));
			
			$this->set('supplier_part_count', db()->getValue("
				SELECT count(*)
				FROM supplier_parts
			"));
			
			$this->set('raw_part_count', db()->getValue("
				SELECT count(*)
				FROM raw_parts
			"));
			
			$this->set('rough_unique_count', db()->getValue("
				SELECT count(distinct(raw_text))
				FROM raw_parts
			"));
			
			$this->set('unique_part_count', db()->getValue("
				SELECT count(*)
				FROM unique_parts
				WHERE type != 'assembly'
					AND type != 'module'
					AND type != 'tool'
			"));
			
			$this->set('part_types', db()->getArray("
				SELECT count(*) AS cnt, type
				FROM unique_parts
				WHERE type != 'assembly'
					AND type != 'module'
					AND type != 'tool'
				GROUP BY type
				ORDER BY cnt DESC
			"));
		}
	}
?>