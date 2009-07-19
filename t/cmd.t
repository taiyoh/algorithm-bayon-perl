#!/usr/bin/env perl

use strict;
use Test::Base qw/no_plan/;
use FindBin;

BEGIN { use_ok "Algorithm::Bayon::Cmd" }

do {
    local $@;
    eval { Algorithm::Bayon::Cmd->new->build_command; };
    ok($@, 'error if defined nothing');
};

do {
    my $args_str = "number => 30, clvector => 'aaaaa', method => 'kmeans', seed => 3";
    diag $args_str;
    my %a    = eval $args_str;
    my $cmd  = Algorithm::Bayon::Cmd->new(%a);
    my @args = $cmd->build_command;
    for my $arg (@args) {
        like(
            $arg,
            qr/^(-n 30|--clvector-size=50|--method=kmeans|--clvector=aaaaa|--seed=3)$/,
            'arg exists: ' . $arg
        );
    }
};

do {
    my $args_str = "limit => 2.3, point => 1, method => 'lmeans'";
    diag $args_str;
    my %a = eval $args_str;
    my $cmd = Algorithm::Bayon::Cmd->new( %a );
    my @args = $cmd->build_command;
    for my $arg (@args) {
        like(
            $arg,
            qr/^(-l 2\.3|--clvector-size=50|--method=rb|-p)$/,
            'arg exists: ' . $arg
        );
    }
};

do {
    my $cmd = Algorithm::Bayon::Cmd->new( number => 3 );
    $cmd->run("$FindBin::Bin/test_data.tsv");
    ok($cmd->stdout);
    #diag $cmd->stdout;
};
