<h1><?=$supplier->get('name')?>: <a href="<?=$supplier->get('website')?>"><?=$supplier->getHost()?></a></h1>

<p>
	<?= $supplier->get('description')?>
</p>

<h2>Supplied Parts</h2>
<? if (!empty($parts)): ?>
	<? foreach ($parts AS $row): ?>
		<? $part = $row['UniquePart'] ?>
		<? $spart = $row['SupplierPart'] ?>
		<p>
			<b><a href="/uniquepart:<?=$part->id?>"><?=$part->get('name')?></a></b>: <?=$spart->get('part_num')?>
			<a href="<?=$spart->getBuyUrl()?>">details/buy</a>
		</p>
	<? endforeach ?>
<? else: ?>
	<b>No parts found.</b>
<? endif ?>