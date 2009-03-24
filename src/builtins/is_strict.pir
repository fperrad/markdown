# Copyright (C) 2009, Parrot Foundation.
# $Id$

.namespace [ 'Markdown';'Grammar' ]

.sub 'is_strict' :method
    $P0 = new 'Env'
    $S0 = $P0['MARKDOWN_STRICT']
    .return ($S0)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

