$!
$	set noverify
$	on error     then goto exit_neatly
$	on control_y then goto exit_neatly
$!
$! command file: OSTF2I - a command file to build the OSTF2I program
$!
$! Copyright (C) Laser-Scan Ltd, Cambridge, England  1985
$!
$! Author TJ Ibbs, 30 April 1986
$!
$! Mod 1435 Use new frtshr				JB 23-Nov-1994
$!
$! *************************************************************************
$!
$	define  cmn  'f$logical("HERE")
$!
$	wsb = "write sys$output """""
$!
$	if P1.eqs."" then -
	  inquire P1 "Compile with debug                      "
$	if P1.eqs."" then P1 = "N"
$!
$	debug = P1
$!
$	wsb
$	inquire cld  "Command line definition                 "
$	inquire msg  "Messages                                "
$	wsb
$	inquire main "Main routine  - ostf2i                  "
$	inquire cmd  "Command line  - cmdline                 "
$	inquire rep  "Report cmds   - report                  "
$	inquire proc "Main loop     - process                 "
$	inquire indx "Index         - do_index,back_sp        "
$	inquire sht  "Start sheet   - start_sheet             "
$	inquire fin  "Find codes    - find_codes              "
$	inquire ftr  "Start feature - start_feature           "
$	inquire mh2  "Map header    - map_header,to_binday    "
$	inquire mh3  "Copy header   - copy_to_mh              "
$	inquire name "Sheet name    - os_name                 "
$	inquire grid "Grid          - osgrid                  "
$	inquire read "Read records  - getrec                  "
$	inquire cord "Coordinates   - coord,flush,check_range "
$	inquire ptsz "Point sizes   - ptsize                  "
$	inquire sca  "Scaled symbol - scasym                  "
$	inquire skip "Skip things   - skip_xxx                "
$	inquire plus "Detect OSTF+  - find_plus               "
$	wsb
$	inquire lnk  "Link                                    "
$	inquire lbg  "Link with debug                         "
$	wsb
$!
$	ldbg="/notraceback/map"
$	dbg = ""
$	pd  = "delete"
$	ver = ";*"
$	if lbg   then ldbg= "/debug"
$	if debug then dbg = "/debug/noopt/check"
$	if debug then pd  = "purge"
$	if debug then ver = ""
$!
$	set verify
$	if .not.cld then goto no_cld
$	   adc   ostf2i.TMP=ostf2i.CLD
$	   set command/object=ostf2i_cld  ostf2i.TMP
$	   pvv   ostf2i_cld
$	   purge ostf2i_cld.OBJ
$	   delete ADC.IDE;*
$	   delete ostf2i.TMP;*
$no_cld:
$	if .not.msg then goto no_msg
$	   newmsg  OSTF2I/number=1603/runoff/hl=2
$	   @OSTF2I.temp_com
$	   purge OSTF2IMSG.rno
$no_msg:
$	if .not.main then goto no_main
$	   adc   ostf2i/co=ostf2i
$	   fortran/extend'dbg' ostf2i
$	   pvv   ostf2i
$	   purge ostf2i.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' ostf2i.FOR'ver'
$no_main:
$	if .not.cmd then goto no_cmd
$	   adc   cmdline/co=cmdline
$	   fortran/extend'dbg' cmdline
$	   pvv   cmdline
$	   purge cmdline.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' cmdline.FOR'ver'
$no_cmd:
$	if .not.rep then goto no_rep
$      	   adc   report/co=report
$	   fortran/extend'dbg' report
$	   pvv   report
$	   purge report.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' report.FOR'ver'
$no_rep:
$	if .not.proc then goto no_proc
$	   adc   process/co=process
$	   fortran/extend'dbg' process
$	   pvv   process
$	   purge process.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' process.FOR'ver'
$no_proc:
$	if .not.indx then goto no_indx
$	   adc   do_index/co=do_index,backspace
$	   fortran/extend'dbg' do_index
$	   pvv   do_index
$	   purge do_index.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' do_index.FOR'ver'
$no_indx:
$	if .not.sht then goto no_sht
$	   adc   start_sheet/co=start_sheet
$	   fortran/extend'dbg' start_sheet
$	   pvv   start_sheet
$	   purge start_sheet.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' start_sheet.FOR'ver'
$no_sht:
$	if .not.fin then goto no_fin
$	   adc   find_codes/co=find_codes
$	   fortran/extend'dbg' find_codes
$	   pvv   find_codes
$	   purge find_codes.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' find_codes.FOR'ver'
$no_fin:
$	if .not.ftr then goto no_ftr
$	   adc   start_feature/co=start_feature
$	   fortran/extend'dbg' start_feature
$	   pvv   start_feature
$	   purge start_feature.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' start_feature.FOR'ver'
$no_ftr:
$	if .not.mh2 then goto no_mh2
$	   adc   map_header/co=map_header,to_binday
$	   fortran/extend'dbg' map_header
$	   pvv   map_header
$	   purge map_header.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' map_header.FOR'ver'
$no_mh2:
$	if .not.mh3 then goto no_mh3
$	   adc   copy_to_mh/co=copy_to_mh
$	   fortran/extend'dbg' copy_to_mh
$	   pvv   copy_to_mh
$	   purge copy_to_mh.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' copy_to_mh.FOR'ver'
$no_mh3:
$	if .not.name then goto no_name
$	   adc   os_name/co=os_name
$	   fortran/extend'dbg' os_name
$	   pvv   os_name
$	   purge os_name.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' os_name.FOR'ver'
$no_name:
$	if .not.grid then goto no_grid
$	   adc   osgrid/co=osgrid
$	   fortran/extend'dbg' osgrid
$	   pvv   osgrid
$	   purge osgrid.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' osgrid.FOR'ver'
$no_grid:
$	if .not.read then goto no_read
$	   adc   getrec/co=getrec
$	   fortran/extend'dbg' getrec
$	   pvv   getrec
$	   purge getrec.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' getrec.FOR'ver'
$no_read:
$	if .not.cord then goto no_cord
$	   adc   coord/co=coord,flush,check_range
$	   fortran/extend'dbg' coord
$	   pvv   coord
$	   purge coord.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' coord.FOR'ver'
$no_cord:
$	if .not.ptsz then goto no_ptsz
$	   adc   ptsize/co=ptsize
$	   fortran/extend'dbg' ptsize
$	   pvv   ptsize
$	   purge ptsize.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' ptsize.FOR'ver'
$no_ptsz:
$	if .not.sca then goto no_sca
$	   adc   scasym/co=scasym
$	   fortran/extend'dbg' scasym
$	   pvv   scasym
$	   purge scasym.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' scasym.FOR'ver'
$no_sca:
$	if .not.skip then goto no_skip
$	   adc   skip_xxx/co=skip_map,skip_ftr,skip_mh
$	   fortran/extend'dbg' skip_xxx
$	   pvv   skip_xxx
$	   purge skip_xxx.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' skip_xxx.FOR'ver'
$no_skip:
$	if .not.plus then goto no_plus
$	   adc   find_plus/co=find_plus
$	   fortran/extend'dbg' find_plus
$	   pvv   find_plus
$	   purge find_plus.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' find_plus.FOR'ver'
$no_plus:
$do_link:
$	if .not.lnk then goto exit_neatly
$!
$	link'ldbg'	ostf2i,cmdline,report,process,do_index,start_sheet, -
			find_codes,start_feature,map_header,os_name,osgrid, -
			getrec,coord,ptsize,scasym,skip_xxx,find_plus, -
			copy_to_mh, -
			ostf2i_cld, -
			ostf2i.promsg_obj, -
			lsl$library:osmhlib/lib, -
			lsl$library:frtshr/opt, -
			lsl$library:iffshr/opt, -
			lsl$library:lslshr/opt
$	purge ostf2i.*
$!
$exit_neatly:
$	set noverify
$!
