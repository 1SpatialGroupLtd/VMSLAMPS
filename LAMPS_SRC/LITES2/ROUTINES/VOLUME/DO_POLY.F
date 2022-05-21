C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-05-16 13:49:44.000000000 +0100
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
	LOGICAL FUNCTION DO_POLY
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
C functions
	INCLUDE		'USRKEEP.CMN'
	INCLUDE 	'USRFEAT.CMN'
	EXTERNAL	CF_SIDE,COPY_SIDE
C
C working storage
	REAL*8	A(3,3)
	INTEGER	I,J,K
	REAL*8	X,Y,Z
	REAL	RES
	REAL	STORE(1,4)	! used for HEAP_SORTing

C
C ensure that there is a closing (xy only) point in the array, for later,
C but don't count the closing point in plane fitting calculations
	IF (COORD(1,1).EQ.COORD(1,NPTS).AND.
     &      COORD(2,1).EQ.COORD(2,NPTS)) THEN
	   NPTS = NPTS-1
	ELSE
	   COORD(1,NPTS+1) = COORD(1,1)
	   COORD(2,NPTS+1) = COORD(2,1)
	ENDIF
C
	IF (NPTS.LT.3) THEN
	   CALL TTWSTR('Bounding polygon must have at least 3 points')
	   DO_POLY = .FALSE.
	   GOTO 9999
	ENDIF
C
	DO 5 J=1,3
	   COEFFS(J) = 0.0D0
	   DO 5 I=1,3
	      A(I,J) = 0.0D0
5	CONTINUE
C	
	DO 10 I=1,NPTS
	   IF (PROFANG.NE.0.0) CALL FILL_ROTATE(
     &				-PROFANG,COORD(1,I),COORD(2,I))
	   X = COORD(1,I)
	   Y = COORD(2,I)
	   Z = COORD(3,I)
	   A(1,1) = A(1,1) + X*X 
	   A(2,1) = A(2,1) + X*Y
	   A(3,1) = A(3,1) + X
	   A(2,2) = A(2,2) + Y*Y
	   A(3,2) = A(3,2) + Y
	   COEFFS(1) = COEFFS(1) + X*Z
	   COEFFS(2) = COEFFS(2) + Y*Z
	   COEFFS(3) = COEFFS(3) + Z
10	CONTINUE
C
	A(1,2) = A(2,1)
	A(1,3) = A(3,1)
	A(2,3) = A(3,2)
	A(3,3) = NPTS
C
	CALL SOLVE(A,COEFFS,3,1,0,3,3)
C
C calculate residuals, and get extents in (rotated) Y
	MAXRES = 0.0
	RMSRES = 0.0
	PYMIN = COORD(2,1)
	PYMAX = COORD(2,1)
C	
	DO 20 I=1,NPTS
	   IF (COORD(2,I).LT.PYMIN) PYMIN = COORD(2,I)
	   IF (COORD(2,I).GT.PYMAX) PYMAX = COORD(2,I)
	   Z = COEFFS(1)*COORD(1,I) + COEFFS(2)*COORD(2,I) + COEFFS(3)
	   RES = ABS( COORD(3,I) - Z )
	   IF (RES.GT.MAXRES) MAXRES = RES
	   RMSRES = RMSRES + RES*RES
20	CONTINUE
	RMSRES = SQRT(RMSRES/NPTS)
C
C form list of sides for getting intersections with profiles
C
	NSIDES = 0		! no sides yet
C
	DO 30 I = 1,NPTS
	   IF ( COORD(2,I).GT.COORD(2,I+1) ) THEN
	      J = 0
	      K = 1
	   ELSEIF ( COORD(2,I).LT.COORD(2,I+1) ) THEN
	      J = 1
	      K = 0
	   ELSE
	      GOTO 30
	   ENDIF
C
	   NSIDES = NSIDES+1
	   SIDES(1,NSIDES) = COORD(1,I+J)
	   SIDES(2,NSIDES) = COORD(2,I+J)
	   SIDES(3,NSIDES) = COORD(1,I+K) - COORD(1,I+J)
	   SIDES(4,NSIDES) = COORD(2,I+K) - COORD(2,I+J)
30	CONTINUE
C
C and so we have our sides - we must now sort them into order
C
	CALL HEAP_SORT( SIDES, NSIDES, CF_SIDE, COPY_SIDE, STORE )
C
	DO_POLY = .TRUE.
C
9999	RETURN
	END
