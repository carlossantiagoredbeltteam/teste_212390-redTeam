<? if ($error): ?>
	<h1>Error:</h1>
	<h3 style="color: red"><?=$error?></h3>
<? else: ?>
	<script type="text/javascript">
		function generateShoppingList()
		{
			$('shopping_list').innerHTML = 'Loading...';

			var params = Form.serialize($('bom_form'));
			new Ajax.Updater('shopping_list', '/partlist', {
				parameters: params,
				method: 'post'
			});
		}
	
		function toggleBreakdown(id)
		{
			Element.toggle('breakdown_' + id);
			Element.toggle('plus_' + id);
			Element.toggle('minus_' + id);
		}
	</script>
	<? if ($module): ?>
		<h1><a href="<?=$module->getViewUrl()?>"><?=$module->get('name')?></a> - <?=date("M j, Y")?></h1>
	<? else: ?>
		<h1>Custom Part List - <?=date("M j, Y")?></h1>
		<table>
			<tr>
				<td colspan="2"><b>Modules used:</b></td>
			</tr>
			<? foreach ($modules AS $module): ?>
				<tr>
					<td><b><a href="<?=$module->getViewUrl()?>"><?=$module->get('name')?></a></b></td>
					<td>x <?=$quantities[$module->id]?></td>
				</tr>
			<? endforeach ?>
		</table>
		<br/>
	<? endif ?>
	<em>
		<strong>Note:</strong> This list is reasonably accurate, but it is not guaranteed.  Please review it before you buy anything.<br/>
		If you do happen to find an error, please report it in the <a href="http://forums.reprap.org">forums</a>.
	</em>
	<br/>
	<br/>
	<? if (!empty($list->uniques)): ?>

		<?= Controller::byName('main')->renderView('global_suppliers', array('suppliers' => $list->getSupplierList())); ?>

		<form onsubmit="return false;" method="POST" id="bom_form">
			<input type="hidden" name="module_id" value="<?=$module->id?>" />
			<table width="100%">
				<? foreach ($list->type_list AS $type => $data): ?>
					<? $data = $list->getTypeList($type)->getAll(); ?>
					<? foreach ($data AS $row): ?>
						<? $unique = $row['UniquePart']; ?>
						<? $quantity = $list->getUniqueQuantity($unique->id); ?>
						<? $type = $unique->get('type'); ?>
						<? if ($unique->get('type') != $old_type): ?>
							<tr>
								<td colspan="3">
									<br/>
									<span style="font-size: 23px; margin: 15 0 5 0"><?=UniquePart::typeToEnglish($type)?></a></span>
									<a href="/type/<?=$type?>">view all</a>
								</td>
							</tr>
						<? endif ?>
						<? $old_type = $type; ?>
						<? if ($quantity): ?>
							<tr>
								<td>
									<img src="/img/plus-icon.gif" id="plus_<?=$unique->id?>" onclick="toggleBreakdown(<?=$unique->id?>)" style="cursor: pointer;"/>
									<img src="/img/minus-icon.gif" id="minus_<?=$unique->id?>" onclick="toggleBreakdown(<?=$unique->id?>)" style="cursor: pointer; display: none"/>
									<input type="checkbox" id="use_<?=$unique->id?>" name="use_part[<?=$unique->id?>]" value="1" checked="true"/>
									<a href="<?=$unique->getViewUrl()?>"><?=$unique->get('name')?></a>
									<img src="/img/help-icon.gif" onclick="Element.toggle('tooltip_<?=$unique->id?>')" style="cursor: pointer;">
									<? if ($unique->get('url')): ?>
										<a href="<?=$unique->get('url')?>" target="_blank"><img src="/img/url-icon.gif" border="0"></a>
									<? endif ?>
									<div id="tooltip_<?=$unique->id?>" class="tooltip" style="display: none; margin-left: 20px; font-size: 90%;"><?=$unique->get('description')?></div>
								</td>
								<td>
									<input type="text" name="quantity[<?=$unique->id?>]" value="<?=$quantity?>" size="3">
									<?= $unique->get('units') ?>
								</td>
								<td><?= Controller::byName('main')->renderView('part_suppliers', array('part' => $unique))?></td>
							</tr>
							<tr id="breakdown_<?=$unique->id?>" class="breakdown" style="display: none;">
								<td colspan="4">
									<div style="margin-left: 20px">
										<table>
											<tr>
												<td><b>Part</b></td>
												<td><b>Quantity</b></td>
											</tr>
											<? $raws = array(); ?>
											<? foreach ($list->raw_list[$unique->id] AS $part): ?>
												<?
													$parent = new RawPart($part->get('parent_id'));
													if ($parent->get('type') == 'assembly')
													{
														$assembly = $parent;
														$parent = new RawPart($assembly->get('parent_id'));
													}
													else
													{
														$grandparent = new RawPart($parent->get('parent_id'));
														$assembly = false;
													}
												?>
												<tr>
													<td><?=$part->get('raw_text')?> <span style="font-size: 90%">(from 
														<? $unique_parent = new UniquePart($parent->get('part_id')); ?>
														<? if ($assembly instanceOf RawPart): ?>
															<a href="<?=$unique_parent->getViewUrl()?>"><?=$parent->get('raw_text')?></a> / <?=$assembly->get('raw_text')?>)</span>
														<? else: ?>
															<a href="<?=$unique_parent->getViewUrl()?>"><?=$parent->get('raw_text')?></a>)</span>
														<? endif ?>
													</td>
													<td><?=$part->get('quantity')?> <?= $unique->get('units') ?></td>
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
			<br/>
			<input type="button" style="font-size: 22px" value="Generate Shopping List" onclick="generateShoppingList()"/>
		</form>
		<br/>
	
		<div id="shopping_list"></div>
	<? else: ?>
		<b>No components found!</b>
	<? endif?>
<? endif ?>