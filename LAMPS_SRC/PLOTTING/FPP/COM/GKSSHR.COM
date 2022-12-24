$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-08-13 11:48:16.000000000 +0100
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
$! Command file for creating FPP GKS shareable image
$! =================================================
$!
$!
$	ON ERROR THEN CONTINUE
$!
$	WS="WRITE SYS$OUTPUT"
$!
$	MAKE	'P1' 'P2' 'P3' 'P4' 'P5' 'P6'
$!
$! define our environment
$!
$	ROOT   = f$trnlnm("LSL$FPP_ROOT")
$	OBJDIR = f$trnlnm("OBJ")
$	EXEDIR = f$trnlnm("EXE")
$	SRCDIR = f$trnlnm("SRC")
$	MARDIR = f$trnlnm("MAR")
$	CMNDIR = f$trnlnm("CMN")
$	COMDIR = f$trnlnm("COM")
$	DEVDIR = f$trnlnm("DEV")
$!
$! start off out batch command file
$!
$	makfil 'EXEDIR'FPPBAT.COM		! who it is
$	wc "$	set def ",OBJDIR		! where it should work
$	wc "$	assign/tran=(c,t) ''ROOT' LSL$FPP_ROOT" ! define its environment
$	wc "$	assign ''OBJDIR' OBJ"
$	wc "$	assign ''EXEDIR' EXE"
$	wc "$	assign ''SRCDIR' SRC"
$	wc "$	assign ''MARDIR' MAR"
$	wc "$	assign ''CMNDIR' CMN"
$	wc "$	assign ''COMDIR' COM"
$	wc "$	assign ''DEVDIR' DEV"
$	wc "$	set noon"
$!
$!
$! Ask him what he wants to do.
$ASK:	COMP=1
$	MAKI4
$!
$! Start compiling.
$	MAKASK VEC "Macro transfer vector"
$	IF NO THEN GOTO 5
$	MAKU M GKSVEC GKSVEC
$!
$! Now link it.
$5:	INQUIRE/NOP TKB "Link ? "
$	IF .NOT.TKB THEN GOTO QUIT
$GETVER:WS "Versions available: WILD,LP,TEK_ARGS,SIG6000,CAL5800,HCBS,VRSC2V1"
$	WS "                    FER,HP,UIS,MOTIF,LWS,GERB,KONG,VERS,AEG,LWS"
$	WS "                    LVU,BEN3000,XYNETICS,KERNGP1,PRIM,PI448"
$	WS "                    POSTSCRIPT"
$	INQUIRE/NOP VER "Which version? "
$	IF VER.eqs."" THEN GOTO QUIT
$	IF VER.eqs."LWS" THEN GOTO BLDLWS
$CHKVER:IF f$search("DEV:FPP''VER'.OPT").nes."".and. -
	   f$search("DEV:''VER'BLK.SRC").nes."" THEN GOTO CHK
$	WS "No such version as ""''VER'"""
$	GOTO GETVER
$!
$CHK:	IF VER.eqs."HCBS" THEN GOTO BLD
$	SEARCH/NOOUTPUT DEV:'VER'BLK.SRC "'HCBS'"
$	IF $SEVERITY.NE.1 THEN GOTO BLD
$	WS "FPP''VER' uses GKSHCBSSHR - GKS''VER'SHR does not exist"
$	GOTO GETVER
$!
$BLD:	INQUIRE/NOP LDEB "Link with debug? "
$	LNKOPT = ""
$	IF LDEB THEN LNKOPT = "/DEBUG"
$	WC "$	DEFINE LSL$HCBSSHARE LSL$EXE:HCBSCAL907.EXE"
$	WC "$	LINK''LNKOPT'/SHARE/EXE=EXE:GKS''VER'SHR -"
$	WC "	/MAP=GKS''VER'SHR/FULL -"
$	WC "	DEV:GKSSHR/OPT,DEV:FPP''VER'/OPT,LSL$LIBRARY:LSLSHR/OPT"
$	WC "$	PURGE EXE:GKS''VER'SHR.EXE"
$	WC "$	PURGE GKS''VER'SHR.MAP"
$	GOTO QUIT
$!
$! Build Laserplot Workstation version
$BLDLWS:INQUIRE LWSU "Compile DASHEX user interface "
$	IF .NOT. LWSU THEN GOTO LWS3
$	 MAKU AF DASHEX_USER DASHEX_USER
$LWS3:	GOTO CHKVER
$!
$QUIT:	MAKEND
$	PURGE EXE:FPPBAT.COM
