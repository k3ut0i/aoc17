# -*- mode: cperl; cperl-indent-level: 4 -*-
#!/usr/bin/perl
package Day17;

use strict;
use warnings;
use Exporter;
our @ISA = 'Exporter';
our @EXPORT = qw(step value_after find_idx_pos);

# Spinlock
# Hash with array to hold it's contents,
# current position, length, and step value: eg.,
# {array => [0], pos => 0, length => 1, skip => 3}

sub step {
  my ($lock) = @_;
  my $new_pos = ($lock->{pos} + $lock->{skip}) % $lock->{length} + 1;
  splice(@{$lock->{array}}, $new_pos, 0, $lock->{length});
  $lock->{pos} = $new_pos;
  $lock->{length}++;
  return $lock;
}

sub value_after {
  my ($skip, $niter, $pos) = @_;
  my $lock = {array => [0],
	      pos => 0,
	      length => 1,
	      skip => $skip};

  for (1..$niter) {
    step($lock);
  }
  $pos //= $lock->{pos}+1;
  return $lock->{array}[$pos];
}

sub find_idx_pos {
  my ($skip, $niter, $idx) = @_;
  $idx //= 1;
  my $pos = 0;
  my $e = 0;
  for (1..$niter) {
    $pos = ($pos + $skip) % $_ + 1;
    $e = $_ if $pos == $idx;
  }
  return $e;
}

1;
