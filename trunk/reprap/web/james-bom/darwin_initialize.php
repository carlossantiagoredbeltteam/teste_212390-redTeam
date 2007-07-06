<?php

// create db
// db must be defined before this file is included.
$db->queries("
INSERT INTO source (name, url, abbreviation, description) VALUES ('RepRap', 'http://reprap.org', 'RR', 'These are parts that will be fabricated on an already-working RepRap.');
INSERT INTO source (name, abbreviation, description, notes) VALUES ('Module', 'Module', 'This part is a module or assembly.', 'See documentation for building details.');
INSERT INTO source (name, abbreviation, description) VALUES ('Mold', 'Mold', 'You can make this part yourself from Friendly Plastic.  See URL for details');
INSERT INTO source (name, url, abbreviation) VALUES ('Greenweld', 'http://www.greenweld.co.uk/', 'GH');
INSERT INTO source (name, url, abbreviation) VALUES ('Sculpt.com', ' http://www.sculpt.com/', 'Sculpt');
INSERT INTO source (name, abbreviation, url, part_url_prefix) 
   VALUES ('Digikey', 'DGK', 'http://digikey.com', 'http://www.digikey.com/scripts/DkSearch/dksus.dll?KeywordSearch&Keywords=');



");
//INSERT INTO source (name, abbreviation) VALUES ('Hardware Store', 'H');
//INSERT INTO source (name, abbreviation, url, part_url_prefix) VALUES ('Amazon', 'A', 'http://amazon.com', 'http://amazon.com/s/field-keywords=');

// INSERT INTO source (name, url, abbreviation, part_url_prefix) VALUES ('Jameco', 'http://jameco.com', 'J', 'http://www.jameco.com/webapp/wcs/stores/servlet/ProductDisplay?langId=-1&storeId=10001&catalogId=10001&productId=');

// INSERT INTO source (name, url, abbreviation) VALUES ('Farnell', 'http://farnell.com', 'F');

// INSERT INTO source (name, url, abbreviation, description, part_url_prefix) VALUES ('RepRap Research Foundation', 'http://rrrf.org', 'RRRF', 'The Reprap Research Foundation\'s online store', 'http://parts.rrrf.org/product_info.php?products_id=');

// INSERT INTO source (name, url, abbreviation, part_url_prefix) VALUES ('Mouser', 'http://mouser.com', 'M', 'http://www.mouser.com/search/refine.aspx?Ntt=');

//INSERT INTO source (name, url, abbreviation) VALUES ('McMaster', 'http://mcmaster.com', 'MCM');
// INSERT INTO source (name, url, abbreviation) VALUES ('Radio Shack', 'http://radioshack.com', 'RShk');
// INSERT INTO source (name, url, abbreviation, notes) VALUES ('RS Electronics', 'http://rselectronics', 'RS', 'This is not Radio Shack.  It\'s a completely different company.');

?>