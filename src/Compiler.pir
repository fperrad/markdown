# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 Markdown::HTML::Compiler - MAST Compiler

=head2 Description

Markdown::HTML::Compiler implements a compiler for MAST nodes.

=head2 Methods

=over

=cut

.namespace [ 'Markdown';'HTML';'Compiler' ]

.sub '__onload' :anon :load :init
    $P0 = get_hll_global 'P6metaclass'
    $P0 = $P0.'new_class'('Markdown::HTML::Compiler')

    $P0 = new 'Hash'
    set_hll_global [ 'Markdown';'HTML';'Compiler' ], '%ref', $P0
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

.sub 'escape_code' :anon
    .param string str
    $P0 = split '&', str
    str = join '&amp;', $P0
    $P0 = split '<', str
    str = join '&lt;', $P0
    $P0 = split '>', str
    str = join '&gt;', $P0
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
    unless $S1 == ':' goto L3
    $S0 .= $S1
    goto L1
  L3:
    $I1 = ord $S1
    $P1[0] = $I1
    $S1 = sprintf '&#x%X;', $P1
    $S0 .= $S1
    goto L1
  L2:
    .return ($S0)
.end

.sub 'detab' :anon
    .param string str
    $P0 = split "\n", str
    $P1 = new 'ResizableStringArray'
  L1:
    unless $P0 goto L2
    $S0 = shift $P0
    $S1 = substr $S0, 0, 1
    unless $S1 == "\t" goto L3
    $S0 = substr $S0, 1
    goto L4
  L3:
    $S1 = substr $S0, 0, 4
    unless $S1 == '    ' goto L4
    $S0 = substr $S0, 4
  L4:
    push $P1, $S0
    goto L1
  L2:
    str = join "\n", $P1
    .return (str)
.end


=item html_children(node)

Return generated HTML for all of its children.

=cut

.sub 'html_children' :method
    .param pmc node
    .local pmc code, iter
    code = new 'CodeString'
    iter = node.'iterator'()
  iter_loop:
    unless iter goto iter_end
    .local pmc cpast
    cpast = shift iter
    $P0 = self.'html'(cpast)
    code .= $P0
    goto iter_loop
  iter_end:
    .return (code)
.end


=item html(Any node)

=cut

.sub 'html' :method :multi(_,_)
    .param pmc node
    .tailcall self.'html_children'(node)
.end


=item html(Markdown::Document node)

=cut

.sub 'html' :method :multi(_,['Markdown';'Document'])
    .param pmc node
    .tailcall self.'html_children'(node)
.end


=item html(Markdown::HorizontalRule node)

=cut

.sub 'html' :method :multi(_,['Markdown';'HorizontalRule'])
    .param pmc node
    .local pmc code
    new code, 'CodeString'
    set code, "<hr />\n\n"
    .return (code)
.end


=item html(Markdown::Title node)

=cut

.sub 'html' :method :multi(_,['Markdown';'Title'])
    .param pmc node
    $S1 = self.'html_children'(node)
    $S2 = node.'level'()
    .local pmc code
    new code, 'CodeString'
    $S0 = "<h"
    $S0 .= $S2
    $S0 .= ">"
    $S0 .= $S1
    $S0 .= "</h"
    $S0 .= $S2
    $S0 .= ">\n\n"
    set code, $S0
    .return (code)
.end


=item html(Markdown::Para node)

=cut

.sub 'html' :method :multi(_,['Markdown';'Para'])
    .param pmc node
    $S1 = self.'html_children'(node)
    .local pmc code
    new code, 'CodeString'
    $S0 = "<p>"
    $S0 .= $S1
    $S0 .= "</p>\n\n"
    set code, $S0
    .return (code)
.end

=item html(Markdown::CodeBlock node)

=cut

.sub 'html' :method :multi(_,['Markdown';'CodeBlock'])
    .param pmc node
    $S1 = node.'text'()
    $S1 = detab($S1)
    $S1 = escape_code($S1)
    .local pmc code
    new code, 'CodeString'
    $S0 = "<pre><code>"
    $S0 .= $S1
    $S0 .= "</code></pre>\n\n"
    set code, $S0
    .return (code)
.end

=item html(Markdown::BlockQuote node)

=cut

.sub 'html' :method :multi(_,['Markdown';'BlockQuote'])
    .param pmc node
    .local pmc code
    new code, 'CodeString'
    $S0 = "<blockquote>\n"
    set code, $S0
    .local pmc iter
    iter = node.'iterator'()
  iter_loop:
    unless iter goto iter_end
    .local pmc cpast
    cpast = shift iter
    $P0 = self.'html'(cpast)
    code .= "  <p>"
    code .= $P0
    code .= "</p>\n"
    goto iter_loop
  iter_end:
    code .= "</blockquote>\n\n"
    .return (code)
.end

=item html(Markdown::ItemizedList node)

=cut

