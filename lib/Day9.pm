# -*- mode: cperl; cperl-indent-level: 4 -*-
#!/usr/bin/perl
package Day9;

use strict;
use warnings;

sub score_stream{
    my ($line) = @_;
    my @chars = split //, $line;

    my $level = 0; my $skip_state = 0; my $garbage = 0;
    my $garbage_count = 0; my @scores = ();
    while (1) {
	last if @chars == 0;
	my $char = shift @chars;
	if ($garbage == 1) { # Inside garbage
	    if ($skip_state == 1) {
		 $skip_state = 0;
	    } elsif ($char eq '!') {
		$skip_state = 1;
	    } elsif ($char eq '>') {
		$garbage = 0;
	    } else {
		$garbage_count++;
	    }
	} else { # Not in garbage
	    if ($char eq '<') {
		$garbage = 1;
	    } elsif ($char eq '{') {
		$level++;
	    } elsif ($char eq '}') {
		push @scores, $level;
		$level--;
	    }
	}
    }
    my $score = 0;
    $score += $_ for (@scores);
    return $score, $garbage_count;
};

1;
