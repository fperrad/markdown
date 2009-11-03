#! parrot
# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 Markdown escapes

=head2 Synopsis

    % parrot t/22-escape.t

=cut

.sub 'main' :main
    load_language 'markdown'

    .include 'test_more.pir'

    plan(3)

    test_asterick()
    test_dot()
    test_symbol()
.end

.sub 'test_asterick'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

\*literal astericks\*

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'asterick')
<p>*literal astericks*</p>
HTML
.end

.sub 'test_dot'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

1986\. What a great season.

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'dot')
<p>1986. What a great season.</p>
HTML
.end

.sub 'test_symbol'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

Hello, World!

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'symbol (not escaped)')
<p>Hello, World!</p>
HTML
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

