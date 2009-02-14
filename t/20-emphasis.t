#! perl
# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 Markdown emphasis

=head2 Synopsis

    % perl t/20-emphasis.t

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 4;
use Test::More;

language_output_is( 'markdown', <<'CODE', <<'OUT', 'emphasis star' );

*emphasis* (e.g., italics)

CODE
<p><em>emphasis</em> (e.g., italics)</p>

OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'strong star' );

**strong emphasis** (e.g., boldface)

CODE
<p><strong>strong emphasis</strong> (e.g., boldface)</p>

OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'emphasis UI' );

_emphasis_ (e.g., italics)

CODE
<p><em>emphasis</em> (e.g., italics)</p>

OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'strong UI' );

__strong emphasis__ (e.g., boldface)

CODE
<p><strong>strong emphasis</strong> (e.g., boldface)</p>

OUT


# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
