use inc::Module::Install;
name 'Algorithm-LSH';
all_from 'lib/Algorithm/LSH.pm';

requires 'Class::Accessor::Fast';
requires 'Class::Data::Inheritable';
requires 'Carp';
requires 'Storable';
requires 'UNIVERSAL::require';
requires 'List::Util';
requires 'List::MoreUtils';
requires 'Scalar::Util';

build_requires 'FindBin::libs';;
build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
