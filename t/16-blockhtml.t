#! parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 Markdown block HTML

=head2 Synopsis

    % parrot t/16-blockhtml.t

=cut

.sub 'main' :main
    load_language 'markdown'

    .include 'test_more.pir'

    plan(3)

    test_HTML_table()
    test_comments()
    test_hr()
.end

.sub 'test_HTML_table'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

This is a regular paragraph.

<table>
    <tr>
        <td>Foo</td>
        <td>Bar</td>
    </tr>
</table>

This is another regular paragraph.

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'HTML table')
<p>This is a regular paragraph.</p>

<table>
    <tr>
        <td>Foo</td>
        <td>Bar</td>
    </tr>
</table>

<p>This is another regular paragraph.</p>
HTML
.end

.sub 'test_comments'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

<!--
    multiline
    comment
-->

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'comments')
<!--
    multiline
    comment
-->
HTML
.end

.sub 'test_hr'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

<hr size=12 />

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'hr')
<hr size=12 />
HTML
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

