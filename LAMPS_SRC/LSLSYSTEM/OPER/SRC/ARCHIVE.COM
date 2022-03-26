$!-----------------------------------------------------------------
$!
$!  Example VAX/VMS Operators Archiving Command File
$!
$!  Created by Laser-Scan Ltd, Cambridge, England,
$!
$!  Original				V1.0	AJW	12-Dec-1981
$!  Recoded				V2.0	PWD	 8-Nov-1985
$!  Rehashed				V3.0	PGH	19-Feb-1990
$!  Saveset names shorter		V3.1	PGH	27-Feb-1990
$!  Know about Exabyte			V3.2	PGH	23-Jun-1990
$!  Avoid spaces in labels		V3.3	PGH	26-Sep-1990
$!  Handle alloclass eg $1$DKA700:	V3.4	PGH	25-Nov-1992
$!
$! Note:
$!  This file is provided as an example of a command procedure to
$!  automate some of the daily/weekly system admin tasks for VMS.
$!  It is not intended to be suitable "as is" for every site, and
$!  may well require changing to suit local requirements.
$!
$!-----------------------------------------------------------------
$!
$! Initial bits & pieces
$!
$	Set noon
$	On Control_y	then goto err4
$	ws="write sys$output"
$	ws " "
$	ws "LSL OPER regular disk archiving procedure V3.3. at ",f$time()
$	ws " "
$	if .not.f$priv("SYSPRV,OPER")
$	then 
$	   write sys$output "%OPER-F-NOPRIV, SYSPRV and OPER privileges needed for sensible results"
$	   goto err4
$	endif
$!
$! determine what disks are available on a system
$! (DCL filched from SHUTDOWN.COM)
$!
$get_disk:
$	ws "The following mounted disk devices are available from this CPU (",f$getsyi("NODENAME"),")"
$	ws " "
$	default_disk="*UNKNOWN*"
$	define/user sys$output sys$scratch:oper_disks.tmp
$	show device/mounted
$	open/error=69 oper_disks_tmp sys$scratch:oper_disks.tmp
$62:	read/end_of_file=69/error=69 oper_disks_tmp line
$	if f$loc(":",line) .eq. f$len(line) then goto 62
$	if .not. f$getdvi(f$elem(0,":",line),"EXISTS") then goto 62
$	disk = f$getdvi(f$elem(0,":",line),"FULLDEVNAM")
$	if f$getdvi(disk,"DEVCLASS") .ne. 1 -
          .or. .not. f$getdvi(disk,"MNT") then goto 62
$	rootdir=disk+"[000000]000000.DIR"
$	devtype=f$getdvi(disk,"MEDIA_NAME")
$	disk=disk-"_"
$	if (f$getdvi(disk,"DEVSTS").AND.256).NE.0
$	then
$	   write sys$output "''disk' is an ''devtype', mounted but currently in verify state"
$	   goto 62
$	endif
$	if f$search(rootdir).eqs.""
$	then
$	   write sys$output "''disk' is an ''devtype', mounted but currently inaccessible"
$	   goto 62
$	else
$	   lastback=f$file_attribute(rootdir,"BDT")
$	   if lastback.eqs."17-NOV-1858 00:00:00.00" then lastback="NONE"
$	endif
$	write sys$output "''disk' is an ''devtype', last recorded full archive ''lastback'"
$	default_disk=disk
$	goto 62
$69:	close /nolog oper_disks_tmp
$	if f$search("sys$scratch:oper_disks.tmp;*") .nes. "" then -
	   delete sys$scratch:oper_disks.tmp;*
$!
$! which disk do we want ?
$!
$	ws " "
$       read/end=err4/prompt="Which disk do you want [default is ''default_disk'] ?  " -
		sys$command disk
