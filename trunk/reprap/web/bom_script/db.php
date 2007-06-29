<?php

function query($sql) {
  global $db;

  if (!preg_match("/[a-z]/i", $sql)) return; // make sure the query isn't blank

  $q = $db->query($sql);
  if (DB::iserror($q)) {
    die("$sql: ".$q->getMessage());
  }  

  return $q;
}

function queries($sql) {
  $queries = explode(";", $sql);
  foreach ($queries as $query) {    
    query($query.";");
  }
}

function get_module_id($name) {
  $q = query("select id from module where name = \"$name\"");
  $row = $q->fetchRow();
  return $row[0];          
}

function get_part_id ($name) {
  $q = query("SELECT id from part WHERE name=\"$name\";");
  $row = $q->fetchRow();
  if ($row[0] == NULL) { return -1; }
  return $row[0];

}

function get_module_id_by_name ($name) {
  // returns -1 if not found
  // returns 0 if $name is blank
  // otherwise returns module id

  if ($name == NULL) { return 0;}
  $q = query("SELECT id from module WHERE name=\"$name\";");
  $row = $q->fetchRow();
  if ($row[0] == NULL) { return -1; }
  return $row[0];
}

function get_type_id_by_name($name) {
  // returns -1 if not found
  // returns 0 if $name is blank
  // otherwise returns type id

  if ($name == NULL) { return 0;}
  $q = query("SELECT id from type WHERE name=\"$name\";");
  $row = $q->fetchRow();
  if ($row[0] == NULL) { return -1; }
  return $row[0];
}

function create_type ($name, $description='') {
  query("INSERT into type (name, description) VALUES (\"$name\", \"$description\")");
  $type_id = get_type_id_by_name($name);
  return $type_id;
}


function escape_quotes ($str) {
  $str = preg_replace('/"/', '\"', $str);
  return $str;
}

function create_part ($name, $type=NULL, $description='', $notes='') {
  $type_id = get_type_id_by_name($type);
  if ($type_id == -1) {
    $type_id = create_type($type);
  }
  $name = escape_quotes($name);
  $description = escape_quotes($description);
  $notes = escape_quotes($notes);
  query("INSERT into part (name, type_id, description, notes) VALUES (\"$name\", $type_id, \"$description\", \"$notes\")");
}

function create_module ($name, $parent_module_id, $quantity=1, $notes='') {
  query ("INSERT into module (name) VALUES (\"".$name."\");");
  $module_id = get_module_id($name);
  query ("INSERT into module_module (supermodule_id, submodule_id, quantity, notes) VALUES ($parent_module_id, $module_id, $quantity, \"$notes\");");
  return $module_id;
}

function dump_module($mod_name) {
  //  query("SELECT id from module 
}

?>