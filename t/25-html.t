#! perl
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 Markdown inline HTML

=head2 Synopsis

    % perl t/25-html.t

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 3;
use Test::More;

language_output_is( 'markdown', <<'CODE', <<'OUT', 'start/end tags' );

tags <cite>Markdown</cite>.

CODE
<p>tags <cite>Markdown</cite>.</p>
OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'empty tag' );

tag <img src="img.jpg" />.

CODE
<p>tag <img src="img.jpg" />.</p>
OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'comment' );

comment <!-- nothing -->.

CODE
<p>comment <!-- nothing -->.</p>
OUT


# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
