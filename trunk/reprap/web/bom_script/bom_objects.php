<?php

// object model for the reprap

require_once("db.php");

function param(&$arg, $val) {is_null($val) || $arg = $val;}

class Model {
  var $name;
  var $id;
  var $module;
  var $type="model";

  function Model ($args = array()) {
    param(&$this->name, $args['name']);
    param(&$this->id, $args['id']);

    if ($args['populate_models']) { $this->populate_modules(); }

  }

  function populate_modules() {
    $q = query("SELECT md.name, mm.submodule_id, mm.quantity, mm.notes ".
               "FROM model m, module_module mm, module md ".
               "WHERE m.module_id=mm.supermodule_id and m.id=$this->id and md.id=mm.submodule_id;");
    $l=0;
    while ($row = $q->fetchRow()) {
      $this->module[$l] = new Module ( array( 'name' => $row[0],
                                              'id' => $row[1],
                                              'quantity' => $row[2],
                                              'notes' => $row[3]
                                              ));
      $l++;

    }
  }
}

class Module {
  var $name;
  var $id;
  var $quantity;
  var $notes;
  var $parent;
  var $type="module";

  function Module ($args = array()) {
    param(&$this->name, $args['name']);
    param(&$this->id, $args['id']);
    param(&$this->quantity, $args['quantity']);
    param(&$this->notes, $args['notes']);
  }  
}

class Part {
}

class Source {
}

?>