$	disk=f$edit(disk,"upcase,collapse")
$	if disk.eqs."?" then goto get_disk
$	if disk.eqs."" then disk=default_disk
$	disk = f$getdvi(disk,"FULLDEVNAM")-"_"
$!
$! now check disk device is sensible
$!
$	class=0
$	name=f$parse(disk,,,"name","no_conceal")
$	if name.nes."" then goto got_name
$	dest_node=f$parse(disk,,,"node","no_conceal")
$	device=f$parse(disk,"sys$disk:",,"device","no_conceal")
$	if dest_node.nes."" then goto silly_dev
$	if device.eqs."" then goto no_such
$	exists=f$getdvi(device,"exists")
$	if .not.exists then goto no_such
$	class=f$getdvi(device,"devclass")
$	if class.ne.1 then goto silly_dev
$	goto disk_device
$no_such:
$	ws "%OPER-W-NOSUCHDEV, device ",disk," is not available"
$	goto get_disk
$silly_dev:
$	ws "%OPER-W-SILLYDEV, device ",disk," is not sensible"
$	goto get_disk
$got_name:
$	ws "%OPER-W-NOCOLON, source ",disk," has unexpected filename"
$	ws "%OPER-I-HINT, device names must end in colon, filenames not allowed."
$	goto get_disk
$!
$! full or incremental archive ?
$!
$disk_device:
$	ws " "
$	rootdir=disk+"[000000]000000.DIR"
$	lastback=f$file_attribute(rootdir,"BDT")
$	if lastback.eqs."17-NOV-1858 00:00:00.00" 
$	then
$	   ws "No recorded full backup of ",DISK," has ever been done,"
$	   ws "so incremental archive not possible - full archive assumed."
$	   increm=0
$	else
$	   ws "Last recorded full backup of ",DISK," was done on ",LASTBACK
$	   ws "An incremental archive will only save files changed since that date."
$	   ws " "
$	   read/end=err4/prompt="Do you want an incremental archive (Y/N) [Default N for a full archive] ?  " -
		sys$command increm
$	endif
$	if increm
$	then
$	   archtype="INCR"
$	   inspec=disk+"[*...]*.*;*
$	   backsw="/since=backup"
$	else
$	   archtype="FULL"
$	   inspec=disk
$	   backsw="/image/record"
$	endif
$!
$! get date for volume name
$!
$	date=f$time()
$	minus=f$locate("-",date)
$	monpos=minus+1
$	month=f$extract(monpos,3,date)
$	if month.eqs."MAR" then month="MR"
$	if month.eqs."MAY" then month="MY"
$	if month.eqs."JUN" then month="JN"
$	if month.eqs."JUL" then month="JL"
$	month=f$extract(0,2,month)
$	day='f$extract(0,minus,date)'
$	if day.lt.10 then day:=0'day'
$	day:='day'
$	devlen=f$len(device)
$	colpos=f$locate(":",device)
$	dolpos=f$locate("$",device)
$	if dolpos.eq.0 then dolpos=f$locate("$",f$extract(1,devlen-1,device))+1
$	if dolpos.eq.devlen
$	then
$	   devpos=2
$	else
$	   devpos=dolpos+3
$	endif
$	devid=f$extract(devpos,2,device)
$!!!	write sys$output month,",",day,",",devid
$	label=month+day+devid
$	saveset=disk-":"-"_"
$	saveset=saveset+archtype
$	ws " "
$	ws "Tape label (based on <month><day><device id>) will be ",label
$	ws "Saveset name (based on <disk><type>) will be ",saveset
$!
$! get tape devices available
$!
$get_dest:
$	default_tape="*UNKNOWN*"
$	ws " "
$	ws "The following magtape devices are available on this CPU (",f$getsyi("NODENAME"),")"
$	ws " "
$	define/user sys$output sys$scratch:oper_tapes.tmp
$	show device m
$	open/error=79 oper_tapes_tmp sys$scratch:oper_tapes.tmp
$72:	read/end_of_file=79/error=79 oper_tapes_tmp line
$	if f$loc(":",line) .eq. f$len(line) then goto 72
$	if .not. f$getdvi(f$elem(0,":",line),"EXISTS") then goto 72
$	tape = f$getdvi(f$elem(0,":",line),"FULLDEVNAM")
$	if f$getdvi(tape,"DEVCLASS") .ne. 2 then goto 72
$	devtype=f$getdvi(tape,"MEDIA_NAME")
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
$	tape=tape-"_"
$	ws "Device ",tape," is a ",devtype," drive ",devtype_explain
$	default_tape=tape
$	goto 72
$79:	close /nolog oper_tapes_tmp
$	if f$search("sys$scratch:oper_tapes.tmp;*") .nes. "" then -
	   delete sys$scratch:oper_tapes.tmp;*
$!
$! ask which one to use
$!
$	ws " "
$       read/end=err4/prompt="Which tape device do you want [default is ''default_tape'] ?  " -
		sys$command tape
