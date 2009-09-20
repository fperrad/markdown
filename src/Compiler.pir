# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 Markdown::Compiler

=head2 Functions & Methods
=over 4

=item onload()

Creates the Markdown compiler using a C<PCT::HLLCompiler>
object.

=cut

.namespace [ 'Markdown';'Compiler' ]

.sub 'onload' :anon :load :init
    load_bytecode 'PCT.pbc'

    .local pmc p6meta
    p6meta = new 'P6metaclass'
    $P0 = p6meta.'new_class'('Markdown::Compiler', 'parent'=>'PCT::HLLCompiler')
    $P1 = $P0.'new'()
    $P1.'language'('markdown')
    $P1.'parsegrammar'('Markdown::Grammar')
    $P1.'parseactions'('Markdown::Grammar::Actions')
    $P1.'removestage'('post')
    $P1.'addstage'('html', 'before' => 'pir')
.end

=item html(source [, adverbs :slurpy :named])

Transform MAST C<source> into a String containing HTML.

=cut

.sub 'html' :method
    .param pmc source
    .param pmc adverbs         :slurpy :named

    $P0 = new ['Markdown';'HTML';'Compiler']
    .tailcall $P0.'to_html'(source, adverbs :flat :named)
.end


.sub 'pir' :method
    .param pmc source
    .param pmc adverbs         :slurpy :named

    new $P0, 'CodeString'
    $P0 = <<'PIRCODE'
.sub 'main' :anon
    $S0 = <<'PIR'
PIRCODE
    $P0 .= source
    $P0 .= <<'PIRCODE'
PIR
    .return ($S0)
.end
PIRCODE
    .return ($P0)
.end

=head1 Markdown::HTML::Compiler - MAST Compiler

=head2 Methods

=over

=cut

.namespace ['Markdown'; 'HTML'; 'Compiler']

.sub '__onload' :anon :load :init
    load_bytecode 'Math/Rand.pbc'

    $P0 = get_hll_global 'P6metaclass'
    $P0 = $P0.'new_class'('Markdown::HTML::Compiler')

    $P0 = new 'Hash'
    set_hll_global ['Markdown'; 'HTML'; 'Compiler'], '%ref', $P0
.end

.sub 'to_html' :method
    .param pmc past
    .param pmc adverbs         :slurpy :named

    .tailcall self.'html'(past)
.end

.sub 'escape_xml' :anon
    .param string str
    $P0 = split '&', str
    str = join '&amp;', $P0
    $P0 = split '<', str
    str = join '&lt;', $P0
    .return (str)
.end

.sub 'escape_attr' :anon
    .param string str
    str = escape_xml(str)
    $P0 = split '"', str
    str = join '&quot;', $P0
    .return (str)
.end

.sub 'escape_code' :anon
    .param string str
    $P0 = split '>', str
    str = join '&gt;', $P0
    .return (str)
.end

.sub 'detab' :anon
    .param string str
    $P0 = split '', str
    $P1 = new 'ResizableStringArray'
  L1:
    unless $P0 goto L2
    $S0 = shift $P0
    if $S0 == "\t" goto L3
    push $P1, $S0
    goto L1
  L3:
    push $P1, ' '
    $I0 = elements $P1
    $I0 %= 4
    if $I0 goto L3
    goto L1
  L2:
    str = join '', $P1
    .return (str)
.end

.sub 'detabn' :anon
    .param string str
    $P0 = split "\n", str
    $P1 = new 'ResizableStringArray'
  L1:
    unless $P0 goto L2
    $S0 = shift $P0
    $S0 = detab($S0)
    push $P1, $S0
    goto L1
  L2:
    str = join "\n", $P1
    .return (str)
.end

