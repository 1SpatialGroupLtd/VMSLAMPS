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
$		wc "$!	'f$verify(0)"
$		wc "$	on control_y then goto i2mapdataex"
$		wc "$	on error then goto i2mapdataex"
$		wc "$	if ""'","'f$logical(""lsl$i2mapdata_building"")'"" -"
$		wc "		 .nes. ""in_progress"" then goto a0"
$		wc "$	write sys$output ""Someone else is building"""
$		wc "$	exit"
$		wc "$!"
$		wc "$a0:	define/group lsl$i2mapdata_building ""in_progress"""
$!!!		wc "$	set noon"
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
$	   i2mapdata		= "t"
$	   control_init		= "t"
$	   obey			= "t"
$	   obey_qual		= "t"
$	   obey_erret		= "t"
$	   rdfrt		= "t"
$	   rdpar		= "t"
$	   rdlin		= "t"
$	   get_strpar		= "t"
$	   check_md_code	= "t"
$	   check_ac_code	= "t"
$	   check_fc		= "t"
$	   find_fc		= "t"
$	   set_ac_details	= "t"
$	   get_ac_code		= "t"
$	   get_ac_name		= "t"
$	   open_iff		= "t"
$	   open_md		= "t"
$	   close_iff		= "t"
$	   close_md		= "t"
$	   process		= "t"
$	   write_md_head	= "t"
$	   write_md_seg		= "t"
$	   write_md_code	= "t"
$	   write_md_coord	= "t"
$!
$	   goto a11
$!
$ a05:	   inq/nop i2mapdata		"Compile I2MAPDATA ? "
$	   inq/nop control_init		"Compile  CONTROL_INIT ? "
$	   inq/nop obey			"Compile OBEY ? "
$	   inq/nop obey_qual		"Compile  OBEY_QUAL ? "
$	   inq/nop obey_erret		"Compile  OBEY_ERRET ? "
$	   inq/nop rdfrt		"Compile RDFRT ? "
$	   inq/nop rdpar		"Compile RDPAR ? "
$	   inq/nop rdlin		"Compile  RDLIN ? "
$	   inq/nop get_strpar		"Compile   GET_STRPAR ? "
$	   inq/nop check_md_code	"Compile   CHECK_MD_CODE ? "
$	   inq/nop check_ac_code	"Compile   CHECK_AC_CODE ? "
$	   inq/nop check_fc		"Compile   CHECK_FC ? "
$	   inq/nop find_fc		"Compile   FIND_FC ? "
$	   inq/nop set_ac_details	"Compile  SET_AC_DETAILS ? "
$	   inq/nop get_ac_code		"Compile   GET_AC_CODE ? "
$	   inq/nop get_ac_name		"Compile   GET_AC_NAME ? "
$	   inq/nop open_iff		"Compile OPEN_IFF ? "
$	   inq/nop open_md		"Compile OPEN_MD ? "
$	   inq/nop close_iff		"Compile CLOSE_IFF ? "
$	   inq/nop close_md		"Compile CLOSE_MD ? "
$	   inq/nop process		"Compile PROCESS ? "
$	   inq/nop write_md_head	"Compile  WRITE_MD_HEAD ? "
$	   inq/nop write_md_seg		"Compile  WRITE_MD_SEG ? "
$	   inq/nop write_md_code	"Compile  WRITE_MD_CODE ? "
$	   inq/nop write_md_coord	"Compile  WRITE_MD_COORD ? "
$	   write sys$output " "
$!
$ a11:	   inq/nop mes "Generate message definitions ? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkver="i2mapdata"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="i2mapdatax"
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$!
$ notkb:   if .not. mes then goto nomess
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$	newmsg/number=1501/prefix=I2MD__/runoff/hl=2 i2mapdata"
$		wc "$	@i2mapdata.temp_com"
$		wc "$	purge i2mapdatamsg.rno"
$!
$ nomess:  if .not. cld then goto fortonly
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$ 	adc i2mapdata.tmp=i2mapdata_cld.cld"
$		wc "$ 	set command/object=i2mapdata_cld i2mapdata.tmp"
$		wc "$ 	pvv i2mapdata_cld"
$		wc "$ 	purge/nolog i2mapdata_cld.obj"
$		wc "$ 	delete adc.ide;*,i2mapdata.tmp;*"
$!
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. i2mapdata then goto a101
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' i2mapdata.f"
$		wc "$ 	purge/nolog i2mapdata.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog i2mapdata.lis"
$!
$ a101:	   if .not. control_init then goto a110
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' control_init.f"
$		wc "$ 	purge/nolog control_init.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog control_init.lis"
$!
$ a110:	   if .not. obey then goto a111
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' obey.f"
$		wc "$ 	purge/nolog obey.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog obey.lis"
$!
$ a111:	   if .not. obey_qual then goto a112
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' obey_qual.f"
$		wc "$ 	purge/nolog obey_qual.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog obey_qual.lis"
$!
$ a112:	   if .not. obey_erret then goto a120
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' obey_erret.f"
$		wc "$ 	purge/nolog obey_erret.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog obey_erret.lis"
$!
$ a120:	   if .not. rdfrt then goto a130
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' rdfrt.f"
$		wc "$ 	purge/nolog rdfrt.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog rdfrt.lis"
$!
$ a130:	   if .not. rdpar then goto a131
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' rdpar.f"
$		wc "$ 	purge/nolog rdpar.obj"
$		wc "$ 	macro''mldbg' parcmd"
$		wc "$ 	append parcmd.obj rdpar.obj"
$		wc "$ 	delete	parcmd.obj;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog rdpar.lis"
$!
$ a131:	   if .not. rdlin then goto a132
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' rdlin.f"
$		wc "$ 	purge/nolog rdlin.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog rdlin.lis"
$!
$ a132:	   if .not. get_strpar then goto a133
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' get_strpar.f"
$		wc "$ 	purge/nolog get_strpar.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog get_strpar.lis"
$!
$ a133:	   if .not. check_md_code then goto a134
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' check_md_code.f"
$		wc "$ 	purge/nolog check_md_code.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog check_md_code.lis"
$!
$ a134:	   if .not. check_ac_code then goto a135
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' check_ac_code.f"
$		wc "$ 	purge/nolog check_ac_code.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog check_ac_code.lis"
$!
$ a135:	   if .not. check_fc then goto a136
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' check_fc.f"
$		wc "$ 	purge/nolog check_fc.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog check_fc.lis"
$!
$ a136:	   if .not. find_fc then goto a137
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' find_fc.f"
$		wc "$ 	purge/nolog find_fc.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog find_fc.lis"
$!
$ a137:	   if .not. set_ac_details then goto a138
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' set_ac_details.f"
$		wc "$ 	purge/nolog set_ac_details.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog set_ac_details.lis"
$!
$ a138:	   if .not. get_ac_code then goto a139
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' get_ac_code.f"
$		wc "$ 	purge/nolog get_ac_code.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog get_ac_code.lis"
$!
$ a139:	   if .not. get_ac_name then goto a140
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' get_ac_name.f"
$		wc "$ 	purge/nolog get_ac_name.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog get_ac_name.lis"
$!
$ a140:	   if .not. open_iff then goto a141
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' open_iff.f"
$		wc "$ 	purge/nolog open_iff.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog open_iff.lis"
$!
$ a141:	   if .not. open_md then goto a142
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' open_md.f"
$		wc "$ 	purge/nolog open_md.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog open_md.lis"
$!
$ a142:	   if .not. close_iff then goto a143
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' close_iff.f"
$		wc "$ 	purge/nolog close_iff.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog close_iff.lis"
$!
$ a143:	   if .not. close_md then goto a150
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' close_md.f"
$		wc "$ 	purge/nolog close_md.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog close_md.lis"
$!
$ a150:	   if .not. process then goto a151
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' process.f"
$		wc "$ 	purge/nolog process.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog process.lis"
$!
$ a151:	   if .not. write_md_head then goto a152
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' write_md_head.f"
$		wc "$ 	purge/nolog write_md_head.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog write_md_head.lis"
$!
$ a152:	   if .not. write_md_seg then goto a153
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' write_md_seg.f"
$		wc "$ 	purge/nolog write_md_seg.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog write_md_seg.lis"
$!
$ a153:	   if .not. write_md_code then goto a154
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' write_md_code.f"
$		wc "$ 	purge/nolog write_md_code.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog write_md_code.lis"
$!
$ a154:	   if .not. write_md_coord then goto a160
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' write_md_coord.f"
$		wc "$ 	purge/nolog write_md_coord.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog write_md_coord.lis"
$!
$ a160:
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	link''linkopts'/exe=''linkver' i2mapdata, -"
$	   	wc "		i2mapdata_cld, -"
$		wc "		control_init, -"
$		wc "		obey, -"
$		wc "		obey_qual, -"
$		wc "		obey_erret, -"
$		wc "		rdfrt, -"
$		wc "		rdpar, -"
$		wc "		rdlin, -"
$		wc "		get_strpar, -"
$		wc "		check_md_code, -"
$		wc "		check_ac_code, -"
$		wc "		check_fc, -"
$		wc "		find_fc, -"
$		wc "		set_ac_details, -"
$		wc "		get_ac_code, -"
$		wc "		get_ac_name, -"
$		wc "		open_iff, -"
$		wc "		open_md, -"
$		wc "		close_iff, -"
$		wc "		close_md, -"
$		wc "		process, -"
$		wc "		write_md_head, -"
$		wc "		write_md_seg, -"
$		wc "		write_md_code, -"
$		wc "		write_md_coord, -"
$		wc "		i2mapdata.promsg_obj, -"
$		wc "		lsl$library:lslfrtlib/lib,-"
$	   	wc "		lsl$library:iffshr/opt,lslshr/opt"
$!
$ nolnk:
$		wc "$!"
$		wc "$ i2mapdataex:				! 'f$verify(0)"
$		wc "$	deass/group lsl$i2mapdata_building"
$		wc "$	exit"
$!
$ filclo:
$!!!	set noverify
$	on error then goto i2mapdataex
$	on control_y then goto i2mapdataex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$i2mapdata_building
$	bat i2mapdatabat.com
$	goto i2mapdatax2
$!
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto i2mapdataex
$	deass/group lsl$i2mapdata_building
$	@i2mapdatabat.com
$	goto i2mapdatax2
$!
$ i2mapdataex:
$	deass/group lsl$i2mapdata_building
$!
$ i2mapdatax2:
$	if ver then set verify
$	pur i2mapdatabat.com
$	pur *.obj
$	exit
$!