#!/usr/bin/perl

$failed = 0;

sub test {
    my $name = shift;
    my $case = shift;
    my $after = shift;
    my $action = shift;
    my $val = shift;
    my $exit = shift;
    print "Testing $name\n";
    system("./master $after $action $val $exit > tmp/$case.out");
    my $res = system("cmp -s tmp/$case.out tests/$case.out");
    if ($res != 0) {
	print STDERR "Failed $name\n";
	$failed = 1;
    }
}

test("Clean test", 1, 0, 0, 0, 50);
test("Data error", 2, 12, 1, 255, 50);
test("Header error", 3, 8, 1, 1, 60);
test("Length error", 4, 9, 1, 2, 60);

exit($failed);
