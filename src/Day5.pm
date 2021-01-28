#!/usr/bin/perl
package Day5;

use strict;
use warnings;

sub step_inst{
  my ($a, $i, $update_fn) = @_; #ref to an array of jumps, current innstruction
  my $offset = $a->[$i];
  my $new_inst = $i + $offset;
  $a->[$i] = $update_fn->($a->[$i]);
  return $new_inst;
}

1;
