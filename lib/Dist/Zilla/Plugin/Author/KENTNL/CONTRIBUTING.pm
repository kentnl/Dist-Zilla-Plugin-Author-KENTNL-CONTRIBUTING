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
our $valid_versions = { map { $_ => 1 } qw( 0.1 ) };

use Moose qw( with has );
use Path::Tiny qw( path );
use File::ShareDir qw( dist_dir );
use Moose::Util::TypeConstraints qw( enum );
with 'Dist::Zilla::Role::AfterBuild';

my $valid_version_enum = enum [ keys %{$valid_versions} ];

has "document_version" => (
  isa     => $valid_version_enum,
  is      => 'ro',
  default => '0.1',
);

my $valid_formats = enum [qw( pod mkdn txt )];

has "format" => (
  isa     => $valid_formats,
  is      => 'ro',
  default => 'mkdn',
);

has "filename" => (
  isa        => 'Str',
  is         => 'ro',
  lazy_build => 1
);

__PACKAGE__->meta->make_immutable;
no Moose;

sub distname {
  my $x = __PACKAGE__;
  $x =~ s/::/-/g;
  return $x;
}

sub after_build {
  my ($self) = @_;
  my $source = path( dist_dir( distname() ) )->child( 'contributing-' . $self->document_version . '.pod' );
  my $target = path( $self->zilla->root )->child( $self->filename );
  my $sub = "_convert_pod_" . $self->format;
  die "No such method $sub for format " . $self->format if not $self->can($sub);
  $self->$sub( $source, $target );
}

sub _build_filename {
  my ($self) = @_;
  my $prefix = "CONTRIBUTING";
  my $exts = { 'pod' => '.pod', 'mkdn' => '.mkdn', 'txt' => '' };
  if ( exists $exts->{ $self->format } ) {
    $prefix .= $exts->{ $self->format };
  }
  return $prefix;
}

sub _convert_pod_pod {
  my ( $self, $source, $target ) = @_;
  path($source)->copy($target);
}

sub _convert_pod_txt {
  my ( $self, $source, $target ) = @_;
  require Pod::Text;
  my $parser = Pod::Text->new( loose => 1 );
  $parser->output_fh( $target->openw_utf8 );
  $parser->parse_file( $source->openr_utf8 );
}

sub _convert_pod_mkdn {
  my ( $self, $source, $target ) = @_;
  require Pod::Markdown;
  Pod::Markdown->VERSION('2.000');
  my $parser = Pod::Markdown->new();
  $parser->output_fh( $target->openw_utf8 );
  $parser->parse_file( $source->openr_utf8 );
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
