$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-11-25 18:16:28.000000000 +0000
$! *
$! * This program is free software: you can redistribute it and/or modify
$! * it under the terms of the GNU General Public License as published by
$! * the Free Software Foundation, version 3.
$! *
$! * This program is distributed in the hope that it will be useful, but
$! * WITHOUT ANY WARRANTY; without even the implied warranty of
$! * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
$! * General Public License for more details.
$! *
$! * You should have received a copy of the GNU General Public License
$! * along with this program. If not, see http://www.gnu.org/licenses/.
$!
$! LSLINSTALL.COM - procedure for automating LSL LAMPS software installations
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$!
$! 	Created (after LAMPSINSTALL.COM)		PGH 05-Jul-1990
$!	Published version				PGH 03-Aug-1990 (2.0)
$!MOD   use * not *.* in magtape saveset name (SPR1172) PGH 24-Jun-1991 (2.1)
$!MOD	Ensure LSL$CUSTOMER_NAME defined (SPR1577)	PGH 23-Mar-1992 (2.2)
$!MOD	Define roots with /EXEC for mail etc		PGH 25-Nov-1992 (2.3)
$!MOD	Knows about DAT tapes and TZ30s			PGH 25-Nov-1992 (2.3)
$!
$	tape_mounted=""
$	on control_C then goto abort
$	on error then goto abort
$	on warning then goto abort
$	ws="write sys$output"
$	wc="write command"
$	cluster_member=f$getsyi("CLUSTER_MEMBER")
$	savdef=f$environment("DEFAULT")
$	savprot=f$environment("PROTECTION")
$	set prot=(sy:rwed,ow:rwed,gr:rwed,w)/default
$	everything=0
$! 
$! check available resources 
$! 
$       username=f$edit(f$getjpi("","username"),"collapse") 
$	if username.nes."SYSTEM"  
$	then  
$	   ws " "
$	   ws "%LSLINSTALL-F-NOTSYSTEM, only user SYSTEM may install LAMPS software" 
$	   ws " "
$	   goto abort
$	endif 
$! 
$! ************************************************************************
$!
$! get a command
$!
$Panic:
$	ws " "
$       ws "LSL LAMPS software installation procedure V2.3 Try HELP for assistance."
$	ws " "
$ question:
$       read/end=exit/prompt="LSLINSTALL>" sys$command P1
$	p1=f$edit(p1,"upcase,collapse")
$       if p1 .eqs."" then goto panic
$	clen=f$length(p1)
$	if p1.eqs."?" then goto help
$	if p1.eqs.f$extract(0,clen,"HELP") then goto help
$	if p1.eqs.f$extract(0,clen,"EXIT") then goto exit
$	if p1.eqs.f$extract(0,clen,"INSTALL") then goto install
$       if p1.eqs.f$extract(0,clen,"PREPARE") then goto prepare
$       if p1.eqs.f$extract(0,clen,"ROOTS") then goto roots
$       if p1.eqs.f$extract(0,clen,"USERNAMES") then goto usernames
$       if p1.eqs.f$extract(0,clen,"LOAD") then goto load
$       if p1.eqs.f$extract(0,clen,"DIRECTORIES") then goto directories
$       if p1.eqs.f$extract(0,clen,"FILES") then goto files
$       if p1.eqs.f$extract(0,clen,"SEARCHLISTS") then goto searchlists
$       if p1.eqs.f$extract(0,clen,"OPTIONS") then goto options
$       if p1.eqs.f$extract(0,clen,"TUNE") then goto tune
$	ws "%LSLINSTALL-W-UNKNCMD, unknown command"
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
INSTALL		- do complete installation (P,U,R,L,D,F,S,O,T)
PREPARE		- give introduction, and check resources.
USERNAMES	- create standard usernames.
ROOTS		- create root directories and set up rooted logical names.
LOAD		- load and install software issue BACKUP savesets.
DIRECTORIES	- create standard site_dependent directories.
FILES		- copy standard startup files to destinations.
SEARCHLISTS	- setup search lists LSL$EXE:, LSL$COM: etc.
OPTIONS		- set up environment for optional software.
TUNE		- recommend sensible SYSGEN VMS tuning parameters.
EXIT		- exit LSLINSTALL (also CTRL/Z)

Suggested sequence, which is done automatically by INSTALL command is:
	PREPARE, USERNAMES, ROOTS, LOAD, DIRECTORIES, FILES, SEARCHLISTS,
	OPTIONS, TUNE

$	goto question
$!
$! ************************************************************************
$!
$! here for complete installation
$!
$install:
$	everything=1
$! 
$! ************************************************************************
$!
$! announce ourselves
$!
$prepare:
$	ws " "
$	ws "--------------------------------------------------------------"
$	ws "PREPARE - give introduction, and check resources
$	ws "--------------------------------------------------------------"
$	ws " "
$       type sys$input
This procedure is used for the installation of LSL LAMPS (Laser-Scan Automated
Map Processing) Mapping and GIS software packages. It is documented in the 
"LSL LAMPS Installation Guide" which is part of the package documentation for
the LSL MAPPING package. 

To run this procedure, you must be logged on as user SYSTEM, as it carries out
the primary system management functions associated with installation of 
LAMPS software, vis:

	- Set up standard usernames for a LAMPS system
	- Load a distrubution tape containing the LSL software
	- Create standard site_dependent directories and files
	- Evaluate changes in SYSGEN parameters needed.

The procedure is general enough to cope with installation on most standalone
and turnkey LAMPS systems. It should be noted however, that on complex
pre-existing sites, it may be necessary for the system manager to edit this
procedure to avoid conflicts with assumptions made by previously installed
software packages.

