#!/usr/bin/perl
package AOCUtil;

use strict;
use warnings;
use Exporter;
our @EXPORT_OK = qw(set_diff set_eq set_union);

sub set_diff {
  my ($a1, $a2) = @_;
  my %a2_hash = map {$_ => 1} @$a2;
  grep {!exists $a2_hash{$_}} @$a1
}

sub set_eq {
  my ($a1, $a2) = @_;
  my %ha1 = map {$_ => 1} @$a1;
  my %ha2 = map {$_ => 1} @$a2;
  for (@$a1, @$a2) {
    return 0 if $ha1{$_} != $ha2{$_};
  }
  return 1;
}

sub set_union {
  my ($a1, $a2) = @_;
  my %contents;
  for (@$a1, @$a2) {
    $contents{$_} = ($contents{$_} // 0)+1;
  }
  grep {$contents{$_}>0} keys %contents;
}

1;
