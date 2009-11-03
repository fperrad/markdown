#! parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 Markdown code block

=head2 Synopsis

    % parrot t/15-codeblock.t

=cut

.sub 'main' :main
    load_language 'markdown'

    .include 'test_more.pir'

    plan(3)

    test_CodeBlock1()
    test_CodeBlock2()
    test_CodeBlockHTML()
.end

.sub 'test_CodeBlock1'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

This is a normal paragraph:

    This is a code block.

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'CodeBlock 1')
<p>This is a normal paragraph:</p>

<pre><code>This is a code block.
</code></pre>
HTML
.end

.sub 'test_CodeBlock2'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

Here is an example of AppleScript:

    tell application "Foo"
        bell
    end tell

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'CodeBlock 2')
<p>Here is an example of AppleScript:</p>

<pre><code>tell application "Foo"
    bell
end tell
</code></pre>
HTML
.end

.sub 'test_CodeBlockHTML'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

HTML fragment:

    <div class="footer">
        &copy; 2004 Foo Corporation
    </div>

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'CodeBlock HTML')
<p>HTML fragment:</p>

<pre><code>&lt;div class="footer"&gt;
    &amp;copy; 2004 Foo Corporation
&lt;/div&gt;
</code></pre>
HTML
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

