#! /usr/local/bin/parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 Markdown inline HTML

=head2 Synopsis

    % parrot t/25-html.t

=cut

.sub 'main' :main
    load_language 'markdown'

    .include 'test_more.pir'

    plan(3)

    test_start_end_tags()
    test_empty_tag()
    test_comment()
.end

.sub 'test_start_end_tags'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

tags <cite>Markdown</cite>.

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'start/end tags')
<p>tags <cite>Markdown</cite>.</p>
HTML
.end

.sub 'test_empty_tag'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

tag <img src="img.jpg" />.

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'empty tag')
<p>tag <img src="img.jpg" />.</p>
HTML
.end

.sub 'test_comment'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

comment <!-- nothing -->.

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'comment')
<p>comment <!-- nothing -->.</p>
HTML
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

