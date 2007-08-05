<?= Controller::byName('main')->renderView('progressbar', array('step' => 2))?>

<? if (!empty($components)): ?>

	<?//= Controller::byName('main')->renderView('global_suppliers', array('parts' => $components)); ?>

	<form action="/partlist" method="POST" id="bom_form">
		<? foreach ($components AS $type => $data): ?>
			<h2><?=$type?></h2>
			<table width="90%">
				<tr>
					<th>Use?</th>
					<th>Part</th>
					<th>Quantity</th>
					<th>Suppliers</th>
				</tr>
				<? foreach ($data AS $part): ?>
					<tr>
						<td><input type="checkbox" id="use_<?=$part->id?>" name="use_part[<?=$part->id?>]" value="1" checked="true"/>
						<td><?=$part->get('name')?></td>
						<td><input type="quantity[<?=$part->id?>]" value="<?=$part->get('quantity')?>" size="3"></td>
						<td><?= Controller::byName('main')->renderView('part_suppliers', array('part' => $part))?></td>
					</tr>
				<? endforeach ?>
			</table>
		<? endforeach ?>
		<input type="submit" name="submit" value="Generate Bill of Materials"/>
	</form>
<? else: ?>
	<b>No components found!</b>
<? endif?>
