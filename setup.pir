#! /usr/local/bin/parrot
# Copyright (C) 2009, Parrot Foundation.

=head1 NAME

setup.pir - Python distutils style

=head1 DESCRIPTION

No Configure step, no Makefile generated.

=head1 USAGE

    $ parrot setup.pir build
    $ parrot setup.pir test
    $ sudo parrot setup.pir install

=cut

.sub 'main' :main
    .param pmc args
    $S0 = shift args
    load_bytecode 'distutils.pbc'

    # build
    $P0 = new 'Hash'
    $P1 = new 'Hash'
    $P1['markdown/grammar_gen.pir'] = 'markdown/grammar.pg'
    $P0['pir_pge'] = $P1
    $P2 = new 'Hash'
    $P2['markdown/actions_gen.pir'] = 'markdown/actions.pm'
    $P0['pir_nqp'] = $P2
    $P3 = new 'Hash'
    $P4 = split "\n", <<'SOURCES'
markdown/Compiler.pir
markdown/Node.pir
markdown/grammar_gen.pir
markdown/actions_gen.pir
markdown/builtins.pir
markdown/builtins/is_strict.pir
markdown/builtins/length.pir
SOURCES
    $P3['markdown/markdown.pbc'] = $P4
    $P5 = split ' ', 'markdown.pir'
    $P3['markdown.pbc'] = $P5
    $P0['pbc_pir'] = $P3
    $P6 = new 'Hash'
    $P6['parrot-markdown'] = 'markdown.pbc'
    $P0['exe_pbc'] = $P6
    # test
    $S0 = get_parrot()
    $P0['prove_exec'] = $S0
    # install
    $P7 = split ' ', 'markdown/markdown.pbc'
    $P0['inst_lang'] = $P7
    .tailcall setup(args :flat, $P0 :flat :named)
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
