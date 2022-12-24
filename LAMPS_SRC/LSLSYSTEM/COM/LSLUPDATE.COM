$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-03-31 17:46:46.000000000 +0100
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
$! LSLUPDATE.COM - procedure for automating LAMPS software updates
$!
$!	Created						PGH 30-Mar-1987 (V1.0)
$!MOD	Remove /NOLIST as VMS V5 doesnt like it!	PGH 03-Oct-1988 (V1.1)
$!MOD	allow wildcards in LOAD phase			PGH 20-Apr-1989 (V1.2)
$!MOD	allow pVAX SCSI magtapes			PGH 16-Oct-1989 (V1.3)
$!MOD   use * not *.* in magtape saveset name (SPR1172) PGH 24-Jun-1991 (V1.4)
$!MOD	Check LSL$SITE_ROOT directories for copies	PGH 30-Mar-1992 (V2.0)
$!MOD	Invoke newly loaded LSLUPDATE procedure if one	PGH 30-Mar-1992 (V2.0)
$!MOD	Invoke any LSLUPDATE_PREMERGE_* procedures 	PGH 30-Mar-1992 (V2.0)
$!
$	on control_C then goto emergency
$	on error then goto emergency
$	on warning then goto emergency
$	ws="write sys$output"
$	tape_mounted=0
$!
$! ************************************************************************
$!
$! get a command
$!
$Panic:
$       ws -
"LSL LAMPS software update procedure V2.0. Try HELP if needed."
$	ws " "
$	ws "Usual sequence is PREPARE, LOAD, [DIRECTORY], CHECK, MERGE, TIDY"
$	ws " "
$ question:
$       read/end=exit/prompt="LSLUPDATE>" sys$command P1
$	p1=f$edit(p1,"upcase,collapse")
$       if p1 .eqs."" then goto panic
$	clen=f$length(p1)
$	if p1.eqs."?" then goto help
$	if p1.eqs.f$extract(0,clen,"HELP") then goto help
$       if p1.eqs.f$extract(0,clen,"PREPARE") then goto prepare
$       if p1.eqs.f$extract(0,clen,"LOAD") then goto load
$       if p1.eqs.f$extract(0,clen,"DIRECTORY") then goto directory
$       if p1.eqs.f$extract(0,clen,"CHECK") then goto check
$       if p1.eqs.f$extract(0,clen,"MERGE") then goto merge
$       if p1.eqs.f$extract(0,clen,"TIDY") then goto tidy
$	ws "%LSLUPDATE-W-UNKNCMD, unknown command"
$	ws "\''p1'\"
$	goto question
$!
$! ************************************************************************
$!
$! here to give help
$!
$help:
$	type sys$input

This procedure is intended to automate the tasks involved in reading a
LSL software update from the distribution medium (eg magtape), and putting
the various software components in the correct places on the public tree.

Commands available in normal order of use are:

HELP	   - Type this message.
PREPARE	   - Prepare update directory tree and set up rooted logical name.
	     This command must be given before LOAD, MERGE, or TIDY.
	     It will check for and delete any existing temporary files from a
	     previous failed update. 
LOAD	   - Load software update BACKUP savesets onto temporary tree.
	     It will prompt for information about the distribution medium.
DIRECTORY  - Give a directory listing of the update files. 
	     This is useful to see what files have changed as part of an
	     incremental update. 
CHECK	   - Check for conflicts between updated files and any copies of
	     existing files in the site-specific directories on LSL$SITE_ROOT:.
	     This command will report any existing files in these directories
	     which have the same name as newly supplied updated files.
MERGE	   - Merge updated files onto main public tree.
	     This will put the new files into use. However see TIDY option 
	     for information on shared images.
             Before doing the actual merge, it will invoke any package-specific
             update files supplied as part of the update.
TIDY	   - Tidy up after update, eg by purging public tree.
	     Note that if any LSL images or shared libraries have been
	     installed using the DEC INSTALL utility, INSTALL/REPLACE
	     should be used or the system rebooted first before TIDYing
	     to ensure that they are no longer active. See bootstrap
	     file SYS$MANAGER:LSIMAGES.COM for a list of LSL installed images.
		  
