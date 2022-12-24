C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-05-16 12:59:00.000000000 +0100
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
	LOGICAL FUNCTION DO_PREP
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
	EXTERNAL	CF_SIDE,COPY_SIDE,CF_REAL,COPY_REAL
C
C working storage
	REAL	ALPHA		! used in intersection calculation
C
	LOGICAL		VTERM	! true if a side terminates on VSLICE
	LOGICAL		VSORT	! true if need to sort these sides
C
	INTEGER		I,J	! DO loop variables
C
	REAL		STORE(1,4)	! used for HEAP_SORTing
C
C get (rotated) y coordinate of profile
	VSLICE = PYMIN + PROFNO * (PYMAX-PYMIN)/(NPROF+1)
C
C get intersections of the profile with the polygon
C
C *********************************************************************
C
C now find which sides are intersected by the slice...
C
C if we find a side with its maximum point (U,V) below VSLICE, then
C all succeeding sides will also have their maximum points above
C VSLICE, and we can stop searching
C
C if we find a side with its minimum point (U+DU,V+DV) above VSLICE,
C then just ignore it
C
	NSCT = 0		! no intersected sides yet
C
	DO 500 I=NSIDES,1,-1
C
C
	IF ( SIDES(2,I) .LT. VSLICE ) THEN
C
C	 this side has its maxV below our slice - it is thus not
C	 intersected, and nor are any of the sides after this
C	 (since they all have lesser maxV values)
C
	   GOTO 510		! got all intersected sides
C
	ELSEIF ( SIDES(2,I)+SIDES(4,I) .GT. VSLICE ) THEN
C
C	 this side has its minV above our slice - it is thus
C	 totally above the slice and may be ignored
C
	   GOTO 500
C
	ELSE
C
C	 this side is intersected - store this side in INTSCT
C
	   NSCT = NSCT+1	! insert into next place in INTSCT
C
	   IF ( NSCT.GT.MAXINT ) THEN
	      CALL TTWSTR('Profile intersects polygon too many times')
	      DO_PREP = .FALSE.
	      GOTO 9999
	   ENDIF
C
C	 copy the data for this side into INTSCT
C
	   CALL COPY_SIDE( SIDES, I, INTSCT, NSCT )
C
C	 and now we want to move onto the next side to be checked
C
	ENDIF
500	CONTINUE
C
C
C *********************************************************************
C
C when we reach here, we have found all the sides which are intersected
C by our slice
C
C we can ignore an empty list of intersections, and a single
C intersection is an error
C
C two intersections are common enough that we treat them specially
C - note that only problem type (1) is relevant to two intersections
C (see notes below for a description of the problem types)
C - problem type (2) requires more than 2 intersections
C
C for two intersections we don't bother to sort
C
510	IF ( NSCT.EQ.1 ) THEN
C
	   CALL TTWSTR('Single intersection side in buffer')
	   DO_PREP = .FALSE.
	   GOTO 9999
C
	ELSEIF ( NSCT.EQ.2 ) THEN
C
	   IF (
     &	      .NOT.(
     &		   INTSCT(2,1) .EQ. INTSCT(2,2)
     &		   .AND.
     &		   INTSCT(2,1) .EQ. VSLICE
     &		   )
     &	     .AND.
     &	      .NOT.(
     &		   INTSCT(2,1)+INTSCT(4,1) .EQ.
     &		   INTSCT(2,2)+INTSCT(4,2)
     &		   .AND.
     &		   INTSCT(2,1)+INTSCT(4,1) .EQ. VSLICE
     &		   )
     &	      ) THEN
C
C	    this line is not a case (1), so work out the intersections
C
	      DO 530 I = 1,2
	         ALPHA = (VSLICE-INTSCT(2,I)) / INTSCT(4,I)
	         INTPTS(I) =  INTSCT(1,I)*(1-ALPHA) +
     &			     (INTSCT(1,I)+INTSCT(3,I))*ALPHA
530	      CONTINUE
C
C sort the two intersections into order
C
	      CALL HEAP_SORT( INTPTS, NSCT, CF_REAL, COPY_REAL, STORE )
C
	   ENDIF
C
	ELSEIF ( NSCT.GT.2 ) THEN
