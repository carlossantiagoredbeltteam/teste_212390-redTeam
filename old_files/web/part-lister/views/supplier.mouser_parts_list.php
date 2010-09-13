<p>
	Copy and paste the text below into their <a href="http://www.mouser.com/BOM/BOM.aspx">BOM Importer tool</a>.  You'll need to register a Mouser account, but you need one anyway to check out.
</p>
<textarea width="100%" rows="<?=count($parts)?>" onfocus="this.select()"><? 
	foreach ($parts AS $part)
		echo $part->get('part_num') . " " . $part->orderQuantity() . "\n";
?></textarea>

<h4>Human Readable List:</h4>
<?
	echo Controller::byName('supplier')->renderView('generic_parts_list', array(
		'supplier' => $supplier,
		'parts' => $parts
	));
?>