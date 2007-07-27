<h3><?=$name?></h3>
<? if (count($parts)): ?>
	<table width="100%">
		<tr>
			<th width="50%">Part</th>
			<th width="10%">Quantity</th>
			<th width="40%">Suppliers</th>
		</tr>
		<? foreach ($parts AS $part): ?>
			<?$total += $part->quantity;?>
			<tr>
				<td valign="top">
					<? if ($part->unique_part->url): ?>
						<a href="<?=$part->unique_part->url?>"><?=$part->name?></a>
					<? else: ?>
					 	<?=$part->name?>
					<? endif ?>
					<? if ($part->unique_part->description): ?>
						<img src="/img/help-icon.gif" onclick="Element.toggle('<?=$part->name?>');" style="margin-left: 5px" />
					<? endif ?>
				</td>
						
				<td align="center"><?=$part->quantity?>
					<? if ($part->unique_part->units): ?>
						<?=$part->unique_part->units?>
					<? endif ?>
				</td>
				<td><? renderPartSuppliers($part) ?></td>
			</tr>
			<tr id="<?=$part->name?>" style="display: none">
				<td colspan="3" class="part_description"><?=$part->unique_part->description?></td>
			</tr>
		<? endforeach ?>
		<tr>
			<td align="right">Total:</td>
			<td align="center"><?=$total?></td>
		</tr>
	</table>
<? else: ?>
	<b>No parts found.</b>
<? endif ?>