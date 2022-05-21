C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1993-07-16 15:52:30.000000000 +0100
C *
C * This program is free software: you can redistribute it and/or modify
C * it under the terms of the GNU General Public License as published by
C * the Free Software Foundation, version 3.
C *
C * This program is distributed in the hope that it will be useful, but
C * WITHOUT ANY WARRANTY; without even the implied warranty of
C * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
C * General Public License for more details.
C *
C * You should have received a copy of the GNU General Public License
C * along with this program. If not, see http://www.gnu.org/licenses/.
C
	PROGRAM DCW2I
C
CDEC$	IDENT	'16JL93'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created from DTMCEATE module TRIANG.SRC		ST	13-May-1992
C
C Description:
C
C       The main routine containing the command line loop which dispatches
C       to appropriate functions for each command. Deals with reading from
C       indirect input files and gets everything set up before the 'GO'.
C
        IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'DCW2IMSG.PAR'
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'
C
C Common blocks
C
	INCLUDE 'GENERAL.CMN'
	INCLUDE 'SELECTIONS.CMN'
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'
	INCLUDE '($SSDEF)/NOLIST'
C
C Command tables
C
	EXTERNAL	DCW2I_CMD_TABLE
	INTEGER		DCW2I_CMD_TABLE
C
C Functions
C
	INTEGER*4	LIB$GET_LUN	! get LUN for IFF file
	INTEGER*4	LIB$FREE_LUN	! free the LUN of IFF file
	LOGICAL		DEVICE_CMD	! read device name
	LOGICAL		ENABLE_CMD	! decode enable keywords
	LOGICAL		GO_CMD		! check if we can go
	LOGICAL		READ_FILE	! read FC/AC file
	LOGICAL		SELECT_CMD	! determine selections
	LOGICAL         SHOW_CMD	! show status
	LOGICAL         SPAWN_CMD	! for DCL SPAWN
	LOGICAL         TARGET_CMD	! for destination of IFF files
	LOGICAL		EXAMINE_TERM	! examine terminal
	LOGICAL		EXTRACT		! start the extraction
	INTEGER         FLRSTR		! read record from file
	INTEGER         FLROPN		! open file for LSLLIB FILEO	
	LOGICAL		GETFILNAM	! read file-spec
	LOGICAL  	RDCHS		! read character from line
	LOGICAL 	RDCOMM  	! read command from line
	LOGICAL		SIGCHS		! gets # significant characters
	INTEGER		TTRSTR  	! read line from terminal
C
C Local workspace
C
	BYTE		CH		! for use with RDCHS
	INTEGER		CMD     	! decoded command number
	INTEGER		I,J 		! temp loop vars.
	INTEGER		IERR		! error return
	INTEGER		INDLEN		! length of indirect file-spec
	LOGICAL		OK		! function return
	CHARACTER*128	INDFILE		! indirect command file name
	CHARACTER*100	DEFNAM		! default device for filename
C
C ......................................................................
C
C Initialise 
C
	CALL LSL_INIT
C
C Check what SYS$OUTPUT is assigned to and if a terminal is it a CRT?
C
	OK=EXAMINE_TERM()
	IF (.NOT.OK) GOTO 290
C
C Starting conditions
C
	TTIN = .TRUE.
	HAD_ENA_REPLY = .TRUE.
	HAD_ENA_VERB  = .TRUE.
	WANT_ALL_CLASSES = .TRUE.
	WANT_AREAS  = .TRUE.
	WANT_LINES  = .TRUE.
	WANT_POINTS = .TRUE.
	WANT_TEXT   = .TRUE.
	TEXTGAP = 100.0
C
C Get free LUNs
C
	OK = LIB$GET_LUN(INDLUN)
	IF (OK) OK = LIB$GET_LUN(IFFLUN)
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(DCW2I__NOFREELUN)
	   GOTO 290
	ENDIF
C
C Announce program
C
	CALL WRITEF('Digital Chart of the World to IFF converter')
	CALL VERSION('Version 1.3')
C
C ......................................................................
C
C Get an input line from the terminal
10	TXTPTR=80
	IF (TTIN) THEN
	   OK=TTRSTR(,,'DCW2I> ',IERR)
	ELSE
	   CALL FLRSEL(INDLUN)
	   OK=FLRSTR(,,IERR)
	ENDIF
	IF (.NOT.OK) THEN
	   IF (OK.EQ.LSL__EOF) THEN
	      IF (TTIN) THEN
	         GOTO 290		! end of file = exit
	      ELSE
		 CALL LSL_PUTMSG(DCW2I__UNEXPEND)
		 CALL WRITEF
	         GOTO 85		! close indirect file etc.
	      ENDIF
	   ENDIF
	   CALL LSL_PUTMSG(OK)
	   CALL LSL_ADDMSG(IERR)
	   CALL WRITEF
	   GOTO 20
	ENDIF
C
C echo and decode the line
	IF (.NOT.TTIN) THEN
	   CALL EXPAND('DCW2I> ')
	   CALL APPEND(TXTDSC) ! echo indirect input
	   CALL TTWSTR
	ENDIF
	CALL BSLN
C
C Look for comment
	IF (RDCHS(CH)) GOTO 10	! substantially empty line
	IF (CH.EQ.'!') GOTO 10	! comment!
