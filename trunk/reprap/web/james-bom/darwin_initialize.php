<?php

// create db
// db must be defined before this file is included.
$db->queries("
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