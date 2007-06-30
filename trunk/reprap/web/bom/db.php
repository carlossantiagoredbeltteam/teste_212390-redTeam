<?php

class mydb {
  var $db; // database_object;
  var $db_name;

  function mydb() {
    require_once('DB.php');

    $auth = `cat db_auth`;
    $auth = split("\n", $auth); // put dbname on line 0, username on line 1 and password on line 2
    $this->db_name = $auth[0];
    $dsn = array(
                 'phptype'  => "mysql",
                 'hostspec' => "localhost",
                 'username' => $auth[1],
                 'password' => $auth[2],
                 );
    $this->db = DB::connect($dsn);
    if (DB::iserror($this->db)) { die($this->db->getMessage()); }
  }

  function query($sql) {


    if (!preg_match("/[a-z]/i", $sql)) return; // make sure the query isn't blank

    $q = $this->db->query($sql);
    if (DB::iserror($q)) {  die("$sql: ".$q->getMessage()); }  

    return $q;
  }

  function queries($sql) {
    $queries = explode(";", $sql);
    foreach ($queries as $query) {    
      $this->query($query.";");
    }
  }

  function get_model_name_by_id ($id) {
    $q = $this->query("SELECT module.name from model, module WHERE module.id=model.id AND model.id=$id;");
    $row = $q->fetchRow();
    if ($row[0] == NULL) { return -1; }
    return $row[0];
  }

  function is_model($module_id) {
    // if module is a model, return 1, else 0
    $q = $this->query("SELECT * from model WHERE module_id=$module_id;");
    $row = $q->fetchRow();
    if ($row[0] == NULL) { return 0; }
    return 1;
  }

  function get_module_name_by_id ($id) {
    $q = $this->query("SELECT name from module WHERE id=$id;");
    $row = $q->fetchRow();
    if ($row[0] == NULL) { return -1; }
    return $row[0];
  }

  function get_part_id_by_name ($name) {
    $q = $this->query("SELECT id from part WHERE name=\"$name\";");
    $row = $q->fetchRow();
    if ($row[0] == NULL) { return -1; }
    return $row[0];
  }

  function get_module_id_by_name ($name) {
    // returns -1 if not found
    // returns 0 if $name is blank
    // otherwise returns module id

    if ($name == NULL) { return 0;}
    $q = $this->query("SELECT id from module WHERE name=\"$name\";");
    $row = $q->fetchRow();
    if ($row[0] == NULL) { return -1; }
    return $row[0];
  }

  function get_top_modules_for_model ($model_id) {
    // returns the largest modules in a model, the ones that are assemblies / submodules of the model itself

    $q = $this->db->query("SELECT md.name, mm.submodule_id, mm.quantity, mm.notes ".
                          "FROM model m, module_module mm, module md ".
                          "WHERE m.module_id=mm.supermodule_id and m.id=1 and md.id=mm.submodule_id;");

    $l=0;
    while ($r[$l] = $q->fetchRow()) {
      
      echo $r[$l][0];
    }
    return $r;
  }

  function get_tag_name_by_id ($id) {
    // returns 0 if $id is 0 or not found
    // otherwise returns tag id

    if (!$id) { return 0; }
    $q = $this->query("SELECT name from tag WHERE id=$id;");
    $row = $q->fetchRow();
    if (!$row[0]) { return 0; }
    return $row[0];
  }

  function get_tag_id_by_name ($name) {
    // returns -1 if not found
    // returns 0 if $name is blank
    // otherwise returns tag id

    if (!$name) { return 0; }
    $q = $this->query("SELECT id from tag WHERE name=\"$name\";");
    $row = $q->fetchRow();
    if (!$row[0]) { return -1; }
    return $row[0];
  }


  function create_tag ($name, $description='') {
    $this->query("INSERT into tag (name, description) VALUES (\"$name\", \"$description\")");
    $type_id = $this->get_tag_id_by_name($name);
    return $type_id;
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
    return $this->get_part_id_by_name($name);    
  }
  
  function create_module ($name, $parent_module_id, $quantity=1, $notes='') {
    $this->query ("INSERT into module (name) VALUES (\"".$name."\");");
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
}



?>