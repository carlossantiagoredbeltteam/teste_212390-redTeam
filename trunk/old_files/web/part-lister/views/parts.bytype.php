<? $parts = $collection->getAll(); ?>

<h2>Unique <?=UniquePart::typeToEnglish($type)?> Parts</h2>
<? if (!empty($parts)): ?>
	<table width="100%">
	<tr>
		<th width="33%">Part</th>
		<th>Description</th>
	</tr>
	<? foreach ($parts AS $row): ?>
		<? $part = $row['UniquePart'] ?>
		<tr>
			<td><b><a href="<?=$part->getViewUrl()?>"><?=$part->get('name')?></a></b></td>
			<td><?=$part->get('description')?></td>
		</tr>
	<? endforeach ?>
	</table>
<? else: ?>
	<b>No parts found.</b>
<? endif ?>