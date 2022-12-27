$!
$	ver=f$verify(0)
$!
$! Copyright Laser-Scan Limited, Cambridge, England.
$!
$! Command file for building MAPDATA2I
$!
$	on error then goto mapdata2iex
$	on control_y then exit
$	define/nolog cmn lsl$source_root:[convert.mapdata2i.src]
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$mapdata2i_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto mapdata2iex
$	define/group lsl$mapdata2i_building "in_progress"
$	open/write comfil mapdata2ibat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$ 	set noverify"
$	wc	"$	on control_y then goto mapdata2iex"
$	wc	"$	if ""'","'f$logical(""lsl$mapdata2i_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$a0:	define/group lsl$mapdata2i_building ""in_progress"""
$	wc	"$	set noon"
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$	inquire/nop mapdata2i_dbg "With debug ? "
$	if .not. mapdata2i_dbg then goto a04
$	   fsw1="/debug"
$	   mldbg="/debug"
$	   inquire/nop answer "Without optimisation ? "
$	   if answer then fsw1=fsw1 + "/noopt"
$	   inquire/nop answer "Check bounds and overflow ? "
$	   if answer then fsw1=fsw1 + "/check=(bounds,overflow)"
$	   inquire/nop answer "With listings ? "
$	   if answer then fsw1=fsw1 + "/list"
$	   inquire/nop answer "Keep fortran sources with comments ? "
$	   if answer then kpcom="/co"
$ a04:
$	   inq/nop cld "Compile CLD modules ? "
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all fortran sources ? "
$	   if .not. everything then goto a05
$	   mapdata2i	 = "t"
$	   obey		 = "t"
$	   obey_qual	 = "t"
$	   obey_erret	 = "t"
$	   rdpar	 = "t"
$	   rdlin	 = "t"
$	   process	 = "t"
$	   process_line	 = "t"
$	   iff_start	 = "t"
$	   insert	 = "t"
$	   write_cb	 = "t"
$	   write_feature = "t"
$	   addpts	 = "t"
$	   outpts	 = "t"
$	   over_limit	 = "t"
$	   coord	 = "t"
$	   retain_flags	 = "t"
$	   check_ac_code = "t"
$	   set_ac_details = "t"
$	   get_ac_code = "t"
$	   get_ac_name = "t"
$	   get_strpar = "t"
$	   check_fc = "t"
$	   check_md_code = "t"
$!
$	   goto a11
$!
$ a05:	   inq/nop mapdata2i	 "Compile MAPDATA2I?	"
$	   inq/nop obey		 "Compile OBEY? 	"
$	   inq/nop obey_qual	 "Compile OBEY_QUAL? 	"
$	   inq/nop obey_erret	 "Compile OBEY_ERRET? 	"
$	   inq/nop rdpar	 "Compile RDPAR?	"
$	   inq/nop rdlin	 "Compile RDLIN?	"
$	   inq/nop process	 "Compile PROCESS?	"
$	   inq/nop process_line	 "Compile PROCESS_LINE?	"
$	   inq/nop iff_start	 "Compile IFF_START? 	"
$	   inq/nop insert	 "Compile INSERT_CONTROL_PT? "
$	   inq/nop write_cb	 "Compile WRITE_CB?	"
$	   inq/nop write_feature "Compile WRITE_FEATURE?"
$	   inq/nop addpts	 "Compile ADDPTS? 	"
$	   inq/nop outpts	 "Compile OUTPTS? 	"
$	   inq/nop over_limit	 "Compile OVER_LIMIT? 	"
$	   inq/nop coord	 "Compile COORD? 	"
$	   inq/nop retain_flags	 "Compile RETAIN_FLAGS? "
$	   inq/nop check_ac_code "Compile CHECK_AC_CODE? "
$	   inq/nop set_ac_details "Compile SET_AC_DETAILS? "
$	   inq/nop get_ac_code   "Compile GET_AC_CODE? "
$	   inq/nop get_ac_name   "Compile GET_AC_NAME? "
$	   inq/nop get_strpar    "Compile GET_STRPAR? "
$	   inq/nop check_fc	 "Compile CHECK_FC? "
$	   inq/nop check_md_code "Compile CHECK_MD_CODE? "
$	   write sys$output " "
$ a11:	   inq/nop mes "Generate message definitions? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkver="mapdata2i"
$	   inquire/nop answer "Experimental version? "
$	   if answer then linkver="mapdata2ix"
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$	   
$ notkb:
$!
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		set verify"
$ 		if .not. mes then goto nomess
$		wc "$	newmsg/number=1502/prefix=MD2I__/param=fortran/runoff/hl=2 mapdata2i.mes"
$		wc "$	@mapdata2i.temp_com"
$		wc "$	purge mapdata2imsg.rno"
$!
$ nomess:	if .not. cld then goto fortonly
$		wc "$ 		adc mapdata2i.tmp=mapdata2i_cld.cld"
$		wc "$ 		set command/object=mapdata2i_cld mapdata2i.tmp"
$	      	wc "$ 		ok=$status"	
$!		wc "$ 		if ok then pvv mapdata2i_cld"
$!		wc "$ 		if ok then delete adc.ide;*"
$		wc "$ 		if ok then delete mapdata2i.tmp;*"
$		wc "$ 		if ok then purge/nolog mapdata2i_cld.obj"
$
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. mapdata2i then goto a200
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' mapdata2i.f"
$		wc "$ 		purge/nolog mapdata2i.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog mapdata2i.lis"
$!
$a200:	   if .not. obey then goto a300
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' obey.f"
$		wc "$ 		purge/nolog obey.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog obey.lis"
$!
$a300:	   if .not. rdpar then goto a400
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' rdpar.f"
$		wc "$ 		purge/nolog rdpar.obj"
$		wc "$ 		macro''mldbg' parcmd"
$		wc "$ 		append parcmd.obj rdpar.obj"
$		wc "$ 		delete	parcmd.obj;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog rdpar.lis"
$!
$a400:	   if .not. process then goto a500
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' process.f"
$		wc "$ 		purge/nolog process.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog process.lis"
$!
$a500:	   if .not. process_line then goto a600
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' process_line.f"
$		wc "$ 		purge/nolog process_line.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog process_line.lis"
$!
$a600:	   if .not. iff_start then goto a700
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' iff_start.f"
$		wc "$ 		purge/nolog iff_start.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog iff_start.lis"
$!
$a700:	   if .not. insert then goto a800
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' insert_control_pt.f"
$		wc "$ 		purge/nolog insert_control_pt.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog insert_control_pt.lis"
$!
$a800:	   if .not. write_cb then goto a900
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' write_cb.f"
$		wc "$ 		purge/nolog write_cb.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog write_cb.lis"
$!
$a900:	   if .not. write_feature then goto a1000
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' write_feature.f"
$		wc "$ 		purge/nolog write_feature.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog write_feature.lis"
$!
$a1000:	   if .not. addpts then goto a1100
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' addpts.f"
$		wc "$ 		purge/nolog addpts.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog addpts.lis"
$!
$a1100:	   if .not. outpts then goto a1200
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' outpts.f"
$		wc "$ 		purge/nolog outpts.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog outpts.lis"
$!
$a1200:	   if .not. over_limit then goto a1300
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' over_limit.f"
$		wc "$ 		purge/nolog over_limit.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog over_limit.lis"
$!
$a1300:	   if .not. coord then goto a1400
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' coord.f"
$		wc "$ 		purge/nolog coord.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog coord.lis"
$!
$a1400:	   if .not. obey_qual then goto a1500
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' obey_qual.f"
$		wc "$ 		purge/nolog obey_qual.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog obey_qual.lis"
$!
$a1500:	   if .not. check_ac_code then goto a1600
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' check_ac_code.f"
$		wc "$ 		purge/nolog check_ac_code.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog check_ac_code.lis"
$!
$a1600:	   if .not. obey_erret then goto a1700
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' obey_erret.f"
$		wc "$ 		purge/nolog obey_erret.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog obey_erret.lis"
$!
$a1700:	   if .not. rdlin then goto a1800
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' rdlin.f"
$		wc "$ 		purge/nolog rdlin.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog rdlin.lis"
$!
$a1800:	   if .not. set_ac_details then goto a1900
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' set_ac_details.f"
$		wc "$ 		purge/nolog set_ac_details.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog set_ac_details.lis"
$!
$a1900:	   if .not. get_ac_code then goto a2000
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' get_ac_code.f"
$		wc "$ 		purge/nolog get_ac_code.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog get_ac_code.lis"
$!
$a2000:	   if .not. get_ac_name then goto a2100
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' get_ac_name.f"
$		wc "$ 		purge/nolog get_ac_name.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog get_ac_name.lis"
$!
$a2100:	   if .not. get_strpar then goto a2200
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' get_strpar.f"
$		wc "$ 		purge/nolog get_strpar.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog get_strpar.lis"
$!
$a2200:	   if .not. check_fc then goto a2300
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' check_fc.f"
$		wc "$ 		purge/nolog check_fc.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog check_fc.lis"
$!
$a2300:	   if .not. check_md_code then goto a3000
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' check_md_code.f"
$		wc "$ 		purge/nolog check_md_code.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog check_md_code.lis"
$!
$a3000:	   if .not. retain_flags then goto lnkonly
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' retain_flags.f"
$		wc "$ 		purge/nolog retain_flags.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog retain_flags.lis"
$!
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		link''linkopts'/exe=''linkver' mapdata2i, -"
$	   	wc "		mapdata2i_cld, -"
$		wc "		obey, -"
$		wc "		obey_qual, -"
$		wc "		obey_erret, -"
$		wc "		rdpar, -"
$		wc "		rdlin, -"
$		wc "		process, -"
$		wc "		process_line, -"
$		wc "		iff_start, -"
$		wc "		insert_control_pt, -"
$		wc "		write_cb, -"
$		wc "		write_feature, -"
$		wc "		addpts, -"
$		wc "		outpts, -"
$		wc "		over_limit, -"
$		wc "		coord, -"
$		wc "		retain_flags, -"
$		wc "		check_ac_code, -"
$		wc "		set_ac_details, -"
$		wc "		get_ac_code, -"
$		wc "		get_ac_name, -"
$		wc "		get_strpar, -"
$		wc "		check_fc, -"
$		wc "		check_md_code, -"
$		wc "		mapdata2i.promsg_obj, -"
$		wc "		lsl$library:coordlib/lib, -"
$!		wc "lsl$source_root:[lslmaint.coordlib.test]coordlib/lib, -"
$		wc "		lsl$library:lslfrtlib/lib,-"
$	   	wc "		lsl$library:iffshr/opt,lslshr/opt"
$ nolnk:
$		wc "$ 		mapdata2iex:"
$		wc "$ 		deass/group lsl$mapdata2i_building"
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto mapdata2iex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$mapdata2i_building
$	bat mapdata2ibat.com
$	goto mapdata2ix2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto mapdata2iex
$	deass/group lsl$mapdata2i_building
$	@mapdata2ibat.com
$	goto mapdata2ix2
$ mapdata2iex:
$	deass/group lsl$mapdata2i_building
$ mapdata2ix2:
$	if ver then set verify
$	pur mapdata2ibat.com
$	pur *.obj
$!
