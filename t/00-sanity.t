#! perl
# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 some Markdown examples

=head2 Synopsis

    % perl t/00-sanity.t

=head2 Description

First tests in order to check infrastructure.

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 1;
use Test::More;

language_output_is( 'markdown', <<'CODE', <<'OUT', 'ex1' );

# Title

some text.

CODE
<h1>Title</h1>

<p>some text.</p>

OUT

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
