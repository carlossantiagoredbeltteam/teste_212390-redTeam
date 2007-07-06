<?php
/*
Bill Of Materials Viewer and Editor

An outgrowth of the RepRap Project.  See reprap.org for details.

Copyright 2007 James Vasile 
Released under Version 1 of the Affero GPL
See LICENSE and <http://www.affero.org/oagpl.html> for details.
*/

class mydb {
  var $db; // database_object;
  var $db_name;
  var $source_id_abbreviation='';

  function mydb($args=array()) {
    // note: set $args['no_use_db'] if you just want to connect to mysql without selecting the bom db

    // Needed to switch from DB.php to mdb2.php for licensing reasons.
    // Thanks to http://www.phpied.com/db-2-mdb2/ for making it easy
    require_once('MDB2.php');

    // included with this distribution in case you don't have it.
    require_once('lib/JSON.php');

    if (!$auth = file('db_auth.php')) {
      die ("Couldn't read db_auth.php!");
    }

    $json = new Services_JSON();
    $auth =  $json->decode(join('', array_slice($auth, 1)));

    if (is_readable($auth->alternate_path)) {
      // if an alternate db_auth file is specified, read it.  If you
      // can't find it, try to use the auth credentials in the
      // original file
      $auth = file($auth->alternate_path);
      $auth =  $json->decode(join('', array_slice($auth, 1)));
    }

    $this->db_name = $auth->db_name;

    $this->db =& MDB2::factory('mysql://'.$auth->db_user.':'.$auth->db_pass.'@'.$auth->host.($args['no_use_db'] ? '' : '/'.$auth->db_name));
    if (MDB2::isError($this->db)) {
      echo ($this->db->getMessage().' - '.$this->db->getUserinfo());
    }

    //$this->db->setFetchMode(MDB2_FETCHMODE_ORDERED);
    $this->db->setFetchMode(MDB2_FETCHMODE_ASSOC);
  }

  function query($sql) {

    if (!preg_match("/[a-z]/i", $sql)) return; // make sure the query isn't blank

    // run the query and get a result handler
    $result = $this->db->query($sql);

    // check if the query was executed properly
    if (MDB2::isError($result)) {
      die ($result->getMessage().' - '.$result->getUserinfo());
    }

    return $result;
  }

  function queries($sql) {
    $queries = explode(";", $sql);
    foreach ($queries as $query) {    
      $this->query($query.";");
    }
  }

  function get_source_abbreviation_id_hash() {
    // get hash of source abbreviations and id

    if ($this->source_id_abbreviation) { return $this->source_id_abbreviation; }

    $q = $this->query("SELECT abbreviation, id FROM source");
    while ($row = $q->fetchRow()) {
      $sid[$row['abbreviation']] = $row['id'];
    }
    $this->source_id_abbreviation = $sid;

    return $sid;
  }

  function get_tags($q) {
    $tag='';
    while ($row = $q->fetchRow(MDB2_FETCHMODE_ORDERED)) {
      $tag .= $this->make_tag_href($row[1], $row[0])."<br />";
    }
    return $tag;
  }
  
  function get_module_tags($id) {
    global $db;
    return $this->get_tags($db->query("SELECT t.name, t.id from tag t, module m, module_tag tm WHERE tm.module_id=m.id AND t.id=tm.tag_id and m.id=$id"));
  }
  
  function get_part_tags($id) {
    global $db;
    return $this->get_tags( $db->query("SELECT t.name, t.id FROM tag t, part_tag pt WHERE pt.part_id=".$id." AND t.id=pt.tag_id;") );
  }

  function get_source_id_by_name ($name) {
    $name = preg_replace('/"/', '\\"', $name);
    $q = $this->query("SELECT id from source WHERE name=\"$name\";");
    $row = $q->fetchRow();
    if ($row['id'] == NULL) { return -1; }
    return $row['id'];
  }

  function get_model_name_by_id ($id) {
    $q = $this->query("SELECT module.name from model, module WHERE module.id=model.id AND model.id=$id;");
    $row = $q->fetchRow();
    if ($row['name'] == NULL) { return -1; }
    return $row['name'];
  }

  function is_model($module_id) {
    // if module is a model, return 1, else 0
    $q = $this->query("SELECT * from model WHERE module_id=$module_id;");
    $row = $q->fetchRow();
    if ($row['id'] == NULL) { return 0; }
    return 1;
  }

  function get_top_modules_by_model($model) {
    // returns top-level module id, name and quantities
    $q = $this->query("SELECT module.id, module.name, mm.quantity FROM module, model, module_module mm ".
                      "WHERE mm.supermodule_id=model.id AND mm.submodule_id=module.id AND model.id=$model;");
    $row = $q->fetchAll();
    return $row;
  }

  function get_module_name_by_id ($id) {
    $q = $this->query("SELECT name from module WHERE id=$id;");
    $row = $q->fetchRow();
    if ($row['name'] == NULL) { return -1; }
    return $row['name'];
  }

