#!/usr/bin/perl
package Day6;

use strict;
use warnings;

sub max_idx {
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
}

1;
