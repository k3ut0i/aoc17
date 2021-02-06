# -*- mode: perl -*-
use strict;
use warnings;
use Test::More;

use_ok('Day9');
my @score_tests = (
	     ['{}', 1],
	     ['{{{}}}', 6],
	     ['{{},{}}', 5],
	     ['{{{},{},{{}}}}', 16],
	     ['{<a>,<a>,<a>,<a>}', 1],
	     ['{{<ab>},{<ab>},{<ab>},{<ab>}}', 9],
	     ['{{<!!>},{<!!>},{<!!>},{<!!>}}', 9],
	     ['{{<a!>},{<a!>},{<a!>},{<ab>}}', 3]
	    );

for my $t (@score_tests) {
  my ($score) = Day9::score_stream($t->[0]);
  is($score, $t->[1], "Score for $t->[0]");
}

my @garbage_tests = (
		     ['<>', 0],
		     ['<random characters>', 17],
		     ['<<<<>', 3],
		     ['<{!>}>', 2],
		     ['<!!>', 0],
		     ['<!!!>>', 0],
		     ['<{o"i!a,<{i<a>', 10],
		    );
for my $t (@garbage_tests) {
  my @scores = Day9::score_stream($t->[0]);
  is($scores[0], 0, "Score for $t->[0]");
  is($scores[1], $t->[1], "Garbage for $t->[0]");
}
done_testing();
