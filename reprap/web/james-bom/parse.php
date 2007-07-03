<?php
/*
Bill Of Materials Parser
Pulls parts list into mysql database for later manipulation.

Part of the RepRap Project.  See reprap.org for details.

Copyright 2007 James Vasile
Released under the latest version of the GNU GPL
See http://www.gnu.org/copyleft/gpl.html for licensing information.

Instructions: put this in ~/public_html/foo.  Edit open_db.php with
your mysql auth info.  Then point your browser at
<http://localhost/~user/foo/parse.php> and hope for the best.

The first time you run this script, it downloads all the spreadsheets
from google.  Thereafter, it just uses the ones on disk.  It has no
way of knowing if the spreadsheets have changed.  If you want to
redownload the spreadsheets, delete files that match /bom_\d+\.csv/.
Be aware that newer copies of the spreadsheet might not parse
correctly (or at all), and that failure will clobber your mysql db.
Backup with mysqldump before attempting or save the old csv files.

You need to be running mysql for this script to work.

This script is just a first hack.  It doesn't even work yet.
Everything is subject to change, including the DB layout.

*/
?>

Parse BOM
Parsing BOM from Google spreadsheets...

<?php include("db.php"); ?>
<?php include("csv.php"); ?>
<?php

//$wget_path = chop(`which wget`); if (!$wget_path){ die ("Can't find wget executable."); }
//$cat_path = chop(`which cat`); if (!$cat_path) { die ("Can't find cat executable."); }

function get_bom_data() {

  // Grabs list of Bills of Materials from google spreadsheets, then
  // gets each spreadsheet as csv

  echo "Getting BOM data from Google or cache.\n";

  $pages = get_csv(8); // retrieve master BOM

  //  $pages[count($pages)] = array(array("Universal Controller","3",'Universal controller board on which the stepper and extruder controller boards are based',"1"));
  array_splice($pages, 8,0,array(array("Universal Controller","3",'Universal controller board on which the stepper and extruder controller boards are based',"1")));

  // Which field contains the id of the spreadsheet page we need?
  //  $fields = parse_csv( $pages[1] );
  $fields = $pages[1];
  $bom_field=-1;
  for ($i=0; $i < sizeof($fields); $i++) {
    if (!strcasecmp($fields[$i], "BOM Id")){$bom_field=$i;}
    if (!strcasecmp($fields[$i], "Module")){$module_field=$i;}
  }
  if ($bom_field==-1) { die("Couldn't find BOM_Id field in master bom spreadsheet."); }

  // Get list of modules and their BOM Ids
  for ($p=2; $p < sizeof($pages);$p++) {
    $data = $pages[$p];
    $modules[ $data[$module_field] ] = $data[$bom_field];
  }
  
  // Get all the spreadsheet pages
  while (list($mod, $id) = each($modules)) {
    $csv[$mod] = get_csv($id);
  }

  return $csv;
}

////////////////////////////////////////////////////////////////////////
/// PARSING

function discover_field_names ($fields) {
  // returns a hash telling us which field has which info
  $f["source"] = array();
  for ($i=0; $i < sizeof($fields); $i++) {
    if (!strcasecmp($fields[$i], "Assembly / Components")) { $f["name"] = $i; }
    if (!strcasecmp($fields[$i], "Name")) { $f["name"] = $i; }
    if (!strcasecmp($fields[$i], "Name / Value")) { $f["name"] = $i; }
    if (!strcasecmp($fields[$i], "Note")) { $f["note"] = $i; }
    if (!strcasecmp($fields[$i], "Notes")) { $f["note"] = $i; }
    if (!strcasecmp($fields[$i], "Qty")) { $f["quantity"] = $i; }
    if (!strcasecmp($fields[$i], "quantity")) { $f["quantity"] = $i; }
    if (!strcasecmp($fields[$i], "type")) { $f["type"] = $i; }
    if (!strcasecmp($fields[$i], "item")) { $f["item"] = $i; }
    if (!strcasecmp($fields[$i], "description")) { $f["description"] = $i; }
    if (!strcasecmp($fields[$i], "item")) { $f["schematic"] = $i; }
    if (!strcasecmp($fields[$i], "part id")) { $f["schematic"] = $i; }
    if (!strcasecmp($fields[$i], "mouser")) { $f["mouser"] = $i;  array_push($f["source"], $i); }
    if (!strcasecmp($fields[$i], "rrrf")) { array_push($f["source"], $i); }
    if (!strcasecmp($fields[$i], "Farnell (For European Reprappers)")) { array_push($f["source"], $i); }
    if (preg_match("/supplier/i", $fields[$i])) { array_push($f["source"], $i); }
  }

  return $f;
}

