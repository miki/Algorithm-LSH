use strict;
use warnings;
use Algorithm::LSH;
use FindBin::libs;
use Test::More tests => 4;

{
    my $lsh = Algorithm::LSH->new(
        d          => 100,
        L          => 5,
        k          => 5,
        hash_class => 'MyHash',
    );
    isa_ok( $lsh->hash, "MyHash" );
    my $result = $lsh->hash->do_hashing;
    is_deeply( $result, ["something arrayref"], "do_hashing() work OK" );
}

{
    my $lsh = Algorithm::LSH->new(
        d          => 100,
        L          => 5,
        k          => 5,
        hash_class => 'MyHash_has_no_method',
    );
    isa_ok( $lsh->hash, "MyHash_has_no_method" );
    eval { $lsh->hash->do_hashing; };
    like(
        $@,
        qr/MyHash_has_no_method::do_hashing is not overridden/,
        'mk_virtual_methods() work correctly'
    );
}