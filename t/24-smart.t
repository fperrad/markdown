#! perl
# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 Markdown smart extensions

=head2 Synopsis

    % perl t/24-smart.t

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 2;
use Test::More;

#language_output_is( 'markdown', <<'CODE', <<'OUT', 'apostrophe' );
#
#smart '
#
#CODE
#<p>smart &rsquo;</p>
#
#OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'ellipsis' );

smart ...

smart . . .

CODE
<p>smart &hellip;</p>

<p>smart &hellip;</p>

OUT

#language_output_is( 'markdown', <<'CODE', <<'OUT', 'endash' );
#
#smart -
#
#CODE
#<p>smart &ndash;</p>
#
#OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'emdash' );

smart --

smart ---

CODE
<p>smart &mdash;</p>

<p>smart &mdash;</p>

OUT


# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
