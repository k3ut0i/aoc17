# -*- mode: cperl; cperl-indent-level: 4 -*-
#!/usr/bin/perl
package Day7;

use strict;
use warnings;
use List::Util qw(all reduce);

sub parse_disc{
    my ($line) = @_;
    if ($line =~ m/(\w+) \((\d+)\)( -> (.*)|)/) {
	return (defined $4) ? [$1, int($2), [split(/,\s+/, $4)]] : [$1, int($2)];
    } else {
	die "Parse error: $line";
    }
}

sub find_root { #search for a node that does not have any parents
    my ($lines) = @_;
    my @nodes = map {parse_disc($_)} @$lines;
    my %network;
    for my $node (@nodes) {
	$network{$node->[0]} = {};
	%{$network{$node->[0]}} = map {$_ => 1} @{$node->[2]} if 3 == @$node;
    }
    my @node_names = keys %network;
    for my $node (@node_names) { # return a node with no parents
	return $node if 0 == grep {$network{$_}->{$node}} @node_names;
    }
}

#node datastructure, name => {weight => no, cumulative_weight => no, children => {...}}
sub create_network {
    my ($lines) = @_;
    my @node_data = map {parse_disc($_)} @$lines;
    my %network;
    for my $node (@node_data) {
	$network{$node->[0]} = {
				weight => $node->[1],
				cumulative_weight => $node->[1],
				children => undef,
				mark => 0
			       };
	%{$network{$node->[0]}->{children}} = map {$_ => undef} @{$node->[2]}
	  if defined $node->[2];
    }
    for my $node (keys %network) {
	if (!defined $network{$node}->{children}) {
	    $network{$node}->{mark} = 1;
	    $network{$node}->{cumulative_weight} = $network{$node}->{weight};
	};
    }
    my @nodes = keys %network;
    my @marked = grep {$network{$_}->{mark}} @nodes;

    until (@marked == 0+keys %network) { # all are marked
	for my $node (@marked) {
	    my @parents = grep { exists $network{$_}->{children}{$node}} @nodes;
	    for my $parent (@parents) {
		$network{$parent}->{children}{$node} = $network{$node};
		if (all {defined} values %{$network{$parent}->{children}}
		    and $network{$parent}->{mark} == 0){
		    $network{$parent}->{mark} = 1;
		    $network{$parent}->{cumulative_weight} +=
		      reduce {$a + $b}
		      (map {$network{$_}->{weight}} keys %{$network{$parent}->{children}})
		};
	    }
	}
	@marked = grep {$network{$_}->{mark}} @nodes;
    }
    my @roots = (); # Assumption that multiple root nodes might exist
    for my $node (@nodes) {
	my @parents = grep { exists $network{$_}->{children}{$node}} @nodes;
	push @roots, $node if @parents == 0;
    }

    return [\%network, \@roots];
}

sub write_network_graphviz {
    my ($network, $outfile) = @_;
    open my $fh, '>', $outfile or die "File Error $outfile: $!";
    print $fh "digraph day7network {\n";
    print $fh "node [shape=point]\nedge [arrowhead=none arrowtail=none]\n";
    my @nodes = keys %$network;
    for my $node (@nodes) {
	my @children = keys %{$network->{$node}{children}};
	for my $child (@children) {
	    print $fh "$node -> $child\n";
	}
    }
    print $fh "}\n";
    close $fh;
}

sub find_error_node {
    my ($network, $root) = @_;
    my $current_node = $root;
    # until () {
    # }
}
1;
