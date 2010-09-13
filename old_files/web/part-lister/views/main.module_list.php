<? if (!empty ($modules)): ?>
	<h2><?=ucfirst($status)?> Modules</h2>
	<form action="/uniqueparts" method="post">
		<table width="100%">
			<tr>
				<th width="10%">Use?</th>
				<th width="75%">Module</th>
				<th width="15%">Quantity</th>
			</tr>
			<? foreach ($modules AS $row): ?>
				<? $module = $row['UniquePart']; ?>
				<tr class="module_row" id="module_<?=$module->id?>">
					<td align="center">
						<input type="checkbox" id="module_check_<?=$module->id?>" name="use_module[<?=$module->id?>]" value="1" onclick="selectModule(<?=$module->id?>)"/>
					</td>
					<td>
						<input type="hidden" name="module_id[<?=$module->id?>]" value="<?=$module->id?>" />
						<b><a href="<?=$module->getViewUrl()?>"><?=$module->get('name')?></a></b>
						<img src="/img/help-icon.gif" onclick="Element.toggle('description_<?=$module->id?>')">
						<? if ($module->get('url')): ?>
							<a href="<?=$module->get('url')?>" target="_blank"><img src="/img/url-icon.gif" border="0"></a>
						<? endif ?>
					</td>
					<td align="center"><input type="text" name="quantities[<?=$module->id?>]" value="1" size="3"></td>
				</tr>
				<tr id="description_<?=$module->id?>" style="display: none">
					<td>&nbsp;</td>
					<td>
						<?=$module->get('description')?>
					</td>
					<td>&nbsp;</td>
				</tr>
			<? endforeach ?>
			<tr>
				<th>Deep Lookup?</th>
				<td>
					<label>
						<input type="checkbox" name="deep_lookup" value="1" checked="true"> Lookup all components for all sub-modules.
					</label>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><input type="submit" name="submit" value="Next Step" /></td>
			</tr>
		</table>
	</form>
<? endif ?>