.sub 'obscure_text' :anon
    .param string str
    $S0 = ''
    new $P1, 'FixedPMCArray'
    set $P1, 1
    $P0 = split '', str
  L1:
    unless $P0 goto L2
    $S1 = shift $P0
    if $S1 == '@' goto L_dec
    if $S1 == ':' goto L_raw
    .local pmc rand
    rand = get_root_global [ 'parrot'; 'Math'; 'Rand' ], 'rand'
    $I0 = rand()
    # roughly 10% raw, 45% hex, 45% dec
    $I0 %= 20
    if $I0 >= 18 goto L_raw
    if $I0 >= 9 goto L_hex
  L_dec:
    $I1 = ord $S1
    $S1 = $I1
    $S1 = '&#' . $S1
    $S1 .= ';'
    goto L_raw
  L_hex:
    $I1 = ord $S1
    $P1[0] = $I1
    $S1 = sprintf '&#x%X;', $P1
  L_raw:
    $S0 .= $S1
    goto L1
  L2:
    .return ($S0)
.end


=item html_children(node)

Return generated HTML for all of its children.

=cut

.sub 'html_children' :method
    .param pmc node
    .param string fsep  :optional
    .param int has_fsep :opt_flag
    .param string ssep  :optional
    .param int has_ssep :opt_flag
    .param string esep  :optional
    .param int has_esep :opt_flag
    .local int first
    first = 1
    .local pmc code, iter
    code = new 'CodeString'
    iter = node.'iterator'()
  iter_loop:
    unless iter goto iter_end
    .local pmc cpast
    cpast = shift iter
    $P0 = self.'html'(cpast)
    $I0 = elements $P0
    unless $I0 goto iter_loop
    unless first goto L1
    first = 0
    unless has_fsep goto L2
    code .= fsep
    goto L2
  L1:
    unless has_ssep goto L2
    code .= ssep
  L2:
    code .= $P0
    unless has_esep goto L3
    code .= esep
  L3:
    goto iter_loop
  iter_end:
    .return (code)
.end


=item html(Any node)

=cut

.sub 'html' :method :multi(_, _)
    .param pmc node
    .tailcall self.'html_children'(node)
.end


=item html(Markdown::Document node)

=cut

.sub 'html' :method :multi(_, ['Markdown'; 'Document'])
    .param pmc node
    .tailcall self.'html_children'(node, '', "\n", "\n")
.end


=item html(Markdown::HorizontalRule node)

=cut

.sub 'html' :method :multi(_, ['Markdown'; 'HorizontalRule'])
    .param pmc node
    .local pmc code
    new code, 'CodeString'
    set code, "<hr />"
    .return (code)
.end


=item html(Markdown::Title node)

=cut

.sub 'html' :method :multi(_, ['Markdown'; 'Title'])
    .param pmc node
    $S1 = self.'html_children'(node)
    $S2 = node.'level'()
    $S0 = "<h"
    $S0 .= $S2
    $S0 .= ">"
    $S0 .= $S1
    $S0 .= "</h"
    $S0 .= $S2
    $S0 .= ">"
    .local pmc code
    new code, 'CodeString'
    set code, $S0
    .return (code)
.end


=item html(Markdown::Para node)

=cut

.sub 'html' :method :multi(_, ['Markdown'; 'Para'])
    .param pmc node
    $S1 = self.'html_children'(node)
    $S0 = "<p>"
    $S0 .= $S1
    $S0 .= "</p>"
    .local pmc code
    new code, 'CodeString'
    set code, $S0
    .return (code)
.end

=item html(Markdown::CodeBlock node)

=cut

.sub 'html' :method :multi(_, ['Markdown'; 'CodeBlock'])
    .param pmc node
    $S1 = self.'html_children'(node)
    $S1 = escape_code($S1)
    $S0 = "<pre><code>"
    $S0 .= $S1
    $S0 .= "</code></pre>"
    .local pmc code
    new code, 'CodeString'
    set code, $S0
    .return (code)
.end

=item html(Markdown::BlockQuote node)

=cut

