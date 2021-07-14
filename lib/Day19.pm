# -*- mode: cperl; cperl-indent-level: 4 -*-
#!/usr/bin/perl
package Day19;

use strict;
use warnings;
use autodie;


use List::Util qw(first);

use Exporter;
our @ISA = 'Exporter';
our @EXPORT = qw(read_file
		 traverse_network);
our @EXPORT_OK = qw(read_data);
### in the folowwing $x is rows and $y is columns
sub read_data {
  my ($data) = @_;
  my @lines = split /\n/, $data;
  chomp(@lines);
  my @a = map {[split //]} @lines;
  return \@a;
};

sub read_file {
  my ($fname) = @_;
  open my $fh, '<', $fname;
  local $/;
  return read_data(<$fh>);
}

sub step {
  my ($d, $x, $y) = @_;
  if ($d eq 'd') {
    $x += 1;
  } elsif ($d eq 'u') {
    $x -= 1;
  } elsif ($d eq 'l') {
    $y -= 1;
  } elsif ($d eq 'r') {
    $y += 1;
  } else {
    die "Stepping unknown direction : $d";
  }
  return ($x, $y);
}

sub neighbours {
  my ($x, $y) = @_;
  return ([$x+1, $y], [$x-1, $y], [$x, $y+1], [$x, $y-1]);
}

sub choose_direction {
  # print "choosing direction with @_\n";
  my ($pd, $down, $up, $right, $left) = map {$_ // ''} @_;
  # ^ set undefined to null strings
  my $direction;
  if ($pd eq 'd' or $pd eq 'u') {
    if ($left =~ /[-a-zA-Z]/) {
      $direction = 'l';
    } elsif ($right =~ /[-a-zA-Z]/) {
      $direction = 'r'
    } else {
      $direction = 'exit';
    }
  } else {
    if ($down =~ /[|a-zA-Z]/) {
      $direction = 'd';
    } elsif($up =~ /[|a-zA-Z]/) {
      $direction = 'u';
    } else {
      $direction = 'exit';
    }
  }
  return $direction;
}

sub traverse_network {
  my ($n) = @_;
  my $start = first {$n->[0][$_] eq '|'} 0..(@{$n->[0]}-1);
  my $xmax = scalar @$n;
  my $ymax = scalar @{$n->[0]};
  my $direction = 'd'; my $x = 0; my $y = $start;
  my $c = '|'; my $pc;
  my @views = (); my $steps = 0;
  # print "$start\n";
 LOOP:
  $steps++;
  # print "stepping from ($x, $y)[$c] to";
  die "out of bounds at ($x, $y) on $c going $direction"
    if $x < 0 or $x >= $xmax or $y < 0 or $y >= $ymax;
  ($x, $y) = step($direction, $x, $y);
  $pc = $c; $c = $n->[$x][$y];
  # print "($x, $y)[$c]\n";
  goto LOOP if $c =~ /^[|-]$/;
  if ($c =~ /^[a-zA-Z]$/) {
    push @views, $c;
    goto LOOP;
  }
  if ($c eq '+') {
    my ($down, $up, $right, $left) =
      map {$n->[$_->[0]][$_->[1]]} neighbours($x, $y);
    $direction = choose_direction($direction, $down, $up, $right, $left);
    goto LOOP unless $direction eq 'exit';
  }
  return [(join '', @views), $steps];
}

1;
