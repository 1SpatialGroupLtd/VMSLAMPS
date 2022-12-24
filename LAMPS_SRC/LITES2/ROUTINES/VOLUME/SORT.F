C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-05-16 10:27:46.000000000 +0100
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
	INTEGER FUNCTION CF_REAL( ELE_ONE, INDEX_1, ELE_TWO, INDEX_2 )
C
CDEC$	IDENT	'16MY91'
C
C	Copyright LaserScan Laboratories Ltd., Cambridge, England
C
C Author TJ Ibbs, 7 December 1984
C
	IMPLICIT NONE
C
C CF_REAL is a longword function to compare two elements
C
C	   eg	CF_REAL( TABLE, index1, TABLE, index2 )
C	   or	CF_REAL( TABLE, index1, STORE, 1 )
C	   or	CF_REAL( STORE, 1,      TABLE, index2 )
C
C	returns	-1 if  element 'index1' < element 'index2'
C		 0 if			=
C		+1 if			>
C
C Arguments
C
	REAL		ELE_ONE(*)
	INTEGER		INDEX_1		! index into ELE_ONE
	REAL		ELE_TWO(*)
	INTEGER		INDEX_2		! index into ELE_TWO
C
C do the comparison
C
	IF ( ELE_ONE(INDEX_1) .LT. ELE_TWO(INDEX_2) ) THEN
	   CF_REAL = -1
	ELSEIF ( ELE_ONE(INDEX_1) .GT. ELE_TWO(INDEX_2) ) THEN
	   CF_REAL = 1
	ELSE
	   CF_REAL = 0
	ENDIF
C
	RETURN
	END
C
C
C
	SUBROUTINE	COPY_REAL( FROM, FINDEX, TO, TINDEX )
C
CDEC$	IDENT	'15MY91'
C
C	Copyright LaserScan Laboratories Ltd., Cambridge, England
C
C Author TJ Ibbs, 7 December 1984
C
	IMPLICIT NONE
C
C COPY_REAL is a routine to copy an element of FROM to an element of TO
C
C Arguments
C
	REAL		FROM(*)
	INTEGER		FINDEX		! index into FROM
	REAL		TO(*)
	INTEGER		TINDEX		! index into TO
C
	TO( TINDEX ) = FROM( FINDEX )
C
	RETURN
	END
C
C
C
 	INTEGER FUNCTION CF_SIDE ( SIDE_1, IX_1, SIDE_2, IX_2 )
C
CDEC$	IDENT	'15MY91'
C
C	Copyright LaserScan Laboratories Ltd., Cambridge, England
C
C Author TJ Ibbs, 2 January 1985
C
	IMPLICIT NONE
C
C CF_SIDE is a longword function to compare two side descriptions
C
C	   eg	CF_REAL( TABLE, index1, TABLE, index2 )
C	   or	CF_REAL( TABLE, index1, STORE, 1 )
C	   or	CF_REAL( STORE, 1,      TABLE, index2 )
C
C	returns	-1 if  SIDE 'index1' < SIDE 'index2'
C		 0 if		     =
C		+1 if		     >
C
C Arguments
C
	REAL		SIDE_1(4,*)
	INTEGER		IX_1		! index into SIDE_1
	REAL		SIDE_2(4,*)
	INTEGER		IX_2		! index into SIDE_2
C
C do the comparison
C
	IF ( SIDE_1(2,IX_1).GT.SIDE_2(2,IX_2) ) THEN
	   CF_SIDE = +1
	ELSEIF ( SIDE_1(2,IX_1).LT.SIDE_2(2,IX_2) ) THEN
	   CF_SIDE = -1
	ELSE
	   IF ( SIDE_1(1,IX_1).LT.SIDE_2(1,IX_2) ) THEN
	      CF_SIDE = +1
	   ELSEIF ( SIDE_1(1,IX_1).GT.SIDE_2(1,IX_2) ) THEN
	      CF_SIDE = -1
	   ELSE
	      IF ( SIDE_1(3,IX_1).LT.SIDE_2(3,IX_2) ) THEN
		 CF_SIDE = +1
	      ELSEIF ( SIDE_1(3,IX_1).GT.SIDE_2(3,IX_2) ) THEN
		 CF_SIDE = -1
	      ELSE
		 IF ( SIDE_1(4,IX_1).GT.SIDE_2(4,IX_2) ) THEN
		    CF_SIDE = +1
		 ELSEIF ( SIDE_1(4,IX_1).LT.SIDE_2(4,IX_2) ) THEN
		    CF_SIDE = -1
		 ELSE
		    CF_SIDE = 0
		 ENDIF
	      ENDIF
	   ENDIF
	ENDIF
C
	RETURN
	END
C
C
C
	SUBROUTINE	COPY_SIDE( FROM, FINDEX, TO, TINDEX )
C
CDEC$	IDENT	'15MY91'
C
C	Copyright LaserScan Laboratories Ltd., Cambridge, England
C
C Author TJ Ibbs, 2 January 1985
C
	IMPLICIT NONE
C
C COPY_SIDE is a routine to copy a side description in FROM to
C	    a side description in TO
C
C Arguments
C
	REAL		FROM(4,*)
	INTEGER		FINDEX		! index into FROM
	REAL		TO(4,*)
	INTEGER		TINDEX		! index into TO
C
C workspace
C
	INTEGER		I		! DO loop counter
C
	DO 10 I = 1,4
	   TO( I,TINDEX ) = FROM( I,FINDEX )
10	CONTINUE
C
	RETURN
	END
C
C
C
 	INTEGER FUNCTION CF_PT ( PT_1, IX_1, PT_2, IX_2 )
C
CDEC$	IDENT	'15MY91'
C
C	Copyright LaserScan Laboratories Ltd., Cambridge, England
C
C Author CC Brunt, 16 May 1991
C
	IMPLICIT NONE
C
C CF_PT is a longword function to compare X coord of 3D points
C
C	   eg	CF_PT( TABLE, index1, TABLE, index2 )
C	   or	CF_PT( TABLE, index1, STORE, 1 )
C	   or	CF_PT( STORE, 1,      TABLE, index2 )
C
C	returns	-1 if  PT 'index1' < PT 'index2'
C		 0 if		   =
C		+1 if		   >
C
C Arguments
C
	REAL		PT_1(3,*)
	INTEGER		IX_1		! index into PT_1
	REAL		PT_2(3,*)
	INTEGER		IX_2		! index into PT_2
C
C do the comparison
C
	IF ( PT_1(1,IX_1).GT.PT_2(1,IX_2) ) THEN
	   CF_PT = +1
	ELSEIF ( PT_1(1,IX_1).LT.PT_2(1,IX_2) ) THEN
	   CF_PT = -1
	ELSE
	   CF_PT = 0
	ENDIF
C
	RETURN
	END
C
C
C
	SUBROUTINE	COPY_PT( FROM, FINDEX, TO, TINDEX )
C
CDEC$	IDENT	'15MY91'
C
C	Copyright LaserScan Laboratories Ltd., Cambridge, England
C
C Author CC Brunt, 16 May 1991
C
	IMPLICIT NONE
C
C COPY_PT is a routine to copy a 3D point in FROM to
C	    a 3D point in TO
C
C Arguments
C
	REAL		FROM(3,*)
	INTEGER		FINDEX		! index into FROM
	REAL		TO(3,*)
	INTEGER		TINDEX		! index into TO
C
C workspace
C
	INTEGER		I		! DO loop counter
C
	DO 10 I = 1,3
	   TO( I,TINDEX ) = FROM( I,FINDEX )
10	CONTINUE
C
	RETURN
	END
