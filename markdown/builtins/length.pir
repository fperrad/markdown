# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 simple implementation of a length function

=cut

.namespace [ 'Markdown';'Grammar' ]

.sub 'length' :method
    $S0 = self
    $I0 = length $S0
    new $P0, 'Integer'
    set $P0, $I0
    .return ($P0)
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

