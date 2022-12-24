C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-07-02 13:52:44.000000000 +0100
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
	LOGICAL FUNCTION RDPTN
C
CDEC$	IDENT	'02JL91'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	10-Jan-1990
C
C	CONVERT SIF2IFF Utility - Read parameters of SIF PTN command
C
C Description
C
C	Read parameters of SIF PTN command
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
	INCLUDE 'CMN:TEXT.CMN'		! 
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	! command decoding
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
C
C Functions called
C
	INTEGER*4	RDCOMM		! read a command
	LOGICAL		RDLONG		! read an integer
	LOGICAL		READ_SEP	! read a seperator
	LOGICAL		READSTR		! read a string
	LOGICAL		RDCHS		! read a character
	LOGICAL		CONT_LINE	! test for continuation line
C
C Local Variables
C
	INTEGER*4	I		! loop counter
	INTEGER*4	IDUMMY		! dummy integer
	INTEGER*4	RESULT		! command read result
	LOGICAL		OK		! function return status
	LOGICAL		EOLN		! end of line flag
	LOGICAL		NOLONG		! integer return status
	LOGICAL		HAD_PT		! flag /PT parameter
	BYTE		ICH		! ASCII character
	BYTE		PTR		! TXTBUF pointer
C
C External declaration
C
	INTEGER*4	PTNCMD_CMD_TABLE
	EXTERNAL	PTNCMD_CMD_TABLE
C
C Assume that everything goes well
C
	RDPTN = .TRUE.
	HAD_PT = .FALSE.
	HAD_PTN = .TRUE.
C
C Now, read the command from the line
C
500	RESULT = RDCOMM(PTNCMD_CMD_TABLE)
C
C and check that there was one
C
	IF (RESULT .LE. 0) THEN
	   IF (HAD_PT) THEN
	      CALL DCPSET(PTR)
	      GOTO 600
	   ELSE
	     GOTO 9999
	   ENDIF
	ENDIF
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
C Unknown command
C
	CALL LSL_PUTMSG(SIF2IFF__UNKCMD,CMDNST)
	GOTO 9999
C
C PT - pattern type
C
510	NOLONG = RDLONG(PATTYPE)
	IF (NOLONG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	! warning if no integer
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
	HAD_PT = .TRUE.
	CALL DCPSAV(PTR)
	GOTO 500
C
C PS - ignore pattern scale
C
520	NOLONG = RDLONG(IDUMMY)		
	IF (NOLONG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	! warning if no integer
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
	CALL DCPSAV(PTR)
	GOTO 500
C
C PA - ignore pattern angle
C
530	NOLONG = RDLONG(IDUMMY)			! save line colour value
	IF (NOLONG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	! warning if no integer
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
	CALL DCPSAV(PTR)
	GOTO 500
C
C PD - ignore pattern delta
C
540	DO 541 I = 1,3
	   NOLONG = RDLONG(IDUMMY)			! save line pattern value
	   OK = READ_SEP(',')		
541	CONTINUE
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
	CALL DCPSAV(PTR)
	GOTO 500
C
C OF - set pattern name to 'NOPAT' to switch off patterning
C
550	PATNAM = 'NOPAT'
	HAD_PTN = .FALSE.
	GOTO 9000
C
C Read the pattern name
C
600	PATLEN = READSTR(PATNAM)
	IF (PATLEN.EQ.0) THEN
	   CALL LSL_PUTMSG(SIF2IFF__TEXNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
C
9999	RDPTN = .FALSE.
C
C Return
C
9000	RETURN
	END
