C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-06-17 16:53:18.000000000 +0100
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
	SUBROUTINE PROCESS(VAL,SIZE,INPUT,OUTPUT)
C
CDEC$	IDENT	'17JN91'
C
C Copyright Laser-Scan Laboratories Limited, Cambridge, England.
C
C	Created					CCB 	17-Jun-1991
C
	IMPLICIT NONE
C
C arguments
	INTEGER	VAL			! data value
	INTEGER	SIZE			! array size
	BYTE	INPUT(*)		! input array
	BYTE	OUTPUT(*)		! output array
C
C workspace
	INTEGER	LVAL
	BYTE	BVAL
	EQUIVALENCE (LVAL,BVAL)
	INTEGER	I
C
	LVAL = VAL
C
	DO 10 I=1,SIZE
	   IF (INPUT(I).NE.0) OUTPUT(I) = BVAL
10	CONTINUE
C
	RETURN
	END
