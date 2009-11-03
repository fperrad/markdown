#! parrot
# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 Markdown list

=head2 Synopsis

    % parrot t/14-list.t

=cut

.sub 'main' :main
    load_language 'markdown'

    .include 'test_more.pir'

    plan(5)

    test_unordered_tight()
    test_ordered_tight()
    test_unordered_loose()
    test_with_continuation()
    test_with_multi_para()
.end

.sub 'test_unordered_tight'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

- An item in a bulleted (unordered) list
- Another item in a bulleted list

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'unordered tight')
<ul>
<li>An item in a bulleted (unordered) list</li>
<li>Another item in a bulleted list</li>
</ul>
HTML
.end

.sub 'test_ordered_tight'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

1. An item in a enumeradted (ordered) list
2. Another item in a enumeradted list

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'ordered tight')
<ol>
<li>An item in a enumeradted (ordered) list</li>
<li>Another item in a enumeradted list</li>
</ol>
HTML
.end

.sub 'test_unordered_loose'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

* Bird

* Magic

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'unordered loose')
<ul>
<li><p>Bird</p></li>
<li><p>Magic</p></li>
</ul>
HTML
.end

.sub 'test_with_continuation'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

*   A list item.
    With continuation.
*   Another item in the list.

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'with continuation')
<ul>
<li>A list item.
With continuation.</li>
<li>Another item in the list.</li>
</ul>
HTML
.end

.sub 'test_with_multi_para'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

*   Para 1.

    Para 2.

*   Another item in the list.

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'with multi-para')
<ul>
<li><p>Para 1.</p>

<p>Para 2.</p></li>
<li><p>Another item in the list.</p></li>
</ul>
HTML
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

