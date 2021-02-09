# -*- mode: cperl; cperl-indent-level: 4 -*-
#!/usr/bin/perl
package Day11;

use strict;
use warnings;
use Math::Complex;

my %dir_map = (n => i,
	       s => -1*i,
	       ne => cos(pi/6)+i*sin(pi/6),
	       se => cos(pi/6)-i*sin(pi/6),
	       nw => -cos(pi/6)+i*sin(pi/6),
	       sw => -cos(pi/6)-i*sin(pi/6),
	      );

sub distance{
  my ($str) = @_;
  my @dirs = split /,/, $str;
  my %count = (); my $orig = 0+0*i; my $step = 0;
  my $max = 0+0*i; my $max_step = 0;
  for (@dirs) {
      $count{$_} = ($count{$_} // 0) + 1;
      $orig += $dir_map{$_};
      if (abs($orig) > abs($max)) {
	  $max = $orig; $max_step = $step;
      };
      $step++;
  };
  my %max_count  = ();
  $max_count{$dirs[$_]} = ($max_count{$dirs[$_]} // 0) + 1 for (0 .. $max_step);
  $count{n} -= $count{s}; delete $count{s};
  $count{ne} -= $count{sw}; delete $count{sw};
  $count{nw} -= $count{se}; delete $count{se};

  return (\%count, \%max_count, sprintf("%s", $max), $max_step, sprintf("%s", $orig), $step);
}


1;
