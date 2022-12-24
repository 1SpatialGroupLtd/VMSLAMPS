C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-07-02 13:52:28.000000000 +0100
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
	LOGICAL FUNCTION RDPLN
C
CDEC$	IDENT	'02JL91'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	12-Jan-1990
C
C	CONVERT SIF2IFF Utility - Read parameters of SIF PLN command
C
C Description
C
C	Read parameters of SIF PLN command
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
	INCLUDE 'CMN:TEXT.CMN'		! text variables
	INCLUDE 'CMN:IFF_FEATURE.CMN'	! IFF
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	! command decoding
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
C
C Functions called
C
	INTEGER*4	READSTR		! read a string
	INTEGER*4	RDCOMM		! read a command
	LOGICAL		READ_SEP	! read a SIF command seperator
	LOGICAL		RDREAL		! read a real
	LOGICAL		FINDFC		! find a feature code
	LOGICAL		SKIP_CONTLIN	! skip over continuation lines
	LOGICAL		CONT_LINE	! test for continuation line
C
C Local Variables
C
	INTEGER*4	LEN		! string length
	INTEGER*4	I		! loop counter
	CHARACTER*80	DUMSTR		! dummy character string
	INTEGER*4	IDUMMY		! dummy integer
	INTEGER*4	RDUMMY		! dummy real
	INTEGER*4	RESULT		! command read result
	LOGICAL		OK		! function return status
	INTEGER		AXIS		! flag x or y axis
	REAL 		RUNITS		! conversion units as REAL
	REAL 		T11,T21		! rotation matrix
	BYTE		COMMA		! terminating character
	PARAMETER	(COMMA=',')
	BYTE		PTR		! decode pointer
	INTEGER		NOREAL		! real returned flag
C
C External declaration
C
	INTEGER*4	PLNCMD_CMD_TABLE
	EXTERNAL	PLNCMD_CMD_TABLE
C
C Assume that everything goes well
C
	RDPLN = .TRUE.
C
	IS_TEXT = .TRUE.
	NOMESS = .TRUE.
C
C Now, read the command from the line
C
500	RESULT = RDCOMM(PLNCMD_CMD_TABLE)
C
C and check that there was one - if not look for a text string
C
	IF (RESULT .LE. 0) GOTO 600
C
C Look for ',' or '=' seperator - send warning mess if not found
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
	GOTO (510,520,530) RESULT
C
C NE - Ignore mirroring, continue reading rest of line
C
510	LEN = READSTR(DUMSTR,COMMA,ON_CHAR)
	OK = READ_SEP(',')
	GOTO 500
C
C ED - ignore
C
520	LEN = READSTR(DUMSTR,COMMA,ON_CHAR)
	OK = READ_SEP(',')
	GOTO 500
C
C EN - trailing banks - ignore, read to next ','
C
530	LEN = READSTR(DUMSTR,COMMA,ON_CHAR)
	GOTO 500
C
C Read a text string
C
600	NCHS = READSTR(TEXT)
	IF (NCHS.EQ.0) THEN
	   CALL LSL_PUTMSG(SIF2IFF__TEXNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
C----------------------------------------------------------------------------
C
C Now ready to create a new IFF feature.
C
C
C First find feature code. If not found then output warning mess
C and ignore the feature, skipping any continuation lines
C
	IF (.NOT.FINDFC()) THEN
	   OK = SKIP_CONTLIN()
	   GOTO 9999
	ENDIF
C
C Start the feature
C
	CALL START_FEATURE
C
C Calculate text height and angle depending on the form of TXT
C
	IF (TXT_TYPE1) THEN
	   TLY = TLY - ((PAR_COUNT-1)*PAR_TH)
	   BLY = BLY - (PAR_COUNT*PAR_TH)
	   BRY = BLY
	   HEIGHT = TLY - BLY
	   IF (HEIGHT.EQ.0) HEIGHT = 1
	   IF (.NOT.HAD_TXT_AN) ANGLE = 0.0		!use default
C	   ANGLE = ATAN((BRY-BLY)/(BRX-BLX))		!in radians
	ELSE IF (TXT_TYPE2.OR.TXT_TYPE3) THEN
	   IF (HAD_TXT_TH) THEN
	      HEIGHT = TXT_HEIGHT
	   ELSE						!use default
	      HEIGHT = 100.0/RUNITS
	   ENDIF
	   IF (.NOT.HAD_TXT_AN) ANGLE = 0.0		!use default
	ENDIF
	PAR_COUNT = PAR_COUNT + 1
C
C Now write the feature
C
	CALL WRITE_FEATURE
	GOTO 9000
C
9999	RDPLN = .FALSE.
	IF (DONE_START_FEATURE) CALL IFFDEL
	DONE_START_FEATURE = .FALSE.
C
C Return
C
9000	IS_TEXT = .FALSE.
	NOMESS = .FALSE.
	RETURN
	END
