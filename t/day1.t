# -*- mode: perl -*-
use strict;
use warnings;

use Test::More;


use lib '../src';
use Day1;

is(Day1::captcha("1122"), 3, "case 1122");
is(Day1::captcha("1111"), 4, "case 1111");
is(Day1::captcha("1234"), 0, "case 1234");
is(Day1::captcha("91212129"), 9, "case 91212129");

is(Day1::captcha2("1122"), 3, "case 1122");
is(Day1::captcha2("1111"), 4, "case 1111");
is(Day1::captcha2("1234"), 0, "case 1234");
is(Day1::captcha2("91212129"), 9, "case 91212129");

is(Day1::captcha_half_way("1212"), 6, "case 1212");
is(Day1::captcha_half_way("1221"), 0, "case 1221");
is(Day1::captcha_half_way("123425"), 4, "case 123425");
is(Day1::captcha_half_way("123123"), 12, "case 123123");

done_testing();
