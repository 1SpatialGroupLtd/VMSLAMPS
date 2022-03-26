$!
$! Command file to build TVES utility DTICONTOUR
$!
$! Copyright Laser-Scan Limited, Cambridge, England.
$!
$!	BRIDGE added					JHR  4-Oct-1988
$!	Created						TJH 12-Jan-1987
$!
$	ver=f$verify(0)
$!
$	on error then goto dticontourex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$dticontour_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto dticontourex
$	define/group lsl$dticontour_building "in_progress"
$	open/write comfil dticontourbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto dticontourex"
$	wc "$	if ""'","'f$logical(""lsl$dticontour_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$dticontour_building ""in_progress"""
$	wc "$	assign here lsl$cmndticontour"
$	wc "$	assign lsl$source_root:[tves.service] lsl$tvessys"
$	wc "$	assign lsl$source_root:[tves.service] lsl$dtmcreatesys"
$	wc "$	sd:=$lsl$sys:sd"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	dticontour_dbg=""
$	macbuild=""
$	mes=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop dticontour_dbg "With Debug ? "
$	if .not. dticontour_dbg then goto a04
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
$!
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all sources ? "
$	   if .not. everything then goto a05
$!
$	ANNO_SET="t"
$	BRIDGE="t"
$	CALC_SCALING="t"
$	CLOSE_FILES="t"
$	CONGRD="t"
$	CONVER="t"
$	CORDS="t"
$	DENSIT="t"
$	DISABLE_CMD="t"
$	DRAW="t"
$	DTICONTOUR="t"
$	DUPLIC="t"
$	ENABLE_CMD="t"
$	EXCP_HAND="t"
$	FIGPLT="t"
$	FILEIN_CMD="t"
$	FILEOUT_CMD="t"
$	FIVE_PERCENT="t"
$	GET_CMDS="t"
$	GET_FC="t"
$	GET_LAYER="t"
$	GET_SCALE="t"
$	HELP_CMD="t"
$	IFADPT="t"
$	IFF_FIN="t"
$	IFF_HEADER="t"
$	IFF_SPOT="t"
$	IFLUSH="t"
$	IFNWFT="t"
$	INDEX_INTERVAL_CMD="t"
$	INTERVAL_CMD="t"
$	ISOLIN="t"
$	LABEL_CMD="t"
$	LABEL_SIZE_CMD="t"
$	LACE="t"
$	MAXCURVE_CMD="t"
$	MINGAP_CMD="t"
$	MODULUS_CMD="t"
$	NOTE="t"
$	OPNDTI="t"
$	PLOT="t"
$	PLOTB="t"
$	POST="t"
$	POSTVL="t"
$	READLL="t"
$	SET_CMD="t"
$	SHOW_CMD="t"
$	SMOOTH="t"
$	SMOOTH_CMD="t"
$	SYMBOL="t"
$	UNITS_CMD="t"
$	VALUE="t"
$	VERSION="t"
$	WIND="t"
$	WINDOW_CMD="t"
$	ZLIMITS_CMD="t"
$	MACBUILD="t"
$!
$	goto a11
$!
$ a05:	   
$	ws " "
$	ws ".............................MACRO32 stuff"
$	   inq/nop MACBUILD	"Compile command table? "
$	ws " " 
$	ws ".............................FORTRAN sources"
$	inq/nop ANNO_SET "ANNO_SET? "
$	inq/nop BRIDGE "BRIDGE? "
$	inq/nop CALC_SCALING "CALC_SCALING? "
$	inq/nop CLOSE_FILES "CLOSE_FILES? "
$	inq/nop CONGRD "CONGRD? "
$	inq/nop CONVER "CONVER? "
$	inq/nop CORDS "CORDS? "
$	inq/nop DENSIT "DENSIT? "
$	inq/nop DISABLE_CMD "DISABLE_CMD? "
$	inq/nop DRAW "DRAW? "
$	inq/nop DTICONTOUR "DTICONTOUR? "
$	inq/nop DUPLIC "DUPLIC? "
$	inq/nop ENABLE_CMD "ENABLE_CMD? "
$	inq/nop EXCP_HAND "EXCP_HAND? "
$	inq/nop FIGPLT "FIGPLT? "
$	inq/nop FILEIN_CMD "FILEIN_CMD? "
$	inq/nop FILEOUT_CMD "FILEOUT_CMD? "
$	inq/nop FIVE_PERCENT "FIVE_PERCENT? "
$	inq/nop GET_CMDS "GET_CMDS? "
$	inq/nop GET_FC "GET_FC? "
$	inq/nop GET_LAYER "GET_LAYER? "
$	inq/nop GET_SCALE "GET_SCALE"
$	inq/nop HELP_CMD "HELP_CMD? "
$	inq/nop IFADPT "IFADPT? "
$	inq/nop IFF_FIN "IFF_FIN? "
$	inq/nop IFF_HEADER "IFF_HEADER? "
$	inq/nop IFF_SPOT "IFF_SPOT? "
$	inq/nop IFLUSH "IFLUSH? "
$	inq/nop IFNWFT "IFNWFT? "
$	inq/nop INDEX_INTERVAL_CMD "INDEX_INTERVAL_CMD? "
$	inq/nop INTERVAL_CMD "INTERVAL_CMD? "
$	inq/nop ISOLIN "ISOLIN? "
$	inq/nop LABEL_CMD "LABEL_CMD? "
$	inq/nop LABEL_SIZE_CMD "LABEL_SIZE_CMD? "
$	inq/nop LACE "LACE? "
$	inq/nop MAXCURVE_CMD "MAXCURVE_CMD? "
$	inq/nop MINGAP_CMD "MINGAP_CMD? "
$	inq/nop MODULUS_CMD "MODULUS_CMD? "
$	inq/nop NOTE "NOTE? "
$	inq/nop OPNDTI "OPNDTI? "
$	inq/nop PLOT "PLOT? "
$	inq/nop PLOTB "PLOTB? "
$	inq/nop POST "POST? "
$	inq/nop POSTVL "POSTVL? "
$	inq/nop READLL "READLL? "
$	inq/nop SET_CMD "SET_CMD? "
$	inq/nop SHOW_CMD "SHOW_CMD? "
$	inq/nop SMOOTH "SMOOTH? "
$	inq/nop SMOOTH_CMD "SMOOTH_CMD? "
$	inq/nop SYMBOL "SYMBOL? "
$	inq/nop UNITS_CMD "UNITS_CMD? "
$	inq/nop VALUE "VALUE? "
$	inq/nop VERSION "VERSION? "
$	inq/nop WIND "WIND? "
$	inq/nop WINDOW_CMD "WINDOW_CMD? "
$	inq/nop ZLIMITS_CMD "ZLIMITS_CMD? "
$!
$ a11:
$	   inq/nop mes "Generate message definitions ? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   linkver="dticontour"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="dticontourx"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$!
$	   if .not. compile then goto lnkonly
$!
$ notkb:
$		wc "$ 	set noverify"
$!
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 	set verify"
$ 		if .not.mes then goto cmponly
$		wc "$	newmsg/dti/number=1653/name=dticont/prefix=dticont__/parameter=for/runoff dticontour.mes"
$		wc "$ @dticontour.temp_com"
$!	
$ cmponly:		
$	mdeb=""
$	if dticontour_dbg then mdeb = "/enable=debug"
$	if .not. macbuild then goto for2
$		wc "$	MACRO''mdeb' dticontour_cmdtab"
$!
$ for2: if .not. compile then goto lnkonly
$!
$	if ANNO_SET then call compiler ANNO_SET
$	if BRIDGE then call compiler BRIDGE
$	if CALC_SCALING then call compiler CALC_SCALING
$	if CLOSE_FILES then call compiler CLOSE_FILES
$	if CONGRD then call compiler CONGRD
$	if CONVER then call compiler CONVER
$	if CORDS then call compiler CORDS
$	if DENSIT then call compiler DENSIT
$	if DISABLE_CMD then call compiler DISABLE_CMD
$	if DRAW then call compiler DRAW
$	if DTICONTOUR then call compiler DTICONTOUR
$	if DUPLIC then call compiler DUPLIC
$	if ENABLE_CMD then call compiler ENABLE_CMD
$	if EXCP_HAND then call compiler EXCP_HAND
$	if FIGPLT then call compiler FIGPLT
$	if FILEIN_CMD then call compiler FILEIN_CMD
$	if FILEOUT_CMD then call compiler FILEOUT_CMD
$	if FIVE_PERCENT then call compiler FIVE_PERCENT
$	if GET_CMDS then call compiler GET_CMDS
$	if GET_FC then call compiler GET_FC
$	if GET_SCALE then call compiler GET_SCALE
$	if GET_LAYER then call compiler GET_LAYER
$	if HELP_CMD then call compiler HELP_CMD
$	if IFADPT then call compiler IFADPT
$	if IFF_FIN then call compiler IFF_FIN
$	if IFF_HEADER then call compiler IFF_HEADER
$	if IFF_SPOT then call compiler IFF_SPOT
$	if IFLUSH then call compiler IFLUSH
$	if IFNWFT then call compiler IFNWFT
$	if INDEX_INTERVAL_CMD then call compiler INDEX_INTERVAL_CMD
$	if INTERVAL_CMD then call compiler INTERVAL_CMD
$	if ISOLIN then call compiler ISOLIN
$	if LABEL_CMD then call compiler LABEL_CMD
$	if LABEL_SIZE_CMD then call compiler LABEL_SIZE_CMD
$	if LACE then call compiler LACE
$	if MAXCURVE_CMD then call compiler MAXCURVE_CMD
$	if MINGAP_CMD then call compiler MINGAP_CMD
$	if MODULUS_CMD then call compiler MODULUS_CMD
$	if NOTE then call compiler NOTE
$	if OPNDTI then call compiler OPNDTI
$	if PLOT then call compiler PLOT
$	if PLOTB then call compiler PLOTB
$	if POST then call compiler POST
$	if POSTVL then call compiler POSTVL
$	if READLL then call compiler READLL
$	if SET_CMD then call compiler SET_CMD
$	if SHOW_CMD then call compiler SHOW_CMD
$	if SMOOTH then call compiler SMOOTH
$	if SMOOTH_CMD then call compiler SMOOTH_CMD
$	if SYMBOL then call compiler SYMBOL
$	if UNITS_CMD then call compiler UNITS_CMD
$	if VALUE then call compiler VALUE
$	if VERSION then call compiler VERSION
$	if WIND then call compiler WIND
$	if WINDOW_CMD then call compiler WINDOW_CMD
$	if ZLIMITS_CMD then call compiler ZLIMITS_CMD
$!
$	goto lnkonly
$!----------------------------------------------------------------------
$ compiler: subroutine 
$!----------------------------------------------------------------------
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
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
		wc "$ 	if ok then delete/nolog ''p1'.lis;*"
$		wc "$	if .not.ok then emsg=emsg+"" ''p1'"""
$		wc "$ 	delete adc.ide;*"
$		wc "$	set noverify"
$	return
$ endsubroutine
$!----------------------------------------------------------------------
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
$	wc "$ set noverify"
$	wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$ set verify"
$	wc "$ 	run lsl$exe:genver"
$		call compiler version
$	wc "$ 	purge/nolog version.src"
$	wc "$ set verify"
$	wc "$ 	link''linkopts'/exe=''linkver' dticontour/opt,lsl$library:iffshr/opt,lslshr/opt"
$ nolnk:
$		wc "$ 	nolnk:"
$		wc "$ 	dticontourex:"
$		wc "$ 	deass/group lsl$dticontour_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto dticontourex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$dticontour_building
$	bat dticontourbat.com
$	goto dticontourx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto dticontourex
$	deass/group lsl$dticontour_building
$	@dticontourbat.com
$	goto dticontourx2
$!
$ dticontourex:
$	deass/group lsl$dticontour_building
$!
$ dticontourx2:
$	purge dticontour.map
$	purge dticontourbat.com
$	if ver then set verify
$!
