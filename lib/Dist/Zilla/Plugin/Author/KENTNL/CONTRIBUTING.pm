use 5.006;    # our
use strict;
use warnings;

package Dist::Zilla::Plugin::Author::KENTNL::CONTRIBUTING;

our $VERSION = '0.001005';

# ABSTRACT: Generates a CONTRIBUTING file for KENTNL's distributions.

# AUTHORITY

# NB: This list is intentionally short, because these are API-versions
# describing which document to fetch, and certain documents will update
# without changing their API version
my $valid_versions = { map { $_ => 1 } qw( 0.1 ) };

use Carp qw( croak );
use Path::Tiny qw( path );
use Moose qw( has around extends );
use Moose::Util::TypeConstraints qw( enum );
use Dist::Zilla::Util::ConfigDumper qw( config_dumper );
use Dist::Zilla::Plugin::GenerateFile::ShareDir 0.006;

extends 'Dist::Zilla::Plugin::GenerateFile::ShareDir';

my $valid_version_enum = enum [ keys %{$valid_versions} ];

no Moose::Util::TypeConstraints;

=attr C<document_version>

Specify which shared document to deploy

Valid values:

  [0.1]

=cut

has 'document_version' => (
  isa     => $valid_version_enum,
  is      => 'ro',
  default => '0.1',
);

has '+filename' => (
  lazy    => 1,
  default => sub { 'CONTRIBUTING.pod' },
);

has '+source_filename' => (
  lazy    => 1,
  default => sub { 'contributing-' . $_[0]->document_version . '.pod' },
);

has '+location' => (
  lazy    => 1,
  default => sub { 'root' },
);

has '+phase' => (
  lazy    => 1,
  default => sub { 'build' },
);

around dump_config => config_dumper( __PACKAGE__, qw( document_version ), );

__PACKAGE__->meta->make_immutable;
no Moose;

1;

=head1 DESCRIPTION

This is a personal Dist::Zilla plug-in that generates a CONTRIBUTING
section in my distribution.

I would have made something more general, but my head exploded in thinking about it.
