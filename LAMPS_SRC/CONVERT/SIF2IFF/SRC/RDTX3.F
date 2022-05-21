C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-07-02 14:54:30.000000000 +0100
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
	LOGICAL FUNCTION RDTX3
C
CDEC$	IDENT	'02JL91'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	12-Jan-1990
C
C	CONVERT SIF2IFF Utility - Read parameters of SIF TX3 command
C
C Description
C
C	Read parameters of SIF TX3 command
C
C	Returns FALSE for error in SIF command line
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	    ! message definitions
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'  ! LSLLIB message definitions
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'    ! LSLLIB message definitions
C
C Common Blocks
C
	INCLUDE 'CMN:SIF2IFF.CMN'	! globals
	INCLUDE 'CMN:FLAGS.CMN'		! flags
	INCLUDE 'CMN:TEXT.CMN'		! text variables
	INCLUDE 'CMN:IFF_FEATURE.CMN'	! IFF
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	! command decoding
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
C
C Functions called
C
	INTEGER*4	RDCOMM		! read a command
	LOGICAL		READ_SEP	! read a SIF command seperator
	LOGICAL		RDCHS		! read an ASCII character
	LOGICAL		RDREAL		! read a real
	LOGICAL		RDLONG		! read a long integer
	LOGICAL		GET_XYZ
	LOGICAL		CONT_LINE	! test for continuation line
C
C Local Variables
C
	INTEGER*4	RESULT		! command read result
	LOGICAL		OK		! function return status
	LOGICAL		EOLN		! end of line flag
	INTEGER		AXIS		! flag x or y axis
	REAL		RDUMMY		! dummy real
	REAL		X,Y,Z		! coords
	BYTE		ICH		! ASCII character
	INTEGER		NOREAL		! real returned flag
	INTEGER		NOLONG		! integer returned flag
C
C External declaration
C
	INTEGER*4	TX3CMD_CMD_TABLE
	EXTERNAL	TX3CMD_CMD_TABLE
C
C Assume that everything goes well
C
	IS_TEXT = .TRUE.
	RDTX3 = .TRUE.
C
	TXT_TYPE3 = .TRUE.
	HAD_TXT_AN = .FALSE.
	HAD_TXT_TH = .FALSE.
	HAD_TX3 = .TRUE.
C
C Now, read the command from the line
C
500	RESULT = RDCOMM(TX3CMD_CMD_TABLE)
C
C and check that there was one - but could be a text string
C
	IF (RESULT .LE. 0) GOTO 9999
C
C Look for '=' seperator - send warning mess if not found
C
	OK = READ_SEP('=')
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(SIF2IFF__SEPNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
C
C test for continuation line
	IF (.NOT.CONT_LINE()) GOTO 9999
C
C Despatch according to command
C
	GOTO (510,520,530,540) RESULT
C
C OR - text origin
C
510	CONTINUE
C
C Get text origin
C
	IF (.NOT.GET_XYZ()) GOTO 9999
	EOLN = RDCHS(ICH)
	CALL BSCH
	IF (EOLN) GOTO 9000
C
	GOTO 500				!get next command or text string
C
C TH - text height
C
520	NOLONG = RDLONG(TXT_HEIGHT)
	IF (NOLONG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	HAD_TXT_TH = .TRUE.
	OK = READ_SEP(',')		
	IF (.NOT.OK) THEN
C
C If it's end of line, exit to RDSIF to read next line in SIF file
C
	   EOLN = RDCHS(ICH)
	   IF ((CHAR(ICH).EQ.' ').OR.EOLN) GOTO 9000
C
	   CALL LSL_PUTMSG(SIF2IFF__EOLEXP)
	   GOTO 9999
	ENDIF
	GOTO 500				!get next command or text string
C
C TW - text width
C
530	NOLONG = RDLONG(TXT_WIDTH)
	IF (NOLONG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	OK = READ_SEP(',')		
	IF (.NOT.OK) THEN
C
C If it's end of line, exit to RDSIF to read next line in SIF file
C
	   EOLN = RDCHS(ICH)
	   IF ((CHAR(ICH).EQ.' ').OR.EOLN) GOTO 9000
C
	   CALL LSL_PUTMSG(SIF2IFF__EOLEXP)	
	   GOTO 9999
	ENDIF
	GOTO 500				!get next command or text string
C
C AN - text angle in degrees
C
540	NOREAL = RDREAL(TXT_ANGLE)
	IF (NOREAL) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	ANGLE = (TXT_ANGLE * PI)/180.0		! convert to radians
	HAD_TXT_AN = .TRUE.
	OK = READ_SEP(',')		
	IF (.NOT.OK) THEN
C
C If it's end of line, exit to RDSIF to read next line in SIF file
C
	   EOLN = RDCHS(ICH)
	   IF ((CHAR(ICH).EQ.' ').OR.EOLN) GOTO 9000
C
	   CALL LSL_PUTMSG(SIF2IFF__EOLEXP)	
	   GOTO 9999
	ENDIF
	GOTO 500				!get next command or text string
C
9999	RDTX3 = .FALSE.
C
C Return
C
9000	RETURN
	END
