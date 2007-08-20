<? $parts = $collection->getAll(); ?>

<h2>Unique <?=UniquePart::typeToEnglish($type)?> Parts</h2>
<? if (!empty($parts)): ?>
	<? foreach ($parts AS $row): ?>
		<? $part = $row['UniquePart'] ?>
		<p>
			<b><a href="/uniquepart:<?=$part->id?>"><?=$part->get('name')?></a></b> <?=$part->get('description')?>
		</p>
	<? endforeach ?>
<? else: ?>
	<b>No parts found.</b>
<? endif ?>