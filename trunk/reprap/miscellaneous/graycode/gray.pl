#!/usr/bin/perl

use strict;

########################################

my $bits = 2;
my $dimension_mm = 40;      # outer diameter (mm)
my $innerdimension_mm = 20;  # inner diameter (mm)
my $strutsize_mm = 2;        # strut thickness (mm)
my $axialdimension_mm = 6;   # centre axis/axle size (mm)
my $span = 360;   # degrees
my $stagger_mm = 0;  # stagger distance between sensor centres (approx mm)
my $filebase = "test";
my $template = 1;  # 0 or 1: generate sensor placement template (over mid item)
my $bitmapresolution = 300;  # resolution for bitmaps (dpi)
my $portion = 1;  # fraction of top left corner to include
my $reps = 2;   # Number of times to repeat pattern around object

my $fillcentre = 1;
my $do_bitmap = 1;
my $do_stl = 0;

########################################

my $pi = 3.1415926535897932384626;
my ($dimension, $innerdimension, $strutsize, $axialdimension, $stagger);
my $maxval = 1 << $bits;

$axialdimension /= 2;  # we want radius

sub scale
{
    my $size = shift;
    return $bitmapresolution * $size / 25.4;
}

sub gray
{
    my $val = shift;
    return $val ^ ($val >> 1);
}

sub bin
{
    my($val, $width, $b, $i, $res);
    ($val, $width) = @_;
    for($b = 1; $i < $width; $i++) {
	if ($val & $b) {
	    $res = "1" . $res;
	} else {
	    $res = "0" . $res;
	}
	$b <<= 1;
    }
    return $res;
}

sub near
{
    my($v, $target);
    ($v, $target) = @_;
    if ($v > $target - 0.01 && $v < $target + 0.01) {
	return 1;
    } else {
	return 0;
    }
}

sub atan2r
{
    my($x, $y);
    ($x, $y) = @_;
    my $res = atan2($x, $y);
#    $res -= $pi / 2;
#    $res -= 2 * $pi if ($res > $pi);
    return $res;
}

sub generate_bitmap
{
    my($x, $y);
    my($xc, $yc, $theta, $grad, $r, $i);
    my(@grays);

    if ($template) {
	open(TOUT, "| ppmtogif > $filebase-cut.gif") || die;
	print TOUT "P1\n" . int($dimension*$portion) . " " .
	    int($dimension*$portion) . "\n";
    }

    open(OUT, "| ppmtogif > $filebase-out.gif") || die;
    print OUT "P1\n" . int($dimension*$portion) . " " .
	int($dimension*$portion) . "\n";

    for($i = 0; $i < $maxval; $i++) {
	$grays[$i] = bin(gray($i), $bits);
    }

    my($pixel, $tpixel);
    my ($g0,$g1);
    for($y = 0; $y < int($dimension * $portion); $y++) {
	$yc = $y - ($dimension >> 1);
	for($x = 0; $x < int($dimension * $portion); $x++) {
	    $xc = $x - ($dimension >> 1);
	    if ($xc == 0 && $yc < 0) {
		$grad = 0;
	    } else {
		$grad = (atan2r($xc, $yc) + $pi) / (2.0 * $pi);  # in grads
	    }
	    $g0 = $grad;

	    $grad *= $reps * 360 / $span;
	    $grad -= int($grad);
	    $grad += 1 if ($grad < 0);

	    $g1 = $grad;

	    $r = sqrt($xc * $xc + $yc * $yc);

	    if ($r >= $innerdimension / 2 && $r <= $dimension / 2) {
		my $b = $bits * 2 * ($r - $innerdimension/2) /
		    ($dimension-$innerdimension);
		$b-- if ($b == $bits);
		$b = int($b);
		
		my $edge_radius =
		    ($b * $dimension - $b * $innerdimension
		     + $bits * $innerdimension) / (2 * $bits);
		
		#print "$r, $b, $edge_radius\n";
		
		$grad += $stagger * $b * 360 /
		    ($span * sqrt($edge_radius) * 120);

		if ($grad > 360 / $span) {
		    $grad -= 360 / $span;
		}
	    }

	    $theta = $maxval * $grad;
	    #print "$theta\n";
	    $theta = int($theta);

	    #$theta -= $maxval if ($theta >= $maxval);
		
	    #$theta &= ($maxval-1) if ($span == 360);
	    $pixel = "0";
	    $tpixel = "0";
	    if ($theta >= 0 && $theta < $maxval) {
		if ($r >= $innerdimension / 2 && $r <= $dimension / 2) {
		    my $b = $bits * 2 * ($r - $innerdimension/2) /
			($dimension-$innerdimension);
		    $b-- if ($b == $bits);
		    $b = int($b);

		    my $strut0 = ($b + 1) *
			($dimension/2 - $innerdimension/2) / $bits +
			$innerdimension / 2;
		    $pixel = 1 if ($r > $strut0 - $strutsize && $r <= $strut0);

		    #print "$theta $b " . $grays[$theta] . "\n";
		    if (substr($grays[$theta], $b, 1) == 1) {
			$pixel = 1;
		    }
		    $tpixel = 1 if ($theta == 0);
		    #print "$y, $x, $yc, $xc, " . atan2($xc,$yc) .
			#", g0=$g0, g1=$g1, grad=$grad, $theta\n";
		}
	    }
	    if ($fillcentre && $r < $innerdimension / 2 && $r >= $axialdimension) {
		$pixel = 1;
	    }
	    if ($r < $axialdimension && $r > 0.9 * $axialdimension) {
		$pixel = 1;
		$tpixel = 1;
	    }
	    if ($r < $axialdimension && (
		  near($grad*$span/360,0) ||
		  near($grad*$span/360,0.25) ||
		  near($grad*$span/360,0.5) ||
		  near($grad*$span/360,0.75) ||
		  near($grad*$span/360,1))) {
		$pixel = 1;
		$tpixel = 1;
	    }
	    print OUT $pixel;
	    print TOUT $tpixel if ($template);
	}
    }
    close(OUT);
    close(TOUT) if ($template);
}

