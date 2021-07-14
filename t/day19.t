# -*- mode: perl; cpel-indent-level: 4 -*-
use strict;
use warnings;
use Test::More;
use_ok('Day19');
use lib '../lib';
use Day19 qw(read_data);

my $data = <<NETWORK;
     |         
     |  +--+   
     A  |  C   
 F---|----E|--+
     |  |  |  D
     +B-+  +--+
NETWORK
  my $n = read_data($data);
is_deeply(traverse_network($n), ["ABCDEF", 38], "example network");
done_testing();
