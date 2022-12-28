$	set noverify            
$	on control_y then goto end
$	on error     then goto end
$!
$! command file: I2SXF - a command file to build the I2SXF program
$!
$! Copyright (C) LaserScan Ltd, Cambridge, England
$!
$! Author R J Hulme, 10 May 1990
$!
$! *************************************************************************
$!
$	wsb = "write sys$output """""
$!
$	define	LSL$CMNI2SXF	'f$logical("HERE")
$!
$	if P1.eqs."" then -
  	inquire P1  "Compile with debug "
$	if P1.eqs."" then P1 = "N"
$!
$	debug = P1
$	rno = 0
$!
$	wsb
$	inquire cld "cld module                                    "
$	inquire mes "messages                                      "
$	if mes then -
	inquire rno "runoff file                                   "
$	wsb
$	inquire mai "i2sxf          (i2sxf)                        "
$ 	inquire cmd "commands       (get_command)                  "
$	inquire par "parameter file (rdpar,rdsxd)                  "
$	inquire iff "IFF file       (close_iff)                    "
$	inquire prc "process        (process)                      "
$	inquire ini "init           (report,find_codes)            "
$	wsb
$	inquire lnk "link            "
$	inquire lbg "link with debug "
$	wsb
$!
$	ldbg="/map"
$	dbg = ""
$	mdbg = ""
$	run = ""
$	if lbg   then ldbg= "/debug"
$	if debug then dbg = "/debug/noopt/check"
$	if debug then mdbg = "/debug"
$	if rno   then run = "/runoff/hl=2"
$!
$	set verify
$      	if .not.mes then goto nomes
$	   newmsg  I2SXF/number=1625'run'
$	   @I2SXF.temp_com
$	   if rno then purge I2SXFMSG.rno
$!
$nomes:	if .not.cld then goto nocld
$	   adc   i2sxf.TMP=i2sxf.CLD
$ 	   set command/object=i2sxf_cld  i2sxf.TMP
$	   pvv   i2sxf_cld
$	   purge i2sxf_cld.OBJ
$	   delete adc.ide;*
$	   delete *.TMP;*            
$!
$nocld:	if .not.mai then goto nomai
$	   fort/extend'dbg' i2sxf.f
$	   purge i2sxf.obj
$!
$nomai:	if .not.cmd then goto nocmd
$	   fort/extend'dbg' get_command.f
$	   purge get_command.obj
$!
$nocmd:	if .not.par then goto nopar
$	   fort/extend'dbg' rdpar.f+rdsxd.f
$	   macro'mbug' parcmd
$	   append parcmd.obj rdpar.obj
$	   delete parcmd.obj;*
$	   purge rdpar.obj
$!
$nopar:	if .not.iff then goto noiff
$	   fort/extend'dbg' close_iff.f
$	   purge close_iff.obj
$!
$noiff:	if .not.prc then goto noprc
$	   fort/extend'dbg' process.f
$	   purge process.obj
$!
$noprc:	if .not.ini then goto noini
$	   fort/extend'dbg' report.f
$	   purge report.obj
$!
$noini:	if .not.lnk then goto end
$!
$lnk:	link'ldbg'	i2sxf,get_command,rdpar,close_iff,report,-
			i2sxf_cld,i2sxf.promsg_obj,-
			lsl$library:lslfrtlib/lib, -
			lsl$library:iffshr/opt, -
			lsl$library:lslshr/opt
$	purge i2sxf.*
$end:
$	set noverify