.sub 'html' :method :multi(_, ['Markdown'; 'BlockQuote'])
    .param pmc node
    $S0 = "<blockquote>\n"
    $S0 .= "  "
    $S1 = self.'html_children'(node, '', "\n", "\n")
    $S0 .= $S1
    $S0 .= "</blockquote>"
    .local pmc code
    new code, 'CodeString'
    set code, $S0
    .return (code)
.end

=item html(Markdown::ItemizedList node)

=cut

.sub 'html' :method :multi(_, ['Markdown'; 'ItemizedList'])
    .param pmc node
    $S1 = self.'html_children'(node)
    $S0 = "<ul>\n"
    $S0 .= $S1
    $S0 .= "</ul>"
    .local pmc code
    new code, 'CodeString'
    set code, $S0
    .return (code)
.end

=item html(Markdown::OrderedList node)

=cut

.sub 'html' :method :multi(_, ['Markdown'; 'OrderedList'])
    .param pmc node
    $S1 = self.'html_children'(node)
    $S0 = "<ol>\n"
    $S0 .= $S1
    $S0 .= "</ol>"
    .local pmc code
    new code, 'CodeString'
    set code, $S0
    .return (code)
.end

=item html(Markdown::ListItem node)

=cut

.sub 'html' :method :multi(_, ['Markdown'; 'ListItem'])
    .param pmc node
    $S0 = "<li>"
    $I0 = node.'loose'()
    if $I0 goto L1
    $S1 = self.'html_children'(node)
    goto L2
  L1:
    $S1 = self.'html_children'(node, "<p>", "\n\n<p>", "</p>")
  L2:
    $S0 .= $S1
    $S0 .= "</li>\n"
    .local pmc code
    new code, 'CodeString'
    set code, $S0
    .return (code)
.end

=item html(Markdown::Link node)

=cut

.sub 'html' :method :multi(_, ['Markdown'; 'Link'])
    .param pmc node
    .local string url, title, content, image
    url = node.'url'()
    title = node.'title'()
    content = self.'html_children'(node)
    image = node.'image'()
    if image goto L1
    $S0 = _link(url, title, content)
    goto L2
  L1:
    $S0 = _image(url, title, content)
  L2:
    .local pmc code
    new code, 'CodeString'
    set code, $S0
    .return (code)
.end

.sub '_link' :anon
    .param string url
    .param string title
    .param string content
    $S0 = "<a href=\""
    $S1 = escape_attr(url)
    $S0 .= $S1
    unless title goto L1
    $S0 .= "\" title=\""
    $S1 = escape_attr(title)
    $S0 .= $S1
  L1:
    $S0 .= "\">"
    $S0 .= content
    $S0 .= "</a>"
    .return ($S0)
.end

.sub '_image' :anon
    .param string url
    .param string title
    .param string content
    $S0 = "<img src=\""
    $S1 = escape_attr(url)
    $S0 .= $S1
    $S0 .= "\" alt=\""
    $S0 .= content
    $S0 .= "\" title=\""
    $S1 = escape_attr(title)
    $S0 .= $S1
    $S0 .= "\" />"
    .return ($S0)
.end

=item html(Markdown::RefLink node)

=cut

.sub 'html' :method :multi(_, ['Markdown'; 'RefLink'])
    .param pmc node
    .local string key
    key = node.'key'()
    $P0 = get_hll_global ['Markdown'; 'HTML'; 'Compiler'], '%ref'
    $S0 = downcase key
    $P1 = $P0[$S0]
    if null $P1 goto L1
    .local string url, title
    url = $P1[0]
    title = $P1[1]
    goto L2
  L1:
    $S0 = node.'text'()
    goto L5
  L2:
    .local string content, image
    content = self.'html_children'(node)
    image = node.'image'()
    if image goto L3
    if content goto L4
    $I0 = length key
    $I0 -= 2
    content = substr key, 1, $I0
  L4:
    $S0 = _link(url, title, content)
    goto L5
  L3:
    $S0 = _image(url, title, content)
  L5:
    .local pmc code
    new code, 'CodeString'
    set code, $S0
    .return (code)
