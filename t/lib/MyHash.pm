package MyHash;
use strict;
use warnings;
use base qw(Algorithm::LSH::Hash);

sub do_hashing {
    my $self = shift;
    return ["something arrayref"];
}

1;