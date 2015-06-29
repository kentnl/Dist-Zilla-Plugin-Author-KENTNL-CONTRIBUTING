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

use Moose;

__PACKAGE__->meta->make_immutable;
no Moose;

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
