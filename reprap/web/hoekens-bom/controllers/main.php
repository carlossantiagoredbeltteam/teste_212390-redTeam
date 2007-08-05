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
				$components = $module->getUniqueComponents();
			
			$this->set('components', $components);
		}
		
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
			
		public function partlist()
		{
			
		}
	}
?>