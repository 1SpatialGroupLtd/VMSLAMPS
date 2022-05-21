C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-07-02 14:55:08.000000000 +0100
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
	LOGICAL FUNCTION RDMTX
C
CDEC$	IDENT	'02JL91'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	10-Jan-1990
C
C	CONVERT SIF2IFF Utility - Read parameters of SIF MTX command
C
C Description
C
C	Read parameters of SIF MTX command
C
C	Returns FALSE for error in SIF command line
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	    ! message definitions
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'  ! LSLLIB message definitions
C
C Common Blocks
C
	INCLUDE 'CMN:SIF2IFF.CMN'	! globals
	INCLUDE 'CMN:IFF_FEATURE.CMN'	! IFF feature
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	! command decoding
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
C
C Functions called
C
	INTEGER*4	RDCOMM		! read a command
	LOGICAL		RDREAL		! read a real
	LOGICAL		READ_SEP	! read a seperator
	LOGICAL		RDCHS		! read a character
	LOGICAL		CONT_LINE	! test for continuation line
C
C Local Variables
C
	INTEGER*4	RESULT		! command read result
	LOGICAL		OK		! function return status
	LOGICAL		EOLN		! end of line flag
	LOGICAL		NOREAL		! real return status
	BYTE		ICH		! ASCII character
	REAL		XSC,YSC		! X and Y scale factors
C
C External declaration
C
	INTEGER*4	MTXCMD_CMD_TABLE
	EXTERNAL	MTXCMD_CMD_TABLE
C
C Assume that everything goes well
C
	RDMTX = .TRUE.
	XSC = 1.0
	YSC = 1.0
	ANGLE = 0.0
C
C Now, read the command from the line
C
500	RESULT = RDCOMM(MTXCMD_CMD_TABLE)
C
C and check that there was one
C
	IF (RESULT .LE. 0) GOTO 9999
C
C Look for '=' seperator - send warning mess if not found
C
	OK = READ_SEP(',')
	IF (.NOT.OK) THEN
	   CALL BSCH
	   OK = READ_SEP('=')
	   IF (.NOT.OK) THEN
	      CALL LSL_PUTMSG(SIF2IFF__SEPNOTFOU)	!warning mess
	      GOTO 9999
	   ENDIF
	ENDIF
C
C test for continuation line
	IF (.NOT.CONT_LINE()) GOTO 9999
C
C Despatch according to command
C
	GOTO (510,520,530,540,550) RESULT
C
C Unknown command
C
	CALL LSL_PUTMSG(SIF2IFF__UNKCMD,CMDNST)
	GOTO 9999
C
C MX - ignore mirroring
C
510	OK = READ_SEP(',')		
	IF (.NOT.OK) THEN
C
C If it's end of line, exit to RDSIF to read next line in SIF file
C
	   EOLN = RDCHS(ICH)
	   IF ((CHAR(ICH).EQ.' ').OR.EOLN) GOTO 600
C
	   CALL LSL_PUTMSG(SIF2IFF__EOLEXP)
	   GOTO 9999
	ENDIF
	GOTO 500
C
C MY - ignore mirroring
C
520	OK = READ_SEP(',')		
	IF (.NOT.OK) THEN
C
C If it's end of line, exit to RDSIF to read next line in SIF file
C
	   EOLN = RDCHS(ICH)
	   IF ((CHAR(ICH).EQ.' ').OR.EOLN) GOTO 600
C
	   CALL LSL_PUTMSG(SIF2IFF__EOLEXP)
	   GOTO 9999
	ENDIF
	GOTO 500
C
C AN - angle
C
530	NOREAL = RDREAL(ANGLE)			! save rotation angle
	IF (NOREAL) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	! warning if no integer
	   GOTO 9999
	ENDIF
	OK = READ_SEP(',')		
	IF (.NOT.OK) THEN
C
C If it's end of line, exit to RDSIF to read next line in SIF file
C
	   EOLN = RDCHS(ICH)
	   IF ((CHAR(ICH).EQ.' ').OR.EOLN) GOTO 600
C
	   CALL LSL_PUTMSG(SIF2IFF__EOLEXP)
	   GOTO 9999
	ENDIF
	ANGLE = (ANGLE * PI)/180.0		! convert to radians
	GOTO 500
C
C XS - ignore scale for time being
C
540	NOREAL = RDREAL(XSC)
	OK = READ_SEP(',')		
	IF (.NOT.OK) THEN
C
C If it's end of line, exit to RDSIF to read next line in SIF file
C
	   EOLN = RDCHS(ICH)
	   IF ((CHAR(ICH).EQ.' ').OR.EOLN) GOTO 600
C
	   CALL LSL_PUTMSG(SIF2IFF__EOLEXP)
	   GOTO 9999
	ENDIF
	GOTO 500
C
C YS - ignore scale for time being
C
550	NOREAL = RDREAL(YSC)
	OK = READ_SEP(',')		
	IF (.NOT.OK) THEN
C
C If it's end of line, exit to RDSIF to read next line in SIF file
C
	   EOLN = RDCHS(ICH)
	   IF ((CHAR(ICH).EQ.' ').OR.EOLN) GOTO 600
C
	   CALL LSL_PUTMSG(SIF2IFF__EOLEXP)
	   GOTO 9999
	ENDIF
	GOTO 500
C
600	SCALE_FACTOR = XSC*YSC*
     &  	(COS(ANGLE)*COS(ANGLE)-SIN(ANGLE)*SIN(ANGLE))
	GOTO 9000
C
9999	RDMTX = .FALSE.
C
C Return
C
9000	RETURN
	END
