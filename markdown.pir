# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 A Markdown compiler.

=head2 Synopsis

as a command line (without interactive mode) :

    $ parrot-markdown document.text
    $ parrot-markdown --target=parse document.text
                               PAST
                               HTML

or as a library from PIR code :

     load_language 'markdown'
     $P0 = compreg 'markdown'
     $S0 = <<'MARKDOWN'
 Title
 =====
 Some text.
 MARKDOWN
     $P1 = $P0.'compile'($S0)
     $S0 = $P1()
     print $S0

or as a compiler from Rakudo :

     my $markdown = q{
 Title
 =====
 Some text.

     };

     say eval($markdown, :lang<markdown>);

=head2 Description

This is the entry file for the Markdown compiler.

=cut


.sub 'main' :main
    .param pmc args

    load_bytecode 'dumper.pbc'
    load_bytecode 'PGE/Dumper.pbc'

    load_language 'markdown'
    $P0 = compreg 'markdown'

    .local pmc opts
    opts = $P0.'process_args'(args)

    $P1 = $P0.'evalfiles'(args, opts :flat :named)
    print $P1
.end


=head2 See Also

L<http://daringfireball.net/projects/markdown/>

L<http://en.wikipedia.org/wiki/Markdown>

L<http://en.wikipedia.org/wiki/Lightweight_markup_language>

=cut

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

