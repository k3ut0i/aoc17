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
TODO: {
  local $TODO = 'parse_network buggy';
  is_deeply(Day7::parse_network(\@lines), $ex_parsed);
}
#print Dumper(Day7::parse_network(\@lines));
my %network = %{Day7::parse_network(\@lines)};
my $max_node;my $max_rank=-1;
for my $node (keys %network) {
  my $rank = $network{$node}->[1];
  if ($rank > $max_rank) {
    $max_rank = $rank;
    $max_node = $node;
  }
}
is($max_node, 'tknk', 'root node name');
is($max_rank, 2, 'root node rank');

done_testing();
