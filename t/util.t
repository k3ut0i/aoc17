# -*- mode: perl; cpel-indent-level: 4 -*-
use strict;
use warnings;
use Test::More;
use lib '../lib';

use_ok('AOCUtil');
use AOCUtil qw(set_diff);

my @s1 = (1, 2, 3, 4 , 5);
my @s2 = (3, 4, 5, 6, 7);
my @diff = AOCUtil::set_diff(\@s1, \@s2);
my @union = AOCUtil::set_union(\@s1, \@s2);

is_deeply(\@diff, [1, 2], "set_diff");
ok(AOCUtil::set_eq(\@union, [1, 2, 3, 4, 5, 6, 7]), "set_union {@s1} U {@s2} EQ {@union}");
#ok(\@{[AOCUtil::set_diff(\@diff, \@union)]}, [], "diff of union");

done_testing();
