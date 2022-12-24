$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-08-13 11:48:18.000000000 +0100
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
! Command file for creating FPP driver programs
! =============================================
!
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
$GETVER:WS "Versions available: WILD,LP,BEN,TEK_ARGS,SIG6000,CAL,VRSC2V1"
$	WS "                    FER,HP,UIS,MOTIF,GERB,KONG,VERS,AEG,LWS"
$	WS "                    LVU,BEN1600,BEN3000,XYNETICS,KERNGP1,PRIM"
$	WS "                    POSTSCRIPT"
$	INQUIRE/NOP VER "Which version? "
$	IF VER.eqs."" THEN GOTO QUIT
$	IF VER.eqs."CAL" THEN GOTO BLDCAL
$	IF VER.eqs."HRD".or.VER.eqs."LWS" THEN GOTO NOSHR
$CHKVER:IF f$search("DEV:''VER'BLK.SRC").nes."" THEN GOTO BLD
$	WS "No such version as ""''VER'"""
$	GOTO GETVER
$!
$NOSHR:	WS "FPP''VER' does not use shareable images - use FPP.COM to build it"
	GOTO GETVER
$!
$! Build standard version.
$BLD:
$	WC "$	ASSIGN/USER DEV:''VER'BLK.SRC DEVDAT"
$	MAKU AF FPPDRV FPPDRV,SRC:IS_ALPHA_AXP
$	WC "$	LINK/MAP=FPP''VER'/EXE=EXE:FPP''VER' FPPDRV
$	WC "$	PURGE EXE:FPP''VER'.EXE"
$	WC "$	PURGE FPP''VER'.MAP"
$	WC "$	DELETE FPPDRV.OBJ;*"
$	GOTO QUIT
$!
$! Build a Calcomp version
$BLDCAL:INQUIRE/NOP CALVER "Calcomp version (eg 907,925,GEOG,AIDU,RAS)? "
$	VER = "CAL''CALVER'"
$	GOTO CHKVER
$!
$QUIT:	MAKEND
$	PURGE EXE:FPPBAT.COM
