package Algorithm::Bayon::CmdClassify;

use Any::Moose;
with 'Algorithm::Bayon::Role::Cmd';

has file => (
    is => 'rw',
    isa => 'Str',
    required => 1,
);

has inv_keys => (
    is => 'rw',
    isa => 'Int',
    default => 20
);

has inv_size => (
    is => 'rw',
    isa => 'Int',
    default => 100
);

has classify_size => (
    is => 'rw',
    isa => 'Int',
    default => 20
);

has idf => (
    is => 'rw',
    isa => 'Bool',
    lazy => 1,
    default => 0
);

no Any::Moose;

#  % bayon -C file [options] file
#     -C, --classify=file   target vectors
#     --inv-keys=num        max size of keys of each vector to be
#                           looked up in inverted index (default: 20)
#     --inv-size=num        max size of inverted index of each key
#                           (default: 100)
#     --classify-size=num   max size of output similar groups
#                           (default: 20)

sub build_command {
    my $self = shift;
    my @args;
    push @args, "--classify=$self->{file}";
    push @args, "--inv-keys=$self->{inv_keys}";
    push @args, "--inv-size=$self->{inv_size}";
    push @args, "--classify-size=$self->{classify_size}";
    push @args, "--idf" if $self->idf;
    return @args;
}

1;
