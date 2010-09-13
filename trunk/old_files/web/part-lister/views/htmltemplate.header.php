<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
	<head>
		<? if ($title): ?>
			<title><?=$title?> - <?=RR_PROJECT_NAME?></title>
		<? else: ?>
			<title><?=RR_PROJECT_NAME?></title>
		<? endif ?>
		<link rel="stylesheet" type="text/css" href="/css/style.css" />
		<link rel="stylesheet" type="text/css" href="/dtree/dtree.css" />
		<meta http-equiv="Content-type" content="text/html; charset=UTF-8" />
		<script src="/js/prototype.js"></script>
		<script src="/dtree/dtree.js"></script>
	</head>
	<body>
		<ul id="nav">
			<li><a href="/">Home</a></li>
			<li><a href="/about">About</a></li>
			<li><a href="/parts">Parts</a></li>
			<li><a href="/suppliers">Suppliers</a></li>
			<li><a href="/statistics">Statistics</a></li>
			<li><a href="http://parts.rrrf.org/">Store</a></li>
			<li><a href="http://www.reprap.org/">RepRap.org</a></li>
		</ul>
		<div id="main">
			<a name="top" class="nodisplay"></a>
			<div id="header">
				<h1 class="shad"><em><?=RR_PROJECT_NAME?></em></h1>
				<h1><em><?=RR_PROJECT_NAME?></em></h1>
				<div class="gear"> </div>
			</div>

			<div id="body">
				<div id="content">
					<? if ($title): ?>
						<h1 id="pageTitle"><?=$title?></h1>
					<? endif ?>