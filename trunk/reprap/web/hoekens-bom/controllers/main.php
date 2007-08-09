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
				$list = $module->getUniquePartList($this->args('deep_lookup'));
			
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
				$part = new SupplierPart($key);
				$part->set('quantity', $args['quantity'][$key]);
				$list->addSupplierPart($part);
			}
			
			$this->set('module', $module);
			$this->set('list', $list);
		}
		
		/**
		*  NOT USED... YET!
		**/
		function render_unique_csv($bom)
		{
			$types = $bom->getTypes();
			foreach ($types AS $type)
			{
				$parts = $bom->getParts($type);
				renderGenericPartsCSV($parts, ucfirst(strtolower($type)));
			}
		}

		function render_unique_json($bom)
		{
			$parts = $bom->getParts();
			echo json_encode($parts);
			die;
		}

		function render_unique_html($bom)
		{
			drawHeader("Choose Suppliers");

			$types = $bom->getTypes();
			$suppliers = $bom->getUniqueSuppliers();
		}
	}
?>