# -*- mode: perl -*-
use strict;
use warnings;
use Test::More;

use lib '..';
use_ok("Day4");

sub string_eq{$_[0] eq $_[1]};

ok(Day4::isvalid([qw(aa bb cc dd ee)], \&string_eq));
ok(not Day4::isvalid([qw(aa bb cc dd aa)], \&string_eq));
ok(Day4::isvalid([qw(aa bb cc dd aaa)], \&string_eq));
ok(not Day4::isvalid([qw(aa bb aa)], \&string_eq));

my @anagrams = ([qw(abcde ecdab)],
		[qw(oiii ioii)],
		[qw(iioi iiio)],
	       );
for (@anagrams) {
  ok(Day4::is_anagram($_->[0], $_->[1]), "anagram $_->[0] $_->[1]");
}

my @not_anagrams = ([qw(abcde fghij)],
		    [qw(abd abf)],
		    [qw(oiii ooii)],
		    [qw(a ab)]);
for (@not_anagrams) {
  ok(!Day4::is_anagram($_->[0], $_->[1]), "not anagram $_->[0] $_->[1]");
}

my @valid = ("abcde fghij",
	     "a ab abc abd abf abj",
	     "iiii oiii ooii oooi oooo",
	     "a ab",
	    );

my @invalid = ("abcde xyz ecdab",
	       "oiii ioii iioi iiio");

for (@valid) {
  ok(Day4::isvalid([split], sub { $_[0] eq $_[1] or
				    Day4::is_anagram($_[0], $_[1])}),
     "valid pass: $_");
}

for (@invalid) {
  ok(!Day4::isvalid([split], sub { $_[0] eq $_[1] or
				     Day4::is_anagram($_[0], $_[1])}),
     "invalid pass: $_");
}

done_testing();
