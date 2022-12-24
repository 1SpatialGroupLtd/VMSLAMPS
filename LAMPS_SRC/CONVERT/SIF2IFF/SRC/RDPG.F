C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-08-16 15:00:42.000000000 +0100
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
	LOGICAL FUNCTION RDPG
C
CDEC$	IDENT	'16AU91'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	12-Jan-1990
C
C	CONVERT SIF2IFF Utility - Read parameters of SIF PAR (ParaGraph)
C	command
C
C Description
C
C	Read parameters of SIF PG command
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
	INTEGER*4	READSTR		! read a string
	INTEGER*4	RDCOMM		! read a command
	LOGICAL		READ_SEP	! read a SIF command seperator
	LOGICAL		RDREAL		! read a real
	LOGICAL		RDLONG		! read a long integer
	LOGICAL		CONT_LINE	! continuation line test
	LOGICAL		GET_XYZ		! get coord on line
	LOGICAL		RDCH
C
C Local Variables
C
	INTEGER*4	LEN		! string length
	INTEGER*4	I		! loop counter
	CHARACTER*80	DUMSTR		! dummy character string
	REAL		RDUMMY		! dummy real
	INTEGER*4	RESULT		! command read result
	LOGICAL		OK		! function return status
	INTEGER		AXIS		! flag x or y axis
	REAL		X,Y,Z		! coords
	REAL 		T11,T21		! rotation matrix
	INTEGER		NOLONG		! integer returned flag
	INTEGER		NOREAL		! real returned flag
	BYTE		PTR		! text buffer pointer
	BYTE		COMMA		! terminating character
	PARAMETER	(COMMA=',')
C
C External declaration
C
	INTEGER*4	PGCMD_CMD_TABLE
	EXTERNAL	PGCMD_CMD_TABLE
C
C Assume that everything goes well
C
	RDPG = .TRUE.
C
	TXT_TYPE1 = .FALSE.
	TXT_TYPE2 = .FALSE.
	HAD_TXT_AN = .FALSE.
	HAD_TXT_TH = .FALSE.
C
C Now, read the command from the line
C
500	RESULT = RDCOMM(PGCMD_CMD_TABLE)
C
C and check that there was one - but could be a text string
C
	IF (RESULT .LE. 0) THEN
	   IF (TXT_TYPE1.OR.TXT_TYPE2) THEN
	      CALL DCPSET(PTR)
	      GOTO 600
	   ENDIF   
	   GOTO 9999
	ENDIF
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
	GOTO (510,520,530,540,550,560,570,580,590,600,610) RESULT
C
C MR - Ignore mirroring, continue reading rest of line
C
510	GOTO 500
C
C TL - Top left
C
520	NOREAL= RDREAL(TLX)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999
	NOREAL = RDREAL(TLY)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999
	IF (NOREAL) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	TLX = TLX/UNITS		!convert from UORs to mm
	TLY = TLY/UNITS		!convert from UORs to mm
	IF (DIMEN.EQ.3) THEN			!3D NOT IMPLEMENTED
	   NOREAL = RDREAL(RDUMMY)
	   OK = READ_SEP(',')
	ENDIF
	GOTO 500
C
C BL - bottom left
C
530	NOREAL = RDREAL(BLX)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999
	NOREAL = RDREAL(BLY)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999
	IF (NOREAL) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	BLX = BLX/UNITS		!convert from UORs to mm
	BLY = BLY/UNITS		!convert from UORs to mm
	IF (DIMEN.EQ.3) THEN			!3D NOT IMPLEMENTED
	   NOREAL = RDREAL(RDUMMY)
	   OK = READ_SEP(',')
	ENDIF
	GOTO 500
C
C BR - bottom right
C
540	NOREAL = RDREAL(BRX)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999
	NOREAL = RDREAL(BRY)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999
	IF (NOREAL) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	BRX = BRX/UNITS		!convert from UORs to mm
	BRY = BRY/UNITS		!convert from UORs to mm
	IF (DIMEN.EQ.3) THEN			!3D NOT IMPLEMENTED
	   NOREAL = RDREAL(RDUMMY)
	   OK = READ_SEP(',')
	ENDIF
	TXT_TYPE1 = .TRUE.
	TXT_TYPE3 = .FALSE.		!switch off TX3
	GOTO 500
C
C OR - text origin
C
550	TXT_TYPE2 = .TRUE.	
	TXT_TYPE3 = .FALSE.		!switch off TX3
C
C Get text origin
C
	IF (.NOT.GET_XYZ()) GOTO 9999
	GOTO 500				!get next command or text string
C
C TH - text height
C
560	NOLONG = RDLONG(TXT_HEIGHT)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999
	IF (NOLONG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	HAD_TXT_TH = .TRUE.
	GOTO 500				
C
C TW - text width
C
570	NOLONG = RDLONG(TXT_WIDTH)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999
	IF (NOLONG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	GOTO 500		
C
C AN - text angle in degrees
C
580	NOREAL = RDREAL(TXT_ANGLE)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999
	IF (NOREAL) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	TXT_ANGLE = TXT_ANGLE/UNITS		!convert from UORs to mm
	ANGLE = (TXT_ANGLE * PI)/180.0		! convert to radians
	HAD_TXT_AN = .TRUE.
	GOTO 500
C
C MA - matrix. Get rotation only from matrix.
C
590	NOREAL = RDREAL(T11)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999
	NOREAL = RDREAL(T21)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999
	ANGLE = ATAN2(T21,T11)			!in radians
	DO 591 I = 1,2
	   NOREAL = RDREAL(RDUMMY)	
	   OK = READ_SEP(',')
	   IF (.NOT.CONT_LINE()) GOTO 9999
591	CONTINUE
	IF (DIMEN.EQ.3) THEN			!3D NOT IMPLEMENTED
	   DO 592 I = 1,5
	   NOREAL = RDREAL(RDUMMY)	
	   OK = READ_SEP(',')
	   IF (.NOT.CONT_LINE()) GOTO 9999
592	   CONTINUE
	ENDIF
	HAD_TXT_AN = .TRUE.
	GOTO 500				
C
C FO - ignore
C
600	LEN = READSTR(DUMSTR,COMMA,ON_CHAR)
	OK = READ_SEP(',')
	GOTO 500				
C
C ID - ignore
C
610	LEN = READSTR(DUMSTR,COMMA,ON_CHAR)
	OK = READ_SEP(',')
	GOTO 500				
C
9999	RDPG = .FALSE.
C
C Return
C
9000	IF (TXT_TYPE1) PAR_TH = (TLY-BLY)/PARLIN
	IF (TXT_TYPE2) TXT_HEIGHT = TXT_HEIGHT/PARLIN
	PAR_COUNT = 1
	RETURN
	END
