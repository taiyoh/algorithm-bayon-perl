package Algorithm::Bayon::Result;

use Any::Moose;
with 'Algorithm::Bayon::Role::File';

has point => (
    is => 'ro',
    isa => 'Bool',
    required => 1,
);

has [qw/raw input/] => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has centroid => (
    is => 'rw',
    isa => 'Str',
);

has classified => (
    is => 'ro',
    isa => 'Bool',
    default => sub { 0 },
);

around to_file => sub {
    my ($orig, $self) = @_;
    return $orig->($self, sub { print $_ $self->raw; });
};

no Any::Moose;

sub BUILD {
    my $cls = shift;
    if ( !$cls->classified ) {
        $cls->meta->add_attribute(
            classify => (
                is      => 'rw',
                isa     => 'Algorithm::Bayon::CmdClassify',
                lazy    => 1,
                handles => [qw/inv_keys inv_size classify_size file idf/],
                default => sub {
                    my $self = shift;
                    Any::Moose::load_class('Algorithm::Bayon::CmdClassify')
                      unless Any::Moose::is_class_loaded('Algorithm::Bayon::CmdClassify');
                    Algorithm::Bayon::CmdClassify->new(
                        debug => $self->debug,
                        file  => $self->centroid
                    );
                }
            )
        );

        $cls->meta->add_method(
            to_classify => sub {
                my $self = shift;
                $self->classify->run( $self->input );

                my $klass = ref $self;
                return $klass->new(
                    point      => 1,
                    raw        => $self->classify->stdout,
                    debug      => $self->debug,
                    input      => $self->input,
                    classified => 1
                );
            }
        ) if $cls->centroid;
    }
}

sub to_list {
    my $self = shift;
    my @data_list = map {
        my ($id, @list) = $self->parse_and_fields($_);
        my $fields = $self->point ? do { my %l = @list; \%l } : \@list;
        { id => $id, list => $fields }
    } split "\n", $self->raw;
    return wantarray ? @data_list : \@data_list;
}

1;
