#! parrot
# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 Markdown code

=head2 Synopsis

    % parrot t/21-code.t

=cut

.sub 'main' :main
    load_language 'markdown'

    .include 'test_more.pir'

    plan(6)

    test_code()
    test_printf()
    test_literal_backtick()
    test_with_space()
    test_HTML_tag()
    test_HTML_entity()
.end

.sub 'test_code'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

`code`

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'code')
<p><code>code</code></p>
HTML
.end

.sub 'test_printf'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

Use the `printf()` function.

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'printf')
<p>Use the <code>printf()</code> function.</p>
HTML
.end

.sub 'test_literal_backtick'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

``There is a literal backtick (`) here.``

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'literal backtick')
<p><code>There is a literal backtick (`) here.</code></p>
HTML
.end

.sub 'test_with_space'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

A single backtick in a code span: `` ` ``

A backtick-delimited string in a code span: `` `foo` ``

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'with space')
<p>A single backtick in a code span: <code>`</code></p>

<p>A backtick-delimited string in a code span: <code>`foo`</code></p>
HTML
.end

.sub 'test_HTML_tag'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

Please don't use any `<blink>` tags.

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'HTML tag')
<p>Please don't use any <code>&lt;blink&gt;</code> tags.</p>
HTML
.end

.sub 'test_HTML_entity'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

`&#8212;` is the decimal-encoded equivalent of `&mdash;`.

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'HTML entity')
<p><code>&amp;#8212;</code> is the decimal-encoded equivalent of <code>&amp;mdash;</code>.</p>
HTML
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

