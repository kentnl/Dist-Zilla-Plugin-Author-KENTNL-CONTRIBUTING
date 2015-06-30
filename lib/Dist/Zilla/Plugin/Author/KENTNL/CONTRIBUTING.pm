use 5.006;    # our
use strict;
use warnings;

package Dist::Zilla::Plugin::Author::KENTNL::CONTRIBUTING;

our $VERSION = '0.001003';

# ABSTRACT: Generates a CONTRIBUTING file for KENTNL's distributions.

our $AUTHORITY = 'cpan:KENTNL'; # AUTHORITY

# NB: This list is intentionally short, because these are API-versions
# describing which document to fetch, and certain documents will update
# without changing their API version
my $valid_versions = { map { $_ => 1 } qw( 0.1 ) };

use Carp qw( croak );
use Moose qw( with has around extends );
use Path::Tiny qw( path );
use File::ShareDir qw( dist_dir );
use Moose::Util::TypeConstraints qw( enum );
use Dist::Zilla::Util::ConfigDumper qw( config_dumper );

extends 'Dist::Zilla::Plugin::GenerateFile::ShareDir';

my $valid_version_enum = enum [ keys %{$valid_versions} ];











has 'document_version' => (
  isa     => $valid_version_enum,
  is      => 'ro',
  default => '0.1',
);

no Moose::Util::TypeConstraints;









has '+filename' => (
  lazy => 1,
  default => sub { 'CONTRIBUTING.pod' },
);

has '+source_filename' => (
  lazy => 1,
  default => sub { $_[0]->_build_source_filename },
);

around dump_config => config_dumper( __PACKAGE__, qw( document_version filename ), );

__PACKAGE__->meta->make_immutable;
no Moose;

sub _build_source_filename {
  my ( $self , ) = @_;
  return 'contributing-' . $self->document_version . '.pod';
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Dist::Zilla::Plugin::Author::KENTNL::CONTRIBUTING - Generates a CONTRIBUTING file for KENTNL's distributions.

=head1 VERSION

version 0.001003

=head1 DESCRIPTION

This is a personal Dist::Zilla plug-in that generates a CONTRIBUTING
section in my distribution.

I would have made something more general, but my head exploded in thinking about it.

=head1 ATTRIBUTES

=head2 C<document_version>

Specify which shared document to deploy

Valid values:

  [0.1]

=head2 C<filename>

The file name to create.

Defaults to C<CONTRIBUTING> with an extension based on the value of L</format>

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 CONTRIBUTOR

=for stopwords David Golden

David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
