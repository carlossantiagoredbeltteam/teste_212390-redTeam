<? if (!empty($supplied_parts)): ?>
	<select name="part_supplier[<?=$part->id?>]" class="supplier_select">
		<? foreach ($supplied_parts AS $row): ?>
			<? $supplier = $row['Supplier']; ?>
			<? $spart = $row['SupplierPart']; ?>
			<option id="supplier_<?=$supplier->id?>" value="<?=$spart->id?>"><?=$supplier->get('name')?></option>
		<? endforeach ?>
	</select>
<? else: ?>
	<input type="hidden" name="no_suppliers[]" value="<?=$part->id?>" />
	<b>No Suppliers!</b>
<? endif ?>