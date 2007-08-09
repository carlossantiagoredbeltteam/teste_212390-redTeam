<p>
	Go to their website -> <b>Choose country</b> -> <b>Quick Paste</b>.  Then do just that with the text below.
</p>
<textarea width="100%" rows="<?=count($parts)?>" onfocus="this.select()"><?
	foreach ($parts AS $part)
		echo $part->get('part_num') . ", " . $part->get('quantity') . "\n";
?></textarea>