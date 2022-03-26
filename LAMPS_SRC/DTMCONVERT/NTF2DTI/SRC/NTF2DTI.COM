$!
$! command file: NTF2DTI - a command file to build the NTF2DTI program
$!
$! Copyright (C) Laser-Scan Ltd, Cambridge, England  1985
$!
$! Author I McLeman 8 April 1988
$!
$! added subroutine COMPILE which does the compilation process provided it is 
$! given the target file and the consituent files. This cuts the size of this
$! file to managable proportions			SG  16-Aug-1991
$!
$! Change READ_RECORD to READ_NTF_RECORD from NTF2I	JB  18-May-1992
$!
$! *************************************************************************
$!
$	set noverify
$	on error     then goto exit_neatly
$	on control_y then goto exit_neatly
$!
$	wsb = "write sys$output """""
$!
$!.............................................................................
$!
$	inquire debug "compile with debug                                      "
$	if debug.eqs."" then debug = "N"
$!
$	wsb
$	inquire cld  "Command line definition                                 "
$	inquire msg  "Messages                                                "
$	wsb
$	inquire main "Main routine     - ntf2dti                              "
$	inquire cmd  "Command line     - cmdlin                               "
$	inquire fils "Files            - open_ntf/log,close_ntf/log           "
$	inquire grid "Grid             - read_gridhrec,gridrec                "
$	inquire misc "Miscellaneous    - comment,check_fname,read_datadesc    "
$	inquire recs "Records          - read_ntf_record,continue,recognised  "
$	inquire sec  "Section          - read_section,sechrec,secqual         "
$	inquire vol1 "Volume           - read_ntf,volhdrec,volterm,mount_tape "
$	inquire vol2 "Volume(database) - read_dbqual,dbhrec,featclass         "
$	inquire dti  "Write DTI files  - dti_write                            "
$	wsb
$	inquire lnk  "Link                                                    "
$	inquire lbg  "Link with debug                                         "
$	wsb
$!
$!.............................................................................
$!
$	ldbg="/map"
$	if debug then ldbg="/map/debug"
$	dbg = ""
$	pd  = "delete"
$	ver = ";*"
$	if debug then dbg = "/debug/noopt/list"
$	if debug then pd  = "purge"
$	if debug then ver = ""
$!
$!.............................................................................
$!
$	set verify
$	if cld
$	then
$	   adc   ntf2dti_cld.tmp=ntf2dti_cld.cld
$	   set command/object=ntf2dti_cld  ntf2dti_cld.tmp
$	   pvv   ntf2dti_cld
$	   purge ntf2dti_cld.obj
$	   delete adc.ide;*
$	   delete ntf2dti_cld.tmp;*
$	endif
$!
$	if msg
$	then
$	   newmsg  ntf2dti/number=1673/runoff/dti
$	   @ntf2dti.temp_com
$	   purge ntf2dtimsg.*
$	endif
$!
$!.............................................................................
$!
$compile:subroutine
$!
$	on error     then exit 4
$	on control_y then exit 4
$	wsb
$	set verify
$	adc   'p1'/co ='p2'
$	fortran/extend'dbg' 'p1'
$	pvv   'p1'
$	purge 'p1'.obj
$	purge 'p1'.lis
$	delete adc.ide;*
$	'pd' 'p1'.for'ver'  
$	set noverify
$	wsb
$!
$endsubroutine
$!
$!.............................................................................
$!
$	set noverify
$!
$	if cmd  then call compile "cmdlin" -
				"cmdlin"
$	if fils then call compile "files" -
				"open_ntf,open_log,close_log,close_ntf"
$	if grid then call compile "grid" -
				"read_gridhrec,read_gridrec"
$	if main then call compile "ntf2dti" -
				"ntf2dti"
$	if misc then call compile "misc" -
				"read_comment, check_fname, read_datadesc"
$	if recs then call compile "records" -
				"read_ntf_record,read_continue,recognised"
$	if sec then call compile "section" -
				"read_section,read_sechrec,read_secqual"
$	if vol1 then call compile "volume1" -
				"read_ntf,read_volhdrec,read_volterm,mount_tape"
$	if vol2 then call compile "volume2" -
				"read_dbqual,read_dbhrec,read_featclass"
$	if dti then call compile "write_dti" -
				"dti_write"
$!
$!.............................................................................
$!
$do_link:
$	set verify
$	if .not.lnk then goto exit_neatly
$!
$	link'ldbg'	ntf2dti,cmdlin,grid,files, -
			volume1,volume2,section, -
			write_dti,records,misc, -
			ntf2dti_cld, -
			ntf2dti.promsg_obj, -
			lsl$library:dtilib/lib, -
			lsl$library:lslshr/opt
$!	purge ntf2dti.*
$!
$!.............................................................................
$!
$exit_neatly:
$	purge ntf2dti.map
$	set verify
$!
