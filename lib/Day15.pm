# -*- mode: cperl; cperl-indent-level: 4 -*-
#!/usr/bin/perl
package Day15;

use strict;
use warnings;
use Exporter;
our @ISA = 'Exporter';
our @EXPORT = qw($agen $bgen match judge_ab judge_adv);

use constant REM => 2147483647; #2^31-1.
# ^ So the generate numbers are within 31 bits

use constant AFAC => 16807;
use constant BFAC => 48271;
use constant SAMPLES => 40_000_000;
use constant ADV_SAMPLES => 5_000_000;

sub create_gen {
  my ($factor) = @_;
  sub {$_[0]*$factor % REM}
}

our $agen = create_gen(AFAC);
our $bgen = create_gen(BFAC);

sub match {
  my ($a, $b) = @_;
  ($a & 0xffff) == ($b & 0xffff);
}

sub judge_ab {
  my ($a, $b) = @_; # initial values;
  my $count = 0;
  for (1..SAMPLES) {
    $count++ if match($a, $b);
    $a = $agen->($a);
    $b = $bgen->($b);
  }
  return $count;
};

sub judge_adv {
    my ($a, $b) = @_;
    my $i = 0; my $count = 0;
    while ($i < ADV_SAMPLES) {
	do {
	    $a = $agen->($a);
	} while ($a % 4);
	do {
	    $b = $bgen->($b);
	} while ($b % 8);
	$i++;
	$count++ if match($a, $b);
    }
    return $count;
}

1;
