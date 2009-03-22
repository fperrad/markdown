#! perl
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 Markdown image

=head2 Synopsis

    % perl t/33-image.t

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 3;
use Test::More;

language_output_is( 'markdown', <<'CODE', <<'OUT', 'image' );

![alternate text](http://someurl.image.gif)

CODE
<p><img src="http://someurl.image.gif" alt="alternate text" title="" /></p>

OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'image with title' );

![tiny arrow](http://greg.vario.us/img/extlink.png "tiny arrow")

CODE
<p><img src="http://greg.vario.us/img/extlink.png" alt="tiny arrow" title="tiny arrow" /></p>

OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'reference image' );

![alt text][id]

   [id]: /path/to/img.jpg "Title"

CODE
<p><img src="/path/to/img.jpg" alt="alt text" title="Title" /></p>

OUT


# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
