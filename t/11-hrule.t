#! /usr/local/bin/parrot
# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 Markdown horizontal rule

=head2 Synopsis

    % parrot t/11-hrule.t

=cut

.sub 'main' :main
    load_language 'markdown'

    .include 'test_more.pir'

    plan(3)

    test_rule_star()
    test_rule_dash()
    test_rule_underscore()
.end

.sub 'test_rule_star'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

******

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'rule *')
<hr />
HTML
.end

.sub 'test_rule_dash'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

 -----

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'rule -')
<hr />
HTML
.end

.sub 'test_rule_underscore'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'

 _ _ _ _

MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S1 = $P1()
     is($S1, <<'HTML', 'rule _')
<hr />
HTML
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