$	goto question
$!
$! ************************************************************************
$!
$! here to do the preparation before an update is read
$!
$prepare:
$	ws "Prepare stage - checking for requisite resources"
$       username=f$edit(f$getjpi("","username"),"collapse")
$	if username.nes."LSLSOFT" then goto not_lslsoft
$	ws "Set up rooted logical name for temporary update directory tree."
$	pubspec=f$trnlnm("LSL$PUBLIC_ROOT")
$	updspec=pubspec-"]"+"UPDATE.]"
$	Define/trans=(concealed,terminal) lsl$update_root	'updspec' 
$	show logical lsl$update_root
$	set noon
$	create/dir/log lsl$update_root:[000000]
$	if .not.$status then goto update_duff
$	create lsl$update_root:[000000]test.tmp
$	if .not.$status then goto update_duff
$	delete/noconfirm lsl$update_root:[000000]test.tmp;*
$	set on
$	existing=f$search("lsl$update_root:[000000...]*.*")
$	reset=f$search("")
$	if existing.eqs."" then goto credir_done	! normal exit
$!
$! ************************************************************************
$!
$! here with old stuff on update tree to clear up
$!
$	ws "There are already some files on LSL$UPDATE_ROOT:"
$       read/end=question/prompt="Do you want a directory listing of them [default N] ?  " -
		sys$command yes
$	yes=f$edit(yes,"upcase,collapse")
$	if yes then directory/date/size lsl$update_root:[000000...]
$       read/end=question/prompt="Can these be deleted now [default N] ?  " -
		sys$command yes
$	yes=f$edit(yes,"upcase,collapse")
$	if .not.yes then goto credir_done
$	gosub delete_update
$credir_done:
$	ws "PREPARE option complete"
$	goto question
$!
$! ************************************************************************
$!
$! subroutine to delete stuff on update tree
$!
$delete_update:
$	ws "Please ignore any ""Directory not empty"" messages"
$	set file/prot=(ow:rwed) lsl$update_root:[000000...]*.*;*
$	this_pass=1
$more_existing:
$	set noon
$	if this_pass.lt.5 then set message/nofacility/noident/noseverity/notext
$	delete/noconfirm lsl$update_root:[000000...]*.*;*
$	set message/facility/ident/severity/text
$	set on
$	existing=f$search("lsl$update_root:[000000...]*.*")
$	reset=f$search("")
$	if existing.eqs."" then goto delete_done	! normal exit
$	this_pass=this_pass+1
$	goto more_existing
$delete_done:
$	return
$!
$! ************************************************************************
$!
$! here to read a software update
$!
$load:
$	ws "Load savesets from distribution medium"
$	updtrn=f$trnlnm("lsl$update_root")
$	if updtrn.eqs."" then goto not_prepared
$	tape_device=0
$	tape_mounted=0
$	default_device="*UNKNOWN*"
$	device="MSA0:"
$	gosub check_device
$	if devtype.nes."" then default_device=device
$	device="MTA0:"
$	gosub check_device
$	if devtype.nes."" then default_device=device
$	device="MUA0:"
$	gosub check_device
$	if devtype.nes."" then default_device=device
$	device="MKA500:"
$	gosub check_device
$	if devtype.nes."" then default_device=device
$	device="MKB500:"
$	gosub check_device
$	if devtype.nes."" then default_device=device
$       read/end=question/prompt="Where should update savesets be read from [default is ''default_device'] ?  " -
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
$!
$! ************************************************************************
$!
$! error cases
$!
$no_such:
$	WS "%LSLUPDATE-W-NOSUCHDEV, device ",source," is not available"
$	goto load
$got_name:
$	WS "%LSLUPDATE-W-NOCOLON, source ",source," has unexpected filename"
$	WS "%LSLUPDATE-I-HINT, device names must end in colon, filenames not allowed."
$	goto load
$!
$! ************************************************************************
$!
$! here with a tape device - get characteristics.
$!
$tape_device:
$	set on
$	tape_device=1
$	rewindsw="/REWIND"
$	WS "Tape device ",source," will now be mounted"
$       read/end=question/prompt="Hit RETURN when ready " -
		sys$command yes