$! 
$       read/end=abort/prompt="OK to proceed [Y] ?  " sys$command yes
$	if yes.eqs."" then yes=1
$	if .not.yes then goto abort
$	if .not.everything then goto question
$!
$! ************************************************************************
$!
$! here to set up the standard LSL usernames.
$!
$usernames:
$	ws " "
$	ws "--------------------------------------------------------------"
$	ws "USERNAMES - Setting up standard LSL usernames."
$	ws "--------------------------------------------------------------"
$	ws " "
$	group100=f$identifier(%X0040FFFF,"number_to_name")
$	if group100.eqs."" then goto groupOK
$	if group100.eqs."LSL" then goto groupOK
$	ws " "
$	ws "%LSLINSTALL-F-GROUPNOTLSL, UIC group [100,*] is occupied by ",group100
$	ws "-LSLINSTALL-F-OTHERGROUP, Modify procedure to use group other than [100,*]"
$	ws " "
$	goto abort
$groupOK:
$	ws "The procedure will create the following standard usernames:"
$	ws "[100,2]   = [LSLSOFT]	! owner of LSL software
$	ws "[100,100] = [LSLUSER]	! template LSL user
$	ws "[100,101] = [LSLBIG]	! template large quota user
$	ws " "
$       read/end=abort/prompt="Proceed with this stage [Y] ?  " sys$command yes
$	if yes.eqs."" then yes=1
$	if .not.yes then goto roots
$	ws " "
$	ws "Creating user [LSLSOFT]"
$	ws " "
$	set default sys$system
$	run authorize
ADD/IDENT/VAL=UIC:[100,*] LSL
ADD LSLSOFT/UIC=[100,2]/ACCOUNT=LSL/PASSWORD=LSLSOFT/PWDEXPIRED
MOD LSLSOFT/OWNER="LSL Software"/FLAGS=NODISUSER
MOD LSLSOFT/DEVICE=LSL$SITE_ROOT:/DIRECTORY=[LSLSOFT]
MOD LSLSOFT/PRIVILEGES=(GROUP,TMPMBX,NETMBX)
MOD LSLSOFT/DEFPRI=(GROUP,TMPMBX,NETMBX)
$	set default 'savdef'
$	ws " "
$       read/end=abort/prompt="Press RETURN to continue  " sys$command yes
$	ws " "
$	ws "Creating user [LSLUSER]"
$	ws " "
$	set default sys$system
$	run authorize
COPY LSLSOFT LSLUSER/UIC=[100,100]/PASSWORD=LSLUSER/PWDEXPIRED
MOD LSLUSER/OWNER="LSL LAMPS user"/DIRECTORY=[LSLUSER]
MOD LSLUSER/DEVICE=LSL$USER_ROOT:
$	set default 'savdef'
$	ws " "
$       read/end=abort/prompt="Press RETURN to continue  " sys$command yes
$	ws " "
$	ws "Creating user [LSLBIG]"
$	ws " "
$	set default sys$system
$	run authorize
COPY LSLSOFT LSLBIG/UIC=[100,101]/PASSWORD=LSLBIG/PWDEXPIRED
MOD LSLBIG/OWNER="LSL LAMPS big user"/DIRECTORY=[LSLUSER]
MOD LSLBIG/DEVICE=LSL$USER_ROOT:
MOD LSLBIG/WSQUO=2048/WSEXT=8192/PGFLQUO=30000
$	set default 'savdef'
$	ws " "
$       read/end=abort/prompt="Press RETURN to continue  " sys$command yes
$	ws " "
$	set default sys$system
$	run authorize
SHOW [100,*]/BR
$	set default 'savdef'
$	ws " "
$       read/end=abort/prompt="Press RETURN to continue  " sys$command yes
$!
$	if .not.everything then goto question
$!
$! ************************************************************************
$!
$! here to set up the root level directory trees.
$!
$roots:
$	ws " "
$	ws "--------------------------------------------------------------"
$	ws "ROOTS - Setting up root level directory trees."
$	ws "--------------------------------------------------------------"
$	ws " "
$	ws "The procedure will create the following root level directories:"
$	ws " "
$	ws "LSL$PUBLIC_ROOT: -> [LSLPUBLIC...]	! LSL published software (read-only)"
$	ws "LSL$SITE_ROOT: ->   [LSLSITE...]	! LSL site-specific software"
$	ws "LSL$USER_ROOT: ->   [LSLUSER...]	! LSL users home directories"
$	ws "LSL$DATA_ROOT: ->   [LSLDATA...]	! LSL data directories"
$	ws "LSL$LOCAL_ROOT: ->  [LSLLOCAL...]	! LSL workspace directories"
$	ws " "
$       read/end=abort/prompt="Proceed with this stage [Y] ?  " sys$command yes
$	if yes.eqs."" then yes=1
$	if .not.yes then goto load
$	ws " "
$	ws "Disk devices available are:"
$	show device d
$do_public:
$	ws " "
$	ws "Firstly select a disk for the LSL standard software files."
$	ws "This will have the following directories:"
$	ws "LSL$PUBLIC_ROOT: -> [LSLPUBLIC...]	! LSL published software (read-only)"
$	ws " "
$	device=f$trnlnm("sys$sysdevice")
$       read/end=abort/prompt="What device for public tree [default is ''device'] ?  " -
		sys$command device
$	rootname="PUBLIC"
$	group_prot="G:RE"
$	gosub create_directory
$	dev_public=device
$	if .not.created_ok then goto do_public
$do_site:
$	ws " "
$	ws "Now select a disk for the LSL site-specific files."
$	ws "This will have the following directories:"
$	ws "LSL$SITE_ROOT: ->   [LSLSITE...]	! site-specific software "
$	ws " "
$	device=f$trnlnm("sys$sysdevice")
$       read/end=abort/prompt="What device for site tree [default is ''device'] ?  " -
		sys$command device
