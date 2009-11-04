#! /usr/local/bin/parrot
# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 Markdown heading

=head2 Synopsis

    % parrot t/10-heading.t

=cut

.sub 'main' :main
    load_language 'markdown'

    .include 'test_more.pir'

    plan(4)

    test_SetextHeading1()
    test_SetextHeading2()
    test_AtxHeading1()
    test_AtxHeading4()
.end

.sub 'test_SetextHeading1'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

First-level heading
===================

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'SetextHeading 1')
<h1>First-level heading</h1>
HTML
.end

.sub 'test_SetextHeading2'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

Second-level heading
--------------------

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'SetextHeading 2')
<h2>Second-level heading</h2>
HTML
.end

.sub 'test_AtxHeading1'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

# First-level heading

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'AtxHeading 1')
<h1>First-level heading</h1>
HTML
.end

.sub 'test_AtxHeading4'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

#### Fourth-level heading ####

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'AtxHeading 4')
<h4>Fourth-level heading</h4>
HTML
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

