<?

	//draw our various areas.
	echo Controller::byName("HTMLTemplate")->renderView('header', array('title' => $title));
	echo $content;
	echo Controller::byName("HTMLTemplate")->renderView('footer');

?>