$	rootname="SITE"
$	group_prot="G:RWE"
$	gosub create_directory
$	dev_site=device
$	if .not.created_ok then goto do_site
$do_user:
$	set on
$	ws " "
$	ws "Now select a disk for the LSL users home directories."
$	ws "This will have the following directories:"
$	ws "LSL$USER_ROOT: -> [LSLUSER...]	! LSL users home directories"
$	ws " "
$       read/end=abort/prompt="What device for user tree [default is ''device'] ?  " -
		sys$command device
$	rootname="USER"
$	group_prot="G:RWE"
$	gosub create_directory
$	dev_user=device
$	if .not.created_ok then goto do_user
$!
$do_data:
$	set on
$	ws " "
$	ws "Now select a disk for the LSL data directories."
$	ws "This will have the following directories:"
$	ws "LSL$DATA_ROOT: -> [LSLDATA...]	! LSL data directories"
$	ws " "
$       read/end=abort/prompt="What device for data tree [default is ''device'] ?  " -
		sys$command device
$	rootname="DATA"
$	group_prot="G:RWE"
$	gosub create_directory
$	dev_data=device
$	if .not.created_ok then goto do_data
$!
$do_local:
$	set on
$	ws " "
$	ws "Now select a disk for the LSL local workspace directories."
$	if cluster_member then -
	ws "Note that this should be a disk connected locally to this node."
$	ws "This will have the following directories:"
$	ws "LSL$LOCAL_ROOT: -> [LSLLOCAL...]	! LSL workspace directories"
$	ws " "
$       read/end=abort/prompt="What device for local tree [default is ''device'] ?  " -
		sys$command device
$	rootname="LOCAL"
$	group_prot="G:RWE"
$	gosub create_directory
$	dev_local=device
$	if .not.created_ok then goto do_local
$!
$! now record these definitions in a startup file
$!
$	ws " "
$	ws "Now creating site-specific definitions file LSDEFNS_ROOTS
$	ws " "
$	create sys$manager:lsdefns_roots.new	! so that it is standard text file format
$	open/append command sys$manager:lsdefns_roots.new
$!
$	ws "$! LSDEFNS_ROOTS.COM - define LSL root logical names."
$	wc "$! LSDEFNS_ROOTS.COM - define LSL root logical names."
$	ws "$!"
$	wc "$!"
$	ws "$! This file was generated by LSLINSTALL.COM, but can now be edited"
$	wc "$! This file was generated by LSLINSTALL.COM, but can now be edited"
$	ws "$!"
$	wc "$!"
$!
$	ws "$	DEFINE/SYSTEM/EXEC/TRANS=(CONCEALED,TERMINAL) LSL$PUBLIC_ROOT -"
$	ws "		''dev_public'[LSLPUBLIC.]"
$	wc "$	DEFINE/SYSTEM/EXEC/TRANS=(CONCEALED,TERMINAL) LSL$PUBLIC_ROOT -"
$	wc "		''dev_public'[LSLPUBLIC.]"
$	ws "$	DEFINE/SYSTEM/EXEC/TRANS=(CONCEALED,TERMINAL) LSL$SITE_ROOT 	-"
$	ws "		''dev_site'[LSLSITE.]"
$	wc "$	DEFINE/SYSTEM/EXEC/TRANS=(CONCEALED,TERMINAL) LSL$SITE_ROOT 	-"
$	wc "		''dev_site'[LSLSITE.]"
$	ws "$	DEFINE/SYSTEM/EXEC/TRANS=(CONCEALED,TERMINAL) LSL$DATA_ROOT 	-"
$	ws "		''dev_data'[LSLDATA.]"
$	wc "$	DEFINE/SYSTEM/EXEC/TRANS=(CONCEALED,TERMINAL) LSL$DATA_ROOT 	-"
$	wc "		''dev_data'[LSLDATA.]"
$	ws "$	DEFINE/SYSTEM/EXEC/TRANS=(CONCEALED,TERMINAL) LSL$USER_ROOT 	-"
$	ws "		''dev_user'[LSLUSER.]"
$	wc "$	DEFINE/SYSTEM/EXEC/TRANS=(CONCEALED,TERMINAL) LSL$USER_ROOT 	-"
$	wc "		''dev_user'[LSLUSER.]"
$	ws "$	DEFINE/SYSTEM/EXEC/TRANS=(CONCEALED,TERMINAL) LSL$LOCAL_ROOT 	-"
$	ws "		''dev_local'[LSLLOCAL.]"
$	wc "$	DEFINE/SYSTEM/EXEC/TRANS=(CONCEALED,TERMINAL) LSL$LOCAL_ROOT 	-"
$	wc "		''dev_local'[LSLLOCAL.]"
$	ws "$!"
$	wc "$!"
$	ws "$	EXIT"
$	wc "$	EXIT"
$!
$	close command
$	purge/noconfirm sys$manager:lsdefns_roots.new
$	rename/noconfirm sys$manager:lsdefns_roots.new -
			 sys$common:[sysmgr]lsdefns_roots.com
