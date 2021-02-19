# -*- mode: cperl; cperl-indent-level: 4 -*-
use strict;
use warnings;
use Test::More;
use Data::Dumper;
use List::Util qw(uniq);
use_ok('Day12');

my @data = split /\n/, <<END;
0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5
END

my %network = (
	       0 => [2],
	       1 => [1],
	       2 => [0, 3, 4],
	       3 => [2, 4],
	       4 => [2, 3, 6],
	       5 => [6],
	       6 => [4, 5],
	      );
is(@data, 7, 'data size');
my $n = Day12::create_network(\@data);
is_deeply($n, \%network, 'example network');
Day12::transitive_closure($n);
# print Dumper($n);
is(scalar @{$n->{0}}, 6, 'connections to node 0');
my $roots = Day12::trees($n); # after transitive closure;
is(uniq (values %$roots), 2, 'number of roots');
done_testing();
