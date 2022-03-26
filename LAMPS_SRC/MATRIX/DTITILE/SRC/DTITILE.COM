$!
$! Logical name assignments made, version.src generated for each link
$!						TJH 24-Feb-1987
$! command file to compile and link DTITILE
$	sv=""
$	if p1.nes."" then sv = "noverify"
$	on error then goto error
$	define lsl$cmndtitile here
$	define lsl$matrixsys lsl$source_root:[matrix.service]
$	define lsl$dtmcreatesys lsl$source_root:[matrix.service]
$!
$	deb=""
$	lst=""
$	dia=""
$	disk:='f$logical("sys$disk")'
$!
$	inquire compile "compile"
$	if .not.compile then goto nocompile
$	inquire dtitile "dtitile,get_cmds,"
$	inquire commands "cancel_cmd through to window_cmd"
$	inquire other "compile opndti,copydat etc.?"
$	inquire cmdtab "command table?"
$!
$nocompile:inquire lnk  "link"
$	inquire debug "debug"
$	if .not.debug then goto nodebug
$	if debug then deb = "/debug/noopt/check=(b,o)"
$	if deb.nes."" then mbug = "/debug"
$	if deb.nes."" then ibug = "/debug"
$nodebug:
$	inquire list "list"
$	if .not.list then goto nolist
$	if list then lst = "/list=list.lis"
$	if .not.compile then goto link
$nolist:if sv.eqs."" then set verify
$	if .not.compile then goto link
$!
$	if .not.dtitile then goto nodtitile
$	adc dtitile= dtitile,get_cmds
$	if .not.list then goto nodtitile_lis
$	if list then lst = "/list=dtitile.lis"
$nodtitile_lis:
$	define/user sys$output error.lis
$	fortran 'deb' 'lst' dtitile
$	pvv  dtitile
$!
$nodtitile:if.not.commands then goto nocommands
$	adc commands = cancel_cmd,disable_cmd,-
		enable_cmd,filein_cmd,fileout_cmd,-
		go_cmd,help_cmd,null_cmd,origin_cmd,pause_cmd,size_cmd,-
		show_cmd,units_cmd,void_cmd,window_cmd
$	if .not.list then goto nocommands_lis
$	if list then lst = "/list=commands.lis"
$!
$nocommands_lis:
$	define/user sys$output error.lis
$	fortran 'deb'  'lst' commands
$	pvv  commands
$!
$nocommands:if.not.other then goto noother
$	adc other = opndti,copydat,readll,modhead,-
				getvoid,showvoid,cvtang,check_null
$	if .not.list then goto noother_lis
$	if list then lst = "/list=other.lis"
$!
$noother_lis:
$	define/user sys$output error.lis
$	fortran 'deb'  'lst' other
$	pvv  other
$!
$noother:if .not.cmdtab then goto link
$	macro 'mbug' dtitile_cmdtab
$!
$link: if .not.lnk then goto nolnk
$	run lsl$exe:genver
$	adc version=version
$	define/user sys$output error.lis
$	fortran 'deb'  'lst' version
$	pvv  version
$	del version.for;*
$!
$	define/user sys$output error.lis
$	link 'ibug'/map dtitile,version,commands,other,dtitile_cmdtab,-
			lsl$library:pmeclock.obj,-
			lsl$matrixsys:matrix/lib,-
			lsl$library:dtilib/lib,-
			lsl$library:lslshr.opt/opt
$ nolnk:
$	delete adc.ide;*
$	purge dtitile.map
$	purge *.obj
$	purge *.lis
$	purge *.for
$	if .not.debug then delete *.for;*
$	goto noerror
$ error:
$	write sys$output " An error occurred "
$ noerror:
$	deassign lsl$matrixsys 
$	deassign lsl$cmndtitile 
$!
$	set noverify
$!
