#! perl
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 Markdown reference link

=head2 Synopsis

    % perl t/32-reflink.t

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 4;
use Test::More;

language_output_is( 'markdown', <<'CODE', <<'OUT', 'reference link double' );

You can also put the [link URL][1] below the current paragraph like [this][2].

   [1]: http://url
   [2]: http://another.url "A funky title"

CODE
<p>You can also put the <a href="http://url">link URL</a> below the current paragraph like <a href="http://another.url" title="A funky title">this</a>.</p>
OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'reference link simple' );

Or you can use a [shortcut][] reference, which links the text "shortcut"

   [shortcut]: http://goes/with/the/link/name/text

CODE
<p>Or you can use a <a href="http://goes/with/the/link/name/text">shortcut</a> reference, which links the text "shortcut"</p>
OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'reference link simple' );

Or you can use a [shortcut][] reference, which links the text "shortcut"
to the link named "[shortcut]" on the next paragraph.

   [shortcut]: http://goes/with/the/link/name/text

CODE
<p>Or you can use a <a href="http://goes/with/the/link/name/text">shortcut</a> reference, which links the text "shortcut"
to the link named "[shortcut]" on the next paragraph.</p>
OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'pathologic label reference link' );

With [embedded [brackets]] [b].

[b]: /url/

CODE
<p>With <a href="/url/">embedded [brackets]</a>.</p>
OUT


# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