C
C Look for indirect file start
	IF (TTIN) THEN
	   IF (CH.EQ.'@') THEN
	      IF (RDCHS(CH)) THEN	! substantially empty line
		 CALL LSL_PUTMSG(DCW2I__NOFILNAM)
		 CALL WRITEF
	         GOTO 20
	      ELSE
	         CALL BSCH
	      ENDIF
	      DEFNAM='SYS$DISK:[]'
	      OK=GETFILNAM(INDFILE,INDLEN,
     &		DEFNAM(1:SIGCHS(DEFNAM))//'.COM;0',.TRUE.,%REF('!'))
	      IF (INDLEN.LT.1) THEN
	         CALL LSL_PUTMSG(LSL__SRCFILNAM)
		 CALL WRITEF
		 GOTO 20
	      ENDIF
	      IF (OK) THEN
	         CALL STR$UPCASE(INDFILE,INDFILE)
	      ELSE
	         CALL LSL_PUTMSG(OK)
	         CALL LSL_ADDMSG(IERR)
		 CALL WRITEF
	         GOTO 20
	      ENDIF
	      OK=FLROPN(INDLUN, INDFILE(:INDLEN), IERR)
	      IF (OK) THEN
		 CALL LSL_PUTMSG(DCW2I__CMDINPUT,INDFILE(:INDLEN))
		 CALL WRITEF
	         TTIN=.FALSE.
	         GOTO 10
	      ELSE
		 CALL LSL_PUTMSG(DCW2I__CANTOPEN,INDFILE(:INDLEN))
	         CALL LSL_PUTMSG(OK)
	         CALL LSL_ADDMSG(IERR)
		 CALL WRITEF
	         GOTO 20
	      ENDIF
	   ENDIF			! CH .. @
	ENDIF
	CALL BSCH			! un-read non-'@'
C
	CMD=RDCOMM(DCW2I_CMD_TABLE)
	GOTO (	20,
     &		25,			! acfile
     &		30,			! deselect
     &		40,			! device
     &		50,			! disable
     &		60,			! enable
     &		300,			! fcfile
     &		200,			! go
     &		70,			! quit
     &		80,			! return
     &		90,			! select
     &		100,			! show
     &		110,			! spawn
     &		120,			! target
     &		130			! textgap
     &	      		), CMD+1
C
C command number out of range
C
	CALL WRITEF
C
C close indirect input following disaster
20	IF (.NOT.TTIN) THEN
	   TTIN=.TRUE.
	   CALL FLRCLO(INDLUN)
	   CALL LSL_PUTMSG(DCW2I__INDERR)
	ENDIF
	IF (CMD.EQ.0) CALL WRITEF
	GOTO 10
C
C ......................................................................
C ACFILE 'filename'
C
25	IF (.NOT.READ_FILE(.FALSE.)) GOTO 20	! .FALSE. means AC file
	GOTO 10
C
C ......................................................................
C DESELECT 'sub-command'
C
30	IF (.NOT.SELECT_CMD(.FALSE.)) GOTO 20	! call select_cmd with FALSE
	GOTO 10
C
C ......................................................................
C DEVICE
C
40	IF (.NOT.DEVICE_CMD()) GOTO 20
	GOTO 10
C
C ......................................................................
C DISABLE 'sub-command'
C
50	IF (.NOT.ENABLE_CMD(.FALSE.)) GOTO 20
	GOTO 10
C
C ......................................................................
C ENABLE 'sub-command'
C
60	IF (.NOT.ENABLE_CMD(.TRUE.)) GOTO 20
	GOTO 10
C
C ......................................................................
C FCFILE 'filename'
C
300	IF (.NOT.READ_FILE(.TRUE.)) GOTO 20	 ! .TRUE. means FC file
	GOTO 10
C
C ......................................................................
C QUIT
C
70	OK=SS$_NORMAL
	GOTO 290
C
C ......................................................................
C RETURN - return to terminal input
C
80	IF (TTIN) THEN
	   CALL LSL_PUTMSG(DCW2I__NORET)
	ELSE
	   CALL LSL_PUTMSG(DCW2I__RETURN)
	ENDIF
	CALL WRITEF
85	IF (.NOT.TTIN) CALL FLRCLO(INDLUN)
	TTIN=.TRUE.
	GOTO 10
C
C ......................................................................
C SELECT 'sub-command'
C
90	IF (.NOT.SELECT_CMD(.TRUE.)) GOTO 20
	GOTO 10
C ......................................................................
C SHOW
100	IF (.NOT.SHOW_CMD()) GOTO 20
	GOTO 10
C
C ......................................................................
C SPAWN DCL process - primarily designed for file management
C
110	IF (.NOT.SPAWN_CMD()) GOTO 20
	GOTO 10
C
C ......................................................................
C TARGET 'directory'
C
120	IF (.NOT.TARGET_CMD()) GOTO 20
	GOTO 10
C ......................................................................
C TEXTGAP 'real'
C
130	IF (CMDRCT.NE.1) GOTO 20
	TEXTGAP = REALAR(1)
	IF (HAD_ENA_REPLY) THEN
	   CALL WRITEF('Text gap tol  : %^F%F0.3',TEXTGAP)
	   CALL WRITEF
	ENDIF
	GOTO 10
C
C ......................................................................
C GO
C
200	IF (.NOT.GO_CMD()) GOTO 20
	OK = EXTRACT()
C
C ......................................................................
290	CALL LIB$FREE_LUN(IFFLUN)
	IF (OK) THEN
	   CALL LSL_EXIT(SS$_NORMAL)
	ELSE
	   CALL LSL_EXIT(SS$_ABORT)
	ENDIF
C
	END