function parse_fields ($line, $field_str='', $module_name='') {
  $fields = $line;
  if (strcasecmp($field_str, join("|", $fields))) {
        echo ("$module_name fields have changed to:\n".join("|", $fields)."\n\nSkipping parsing\n");
        return NULL;
  }
  return $fields;
}

function parse_supplier_columns($vals, $f, $part_id) {
  // returns -1 if there's nothing in the supplier columns
  // otherwise, returns 1
  global $db;

  $success = -1;

  $sid = $db->get_source_abbreviation_id_hash();

  for ($s=$f["source"][0]; $s<count($vals); $s++) {  //iterate over source columns
    if (preg_match('/:/', $vals[$s])) {
      list($code, $id) = explode(':', $vals[$s], 2);
      if (!strcasecmp($code, 'http')) {
        if (preg_match("/sculpt\.com/", $vals[$s])) {
          $db->query("INSERT into source_part (part_id, source_id, url) VALUES ($part_id, ".$sid['Sculpt'].", \"$vals[$s]\")"); // Farnell
          $success = 1;
        } else {
          echo "Don't know how to parse url source: $vals[$s].\n";
        }
      } else {
        $q = $db->query("SELECT id FROM source WHERE abbreviation=\"$code\"");
        $row = $q->fetchRow();
        if ($row['id']) {
          $q = $db->query("SELECT source_id, part_id FROM source_part where source_id=".$row['id']." AND part_id=$part_id");
          if (!$q->fetchRow()) { $db->query("INSERT into source_part (part_id, source_id, vendor_part_id) VALUES ($part_id, ".$row['id'].", \"$id\")"); }
          $success = 1;
        } else {
          echo "Unknown source abbreviation: $code in $vals[$s]\n";
        }
      }
    } else {
      if ($val[$s]) {
        echo "Malformed source: $vals[$s]\n";
      }
    }
  }
  return $success;
}

function set_module_part ($quantity, $part_id, $module_id=0, $description='', $schematic='') {
  global $db;

  // write a line in the db for each module part
  $description = preg_replace("/\"/", '\"', $description);
  $schematic = preg_replace("/\"/", '\"', $schematic);
  if (!strcmp($schematic, '-')) { $schematic = NULL; }
  $db->query("INSERT into module_part (part_id, module_id, description, schematic, quantity) VALUES ($part_id, $module_id,\"$description\", \"$schematic\", $quantity)");
}

function parse_name_quantity_type_description ($vals, $f, $parent_module_id=0, $module_id=0) {
  global $db;

  if (preg_match("/assembly/i", $vals[$f["type"]])) {
    $module_id = $db->create_module($vals[$f["name"]], $parent_module_id, $vals[$f["quantity"]], $vals[$f["note"]]);
    $db->tag_module($module_id, $vals[$f["type"]]);
    // echo "New module ($module_id): ".$vals[$f["name"]]."\n";
    return $module_id;
  }

  // It's a part
  $part_id = $db->get_part_id_by_name($vals[$f["name"]]);
  if ($part_id == -1) {
    $part_id = $db->create_part($vals[$f["name"]], $vals[$f["description"]]);
    $tags = explode("\n", $vals[$f["type"]]);
    if (count($tags)) {
      foreach ($tags as $tag) {
        $db->tag_part($part_id, $tag);
      }
    }
  }

  // Module_Part
  set_module_part($vals[$f["quantity"]], $part_id, $module_id, $vals[$f["description"]], $vals[$f["schematic"]], $vals[$f["note"]]);
  
  // Source
  parse_supplier_columns($vals, $f, $part_id);

  return $module_id;
}


