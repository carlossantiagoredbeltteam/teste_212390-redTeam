<?
	class View
	{
		//hold our private data.
		private $controller;
		private $view;
		private $data;
		
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
		
			if (file_exists(Config::get('VIEW_DIR') . "/{$this->controller}.{$this->view}.php"))
				include(Config::get('VIEW_DIR') . "/{$this->controller}.{$this->view}.php");
			else
				throw new ViewException('This page does not exist!');
		
			return ob_get_clean();
		}
	}
?>