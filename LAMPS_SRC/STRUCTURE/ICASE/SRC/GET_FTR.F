C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-03-05 12:16:36.000000000 +0000
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
	LOGICAL*4 FUNCTION GET_FTR(TOTPTS,ADDR)
C
CDEC$	IDENT	'05MA92'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	25-Oct-1991
C
C Description:
C       Routine to return (in ZIN) the points of a feature given its ST address
C
	IMPLICIT NONE
C
C Message parameters
C
	INCLUDE	'LSL$ICASE:ICASEMSG.PAR'	! ICASE messages
C
C Common Blocks
C
	INCLUDE 'LSL$ICASE:ICASE.CMN'
	INCLUDE 'LSL$ICASE:IFFVARS.CMN'
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'
C
C Arguments
C
	INTEGER*4	TOTPTS		! total points read in so far
	INTEGER*4	ADDR		! ST address of current feature
C
C Local Variables
C
	INTEGER*4	STATUS		! routine success status
	INTEGER*4	TPSAVE		! total points at start of feature
	INTEGER*4	I
	REAL*4		TEMP
	INTEGER*2	NPTS
	INTEGER*2	IENDS
	INTEGER*2	IECODE
	INTEGER*2	IELEN
C
C------------------------------------------------------------------------------
C
	STATUS=.TRUE.
C
C position to start of feature
C
	CALL IFFSEL(1)
	CALL IFFPKE(IECODE,IELEN,ADDR)
	IF(IECODE.NE.'ST') THEN
	   STATUS=ICASE__BADADDRESS
	   CALL LSL_PUTMSG(STATUS,NF)
	   GOTO 999
	ENDIF
C
C read co-ords straight into ZIN
C
	TOTPTS = 0
100	CONTINUE
	IF(IECODE.EQ.'ST')THEN
	   CALL EIHRS( NPTS, IENDS)
	   IF (TOTPTS.GT.0 .AND. IENDS.EQ.0) GOTO 150  ! ignore invisible lines
	   CALL EIHRR(ZIN(1,TOTPTS+1),NPTS*2,1)
	   TOTPTS=TOTPTS+NPTS
150	   CALL IFFNXT(IECODE,IELEN)
	   GOTO 100
	ELSE IF(IECODE.EQ.'EF')THEN
	   GOTO 999
	ENDIF
C
999	GET_FTR=STATUS
	RETURN
	END
