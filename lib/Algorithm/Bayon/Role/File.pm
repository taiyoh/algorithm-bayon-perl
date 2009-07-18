package Algorithm::Bayon::Role::File;

use Any::Moose '::Role';
use utf8;
use Carp;

use File::Temp ();
use Text::CSV_XS;

has csv => (
    is => 'rw',
    isa => 'Text::CSV_XS',
    lazy => 1,
    default => sub {
        Text::CSV_XS->new({binary => 1, sep_char => "\t"});
    },
);

has debug => (
    is => 'rw',
    isa => 'Bool',
    lazy => 1,
    default => 0
);

no Any::Moose '::Role';

sub get_tempfile { File::Temp::tempfile( SUFFIX => '.tsv' ) }

sub combine_and_string {
    my $self = shift;
    $self->csv->combine(@_);
    return $self->csv->string;
}

sub parse_and_fields {
    my $self = shift;
    $self->csv->parse(shift);
    return $self->csv->fields;
}

sub to_file {
    my $self = shift;
    my $callback = shift;

    my ($fh, $filename) = $self->get_tempfile();
    $self->register_file($filename);
    print STDERR "[DEBUG] generated: $filename\n" if $self->debug;
    local $_ = $fh;
    $callback->();
    close $fh;
    return $filename;
}

do {
    my @files;

    sub register_file {
        my $self = shift;
        push @files, shift;
    }

    sub END { unlink $_ for @files; }
};

1;
