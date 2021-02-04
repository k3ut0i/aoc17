# -*- mode: cperl; cperl-indent-level: 4 -*-
#!/usr/bin/perl
package Day8;

use strict;
use warnings;

my %cmp_ops = ( # explicit for better security
	       '==' => sub {$_[0] == $_[1]},
	       '!=' => sub {$_[0] != $_[1]},
	       '<' => sub {$_[0] < $_[1]},
	       '>' => sub {$_[0] > $_[1]},
	       '<=' => sub {$_[0] <= $_[1]},
	       '>=' => sub {$_[0] >= $_[1]},
	      );
my %arith_ops = (
		 inc => sub {$_[0]+1},
		 dec => sub {$_[0]-1},
		);

sub parse_inst{
    my ($line) = @_;
    $line =~ /^(\w+) (inc|dec) (-?\d+) if (\w+) ([<>=!]+) (-?\d+)$/ or
      die "Could not parse $line";
    my $inc_amount = $2 eq 'inc' ? $3 : -$3;
    return ($1, $inc_amount, $4, $5, $6);
}

sub eval_inst { # return the value assigned in this evaluation
    my ($inst, $context) = @_;
    my ($change_var, $amount, $cond_var, $cond_op, $cond_amount) = @$inst;
    my $cond_var_value = $context->{$cond_var} // 0;
    if ($cmp_ops{$cond_op}->($cond_var_value, $cond_amount)) {
	return $context->{$change_var} += $amount;
    } else {
	return;
    }
}

1;
