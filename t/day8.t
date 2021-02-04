# -*- mode: perl -*-
use strict;
use warnings;
use Test::More;

use_ok('Day8');
my @parse_tests = (# I have mistakenly used a hash previously
		   # The order of this inst-seq is important
		   ['b inc 5 if a > 1', ['b', 5, 'a', '>', 1]],
		   ['a inc 1 if b < 5',  ['a', 1, 'b', '<', 5]],
		   ['c dec -10 if a >= 1', ['c', 10, 'a', '>=', 1]],
		   ['c inc -20 if c == 10', ['c', -20, 'c', '==', 10]],
		  );
my @insts;
for my $t (@parse_tests) {
  my @parse_result = Day8::parse_inst($t->[0]);
  is_deeply(\@parse_result, $t->[1], "parse test: $t->[0]");
  push @insts, \@parse_result;
}

my %context = (); my $max=0;
for (@insts) {
  my $val = Day8::eval_inst($_, \%context) // 0;
  $max = $val if $max < $val;
};
#use Data::Dumper; print Dumper(%context);
is_deeply(\%context, {a=>1, c=>-10}, 'example evaluation');
is($max, 10, 'example max reg-val ever');
done_testing();
