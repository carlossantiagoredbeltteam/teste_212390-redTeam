<?
	class View
	{
		//hold our private data.
		private $controller;
		private $view;
		
		//init and save our controller/view info.
		public function __construct($controller, $view)
		{
			$this->controller = $controller;
			$this->view = $view;
		}
		
		//placeholder functions for any special stuff you gotta do.
		public function preRender() {}
		public function postRender() {}
	
		public function render($data = array())
		{
			//get our data variables into the local scope
			if (!empty($data))
	        	extract((array)$data, EXTR_OVERWRITE);
	
			ob_start();

			$view_file = strtolower(VIEWS_DIR . "{$this->controller}.{$this->view}.php");
			if (file_exists($view_file))
				include($view_file);
			else
				throw new ViewException("The {$this->controller}.{$this->view} page does not exist!");
		
			return ob_get_clean();
		}
	}
?>