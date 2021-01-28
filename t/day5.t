# -*- mode: perl -*-
use strict;
use warnings;
use Test::More;

use_ok('Day5');

my $a = [0, 3, 0, 1, -3];
my $i = 0; my $n = 0;
my @steps = (
	     [[0, 3, 0, 1, -3], 0],
	     [[1, 3, 0, 1, -3], 0],
	     [[2, 3, 0, 1, -3], 1],
	     [[2, 4, 0, 1, -3], 4],
	     [[2, 4, 0, 1, -2], 1],
	     [[2, 5, 0, 1, -2], 5]
	    );

while ($i < scalar @$a) {
  is_deeply($a, $steps[$n]->[0], "nth step: $n");
  $i = Day5::step_inst($a, $i, sub {$_[0]+1}); $n++;
}

my $a2 = [0, 3, 0, 1, -3];
my $i2 = 0; my $n2 = 0;
while ($i2 < scalar @$a2) {
  $i2 = Day5::step_inst($a2, $i2, sub {$_[0] >= 3 ? ($_[0]-1) : ($_[0]+1)});
  $n2++;
}
is($n2, 10, "part2 example, steps check");
is_deeply($a2, [2, 3, 2, 3, -1], "part2 example, offsets check");

done_testing();
