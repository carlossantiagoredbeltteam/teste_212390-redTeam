#!/usr/bin/php -q
<?php
// By Erik de Bruijn <reprap@erikdebruijn.nl>
// Description: this script will parse a G-Code file and reformat it to work with the newer RepRap G-Code interpreter firmware.
// Licence: GPL
/* Changelog:
 * 0.5 Erik		14/07/09	Software anti-backlash (TODO: differentiate between dynamic and static friction)
 * 0.6 Erik		15/07/09	Output to file --output_file filename.gcode Default: out-5D.gcode
 * 0.7 Erik		19/07/09	Condition based actions (change lines based on a list of criteria).
 * 0.8 Erik		20/07/09	Added start and stop conditions in addition to 'while'.
 * 0.9 Erik		11/08/09	Possibly fixed non-incremental extrusion mode. Needs testing though. Siert, tnx for bug report.
 */
ini_set('memory_limit','128M');

$version = 0.9;
out("\n( Modified by 3D-to-5D-Gcode v$version on ".date("c").')');
// Settings:

$setting['prepend_gcode'] = "";  // begin with this Gcode
$setting['append_gcode'] = "G91\nG1 Z4F100\nG90\nM104S200";  // add this Gcode at the end
$setting['extrusion_adjust'] = 1.5;  // factor to adjust extruded distances with
$setting['extrude_incremental'] = 1;  // E values are incremental. Better for making small adjustments
//$setting['replace_ereg'] = array('F330.0[^0-9]'=>'F1320.0');  // 
$setting['replace_strings'] = array(
	//'F330.0'=>'F1320.0', // hugely speed up the raft-making
	//'F330.0'=>'F430.0', // moderately speed up the raft-making
);  // 
$setting['actions'] = array(
	array('while'=>array('match','F330.0'),'actions'=>array('E_mul'=>6,'F_mul'=>0.7)), // raft making: slow down XY-moves, speed up extrusion.
	array('while'=>array('match','F1320.0'),'actions'=>array('E_mul'=>2.2,'F_mul'=>0.8)), // raft making: slow down XY-moves, speed up extrusion.
/*
	array( // raft making: slow down XY-moves, speed up extrusion. Does the same as the above if the raft is set for feedrate 330.0 in skeinforge. This might be more reliable though...
          'condition_start'=>array('match','<layer> 0.5'), // set it to match the foundation layer of your raft.
          'condition_stop'=>array('match','</layer>'),
          'actions'=>array('E_mul'=>15,'F_mul'=>0.75)
        ),
	array( // raft making: the same, but now for interface layer
          'condition_start'=>array('match','<layer> 0.86'), // set it to match the foundation layer of your raft.
          'condition_stop'=>array('match','</layer>'),
          'actions'=>array('E_mul'=>4,'F_mul'=>0.8)
        ),
*/

);
$setting['remove_comments'] = true;  // Set true/false to remove comments from input file or not.
$setting['soften_z_move_factor'] = 0.4;  // this slows down the move in the Z direction to this speed
$setting['anti-backlash'] = array(
	'X'=>array('fwd_dynamic'=>0.20/*mm*/, 'rev_dynamic'=>0.20/*mm*/,'fwd_static'=>0.1/*mm*/, 'rev_static'=>0.1/*mm*/ ), // Backlash on X-axis
	'Y'=>array('fwd_dynamic'=>0.45/*mm*/, 'rev_dynamic'=>0.45/*mm*/,'fwd_static'=>0.1/*mm*/, 'rev_static'=>0.1/*mm*/ ), // Backlash on Y-axis
);
$setting['output_file'] = 'out-5D.gcode'; // null = output directly.

$settings_file = $_SERVER['HOME']."/.reprap/3D-to-5D.settings";
if(file_exists($settings_file))
  $setting = ini_get($settings_file);
else 
  out("\n( Warning: no settings file found in $settings_file using only defaults.)");
// explain defaults
foreach($setting as $sName => $sVal)
{
   $sVal = str_replace("\n"," \\n ",$sVal);
   out("\n( $sName = $sVal )");
  if($aKey = array_search("--".$sName,$argv))
  {
    out("\n( Cmdline override of setting: $sName ".$argv[($aKey+1)].')');
    $setting[$sName] = $argv[$aKey+1];
  }

}


$conditionOk = false;

// The *OLD*, 3D (lame!) way:
// M108S200 ; extruder motor speed at 200 PWM
// M101 ; extruder motor forward
// G1 ... ; make your moves...

