<?
	
	// Load Constants
	$f = __FILE__;

	// figure out the base dir, we're two directories past the base dir
	// so just pop them off the end
	$parts = explode("/", $f);
	array_pop($parts);
	array_pop($parts);
	$base_dir = join('/', $parts);
	
	$constants = array(
					   'APP_NAME'			=>	$application_name,
					   'ROOT_DIR_NAME'		=> 	$application_name,
					   'HOME_DIR'			=>	$base_dir,
					   'WEB_DIR' 			=>	$base_dir.'/web/', 
					   'BASE_DIR' 			=>  $base_dir.'/framework/',
					   'EXTENSIONS_DIR' 	=>  $base_dir.'/extensions/',
					   'CLASSES_DIR' 		=>  $base_dir.'/classes/',
					   'INCLUDES_DIR'		=>	$base_dir.'/includes/',
					   'VIEWS_DIR'			=>	$base_dir.'/views/',
					   'CONTROLLERS_DIR'	=>	$base_dir.'/controllers/',
					   'MODELS_DIR'			=>	$base_dir.'/models/',
					   'CRONS_DIR'			=>	$base_dir.'/cron/'
				 );
	
	foreach($constants as $c => $v) {
	 	#echo $v . "<br/>";
	 	
		define($c,$v);
	}
	
	//simply include all our files...
	include(BASE_DIR . "model.php");
	include(BASE_DIR . "view.php");
	include(BASE_DIR . "controller.php");
	include(BASE_DIR . "collection.php");
	include(BASE_DIR . "db.php");
	include(BASE_DIR . "exceptions.php");
	include(BASE_DIR . "file.php");
	
	function __autoload($class)
	{
		$class = strtolower($class);
		
		$file = MODELS_DIR . "$class.php";
		if (is_file($file))
		{
			include($file);
			return true;
		}
		
		$file = CLASSES_DIR . "$class.php";
		if (is_file($file))
		{
			include($file);
			return true;
		}
		
		return false;
	}

?>