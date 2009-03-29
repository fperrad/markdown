#! perl
# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 Markdown list

=head2 Synopsis

    % perl t/14-list.t

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 3;
use Test::More;

language_output_is( 'markdown', <<'CODE', <<'OUT', 'unordered' );

- An item in a bulleted (unordered) list
- Another item in a bulleted list

CODE
<ul>
<li>An item in a bulleted (unordered) list</li>
<li>Another item in a bulleted list</li>
</ul>

OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'ordered' );

1. An item in a enumeradted (ordered) list
2. Another item in a enumeradted list

CODE
<ol>
<li>An item in a enumeradted (ordered) list</li>
<li>Another item in a enumeradted list</li>
</ol>

OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'unordered loose' );

* Bird

* Magic

CODE
<ul>
<li><p>Bird</p></li>
<li><p>Magic</p></li>
</ul>

OUT


# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
