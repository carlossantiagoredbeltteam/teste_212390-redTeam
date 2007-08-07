<?= Controller::byName('main')->renderView('progressbar', array('step' => 2))?>

<p>
	Link here: <a href="http://<?=$_SERVER['HTTP_HOST']?>/uniqueparts:<?=$module->id?>"><?=$_SERVER['HTTP_HOST']?>/uniqueparts:<?=$module->id?></a>
</p>

<? if (!empty($components)): ?>

	<?//= Controller::byName('main')->renderView('global_suppliers', array('parts' => $components)); ?>

	<form action="/partlist" method="POST" id="bom_form">
		<h2><?=$type?></h2>
		<table width="100%">
			<tr>
				<th>Part</th>
				<th>Type</th>
				<th>Quantity</th>
				<th>Suppliers</th>
			</tr>
			<? foreach ($components AS $type => $data): ?>
				<? foreach ($data AS $part): ?>
					<tr>
						<td><input type="checkbox" id="use_<?=$part->id?>" name="use_part[<?=$part->id?>]" value="1" checked="true"/> <?=$part->get('name')?></td>
						<td><?=$type?></td>
						<td><input type="quantity[<?=$part->id?>]" value="<?=$part->get('quantity')?>" size="3"></td>
						<td><?= Controller::byName('main')->renderView('part_suppliers', array('part' => $part))?></td>
					</tr>
				<? endforeach ?>
			<? endforeach ?>
		</table>
		<input type="submit" name="submit" value="Generate Bill of Materials"/>
	</form>
<? else: ?>
	<b>No components found!</b>
<? endif?>
