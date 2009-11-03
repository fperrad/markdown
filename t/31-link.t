#! parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 Markdown inline link

=head2 Synopsis

    % parrot t/31-link.t

=cut

.sub 'main' :main
    load_language 'markdown'

    .include 'test_more.pir'

    plan(2)

    test_inline_link()
    test_inline_link_with_title()
.end

.sub 'test_inline_link'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

This is an [example link](http://example.com/).

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'inline link')
<p>This is an <a href="http://example.com/">example link</a>.</p>
HTML
.end

.sub 'test_inline_link_with_title'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

This is an [example link](http://example.com/ "With a Title").

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'inline link with title')
<p>This is an <a href="http://example.com/" title="With a Title">example link</a>.</p>
HTML
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

