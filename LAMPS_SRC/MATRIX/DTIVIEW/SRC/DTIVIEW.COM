$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1996-09-24 16:37:44.000000000 +0100
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
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! command file to compile and link DTIVIEW
$!
$! Modified for changed calls to graphics libraries		22-Nov-1988
$! Modified to include matrix service library in link	ALB	16-Jun-1988
$! mod1265 Use matrix service for anything from dtmcreate JB	11-Aug-1993
$! mod1426 Use FRTSHR					 JB	15-Nov-1994
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	assign lsl$source_root:[matrix.service]	lsl$matrixsys
$	assign here lsl$cmndtiview
$!
$	set noverify
$	on error then goto nolnk
$!
$	mbug = ""
$	ibug = ""
$	inquire compile "compile"
$	inquire debug "with debug"
$	inquire mar "mar"
$!
$	inquire lnk  "link"
$	if .not. lnk then goto next
$	inquire ldebug "with debug"
$!
$! decide which workstation this is to be built for
$!
$wk2:	inquire this "MOTIF workstation"
$	if .not. this then goto wk3
$	lnklib = "here:dtiviewmotif/opt"
$	dtiview = "dtiviewmotif"
$	gkssubs = "gksmotif"
$	gksobj = "gksmotif"
$	goto next
$!
$wk3:	inquire this "Vaxstation"
$	if .not. this then goto wk4
$	lnklib = "lsl$library:gksuislib/lib"
$	dtiview = "dtiviewuis"
$	gkssubs = "gksuis"
$	gksobj = "gksuis"
$	goto next
$!
$wk4:	inquire this "Sigma 6100"
$	if .not. this then goto wk5
$	lnklib = "lsl$library:gkssiglib/lib,lsl$library:wkslib/lib"
$	dtiview = "dtiviewsig6000"
$	gkssubs = "gkssig6000,gd2w2d"
$	gksobj = "gkssig6000"
$	goto next
$!
$wk5:	inquire this "TEK_ARGS workstation"
$	if .not. this then goto nolnk
$	lnklib = "lsl$library:gksldlib2/lib,vslib/lib,wosplib/lib"
$	dtiview = "dtiviewtek_args"
$	gkssubs = "gkstek_args"
$	gksobj = "gkstek_args"
$	goto next
$!
$next:
$	if debug then mbug = "/debug/noopt/check=(b,o)"
$	if ldebug then ibug = "/debug"
$	if .not. compile then goto nocompile
$!
$	inquire dtv1	"compile dtiview,open_file,help,readll,pause,iffwin"
$	inquire dtv2	"compile wait,clear,put_output,showerr,get*,ctrl*"
$	inquire dtv3	"compile inmenu,setmenu,setmap,open_command_file"
$	inquire vec	"compile addnod,icol,cordtf,legend,horini,annotate"
$	inquire plt	"compile plt*,sri*,model,profile,set_colour,fishnet"
$	inquire culture "compile open_iff_file,traiff,vsblty,fog_cmd,rd*"
$	inquire symbol  "compile process_symbols,symbol_cmd,show_symbols"
$	inquire lib	"compile g3ft,ifadpt,ifnwft,flush,ifftxt,otplstrg"
$	inquire gks	"compile gkssubs,gssgt,gevtm,init_device,lutset"
$!
$	set verify
$	if .not. dtv1 then goto nodtv1
$	adc	dtiview    = dtiview,open_file,dtiv_pause
$	adc	dtiview/ap = help,readll,set_iffwin,reset_iffwin
$	fortran	'mbug' dtiview
$	pvv	dtiview
$	if .not.debug then delete dtiview.for;*
$	delete	adc.ide;*
$	purge	dtiview.*
$!
$nodtv1:
$	if.not. dtv2 then goto nodtv2
$	adc	dtv2    = wait,put_output,ctrlcast,hadctrlc,showerr,clear
$	adc	dtv2/ap = getdti,gettab,get_window_points,get_profile_points
$	fortran	'mbug' dtv2
$	pvv	dtv2
$	if .not.debug then delete dtv2.for;*
$	delete	adc.ide;*
$	purge	dtv2.*
$!
$nodtv2:
$	if.not. dtv3 then goto nodtv3
$	adc	dtv3    = inmenu,setmenu,setmap,open_command_file
$	fortran	'mbug' dtv3
$	pvv	dtv3
$	if .not.debug then delete dtv3.for;*
$	delete	adc.ide;*
$	purge	dtv3.*
$!
$nodtv3:
$	if .not. vec then goto novec
$	adc	vec    = addnod,nxtnod,icol,setcol,cordtf,horini,horint
$	adc	vec/ap = horvin,horvnx,draw_legend,legbat,annotate,seaset
$	fortran	'mbug' vec
$	pvv	vec
$	if .not.debug then delete vec.for;*
$	delete	adc.ide;*
$	purge	vec.*
$!
$novec:
$	if .not. plt then goto noplt
$	adc	pltpos    = pltpos,model,profile,set_colour,draw_fishnet
$	adc	pltpos/ap = pltsym,pltlin,pltare,srigpl,srigfa
$	fortran	'mbug' pltpos
$	pvv	pltpos
$	if .not.debug then delete pltpos.for;*
$	delete	adc.ide;*
$	purge	pltpos.*
$!
$noplt: 
$	if .not. culture then goto noculture
$	adc	 culture    = open_iff_file,traiff,vsblty,point_visible
$	adc	 culture/ap = create_iff_file,enciff,culplt,ifftrn,inword
$	adc	 culture/ap = rdsel,rdfsn,rdlay,rdrang,fog_cmd,shsele
$	fortran 'mbug' culture
$	pvv	 culture
$	if .not.debug then delete culture.for;*
$	delete	 adc.ide;*
$	purge	 culture.*
$!
$noculture:
$	if .not. symbol then goto nosymbol
$	adc	 symbol    = process_symbols,symbol_cmd,show_symbols
$	adc	 symbol/ap = symbol_clear_cmd,symbol_fc_cmd,symbol_position_cmd
$	fortran 'mbug' symbol
$	pvv	 symbol
$	if .not.debug then delete symbol.for;*
$	delete	 adc.ide;*
$	purge	 symbol.*
$!
$nosymbol:
$	if .not. lib then goto nolib
$	adc	lib    = g3ft,ifadpt,ifnwft,flush,ifftxt
$       adc	lib/ap = displbtmp,otplstrg
$	fortran	'mbug' lib
$	pvv	lib
$	if .not.debug then delete lib.for;*
$	delete	adc.ide;*
$	purge	lib.*
$!
$nolib: 
$	if .not. gks then goto nogks
$	adc	'gksobj' = 'gkssubs',gevtm,gssgt,init_device,inigks
$	adc	'gksobj'/ap = vstkd2w,shotrn,lutset,gksdum
$	fortran	'mbug' 'gksobj'
$	pvv	'gksobj'
$	if .not.debug then delete 'gksobj'.for;*
$	delete	adc.ide;*
$	purge	'gksobj'.*
$!
$nogks:
$nocompile:if .not. mar then goto link
$	set verify
$	macro dtiview_commands+lsl$library:lslmaclib/lib
$	purge dtiview_commands.obj
$!
$link:	if .not. lnk then goto nolnk
$! ----------------------------------------------------------------------------
$! 
$	set verify
$	run lsl$exe:genver
$	adc version=version
$	define/user sys$output error.lis
$	fortran 'mbug' version
$	pvv version
$	del version.for;*
$	purge version.*
$!
$! ----------------------------------------------------------------------------
$! 
$	set verify
$	link 'ibug'/map='dtiview'/exe='dtiview' -
			dtiview,version,dtv2,dtv3,-
			vec,pltpos,lib,culture,symbol,'gksobj',-
			dtiview_commands,-
			lsl$matrixsys:matrix/lib,-
			lsl$library:tablib/lib,-
			lsl$library:dtilib/lib,-
			lsl$library:frtshr/opt,-
			lsl$library:lslfrtlib/lib,-
			'lnklib',-
			lsl$library:iffshr.opt/opt,-
			lsl$library:lslshr.opt/opt
$	mapid 'dtiview'
$	delete adc.ide;*
$	delete 'dtiview'.map;*
$!
$!	purge *.exe
$	purge *.mapid
$!
$nolnk:	set noverify
$!
