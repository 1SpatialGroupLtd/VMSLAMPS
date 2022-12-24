C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-05-16 17:17:56.000000000 +0100
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
	LOGICAL FUNCTION DO_PROF
C
CDEC$	IDENT	'16MY91'
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Clarke Brunt			CCB	15-May-1991
C
C Description
C
C	LITES2 cartographic editor user command routines
C	Volume calculation routine
C
        IMPLICIT NONE
C
	INCLUDE		'USRKEEP.CMN'
	INCLUDE 	'USRFEAT.CMN'
C
C functions
	EXTERNAL	CF_PT,COPY_PT
C
C working storage
	REAL		STORE(3)	! for HEAP sorting
	INTEGER		I,N,ISCT
	LOGICAL		INSIDE
	REAL		TOL
	REAL		RES
	REAL		DIST
C
C statement function
	REAL*8		ZVAL
	REAL		X,Y
	ZVAL(X,Y) = COEFFS(1)*X + COEFFS(2)*Y + COEFFS(3)
C
C rotate the profile to horizontal, checking Y coordinates as we go
C (should lie on VSLICE)
	MAXRES = 0.0
	RMSRES = 0.0
	DO 10 I=1,NPTS
	   IF (PROFANG.NE.0.0) CALL FILL_ROTATE(
     &				-PROFANG,COORD(1,I),COORD(2,I))
	   RES = ABS( COORD(2,I) - VSLICE )
	   IF (RES.GT.MAXRES) MAXRES = RES
	   RMSRES = RMSRES + RES*RES
10	CONTINUE
	RMSRES = SQRT(RMSRES/NPTS)
C
C sort X coordinates into order
	CALL HEAP_SORT( COORD, NPTS, CF_PT, COPY_PT, STORE )
C
C Compare X coordinates with intersection points of feature with
C polygon. Discard any points outside the polygon, and add points on
C the boundary (if points not on boundary already).
C
	INSIDE = .FALSE.	! not in a visible bit
	N = 0			! no output points yet
	I = 1			! begin with first coord
	ISCT = 1		! begin with first intersection
	TOL = ((PYMAX-PYMIN)/(NPROF+1))/100.0
C
20	IF (I.LE.NPTS) THEN	! not done all points yet
C
C check for a near duplicated point, and discard
	   IF (N.GT.0) THEN
	      IF (ABS(COORD(1,I)-COORD(1,N)).LE.TOL) THEN
	         I = I+1	! point too close, discard
	         GOTO 20
	      ENDIF
	   ENDIF
C
C get distance from next intersection
	   DIST = COORD(1,I) - INTPTS(ISCT)
	ELSE
	   DIST = 2.0*TOL+1.0	! pretend point after intersection
	ENDIF
C
	IF (DIST.LT.-TOL) THEN	! coord before next intersection
	   IF (INSIDE) THEN	! include this point
	      N = N+1
	      IF (N.NE.I) THEN
	         COORD(1,N) = COORD(1,I)
	         COORD(3,N) = COORD(3,I)
	      ENDIF
	      COORD(2,N) = VSLICE
	      FLG(N) = 1	! visible
	      I = I+1
	   ELSE			! discard this point
	      I = I+1
	   ENDIF
	ELSEIF (DIST.GT.TOL) THEN	! coord after next intersection
	   N = N+1
	   IF (N.GE.I) THEN	! move array to make space
	      NPTS = NPTS+1
	      IF (NPTS.GT.MAXPTS) THEN
	         CALL WRITEF(
     &		'Processed profile must not have more than %N points',
     &			MAXPTS)
	         DO_PROF = .FALSE.
	         GOTO 9999
	      ENDIF
	      CALL VIOMV3(COORD(1,I),12*(NPTS-I),COORD(1,I+1))
	      I = I+1
	   ENDIF
	   COORD(1,N) = INTPTS(ISCT)
	   COORD(2,N) = VSLICE
	   COORD(3,N) = ZVAL(COORD(1,N),VSLICE)
	   IF (INSIDE) THEN
	      FLG(N) = 1	! visible
	   ELSE
	      FLG(N) = 0	! invisible
	   ENDIF
	   INSIDE = .NOT.INSIDE
	   ISCT = ISCT+1
	ELSE		! coord within tolerance of intersection
C
C keep the coord height, instead of the intersection
	   N = N+1
	   IF (N.NE.I) THEN
	      COORD(3,N) = COORD(3,I)
	   ENDIF
	   COORD(1,N) = INTPTS(ISCT)
	   COORD(2,N) = VSLICE
	   IF (INSIDE) THEN
	      FLG(N) = 1	! visible
	   ELSE
	      FLG(N) = 0	! invisible
	   ENDIF
	   INSIDE = .NOT.INSIDE
	   ISCT= ISCT+1
	   I = I+1
	ENDIF
	IF (ISCT.LE.NSCT) GOTO 20
	NPTS = N		! new number of points
C
C compute area
	AREA(PROFNO) = 0.0D0
	DO 30 I=1,NPTS-1
	   IF (FLG(I+1).EQ.1) THEN
	      AREA(PROFNO) = AREA(PROFNO) +
     &		((COORD(3,I  )-ZVAL(COORD(1,I  ),VSLICE))+
     &		 (COORD(3,I+1)-ZVAL(COORD(1,I+1),VSLICE)))
     &		*(COORD(1,I+1)-COORD(1,I))/2.0
	   ENDIF
30	CONTINUE
C
C rotate back
	IF (PROFANG.NE.0.0) THEN
	   DO 40 I=1,NPTS
	      CALL FILL_ROTATE(PROFANG,COORD(1,I),COORD(2,I))
40	   CONTINUE
	ENDIF
C
	PDONE(PROFNO) = .TRUE.
	DO_PROF = .TRUE.
C
9999	RETURN
	END
