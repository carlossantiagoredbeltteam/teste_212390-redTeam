<p>
	Copy and paste the text below into their <a href="http://www.mouser.com/index.cfm?handler=cart._formBOM">BOM Importer tool</a>.  You'll need an account, but you need one anyway to check out.
</p>
<textarea width="100%" rows="<?=count($parts)?>" onfocus="this.select()"><? 
	foreach ($parts AS $part)
		echo $part->get('part_num') . " " . $part->orderQuantity() . "\n";
?></textarea>