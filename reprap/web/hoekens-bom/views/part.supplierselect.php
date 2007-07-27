<?
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
?>