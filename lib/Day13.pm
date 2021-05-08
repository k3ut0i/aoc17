# -*- mode: cperl; cperl-indent-level: 4 -*-
#!/usr/bin/perl
package Day13;

use strict;
use warnings;
use List::Util qw(max);
use Clone qw(clone);

sub parse_line {
    my ($line) = @_;
    if ($line =~ /^(\d+): (\d+)$/) {
	return ($1, $2);
    } else {
	die "Could not parse $line";
    }
}

sub read_init_state {
    my ($lines) = @_;
    my %state = ();
    for (@$lines) {
	chomp;
	my ($layer, $depth) = parse_line($_);
	$state{$layer} = {depth => $depth, scanner => 0, direction => 1};
    }
    return \%state;
}

sub step_firewall {
    my ($state) = @_;
    for my $layer (keys %$state) {
	my $scanner_pos = $state->{$layer}{scanner};
	my $direction = $state->{$layer}{direction};
	my $depth = $state->{$layer}{depth};
	if ($scanner_pos == 0 and $direction == -1) {
	    $scanner_pos = 1;
	    $direction = 1;
	} elsif ($scanner_pos == $depth-1 and $direction == 1) {
	    $scanner_pos = $depth-2;
	    $direction = -1;
	} else {
	    $scanner_pos += $direction;
	}
	$state->{$layer}{scanner} = $scanner_pos;
	$state->{$layer}{direction} = $direction;
    }
    return $state;
}

sub simulate_part1 {
    my ($state) = @_;		# initial state
    my %caught = ();
    my $max_layer = max keys %$state;
    for my $n (0..$max_layer) {
	$caught{$n} = 1
	  if exists $state->{$n} and $state->{$n}{scanner} == 0;
	step_firewall($state);
    }
    return \%caught;
}

sub severity{
    my ($init_state) = @_;
    my $max_layer = max keys %$init_state;
    my $severity = 0;
    for my $n (0 .. $max_layer) {
	next if not exists $init_state->{$n};
	my $layer_depth = $init_state->{$n}{depth};
	my $caught = not $n % (2*($layer_depth - 1));
	if ($caught) {
	    $severity += $n * $layer_depth;
	}
    }
    return $severity;
}

sub find_delay {
    my ($init_state) = @_;
    my $delay = 0;
    my $max_layer = max keys %$init_state;
    # can find the lcm of all the depths and constrain
    # the search of $delay to that specific number
  NEXT: while (1) {
	my $state = clone($init_state);
	step_firewall($state) for (1..$delay); # run it $delay times
	for my $n (0..$max_layer) {
	    if (exists $state->{$n} and $state->{$n}{scanner} == 0) {
		$delay++;
		next NEXT;
	    } else {
		step_firewall($state);
	    }
	}
	last NEXT;
    }
    return $delay;
}
sub find_delay_direct {
    my ($init_state) = @_;
    my $delay = 0;
    my $max_layer = max keys %$init_state;
  NEXT:
    for my $n (0 .. $max_layer) {
	next if not exists $init_state->{$n};
	my $layer_depth = $init_state->{$n}{depth};
	my $period = (2 * ($layer_depth - 1));
	my $not_caught = ($n + $delay) % $period;
	if (not $not_caught) {
	    $delay++;
	    goto NEXT;
	}
    }
    return $delay;
}
1;
