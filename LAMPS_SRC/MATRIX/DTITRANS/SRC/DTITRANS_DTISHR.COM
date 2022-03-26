$!
$! 	Command file for building DTITRANS
$!
$! 	Copyright Laser-Scan Limited, Cambridge, England.
$! 	Author  : D R Catlow
$! 	Created : 24 September 1987  
$!
$! mod1500 Add $ @lsl$source_root:[mapping.common.ifflib]def_lsl$cmniff
$!	   to define the new lsl$cmniff common blocks
$!
$! mod1533 Add lsl$cmniff:md2dat in compile list	JB 1-Mar-1996
$!	   Add ROUND_ORIGIN				JB 4-Mar-1996
$!
$	ver=f$verify(0)
$!
$! get lsl$cmniff common blocks
$! 
$! @lsl$cmniff:def_lsl$cmniff
$!
$!!! @lsl$source_root:[mapping.common.ifflib]def_lsl$cmniff
$!
$	on error then goto dtitransex
$	on control_y then goto dtitransex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$dtitrans_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto dtitransex
$	define/group lsl$dtitrans_building "in_progress"
$	open/write comfil dtitransbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$ 	set noverify"
$	wc	"$	on control_y then goto dtitransex"
$	wc	"$	if ""'","'f$logical(""lsl$dtitrans_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$a0:	define/group lsl$dtitrans_building ""in_progress"""
$	wc	"$	assign here lsl$cmndtitrans"
$	wc	"$	assign lsl$source_root:[matrix.service] lsl$matrixsys"
$	wc	"$	sd:=$lsl$sys:sd"
$	wc	"$	set noon"
$!
$	mldbg =""
$	fsw1  =""
$	kpcom =""
$	gctplib = "lsl$library:gctplib/lib"
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$	inquire/nop dtitrans_dbg "With debug ? "
$	if .not. dtitrans_dbg then goto a04
$!
$	   fsw1 ="/debug"
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
$	   dtitrans		="t"
$	   dtitrans_decode	="t"
$	   open_input_file	="t"
$	   open_control_file	="t"
$	   open_satmap_file	="t"
$	   open_output_file	="t"
$	   close_dti_files	="t"
$	   get_output_size	="t"
$	   ask_input_params	="t"
$	   ask_input_window	="t"
$	   ask_output_window	="t"
$	   ask_output_params	="t"
$	   ask_sample		="t"
$	   round_origin		="t"
$	   ask_projection	="t"
$	   ask4pt		="t"
$	   transform_coord	="t"
$	   trnuse		="t"
$	   process_dti		="t"
$	   sample		="t"
$	   outang		="t"
$	   print_proj_rec	="t"
$	   satmap_trans		="t"
$	   iff			="t"
$	   test_transform	="t"
$	   goto a11
$!
$ A05:     INQ/NOP DTITRANS	     "Compile DTITRANS,DTITRANS_INIT          ?"
$ 	   INQ/NOP DTITRANS_DECODE   "Compile DTITRANS_DECODE                 ?"
$ 	   INQ/NOP OPEN_INPUT_FILE   "Compile OPEN_INPUT_FILE                 ?"
$ 	   INQ/NOP OPEN_CONTROL_FILE "Compile OPEN_CONTROL_FILE               ?"
$ 	   INQ/NOP OPEN_SATMAP_FILE  "Compile OPEN_SATMAP_FILE                ?"
$ 	   INQ/NOP OPEN_OUTPUT_FILE  "Compile OPEN_OUTPUT_FILE                ?"
$	   INQ/NOP CLOSE_DTI_FILES   "Compile CLOSE_DTI_FILES,SET_GRID_VALUES ?"
$ 	   INQ/NOP GET_OUTPUT_SIZE   "Compile GET_OUTPUT_SIZE,PARINIT         ?"
$ 	   INQ/NOP ASK_INPUT_PARAMS  "Compile ASK_INPUT_PARAMS,SET_PROJ_REC   ?"
$ 	   INQ/NOP ASK_INPUT_WINDOW  "Compile ASK_INPUT_WINDOW                ?"
$ 	   INQ/NOP ASK_OUTPUT_WINDOW "Compile ASK_OUTPUT_WINDOW               ?"
$ 	   INQ/NOP ASK_OUTPUT_PARAMS "Compile ASK_OUTPUT_PARAMS               ?"
$	   INQ/NOP ASK_SAMPLE        "Compile ASK_SAMPLE etc.,ASK_SHIFT       ?"
$	   INQ/NOP ASK_PROJECTION    "Compile ASK_PROJECTION,ASK_PROJ_PARAMS  ?"
$	   INQ/NOP ROUND_ORIGIN      "Compile ROUND_ORIGIN                    ?"
$	   INQ/NOP ASK4PT            "Compile ASK4PT                          ?"
$	   INQ/NOP TRANSFORM_COORD   "Compile TRANSFORM_COORD                 ?"
$	   INQ/NOP TRNUSE            "Compile TRNUSE                          ?"
$	   INQ/NOP PROCESS_DTI       "Compile PROCESS_DTI,FRAMED_MES          ?"
$	   INQ/NOP SAMPLE            "Compile SAMPLE                          ?"
$	   INQ/NOP PRINT_PROJ_REC    "Compile PRINT_PROJ_REC                  ?"
$	   INQ/NOP OUTANG            "Compile OUTANG,OUTDBL etc.              ?"
$	   INQ/NOP SATMAP_TRANS      "Compile SATMAP_TRANS                    ?"
$	   INQ/NOP IFF		     "Compile IFF                             ?"
$	   INQ/NOP TEST_TRANSFORM    "Compile TEST_TRANSFORM,TEST_RESAMPLE    ?"
$!
$	   write sys$output " "
$ A11:	   inq/nop mes "Generate message definitions ? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   inquire/nop answer "Link with debug gctplib ? "
$	   if answer then -
	   gctplib = "lsl$library:gctpdlib/lib
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$	   
$	   linkver="dtitrans"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="dtitransx"
$!
$ notkb:
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		set verify"
$ 		if .not. mes then goto nomessing
$  	        wc "$ newmsg/dti/runoff/number=1641/prefix=dtrans__ dtitrans.mes"
$  		wc "$ @dtitrans.temp_com "
$ nomessing:
$	   if .not. cld then goto fortonly
$		wc "$ 		adc dtitrans.tmp=dtitrans.cld"
$		wc "$ 		set command/object=dtitrans_cld dtitrans.tmp"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dtitrans_cld"
$	      	wc "$ 		delete dtitrans.tmp;*"	
$		wc "$		purge/nolog dtitrans_cld.obj"
$	      	wc "$ 		ok=$status"	
$!	
$ fortonly:		
$	if .not. compile then goto lnkonly
$!
$ 	   if .not. dtitrans then goto a120
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc dtitrans''kpcom'=dtitrans,dtitrans_init"
$	   	wc "$ 		fort''fsw1' dtitrans"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dtitrans"
$		wc "$ 		purge/nolog dtitrans.obj"
$		if fsw1.eqs."" then -
			wc "$ 		delete dtitrans.for;*"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog dtitrans.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog dtitrans.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a120:	   if .not. dtitrans_decode then goto a130
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc dtitrans_decode''kpcom'=dtitrans_decode"
$	   	wc "$ 		fort''fsw1' dtitrans_decode"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dtitrans_decode"
$		wc "$ 		purge/nolog dtitrans_decode.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog dtitrans_decode.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete dtitrans_decode.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog dtitrans_decode.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a130:	   if .not. open_input_file then goto a133
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc open_input_file''kpcom'=open_input_file"
$	   	wc "$ 		fort''fsw1' open_input_file"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv open_input_file"
$		wc "$ 		purge/nolog open_input_file.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog open_input_file.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete open_input_file.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog open_input_file.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a133:	   if .not. open_control_file then goto a137
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc open_control_file''kpcom'=open_control_file"
$	   	wc "$ 		fort''fsw1' open_control_file"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv open_control_file"
$		wc "$ 		purge/nolog open_control_file.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog open_control_file.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete open_control_file.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog open_control_file.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a137:	   if .not. open_satmap_file then goto a140
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc open_satmap_file''kpcom'=open_satmap_file"
$	   	wc "$ 		fort''fsw1' open_satmap_file"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv open_satmap_file"
$		wc "$ 		purge/nolog open_satmap_file.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog open_satmap_file.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete open_satmap_file.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog open_satmap_file.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a140:	   if .not. open_output_file then goto a150
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc open_output_file''kpcom'=open_output_file"
$	   	wc "$ 		fort''fsw1' open_output_file"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv open_output_file"
$		wc "$ 		purge/nolog open_output_file.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog open_output_file.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete open_output_file.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog open_output_file.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a150:	   if .not. close_dti_files then goto a160
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc close_dti_files''kpcom'=close_dti_files,set_grid_values"
$	   	wc "$ 		fort''fsw1' close_dti_files"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv close_dti_files"
$		wc "$ 		purge/nolog close_dti_files.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog close_dti_files.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete close_dti_files.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog close_dti_files.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a160:	   if .not. get_output_size then goto a170
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc get_output_size''kpcom'=get_output_size,parinit"
$	   	wc "$ 		fort''fsw1' get_output_size"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv get_output_size"
$		wc "$ 		purge/nolog get_output_size.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog get_output_size.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete get_output_size.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog get_output_size.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a170:	   if .not. ask_input_params then goto a175
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc ask_input_params''kpcom'=ask_input_params,set_proj_rec"
$	   	wc "$ 		fort''fsw1' ask_input_params"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv ask_input_params"
$		wc "$ 		purge/nolog ask_input_params.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog ask_input_params.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete ask_input_params.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog ask_input_params.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a175:	   if .not. ask_input_window then goto a178
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc ask_input_window''kpcom'=ask_input_window"
$	   	wc "$ 		fort''fsw1' ask_input_window"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv ask_input_window"
$		wc "$ 		purge/nolog ask_input_window.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog ask_input_window.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete ask_input_window.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog ask_input_window.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a178:	   if .not. ask_output_window then goto a180
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc ask_output_window''kpcom'=ask_output_window"
$	   	wc "$ 		fort''fsw1' ask_output_window"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv ask_output_window"
$		wc "$ 		purge/nolog ask_output_window.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog ask_output_window.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete ask_output_window.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog ask_output_window.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a180:	   if .not. ask_output_params then goto a185
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc ask_output_params''kpcom'=ask_output_params"
$	   	wc "$ 		fort''fsw1' ask_output_params"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv ask_output_params"
$		wc "$ 		purge/nolog ask_output_params.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog ask_output_params.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete ask_output_params.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog ask_output_params.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a185:	   if .not. ask4pt then goto a190
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc ask4pt''kpcom'=ask4pt"
$	   	wc "$ 		fort''fsw1' ask4pt"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv ask4pt"
$		wc "$ 		purge/nolog ask4pt.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog ask4pt.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete ask4pt.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog ask4pt.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a190:	   if .not. ask_sample then goto a195
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc ask_sample''kpcom'=ask_sample,ask_spheroid,ask_shift"
$		wc "$ 		adc ask_sample/ap=ask_origin,ask_units
$	   	wc "$ 		fort''fsw1' ask_sample"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv ask_sample"
$		wc "$ 		purge/nolog ask_sample.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog ask_sample.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete ask_sample.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog ask_sample.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a195:	   if .not. round_origin then goto a200
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc round_origin''kpcom'=round_origin"
$	   	wc "$ 		fort''fsw1' round_origin"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv round_origin"
$		wc "$ 		purge/nolog round_origin.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog round_origin.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete round_origin.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog round_origin.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a200:	   if .not. process_dti then goto a210
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc process_dti''kpcom'=process_dti,framed_mes"
$	   	wc "$ 		fort''fsw1' process_dti"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv process_dti"
$		wc "$ 		purge/nolog process_dti.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog process_dti.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete process_dti.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog process_dti.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a210:	   if .not. sample then goto a220
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc sample''kpcom'=sample"
$	   	wc "$ 		fort''fsw1' sample"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv sample"
$		wc "$ 		purge/nolog sample.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog sample.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete sample.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog sample.lis"
$		wc "$ 		delete adc.ide;*"
$ a220:	   if .not. print_proj_rec then goto a230
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc print_proj_rec''kpcom'=print_proj_rec"
$	   	wc "$ 		fort''fsw1' print_proj_rec"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv print_proj_rec"
$		wc "$ 		purge/nolog print_proj_rec.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog print_proj_rec.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete print_proj_rec.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog print_proj_rec.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a230:	   if .not. outang then goto a235
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc outang''kpcom'=outang,outdbl"
$		wc "$		adc outang/ap=dblqu,dmsqu,angqu,rdang"
$		wc "$		adc outang/ap=dtitransexcp,eqrad
$	   	wc "$ 		fort''fsw1' outang"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv outang"
$		wc "$ 		purge/nolog outang.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog outang.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete outang.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog outang.lis"
$		wc "$ 		delete adc.ide;*"
$
$ a235:	   if .not. satmap_trans then goto a237
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc satmap_trans''kpcom'=satmap_trans"
$	   	wc "$ 		fort''fsw1' satmap_trans"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv satmap_trans"
$		wc "$ 		purge/nolog satmap_trans.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog satmap_trans.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete satmap_trans.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog satmap_trans.lis"
$		wc "$ 		delete adc.ide;*"
$
$ a237:	   if .not. iff then goto a240
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc iff''kpcom'=iff"
$	   	wc "$ 		fort''fsw1' iff"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv iff"
$		wc "$ 		purge/nolog iff.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog iff.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete iff.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog iff.lis"
$		wc "$ 		delete adc.ide;*"
$
$ a240:	   if .not. ask_projection then goto a250
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$		adc ask_projection''kpcom'=ask_projection
$               wc "$		adc ask_projection/ap=ask_proj_params,spshlp"
$	   	wc "$		fort''fsw1' ask_projection"
$	      	wc "$		ok=$status"	
$		wc "$		if ok then pvv ask_projection"
$		wc "$		purge/nolog ask_projection.obj"
$		if fsw1.nes."" then -
			wc "$		purge/nolog ask_projection.for"