$!
$	ws " "
$       read/end=abort/prompt="Press RETURN to continue  " sys$command yes
$	if .not.everything then goto question
$!
$! ************************************************************************
$!
$! here to read a software issue 
$!
$load:
$	ws " "
$	ws "--------------------------------------------------------------"
$	ws "LOAD - Load savesets from distribution medium"
$	ws "--------------------------------------------------------------"
$	ws " "
$       read/end=abort/prompt="Proceed with this stage [Y] ?  " sys$command yes
$	if yes.eqs."" then yes=1
$	if .not.yes then goto directories
$	tape_device=0
$	tape_mounted=0
$	ws " "
$!
$! get tape devices available
$!
$get_dest:
$	default_device="*UNKNOWN*"
$	ws " "
$	ws "The following magtape devices are available on this CPU (",f$getsyi("NODENAME"),")"
$	ws " "
$	define/user sys$output sys$scratch:lslinstall_tapes.tmp
$	show device m
$	open/error=enddevlst lslinstall_tapes_tmp sys$scratch:lslinstall_tapes.tmp
$nextdev:
$	read/end_of_file=enddevlst/error=enddevlst lslinstall_tapes_tmp line
$	if f$loc(":",line) .eq. f$len(line) then goto nextdev
$	if .not. f$getdvi(f$elem(0,":",line),"EXISTS") then goto nextdev
$	device = f$getdvi(f$elem(0,":",line),"FULLDEVNAM")
$	if f$getdvi(device,"DEVCLASS") .ne. 2 then goto nextdev
$	devtype=f$getdvi(device,"MEDIA_NAME")
$	devtype_explain="(Unknown type)"
$	if devtype.eqs."TK50" then devtype_explain="(95MB Cartridge tape)"
$	if devtype.eqs."TZ30" then devtype_explain="(95MB Cartridge tape)"
$	if devtype.eqs."TK70" then devtype_explain="(296MB Cartridge tape)"
$	if devtype.eqs."TU81" then devtype_explain="(Half inch magtape)"
$	if devtype.eqs."TU78" then devtype_explain="(Half inch magtape)"
$	if devtype.eqs."TE16" then devtype_explain="(Half inch magtape)"
$	if devtype.eqs."TS11" then devtype_explain="(Half inch magtape)"
$	if devtype.eqs."TLZ04" then devtype_explain="(1.2GB DAT tape)"
$	if devtype.eqs."TLZ06" then devtype_explain="(4GB DAT tape)"
$	if devtype.eqs."TKZ08" then devtype_explain="(Exabyte tape)"
$	if devtype.eqs."MKX00" then devtype_explain="(SCSI tape)"
$	device=device-"_"
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
$	default_device=device
$	goto nextdev
$enddevlst:
$	close /nolog lslinstall_tapes_tmp
$	if f$search("sys$scratch:lslinstall_tapes.tmp;*") .nes. "" then -
	   delete sys$scratch:lslinstall_tapes.tmp;*
$!
$! ------------------------------------------------------------------
$!
$! got a tape device to offer them, get definite source
$!
$	ws " "
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
$	ws "%LSLINSTALL-W-NOSUCHDEV, Device ",source," is not available"
$	goto get_dest
$got_name:
$	ws "%LSLINSTALL-W-NOCOLON, source ",source," has unexpected filename"
$	ws "%LSLINSTALL-I-HINT, Device names must end in colon, filenames not allowed"
$	goto get_dest
$!
$! ------------------------------------------------------------------
$!
$! here with a tape device - get characteristics.
$!
$tape_device:
$	set on
$	tape_device=1
$	rewindsw="/REWIND"
$	ws "Tape device ",source," will now be mounted"
$       read/end=abort/prompt="Press RETURN to continue  " sys$command yes
$	set noon
$	mount 'source'/foreign
$	if .not.$status then goto tape_device
$	set on
$	tape_mounted=1
$	default_action="[default is first on tape]"
$	load_all=1
$	ws " "
$	ws "Laser-Scan strongly recommend that the whole of any installation kit is applied."
$       read/end=done2/prompt="Do you want to select only part of this kit [default N] ?  " -
		sys$command yes
$	if yes then load_all=0
$	if load_all then package="*"
$	goto all_devices
$!
$! ------------------------------------------------------------------
$!
$! here with not a tape device
$!
$not_tape:
$	ws "Device ",source," is not a tape. Assumed file structured."
$	rewindsw=""
$	default_action=""
$	load_all=0
$!
$! ------------------------------------------------------------------
$!
$! here to get rest of characteristics for all source devices.
$!
$all_devices:
$	ws " "
$	ws "Now select any special options for the loading:"
$	ws "  /VERIFY will carry out an extra BACKUP verification pass for each saveset."
$	ws "  /LIST will produce a BACKUP listing for each saveset and file loaded."
$	ws "  /LOG will produce a BACKUP log line for each file loaded.
$	ws "The defaults are usually adequate for a normal installation."
$	ws " "
$	verifysw="/NOVERIFY"
$       read/end=done2/prompt="/VERIFY [default N] ?  " -
		sys$command yes
$	if yes then verifysw="/VERIFY"
$	listsw=""
$       read/end=done2/prompt="/LIST [default N] ?  " -
		sys$command yes
$	if yes then listsw="/LIST"
$	logsw="/NOLOG"
$	if yes then goto nolog
$       read/end=done2/prompt="/LOG [default N] ?  " -
		sys$command yes
$	if yes then logsw="/LOG"
$nolog:
$	miscsw=verifysw+logsw+listsw
$	ws " "
$!
$! ------------------------------------------------------------------
$!
$! almost ready to go - set up prompts etc
$!
$	to_root="LSL$PUBLIC_ROOT:"
$	if load_all 
$	then 
$	   ws "Starting load now - this may take several minutes."
$	   goto load_it
$	endif
$!
$	first_next="First"
$	ws "Use CTRL/Z to saveset name prompt to end LOAD phase"
$!
$next_saveset:
$       read/end=done2/prompt="''first_next' saveset name ? ''default_action' " -
		sys$command package
