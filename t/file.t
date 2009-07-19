#!/usr/bin/env perl

use strict;
use Test::Base qw/no_plan/;
use FindBin;

use Algorithm::Bayon::Cmd;
BEGIN {
    use_ok "Algorithm::Bayon::File";
}

my $cmd = Algorithm::Bayon::Cmd->new( number => 3 );
$cmd->run("$FindBin::Bin/test_data.tsv");

my $dumped_tsv = $cmd->stdout;

do {
    my $file = Algorithm::Bayon::File->new;
    my @labels = qw/foo bar baz/;
    my $data_list = [
        [qw/1 a 2 b 3 c/],
        [qw/4 d 5 e 6 f/],
        [qw/7 g 8 h 9 i/],
    ];
    my $data = <<_TSV_;
foo	1	a	2	b	3	c
bar	4	d	5	e	6	f
baz	7	g	8	h	9	i
_TSV_
    my $filename = $file->dump_file($data_list, \@labels);
    is(`cat $filename`, $data, 'data with label');
};

do {
    my $file = Algorithm::Bayon::File->new;
    my $data_list = [
        [qw/1 a 2 b 3 c/],
        [qw/4 d 5 e 6 f/],
        [qw/7 g 8 h 9 i/],
    ];
    my $data = <<_TSV_;
0	1	a	2	b	3	c
1	4	d	5	e	6	f
2	7	g	8	h	9	i
_TSV_
    my $filename = $file->dump_file($data_list);
    is(`cat $filename`, $data, 'data without label(but numbers)');
};
