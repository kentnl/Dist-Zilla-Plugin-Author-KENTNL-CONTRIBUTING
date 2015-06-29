use 5.006;  # our
use strict;
use warnings;

package Dist::Zilla::Plugin::Author::KENTNL::CONTRIBUTING;

our $VERSION = '0.001000';

# ABSTRACT: Generates a CONTRIBUTING file for KENTNL's distributions.

# AUTHORITY

use Moose;

__PACKAGE__->meta->make_immutable;
no Moose;

1;

=head1 DESCRIPTION

This is a personal Dist::Zilla plug-in that generates a CONTRIBUTING
section in my distribution.
