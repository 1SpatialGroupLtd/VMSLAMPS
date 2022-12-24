C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-03-05 12:16:22.000000000 +0000
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
	SUBROUTINE GET_FC(ADDR,FC)
C
CDEC$	IDENT	'05MA92'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	14-Oct-1991
C
C Description:
C       Binary chop to get FC of feature, given the address of its ST entry.
C
C
	IMPLICIT NONE
C
C Common Blocks
C
	INCLUDE 'LSL$ICASE:ICASE.CMN'
C
	INTEGER*4	ADDR
	INTEGER*2	FC
C
	INTEGER*4	GUESS
	INTEGER*4	HIGUESS
	INTEGER*4	LOGUESS
C
C------------------------------------------------------------------------------
C
	LOGUESS=1
	HIGUESS=STWIDPTR
10	GUESS=(HIGUESS+LOGUESS)/2
	IF(ADDR.LT.STINFO(1,GUESS))THEN
	   HIGUESS=GUESS-1
	ELSE
	   LOGUESS=GUESS
	ENDIF
	IF(HIGUESS.EQ.LOGUESS)THEN
	   FC=STINFO(2,LOGUESS)
	ELSE IF(HIGUESS.EQ.LOGUESS+1)THEN
	   IF(STINFO(1,HIGUESS).GT.ADDR)THEN
	      FC=STINFO(2,LOGUESS)
	   ELSE
	      FC=STINFO(2,HIGUESS)
	   ENDIF
	ELSE
	   GOTO 10
	ENDIF
C
	RETURN
	END
