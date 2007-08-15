<?= Controller::byName('main')->renderView('progressbar', array('step' => 2))?>

<? if (!empty($list->uniques)): ?>

	<?//= Controller::byName('main')->renderView('global_suppliers', array('parts' => $components)); ?>

	<form action="/partlist" method="POST" id="bom_form">
		<input type="hidden" name="module_id" value="<?=$module->id?>" />
		<table width="100%">
			<tr>
				<th>Part</th>
				<th>Type</th>
				<th>Quantity</th>
				<th>Suppliers</th>
			</tr>
			<? foreach ($list->type_list AS $type => $data): ?>
				<? foreach ($data AS $unique_id): ?>
					<? $unique = $list->getUnique($unique_id); ?>
					<? $quantity = $list->getUniqueQuantity($unique->id); ?>
					<? if ($quantity): ?>
						<tr>
							<td>
								<input type="checkbox" id="use_<?=$unique->id?>" name="use_part[<?=$unique->id?>]" value="1" checked="true"/>
								<a href="/uniquepart:<?=$unique->id?>"><?=$unique->get('name')?></a>
						
								<span onclick="Element.toggle('breakdown_<?=$unique->id?>')">(breakdown)</span>
							</td>
							<td><a href="/type/<?=$type?>"><?=$type?></a></td>
							<td>
								<input type="text" name="quantity[<?=$unique->id?>]" value="<?=$quantity?>" size="3">
								<?= $unique->get('units') ?>
							</td>
							<td><?= Controller::byName('main')->renderView('part_suppliers', array('part' => $unique))?></td>
						</tr>
						<tr id="breakdown_<?=$unique->id?>" style="display: none;">
							<td colspan="4">
								<div style="margin-left: 20px">
									<table>
										<tr>
											<td><b>Part</b></td>
											<td><b>Quantity</b></td>
										</tr>
										<? foreach ($list->raw_list[$unique->id] AS $part): ?>
											<tr>
												<td><?=$part->get('raw_text')?></td>
												<td><?=$part->get('quantity')?></td>
											</tr>
										<? endforeach ?>
									</table>
								</div>
							</td>
						</tr>
					<? endif ?>
				<? endforeach ?>
			<? endforeach ?>
		</table>
		<input type="submit" name="submit" value="Generate Bill of Materials"/>
	</form>
<? else: ?>
	<b>No components found!</b>
<? endif?>
