# -*- mode: perl -*-
use strict;
use warnings;
use Test::More;

use_ok('Day10');

my @steps = ( # 0 1 2 3 4 with lengths 3, 4, 1, 5
	     [[2, 1, 0, 3, 4], 3, 1],
	     [[4, 3, 0, 1, 2], 3, 2],
	     [[4, 3, 0, 1, 2], 1, 3],
	     [[3, 4, 2, 1, 0], 4, 4],
	    );

my $step_n = 0; my $a = [0, 1, 2, 3, 4]; my $pos = 0; my $skip = 0;
for my $len (3, 4, 1, 5) {
  my ($a_e, $pos_e, $skip_e) = @{$steps[$step_n]};
  ($a, $pos, $skip) = Day10::step_sim($a, $pos, $skip, $len);
  is_deeply($a, $a_e, "simulation: $step_n elements");
  is($pos, $pos_e, "simulation: $step_n pos");
  is($skip, $skip_e, "simulation: $step_n skip");
  $step_n++;
}

is_deeply(Day10::getseq('1,2,3'), [49,44,50,44,51,17,31,73,47,23],
	  'getseq example');
is_deeply(Day10::sparse2dense([65,27,9,1,4,3,40,50,91,7,6,0,2,5,68,22]),
	  '40', 'dense hash reduction example');
is(Day10::densehash(''), 'a2582a3a0e66e6e86e3812dcb672a272',
   'densehash: ""');
is(Day10::densehash('AoC 2017'), '33efeb34ea91902bb2f59c9920caa6cd',
   'densehash: "AoC 2017"');
is(Day10::densehash('1,2,3'),'3efbe78a8d82f29979031a4aa0b16a9d',
   'densehash: "1,2,3"');
is(Day10::densehash('1,2,4'), '63960835bcdc130f0b66d7ff4f6a5a8e',
   'densehash: "1,2,4"');


done_testing();
