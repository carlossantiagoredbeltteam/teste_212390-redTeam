<?php

// cretae db
// db must be defined before this file is included.
$db->queries("
DROP DATABASE if exists bom;
CREATE DATABASE bom;
USE bom;

CREATE TABLE IF NOT EXISTS model (
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT UNIQUE,
  module_id INT
);

CREATE TABLE IF NOT EXISTS part (
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT UNIQUE,
  name VARCHAR(128),
  description VARCHAR(256),
  url VARCHAR(256),
  photo MEDIUMBLOB,
  stl MEDIUMBLOB,
  notes VARCHAR(2048)
);

CREATE TABLE IF NOT EXISTS source (
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT UNIQUE,
  name VARCHAR(128),
  description VARCHAR(256),
  url VARCHAR(256),
  notes VARCHAR(2048)
);

CREATE TABLE IF NOT EXISTS module ( /* also used for assemblies */
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT UNIQUE,
  name VARCHAR(128) UNIQUE,
  description VARCHAR(256),
  url VARCHAR(256),
  notes VARCHAR(2048)
);

CREATE TABLE IF NOT EXISTS tag ( /*just like flickr tags */
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT UNIQUE,
  name VARCHAR(32),
  description VARCHAR(256)
);

CREATE TABLE IF NOT EXISTS model_tag ( /*just like flickr tags */
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT UNIQUE,
  model_id INT,
  tag_id INT
);

CREATE TABLE IF NOT EXISTS module_tag ( /*just like flickr tags */
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT UNIQUE,
  module_id INT,
  tag_id INT
);

CREATE TABLE IF NOT EXISTS part_tag ( /*just like flickr tags */
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT UNIQUE,
  part_id INT,
  tag_id INT
);


CREATE TABLE IF NOT EXISTS source_part (
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT UNIQUE,
  source_id INT,
  part_id INT,
  vendor_part_id VARCHAR(64),  /* Vendor's part number */
  vendor_part_name VARCHAR(256),  /* Vendor's name for part, if different from ours */
  url VARCHAR(256),
  price FLOAT(2),
  price_date DATE,
  notes VARCHAR(2048)  /* notes about getting this particular part from this vendor */
);


CREATE TABLE IF NOT EXISTS module_part (
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT UNIQUE,
  module_id INT,
  part_id INT,
  quantity INT,
  schematic VARCHAR(16),   /* this is the code used to identify this part on a drawing */
  description VARCHAR(256), /* If part has a colloquial name when used in this context, put it here */
  notes VARCHAR(2048)  /* notes about how this part is used in this module*/
);


CREATE TABLE IF NOT EXISTS module_module (
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT UNIQUE,
  supermodule_id INT,
  submodule_id INT,
  quantity INT,        /*how many submodules in the supermodule? */
  schematic VARCHAR(16),   /* this is the code used to identify the submodule on a drawing */
  notes VARCHAR(2048) /* notes about how this assembly or submodule fits with the supermodule */
);


INSERT INTO model (module_id) VALUES (1); /* identify master module */

INSERT INTO tag (name, description) VALUES ('', 'N/A');

INSERT INTO source (name, url, description) VALUES ('RepRap', 'http://reprap.org', 'These are parts that will be fabricated on an already-working RepRap.');
INSERT INTO source (name, url, description) VALUES ('RepRap Research Foundation', 'http://rrrf.org', 'The Reprap Research Foundation\'s online store');
INSERT INTO source (name, description) VALUES ('No Source', 'Some parts you\'ll just have to find on your own.');
INSERT INTO source (name, description, notes) VALUES ('Module', 'This part is a module or assembly.', 'See documentation for building details.');
INSERT INTO source (name, description) VALUES ('Mold', 'You can to make this part yourself from Friendly Plastic.  See URL for details');
INSERT INTO source (name, url, notes) VALUES ('RS Electronics', 'http://rselectronics', 'This is not Radio Shack.  It\'s a completely different company.');
INSERT INTO source (name, url) VALUES ('Farnell Electronics', 'http://farnell.com');
INSERT INTO source (name, url) VALUES ('Jameco Electronics', 'http://jameco.com');
INSERT INTO source (name, url) VALUES ('McMaster-Carr', 'http://mcmaster.com');
INSERT INTO source (name, url) VALUES ('Mouser Electronics', 'http://mouser.com');
INSERT INTO source (name, url) VALUES ('Radio Shack', 'http://radioshack.com');
INSERT INTO source (name, url) VALUES ('Greenweld Hobbies', 'http://www.greenweld.co.uk/');

INSERT into module (name) VALUES ('Darwin'); /* master module */
INSERT into module (name) VALUES ('Cartesian Robot');
INSERT into module (name) VALUES ('Thermoplast Extruder');
INSERT into module (name) VALUES ('Material Extruder');
INSERT into module (name) VALUES ('PowerComms Board');
INSERT into module (name) VALUES ('Stepper Controller Board');
INSERT into module (name) VALUES ('Extruder Controller Board');
INSERT into module (name) VALUES ('Opto Endstop Board');
INSERT into module (name) VALUES ('Stepper Tester Board');
INSERT into module (name) VALUES ('Miscellaneous Kit');

INSERT into module_module (supermodule_id, submodule_id, quantity) VALUES (1,2,1);
INSERT into module_module (supermodule_id, submodule_id, quantity) VALUES (1,3,1);
INSERT into module_module (supermodule_id, submodule_id, quantity) VALUES (1,4,1);
INSERT into module_module (supermodule_id, submodule_id, quantity) VALUES (1,5,1);
INSERT into module_module (supermodule_id, submodule_id, quantity) VALUES (1,6,3);
INSERT into module_module (supermodule_id, submodule_id, quantity) VALUES (1,7,2);
INSERT into module_module (supermodule_id, submodule_id, quantity) VALUES (1,8,3);
INSERT into module_module (supermodule_id, submodule_id, quantity) VALUES (1,9,1);
INSERT into module_module (supermodule_id, submodule_id, quantity) VALUES (1,10,1);


");

?>