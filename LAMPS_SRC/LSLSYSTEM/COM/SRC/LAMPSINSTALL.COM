$! LAMPSINSTALL.COM - procedure for automating LAMPS software installations
$!
$! 	Created						PGH 02-Dec-1986
$!MOD   Unsatisified GOTO GET_DEST fixed (bad device)	TJH 30-Mar-1988
$!MOD	Create [LSLUSER...]				PGH 05-Aug-1988
$!MOD	Remove /NOLIST as VMS V5 doesnt like it!	PGH 03-Oct-1988
$!MOD	allow pVAX SCSI magtapes			PGH 16-Oct-1989
$!
$	on control_C then goto emergency
$	on error then goto emergency
$	on warning then goto emergency
$	ws="write sys$output"
$!
$! get a command
$!
$Panic:
$       type sys$input
LSL LAMPS software installation procedure V1.3 Try HELP if needed.
$ question:
$       read/end=exit/prompt="LAMPSINSTALL>" sys$command P1
$	p1=f$edit(p1,"upcase,collapse")
$       if p1 .eqs."" then goto panic
$	clen=f$length(p1)
$	if p1.eqs."?" then goto help
$	if p1.eqs.f$extract(0,clen,"HELP") then goto help
$       if p1.eqs.f$extract(0,clen,"ROOTS") then goto roots
$       if p1.eqs.f$extract(0,clen,"SEARCHLISTS") then goto searchlists
$       if p1.eqs.f$extract(0,clen,"LOAD") then goto load
$       if p1.eqs.f$extract(0,clen,"DIRECTORIES") then goto directories
$	ws "%LAMPSINSTALL-W-UNKNCMD, unknown command"
$	ws "\''p1'\"
$	goto question
$!
$! ************************************************************************
$!
$! here to give help
$!
$help:
$	type sys$input

Commands available are:

HELP		- type this message.
ROOTS		- set up rooted logical names for main trees
DIRECTORIES	- create standard site_dependent directories
LOAD		- load and install software issue BACKUP savesets
SEARCHLISTS	- setup search lists LSL$EXE:, LSL$COM: etc

Suggested sequence is ROOTS, LOAD, DIRECTORIES, SEARCHLISTS

$	goto question
$!
$! ************************************************************************
$!
$! here to set up the rooted logical names for main trees
$!
$roots:
$	ws "Set up rooted logical names for main directory trees."
$	ws "Firstly select a disk for the LSL public, site-dependent, and user trees"
$	device=f$trnlnm("sys$sysdevice")
$       read/end=question/prompt="What device for public, site, and user trees [default is ''device'] ?  " -
		sys$command device
$	device=f$edit(device,"upcase,collapse")
$	if device.eqs."" then device=f$trnlnm("sys$sysdevice")
$	exists=f$getdvi(device,"exists")
$	if .not.exists then goto roots
$	pubdevice=f$getdvi(device,"devnam")-"_"-"_"
$	assign/trans=(concealed,terminal) -
	'pubdevice'[LSLPUBLIC.] 		LSL$PUBLIC_ROOT
$	show logical lsl$public_root
$	set noon
$	create lsl$public_root:[000000]test.tmp
$	if $status then goto public_ok
$	WS "%LAMPSINSTALL-W-CREATEFAIL. failed to create file in LSL$PUBLIC_ROOT:"
$	goto do_site
$!
$public_ok:
$	delete/noconfirm lsl$public_root:[000000]test.tmp;*
$do_site:
$	set on
$	assign/trans=(concealed,terminal) -
	'pubdevice'[LSLSITE.]			LSL$SITE_ROOT
$	show logical lsl$site_root
$	set noon
$	create lsl$site_root:[000000]test.tmp
$	if $status then goto site_ok
$	WS "%LAMPSINSTALL-W-CREATEFAIL. failed to create file in LSL$SITE_ROOT:"
$	goto do_user
$!
$site_ok:
$	delete/noconfirm lsl$site_root:[000000]test.tmp;*
$do_user:
$	set on
$	assign/trans=(concealed,terminal) -
	'pubdevice'[LSLUSER.]			LSL$USER_ROOT
$	show logical lsl$user_root
$	set noon
$	create lsl$user_root:[000000]test.tmp
$	if $status then goto user_ok
$	WS "%LAMPSINSTALL-W-CREATEFAIL. failed to create file in LSL$USER_ROOT:"
$	goto do_data
$!
$user_ok:
$	delete/noconfirm lsl$user_root:[000000]test.tmp;*
$do_data:
$	set on
$!
$getdatadev:
$	ws "Now select a disk for the LSL data tree"
$	device=f$trnlnm("sys$sysdevice")
$       read/end=question/prompt="What device for data tree [default is ''device'] ?  " -
		sys$command device
