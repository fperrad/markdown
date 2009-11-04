#! /usr/local/bin/parrot
# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 some Markdown examples

=head2 Synopsis

    % parrot t/00-sanity.t

=head2 Description

First tests in order to check infrastructure.

=cut

.sub 'main' :main
    load_language 'markdown'

    .include 'test_more.pir'

    plan(1)

    test_ex1()
.end

.sub 'test_ex1'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

# Title

some text.

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'ex1')
<h1>Title</h1>

<p>some text.</p>
HTML
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

