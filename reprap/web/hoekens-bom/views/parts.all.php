<h1>Parts</h1>
<? if (!empty($parts)): ?>
	<? foreach ($parts AS $row): ?>
		<? $part = $row['UniquePart'] ?>
		<? if ($part->get('type') != $type): ?>
			<? $type = $part->get('type'); ?>
			<h2><?=UniquePart::typeToEnglish($type)?> Parts (<a href="/type/<?=$type?>">see all</a>)</h2>
		<? endif ?>
		<p>
			<b><a href="/uniquepart:<?=$part->id?>"><?=$part->get('name')?></a></b> <?=$part->get('description')?>
		</p>
	<? endforeach?>
<? else: ?>
	<b>No parts found.</b>
<? endif ?>