<? if (!empty($parts)): ?>
	<table>
		<tr>
			<th>Part to Buy</th>
			<th>Quantity</th
		</tr>
		<? foreach ($parts AS $part): ?>
			<? $unique = new UniquePart($part->get('part_id')) ?>
			<? $url = $part->getBuyUrl() ?>
			<tr>
				<? if ($url): ?>
					<td><a href="<?=$part->getBuyUrl()?>"><?=$unique->get('name')?> (<?=$part->get('part_num')?>)</a></td>
				<? else: ?>
					<td><?=$unique->get('name')?> (<?=$part->get('part_num')?>)</td>
				<? endif ?>
				<td><?=$part->get('quantity')?></td>
			</tr>
		<? endforeach ?>
	</table>
	<br/><br/>
<? else: ?>
	<b>No parts found.</b>
<? endif?>