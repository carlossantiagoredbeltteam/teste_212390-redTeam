<script>
	function selectModule(id)
	{
		if ($('module_check_' + id).checked)
			Element.addClassName('module_' + id, 'module_row_selected');
		else
			Element.removeClassName('module_' + id, 'module_row_selected');
	}
</script>
<h1>How to use this site</h1>
<?= Controller::byName('main')->renderView('progressbar', array('step' => 1))?>

<?= Controller::byName('main')->renderView('module_list', array('status' => 'production'))?>
<?= Controller::byName('main')->renderView('module_list', array('status' => 'beta'))?>
<?= Controller::byName('main')->renderView('module_list', array('status' => 'obsolete'))?>

<h2>Tree View</h1>
<p>
	Click +/- to expand/collapse.  Click part name to view detail page.
</p>
<p>
	<a href="javascript:d.openAll()">open all</a> | <a href="javascript:d.closeAll()">close all</a>
</p>
<p>
	<script type="text/javascript">
	<!--
		d = new dTree('d');
		d.add(<?=$root->id?>, -1, "<?=$root->get('name')?>", "<?=$root->getViewUrl()?>");
		<?= Controller::byName('parts')->renderView('tree', array('root' => $root)) ?>
		document.write(d);
	//-->
	</script>
</p>
