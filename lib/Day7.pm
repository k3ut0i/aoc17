# -*- mode: cperl; cperl-indent-level: 4 -*-
#!/usr/bin/perl
package Day7;

use strict;
use warnings;
use List::Util qw(all reduce uniqint);

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
		      (map {$network{$_}->{cumulative_weight}} keys %{$network{$parent}->{children}})
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

    return (\%network, \@roots);
}

sub write_network_graphviz {
    my ($network, $outfile, $highlight_nodes) = @_;
    open my $fh, '>', $outfile or die "File Error $outfile: $!";
    print $fh "digraph day7network {\n";
    print $fh "node [shape=point]\nedge [arrowhead=none arrowtail=none]\n";
    for (@$highlight_nodes) {
	print $fh "$_ [color=red]\n";
    }
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

sub find_error_node { # error node, and weight to be decreased
    my ($network, $root) = @_;
    my $current_node = $root;
    my $sibling_weight = undef;
    while (1) {
	my @children = keys %{$network->{$current_node}{children}};
	my @weights = uniqint map {$network->{$_}{cumulative_weight}} @children;
	return ($current_node,
		$network->{$current_node}{cumulative_weight} - $sibling_weight)
	  if @weights == 1;
	warn "Node: $current_node has @weights different weights"
	  and return if @weights > 2;
	my ($w1, $w2) = @weights;
	my (@w1_nodes, @w2_nodes);
	for my $child (@children) {
	    if ($network->{$child}{cumulative_weight} == $w1) {
		push @w1_nodes, $child;
	    } else {
		push @w2_nodes, $child
	    }
	}
	if (@w1_nodes == 1) {
	    ($current_node) = @w1_nodes;
	    $sibling_weight = $w2;
	} elsif (@w2_nodes == 1) {
	    ($current_node) = @w2_nodes;
	    $sibling_weight = $w1;
	} else {
	    warn <<EMSG and return;
"Could not find distinguish b/w nodes.
They are  partitioned as ${\ (scalar @w1_nodes) } ${\(scalar @w2_nodes)}"
EMSG
	}
    }
}
1;
