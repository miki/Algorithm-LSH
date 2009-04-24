package Algorithm::LSH::Storage::Storable;
use strict;
use warnings;
use Storable qw(store retrieve);
use base qw(Algorithm::LSH::Storage);

sub save {
    my $self = shift;
    my $file_path = shift;
    store($self->context, $file_path);
}

sub load {
    my $self = shift;
    my $file_path = shift;
    retrieve($file_path);
}

1;
__END__

=head1 NAME

Algorithm::LSH::Storage::Storable - Storage class (it uses Storable) 

=head1 SYNOPSYS

  use Algorithm::LSH::Storage::Storable;

  my $storage = Algorithm::LSH::Storage::Storable->new;
  $storage->save($file_path);
  $storage->load($file_path);

=head1 METHODS

=head2 save

=head2 load

=head1 AUTHOR

Takeshi Miki E<lt>miki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

