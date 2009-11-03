#! parrot
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
<p><a href="ma&#x69;&#x6C;&#x74;&#111;:&#x73;o&#x6D;&#101;&#x62;&#46;&#98;&#111;&#98;&#64;&#101;&#x78;&#97;&#x6D;&#112;&#108;e&#x2E;&#x63;&#111;&#x6D;">&#x73;o&#x6D;&#101;&#x62;&#46;&#98;&#111;&#98;&#64;&#101;&#x78;&#97;&#x6D;&#112;&#108;e&#x2E;&#x63;&#111;&#x6D;</a></p>
HTML
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

