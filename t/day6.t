# -*- mode: perl -*-
use strict;
use warnings;
use Test::More;
use lib '../src';
use_ok('Day6');
# from (generate-random-num-list)
my @tests = ( # min and max indices
	     [[qw(2 1 0 6 7 7 4 2 9 9)], 2, 8],
	     [[qw(6 0 4 7 7 9 2 9 3 5)], 1, 5],
	     [[qw(3 4 6 9 8 3 5 5 1 0)], 9, 3],
	     [[qw(0 0 7 1 9 7 6 8 2 2)], 0, 4],
	    );

for (@tests) {
  my $min_idx = Day6::max_idx($_->[0], sub {$_[0] < $_[1]});
  my $max_idx = Day6::max_idx($_->[0], sub {$_[0] > $_[1]});
  my $list_str = join(',', @{$_->[0]}); # is this necessary?
  is($min_idx, $_->[1], "min of: $list_str");
  is($max_idx, $_->[2], "max of: $list_str");
}

my @ex_steps = (
		[0, 2, 7, 0],
		[2, 4, 1, 2],
		[3, 1, 2, 3],
		[0, 2, 3, 4],
		[1, 3, 4, 1],
		[2, 4, 1, 2],
	       );

my $state = [0, 2, 7, 0];
my $state_str = join(':', @$state);
my @seen; my $step_num = 0;
until (grep {/^$state_str$/} @seen) { # A HASH is better for @seen data. See notes.org
  push @seen, $state_str;
  is_deeply($ex_steps[$step_num], $state,
	    "step number: $step_num, state: $state_str");

  Day6::step_redist_x($state);
  $state_str = join(':', @$state);
  $step_num++;
}
is_deeply($ex_steps[$step_num], $state,
	  "Final state: $state_str, after $step_num steps");
done_testing();
