<? if ($error): ?>
	<h1>Error:</h1>
	<h3 style="color: red;"><?=$error?></h3>
<? else: ?>
	<h1><?=$part->get('name')?>, a <a href="/type/<?=$part->get('type')?>"><?=UniquePart::typeToEnglish($part->get('type'))?></a> type part.</h1>
	<p>
		<?=$part->get('description')?>
	</p>
	<? if ($part->get('url')): ?>
		<p>
			More information: <a href="<?=$part->get('url')?>"><?=parse_url($part->get('url'), PHP_URL_HOST)?></a>
		</p>
	<? endif ?>

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
							<td><a href="<?=$unique->getViewUrl()?>"><?=$unique->get('name')?></a></td>
							<td><a href="/type/<?=$type?>"><?=UniquePart::typeToEnglish($type)?></a></td>
							<td><?=$list->getUniqueQuantity($unique->id)?> <?=$unique->get('units')?></td>
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
		<table width="100%">
			<tr>
				<th width="33%">Name</th>
				<th>Info</th>
			</tr>
			<? foreach ($suppliers AS $row): ?>
				<? $supplier = $row['Supplier'] ?>
				<? $spart = $row['SupplierPart'] ?>
				<? $url = $spart->getBuyUrl() ?>
				
				<tr>
					<td><b><a href="<?=$supplier->getViewUrl()?>"><?=$supplier->get('name')?></a></b></td>
					<? if ($url): ?>
						<td><a href="<?=$url?>"><?=$spart->get('part_num')?></a></td>
					<? else: ?>
						<td><?=$spart->get('part_num')?></td>
					<? endif ?>
				</tr>
			<? endforeach ?>
		</table>
	<? else: ?>
		<b>No suppliers found.</b>
	<? endif ?>

	<h2>Where is it used?</h2>
	<? if (!empty($modules)): ?>
		<table width="100%">
			<tr>
				<th width="33%">Module</th>
				<th>Subassembly</th>
			</tr>
			<? foreach ($modules AS $row): ?>
				<? $upart = $row['UniquePart'] ?>
				<? $raw = $row['RawPart'] ?>
				<?
					if (!$upart->id):
						$parent = new RawPart($raw->get('parent_id'));
						$upart = new UniquePart($parent->get('part_id'));
				?>
					<tr>
						<td><b><a href="<?=$upart->getViewUrl()?>"><?=$upart->get('name')?></a></b></td>
						<td><?=$raw->get('raw_text')?></td>
					</tr>
				<? else: ?>
					<tr>
						<td><b><a href="<?=$upart->getViewUrl()?>"><?=$upart->get('name')?></a></b></td>
						<td><?=$upart->get('description')?></td>
					</tr>
				<? endif ?>
			<? endforeach ?>
		</table>
	<? else: ?>
		<b>This part is not used anywhere.</b>
	<? endif ?>
	
	<h2>Embed this part list:</h2>
	<textarea style="width: 600px; height: 50px;"><iframe src="<?=$part->getEmbedUrl()?>" width="600" height="500" frameborder="0">Visit <?=$part->getEmbedUrl()?></iframe></textarea>
	
	<h2><a href="http://www.wikidot.com">Wikidot.com</a> embed:</h2>
	<textarea style="width: 600px; height: 50px;">[[iframe <?=$part->getEmbedUrl()?> width="600" height="500" frameborder="0"]]</textarea>
<? endif ?>