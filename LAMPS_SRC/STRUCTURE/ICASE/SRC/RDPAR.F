C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-11-01 14:55:26.000000000 +0000
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
	LOGICAL FUNCTION RDPAR
C
CDEC$	IDENT	'28OC91'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	16-Sep-1991
C
C Description:
C	This function reads the parameter file in order to find the
C       FCs and widths for road casings and road fills
C	For ordinary errors, we attempt to continue with the file
C	Returns FALSE if something drastic goes wrong, TRUE otherwise
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'LSL$ICASE:ICASEMSG.PAR'	! ICASE messages
C
C Local Parameters
C
	BYTE		PLING		! comment delimiter
	PARAMETER	(PLING = '!')
C
C Common blocks
C
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'		! LSLLIB status flag
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'		! command decoding
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! Text input
	INCLUDE 'LSL$ICASE:ICASE.CMN'
	INCLUDE 'LSL$ICASE:CMDLIN.CMN'
C
C Functions called
C
	INTEGER*4	FLROPN		! open file for reading
	INTEGER*4	FLRCLO		! close file for reading
	INTEGER*4	FLRLIN		! read in line from file
	INTEGER*4	RDCOMM		! read a command
	LOGICAL*4	RDCHS		! read next character
	LOGICAL*4	CHECK_GT	! check GT in FRT
C
C Local Variables
C
	INTEGER*4	STATUS		! Routine success status
	INTEGER*4	LINE		! count line numbers
	INTEGER*4	I		! counter
	INTEGER*4	J		! counter
	INTEGER*4	RESULT		! command read result
	INTEGER*4	ERRCOD		! LSLLIB error code
	INTEGER*4	RETCOD		! system error code
	LOGICAL		GOT_IT		! got FC in FC-layer table ?
	BYTE		CH		! character read
	INTEGER*4	MIN_WIDTH
	INTEGER*2	IFCODE
	INTEGER*2	CASECO
	INTEGER*2	AREACO
	INTEGER*4	PRI
	REAL*4		CASEWID
	REAL*4		AREAWID
C
C External declaration
C
	INTEGER*4	TABCMD_CMD_TABLE
	EXTERNAL	TABCMD_CMD_TABLE
C
C------------------------------------------------------------------------------
C
	STATUS = .TRUE.
	MIN_WIDTH = 1000000.0
C
	DO 10 I=0,MAXFC
	   CASECODE(I)=-1
	   AREACODE(I)=-1
	   CASEWIDTH(I)=-1.0     ! Casing width
	   AREAWIDTH(I)=-1.0     ! Road width
10	CONTINUE
C
	ERRCOD = FLROPN(PARLUN,PARFILE,RETCOD)
C
C If unsuccessful output message
C
	IF (.NOT. ERRCOD) THEN
	   STATUS=ICASE__ERROPN
	   CALL LSL_PUTMSG(STATUS,PARFILE(1:PARLEN))
	   CALL LSL_ADDMSG(ERRCOD)
	   IF (ERRCOD .EQ. LSL__SYSOPEN) CALL LSL_ADDMSG(RETCOD)
	   GOTO 999
C
C Otherwise let them know what we are doing if that's what they'd like
C
	ENDIF
C
C Haven't got a line yet
C
	LINE = 0
C
C So let us read in the lines, one by one
C
500	LINE = LINE+1
C
	ERRCOD = FLRLIN(,,,RETCOD)
	IF (ERRCOD .EQ. LSL__EOF) GOTO 800
C
C If unsuccessful output message
C
	IF (.NOT. ERRCOD) THEN
	   STATUS=ICASE__ERRRDPAR
	   CALL LSL_PUTMSG(STATUS,PARFILE(1:PARLEN),LINE)
	   CALL LSL_ADDMSG(ERRCOD)
	   IF (ERRCOD .EQ. LSL__SYSREAD) CALL LSL_ADDMSG(RETCOD)
	   GOTO 999
	ENDIF
C
C Now reset the decoding pointer to the start of the line
C
	CALL BSLN
C
C Check for a comment delimiter - ignore an empty line
C
	IF ( RDCHS( CH ) ) GOTO 500
	IF ( CH.EQ.PLING ) THEN
	   GOTO 500			! ignore line
	ELSE
	   CALL BSCH			! unread non-pling
	ENDIF
C
C Now, read the command from the line
C
	RESULT = RDCOMM(TABCMD_CMD_TABLE)
C
C and check that there was one
C
	IF (RESULT .LE. 0) GOTO 5555
C
C Despatch according to command
C
	GOTO (510) RESULT
C
C Unknown command
C
	CALL LSL_PUTMSG(ICASE__UNKCMD,CMDNST)
	GOTO 5555
C
C Default line, symbol and text feature codes
C
510	CONTINUE
	IFCODE=INTARG(1)
	PRI=INTARG(2)
	CASECO=INTARG(3)
	AREACO=INTARG(4)
	CASEWID=REALAR(1)
	AREAWID=REALAR(2)
C
	CASEWID=CASEWID*0.5
	AREAWID=AREAWID*0.5
C
C Only find minimum width if needed
C
	IF (.NOT.HAD_TOL) THEN
	   IF (AREAWID.LT.MIN_WIDTH) MIN_WIDTH=AREAWID
	   IF (CASEWID.LT.MIN_WIDTH) MIN_WIDTH=CASEWID
	ENDIF
C
C Check GT of featurs in FRT
C    IFCODE must be GT 1
C    CASECO must be GT 1
C    AREACO must be GT 12
C
	IF (HAD_FRT) THEN
	   STATUS=CHECK_GT(IFCODE,IFCODE,1)
	   IF (.NOT.STATUS) GOTO 800
	   STATUS=CHECK_GT(IFCODE,CASECO,1)
	   IF (.NOT.STATUS) GOTO 800
	   STATUS=CHECK_GT(IFCODE,AREACO,12)
	   IF (.NOT.STATUS) GOTO 800
	ENDIF
C
C Save values
C
	PRIORITY(IFCODE)=PRI
	CASEWIDTH(IFCODE)=CASEWID
	CASECODE(IFCODE)=CASECO
	AREAWIDTH(IFCODE)=AREAWID
	AREACODE(IFCODE)=AREACO
C
	GOTO 500
C
C Error decoding line
C
5555	CONTINUE
	STATUS = ICASE__LINEINPAR	! informational message has correct
	CALL LSL_ADDMSG(STATUS,LINE)	! 'severity' bits set
	GOTO 500
C
C Close the file
C
800	ERRCOD = FLRCLO(PARLUN,RETCOD)
C
C If unsuccessful output message
C
	IF (.NOT. ERRCOD) THEN
	   STATUS=ICASE__ERRCLO
	   CALL LSL_PUTMSG(STATUS,PARFILE(1:PARLEN))
	   CALL LSL_ADDMSG(ERRCOD)
	   IF (ERRCOD .EQ. LSL__SYSCLOSE) CALL LSL_ADDMSG(RETCOD)
	   GOTO 999
	ENDIF
C
C Default the tolerance to the minimum width
C
	IF (.NOT.HAD_TOL) THEN
	   TOL=MIN_WIDTH
	ENDIF
C
999	RDPAR = STATUS
C
	RETURN
	END