.end

=item html(Markdown::Reference node)

=cut

.sub 'html' :method :multi(_, ['Markdown'; 'Reference'])
    .param pmc node
    .local pmc code
    new code, 'CodeString'
    set code, ''
    .return (code)
.end

=item html(Markdown::Email node)

=cut

.sub 'html' :method :multi(_, ['Markdown'; 'Email'])
    .param pmc node
    $S0 = "<a href=\""
    $S1 = node.'text'()
    $S1 = 'mailto:' . $S1
    $S1 = obscure_text($S1)
    $S0 .= $S1
    $S0 .= "\">"
    $I0 = index $S1, ':'
    inc $I0
    $S1 = substr $S1, $I0
    $S0 .= $S1
    $S0 .= "</a>"
    .local pmc code
    new code, 'CodeString'
    set code, $S0
    .return (code)
.end

=item html(Markdown::Emphasis node)

=cut

.sub 'html' :method :multi(_, ['Markdown'; 'Emphasis'])
    .param pmc node
    $S1 = self.'html_children'(node)
    $S0 = "<em>"
    $S0 .= $S1
    $S0 .= "</em>"
    .local pmc code
    new code, 'CodeString'
    set code, $S0
    .return (code)
.end

=item html(Markdown::Strong node)

=cut

.sub 'html' :method :multi(_, ['Markdown'; 'Strong'])
    .param pmc node
    $S1 = self.'html_children'(node)
    $S0 = "<strong>"
    $S0 .= $S1
    $S0 .= "</strong>"
    .local pmc code
    new code, 'CodeString'
    set code, $S0
    .return (code)
.end

=item html(Markdown::Code node)

=cut

.sub 'html' :method :multi(_, ['Markdown'; 'Code'])
    .param pmc node
    $S1 = node.'text'()
    $S1 = escape_xml($S1)
    $S1 = escape_code($S1)
    $S0 = "<code>"
    $S0 .= $S1
    $S0 .= "</code>"
    .local pmc code
    new code, 'CodeString'
    set code, $S0
    .return (code)
.end

=item html(Markdown::Html node)

=cut

.sub 'html' :method :multi(_, ['Markdown'; 'Html'])
    .param pmc node
    $S0 = node.'text'()
    $I0 = node.'detab'()
    unless $I0 goto L1
    $S0 = detabn($S0)
  L1:
    .local pmc code
    new code, 'CodeString'
    set code, $S0
    .return (code)
.end

=item html(Markdown::Line node)

=cut

.sub 'html' :method :multi(_, ['Markdown'; 'Line'])
    .param pmc node
    $S1 = node.'text'()
    $I0 = node.'detab'()
    unless $I0 goto L1
    $S1 = detab($S1)
  L1:
    $S0 = escape_xml($S1)
    .local pmc code
    new code, 'CodeString'
    set code, $S0
    .return (code)
.end

=item html(Markdown::Word node)

=cut

.sub 'html' :method :multi(_, ['Markdown'; 'Word'])
    .param pmc node
    $S1 = node.'text'()
    $S0 = escape_xml($S1)
    .local pmc code
    new code, 'CodeString'
    set code, $S0
    .return (code)
.end

=item html(Markdown::Space node)

=cut

.sub 'html' :method :multi(_, ['Markdown'; 'Space'])
    .param pmc node
    .local pmc code
    new code, 'CodeString'
    set code, ' '
    .return (code)
.end

=item html(Markdown::Newline node)

=cut

.sub 'html' :method :multi(_, ['Markdown'; 'Newline'])
    .param pmc node
    .local pmc code
    new code, 'CodeString'
    set code, "\n"
    .return (code)
.end

=back

=cut

.include 'src/gen_grammar.pir'
.include 'src/gen_actions.pir'
.include 'src/gen_builtins.pir'
.include 'src/Node.pir'


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

