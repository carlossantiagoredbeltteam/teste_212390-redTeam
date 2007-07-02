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
require_once("db.php");
$db  = new mydb();
$db->query("use ".$db->db_name);

$model = $_GET["model"] ? $_GET["model"] : 1;
$model_name = $db->get_model_name_by_id($model);
?>

<html><head><title>BOM Viewer (<?= $model_name ?>)</title>

<link rel="stylesheet" type="text/css" href="bom.css" />

<script type="text/javascript">
function toggleModule( _toggleID, _levelId) {
  var thisImg =  document.getElementById( _toggleID );
  var thisLevel = document.getElementById( _levelId );
  alert('these buttons are not yet functional');
  return;
  if ( thisLevel.style.display == "none") {
    thisLevel.style.display = "block";
    thisLevel.style.display = "table-row";
    thisImg.src = "images/minus.png";
  }
  else {
    thisImg.src = "images/plus.png";
    thisLevel.style.display = "none";
  }
}
</script>

</head><body>

<?php
if (!strcmp($_GET['list'], 'part')) { $str = dump_parts_for_model ( $model ); }
elseif (!strcmp($_GET['list'], 'module')) { $str = dump_module ( $model ); }
elseif ($_GET['part']) { $str = dump_part ( $_GET['part'] ); }
elseif ($_GET['module']) { $str = dump_module ( $_GET['module'] ); }
elseif ($_GET['tag']) { $str = dump_tag ( $_GET['tag'] ); }
else {$str = display_main();}

if (strcmp($str,'Array')) {
  html_out(array('body' => $str));
} else {
  html_out($str);
}

function html_out($str) {
  if (!$str['title']) { $str['title']='RepRap Bill of Materials Viewer'; }

?>

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

<?php
   }

function dump_part($part_id) {

  // TODO: make it model-specific
  global $db;
  global $model_name;

  $str .= '<table summary="Darwin Bill of Materials organized by part" class="bomT" cellspacing="0">'.
    '<tr><td class="field">'.join("</td><td class=\"field\">", array('Part ID', 'Name', 'Qty', 'Modules', 'Description', 'Notes', 'Tags', 'Suppliers')).'</td></tr>';

  $q = $db->query("SELECT p.id, p.name, m.name, m.id, mp.quantity, p.description, p.notes, p.photo ".
                  "FROM part p, module m, module_part mp WHERE p.id=mp.part_id AND m.id=mp.module_id AND p.id=$part_id");

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
      $module .= $db->make_module_href($m[3],$m[2])." ($m[4])<br />";
      $quantity = $quantity + $m[4];
    }

    $tag = $db->get_part_tags($p[0][0]);
    $supplier = $db->get_source_for_part($part_id);

    $str .= '<tr><td>'.
      join('</td><td class="bomBorderLeft">', array($part_id, make_part_href($part_id,$p[0][1]), $quantity, $module, $p[0][5], $p[0][6], $tag, $supplier)).
      "</td></tr>\n";
  }

  $str .= '</table>';

  if ($photo) { $str .= '<p><img src="pic.php?part='.$part_id.'"/></p>'; }

  return array('title' => 'Part Detail for '.$p[0][1], 'body' => $str);
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

