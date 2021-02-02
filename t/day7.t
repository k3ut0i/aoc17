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

my $ex_parsed = {
		 tknk => [41, {
			       ugml => [68, {
					     gyxo => [61],
					     ebii => [61],
					     jptl => [61],
					    }
				       ],
			       padx => [45, {
					     pbga => [66],
					     havc => [66],
					     qoya => [66],
					    }
				       ],
			       fwft => [72, {
					     ktlj => [57],
					     cntj => [57],
					     xhth => [57],
					    }
				       ]
			      }
			 ]
		};

is_deeply(Day7::parse_disc("pbga (66)"), ["pbga", 66], "parse test pbga");
is_deeply(Day7::parse_disc("fwft (72) -> ktlj, cntj, xhth"),
	  ["fwft", 72, ["ktlj", "cntj", "xhth"]], "parse test fwft");

my @lines = split(/\n/, $ex);
is(Day7::find_root(\@lines), 'tknk', 'root node using find_root');

my $network_root = Day7::create_network(\@lines);
print Dumper(%{$network_root->[0]}{$network_root->[1]->[0]});
my @roots = @{$network_root->[1]};
is(scalar @roots, 1, 'number of root nodes');
is($roots[0], 'tknk', 'root node using create_network');
# graphviz visual
# Day7::write_network_graphviz($network_roots->[0], '/tmp/day7graph');

done_testing();
