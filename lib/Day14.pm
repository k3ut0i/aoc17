# -*- mode: cperl; cperl-indent-level: 4 -*-
#!/usr/bin/perl
package Day14;

use strict;
use warnings;
use lib './';
use Day10;
use List::Util qw(sum uniqint);
use AOCUtil qw(set_diff);

my %bit_table = (0 => 0, 1 => 1, 2 => 1, 3 => 2,
		 4 => 1, 5 => 2, 6 => 2, 7 => 3,
		 8 => 1, 9 => 2, a => 2, b => 3,
		 c => 2, d => 3, e => 3, f => 4);

sub direct_calc {
    my ($key) = @_;
    my $ones = 0;
    for my $row (0 .. 127) {
	my $hash_input = "$key-$row";
	my $hash_output = Day10::densehash($hash_input);
	for my $c (split //, $hash_output) {
	    $ones += $bit_table{$c};
	}
    }
    return $ones;
}

sub get_bit_array {
    my ($key) = @_;
    my @bit_array = ();
    for my $row (0 .. 127) {
	my $hash_input = "$key-$row";
	my $hash_output = Day10::densehash($hash_input);
	my $bit_string = '';
	for my $c (split //, $hash_output) {
	    $bit_string .= sprintf "%04b", hex($c);
	}
	$bit_array[$row] = [split //, $bit_string];
    }
    return \@bit_array;
}

# We have again come to the transitive closure of a network.
# To color this image we need to find the connected trees and
# color them differently. This process of traversing the tree
# is the same as finding the transitive closure of the graph
sub neighbours {
    my ($x, $y) = @_;
    my @tmp = ([$x-1, $y], [$x, $y+1],
	       [$x+1, $y], [$x, $y-1]);
    grep {
	$_->[0] >= 0 && $_->[0] <= 127 &&
	  $_->[1] >= 0 && $_->[1] <= 127
    } @tmp
}

sub rmo2xy{
    my ($i) = @_;
    my $y = $i %128;
    my $x = int($i/128);
    return ($x, $y);
}

sub neighbours_rmo { # with co-ordinates in row-major-order
    my ($i) = @_;
    my ($x, $y) = rmo2xy($i);
    map {$_->[0]*128+$_->[1]} neighbours($x, $y);
}

sub full_sim {
    my ($key, $image_file) = @_;
    my $do_image = defined $image_file;
    my $bit_array = get_bit_array($key);
    my $fh;

    my %color;
    my @nodes = grep {
	my ($x, $y) = rmo2xy($_);
	$bit_array->[$x][$y];
    } (0..16383);
    until (0 == scalar @nodes) {
	my $root = shift @nodes;
	my @unmarked = ($root);
	my @cluster;
	until (0 == scalar @unmarked) {
	    my $node = shift @unmarked;
	    my @live_nodes = grep {
		my ($x, $y) = rmo2xy($_);
		$bit_array->[$x][$y];
	    } neighbours_rmo($node);
	    push @unmarked, @live_nodes;
	    @unmarked = AOCUtil::set_diff(\@unmarked, \@cluster);
	    push @cluster, $node;
	    print "\rWith Root node: $root $node ",
	      scalar @cluster, " ", scalar @unmarked, " " if 0;

	}
	@nodes = AOCUtil::set_diff(\@nodes, \@cluster);
	$color{$_}=$root for @cluster;
    }

    if ($do_image) {
	open $fh, '>', $image_file
	  or die "Could not open file $image_file:$!";
	print $fh "P1\n"; # bitmap
	print $fh "128 128\n"; # size
    }

    my $ones = 0;
    for my $row (0 .. 127) {
	for my $col (0 .. 127) {
	    print $fh $bit_array->[$row][$col], " " if $do_image;
	    $ones += $bit_array->[$row][$col];
	}
	print $fh "\n" if $do_image;
    }

    close($fh) if $do_image;
    return ($ones, scalar uniqint values %color);
}


1;
