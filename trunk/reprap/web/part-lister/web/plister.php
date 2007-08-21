<?
	include("../extensions/global.php");

	//are we in the right place?
	if ($_SERVER['HTTP_HOST'] != SITE_HOSTNAME)
		header("Location: http://" . SITE_HOSTNAME . $_SERVER['REQUEST_URI']);

	//get our stuff.
	$mode = $_GET['mode'];
	$controller = $_GET['controller'];
	$view = $_GET['view'];

	//set some defaults here.
	if (!$mode)
		$mode = "HTML";
	if (!$controller)
		$controller = 'main';
	if (!$view)
		$view = 'home';

	//load the content.
	$main = Controller::byName($controller);
	$content = $main->renderView($view);
	
	//now draw it in our template.
	echo Controller::byName("{$mode}Template")->renderView('main', array(
		'content' => $content,
		'title' => $main->get('title')
	));
?>