	LOGICAL FUNCTION OUTPTS
C
CDEC$	IDENT	'23SE94'
C
C	Copyright (C)			Laser-Scan Ltd., Cambridge
C
C       Author				Steve Townrow	26-Jul-1994
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
	INTEGER*4	J,START_POS_IN_LIST
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
C Give the flags to the right points
C
	   CALL RETAIN_FLAGS(START_POS_IN_LIST)
	ELSE
C
C Otherwise, copy them over unaltered
C
	   DO 10 J = 1,NUM_IN
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
10	   CONTINUE
	ENDIF
C
C and that's it
C
999	RETURN
	END
C