.sub 'html' :method :multi(_,['Markdown';'ItemizedList'])
    .param pmc node
    $S1 = self.'html_children'(node)
    .local pmc code
    new code, 'CodeString'
    $S0 = "<ul>\n"
    $S0 .= $S1
    $S0 .= "</ul>\n\n"
    set code, $S0
    .return (code)
.end

=item html(Markdown::OrderedList node)

=cut

.sub 'html' :method :multi(_,['Markdown';'OrderedList'])
    .param pmc node
    $S1 = self.'html_children'(node)
    .local pmc code
    new code, 'CodeString'
    $S0 = "<ol>\n"
    $S0 .= $S1
    $S0 .= "</ol>\n\n"
    set code, $S0
    .return (code)
.end

=item html(Markdown::ListItem node)

=cut

.sub 'html' :method :multi(_,['Markdown';'ListItem'])
    .param pmc node
    $S1 = self.'html_children'(node)
    .local pmc code
    new code, 'CodeString'
    $S0 = "<li>"
    $S0 .= $S1
    $S0 .= "</li>\n"
    set code, $S0
    .return (code)
.end

=item html(Markdown::Link node)

=cut

.sub 'html' :method :multi(_,['Markdown';'Link'])
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
    $S1 = escape_xml(url)
    $S0 .= $S1
    unless title goto L1
    $S0 .= "\" title=\""
    $S1 = escape_xml(title)
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
    $S1 = escape_xml(url)
    $S0 .= $S1
    $S0 .= "\" alt=\""
    $S0 .= content
    $S0 .= "\" title=\""
    $S1 = escape_xml(title)
    $S0 .= $S1
    $S0 .= "\" />"
    .return ($S0)
.end

=item html(Markdown::RefLink node)

=cut

.sub 'html' :method :multi(_,['Markdown';'RefLink'])
    .param pmc node
    .local string content, image, key
    content = self.'html_children'(node)
    key = node.'key'()
    $P0 = get_hll_global [ 'Markdown';'HTML';'Compiler' ], '%ref'
    $S0 = downcase key
    $P1 = $P0[$S0]
    if null $P1 goto L1
    .local string url, title
    $S0 = $P1[0]
    url = escape_xml($S0)
    $S0 = $P1[1]
    title = escape_xml($S0)
    goto L2
  L1:
    $S0 = key
    $S0 .= content
    goto L5
  L2:
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

.sub 'html' :method :multi(_,['Markdown';'Reference'])
    .param pmc node
    .local pmc code
    new code, 'CodeString'
    set code, ''
    .return (code)
.end

=item html(Markdown::Email node)

=cut

.sub 'html' :method :multi(_,['Markdown';'Email'])
    .param pmc node
    .local pmc code
    new code, 'CodeString'
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
    set code, $S0
    .return (code)
.end

=item html(Markdown::Emphasis node)

=cut

.sub 'html' :method :multi(_,['Markdown';'Emphasis'])
    .param pmc node
    $S1 = self.'html_children'(node)
    .local pmc code
    new code, 'CodeString'
    $S0 = "<em>"
    $S0 .= $S1
    $S0 .= "</em>"
    set code, $S0
    .return (code)
.end

=item html(Markdown::Strong node)

=cut

.sub 'html' :method :multi(_,['Markdown';'Strong'])
    .param pmc node
    $S1 = self.'html_children'(node)
    .local pmc code
    new code, 'CodeString'
    $S0 = "<strong>"
    $S0 .= $S1
    $S0 .= "</strong>"
    set code, $S0
    .return (code)
.end

=item html(Markdown::Code node)

=cut

.sub 'html' :method :multi(_,['Markdown';'Code'])
    .param pmc node
    $S1 = node.'text'()
    $S1 = escape_code($S1)
    .local pmc code
    new code, 'CodeString'
    $S0 = "<code>"
    $S0 .= $S1
    $S0 .= "</code>"
    set code, $S0
    .return (code)
.end

=item html(Markdown::Entity node)

=cut

.sub 'html' :method :multi(_,['Markdown';'Entity'])
    .param pmc node
    $S1 = node.'text'()
    .local pmc code
    new code, 'CodeString'
    set code, $S1
    .return (code)
.end

=item html(Markdown::Line node)

=cut

.sub 'html' :method :multi(_,['Markdown';'Line'])
    .param pmc node
    $S1 = node.'text'()
    $S1 = escape_xml($S1)
    .local pmc code
    new code, 'CodeString'
    set code, $S1
    .return (code)
.end

=item html(Markdown::Word node)

=cut

.sub 'html' :method :multi(_,['Markdown';'Word'])
    .param pmc node
    $S1 = node.'text'()
    $S1 = escape_xml($S1)
    .local pmc code
    new code, 'CodeString'
    set code, $S1
    .return (code)
.end

=item html(Markdown::Space node)

=cut

.sub 'html' :method :multi(_,['Markdown';'Space'])
    .param pmc node
    .local pmc code
    new code, 'CodeString'
    set code, ' '
    .return (code)
.end

=back

=cut

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

