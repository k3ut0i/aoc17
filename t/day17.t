# -*- mode: perl; cpel-indent-level: 4 -*-
use strict;
use warnings;
use Test::More;
use_ok('Day17');
use lib '../lib';
use Day17;

my @a = ([0],
	 [0, 1],
	 [0, 2, 1],
	 [0, 2, 3, 1],
	 [0,  2, 4, 3,  1],
	 [0, 5, 2,  4,  3,  1],
	 [0,  5, 2, 4,  3, 6, 1],
	 [0,  5, 7, 2,,  4,  3,  6,  1],
	 [0,  5,  7,  2,  4,  3, 8, 6,  1],
	 [0, 9, 5,  7,  2,  4,  3,  8,  6,  1]
	);

my $eg = {array => [0],
	  pos => 0,
	  length => 1,
	  skip => 3};

for (0..@a-1) {
  is_deeply($a[$_], $eg->{array}, "step $_ of sim");
  step($eg);
}

for (10..2016) {
  step($eg);
}

my @around_2017 = @{$eg->{array}}[$eg->{pos}-3..$eg->{pos}+3];

# {
#   local $, = ' ';
#   print @around_2017, "\n";
# }
is_deeply([1512, 1134, 151, 2017, 638, 1513, 851],
	  [@around_2017],
	   "after 2017");

is(value_after(3, 2017), 638, "value after test");
is(find_idx_pos(3, 9, 1), 9, "value after 0 in eg");
done_testing();
