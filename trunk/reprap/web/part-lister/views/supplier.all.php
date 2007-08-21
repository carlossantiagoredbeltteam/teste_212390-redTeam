<h1>Suppliers</h1>
<? if (!empty($suppliers)): ?>
	<? foreach ($suppliers AS $row): ?>
		<? $supplier = $row['Supplier'] ?>
		<p>
			<b><a href="<?=$supplier->getViewUrl()?>"><?=$supplier->get('name')?></a></b> <?=$supplier->get('description')?>
		</p>
	<? endforeach ?>
<? else: ?>
	<b>No suppliers found.</b>
<? endif ?>