function parse_spreadsheet($module_name, $lines, $field_str, $parent_module_id=1) {
  global $db;

  $fields = parse_fields($lines[1], $field_str, $module_name);
   if (!$fields) { return; }

  $f = discover_field_names($fields);
  //  var_dump ($f); exit;

  $module_id = $parent_module_id;  // just to start out

  for ($i = 2; $i < count($lines); $i++) {
    $vals = $lines[$i];
    if ($vals[$f["name"]] == NULL) { continue; }
    $module_id = parse_name_quantity_type_description ($vals, $f, $parent_module_id, $module_id);
  }
}

function dump_spreadsheet($sheet) {
  foreach ($sheet as $row) {
    if ($row) {
      foreach ($row as $cell) {
        echo "$cell\t";
      }
      echo "\n";
    }
  }
}
function dump_spreadsheets($sheets) {
  foreach ($sheets as $sheet)  {
    if ($sheet) {
      dump_spreadsheet($sheet);
    }
  }
}

////////////////////////////////////////////////////////////////////////

$suppliers = get_csv(12); //TODO parse suppliers

$modules = get_bom_data(); // get the modules as an array of arrays of rows of cells
//dump_spreadsheets(&$modules);

$db = new mydb( array('no_use_db' => 1));
// drop and recreate database to start clean
$db->queries("DROP DATABASE if exists bom;".
             "CREATE DATABASE ".$db->db_name.";".
             "USE ".$db->db_name.";");
include ("tables.mysql");          // create tables
$darwin_module_id = $db->create_model("Darwin");
$darwin_module_id = $darwin_module_id['module_id'];

include("darwin_initialize.php");  // load the darwin data into the fresh db

// Parse the spreadsheets

