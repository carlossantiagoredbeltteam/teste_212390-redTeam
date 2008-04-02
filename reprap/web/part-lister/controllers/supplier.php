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

		public function digikey_parts_list()
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
			//dont let us time out here.
			set_time_limit(0);
			
			//get our items
			$asins = $this->args('asin');
			$qtys = $this->args('quantities');
			
			//setup our base url.
			$base_url = "http://ecs.amazonaws.com/onca/xml?Service=AWSECommerceService&AWSAccessKeyId=" . AWSAccessKeyId . "&AssociateTag=" . AmazonAssociateTag;

			//create our cart (we need one product in there to start.)
			$url = $base_url . "&Operation=CartCreate&Item.0.ASIN=0071459332&Item.0.Quantity=1";
			$file = new File(TEMP_DIR);
			$file->open($url);
			$xml_data = $file->read();
			$xml = simplexml_load_string($xml_data);
			
			//get our cart values.
			$cart_id = (string) $xml->Cart->CartId;
			$hmac = (string) $xml->Cart->URLEncodedHMAC;

			//clear our cart so that we start fresh each time. 
			$url = $base_url . "&Operation=CartClear&CartId=$cart_id&HMAC=$hmac";
			$file = new File(TEMP_DIR);
			$file->open($url);
			$xml_data = $file->read();
			$xml = simplexml_load_string($xml_data);
			
			//now add each product in individually.
			foreach ($asins AS $key => $asin)
			{
				//get our data
				$qty = $qtys[$key];

				//create our url.
				$url = $base_url . "&Operation=CartAdd&CartId=$cart_id&HMAC=$hmac&Item.0.ASIN={$asin}&Item.0.Quantity={$qty}";

				//add our product in!
				$file = new File(TEMP_DIR);
				$file->open($url);
				$xml_data = $file->read();
				$xml = simplexml_load_string($xml_data);
				
				//was our request successful?
				$result = (string) $xml->Cart->Request->IsValid;
				if ($result != 'True')
				{
					$errors[] = "Error adding $asin to cart.";
				}
			}
			
			//get our final cart info.
			$url = $base_url . "&Operation=CartGet&CartId=$cart_id&HMAC=$hmac";
			
			$file = new File(TEMP_DIR);
			$file->open($url);
			$xml_data = $file->read();
			$xml = simplexml_load_string($xml_data);
			$cart = $xml->Cart;

			//save our data for our view.
			$this->set('cart', $cart);
			$this->set('errors', $errors);
			$this->set('cart_id', $cart_id);
			$this->set('hmac', $hmac);
		}
	}
?>