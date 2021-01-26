# -*- mode: perl -*-
use strict;
use warnings;
use Test::More;

use lib '../src';
use Day3;

my @tests1 = (
	      [1, 0],
	      [12, 3],
	      [23, 2],
	      [1024, 31],
	     );

for my $t (@tests1) {
  is(Day3::getdis($t->[0]), $t->[1], "test: $t->[0]");
}

my @xy_map_n_tests =
  (
   [[2, 2], 13],
   [[-1, -2], 22],
   [[1, -1], 9],
   [[2, -2], 25]
  );

for my $t (@xy_map_n_tests) {
  is(Day3::xy_to_n(@{$t->[0]}), $t->[1],
     "test xy -> n : $t->[1]");
  is_deeply(Day3::n_to_xy($t->[1]), $t->[0],
	    "test n -> xy: $t->[1]");
}

for (1..100) { # idempotency of the transformation
  my $pos = Day3::n_to_xy($_);
  is($_, Day3::xy_to_n(@{$pos}), "test continuous: $_");
}
done_testing();