$!
$! ------------------------------------------------------------------
$!
$! here to backup one or more savesets
$!
$load_it:
$	set noon
$	backup 'source''package''rewindsw'/save -
		'to_root'[*...]/owner=[LSLSOFT]'miscsw'
$	set on
$	if load_all then goto done2
$	if tape_device then rewindsw="/NOREWIND"
$	first_next="Next"
$	if tape_device then default_action="[default is next on tape]"
$	goto next_saveset
$!
$! ------------------------------------------------------------------
$!
$! here at end of tape or CTRL/Z
$!
$done2:
$	if load_all then ws "Load complete"
$	if tape_mounted then dismount 'source'/nounload
$	tape_mounted=0
$!
$! ------------------------------------------------------------------
$!
$! now set the protections on everything on public_root
$!
$	ws " "
$	ws "Now setting protections on all files on LSL$PUBLIC_ROOT:"
$	ws " "
$	set file lsl$public_root:[*...]*.*/prot=(sy:rwed,ow:rwed,gr:re,wo)
$	set file lsl$public_root:[000000...]*.DIR/prot=(sy:rwe,ow:rwe,gr:re,wo)
$	purge/nolog/noconf lsl$public_root:[*...]
$	ws " "
$       read/end=abort/prompt="Press RETURN to continue  " sys$command yes
$	if .not.everything then goto question
$!
$! ************************************************************************
$!
$! here to set up the standard directories
$!
$directories:
$	ws " "
$	ws "--------------------------------------------------------------"
$	ws "DIRECTORIES - Set up standard site_dependent directories"
$	ws "--------------------------------------------------------------"
$	ws " "
$       read/end=abort/prompt="Proceed with this stage [Y] ?  " sys$command yes
$	if yes.eqs."" then yes=1
$	if .not.yes then goto files
$	set noon
$	create/dir/log lsl$site_root:[lsl.com]/prot=(gr:rwe)
$	create/dir/log lsl$site_root:[lsl.exe]/prot=(gr:rwe)
$	create/dir/log lsl$site_root:[lsl.lib]/prot=(gr:rwe)
$	create/dir/log lsl$site_root:[lsl.help]/prot=(gr:rwe)
$	create/dir/log lsl$site_root:[lsl.lookup]/prot=(gr:rwe)
$	create/dir/log lsl$site_root:[lsl.frt]/prot=(gr:rwe)
$	create/dir/log lsl$site_root:[lsl.uil]/prot=(gr:rwe)
$	create/dir/log lsl$site_root:[lsl.uid]/prot=(gr:rwe)
$	create/dir/log lsl$site_root:[lsl.cdl]/prot=(gr:rwe)
$	create/dir/log lsl$site_root:[lsl.fpp]/prot=(gr:rwe)
$	create/dir/log lsl$site_root:[lsl.mgmt]/prot=(gr:rwe)
$	create/dir/log lsl$site_root:[lslsoft]/prot=(gr:rwe)
$	create/dir/log lsl$site_root:[lites2.cmd]/prot=(gr:rwe)
$	create/dir/log lsl$user_root:[lsluser]/prot=(gr:rwe)
$	create/dir/log lsl$data_root:[lsl.iff]/prot=(gr:rwe)
$	create/dir/log lsl$data_root:[lsl.dti]/prot=(gr:rwe)
$	create/dir/log lsl$local_root:[lites2.work]/prot=(gr:rwe)
$	create/dir/log lsl$local_root:[lites2.jnl]/prot=(gr:rwe)
$	set directory/version=3/log lsl$local_root:[lites2.jnl]
$	set on
$	ws " "
$       read/end=abort/prompt="Press RETURN to continue  " sys$command yes
$	if .not.everything then goto question
$!
$! ************************************************************************
$!
$! here to copy the startup files
$!
$files:
$	ws " "
$	ws "--------------------------------------------------------------"
$	ws "FILES - Copy the startup files to SYS$MANAGER:
$	ws "--------------------------------------------------------------"
$	ws " "
$	ws "This will copy the template LS*.com startup files from the newly
$	ws "loaded public tree, and also any package-specific startup files."
$	ws " "
$       read/end=abort/prompt="Proceed with this stage [Y] ?  " sys$command yes
$	if yes.eqs."" then yes=1
$	if .not.yes then goto searchlists
$!
$	name=""
$	ws " "
$	ws "Copying the following startup template files to SYS$COMMON:[SYSMGR]:"
$nextfile:
$	filespec=f$search("lsl$public_root:[lslsystem.examples.startup]ls*.com")
$	if filespec.eqs."" then goto nofile
$	name=f$parse(filespec,,,"name")
$	if f$search("SYS$MANAGER:"+name+".COM",2) .nes.""
$	then
$	   if name.eqs."LSDEFNS_ROOTS" then goto nextfile
$	   ws "%LSLINSTALL-W-EXISTS, startup procedure ",name,".COM already exists"
$          read/end=abort/prompt="Overwrite it [N] ?  " sys$command yes
$	   if .not.yes then goto nextfile
$	endif
$	ws "	",NAME,".COM"
$	copy/nolog/noconf 'filespec' sys$common:[sysmgr]
$	goto nextfile
$nofile:
$	ws " "
$	if name.eqs."" 
$	then
$	   ws "%LSLINSTALL-F-NOTEMPLATES, No template startup procedures found"
$	   ws " "
$	   goto abort
$	endif
$!
$! set the protection on the system-wide login file so all can execute it
$!
$	set file sys$manager:lslogin.com/prot=w:re
$       read/end=abort/prompt="Press RETURN to continue  " sys$command yes
$!
$! and now the package-specific ones
$!
$	name=""
$	ws " "
$	ws "Copying the following package-specific startup files to SYS$COMMON:[SYSMGR]:"
$nextfile2:
$	filespec=f$search("lsl$com:lsstartup_*.com")
$	if filespec.eqs."" then goto nofile2
$	name=f$parse(filespec,,,"name")
$	if f$search("SYS$MANAGER:"+name+".COM",2) .nes.""
$	then
$	   ws "%LSLINSTALL-W-EXISTS, startup procedure ",name," already exists"
$          read/end=abort/prompt="Overwrite it [N] ?  " sys$command yes
$	   if .not.yes then goto nextfile2
$	endif
$	ws "	",NAME,".COM"
$	copy/nolog/noconf 'filespec' sys$common:[sysmgr]
$	goto nextfile2
$nofile2:
$	if name.eqs."" then ws "No package-specific startup procedures found"
$	ws " "
$       read/end=abort/prompt="Press RETURN to continue  " sys$command yes
$! 
$!------------------------------------------------------------------ 
$! 
$	ws " "
$	ws "Creating the login definitions files for LSLUSER and LSLSOFT"
$	ws " "
$	ws "Creating login.com for [LSLSOFT]"
$	copy/nolog/noconf -
		lsl$public_root:[lslsystem.examples.startup]login_lslsoft.com -
		lsl$site_root:[lslsoft]login.com
