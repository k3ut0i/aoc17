# -*- mode: perl; cpel-indent-level: 4 -*-
use strict;
use warnings;
use Test::More;
use_ok('Day15');
use lib '../lib';
use Day15;
my @aseq = (1092455,
	   1181022009,
	   245556042,
	   1744312007,
	   1352636452);

my @bseq = (430625591,
	    1233683848,
	    1431495498,
	    137874439,
	    285222916);

my $astart = 65;
my $bstart = 8921;
my $a = $astart; my $b = $bstart;
for (@aseq) {
  $a = $agen->($a);
  is($a, $_, "A init sequence $_");
}

for (@bseq) {
  $b = $bgen->($b);
  is($b, $_, "B init sequence $_");
}

my @a_adv = (1352636452,
	     1992081072,
	     530830436,
	     1980017072,
	     740335192);

my @b_adv = (1233683848,
	     862516352,
	     1159784568,
	     1616057672,
	     412269392);

my $i = 0;
$a = $astart; $b = $bstart;
while ($i < 5) {
  do {
    $a = $agen->($a);
  } while ($a % 4);
  do {
    $b = $bgen->($b);
  } while ($b % 8);
  is($a, $a_adv[$i], "advanced a seq $a");
  is($b, $b_adv[$i], "advanced b seq $b");
  $i++;
}

$i = 0;
$a = $astart; $b = $bstart;
until (match($a, $b)) {
  do {
    $a = $agen->($a);
  } while ($a % 4);
  do {
    $b = $bgen->($b);
  } while ($b % 8);
  $i++;
}
is($i, 1056, "index of first matched pair in second part");
is(judge_ab($astart, $bstart), 588, "judge count");
is(judge_adv($astart, $bstart), 309, "judge advanced count");

done_testing();
