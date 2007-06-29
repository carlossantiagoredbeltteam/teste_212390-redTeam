<?php
/*
Bill Of Materials Viewer
Pulls parts list into mysql database for later manipulation.

Part of the RepRap Project.  See reprap.org for details.

Copyright 2007 James Vasile
Released under the latest version of the GNU GPL
See http://www.gnu.org/copyleft/gpl.html for licensing information.
*/
?>

<html><head><title>BOM Viewer</title></head><body>

<?php

function get_top_modules_for_model ($model_id) {
  // returns the largest modules in a model, the ones that are assemblies / submodules of the model itself

  $q = query("SELECT md.name, mm.submodule_id, mm.quantity, mm.notes ".
             "FROM model m, module_module mm, module md ".
             "WHERE m.module_id=mm.supermodule_id and m.id=1 and md.id=mm.submodule_id;");

  $l=0;
  while ($r[$l] = $q->fetchRow()) {

   echo $r[$l][0];
  }
  return $r;
}

require_once("db.php");
require_once("open_db.php");
require_once("bom_objects.php");
query("use bom");

// TODO: get list of models and pick one
$Model = new Model (array ( 'name' => 'Darwin',
                            'id' => 1,
                            'populate_models' => 1,
                            ));

echo '<h2>'.$Model->name.'</h2>';
foreach ($Model->module as $m) {
  echo '<li>'.$m->name.'</li>';
}

exit;
$top_modules = get_top_modules_for_model($Model->id);
   echo "<p>!".$top_modules;
echo '<h2>Modules Used in this Model</h2>';
for ($m=0; $m < count($top_modules); $m++) {
  echo '<li>';
  for ($f=0; $f < 4; $f++) {
    echo $top_modules[$m][$f];
  }
  echo '</li>';
}

?></body></html>