$	set noon
$	mount 'source'/foreign
$	if .not.$status then goto tape_device
$	set on
$	tape_mounted=1
$	default_action="[default is first on tape]"
$	load_all=1
$	WS "Laser-Scan strongly recommend that the whole of any update is applied."
$       read/end=done2/prompt="Do you want to select only part of this update [default N] ?  " -
		sys$command yes
$	if yes then load_all=0
$	if load_all then package="*"
$	goto all_devices
$!
$! ************************************************************************
$!
$! here with not a tape device
$!
$not_tape:
$	WS "Device ",source," is not a tape. Assumed file structured."
$	rewindsw=""
$	default_action=""
$	load_all=0
$!
$! ************************************************************************
$!
$! here to get rest of characteristics for all source devices.
$!
$all_devices:
$	WS " "
$	WS "Now select any special options for the loading:"
$	WS "  /VERIFY will carry out an extra BACKUP verification pass for each saveset."
$	WS "  /LIST will produce a BACKUP listing for each saveset and file loaded."
$	WS "  /LOG will produce a BACKUP log line for each file loaded.
$	WS "The defaults are usually adequate for a normal incremental update."
$	WS " "
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
$!
$	to_root="LSL$UPDATE_ROOT:"
$	if load_all then goto load_it
$	first_next="First"
$	ws "Use CTRL/Z to saveset name prompt to return to LSLUPDATE> prompt"
$!
$! ************************************************************************
$!
$next_saveset:
$       read/end=done2/prompt="''first_next' saveset name ? ''default_action' " -
		sys$command package
$!
$! ************************************************************************
$!
$load_it:
$	set noon
$	backup 'source''package''rewindsw'/save 'to_root'[*...]'miscsw'
$	set on
$	if load_all then goto done2
$	if tape_device then rewindsw="/NOREWIND"
$	first_next="Next"
$	if tape_device then default_action="[default is next on tape]"
$	goto next_saveset
$!
$! ************************************************************************
$!
$done2:
$	if tape_mounted then dismount 'source'/nounload
$	tape_mounted=0
$	ws "LOAD option complete"
$	ws " "
$	ws "Checking newly loaded files for revised LSLUPDATE procedure"
$	new_lslupdate=f$search("LSL$UPDATE_ROOT:[LSLSYSTEM.COM]LSLUPDATE.COM")
$	if new_lslupdate.nes."" then goto new_lslupdate
$	ws "No revised LSLUPDATE procedure found, so continuing"
$	goto question
$new_lslupdate:
$	ws "New LSLUPDATE procedure found - transferring to it now"
$	ws " "
$	@LSL$UPDATE_ROOT:[LSLSYSTEM.COM]LSLUPDATE.COM
$	goto exit
$!
$! ************************************************************************
$!
$! here to give a directory listing of the update files
$!
$Directory:
$	ws "Directory listing of update files"
$	updtrn=f$trnlnm("lsl$update_root")
$	if updtrn.eqs."" then goto not_prepared
$	set noon
$	directory/date/size lsl$update_root:[*...]
$	set on
$	ws "DIRECTORY option complete"
$	goto question
$!
$! ************************************************************************
$!
$! here to check the new files for conflicts with site versions
$!
$Check:
$	ws "Check of updated files against site-specific versions"
$	updtrn=f$trnlnm("lsl$update_root")
$	if updtrn.eqs."" then goto not_prepared
$	set noon
$!
$! loop for each package
$!
$	total_site_found=0
$	crud=f$search("XXX.YYY",1)	! reset search context
$check_next_dir:
$	crud=f$search("XXX.YYY",2)	! reset search context
$	package_dir=f$search("LSL$UPDATE_root:[000000]*.DIR",1)
$	if package_dir.eqs."" then goto check_dirs_done	! normal exit
$	package_name=f$parse(package_dir,,,"name")
$	if package_name.eqs."HORIZON" then goto check_skip_package
$	if package_name.eqs."METROPOLIS" then goto check_skip_package
$	if package_name.eqs."XGIS" then goto check_skip_package
$	if package_name.eqs."MAPPER" then goto check_skip_package
$	if f$extract(0,5,package_name).eqs."$XGIS" then goto check_skip_package
$	ws " "
$	ws "Checking package ",package_name
$	previous_file_dir="#UNSET#"
$	goto check_next_file
$check_skip_package:
$	ws "Skipping package ",package_name," as checked later"
$	goto check_next_dir
$!
$! loop for each file within the package
$!
$check_next_file:
$	next_file=f$search("LSL$UPDATE_ROOT:[''package_name'.*]*.*",2)
$	if next_file.eqs."" then goto check_next_dir	! normal exit
$	file_type=f$parse(next_file,,,"type")
$	if file_type.eqs.".DIR" then goto check_next_file
$	file_dir=f$parse(next_file,,,"directory")
$	if file_dir.eqs.previous_file_dir then goto check_same_dir
$!
$! first file in this directory, so see where and if to check.
$! We search [LSL.xxx] (except .CMD is [LITES2.xxx]), and [package.XXX]
$!
$	previous_file_dir=file_dir
$	subdir=file_dir-"["-package_name-"."-"]"
$	prefix_1="[LSL."
$	if subdir.eqs."CMD" then prefix_1="[LITES2."
$	prefix_2="["+package_name+"."
$	site_dir_1=prefix_1+subdir+"]"
$	site_dir_2=prefix_2+subdir+"]"
$	exists=f$search("LSL$SITE_ROOT:["+package_name+"]"+subdir+".dir;1",3)
$	if exists.eqs."" then site_dir_2=""
$	if prefix_2.eqs.prefix_1 then site_dir_2=""
$	site_found=0
$!
$! actually check for file of same name
$!
$check_same_dir:
$	if site_dir_1.nes."" 
$	then 
$	  site_dir=site_dir_1
$	  gosub check_site_directory
$	endif
$	if site_dir_2.nes."" 
$	then 
$	  site_dir=site_dir_2
$	  gosub check_site_directory
$	endif
$	goto check_next_file
$!
$! checks complete
$!
$check_dirs_done:
$	set on
$	ws " "
$	if total_site_found.eq.0 then goto check_ok
$	ws -
"=============================================================================="
$	ws " "
$	ws total_site_found,-
" site-specific files were found during the check, for which new versions are"
$	Type sys$input:
supplied as part of this update.

