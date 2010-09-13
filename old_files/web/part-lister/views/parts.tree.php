<? if (!empty($kids)): ?>
	<? foreach ($kids AS $type => $row): ?>
		<? foreach ($row AS $part): ?>
			d.add(<?=$part->id?>, <?=$root->id?>, "<?= htmlentities($part->get('name')) ?>", '<?=$part->getViewUrl()?>');
			<? if ($part->get('type') == 'module'): ?>
				<?= Controller::byName('parts')->renderView('tree', array('root' => $part)) ?>
			<? endif ?>
		<? endforeach ?>
	<? endforeach ?>
<? endif ?>