sub stl_facet {
    #my($norm_x, $norm_y, $norm_z,
    #   $v1_x, $v1_y, $v1_z,
    #   $v2_x, $v2_y, $v2_z,
    #   $v3_x, $v3_y, $v3_z);
    my $colour = 0;

    print OUT pack("f12S", @_, $colour);
}

# Create a 2D triangular pattern
# And convert to STL, adding depth
sub generate_stl
{
    open(OUT, "> $filebase-out.stl");

    my $title = 'Graycode Wheel';
    my $facets = 8;

    my($norm_x, $norm_y, $norm_z,
       $v1_x, $v1_y, $v1_z,
       $v2_x, $v2_y, $v2_z,
       $v3_x, $v3_y, $v3_z);

    print OUT pack("A80L", $title, $facets);

    stl_facet(-1, 0, 0,
	       0, 1, 0,
	       0, 0, 0,
	       0, 1, 1);
    stl_facet(-1, 0, 0,
	       0, 0, 0,
	       0, 0, 1,
	       0, 1, 1);
    stl_facet( 0, 0,-1,
	       1, 0, 0,
	       0, 0, 0,
	       1, 1, 0);
    stl_facet( 0, 0,-1,
	       0, 0, 0,
	       0, 1, 0,
	       1, 1, 0);
    stl_facet( 0,-1, 0,
	       0, 0, 1,
	       0, 0, 0,
	       1, 0, 0);

    stl_facet( 0.707107, 0, 0.707107,
	       1, 0, 0,
	       1, 1, 0,
	       0, 0, 1);
    stl_facet( 0, 1, 0,
	       0, 1, 1,
	       1, 1, 0,
	       0, 1, 0);
    stl_facet( 0.707107, 0, 0.707107,
	       1, 1, 0,
	       0, 1, 1,
	       0, 0, 1);

    close(OUT);
}

# Calculate absolute pixel sizes for bitmaps
$dimension = scale($dimension_mm);
$innerdimension = scale($innerdimension_mm);
$strutsize = scale($strutsize_mm);
$axialdimension = scale($axialdimension_mm);
$stagger = scale($stagger_mm);

generate_bitmap if ($do_bitmap);
generate_stl if ($do_stl);
