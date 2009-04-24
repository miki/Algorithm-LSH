package Algorithm::LSH::Base;
use strict;
use warnings;
use base qw( Class::Accessor::Fast Class::Data::Inheritable);
use Carp;

__PACKAGE__->mk_accessors($_) for qw( context d L k );

sub new {
    my $class = shift;
    my $self = $class->SUPER::new( {@_} );
    return $self;
}

sub mk_virtual_methods {
    my $class = shift;
    foreach my $method (@_) {
        my $slot = "${class}::${method}";
        {
            no strict 'refs';
            *{$slot} = sub {
                Carp::croak( ref( $_[0] ) . "::${method} is not overridden" );
                }
        }
    }
    return ();
}

sub _check_parameters {
    my $self = shift;
    for my $param ( 'd', 'L', 'k' ) {
        unless ( $self->$param ) {
            croak(
                "ERROR: cannot create object [ new() method had to parameter '$param' is necessary ]"
            );
        }
    }
    if ( $self->k > $self->d ) {
        croak(
            "ERROR: cannot create object [ parameter 'k' must be smaller than parameter 'd' ]"
        );
    }
}

1;
__END__

=head1 NAME

Algorithm::LSH::Base - Base class for Algorithm::LSH

=head1 SYNOPSYS

  package My::Class;
  use base qw(Algorithm::LSH::Base);

=head1 METHODS

=head2 new

=head2 mk_virtual_methods

=head1 AUTHOR

Takeshi Miki E<lt>miki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

