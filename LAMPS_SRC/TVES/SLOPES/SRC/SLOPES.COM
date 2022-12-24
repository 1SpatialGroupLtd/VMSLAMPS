$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1996-09-24 15:26:24.000000000 +0100
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
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
$!
$! command file to compile and link SLOPES
$!
$!	use tves service library			JB 10-Aug-1993
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
$!
$	set noverify
$!
$	def	lsl$tvessys	lsl$source_root:[tves.service]
$!
$	dbg := " "
$!
$	inquire ans "Compile/link with debug? "
$	if ans then dbg := /debug
$	if ans then deb := /debug/noopt/check=(b,o)/lis"
$!
$	inquire slopes "slopes"
$	inquire gradient "gradient"
$	inquire table "table"
$       inquire opnfil "opnfil"
$	inquire	shades "shades"
$	inquire icol "icol"
$	inquire dtihgt "dtihgt"
$	inquire shdraw "shdraw"
$	inquire lutset "lutset"
$	inquire mar "mar"
$!
$       inquire lnkarg   "link (ARGS)"
$	inquire lnkmotif "link (MOTIF)"
$	inquire lnkuis   "link (UIS)"
$	inquire lnksig   "link (SIG6000)"
$!
$	set verify
$	if .not.slopes then goto noslopes
$	adc slopes=slopes,ctrlcast,hadctrlc
$	fort 'deb' slopes
$	pvv slopes
$	delete adc.ide;*
$!
$noslopes: if.not.gradient   then goto nogradient
$	adc gradient=gradient1,gradient2,gradient3,gradient4
$	fort 'deb' gradient
$	PVV gradient
$	delete adc.ide;*
$!
$nogradient: if.not.table then goto notable
$	adc tabs = getdti,gettab,wait,put_output
$	adc tabs/ap = inmenu,setmenu,setmap,showerr
$	fort 'deb' tabs
$	pvv tabs
$!
$notable: if.not.opnfil then goto noopnfil
$       adc opnfil= opnfil,streq,transf,legend,help,dtinum,putflt,anotate
$	adc opnfil/ap = opnslp,cvtang,rdfang,readll
$	adc opnfil/ap = text,parse_filename,chkwin
$       fort 'deb' opnfil
$       pvv opnfil
$       delete adc.ide;*
$!
$noopnfil:if.not.shades then goto noshades
$       adc shades=shades,aspect1,rough
$       fort 'deb' shades
$       pvv shades
$       delete adc.ide;*
$!
$noshades:if.not.icol then goto noicol
$       adc icol=icol,putrow,inimat,at_cmd,close_fileout,tidy_up,modhead
$	adc icol/ap = data_type_cmd,default_cmd,show_cmd,window_cmd
$       fort 'deb' icol
$       pvv icol
$       delete adc.ide;*
$!
$noicol:if.not.dtihgt then goto nodtihgt
$       adc dtihgt=dtihgt,write_value,read_value
$       fort 'deb' dtihgt
$       pvv dtihgt
$       delete adc.ide;*
$!
$nodtihgt:if.not.shdraw then goto noshdraw
$       adc shdraw=shdraw,display_init,prepare
$       fort 'deb' shdraw
$       pvv shdraw
$       delete adc.ide;*
$!
$noshdraw:if.not.lutset then goto nolutset
$	adc lutset=lutset,lut_cmd
$	fort 'deb' lutset
$	pvv lutset
$	delete adc.ide;*
$!
$nolutset:if .not.mar then goto link
$	macro slpcmd
$!
$link: 
$	run lsl$exe:genver
$	adc version=version
$	fort version
$	pvv version
$	purge version.*
$	delete adc.ide;*
$!
$ if.not.lnkarg then goto nolnkarg
$	link 'dbg'/map=slopesargs/exe=slopesargs -
                 slopes,opnfil,gradient,dtihgt,-
                 tabs,shdraw,shades,icol,slpcmd,lutset,-
                 version,lsl$tvessys:tves_service/lib,-
			lsl$library:tablib/lib,- 
			lsl$library:gksldlib2/lib,-
			lsl$library:wosplib/lib,-
			lsl$library:vslib/lib,-
			lsl$library:dtilib/lib,-
			lsl$library:lslshr/opt
$!
$	mapid slopesargs
$	delete slopesargs.map;*
$!
$nolnkarg: if .not.lnkmotif then goto nolnkmotif
$	link 'dbg'/map=slopesmotif/exe=slopesmotif -
                 slopes,opnfil,gradient,dtihgt,-
                 tabs,shdraw,shades,icol,slpcmd,lutset,-
                 version,lsl$tvessys:tves_service/lib,-
			lsl$library:tablib/lib,-
			lsl$library:dtilib/lib,-
			lsl$library:gksmotiflib/lib,-
			lsl$library:lslshr/opt,-
			sys$input:/opt
			sys$share:xdps$dpsbindingsshr/share
			sys$share:decw$xmlibshr/share
$!
$	mapid slopesmotif
$	delete slopesmotif.map;*
$!
$nolnkmotif: if .not.lnkuis then goto nolnkuis
$	link 'dbg'/map=slopesuis/exe=slopesuis -
                 slopes,opnfil,gradient,dtihgt,-
                 tabs,shdraw,shades,icol,slpcmd,lutset,-
                 version,lsl$tvessys:tves_service/lib,-
			lsl$library:tablib/lib,-
			lsl$library:gksuislib/lib,-
			lsl$library:dtilib/lib,-
			lsl$library:lslshr/opt
$!
$	mapid slopesuis
$	delete slopesuis.map;*
$!
$nolnkuis: if .not.lnksig then goto nolnksig
$	link 'dbg'/map=slopessig6000/exe=slopessig6000 -
                 slopes,opnfil,gradient,dtihgt,-
                 tabs,shdraw,shades,icol,slpcmd,lutset,-
                 version,lsl$tvessys:tves_service/lib,-
			lsl$library:tablib/lib,-
			lsl$library:gkssiglib/lib,-
			lsl$library:wkslib/lib,-
			lsl$library:dtilib/lib,-
			lsl$library:lslshr/opt
$!
$	mapid slopessig6000
$	delete slopessig6000.map;*
$nolnksig:
$	purge *.exe
$	purge *.for
$nolnk:
$	purge *.obj
$	set noverify
$!
