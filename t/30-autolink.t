#! perl
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 Markdown automatic link

=head2 Synopsis

    % perl t/30-autolink.t

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 2;
use Test::More;

language_output_is( 'markdown', <<'CODE', <<'OUT', 'autolink url' );

<http://someurl>

CODE
<p><a href="http://someurl">http://someurl</a></p>
OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'autolink email' );

<someb.bob@example.com>

CODE
<p><a href="ma&#x69;&#x6C;&#x74;&#111;:&#x73;o&#x6D;&#101;&#x62;&#46;&#98;&#111;&#98;&#64;&#101;&#x78;&#97;&#x6D;&#112;&#108;e&#x2E;&#x63;&#111;&#x6D;">&#x73;o&#x6D;&#101;&#x62;&#46;&#98;&#111;&#98;&#64;&#101;&#x78;&#97;&#x6D;&#112;&#108;e&#x2E;&#x63;&#111;&#x6D;</a></p>
OUT


# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
