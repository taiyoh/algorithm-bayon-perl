package Algorithm::Bayon::Role::Cmd;

use Any::Moose '::Role';
use utf8;
use Carp;

use IPC::Run ();

has stderr => (
    is => 'rw',
    isa => 'Str',
    default => ''
);

has stdout => (
    is => 'rw',
    isa => 'Str',
    default => ''
);

has stdin => (
    is => 'rw',
    isa => 'Str',
    default => ''
);

has debug => (
    is => 'rw',
    isa => 'Bool',
    lazy => 1,
    default => 0,
);

requires 'build_command';

no Any::Moose '::Role';

sub run {
    my $self = shift;

    my $filename = shift or Carp::croak 'undef filename';
    my $cmds = [ 'bayon', $self->build_command(), $filename ];

    print STDERR "[DEBUG] @$cmds\n" if $self->debug;
    IPC::Run::run( $cmds, \my $sin, \$self->{stdout}, \$self->{stderr} );
    print STDERR "[DEBUG]".$self->stderr."\n" if $self->debug && $self->stderr;
    print STDERR "[DEBUG] result dumped\n"    if $self->debug && !$self->stderr;
}

1;
