$!
$	ver=f$verify(0)
$!
$! Copyright Laser-Scan Limited, Cambridge, England.
$!
$!	Created      				JB 17-Sep-1988
$!
$!	Mod 1435 Use new frtshr			JB 25-Nov-1994
$!
$! Command file for building KERNCAM2I
$!
$	on error then goto kerncam2iex
$	on control_y then exit
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$kerncam2i_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$ a0:	on control_y then goto kerncam2iex
$	define/group lsl$kerncam2i_building "in_progress"
$	open/write comfil kerncam2ibat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$ 	set noverify"
$	wc	"$	on control_y then goto kerncam2iex"
$	wc	"$	if ""'","'f$logical(""lsl$kerncam2i_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$ a0:	define/group lsl$kerncam2i_building ""in_progress"""
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$	inquire/nop kerncam2i_dbg "With Debug ? "
$	if .not. kerncam2i_dbg then goto a04
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
$	   kerncam2i="t"
$	   kerncam2i_init="t"
$	   getcomlin="t"
$	   open_files="t"
$          read_kern_header="t"
$          read_kern_main="t"
$          output_iff_header="t"
$          output_iff_feature="t"
$          output_network="t"
$          output_arc="t"
$          output_iff_symbol="t"
$          read_line="t"
$          read_coord_line="t"
$          read_integer="t"
$          read_double="t"
$          read_real="t"
$          update_range="t"
$          end_feature="t"
$          end_layer="t"
$	   close_files="t"
$!
$	   goto a11
$!
$ a05:
$	   INQ/NOP KERNCAM2I          	"Compile KERNCAM2I? "
$	   INQ/NOP KERNCAM2I_INIT     	"Compile KERNCAM2I_INIT? "
$	   INQ/NOP GETCOMLIN          	"Compile GETCOMLIN? "
$	   INQ/NOP OPEN_FILES         	"Compile OPEN_FILES? "
$          INQ/NOP READ_KERN_HEADER   	"Compile READ_KERN_HEADER? "
$          INQ/NOP READ_KERN_MAIN     	"Compile READ_KERN_MAIN? "
$          INQ/NOP OUTPUT_IFF_HEADER  	"Compile OUTPUT_IFF_HEADER? "
$          INQ/NOP OUTPUT_IFF_FEATURE 	"Compile OUTPUT_IFF_FEATURE? "
$          INQ/NOP OUTPUT_NETWORK	"Compile OUTPUT_NETWORK? "
$          INQ/NOP OUTPUT_ARC		"Compile OUTPUT_ARC? "
$          INQ/NOP OUTPUT_IFF_SYMBOL    "Compile OUTPUT_IFF_SYMBOL? "
$          INQ/NOP READ_LINE          	"Compile READ_LINE? "
$          INQ/NOP READ_COORD_LINE    	"Compile READ_COORD_LINE? "
$          INQ/NOP READ_INTEGER 	"Compile READ_INTEGER? "
$          INQ/NOP READ_DOUBLE  	"Compile READ_DOUBLE? "
$          INQ/NOP READ_REAL    	"Compile READ_REAL? "
$          INQ/NOP UPDATE_RANGE         "Compile UPDATE_RANGE? "
$          INQ/NOP END_FEATURE  	"Compile END_FEATURE? "
$          INQ/NOP END_LAYER    	"Compile END_LAYER? "
$	   INQ/NOP CLOSE_FILES  	"Compile CLOSE_FILES? "
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
$	   linkver="kerncam2i"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="kerncam2ix"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$	   
$ notkb:
$!
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		set verify"
$ 		if .not. mes then goto nomessing
$		wc "$	newmsg kerncam2i.mes/num=1619/name=kerncam2i/pre=kern2i__/par=for/runoff"
$		wc "$	@kerncam2i.temp_com"
$ nomessing:
$	   if .not. cld then goto fortonly
$		wc "$ 		adc kerncam2i.tmp=kerncam2i.cld"
$		wc "$ 		set command/object=kerncam2i_cld kerncam2i.tmp"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv kerncam2i_cld"
$		wc "$ 		if ok then delete kerncam2i.tmp;*"
$		wc "$ 		if ok then purge/nolog kerncam2i_cld.obj"
$	
$ fortonly:		
$	if .not. compile then goto lnkonly
$!
$          if .not. kerncam2i then goto a100
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		adc kerncam2i''kpcom'=kerncam2i"
$	   	wc "$ 		fort''fsw1' kerncam2i"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv kerncam2i"
$		wc "$	 	purge/nolog kerncam2i.obj"
$		if fsw1.eqs.""  then -
			wc "$ 		delete/nolog kerncam2i.for;*"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog kerncam2i.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog kerncam2i.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a100:	   if .not. kerncam2i_init then goto a105
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		adc kerncam2i_init''kpcom'=kerncam2i_init"
$	   	wc "$ 		fort''fsw1' kerncam2i_init"
$	      	wc "$ 		ok=$status"
$		wc "$ 		if ok then pvv kerncam2i_init"
$		wc "$ 		purge/nolog kerncam2i_init.obj"
$		if fsw1.eqs.""  then -
			wc "$ 		delete/nolog kerncam2i_init.for;*"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog kerncam2i_init.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog kerncam2i_init.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a105:	   if .not. getcomlin then goto a110
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc getcomlin''kpcom'=getcomlin"
$	   	wc "$ 		fort''fsw1' getcomlin"
$	      	wc "$ 		ok=$status"
$		wc "$ 		if ok then pvv getcomlin"
$		wc "$ 		purge/nolog getcomlin.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog getcomlin.for"
$		if fsw1.eqs.""  then -
			wc "$ 		delete/nolog getcomlin.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog getcomlin.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a110:	   if .not. open_files then goto a115
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc open_files''kpcom'=open_files"
$	   	wc "$ 		fort''fsw1' open_files"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv open_files"
$		wc "$ 		purge/nolog open_files.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog open_files.for"
$		if fsw1.eqs.""  then -
			wc "$ 		delete/nolog open_files.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog open_files.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a115:	   if .not. read_kern_header then goto a118
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc read_kern_header''kpcom'=read_kern_header"
$	   	wc "$ 		fort''fsw1' read_kern_header"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv read_kern_header"
$		wc "$ 		purge/nolog read_kern_header.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog read_kern_header.for"
$		if fsw1.eqs.""  then -
			wc "$ 		delete/nolog read_kern_header.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog read_kern_header.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a118:	   if .not. read_kern_main then goto a120
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc read_kern_main''kpcom'=read_kern_main"
$	   	wc "$ 		fort''fsw1' read_kern_main"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv read_kern_main"
$		wc "$ 		purge/nolog read_kern_main.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog read_kern_main.for"
$		if fsw1.eqs.""  then -
			wc "$ 		delete/nolog read_kern_main.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog read_kern_main.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a120:	   if .not. output_iff_header then goto a122
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc output_iff_header''kpcom'=output_iff_header"
$	   	wc "$ 		fort''fsw1' output_iff_header"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv output_iff_header"
$		wc "$ 		purge/nolog output_iff_header.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog output_iff_header.for"
$		if fsw1.eqs.""  then -
			wc "$ 		delete/nolog output_iff_header.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
 	  	 	wc "$ 		purge/nolog output_iff_header.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a122:	   if .not. output_iff_feature then goto a123
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc output_iff_feature''kpcom'=output_iff_feature"
$	   	wc "$ 		fort''fsw1' output_iff_feature"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv output_iff_feature"
$		wc "$ 		purge/nolog output_iff_feature.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog output_iff_feature.for"
$		if fsw1.eqs.""  then -
			wc "$ 		delete/nolog output_iff_feature.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
 	  	 	wc "$ 		purge/nolog output_iff_feature.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a123:	   if .not. output_network then goto a124
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc output_network''kpcom'=output_network"
$	   	wc "$ 		fort''fsw1' output_network"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv output_network"
$		wc "$ 		purge/nolog output_network.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog output_network.for"
$		if fsw1.eqs.""  then -
			wc "$ 		delete/nolog output_network.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
 	  	 	wc "$ 		purge/nolog output_network.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a124:	   if .not. output_arc then goto a125
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc output_arc''kpcom'=output_arc"
$	   	wc "$ 		fort''fsw1' output_arc"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv output_arc"
$		wc "$ 		purge/nolog output_arc.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog output_arc.for"
$		if fsw1.eqs.""  then -
			wc "$ 		delete/nolog output_arc.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
 	  	 	wc "$ 		purge/nolog output_arc.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a125:	   if .not. output_iff_symbol then goto a126
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc output_iff_symbol''kpcom'=output_iff_symbol"
$	   	wc "$ 		fort''fsw1' output_iff_symbol"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv output_iff_symbol"
$		wc "$ 		purge/nolog output_iff_symbol.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog output_iff_symbol.for"
$		if fsw1.eqs.""  then -
			wc "$ 		delete/nolog output_iff_symbol.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
 	  	 	wc "$ 		purge/nolog output_iff_symbol.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a126:	   if .not. read_line then goto a128
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc read_line''kpcom'=read_line"
$	   	wc "$ 		fort''fsw1' read_line"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv read_line"
$		wc "$ 		purge/nolog read_line.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog read_line.for"
$		if fsw1.eqs.""  then -
			wc "$ 		delete/nolog read_line.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog read_line.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a128:	   if .not. read_coord_line then goto a130
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc read_coord_line''kpcom'=read_coord_line"
$	   	wc "$ 		fort''fsw1' read_coord_line"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv read_coord_line"
$		wc "$ 		purge/nolog read_coord_line.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog read_coord_line.for"
$		if fsw1.eqs.""  then -
			wc "$ 		delete/nolog read_coord_line.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog read_coord_line.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a130:	   if .not. read_integer then goto a131
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc read_integer''kpcom'=read_integer"
$	   	wc "$ 		fort''fsw1' read_integer"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv read_integer"
$		wc "$ 		purge/nolog read_integer.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog read_integer.for"
$		if fsw1.eqs.""  then -
			wc "$ 		delete/nolog read_integer.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog read_integer.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a131:	   if .not. read_double then goto a132
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc read_double''kpcom'=read_double"
$	   	wc "$ 		fort''fsw1' read_double"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv read_double"
$		wc "$ 		purge/nolog read_double.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog read_double.for"
$		if fsw1.eqs.""  then -
			wc "$ 		delete/nolog read_double.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog read_double.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a132:	   if .not. read_real then goto a135
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc read_real''kpcom'=read_real"
$	   	wc "$ 		fort''fsw1' read_real"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv read_real"
$		wc "$ 		purge/nolog read_real.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog read_real.for"
$		if fsw1.eqs.""  then -
			wc "$ 		delete/nolog read_real.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog read_real.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a135:	   if .not. update_range then goto a137
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc update_range''kpcom'=update_range"
$	   	wc "$ 		fort''fsw1' update_range"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv update_range"
$		wc "$ 		purge/nolog update_range.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog update_range.for"
$		if fsw1.eqs.""  then -
			wc "$ 		delete/nolog update_range.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog update_range.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a137:	   if .not. end_feature then goto a138
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc end_feature''kpcom'=end_feature"
$	   	wc "$ 		fort''fsw1' end_feature"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv end_feature"
$		wc "$ 		purge/nolog end_feature.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog end_feature.for"
$		if fsw1.eqs.""  then -
			wc "$ 		delete/nolog end_feature.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog end_feature.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a138:	   if .not. end_layer then goto a140
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc end_layer''kpcom'=end_layer"
$	   	wc "$ 		fort''fsw1' end_layer"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv end_layer"
$		wc "$ 		purge/nolog end_layer.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog end_layer.for"
$		if fsw1.eqs.""  then -
			wc "$ 		delete/nolog end_layer.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog end_layer.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a140:	   if .not. close_files then goto a200
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc close_files''kpcom'=close_files"
$	   	wc "$ 		fort''fsw1' close_files"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv close_files"
$		wc "$ 		purge/nolog close_files.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog close_files.for"
$		if fsw1.eqs.""  then -
			wc "$ 		delete/nolog close_files.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog close_files.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a200:
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$	link''linkopts'/exe=''linkver' -"
$		wc "    kerncam2i,-"
$               wc "    kerncam2i_cld,-"
$               wc "    kerncam2i_init,-"
$               wc "    getcomlin,-"
$               wc "    open_files,-"
$               wc "    read_kern_header,-"
$               wc "    read_kern_main,-"
$               wc "    output_iff_header,-"
$               wc "    output_iff_feature,-"
$               wc "    output_network,-"
$		wc "    output_arc,-"
$               wc "    output_iff_symbol,-"
$               wc "    read_integer,-"
$               wc "    read_double,-"
$               wc "    read_real,-"
$               wc "    read_line,-"
$               wc "    read_coord_line,-"
$               wc "    update_range,-"
$               wc "    end_feature,-"
$               wc "    end_layer,-"
$               wc "    close_files,-"
$	        wc "    kerncam2i.promsg_obj,-"
$               wc "    lsl$library:iffshr.opt/opt,-"
$               wc "    lsl$library:lslshr.opt/opt,-"
$               wc "    lsl$library:frtshr.opt/opt"
$!
$ nolnk:
$		wc "$ 		kerncam2iex:"
$		wc "$ 		deass/group lsl$kerncam2i_building"
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto kerncam2iex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$kerncam2i_building
$	bat kerncam2ibat.com
$	goto kerncam2ix2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto kerncam2iex
$	deass/group lsl$kerncam2i_building
$	@kerncam2ibat.com
$	goto kerncam2ix2
$!
$ kerncam2iex:
$	deass/group lsl$kerncam2i_building
$!
$ kerncam2ix2:
$	if ver then set verify
$!
