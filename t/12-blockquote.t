#! perl
# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 Markdown blockquote

=head2 Synopsis

    % perl t/12-blockquote.t

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 4;
use Test::More;

language_output_is( 'markdown', <<'CODE', <<'OUT', 'BlockQuote 1' );

> This text will be enclosed in an HTML blockquote element.

CODE
<blockquote>
  <p>This text will be enclosed in an HTML blockquote element.</p>
</blockquote>

OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'BlockQuote 2' );

> Use the > character in front of a line, *just like in email*.
> Use it if you're quoting a person, a song or whatever.

CODE
<blockquote>
  <p>Use the > character in front of a line, <em>just like in email</em>.
Use it if you're quoting a person, a song or whatever.</p>
</blockquote>

OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'BlockQuote 3' );

> You can use *italic* or lists inside them also.
And just like with other paragraphs,
all of these lines are still
part of the blockquote, even without the > character in front.

To end the blockquote, just put a blank line before the following paragraph.

CODE
<blockquote>
  <p>You can use <em>italic</em> or lists inside them also.
And just like with other paragraphs,
all of these lines are still
part of the blockquote, even without the > character in front.</p>
</blockquote>

<p>To end the blockquote, just put a blank line before the following paragraph.</p>

OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'BlockQuote 4' );

> Use the > character in front of a line, *just like in email*.

> Use it if you're quoting a person, a song or whatever.

CODE
<blockquote>
  <p>Use the > character in front of a line, <em>just like in email</em>.</p>

<p>Use it if you're quoting a person, a song or whatever.</p>
</blockquote>

OUT

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
