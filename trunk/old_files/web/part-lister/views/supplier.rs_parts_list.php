<p>
	Go to their website, <b>Ready to order?</b> -> <b>Copy &amp; paste your order</b>.  Then do just that with the text below.
</p>
<textarea width="100%" rows="<?=count($parts)?>" onfocus="this.select()"><?
	foreach ($parts AS $part)
		echo $part->get('part_num') . "," . $part->orderQuantity() . "\n";
?></textarea>

<h4>Human Readable List:</h4>
<?
	echo Controller::byName('supplier')->renderView('generic_parts_list', array(
		'supplier' => $supplier,
		'parts' => $parts
	));
?>