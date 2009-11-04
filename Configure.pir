#! /usr/local/bin/parrot
# Copyright (C) 2009, Parrot Foundation.

.include 'sysinfo.pasm'
.include 'iglobals.pasm'

.sub 'main' :main
    # Wave to the friendly users
    print "Hello, I'm Configure. My job is to poke and prod\n"
    print "your system to figure out how to build Markdown.\n"

    .local pmc config
    $P0 = getinterp
    config = $P0[.IGLOBALS_CONFIG_HASH]
    .local string OS
    OS = sysinfo .SYSINFO_PARROT_OS

    # Something, we need extra configuration variables
    $S0 = ''
    unless OS == 'darwin' goto L1
    # MACOSX_DEPLOYMENT_TARGET must be defined for OS X compilation/linking
    $S0 = "export MACOSX_DEPLOYMENT_TARGET := "
    $S1 = config['osx_version']
    $S0 .= $S1
  L1:
    config['macosx_deployment_target'] = $S0

    # Here, do the job
    push_eh _handler
    genfile('config/makefiles/root.in', 'Makefile', config)
    pop_eh

    # Give the user a hint of next action
    .local string make
    make = config['make']
    print "Configure completed for platform '"
    print OS
    print "'.\n"
    print "You can now type '"
    print make
    print "' to build Markdown.\n"
    print "You may also type '"
    print make
    print " test' to run the Markdown test suite.\n"
    print "\nHappy Hacking.\n"
    end

  _handler:
    .local pmc e
    .local string msg
    .get_results (e)
    printerr "\n"
    msg = e
    printerr msg
    printerr "\n"
    end
.end


.sub 'genfile'
    .param string tmpl
    .param string outfile
    .param pmc config
    $S0 = slurp(tmpl)
    $S0 = subst_config($S0, config)
    $S0 = subst_slash($S0)
    output(outfile, $S0)
    printerr "\n\tGenerating '"
    printerr outfile
    printerr "'\n\n"
.end

.sub 'slurp'
    .param string filename
    $P0 = new 'FileHandle'
    push_eh _handler
    $S0 = $P0.'readall'(filename)
    pop_eh
    .return ($S0)
  _handler:
    .local pmc e
    .get_results (e)
    $S0 = "Can't open '"
    $S0 .= filename
    $S0 .= "' ("
    $S1 = err
    $S0 .= $S1
    $S0 .= ")\n"
    e = $S0
    rethrow e
.end

.sub 'output'
    .param string filename
    .param string content
    $P0 = new 'FileHandle'
    push_eh _handler
    $P0.'open'(filename, 'w')
    pop_eh
    $P0.'puts'(content)
    $P0.'close'()
    .return ()
  _handler:
    .local pmc e
    .get_results (e)
    $S0 = "Can't open '"
    $S0 .= filename
    $S0 .= "' ("
    $S1 = err
    $S0 .= $S1
    $S0 .= ")\n"
    e = $S0
    rethrow e
.end

.sub 'subst_config'
    .param string content
    .param pmc config
    $P0 = split "\n", content
    .local string result, line
    result = ''
  L1:
    unless $P0 goto L2
    line = shift $P0
    $I0 = 0
    $S0 = ''
  L3:
    $I1 = index line, '@', $I0
    if $I1 < 0 goto L4
    $I2 = $I1 - $I0
    inc $I1
    $I3 = index line, '@', $I1
    if $I3 < 0 goto L4
    $S1 = substr line, $I0, $I2
    $S0 .= $S1
    $I4 = $I3 - $I1
    $S1 = substr line, $I1, $I4
    $I7 = exists config[$S1]
    unless $I7 goto L5
    $S2 = config[$S1]
    $S0 .= $S2
    goto L6
  L5:
    printerr "\tunknown config: "
    printerr $S1
    printerr "\n"
  L6:
    $I0 = $I3 + 1
    goto L3
  L4:
    $S1 = substr line, $I0
    $S0 .= $S1
    result .= $S0
    result .= "\n"
    goto L1
  L2:
    .return (result)
.end

.sub 'subst_slash'
    .param string str
    $S1 = sysinfo .SYSINFO_PARROT_OS
    unless $S1 == 'MSWin32' goto L1
    $P0 = split "/", str
    str = join "\\", $P0
    $P0 = split "\\\\", str
    str = join "/", $P0
    $P0 = split "\\*", str
    str = join "\\\\*", $P0
    .return (str)
  L1:
    $P0 = split "//", str
    str = join "/", $P0
    .return (str)
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

