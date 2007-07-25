<?
	require_once("include/global.php");
	drawHeader("Importing Bill of Materials");
	
	error_reporting(E_ALL);
	
	//create our structure.
	$sql = file_get_contents("sql/structure.sql");
	//DB::execute($sql);
	
	//perhaps load a 'legend sheet' that tells us what id's each sheet has?
	
	//load our suppliers
	
	//load our unique parts, as well as supplier parts
	
	//load our raw part lists
	
?>
	<p>
		Created Database Structure (<a href="#" onclick="Element.toggle('create_sql'); return false;">SQL</a>)
		<pre class="sql" id="create_sql" style="display: none; margin: 0px; padding: 0px;"><?=$sql?></pre>
	</p>

	<p>Loaded Bill of Materials from Google Spreadsheet: 
		<a href="http://spreadsheets.google.com/ccc?key=<?=RR_GOOGLE_DOC_KEY?>"><?=RR_PROJECT_NAME?></a>
	</p>
<?
	drawFooter();
?>