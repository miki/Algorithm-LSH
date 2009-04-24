package Algorithm::LSH::Hash::Hamming;
use strict;
use warnings;
use List::Util qw(max);
use Carp;
use base qw(Algorithm::LSH::Hash);

__PACKAGE__->mk_accessors($_) for qw( _indexes );

our $SCALE = 100;

sub do_hashing {
    my $self   = shift;
    my $vector = shift;
    if ( ref $vector ne 'ARRAY' ) {
        carp("args should be an array_ref") and return;
    }
    my $d = $self->d || sub { $self->d( int @$vector ) }
      ->();
    if ( $d != scalar @$vector ) {
        carp("invalid dimention number") and return;
    }
    my $L          = $self->L;
    my $unary_code = $self->_unarize($vector);
    my @hashes;
    for my $i ( 0 .. $L - 1 ) {
        my @array;
        for my $j ( @{ $self->_pickuped_indexes->[$i] } ) {
            push( @array, $unary_code->[$j] );
        }
        push( @hashes, \@array );
    }
    return \@hashes;
}

sub _pickuped_indexes {
    my $self = shift;
    $self->_indexes or sub {
        my @indexes;
        my $L = $self->L;
        for my $i ( 0 .. $L - 1 ) {
            my %seen;
            while (1) {
                my $rand = int( rand( $self->d * $SCALE ) );
                if ( !$seen{$rand} ) {
                    $seen{$rand} = 1;
                    last if keys %seen == $self->k * $SCALE;
                }
            }
            push( @indexes, [ sort { $a <=> $b } keys %seen ] );
        }
        $self->_indexes( \@indexes );
      }
      ->();
}

sub _unarize {
    my $self   = shift;
    my $vector = shift;
    my $max    = max(@$vector);
    my $n      = $SCALE / $max;
    my @unary;
    for (@$vector) {
        my $i = int( $_ * $n );
        my $j = $SCALE - $i;
        for ( 1 .. $i ) {
            push( @unary, 1 );
        }
        for ( 1 .. $j ) {
            push( @unary, 0 );
        }
    }
    return \@unary;
}

1;
__END__

=head1 NAME

Algorithm::LSH::Hash::Hamming - Hash function class (Hamming Distance) 

=head1 SYNOPSYS

  use Algorithm::LSH::Hash::Hamming;
  my $hash = Algorithm::LSH::Hash::Hamming->new;
  my $hashed_array = $hash->do_hashing([123,456,789]);

=head1 METHODS

=head2 do_hashing

=head1 AUTHOR

Takeshi Miki E<lt>miki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

