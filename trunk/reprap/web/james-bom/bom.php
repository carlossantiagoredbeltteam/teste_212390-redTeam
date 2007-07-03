<?php
/*
Bill Of Materials Viewer and Editor

An outgrowth of the RepRap Project.  See reprap.org for details.

Copyright 2007 James Vasile 
Released under Version 1 of the Affero GPL
See LICENSE and <http://www.affero.org/oagpl.html> for details.
*/
?>
<?php main(); ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>BOM Viewer (<?= $model_name ?>)</title>
  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
  <link rel="stylesheet" type="text/css" href="bom.css" />
  <script type="text/javascript" src="hide_show.js"></script>
</head>

<body>
<div id="wrap">
   <div id="header"><h1><?= $str['title'] ?></h1></div>
    <div id="nav">
        <ul>
            <li><a href="?">Home</a></li>
            <li><a href="?show=models">Projects</a></li>
            <li><a href="?model=<?=$model?>&list=module">Modules</a></li>
            <li><a href="?model=<?=$model?>&list=part">Parts</a></li>
            <li><a href="?show=vendors">Sources</a></li>
            <li><a href="#"><strike>Search</strike></a></li>
        </ul>
    </div>
    <?php // include ('sidebar.html') ?>
    <div id="main">
      <?php if ($str['file']) { include($str['file']); } else {echo $str['body'];} ?>
    </div>
    <div id="footer">
        <p>BOM Viewer is an outgrowth of the <a href="reprap.org">RepRap</a> project.<br />
        <a href="bom_0.1.1.tar.gz">Code</a> is copyright 2007 <a href="">James Vasile</a> 
        and released under the <a href="http://www.affero.org/oagpl.html">Affero GPL</a>.
        </p>
    </div>
</div>
</body></html>

<?php

function main() {
  global $db;
  global $model;
  global $model_name;
  global $str;

  require_once("db.php");
  $db  = new mydb();
  $db->query("use ".$db->db_name);

  $model = $_GET["model"] ? $_GET["model"] : 1;
  $model_name = $db->get_model_name_by_id($model);

  if (!strcmp($_GET['list'], 'part')) {
    require_once("part.php");
    $str = dump_parts_for_model ( $model );
  
  } elseif (!strcmp($_GET['show'], 'vendors')) {
    $str = dump_sources(); 

  } elseif (!strcmp($_GET['list'], 'module')) {
    require_once ("module.php");
    $str = dump_module ( $model ); 

  } elseif ($_GET['part']) { 
    require_once("part.php");
    $str = dump_part ( $_GET['part'] ); 

  } elseif ($_GET['module']) { 
    require_once ("module.php");
    $str = dump_module ( $_GET['module'] );

  } elseif ($_GET['tag']) { 
    $str = dump_tag ( $_GET['tag'] ); 

  } else {
    $str['file'] = 'home.html';
  }

  if (strcmp($str,'Array')) {
    $str = array('body' => $str);
  }
  
  if (!$str['title']) { $str['title'] ='RepRap Bill of Materials Viewer'; }
}

function combine_description_notes($description='', $notes='') {
  // combine description and note fields
  if ($notes) {
    if ($description) {
      $description .= '<br />';
    }
    $description .=  'Note: '.$notes;
  }
  return $description;
}


function dump_sources() {
  global $db;

  $str = '<table summary="Darwin Bill of Materials organized by part" class="bomT" cellspacing="0">'.
    '<tr><td class="field">'.
    join("</td><td class=\"field\">", array('Name', 'Prefix', 'Description', 'Region')).
    '</td></tr>';
  
  $q = $db->query("SELECT * FROM source ORDER BY REGION");

  while ($row = $q->fetchRow()) {
    if ($row['id'] == 1) { continue; }
    $str .= '<tr><td class="bomBorderLeft">'.
      join('</td><td class="bomBorderLeft">', array(
                              ($row['url'] ? '<a href="'.$row['url'].'">'.$row['name'].'</a>' : $row['name']), 
                              $row['abbreviation'], 
                              $row['description'],
                              $row['region']
                              )).
      '</td></tr>';
  }

  return array('title' => 'Sources for Parts', 'body' => ($str.'</table>'));
}


function dump_tag($tag_id) {
  global $db;

  $tag_name = $db->get_tag_name_by_id($tag_id);

  $field_header = '<tr><td class="field">'.join("</td><td class=\"field\">", array('Name', 'Modules', 'Description and Notes', 'Tags', 'Suppliers')).'</td></tr>';

  $str .= '<table summary="Bill of Materials tag viewer" class="bomT" cellspacing="0">';

  // Modules
  $r = $db->query("SELECT m.id, m.name from tag t, module_tag mt, module m WHERE m.id=mt.module_id AND t.id=mt.tag_id AND t.id=$tag_id");
  if ($row = $r->fetchRow(MDB2_FETCHMODE_ORDERED)) {
    $str .= '<tr><td colspan="20" class="topModule">Modules tagged "'.$tag_name.'"</td></tr>'.$field_header;
    do {
      $str .= '<tr><td>'.$db->make_module_href($row[0],$row[1]).'</td></tr>';
    } while ($row = $r->fetchRow(MDB2_FETCHMODE_ORDERED));
  }

  // Parts
  $rows = get_part_rows($db->query("SELECT p.id, p.name, m.name, m.id, mp.quantity, p.description, p.notes ".
                                   "FROM part p, module m, module_part mp, part_tag pt ".
                                   "WHERE p.id=mp.part_id AND m.id=mp.module_id AND pt.part_id=p.id and pt.tag_id=$tag_id ORDER BY p.name"));
  if ($rows) {
    $str .= '<tr><td colspan="20" class="topModule">Parts tagged "'.$tag_name.'"</td></tr>'.$field_header.$rows;
  }
  return (array('title' => 'Parts and Modules Tagged "'.$tag_name.'"', 'body' => $str.'</table>'));
}

