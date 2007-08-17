<h1><?=$part->get('name')?>, a <a href="/type/<?=$part->get('type')?>"><?=UniquePart::typeToEnglish($part->get('type'))?></a> type part.</h1>

<p>
	<?=$part->get('description')?>
</p>

<? if ($part->get('type') == 'module'): ?>
	<h2>Generate Part List</h2>
	<form action="/uniqueparts" method="post">
		<input type="hidden" name="module_id" value="<?=$part->id?>"/>
		Quantity: <input type="text" name="quantity" value="1" size="3">
		<input type="submit" value="Go"/>
	</form>
<? endif ?>

<? if ($part->get('type') == 'module' || $part->get('type') == 'assembly' || $part->get('type') == 'kit'): ?>
	<h2>Component Parts</h2>
	<? if (!empty($list->type_list)): ?>
		<table width="100%">
			<tr>
				<th>Part</th>
				<th>Type</th>
				<th>Quantity</th>
			</tr>
			<? foreach ($list->type_list AS $type => $data): ?>
				<? foreach ($data AS $unique_id): ?>
					<? $unique = $list->getUnique($unique_id); ?>
					<tr>
						<td><a href="/uniquepart:<?=$unique->id?>"><?=$unique->get('name')?></a>
						</td>
						<td><a href="/type/<?=$type?>"><?=UniquePart::typeToEnglish($type)?></a></td>
						<td><?=$list->getUniqueQuantity($unique->id)?></td>
					</tr>
				<? endforeach ?>
			<? endforeach ?>
		</table>
	<? else: ?>
		<b>No parts found.</b>
	<? endif ?>
<? endif ?>

<h2>Suppliers</h2>
<? if (!empty($suppliers)): ?>
	<? foreach ($suppliers AS $row): ?>
		<p>
			<? $supplier = $row['Supplier'] ?>
			<? $spart = $row['SupplierPart'] ?>
			<b><a href="/supplier:<?=$supplier->id?>"><?=$supplier->get('name')?></a></b>: <?=$spart->get('part_num')?>
			(<a href="<?=$spart->getBuyUrl()?>">buy</a>)
		</p>
	<? endforeach ?>
<? else: ?>
	<b>No suppliers found.</b>
<? endif ?>

<h2>Where is it used?</h2>
<? if (!empty($modules)): ?>
	<? foreach ($modules AS $row): ?>
		<? $part = $row['UniquePart'] ?>
		<? $raw = $row['RawPart'] ?>
		<?
			if (!$part->id):
				$parent = new RawPart($raw->get('parent_id'));
				$part = new UniquePart($parent->get('part_id'));
		?>
			<p>
				<b><a href="/uniquepart:<?=$part->id?>"><?=$part->get('name')?></a></b> (<?=$raw->get('raw_text')?>)
			</p>
		<? else: ?>
			<p>
				<b><a href="/uniquepart:<?=$part->id?>"><?=$part->get('name')?></a></b> <?=$part->get('description')?>
			</p>
		<? endif ?>
	<? endforeach ?>
<? else: ?>
	<b>This part is not used anywhere.</b>
<? endif ?>