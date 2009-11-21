#!/usr/bin/php -q
<?php
/* Process Thingiverse's files
 1. Render different perspectives
 2. Find out whether it slices.
 3. If so, make available G-Code. Behold screenshot??

 */
$setting['stl_path'] = "/home/erik/RepRap/thingiverse/";
$setting['tmpfile'] = $setting['stl_path']."last.rss.xml";
$setting['cache_expires_in'] = 600 /*seconds*/;
$setting['thingiverse_rss_feed'] = "http://www.thingiverse.com/rss/newest";


if(!is_dir($setting['tmpfile']))
  @mkdir($setting['stl_path']);
chdir($setting['stl_path']);

if(!file_exists($setting['tmpfile']) || (time() - filemtime($setting['tmpfile'])) > $setting['cache_expires_in'])
{
  echo "Downloading XML data (RSS)...";
  $rss=file_get_contents($setting['thingiverse_rss_feed']);
  echo " done!\n";
  file_put_contents($setting['tmpfile'], $rss);
}
  else // use cached version of XML
{
  echo "Notice: Using cached version of RSS.\n";
  $rss = file_get_contents($setting['tmpfile']);
}

$xml = simplexml_load_string($rss);
$ns = $xml->getNamespaces(true);

if($xml->ErrorResponse)
  echo "Error in XML: ".$xml->ErrorResponse->Error->Message;

/*             [29] => SimpleXMLElement Object
                        (
                            [title] => Clamp On Cable Rack (w/ Snap Together Parts!)
                            [link] => http://www.thingiverse.com/thing:979
                            [description] => SimpleXMLElement Object
                                (
                                )

                            [author] => builttospec
                            [pubDate] => Mon, 07 Sep 2009 22:30:54 +0100
                            [guid] => http://www.thingiverse.com/thing:979
                            [enclosure] => SimpleXMLElement Object
                                (
                                    [@attributes] => Array
                                        (
                                            [url] => http://thingiverse_beta.s3.amazonaws.com/assets/ff/82/1c/02/59/Clamp_on_Cable_Rack.eps
                                            [length] => 93661
                                            [type] => application/postscript
                                        )

                                )
*/




foreach ($xml->channel->item as $item)
{
  $dir = $setting['stl_path'].'/'.$item->title;
  @mkdir($dir);

  echo "Thing: ".$item->title."\n";
  print_r($item);
if(isset($item->enclosure))
  foreach($item->enclosure as $file)
  {
    echo "  File: ".print_r($file,true)."\n";
    $fname = basename($file['url']);
    if(!file_exists($dir.'/'.$fname))
      passthru('wget --continue -O '.escapeshellarg($dir.'/'.$fname).' '.escapeshellarg($file['url'])."\n");
    file_put_contents("$dir/".$fname.".skein.sh","runskeinforge.sh \$PWD/$fname");  
    echo("chmod +x -- ".escapeshellarg($dir.'/'.$fname.'.skein.sh'));
    shell_exec("chmod +x -- ".escapeshellarg($dir.'/'.$fname.'.skein.sh'));
  }
}
?>


