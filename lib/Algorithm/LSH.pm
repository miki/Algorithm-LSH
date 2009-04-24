package Algorithm::LSH;
use strict;
use warnings;
use base qw(Algorithm::LSH::Base);
use Algorithm::LSH::Bucket;
use UNIVERSAL::require;
use Scalar::Util qw(blessed);
use Carp;
use Storable qw( retrieve store );

our $VERSION = '0.00001_01';

__PACKAGE__->mk_accessors($_) for qw( hash bucket storage );

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
    $self->_setup(@_);
    return $self;
}

sub insert {
    my $self = shift;
    my ( $label, $vector ) = @_;
    my $hashed_arrayref = $self->hash->do_hashing($vector);
    $self->bucket->insert( $label, $vector, $hashed_arrayref );
}

sub nn {
    my $self = shift;
    my $nn   = $self->nearest_neighbours(@_);
    return $nn;
}

sub nearest_neighbours {
    my $self         = shift;
    my $vector       = shift;
    my $without_self = shift;
    my $neighbours   = $self->neighbours( $vector, $without_self );
    my $nn           = $self->nearest( $vector, $neighbours );
    return $nn;
}

sub neighbours {
    my $self            = shift;
    my $vector          = shift;
    my $without_self    = shift;
    my $hashed_arrayref = $self->hash->do_hashing($vector);
    my $neighbours =
      $self->bucket->select( $vector, $hashed_arrayref, $without_self );
    return $neighbours;
}

sub nearest {
    my $self       = shift;
    my $vector     = shift;
    my $neighbours = shift;
    my %nearest;
    for (@$neighbours) {
        my ( $n_label, $n_vector ) = each %$_;
        my $dist = $self->distance( $vector, $n_vector );
        if ( ! defined $nearest{distance} || $dist < $nearest{distance} ) {
            $nearest{label}    = $n_label;
            $nearest{vector}   = $n_vector;
            $nearest{distance} = $dist;
        }
    }
    return \%nearest;
}

sub distance {
    my $self     = shift;
    my $vector_1 = shift;
    my $vector_2 = shift;
    my $sum;
    for my $i ( 0 .. @{$vector_1} - 1 ) {
        my $d = ( $vector_1->[$i] - $vector_2->[$i] )**2;
        $sum += $d;
    }
    my $distance = sqrt($sum);
    return $distance;
}

sub save {
    my $self = shift;
    my $file_path = shift || './save.bin';
    $self->storage->save($file_path);
}

sub load {
    my $self      = shift;
    my $file_path = shift || './save.bin';
    my $data      = $self->storage->load($file_path);
    my $class     = blessed $data->hash;
    $class->use;
    for ( keys %$data ) {
        $self->$_( $data->$_ );
    }
}

sub _setup {
    my $self = shift;

    # param check
    $self->_check_parameters;

    # dynamic load (hash class)
    my $hash_class = delete $self->{hash_class};
    $hash_class ||= 'Algorithm::LSH::Hash::Hamming';
    $hash_class->require or croak $@;
    $self->hash( $hash_class->new( context => $self, @_ ) );

    # dynamic loading (storage class)
    my $storage_class = delete $self->{storage_class};
    $storage_class ||= 'Algorithm::LSH::Storage::Storable';
    $storage_class->require or croak $@;
    $self->storage( $storage_class->new( context => $self, @_ ) );

    # bucket class
    $self->bucket( Algorithm::LSH::Bucket->new( context => $self, @_ ) );
}

1;
__END__

=head1 NAME

Algorithm::LSH - perl implementation of Locality Sensitive Hashing

=head1 SYNOPSIS

  use Algorithm::LSH;

  my $lsh = Algorithm::LSH->new(
      L => 5,   # number of hash functions
      k => 10,  # number of reductions
      d => 3,   # number of dimentions,
  );

  
  while(my($label, $vector) = each %database){
      $lsh->insert($label, $vector);
  }

  $lsh->save("data.bin");

  my $query_vector = [ 123, 456, 789 ];

  $lsh->load("data.bin");

  my $neighbours = $lsh->neighbours($query_vector);
  my $nearest    = $lsh->nearest($neighbours);

  # or 

  my $nearest    = $lsh->nearest_neighbours($query_vector);

  # or 

  my $nearest    = $lsh->nn($query_vector);

=head1 DESCRIPTION

Algorithm::LSH is a perl implementation of Locality Sensitive Hashing algorithm.

B<THIS MODULE IS IN ITS VERY ALPHA QUALITY.>

=head1 METHODS

=head2 new

constructor. it needs three parameters.

      L :  a number of hash function. 
      k :  a number of reduction. it must be smaller than parameter 'd'.
      d :  a number of dimention.

=head2 insert

insert a vector data to buckets.

=head2 neighbours

it extracts some datas as neighbours with query vector.

=head2 nearest

pickup 1 nearest data from neighbours.

=head2 nearest_neighbours

it does neighbours() and nearset() at onece.

=head2 nn

an alias of nearest_neighbours()

=head2 distance

=head2 save

save the data to storage.

=head2 load

load th data from storage

=head2 hash

accessor method

=head2 bucket

accessor method

=head2 storage

accessor method

=head1 AUTHOR

Takeshi Miki E<lt>miki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
