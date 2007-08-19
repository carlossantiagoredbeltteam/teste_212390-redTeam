<script>
	function selectModule(id)
	{
		if ($('module_check_' + id).checked)
			Element.addClassName('module_' + id, 'module_row_selected');
		else
			Element.removeClassName('module_' + id, 'module_row_selected')
	}
</script>
<h1>Quick Part List Lookup</h1>
<?= Controller::byName('main')->renderView('progressbar', array('step' => 1))?>
<form action="/uniqueparts" method="POST" name="bom_form">
	<table>
		<tr>
			<th>Module</th>
			<td>
				<select name="module_id">
					<? foreach ($modules AS $row): ?>
						<? $module = $row['UniquePart']; ?>
						<option value="<?=$module->id?>"><?=$module->get('name')?></option>
					<? endforeach ?>
				</select>
			</td>
		</tr>
		
		<tr>
			<th>Quantity</th>
			<td>
				<input type="text" name="quantity" value="1" size="4">
			</td>
		</tr>
		
		<tr>
			<th>Deep Lookup?</th>
			<td>
				<label>
					<input type="checkbox" name="deep_lookup" value="1" checked="true"> Lookup all components for all sub-modules.
				</label>
			</td>
		</tr>

<!--
		<tr>
			<th>Your Location</th>
			<td>
				<select name="location">
					<option value="usa">USA</option>
					<option value="europe">Europe</option>
					<option value="oceania">Oceania</option>
					<option value="africa">Africa</option>
					<option value="asia">Asia</option>
					<option value="south-america">South America</option>
				</select>
			</td>
		</tr>

		<tr>
			<th>Output</th>
			<td>
				<select name="output">
					<option value="html">HTML</option>
					<option value="csv">CSV</option>
					<option value="json">JSON</option>
				</select>
			</td>
		</tr>
-->		
		<tr>
			<td>&nbsp;</td><td><input type="submit" name="submit" value="Next Step"></td>
		</tr>
	</table>
	
	<h1>Detailed Part List Lookup</h1>
	<form action="/uniqueparts">
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
						<b><a href="/uniquepart:<?=$module->id?>"><?=$module->get('name')?></a></b>
						<img src="/img/help-icon.gif" onclick="Element.toggle('description_<?=$module->id?>')">
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
</form>