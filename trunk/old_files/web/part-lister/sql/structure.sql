
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS suppliers_to_countries;
DROP TABLE IF EXISTS countries;
DROP TABLE IF EXISTS legend;
DROP TABLE IF EXISTS unique_parts;
DROP TABLE IF EXISTS raw_parts;
DROP TABLE IF EXISTS supplier_parts;


CREATE TABLE `suppliers` (
`id` INT( 11 ) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`prefix` VARCHAR( 32 ) NOT NULL ,
`name` VARCHAR( 255 ) NOT NULL ,
`website` VARCHAR( 255 ) NOT NULL ,
`description` TEXT NOT NULL ,
`buy_link` VARCHAR( 255 ) NOT NULL
) ENGINE = MYISAM ;

CREATE TABLE `suppliers_to_countries` (
`id` INT( 11 ) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`supplier_id` INT( 11 ) NOT NULL ,
`country_id` INT( 11 ) NOT NULL ,
INDEX ( `supplier_id` , `country_id` )
) ENGINE = MYISAM ;

CREATE TABLE `countries` (
`id` INT (11) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`name` VARCHAR( 255 ) NOT NULL ,
`code` CHAR( 2 ) NOT NULL ,
`group` VARCHAR (255),
INDEX ( `name` ),
INDEX ( `group` )
) ENGINE = MYISAM ;

CREATE TABLE `legend` (
`id` INT (11) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`unique_part_id` INT( 11 ) NOT NULL ,
`status` ENUM('production', 'beta', 'obsolete') NOT NULL,
INDEX ( `unique_part_id` ),
INDEX ( `status` )
) ENGINE = MYISAM ;

CREATE TABLE `unique_parts` (
`id` INT (11) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`type` VARCHAR( 32 ) NOT NULL ,
`name` VARCHAR( 255 ) NOT NULL ,
`description` TEXT NOT NULL ,
`url` VARCHAR( 255 ) NOT NULL ,
`units` VARCHAR( 255 ) NOT NULL ,
`fudge_factor` DOUBLE NOT NULL ,
INDEX ( `type` , `name` )
) ENGINE = MYISAM ;

CREATE TABLE `raw_parts` (
`id` INT (11) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`part_id` INT( 11 ) NOT NULL ,
`type` VARCHAR( 32 ) NOT NULL ,
`raw_id` VARCHAR( 255 ) NOT NULL ,
`raw_text` VARCHAR( 255 ) NOT NULL ,
`quantity` INT( 11 ) NOT NULL ,
`parent_id` INT( 11 ) NOT NULL ,
INDEX ( `part_id` ),
INDEX ( `parent_id`)
) ENGINE = MYISAM ;

CREATE TABLE `supplier_parts` (
`id` INT (11) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`supplier_id` INT( 11 ) NOT NULL ,
`part_id` INT( 11 ) NOT NULL ,
`url` VARCHAR( 255 ) NOT NULL ,
`part_num` VARCHAR( 255 ) NOT NULL ,
`quantity` INT( 11 ) NOT NULL DEFAULT '1',
INDEX ( `supplier_id` , `part_id` )
) ENGINE = MYISAM ;