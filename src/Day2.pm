package Day2;
use strict;
use warnings;


# It would be better to read the whole file and then map the
# checksum function on lines, but IF the file is big, holding
# all of it memory might be wasteful. We have no dependency b/w
# the lines, so just iterating over the lines is sufficient.
sub crunch_spreadsheet {
  my ($file, $map_op, $reduce_op) = @_;
  open my $fh, '<', $file or
    die "Cannot open file $file: $!";
  my $result;
  while (<$fh>) {
    chomp;
    my @nums = split;
    $result = $reduce_op->($result, $map_op->(\@nums));
  }
  return $result;
}

sub checksum {
  my ($nums) = @_;
  my $min = $nums->[0];
  my $max = $min;
  for my $n (@$nums) {
    $min = $n if $n < $min;
    $max = $n if $n > $max;
  }
  return $max - $min;
}

sub checksum_div {
  my ($nums) = @_;
  my $len = scalar @$nums;
  for my $i (0..$len-2) {
    for my $j ($i+1..$len-1) {
      my $ni = $nums->[$i];
      my $nj = $nums->[$j];
      return $ni / $nj if $ni % $nj == 0;
      return $nj / $ni if $nj % $ni == 0;
    }
  }
}

1;
