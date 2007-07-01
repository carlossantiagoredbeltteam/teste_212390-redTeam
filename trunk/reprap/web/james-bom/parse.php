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

$wget_path = chop(`which wget`); if (!$wget_path){ die ("Can't find wget executable."); }
$cat_path = chop(`which cat`); if (!$cat_path) { die ("Can't find cat executable."); }

function get_bom_data() {
  // Grabs list of Bills of Materials from google spreadsheets, then
  // gets each spreadsheet as csv

  $master_bom = get_csv(8); // retrieve master BOM
  //  echo "$master_bom";
  $pages = explode("\n", $master_bom);
  array_splice($pages, 5,0,array("Universal Controller,3,'Universal controller board on which the stepper and extruder controller boards are based',1"));
  //TODO: compensate for faking the universal controller as module of darwin

  // Which field contains the id of the spreadsheet page we need?
  $fields = parse_csv( $pages[1] );
  $bom_field=-1;
  for ($i=0; $i < sizeof($fields); $i++) {
    if (!strcasecmp($fields[$i], "BOM Id")){$bom_field=$i;}
    if (!strcasecmp($fields[$i], "Module")){$module_field=$i;}
  }
  if ($bom_field==-1) { die("Couldn't find BOM_Id field in master bom spreadsheet."); }
  
  // Get list of modules and their BOM Ids
  for ($p=2; $p < sizeof($pages);$p++) {
    $data = parse_csv($pages[$p]);
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
  $fields = parse_csv($line);
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

  foreach ($f["source"] as $s) {  //iterate over source columns
    if (preg_match("/^R\d+/", $vals[$s])) {
      $db->query("INSERT into source_part (part_id, source_id) VALUES ($part_id, 6)"); // rs electronics
      $success = 1;
    } elseif (preg_match("/^RS:\d+/", $vals[$s])) {
      $db->query("INSERT into source_part (part_id, source_id) VALUES ($part_id, 6)"); // rs electronics
      $success = 1;
    } elseif (preg_match("/^F\d+/", $vals[$s])) {
      $db->query("INSERT into source_part (part_id, source_id) VALUES ($part_id, 7)"); // Farnell
      $success = 1;
    } elseif (preg_match("/http\:\/\/parts\.rrrf\.org/", $vals[$s])) {
      $db->query("INSERT into source_part (part_id, source_id, url) VALUES ($part_id, 2, \"$vals[$s]\")"); // rrrf
      $success = 1;
    } elseif (($f["mouser"] == $s) and ($vals[$s] != NULL)) {
      $db->query("INSERT into source_part (part_id, source_id, vendor_part_id) VALUES ($part_id, 10, \"$vals[$s]\")"); // mouser
      $success = 1;
    } elseif (preg_match("/greenweld\.co\.uk/", $vals[$s])) {
      $db->query("INSERT into source_part (part_id, source_id, url) VALUES ($part_id, 12, \"$vals[$s]\")"); // greenweld
      $success = 1;
    } elseif (preg_match("/farnell.com/", $vals[$s])) {
      $db->query("INSERT into source_part (part_id, source_id, url) VALUES ($part_id, 7, \"$vals[$s]\")"); // Farnell
      $success = 1;
    } elseif (!strcmp("-", $vals[$s])) { //ignore
    } elseif ($vals[$s]) {
      echo "Could not parse supply column $s: $vals[$s]\n";
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
    //echo "New module ($module_id): ".$vals[$f["name"]]."\n";
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
  if (!strcasecmp($vals[$f["type"]], 'rp')) {
    $db->query("INSERT into source_part (part_id, source_id) VALUES ($part_id, 1)"); // reprap
  } elseif (!strcasecmp($vals[$f["type"]], 'assembly')) {
    $db->query("INSERT into source_part (part_id, source_id) VALUES ($part_id, 4)"); // module
  } elseif (!strcasecmp($vals[$f["type"]], 'mold')) {
    $db->query("INSERT into source_part (part_id, source_id) VALUES ($part_id, 5)"); // mold it yourself
  } elseif (!strcasecmp($vals[$f["type"]], 'electronic')) {
    $db->query("INSERT into source_part (part_id, source_id) VALUES ($part_id, 4)"); // electronic
  } elseif (!strcasecmp($vals[$f["type"]], 'fast') || !strcasecmp($vals[$f["type"]], 'rod') || !strcasecmp($vals[$f["type"]], 'stud')) {
    $db->query("INSERT into source_part (part_id, source_id) VALUES ($part_id, 9)"); // mcmaster carr
  } elseif (parse_supplier_columns($vals, $f, $part_id) != -1) {
  } else {
    $db->query("INSERT into source_part (part_id, source_id) VALUES ($part_id, 3)"); // no source
  }

  return $module_id;
}


function parse_spreadsheet($module_name, $lines, $field_str) {
  global $db;

  $fields = parse_fields($lines[1], $field_str, $module_name);
  if (!$fields) { return;}

  $f = discover_field_names($fields);

  $parent_module_id = $db->get_module_id_by_name($module_name);
  $module_id = $parent_module_id;  // just to start out

  for ($i = 2; $i < count($lines); $i++) {
    $vals = parse_csv($lines[$i]);
    if ($vals[$f["name"]] == NULL) { continue; }
    $module_id = parse_name_quantity_type_description ($vals, $f, $parent_module_id, $module_id);
  }
}

////////////////////////////////////////////////////////////////////////

$modules = get_bom_data();
$db = new mydb();

// drop and recreate database to start clean
$db->queries("DROP DATABASE if exists bom;".
             "CREATE DATABASE ".$db->name.";".
             "USE ".$db->name.";");
include ("tables.mysql");          // create tables
include("darwin_initialize.php");  // load the darwin data into the fresh db


// Parse the spreadsheets

while (list($mod, $data) = each($modules)) {
  // process csv

  $lines = explode("\n", $data);

  if (!strcasecmp($mod, "Cartesian Robot")) {        // parse Cartesian Robot
    // Change jig module to a bunch of parts tagged "jig".  They're not really a separate module
    for ($l=0; $l < count($lines); $l++) {
      if (preg_match('/jig/i', $lines[$l])) {
        $jig_line=$l;
        break;
      }
    }
    unset($lines[$jig_line]);
    for ($l=$jig_line; !preg_match('/assembly/i', $lines[$l]) && $l < count($lines); $l++) {
      $lines[$l] = preg_replace('/,(rod)/', ",$1\njig,", $lines[$l]);
      $lines[$l] = preg_replace('/,(rp)/', ",$1\njig,", $lines[$l]);
    }

    parse_spreadsheet($mod, $lines, 'Assembly / Components|Qty|Type|Supplier (F=Farnell, R=RS)');
  } elseif (!strcasecmp($mod, "Thermoplast Extruder")) {      // parse extruder
    parse_spreadsheet($mod, $lines, 'Name|Qty|Type|Description|Part Id|Main Supplier|Alternate Supplier');
  } elseif (!strcasecmp($mod, "Support Material Extruder")) {
    // spreadsheet doesn't exist yet
  } elseif (!strcasecmp($mod, "Universal Controller")) {
    // disambiguate signal connector and connector housing parts
    for ($l=0; $l < count($lines); $l++) {
      if (preg_match('/signal connector/i', $lines[$l]) || preg_match('/connector housing/i', $lines[$l])) {
        if (preg_match('/\d+ pin/', $lines[$l], $matches)) {
          $lines[$l] = $matches[0].' '.$lines[$l];
        }
      }
    }
    
    parse_spreadsheet($mod, $lines, 'Name|Quantity|Type|Description|Item|Mouser|RRRF');
    
    $db->query ("INSERT into module_module (supermodule_id, submodule_id, quantity) ".
                "VALUES (".$db->get_module_id_by_name("Stepper Controller Board").", ".
                $db->get_module_id_by_name("Universal Board Component Kit").", 1);");
    
    $db->query ("INSERT into module_module (supermodule_id, submodule_id, quantity) ".
                "VALUES (".$db->get_module_id_by_name("Extruder Controller Board").", ".
                $db->get_module_id_by_name("Universal Board Component Kit").", 1);");
    
  } elseif (!strcasecmp($mod, "Stepper Controller Board")) {
    $lines[1].=",Mouser";
    unset ($lines[2]);
    parse_spreadsheet($mod, $lines, 'Name|Quantity|Type|Description|Item|Mouser');
  } elseif (!strcasecmp($mod, "Extruder Controller Board")) {
    $lines[1] = preg_replace("/Supplier/i", "Mouser", $lines[1]);
    unset ($lines[2]);
    parse_spreadsheet($mod, $lines, 'Name|Quantity|Type|Description|Item|Mouser');
  } elseif (!strcasecmp($mod, "PowerComms Board")) {
    
    // move the note into the rest of the spreadsheet
    for ($l=0; $l < count($lines); $l++) {
      if (preg_match("/C2-C5/", $lines[$l])) { $c_item = $l; }
      if (preg_match("/U2/", $lines[$l])) { $u_item = $l; }
      if (preg_match("/MAX202/", $lines[$l])) { $note_line = $l; }
    }
    $lines[$c_item].=','.$lines[$note_line];
    $lines[$u_item].=','.$lines[$note_line];
    unset($lines[19]);
    $lines[1].=",Note";
    
    parse_spreadsheet($mod, $lines, 'Name|Quantity|Type|Item|Description|Mouser|RRRF|Note');
    
  } elseif (!strcasecmp($mod, "Opto Endstop Board")) {
    // split spreadsheet in two
    $electrical = array($lines[0]);
    $l=2;
    do {
      array_push($electrical, $lines[$l]);
      $l++;
    } while ($l < count($lines) && !preg_match("/^Mechanical/i", $lines[$l]));
    parse_spreadsheet($mod, $electrical, 'Item|Name / Value|Quantity|Description|Mouser|RRRF|Farnell (For European Reprappers)');
    
    $l++;
    $lines[$l] = preg_replace("/Item/i", "Name", $lines[$l]);
    $mechanical = array($lines[0], $lines[$l++]);
    do {
      array_push($mechanical, $lines[$l]);
      $l++;
    } while ($l < count($lines));
    parse_spreadsheet($mod, $mechanical, 'Name|Quantity|Type');
    
  } elseif (!strcasecmp($mod, "Stepper Tester Board")) {
    
    // remove Mouser BOM
    $BOM_trigger=0;
    for ($l=0; $l < count($lines); $l++) {
      if (preg_match("/BOM Importer/i", $lines[$l])) { $BOM_trigger=1; }
      if ($BOM_trigger) { unset($lines[$l]); }
    }
    
    parse_spreadsheet($mod, $lines, 'Item|Name / Value|Quantity|Description|Mouser|RRRF');
  } elseif (!strcasecmp($mod, "Miscellaneous Kit")) {
    parse_spreadsheet($mod, $lines, 'Name|Quantity|Description');
  } else {
    echo ("Couldn't find a parser for $mod\n");
  }
}

$db->query("UPDATE tag SET name='fastener' WHERE name='fast'");
$db->query("UPDATE module SET url='http://reprap.org/bin/view/Main/WebHome' WHERE id=1");

echo "\n\ndone.\n";