$	set file lsl$site_root:[lslsoft]login.com/owner=[LSLSOFT]
$	ws "Creating login.com for [LSLUSER]"
$	copy/nolog/noconf -
		lsl$public_root:[lslsystem.examples.startup]login_lsluser.com -
		lsl$user_root:[lsluser]login.com
$	set file lsl$user_root:[lsluser]login.com/owner=[LSLUSER]
$	ws " "
$       read/end=abort/prompt="Press RETURN to continue  " sys$command yes
$! 
$!------------------------------------------------------------------ 
$! 
$! now set up the customer name for licence purposes 
$! 
$	type sys$input 

Now you need to specify the Laser-Scan short name for your site, which will be
used for software licensing purposes.

It will usually be an acronym of the name of the organisation, eg LSLCAM. If
you do not know the name that LSL have given your site, either deduce it from
the following list of available licences, or telephone the Customer Services
department at LSL Cambridge.

If you are not able to specify a valid name, then give a value of "UNKNOWN",
and edit the correct value later into the file which will now be created called
SYS$MANAGER:LSDEFNS_SITE.COM. If you do this, then you will not be able to run
full LAMPS software until the correct name and/or licence files are supplied.

$       read/end=abort/prompt="Press RETURN to continue  " sys$command yes
$	name=""
$	ws " "
$	ws "Licences are available for the following customers:"
$nextlic:
$	filespec=f$search("LSL$PUBLIC_ROOT:[LITES2.EXE]*.LIC")
$	if filespec.eqs."" then goto nolic
$	name=f$parse(filespec,,,"name")
$	ws "	",NAME
$	goto nextlic
$nolic:
$	ws " "
$	if name.eqs."" then name="UNKNOWN"
$       read/end=abort/prompt="What is your customer name [default is ''name'] ?  " -
		sys$command custnam
$	if custnam.eqs."" then custnam=name
$!
$! now record the customer name in a startup file
$!
$	ws " "
$	ws "Now creating site-specific definitions file LSDEFNS_SITE
$	ws " "
$	create sys$manager:lsdefns_site.new	! so that it is standard text file format
$	open/append command sys$manager:lsdefns_site.new
$!
$	ws "$! LSDEFNS_SITE.COM - define LSL site-specific logical names."
$	wc "$! LSDEFNS_SITE.COM - define LSL site-specific logical names."
$	ws "$!"
$	wc "$!"
$	ws "$! This file was generated by LSLINSTALL.COM, but can now be edited"
$	wc "$! This file was generated by LSLINSTALL.COM, but can now be edited"
$	ws "$!"
$	wc "$!"
$	ws "$! Firstly a customer name, to be used for software licences"
$	wc "$! Firstly a customer name, to be used for software licences"
$	ws "$!"
$	wc "$!"
$	ws "$	DEFINE/SYSTEM	LSL$CUSTOMER_NAME		''custnam'"
$	wc "$	DEFINE/SYSTEM	LSL$CUSTOMER_NAME		''custnam'"
$	ws "$!"
$	wc "$!"
$	ws "$	EXIT"
$	wc "$	EXIT"
$!
$	close command
$	purge/noconfirm sys$manager:lsdefns_site.new
$	rename/noconfirm sys$manager:lsdefns_site.new -
			 sys$common:[sysmgr]lsdefns_site.com
