<h1>Statistics</h1>

<ul>
	<li><?=$supplier_count?> suppliers with <?=$supplier_part_count?> total supplied parts.</li>
	<li><?=$raw_part_count?> total raw part entries in Bill of Materials.</li>
	<li><?=$rough_unique_count?> rough unique parts count.</li>
</ul>

<h2>Unique Parts</h2>
<table>
	<tr>
		<th>Type</th>
		<th>Quantity</th>
		<th>Percentage</th>
	</tr>
	<? foreach ($part_types AS $row): ?>
		<tr>
			<td><a href="/type/<?=$row['type']?>"><?=UniquePart::typeToEnglish($row['type'])?></a></td>
			<td align="right"><?=$row['cnt']?></td>
			<td align="right"><?=number_format(($row['cnt']/$unique_part_count) * 100, 2)?>%
		</tr>
	<? endforeach ?>
	<tr>
		<td><b>Total:</b></td>
		<td align="right"><b><?=$unique_part_count?></b></td>
</table>


<h2>List of parts (sorted by quantity needed)</h2>
<table>
	<tr>
		<th>Part</th>
		<th>Type</th>
		<th>Quantity</th>
		<th>Units</th>
	</tr>
	<? foreach ($unique_quantities AS $id => $qty): ?>
		<? $part = $unique_parts->getUnique($id); ?>
		<tr>
			<td><b><a href="<?=$part->getViewUrl()?>"><?=$part->get('name')?></a></b></td>
			<td><a href="/type/<?=$part->get('type')?>"><?=UniquePart::typeToEnglish($part->get('type'))?></a></td>
			<td align="right"><?=$qty?></td>
			<td><?=$part->get('units')?></td>
		</tr>
	<? endforeach ?>
	
</table>
