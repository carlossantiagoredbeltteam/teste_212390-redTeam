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
		
		public function amazon_checkout()
		{
			die('under construction...');
			
			print_r($this->args());
			
			$asins = $this->args('asin');
			$qty = $this->args('quantities');
			
			$url  = "http://ecs.amazonaws.com/onca/xml?Service=AWSECommerceService&AWSAccessKeyId=" . AWSAccessKeyId;
			$url .= "&AssociateTag=" . AmazonAssociateTag;
			$url .= "&Operation=CartCreate";
			
			foreach ($asins AS $key => $asin)
			{
				$quantity = $qty[$key];
				
				if ($quantity && $asin)
					$url .= "&Item.{$key}.ASIN={$asin}&Item.{$key}.Quantity={$quantity}";
					
				break;
			}
			
			$xml = simplexml_load_string(file_get_contents($url));
			
			echo "<!-- $url -->\n";
			print_r($xml);
			
			die();
		}
	}
?>