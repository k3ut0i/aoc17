# -*- mode: cperl; cperl-indent-level: 4 -*-
use strict;
use warnings;
use Test::More skip_all => 'too much work to get the direction for all cases';

use_ok('Day11');

my %tests = (
	     "ne,ne,ne" => 3,
	     "ne,ne,sw,sw" => 0,
	     "ne,ne,s,s" => 2, # TODO: Somehow missing this test case.
	     "se,sw,se,sw,sw" => 3
	    );

for my $t (keys %tests) {
    is(Day11::distance($t), $tests{$t}, "distance: $t");
}
