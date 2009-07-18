package Algorithm::Bayon;

use Any::Moose;
use utf8;

use Carp;
use Algorithm::Bayon::File;
use Algorithm::Bayon::Cmd;
use Algorithm::Bayon::Result;

our $VERSION = '0.001_1';

#   -n, --number=num      分割するクラスタの数
#   -l, --limit=lim       分割ポイントの閾値
#   -p, --point           各ドキュメントの所属クラスタへの所属度を出力
#   -c, --clvector=file   クラスタの中心ベクトルの出力先ファイル
#   --clvector-size=num   クラスタの中心ベクトルの最大要素数(デフォルトは50)
#   --method=method       クラスタリング手法(rb, kmeans), デフォルトはrb
#   --seed=seed           乱数のseed値を指定

has debug => (
    is => 'rw',
    isa => 'Bool',
    lazy => 1,
    default => sub {
        return $ENV{BAYON_DEBUG} ? 1 : 0;
    }
);

has cmd => (
    is => 'rw',
    isa => 'Algorithm::Bayon::Cmd',
    lazy => 1,
    handles => [qw/number limit point clvector clvector_size method seed idf/],
    default => sub {
        my $self = shift;
        Algorithm::Bayon::Cmd->new(debug => $self->debug);
    }
);

has file => (
    is => 'rw',
    isa => 'Algorithm::Bayon::File',
    lazy => 1,
    handles => [qw/dump_file load/],
    default => sub {
        my $self = shift;
        Algorithm::Bayon::File->new(debug => $self->debug);
    }
);

no Any::Moose;

sub cluster {
    my $self = shift;
    my %args = @_;
    my $data = $args{data};
    my $labels = $args{labels} || [];

    my $filename = $self->dump_file($data, $labels);
    $self->cmd->run($filename);
    if ($self->debug && $self->cmd->stderr) {
        Carp::confess $self->cmd->stderr;
    }

    my $result = Algorithm::Bayon::Result->new(
        point    => $self->cmd->point,
        input    => $filename,
        raw      => $self->cmd->stdout,
        debug    => $self->debug
    );
    $result->centroid($self->cmd->clvector) if $self->cmd->clvector;
    return $result;
}

1;
__END__

=head1 NAME

Algorithm::Bayon - perl bindings for 'bayon' clustering tool

=head1 SYNOPSIS

  use Algorithm::Bayon;

  my $bayon = Algorithm::Bayon->new;
  $bayon->number(3);

  my $result = $bayon->cluster( data => $data );


=head1 DESCRIPTION

Algorithm::Bayon is

=head1 AUTHOR

taiyoh E<lt>sun.basix@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
