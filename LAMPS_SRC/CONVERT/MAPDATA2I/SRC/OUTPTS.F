C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-10-31 11:14:44.000000000 +0000
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
	LOGICAL FUNCTION OUTPTS
C
CDEC$	IDENT	'31OC94'
C
C	Copyright (C)			Laser-Scan Ltd., Cambridge
C
C       Author				Steve Townrow	26-Jul-1994
C
C       Mod 1415. Calls SHUFFLE_POINTS		31-Oct-1994	Steve Townrow
C
C Description:
C       This routine is called from PROCESS_LINE and uses the points in
C       LINE_IN and calls the AKIMA interpolation which sticks them into
C       LINE_OUT (using ADDPTS) or just copies the points over unchanged
C       if there weren't enough for smoothing or the smoothing option is
C       not on for this feature.
C       After smoothing the LINE_OUT array the routine RETAIN_FLAGS is
C       used to match the Z and attributes of the output array from the
C       input array. This is necessary as the COORDLIB routine which does
C       the smoothing will only take 2D arrays, not one with per-point atts.
C
C
	IMPLICIT	NONE
C
C common blocks
C
	INCLUDE 'CMN:LINES.CMN'
	INCLUDE 'CMN:FILE.CMN'
	INCLUDE 'CMN:IFF.CMN'
C
C External Subroutines
C
	INTEGER*4	AKIMA		! Akima curve interpolation 
	EXTERNAL	AKIMA
C
C Functions
C
	LOGICAL		OVER_LIMIT	! Check if we overflow our buffer
C
C workspace
C
	INTEGER*4	J
	INTEGER*4	START_POS_IN_LIST
	LOGICAL		LOOP
C
C------------------------------------------------------------------------------
C
	OUTPTS = .TRUE.
C
C Smooth the line if necessary.
C
	IF (NUM_IN.GE.3 .AND. INTERP(FC_INDEX).EQ.INTERP_STRAIGHT) THEN
	   START_POS_IN_LIST = NUM_OUT + 1
	   LOOP = ((LINE_IN(1,1).EQ.LINE_IN(1,NUM_IN)) .AND.
     &		   (LINE_IN(2,1).EQ.LINE_IN(2,NUM_IN)))
	   CALL INTRPL(NUM_IN,LINE_IN,.TRUE.,.TRUE.,LOOP,.TRUE.,AKIMA)
C
C Check that the interpolation didn't add more points than we can hold
C
	   OUTPTS = .NOT.OVER_LIMIT(NUM_OUT)
	   IF (.NOT.OUTPTS) GOTO 999	   
C
C Move the points around so that the first of the output is the same as
C the first of the input. This applies to looped features only since the
C output points start with the third input point
C
	   IF (LOOP) CALL SHUFFLE_POINTS()
C
C Give the flags to the right points
C
	   CALL RETAIN_FLAGS(START_POS_IN_LIST)
	ELSE
C
C Otherwise, copy them over unaltered
C
	   DO 100 J = 1,NUM_IN
	      NUM_OUT = NUM_OUT + 1
C
C Check for overflow
C
	      OUTPTS = .NOT.OVER_LIMIT(NUM_OUT)
	      IF (.NOT.OUTPTS) GOTO 999
	      LINE_OUT(1,NUM_OUT) = LINE_IN(1,J)
	      LINE_OUT(2,NUM_OUT) = LINE_IN(2,J)
	      LINE_OUT_Z(NUM_OUT) = LINE_IN_Z(J)
	      LINE_OUT_FLAGS(NUM_OUT) = LINE_IN_FLAGS(J)
100	   CONTINUE
	ENDIF
C
C and that's it
C
999	RETURN
	END
C