  function get_part_id_by_name ($name) {
    $name = preg_replace('/"/', '\\"', $name);
    $q = $this->query("SELECT id from part WHERE name=\"$name\";");
    $row = $q->fetchRow();
    if ($row['id'] == NULL) { return -1; }
    return $row['id'];
  }

  function get_module_id_by_name ($name) {
    // returns -1 if not found
    // returns 0 if $name is blank
    // otherwise returns module id

    if ($name == NULL) { return 0;}
    $q = $this->query("SELECT id from module WHERE name=\"$name\";");
    $row = $q->fetchRow();
    if ($row['id'] == NULL) { return -1; }
    return $row['id'];
  }


  function get_tag_name_by_id ($id) {
    // returns 0 if $id is 0 or not found
    // otherwise returns tag id

    if (!$id) { return 0; }
    $q = $this->query("SELECT name from tag WHERE id=$id;");
    $row = $q->fetchRow();
    if (!$row['name']) { return 0; }
    return $row['name'];
  }

  function get_tag_id_by_name ($name) {
    // returns -1 if not found
    // returns 0 if $name is blank
    // otherwise returns tag id

    if (!$name) { return 0; }
    $q = $this->query("SELECT id from tag WHERE name=\"$name\";");
    $row = $q->fetchRow();
    if (!$row['id']) { return -1; }
    return $row['id'];
  }

  function create_source($args) {
    // assume only one region.  TODO multiple regions
    $this->query("INSERT INTO source (name, description, url, part_url_prefix, region, abbreviation)".
                 'VALUES ("'. $args['name'] .'", '.
                          '"'.$args['description'].'", '.
                          '"'.$args['url'].'", '.
                          '"'.$args['part_url_prefix'].'", '.
                          '"'.$args['region'].'", '.
                          '"'.$args['abbreviation'].'" '.
                 ');');
    return $this->db->lastInsertID();
  }

  function create_model ($model) {
    // returns module id and model id
    $module_id = $this->create_module($model);
    $this->query("INSERT INTO model (module_id) VALUES ($module_id);");
    return array('model_id' => $this->db->lastInsertID(),
                 'module_id' => $module_id);
  }

  function create_tag ($name, $description='') {
    $this->query("INSERT into tag (name, description) VALUES (\"$name\", \"$description\")");
    return $this->db->lastInsertID();
  }


  function escape_quotes ($str) {
    $str = preg_replace('/"/', '\"', $str);
    return $str;
  }

  function create_part ($name, $description='', $notes='') {
    $name = $this->escape_quotes($name);
    $description = $this->escape_quotes($description);
    $notes = $this->escape_quotes($notes);
    $this->query("INSERT into part (name, description, notes) VALUES (\"$name\", \"$description\", \"$notes\")");
    return $this->db->lastInsertID('part', 'id');
  }
  
  function create_module ($name, $parent_module_id=-1, $quantity=1, $notes='') {
    $q = $this->query ("INSERT into module (name) VALUES (\"".$name."\");");
    $module_id = $this->get_module_id_by_name($name);
    if ($parent_module_id != -1) {
      $this->query ("INSERT into module_module (supermodule_id, submodule_id, quantity, notes) VALUES ($parent_module_id, $module_id, $quantity, \"$notes\");");
    }
    return $module_id;
  }

  function tag_model ($model_id, $tag) {
    if (!$tag) { return; }
    $tag_id = $this->get_tag_id_by_name($tag);
    if ($tag_id == -1) {
      $tag_id = $this->create_tag($tag);
    }
    $this->query("INSERT into model_tag (model_id, tag_id) VALUE ($model_id, $tag_id);");
  }

  function tag_module ($module_id, $tag) {
    if (!$tag) { return; }
    $tag_id = $this->get_tag_id_by_name($tag);
    if ($tag_id == -1) {
      $tag_id = $this->create_tag($tag);
    }
    $this->query("INSERT into module_tag (module_id, tag_id) VALUE ($module_id, $tag_id);");
  }

  function tag_part($part_id, $tag) {
    if (!$tag) { return; }
    $tag_id = $this->get_tag_id_by_name($tag);
    if ($tag_id == -1) {
      $tag_id = $this->create_tag($tag);
    }
    $this->query("INSERT into part_tag (part_id, tag_id) VALUE ($part_id, $tag_id);");
  }

  function make_tag_href($id, $text) {
    global $model;
    return '<a href="?model='.$model.'&tag='.$id.'">'.$text.'</a>';
  }

  function make_module_href($id, $text) {
    global $model;
    //  return $text;
    return '<a href="?model='.$model.'&module='.$id.'">'.$text.'</a>';
  }

  function make_part_href($id, $text) {
    global $model;
    return '<a href="?model='.$model.'&part='.$id.'">'.$text.'</a>';
  }

}

?>