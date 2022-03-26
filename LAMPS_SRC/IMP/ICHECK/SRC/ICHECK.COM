$!
$! Command file to build IMP utility ICHECK
$!
$!
$! Copyright Laser-Scan Limited, Cambridge, England.
$!
$!	Created						ATT 12-Jan-1987
$!
$!MOD	Use shareable library images			JMB 30-Nov-1987
$!MOD	New LOAD_STBUF routine added			JMC 27-Oct-1989
$!MOD	/LIST now works, NEWMESSAGE changed to NEWMSG 	TJH 22-Oct-1990
$!MOD	Build directory changed for CMS			ST  27-Jul-1993
$!MOD1432 Use new frtshr				JB  23-Nov-1994
$!
$	ver=f$verify(0)
$!
$	on error then goto icheckex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$icheck_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto icheckex
$	define/group lsl$icheck_building "in_progress"
$	open/write comfil icheckbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto icheckex"
$	wc "$	if ""'","'f$logical(""lsl$icheck_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$icheck_building ""in_progress"""
$	wc "$	assign lsl$source_root:[imp.icheck.src] lsl$cmnicheck"
$	wc "$	sd:=$lsl$sys:sd"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1="/list"
$	kpcom=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$	inquire/nop icheck_dbg "With Debug ? "
$	if .not. icheck_dbg then goto a04
$	   fsw1="/list/debug"
$	   mldbg="/debug"
$	   inquire/nop answer "Without optimisation ? "
$	   if answer then fsw1=fsw1 + "/noopt"
$	   inquire/nop answer "Check bounds and overflow ? "
$	   if answer then fsw1=fsw1 + "/check=(bounds,overflow)"
$	   inquire/nop answer "Keep FORtran sources with comments ? "
$	   if answer then kpcom="/co"
$ a04:
$!
$	   inq/nop cld "Compile CLD module ? "
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all FORTRAN sources ? "
$	   if .not. everything then goto a05
$	   icheck="t"
$	   getcmd="t"
$	   getfil="t"
$	   chkqual="t"
$	   clofil="t"
$	   wrtohdr="t"
$	   wrtlhdr="t"
$	   wrtlend="t"
$	   read_iff="t"
$	   read_ef="t"
$	   read_ej="t"
$	   read_eo="t"
$	   read_fs="t"
$	   read_nf="t"
$	   read_no="t"
$	   read_ra="t"
$	   read_ro="t"
$	   read_st="t"
$          load_stbuf="t"
$	   read_ts="t"
$	   read_tx="t"
$	   read_zs="t"
$	   reset_ft="t"
$	   check_neat="t"
$	   lites_err="t"
$	   mark_err="t"
$	   write_err="t"
$	   check_ft="t"
$	   check_tch="t"
$	   check_frt="t"
$	   find_int="t"
$	   rep_int="t"
$	   int_init="t"
$	   segchk="t"
$!	   frtwrt="t"
$	   goto a11
$!
$ a05:	   
$	ws ".............................First the main modules"
$ 	   inq/nop icheck	"Compile ICHECK ?"
$	   inq/nop chkqual	"Compile CHKQUAL ?"
$	   inq/nop clofil	"Compile CLOFIL ?"
$ 	   inq/nop getcmd 	"Compile GETCMD ?"
$ 	   inq/nop getfil	"Compile GETFIL ?"
$	ws ".............................Now IFF reading"
$	   inq/nop read_iff	"Compile READ_IFF ?"
$	   inq/nop read_ef	"Compile READ_EF ?"
$	   inq/nop read_ej	"Compile READ_EJ ?"
$	   inq/nop read_eo	"Compile READ_EO ?"
$	   inq/nop read_fs	"Compile READ_FS ?"
$	   inq/nop read_nf	"Compile READ_NF ?"
$	   inq/nop read_no	"Compile READ_NO ?"
$	   inq/nop read_ra	"Compile READ_RA ?"
$	   inq/nop read_ro	"Compile READ_RO ?"
$	   inq/nop read_st	"Compile READ_ST ?"
$	   inq/nop read_ts	"Compile READ_TS ?"
$	   inq/nop read_tx	"Compile READ_TX ?"
$	   inq/nop read_zs	"Compile READ_ZS ?"
$	ws ".............................checking"
$	   inq/nop check_frt	"Compile CHECK_FRT ?"
$	   inq/nop check_ft	"Compile CHECK_FT ?"
$	   inq/nop check_neat	"Compile CHECK_NEAT ?"
$	   inq/nop check_tch	"Compile CHECK_TCH ?"
$	   inq/nop load_stbuf	"Compile LOAD_STBUF ?"
$	   inq/nop reset_ft	"Compile RESET_FT ?"
$	ws ".............................file writing"
$!	   inq/nop frtwrt 	"Compile FRTWRT(dummy FRTLIB routine) ?"
$	   inq/nop lites_err 	"Compile LITES_ERR ?"
$	   inq/nop mark_err 	"Compile MARK_ERR ?"
$	   inq/nop write_err	"Compile WRITE_ERR ?"
$	   inq/nop wrtlhdr	"Compile WRTLHDR ?"
$	   inq/nop wrtlend	"Compile WRTLEND ?"
$	   inq/nop wrtohdr	"Compile WRTOHDR ?"
$	ws ".............................intersection stuff"
$	   inq/nop find_int	"Compile FIND_INT ?"
$	   inq/nop int_init	"Compile INT_INIT ?"
$	   inq/nop rep_int	"Compile REP_INT ?"
$	   inq/nop segchk 	"Compile SEGCHK ?"
$	ws " "
$ a11:
$	   inq/nop mes "Generate message definitions ? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   linkver="icheck"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="icheckx"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$!
$ notkb:
$		wc "$ 	set noverify"
$!
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 	set verify"
$ 		if .not.mes then goto nomess
$		wc "$	newmsg/number=1206/name=ICHECK/prefix=ICHECK__/param=for/runoff ICHECK.mes"
$		wc "$	purge icheckmsg.rno"
$		wc "$	@ICHECK.temp_com"
$!
$ nomess:	   if .not. cld then goto fortonly
$		wc "$ 		adc icheck.tmp=icheck_cld.cld"
$		wc "$ 		set command/object=icheck_cld icheck.tmp"
$	      	wc "$ 		ok=$status"
$		wc "$ 		if ok then pvv icheck_cld"
$		wc "$		if ok then purge icheck_cld.obj"
$		wc "$		if ok then delete icheck.tmp;
$	      	wc "$ 		ok=$status"	
$		wc "$! "
$!	
$ fortonly:		
$	if .not. compile then goto lnkonly
$	if icheck then call compiler icheck 
$	if getcmd then call compiler getcmd 
$	if getfil then call compiler getfil 
$	if chkqual then call compiler chkqual 
$	if clofil then call compiler clofil 
$	if wrtohdr then call compiler wrtohdr 
$	if wrtlhdr then call compiler wrtlhdr 
$	if wrtlend then call compiler wrtlend 
$	if read_iff then call compiler read_iff
$	if read_ef then call compiler read_ef
$	if read_ej then call compiler read_ej 
$	if read_eo then call compiler read_eo 
$	if read_fs then call compiler read_fs 
$	if read_nf then call compiler read_nf 
$	if read_no then call compiler read_no 
$	if read_ra then call compiler read_ra 
$	if read_ro then call compiler read_ro 
$	if load_stbuf then call compiler load_stbuf
$	if read_st then call compiler read_st 
$	if read_ts then call compiler read_ts 
$	if read_tx then call compiler read_tx 
$	if read_zs then call compiler read_zs 
$	if reset_ft then call compiler reset_ft
$	if check_neat then call compiler check_neat
$	if check_frt then call compiler check_frt
$	if check_tch then call compiler check_tch
$	if check_ft then call compiler check_ft
$	if lites_err then call compiler lites_err
$	if mark_err then call compiler mark_err
$	if write_err then call compiler write_err
$	if find_int then call compiler find_int
$	if rep_int then call compiler rep_int
$	if int_init then call compiler int_init
$	if segchk then call compiler segchk
$!	if frtwrt then call compiler frtwrt
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ compiler: subroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$		wc "$ 	set noverify"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$ 	adc ''p1'''kpcom'=''p1'"
$	   	wc "$	fort''fsw1' ''p1'"
$	      	wc "$ 	ok=$status"	
$		wc "$ 	if ok then pvv ''p1'"
$		wc "$ 	purge/nolog ''p1'.obj"
$		if fsw1.eqs."" then -
		wc "$ 	delete/nolog ''p1'.for;*"
$		if fsw1.nes.""  then -
		wc "$ 	purge/nolog ''p1'.for"
		wc "$ 	if ok then delete/nolog ''p1'.lis;*"
$		wc "$	if .not.ok then emsg=emsg+"" ''p1'"""
$		wc "$ 	delete adc.ide;*"
$		wc "$	set noverify"
$	return
$ endsubroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ lnkonly:
$	wc "$	set noverify"
$	wc "$	if emsg.eqs."""" then goto noerr"
$	wc "$	write sys$output ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	write sys$output ""Compilation errors in:"""
$	wc "$	write sys$output emsg"
$	wc "$	write sys$output ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	goto nolnk"
$	wc "$	noerr:"
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 	link''linkopts'/exe=''linkver' icheck,-"
$	   	wc "	icheck_cld, getcmd, chkqual, getfil,-"
$	   	wc "	clofil, wrtohdr, wrtlhdr, wrtlend,-"
$	   	wc " 	read_ef, read_ej, read_eo, read_fs, read_iff,-"
$	   	wc " 	read_nf, read_no, read_ra, read_ro, read_st,-"
$	   	wc " 	read_ts, read_tx, read_zs, reset_ft, mark_err,-"
$	   	wc " 	check_neat, check_frt, lites_err, write_err,-"
$	   	wc " 	check_ft, find_int, segchk, rep_int, int_init,-"
$		wc "	check_tch, load_stbuf, -"
$!		wc "	frtwrt, -"
$		wc "	icheck.promsg_obj, -"
$		wc "	lsl$library:coordlib/lib, -"
$	   	wc "	lsl$library:frtshr/opt,lslshr/opt,iffshr/opt"
$!
$ nolnk:
$		wc "$ 	nolnk:"
$		wc "$ 	icheckex:"
$		wc "$ 	deass/group lsl$icheck_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto icheckex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto fast
$	deass/group lsl$icheck_building
$	bat icheckbat.com
$	goto icheckx2
$fast:
$	if ok then inq/nop answer_bat "Submit for fast batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$icheck_building
$	fbat icheckbat.com
$	goto icheckx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto icheckex
$	deass/group lsl$icheck_building
$	@icheckbat.com
$	purge icheckbat.com
$	goto icheckx2
$!
$ icheckex:
$	deass/group lsl$icheck_building
$!
$ icheckx2:
$	if ver then set verify
$!
