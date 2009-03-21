#! perl
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 Markdown automatic link

=head2 Synopsis

    % perl t/30-autolink.t

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 2;
use Test::More;

language_output_is( 'markdown', <<'CODE', <<'OUT', 'autolink url' );

<http://someurl>

CODE
<p><a href="http://someurl">http://someurl</a></p>

OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'autolink email' );

<somebbob@example.com>

CODE
<p><a href="mailto:somebbob@example.com">somebbob@example.com</a></p>

OUT


# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
