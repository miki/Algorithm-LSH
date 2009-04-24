package Algorithm::LSH::Bucket;
use strict;
use warnings;
use List::MoreUtils qw(uniq first_index);
use base qw( Algorithm::LSH::Base );

sub insert {
    my $self = shift;
    my ( $label, $vector, $hashed_arrayref ) = @_;
    my $L = $self->L;
    for my $i ( 0 .. $L - 1 ) {
        $self->_put( $i, $vector, $hashed_arrayref->[$i] );
    }
    $self->{label}->{ join( ':', @$vector ) } = $label;
}

sub select {
    my $self = shift;
    my ( $query_vector, $hashed_arrayref, $without_self ) = @_;
    my $query_vector_str = join( ":", @$query_vector );
    my $L = $self->L;
    my @result;
    my %seen;
    for my $i ( 0 .. $L - 1 ) {
        my $hashed = join( "", @{ $hashed_arrayref->[$i] } );
        my $vectors = $self->{data}->[$i]->{$hashed};
        if ( ref $vectors ne 'ARRAY' ) {
            $vectors = $self->_left_light( $hashed, $i );
        }
        for my $vector (@$vectors) {
            my $str = join( ":", @$vector );
            next if defined $seen{$str};
            next if $str eq $query_vector_str && $without_self;
            $seen{$str} = 1;
            push( @result, { $self->{label}->{$str} => $vector } );
        }
        last if @result >= $L * 2;
    }
    return \@result;
}

sub _left_right {
    my $self   = shift;
    my $hashed = shift;
    my $i      = shift;
    my $n      = first_index { $hashed < $_ } @{ $self->index->[$i] };
    if ( $n == 0 || $n == -1 ) {
        return $self->data->[$i]->{ $self->index->[$i]->[$n] };
    }
    else {
        my @result;
        for ( $n - 1, $n ) {
            my $index = $self->index->[$i]->[$_];
            push @result, @{ $self->data->[$i]->{$index} };
        }
        return \@result;
    }
}

sub _put {
    my $self   = shift;
    my $i      = shift;
    my $vector = shift;
    my $hashed = shift;
    $hashed = join( "", @$hashed );
    my $index = $self->{index}->[$i] || [];
    push @$index, $hashed;
    $self->{index}->[$i] = [ uniq sort @$index ];
    push @{ $self->{data}->[$i]->{$hashed} }, $vector;
}

1;
__END__

=head1 NAME

Algorithm::LSH::Bucket - Data bucket class 

=head1 SYNOPSYS

  use Algorithm::LSH::Bucket;
  my $bucket = Algorithm::LSH::Bucket;
  $bucket->insert($label, $vector, $hashed_arrayref);
  $bucket->select($vector, $hashed_arrayref, $without_self_opiton);

=head1 METHODS

=head2 insert

=head2 select

=head1 AUTHOR

Takeshi Miki E<lt>miki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