You should review these site-specific versions (listed above), and determine
if they are still required. You can repeat this CHECK stage of LSLUPDATE as
needed until you are satisfied.

Examples of files for which site-specific versions may be required include
package initialisation command files such as LITES2INI.COM, and site_tailored
lookup files such as FRT files, LITES2 .CMD files, colour table files etc.

However, site-specific versions of program files (.EXE), and other command
files, are generally only required for short periods and may well be superceded 
by this update.

After careful consideration and possible consultation with Laser-Scan, these
unwanted site-specific versions should be deleted once the update is complete.

==============================================================================

$check_ok:
$	ws "CHECK option complete"
$	goto question
$!
$! ************************************************************************
$! Subroutines for check procedure
$!
$check_site_directory:
$	file_name=f$parse(next_file,,,"name")
$	site_spec="lsl$site_root:"+site_dir+file_name+file_type
$	exists=f$search(site_spec,3)
$	if exists.eqs."" then goto end_check_site_directory
$	site_found=site_found+1
$	total_site_found=total_site_found+1
$	if site_found.ne.1 then goto check_got_another
$	ws " "
$	ws "Site-specific version found while checking LSL$UPDATE_ROOT:",file_dir
$check_got_another:
$	exists_created=f$extract(0,11,f$file_attributes(exists,"CDT"))
$	ws "   LSL$SITE_ROOT:",site_dir,file_name,file_type," of ",exists_created
$	difference/output=nl: 'next_file' 'exists'
$	if $status.eqs."%X006C8009" then ws -
           "      (file contents are identical to new version)"
