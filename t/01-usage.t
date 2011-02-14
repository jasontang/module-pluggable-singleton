#!/usr/bin/env perl

use strict;
use warnings;
use FindBin::libs;
use Test::More;
use XT::Business;
use Data::Dump qw/pp/;

my $tests = [
    {
        label => 'Bar',
        method => 'foo',
        params => 'hello there',
    },
    {
        label => 'Bar',
        method => 'unknown',
        params => '',
        error => "Cannot call 'unknown' on 'Bar'",
    },
    {
        label => 'Baz',
        method => 'foo',
        params => '',
        error => 'Not possible to load module',
    },
];

note "Plugins available:\n";
#foreach my $method (qw/plugin call/) {
#    if (XT::Business->can($method)) {
#        note "$method: yups\n";
#    } else {
#        note "$method: nope\n";
#    }
#}

is(scalar XT::Business->plugin, 1,
    'Found one plugin');
is(XT::Business->plugin('Bar'),'XT::Business::Plugin::Bar',
    'Correct fully qualified name');
is(XT::Business->plugin('Baz'),undef,
    'Unknown plugin');

my $rv;

#foreach my $test (@{$tests}) {
#    my $label = 'Bar';
#    eval {
#        $rv = XT::Business->call($test->{label}, $test->{method}, $test->{params});
#    };
#    if (my $e = $@) {
#        if ($test->{error}) {
#            my $foo = $test->{error};
#
#            is($e =~ /$foo/, 'blah', 'Matched expected error');
##            if ($e =~ /$foo/i) {
##                warn __PACKAGE__ .": not matching error - $foo";
##            }
#        } else {
#            warn __PACKAGE__ .": error when test not expecting";
#        }
#
#        note "Error: $e\n";
#    } else {
#        if ($test->{error}) {
#            warn __PACKAGE__ .": should be an error";
#        }
#    }
#}

done_testing;
