C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-02-25 11:52:14.000000000 +0000
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
	LOGICAL FUNCTION RDPAR(PARFILE)
C
CDEC$	IDENT	'28JA91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Pinched from ARC2I              	ST	 8-Jan-1991
C	Implemented				RJH	 2-Jun-1989
C	Created					RJH	24-Sep-1987
C
C Description:
C
C	This function reads the parameter file which translates 
C	ARC/INFO attributes into IFF feature codes
C
C	For ordinary errors, we attempt to continue with the file
C
C	Returns FALSE if something drastic goes wrong, TRUE otherwise
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'HERE:I2ARCMSG.PAR'		! I2ARC messages
	INCLUDE 'HERE:LUN.PAR'			! Logical units for file I/O
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
C
	CHARACTER*(*)	PARFILE
C
C Functions called
C
	INTEGER*4	FLROPN		! open file for reading
	INTEGER*4	FLRCLO		! close file for reading
	INTEGER*4	FLRLIN		! read in line from file
	INTEGER*4	RDCOMM		! read a command
	LOGICAL		RDCHS		! read next character
	LOGICAL		RDADT		! read attribute description
C
C Local Variables
C
	INTEGER*4	LINE		! count line numbers
	INTEGER*4	I		! counter
	INTEGER*4	J		! counter
	INTEGER*4	RESULT		! command read result
	INTEGER*4	ERRCOD		! LSLLIB error code
	INTEGER*4	RETCOD		! system error code
	LOGICAL		GOT_IT		! got FC in FC-layer table ?
	BYTE		CH		! character read
	INTEGER*4	PARLEN          ! calculated length of filename
C
C External declaration
C
	INTEGER*4	PARCMD_CMD_TABLE
	EXTERNAL	PARCMD_CMD_TABLE
C
C-------------------------------------------------------------------------------
C
C Assume that everything goes well
C
	RDPAR = .TRUE.
C
C Determine parameter file name length
C
	DO 10 I = 1,80
	   IF (PARFILE(I:I).EQ.' ') THEN
	      PARLEN=I-1
	      GOTO 20
	   ENDIF
10	CONTINUE
C
20	ERRCOD = FLROPN(PARLUN,PARFILE,RETCOD)
C
C If unsuccessful output message
C
	IF (.NOT. ERRCOD) THEN
	   CALL LSL_PUTMSG(I2ARC__ERROPN,PARFILE(1:PARLEN))
	   CALL LSL_ADDMSG(ERRCOD)
	   IF (ERRCOD .EQ. LSL__SYSOPEN) CALL LSL_ADDMSG(RETCOD)
	   GOTO 9999
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
	   CALL LSL_PUTMSG(I2ARC__ERRRDPAR,PARFILE(1:PARLEN),LINE)
	   CALL LSL_ADDMSG(ERRCOD)
	   IF (ERRCOD .EQ. LSL__SYSREAD) CALL LSL_ADDMSG(RETCOD)
	   GOTO 9999
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
	RESULT = RDCOMM(PARCMD_CMD_TABLE)
C
C and check that there was one
C
	IF (RESULT .LE. 0) GOTO 5555
C
C Despatch according to command
C
C	def_line,def_sym,def_txt,arc_att
	GOTO (510,520,530,540) RESULT
C
C Unknown command
C
	CALL LSL_PUTMSG(I2ARC__UNKCMD,CMDNST)
	GOTO 5555
C
C Default line, symbol and text feature codes
C
510	CONTINUE
!	LINE_FC = INTARG(1)            /* Not used in I2ARC parameter file */
	GOTO 500
C
520	CONTINUE
!	SYMB_FC = INTARG(1)            /* Not used in I2ARC parameter file */
	GOTO 500
C
530	CONTINUE
!	TEXT_FC = INTARG(1)            /* Not used in I2ARC parameter file */
	GOTO 500
C
C ARC attribute description
C
540	CONTINUE
	IF ( .NOT. RDADT() ) GOTO 5555
	GOTO 500
C
C Error decoding line
C
5555	CONTINUE
	CALL LSL_ADDMSG(I2ARC__LINEINPAR,LINE)
	LSL_STATUS = I2ARC__LINEINPAR		! reduce error status
	GOTO 500
C
C Close the file
C
800	continue
	ERRCOD = FLRCLO(PARLUN,RETCOD)
C
C If unsuccessful output message
C
	IF (.NOT. ERRCOD) THEN
	   CALL LSL_PUTMSG(I2ARC__ERRCLO,PARFILE(1:PARLEN))
	   CALL LSL_ADDMSG(ERRCOD)
	   IF (ERRCOD .EQ. LSL__SYSCLOSE) CALL LSL_ADDMSG(RETCOD)
	   GOTO 9999
	ENDIF
	GOTO 9000
C
C Failure
C
9999	RDPAR = .FALSE.
C
C Return
C
9000	RETURN
	END
