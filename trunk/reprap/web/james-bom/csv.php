<?php

function get_csv($page_num) {
  global $wget_path;
  global $cat_path;

  $file = `$cat_path bom_$page_num.csv`;
  if (! $file == '') {return $file;}

  $url = 'http://spreadsheets.google.com/pub?key=pmEMxYRcQzzATwbOb71BmGA&output=csv&gid=';
  $destination_path = "bom_data_files";
  
  $wget_command = "$wget_path -O - '$url$page_num' 2>/tmp/wget.out | tee bom_$page_num.csv";
  $temp = `$wget_command`;
  if ($temp=='') {
    echo "<p class=\"error\">Error retrieving BOM page $page_num:</p><p>".
      `$cat_path /tmp/wget.out`.
      '</p>';
  }
  return $temp;
}

function repair_one_csv_line($vals) {
  // Fix one instance of a comma apeparing ina  quoted field breaking that field in two
  for ($i=0; $i < count($vals); $i++) {
    if (!strcmp($vals[$i][0], '"')) {  // if this field is quoted
      if ( strcmp($vals[$i][strlen($vals[$i])-1], '"') ) {  // and we cut it off
        array_splice($vals, $i, 2, array($vals[$i].=','.$vals[$i+1]));
        return array(1, $vals);
      }
    }
  }
  return array(0, $vals);
}

function repair_csv($vals) {
  // fix all instances of a comma appearing in a quoted field breaking that field in two
  
  do {
    $iteration = repair_one_csv_line($vals);
    $ret_code = array_shift($iteration);
    $vals = array_shift($iteration);
  } while ($ret_code);

  return $vals;
}

function remove_quotes($vals) {
  // Google quotes fields with internal commas.
  foreach ($vals as &$v) {
    $v = preg_replace('/\"\"/', '"', $v);
    if (preg_match("/^\".*\"$/", $v)) {
      $v = preg_replace('/^\"/', '', $v);
      $v = preg_replace('/\"$/', '', $v);
    }
  }

  return $vals;
}

function parse_csv($str) {
//TODO: step through fields and handle excaped or quoted fields with internal commas.  If one starts with a " or ' and includes a , before a closing " or ', combine with next.
  $vals = explode(",", $str);
  $vals = repair_csv($vals);
  $vals = remove_quotes($vals);
  return $vals;
}

?>