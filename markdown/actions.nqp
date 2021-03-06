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
        $mast.push( $_.ast() );
    }
    make $mast;
}

method Block($/, $key) {
    make $/{$key}.ast();
}

method Para($/) {
    my $mast := Markdown::Para.new();
    for $<Inlines><_Inline> {
        $mast.push( $_.ast() );
    }
    make $mast;
}

method Heading($/, $key) {
    make $/{$key}.ast();
}

method AtxHeading($/) {
    my $mast := Markdown::Title.new( :level( $<AtxStart>.length() ) );
    for $<AtxInline> {
        $mast.push( $_.ast() );
    }
    make $mast;
}

method AtxInline($/) {
    make $<Inline>.ast();
}

method _Inline($/, $key) {
    make $/{$key}.ast();
}

method Inline($/, $key) {
    make $/{$key}.ast();
}

method SetextHeading($/, $key) {
    make $/{$key}.ast();
}

method SetextHeading1($/) {
    my $mast := Markdown::Title.new( :level( 1 ) );
    for $<Inline> {
        $mast.push( $_.ast() );
    }
    make $mast;
}

method SetextHeading2($/) {
    my $mast := Markdown::Title.new( :level( 2 ) );
    for $<Inline> {
        $mast.push( $_.ast() );
    }
    make $mast;
}

method BlockQuote($/) {
    my $mast := Markdown::BlockQuote.new();
    for $<BlockQuoteChunk> {
        $mast.push( $_.ast() );
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
        $mast.push( $_.ast() );
        $first := 0;
    }
    make $mast;
}

method BlockQuoteLine($/) {
    my $mast := Markdown::Node.new();
    $mast.push( $<BlockQuoteFirstLine>.ast() );
    for $<BlockQuoteNextLine> {
        $mast.push( Markdown::Newline.new() );
        $mast.push( $_.ast() );
    }
    make $mast;
}

method BlockQuoteFirstLine($/) {
    my $mast := Markdown::Node.new();
    for $<Inline> {
        $mast.push( $_.ast() );
    }
    make $mast;
}

method BlockQuoteNextLine($/) {
    my $mast := Markdown::Node.new();
    for $<Inline> {
        $mast.push( $_.ast() );
    }
    make $mast;
}

method Line($/) {
    make Markdown::Line.new( :text( $<RawLine>[0].Str() ) );
}

method BlankLine($/) {
    make Markdown::Newline.new( :text( $/.Str() ) );
}

method NonblankIndentedLine($/) {
    make Markdown::Line.new( :text( $<IndentedLine><Line><RawLine>.Str() ),
                             :detab( 1 ) );
}

method VerbatimChunk($/) {
    my $mast := Markdown::Node.new();
    for $<BlankLine> {
        $mast.push( $_.ast() );
    }
    for $<NonblankIndentedLine> {
        $mast.push( $_.ast() );
    }
    make $mast;
}

method Verbatim($/) {
    my $mast := Markdown::CodeBlock.new();
    for $<VerbatimChunk> {
        $mast.push( $_.ast() );
    }
    make $mast;
}

method HorizontalRule($/) {
    make Markdown::HorizontalRule.new();
}

method BulletList($/, $key) {
    make $/{$key}.ast();
}

method BulletListTight($/) {
    my $mast := Markdown::ItemizedList.new();
    for $<BulletListItem> {
        $mast.push( $_.ast() );
    }
    make $mast;
}

method BulletListLoose($/) {
    my $mast := Markdown::ItemizedList.new();
    for $<BulletListItem> {
        my $item := $_.ast();
        $item.loose( 1 );
        $mast.push( $item );
    }
    make $mast;
}

method BulletListItem($/) {
    make $<ListItem>.ast();
}

method ListItem($/) {
    if ( $<ListContinuationBlock> ) {
        my $mast := Markdown::ListItem.new( $<ListBlock>.ast() );
        for $<ListContinuationBlock> {
            $mast.push( $_.ast() );
        }
        make $mast;
    }
    else {
        make Markdown::ListItem.new( $<ListBlock>.ast() );
    }
}

method ListBlock($/) {
    my $mast := Markdown::Node.new();
    for $<Inline> {
        $mast.push( $_.ast() );
    }
    for $<ListBlockLine> {
        $mast.push( Markdown::Newline.new() );
        $mast.push( $_.ast() );
    }
    make $mast;
}

method ListBlockLine($/) {
    make $<OptionallyIndentedLine><Line>.ast();
}

method ListContinuationBlock($/) {
    my $mast := Markdown::Node.new();
    for $<ListBlock> {
        $mast.push( $_.ast() );
    }
    make $mast;
}

method OrderedList($/, $key) {
    make $/{$key}.ast();
}

method OrderedListTight($/) {
    my $mast := Markdown::OrderedList.new();
    for $<OrderedListItem> {
        $mast.push( $_.ast() );
    }
    make $mast;
}

method OrderedListLoose($/) {
    my $mast := Markdown::OrderedList.new();
    for $<OrderedListItem> {
        my $item := $_.ast();
        $item.loose( 1 );
        $mast.push( $item );
    }
    make $mast;
}

