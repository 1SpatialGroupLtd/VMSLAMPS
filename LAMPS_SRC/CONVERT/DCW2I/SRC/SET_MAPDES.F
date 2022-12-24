C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-06-29 12:12:32.000000000 +0100
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
	SUBROUTINE SET_MAPDES()
C
CDEC$	IDENT	'21MY92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	21-May-1992
C
C Description:
C
C       Routine to calculate the origin of the 
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'MESPAR.PAR'
C
C Common blocks
C
	INCLUDE 'TABLES.CMN'
	INCLUDE 'GENERAL.CMN'
	INCLUDE 'SELECTIONS.CMN'
	INCLUDE 'LSL$CMNIFF:MD2DES.CMN'
C
C Local workspace
C
	INTEGER*4	X,Y		     	! loopy
	INTEGER*4	T1,T2			! working tile name
	CHARACTER*1	LONG,LAT
C
C ......................................................................
C
	LONG = CURRGEO(1:1)
	LAT  = CURRGEO(2:2)
	T1 = ICHAR(TILESEL(1:1))-48
	T2 = ICHAR(TILESEL(2:2))-48
C
	IF (CURRGEO(1:2).EQ.'  ') THEN
	   MD2LOC(1) = 0.0
	   MD2LOC(2) = 0.0
	   ORIGIN(1) = 0.0
	   ORIGIN(2) = 0.0
	ELSE
	   DO 100 X = 1,NUM_LONG_GEO
	      IF (LONG_GEOREF(X:X).EQ.LONG) THEN
		 DO 200 Y = 1,NUM_LAT_GEO
		    IF (LAT_GEOREF(Y:Y).EQ.LAT) THEN
		       MD2LOC(1)=DBLE((X-13)*15+(T1-1)*5)
		       MD2LOC(2)=DBLE((Y-7)*15+(T2-1)*5)
		       ORIGIN(1)=REAL(MD2LOC(1))
		       ORIGIN(2)=REAL(MD2LOC(2))
		    ENDIF
 200		 CONTINUE
	      ENDIF
100	   CONTINUE
	ENDIF
	MATV2 = 2
	MD2SCL = 1000000
	MD2PRJ = 100
	MD2UNT = 4
	MD2SPH = 22
C
C ......................................................................
C
1000	RETURN
	END
