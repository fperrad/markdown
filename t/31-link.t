#! perl
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 Markdown inline link

=head2 Synopsis

    % perl t/31-link.t

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 2;
use Test::More;

language_output_is( 'markdown', <<'CODE', <<'OUT', 'inline link' );

This is an [example link](http://example.com/).

CODE
<p>This is an <a href="http://example.com/">example link</a>.</p>

OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'inline link with title' );

This is an [example link](http://example.com/ "With a Title").

CODE
<p>This is an <a href="http://example.com/" title="With a Title">example link</a>.</p>

OUT


# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
