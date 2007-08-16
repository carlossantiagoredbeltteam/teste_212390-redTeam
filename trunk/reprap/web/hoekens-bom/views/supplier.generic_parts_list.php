<? if (!empty($parts)): ?>
	<table>
		<tr>
			<th>Part #</th>
			<th>Name</th>
			<th>Math</th>
			<th>Quantity</th>
		</tr>
		<? foreach ($parts AS $part): ?>
			<? $unique = new UniquePart($part->get('part_id')) ?>
			<? $url = $part->getBuyUrl() ?>
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
				<td>
					<?=$part->get('total_quantity')?><?=$unique->get('units')?> needed / 
					<?=$part->get('quantity')?><?=$unique->get('units')?> per unit
				</td>
				<td>
					<b><?=$part->orderQuantity()?> total</b>
				</td>
			</tr>
		<? endforeach ?>
	</table>
	<br/><br/>
<? else: ?>
	<b>No parts found.</b>
<? endif?>