$	device=f$edit(device,"upcase,collapse")
$	if device.eqs."" then device=f$trnlnm("sys$sysdevice")
$	exists=f$getdvi(device,"exists")
$	if .not.exists then goto getdatadev
$	datdevice=f$getdvi(device,"devnam")-"_"-"_"
$!
$	assign/trans=(concealed,terminal) -
	'datdevice'[LSLDATA.] 			LSL$DATA_ROOT
$	show logical lsl$data_root
$	set noon
$	create lsl$data_root:[000000]test.tmp
$	if $status then goto data_ok
$	WS "%LAMPSINSTALL-W-CREATEFAIL. failed to create file in LSL$DATA_ROOT:"
$	goto data_done
$!
$data_ok:
$	delete/noconfirm lsl$data_root:[000000]test.tmp;*
$data_done:
$	set on
$!
$	goto question
$!
$! ************************************************************************
$!
$! here to set up the standard directories
$!
$directories:
$	ws "Set up standard site_dependent directories"
$	set noon
$	create/dir/log lsl$site_root:[lsl.com]/prot=(gr:rwe)
$	create/dir/log lsl$site_root:[lsl.exe]/prot=(gr:rwe)
$	create/dir/log lsl$site_root:[lsl.lib]/prot=(gr:rwe)
$	create/dir/log lsl$site_root:[lsl.help]/prot=(gr:rwe)
$	create/dir/log lsl$site_root:[lsl.lookup]/prot=(gr:rwe)
$	create/dir/log lsl$site_root:[lsl.frt]/prot=(gr:rwe)
$	create/dir/log lsl$site_root:[lsl.fpp]/prot=(gr:rwe)
$	create/dir/log lsl$site_root:[lsl.mgmt]/prot=(gr:rwe)
$	create/dir/log lsl$site_root:[lslsoft]/prot=(gr:rwe)
$	create/dir/log lsl$site_root:[lites2.cmd]/prot=(gr:rwe)
$	create/dir/log lsl$site_root:[lites2.jnl]/prot=(gr:rwe)
$	set directory/version=3/log lsl$site_root:[lites2.jnl]
$	create/dir/log lsl$user_root:[lsluser]/prot=(gr:rwe)
$	create/dir/log lsl$data_root:[lsl.iff]/prot=(gr:rwe)
$	create/dir/log lsl$data_root:[lsl.dti]/prot=(gr:rwe)
$	create/dir/log lsl$data_root:[lites2.work]/prot=(gr:rwe)
$	set on
$	goto question
$!
$! ************************************************************************
$!
$! here to read a software issue 
$!
$load:
$	ws "Load savesets from distribution medium"
$	tape_device=0
$	tape_mounted=0
$get_dest:
$	default_device="*UNKNOWN*"
$	device="MSA0:"
$	gosub check_device
$	if devtype.nes."" then default_device=device
$	device="MTA0:"
$	gosub check_device
$	if devtype.nes."" then default_device=device
$	device="MKA500:"
$	gosub check_device
$	if devtype.nes."" then default_device=device
$	device="MKB500:"
$	gosub check_device
$	if devtype.nes."" then default_device=device
$	device="MUB1:"
$	gosub check_device
$	if devtype.nes."" then default_device=device
$	device="MUA0:"
$	gosub check_device
$	if devtype.nes."" then default_device=device
$! ************************************************************************
$!
$       read/end=question/prompt="Where should issue savesets be read from [default is ''default_device'] ?  " -
		sys$command source
$	source=f$edit(source,"upcase,collapse")
$	if source.eqs."" then source=default_device
$	name=f$parse(source,,,"name","no_conceal")
$	if name.nes."" then goto got_name
$	node=f$parse(source,,,"node","no_conceal")
$	if node.nes."" then goto not_tape
$	device=f$parse(source,"sys$disk:",,"device","no_conceal")
$	if device.eqs."" then goto no_such
$	exists=f$getdvi(device,"exists")
$	if .not.exists then goto no_such
$	class=f$getdvi(device,"devclass")
$	if class.ne.2 then goto not_tape
$	goto tape_device
$no_such:
$	WS "%LAMPSINSTALL-W-NOSUCHDEV, Device ",source," is not available"
$	goto get_dest
$got_name:
$	WS "%LAMPSINSTALL-W-NOCOLON, source ",source," has unexpected filename"
$	WS "%LAMPSINSTALL-I-HINT, Device names must end in colon, filenames not allowed"
$	goto get_dest
$!
$! ************************************************************************
$!
$! here with a tape device - get characteristics.
$!
$tape_device:
$	set on
$	tape_device=1
$	WS "Device ",source," assumed to be a tape and will be mounted"
$	rewindsw="/REWIND"
$       read/end=question/prompt="Hit RETURN when ready " -
		sys$command yes
