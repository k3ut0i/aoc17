# -*- mode: perl; cpel-indent-level: 4 -*-
use strict;
use warnings;
use Test::More;

use_ok('Day14');

my $test_key = "flqrgnkx";

is(Day14::direct_calc($test_key), 8108,
   "direct calc of one squares for the key $test_key");

my ($ones, $clusters) = Day14::full_sim($test_key);
is($ones, 8108, "full sim calc of one squares for the key $test_key");
is($clusters, 1242, "full sim calc of clusters for the key $test_key");

done_testing();
