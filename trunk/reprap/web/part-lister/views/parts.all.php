<h1>Parts</h1>
<? if (!empty($parts)): ?>
		<? foreach ($parts AS $row): ?>
			<? $part = $row['UniquePart'] ?>
			<? if ($part->get('type') != $type): ?>
				<? if ($type): ?>
					</table>
				<? endif ?>
				<? $type = $part->get('type'); ?>
				<h2><?=UniquePart::typeToEnglish($type)?> Parts (<a href="/type/<?=$type?>">see all</a>)</h2>
				<table width="100%">
					<tr>
						<th width="33%">Part</th>
						<th>Description</th>
					</tr>
			<? endif ?>
			<tr>
				<td><b><a href="<?=$part->getViewUrl()?>"><?=$part->get('name')?></a></b></td>
				<td><?=$part->get('description')?></td>
			</tr>
		<? endforeach?>
	</table>
<? else: ?>
	<b>No parts found.</b>
<? endif ?>