$	@sys$common:[sysmgr]lsdefns_site.com
$	ws " "
$       read/end=abort/prompt="Press RETURN to continue  " sys$command yes
$	if .not.everything then goto question
$!
$! ************************************************************************
$!
$! here to set up the search lists
$!
$searchlists:
$	ws " "
$	ws "--------------------------------------------------------------"
$	ws "SEARCHLISTS - Set up search lists for LSL$EXE etc"
$	ws "--------------------------------------------------------------"
$	ws " "
$       read/end=abort/prompt="Proceed with this stage [Y] ?  " sys$command yes
$	if yes.eqs."" then yes=1
$	if .not.yes then goto options
$	ws " "
$	ws "Now creating site-specific searchlists file LSDEFNS_SEARCHLISTS"
$	ws " "
$	@lsl$public_root:[lslsystem.com]lslsearchlists_generate.com
$	ws " "
$	@sys$manager:lsdefns_searchlists
$	ws " "
$       read/end=abort/prompt="Press RETURN to continue  " sys$command yes
$	if .not.everything then goto question
$!
$! ************************************************************************
$!
$! here to set the environment for software options
$!
$options:
$	ws " "
$	ws "--------------------------------------------------------------"
$	ws "OPTIONS - set up environment for optional software
$	ws "--------------------------------------------------------------"
$	ws " "
$       read/end=abort/prompt="Proceed with this stage [Y] ?  " sys$command yes
$	if yes.eqs."" then yes=1
$	if .not.yes then goto tune
$	gosub check_options
$	if .not.do_vtrak then goto no_vtrak_user
$	filespec=f$search("lsl$public_root:[vtrak.com]lslinstall_vtrak.com")
$	if filespec.nes."" then goto no_vtrak_user
$	ws " "
$	ws "The procedure will create the following captive usernames:"
$	ws "[100,1]   = [VTRAK]  	! VTRAK captive user
$	ws " "
$	ws "Creating user [VTRAK]"
$	ws " "
$	set default sys$system
$	run authorize
COP LSLUSER VTRAK/UIC=[100,1]/PASSWORD=VTRAK/PWDEXPIRED
MOD VTRAK/OWNER="LSL VTRAK user"/DIRECTORY=[VTRAK]
MOD VTRAK/WSDEF=1536/WSQUO=12288/WSEXT=30000/PGFLQUO=100000
MOD VTRAK/FILLM=30/BYTLM=25000/PRIV=GRPNAM/DEFPRV=GRPNAM
SHOW VTRAK/BRIEF
$	set default 'savdef'
$	ws " "
$       read/end=abort/prompt="Press RETURN to continue  " sys$command yes
$no_vtrak_user:
$!
$! and now for a possible OPER user
$!
$	type sys$input

The LAMPS environment contains an optional privileged user called [OPER],
which is supplied with a template captive command procedure for carrying 
out useful VMS operator functions such as disk archiving, queue management,
system shutdown, etc.

This functionality is particularly useful for small LAMPS turnkey systems,
which are not run as general-purpose timesharing systems, and hence do not 
have full-time system management and systems operations personnel.

Larger systems with many layered products installed will usually already 
have operator accounts, and so will not want to include the LSL offering.

$       read/end=abort/prompt=-
	   "Do you want to create a privileged operator [OPER] user [Y] ?  " -
	   sys$command yes
$	if yes.eqs."" then yes=1
$	if .not.yes then goto no_oper_user
$	ws " "
$	ws "Creating user [OPER]"
$	ws " "
$	set default sys$system
$	run authorize
COP LSLSOFT OPER/UIC=[1,377]/PASSWORD=OPER/PWDEXPIRED
MOD OPER/OWNER="SYSTEM OPERATOR"/ACCOUNT=OPERATOR
MOD OPER/DEVICE=SYS$SYSDEVICE:/DIRECTORY=[OPER]
MOD OPER/LGICMD=SYS$SYSDEVICE:[OPER]OPER
MOD OPER/FLAGS=(CAPTIVE,DISWELCOME,DISNEWMAIL,DISMAIL,DISREPORT)
MOD OPER/PRIVILEGES=(SETPRV,TMPMBX,NETMBX)
MOD OPER/DEFPRI=(SYSNAM,GRPNAM,GROUP,ALTPRI,TMPMBX,WORLD,OPER,NETMBX)
MOD OPER/DEFPRI=(VOLPRO,PHY_IO,MOUNT,SYSPRV)
SHOW OPER/BRIEF
$	set default 'savdef'
$	ws " "
$	create/dir sys$sysdevice:[oper]/owner=[OPER]
$	backup lsl$public_root:[lslsystem.oper]*.* -
		sys$sysdevice:[oper]/owner=[OPER]
$	set file sys$sysdevice:[oper]*.*/prot=(sy:rwed,ow:rwed,gr,wo)
$	ws " "
$       read/end=abort/prompt="Press RETURN to continue  " sys$command yes
$	ws " "
$no_oper_user:
$!
$!
$! ------------------------------------------------------------------
$!
$! here to call any package installation procedures
$!
$	count=0
$nextini:
$	filespec=f$search("lsl$com:lslinstall_*.com")
$	if filespec.nes."" 
$	then
$	   count=count+1
$	   ws "Calling package-specific installation file ",filespec
$	   @'filespec'
$	   ws " "
$          read/end=abort/prompt="Press RETURN to continue  " sys$command yes
$	   ws " "
$	   goto nextini
$	endif
$	if count.eq.0 then ws "No package-specific installation procedures found"
$	ws " "
$       read/end=abort/prompt="Press RETURN to continue  " sys$command yes
$	if .not.everything then goto question
$!
$! ************************************************************************
$!
$! here to give advice about SYSGEN parameters
$!
$tune:
$	ws " "
$	ws "--------------------------------------------------------------"
$	ws "TUNE - Evaluate SYSGEN parameters."
$	ws "--------------------------------------------------------------"
$	ws " "
$       read/end=abort/prompt="Proceed with this stage [Y] ?  " sys$command yes
$	if yes.eqs."" then yes=1
$	if .not.yes then goto done
$	ws " "
$	ws "Now checking SYSGEN parameters"
$	ws " "
$	gosub check_options
$	change_param=0		! no parameters to change yet
$	create sys$system:lslinstall_modparams.dat	! so that it is standard text file format
$	open/append command sys$system:lslinstall_modparams.dat
$	wc "! LSLINSTALL_MODPARAMS.DAT - LSL suggested parameter changes"
$	wc "!"
$!
$	parameter="VIRTUALPAGECNT"
$	suggestion=20000
$	if do_structure then suggestion=40000
$	if do_matrix then suggestion=60000
$	if do_vtrak then suggestion=300000
$	gosub suggest_param
$!
$	parameter="WSMAX"
$	suggestion=1024
$	if do_structure then suggestion=4096
$	if do_matrix then suggestion=8192
$	if do_vtrak then suggestion=16384
$	gosub suggest_param
$!
$	ws " "
$	close command
$	purge/noconfirm sys$system:lslinstall_modparams.dat
$	ws " "
$	if change_param
$	then
$	   read/end=abort/prompt="Press RETURN to continue  " sys$command yes
$	   type sys$input

