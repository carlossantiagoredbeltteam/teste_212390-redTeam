<?php
//  Animations: http://www.f-lohmueller.de/pov_tut/animate/anim12e.htm
?>
<html>
<head>
</head>
<body>
<?php
$code = <<< EOT
<div class="stl2web" id="stl2web1" type="camera.rotate(360)" fps="5">
<script src="http://counter.reprap.org/stl2web/jquery.js"></script>
<script src="http://counter.reprap.org/stl2web/stl2web.js"></script>
EOT;

echo "\nEmbed this: <textarea>".htmlentities($code,ENT_NOQUOTES)."</textarea>";
echo $code;

?>
Look at the discussion here:
<a href=""></a>
</body>
