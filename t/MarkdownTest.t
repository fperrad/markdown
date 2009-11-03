#! parrot
# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 the official test suite

=head2 Synopsis

    % parrot t/MarkdownTest.t

=head2 Description

Run the tests of the official test suite.

=cut

.sub 'main' :main
    load_language 'markdown'

    .include 'test_more.pir'

    $P0 = new 'OS'
    push_eh _handler
    $P1 = $P0.'readdir'('t/MarkdownTest_1.0/Tests')
    pop_eh
    .local pmc test_files
    test_files = new 'ResizableStringArray'
  L1:
    unless $P1 goto L2
    $S0 = shift $P1
    $I0 = length $S0
    if $I0 < 5 goto L1
    $I0 -= 5
    $S1 = substr $S0, $I0
    if $S1 != '.text' goto L1
    $S2 = substr $S0, 0, $I0
    push test_files, $S2
    goto L1
  L2:

    $I0 = test_files
    if $I0 > 0 goto L3
  _handler:
    # skip_all("no MarkdownTest")
    print "1..0"
    print " # SKIP "
    print "no MarkdownTest"
    end
  L3:
    plan($I0)

    $P0 = new 'Env'
    $P0['MARKDOWN_STRICT'] = 'NO_EXT'

    .local pmc _skip
    _skip = new 'Hash'
    _skip[14] = 'skip'

    .local pmc _todo
    _todo = new 'Hash'
    _todo[4] = 'todo'
    _todo[14] = 'todo'
    _todo[15] = 'todo'
    _todo[16] = 'todo'
    _todo[19] = 'todo'

     $P0 = compreg 'markdown'
    .local int idx
    idx = 0
  L4:
    unless test_files goto L5
    inc idx
    $S0 = shift test_files
    $I0 = exists _skip[idx]
    unless $I0 goto L6
    skip(1, $S0)
    goto L4
  L6:
    .local string markdown, html, out
    .local pmc fh
    fh = new 'FileHandle'
    $S1 = 't/MarkdownTest_1.0/Tests/' . $S0
    $S2 = $S1 . '.text'
    markdown = fh.'readall'($S2)
    markdown .= "\n"
    $S2 = $S1 . '.html'
    html = fh.'readall'($S2)
    $P1 = $P0.'compile'(markdown)
    out = $P1()
    $I0 = exists _todo[idx]
    unless $I0 goto L7
    $I1 = out == html
    todo($I1, $S0)
    goto L4
  L7:
    is(out, html, $S0)
    goto L4
  L5:
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