WARNING - Your current SYSGEN parameters are probably low.

You should note the values which were recommended above and which have been
stored for you in the file SYS$SYSTEM:LSLINSTALL_MODPARAMS.DAT. Consider
whether they are indeed suitable for your hardware and software configuration.
When satisfied, edit the values into the MODPARAMS.DAT file in SYS$SYSTEM:,
then run the DEC-supplied AUTOGEN procedure, then reboot the system. 

Look up AUTOGEN in the VMS System Management manuals if you are not familiar
with changing SYSGEN parameters using AUTOGEN and the MODPARAMS.DAT file. 

You should do this as soon as this LSLINSTALL procedure finishes, before
logging off as SYSTEM.

$	else
$	   ws "Your current SYSGEN parameters seem adequate."
$	endif
$	ws " "
$       read/end=abort/prompt="Press RETURN to continue  " sys$command yes
$	ws " "
$	if .not.everything then goto question
$	goto done
$!
$! ************************************************************************
$! ***				SUBROUTINES				***
$! ************************************************************************
$!
$!
$! subroutine to create a root level directory
$!
$create_directory:
$	created_ok=0	! assume failure
$	device=f$edit(device,"upcase,collapse")
$	if device.eqs."" then device=f$trnlnm("sys$sysdevice")
$	exists=f$getdvi(device,"exists")
$	if .not.exists 
$	then 
$	   ws "%LSLINSTALL-W-NOSUCHDEV, no such device as ",device
$	   return
$	endif
$	device=f$getdvi(device,"devnam")-"_"-"_"
$	create/dir 'device'[LSL'rootname']/owner=[LSLSOFT]/PROT=('group_prot')
$	if .not.$status 
$	then 
$	   ws "%LSLINSTALL-W-CREATEFAIL. Failed to create ''device'[LSL''rootname']"
$	   return
$	endif
$	define/system/exec/trans=(concealed,terminal) LSL$'rootname'_ROOT -
		'device'[LSL'rootname'.]"
$	show logical LSL$'rootname'_ROOT
$	set noon
$	create LSL$'rootname'_ROOT:[000000]test.tmp
$	if .not.$status 
$	then 
$	   ws "%LSLINSTALL-W-CREATEFAIL. failed to create file in LSL$''rootname'_ROOT:"
$	   set on
$	   return
$	else
$	   set on
$	   delete/noconfirm LSL$'rootname'_ROOT:[000000]test.tmp;*
$	endif
$	created_ok=1	! succeeded
$	return
$!
$! ************************************************************************
$! ************************************************************************
$!
$! subroutine to suggest value for SYSGEN parameter
$!
$suggest_param:
$	current=f$getsyi(parameter)
$	ws " "
$	ws "Current value of ",parameter," is ",current
$	ws "   LSL recommend at least ",suggestion
$	if suggestion.ge.current
$	then
$	   ws "   You should edit MODPARAMS.DAT and insert the line:
$	   ws "   MIN_''parameter'=''suggestion'	! Increase for LSL LAMPS"
$	   wc "MIN_''parameter'=''suggestion'	! Increase for LSL LAMPS"
$	   change_param=1
$	else
$	   ws "   Current value is probably adequate."
$	endif
$	return
$!
$! ************************************************************************
$! ************************************************************************
$!
$! subroutine to check for options
$!
$check_options:
$	do_vtrak=""
$	if f$search("LSL$PUBLIC_ROOT:[000000]VTRAK.DIR").nes."" then do_vtrak=1
$	do_structure=""
$	if f$search("LSL$PUBLIC_ROOT:[000000]STRUCTURE.DIR").nes."" then do_structure=1
$	do_polygons=""
$	if f$search("LSL$PUBLIC_ROOT:[000000]POLYGONS.DIR").nes."" then do_polygons=1
$	do_horizon=""
$	if f$search("LSL$PUBLIC_ROOT:[000000]HORIZON.DIR").nes."" then do_horizon=1
$	do_metropolis=""
$	if f$search("LSL$PUBLIC_ROOT:[000000]METROPOLIS.DIR").nes."" then do_metropolis=1
$	do_matrix=""
$	if f$search("LSL$PUBLIC_ROOT:[000000]MATRIX.DIR").nes."" then do_matrix=1
$	return
$!
$! ************************************************************************
$! ************************************************************************
$!
$! here for normal exit
$!
$done:
$	type sys$input

The LSLINSTALL stage of LSL LAMPS software installation is now complete.

If the TUNE stage above suggested changes to MODPARAMS.DAT, do that now.

$	ws "LSLINSTALL terminating sucessfully"
$	goto exit
$!
$! ************************************************************************
$!
$! here for abnormal exits
$!
$abort:
$	ws "%LSLINSTALL-W-ABORT. Procedure terminated abnormally"
$!
$! ************************************************************************
$!
$! all done
$!
$exit:
$	set noverify
$	if tape_mounted then dismount 'source'/nounload
$	set default 'savdef'
$	set prot=('savprot')/default
$	exit
