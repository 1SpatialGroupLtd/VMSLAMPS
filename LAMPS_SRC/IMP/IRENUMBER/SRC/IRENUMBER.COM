$!
$! Command file to build IMP utility IRENUMBER 
$!
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!MOD	Changed build directory for CMS			ST  27-Jul-1993
$!MOD	Uses library shareable images			JMB 30-Nov-1987
$!MOD	TJI's new NEWMSG message utility now used	TJH 20-Oct-1987
$!MOD	Newmessage (Fortran) option added		ATT 14-Jan-1987
$!MOD	Test LSLLIB added				ATT 10-Nov-1986
$!MOD	And now it doesn't!				TJH 30-Oct-1986
$!MOD	Now optionally renames general message object
$!	to LSL$GENMSG					TJH 02-Sep-1986
$!	Created						ATT 13-Aug-1986
$!
$	ver=f$verify(0)
$!
$	on error then goto irenumberex
$	on control_y then exit
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$irenumber_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto irenumberex
$	define/group lsl$irenumber_building "in_progress"
$	open/write comfil irenumberbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto irenumberex"
$	wc "$	if ""'","'f$logical(""lsl$irenumber_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$irenumber_building ""in_progress"""
$	wc "$	assign lsl$source_root:[imp.irenumber.src] lsl$cmnirenumber"
$	wc "$	sd:=$lsl$sys:sd"
$	wc "$	set noon"
$!
$	renmes=""
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$	inquire/nop irenumber_dbg "With Debug ? "
$	if .not. irenumber_dbg then goto a04
$	   fsw1="/debug"
$	   mldbg="/debug"
$	   inquire/nop answer "Without optimisation ? "
$	   if answer then fsw1=fsw1 + "/noopt"
$	   inquire/nop answer "Check bounds and overflow ? "
$	   if answer then fsw1=fsw1 + "/check=(bounds,overflow)"
$	   inquire/nop answer "With listings ? "
$	   if answer then fsw1=fsw1 + "/list"
$	   inquire/nop answer "Keep FORtran sources with comments ? "
$	   if answer then kpcom="/co"
$ a04:
$	   inq/nop cld "Compile CLD module ? "
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all FORTRAN sources ? "
$	   if .not. everything then goto a05
$	   irenumber="t"
$	   getcmd="t"
$	   chkqual="t"
$	   renum="t"
$	   closef="t"
$	   goto a11
$!
$ a05:	   
$ 	   inq/nop irenumber	"Compile IRENUMBER ?"
$ 	   inq/nop getcmd 	"Compile GETCMD ?"
$ 	   inq/nop renum 	"Compile RENUM ?"
$	   inq/nop chkqual	"Compile CHKQUAL ?"
$	   inq/nop closef	"Compile CLOSEF ?"
$	   write sys$output " "
$ a11:	   inq/nop mes "Generate message definitions ? "
$! 	   if mes then inq/nop renmes "Rename general message object to package message directory ? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkver="irenumber"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="IRENUMBERX"
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/DEBUG"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/CROSS"
$!
$	   
$ notkb:
$!
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		set verify"
$ 		if mes then -
$		WC "$	newmsg/number=1206/name=irenumber/prefix=iren__/parameter=for irenumber.mes" 
$		wc "$ @irenumber.temp_com" 
$	   if .not. cld then goto fortonly
$		wc "$ 		adc IRENUMBER.TMP=IRENUMBER_cld.CLD"
$		wc "$ 		set command/object=IRENUMBER_CLD IRENUMBER.TMP"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv IRENUMBER_CLD"
$	      	wc "$ 		ok=$status"	
$!	
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. irenumber then goto a110
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc irenumber''kpcom'=irenumber"
$	   	wc "$ 		fort''fsw1' irenumber"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv irenumber"
$		wc "$ 		purge/nolog irenumber.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog irenumber.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog irenumber.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog irenumber.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a110:	   if .not. getcmd then goto a120
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc getcmd''kpcom'=getcmd"
$	   	wc "$ 		fort''fsw1' getcmd"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv getcmd"
$		wc "$ 		purge/nolog getcmd.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog getcmd.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog getcmd.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog getcmd.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a120:	   
$ 	   if .not. closef then goto a130
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc closef ''kpcom'=closef "
$	   	wc "$ 		fort''fsw1' closef "
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv closef "
$		wc "$ 		purge/nolog closef.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog closef.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog closef.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog closef.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a130:	   if .not. renum then goto a140
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc renum ''kpcom'=renum "
$	   	wc "$ 		fort''fsw1' renum "
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv renum "
$		wc "$ 		purge/nolog renum.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog renum.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog renum.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog renum.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a140:	   if .not. chkqual then goto a150
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc chkqual''kpcom'=chkqual"
$	   	wc "$ 		fort''fsw1' chkqual"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv chkqual"
$		wc "$ 		purge/nolog chkqual.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog chkqual.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog chkqual.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog chkqual.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a150:	   
$!
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		link''linkopts'/exe=''linkver' irenumber, -"
$	   	wc "		irenumber_cld, getcmd, chkqual, renum,-"
$	   	wc "		closef , -'
$		wc "		irenumber.promsg_obj, -"
$!
$	   	wc "		lsl$library:iffshr/opt,lslshr/opt"
$!
$ nolnk:
$		wc "$ 		irenumberex:"
$		wc "$ 		deass/group lsl$irenumber_building"
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto irenumberex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$irenumber_building
$	bat irenumberbat.com
$	goto irenumberx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto irenumberex
$	deass/group lsl$irenumber_building
$	@irenumberbat.com
$	goto irenumberx2
$ irenumberex:
$	deass/group lsl$irenumber_building
$ irenumberx2:
$	if ver then set verify
