<?php

function get_csv($page_num) {

  // If we already have a copy here, don't download a new one
  $cache = "cache/spreadsheet_$page_num.csv";
  if (!is_readable($cache)) {
    $url = 'http://spreadsheets.google.com/pub?key=pmEMxYRcQzzATwbOb71BmGA&output=csv&gid='.$page_num;
    $spreadsheet = file_get_contents($url);

    $out = fopen($cache, 'w+');
    if(!is_resource($out)) { die ("Error opening spreadsheet cache file"); }
    fwrite($out, $spreadsheet);

  }

  // read the cached version
  $handle = fopen($cache, "r");
  if (!$handle) {die("Couldn't retrieve BOM page $page_num\n");}

  // grab the csv and stick it in an array
  while ($row = fgetcsv($handle)) {
    $csv[count($csv)] = $row;
  }

  // close file handle
  if ($handle) { fclose ($handle);  }

  return $csv;
}


?>