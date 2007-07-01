<?
	require_once("include/global.php");

	drawHeader("RepRap Bill of Materials - " . date("F d, Y"));

	if (isset($_POST['submit']))
	{
		$suppliers = loadSupplierData();
		$list = new SupplierList;
		
		foreach ($_POST['parts'] AS $key => $part)
		{
			$supplier = new Supplier($_POST['suppliers'][$key]);
			$supplier->name = str_replace("_", " ", $part);
			$supplier->quantity = $_POST['quantities'][$key];
			
			$list->addSupplier($supplier);
		}
		
		
		$corps = $list->getSuppliers();
?>
		<ul>
			<li>Step 1: Choose which assemblies and the quantities of each.</li>
			<li>Step 2: Choose which suppliers you'd like to use.</li>
			<li><b>Step 3: Order your parts!  Super easy.</b></li>
		</ul>
<?
		echo "<p><b>" . count($corps) . " total suppliers selected.</b>  You may want to print this to help keep track of what parts you need.</p>";
		
		foreach ($corps AS $corp)
		{
			$parts = $list->getParts($corp);
			
			if (count($parts))
			{
				if ($corp == 'M')
					renderMouserParts($parts);
				else if ($corp == 'RS')
					renderRSParts($parts);
				else if ($corp == 'F')
					renderFarnellParts($parts);
				else if ($corp == '')
					renderUnknownParts($parts);
				else
				{
					if (isset($suppliers[$corp]))
						renderParts($parts, $suppliers[$corp]);
					else
						renderParts($parts, $corp);
				}
			}
		}
	}
	else
		echo "Oops, you gotta POST here bro.";
		
	drawFooter();
	
	
	//VIEW FUNCTIONS BELOW.

	function renderParts($parts, $corp)
	{
		if ($corp instanceof Corporation)
		{
			echo '<h2><a href="' . $corp->website . '">' . $corp->name . '</a></h2>';
			echo "<p>$corp->description</p>";
		}
		else
			echo "<h2><a href=\"http://$corp\">$corp</a></h2>";
			
		if (count($parts))
		{
?>
	<table>
		<tr>
			<th>Part #</th>
			<th>Quantity</th>
		</tr>
<?
			foreach ($parts AS $part)
			{
				echo "<tr>";
				echo "<td>";
				
				if ($corp->buy_url)
				{
					$url = str_replace("%%PARTID%%", $part->part_id, $corp->buy_url);
						echo '<a href="' . $url . '">' . $part->name . '</a>';
				}
				else if (preg_match("/http:/", $part->part_id))
					echo '<a href="' . $part->part_id . '">' . $part->part_id . "</a>";
				else
					echo $part->part_id;
					
				echo "</td><td>$part->quantity</td></tr>";
			}
			
 			echo "</table>";
		}
		else
			echo "<b>No parts found.</b>";
	}
	
	function renderMouserParts($parts)
	{
?>
<h2><a href="http://www.mouser.com">Mouser Parts</a></h2>
<p>
	Copy and paste the text below into their <a href="http://www.mouser.com/index.cfm?handler=cart._formBOM">BOM Importer tool</a>.  You'll need an account, but you need one anyway to check out.
</p>
<textarea width="100%" rows="<?=count($parts)?>" onfocus="this.select()"><?
	foreach ($parts AS $part)
		echo "$part->part_id $part->quantity\n";
?></textarea>
<?
	}
	
	function renderRsParts($parts)
	{
?>
	<h2><a href="http://www.rswww.com">RS Parts</a></h2>
	<p>
		Go to their website, <b>Ready to order?</b> -> <b>Copy &amp; paste your order</b>.  Then do just that with the text below.
	</p>
	<textarea width="100%" rows="<?=count($parts)?>" onfocus="this.select()"><?
		foreach ($parts AS $part)
			echo "$part->part_id,$part->quantity\n";
	?></textarea>
<?
	}
	
	function renderFarnellParts($parts)
	{
?>
	<h2><a href="http://www.farnellinone.com/">Farnell Parts</a></h2>
	<p>
		Go to their website, <b>Choose country</b> -> <b>Quick Paste</b>.  Then do just that with the text below.
	</p>
	<textarea width="100%" rows="<?=count($parts)?>" onfocus="this.select()"><?
		foreach ($parts AS $part)
			echo "$part->part_id, $part->quantity\n";
	?></textarea>
<?
	}
	
	function renderUnknownParts($parts)
	{
?>
<h2>Parts with No Suppliers</h2>
<table>
	<tr>
		<th>Part</th>
		<th>Quantity</th>
	</tr>
<?
		foreach ($parts AS $part)
			echo "<tr><td>$part->name</td><td>$part->quantity</td></tr/>";
	
		echo "</table>";
	}
?>