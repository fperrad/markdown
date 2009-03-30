# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=begin comments

Markdown::Grammar::Actions - ast transformations for Markdown

This file contains the methods that are used by the parse grammar
to build the PAST representation of an Markdown program.
Each method below corresponds to a rule in F<src/parser/grammar.pg>,
and is invoked at the point where C<{*}> appears in the rule,
with the current match object as the first argument.  If the
line containing C<{*}> also has a C<#= key> comment, then the
value of the comment is passed as the second argument to the method.

=end comments

=cut

class Markdown::Grammar::Actions;

method TOP($/) {
    my $mast := Markdown::Document.new();
    for $<Block> {
        $mast.push( $( $_ ) );
    }
    make $mast;
}

method Block($/, $key) {
    make $( $/{$key} );
}

method Para($/) {
    my $mast := Markdown::Para.new();
    for $<Inlines><_Inline> {
        $mast.push( $( $_ ) );
    }
    make $mast;
}

method Heading($/, $key) {
    make $( $/{$key} );
}

method AtxHeading($/) {
    my $mast := Markdown::Title.new( :level( ~$<AtxStart>.length() ) );
    for $<AtxInline> {
        $mast.push( $( $_ ) );
    }
    make $mast;
}

method AtxInline($/) {
    make $( $<Inline> );
}

method _Inline($/, $key) {
    make $( $/{$key} );
}

method Inline($/, $key) {
    make $( $/{$key} );
}

method SetextHeading($/, $key) {
    make $( $/{$key} );
}

method SetextHeading1($/) {
    my $mast := Markdown::Title.new( :level( 1 ) );
    for $<Inline> {
        $mast.push( $( $_ ) );
    }
    make $mast;
}

method SetextHeading2($/) {
    my $mast := Markdown::Title.new( :level( 2 ) );
    for $<Inline> {
        $mast.push( $( $_ ) );
    }
    make $mast;
}

method BlockQuote($/) {
    my $mast := Markdown::BlockQuote.new();
    for $<BlockQuoteChunk> {
        $mast.push( $( $_ ) );
    }
    make $mast;
}

method BlockQuoteChunk($/) {
    my $mast := Markdown::Para.new();
    my $first := 1;
    for $<BlockQuoteLine> {
        unless ( $first ) {
            $mast.push( Markdown::Newline.new() );
        }
        $mast.push( $( $_ ) );
        $first := 0;
    }
    make $mast;
}

method BlockQuoteLine($/) {
    my $mast := Markdown::Node.new();
    $mast.push( $( $<BlockQuoteFirstLine> ) );
    for $<BlockQuoteNextLine> {
        $mast.push( Markdown::Newline.new() );
        $mast.push( $( $_ ) );
    }
    make $mast;
}

method BlockQuoteFirstLine($/) {
    my $mast := Markdown::Node.new();
    for $<Inline> {
        $mast.push( $( $_ ) );
    }
    make $mast;
}

method BlockQuoteNextLine($/) {
    my $mast := Markdown::Node.new();
    for $<Inline> {
        $mast.push( $( $_ ) );
    }
    make $mast;
}

method Line($/) {
    make Markdown::Line.new( :text( ~$<RawLine>[0] ) );
}

method BlankLine($/) {
    make Markdown::Newline.new( :text( $/.text() ) );
}

method NonblankIndentedLine($/) {
    make Markdown::Line.new( :text( ~$<IndentedLine><Line><RawLine>.text() ),
                             :detab( 1 ) );
}

method VerbatimChunk($/) {
    my $mast := Markdown::Node.new();
    for $<BlankLine> {
        $mast.push( $( $_ ) );
    }
    for $<NonblankIndentedLine> {
        $mast.push( $( $_ ) );
    }
    make $mast;
}

method Verbatim($/) {
    my $mast := Markdown::CodeBlock.new();
    for $<VerbatimChunk> {
        $mast.push( $( $_ ) );
    }
    make $mast;
}

method HorizontalRule($/) {
    make Markdown::HorizontalRule.new();
}

method BulletList($/, $key) {
    make $( $/{$key} );
}

method BulletListTight($/) {
    my $mast := Markdown::ItemizedList.new();
    for $<BulletListItem> {
        $mast.push( $( $_ ) );
    }
    make $mast;
}

method BulletListLoose($/) {
    my $mast := Markdown::ItemizedList.new();
    for $<BulletListItem> {
        my $item := $( $_ );
        $item.loose( 1 );
        $mast.push( $item );
    }
    make $mast;
}

method BulletListItem($/) {
    make $( $<ListItem> );
}

method ListItem($/) {
    if ( $<ListContinuationBlock> ) {
        my $mast := Markdown::ListItem.new( $( $<ListBlock> ) );
        for $<ListContinuationBlock> {
            $mast.push( $( $_ ) );
        }
        make $mast;
    }
    else {
        make Markdown::ListItem.new( $( $<ListBlock> ) );
    }
}

method ListBlock($/) {
    my $mast := Markdown::Node.new();
    for $<Inline> {
        $mast.push( $( $_ ) );
    }
    for $<ListBlockLine> {
        $mast.push( Markdown::Newline.new() );
        $mast.push( $( $_ ) );
    }
    make $mast;
}

method ListBlockLine($/) {
    make $( $<OptionallyIndentedLine><Line> );
}

method ListContinuationBlock($/) {
    my $mast := Markdown::Node.new();
    for $<ListBlock> {
        $mast.push( $( $_ ) );
    }
    make $mast;
}

