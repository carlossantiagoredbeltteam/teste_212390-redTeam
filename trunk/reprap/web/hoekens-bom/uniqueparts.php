<?
	require_once("include.php");

	$output = $_POST['output'];
	if ($output != '')
	{
		//send it out!
		$parts = importBOMData($_POST['assembly_ids'], $_POST['assembly_qty']);
	
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
?>
	<h1>Choose Suppliers</h1>
	<ul>
		<li>Step 1: Choose which assemblies and the quantities of each.</li>
		<li><b>Step 2: Choose which suppliers you'd like to use.</b></li>
		<li>Step 3: Order your parts!  Super easy.</li>
	</ul>
	<form action="billofmaterials.php" method="post">
<?
		$types = $bom->getTypes();

		foreach ($types AS $type)
		{
			$parts = $bom->getParts($type);
			
			renderGenericPartsHTML($parts, ucfirst(strtolower($type)));
		}
?>
		<input type="submit" name="submit" value="Generate Bill of Materials"/>
	</form>
<?
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
		<table>
			<tr>
				<th>Part</th>
				<th>Quantity</th>
				<th>Suppliers</th>
			</tr>
			<? foreach ($parts AS $part): ?>
				<tr>
					<td><?=$part->name?></td>
					<td><?=$part->quantity?></td>
					<td><? renderPartSuppliers($part) ?></td>
				</tr>
			<? endforeach ?>
		</table>
	<? else: ?>
		<b>No parts found.</b>
	<? endif ?>
<?
	}

	function renderPartSuppliers($part)
	{
		echo '<input type="hidden" name="parts[]" value="' . $part->getSafeName() . '"/>';
		echo '<input type="hidden" name="quantities[]" value="' . $part->quantity .  '"/>';

		if (count($part->suppliers))
		{
			echo '<select name="suppliers[]">';
			foreach ($part->suppliers AS $supplier)
				echo '<option value="' . $supplier->name . '">' . $supplier->key . ' (' . $supplier->part_id . ')</option>';
			echo '</select>';
		}
		else
		{
			echo '<input type="hidden" name="suppliers[]" value=""/>';
			echo '<b>no suppliers</b> - <a href="http://forums.reprap.org">suggest one!</a>';
		}
	}
?>