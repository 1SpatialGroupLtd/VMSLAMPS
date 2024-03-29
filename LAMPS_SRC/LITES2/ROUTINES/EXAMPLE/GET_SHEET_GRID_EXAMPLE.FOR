C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-12-22 11:08:46.000000000 +0000
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
	LOGICAL FUNCTION GET_SHEET_GRID(STR,STRL,SCALE,GRID)
C
C Copyright Laser-Scan Ltd., Cambridge, England.
C
C Example routine to convert from grid position to map sheet name.
C Function should return .TRUE. for success and .FALSE. for failure
C
C To link it do the following:
C	$ FORTRAN GET_SHEET_GRID_EXAMPLE
C	$ LINK/share GET_SHEET_GRID_EXAMPLE,SYS$INPUT:/opt
C       universal=GET_SHEET_GRID
C	$ Define LSL$LITES2_MAP_SHEET_ROUTINES -
C	                     disk:[directory]GET_SHEET_GRID_EXAMPLE.EXE
C
	IMPLICIT NONE
C
C arguments
	CHARACTER*(*)	STR		! string to return
	INTEGER		STRL		! string length
	INTEGER		SCALE		! scale
	REAL*8		GRID(2)		! Eastings and Northings of point
C
C This example returns a sheet name based on the coordinates of the
C point, divided by the scale.
C
C working storage
	INTEGER		E,N
	REAL		R
	INTEGER		L1,L2
C
C assume failure
	GET_SHEET_GRID = .FALSE.
	IF (SCALE.LE.0) GOTO 900
	E = GRID(1)/SCALE
	N = GRID(2)/SCALE
C
C get number of digits in these numbers
	IF (E.GE.1) THEN
	   R = E
	   L1 = LOG10(R) + 1
	ELSE
	   L1 = 1
	ENDIF
C
	IF (N.GE.1) THEN
	   R = N
	   L2 = LOG10(R) + 1
	ELSE
	   L2 = 1
	ENDIF
C
C convert values to string
	IF ((L1 + L2 + 2).GT.STRL) GOTO 900
	WRITE(STR,100,ERR=900),E,N
	STRL = L1 + L2 + 2
C
C success
	GET_SHEET_GRID = .TRUE.
C
900	RETURN
C
100	FORMAT('E',I<L1>,'N',I<L2>)
	END
