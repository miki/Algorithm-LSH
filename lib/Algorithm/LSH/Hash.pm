package Algorithm::LSH::Hash;
use strict;
use warnings;
use base qw(Algorithm::LSH::Base);

__PACKAGE__->mk_virtual_methods($_) for qw(do_hashing);

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
    $self->_check_parameters;
    return $self;
}

1;
__END__

=head1 NAME

Algorithm::LSH::Hash - Base class for Algorithm::LSH::Hash::XXX 

=head1 SYNOPSYS

  package MyHash;
  use baes qw(Algorithm::LSH::Hash);

  sub do_hashing {
     # do something
  }
  
  1;  

=head1 METHODS

=head2 new

=head1 AUTHOR

Takeshi Miki E<lt>miki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

