#!/usr/bin/env perl

use strict;
use Test::Base qw/no_plan/;
use FindBin;

BEGIN { use_ok "Algorithm::Bayon"; }

my $data = [
    [qw/a 1 b 3 c 9 d 7 e 0 f 2 g 5 h 1 i 3 j 6/],
    [qw/a 7 b 8 c 0 d 5 e 3 f 4 g 1 h 9 i 7 j 4/],
    [qw/a 2 b 2 c 1 d 8 e 6 f 7 g 3 h 8 i 4 j 0/],
    [qw/a 0 b 5 c 2 d 9 e 4 f 4 g 8 h 7 i 5 j 3/],
    [qw/a 4 b 1 c 4 d 3 e 8 f 6 g 2 h 6 i 9 j 2/]
];

my @label = qw/foo bar baz hoge fuga/;

do {
    my $bayon = Algorithm::Bayon->new( debug => 1 );
    $bayon->number(3);

    my $result = $bayon->cluster( data => $data, labels => \@label );
    isa_ok( $result, 'Algorithm::Bayon::Result' );

    eval { $result->to_classify };
    ok( $@, $@ );
};

do {
    my $data2 = [
        {a => 1, b => 3, c => 9, d => 7, e => 0, f => 2, g => 5, h => 1, i => 3, j => 6},
        {a => 7, b => 8, c => 0, d => 5, e => 3, f => 4, g => 1, h => 9, i => 7, j => 4},
        {a => 2, b => 2, c => 1, d => 8, e => 6, f => 7, g => 3, h => 8, i => 4, j => 0},
        {a => 0, b => 5, c => 2, d => 9, e => 4, f => 4, g => 8, h => 7, i => 5, j => 3},
        {a => 4, b => 1, c => 4, d => 3, e => 8, f => 6, g => 2, h => 6, i => 9, j => 2}
    ];

    my $bayon = Algorithm::Bayon->new( debug => 1 );
    $bayon->number(3);

    my $result = $bayon->cluster( data => $data2, labels => \@label );
    isa_ok( $result, 'Algorithm::Bayon::Result' );
    #diag $result->raw;
};

do {
# TODO: やっぱりインターフェイスがあまりよくない気が…
    my $bayon = Algorithm::Bayon->new( debug => 1 );
    $bayon->number(3);
    $bayon->clvector('/tmp/classify.tsv');

    my $result = $bayon->cluster( data => $data, labels => \@label );
    isa_ok( $result, 'Algorithm::Bayon::Result' );

    my $classified_res = $result->to_classify;
    isa_ok( $classified_res, 'Algorithm::Bayon::Result' );
    my $list = $result->to_list;
    is( ref $list, 'ARRAY', 'list dumped' );

    unlink '/tmp/classify.tsv';
};
