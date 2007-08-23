<h1><?=$supplier->get('name')?>: <a href="<?=$supplier->get('website')?>"><?=$supplier->getHost()?></a></h1>

<p>
	<?= $supplier->get('description')?>
</p>

<h2>Supplied Parts</h2>
<? if (!empty($parts)): ?>
	<table width="100%">
		<tr>
			<th width="33%">Name</th>
			<th>Part #</th>
		</tr>
		<? foreach ($parts AS $row): ?>
			<? $part = $row['UniquePart'] ?>
			<? $spart = $row['SupplierPart'] ?>
			<? $url = $spart->getBuyUrl() ?>
			<tr>
				<td><b><a href="<?=$part->getViewUrl()?>"><?=$part->get('name')?></a></b></td>
				<? if ($url): ?>
					<td><a href="<?=$url?>"><?=$spart->get('part_num')?></a></td>
				<? else: ?>
					<td><?=$spart->get('part_num')?></td>
				<? endif ?>
			</tr>
		<? endforeach ?>
	</table>
<? else: ?>
	<b>No parts found.</b>
<? endif ?>