// *NEW*, Now 5 Dimensionally!
// G1 X0.0 Y0.0 Z0.0
// G1 X1.0 Y1.0 E1.4142 ; Extrude the pythagorian distance (X^2+Y^2)^.5. Assuming just XY plain (2D) moves...
//
if($argv[1])
  $fName = $argv[1];
else 
  die("\nUsage: ".basename($argv[0])." foo.gcode [--setting-name setting-value] [--output_file filename.gcode]\n");

bcscale(4);
$lines = file($fName); // ugly mem-sucker... I know. When I have files that are too big I'll improve this ;) 
// if you fix it, please e-mail the update.

// Defaults: (check your firmware!)
$abs = false;
$X = $Y = $Z = "0.0";
$lastX = $lastY = $lastZ = "0.0";
$dist = 0;
$extruder_starting = false;

out($setting['prepend_gcode']);
out("\nG92 E0 \n");
//out("\nG92 E0 ( reset extruder home pos)\n");

foreach($lines as $line)
{
  // Remove original comments
  if($setting['remove_comments']==true)
  { 
    if($line{0}==';') continue;
    if($line{0}=='\'') continue;
    if($line{0}=='(') continue;
  }
  #ereg("[GMEXYZFS]{1

  $comment = '';

  if(ereg("M[ ]*108[ ]S([0-9.]+)",$line,$regs))
  {
    $line = trim($line)." ; fw/bck/off";
    $speed = $regs[1];
    out("(".trim($line).")\n");
    continue;
  }
  // Store previous coordinates
  $lastX = $X;
  $lastY = $Y;
  $lastZ = $Z;

  if(ereg("X[ ]*(-?[0-9.]+)",$line,$regs))
    $X = $regs[1];
  if(ereg("Y[ ]*(-?[0-9.]+)",$line,$regs))
    $Y = $regs[1];
  if(ereg("Z[ ]*(-?[0-9.]+)",$line,$regs))
    $Z = $regs[1];

  if(ereg("M[ ]*10([123])",$line,$regs))
  {
    switch($regs[1])
    {
      case "1":
        $dir = 1;
        $extruder_starting = true;
        // When starting extrusion, E = 0?
      break;
      case "2";
        $dir = -1;
      break;
      case "3":
        $dir = 0;
      break;
    }
    //$comment .= " dir $dir";
    //out("(".trim($line).")\n");
    continue; // Assuming that M codes are always on a single line... skip this
  }
  if(ereg("G[ ]*90",$line))
    $abs = true;
  if(ereg("G[ ]*91",$line))
    $abs = false;
  // G20 - inches, G21 - mm
  unset($E);
  $comment .= sprintf("dXY=%.2f,%.2f ",$dX,$dY)." lastXY= ".sprintf("%.2f,%.2f",$lastX,$lastY);
  if($abs)
  {
/*    $dX=bcsub($X,$lastX);
    $dY=bcsub($Y,$lastY);
    $dZ=bcsub($Z,$lastZ);
*/
    $dX=(1.0*$X-$lastX);
    $dY=(1.0*$Y-$lastY);
    $dZ=(1.0*$Z-$lastZ);
 
  } else
  {
    $dX=$X;
    $dY=$Y;
    $dZ=$Z;
  }
    $dist2 = bcsqrt(bcadd(bcpow($dX,2),bcpow($dY,2)));
    if($setting['extrude_incremental'] != 1)
      $dist = bcadd($dist,$dist2);
    else
      $dist = $dist2;
    $comment .= "( dist=sqrt($dX^2+$dY^2)=".bcpow($dX,2).'+'.bcpow($dY,2).'= '.sprintf("%.2f",$dist).')';
  if($dir!=0) 
    $E = bcmul($setting['extrusion_adjust'],$dist);

  // Only when cartesian coordinates are used???
  //if(ereg("[^;(].*[XYZ])",$line,$regs))
  //{}

  $line = trim($line);
  if(($extruder_starting) && ($setting['extrude_incremental'] == 1)) // FIXME: Needs testing. Does the non-incremental work now?
  {
    $line .= " E0";
    $dist = 0;
    $extruder_starting = false;
  }
  if($dZ>0.1)
  {
    // Smooth-Z:
    if($setting['soften_z_move_factor'])
    {
      if(ereg("F([0-9\.]+)",$line,$regs))
      {
        $newF = bcmul($setting['soften_z_move_factor'],$regs[1]);
        if($setting['debug'])
          out("(Smooth-Z dZ > 0.1 F=$regs[1], newF=$newF)\n");
        $line = ereg_replace("F[0-9\.]+","F$newF",$line);
      }
    }//end if smooth
  }
  elseif($E)
    $line .= " E".sprintf("%.2f",bcmul($E,$dir)); // number w/ four decimals

  // Anti-backlash:
  if(is_array($setting['anti-backlash']))
  {
    foreach($setting['anti-backlash'] as $thisAxis => $backlash)
    { //'Y'=>array('fwd_dynamic'=>0.1/*mm*/, 'rev_dynamic'=>0.1/*mm*/,'fwd_static'=>0.1/*mm*/, 'rev_static'=>0.1/*mm*/ ), // Backlash on Y-axis
      extract($backlash);
      if($thisAxis == 'X')
      {
	$axisPos = $X;
        $axisDelta = $dX;

      }
 
      if($thisAxis == 'Y')
      {
	$axisPos = $Y;
        $axisDelta = $dY;
      }
      $newAxisPos = $axisPos;
      if($axisDelta > 0)
        $newAxisPos = bcadd($axisPos,$fwd_dynamic);
      elseif($axisDelta < 0)
        $newAxisPos = bcsub($axisPos,$rev_dynamic);
      // maintain once previous backlash compensation if axis didn't move. After that compensation will be removed (!?)
      elseif($lastDelta[$thisAxis] > 0)
        $newAxisPos = bcadd($axisPos,$fwd_dynamic);
      elseif($lastDelta[$thisAxis] < 0)
        $newAxisPos = bcsub($axisPos,$rev_dynamic);

      //$lastDelta[$thisAxis] = $axisDelta; //not used???
      $line = str_replace("$thisAxis$axisPos","$thisAxis$newAxisPos",$line);
      //out("(AntiBacklash d$thisAxis=$axisDelta: $thisAxis$axisPos now $newAxisPos)\n");
    }
  }

  // Replace feedrate:
  foreach($setting['replace_strings'] as $oldRate=>$newRate)
  {
    $line = str_replace("$oldRate","$newRate",$line);
  }

  // Actions:
  $orrigLine = $line;
  foreach($setting['actions'] as $action)
  { //array('condition'=>array('match','F330.0'),'actions'=>array('E_mul'=>2,'F_mul'=>0.5)), // raft making: slow down XY-moves, speed up extrusion.
    // conditions:
    // Implemented: match a string. To implement: match a Z-layer, < > or =.?
    if($action['while'][0]=='match')
    {
      if(isset($action['while']))
        $conditionOk = false;
      if(strpos($orrigLine,$action['while'][1]))
      {
        //echo "(line matches $action[condition]";
        $conditionOk = true;
      }
    } // I know, this is not coded in a very elegant way... EdB
    if(($action['condition_start'][0]=='match') && (strpos($orrigLine,$action['condition_start'][1])))
      $conditionOk = true;
    if(($action['condition_stop'][0]=='match') && (strpos($orrigLine,$action['condition_stop'][1])))
      $conditionOk = false;


    if($conditionOk)
    {
	    foreach($action['actions'] as $actParam => $actVal)
	    {// Todo: eval expressions?
	    //echo "Condit: $conditionOk";
	      if(ereg('([XYZFE])_mul',$actParam,$regs))
	      {
		$actOnAxis=$regs[1];
		if(ereg("$actOnAxis([0-9\.]+)",$orrigLine,$regs2)) // eval action against original line?
		{
		  $newRate = bcmul($regs2[1],$actVal);
		  $line = str_replace("$regs2[1]","$newRate",$line);
		}
	      }

	    }
    }
  }
  
  out($line);
  if($E > 999)
  {
    out("\nG92 E0 ( set extruder home )");
    $dist = 0;
  }

 //out(" ; ".$comment);
  out("\n");
  //

} // end foreach line

out($setting['append_gcode']);
/*

$fp = fopen($fName,'r');
if(!$fp) die("File $argv[0] could not be opened.");

$go = true;
while($go)
{
if(!strpos($str,"\n"))
{
  $str .= fgets($fp,128);
}
else
{
  $lines = split("\n",$str);
  out($str);
}  
}
*/
function out($str) // TODO: writer class
{
  global $setting;
  if($setting['output_file'] == null)
  {
    echo($str);
  } 
  else 
  {
    if(!isset($setting['firstline']))
    {
      file_put_contents($setting['output_file'],$str);
      $setting['firstline'] = false;
    }
    else
      file_put_contents($setting['output_file'],$str,FILE_APPEND);
  }
}
?>