function dump_module($module_id) {
  global $db;
  global $model_name;

  function html_row($row, $fields, $indent, $module=0, $master_row=0) {
    if (!count($row)) {return;}

    $str .= '<tr id="bomRow'.$master_row.'">';
    for ($l=0; $l < count($row); $l++) {
      $padding='';
      if ($l==0) {
        if ($indent > 0) {$padding = ' style="padding-left:'.($indent * 15).'px"';}
        $img='';
        if ($module) {
          $img = '<img id="toggle'.$master_row.'" src="images/minus.png" onclick="toggleModule(\'toggle0\', \'bomRow'.($master_row+1).'\');"/> ';          

          if ($indent==0) {
            $class = ' class="topmodule"';
          } else {
            $class = ' class="submodule"';
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

  function recursive_dump_module($module_id, $level=0, $master_row=0) {
    global $db;
    global $model_name;
    
    // get all parts
    $q = $db->query("SELECT p.id, p.name, mp.quantity, mp.description, mp.schematic, mp.notes ".
                    "FROM part p, module_part mp WHERE mp.module_id=$module_id AND p.id=mp.part_id;");
    while ($row = $q->fetchRow(MDB2_FETCHMODE_ORDERED)) {
      $id = array_shift($row);
      $row[count($row)] = $db->get_part_tags($id);
      $row[0] = $db->make_part_href($id, $row[0]);
      $row[count($row)] = $db->get_source_for_part($id);
      $str .= html_row($row, array('Name', 'Qty', 'Descrip', 'Schematic ID', 'Tag', 'Notes'), $level, 0, $master_row++);
    }
    

    // get all modules
    $q = $db->query("SELECT m.id, m.name, mm.quantity, m.description, mm.schematic, mm.notes ".
                    "FROM module m, module_module mm WHERE m.id=mm.submodule_id AND mm.supermodule_id=$module_id;");
    while ($row = $q->fetchRow(MDB2_FETCHMODE_ORDERED)) {
      $id = array_shift($row);
      $row[count($row)] = $db->get_module_tags($id);
      $row[count($row)] = ' ';
      $row[0] = $db->make_module_href($id, $row[0]);
      $str .= html_row($row, array('Name', 'Qty', 'Descrip', 'Schematic', 'Notes', 'Tags'), $level, 1, $master_row++);
      $str .= recursive_dump_module($id, $level+1, &$master_row);
    }
    
    return $str;
  }

  $str .= '<table summary="Darwin Bill of Materials" class="bomT" cellspacing="0">';

  if (!$db->is_model($module_id)) {
    $str .=  '<tr><td colspan="20" class="bomHeader">'.$db->get_module_name_by_id($module_id).'</td></tr>'."\n";
  }

  $str .= '<tr><td class="field">'.join("</td><td class=\"field\">", array('Name', 'Qty', 'Descrip', 'Schematic', 'Notes', 'Tags', 'Suppliers')).'</td></tr>'."\n".
    recursive_dump_module($module_id);

  return array('title' => 'Bill of Materials for '.$model_name, 'body' => $str.'</table>');
}


function get_part_rows($q) {
  global $db;

  $part=array();
  while ($row = $q->fetchRow(MDB2_FETCHMODE_ORDERED)) {
    $part[$row[0]][ count($part[$row[0]]) ] = $row;
  }

  foreach ($part as $p) {
    $quantity = 0;
    $module = '';
    foreach ($p as $m) {
      $module .= $db->make_module_href($m[3],$m[2])." ($m[4])<br />";
      $quantity = $quantity + $m[4];
    }

    $tag = $db->get_part_tags($p[0][0]);

    $str .= '<tr><td>'.join('</td><td class="bomBorderLeft">', array($p[0][0], $db->make_part_href($p[0][0],$p[0][1]), $quantity, $module, $p[0][5], $p[0][6], $tag, '')). "</td></tr>\n";
  }
  return $str;
}


function dump_parts_for_model ($model=0) {
  // TODO: make it model-specific
  global $db;
  global $model_name;

  $str .= '<table summary="Darwin Bill of Materials organized by part" class="bomT" cellspacing="0">'.
    '<tr><td class="field">'.join("</td><td class=\"field\">", array('Part ID', 'Name', 'Qty', 'Modules', 'Description', 'Notes', 'Tags', 'Suppliers')).'</td></tr>';

  $q = $db->query("SELECT p.id, p.name, m.name, m.id, mp.quantity, p.description, p.notes ".
                  "FROM part p, module m, module_part mp WHERE p.id=mp.part_id AND m.id=mp.module_id");
  $str .=get_part_rows($q);
  return array('title' => $model_name.' Bill of Materials Organized by Part', 'body' => $str.'</table>');
}

function dump_tag($tag_id) {
  global $db;

  $tag_name = $db->get_tag_name_by_id($tag_id);

  $field_header = '<tr><td class="field">'.join("</td><td class=\"field\">", array('Part ID', 'Name', 'Qty', 'Modules', 'Description', 'Notes', 'Tags', 'Suppliers')).'</td></tr>';

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
                                   "WHERE p.id=mp.part_id AND m.id=mp.module_id AND pt.part_id=p.id and pt.tag_id=$tag_id"));
  if ($rows) {
    $str .= '<tr><td colspan="20" class="topModule">Parts tagged "'.$tag_name.'"</td></tr>'.$field_header.$rows;
  }
  return (array('title' => 'Parts and Modules Tagged "'.$tag_name.'"', 'body' => $str.'</table>'));
}




?></body></html>