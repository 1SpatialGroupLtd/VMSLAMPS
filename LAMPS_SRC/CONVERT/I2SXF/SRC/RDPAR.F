C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-05-10 16:52:48.000000000 +0100
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
CDEC$	IDENT	'10MY90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					RJH	10-May-1990
C
C	CONVERT I2SXF Utility - Read parameter file
C
C Description
C
C	This function reads the parameter file which determines feature
C	code characteristics, etc
C
C	For ordinary errors, we attempt to continue with the file
C
C	Returns FALSE if something drastic goes wrong, TRUE otherwise
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'LSL$CMNI2SXF:I2SXFMSG.PAR' ! message definitions
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'  ! LSLLIB message definitions
C
C Local Parameters
C
	BYTE		PLING		! comment delimiter
	PARAMETER	(PLING = '!')
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	! command decoding
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filename parse
	INCLUDE 'LSL$CMNI2SXF:COMMANDS.CMN'	! command line things
	INCLUDE 'LSL$CMNI2SXF:TABLE.CMN'! feature description table
C
C Functions called
C
	INTEGER*4	FLROPN		! open file for reading
	INTEGER*4	FLRCLO		! close file for reading
	INTEGER*4	FLRLIN		! read in line from file
	INTEGER*4	RDCOMM		! read a command
	LOGICAL		RDCHS		! read next character
	LOGICAL		RDSXD		! read a feature description
C
C Local Variables
C
	INTEGER*4	LINE		! count line numbers
	INTEGER*4	I,J		! counters
	INTEGER*4	RESULT		! command read result
	INTEGER*4	ERRCOD		! LSLLIB error code
	INTEGER*4	RETCOD		! system error code
	BYTE		CH		! character read
C
C External declaration
C
	INTEGER*4	PARCMD_CMD_TABLE
	EXTERNAL	PARCMD_CMD_TABLE
C
C Assume that everything goes well
C
	RDPAR = .TRUE.
C
C Clear the translation tables
C
	TABLE_LEN = 0
C
C Open our parameter file, read only
C
	ERRCOD = FLROPN(PARLUN,PARFIL,RETCOD)
C
C If unsuccessful output message
C
	IF (.NOT. ERRCOD) THEN
	   CALL LSL_PUTMSG(I2SXF__ERROPNPAR,PARFIL(1:PARLEN))
	   CALL LSL_ADDMSG(ERRCOD)
	   IF (ERRCOD .EQ. LSL__SYSOPEN) CALL LSL_ADDMSG(RETCOD)
	   GOTO 9999
C
C Otherwise let them know what we are doing if that's what they'd like
C
	ELSEIF (HAD_LOG) THEN
	   CALL LSL_PUTMSG(I2SXF__READPAR)
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
	   CALL LSL_PUTMSG(I2SXF__ERRRDPAR,PARFIL(1:PARLEN),LINE)
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
	GOTO (510) RESULT
C
C Unknown command
C
	CALL LSL_PUTMSG(I2SXF__UNKCMD,CMDNST)
	GOTO 5555
C
C SXD - SXF description
C
510	IF ( .NOT. RDSXD() ) THEN
	   IF (LSL_STATUS .EQ. I2SXF__TABLEFULL) GOTO 9999
	   GOTO 5555
	ENDIF
	GOTO 500
C
C Error decoding line
C
5555	CALL LSL_ADDMSG(I2SXF__LINEINPAR,LINE)
	LSL_STATUS = I2SXF__LINEINPAR		! reduce error status
	GOTO 500
C
C Close the file
C
800	ERRCOD = FLRCLO(PARLUN,RETCOD)
C
C If unsuccessful output message
C
	IF (.NOT. ERRCOD) THEN
	   CALL LSL_PUTMSG(I2SXF__ERRCLOPAR,PARFIL(1:PARLEN))
	   CALL LSL_ADDMSG(ERRCOD)
	   IF (ERRCOD .EQ. LSL__SYSCLOSE) CALL LSL_ADDMSG(RETCOD)
C
C Otherwise just finish
C
	ELSE
	   GOTO 9000
	ENDIF
C
C Failure
C
9999	RDPAR = .FALSE.
C
C Return
C
9000	RETURN
	END
