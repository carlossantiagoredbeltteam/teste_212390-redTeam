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
			<td><a href="/type/<?=$row['type']?>"><?=$row['type']?></a></td>
			<td align="right"><?=$row['cnt']?></td>
			<td align="right"><?=number_format(($row['cnt']/$unique_part_count) * 100, 2)?>%
		</tr>
	<? endforeach ?>
	<tr>
		<td><b>Total:</b></td>
		<td align="right"><b><?=$unique_part_count?></b></td>
</table>