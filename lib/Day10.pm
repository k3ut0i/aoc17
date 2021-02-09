# -*- mode: cperl; cperl-indent-level: 4 -*-
#!/usr/bin/perl
package Day10;

use strict;
use warnings;
use POSIX qw(floor);

sub step_sim{
  my ($a, $pos, $skip, $len) = @_;
  my $array_len = @$a;
  my @indices = map {$_ % $array_len} $pos .. $pos + $len - 1;
  @{$a}[@indices] = reverse @{$a}[@indices];
  return ($a, ($pos+$len+$skip) % $array_len, $skip+1);
}

sub step_round {
    my ($a, $pos, $skip, $lengths) = @_;
    for my $len (@$lengths){
	($a, $pos, $skip) = step_sim($a, $pos, $skip, $len);
    }
    return ($a, $pos, $skip);
}

sub getseq {
    my ($str) = @_;
    my @bytes = map {unpack 'c2'} split //, $str;
    my @padding = (17, 31, 73, 47, 23);
    push @bytes, @padding;
    return \@bytes;
}

sub sparse2dense{
    my ($a) = @_;
    my $len = scalar @$a;
    warn "length is not a multiple of 16: $len" if $len % 16;
    my $blocks = int($len/16); my $hash = '';
    for my $b (0..$blocks-1) {
	my $bv = $a->[$b*16];
	for (1..15) {
	    $bv = $bv ^ $a->[$b*16+$_];
	}
	$hash .= sprintf '%02x', $bv;
    }
    return $hash;
}

sub sparsehash{
    my ($str) = @_;
    my @lengths = @{getseq($str)};
    my $pos = 0; my $skip = 0; my $a = [0..255];
    for (0 .. 63) { # 64 rounds
	($a, $pos, $skip) = step_round($a, $pos, $skip, \@lengths);
    }
    return $a;
}

sub densehash{
    my ($str) = @_;
    return sparse2dense(sparsehash($str));
}

1;
