#!/usr/bin/env parrot
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

    .const 'Sub' spectest = 'spectest'
    register_step('spectest', spectest)

    $P0 = new 'Hash'
    $P0['name'] = 'Markdown'
    $P0['abstract'] = 'Markdown on Parrot'
    $P0['authority'] = 'http://github.com/fperrad'
    $P0['description'] = 'This is the port of the Markdown, a lightweight markup language, on the Parrot VM.'
    $P5 = split ',', 'markdown,wiki'
    $P0['keywords'] = $P5
    $P0['license_type'] = 'Artistic License 2.0'
    $P0['license_uri'] = 'http://www.perlfoundation.org/artistic_license_2_0'
    $P0['copyright_holder'] = 'Parrot Foundation'
    $P0['checkout_uri'] = 'git://github.com/fperrad/markdown.git'
    $P0['browser_uri'] = 'http://github.com/fperrad/markdown'
    $P0['project_uri'] = 'http://github.com/fperrad/markdown'

    # build
    $P1 = new 'Hash'
    $P1['markdown/grammar_gen.pir'] = 'markdown/grammar.pg'
    $P0['pir_pge'] = $P1

    $P2 = new 'Hash'
    $P2['markdown/actions_gen.pir'] = 'markdown/actions.nqp'
    $P0['pir_nqp-rx'] = $P2

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
    $P3['markdown.pbc'] = 'markdown.pir'
    $P0['pbc_pir'] = $P3

    $P6 = new 'Hash'
    $P6['parrot-markdown'] = 'markdown.pbc'
    $P0['installable_pbc'] = $P6

    $P7 = new 'Hash'
    $P7['man/man1/parrot-markdown.1'] = 'markdown.pir'
    $P0['man_pod'] = $P7

    # test
    $S0 = get_parrot()
    $P0['prove_exec'] = $S0

    # install
    $P0['inst_lang'] = 'markdown/markdown.pbc'

    # dist
    $P8 = split ' ', 'CREDITS MAINTAINER README'
    $P0['doc_files'] = $P8

    .tailcall setup(args :flat, $P0 :flat :named)
.end

.sub 'spectest' :anon
    .param pmc kv :slurpy :named
    .local string cmd
    $I0 = file_exists('t/MarkdownTest_1.0.zip')
    if $I0 goto L1
    cmd = 'cd t && perl -MLWP::Simple -e "getstore(q{http://daringfireball.net/projects/downloads/MarkdownTest_1.0.zip}, q{MarkdownTest_1.0.zip});"'
    system(cmd, 1 :named('verbose'))
  L1:
    $I0 = file_exists('t/MarkdownTest_1.0')
    if $I0 goto L2
    cmd  = 'cd t && perl -MArchive::Zip -e "Archive::Zip->new(q{MarkdownTest_1.0.zip})->extractTree();"'
    system(cmd, 1 :named('verbose'))
  L2:

    run_step('test', kv :flat :named)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
