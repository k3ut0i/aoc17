package Day1;

use strict;
use warnings;


sub captcha{ # Array diff version more suited for APL likes.
  my ($str) = @_;
  my $shifted_str = (substr $str, 1) . (substr $str, 0, 1);
  my $str_len = length $str;
  warn "Unequal length\n" unless $str_len eq length $shifted_str;
  my $sum = 0;
  for my $idx (0 .. $str_len - 1) {
    my $current_digit = (substr $str, $idx, 1);
    my $shifted_digit = (substr $shifted_str, $idx, 1);
    $sum += substr $str, $idx, 1
      if  $current_digit eq $shifted_digit;
  }
  return $sum;
}

sub captcha2{
  my ($str) = @_;
  my $sum = 0;
  for (0..(length $str)-1) {
    $sum += substr $str, $_, 1
      if (substr $str, $_, 1) eq (substr $str, ($_+1), 1);
  }
  $sum += substr $str, 0, 1
    if (substr $str, 0, 1) eq (substr $str, -1, 1);
  return $sum;
}

sub captcha_half_way {
  # How efficient is this ~substr~ compare to just character access?
  my ($str) = @_;
  my $len = length $str;
  my $offset = $len/2;
  my $sum = 0;
  die "Odd length string" if $offset != int($offset);

  for my $idx (0 .. $len-1) {
    my $next_idx = ($idx+$offset) % $len;
    $sum += substr $str, $idx, 1
      if (substr $str, $idx, 1) eq (substr $str, $next_idx, 1);
  }
  return $sum;
}

1;

