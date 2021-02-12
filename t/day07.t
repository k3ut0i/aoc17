# -*- mode: cperl -*-
use strict;
use warnings;
use Test::More;
use Data::Dumper;

use_ok('Day7');

my $ex=<<EOF;
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
EOF
;

is_deeply(Day7::parse_disc("pbga (66)"), ["pbga", 66], "parse test pbga");
is_deeply(Day7::parse_disc("fwft (72) -> ktlj, cntj, xhth"),
	  ["fwft", 72, ["ktlj", "cntj", "xhth"]], "parse test fwft");

my @lines = split(/\n/, $ex);
is(Day7::find_root(\@lines), 'tknk', 'root node using find_root');

my ($network, $roots) = Day7::create_network(\@lines);
# print Dumper($network);
is(scalar @$roots, 1, 'number of root nodes');
is($roots->[0], 'tknk', 'root node using create_network');
# for graphviz visuals
# Day7::write_network_graphviz($network_roots->[0], '/tmp/day7graph');
my ($error_node, $error_weight) = Day7::find_error_node($network,
							$roots->[0]);
is($error_node, 'ugml', "error node name");
is($error_weight, 8, "error node weight correction");

done_testing();
