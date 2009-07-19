#!/usr/bin/env perl

use strict;
use Test::Base qw/no_plan/;
use FindBin;

use Algorithm::Bayon::Cmd;
BEGIN {
    use_ok "Algorithm::Bayon::Result";
}

my $cmd = Algorithm::Bayon::Cmd->new( number => 3 );
$cmd->clvector('/tmp/classify.tsv');
$cmd->run("$FindBin::Bin/test_data.tsv");

my $dumped_tsv = $cmd->stdout;

do {
    my $result = Algorithm::Bayon::Result->new(
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
        point => 0,
        raw   => $dumped_tsv,
        input => "$FindBin::Bin/test_data.tsv",
    );
    #$result->centroid($cmd->clvector) if $cmd->clvector;
    my $filename = $result->to_file();
    is(`cat $filename`, $dumped_tsv, 'data dumped');
    eval { $result->to_classify };
    ok($@, $@);
};

do {
    my $result = Algorithm::Bayon::Result->new(
        point => 0,
        raw   => $dumped_tsv,
        input => "$FindBin::Bin/test_data.tsv",
        centroid => $cmd->clvector
    );
    my $filename = $result->to_file();
    is(`cat $filename`, $dumped_tsv, 'data dumped');
    my $classified_res = $result->to_classify;
    ok($classified_res->classified, 'classified');
    ok($classified_res->raw, 'data exists');
};

unlink '/tmp/classify.tsv';
