<script>
	function selectGlobalSupplier(ele)
	{
		var supplier_key = ele.value;
		if (supplier_key)
		{
			var selects = Element.getElementsByClassName($('bom_form'), 'supplier_select');
			for (var i=0; i<selects.length; i++)
			{
				var select = selects[i];

				var options = Element.immediateDescendants(select);

				for (var j=0; j<options.length; j++)
				{
					var option = options[j];
					if (option.id == "supplier_" + supplier_key)
						option.selected = true;
				}
			}
		}
	}
</script>

<span style="font-size: 23px">Set a global supplier:</span>
<select name="global_supplier" onchange="selectGlobalSupplier(this)">
	<option value="">Choose Supplier</option>
	<? foreach ($suppliers AS $row): ?>
		<? $corp = $row['Supplier']; ?>
		<? if ($corp instanceof Supplier): ?>
			<option value="<?=$corp->id?>"><?=$corp->get('name')?> <? /* ?>(<?= implode(", ", $corp->getCountries()); ?>) <? */ ?></option>
		<? endif ?>
	<? endforeach ?>
</select>
<br/>
(This will choose this supplier below, if it is an option for that part. It can be used multiple times.)
