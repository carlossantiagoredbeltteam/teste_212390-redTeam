<? if (!empty($parts)): ?>
	<table width="100%">
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
					<? if ($url): ?>
						 <a href="<?=$url?>">(buy)</a>
					<? endif ?>
				</td>
				<td>
					<a href="<?=$unique->getViewUrl()?>"><?=$unique->get('name')?></a>
				</td>
				<td>
					<?=$part->get('total_quantity')?> <?=$unique->get('units')?> needed / 
					<?=$part->get('quantity')?> <?=$unique->get('units')?> per unit
				</td>
				<td>
					<b><?=$part->orderQuantity()?> total</b>
				</td>
			</tr>
		<? endforeach ?>
	</table>
<? else: ?>
	<b>No parts found.</b>
<? endif?>