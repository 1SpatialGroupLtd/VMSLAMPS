C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-12-06 16:20:14.000000000 +0000
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
	LOGICAL FUNCTION GET_SHEET_GEOG(STR,STRL,SCALE,GEOG)
C
C Copyright Laser-Scan Ltd., Cambridge, England.
C
C To link it do the following:
C	$ FORTRAN GET_SHEET_GEOG_EXAMPLE
C	$ LINK/share GET_SHEET_GEOG_EXAMPLE,SYS$INPUT:/opt
C       universal=GET_SHEET_GEOG
C	$ Define LSL$LITES2_MAP_SHEET_ROUTINES -
C	                     disk:[directory]GET_SHEET_GEOG_EXAMPLE.EXE
C
	IMPLICIT NONE
C
C arguments
	CHARACTER*(*)	STR		! string to return
	INTEGER		STRL		! string length
					! input  - maximum length of string
					! output - actual length of string
	INTEGER		SCALE		! scale
	REAL*8		GEOG(2)		! Latitude and Longitude
C
C This example returns a sheet name based on the UTM zone of the point.
C This number is suffixed by N or S to indicate if the point is north
C or south of the equator. The number is further suffixed by the scale
C factor.
C
C working storage
	REAL		ANG
	INTEGER		L1,L2
	REAL		R
	INTEGER		ZONE
	CHARACTER*1	CH
C
C assume failure
	GET_SHEET_GEOG = .FALSE.
C
C get logitude in range -180 -> +180
	ANG = GEOG(2)
100	IF (ANG.LT.-180.0) THEN
	   ANG = ANG + 360.0
	   GOTO 100
	ELSEIF (ANG.GE.+180.0) THEN
	   ANG = ANG - 360.0
	   GOTO 100
	ENDIF
C
	ANG = ANG + 180
	ZONE = ANG/6.0 + 1		! truncate to integer
C
C get length for format
	R  = ZONE
	L1 = LOG10(R)+1
C
C get length of scale for format
	R  = SCALE
	L2 = LOG10(R)+1
C
	IF (GEOG(1).LT.0.0) THEN
	   CH = 'S'
	ELSE
	   CH = 'N'
	ENDIF
C
C construct return string
	IF ((L1+L2+1).LE.STRL) THEN
	   WRITE(STR,200,ERR=999),ZONE,CH,SCALE
200	   FORMAT(I<L1>,A,I<L2>)
	   GET_SHEET_GEOG = .TRUE.		! success
	   STRL = L1 + L2 + 1
	ENDIF

999	RETURN
	END
