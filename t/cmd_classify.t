#!/usr/bin/env perl

use strict;
use Test::Base qw/no_plan/;
use FindBin;

use YAML;
use Algorithm::Bayon::Cmd;
use Algorithm::Bayon::File;
BEGIN { use_ok "Algorithm::Bayon::CmdClassify" }

do {
    local $@;
    eval { Algorithm::Bayon::CmdClassify->new->build_command; };
    ok($@, 'error if defined nothing');
};

do {
    my $args_str = "file => '/tmp/classify_cmd.tsv', inv_keys => 5, inv_size => 150";
    diag $args_str;
    my %a    = eval "($args_str)";
    my $cmd  = Algorithm::Bayon::CmdClassify->new(%a, debug => 1 );
    my $args = join ' ', $cmd->build_command;
    is( $args, q{--classify=/tmp/classify_cmd.tsv --inv-keys=5 --inv-size=150 --classify-size=20});
};

do {
    my $args_str = "file => '/tmp/classify_cmd.tsv'";
    diag $args_str;
    my %a = eval "($args_str)";

    my $_cmd = Algorithm::Bayon::Cmd->new( number => 3, debug => 1, clvector => $a{file} );
    $_cmd->run("$FindBin::Bin/test_data.tsv");
    my $file = Algorithm::Bayon::File->new( debug => 1 );
    my $filename = $file->to_file(sub { print $_ $_cmd->stdout });

    my $cmd = Algorithm::Bayon::CmdClassify->new( %a, debug => 1 );
    $cmd->run("$FindBin::Bin/test_data.tsv");
    ok($cmd->stdout);
    unlink '/tmp/classify_cmd.tsv';
};
