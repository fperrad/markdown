#! /usr/local/bin/parrot
# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 Markdown entities

=head2 Synopsis

    % parrot t/23-entity.t

=cut

.sub 'main' :main
    load_language 'markdown'

    .include 'test_more.pir'

    plan(2)

    test_CharEntity()
    test_HexEntity()
.end

.sub 'test_CharEntity'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

4 &lt; 5

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'CharEntity')
<p>4 &lt; 5</p>
HTML
.end

.sub 'test_HexEntity'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

20 &#x20ac;.

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'HexEntity')
<p>20 &#x20ac;.</p>
HTML
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

