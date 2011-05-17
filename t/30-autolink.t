#! /usr/local/bin/parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 Markdown automatic link

=head2 Synopsis

    % parrot t/30-autolink.t

=cut

.sub 'main' :main
    load_language 'markdown'

    .include 'test_more.pir'

    plan(2)

    test_url()
    test_email()
.end

.sub 'test_url'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

<http://someurl>

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'autolink url')
<p><a href="http://someurl">http://someurl</a></p>
HTML
.end

.sub 'test_email'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

<someb.bob@example.com>

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'autolink email')
<p><a href="&#109;&#x61;&#105;&#x6C;&#x74;&#x6F;:&#x73;&#111;&#x6D;&#x65;&#x62;&#46;&#x62;&#111;&#98;&#64;&#x65;&#x78;&#x61;&#x6D;&#112;&#x6C;&#101;&#x2E;&#99;&#x6F;m">&#x73;&#111;&#x6D;&#x65;&#x62;&#46;&#x62;&#111;&#98;&#64;&#x65;&#x78;&#x61;&#x6D;&#112;&#x6C;&#101;&#x2E;&#99;&#x6F;m</a></p>
HTML
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

