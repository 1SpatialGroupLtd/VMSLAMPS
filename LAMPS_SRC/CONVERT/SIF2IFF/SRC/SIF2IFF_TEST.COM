$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-07-28 17:17:28.000000000 +0100
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
$! Command file to compile SIF2IFF program
$!
$	set noverify
$	on control then goto end
$       on error  then goto end
$!
$	define/nolog  cmn  'f$logical("HERE")
$	define/nolog  lsl$sif lsl$data_root:[lsl.sif]
$!  
$! Define some symbols
$!
$	ws    := "write sys$output "
$	wsb   := "write sys$output """""
$	dbg   :=
$	debug :=
$	mbug  :=
$ 	lbug  :=
$	link_dir := "lsl$SOURCE_ROOT:[CONVERT.SIF2IFF.SRC]"
$	cmp   :=
$	lst   :=
$	list  :=
$	cmt   :=
$	lnk   :=
$	rno   :=
$	runoff:=
$	tidy  := "delete"
$	ver   := ";*"
$	link_dir := 'f$logical("HERE")
$!
$	wsb
$askcmp:inquire CMP "Compile                 "
$	if .not. CMP then goto askcop
$	inquire DBG "   with debug           "
$	if .not. DBG then goto askall
$	   debug = "/debug/noopt/check=all"
$	   mbug  = "/debug"
$	   cmt   = "/co"
$	   tidy  = "purge"
$	   ver   = ""
$!
$	inquire LST "   and listings         "
$	if LST then list = "/list"
$!
$askall:wsb
$	inquire MAIN     "sif2iff                                   "
$	inquire CLD      "Command Line Decoding                     "
$	inquire CMD      "get_command                               "
$	inquire INI      "ini_sif2iff,ini_fdf,ini_feature           "
$	inquire RD1      "rdpar,rdfdf,rdsif,rddid,rdlst             "
$	inquire RD2      "rdsym,rdtxt,rdcir,rdarc,rdlac             "
$	inquire RD3      "rdpln,rdpg,rdtpc,rdacz,rdmtx,rdptn,rdtx3  "
$	inquire TAB      "xxxCMD                                    "
$	inquire PR1	 "condat,findfc,read_nam,read_sep,cont_line "
$       inquire PR2      "report,readline,get_xyz,skip_contlin,findpsize "
$	inquire IF1      "close_iff,write_start,write_end           "
$	inquire IF2      "start_feature,flush,coord,write_feature   "
$	inquire CCG      "read_lut,write_lut,id_ccsm                "
$	inquire MES      "Message Definitions                       "
$	if .not. MES then goto askcop
$	   inquire RNO   "Runoff file                               "
$	   if RNO then runoff = "/runoff/hl=2"
$askcop:wsb
$!
$	inquire LNK	 "Link                                      "
$	if .not. LNK then goto noLNK
$	inquire DBG	 "   with debug                             "
$	if DBG then lbug  = "/debug"
$!
$	set verify
$!
$	if .not. MES then goto noMES
$	newmsg  SIF2IFF/number=1610'runoff'
$	@SIF2IFF.temp_com
$	if RNO then purge SIF2IFFMSG.rno
$!
$noMES :if .not. CLD then goto noCLD
$	set command/object=SIF2IFF_CLD SIF2IFF_CLD
$	purge SIF2IFF_CLD.obj
$!
$noCLD:	if .not. MAIN then goto noMAIN
$	fort'debug''list' SIF2IFF.F
$	purge SIF2IFF.obj
$!
$noMAIN:if .not. CMD then goto noCMD
$	fort 'debug''list' GET_COMMAND.F
$	purge GET_COMMAND.obj
$!
$noCMD:if .not. INI then goto noINI
$	fort 'debug''list' INI_SIF2IFF.F+INI_FDF.F+INI_FEATURE.F
$	purge INI_SIF2IFF.obj
$!
$noINI:	if .not. RD1 then goto noRD1
$	fort 'debug''list' RDPAR.F
$	fort 'debug''list' RDFDF.F
$	fort 'debug''list' RDSIF.F
$	fort 'debug''list' RDDID.F
$	fort 'debug''list' RDLST.F
$	append RDLST.obj,RDFDF.obj,RDSIF.obj,RDDID.obj RDPAR.OBJ
$	purge RDPAR.obj
$	delete RDFDF.obj;*,RDSIF.obj;*,RDDID.obj;*,RDLST.obj;*
$noRD1:	if .not. RD2 then goto noRD2
$	fort 'debug''list' RDSYM.F
$	fort 'debug''list' RDTXT.F
$	fort 'debug''list' RDCIR.F
$	fort 'debug''list' RDARC.F
$	fort 'debug''list' RDLAC.F
$	append RDTXT.obj,RDCIR.obj,RDARC.obj,RDLAC.obj RDSYM.OBJ
$	purge RDSYM.obj
$	delete RDTXT.obj;*,RDCIR.obj;*,RDARC.obj;*,RDLAC.obj;*
$noRD2:	if .not. RD3 then goto noRD3
$	fort 'debug''list' RDPTN.F
$	fort 'debug''list' RDTX3.F
$	fort 'debug''list' RDPLN.F
$	fort 'debug''list' RDPG.F
$	fort 'debug''list' RDTPC.F
$	fort 'debug''list' RDACZ.F
$	fort 'debug''list' RDMTX.F
$	append RDTPC.obj,RDACZ.obj,RDMTX.obj,RDTX3.obj,RDPLN.obj,RDPG.obj RDPTN.obj
$	purge RDPTN.obj
$	delete RDTX3.obj;*,RDPLN.obj;*,RDPG.obj;*
$	delete RDTPC.obj;*,RDACZ.obj;*,RDMTX.obj;*
$noRD3:	if .not. TAB then goto noTAB
$	macro'mbug''list' PARCMD
$	macro'mbug''list' SIFCMD
$	macro'mbug''list' LACCMD
$	macro'mbug''list' LSTCMD
$	macro'mbug''list' TXTCMD
$	macro'mbug''list' DIDCMD
$	macro'mbug''list' SYMCMD
$	macro'mbug''list' CIRCMD
$	macro'mbug''list' ARCCMD
$	macro'mbug''list' PTNCMD
$	macro'mbug''list' TX3CMD
$	macro'mbug''list' PGCMD
$	macro'mbug''list' PLNCMD
$	macro'mbug''list' TPCCMD
$	macro'mbug''list' ACZCMD
$	macro'mbug''list' MTXCMD
$	append LACCMD.OBJ,LSTCMD.OBJ,TXTCMD.OBJ,DIDCMD.OBJ PARCMD.obj
$	append SYMCMD.OBJ,CIRCMD.OBJ,ARCCMD.OBJ,PTNCMD PARCMD.obj
$	append TX3CMD.OBJ,PGCMD.OBJ,PLNCMD.OBJ,TPCCMD.OBJ PARCMD.obj
$	append ACZCMD.OBJ,MTXCMD.OBJ,SIFCMD.OBJ PARCMD.obj
$	purge PARCMD.obj
$	delete SIFCMD.obj;*,LACCMD.OBJ;*,LSTCMD.OBJ;*
$	delete TXTCMD.OBJ;*,DIDCMD.OBJ;*,SYMCMD.OBJ;*
$	delete CIRCMD.OBJ;*,ARCCMD.OBJ;*,PTNCMD.OBJ;*
$	delete TX3CMD.OBJ;*,PGCMD.OBJ;*,PLNCMD.OBJ;*,TPCCMD.OBJ;*
$	delete ACZCMD.OBJ;*,MTXCMD.OBJ;*
$!
$noTAB: if .not. PR1 then goto noPR1
$	fort 'debug''list' CONDAT.F+FINDFC.F+READ_NAM.F+READ_SEP.F-
	+CONT_LINE.F
$	purge CONDAT.obj
$!
$noPR1: if .not. PR2 then goto noPR2
$	fort 'debug''list' REPORT.F+READLINE.F+GET_XYZ.F+SKIP_CONTLIN+FINDPSIZE
$	purge REPORT.obj
$!
$noPR2: if .not. IF1 then goto noIF1
$	fort 'debug''list' CLOSE_IFF.F+WRITE_START.F+WRITE_END.F
$	purge CLOSE_IFF.obj
$!
$noIF1: if .not. IF2 then goto noIF2
$	fort 'debug''list' START_FEATURE.F+FLUSH.F+COORD.F+WRITE_FEATURE.F
$	purge START_FEATURE.obj
$!
$noIF2: if .not. CCG then goto noCCG
$	fort 'debug''list' READ_LUT.F+WRITE_LUT.F+ID_CCSM.F
$	purge READ_LUT.obj
$!
$noCCG:	link'lbug'/map='link_dir'/exe='link_dir' -
			SIF2IFF,SIF2IFF_CLD, -
			GET_COMMAND, INI_SIF2IFF, RDPAR,-
			RDSYM, RDPTN, PARCMD,-
			CONDAT, REPORT, CLOSE_IFF,-
			START_FEATURE,-
			READ_LUT,-
			SIF2IFF.PROMSG_OBJ,-
			LSL$LIBRARY:IFFSHR/OPT,-
			LSL$LIBRARY:LSLSHR/OPT
$noLNK:	
$	set noverify
$	wsb
$end:
