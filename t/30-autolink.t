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
<p><a href="&#x6D;&#x61;&#x69;&#x6C;&#x74;&#x6F;:&#x73;&#x6F;&#x6D;&#x65;&#x62;&#x62;&#x6F;&#x62;&#x40;&#x65;&#x78;&#x61;&#x6D;&#x70;&#x6C;&#x65;&#x2E;&#x63;&#x6F;&#x6D;">&#x73;&#x6F;&#x6D;&#x65;&#x62;&#x62;&#x6F;&#x62;&#x40;&#x65;&#x78;&#x61;&#x6D;&#x70;&#x6C;&#x65;&#x2E;&#x63;&#x6F;&#x6D;</a></p>
OUT


# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
