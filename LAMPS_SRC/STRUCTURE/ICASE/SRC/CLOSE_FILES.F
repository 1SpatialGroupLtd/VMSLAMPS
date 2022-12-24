C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-11-01 13:33:10.000000000 +0000
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
	LOGICAL*4 FUNCTION CLOSE_FILES
C
CDEC$	IDENT	'12SE91'
C
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	25-Sep-1991
C
C Description
C       Close files. If they are open.
C
	IMPLICIT NONE
C
C Message parameters
C
	INCLUDE	'LSL$ICASE:ICASEMSG.PAR'	! ICASE messages
C
C Common Blocks
C
	INCLUDE 'LSL$ICASE:CMDLIN.CMN'	! File LUNs, etc
!	INCLUDE 'LSL$CMNLSL:CLD.CMN'	! DCL command decoding
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'	! Access to IERCD
C
	INTEGER*4	STATUS
C
C------------------------------------------------------------------------------
C
	STATUS=.TRUE.
C
	IF (IN_OPEN) THEN
	   CALL IFFERM(.FALSE.)		! turn off error messages
	   CALL IFFCLO(INLUN)
	   CALL IFFERM(.TRUE.)		! turn on error messages
	   STATUS = IERCD.EQ.0
	   IF (.NOT.STATUS) THEN
	      CALL LSL_PUTMSG(STATUS,INFILE(:INLEN))
	      CALL IFFERR
	      GOTO 999
	   ENDIF
	   IN_OPEN=.FALSE.
	ENDIF
C
	IF (OUT_OPEN) THEN
	   CALL IFFERM(.FALSE.)		! turn off error messages
	   CALL IFFCLO(OUTLUN)
	   CALL IFFERM(.TRUE.)		! turn on error messages
	   STATUS = IERCD.EQ.0
	   IF (.NOT.STATUS) THEN
	      CALL LSL_PUTMSG(STATUS,OUTFILE(:OUTLEN))
	      CALL IFFERR
	      GOTO 999
	   ENDIF
	   OUT_OPEN=.FALSE.
	ENDIF
C
999	CLOSE_FILES=STATUS
	RETURN
	END
