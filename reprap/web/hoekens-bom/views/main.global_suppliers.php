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
					if (option.innerHTML == supplier_key)
						option.selected = true;
				}
			}
		}
	}
</script>

<h3>Set a global supplier (it will choose this supplier if available below.)</h3>
<select name="global_supplier" onchange="selectGlobalSupplier(this)">
	<option value="">Choose Supplier</option>
	<? foreach ($suppliers AS $corp): ?>
		<? if ($corp instanceof Supplier): ?>
			<option value="<?=$corp->id?>"><?=$corp->get('name')?> (<?= implode(", ", $corp->getCountries()); ?>)</option>
		<? endif ?>
	<? endforeach ?>
</select>