<style>
	tr {
		padding: 0px;
		margin: 0px;
	}
	td {
		border: 1px solid black;
		margin: 0px;
		padding: 4px;
	}
</style>

<h1>About the Parts Lister</h1>

<p>
	This website is a front-end for viewing Bill of Material information on the <a href="http://www.reprap.org">RepRap</a> project in an easy to manage, centralized, and database driven fashion.  The master data is stored in <a href="http://docs.google.com">Google Docs</a> to make data entry easy, to take advantage of their excellent UI, as well as author controls.  The code and the data are all licensed under the GPL.
</p>

<h2>Get the data!</h2>
<ul>
	<li><a href="http://spreadsheets.google.com/ccc?key=<?=RR_GOOGLE_DOC_KEY?>">Access the Google Spreadsheet</a></li>
	<li><a href="/reprap-bill-of-materials.sql">Access the imported MySQL data</a></li>
	<li><a href="http://reprap.svn.sourceforge.net/svnroot/reprap/trunk/reprap/web/partlister/">View the Subversion repository</a></li>
	<li>You can also link to a unique part like this: 'http://<?=$_SERVER['HTTP_HOST']?>/uniquepart/My Part Name'</li>
</ul>

<h2>Data Input</h2>

<p>
	The master version of the data is stored in a Google Spreadsheet.  The reason is that Google Spreadsheets provides us with a great interface, easy data export, and solid backups / reliability.  We use their spreadsheet UI to format the data, their CSV publishing option to programmatically access the data, and their always-on nature as being Google for reliability.
</p>

<p>
	In order to be useful in a web context, the data stored on Google must be parsed into something the machine can handle and manipulate.  We have an import script that runs, and imports the spreadsheet into a MySQL database.  For this to work successfully, the data must follow a specific format.  That is detailed below.
</p>

<h3>Suppliers List</h3>

<p>
	The suppliers list simply contains a list of all the suppliers that are referenced later on in the Bill of Materials.  It has a relatively simple format.  The first two lines are for humans, and are ignored.  Following that, each line represents a unique supplier.  Here are the definitions for each field:
</p>

<table>
	<tr>
		<td><b>Name</b></td>
		<td>A free-form name field for the supplier. It should be unique to that supplier.</td>
	</tr>
	<tr>
		<td><b>Prefix</b></td>
		<td>This is used when specifying supplied parts for each unique part.  It should be unique to each supplier, short, and something easy to remember.</td>
	</tr>
	<tr>
		<td><b>Website</b></td>
		<td>This is the url to the main</td>
	</tr>
	<tr>
		<td><b>Description</b></td>
		<td>Free form text description of the supplier.  The more informative, the better.</td>
	</tr>
	<tr>
		<td><b>Countries</b></td>
		<td>A comma separated list of countries that the supplier supplies for.  Not currently used.</td>
	</tr>
	<tr>
		<td><b>Buy Link</b></td>
		<td>
			A string used to generate the URL where a user can buy a part.  When the URL is generated, two strings are replaced with variables:  %%PARTID%% is replaced with the part number, and %%QUANTITY%% is replaced with the quantity to purchase.
		</td>
	</tr>
</table>

<h3>Unique Parts List</h3>

<p>
	The unique parts list contains a list of each type of part used in the project.  Later, in the raw part lists, quantities and associations for the components of each module are listed.  The unique part list holds descriptions, urls, units, suppliers, and other information unique to a part.  The list is grouped by type.  The first two lines are discarded and for humans only.  There are also two lines between each group of parts that are discarded as well.  The rest of the lines each represent a unique part.  Here are the definitions for each field:
</p>

<table>
	<tr>
		<td><b>Name</b></td>
		<td>A free-form name field for the part.  It should be unique to other parts with the same type.  Also, when parts are specified elsewhere, they are matched exactly on the name.  If you change the name here, make sure you change all the names that reference it to the new name.  Otherwise things will break.</td>
	</tr>
	<tr>
		<td><b>Type</b></td>
		<td>This is the type of the part.  Generally you should put a part into an existing type, but if it doesn't fit, then create a new part type.  Certain types (module, assembly, rods, etc.) are used for special things by the software.</td>
	</tr>
	<tr>
		<td><b>Description</b></td>
		<td>Free for text description of the part.  The more informative, the better.</td>
	</tr>
	<tr>
		<td><b>URL</b></td>
		<td>A URL that links to more detailed information on the part.</td>
	</tr>
	<tr>
		<td><b>Unit</b></td>
		<td>What units the part is measured in (g, mm, etc.)</td>
	</tr>
	<tr>
		<td><b>Suppliers</b></td>
		<td>
			Any field after 'Unit' is a supplier field.  You may specify any number of suppliers.  In each thing, you are specifying 3 different things:<br/>
			<b>Supplier</b> - the prefix of the supplier<br/>
			<b>Part #</b> - the part number or id that is used by the supplier.  this is used in URL generation and other various things<br/>
			<b>Quantity</b> - this is an optional field if the item contains multiple units of the part.  for example a pack of bolts.<br/>
			<br/>
			Format: <strong>PREFIX:PARTNUM::QUANTITY</strong><br/>
			Example: <strong>RRRF:123::100</strong><br/>
			Single Quantity Example: <strong>RRRF:12</strong>
		</td>
	</tr>
</table>

<h3>Module Raw Parts Lists</h3>

<p>
	Now that suppliers and parts have been specified, the rest of the sheets fall under the 'raw parts' category.  Basically, every module is broken down into its component parts, part types, and quantities.  You can also specify a part id that is not used and is for easy reference only.  Blank lines are ignored.  Here are the definitions for each field:
</p>

<table>
	<tr>
		<td><b>Part Id</b></td>
		<td>Short text that identifies the part.  Not used for anything.</td>
	</tr>
	<tr>
		<td><b>Name</b></td>
		<td>This name uniquely identifies the unique part required.  It is important to get the name correct (ie. use the exact same name as the unique part).  Also, certain types use a type of formatting in order to let you specify the length.  Rods and Studding are two examples of this.  The format is like this:<br/>
			<Br/>
			Studding: <strong>M5 x 300mm</strong> (meaning a M5 stud, 300mm length)<br/>
			Rods: <strong>8mm x 340mm</strong> (meaning a 8mm diameter rod, 340mm length)<br/>
			Belts: <strong>MXL x 950mm</strong>  (meaning MXL size, 950mm length).<br/>
			<br/>
			As long as the name starts with that format, you can add text in afterwards.  For example:<br/>
			<strong>M8 x 40 (X idler)</strong> will parse correctly.
		</td>
	</tr>
	<tr>
		<td><b>Quantity</b></td>
		<td>
			The quantity field determines how many items are required.  You should input this in the number of units the part is measured in.  If no units are specified, enter the number of items required.
		</td>
	</tr>
	<tr>
		<td><b>Type</b></td>
		<td>
			The type has to match the type specified for the part in the unique part list.  Also, there are two special types:  <strong>module</strong> and <strong>assembly</strong>.<br/>
			<Br/>
			The <strong>module</strong> type references another module list in the system.  When a part list is generated for the parent module, it can also load the part list from the child module specified.<br/>
			<br/>
			The <strong>assembly</strong> type allows you to specify sub-assemblies in the current module.  All the items below the assembly will have their quantity multiplied by the assembly quantity.  An assembly ends when a blank line is encountered.
		</td>
	</tr>
</table>