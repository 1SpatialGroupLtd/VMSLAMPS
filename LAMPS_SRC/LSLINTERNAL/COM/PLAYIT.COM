$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-11-11 18:33:56.000000000 +0000
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
$	V='F$VERIFY(0)
$	SET NOON
$	ON CONTROL_Y THEN GOTO END
$!
$	UIC=F$USER()
$	G=F$LOC("[",UIC) + 1
$	GLEN=F$LOC(",",UIC) - G
$	GROUP=F$EXTRACT(G,GLEN,UIC)
$	BASE=GLEN + G + 1
$	CRETIN=F$EXT(BASE,3,UIC)
$!
$	IF GROUP.NE.100 THEN GOTO OK
$	IF P2.EQS."ZXC" .AND. CRETIN.NE.200 THEN GOTO OK
$!
$	MINHR=9
$	MAXHR=17
$	TIM=F$TIME()
$	FB=F$LOC(" ",TIM)+1
$	HRS=F$EXT(FB,2,TIM)
$!
$! Make sure that the user is charging this to "PRIVATE". If not then
$! be beastly if it is a Buroid.  Abuse them then log them out!
$! (code skipped when CHARGE removed - PGH 11/11/91)
$! 
$!!!	IF SYS$ACCOUNT .EQS. "PRIVATE" .OR. CRETIN .NE. 200 THEN GOTO CRET_TEST
$!!!	WRITE SYS$OUTPUT " "
$!!!	WRITE SYS$OUTPUT " "
$!!!	WRITE SYS$OUTPUT " "
$!!!	WRITE SYS$OUTPUT "*** THIS IS FRAUD ***"
$!!!	WRITE SYS$OUTPUT "*** THOU SHALT ONLY CHARGE GAMES TO PRIVATE ***"
$!!!	WRITE SYS$OUTPUT " "
$!!!	LO					! logout the offender
$ CRET_TEST:
$	IF CRETIN .NE. 200 THEN GOTO NOTBUR	! clobber the bureau
$	OAF=F$GETJPI("","USERNAME")
$	OAF=F$EXTRACT(0,F$LOC(" ",OAF),OAF)
$	IF OAF .EQS. "TOM"  .OR. OAF .EQS. "CLIVE" .OR. -
	   OAF .EQS. "DAVID".OR. OAF .EQS. "TIMA" THEN GOTO NOTBUR	! pass, friend
