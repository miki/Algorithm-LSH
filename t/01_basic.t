use strict;
use warnings;
use Algorithm::LSH;
use Test::More tests => 15;

{
    my $lsh = Algorithm::LSH->new(d => 100, L =>3, k => 10);
    isa_ok( $lsh,          'Algorithm::LSH' );
    isa_ok( $lsh->hash,    'Algorithm::LSH::Hash::Hamming' );
    isa_ok( $lsh->storage, 'Algorithm::LSH::Storage::Storable' );
    isa_ok( $lsh->bucket,  'Algorithm::LSH::Bucket' );
}

{
    my $lsh = Algorithm::LSH->new(d => 100, L =>3, k => 10);
    can_ok( $lsh, 'new' );
    can_ok( $lsh, 'nearest_neighbours' );
    can_ok( $lsh, 'nn' );
    can_ok( $lsh, 'neighbours' );
    can_ok( $lsh, 'nearest' );
    can_ok( $lsh, 'distance' );
    can_ok( $lsh, 'save' );
    can_ok( $lsh, 'load' );
    can_ok( $lsh, 'hash' );
    can_ok( $lsh, 'storage' );
    can_ok( $lsh, 'bucket' );
}
