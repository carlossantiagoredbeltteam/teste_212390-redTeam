<? if (!empty($supplied_parts)): ?>
	<select name="part_supplier[<?=$part->id?>]">
		<? foreach ($supplied_parts AS $row): ?>
			<? $supplier = $row['Supplier']; ?>
			<? $spart = $row['SuppliedPart']; ?>
			<option value="<?=$spart->id?>"><?=$supplier->get('name')?></option>
		<? endforeach ?>
	</select>
<? else: ?>
	<b>No Suppliers!</b>
<? endif ?>