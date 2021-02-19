# -*- mode: cperl; cperl-indent-level: 4 -*-
use strict;
use warnings;
use Test::More;
use Clone qw(clone);

use_ok('Day13');
my $test_lines = <<END;
0: 3
1: 2
4: 4
6: 4
END

my %depth = (0 => 3,
	     1 => 2,
	     4 => 4,
	     6 => 4);

for my $line (split /\n/, $test_lines) {
    my ($l, $d) = Day13::parse_line($line);
    is($depth{$l}, $d, "Depth of layer $l");
}

my %init_state = (0 => {scanner => 0, depth => 3, direction => 1},
		  1 => {scanner => 0, depth => 2, direction => 1},
		  4 => {scanner => 0, depth => 4, direction => 1},
		  6 => {scanner => 0, depth => 4, direction => 1});

my %final_state = (0 => {scanner => 1, depth => 3, direction => -1},
		   1 => {scanner => 1, depth => 2, direction => 1},
		   4 => {scanner => 1, depth => 4, direction => 1},
		   6 => {scanner => 1, depth => 4, direction => 1});

is_deeply(Day13::read_init_state([split /\n/, $test_lines]),
	  \%init_state, "Initial state parse");
my $state = clone(\%init_state);
is_deeply(Day13::simulate_part1($state), {0 => 1, 6 => 1}, "Caught places");
is_deeply($state, \%final_state, "Full simulation");
is(Day13::find_delay(\%init_state), 10, 'Delay to escape firewall');
done_testing();