while (list($mod, $lines) = each($modules)) {
  switch ($mod) {
  case "Cartesian Robot v1.0":  // parse Cartesian Robot
    echo "Parsing Cartesion Robot\n";

    $module_id = $db->create_module("Cartesian Robot v1.0", $darwin_module_id);
    
    // Change jig module to a bunch of parts tagged "jig".  Jigs are not really a separate module
    for ($l=2; $l < count($lines); $l++) {
      if (preg_match('/jig/i', $lines[$l][1])) {
        $jig_line=$l;
        break;
      }
    }
    unset($lines[$jig_line]);
    for ($l=$jig_line; !preg_match('/assembly/i', $lines[$l][3]) && $l < count($lines); $l++) {
      $lines[$l][3] .= "\njig";
      if (!$lines[$l][4]) { $lines[$l][4] = "This jig is used for lining up and measuring other pieces during assembly."; }
    }
    
    parse_spreadsheet($mod, $lines, 'Part Id|Name|Quantity|Type|Description|Suppliers', $module_id);
    break;
  
  case "Thermoplast Extruder v1.0":      // parse extruder
    echo "Parsing extruder.\n";
    $module_id = $db->create_module("Thermoplast Extruder v1.0", $darwin_module_id);
    parse_spreadsheet($mod, $lines, 'Part Id|Name|Quantity|Type|Description|Suppliers', $module_id);
    break;

  case "Support Extruder Controller Board v1.2":
    echo "Parsing Support Extruder Controller Board\n";
    $module_id = $db->create_module("Support Extruder Controller Board v1.2", $darwin_module_id);
    parse_spreadsheet($mod, $lines, 'Part Id|Name|Quantity|Type|Description|Suppliers', $module_id);
    break;

  case "Support Material Extruder v1.0":
    echo "Parsing Support Material Extruder v1.0\n";
    $module_id = $db->create_module("Support Material Extruder", $darwin_module_id);
    parse_spreadsheet($mod, $lines, 'Part Id|Name|Quantity|Type|Description|Suppliers', $module_id);
    break;

  case "Universal Controller":
    echo "Parsing Universal Controller\n";
    $module_id = $db->create_module("Universal Controller",  $thermoplast_controller_id);
    parse_spreadsheet($mod, $lines, 'Part Id|Name|Quantity|Type|Description|Suppliers', $module_id);
    
    $db->query ("INSERT into module_module (supermodule_id, submodule_id, quantity) ".
                "VALUES ($stepper_controller_id, $module_id, 1);");
    break;

  case  "Stepper Controller Board v1.2":
    echo "Parsing Stepper Controller\n";
    $stepper_controller_id = $db->create_module("Stepper Controller Board v1.2", $darwin_module_id, 3);
    parse_spreadsheet($mod, $lines, 'Part Id|Name|Quantity|Type|Description|Suppliers', $stepper_controller_id);
    break;

  case "Thermoplast Extruder Controller Board v1.2":
    echo "Parsing extruder\n";
    $thermoplast_controller_id = $db->create_module("Thermoplast Extruder Controller Board v1.2", $darwin_module_id);
    parse_spreadsheet($mod, $lines, 'Part Id|Name|Quantity|Type|Description|Suppliers',  $thermoplast_controller_id);
    break;

  case  "PowerComms Board v1.2":
    echo "Parsing PowerComms board\n";
    $module_id = $db->create_module("PowerComms Board v1.2", $darwin_module_id);
    parse_spreadsheet($mod, $lines, 'Part Id|Name|Quantity|Type|Description|Suppliers', $module_id);
    break;

  case "Opto Endstop Board v1.0":
    echo "Parsing Opto Endstop Board\n";
    $module_id = $db->create_module("Opto Endstop Board v1.0", $darwin_module_id, 3);
    parse_spreadsheet($mod, $lines, 'Part Id|Name|Quantity|Type|Description|Suppliers', $module_id);
    break;

  case  "Stepper Tester Board v1.0";
    echo "Parsing Stepper Tester Board\n";
    $module_id = $db->create_module("Stepper Tester Board v1.0", $darwin_module_id);
    parse_spreadsheet($mod, $lines, 'Item|Name / Value|Quantity|Type|Description|Suppliers', $module_id);
    break;

  case "Miscellaneous Kit":
    echo "Parsing miscellaneous kit\n";
    parse_spreadsheet($mod, $lines, 'Id|Name|Quantity|Type|Description|Suppliers', $module_id);
    break;

  default:
    echo ("Couldn't find a parser for $mod\n");
  }
}

$db->query("UPDATE tag SET name='fastener' WHERE name='fast'");
$db->query("UPDATE module SET url='http://reprap.org/bin/view/Main/WebHome' WHERE name=\"Darwin\"");

function set_vendor_part_id_by_part_name($part_name, $vendor_part_id) {
  // adjusts source_part, creates if needed

  global $db;

  $part_id = $db->get_part_id_by_name($part_name);
  if ($part_id == 1) {
    echo "Can't set vendor part id to $vendor_part_id for $part_name.\n";
  } else {
    $source_id = $db->get_source_id_by_name("McMaster");
    $q = $db->query("SELECT id FROM source_part WHERE part_id=$part_id and source_id=$source_id");
    $row = $q->fetchRow();
    if ($row['id']) {
      $db->query("UPDATE source_part SET vendor_part_id='$vendor_part_id' WHERE id=".$row['id']);
    } else {
      $db->query("INSERT into source_part (part_id, source_id, vendor_part_id) VALUES ($part_id, $source_id, \"$vendor_part_id\")");
    }      
  }
}

set_vendor_part_id_by_part_name('M3 nut', '90591A121');
set_vendor_part_id_by_part_name('M3 washer', '91166A210');
set_vendor_part_id_by_part_name('M3 x 15 cap', '91290A120');
set_vendor_part_id_by_part_name('M3 x 25 cap', '91290A125');
set_vendor_part_id_by_part_name('M3 x 30 cap', '91290A130');
set_vendor_part_id_by_part_name('M3 x 35 cap', '91292A033 ');

echo "\n\ndone.\n";
