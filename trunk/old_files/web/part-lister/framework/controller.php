<?
	class Controller
	{
		private $view_name;
		private $controller_name;
		private $mode;
		private $args;
		private $data;
		
		public function __construct($name)
		{
			$this->controller_name = $name;
		}

		public static function makeControllerViewKey($controller_name, $view_name, $params) 
		{		
			return sha1("{$controller_name}.{$view_name}." . serialize($params));
		}
	
		public static function byName($name)
		{
			// Get the name of the class to load
			$class_name = "{$name}Controller";
			$class_file = CONTROLLERS_DIR . "/" . strtolower($name) . ".php";
		
			if (file_exists($class_file))
				require_once($class_file);
			else
				throw new ViewException("$name controller does not exist.");
		
			return new $class_name($name);
		}
	
		public function viewFactory()
		{
			$class = ucfirst($mode) . "View";
			if (class_exists($class))
				return new $class($this->controller_name, $this->view_name);
		}

	
		public function renderView($view_name, $args = array(), $cache_time = 0, $key = null)
		{
			// Check the cache
			/*
			if ($cache_time > Cache::TIME_NEVER)
			{
				if ($key === null)
					$key = Controller::makeControllerViewKey($this->controller_name, $view_name, $args);

				$data = CacheBot::get($key);
				
				if ($data !== false)
					return $data;
			}
			*/
		
			//save our params, prep for drawing the view.
			$this->args = $args;
			$this->args = $this->getArgs();

			//call our controller's view method
			if (method_exists($this, $view_name))
				$this->$view_name();	
			
			//no cache, get down to business
			$this->view_name = $view_name;
			$view = $this->viewFactory();
			
			//do our dirty work.
			$view->preRender();
			$output = $view->render($this->data);
			$view->postRender();
		
			//do we save it to cache?
			/*
			if ($cache_time > Cache::TIME_NEVER)
				CacheBot::set($output, $key, $cache_time);
			*/
			
			return $output;
		}
		
		public function get($key = null)
		{
			if ($key === null)
				return $this->data;
			else
				return $this->data[$key];
		}
		
		public function set($key, $data)
		{
			$this->data[$key] = $data;
		}
		
		public function args($key = null)
		{
			if ($key === null)
				return $this->args;
			else
				return $this->args[$key];
		}
		
		protected function setArg($key)
		{
			$this->set($key, $this->args[$key]);
		}

		protected function setView($view_name) 
		{
			$this->view_name = $view_name;
		}

		protected function forwardToURL($url)
		{
			header("Location: {$url}");
			exit();
		}
	
		private function getArgs()
		{
			//for ease of debug.
			ob_start();
			
			//use our already set args.
			$args = array();
		
			// GET is the first level of args.
			if (count($_GET))
				$args = array_merge($args, $_GET);
			echo "After GET:\n";
			print_r($args);
			
			// POST overrides GET.
			if (count($_POST))
				$args = array_merge($args, $_POST);
			echo "After POST:\n";
			print_r($args);

			// JSON data overrides GET and POST
			if (!empty($args['jdata']))
			{
			    $json_data = json_decode(stripslashes($args['jdata']), true);
			    unset($args['jdata']);
			    $args = array_merge($args, $json_data);
			}
			echo "After jdata:\n";
			print_r($args);
			
			// user-defined args rule all!
			if (count($this->args))
				$args = array_merge($args, $this->args);
			echo "Finally:\n";
			print_r($args);
			
			//for debug;
			ob_end_clean();
			
			return $args;
		}
	}
?>
