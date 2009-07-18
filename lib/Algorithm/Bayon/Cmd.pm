package Algorithm::Bayon::Cmd;

use Any::Moose;
with 'Algorithm::Bayon::Role::Cmd';

has number => (
    is => 'rw',
    isa => 'Int',
);

has limit => (
    is => 'rw',
    isa => 'Num',
);

has point => (
    is => 'rw',
    isa => 'Bool',
    lazy => 1,
    default => 0
);

# sprintf('centroid%s_%s.tsv', time(), int(rand()*1000));
has clvector => (
    is => 'rw',
    isa => 'Str',
);

has clvector_size => (
    is => 'rw',
    isa => 'Int',
    lazy => 1,
    default => 50,
);

has method => (
    is => 'rw',
    isa => 'Str',
    lazy => 1,
    default => 'rb',
);

has seed => (
    is => 'rw',
    isa => 'Int',
);

has idf => (
    is => 'rw',
    isa => 'Bool',
    lazy => 1,
    default => 0
);

no Any::Moose;

sub build_command {
    my $self = shift;

    my @args;
    Carp::croak "none of number or limit"
        if !$self->number && !$self->limit;
    if ( $self->number ) {
        push @args, "-n $self->{number}";
    }
    else {
        push @args, "-l $self->{limit}";
    }

    push @args, '-p' if $self->point;
    push @args, "--clvector=$self->{clvector}" if $self->clvector;
    push @args, "--clvector-size=".$self->clvector_size;
    my $method = $self->method;
    $method = 'rb' if $method ne 'kmeans';
    push @args, "--method=".$method;
    push @args, "--seed=".$self->seed if $self->seed;
    push @args, "--idf" if $self->idf;

    return @args;
}

1;
