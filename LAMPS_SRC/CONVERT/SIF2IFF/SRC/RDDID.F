C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-07-02 12:47:48.000000000 +0100
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
	LOGICAL FUNCTION RDDID
C
CDEC$	IDENT	'02JL91'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	10-Jan-1990
C
C	CONVERT SIF2IFF Utility - Read parameters of SIF DID command
C
C Description
C
C	Read parameters of SIF DID command
C
C	Returns FALSE for error in SIF command line
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	    ! message definitions
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'  ! LSLLIB message definitions
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'    ! for routine READSTR
C
C Common Blocks
C
	INCLUDE 'CMN:SIF2IFF.CMN'	! globals
	INCLUDE 'CMN:IFF_MAP.CMN'	! IFF map data
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	! command decoding
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'	! text buffer
C
C Functions called
C
	INTEGER*4	RDCOMM		! read a command
	INTEGER*4	READSTR		! read a string
	LOGICAL		RDLONG		! read a longword integer
	LOGICAL		READ_SEP	! read a seperator
	LOGICAL		CONT_LINE	! test for continuation line
	LOGICAL		RDCH		! read a character
	LOGICAL		RDCHS		! read a character - skip spaces
C
C Local Variables
C
	INTEGER*4	IDUMMY		! dummy integer
	INTEGER*4	LEN		! string length
	INTEGER*4	I		! loop counter
	INTEGER*4	RESULT		! command read result
	LOGICAL		EOLN		! end of line flag
	LOGICAL		OK		! function return status
	LOGICAL		NOLONG		! integer return status
	INTEGER*2	IECODE		! IFF entry type
	INTEGER*2	IELEN		! IFF entry length
C
	BYTE		ICH
	BYTE		COMMA
	PARAMETER	(COMMA=',')
	CHARACTER*80	DUMSTR		! dummy string
	LOGICAL		HAD_NAME
C
C External declaration
C
	INTEGER*4	DIDCMD_CMD_TABLE
	EXTERNAL	DIDCMD_CMD_TABLE
C
C Assume that everything goes well
C
	RDDID = .TRUE.
	HAD_NAME = .FALSE.
	NOMESS = .FALSE.
C
C Now, read the command from the line
C
500	RESULT = RDCOMM(DIDCMD_CMD_TABLE)
C
C and check that there was one
C
	IF (RESULT .LE. 0) THEN
	   IF (HAD_NAME) GOTO 9000	! must be the title, so carry on
	   GOTO 9999
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
	GOTO (510,520,530,540,550) RESULT
C
C Unknown command
C
	CALL LSL_PUTMSG(SIF2IFF__UNKCMD,CMDNST)
	GOTO 9999
C
C NA - ignore name, read string to next ','
C
510	LEN = READSTR(DUMSTR,COMMA,ON_CHAR)
	EOLN = RDCHS(ICH)
	IF (EOLN) GOTO 9000
	CALL BSCH
	NOMESS = .TRUE.
	HAD_NAME = .TRUE.
	GOTO 500
C
C DA - ignore date
C
520	LEN = READSTR(DUMSTR,COMMA,ON_CHAR)
	EOLN = RDCHS(ICH)
	IF (EOLN) GOTO 9000
	CALL BSCH
	GOTO 500
C
C MO - mode
C
530	NOLONG = RDLONG(DIMEN)			! save line colour value
	IF (NOLONG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	! warning if no integer
	   GOTO 9999
	ENDIF
	OK = READ_SEP(',')		
	IF (.NOT.CONT_LINE()) GOTO 9999
	EOLN = RDCHS(ICH)
	IF (EOLN) GOTO 9000
	CALL BSCH
	GOTO 500
C
C RA - range
C
540	NOLONG = RDLONG(XMIN)
	EOLN = RDCH(ICH)
	IF (.NOT.CONT_LINE()) GOTO 9999
	NOLONG = RDLONG(YMIN)
	EOLN = RDCH(ICH)
	IF (DIMEN.EQ.3) THEN
	   IF (.NOT.CONT_LINE()) GOTO 9999	 ! test for continuation line
	   NOLONG = RDLONG(ZMIN)
	   EOLN = RDCH(ICH)
	ENDIF
	IF (.NOT.CONT_LINE()) GOTO 9999
	NOLONG = RDLONG(XMAX)
	EOLN = RDCH(ICH)
	IF (.NOT.CONT_LINE()) GOTO 9999
	NOLONG = RDLONG(YMAX)
	EOLN = RDCH(ICH)
	IF (DIMEN.EQ.3) THEN
	   IF (.NOT.CONT_LINE()) GOTO 9999	 ! test for continuation line
	   NOLONG = RDLONG(ZMAX)
	   EOLN = RDCH(ICH)
	ENDIF
	HAD_RANGE = .TRUE.
	CALL IFFPKE( IECODE, IELEN, LPOSRA )
	IF ( IECODE.NE.'RA' ) THEN
	    CALL LSL_PUTMSG( SIF2IFF__NORA )
	    GOTO 9999
	ELSE
	   CALL EIHWR( RANGE, 4, 1 )
	ENDIF
C
	IF (EOLN) GOTO 9000
	IF (.NOT.CONT_LINE()) GOTO 9999
	GOTO 500
C
C DU - drawing units, want only the 3rd entry - UOR 
C
550	DO 551 I = 1,3
	   NOLONG = RDLONG(IDUMMY)
	   OK = READ_SEP(',')
551	CONTINUE
	IF (NOLONG.OR..NOT.OK) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	! warning if no integer
	   GOTO 9999
	ENDIF
	DO 552 I = 1,2
	LEN = READSTR(DUMSTR,COMMA,ON_CHAR)
552	CONTINUE
	IF (.NOT.CONT_LINE()) GOTO 9999
	LEN = READSTR(DUMSTR,,,.FALSE.)
	IF (.NOT.CONT_LINE()) GOTO 9999
C
553	LEN = READSTR(DUMSTR,,,.FALSE.)
	IF (DUMSTR(1:4).EQ.'    ') THEN
	   IF (.NOT.CONT_LINE()) GOTO 9999
	   GOTO 553
	ELSE
	   EOLN = RDCHS(ICH)
	   IF (EOLN) GOTO 9000
	   CALL BSCH
	   GOTO 9000
	ENDIF
C
9999	RDDID = .FALSE.
C
C Return
C
9000	NOMESS = .FALSE.
	RETURN
	END
