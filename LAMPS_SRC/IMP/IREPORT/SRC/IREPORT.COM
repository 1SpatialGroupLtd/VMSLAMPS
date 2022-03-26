$!
$	ver=f$verify(0)
$!
$! Copyright Laser-Scan Limited, Cambridge, England.
$!
$!	Created					 	TJH 30-Sep-1986
$!
$!MOD	Option to link with testing LSLLIB 		TJH 03-Nov-1986
$!MOD	Newmessage F(ortran) option added		ATT 14-Jan-1987
$!MOD	Replace NEWMESSAGE with NEWMSG			AJV 01-Jun-1990
$!MOD	Changed build directory for CMS			ST  27-Jul-1993
$!MOD1432 Use new frtshr				JB  22-Nov-1994
$!
$! Command file for building IREPORT
$!
$	on error then goto ireportex
$	on control_y then exit
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$ireport_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$ a0:	on control_y then goto ireportex
$	define/group lsl$ireport_building "in_progress"
$	open/write comfil ireportbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$ 	set noverify"
$	wc	"$	on control_y then goto ireportex"
$	wc	"$	if ""'","'f$logical(""lsl$ireport_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$ a0:	define/group lsl$ireport_building ""in_progress"""
$	wc	"$	assign lsl$disk:[iff.imp.ireport.src] lsl$cmnireport"
$	wc	"$	sd:=$lsl$sys:sd"
$	wc	"$	set noon"
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$	inquire/nop ireport_dbg "With Debug ? "
$	if .not. ireport_dbg then goto a04
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
$	   inq/nop cld "Compile CLD modules ? "
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all FORTRAN sources ? "
$	   if .not. everything then goto a05
$!
$	   get_com_lin="t"
$	   fileini="t"
$	   wrtcmd="t"
$	   lites2m="t"
$	   no_report="t"
$	   eo_report="t"
$	   cc_report="t"
$	   cp_report="t"
$	   ej_report="t"
$	   ns_report="t"
$	   ac_report="t"
$	   cb_report="t"
$	   ireport="t"
$	   fc_report="t"
$	   ef_report="t"
$	   nf_report="t"
$	   st_report="t"
$	   zs_report="t"
$	   ro_report="t"
$	   tc_report="t"
$	   th_report="t"
$	   ts_report="t"
$	   tx_report="t"
$	   goto a11
$!
$ a05:
$	   INQ/NOP AC_REPORT "Compile AC_REPORT? "
$	   INQ/NOP CB_REPORT "Compile CB_REPORT? "
$	   INQ/NOP CC_REPORT "Compile CC_REPORT? "
$	   INQ/NOP CP_REPORT "Compile CP_REPORT? "
$	   INQ/NOP EF_REPORT "Compile EF_REPORT? "
$	   INQ/NOP EO_REPORT "Compile EO_REPORT? "
$	   INQ/NOP FC_REPORT "Compile FC_REPORT? "
$	   INQ/NOP GET_COM_LIN "Compile GET_COM_LIN? "
$	   INQ/NOP EJ_REPORT "Compile EJ_REPORT? "
$	   INQ/NOP IREPORT  "Compile IREPORT? "
$	   INQ/NOP LITES2M "Compile LITES2M? "
$	   INQ/NOP NF_REPORT "Compile NF_REPORT? "
$	   INQ/NOP NS_REPORT "Compile NS_REPORT? "
$	   INQ/NOP NO_REPORT "Compile NO_REPORT? "
$	   INQ/NOP FILEINI "Compile FILEINI? "
$	   INQ/NOP RO_REPORT "Compile RO_REPORT? "
$	   INQ/NOP ST_REPORT "Compile ST_REPORT? "
$	   INQ/NOP TC_REPORT "Compile TC_REPORT? "
$	   INQ/NOP TH_REPORT "Compile TH_REPORT? "
$	   INQ/NOP TS_REPORT "Compile TS_REPORT? "
$	   INQ/NOP TX_REPORT "Compile TX_REPORT? "
$	   INQ/NOP WRTCMD "Compile WRTCMD? "
$	   INQ/NOP ZS_REPORT "Compile ZS_REPORT? "
$!
$	   goto a11
$!
$ a11:	   inq/nop mes "Generate message definitions? "
$!
$	   inquire/nop lnkit "Link? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   linkver="ireport"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="ireportx"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$	   
$ notkb:
$!
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		set verify"
$ 		if .not. mes then goto nomessing
$		wc "$ 	newmsg ireport /number=1215/prefix=ireport__"
$		wc "$	@ireport.temp_com"
$! Old message generation
$! 		WC "$	NEWMESSAGE IREPORT.MES IREPORT 1215 IREPORT__ N F"
$ nomessing:
$	   if .not. cld then goto fortonly
$		wc "$ 		adc ireport.tmp=ireport.cld"
$		wc "$ 		set command/object=ireport_cld ireport.tmp"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv ireport_cld"
$		wc "$ 		if ok then delete ireport.tmp;*"
$		wc "$ 		if ok then purge/nolog ireport_cld.obj"
$	
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. ac_report then goto a110
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		adc ac_report''kpcom'=ac_report"
$	   	wc "$ 		fort''fsw1' ac_report"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv ac_report"
$		wc "$ 		purge/nolog ac_report.obj"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog ac_report.for;*"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog ac_report.for"
$		wc "$ 		delete adc.ide;*"
$!
$ a110:	   if .not. cb_report then goto a115
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc cb_report''kpcom'=cb_report"
$	   	wc "$ 		fort''fsw1' cb_report"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv cb_report"
$		wc "$ 		purge/nolog cb_report.obj"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog cb_report.for;*"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog cb_report.for"
$		wc "$ 		delete adc.ide;*"
$!
$ a115:	   if .not. cc_report then goto a120
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc cc_report''kpcom'=cc_report"
$	   	wc "$ 		fort''fsw1' cc_report"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv cc_report"
$		wc "$ 		purge/nolog cc_report.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog cc_report.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog cc_report.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog cc_report.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a120:	   if .not. cp_report then goto a130
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc cp_report''kpcom'=cp_report"
$	   	wc "$ 		fort''fsw1' cp_report"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv cp_report"
$		wc "$ 		purge/nolog cp_report.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog cp_report.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog cp_report.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog cp_report.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a130:	   if .not. ef_report then goto a140
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc ef_report''kpcom'=ef_report"
$	   	wc "$ 		fort''fsw1' ef_report"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv ef_report"
$		wc "$ 		purge/nolog ef_report.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog ef_report.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog ef_report.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog ef_report.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a140:	   if .not. eo_report then goto a150
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc eo_report''kpcom'=eo_report"
$	   	wc "$ 		fort''fsw1' eo_report"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv eo_report"
$		wc "$ 		purge/nolog eo_report.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog eo_report.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog eo_report.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog eo_report.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a150:	   if .not. fc_report then goto a160
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc fc_report''kpcom'=fc_report"
$	   	wc "$ 		fort''fsw1' fc_report"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv fc_report"
$		wc "$ 		purge/nolog fc_report.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog fc_report.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog fc_report.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog fc_report.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a160:	   if .not. get_com_lin then goto a170
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc get_com_lin''kpcom'=get_com_lin"
$	   	wc "$ 		fort''fsw1' get_com_lin"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv get_com_lin"
$		wc "$ 		purge/nolog get_com_lin.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog get_com_lin.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog get_com_lin.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog get_com_lin.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a170:	   if .not. ej_report then goto a175
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc ej_report''kpcom'=ej_report"
$	   	wc "$ 		fort''fsw1' ej_report"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv ej_report"
$		wc "$ 		purge/nolog ej_report.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog ej_report.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog ej_report.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog ej_report.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a175:	   if .not. ireport then goto a180
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc ireport''kpcom'=ireport"
$	   	wc "$ 		fort''fsw1' ireport"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv ireport"
$		wc "$ 		purge/nolog ireport.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog ireport.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog ireport.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog ireport.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a180:	   if .not. lites2m then goto a190
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc lites2m''kpcom'=lites2m"
$	   	wc "$ 		fort''fsw1' lites2m"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv lites2m"
$		wc "$ 		purge/nolog lites2m.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog lites2m.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog lites2m.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog lites2m.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a190:	   if .not. nf_report then goto a200
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc nf_report''kpcom'=nf_report"
$	   	wc "$ 		fort''fsw1' nf_report"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv nf_report"
$		wc "$ 		purge/nolog nf_report.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog nf_report.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog nf_report.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog nf_report.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a200:	   if .not. ns_report then goto a210
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc ns_report''kpcom'=ns_report"
$	   	wc "$ 		fort''fsw1' ns_report"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv ns_report"
$		wc "$ 		purge/nolog ns_report.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog ns_report.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog ns_report.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog ns_report.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a210:	   if .not. no_report then goto a220
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc no_report''kpcom'=no_report"
$	   	wc "$ 		fort''fsw1' no_report"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv no_report"
$		wc "$ 		purge/nolog no_report.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog no_report.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog no_report.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog no_report.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a220:	   if .not. fileini then goto a230
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc fileini''kpcom'=fileini"
$	   	wc "$ 		fort''fsw1' fileini"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv fileini"
$		wc "$ 		purge/nolog fileini.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog fileini.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog fileini.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog fileini.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a230:	   if .not. wrtcmd then goto a240
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc wrtcmd''kpcom'=wrtcmd"
$	   	wc "$ 		fort''fsw1' wrtcmd"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv wrtcmd"
$		wc "$ 		purge/nolog wrtcmd.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog wrtcmd.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog wrtcmd.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog wrtcmd.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a240:	   if .not. ro_report then goto a250
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc ro_report''kpcom'=ro_report"
$	   	wc "$ 		fort''fsw1' ro_report"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv ro_report"
$		wc "$ 		purge/nolog ro_report.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog ro_report.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog ro_report.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog ro_report.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a250:	   if .not. st_report then goto a260
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc st_report''kpcom'=st_report"
$	   	wc "$ 		fort''fsw1' st_report"
$	      	wc "$ 		ok=$status	
$		wc "$ 		if ok then pvv st_report"
$		wc "$ 		purge/nolog st_report.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog st_report.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog st_report.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog st_report.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a260:	   if .not. tc_report then goto a270
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		adc tc_report''kpcom'=tc_report"
$	   	wc "$ 		fort''fsw1' tc_report"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv tc_report"
$		wc "$ 		purge/nolog tc_report.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog tc_report.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog tc_report.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog tc_report.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a270:	   if .not. th_report then goto a280
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc th_report''kpcom'=th_report"
$	   	wc "$ 		fort''fsw1' th_report"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv th_report"
$		wc "$ 		purge/nolog th_report.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog th_report.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog th_report.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog th_report.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a280:	   if .not.  ts_report then goto a290
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc ts_report''kpcom'=ts_report"
$	   	wc "$ 		fort''fsw1' ts_report"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv ts_report"
$		wc "$ 		purge/nolog ts_report.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog ts_report.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog ts_report.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog ts_report.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a290:	   if .not. tx_report then goto a300
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc tx_report''kpcom'=tx_report"
$	   	wc "$ 		fort''fsw1' tx_report"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv tx_report"
$		wc "$ 		purge/nolog tx_report.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog tx_report.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog tx_report.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog tx_report.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a300:	   if .not. zs_report then goto lnkonly
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc zs_report''kpcom'=zs_report"
$	   	wc "$ 		fort''fsw1' zs_report"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv zs_report"
$		wc "$ 		purge/nolog zs_report.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog zs_report.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog zs_report.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog zs_report.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$	link''linkopts'/exe=''linkver' -"
$		wc "	ireport,ireport_cld, -"
$		wc "	ac_report,cc_report,cp_report,ef_report,-"
$		wc "	eo_report,fc_report,get_com_lin,ej_report,lites2m,-"
$		wc "	nf_report,ns_report,no_report,fileini,-"
$		wc "	wrtcmd,ro_report,st_report,cb_report,-"
$		wc "	tc_report,th_report,ts_report,tx_report,-"
$		wc "	zs_report, ireport.promsg_obj,-"
$		wc "	lsl$library:iffshr.opt/opt,-"
$		wc "	lsl$library:lslshr.opt/opt,-"
$		wc "	lsl$library:frtshr.opt/opt"
$!
$ nolnk:
$		wc "$ 		ireportex:"
$		wc "$ 		deass/group lsl$ireport_building"
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto ireportex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$ireport_building
$	bat ireportbat.com
$	goto ireportx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto ireportex
$	deass/group lsl$ireport_building
$	@ireportbat.com
$	goto ireportx2
$!
$ ireportex:
$	deass/group lsl$ireport_building
$!
$ ireportx2:
$	if ver then set verify
$!
