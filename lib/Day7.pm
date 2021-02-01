# -*- mode: cperl; cperl-indent-level: 4 -*-
#!/usr/bin/perl
package Day7;

use strict;
use warnings;

sub parse_disc{
    my ($line) = @_;
    if ($line =~ m/(\w+) \((\d+)\)( -> (.*)|)/) {
	return (defined $4) ? [$1, int($2), [split(/,\s+/, $4)]] : [$1, int($2)];
    } else {
	die "Parse error: $line";
    }
}

#node datastructure, name => [rank, weight, @children]
sub parse_network{
    my ($lines) = @_;
    my @nodes = map { parse_disc($_) } @$lines;
    my %node_list;
    for my $node (@nodes) {	# bare nodes, with leaves ranked
	my $name = $node->[0];
	my $weight = $node->[1];
	if (2 < @$node) {
	    my $children = $node->[2];
	    $node_list{$node->[0]} = [$weight, undef, $children];
	} else {
	    $node_list{$node->[0]} = [$weight, 0, undef];
	}
    }
    my @node_names = keys %node_list;
    my $unranked = grep {!defined $node_list{$_}->[1]} @node_names;
    until ($unranked == 0) {
	for my $node (@node_names) {
	    my $rank = $node_list{$node}->[1];
	    my @parents = grep {grep(/^$node$/,@{$node_list{$_}->[2]})} @node_names;
	    for my $parent (@parents) {
		$node_list{$parent}->[1] = $rank+1 if defined $rank;
	    }
	}
	$unranked = grep {!defined $node_list{$_}->[1]} @node_names;
    }
    return \%node_list;
}
;

1;
