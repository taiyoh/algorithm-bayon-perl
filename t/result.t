#!/usr/bin/env perl

use strict;
use Test::Base qw/no_plan/;
use FindBin;

use Algorithm::Bayon::Cmd;
BEGIN {
    use_ok "Algorithm::Bayon::Result";
}

my $cmd = Algorithm::Bayon::Cmd->new( number => 3, clvector => '/tmp/classify.tsv' );
$cmd->run("$FindBin::Bin/test_data.tsv");

my $dumped_tsv = $cmd->stdout;

do {
    my $result = Algorithm::Bayon::Result->new(
        debug => 1,
        point => 0,
        raw   => $dumped_tsv,
        input => "$FindBin::Bin/test_data.tsv"
    );
    $result->centroid($cmd->clvector) if $cmd->clvector;
    my @result = $result->to_list;
    my $list_out;
    for (@result) {
        $list_out++ unless @{ $_->{list} } > 0;
    }
    ok(!$list_out, 'list filled');
};


do {
    my $result = Algorithm::Bayon::Result->new(
        debug => 1,
        point => 0,
        raw   => $dumped_tsv,
        input => "$FindBin::Bin/test_data.tsv",
    );
    $result->centroid($cmd->clvector) if $cmd->clvector;
    my $filename = $result->to_file();
    is(`cat $filename`, $dumped_tsv, 'data dumped');
    my $classified = $result->to_classify;
    isa_ok($classified, 'Algorithm::Bayon::Result');
    ok($classified->classified, "it's classified");
    ok(!$classified->{classify}, 'classify attr is not exists');
    ok($classified->raw);
    #use YAML qw/Dump/;
    #print Dump $classified->to_list;
};

unlink '/tmp/classify.tsv';
