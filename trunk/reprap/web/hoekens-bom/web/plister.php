<?
	include("../extension/global.php");

	$controller = $_GET['controller'];
	$view = $_GET['view'];

	if (!$controller)
		$controller = 'main';
	if (!$view)
		$view = 'home';

	echo Controller::byName($controller)->renderView($view);
?>