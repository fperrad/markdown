#! perl
# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 the official test suite

=head2 Synopsis

    % perl t/MarkdownTest.t

=head2 Description

Run the tests of the official test suite.

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test;
use Test::More;
use File::Basename;
use File::Spec;

my @dir = ( 't', 'MarkdownTest_1.0', 'Tests' );
my @test_files = glob( File::Spec->catfile( @dir, '*.text' ) );

if ( scalar @test_files ) {
    plan tests => scalar @test_files;
}
else {
    plan skip_all => 'no MarkdownTest';
}

$ENV{MARKDOWN_STRICT} = 'NO_EXT';

my %skip = map { $_ => 'skip' } (
    14,
);

my %todo = map { $_ => 'todo' } (
    4,
    14,
    15,
    16,
    19
);

my $idx = 0;
foreach my $test_file (@test_files) {
    $idx += 1;
    my $test_name = basename($test_file, '.text');

SKIP:
    {
        skip($test_name, 1) if (exists $skip{$idx});
        my $code = Parrot::Test::slurp_file( $test_file ) . "\n";
        my $out = Parrot::Test::slurp_file(File::Spec->catfile( @dir, "$test_name.html" )) ;
        my @todo = (exists $todo{$idx}) ? ( 'todo', $test_name ) : ();
        language_output_is( 'markdown', $code, $out, $test_name, @todo );
    }
}


# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
