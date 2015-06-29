use 5.006;    # our
use strict;
use warnings;

package Dist::Zilla::Plugin::Author::KENTNL::CONTRIBUTING;

our $VERSION = '0.001000';

# ABSTRACT: Generates a CONTRIBUTING file for KENTNL's distributions.

our $AUTHORITY = 'cpan:KENTNL'; # AUTHORITY

# NB: This list is intentionally short, because these are API-versions
# describing which document to fetch, and certain documents will update
# without changing their API version
my $valid_versions = { map { $_ => 1 } qw( 0.1 ) };

use Carp qw( croak );
use Moose qw( with has around );
use Path::Tiny qw( path );
use File::ShareDir qw( dist_dir );
use Moose::Util::TypeConstraints qw( enum );
use Dist::Zilla::Util::ConfigDumper qw( config_dumper );
with 'Dist::Zilla::Role::AfterBuild';

my $valid_version_enum = enum [ keys %{$valid_versions} ];











has 'document_version' => (
  isa     => $valid_version_enum,
  is      => 'ro',
  default => '0.1',
);

my $valid_formats = enum [qw( pod mkdn txt )];

no Moose::Util::TypeConstraints;











has 'format' => (
  isa     => $valid_formats,
  is      => 'ro',
  default => 'mkdn',
);









has 'filename' => (
  isa        => 'Str',
  is         => 'ro',
  lazy_build => 1,
);

around dump_config => config_dumper( __PACKAGE__, qw( document_version format filename ), );

__PACKAGE__->meta->make_immutable;
no Moose;

sub _distname {
  my $x = __PACKAGE__;
  $x =~ s/::/-/sxg;
  return $x;
}





sub after_build {
  my ($self) = @_;
  my $source = path( dist_dir( _distname() ) )->child( 'contributing-' . $self->document_version . '.pod' );
  my $target = path( $self->zilla->root )->child( $self->filename );
  my $sub    = '_convert_pod_' . $self->format;
  croak "No such method $sub for format " . $self->format if not $self->can($sub);
  $self->$sub( $source, $target );
  return;
}

sub _build_filename {
  my ($self) = @_;
  my $prefix = 'CONTRIBUTING';
  my $exts = { 'pod' => '.pod', 'mkdn' => '.mkdn', 'txt' => q[] };
  if ( exists $exts->{ $self->format } ) {
    $prefix .= $exts->{ $self->format };
  }
  return $prefix;
}

sub _convert_pod_pod {
  my ( undef, $source, $target ) = @_;
  path($source)->copy($target);
  return;
}

sub _convert_pod_txt {
  my ( undef, $source, $target ) = @_;
  require Pod::Text;
  my $parser = Pod::Text->new( loose => 1 );
  $parser->output_fh( $target->openw_utf8 );
  $parser->parse_file( $source->openr_utf8 );
  return;
}

sub _convert_pod_mkdn {
  my ( undef, $source, $target ) = @_;
  require Pod::Markdown;
  Pod::Markdown->VERSION('2.000');
  my $parser = Pod::Markdown->new();
  $parser->output_fh( $target->openw_utf8 );
  $parser->parse_file( $source->openr_utf8 );
  return;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Dist::Zilla::Plugin::Author::KENTNL::CONTRIBUTING - Generates a CONTRIBUTING file for KENTNL's distributions.

=head1 VERSION

version 0.001000

=head1 DESCRIPTION

This is a personal Dist::Zilla plug-in that generates a CONTRIBUTING
section in my distribution.

I would have made something more general, but my head exploded in thinking about it.

=head1 ATTRIBUTES

=head2 C<document_version>

Specify which shared document to deploy

Valid values:

  [0.1]

=head2 C<format>

Document format to emit.

Valid values:

  pod [mkdn] txt

=head2 C<filename>

The filename to create.

Defaults to C<CONTRIBUTING> with an extension based on the value of L</format>

=for Pod::Coverage after_build

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
