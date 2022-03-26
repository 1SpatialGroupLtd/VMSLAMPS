$!
$	ver=f$verify(0)
$!
$! Copyright Laser-Scan Limited, Cambridge, England.
$!
$!------------------------------------------------------------------------
$! Command file for building DXF2I
$!------------------------------------------------------------------------
$! Modifications
$! 19-Mar-1990 AJ Verrill	Link with shared libraries LSLSHR, IFFSHR
$! 12-May-1993 J Barber		Add SCAN_ routines for /SCAN
$!  7-Jun-1993 J Barber		Add WRITE_HEADER routine for no header
$! 28-Jul-1993 S Townrow	Change DXFPARLIB logical for use with CMS
$! 29-Nov-1994 J Barber		Use new frtshr
$!------------------------------------------------------------------------
$!
$	on error then goto dxf2iex
$	on control_y then exit
$!
$! 	assign lsl$source_root:[convert.dxfparlib] lsl$dxfpar:
$! 	assign lsl$source_root:[convert.dxfparlib] lsl$cmndxfpar:
$ 	assign lsl$source_root:[convert.dxfparlib.src] lsl$dxfpar:
$ 	assign lsl$source_root:[convert.dxfparlib.src] lsl$cmndxfpar:
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$dxf2i_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto dxf2iex
$	define/group lsl$dxf2i_building "in_progress"
$	open/write comfil dxf2ibat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$ 	set noverify"
$	wc	"$	on control_y then goto dxf2iex"
$	wc	"$	if ""'","'f$logical(""lsl$dxf2i_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""sOMEONE ELSE IS BUILDING"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$a0:	define/group lsl$dxf2i_building ""in_progress"""
$	wc	"$	sd:=$lsl$sys:sd"
$	wc	"$	set noon"
$!	wc	"$	assign lsl$source_root:[convert.dxfparlib] lsl$dxfpar:"
$!	wc	"$	assign lsl$source_root:[convert.dxfparlib] lsl$cmndxfpar:"
$	wc	"$	assign lsl$source_root:[convert.dxfparlib.src] lsl$dxfpar:"
$	wc	"$	assign lsl$source_root:[convert.dxfparlib.src] lsl$cmndxfpar:"
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	INQUIRE/NOP COMPILE "Compile ? "
$	if .not.compile then goto a04
$	INQUIRE/NOP DXF2I_DBG "With Debug ? "
$	if .not. dxf2i_dbg then goto a04
$	   fsw1="/debug"
$	   mldbg="/debug"
$	   INQUIRE/NOP ANSWER "Without optimisation ? "
$	   if answer then fsw1=fsw1 + "/noopt"
$	   INQUIRE/NOP ANSWER "Check bounds and overflow ? "
$	   if answer then fsw1=fsw1 + "/check=(bounds,overflow)"
$	   INQUIRE/NOP ANSWER "With listings ? "
$	   if answer then fsw1=fsw1 + "/list"
$	   INQUIRE/NOP ANSWER "Keep fortran sources with comments ? "
$	   if answer then kpcom="/co"
$ a04:
$	   INQ/NOP CLD "Compile CLD modules ? "
$	   if .not.compile then goto a11
$!
$	   INQ/NOP EVERYTHING "Compile all FORTRAN sources ? "
$	   if .not. everything then goto a05
$	   dxf2i	="t"
$	   getcmd	="t"
$	   read_file	="t"
$	   read_blocks	="t"
$	   read_tables	="t"
$	   read_entities="t"
$	   read_header	="t"
$	   scan_blocks	="t"
$	   scan_tables	="t"
$	   scan_header	="t"
$	   write_header ="t"
$	   dxf_arc	="t"
$	   dxf_circle   ="t"
$	   dxf_insert	="t"
$	   dxf_line	="t"
$	   dxf_point	="t"
$	   dxf_polyline	="t"
$	   dxf_solid	="t"
$	   dxf_text	="t"
$	   dxf_trace	="t"
$	   check_range  ="t"
$	   goto a11
$!
$ A05:	   INQ/NOP DXF2I	"Compile DXF2I?		"
$	   INQ/NOP GETCMD	"Compile GETCMD? 	"
$	   INQ/NOP READ_FILE	"Compile READ_FILE?	"
$	   INQ/NOP READ_BLOCKS	"Compile READ_BLOCKS? 	"
$	   INQ/NOP READ_TABLES	"Compile READ_TABLES? 	"
$	   INQ/NOP READ_ENTITIES "Compile READ_ENTITIES? 	"
$	   INQ/NOP READ_HEADER	"Compile READ_HEADER?	"
$	   INQ/NOP SCAN_BLOCKS	"Compile SCAN_BLOCKS? 	"
$	   INQ/NOP SCAN_TABLES	"Compile SCAN_TABLES? 	"
$	   INQ/NOP SCAN_HEADER	"Compile SCAN_HEADER?	"
$	   INQ/NOP WRITE_HEADER	"Compile WRITE_HEADER?	"
$	   INQ/NOP DXF_ARC	"Compile DXF_ARC?	"
$	   INQ/NOP DXF_CIRCLE	"Compile DXF_CIRCLE?	"
$	   INQ/NOP DXF_INSERT	"Compile DXF_INSERT?	"
$	   INQ/NOP DXF_LINE	"Compile DXF_LINE?	"
$	   INQ/NOP DXF_POINT	"Compile DXF_POINT?	"
$	   INQ/NOP DXF_POLYLINE	"Compile DXF_POLYLINE?	"
$	   INQ/NOP DXF_SOLID	"Compile DXF_SOLID?	"
$	   INQ/NOP DXF_TEXT	"Compile DXF_TEXT?	"
$	   INQ/NOP DXF_TRACE	"Compile DXF_TRACE?	"
$	   INQ/NOP CHECK_RANGE	"Compile CHECK_RANGE?	"
$	   write sys$output " "
$!
$ a11:	   inq/nop mes "Generate message definitions ? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   linkver="dxf2i"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="dxf2ix"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$!
$ notkb:
$!
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		set verify"
$ 	   if .not.mes then goto do_cld
$!
$		wc "$	newmsg dxf2i.mes/number=1615/runoff/hl=2"
$		wc "$	purge dxf2imsg.rno"
$		wc "$	@dxf2i.temp_com"
$ do_cld:
$	   if .not. cld then goto fortonly
$		wc "$ 		adc dxf2i.tmp=dxf2i_cld.cld"
$		wc "$ 		set command/object=dxf2i_cld dxf2i.tmp"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dxf2i_cld"
$		wc "$ 		if ok then delete dxf2i.tmp;*"
$		wc "$ 		if ok then delete adc.ide;*"
$		wc "$ 		if ok then purge/nolog dxf2i_cld.obj"
$!
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. dxf2i then goto a100
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$		set verify"
$		wc "$ 		adc dxf2i''kpcom'=dxf2i"
$	   	wc "$ 		fort''fsw1' dxf2i"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dxf2i"
$		wc "$ 		purge/nolog dxf2i.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog dxf2i.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dxf2i.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a100:	   if .not. getcmd then goto a120
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
$		wc "$ 		delete adc.ide;*"
$!
$ a120:	   if .not. read_blocks  then goto a125
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc read_blocks''kpcom'=read_blocks"
$	   	wc "$ 		fort''fsw1' read_blocks"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv read_blocks"
$		wc "$ 		purge/nolog read_blocks.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog read_blocks.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog read_blocks.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a125:	   if .not. scan_blocks  then goto a130
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc scan_blocks''kpcom'=scan_blocks"
$	   	wc "$ 		fort''fsw1' scan_blocks"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv scan_blocks"
$		wc "$ 		purge/nolog scan_blocks.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog scan_blocks.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog scan_blocks.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a130:	   if .not. read_tables  then goto a135
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc read_tables''kpcom'=read_tables"
$	   	wc "$ 		fort''fsw1' read_tables"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv read_tables"
$		wc "$ 		purge/nolog read_tables.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog read_tables.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog read_tables.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a135:	   if .not. scan_tables  then goto a140
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc scan_tables''kpcom'=scan_tables"
$	   	wc "$ 		fort''fsw1' scan_tables"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv scan_tables"
$		wc "$ 		purge/nolog scan_tables.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog scan_tables.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog scan_tables.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a140:	   if .not. read_entities  then goto a150
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc read_entities''kpcom'=read_entities"
$	   	wc "$ 		fort''fsw1' read_entities"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv read_entities"
$		wc "$ 		purge/nolog read_entities.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog read_entities.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog read_entities.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a150:	   if .not. read_header  then goto a155
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc read_header''kpcom'=read_header"
$	   	wc "$ 		fort''fsw1' read_header"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv read_header"
$		wc "$ 		purge/nolog read_header.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog read_header.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog read_header.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a155:	   if .not. scan_header  then goto a157
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc scan_header''kpcom'=scan_header"
$	   	wc "$ 		fort''fsw1' scan_header"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv scan_header"
$		wc "$ 		purge/nolog scan_header.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog scan_header.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog scan_header.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a157:	   if .not. write_header  then goto a160
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc write_header''kpcom'=write_header"
$	   	wc "$ 		fort''fsw1' write_header"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv write_header"
$		wc "$ 		purge/nolog write_header.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog write_header.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog write_header.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a160:	   if .not. read_file  then goto a170
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc read_file''kpcom'=read_file"
$	   	wc "$ 		fort''fsw1' read_file"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv read_file"
$		wc "$ 		purge/nolog read_file.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog read_file.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog read_file.lis"
$		wc "$ 		delete adc.ide;*"
$!
$a170:	   if .not. dxf_arc then goto a180
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc dxf_arc''kpcom'=dxf_arc"
$	   	wc "$ 		fort''fsw1' dxf_arc"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dxf_arc"
$		wc "$ 		purge/nolog dxf_arc.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog dxf_arc.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dxf_arc.lis"
$		wc "$ 		delete adc.ide;*"
$!
$a180:	   if .not. dxf_circle then goto a190
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc dxf_circle''kpcom'=dxf_circle"
$	   	wc "$ 		fort''fsw1' dxf_circle"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dxf_circle"
$		wc "$ 		purge/nolog dxf_circle.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog dxf_circle.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dxf_circle.lis"
$		wc "$ 		delete adc.ide;*"
$!
$!
$a190:	   if .not. dxf_insert then goto a200
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc dxf_insert''kpcom'=dxf_insert"
$	   	wc "$ 		fort''fsw1' dxf_insert"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dxf_insert"
$		wc "$ 		purge/nolog dxf_insert.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog dxf_insert.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dxf_insert.lis"
$		wc "$ 		delete adc.ide;*"
$!
$!
$a200:	   if .not. dxf_line then goto a210
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc dxf_line''kpcom'=dxf_line"
$	   	wc "$ 		fort''fsw1' dxf_line"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dxf_line"
$		wc "$ 		purge/nolog dxf_line.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog dxf_line.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dxf_line.lis"
$		wc "$ 		delete adc.ide;*"
$! 
$!
$a210:	   if .not. dxf_point then goto a220
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc dxf_point''kpcom'=dxf_point"
$	   	wc "$ 		fort''fsw1' dxf_point"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dxf_point"
$		wc "$ 		purge/nolog dxf_point.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog dxf_point.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dxf_point.lis"
$		wc "$ 		delete adc.ide;*"
$!
$!
$a220:	   if .not. dxf_polyline then goto a230
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc dxf_polyline''kpcom'=dxf_polyline"
$	   	wc "$ 		fort''fsw1' dxf_polyline"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dxf_polyline"
$		wc "$ 		purge/nolog dxf_polyline.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog dxf_polyline.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dxf_polyline.lis"
$		wc "$ 		delete adc.ide;*"
$!
$!
$a230:	   if .not. dxf_solid then goto a240
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc dxf_solid''kpcom'=dxf_solid"
$	   	wc "$ 		fort''fsw1' dxf_solid"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dxf_solid"
$		wc "$ 		purge/nolog dxf_solid.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog dxf_solid.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dxf_solid.lis"
$		wc "$ 		delete adc.ide;*"
$!
$!
$a240:	   if .not. dxf_text then goto a250
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc dxf_text''kpcom'=dxf_text"
$	   	wc "$ 		fort''fsw1' dxf_text"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dxf_text"
$		wc "$ 		purge/nolog dxf_text.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog dxf_text.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dxf_text.lis"
$		wc "$ 		delete adc.ide;*"
$!
$!
$!
$a250:	   if .not. dxf_trace then goto a260
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc dxf_trace''kpcom'=dxf_trace"
$	   	wc "$ 		fort''fsw1' dxf_trace"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dxf_trace"
$		wc "$ 		purge/nolog dxf_trace.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog dxf_trace.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dxf_trace.lis"
$		wc "$ 		delete adc.ide;*"
$!
$!
$a260:	   if .not. check_range then goto lnkonly
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc check_range''kpcom'=check_range"
$	   	wc "$ 		fort''fsw1' check_range"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv check_range"
$		wc "$ 		purge/nolog check_range.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog check_range.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog check_range.lis"
$		wc "$ 		delete adc.ide;*"
$!
$!
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		link''linkopts'/exe=''linkver' dxf2i, -"
$	   	wc "		dxf2i_cld, getcmd, write_header, -"
$		wc "		read_blocks, scan_blocks, -"
$	   	wc "		read_tables, read_header, -"
$	   	wc "		scan_tables, scan_header, read_entities, -"
$		wc "		read_file, dxf_arc, dxf_circle, dxf_insert, -"
$		wc "		dxf_line, dxf_point, dxf_polyline, -"
$		wc "		dxf_solid, dxf_text, dxf_trace,check_range, -"
$		wc "		here:dxf2i.promsg_obj, -"
$	   	wc "		lsl$dxfpar:dxfpar.promsg_obj, -"
$	   	wc "		lsl$dxfpar:dxfparlib/lib, -"
$	   	wc "		lsl$library:frtshr/opt, -"
$	   	wc "		lsl$library:iffshr/opt, lslshr/opt"
$!
$ nolnk:
$		wc "$ 		dxf2iex:"
$		wc "$ 		deass/group lsl$dxf2i_building"
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto dxf2iex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$dxf2i_building
$	bat dxf2ibat.com
$	goto dxf2ix2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto dxf2iex
$	deass/group lsl$dxf2i_building
$	@dxf2ibat.com
$	purge dxf2ibat.com
$	goto dxf2ix2
$ dxf2iex:
$	deass/group lsl$dxf2i_building
$ dxf2ix2:
$	if ver then set verify
$	purge *.for
$	purge *.lis
$!
