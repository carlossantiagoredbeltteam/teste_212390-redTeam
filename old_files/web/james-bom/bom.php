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
  <link rel="stylesheet" type="text/css" href="css/bom.css" />
  <script type="text/javascript" src="js/hide_show.js"></script>
  <link rel="stylesheet" type="text/css" href="css/chrometheme/chromestyle.css" />
  <script type="text/javascript" src="js/chromejs/chrome.js"></script>
</head>

<body>
<div id="wrap">
   <div id="header"><h1><?= $str['title'] ?></h1></div>

    <div class="chromestyle" id="chromemenu">
      <div class="chromestyleLeft" id="chromemenu">
        <ul>
          <li><a href="?">Home</a></li>
          <li><a href="?show=model">Projects</a></li>
          <li><a href="?model=<?=$model?>&list=module">Modules</a></li>
          <li><a href="?model=<?=$model?>&list=part">Parts</a></li>	
          <li><a href="?show=vendor" rel="dropmenuSource">Sources</a></li>	
          <li><a href="#" rel="dropmenuHelp">Help</a></li>	
        </ul>
      </div>

     <!-- <div class="chromestyleRight" >
        <ul>
          <li><form><input type="text" name="search" size="15"/></form></li>	
        </ul>
      </div> -->
    </div>
      <!--Source drop down menu -->                                                   
      <div id="dropmenuSource" class="dropmenudiv">
        <a href="?show=vendor" rel="dropmenuSource">Show vendors</a></li>	
        <a href="?show=orphans">Orphans</a>
      </div>

      <!--Help drop down menu -->                                                
      <div id="dropmenuHelp" class="dropmenudiv" style="width: 150px;">
        <a href="?show=builders">Builders</a>
        <a href="?show=developers">Developers</a>
        <a href="?show=faq">FAQ</a>
        <a href="?show=about">About</a>
      </div>

      <script type="text/javascript">cssdropdown.startchrome("chromemenu")</script>
   <!-- END MENU -->


    <?php // include ('sidebar.html') ?>
    <div id="main">
      <?php if ($str['file']) { include($str['file']); } else {echo $str['body'];} ?>
    </div>
    <div id="footer">
        <p>BOM Viewer is an outgrowth of the <a href="http://reprap.org">RepRap</a> project.<br />
        <!--<a href="bom_0.1.1.tar.gz">Code</a>--> Code is copyright 2007 <a href="">James Vasile</a> 
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
    require_once("view.php");
    require_once("part.php");
    $str = dump_parts_for_model ( $model );
  
  } elseif (!strcmp($_GET['list'], 'module')) {
    require_once("view.php");
    require_once ("module.php");
    $str = dump_module ( $model ); 

  } elseif ($_GET['part']) { 
    require_once("view.php");
    require_once("part.php");
    $str = dump_part ( $_GET['part'] ); 

  } elseif ($_GET['module']) { 
    require_once("view.php");
    require_once ("module.php");
    $str = dump_module ( $_GET['module'] );

  } elseif ($_GET['tag']) { 
    require_once("view.php");
    $str = dump_tag ( $_GET['tag'] ); 

  } elseif ($_GET['show']) {

    switch ($_GET['show']) {

      case "vendor":
      require_once("view.php");
      $str = dump_source($_GET['id']); 
      break;

      case "orphans":
      $str = html_parts_sans_source();
      break;

      case "search":
      $str = search();
      break;

      default:
      $str = '<h2>Page Not Found</h2><p>Couldn\'t find any pages marked "'.$_GET['show'].'".  Perhaps you have selected a link that doesn\'t go anywhere yet.</p>';
    }

  } else {
    $str['file'] = 'home.html';
  }

  if (strcmp($str,'Array')) {
    $str = array('body' => $str);
  }
  
  if (!$str['title']) { $str['title'] ='RepRap Bill of Materials Viewer'; }
}

function search() {

  global $db;
  global $model;

  $str .= "<h2>Preferences</h2>".

    '<p>If you tell us what region you\'re in, we can generate order forms
     for the various online stores that best serve your part of the
     world.  This will help cut down on shipping costs.</p>'.

    '<form method="post" action="?find_source">
        <select>
          <option>Americas (North)</option>
          <option>Americas (South)</option>
          <option>Asia</option>
          <option>Europe</option>
          <option>Oceania</option>
        </select>';

  $str.= '<br /><br />For which modules do you need parts?<br /><ul>';
  $modules = $db->get_top_modules_by_model($model);
  $str.= '<input type="checkbox" name="" value="" />All<br />'."\n";
  foreach ($modules as $module) {
    $str .= '<input type="checkbox" name="modules" value="'. $module['id'].'" />'. $module['name']."<br />\n";
  }
  $str .= "</ul>\n";
  

  $str .= '</form>';


  $q = $db->query("SELECT sp.part_id, p.name, sp.source_id  from part p, source_part sp WHERE sp.part_id=p.id ORDER BY p.name");
  while ($row = $q->fetchRow()) {
    //$str .= join(' ', array($row['part_id'], $row['source_id'], $row['name'])).'<br />';
  }


  $str .= "<h2>Orphaned Parts</h2>";
  $orphans = html_parts_sans_source();
  $str .= $orphans['body'];



  return array('title'=>'Search', 'body'=>$str);
}

function html_parts_sans_source() {
  require_once ("view.php");
  global $db;

  $str .= '<table summary="Darwin Bill of Materials organized by part" class="bomT" cellspacing="0">'.
    '<tr><td class="bomHeader" colspan="20">Parts With No Sources</td></tr>'.
    '<tr><td class="field">'.join("</td><td class=\"field\">", array('Name', 'Modules', 'Description and Notes', 'Tags')).'</td></tr>';

  // return all the parts that have no source
  $q = $db->query("SELECT p.id, p.name, m.name, m.id, mp.quantity, p.description, p.notes FROM part p, module_part mp, module m ".
                  "WHERE m.id=mp.module_id AND mp.part_id = p.id AND p.id NOT IN (SELECT part_id FROM source_part) ORDER BY p.name;");

  $str .= html_part_rows(array('query'=>$q, 'orphans'=>1)).'</table>';

  return array('title'=>'Orphaned Parts', 'body'=>$str);
}

