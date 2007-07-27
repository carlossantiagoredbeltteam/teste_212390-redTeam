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
	<ul>
		<li>Step 1: Choose which assemblies and the quantities of each.</li>
		<li><b>Step 2: Choose which suppliers you'd like to use.</b></li>
		<li>Step 3: Order your parts!  Super easy.</li>
	</ul>
	
	<h3>Set a global supplier (it will choose this supplier if available below.)</h3>
	<select name="global_supplier" onchange="selectGlobalSupplier(this)">
		<option value="">Choose Supplier</option>
		<? foreach ($suppliers AS $corp): ?>
			<? if ($corp instanceof Corporation): ?>
				<option value="<?=$corp->name?>"><?=$corp->name?> (<?= implode(", ", $corp->countries); ?>)</option>
			<? endif ?>
		<? endforeach ?>
	</select>
	<form action="billofmaterials.php" method="post" id="bom_form">
<?
		foreach ($types AS $type)
		{
			$parts = $bom->getParts($type);
			
			if ($type != 'assembly')
				renderGenericPartsHTML($parts, ucfirst(strtolower($type)));
		}
?>
		<input type="submit" name="submit" value="Generate Bill of Materials"/>
	</form>