$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! Command file for building DMTLIB
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Initialise
$	set noverify
$!
$	on error then goto nolink
$	on control then goto exit
$!
$	TRUE  = 1
$	FALSE = 0
$!
$	assign lsl$source_root:[lslinternal.dmtlib] lsl$cmndmt
$!
$!	newmsg == "$lsl750::lsl$exe:newmsg
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Decide what needs doing
$!
$	inquire mes  "DMTLIB message definitions"
$	inquire cmp  "compile"
$	cdbg = ""
$	ldbg = ""
$	dbg = FALSE
$	if cmp then inquire dbg "debug"
$	if dbg then fdbg = "/debug/nooptimise/check=(b,o)"
$!
$	if.not.cmp then goto noask
$	inquire all  "compile everything"
$	if.not.all then goto notall
$!
$	m1  = TRUE
$	m2  = TRUE
$!	...
$!
$	goto noask
$notall:
$	m1  = FALSE
$	m2  = FALSE
$!	...
$!
$	INQUIRE m1   "compile MTI DMTLIB routines"
$	INQUIRE m2   "compile MTO DMTLIB routines"
$noask:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Build message files
$	if.not.mes then goto nomes
$	set verify
$	newmsg dmtlib.mes/number=1902/parameter=(fortran)
$	@dmtlib.temp_com
$nomes:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Compile
$	if.not.cmp then goto nocmp
$	set verify
$!
$	if.not.m1 then goto nom1
$	adc mti = mtinit,mtirdb,mtispc,mtirwd,mtibck,mtieov,mtisns
$	fortran'fdbg' mti
$	pvv mti
$	libr/replace lsl$site_root:[lsl.lib]dmtlib mti
$nom1:
$	if.not.m2 then goto nom2
$	adc mto = mtonit,mtordb,mtospc,mtorwd,mtobck,mtowrb,mtoeof,mtoeov,mtosns
$	fortran'fdbg' mto
$	pvv mto
$	libr/replace lsl$site_root:[lsl.lib]dmtlib mto
$nom2:
$!
$nocmp:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Purge
$	purge/log *.obj,*.for
$	del adc.ide;*
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Exit
$exit:	set noverify
$	exit
