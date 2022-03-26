$!
$	set noverify            
$	on control_y then goto end
$	on error     then goto end
$!
$! command file: I2OSTF - a command file to build the I2OSTF program
$!
$! Copyright (C) Laser-Scan Ltd, Cambridge, England
$!
$! Author TJ Ibbs, 23 June 1986
$!
$! Mod 1435 Use new frtshr			JB 28-Nov-1994
$!
$! *************************************************************************
$!
$	wsb = "write sys$output """""
$!
$	if p1.eqs."" then -
  	inquire p1  "Compile with debug "
$	if p1.eqs."" then p1 = "n"
$!
$	debug = p1
$!
$	wsb
$	inquire cld "cld module                                        "
$	inquire mes "messages                                          "
$	wsb
$	inquire dmc "i2ostf                                            "
$ 	inquire cmd "commands                                          "
$	inquire prc "procfile   (procfile,outht)                       "
$	inquire ckf "chkfeature (check_feature)                        "
$	inquire att "attributes (check_char_att,set_date_att)          "
$	inquire idx "wrtindex                                          "
$	inquire ini "init       (report,endblk,find_codes,get_mh_info) "
$	inquire txt "text       (form,outtxt)                          "
$	inquire out "output     (putbin,putchr,putrec,flush,count_ch)  "
$!**	inquire oth "other      (bdyicl,ascicl,pad)                    "
$	inquire ext "extra      (cnvtos,newstart,gttxtlnth,getchr)     "
$	wsb
$	inquire lnk "link            "
$	inquire lbg "link with debug "
$	wsb
$!
$	ldbg="/map/cross"
$	dbg = ""
$	pd  = "delete"
$	ver = ";*"
$	if lbg   then ldbg= ldbg + "/debug"
$	if debug then dbg = "/debug/noopt/check"
$	if debug then pd  = "purge"
$	if debug then ver = ""
$!
$	set verify
$      	if .not.mes then goto nomes
$	   newmsg  I2OSTF/number=1602/runoff/hl=2
$	   @I2OSTF.temp_com
$	   purge I2OSTFMSG.rno
$!
$nomes:	if .not.cld then goto nocld
$	   adc   i2ostf.TMP=i2ostf.CLD
$ 	   set command/object=i2ostf_cld  i2ostf.TMP
$	   pvv   i2ostf_cld
$	   purge i2ostf_cld.OBJ
$	   adc   inlist.TMP=inlist.CLD
$ 	   set command/object=inlist_cld  inlist.TMP
$	   pvv   inlist_cld
$	   purge inlist_cld.OBJ
$	   delete adc.ide;*
$	   delete *.TMP;*            
$!
$nocld:	if .not.dmc then goto nodmc
$	   adc i2ostf/co = i2ostf
$	   fort/extend'dbg' i2ostf
$	   pvv i2ostf
$	   purge i2ostf.obj
$	   delete adc.ide;*
$	   'pd' i2ostf.for'ver'
$!
$nodmc:	if .not.cmd then goto nocmd
$	   adc commands/co = cmdline,switches,input_list,p1_list
$	   fort/extend'dbg' commands
$	   pvv commands
$	   purge commands.obj
$	   delete adc.ide;*
$	   'pd' commands.for'ver'
$!
$nocmd:	if .not.prc then goto noprc
$	   adc procfile/co = procfile,outht
$	   fort/extend'dbg' procfile
$	   pvv procfile
$	   purge procfile.obj
$	   delete adc.ide;*
$	   'pd' procfile.for'ver'
$!
$noprc:	if .not.ckf then goto nockf
$	   adc chkfeature/co = check_feature
$	   fort/extend'dbg' chkfeature
$	   pvv chkfeature
$	   purge chkfeature.obj
$	   delete adc.ide;*
$	   'pd' chkfeature.for'ver'
$!
$nockf:	if .not.att then goto noatt
$	   adc att/co = check_char_att,set_date_att
$	   fort/extend'dbg' att
$	   pvv att
$	   purge att.obj
$	   delete adc.ide;*
$	   'pd' att.for'ver'
$!
$noatt:	if .not.idx then goto noidx
$	   adc wrtindex/co = wrtindex
$	   fort/extend'dbg' wrtindex
$	   pvv wrtindex
$	   purge wrtindex.obj
$	   delete adc.ide;*
$	   'pd' wrtindex.for'ver'
$!
$noidx:	if .not.ini then goto noini
$	   adc init/co = report,endblk,find_codes,get_mh_info
$	   fort/extend'dbg' init
$	   pvv init
$	   purge init.obj
$	   delete adc.ide;*
$	   'pd' init.for'ver'
$!
$noini:	if .not.txt then goto notxt
$	   adc text/co = form, outtxt
$	   fort/extend'dbg' text
$	   pvv text
$	   purge text.obj
$	   delete adc.ide;*
$	   'pd' text.for'ver'
$!
$notxt:	if .not.out then goto noout
$	   adc out/co = putbin, putchr, putrec, flush, count_ch
$	   fort/extend'dbg' out
$	   pvv out
$	   purge out.obj
$	   delete adc.ide;*
$	   'pd' out.for'ver'
$!
$!**noout:	if .not.oth then goto nooth
$!**	   adc oth/co = bdyicl,ascicl,pad
$!**	   fort/extend'dbg' oth
$!**	   pvv oth
$!**	   purge oth.obj
$!**	   delete adc.ide;*
$!**	   'pd' oth.for'ver'
$!
$noout:	if .not.ext then goto noext
$	   adc ext/co = cnvtos,newstart,gttxtlnth,getchr
$	   fort/extendy'dbg' ext
$	   pvv ext
$	   purge ext.obj
$	   delete adc.ide;*
$	   'pd' ext.for'ver'
$!
$noext:	if .not.lnk then goto end
$!
$lnk:	link'ldbg'	i2ostf,commands,procfile,att,-
			chkfeature,-
			wrtindex,init,text,out,ext,-
			i2ostf_cld,inlist_cld,-
			i2ostf.promsg_obj,-
			lsl$library:osmhlib/lib,-
			lsl$library:frtshr/opt,-
			lsl$library:iffshr/opt,-
			lsl$library:lslshr/opt
$	purge i2ostf.*
$end:
$	set noverify
$!
