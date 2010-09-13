<? if (!empty($parts)): ?>
	<form action="/amazon_checkout" method="post">
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
						<?=$part->get('part_num')?> <a href="<?=$url?>">(buy)</a>
						<input type="hidden" name="asin[]" value="<?=$part->get('part_num')?>" />
					</td>
					<td>
						<a href="<?=$unique->getViewUrl()?>"><?=$unique->get('name')?></a>
					</td>
					<td>
						<?=$part->get('total_quantity')?><?=$unique->get('units')?> needed / 
						<?=$part->get('quantity')?><?=$unique->get('units')?> per unit
					</td>
					<td>
						<b><?=$part->orderQuantity()?> total</b>
						<input type="hidden" name="quantities[]" value="<?=$part->orderQuantity()?>" />
					</td>
				</tr>
			<? endforeach ?>
			<tr>
				<td colspan="4" align="right"><input type="submit" value="Add to Amazon Cart" style="font-size: 20px" onclick="this.value = 'Creating cart. Please be patient.'; this.disabled = true; return true;"/>
			</tr>
		</table>
		<br/>
	</form>
<? else: ?>
	<b>No parts found.</b>
<? endif?>