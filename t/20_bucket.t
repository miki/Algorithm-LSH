use strict;
use warnings;
use Algorithm::LSH::Bucket;
use Test::More tests => 3;
use Data::Dumper;

{
    my $bucket = Algorithm::LSH::Bucket->new;
    isa_ok($bucket, 'Algorithm::LSH::Bucket');
    can_ok($bucket, 'insert');
    can_ok($bucket, 'select');
}