method OrderedListItem($/) {
    make $<ListItem>.ast();
}

method HtmlBlock($/) {
    make Markdown::Html.new( :text( $/.Str() ),
                             :detab( 1 ) );
}

method Emph($/, $key) {
    make $/{$key}.ast();
}

method EmphStar($/) {
    my $mast := Markdown::Emphasis.new();
    for $<Inline> {
        $mast.push( $_.ast() );
    }
    $mast.push( $<OneStarClose><Inline>.ast() );
    make $mast;
}

method EmphUI($/) {
    my $mast := Markdown::Emphasis.new();
    for $<Inline> {
        $mast.push( $_.ast() );
    }
    $mast.push( $<OneUIClose><Inline>.ast() );
    make $mast;
}

method Strong($/, $key) {
    make $/{$key}.ast();
}

method StrongStar($/) {
    my $mast := Markdown::Strong.new();
    for $<Inline> {
        $mast.push( $_.ast() );
    }
    $mast.push( $<TwoStarClose><Inline>.ast() );
    make $mast;
}

method StrongUI($/) {
    my $mast := Markdown::Strong.new();
    for $<Inline> {
        $mast.push( $_.ast() );
    }
    $mast.push( $<TwoUIClose><Inline>.ast() );
    make $mast;
}

method Image($/, $key) {
    my $mast := $/{$key}.ast();
    $mast.image( '1' );
    make $mast;
}

method Link($/, $key) {
    make $/{$key}.ast();
}

method ReferenceLink($/, $key) {
    make $/{$key}.ast();
}

method ReferenceLinkDouble($/) {
    my $mast := Markdown::RefLink.new( :key( $<Label>[1].Str() ),
                                       :text( $/.Str() ) );
    for $<Label>[0]<Inline> {
        $mast.push( $_.ast() );
    }
    make $mast;
}

method ReferenceLinkSingle($/) {
    make Markdown::RefLink.new( :key( $<Label>.Str() ),
                                :text( $/.Str() ) );
}

method ExplicitLink($/) {
    my $mast := Markdown::Link.new( :title( $<Title>[0].Str() ),
                                    :url( $<Source><SourceContents>.Str() ) );
    for $<Label><Inline> {
        $mast.push( $_.ast() );
    }
    make $mast;
}

method AutoLink($/, $key) {
    make $/{$key}.ast();
}

method AutoLinkUrl($/) {
    my $mast := Markdown::Link.new( :url( $/[0].Str() ) );
    $mast.push( Markdown::Line.new( :text( $/[0].Str() ) ));
    make $mast
}

method AutoLinkEmail($/) {
    make Markdown::Email.new( :text( $/[0].Str() ) );
}

method Reference($/) {
    my $mast := Markdown::Reference.new( );
    $mast.insert( $<Label>.Str(), $<RefSrc>.Str(), $<RefTitle>[0].Str() );
    make $mast
}

method Code($/) {
    make Markdown::Code.new( :text( $/[0].Str() ) );
}

method RawHtml($/, $key) {
    make $/{$key}.ast();
}

method HtmlComment($/) {
    make Markdown::Html.new( :text( $/.Str() ),
                             :detab( 1 ) );
}

method HtmlTag($/) {
    make Markdown::Html.new( :text( $/.Str() ) );
}

method EscapedChar($/) {
    make Markdown::Word.new( :text( $/[0].Str() ) );
}

method Entity($/) {
    make Markdown::Html.new( :text( $/.Str() ) );
}

method Symbol($/) {
    make Markdown::Word.new( :text( $/.Str() ) );
}

method Endline($/) {
    make Markdown::Word.new( :text( $/.Str() ) );
}

method String($/) {
    make Markdown::Word.new( :text( $/.Str() ) );
}

method Space($/) {
    make Markdown::Space.new( :text( $/.Str() ) );
}

method Smart($/, $key) {
    make $/{$key}.ast();
}

method Apostrophe($/) {
#    if ( $/.is_strict() ) {
        make Markdown::Word.new( :text( $/.Str() ) );
#    }
#    else {
#        make Markdown::Html.new( :text( '&rsquo;' ) );
#    }
}

method Ellipsis($/) {
    if ( $/.is_strict() ) {
        make Markdown::Word.new( :text( $/.Str() ) );
    }
    else {
        make Markdown::Html.new( :text( '&hellip;' ) );
    }
}

method Dash($/, $key) {
    make $/{$key}.ast();
}

method EnDash($/) {
#    if ( $/.is_strict() ) {
        make Markdown::Word.new( :text( $/.Str() ) );
#    }
#    else {
#        make Markdown::Html.new( :text( '&ndash;' ) );
#    }
}

method EmDash($/) {
    if ( $/.is_strict() ) {
        make Markdown::Word.new( :text( $/.Str() ) );
    }
    else {
        make Markdown::Html.new( :text( '&mdash;' ) );
    }
}

method DoubleQuoted($/) {
    make Markdown::Line.new( :text( $/.Str() ) );
}

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
