$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-07-28 12:58:50.000000000 +0100
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
$!	
$!
$!	Copyright               Laser-Scan Ltd., Cambridge, England.
$!
$!	Created							ST 14-Apr-1992
$!MOD	Changed logical to point to new build directory		ST 28-Jul-1993
$!	for CMS
$!
$! Description:
$!
$!	Command procedure to build DCW2I
$!
$!-----------------------------------------------------------------------------
$!
$!
$!	oracleini
$!
$!
$!
$	on error     then goto exit_neatly
$	on control_y then goto exit_neatly
$!
$	define lsl$dcw_src lsl$source_root:[convert.dcw2i.src]
$!
$	ws = "write sys$output"
$	wsb = "write sys$output """"
$	debug = "N"
$!
$	wsb
$	ws "Building DCW2I"
$	wsb
$	inquire/nopunct cmp    "Compile ?                     "
$	if .not.cmp then goto asklnk
$	inquire/nopunct debug  "with debug ?                  "
$	if debug.eqs."" then debug = "N"
$	wsb
$	inquire/nopunct vpf    "Compile related VPF sources ? "
$	if vpf then goto ask_vpf
$	wsb
$	inquire/nopunct cmd    "Command tables ?              "
$	inquire/nopunct msg    "Messages ?                    "
$	wsb
$	inquire/nopunct main   "DCW2I ?                       "
$	inquire/nopunct devi   "DEVICE_CMD ?                  "
$	inquire/nopunct enab   "ENABLE_CMD ?                  "
$	inquire/nopunct exam   "EXAMINE_TERM ?                "
$	inquire/nopunct gocm   "GO_CMD ?                      "
$	inquire/nopunct rdfi   "READ_FILE ?                   "
$	inquire/nopunct rdfc   "READ_FC_LINE ?                "
$	inquire/nopunct rdac   "READ_AC_LINE ?                "
$	inquire/nopunct sele   "SELECT_CMD ?                  "
$	inquire/nopunct selc   "SEL_COVER ?                   "
$	inquire/nopunct selg   "SEL_GEOREF ?                  "
$	inquire/nopunct shcm   "SHOW_CMD ?                    "
$	inquire/nopunct shen   "SHOW_ENA ?                    "
$	inquire/nopunct shse   "SHOW_SEL ?                    "
$	inquire/nopunct spwn   "SPAWN_CMD ?                   "
$	inquire/nopunct targ   "TARGET_CMD ?                  "
$	wsb
$ask_vpf:
$	inquire/nopunct char   "CHAR_CHECK ?                  "
$	inquire/nopunct extr   "EXTRACT ?                     "
$	inquire/nopunct exco   "EXTRACT_COVER ?               "
$	inquire/nopunct exge   "EXTRACT_GEOREF ?              "
$	inquire/nopunct exti   "EXTRACT_TILE ?                "
$	inquire/nopunct file   "FILE_EXISTS ?                 "
$	inquire/nopunct iees   "IEEE_VAX_S ?                  "
$	inquire/nopunct setm   "SET_MAPDES ?                  "
$	inquire/nopunct vac    "VPF_AC ?                      "
$	inquire/nopunct vedg   "VPF_EDGES ?                   "
$	inquire/nopunct vfc    "VPF_FC ?                      "
$	inquire/nopunct gene   "VPF_GENERAL ?                 "
$	inquire/nopunct tabl   "VPF_READ_TABLE ?              "
$	wsb
$	inquire/nopunct vers   "VERSION ?                     "
$	wsb
$asklnk:
$	inquire/nopunct lnk    "Link ?                        "
$	inquire/nopunct lbg    "with debug ?                  "
$	wsb
$!
$	ldbg="/map/cross"
$	dbg = ""
$	mbug = ""
$	pd  = "delete/nocon"
$	ver = ";*"
$	if lbg   then ldbg= "/debug"
$	if debug then dbg = "/debug/noopt/check"
$	if debug then cdbg = "/debug/noopt"
$	if debug then mbug = "/debug"
$	if debug then pd  = "purge"
$	if debug then ver = ""
$!
$!
$	set verify
$	if .not.cmp then goto do_link
$	if vpf then goto do_vpf
$!
$	if .not.cmd then goto no_cmd
$	   macro'mbug''list' 	DCW2I_CMDTAB
$	   purge		DCW2I_CMDTAB.OBJ
$no_cmd:
$	if .not.msg then goto no_msg
$!
$! produce DCW2IMSG.PAR and DCW2IMSG.H to call from both FORTRAN and C
$!
$	   newmsg		DCW2I/number=1630/runoff/param=(fortran,c)
$	   @DCW2I.TEMP_COM
$	   purge		DCW2IMSG.*
$	   purge		DCW2I.PROMSG_OBJ
$no_msg:
$	if .not.main then goto no_main
$	   fortran/extend'dbg'	DCW2I.F
$	   purge		DCW2I.*
$no_main:
$	if .not.devi then goto no_devi
$	   fortran/extend'dbg'	DEVICE_CMD.F
$	   purge		DEVICE_CMD.*
$no_devi:
$	if .not.enab then goto no_enab
$	   fortran/extend'dbg'	ENABLE_CMD.F
$	   purge		ENABLE_CMD.*
$no_enab:
$	if .not.exam then goto no_exam
$	   fortran/extend'dbg'	EXAMINE_TERM.F
$	   purge		EXAMINE_TERM.*
$no_exam:
$	if .not.gocm then goto no_gocm
$	   fortran/extend'dbg'	GO_CMD.F
$	   purge		GO_CMD.*
$no_gocm:
$	if .not.rdfi then goto no_rdfi
$	   fortran/extend'dbg'	READ_FILE.F
$	   purge		READ_FILE.*
$no_rdfi:
$	if .not.rdfc then goto no_rdfc
$	   fortran/extend'dbg'	READ_FC_LINE.F
$	   purge		READ_FC_LINE.*
$no_rdfc:
$	if .not.rdac then goto no_rdac
$	   fortran/extend'dbg'	READ_AC_LINE.F
$	   purge		READ_AC_LINE.*
$no_rdac:
$	if .not.sele then goto no_sele
$	   fortran/extend'dbg'	SELECT_CMD.F
$	   purge		SELECT_CMD.*
$no_sele:
$	if .not.selc then goto no_selc
$	   fortran/extend'dbg'	SEL_COVER.F
$	   purge		SEL_COVER.*
$no_selc:
$	if .not.selg then goto no_selg
$	   fortran/extend'dbg'	SEL_GEOREF.F
$	   purge		SEL_GEOREF.*
$no_selg:
$	if .not.shcm then goto no_shcm
$	   fortran/extend'dbg'	SHOW_CMD.F
$	   purge		SHOW_CMD.*
$no_shcm:
$	if .not.shse then goto no_shse
$	   fortran/extend'dbg'	SHOW_SEL.F
$	   purge		SHOW_SEL.*
$no_shse:
$	if .not.shen then goto no_shen
$	   fortran/extend'dbg'	SHOW_ENA.F
$	   purge		SHOW_ENA.*
$no_shen:
$	if .not.spwn then goto no_spwn
$	   fortran/extend'dbg'	SPAWN_CMD.F
$	   purge		SPAWN_CMD.*
$no_spwn:
$	if .not.targ then goto no_targ
$	   fortran/extend'dbg'	TARGET_CMD.F
$	   purge		TARGET_CMD.*
$no_targ:
$!
$! Table extracting. Kept separate from command line routines for clarity
$!
$do_vpf:
$	if .not.char then goto no_char
$	   fortran/extend'dbg'	CHAR_CHECK.F
$	   purge		CHAR_CHECK.*
$no_char:
$	if .not.extr then goto no_extr
$	   fortran/extend'dbg'	EXTRACT.F
$	   purge		EXTRACT.*
$no_extr:
$	if .not.exco then goto no_exco
$	   fortran/extend'dbg'	EXTRACT_COVER.F
$	   purge		EXTRACT_COVER.*
$no_exco:
$	if .not.exge then goto no_exge
$	   fortran/extend'dbg'	EXTRACT_GEOREF.F
$	   purge		EXTRACT_GEOREF.*
$no_exge:
$	if .not.exti then goto no_exti
$	   fortran/extend'dbg'	EXTRACT_TILE.F
$	   purge		EXTRACT_TILE.*
$no_exti:
$	if .not.file then goto no_file
$	   fortran/extend'dbg'	FILE_EXISTS.F
$	   purge		FILE_EXISTS.*
$no_file:
$	if .not.iees then goto no_iees
$	   fortran/extend'dbg'	IEEE_VAX_S.F
$	   purge		IEEE_VAX_S.*
$no_iees:
$	if .not.setm then goto no_setm
$	   fortran/extend'dbg'	SET_MAPDES.F
$	   purge		SET_MAPDES.*
$no_setm:
$	if .not.vac then goto no_vac
$	   cc'cdbg'		VPF_AC.C
$	   purge		VPF_AC.*
$no_vac:
$	if .not.vedg then goto no_vedg
$	   cc'cdbg'		VPF_EDGES.C
$	   purge		VPF_EDGES.*
$no_vedg:
$	if .not.vfc then goto no_vfc
$	   cc'cdbg'		VPF_FC.C
$	   purge		VPF_FC.*
$no_vfc:
$	if .not.gene then goto no_gene
$	   cc'cdbg'		VPF_GENERAL.C
$	   purge		VPF_GENERAL.*
$no_gene:
$	if .not.tabl then goto no_tabl
$	   cc'cdbg'		VPF_READ_TABLE.C
$	   purge		VPF_READ_TABLE.*
$no_tabl:
$!
$!
$	if .not.vers then goto do_link
$	   run lsl$exe:genver			! update VERSION routine
$	   purge		VERSION.*
$	   rename		VERSION.SRC .F
$	   fortran/extend'dbg'	VERSION.F
$do_link:
$	if .not.lnk then goto exit_neatly
$!
$	ws "Linking..."
$	ws "DCW2I"
$	link'ldbg'	DCW2I,-
			DCW2I_CMDTAB,CHAR_CHECK,	-
			DEVICE_CMD,ENABLE_CMD,EXAMINE_TERM,EXTRACT,-
			EXTRACT_COVER,EXTRACT_GEOREF,EXTRACT_TILE,-
			FILE_EXISTS,IEEE_VAX_S,GO_CMD,READ_FILE, -
			READ_FC_LINE,READ_AC_LINE,SELECT_CMD,SEL_COVER,-
			SEL_GEOREF,SET_MAPDES,SHOW_CMD,SHOW_ENA,SHOW_SEL,-
			SPAWN_CMD,TARGET_CMD,VPF_AC,VPF_EDGES,VPF_FC,-
			VPF_GENERAL,VPF_READ_TABLE,-
			VERSION,-
			DCW2I.PROMSG_OBJ,-
			lsl$library:lslshr/opt,-
			lsl$library:iffshr/opt,-
			sys$input:/opt
sys$library:vaxcrtl/share
$!
$	purge DCW2I.*
$exit_neatly:
$	set noverify
