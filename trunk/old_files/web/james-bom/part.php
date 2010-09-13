<?php
/*
Bill Of Materials Viewer and Editor

An outgrowth of the RepRap Project.  See reprap.org for details.

Copyright 2007 James Vasile 
Released under Version 1 of the Affero GPL
See LICENSE and <http://www.affero.org/oagpl.html> for details.
*/
?>

<?php

function dump_part($part_id) {
  require_once("view.php");
  // TODO: make it model-specific
  global $db;
  global $model_name;

  $str .= '<table summary="Darwin Bill of Materials organized by part" class="bomT" cellspacing="0">'.

    '<tr><td class="field">'.join("</td><td class=\"field\">", array('Name', 'Modules', 'Description and Notes', 'Tags', 'Suppliers')).'</td></tr>';

  $q = $db->query("SELECT p.id, p.name, m.name, m.id, mp.quantity, p.description, p.notes, p.photo ".
                  "FROM part p, module m, module_part mp WHERE p.id=mp.part_id AND m.id=mp.module_id AND p.id=$part_id ORDER BY p.name");


  $part=array();
  while ($row = $q->fetchRow(MDB2_FETCHMODE_ORDERED)) {
    $part[$row[0]][ count($part[$row[0]]) ] = $row;
  }

  foreach ($part as $p) {
    $quantity = 0;
    $module = '';
    $part_id = $p[0][0];
    $photo = $p[0][7];
    foreach ($p as $m) {
      $module .= $db->make_module_href($m[3],$m[2]).($m[4] != 1 ? " ($m[4])<br />" : '<br />');
      $quantity = $quantity + $m[4];
    }

    $tag = $db->get_part_tags($p[0][0]);
    $supplier = html_source_for_part($part_id);
    $descrip = combine_description_notes($p[0][5], $p[0][6]);

    $str .= '<tr><td>'.
      join('</td><td class="bomBorderLeft">', array($db->make_part_href($part_id,$p[0][1]).($quantity != 1 ? " ($quantity)" : ''), $module, $descrip, $tag, $supplier)).
      "</td></tr>\n";
  }

  $str .= '</table>';

  if ($photo) { $str .= '<p><img src="pic.php?part='.$part_id.'"/></p>'; }

  return array('title' => 'Part Detail for '.$p[0][1], 'body' => $str);
}


function dump_parts_for_model ($model=0) {
  // TODO: make it model-specific
  global $db;
  global $model_name;

  $str .= '<table summary="Darwin Bill of Materials organized by part" class="bomT" cellspacing="0">'.
    '<tr><td class="field">'.join("</td><td class=\"field\">", array('Name', 'Modules', 'Description and Notes', 'Tags', 'Suppliers')).'</td></tr>';

  $q = $db->query("SELECT p.id, p.name, m.name, m.id, mp.quantity, p.description, p.notes ".
                  "FROM part p, module m, module_part mp WHERE p.id=mp.part_id AND m.id=mp.module_id ".
                  "ORDER BY p.name");
  $str .= html_part_rows($q);
  return array('title' => $model_name.' Bill of Materials Organized by Part', 'body' => $str.'</table>');
}
