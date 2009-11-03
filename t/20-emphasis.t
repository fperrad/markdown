#! parrot
# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 Markdown emphasis

=head2 Synopsis

    % parrot t/20-emphasis.t

=cut

.sub 'main' :main
    load_language 'markdown'

    .include 'test_more.pir'

    plan(4)

    test_emphasis_star()
    test_strong_star()
    test_emphasis_UI()
    test_strong_UI()
.end

.sub 'test_emphasis_star'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

*emphasis* (e.g., italics)

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'emphasis star')
<p><em>emphasis</em> (e.g., italics)</p>
HTML
.end

.sub 'test_strong_star'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

**strong emphasis** (e.g., boldface)

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'strong star')
<p><strong>strong emphasis</strong> (e.g., boldface)</p>
HTML
.end

.sub 'test_emphasis_UI'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

_emphasis_ (e.g., italics)

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'emphasis UI')
<p><em>emphasis</em> (e.g., italics)</p>
HTML
.end

.sub 'test_strong_UI'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

__strong emphasis__ (e.g., boldface)

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'strong UI')
<p><strong>strong emphasis</strong> (e.g., boldface)</p>
HTML
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

