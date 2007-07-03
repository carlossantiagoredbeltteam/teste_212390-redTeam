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

<html><head><title>BOM Viewer (<?= $model_name ?>)</title>

<link rel="stylesheet" type="text/css" href="bom.css" />

<script type="text/javascript">
function toggleModule( image, startrow, endrow) {
  var thisImg =  document.getElementById( 'toggle' + image );
  var thisRow =  document.getElementById( 'bomRow' + image );
  
  var RegularExpression = /plus\.png/;

  for (row = startrow; row <= endrow; row++) {
    var currRow = document.getElementById( 'bomRow' + row );
    if ( thisImg.src.search(RegularExpression) != -1) {
      currRow.style.display = "block";
      currRow.style.display = "table-row";
    } else {
      currRow.style.display = "none";
    }
  }

  if ( thisImg.src.search(RegularExpression) != -1) {
    thisImg.src = "images/minus.png";
  } else {
    thisImg.src = "images/plus.png";
  }
}
</script>

</head><body>

<div id="wrap">
   <div id="header"><h1><?= $str['title'] ?></h1></div>
<!--    <div id="nav">
        <ul>
            <li><a href="?">Home</a></li>
            <li><a href="http://reprap.org/bin/view/Main/WebHome">RepRap Wiki</a></li>
            <li><a href="http://forums.reprap.org">Forums</a></li>
        </ul>
    </div>-->
   <div id="sidebar">
        <ul> 
            <li><a href="?"><strong>BOM Home</strong></a></li>
            <li><a href="?model=<?=$model?>&list=module">List all modules</a></li>
            <li><a href="?model=<?=$model?>&list=part">List all parts</a></li>
            <li><a href="?show=vendors">Show part sources</a></li>
            <li><a href="#"><strike>Search</strike></a></li>
        </ul>
        <ul>
            <li><strong><a href="http://reprap.org">RepRap Core</a></strong></li>
            <li><a href="http://www.reprap.org/bin/view/Main/ShowCase">RepRap Intro</a></li>
            <li><a href="http://www.reprap.org/bin/view/Main/FuturePlans">Future Plans</a></li>
            <li><a href="http://blog.reprap.org/">Main Blog</a></li>
            <li><a href="https://sourceforge.net/projects/reprap/">Sourceforge Project</a></li>
        </ul>
        <ul>
            <li><strong><a href="http://reprap.org/bin/view/Main/Community">RepRap Community</a></strong></li>
            <li><a href="http://forums.reprap.org">Forums</a></li>
            <li><a href="http://reprap.org/bin/view/Main/PeopleMain">People</a></li>
            <li><a href="http://objects.reprap.org/mediawiki/index.php/Main_Page">Object Library</a></li>
        </ul>
    </div>
    <div id="main">
      <?= $str['body'] ?>
    </div>
    <div id="footer">
        <p>BOM Viewer is an outgrowth of the <a href="reprap.org">RepRap</a> project.<br />
           <a href="bom_0.1.1.tar.gz">Code</a> is copyright 2007 <a href="">James Vasile</a> and released under the <a href="http://www.affero.org/oagpl.html">Affero GPL</a>.
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

  } else {$str = display_main();}


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
  
  $q = $db->query("SELECT * FROM source");

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


function display_main() {
  global $model;
  return '<h2>List Parts and Modules</h2>'.

    '<p>The BOM viewer is ugly and not yet complete, but it is starting to '.
    'be useful.  Be aware that the code is not stable, and inbound links might not survive future revisions.  Enjoy.</p>'.

    '<p> From here, you can <a class="twikiLink" href="?model='. $model .'&list=module">list all the modules and the parts they
     comprise</a> or <a href="?model='. $model .'&list=part">list all parts</a> (probably what you want if
     you\'re going to be ordering parts).</p>

    <h2>Search for a specific part</h2>'.
    '<p><form>
[TODO: Search function] 
</form></p>';
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

