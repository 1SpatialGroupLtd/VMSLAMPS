$!
$! command file to compile and link dtirotate
$!
$	on error then goto error
$	define lsl$matrixsys    lsl$source_root:[matrix.service]
$	define lsl$dtmcreatesys lsl$source_root:[matrix.service]
$	define lsl$cmndtirotate here
$!	delete error.lis;*
$!
$	deb=""
$	lst=""
$	dia=""
$	disk:='f$logical("sys$disk")'
$!
$	inquire compile "compile"
$	if .not.compile then goto nocompile
$!
$	inquire dtirotate "dtirotate,get_cmds "
$	inquire commands  "disable_cmd through to show_cmd "
$	inquire other     "dtirotate_setup,rotatedat etc.? "
$	inquire cmdtab    "command table? "
$!
$nocompile:
$	inquire lnk   "link"
$	inquire debug "debug"
$	if .not.debug then goto nodebug
$!
$	if debug then deb = "/debug/noopt/check=(b,o)"
$	if deb.nes."" then mbug = "/debug"
$	if deb.nes."" then ibug = "/debug"
$!
$nodebug:
$	inquire list "list"
$	if .not.list then goto nolist
$	if list then lst = "/list=list.lis"
$	if .not.compile then goto link
$!
$nolist:
$	set verify
$	if .not.compile then goto link
$!
$	if .not.dtirotate then goto nodtirotate
$!
$	adc dtirotate= dtirotate,get_cmds
$	if .not.list then goto nodtirotate_lis
$	if list then lst = "/list=dtirotate.lis"
$!
$nodtirotate_lis:
$	define/user sys$output error.lis
$	fortran 'deb' 'lst' dtirotate
$	pvv  dtirotate
$!
$nodtirotate:
$	if.not.commands then goto nocommands
$!
$	adc commands =  disable_cmd,enable_cmd,filein_cmd,fileout_cmd,-
			go_cmd,help_cmd,pause_cmd,show_cmd
$	if .not.list then goto nocommands_lis
$	if list then lst = "/list=commands.lis"
$!
$nocommands_lis:
$	define/user sys$output error.lis
$	fortran 'deb'  'lst' commands
$	pvv  commands
$!
$nocommands:
$	if.not.other then goto noother
$	adc other = mirror,dtirotate_setup,rotatedat,output_crt,percent
$	if .not.list then goto noother_lis
$	if list then lst = "/list=other.lis"
$!
$noother_lis:
$	define/user sys$output error.lis
$	fortran 'deb'  'lst' other
$	pvv  other
$!
$noother:
$	if .not.cmdtab then goto link
$!
$	macro 'mbug' dtirotate_cmdtab
$!
$link:
$	if .not.lnk then goto nolnk
$!
$!	newmsg/dti/number=1643/prefix=dtirot__/par=for/runoff dtirotate.mes
$!	@dtirotate.temp_com
$!
$	run lsl$exe:genver
$	adc version=version
$	define/user sys$output error.lis
$	fortran 'deb'  'lst' version
$	pvv  version
$	del version.for;*
$!
$	define/user sys$output error.lis
$	link 'ibug'/map dtirotate,version,commands,-
			other,dtirotate_cmdtab,-
			lsl$library:pmeclock.obj,-
			lsl$matrixsys:matrix/lib,-
			lsl$library:dtilib/lib,-
			lsl$library:lslshr/opt,-
			lsl$library:lsllib/lib
$!	pl *.exe
$!
$nolnk:
$	mapid dtirotate
$	delete adc.ide;*
$	delete *.obj;*
$	if .not.debug then delete *.for;*
$!
$ error:
$	deassign lsl$matrixsys 
$	deassign lsl$dtmcreatesys 
$	deassign lsl$cmndtirotate 
$	set noverify
$!
