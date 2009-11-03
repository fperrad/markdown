#! parrot
# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 Markdown paragraph

=head2 Synopsis

    % parrot t/13-para.t

=cut

.sub 'main' :main
    load_language 'markdown'

    .include 'test_more.pir'

    plan(2)

    test_Para1()
    test_ParaMultiLine()
.end

.sub 'test_Para1'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

This is a paragraph. It has two sentences.

This is another paragraph. It also has two sentences.

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'Para 1')
<p>This is a paragraph. It has two sentences.</p>

<p>This is another paragraph. It also has two sentences.</p>
HTML
.end

.sub 'test_ParaMultiLine'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

This is a paragraph.
It has two sentences.

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'Para multi-line')
<p>This is a paragraph.
It has two sentences.</p>
HTML
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

