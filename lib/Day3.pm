package Day3;
use strict;
use warnings;
use v5.30;

use POSIX qw(floor ceil);
use List::Util qw(reduce);

sub getpos { # This is similar to polar co-ordinates
  my ($n) = @_;
  my $circle = ceil((sqrt($n)-1)/2);
  return [0, 0, 0] if $circle == 0;

  my $offset = ($n - (2*$circle-1)**2) % (2*$circle);
  my $in_arc = abs($offset - $circle);

  return [$circle, $in_arc, $offset];
}

sub n_to_xy { # X-Y co-ordinates
  my ($n) = @_;
  my $circle = ceil((sqrt($n)-1)/2);
  return [0, 0] if $circle == 0;

  my $offset = ($n - (2*$circle-1)**2);
  my $ratio = $offset/(2*$circle);
  if (0 < $ratio and $ratio <= 1) {
    return [$circle, $offset - $circle];
  } elsif (1 < $ratio and $ratio <= 2) {
    return [3*$circle - $offset, $circle];
  } elsif (2 < $ratio and $ratio <= 3) {
    return [-$circle, 5*$circle - $offset];
  } else {
    return [($offset - 7*$circle) , -$circle];
  }
}

sub manhattan_dis {
  my ($pos) = @_;
  return abs($pos->[0]) + abs($pos->[1]);
};

sub getdis {
  return manhattan_dis(getpos($_[0]));
};

sub neighbours {
  my ($x, $y) = @_;
  return [[$x-1, $y-1], [$x, $y-1], [$x+1, $y-1],
	  [$x-1, $y], [$x+1, $y],
	  [$x-1, $y+1], [$x, $y+1], [$x+1, $y+1]];
}

sub xy_to_n {
  my ($x, $y) = @_;
  # Ending SouthEast Diagonal case
  return (2*$x+1)**2 if $x + $y  == 0 and $x > 0;

  my $mx = abs($x); my $my = abs($y);
  if ($mx >= $my) {
    if ($x >= 0) { # left
      return (2*$mx-1)**2 + $mx + $y;
    } else { #right
      return (2*$mx-1)**2 + 5*$mx - $y;
    }
  } else {
    if ($y >= 0) { #top
      return (2*$my-1)**2 + 3*$my - $x;
    } else { #bottom
      return (2*$my-1)**2 + 7*$my + $x;
    }
  }
}


sub stress_test { # keep generating until
  my ($fn) = @_;  # $fn fails
  my $n = 1; my $val = 1; my %state = (1 => 1);
  while($fn->($val)) {
    $n++;
    my $pos = n_to_xy($n);
    my @ns = map { $state{xy_to_n(@{$_})} }  @{neighbours(@$pos)};
    $val = reduce {$a+$b} (grep {defined} @ns);
    $state{$n} = $val;
  }
  return $val;
}

1;
