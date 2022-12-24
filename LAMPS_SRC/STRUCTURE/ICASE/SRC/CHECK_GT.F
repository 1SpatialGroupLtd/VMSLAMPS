C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-11-01 14:14:56.000000000 +0000
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
	LOGICAL FUNCTION CHECK_GT(LINEFC,FC,GT)
C
CDEC$	IDENT	'25SE91'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	25-Sep-1991
C
C Description
C	Routine called check GT of feature in FRT is what was expected.
C
	IMPLICIT NONE
C
C Message parameters
C
	INCLUDE	'LSL$ICASE:ICASEMSG.PAR'	! ICASE messages
C
C Common Blocks
C
	INCLUDE 'LSL$CMNFRT:FRTCOM.CMN'		! FRT command block
C
C Arguments
C
	INTEGER*2	LINEFC,FC,GT		! The FC and GT to check
C
C Functions called
C
	LOGICAL*4	FRTFND			! Find entry in FRT
C
C Local variables
C
	LOGICAL*4	STATUS			! Success/failure of routine
C
C-----------------------------------------------------------------------------
C
	STATUS = .TRUE.
C
	IF (FRTFND(FC)) THEN 		! generates its own message
	   STATUS=.FALSE.
	ELSE
	   IF (FRTGT.NE.GT) THEN
	      STATUS=ICASE__WRONGGT
	      CALL LSL_PUTMSG(STATUS,LINEFC)
	   ENDIF
	ENDIF
C
	CHECK_GT = STATUS
	RETURN
	END
