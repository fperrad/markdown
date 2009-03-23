#! perl
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 Markdown code block

=head2 Synopsis

    % perl t/15-codeblock.t

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 3;
use Test::More;

language_output_is( 'markdown', <<'CODE', <<'OUT', 'CodeBlock 1' );

This is a normal paragraph:

    This is a code block.

CODE
<p>This is a normal paragraph:</p>

<pre><code>This is a code block.
</code></pre>

OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'CodeBlock 2' );

Here is an example of AppleScript:

    tell application "Foo"
        bell
    end tell

CODE
<p>Here is an example of AppleScript:</p>

<pre><code>tell application "Foo"
    bell
end tell
</code></pre>

OUT

language_output_is( 'markdown', <<'CODE', <<'OUT', 'CodeBlock HTML' );

HTML fragment:

    <div class="footer">
        &copy; 2004 Foo Corporation
    </div>

CODE
<p>HTML fragment:</p>

<pre><code>&lt;div class="footer"&gt;
    &amp;copy; 2004 Foo Corporation
&lt;/div&gt;
</code></pre>

OUT

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
