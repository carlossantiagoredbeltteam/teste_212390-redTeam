<?
	class MainController extends Controller
	{
		public function home()
		{
			$modules = loadModulesData();
		}
		
		public function uniqueparts()
		{
			$output = $_POST['output'];
			if ($output != '')
			{
				//send it out!
				$parts = importBOMData($_POST['assembly_ids'], $_POST['assembly_qty']);
				$corps = loadSupplierData();				
			}
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