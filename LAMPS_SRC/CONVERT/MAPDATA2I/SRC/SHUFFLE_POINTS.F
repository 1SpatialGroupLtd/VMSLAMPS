	SUBROUTINE	SHUFFLE_POINTS()
C
CDEC$	IDENT	'25OC94'
C
C	Copyright (C)			Laser-Scan Ltd., Cambridge
C
C       Author				Steve Townrow	25-Oct-1994
C
C Description:
C
C       The COORDLIB routine INTRPL returns the output smoothed points in
C       the array LINE_OUT. OUTPTS then has to check each point in the output
C       array against the input points to assign the correct flags to the
C       output points. When the feature is closed, the output points come out
C       starting with the third input point and so RETAIN_FLAGS gets all out
C       of step and assigns I flags to most of the points (this was identified
C       because I2MAPDATA threw away these points which were valid.)
C       
C       This routine therefore, shuffles the points around so that the first
C       output point is the same as the first input point. The added
C       complication is that the first input point can be found near the end
C       of the output array but may be anywhere due to the new interpolated
C       points. We therefore should search backwards throught the output list
C       until we find this point and copy from there onwards into a temporary
C       buffer. The rest should then be copied and then finally the temporary
C       buffer replaces the points in LINE_OUT.

	IMPLICIT	NONE
C
C common blocks
C
	INCLUDE 'CMN:LINES.CMN'
	INCLUDE 'CMN:IFF.CMN'
C
C workspace
C
	REAL*4		TMP(2,MAXPTS)		! output line string
	INTEGER*4	J,COUNT
	INTEGER*4	FIRSTPT
C
C------------------------------------------------------------------------------
C Find the first input point in the output array, searching backwards so we
C don't find a wrong point.
C
	FIRSTPT = 1
	DO 10 J = NUM_OUT,1,-1
	   IF ((LINE_IN(1,1).EQ.LINE_OUT(1,J)) .AND.
     &		(LINE_IN(2,1).EQ.LINE_OUT(2,J))) THEN
	      FIRSTPT = J
	      GOTO 15
	   ENDIF
10	CONTINUE
C
C Now we copy from that first point to the end of the output array into a
C temporary buffer.
C
15	COUNT = 0
	DO 20 J = FIRSTPT,NUM_OUT
	   COUNT = COUNT + 1
	   TMP(1,COUNT) = LINE_OUT(1,J)
	   TMP(2,COUNT) = LINE_OUT(2,J)
20	CONTINUE
C
C If no points copied, copy the first as the following loop starts at 2.
C
	IF (COUNT.EQ.0) THEN
	   COUNT = 1
	   TMP(1,COUNT) = LINE_OUT(1,1)
	   TMP(2,COUNT) = LINE_OUT(2,1)
	ENDIF
C
C If there are still points to copy over...
C
	IF (COUNT.LT.NUM_OUT) THEN
C
C The first point is the same as the last in looped features so start copying
C the features across to the temp buffer starting from the second.
C
	   DO 30 J = 2,NUM_OUT-COUNT+1
	      COUNT = COUNT + 1
	      TMP(1,COUNT) = LINE_OUT(1,J)
	      TMP(2,COUNT) = LINE_OUT(2,J)
30	   CONTINUE
	ENDIF
C
C Copy re-ordered array back and overwrite LINE_OUT
C
	DO 40 J = 1,NUM_OUT
	   LINE_OUT(1,J) = TMP(1,J)
	   LINE_OUT(2,J) = TMP(2,J)
40	CONTINUE
C
C------------------------------------------------------------------------------
C and that's it
C
	RETURN
	END
C
