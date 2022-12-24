C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-07-17 18:34:00.000000000 +0100
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
	LOGICAL FUNCTION SKIP_CONTLIN
C
CDEC$	IDENT	'17JL90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	17-Jul-1990
C
C	CONVERT SIF2IFF Utility - get SIF coords in a SIF command line
C
C Description
C
C	Returns FALSE for error in SIF command line
C
	IMPLICIT NONE
C
C Included Parameter Files
C
C
C Common Blocks
C
C
C Functions called
C
	LOGICAL		READSTR		! read a string
	LOGICAL		CONT_LINE	! continuation line
C
C Local Variables
C
	CHARACTER*80	DUMSTR		! dummy character string
	INTEGER*4	LEN		! string length
C
C Assume that everything goes well
C
	SKIP_CONTLIN = .TRUE.
C
10	LEN = READSTR(DUMSTR)
C
C If LEN is 0 treat as no continuation line.
C
	IF (LEN.NE.0) THEN
	   IF (DUMSTR(LEN:LEN).EQ.',') THEN
	     IF (.NOT.CONT_LINE()) GOTO 9999
	     GOTO 10
	   ENDIF
	ENDIF
	GOTO 9000
C
9999	SKIP_CONTLIN = .FALSE.
C
9000	RETURN
	END
