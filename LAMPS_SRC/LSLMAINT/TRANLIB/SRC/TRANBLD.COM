$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-02-14 13:41:16.000000000 +0000
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
$!	VER='F$VERIFY(0)
$	NOVER=0
$!!!	SET VER
$	ON ERROR THEN GOTO END
$!
$	INQUIRE VAX	"Native mode"
$	IF .NOT. VAX THEN GOTO PDP1
$	INQUIRE DEBUG "Debug"
$	IF .NOT.DEBUG THEN DEBUG=""
$	IF      DEBUG THEN DEBUG="/DEBUG"
$	OPTIM=0
$	IF DEBUG .NES. "" THEN INQUIRE OPTIM "Optimisation"
$	IF .NOT.OPTIM THEN DEBUG=DEBUG + "/NOOPT"
$	CHECKS = 0
$	IF DEBUG .NES. "" THEN INQUIRE CHECKS "Checks"
$	IF CHECKS THEN DEBUG=DEBUG + "/CHECK=(BOUNDS,OVERFLOW)"
$	GOTO VAXPDP
$PDP1:
$	INQUIRE CMP "Use F77 (if not - F4P)"
$	if .not.CMP then CMP="F4P"
$	if CMP.NES."F4P" then cmp="F77"
$VAXPDP:
$	INQUIRE NEW	"Create new library"
$	REP=0
$	IF .NOT.NEW THEN INQUIRE REP	"Replace in library"
$	MOD0="DM4PT"
$	MOD1="WJJ4PT"
$	MOD2="MCF4PT"
$	MOD3="TFORM"
$	MOD4="BICUBE"
$	MOD5="GENTRN"
$	MOD6="TFORMC"
$	MOD7="NEWFIT"
$	MOD8="NEWFIT_DBL"
$	MOD9="RWR2PT"
$	MOD10="PROJ4PT"
$	MOD11="EXTENDED_4PT_LS"
$	MOD12="PROJ_4PT_LS"
$	MOD13="SECOND_ORDER_LS"
$	POINT4="WJJ4PT"
$	COUNT=0
$	TOTMOD = 13
$ NXTMOD:
$	XXX=MOD'COUNT'
$	INQUIRE  'XXX' 'XXX'
$	COUNT=COUNT+1
$	IF COUNT .NE. 1 .OR. .NOT.'XXX' THEN GOTO BBB
$	COUNT=COUNT + 1
$	WJJ4PT=0
$	POINT4="DM4PT"
$ BBB: 	IF COUNT.LE.'TOTMOD' THEN GOTO NXTMOD
$!
$	COUNT=0
$ AAA:
$	XXX=MOD'COUNT'
$	IF .NOT.'XXX' THEN GOTO NXTC
$	IF VAX THEN GOTO VAX
$	  SET VER
$	  ADC 'XXX'='XXX'
$	  'cmp' 'XXX'='XXX'.FOR
$	  PVR 'XXX'
$	  IF REP THEN LIBRARY/RSX TRAN4PLIB/REP 'XXX'
$	  DELETE ADC.IDE;*
$	  V='F$VERIFY(NOVER)
$	  GOTO NXTC
$ VAX:
$	  SET VER
$	  ADC 'XXX'='XXX'
$	  FORT'DEBUG'/NOI4 'XXX'
$	  PVV 'XXX'
$	  IF REP THEN LIBRARY TRANLIB/REP/LOG 'XXX'
$	  DELETE ADC.IDE;*
$	  V='F$VERIFY(NOVER)
$ NXTC:
$	COUNT=COUNT+1
$	IF COUNT.LE.'TOTMOD' THEN GOTO AAA
$!
$	IF DM4PT .OR. WJJ4PT THEN RENAME 'POINT4'.OBJ 4POINT
$	PURGE *.OBJ
$	IF "''DEBUG'".EQS."" THEN DELETE *.FOR;*
$	IF "''DEBUG'".NES."" THEN IF F$SEARCH("*.FOR;-1").NES."" THEN -
	  PURGE *.FOR
$	IF .NOT.NEW THEN GOTO NONEW
$	IF .NOT.VAX THEN GOTO A100
$	  SET VERIFY
$	  LIBRARY TRANLIB/CREATE=(BLOCKS:20)
$	  LIBRARY TRANLIB/INS/LOG 4POINT,MCF4PT,TFORM,BICUBE,GENTRN,-
				TFORMC,NEWFIT,NEWFIT_DBL,RWR2PT,PROJ4PT,-
				EXTENDED_4PT_LS,PROJ_4PT_LS,-
				SECOND_ORDER_LS
$	  V='F$VERIFY(NOVER)
$	  GOTO NONEW
$ A100:
$	  SET VERIFY
$	  LIBRARY/RSX TRAN4PLIB/CREATE=(BLOCKS:20)
$	  LIBRARY/RSX TRAN4PLIB/INS 4POINT,MCF4PT,TFORM,BICUBE,GENTRN,-
				TFORMC,NEWFIT,NEWFIT_DBL,RWR2PT,PROJ4PT,-
				EXTENDED_4PT_LS,PROJ_4PT_LS,-
				SECOND_ORDER_LS
$	  V='F$VERIFY(NOVER)
$NONEW:
$	IF      VAX THEN PURGE TRANLIB.OLB
$	IF .NOT.VAX THEN PURGE TRAN4PLIB.OLB
$END:
$!	V='F$VERIFY(VER)
