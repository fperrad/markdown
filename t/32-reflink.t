#! /usr/local/bin/parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 Markdown reference link

=head2 Synopsis

    % parrot t/32-reflink.t

=cut

.sub 'main' :main
    load_language 'markdown'

    .include 'test_more.pir'

    plan(4)

    test_double()
    test_simple1()
    test_simple2()
    test_pathologic()
.end

.sub 'test_double'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

You can also put the [link URL][1] below the current paragraph like [this][2].

   [1]: http://url
   [2]: http://another.url "A funky title"

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'reference link double')
<p>You can also put the <a href="http://url">link URL</a> below the current paragraph like <a href="http://another.url" title="A funky title">this</a>.</p>
HTML
.end

.sub 'test_simple1'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

Or you can use a [shortcut][] reference, which links the text "shortcut"

   [shortcut]: http://goes/with/the/link/name/text

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'reference link simple')
<p>Or you can use a <a href="http://goes/with/the/link/name/text">shortcut</a> reference, which links the text "shortcut"</p>
HTML
.end

.sub 'test_simple2'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

Or you can use a [shortcut][] reference, which links the text "shortcut"
to the link named "[shortcut]" on the next paragraph.

   [shortcut]: http://goes/with/the/link/name/text

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'reference link simple')
<p>Or you can use a <a href="http://goes/with/the/link/name/text">shortcut</a> reference, which links the text "shortcut"
to the link named "[shortcut]" on the next paragraph.</p>
HTML
.end

.sub 'test_pathologic'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

With [embedded [brackets]] [b].

[b]: /url/

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'pathologic label reference link')
<p>With <a href="/url/">embedded [brackets]</a>.</p>
HTML
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

