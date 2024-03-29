C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-09-11 15:10:18.000000000 +0100
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
CDEC$	IDENT	'10DE91'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	10-Dec-1991
C
C Description:
C	This function reads the parameter file in order to find the
C       characteristics required for each DIGIT feature.
C
	IMPLICIT NONE
C
C Parameter Files
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'I2DIGITMSG.PAR'		! I2DIGIT messages
C
C Local Parameters
C
	BYTE		PLING			! comment delimiter
	PARAMETER	(PLING = '!')
C
C Common blocks
C
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'		! LSLLIB status flag
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'		! command decoding
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! Text input
	INCLUDE 'FILES.CMN'
	INCLUDE 'GENERAL.CMN'
	INCLUDE 'COMMANDS.CMN'
C
C Functions called
C
	INTEGER*4	FLROPN		! open file for reading
	INTEGER*4	FLRCLO		! close file for reading
	INTEGER*4	FLRLIN		! read in line from file
	INTEGER*4	RDCOMM		! read a command
	LOGICAL*4	RDCHS		! read next character
	INTEGER*4	INT_RANGE	! check range of parameter file values
C
C Local Variables
C
	INTEGER*4	STATUS		! Routine success status
	INTEGER*4	LINE		! count line numbers
	INTEGER*4	I		! counter
	INTEGER*4	J,JJ		! counter
	INTEGER*4	RESULT		! command read result
	INTEGER*4	ERRCOD		! LSLLIB error code
	INTEGER*4	RETCOD		! system error code
	LOGICAL		GOT_IT		! got FC in FC-layer table ?
	BYTE		CH		! character read
	INTEGER*4	OK		! success of INT_CHECK
C
C External declaration
C
	INTEGER*4	TABCMD_CMD_TABLE
	EXTERNAL	TABCMD_CMD_TABLE
C
C------------------------------------------------------------------------------
C
	PARRAY_PTR = 0
	STATUS = .TRUE.
C
10	CONTINUE
C
	ERRCOD = FLROPN(PARLUN,PARFILE,RETCOD)
C
C If unsuccessful output message
C
	IF (.NOT. ERRCOD) THEN
	   STATUS = I2DIGIT__ERROPN
	   CALL LSL_PUTMSG(STATUS,PARFILE(1:PARLEN))
	   CALL LSL_ADDMSG(ERRCOD)
	   IF (ERRCOD .EQ. LSL__SYSOPEN) CALL LSL_ADDMSG(RETCOD)
	   GOTO 999
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
	IF (.NOT.ERRCOD) THEN
	   STATUS = I2DIGIT__ERRRDPAR
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
	GOTO (505,510,520,530,540,550,560,570,580,590,600) RESULT
C
C Unknown command
C
	CALL LSL_PUTMSG(I2DIGIT__UNKCMD,CMDNST)
	GOTO 5555
C
505	IF (.NOT.HAD_RES) THEN
	   IF (INTARG(1).LT.1 .OR. INTARG(1).GE.100) THEN
	      CALL LSL_PUTMSG(I2DIGIT__DEFRES,RESOLUTION)
	      GOTO 500
	   ENDIF
	   RESOLUTION = INTARG(1)
	   HAD_RES = .TRUE.
	ENDIF
	GOTO 500
C
510	IF (.NOT.HAD_SCALEIFF) THEN
	   IF (REALAR(1).LE.0.0) THEN
	      CALL LSL_PUTMSG(I2DIGIT__BADSCALE,'IFF scale')
	      STATUS = .FALSE.
	      GOTO 999
	   ENDIF
	   SCALEIFF = REALAR(1)
	   HAD_SCALEIFF = .TRUE.
	ENDIF
	GOTO 500
C
520	IF (.NOT.HAD_SCALESHEET) THEN
	   IF (REALAR(1).LE.0.0) THEN
	      CALL LSL_PUTMSG(I2DIGIT__BADSCALE,'SHEET scale')
	      STATUS = .FALSE.
	      GOTO 999
	   ENDIF
	   SCALESHEET = REALAR(1)
	   HAD_SCALESHEET = .TRUE.
	ENDIF
	GOTO 500
C
530	IF (.NOT.HAD_SCALEFACTOR) THEN
	   IF (REALAR(1).LE.0.0) THEN
	      CALL LSL_PUTMSG(I2DIGIT__BADSCALE,'SCALE_FACTOR')
	      STATUS = .FALSE.
	      GOTO 999
	   ENDIF
	   SCALEFACTOR = REALAR(1)
	   HAD_SCALEFACTOR = .TRUE.
	ENDIF
	GOTO 500
