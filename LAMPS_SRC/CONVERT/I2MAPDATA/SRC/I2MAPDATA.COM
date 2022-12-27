$	ver=f$verify(0)
$!
$!	Copyright (C) Laser-Scan Ltd., Cambridge, England.
$!
$!	Created						RJH	16-Sep-1994
$!
$!	CONVERT I2MAPDATA Utility - Command file to build the program
$!
$	on error then goto i2mapdataex
$	on control_y then exit
$	define/nolog cmn lsl$source_root:[convert.i2mapdata.src]
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$i2mapdata_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$ a0:	on control_y then goto i2mapdataex
$	define/group lsl$i2mapdata_building "in_progress"
$	open/write comfil i2mapdatabat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$ 	set noverify"
$	wc	"$	on control_y then goto i2mapdataex"
$	wc	"$	if ""'","'f$logical(""lsl$i2mapdata_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$a0:	define/group lsl$i2mapdata_building ""in_progress"""
$	wc	"$	set noon"
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$	inquire/nop i2mapdata_dbg "With debug ? "
$	if .not. i2mapdata_dbg then goto a04
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
$!
$ a04:	   inq/nop cld "Compile CLD modules ? "
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all fortran sources ? "
$	   if .not. everything then goto a05
$	   i2mapdata	 = "t"
$	   dcl_qual	 = "t"
$	   obey		 = "t"
$	   rdpar	 = "t"
$	   process	 = "t"
$!
$	   goto a11
$!
$ a05:	   inq/nop i2mapdata	 "Compile I2MAPDATA?	"
$	   inq/nop dcl_qual	 "Compile DCL_QUAL? 	"
$	   inq/nop obey		 "Compile OBEY? 	"
$	   inq/nop rdpar	 "Compile RDPAR?	"
$	   inq/nop process	 "Compile PROCESS?	"
$	   write sys$output " "
$!
$ a11:	   inq/nop mes "Generate message definitions? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkver="i2mapdata"
$	   inquire/nop answer "Experimental version? "
$	   if answer then linkver="i2mapdatax"
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$!
$ notkb:
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		set verify"
$ 		if .not. mes then goto nomess
$		wc "$	newmsg/number=1627/prefix=MD2I__/param=fortran/runoff/hl=2 i2mapdata.mes"
$		wc "$	@i2mapdata.temp_com"
$		wc "$	purge i2mapdatamsg.rno"
$!
$ nomess:	if .not. cld then goto fortonly
$		wc "$ 		adc i2mapdata.tmp=i2mapdata_cld.cld"
$		wc "$ 		set command/object=i2mapdata_cld i2mapdata.tmp"
$	      	wc "$ 		ok=$status"	
$!!!		wc "$ 		if ok then pvv i2mapdata_cld"
$!!!		wc "$ 		if ok then delete adc.ide;*"
$		wc "$ 		if ok then delete i2mapdata.tmp;*"
$		wc "$ 		if ok then purge/nolog i2mapdata_cld.obj"
$
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. i2mapdata then goto a99
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' i2mapdata.f"
$		wc "$ 		purge/nolog i2mapdata.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog i2mapdata.lis"
$!
$ a99:	   if .not. dcl_qual then goto a100
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' dcl_qual.f"
$		wc "$ 		purge/nolog dcl_qual.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dcl_qual.lis"
$!
$ a100:	   if .not. obey then goto a101
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' obey.f"
$		wc "$ 		purge/nolog obey.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog obey.lis"
$!
$ a101:	   if .not. rdpar then goto a102
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
$ a102:	   if .not. process then goto a105
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' process.f"
$		wc "$ 		purge/nolog process.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog process.lis"
$!
$ a105:	   if .not. process_line then goto a108
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' process_line.f"
$		wc "$ 		purge/nolog process_line.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog process_line.lis"
$!
$ a108:	   if .not. iff_start then goto a109
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' iff_start.f"
$		wc "$ 		purge/nolog iff_start.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog iff_start.lis"
$!
$ a109:	   if .not. insert then goto a110
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' insert_control_pt.f"
$		wc "$ 		purge/nolog insert_control_pt.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog insert_control_pt.lis"
$!
$ a110:	   if .not. write_cb then goto a115
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' write_cb.f"
$		wc "$ 		purge/nolog write_cb.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog write_cb.lis"
$!
$ a115:	   if .not. write_feature then goto a120
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' write_feature.f"
$		wc "$ 		purge/nolog write_feature.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog write_feature.lis"
$!
$ a120:	   if .not. addpts then goto a130
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' addpts.f"
$		wc "$ 		purge/nolog addpts.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog addpts.lis"
$!
$ a130:	   if .not. outpts then goto a140
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' outpts.f"
$		wc "$ 		purge/nolog outpts.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog outpts.lis"
$!
$ a140:	   if .not. coord then goto a150
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' coord.f"
$		wc "$ 		purge/nolog coord.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog coord.lis"
$!
$ a150:	   if .not. flush then goto a160
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' flush.f"
$		wc "$ 		purge/nolog flush.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog flush.lis"
$!
$ a160:	   if .not. retain_flags then goto lnkonly
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
$	   	wc "$ 		link''linkopts'/exe=''linkver' i2mapdata, -"
$	   	wc "		i2mapdata_cld, -"
$		wc "		obey, -"
$		wc "		rdpar, -"
$		wc "		process, -"
$		wc "		process_line, -"
$		wc "		iff_start, -"
$		wc "		insert_control_pt, -"
$		wc "		write_cb, -"
$		wc "		write_feature, -"
$		wc "		addpts, -"
$		wc "		outpts, -"
$		wc "		coord, -"
$		wc "		flush, -"
$		wc "		retain_flags, -"
$		wc "		i2mapdata.promsg_obj, -"
$!		wc "            lsl$library:coordlib/lib, -"
$		wc "lsl$source_root:[lslmaint.coordlib.test]coordlib/lib, -"
$		wc "		lsl$library:lslfrtlib/lib,-"
$	   	wc "		lsl$library:iffshr/opt,lslshr/opt"
$!
$ nolnk:
$		wc "$ 		i2mapdataex:"
$		wc "$ 		deass/group lsl$i2mapdata_building"
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto i2mapdataex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$i2mapdata_building
$	bat i2mapdatabat.com
$	goto i2mapdatax2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto i2mapdataex
$	deass/group lsl$i2mapdata_building
$	@i2mapdatabat.com
$	goto i2mapdatax2
$ i2mapdataex:
$	deass/group lsl$i2mapdata_building
$ i2mapdatax2:
$	if ver then set verify
$	pur i2mapdatabat.com
$	pur *.obj
$!
