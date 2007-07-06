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

  array_splice($pages, 8,0,array(array("Universal Controller","3",'Universal controller board on which the stepper and extruder controller boards are based',"1")));

  unset($pages[1]);
  unset($pages[0]);

  for ($p=0; $p < count($pages); $p++) {
    $out[$p]['name'] = $pages[$p][0];
    $out[$p]['quantity'] = $pages[$p][1];
    $out[$p]['description'] = $pages[$p][2];
    $out[$p]['id'] = $pages[$p][3];
  }
  return $out;
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
        } elseif (preg_match("/greenweld.co.uk/", $vals[$s])) {
          $db->query("INSERT into source_part (part_id, source_id, url) VALUES ($part_id, ".$sid['GH'].", \"$vals[$s]\")"); // Farnell
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
    //   echo "New module ($module_id): ".$vals[$f["name"]]."\n";
    $db->tag_module($module_id, $vals[$f["type"]]);
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

function parse_suppliers_csv($csv) {
  global $db;
  //Name,Prefix,Website,Description,Countries,Buy Link

  array_shift($csv);
  array_shift($csv);

  foreach ($csv as $row) {
    $part_url=preg_replace('/%%PARTID%%\/*$/','',$row[5]);
    $region = $row[4];

    switch ($region) {
    case 'all':
      $region=0;
      break;
    case 'usa':
      $region=1;
      break;
    case 'europe':
      $region=4;
      break;
    case 'oceania':
      $region=5;
      break;
    }

    $db->create_source(array('name' => $row[0], 
                        'abbreviation' => $row[1],
                        'url' => $row[2],
                        'description' => $row[3],
                        'region' => $region,
                        'part_url_prefix' => $part_url
                        ));
  }


}
////////////////////////////////////////////////////////////////////////

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

$suppliers = get_csv(12); //TODO parse suppliers
parse_suppliers_csv($suppliers);

parse($modules);

$db->query("UPDATE tag SET name='fastener' WHERE name='fast'");
$db->query("UPDATE module SET url='http://reprap.org/bin/view/Main/WebHome' WHERE name=\"Darwin\"");

function parse($modules) {
  global $darwin_module_id;
  global $db;
  // Parse the spreadsheets

  // Fetch all the spreadsheet pages
  foreach ($modules as $row) {
    if (!$row['name'] || !strcmp('Incomplete', $row['name'])) { continue; }

    $lines = get_csv($row['id']);
    echo "Parsing ".$row['name']."\n";

    $row['parent_id'] = $darwin_module_id;

    $mod = $row['name'];

    if (strcmp($mod, "Universal Controller")) {
      $module_id = $db->create_module($mod, $darwin_module_id, $row['quantity'], $row['description']);
    }

    //    parse_module($row);
    switch ($mod) {

    case "Cartesian Robot v1.0":  // parse Cartesian Robot
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
      
    case  "PowerComms Board v1.2":
    case "Thermoplast Extruder v1.0":  
    case "Support Material Extruder v1.0":
    case "Opto Endstop Board v1.0":
      parse_spreadsheet($mod, $lines, 'Part Id|Name|Quantity|Type|Description|Suppliers', $module_id);
      break;
      
    case "Thermoplast Extruder Controller Board v1.2":
    case "Support Extruder Controller Board v1.2":
    case "Stepper Controller Board v1.2":
      $universal_parent[count($universal_parent)] = $module_id;
      parse_spreadsheet($mod, $lines, 'Part Id|Name|Quantity|Type|Description|Suppliers', $module_id);
      break;
      
    case "Universal Controller":
      $module_id = $db->create_module($mod,  $universal_parent[0]);
      parse_spreadsheet($mod, $lines, 'Part Id|Name|Quantity|Type|Description|Suppliers', $module_id);
      
      for ($l=1; $l < count($universal_parent); $l++) {
        $db->query ("INSERT into module_module (supermodule_id, submodule_id, quantity) VALUES (".$universal_parent[$l].", $module_id, 1);");
      }
      break;
      
      
    case  "Stepper Tester Board v1.0":
      parse_spreadsheet($mod, $lines, 'Item|Name / Value|Quantity|Type|Description|Suppliers', $module_id);
      break;
      
    case "Miscellaneous Kit":
    case "Pulley Mold Kit":
      parse_spreadsheet($mod, $lines, 'Id|Name|Quantity|Type|Description|Suppliers', $module_id);
      break;
      
    default:
      echo ("Couldn't find a parser for $mod\n");
    }
  }
}


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

/*set_vendor_part_id_by_part_name('M3 nut', '90591A121');
set_vendor_part_id_by_part_name('M3 washer', '91166A210');
set_vendor_part_id_by_part_name('M3 x 15 cap', '91290A120');
set_vendor_part_id_by_part_name('M3 x 25 cap', '91290A125');
set_vendor_part_id_by_part_name('M3 x 30 cap', '91290A130');
*/
set_vendor_part_id_by_part_name('M3 x 35 cap', '91292A033 ');

echo "\ndone.\n";
