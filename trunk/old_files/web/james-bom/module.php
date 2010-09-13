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

function dump_module($module_id) {
  global $db;
  global $model_name;
  global $model;

  function html_row($row, $indent, $module=0, $master_row=0, $start_hide_row=0, $end_hide_row=0) {
    if (!count($row)) {return;}

    $str .= '<tr id="bomRow'.$master_row.'"'.$hide.'>';
    for ($l=0; $l < count($row); $l++) {
      $padding='';
      if ($l==0) {
        if ($indent > 0) {$padding = ' style="padding-left:'.($indent * 15).'px"';}
        $img='';
        if ($module) {
          if ($start_hide_row) {
            $img = '<img id="toggle'.$master_row.'" src="'."css/images/minus.png".'" '.
                   'onclick="toggleModule('."$master_row, $start_hide_row, $end_hide_row)\" />";
          }

          if ($indent==0) {
            $class = ' class="topmodule" ';
          } else {
            $class = ' class="submodule" ';
          }
        }
        $str .= '<td'.$padding.$class.'>'.$img.$row[$l].'</td>';
      } else {
        if ($indent==0 && $module) {
          $str .= "<td class=\"topmodule\">$row[$l]</td>";
        } else {
          $str .= "<td class=\"bomBorderLeft\">$row[$l]</td>";
        }

      }
    }
    $str .= "</tr></div>\n";
    return $str;
  }

  function html_parent_modules($module_id) {
    global $db;

    $q = $db->query("SELECT m.name, m.id FROM module_module mm, module m WHERE mm.submodule_id = $module_id AND mm.supermodule_id=m.id AND m.id NOT IN (SELECT module_id FROM model);");
  
    while ($row = $q->fetchRow()) {
      $str .= $db->make_module_href($row['id'], $row['name']).' ';
    }

    if (!$str) { return; }

    return "This module is part of the following modules: \n".$str;
  }

  function recursive_dump_module($module_id, $level=0, $master_row=0) {
    require_once("view.php");

    global $db;
    global $model_name;
    
    // get all parts
    $q = $db->query("SELECT p.id, p.name, mp.quantity, mp.description, mp.schematic, mp.notes ".
                    "FROM part p, module_part mp WHERE mp.module_id=$module_id AND p.id=mp.part_id ORDER BY p.name;");
    while ($row = $q->fetchRow(MDB2_FETCHMODE_ORDERED)) {
      $id = $row[0];
      $out[0] =  $db->make_part_href($id, $row[1]).($row[2] != 1 ? " ($row[2])" : '');
      $out[1] =  combine_description_notes($row[3], $row[5]);
      $out[2] = $row[4];
      $out[3] =  $db->get_part_tags($id);
      $out[4] = html_source_for_part($id);

      $str .= html_row($out,  $level, 0, $master_row++);
    }
    

    // get all modules
    /*    $sort = 'm.name';
    if (!strcmp($_GET['sort'], 'supplier')) {
      $sort = 'm.source???
    }
    */

    $q = $db->query("SELECT m.id, m.name, mm.quantity, m.description, mm.schematic, mm.notes ".
                    "FROM module m, module_module mm WHERE m.id=mm.submodule_id AND mm.supermodule_id=$module_id ORDER BY m.name;");
    while ($row = $q->fetchRow(MDB2_FETCHMODE_ORDERED)) {
      $id = $row[0];
      $out[0] = $db->make_module_href($id, $row[1]).($row[2] != 1 ? " ($row[2])" : '');
      $out[1] = combine_description_notes($row[3], $row[5]);
      $out[2] = $row[4];
      $out[3] = $db->get_module_tags($id);
      $out[4] = '';

      $temp_master_row = $master_row;
      $master_row++;
      $temp = recursive_dump_module($id, $level+1, &$master_row);

      if ($master_row > $temp_master_row+1) {
        $start_row_hide = $temp_master_row + 1;
        $end_row_hide = $master_row-1;
      } else {
        $start_row_hide=0;
        $end_row_hide=0;
      }

      $temp_module_row = html_row($out, $level, 1, $temp_master_row, $start_row_hide, $end_row_hide);
      $str .= $temp_module_row.$temp;
    }
    
    return $str;
  }

  $str .= '<table summary="Darwin Bill of Materials" class="bomT" cellspacing="0">';

  if (!$db->is_model($module_id)) {
    $str .=  '<tr><td colspan="20" class="bomHeader">'.$db->get_module_name_by_id($module_id).'</td></tr>'."\n";
  }

  $str .= '<tr><td class="field">'.
    //join("</td><td class=\"field\">", array('Name', 'Description and Notes', 'Schematic', 'Tags', '<a href="?model='.$model.'&module='.$module_id.'&sort=supplier">Suppliers</a>')).    
    join("</td><td class=\"field\">", array('Name', 'Description and Notes', 'Schematic', 'Tags', 'Suppliers')).
    '</td></tr>'."\n";

  $str .=  recursive_dump_module($module_id).'</table>';

  $str .= html_parent_modules($module_id);


  return array('title' => 'Bill of Materials for '.$model_name, 'body' => $str);
}

