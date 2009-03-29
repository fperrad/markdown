#! perl
# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 Markdown horizontal rule

=head2 Synopsis

    % perl t/10-hrule.t

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 3;
use Test::More;

language_output_is( 'markdown', <<'CODE', <<'OUT', 'rule *' );

******

CODE
<hr />
OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'rule -' );

 -----

CODE
<hr />
OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'rule _' );

 _ _ _ _

CODE
<hr />
OUT

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
