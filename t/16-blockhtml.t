#! perl
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 Markdown block HTML

=head2 Synopsis

    % perl t/16-blockhtml.t

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 3;
use Test::More;

language_output_is( 'markdown', <<'CODE', <<'OUT', 'HTML table' );

This is a regular paragraph.

<table>
    <tr>
        <td>Foo</td>
        <td>Bar</td>
    </tr>
</table>

This is another regular paragraph.

CODE
<p>This is a regular paragraph.</p>

<table>
    <tr>
        <td>Foo</td>
        <td>Bar</td>
    </tr>
</table>

<p>This is another regular paragraph.</p>
OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'comments' );

<!--
    multiline
    comment
-->

CODE
<!--
    multiline
    comment
-->
OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'hr' );

<hr size=12 />

CODE
<hr size=12 />
OUT


# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