$	set noon
$	mount 'source'/foreign
$	if .not.$status then goto tape_device
$	set on
$	tape_mounted=1
$	default_action="[default is first on tape]"
$	goto all_devices
$not_tape:
$	WS "Device ",source," is not a tape. Assumed file structured."
$	rewindsw=""
$	default_action=""
$!
$! ************************************************************************
$!
$! here to get rest of characteristics for all source devices.
$!
$all_devices:
$       read/end=done2/prompt="/VERIFY [default N] ?  " -
		sys$command yes
$	if yes then verifysw="/VERIFY"
$	if .not.yes then verifysw="/NOVERIFY"
$       read/end=done2/prompt="/LOG [default N] ?  " -
		sys$command yes
$	if yes then logsw="/LOG"
$	if .not.yes then logsw="/NOLOG"
$       read/end=done2/prompt="/LIST [default N] ?  " -
		sys$command yes
$	if yes then listsw="/LIST"
$	if .not.yes then listsw=""
$	miscsw=verifysw+logsw+listsw
$!
$	to_root="LSL$PUBLIC_ROOT:"
$	first_next="First"
$!
$! ************************************************************************
$!
$next_saveset:
$       read/end=done2/prompt="''first_next' saveset name ? ''default_action' " -
		sys$command package
$!
$! ************************************************************************
$!
$	set noon
$	backup 'source''package''rewindsw'/save 'to_root'[*...]'miscsw'
$	if tape_device then rewindsw="/NOREWIND"
$	first_next="Next"
$	if tape_device then default_action="[default is next on tape]"
$	set on
$	goto next_saveset
$!
$! ************************************************************************
$!
$done2:
$	if tape_mounted then dismount 'source'/nounload
$	tape_mounted=0
$	goto question
$!
$! ************************************************************************
$!
$! here to set up the search lists
$!
$searchlists:
$	ws "Set up search lists for LSL$EXE etc"
$	@lsl$public_root:[lslsystem.com]searchlist_tree
$	goto question
$!
$! ************************************************************************
$!
$! subroutine to check availability of a magtape device
$!	
$ check_device:
$	devnam=device-":"-"_"
$	devtype=""
$	exists=f$getdvi(device,"exists")
$	if .not.exists then goto end_check_device
$	devtype=f$getdvi(device,"MEDIA_NAME")
$	devtype_explain=""
$	if devtype.eqs."TK50" then devtype_explain="(Cartridge tape)"
$	if devtype.eqs."TK70" then devtype_explain="(Cartridge tape)"
$	if devtype.eqs."TU81" then devtype_explain="(Half inch magtape)"
$	if devtype.eqs."TU78" then devtype_explain="(Half inch magtape)"
$	if devtype.eqs."TS11" then devtype_explain="(Half inch magtape)"
$	if devtype.eqs."TU10" then devtype_explain="(Half inch magtape)"
$	if devtype.eqs."TJ16" then devtype_explain="(Half inch magtape)"
$	explain_owner=""
$	ownerpid=f$getdvi(device,"PID")
$	if ownerpid.eqs."" then goto output_check_device
$	owneruser=""
$	set noon
$       owneruser=f$getjpi(ownerpid,"username")
$	set on
$	if owneruser.eqs."" then owneruser="* UNKNOWN *"
$       owneruser=f$edit(owneruser,"collapse")
$	mountcnt=f$getdvi(device,"MOUNTCNT")
$	if mountcnt.gt.0 then goto dev_mounted
$	explain_owner=" -  Allocated by "+owneruser
$	goto output_check_device
$dev_mounted:
$	explain_owner=" -  Mounted by "+owneruser
$	goto output_check_device
$output_check_device:
$	ws "Device ",device," is a ",devtype," drive ",devtype_explain,explain_owner
$end_check_device:
$	devtype_'devnam'=devtype
$	return
$!
$! ************************************************************************
$!
$! here for abnormal exits
$!
$emergency:
$	if tape_mounted then dismount 'source'/nounload
$	WS "%LAMPSINSTALL-W-ABORT. Procedure terminated abnormally"
$!
$! ************************************************************************
$!
$! all done
$!
$exit:
$	set noverify
$	exit
