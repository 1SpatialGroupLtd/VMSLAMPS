$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1996-02-06 11:24:20.000000000 +0000
$! *
$! * This program is free software: you can redistribute it and/or modify
$! * it under the terms of the GNU General Public License as published by
$! * the Free Software Foundation, version 3.
$! *
$! * This program is distributed in the hope that it will be useful, but
$! * WITHOUT ANY WARRANTY; without even the implied warranty of
$! * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
$! * General Public License for more details.
$! *
$! * You should have received a copy of the GNU General Public License
$! * along with this program. If not, see http://www.gnu.org/licenses/.
$!
$	set noverify
$	ass lsl$source_root:[dfad.fadtcmn] lsl$fadtcmn
$	ass lsl$source_root:[dfad.dfadval] lsl$dfadval
$	deb = ""
$	mbug = ""
$	lbug = ""
$	inquire debg "debug"
$	if debg then deb = "/debug/noopt/check=(b,o)"
$	if deb.nes."" then mbug = "/debug"
$	if deb.nes."" then ibug = "/debug"
$	inquire doadc  "adc"
$	inquire for  "compile"
$	inquire mar  "mar"
$	inquire cld  "cld"
$	inquire mes  "mes"
$	inquire lnk  "link"
$!
$	set verify
$!
$	if.not.mes then goto nomes
$	newmsg/number=1691/prefix=dv__/parameter=for/runoff dfadval.mes
$	@dfadval.temp_com
$!	
$nomes:	if.not.doadc then goto noadc
$	adc dfadval/co=dfadval,cvt,repchk,repint
$	adc dfadval/ap/co=intchk,inichk,place,divbox,segchk,fifver,clock,clmin
$	adc dfadval/ap/co=ac_val,fs_val,mh_val,nf_val,no_val,ns_val
$	adc dfadval/ap/co=st_val,ef_val,em_val,eo_val
$	adc dfadval/ap/co=get_command,list_heading,check_by_rule
$	adc dfadval/ap/co=fadt_validate,read_def_rule,read_file_rule
$	adc dfadval/ap/co=open_files,open_rule,open_iff,open_list
$	adc dfadval/ap/co=open_lites2,close_files,validate,accreg_val
$	adc dfadval/ap/co=lcm_msg,lcm_pos
$!
$noadc:	if.not.for then goto nofor
$	fortran'deb' dfadval
$!
$	pvv dfadval
$	delete adc.ide;*
$	purge/log dfadval.*
$!
$nofor:	if.not.mar then goto nomar
$	macro'mbug' dfadcmd+lsl$library:lslmaclib/lib
$	purge/log dfadcmd.obj
$!
$nomar:	if.not.cld then goto nocld
$	adc dfadval.tmp = dfadval_cld.cld
$	set command/object = dfadval_cld dfadval.tmp
$	pvv dfadval_cld
$	delete dfadval.tmp;*
$	delete adc.ide;*
$	purge dfadval_cld.obj
$!
$nocld:	if.not.lnk then goto nolnk
$	link/map 'ibug' dfadval,dfadcmd,dfadval_cld,dfadval.promsg_obj,-
			lsl$library:iffshr/opt,-
			lsl$library:lslshr/opt
$	purge/log *.map
$	purge/log *.exe
$nolnk:	dfadval :== $lsl$source_root:[dfad.dfadval]dfadval
$	set noverify
