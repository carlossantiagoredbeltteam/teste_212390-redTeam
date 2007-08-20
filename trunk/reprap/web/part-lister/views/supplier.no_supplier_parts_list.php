<? if (!empty($parts)): ?>
	<table>
		<tr>
			<th>Part #</th>
			<th>Name</th>
			<th>Quantity</th>
		</tr>
		<? foreach ($parts AS $part): ?>
			<? $unique = new UniquePart($part->get('part_id')) ?>
			<tr>
				<td>
					 <?=$part->get('part_num')?>
				</td>
				<td>
					<? if ($url): ?>
						<a href="<?=$part->getBuyUrl()?>"><?=$unique->get('name')?>

					<? else: ?>
						<?=$unique->get('name')?>
					<? endif ?>
				</td>
				<td><?=$part->orderQuantity()?></td>
			</tr>
		<? endforeach ?>
	</table>
<? else: ?>
	<b>No parts found.</b>
<? endif?>