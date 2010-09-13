<h1>Suppliers</h1>
<? if (!empty($suppliers)): ?>
	<table width="100%">
		<tr>
			<th width="33%">Name</th>
			<th>Info</th>
		</tr>
		<? foreach ($suppliers AS $row): ?>
			<? $supplier = $row['Supplier'] ?>
			<tr>
				<td><b><a href="<?=$supplier->getViewUrl()?>"><?=$supplier->get('name')?></a></b></td>
				<td><?=$supplier->get('description')?></td>
			</p>
		<? endforeach ?>
		</table>
<? else: ?>
	<b>No suppliers found.</b>
<? endif ?>