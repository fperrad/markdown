#! parrot
# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 Markdown smart extensions

=head2 Synopsis

    % parrot t/24-smart.t

=cut

.sub 'main' :main
    load_language 'markdown'

    .include 'test_more.pir'

    plan(2)

#    test_apostrophe()
    test_ellipsis()
#    test_endash()
    test_emdash()
.end

.sub 'test_apostrophe'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

smart '

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'apostrophe')
<p>smart &rsquo;</p>
HTML
.end

.sub 'test_ellipsis'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

smart ...

smart . . .

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'ellipsis')
<p>smart &hellip;</p>

<p>smart &hellip;</p>
HTML
.end

.sub 'test_endash'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

smart -

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'endash')
<p>smart &ndash;</p>
HTML
.end

.sub 'test_emdash'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

smart --

smart ---

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'emdash')
<p>smart &mdash;</p>

<p>smart &mdash;</p>
HTML
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

