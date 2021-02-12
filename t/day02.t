# -*- mode: perl -*-
use strict;
use warnings;

use Test::More;

use lib '../src';

use Day2;

my @test1 = (
	     [[5, 1, 9, 5], 8],
	     [[7, 5, 3], 4],
	     [[2, 4, 6, 8], 6],
	    );

for my $t (@test1){
  is(Day2::checksum($t->[0]), $t->[1],
     'test ' . join(' ', @{$t->[0]}));
}

my @test2 = (
	     [[5, 9, 2, 8], 4],
	     [[9, 4, 7, 3], 3],
	     [[3, 8, 6, 5], 2]
	    );

for my $t (@test2){
  is(Day2::checksum_div($t->[0]), $t->[1],
     'test ' . join(' ', @{$t->[0]}))
}

done_testing();
