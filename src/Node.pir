# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 MAST - Markdown abstract syntax tree

=head2 Description

This file implements the various abstract syntax tree nodes
for Markdown.

=cut

.namespace [ 'Markdown';'Node' ]

.sub 'onload' :anon :load :init
    .local pmc p6meta, base
    p6meta = new 'P6metaclass'
    base = p6meta.'new_class'('Markdown::Node', 'parent'=>'PAST::Node')

    p6meta.'new_class'('Markdown::BlockQuote', 'parent'=>base)
    p6meta.'new_class'('Markdown::Code', 'parent'=>base)
    p6meta.'new_class'('Markdown::Document', 'parent'=>base)
    p6meta.'new_class'('Markdown::Emphasis', 'parent'=>base)
    p6meta.'new_class'('Markdown::Email', 'parent'=>base)
    p6meta.'new_class'('Markdown::Entity', 'parent'=>base)
    p6meta.'new_class'('Markdown::HorizontalRule', 'parent'=>base)
    p6meta.'new_class'('Markdown::ItemizedList', 'parent'=>base)
    p6meta.'new_class'('Markdown::Line', 'parent'=>base)
    p6meta.'new_class'('Markdown::Link', 'parent'=>base)
    p6meta.'new_class'('Markdown::ListItem', 'parent'=>base)
    p6meta.'new_class'('Markdown::OrderedList', 'parent'=>base)
    p6meta.'new_class'('Markdown::Para', 'parent'=>base)
    p6meta.'new_class'('Markdown::RefLink', 'parent'=>base)
    p6meta.'new_class'('Markdown::Reference', 'parent'=>base)
    p6meta.'new_class'('Markdown::Space', 'parent'=>base)
    p6meta.'new_class'('Markdown::Strong', 'parent'=>base)
    p6meta.'new_class'('Markdown::Title', 'parent'=>base)
    p6meta.'new_class'('Markdown::Word', 'parent'=>base)
.end


.sub 'text' :method
    .param pmc value           :optional
    .param int has_value       :opt_flag
    .tailcall self.'attr'('text', value, has_value)
.end


.namespace [ 'Markdown';'Link' ]

.sub 'title' :method
    .param pmc value           :optional
    .param int has_value       :opt_flag
    .tailcall self.'attr'('title', value, has_value)
.end

.sub 'url' :method
    .param pmc value           :optional
    .param int has_value       :opt_flag
    .tailcall self.'attr'('url', value, has_value)
.end


.namespace [ 'Markdown';'RefLink' ]

.sub 'key' :method
    .param pmc value           :optional
    .param int has_value       :opt_flag
    .tailcall self.'attr'('key', value, has_value)
.end


.namespace [ 'Markdown';'Title' ]

.sub 'level' :method
    .param pmc value           :optional
    .param int has_value       :opt_flag
    .tailcall self.'attr'('level', value, has_value)
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

