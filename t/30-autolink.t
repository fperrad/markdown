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

<somebbob@example.com>

CODE
<p><a href="ma&#x69;&#x6C;&#x74;&#111;:&#x73;o&#x6D;&#101;&#x62;&#98;&#111;&#98;&#64;&#101;&#120;&#x61;&#109;&#x70;&#108;&#101;.&#x63;&#x6F;&#109;">&#x73;o&#x6D;&#101;&#x62;&#98;&#111;&#98;&#64;&#101;&#120;&#x61;&#109;&#x70;&#108;&#101;.&#x63;&#x6F;&#109;</a></p>
OUT


# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
