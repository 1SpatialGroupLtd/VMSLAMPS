	SUBROUTINE	RETAIN_FLAGS(START_POS_IN_LIST)
C
CDEC$	IDENT	'23SE94'
C
C	Copyright (C)			Laser-Scan Ltd., Cambridge
C
C       Author				Steve Townrow	19-Aug-1994
C
C Description:
C       This routine goes through the output points array and identifies
C       which points are from the original input line and which are
C       interpolated. Original ones are given the corresponding Z values
C       and per-point attributes. Interpolated points are given an 'I' in
C       the curve flag AC and if the previous master point is a high or low
C       priority flag, each interpolated point will be given the same.
C
	IMPLICIT	NONE
C
C Arguments
C
	INTEGER*4	START_POS_IN_LIST
C
C common blocks
C
	INCLUDE 'CMN:LINES.CMN'
	INCLUDE 'CMN:IFF.CMN'
C
C workspace
C
	INTEGER*4	I,J,PREV_FLAG
C
C------------------------------------------------------------------------------
C
C Let us go through the list
C
	I = 1
	DO 10 J = START_POS_IN_LIST,NUM_OUT
C
C Check each output point to see if it is a master point and
C if it is, copy its flags over.
C
	   IF ((LINE_OUT(1,J).EQ.LINE_IN(1,I)).AND.
     &	       (LINE_OUT(2,J).EQ.LINE_IN(2,I)).OR.J.EQ.1) THEN
	      LINE_OUT_FLAGS(J) = LINE_IN_FLAGS(I)
	      LINE_OUT_Z(J) = LINE_IN_Z(I)
	      PREV_FLAG = LINE_IN_FLAGS(I).AND.'0003'X  ! only care about H & L
	      I = I + 1
	   ELSE
C
C The point is an interpolated one which we should flag as such so that
C I2MAPDATA can throw them away.
C
	      LINE_OUT_FLAGS(J) = LINE_OUT_FLAGS(J).OR.'0008'X
	      IF ((PREV_FLAG.AND.'0002'X).EQ.2) THEN
		 LINE_OUT_FLAGS(J) = LINE_OUT_FLAGS(J).OR.'0002'X
	      ENDIF
	      IF ((PREV_FLAG.AND.'0001'X).EQ.1) THEN
		 LINE_OUT_FLAGS(J) = LINE_OUT_FLAGS(J).OR.'0001'X
	      ENDIF
	      LINE_OUT_Z(J) = 0.0
C
	   ENDIF
10	CONTINUE
C
C------------------------------------------------------------------------------
C and that's it
C
	RETURN
	END
C
