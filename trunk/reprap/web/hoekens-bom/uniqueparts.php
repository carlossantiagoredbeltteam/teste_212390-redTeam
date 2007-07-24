<?
	require_once("include/global.php");

	$output = $_POST['output'];
	if ($output != '')
	{
		//send it out!
		$parts = importBOMData($_POST['assembly_ids'], $_POST['assembly_qty']);
		$corps = loadSupplierData();
	
		if ($output == 'json')
			renderUniqueJSON($parts);
		else if ($output == 'csv')
			renderUniqueCSV($parts);
		else
			renderUniqueHTML($parts);
	}
	else
		echo "Oops, you gotta POST here bro.";
		
	function renderUniqueCSV($bom)
	{
		$types = $bom->getTypes();

		foreach ($types AS $type)
		{
			$parts = $bom->getParts($type);
			renderGenericPartsCSV($parts, ucfirst(strtolower($type)));
		}
	}

	function renderUniqueJSON($bom)
	{
		$parts = $bom->getParts();
		echo json_encode($parts);
	}

	function renderUniqueHTML($bom)
	{
		drawHeader("Choose Suppliers");

		$types = $bom->getTypes();
		$suppliers = $bom->getUniqueSuppliers();
?>
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
<?
		drawFooter();
	}

	function renderGenericPartsCSV($parts, $name)
	{
		$fp = fopen('php://output', 'w');

		fputcsv($fp, array($name));
		fputcsv($fp, array("Name", "Quantity"));

		if (count($parts))
			foreach ($parts AS $part)
				fputcsv($fp, array($part->name, $part->quantity));

		fputcsv($fp, array());
		fclose($fp);
	}

	function renderGenericPartsHTML($parts, $name)
	{
?>
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
<?
	}

	function renderPartSuppliers($part)
	{
		global $corps;
		
		echo '<input type="hidden" name="parts[]" value="' . $part->getSafeName() . '"/>';
		echo '<input type="hidden" name="quantities[]" value="' . $part->quantity .  '"/>';

		if (!empty($part->unique_part->suppliers))
		{
			echo '<select class="supplier_select" name="suppliers[]">';
			foreach ($part->unique_part->suppliers AS $supplier)
			{
				if ($corps[$supplier->key])
					$name = $corps[$supplier->key]->name;
				else
					$name = $supplier->key;
			
				echo '<option value="' . $supplier->name . '">' . $name . '</option>';
			}
			echo '</select>';
		}
		else
		{
			echo '<input type="hidden" name="suppliers[]" value=""/>';
			echo '<b>no suppliers</b> - <a href="http://forums.reprap.org">suggest one!</a>';
		}
		echo "\n";
	}
?>