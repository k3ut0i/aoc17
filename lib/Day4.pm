#!/usr/bin/perl
package Day4;

use strict;
use warnings;

sub isvalid {
  my ($a, $fn) = @_; # array and eq function
  my $len = scalar @$a;
  for my $i (0..$len-1) {
    for my $j ($i+1..$len-1) {
      return 0 if $fn->($a->[$i], $a->[$j]);
    }
  }
  return 1;
}

sub chars_count {
  my ($s) = @_;
  my @chars = split '', $s;
  my %count;
  for (@chars) {
    $count{$_}++;
  }
  return \%count;
}

sub is_anagram {
  my ($s1, $s2) = @_;
  my $c1 = chars_count($s1);
  my $c2 = chars_count($s2);
  for (keys %$c1, keys %$c2) { # bad union
    return 0 if (exists $c1->{$_}) xor (exists $c2->{$_});
    return 0 if $c1->{$_} ne $c2->{$_};
  }
  return 1;
}

1;
