$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-09-28 17:35:40.000000000 +0100
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
$!
$	set noverify
$!
$	def	lsl$cmndti	lsl$source_root:[matrix.dtilib]
$	def 	lsl$tvessys	lsl$source_root:[tves.service]
$!
$	deb = ""
$	mbug = ""
$	lbug = ""
$	inquire debg "debug"
$	if debg then deb = "/debug/noopt/check=(b,o)"
$	if deb.nes."" then mbug = "/debug"
$	if deb.nes."" then ibug = "/debug"
$	inquire for  "compile"
$	inquire mar  "mar"
$       inquire mes  "generate message definitions ? "
$	inquire lnk  "link"
$!
$	if.not.for then goto nofort
$!
$	INQUIRE FOR0 "Compile VECTORISE,OPEN_DTI_FILE,GET_IFFNAME"
$	INQUIRE FOR1 "Compile LNKNDS,TIDYLNKNDS,REVERSLINK"
$	INQUIRE FOR2 "Compile VEC_SET_WINDOW,READLL"
$	INQUIRE FOR4 "Compile FRAMED_MES
$	INQUIRE FOR5 "Compile SETAREAS,SETEDGES"
$	INQUIRE FOR6 "Compile FOLLOW"
$	INQUIRE FOR8 "Compile NODEINDEX,WHICHWAY"
$	INQUIRE FOR9 "Compile RDRANG,RDRANG_REAL,HELP"
$	INQUIRE FOR11 "Compile AREA,WRTIFJ,WRTSTR"
$	set verify
$!
$ nofort:
$	if .not. mes then goto nomess
$  	newmsg/dti/runoff/number=1651/prefix=vec__ vectorise.mes
$  	@vectorise.temp_com
$!
$ nomess:
$	if.not.for then goto nofor
$!
$	if.not.for0 then goto nofor0
$	adc vectorise = vectorise,open_dti_file,get_iffname
$	fortran'deb' vectorise
$	pvv vectorise
$!
$nofor0:if.not.for1 then goto nofor2
$	adc lnknds = lnknds,tidylnknds,reverslink
$	fortran'deb' lnknds
$	pvv lnknds
$!
$nofor2:if.not.for2 then goto nofor3
$	adc window = vec_set_window,readll
$	fortran'deb' window
$	pvv window
$!
$nofor3:if.not.for4 then goto nofor4
$	adc framed_mes = framed_mes
$	fortran'deb' framed_mes
$	pvv framed_mes
$!
$nofor4:if.not.for5 then goto nofor5
$	adc setareas = setareas,setedges
$	fortran'deb' setareas
$	pvv setareas
$!
$nofor5:if.not.for6 then goto nofor7
$	adc follow = follow
$	fortran'deb' follow
$	pvv follow
$!
$nofor7:if.not.for8 then goto nofor8
$	adc nodeindex = nodeindex,whichway
$	fortran'deb' nodeindex
$	pvv nodeindex
$!
$nofor8:if.not.for9 then goto nofor9
$	adc oddbits = rdrang,rdrang_real,help
$	fortran'deb' oddbits
$	pvv oddbits
$!
$nofor9:if.not.for11 then goto nofor
$	adc wrtifj = wrtifj,wrtstr
$	fortran'deb' wrtifj
$	pvv wrtifj
$!
$nofor :
$	purge *.for,*.obj
$	delete adc.ide;*
$!
$nofor:	if.not.mar then goto nomar
$	set verify
$	macro'mbug' veccmd+lsl$library:lslmaclib/lib
$	purge veccmd.obj
$!
$nomar:	if.not.lnk then goto nolnk
$	set verify
$	run lsl$exe:genver
$	adc version = version
$	fortran version
$	pvv version
$	purge version.*
$	delete adc.ide;*
$!
$	link/map'ibug' vectorise,-
		window,lnknds,setareas,follow,-
		wrtifj,framed_mes,nodeindex,-
		oddbits,veccmd,version,-
		here:vectorise.promsg_obj,-
		lsl$tvessys:tves_service/lib,-
		lsl$library:coordlib/lib,-
		lsl$library:dtilib/lib,-
		lsl$library:iffshr.opt/opt,-
		lsl$library:lslshr.opt/opt
$!
$	purge *.map
$!	purge *.exe
$!
$nolnk:
$	set noverify
$!
