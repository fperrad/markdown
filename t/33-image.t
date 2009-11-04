#! /usr/local/bin/parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 Markdown image

=head2 Synopsis

    % parrot t/33-image.t

=cut

.sub 'main' :main
    load_language 'markdown'

    .include 'test_more.pir'

    plan(3)

    test_image()
    test_image_with_title()
    test_reference_image()
.end

.sub 'test_image'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

![alternate text](http://someurl.image.gif)

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'image')
<p><img src="http://someurl.image.gif" alt="alternate text" title="" /></p>
HTML
.end

.sub 'test_image_with_title'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

![tiny arrow](http://greg.vario.us/img/extlink.png "tiny arrow")

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'image with title')
<p><img src="http://greg.vario.us/img/extlink.png" alt="tiny arrow" title="tiny arrow" /></p>
HTML
.end

.sub 'test_reference_image'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

![alt text][id]

   [id]: /path/to/img.jpg "Title"

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'reference image')
<p><img src="/path/to/img.jpg" alt="alt text" title="Title" /></p>
HTML
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

