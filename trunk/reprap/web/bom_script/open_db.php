<?php
require_once('DB.php');
$dsn = array(
             'phptype'  => "mysql",
             'hostspec' => "localhost",
             'username' => "vasile",
             'password' => "xxxxxxxx"
             );
$db = DB::connect($dsn);
if (DB::iserror($db)) { die($db->getMessage()); }
?>
