package Algorithm::LSH::Storage;
use strict;
use warnings;
use base qw(Algorithm::LSH::Base);

__PACKAGE__->mk_virtual_methods($_) for qw(save load);

1;
__END__

=head1 NAME

Algorithm::LSH::Storage - Base class for Algorithm::LSH::Storage::XXX 

=head1 SYNOPSYS

  package MyStorage;
  use baes qw(Algorithm::LSH::Storage);

  sub save{ 
     # do something
  }
  
  sub load{ 
     # do something
  }

  1;  

=head1 METHODS

=head1 AUTHOR

Takeshi Miki E<lt>miki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

