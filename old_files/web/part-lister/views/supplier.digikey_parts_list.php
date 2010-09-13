
<? if (!empty($parts)): ?>
	<FORM METHOD=POST ACTION='http://sales.digikey.com/scripts/sales.dll'>
		<INPUT TYPE=HIDDEN NAME='action' VALUE='checkfastadd'>
		<INPUT TYPE=HIDDEN NAME='source' VALUE='fastadd'>
		<table width="100%">
			<tr>
				<th>Part #</th>
				<th>Name</th>
				<th>Math</th>
				<th>Quantity</th>
			</tr>
			<? $i=1; ?>
			<? foreach ($parts AS $part): ?>
				<? $unique = new UniquePart($part->get('part_id')) ?>
				<? $url = $part->getBuyUrl() ?>
				<tr>
					<td>
						<INPUT TYPE="hidden" NAME='cref<?=$i?>' value="<?=$unique->get('name')?>"/>
						<INPUT TYPE="hidden" NAME='part<?=$i?>' value="<?=$part->get('part_num')?>"/>
						<?=$part->get('part_num')?>
					</td>
					<td>
						<a href="<?=$unique->getViewUrl()?>"><?=$unique->get('name')?></a>
					</td>
					<td>
						<?=$part->get('total_quantity')?> <?=$unique->get('units')?> needed / 
						<?=$part->get('quantity')?> <?=$unique->get('units')?> per unit
					</td>
					<td>
						<INPUT TYPE=TEXT NAME='qty<?=$i?>' size="3" value="<?=$part->orderQuantity()?>"/>
					</td>
				</tr>
				<? $i++ ?>
			<? endforeach ?>
			<tr>
				<td colspan="4"><input type="submit" NAME='Add List To Order' value="Click here to order above list from DigiKey"/></td>
			</tr>
		</table>
	</form>
<? else: ?>
	<b>No parts found.</b>
<? endif?>