<?
	require_once("include/global.php");

	$modules = loadModulesData();
	
	drawHeader("Generate Bill of Materials");
?>
<ul>
	<li><b>Step 1: Choose which assemblies and the quantities of each.</b></li>
	<li>Step 2: Choose which suppliers you'd like to use.</li>
	<li>Step 3: Order your parts!  Super easy.</li>
</ul>
<form action="uniqueparts.php" method='post' name="bom_form">
	<table>
		<tr>
			<th>Module</th>
			<th>Quantity</th>
		</tr>
		<? foreach ($modules AS $key => $module): ?>
			<? if($module[3] >= -1): ?>
				<tr>
					<td><label><input type="checkbox" name="assembly_ids[]" value="<?=$module[3]?>"/> <b><?=$module[0]?></b></label></td>
					<td><input type="text" size="5" name="assembly_qty[<?=$module[3]?>]" value="<?=$module[1]?>"/></td>
				</tr>
				<tr id="module_<?=$key?>" style="display: none">
					<td colspan="2"><?=$module[2]?></td>
				</tr>
			<? endif ?>
		<? endforeach ?>
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
			<td><input type="submit" name="submit" value="Generate BOM"></td>
		</tr>
	</table>
</form>
<? drawFooter() ?>