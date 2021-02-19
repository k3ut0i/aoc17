# -*- mode: cperl; cperl-indent-level: 4 -*-
#!/usr/bin/perl
package Day12;

use strict;
use warnings;
use List::Util qw(uniq);

sub parse_line {
  my ($line) = @_;
  die "Could not match $line" unless $line =~ /^(\d+) <-> (.*)$/;
  my $parent = $1; my @children = split /,\s*/, $2;
  return ($parent, \@children);
}

sub create_network {
  my ($lines) = @_;
  my %network = ();
  for my $line (@$lines) {
    my ($parent, $children) = parse_line($line);
    $network{$parent} = $children;
  }
  return \%network;
}

sub transitive_closure {
  my ($network) = @_;
  my $total_nodes = scalar keys %$network;
  my $n = 0; my $changes = 1;
  until ($changes == 0) {
    $changes = 0;
    for my $node (keys %$network) {
      my @attached = @{$network->{$node}}; push @attached, $node;
      my @next = ();
      for (@attached) {
	push @next, @{$network->{$_}};
      }
      push @{$network->{$node}}, @next;
      my @union = uniq @{$network->{$node}};
      $changes += @union - uniq @attached;
      @{$network->{$node}} = @union;
    }
    $n++;
  }
  # for my $node (keys %$network) {
  #   @{$network->{$node}} = grep {$_ ne $node} @{$network->{$node}};
  # }
  return $network;
}

sub trees { # total number of trees in this forest
    my ($network) = @_; # network must be transitively closed.
    my %root = (); # each node is mapped to it's root
    my @nodes = keys %$network;
    for my $node (@nodes) {
	next if exists $root{$node};
	my @attached = @{$network->{$node}};
	$root{$node} = $node;
	for (@attached) {
	    $root{$_} = $node;
	}
    }
    return \%root;
}
1;
