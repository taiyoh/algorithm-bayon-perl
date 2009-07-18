package Algorithm::Bayon::File;

use Any::Moose;
with 'Algorithm::Bayon::Role::File';

no Any::Moose;

sub dump_file {
    my $self = shift;

    my ( $data, $labels ) = @_;
    $self->to_file(sub {
        my $len = @$data - 1;
        for my $n ( 0 .. $len ) {
            my $mid = $labels->[$n] || $n;
            my @fields = ref($data->[$n]) eq 'HASH'
                ? map { $_ => $data->[$n]->{$_} } keys %{ $data->[$n] }
                : @{ $data->[$n] };
            my $str = $self->combine_and_string( $mid, @fields );
            print $_ "$str\n";
        }
    });
}

1;