method OrderedList($/, $key) {
    make $( $/{$key} );
}

method OrderedListTight($/) {
    my $mast := Markdown::OrderedList.new();
    for $<OrderedListItem> {
        $mast.push( $( $_ ) );
    }
    make $mast;
}

method OrderedListLoose($/) {
    my $mast := Markdown::OrderedList.new();
    for $<OrderedListItem> {
        my $item := $( $_ );
        $item.loose( 1 );
        $mast.push( $item );
    }
    make $mast;
}

method OrderedListItem($/) {
    make $( $<ListItem> );
}

method HtmlBlock($/, $key) {
    make $( $/{$key} );
}

method Emph($/, $key) {
    make $( $/{$key} );
}

method EmphStar($/) {
    my $mast := Markdown::Emphasis.new();
    for $<Inline> {
        $mast.push( $( $_ ) );
    }
    $mast.push( $( $<OneStarClose><Inline> ) );
    make $mast;
}

method EmphUI($/) {
    my $mast := Markdown::Emphasis.new();
    for $<Inline> {
        $mast.push( $( $_ ) );
    }
    $mast.push( $( $<OneUIClose><Inline> ) );
    make $mast;
}

method Strong($/, $key) {
    make $( $/{$key} );
}

method StrongStar($/) {
    my $mast := Markdown::Strong.new();
    for $<Inline> {
        $mast.push( $( $_ ) );
    }
    $mast.push( $( $<TwoStarClose><Inline> ) );
    make $mast;
}

method StrongUI($/) {
    my $mast := Markdown::Strong.new();
    for $<Inline> {
        $mast.push( $( $_ ) );
    }
    $mast.push( $( $<TwoUIClose><Inline> ) );
    make $mast;
}

method Image($/, $key) {
    my $mast := $( $/{$key} );
    $mast.image( '1' );
    make $mast;
}

method Link($/, $key) {
    make $( $/{$key} );
}

method ReferenceLink($/, $key) {
    make $( $/{$key} );
}

method ReferenceLinkDouble($/) {
    my $mast := Markdown::RefLink.new( :key( ~$<Label>[1].text() ),
                                       :text( $/.text() ) );
    for $<Label>[0]<Inline> {
        $mast.push( $( $_ ) );
    }
    make $mast;
}

method ReferenceLinkSingle($/) {
    make Markdown::RefLink.new( :key( ~$<Label>.text() ),
                                :text( $/.text() ) );
}

method ExplicitLink($/) {
    my $mast := Markdown::Link.new( :title( ~$<Title>[0].text() ),
                                    :url( ~$<Source><SourceContents>.text() ) );
    for $<Label><Inline> {
        $mast.push( $( $_ ) );
    }
    make $mast;
}

method AutoLink($/, $key) {
    make $( $/{$key} );
}

method AutoLinkUrl($/) {
    my $mast := Markdown::Link.new( :url( $/[0].text() ) );
    $mast.push( Markdown::Line.new( :text( $/[0].text() ) ));
    make $mast
}

method AutoLinkEmail($/) {
    make Markdown::Email.new( :text( $/[0].text() ) );
}

method Reference($/) {
    my $mast := Markdown::Reference.new( );
    $mast.insert( ~$<Label>.text(), ~$<RefSrc>.text(), ~$<RefTitle>[0].text() );
    make $mast
}

method Code($/) {
    make Markdown::Code.new( :text( $/[0].text() ) );
}

method RawHtml($/, $key) {
    make $( $/{$key} );
}

method HtmlComment($/) {
    make Markdown::Html.new( :text( $/.text() ),
                             :detab( 1 ) );
}

method HtmlTag($/) {
    make Markdown::Html.new( :text( $/.text() ) );
}

method EscapedChar($/) {
    make Markdown::Word.new( :text( $/[0].text() ) );
}

method Entity($/) {
    make Markdown::Html.new( :text( $/.text() ) );
}

method Symbol($/) {
    make Markdown::Word.new( :text( $/.text() ) );
}

method Endline($/) {
    make Markdown::Word.new( :text( $/.text() ) );
}

method Str($/) {
    make Markdown::Word.new( :text( $/.text() ) );
}

method Space($/) {
    make Markdown::Space.new( :text( $/.text() ) );
}

method Smart($/, $key) {
    make $( $/{$key} );
}

method Apostrophe($/) {
#    if ( $/.is_strict() ) {
        make Markdown::Word.new( :text( $/.text() ) );
#    }
#    else {
#        make Markdown::Html.new( :text( '&rsquo;' ) );
#    }
}

method Ellipsis($/) {
    if ( $/.is_strict() ) {
        make Markdown::Word.new( :text( $/.text() ) );
    }
    else {
        make Markdown::Html.new( :text( '&hellip;' ) );
    }
}

method Dash($/, $key) {
    make $( $/{$key} );
}

method EnDash($/) {
#    if ( $/.is_strict() ) {
        make Markdown::Word.new( :text( $/.text() ) );
#    }
#    else {
#        make Markdown::Html.new( :text( '&ndash;' ) );
#    }
}

method EmDash($/) {
    if ( $/.is_strict() ) {
        make Markdown::Word.new( :text( $/.text() ) );
    }
    else {
        make Markdown::Html.new( :text( '&mdash;' ) );
    }
}

method DoubleQuoted($/) {
    make Markdown::Line.new( :text( $/.text() ) );
}

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
