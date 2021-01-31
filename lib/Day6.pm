#!/usr/bin/perl
package Day6;

use strict;
use warnings;
use POSIX qw(floor);

sub max_idx { # ties broken by the lowest index
  my ($a, $fn) = @_;
  my $len = scalar @$a;
  my $max_idx = 0; my $max = $a->[$max_idx];
  for (0..$len-1) {
    my $current = $a->[$_];
    if ($fn->($current, $max)) {
      $max_idx = $_; $max = $current;
    }
  }
  return $max_idx;
}

sub step_redist_x {
  my ($a) = @_; # The array to redistribute. Inplace change
  my $max_idx = max_idx($a, sub {$_[0] > $_[1]});
  #TODO: Calculate redistribution
  #floor($max/$len) is increased for all indices.
  #the remaining are for $rem modulo $len indices.
  my $max = $a->[$max_idx];
  my $len = @$a;
  my $all_inc = floor($max/$len);
  my $rest = $max - $all_inc*$len;
  $a->[$max_idx] = 0;
  for my $idx (0..$len-1) {
    $a->[$idx] += $all_inc;
    $a->[$idx]++ if 0 < ($idx - $max_idx) % $len <= $rest;
  }
  return $max; # array is changed in-place. return total moved.
}

1;
