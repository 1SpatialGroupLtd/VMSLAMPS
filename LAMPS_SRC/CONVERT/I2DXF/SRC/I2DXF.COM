$!
$	ver=f$verify(0)
$	set noon
$!
$! Copyright Laser-Scan Limited, Cambridge, England.
$!
$! Mod 1437 Use new frtshr			JB 24-Nov-1994
$!
$! Command file for building I2DXF
$!
$	on error then goto i2dxfex
$	on control_y then exit
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$i2dxf_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:	on control_y then goto i2dxfex
$	define/group lsl$i2dxf_building "in_progress"
$	open/write comfil i2dxfbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$ 	set noverify"
$	wc 	"$ 	set noon"
$	wc	"$ 	assign lsl$source_root:[convert.dxfparlib.src] lsl$dxfpar"
$ 	wc	"$	assign lsl$source_root:[convert.dxfparlib.src] lsl$cmndxfpar"
$ 	wc	"$	assign lsl$source_root:[convert.i2dxf.src] lsl$cmni2dxf"
$!
$	wc	"$	on control_y then goto i2dxfex"
$	wc	"$	if ""'","'f$logical(""lsl$i2dxf_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$a0:	define/group lsl$i2dxf_building ""in_progress"""
$	wc	"$	sd:=$lsl$sys:sd"
$	wc	"$	set noon"
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$	inquire/nop i2dxf_dbg "With Debug ? "
$	if .not. i2dxf_dbg then goto a04
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
$	   i2dxf	="t"
$	   getcmd	="t"
$	   read_iff	="t"
$	   circle_sol	="t"
$	   iff_line	="t"
$ 	   iff_point    ="t"
$	   iff_circle   ="t"
$ 	   iff_arc      ="t"
$	   iff_text	="t"
$ 	   iff_insert   ="t"
$ 	   iff_poly     ="t"
$ 	   iff_circum   ="t"
$ 	   newstart	="t"
$ 	   output_coord	="t"
$ 	   gttxtlnth 	="t"
$	   goto a11
$!
$ A05:	   INQ/NOP I2DXF	"Compile I2DXF?		"
$	   INQ/NOP GETCMD	"Compile GETCMD? 	"
$	   INQ/NOP READ_IFF	"Compile READ_IFF?	"
$	   INQ/NOP CIRCLE_SOL	"Compile CIRCLE_SOL?	"
$	   INQ/NOP IFF_LINE	"Compile IFF_LINE? 	"
$	   INQ/NOP IFF_POINT	"Compile IFF_POINT?	"
$	   INQ/NOP IFF_CIRCLE	"Compile IFF_CIRCLE?	"
$	   INQ/NOP IFF_ARC 	"Compile IFF_ARC?  	"
$	   INQ/NOP IFF_TEXT	"Compile IFF_TEXT? 	"
$	   INQ/NOP IFF_INSERT	"Compile IFF_INSERT?	"
$	   INQ/NOP IFF_POLY	"Compile IFF_POLY? 	"
$	   INQ/NOP IFF_CIRCUM  	"Compile IFF_CIRCUM?	"
$	   INQ/NOP NEWSTART	"Compile NEWSTART?	"
$	   INQ/NOP OUTPUT_COORD	"Compile OUTPUT_COORD?	"
$	   INQ/NOP GTTXTLNTH	"Compile GTTXTLNTH?	"
$	   write sys$output " "
$ a11:	   inq/nop mes "Generate message definitions ? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   linkver="i2dxf"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="i2dxfx"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$
$ notkb:
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		set verify"
$	   if .not.mes then goto do_cld
$		wc "$	newmsg i2dxf.mes/number=1622/runoff/hl=2"
$		wc "$	purge i2dxfmsg.rno"
$		wc "$	purge i2dxf.promsg_obj"
$		wc "$	@i2dxf.temp_com"
$!
$ do_cld:
$	   if .not. cld then goto fortonly
$		wc "$ 		adc i2dxf.tmp=i2dxf_cld.cld"
$		wc "$ 		set command/object=i2dxf_cld i2dxf.tmp"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv i2dxf_cld"
$		wc "$ 		if ok then delete/noconfirm i2dxf.tmp;*"
$		wc "$ 		if ok then delete/noconfirm adc.ide;*"
$		wc "$ 		if ok then purge/nolog i2dxf_cld.obj"
$!
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. i2dxf then goto a100
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$		set verify"
$		wc "$ 		adc i2dxf''kpcom'=i2dxf"
$	   	wc "$ 		fort''fsw1' i2dxf"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv i2dxf"
$		wc "$ 		purge/nolog i2dxf.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog i2dxf.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog i2dxf.lis"
$		wc "$ 		delete/noconfirm adc.ide;*"
$!
$ a100:	   if .not. getcmd then goto a110
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc getcmd''kpcom'=getcmd"
$	   	wc "$ 		fort''fsw1' getcmd"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv getcmd"
$		wc "$ 		purge/nolog getcmd.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog getcmd.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog getcmd.lis"
$		wc "$ 		delete/noconfirm adc.ide;*"
$!
$ a110:	   if .not. read_iff then goto a130
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc read_iff''kpcom'=read_iff"
$	   	wc "$ 		fort''fsw1' read_iff"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv read_iff"
$		wc "$ 		purge/nolog read_iff.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog read_iff.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog read_iff.lis"
$		wc "$ 		delete/noconfirm adc.ide;*"
$!
$ a130:	   if .not. circle_sol then goto a150
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc circle_sol''kpcom'=circle_sol" 
$	   	wc "$ 		fort''fsw1' circle_sol" 
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv circle_sol"
$		wc "$ 		purge/nolog circle_sol.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog circle_sol.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog circle_sol.lis"
$		wc "$ 		delete/noconfirm adc.ide;*"
$!
$!
$ a150:	   if .not. iff_line  then goto a160
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc iff_line''kpcom'=iff_line"
$	   	wc "$ 		fort''fsw1' iff_line"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv iff_line"
$		wc "$ 		purge/nolog iff_line.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog iff_line.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog iff_line.lis"
$		wc "$ 		delete/noconfirm adc.ide;*"
$!
$ a160:	   if .not. iff_point  then goto a170
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc iff_point''kpcom'=iff_point"
$	   	wc "$ 		fort''fsw1' iff_point"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv iff_point"
$		wc "$ 		purge/nolog iff_point.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog iff_point.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog iff_point.lis"
$		wc "$ 		delete/noconfirm adc.ide;*"
$!
$a170:	   if .not. iff_circle then goto a180
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc iff_circle''kpcom'=iff_circle"
$	   	wc "$ 		fort''fsw1' iff_circle"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv iff_circle"
$		wc "$ 		purge/nolog iff_circle.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog iff_circle.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog iff_circle.lis"
$		wc "$ 		delete/noconfirm adc.ide;*"
$!
$a180:	   if .not. iff_arc then goto a190
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc iff_arc''kpcom'=iff_arc"
$	   	wc "$ 		fort''fsw1' iff_arc"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv iff_arc"
$		wc "$ 		purge/nolog iff_arc.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog iff_arc.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog iff_arc.lis"
$		wc "$ 		delete/noconfirm adc.ide;*"
$!
$!
$a190:	   if .not. iff_text then goto a200
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc iff_text''kpcom'=iff_text"
$	   	wc "$ 		fort''fsw1' iff_text"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv iff_text"
$		wc "$ 		purge/nolog iff_text.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog iff_text.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog iff_text.lis"
$		wc "$ 		delete/noconfirm adc.ide;*"
$!
$!
$a200:	   if .not. iff_insert then goto a210
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc iff_insert''kpcom'=iff_insert"
$	   	wc "$ 		fort''fsw1' iff_insert"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv iff_insert"
$		wc "$ 		purge/nolog iff_insert.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog iff_insert.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog iff_insert.lis"
$		wc "$ 		delete/noconfirm adc.ide;*"
$! 
$!
$a210:	   if .not. iff_poly then goto a220
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc iff_poly''kpcom'=iff_poly"
$	   	wc "$ 		fort''fsw1' iff_poly"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv iff_poly"
$		wc "$ 		purge/nolog iff_poly.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog iff_poly.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog iff_poly.lis"
$		wc "$ 		delete/noconfirm adc.ide;*"
$!
$!
$a220:	   if .not. iff_circum then goto a230
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc iff_circum''kpcom'=iff_circum"
$	   	wc "$ 		fort''fsw1' iff_circum"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv iff_circum"
$		wc "$ 		purge/nolog iff_circum.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog iff_circum.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog iff_circum.lis"
$		wc "$ 		delete/noconfirm adc.ide;*"
$!
$!
$a230:	   if .not. newstart then goto a235
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc newstart''kpcom'=newstart"
$	   	wc "$ 		fort''fsw1' newstart"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv newstart"
$		wc "$ 		purge/nolog newstart.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog newstart.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog newstart.lis"
$		wc "$ 		delete/noconfirm adc.ide;*"
$!
$a235:	   if .not. output_coord then goto a240
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc output_coord''kpcom'=output_coord"
$	   	wc "$ 		fort''fsw1' output_coord"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv output_coord"
$		wc "$ 		purge/nolog output_coord.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog output_coord.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog output_coord.lis"
$		wc "$ 		delete/noconfirm adc.ide;*"
$!
$!
$a240:	   if .not. gttxtlnth then goto lnkonly
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc gttxtlnth''kpcom'=gttxtlnth"
$	   	wc "$ 		fort''fsw1' gttxtlnth"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv gttxtlnth"
$		wc "$ 		purge/nolog gttxtlnth.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog gttxtlnth.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog gttxtlnth.lis"
$		wc "$ 		delete/noconfirm adc.ide;*"
$!
$!
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		link''linkopts'/exe=''linkver' i2dxf, -"
$	   	wc "		i2dxf_cld, getcmd, read_iff, circle_sol, -"
$	   	wc "		iff_line, iff_point, iff_circle, iff_arc, -"
$		wc "		iff_text, iff_insert, iff_poly, iff_circum, -"
$		wc "		newstart, output_coord, gttxtlnth, -"
$		wc "		here:i2dxf.promsg_obj, -"
$	   	wc "		lsl$dxfpar:dxfpar.promsg_obj, -"
$	   	wc "		lsl$dxfpar:dxfparlib/lib, -"
$	   	wc "		lsl$library:frtshr/opt,lslshr/opt, -"
$	   	wc "		iffshr/opt"
$		wc "$ mapid i2dxf"
$!
$ nolnk:
$		wc "$ 		i2dxfex:"
$		wc "$ 		deass/group lsl$i2dxf_building"
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto i2dxfex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$i2dxf_building
$	bat i2dxfbat.com
$	goto i2dxfx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto i2dxfex
$	deass/group lsl$i2dxf_building
$	@i2dxfbat.com
$	purge i2dxfbat.com
$	goto i2dxfx2
$ i2dxfex:
$	deass/group lsl$i2dxf_building
$ i2dxfx2:
$	purge *.for
$	purge i2dxf.map
$
$	if ver then set verify
$!