C
C	 we have a list of intersected sides - check if we should throw
C	 any of them away
C
C	 We look for sides (in our INTSCT list) with a maximum or
C	 minimum point lying on VSLICE, as follows:
C
C	 -----	in the diagrams, the dashed horizontal line is VSLICE,
C		and passes exactly through the common point of the line
C		segments shown
C
C	  		    /				    /
C	 ---/\--   or   ---x---   or   --x==x--   or  --x==x--
C	   /  \		  /		/    \	       /
C
C	   (1)		  (2)		 (3)		(4)
C
C	 in case (1) both intersections may be discarded, as
C	 	     they define a null line
C	 	     - we have VSLICE = maxima or minima of both sides
C
C	 in case (2) one of the intersections may be discarded, as
C	 	     retaining both would yield the wrong result
C		     - we have VSLICE = maximum of one side, and
C					minimum of the other side
C
C	 in case (3) the line segment parallel to VSLICE has DV zero,
C	 	     so is ignored, meaning that this case is reduced
C		     to case (1)
C
C	 in case (4) the line segment parallel to VSLICE has DV zero,
C	 	     so is ignored, meaning that this case is reduced
C		     to case (2)
C
C	 so let us check our intersected sides according to these
C	 criteria.
C
C	 We inspect our list for any sides terminating on VSLICE,
C	 and ensure that all such sides have their U,V point as the
C	 point on VSLICE (to make later comparisons easier).
C	 Note that if we do invert any sides, then we shall need to
C	 sort the list of intersected sides again.
C
C	 Our conditions for type (1) and type (2) are now:
C
C	 for type (1) we have
C			INTSCT(V,I) = INTSCT(V,I+1) = VSLICE
C			both sides have INTSCT(DV,...) of the
C			same sign (both sides have the second
C			point 'below' or 'above' the first)
C
C	 for type (2) we have
C			INTSCT(V,I) = INTSCT(V,I+1) = VSLICE
C			the sides have INTSCT(DV,...) of a
C			different sign (one side has its second
C			point 'above' the first, the other 'below')
C
C	 we shall thus have a sequence of type (1) and type (2) all
C	 together in the list (since their value of V is the same)
C
C
	   VTERM = .FALSE.		! no sides ending on VSLICE yet
	   VSORT = .FALSE.		! thus no need to sort
C
	   DO 540 I = 1,NSCT
	      IF ( INTSCT(2,I) .EQ. VSLICE ) THEN
		 VTERM     = .TRUE.
	      ELSEIF ( INTSCT(2,I)+INTSCT(4,I) .EQ. VSLICE ) THEN
		 INTSCT(1,I)  =  INTSCT(1,I)+INTSCT(3,I)
		 INTSCT(2,I)  =  INTSCT(2,I)+INTSCT(4,I)
		 INTSCT(3,I) = -INTSCT(3,I)
		 INTSCT(4,I) = -INTSCT(4,I)
		 VTERM     = .TRUE.
		 VSORT     = .TRUE.	! necessitates a re-sort
	      ENDIF
540	   CONTINUE
C
C	    so, do we have to deal with special cases?
C
	   IF ( VTERM ) THEN
C
	      IF (VSORT) THEN
		 CALL HEAP_SORT(INTSCT,NSCT,CF_SIDE,COPY_SIDE,STORE)
	      ENDIF
C
C	       we intend to copy all the required sides back into
C	       INTSCT...
C
	      I = 0
	      J = 0
C
544	      IF ( I.GE.NSCT ) GOTO 546		! finished all sides
	      I = I+1				! next side
C
	      IF ( INTSCT(2,I).NE.VSLICE ) THEN	! an ordinary side
C
C	       for an ordinary side, we simply copy it over
C
		 J = J+1
		 CALL COPY_SIDE( INTSCT, I, INTSCT, J )
C
	      ELSEIF ( SIGN(1.0,INTSCT(4,I)) .NE.
     &		       SIGN(1.0,INTSCT(4,I+1))  ) THEN
C
C	       for case 2, we ignore one of the sides, and
C	       copy the other
C
		 I = I+1		! copy the second side only
		 J = J+1
		 CALL COPY_SIDE( INTSCT, I, INTSCT, J )
C
	      ELSE
C
C	       for case 1, we ignore both of the sides
C
		 I = I+1
C
	      ENDIF
	      GOTO 544			! inspect the next side
C
C	    we now have a new number of sides in our list
C
546	      NSCT = J
C
	   ENDIF
C
C	 does that leave us with anything to do?
C
C not sure whether this can happen as a matter of routine
	   IF ( NSCT.EQ.0 ) THEN		! ignore it
	      CALL TTWSTR('No intersections with profile')
	      DO_PREP = .FALSE.
	      GOTO 9999
	   ENDIF
C
C	 so we can now work out the actual intersections
C
	   DO 550 I = 1,NSCT
C
C	    calculate the 'height' at which VSLICE intersects
C	    this side
C
	      ALPHA = (VSLICE-INTSCT(2,I)) / INTSCT(4,I)
C
C	    and now calculate the actual intersection position
C
	      INTPTS(I) =  INTSCT(1,I)*(1-ALPHA) +
     &			  (INTSCT(1,I)+INTSCT(3,I))*ALPHA
550	   CONTINUE
C
C	 sort the list of intersections into order
C
	   CALL HEAP_SORT( INTPTS, NSCT, CF_REAL, COPY_REAL, STORE )
C
C	 check that we now have an even number of intersections
C	 (we always should have by now)
C
	   IF ( (NSCT.AND.1).EQ.1 ) THEN
	      CALL TTWSTR('Odd number of intersections')
	      DO_PREP = .FALSE.
	      GOTO 9999
	   ENDIF
C
	ENDIF
C
C get first intersection point
	PSTART(1) = INTPTS(1)
	PSTART(2) = VSLICE
	PSTART(3) = COEFFS(1)*PSTART(1) + COEFFS(2)*PSTART(2) + COEFFS(3)
	IF (PROFANG.NE.0.0) CALL FILL_ROTATE(
     &				PROFANG,PSTART(1),PSTART(2))
C
	DO_PREP = .TRUE.
C
9999	RETURN
	END