$end_check_site_directory:
$	return
$!
$! ************************************************************************
$!
$! Here to merge the software update with the existing public tree.
$! First check all is well, and invoke any package-specific update procedures
$!
$merge:
$	ws "Merge update files with existing public tree"
$	updtrn=f$trnlnm("lsl$update_root")
$	if updtrn.eqs."" then goto not_prepared
$	ws " "
$	ws -
"First we check the newly loaded files for package-specific LSLUPDATE procedures"
$	crud=f$search("xxx.yyy",1)	! reset search context
$next_premerge:
$	new_lslupdate=f$search("LSL$UPDATE_ROOT:[*.COM]LSLUPDATE_PREMERGE_*.COM",1)
$	if new_lslupdate.eqs."" then goto end_premerge
$	package_name=f$parse(new_lslupdate,,,"name")-"LSLUPDATE_PREMERGE_"
$	ws " "
$	ws "Package-specific LSLUPDATE procedure being invoked for package ",package_name
$	ws " "
$	@'new_lslupdate'
$	ws " "
$	ws "Returned to LSLUPDATE.COM"
$	goto next_premerge
$!
$end_premerge:
$	ws " "
$       read/end=abort/prompt="Press RETURN to continue with MERGE phase " sys$command yes
$!
$! ************************************************************************
$!
$	ws " "
$	ws "Now create any public tree directories necessary"
$next_dir:
$	this=f$search("lsl$update_root:[000000...]*.DIR",1)
$	if this.eqs."" then goto dirs_done		! normal exit
$	this_dir=f$parse(this,,,"directory")
$	this_name=f$parse(this,,,"name")
$	dir_spec="["+this_dir-"]"+"."+this_name+"]"-"[000000."
$	file_spec="lsl$public_root:"+this_dir+this_name+".DIR"
$	exists=f$search(file_spec,2)
$	if exists.nes."" then goto next_dir
$	create/dir/log lsl$public_root:'dir_spec'/prot=(g:re,w)
$	goto next_dir
$dirs_done:
$	ws " "
$	ws "Now purging update tree"
$	purge/log/noconfirm lsl$update_root:[*...]
$	ws "Now renaming all update files to the public tree"
$	rename/noconf/nolog/excl=*.dir lsl$update_root:[*...]*.* lsl$public_root:
$	ws "Now deleting remaining directories"
$	gosub delete_update
$	ws "MERGE option complete"
$	goto question
$!
$! ************************************************************************
$!
$! here to tidy up after an update
$!
$tidy:
$	ws "Tidy up after update"
$	updtrn=f$trnlnm("lsl$update_root")
$	if updtrn.eqs."" then goto not_prepared
$	ws "The following files have been replaced and may now be purged"
$	set noon
$	directory/date/size lsl$public_root:[*...]*.*;-1
$	set on
$	type sys$input:

Note that if any of those files are INSTALLed image files, you should either
reboot VMS, or use VMS INSTALL with /REPLACE option before this tidy operation.

$       read/end=question/prompt="Do you want to abandon this TIDY operation [default N] ?  " -
		sys$command yes
$	yes=f$edit(yes,"upcase,collapse")
$	if yes then goto tidy_abort
$	purge/noconfirm/log lsl$public_root:[*...]*.*
$tidy_done:
$	ws "TIDY option complete"
$	goto question
$tidy_abort:
$	ws "TIDY option aborted"
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
$!
$! ************************************************************************
$!
$! here for error cases
$!
$update_duff:
$	WS "%LSLUPDATE-W-CREATEFAIL, failed to create file in LSL$UPDATE_ROOT:"
$	set on
$	goto question
$!
$not_prepared:
$	WS "%LSLUPDATE-W-NOTDEF, LSL$UPDATE_ROOT: is not defined"
$	WS "%LSLUPDATE-I-HINT, give command PREPARE, then try again"
$	goto question
$!
$not_lslsoft:
$	WS "%LSLUPDATE-W-NOTLSL, only user LSLSOFT may update LSL software"
$	goto emergency
$!
$! ************************************************************************
$!
$! here for abnormal exits
$!
$emergency:
$abort:
$	if tape_mounted then dismount 'source'/nounload
$	WS "%LSLUPDATE-W-ABORT, Procedure terminated abnormally"
$!
$! ************************************************************************
$!
$! all done
$!
$exit:
$	set noverify
$	exit