$		if fsw1.eqs."" then -
			wc "$		delete ask_projection.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$		purge/nolog ask_projection.lis"
$		wc "$		delete adc.ide;*"
$!
$ a250:	   if .not. transform_coord then goto a260
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$		adc transform_coord''kpcom'=transform_coord"
$	   	wc "$		fort''fsw1' transform_coord"
$	      	wc "$		ok=$status"	
$		wc "$		if ok then pvv transform_coord"
$		wc "$		purge/nolog transform_coord.obj"
$		if fsw1.nes."" then -
			wc "$		purge/nolog transform_coord.for"
$		if fsw1.eqs."" then -
			wc "$		delete transform_coord.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$		purge/nolog transform_coord.lis"
$		wc "$		delete adc.ide;*"
$!
$ a260:	   if .not. trnuse then goto a265
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$		adc trnuse''kpcom'=trnuse"
$	   	wc "$		fort''fsw1' trnuse"
$	      	wc "$		ok=$status"	
$		wc "$		if ok then pvv trnuse"
$		wc "$		purge/nolog trnuse.obj"
$		if fsw1.nes."" then -
			wc "$		purge/nolog trnuse.for"
$		if fsw1.eqs."" then -
			wc "$		delete trnuse.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$		purge/nolog trnuse.lis"