$	IF OAF .NES. "BUREAU" THEN GOTO WORKS_TIME
$	WRITE SYS$OUTPUT " "
$	WRITE SYS$OUTPUT " "
$	WRITE SYS$OUTPUT "*** THIS IS FRAUD ***"
$	WRITE SYS$OUTPUT "*** THOU SHALT ONLY LOG ON AS YOURSELF ***"
$	WRITE SYS$OUTPUT " "
$	LO			! logout the offender
$ WORKS_TIME:
$	MINHR=7
$	MAXHR=5
$!
$ NOTBUR:
$	IF HRS.LT.MINHR THEN GOTO OK
$	IF HRS.GE.MAXHR THEN GOTO OK
$	IF HRS.EQ.13 THEN GOTO OK
$	WRITE SYS$OUTPUT "*** THOU SHALT NOT PLAY IN FIRM'S TIME ! ***"
$	EXIT
$!
$ OK:
$	GAMDEV=F$LOG("LSL$GAMESDISK")-"_"
$	IF GAMDEV.EQS."" THEN GAMDEV="LSL$USER_ROOT:"
$	IF F$LOG("SYS$GAMES") .EQS. "" THEN ASS 'GAMDEV'[GAMES] SYS$GAMES
$	NEWDEF="F"
$!
$	IF P1 .EQS. "" THEN GOTO LIST
$!
$	PLAY_CURPRI=F$GETJPI("0","PRIB")
$	PLAY_PRIO=3
$	IF CRETIN .EQ. 200 THEN PLAY_PRIO=1
$!
$	LEN=F$LENGTH(P1)		! ADVUPGRAD is special
$	IF LEN .LT. 4 THEN LEN = 4
$	IF P1 .NES. F$EXTRACT(0,LEN,"ADVUPGRADE") THEN GOTO OK1
$	P1="ADVUPGRAD.V23"
$	GOTO PLAY3
$!
$ OK1:	IF LEN .EQ. 9 THEN GOTO OK2
$	P1SAV=P1
$	A=F$PARSE("SYS$GAMES:"+P1+"*.EXE")
$	P1=F$SEARCH(A)
$	IF P1.EQS."" THEN GOTO NOSUCH
$ 	P1=F$PARSE(P1,,,"NAME")
$	IF P1 .EQS. P1SAV THEN GOTO OK2	! exact name match
$	IF F$SEARCH(A).EQS."" THEN GOTO OK2
$	WRITE SYS$OUTPUT "Ambiguous abbreviation"
$	GOTO END
$!
$ OK2:	IF P1 .EQS. "STARTREK"  THEN GOTO PLAY3
$	IF P1 .EQS. "DUNGEON"   THEN GOTO PLAY3
$	IF P1 .EQS. "ADVENTURE" THEN GOTO PLAY3
$	IF P1 .EQS. "QIX" 	THEN GOTO PLAY2
$	IF P1 .EQS. "INVADERS"  THEN GOTO INVADERS
$	IF P1 .EQS. "ROGUE"	THEN GOTO ROGUE
$	IF P1 .EQS. "VTDEMO"    THEN GOTO VTDEMO
$	GOTO PLAY1
$!
$ ROGUE:
$	ON CONTROL THEN GOTO END1
$	SET PROCESS/PRIORITY='PLAY_PRIO'
$	@SYS$GAMES:ROGUE
$	GOTO END1
$!
$ VTDEMO:
$	SET TERM/WID=255
$	GOTO PLAY3
$!
$ INVADERS:
$	PLAY_PRIO=2
$	IF CRETIN .EQ. 200 THEN PLAY_PRIO=1
$!
$!	Set VT100 terminal to VT52 mode
$ PLAY1:
$	RUN SYS$GAMES:SETVT52
$!
$!	Move to the games directory
$ PLAY2:
$	DEFDIR=F$LOGICAL("SYS$DISK")+F$DIRECTORY()
$	SET DEF 'GAMDEV'[GAMES]
$	NEWDEF="T"
$!
$ PLAY3:
$	ON CONTROL THEN GOTO END1
$	SET PROCESS/PRIORITY='PLAY_PRIO'
$	ASSIGN/USER 'GAMDEV'[GAMES] AI:
$	ASSIGN/USER 'GAMDEV'[GAMES.DOC]STARTREK.HLP HELPFILE
$	ASSIGN/USER 'F$LOGICAL("TT")' FOR001
$	ASSIGN/USER 'F$LOGICAL("TT")' FOR005
$	ASSIGN/USER 'F$LOGICAL("TT")' FOR006
$	ASSIGN/USER 'F$LOGICAL("TT")' FOR$ACCEPT
$	ASSIGN/USER 'F$LOGICAL("TT")' FOR$TYPE
$	ASSIGN/USER 'F$LOGICAL("TT")' SYS$INPUT
$!
$	IF P2 .EQS. "" .OR. F$LOCATE(P2,"DEBUG").NE.0 THEN GOTO NODEB
$	SET NOCONTROL=Y
$	SET   CONTROL=Y
$	RUN/DEBUG SYS$GAMES:'P1
$	GOTO END1
$!
$NODEB:	RUN SYS$GAMES:'P1
$END1:	SET PROCESS/PRIORITY='PLAY_CURPRI'
$	GOTO END
$!
$ NOSUCH:
$	WRITE SYS$OUTPUT "Sorry, no such game"
$ LIST:
$	WRITE SYS$OUTPUT "Games available are:"
$	TYPE SYS$GAMES:GAMELIST.DAT
$	WRITE SYS$OUTPUT ""
$!!!	WRITE SYS$OUTPUT "Type ""HELP @GAMES"" for help on selected games."
$	GOTO END
$!
$END:
$	IF NEWDEF THEN SET DEF 'DEFDIR