C
540	IF (.NOT.HAD_OFFSET) THEN
	   IF (INTARG(1).LT.1 .OR. INTARG(2).LT.1) THEN
	      CALL LSL_PUTMSG(I2DIGIT__MINOFFSET)
	      STATUS = .FALSE.
	      GOTO 999	      
	   ENDIF
	   OFFSET(1) = INTARG(1)
	   OFFSET(2) = INTARG(2)
	   HAD_OFFSET = .TRUE.
	ENDIF
	GOTO 500
C
550	IF (.NOT.HAD_BORDER) THEN
	   IF (INTARG(1).LT.0) THEN
	      CALL LSL_PUTMSG(I2DIGIT__BADBORDER)
	      STATUS = .FALSE.
	      GOTO 999	      
	   ENDIF
	   BORDER = INTARG(1)
	   HAD_BORDER = .TRUE.
	ENDIF
	GOTO 500
C
560	IF (.NOT.HAD_XMIN) THEN
	   XMIN = REALAR(1)
	   HAD_XMIN = .TRUE.
	ENDIF
	GOTO 500
C
570	IF (.NOT.HAD_XMAX) THEN
	   XMAX = REALAR(1)
	   HAD_XMAX = .TRUE.
	ENDIF
	GOTO 500
C
580	IF (.NOT.HAD_YMIN) THEN
	   YMIN = REALAR(1)
	   HAD_YMIN = .TRUE.
	ENDIF
	GOTO 500
C
590	IF (.NOT.HAD_YMAX) THEN
	   YMAX = REALAR(1)
	   HAD_YMAX = .TRUE.
	ENDIF
	GOTO 500
C
600	OK = INT_RANGE(INTARG(1),0,32767,UNDEFINED,LINE,1)	! FC
	IF (.NOT.OK) GOTO 500
	OK = INT_RANGE(INTARG(2),0,999,UNDEFINED,LINE,2)	! font number
	IF (.NOT.OK) GOTO 500
	OK = INT_RANGE(INTARG(3),1,99,UNDEFINED,LINE,3)		! line width
	IF (.NOT.OK) GOTO 500
	OK = INT_RANGE(INTARG(4),1,3,UNDEFINED,LINE,4)		! curve type
	IF (.NOT.OK) GOTO 500
	OK = INT_RANGE(INTARG(5),4,5,9,LINE,5)			! termination
	IF (.NOT.OK) GOTO 500
	OK = INT_RANGE(INTARG(6),6,8,UNDEFINED,LINE,6)		! priority
	IF (.NOT.OK) GOTO 500
	OK = INT_RANGE(INTARG(7),1,12,UNDEFINED,LINE,7)		! colour
	IF (.NOT.OK) GOTO 500
C
C Save values. All value in this line were in range
C
	PARRAY_PTR = PARRAY_PTR + 1
	DO 700 JJ = 1,7
	   PARRAY(JJ,PARRAY_PTR) = INTARG(JJ)
700	CONTINUE
C
	GOTO 500
C
C Error decoding line
C
5555	CONTINUE
	STATUS = I2DIGIT__LINEINPAR	! informational message has correct
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
	   STATUS = I2DIGIT__ERRCLO
	   CALL LSL_PUTMSG(STATUS,PARFILE(1:PARLEN))
	   CALL LSL_ADDMSG(ERRCOD)
	   IF (ERRCOD .EQ. LSL__SYSCLOSE) CALL LSL_ADDMSG(RETCOD)
	   GOTO 999
	ENDIF
C
C Check max/min Easting and Northing
C
	GET_CPS = (.NOT.HAD_XMIN .OR. .NOT.HAD_XMAX .OR.
     &	           .NOT.HAD_YMIN .OR. .NOT.HAD_YMAX)
	IF (GET_CPS) THEN
	   CALL LSL_PUTMSG(I2DIGIT__NOEXTENT)
	ELSE
	   IF (XMIN.GE.XMAX .OR. YMIN.GE.YMAX) THEN
	      CALL LSL_PUTMSG(I2DIGIT__BADEXTENT)
	      STATUS = .FALSE.
	      GOTO 999
	   ENDIF
	ENDIF
C
999	RDPAR = STATUS
C
	RETURN
	END