$		wc "$		delete adc.ide;*"
$!
$ a265:	   if .not. test_transform then goto a270
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$		adc test_transform ''kpcom'=test_transform,test_resample"
$	   	wc "$		fort''fsw1' test_transform"
$	      	wc "$		ok=$status"	
$		wc "$		if ok then pvv test_transform"
$		wc "$		purge/nolog test_transform.obj"
$		if fsw1.nes."" then -
			wc "$		purge/nolog test_transform.for"
$		if fsw1.eqs."" then -
			wc "$		delete test_transform.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$		purge/nolog test_transform.lis"
$		wc "$		delete adc.ide;*"
$!
$ a270:
$!
$ lnkonly:
$ if (.not.lnkit) then goto nolnk
$		wc "$ run lsl$exe:genver"
$		wc "$ adc version=version"
$		wc "$ fort version"
$		wc "$ pvv  version"
$		wc "$ purge/nolog version.*"
$		wc "$ delete adc.ide;*"
$!
$		wc "$ adc lnk = lsl$cmniff:md2dat"
$		wc "$ fort lnk"
$		wc "$ pvv lnk"
$		wc "$ purge/nolog lnk.*"
$		wc "$ delete adc.ide;*"
$!
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		link''linkopts'/exe=''linkver' dtitrans, -"
$		wc "		dtitrans_cld,lnk, -"
$	   	wc "		version,dtitrans_decode,-"
$		wc "		open_input_file,open_output_file,-"
$		wc "		open_control_file,open_satmap_file,-"
$	        wc "		close_dti_files,get_output_size,-"
$               wc "		ask_input_params,ask_output_params,-"
$               wc "		ask_input_window,-"
$               wc "		ask_output_window,-"
$               wc "		round_origin,-"
$               wc "		ask_sample,process_dti,sample,-"
$               wc "		ask_projection,ask4pt,-"
$	        wc "		print_proj_rec,outang,-"
$	        wc "		satmap_trans,test_transform,-"
$	        wc "		iff,transform_coord,trnuse,-"
$		wc "		dtitrans.promsg_obj, -"
$		wc "		lsl$matrixsys:matrix/lib,-"
$	   	wc "		lsl$library:dtishr/opt, -"
$		wc "		''gctplib', -"
$		wc "		lsl$library:tranlib/lib, -"
$		wc "		lsl$library:lsllib.olb/include=(lsl_rddble_cmpt,lsl_rdsign),-"
$	   	wc "		lsl$library:iffshr/opt,lslshr/opt"
$!!!	   	wc "		lsl$library:iffshr/opt,lslshr/opt, -"
$!!!	   	wc "		lsl$library:lsllib/lib"
$!
$ nolnk:
$		wc "$ 		dtitransex:"
$		wc "$ 		deass/group lsl$dtitrans_building"
$		wc "$ 		set nover"
$!
$               wc "$           purge/nolog *.map,*.com"
$!
$ filclo:
$	set noverify
$	on error then goto dtitransex
$	on control_y then goto dtitransex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$dtitrans_building
$	bat dtitransbat.com
$	goto dtitransx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto dtitransex
$	deass/group lsl$dtitrans_building
$	@dtitransbat.com
$	goto dtitransx2
$!
$ dtitransex:
$	deass/group lsl$dtitrans_building
$!
$ dtitransx2:
$	if ver then set verify
$!
