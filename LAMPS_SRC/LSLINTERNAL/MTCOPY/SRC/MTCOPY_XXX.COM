$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! Command file for building MTCOPY_XXX (doesn't stop at multiple tape-marks)
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
$	assign lsl$source_root:[lslinternal.dmtlib.mtcopy] lsl$cmnmtcopy
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Decide what needs doing
$!
$	inquire mes  "MTCOPY message definitions"
$	inquire cld  "MTCOPY command definitions"
$	inquire cmp  "compile"
$	inquire lnk  "link MTCOPY"
$	cdbg = ""
$	ldbg = ""
$	dbg = FALSE
$	if cmp.or.lnk then inquire dbg "debug"
$	if dbg then fdbg = "/debug/nooptimise/check=(b,o)"
$	if dbg then ldbg = "/debug"
$!
$	if.not.cmp then goto noask
$	inquire all  "compile everything"
$	if.not.all then goto notall
$!
$	m1  = TRUE
$	m2  = TRUE
$	m3  = TRUE
$	m4  = TRUE
$	m5  = TRUE
$	m6  = TRUE
$!
$	goto noask
$notall:
$	m1  = FALSE
$	m2  = FALSE
$	m3  = FALSE
$	m4  = FALSE
$	m5  = FALSE
$	m6  = FALSE
$!
$	INQUIRE m1   "compile f_to_t"
$	INQUIRE m2   "compile get_commands"
$	INQUIRE m3   "compile identify_io_devices"
$	INQUIRE m4   "compile mtcopy"
$	INQUIRE m5   "compile t_to_f"
$	INQUIRE m6   "compile t_to_t"
$noask:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Build message files
$	if.not.mes then goto nomes
$	set verify
$	newmsg mtcopy.mes/number=1902/parameter=(fortran)
$	@mtcopy.temp_com
$nomes:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Compile
$	if.not.cmp then goto nocmp
$	set verify
$!
$	if.not.m1 then goto nom1
$	adc f_to_t = f_to_t
$	fortran'fdbg' f_to_t
$	pvv f_to_t
$!
$nom1:	if.not.m2 then goto nom2
$	adc get_commands = get_commands
$	fortran'fdbg' get_commands
$	pvv get_commands
$!
$nom2:	if.not.m3 then goto nom3
$	adc identify_io_devices = identify_io_devices
$	fortran'fdbg' identify_io_devices
$	pvv identify_io_devices
$!
$nom3:	if.not.m4 then goto nom4
$	adc mtcopy = mtcopy
$	fortran'fdbg' mtcopy
$	pvv mtcopy
$!
$nom4:	if.not.m5 then goto nom5
$	adc t_to_f = t_to_f
$	fortran'fdbg' t_to_f
$	pvv t_to_f
$!
$nom5:	if.not.m6 then goto nom6
$	adc t_to_t = t_to_t
$	fortran'fdbg' t_to_t
$	pvv t_to_t
$!
$nom6:
$!
$nocmp:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Compile CLD module
$	if.not.cld then goto nocld
$	set verify
$	adc mtcopy.tmp = mtcopy.cld
$	set command/object = mtcopycld mtcopy.tmp
$	pvv mtcopycld
$	delete mtcopy.tmp;*
$!
$nocld:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Link
$	if.not.lnk then goto nolink
$	set verify
$	link'ldbg'/map/exe=mtcopy_xxx -
		mtcopy,f_to_t,get_commands,-	! routines
		identify_io_devices,-
		t_to_f,t_to_t,-
		mtcopycld,-			! commands
		mtcopy.promsg_obj,-		! message table
		lsl$library:lslshr/opt		! for I/O
$!
$nolink:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Purge
$	purge/log *.obj,*.for,*.exe
$	del adc.ide;*
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Exit
$exit:	set noverify
$	exit
