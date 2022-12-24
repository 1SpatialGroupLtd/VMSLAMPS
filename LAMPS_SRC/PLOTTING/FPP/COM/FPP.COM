$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-11-15 16:18:40.000000000 +0000
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
! Command file for creating FPP
! =============================
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
$	IF P1.EQS."" THEN INQUIRE/NOP COMP "Compile ? "
$	IF .NOT.COMP THEN GOTO 5
$	FSW1=""
$	INQUIRE/NOP	DBG	"With Debug ? "
$	IF .NOT.DBG THEN GOTO NODBG
$	MAKDEBUG
$	MAKFKP
$	FSW1="/NOOPT"
$	INQUIRE/NOP ANSWER "Check bounds and overflow ? "
$	IF ANSWER THEN FSW1=FSW1+"/CHECK=(BOUNDS,OVERFLOW)"
$	IF FSW1 .NES. "" THEN MAKFSW 'FSW1'
$NODBG:	MAKINQ  DOALL	"Compile everything"
$	IF DOALL THEN MAKALL
$!
$! Start compiling.
$	MAKASK MAIN "Main"
$	IF NO THEN GOTO 1
$	MAKU A   MAIN  FPP,BLKDAT,FPPSET,FPOPWK,OBEY,EXCEPTION
$	MAKU AP  MAIN  SHTOLE,SHLABE,SHSCAL,LABEL,CTRLCAST,HADCTRLC
$	MAKU APF MAIN  TITLE,TITLE_ADD,GETVERSION,INIDRAW
$	MAKU AM  MAIN  COMTBL
$!
$1:	MAKASK BODY "Body"
$	IF NO THEN GOTO 2
$	MAKU A   BODY  IFFBDY,IFFHDR,LOOPY,OSHEAD,MCEHEA,PRIOBDY
$	MAKU AP  BODY  CREATE_PRIO_LIST,SORT_PRIO_LIST,DRAW_PRIO_LIST
$	MAKU AP  BODY  FREE_PRIO_LIST,FPP_ALLOC,OVERLAY
$	MAKU AP  BODY  BUFFER,SETLIN,SETCOL,CHKST,ANGSIZ
$	MAKU AP  BODY  SRTOFF,OFF,OFSEG,INTSCT
$	MAKU APF BODY  DRWLAB,SETCON,PSTOSZ,GETATT
$!
$2:	MAKASK DRAW "Draw"
$	IF NO THEN GOTO 3
$	MAKU A   DRAW  STDRAW,GENCIR,STCIRC,INTERP,BOX_AUX,DRAFTR
$	MAKU APF DRAW  ADDPTS,ADDBLK,OUTBLK,GETTXT,GETSYM,BOX_DRAFTR
$!
$3:	MAKASK SELE "Selections"
$	IF NO THEN GOTO 4
$	MAKU A   SELE SHSELE,DISPLBTMP,INWORD,OTPLSTRG
$	MAKU AP  SELE RDSEL,RDLAY,RDFSN,PROSEL,RDRANG
$	MAKU AP  SELE SELEAC,GET_ACTYPE,CREATE_ACSEL,FNDAC
$	MAKU AP  SELE GET_ACVAL,CMPAC,SHSELAC
$	MAKU APF SELE ISELAC,TSTAC,STORE_ACSEL
!$
$4:	MAKASK PENDUM "Dummy GKS routines for some versions"
$	IF NO THEN GOTO 5
$	MAKU AF GKSDUM GKSDUM
$	WC "$	LIBR/CREATE GKSDUM GKSDUM"
$	WC "$	LIBR/COMP GKSDUM"
$	WC "$	SET FILE/TRUNC GKSDUM.OLB"
$	WC "$	PURGE GKSDUM.OLB"
$	WC "$	DELETE GKSDUM.OBJ;*"
$!
$! Now link it.
$5:	INQUIRE/NOP TKB "Link ? "
$	IF .NOT.TKB THEN GOTO QUIT
$	INQUIRE/NOP VER "Link FPPSHR ? "
$	IF .NOT.VER THEN GOTO NOSHAR
$	VER = "SHR"
$	GOTO CHKVER
$!
$NOSHAR:INQUIRE/NOP VER "Link FPPHRD ? "
$	IF .NOT.VER THEN GOTO NOHRD
$	VER = "HRD"
$	GOTO CHKVER
$!
$! Build Laserplot Workstation version
$NOHRD:	INQUIRE/NOP VER "Link FPPLWS ? "
$	IF .NOT.VER THEN GOTO QUIT
$	VER = "LWS"
$	INQUIRE LWSU "Compile DASHEX user interface "
$	IF .NOT. LWSU THEN GOTO LWS3
$	 MAKU AF DASHEX_USER DASHEX_USER
$LWS3:	GOTO CHKVER
$!
$CHKVER:IF f$search("DEV:''VER'BLK.SRC").nes."".and.-
           f$search("DEV:FPP''VER'.OPT").nes."" THEN GOTO BLD
$	WS "No such version as ""''VER'"""
$	GOTO GETVER
$!
$! Build standard version.
$BLD:	INQUIRE/NOP LDEB "Link with debug? "
$	LNKOPT = ""
$	IF LDEB THEN LNKOPT = "/DEBUG"
$	IF VER.NES."SHR" THEN GOTO NOSHR
$	LNKOPT = LNKOPT+"/SHARE/FULL"
$	WC "$	DEFINE LSL$GKSSHR    LSL$EXE:GKSAEGSHR"
$	WC "$	DEFINE LSL$HCBSSHARE LSL$EXE:HCBSCAL907"
$NOSHR:	WC "$	ASSIGN/USER DEV:''VER'BLK.SRC DEVDAT"
$	MAKU AF 'VER'BLK DEVBLK
$!
$! generate a version identifier
$	WC "$	RUN LSL$EXE:GENVER"
$	WC "$	ADC VERSION/CD:CMN:=OBJ:VERSION"
$	WC "$	FORTRAN/NOLIST VERSION"
$	WC "$	PVV VERSION"
$	WC "$	DELETE VERSION.SRC;*,VERSION.FOR;*,ADC.IDE;*"
$	WC "$	PURGE/NOLOG VERSION.OBJ"
$!
$! link it
$	WC "$	LINK''LNKOPT'/MAP=FPP''VER'/EXE=EXE:FPP''VER' -"
$	WC "	 DEV:FPP/OPT,OBJ:''VER'BLK,DEV:FPP''VER'/OPT,-"
$	WC "	 LSL$LIBRARY:FRTSHR/OPT,-"
$	WC "	 LSL$LIBRARY:IFFSHR/OPT,-"
$	WC "	 LSL$LIBRARY:LSLSHR/OPT"
$	WC "$	PURGE EXE:FPP''VER'.EXE"
$	WC "$	PURGE FPP''VER'.MAP"
$	WC "$	DELETE ''VER'BLK.OBJ;*"
$	GOTO QUIT
$!
$QUIT:	MAKEND
$	PURGE EXE:FPPBAT.COM
