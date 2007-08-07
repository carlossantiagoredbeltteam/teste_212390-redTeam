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
					<input type="checkbox" name="deep_lookup" value="1"> Lookup all components for all sub-modules.
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
</form>