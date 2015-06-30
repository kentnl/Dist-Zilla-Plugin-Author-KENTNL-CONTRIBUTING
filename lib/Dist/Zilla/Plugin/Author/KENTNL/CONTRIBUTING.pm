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
use Path::Tiny qw( path );
use Moose qw( has around extends with );
use Moose::Util::TypeConstraints qw( enum );
use Dist::Zilla::Util::ConfigDumper qw( config_dumper );

extends 'Dist::Zilla::Plugin::GenerateFile::ShareDir';
with 'Dist::Zilla::Role::FilePruner', 'Dist::Zilla::Role::AfterBuild';

my $valid_version_enum = enum [ keys %{$valid_versions} ];

no Moose::Util::TypeConstraints;











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

around dump_config => config_dumper( __PACKAGE__, qw( document_version ), );

## NB: The following lines of garbage is what you have to do to use a thing that gathers files
## but have it appear on disk, and not in the release.
## This file *cannot* appear in the release because EUMM is stupid and installs *.pod files
## In the root directory.
has '_secret_stash' => (
  isa     => 'ArrayRef',
  is      => 'ro',
  default => sub { [] },
);

__PACKAGE__->meta->make_immutable;
no Moose;

# DGAF





sub prune_files {
  my ($self) = @_;
  for my $file ( (), @{ $self->zilla->files } ) {
    next unless $file->name eq $self->filename;
    $self->log_debug( [ "Stashing %s ( %s )", $file->name, $file ] );
    push @{ $self->_secret_stash }, $file;
    $self->zilla->prune_file($file);
  }
  return;
}

sub after_build {
  my ($self) = @_;
  for my $file ( (), @{ $self->_secret_stash } ) {

    # Appropriated from Dist::Zilla::write_out_file
    # Okay, this is a bit much, until we have ->debug. -- rjbs, 2008-06-13
    # $self->log("writing out " . $file->name);

    my $file_path = path( $file->name );
    my $to        = path( $self->zilla->root )->child($file_path);
    my $to_dir    = $to->parent;
    $to_dir->mkpath unless -e $to_dir;

    croak "not a directory: $to_dir" unless -d $to_dir;

    $self->log_debug("Overwriting $to");
    $to->spew_raw( $file->encoded_content );
    chmod $file->mode, "$to" or croak "couldn't chmod $to: $!";
  }
  return;
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

=for Pod::Coverage prune_files after_build

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
