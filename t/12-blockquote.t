#! /usr/local/bin/parrot
# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 Markdown blockquote

=head2 Synopsis

    % parrot t/12-blockquote.t

=cut

.sub 'main' :main
    load_language 'markdown'

    .include 'test_more.pir'

    plan(4)

    test_BlockQuote1()
    test_BlockQuote2()
    test_BlockQuote3()
    test_BlockQuote4()
.end

.sub 'test_BlockQuote1'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

> This text will be enclosed in an HTML blockquote element.

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'BlockQuote 1')
<blockquote>
  <p>This text will be enclosed in an HTML blockquote element.</p>
</blockquote>
HTML
.end

.sub 'test_BlockQuote2'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

> Use the > character in front of a line, *just like in email*.
> Use it if you're quoting a person, a song or whatever.

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'BlockQuote 2')
<blockquote>
  <p>Use the > character in front of a line, <em>just like in email</em>.
Use it if you're quoting a person, a song or whatever.</p>
</blockquote>
HTML
.end

.sub 'test_BlockQuote3'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

> You can use *italic* or lists inside them also.
And just like with other paragraphs,
all of these lines are still
part of the blockquote, even without the > character in front.

To end the blockquote, just put a blank line before the following paragraph.

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'BlockQuote 3')
<blockquote>
  <p>You can use <em>italic</em> or lists inside them also.
And just like with other paragraphs,
all of these lines are still
part of the blockquote, even without the > character in front.</p>
</blockquote>

<p>To end the blockquote, just put a blank line before the following paragraph.</p>
HTML
.end

.sub 'test_BlockQuote4'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

> Use the > character in front of a line, *just like in email*.

> Use it if you're quoting a person, a song or whatever.

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'BlockQuote 4')
<blockquote>
  <p>Use the > character in front of a line, <em>just like in email</em>.</p>

<p>Use it if you're quoting a person, a song or whatever.</p>
</blockquote>
HTML
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