$	tape=f$edit(tape,"upcase,collapse")
$	if tape.eqs."?" then goto get_dest
$	if tape.eqs."" then tape=default_tape
$	class=0
$	name=f$parse(tape,,,"name","no_conceal")
$	if name.nes."" then goto got_name2
$	dest_node=f$parse(tape,,,"node","no_conceal")
$	device=f$parse(tape,"sys$disk:",,"device","no_conceal")
$	if dest_node.nes."" then goto silly_dev2
$	if device.eqs."" then goto no_such2
$	exists=f$getdvi(device,"exists")
$	if .not.exists then goto no_such2
$	class=f$getdvi(device,"devclass")
$	if class.ne.2 then goto silly_dev2
$	goto tape_device
$no_such2:
$	ws "%OPER-W-NOSUCHDEV, device ",tape," is not available"
$	goto get_dest
$silly_dev2:
$	ws "%OPER-W-SILLYDEV, device ",tape," is not sensible"
$	goto get_dest
$got_name2:
$	ws "%OPER-W-NOCOLON, destination ",tape," has unexpected filename"
$	ws "%OPER-I-HINT, device names must end in colon, filenames not allowed."
$	goto get_dest
$not_free2:
$	ws "%OPER-W-DEVNOTFREE, device ",tape," is already in use"
$	goto get_dest
$!
$! here with a tape device - get characteristics.
$!
$tape_device:
$	devnam=device-":"-"_"
$	devtype=f$getdvi(device,"MEDIA_NAME")
$	devtype_explain="(Unknown type)"
$	if devtype.eqs."TK50" then devtype_explain="(Cartridge tape)"
$	if devtype.eqs."TK70" then devtype_explain="(Cartridge tape)"
$	if devtype.eqs."TU81" then devtype_explain="(Half inch magtape)"
$	if devtype.eqs."TU78" then devtype_explain="(Half inch magtape)"
$	if devtype.eqs."TE16" then devtype_explain="(Half inch magtape)"
$	if devtype.eqs."TS11" then devtype_explain="(Half inch magtape)"
$	if devtype.eqs."MKX00" then devtype_explain="(SCSI tape)"
$	dev_inuse=0
$	explain_owner=""
$	ownerpid=f$getdvi(device,"PID")
$	if ownerpid.eqs."" then goto output_check_device
$	owneruser=""
$       owneruser=f$getjpi(ownerpid,"username")
$	if owneruser.eqs."" then owneruser="* UNKNOWN *"
$       owneruser=f$edit(owneruser,"collapse")
$	mountcnt=f$getdvi(device,"MOUNTCNT")
$	if mountcnt.gt.0 then goto dev_mounted
$	explain_owner=" -  Allocated by "+owneruser
$	dev_inuse=1
$	goto output_check_device
$dev_mounted:
$	explain_owner=" -  Mounted by "+owneruser
$	dev_inuse=1
$	goto output_check_device
$output_check_device:
$	ws "Device ",device," is a ",devtype," drive ",devtype_explain,explain_owner
$end_check_device:
$	if dev_inuse then goto not_free2
$	ws " "
$!
$! check density
$!
$	densitysw=""		! density only set for (TU81+)
$	if class.eq.0 then goto not_tu81
$	devtype=f$getdvi(device,"MEDIA_NAME")
$	if devtype.nes."TU81" then goto not_tu81
$       read/end=err4/prompt="1600BPI Density [default N for 6250BPI] ?  " -
		sys$command yes
$	if yes then densitysw="/DENSITY=1600"
$	if .not.yes then densitysw="/DENSITY=6250"
$	ws " "
$not_tu81:
$!
$! check all well
$!
$ mtok1:
$	read/end=err4/prompt="Hit return when the first reel is loaded on ''device'" -
		sys$command yes
$	mount/foreign/noassist 'device'
$	On Control_y	then goto err3
$	read/end=err3/prompt="Did the magtape mount correctly (Y/N) ?  " -
		sys$command yes
$	if yes then goto mtok2
$	dismount 'device'/nounload
$	goto mtok1
$!
$! announce ourselves and let it rip
$!
$ mtok2:
$	ws " "
$	ws  "Archive of ''DISK' starting at ",f$time()
$	ws " "
$	set noon
$	set verify
$	assign/user 'f$log("tt")' sys$input
$	backup/noassist/verify/rewind/ignore=(label,interlock)'backsw' -
               'inspec' -
               'device''saveset'/label='label''densitysw'
$	set noverify
$	ws " "
$	ws "Archive of ''DISK' ending at ",f$time()
$	ws " "
$!
$err3:	set noon
$	dismount 'device'
$err4:	
$	set noverify
$	exit
