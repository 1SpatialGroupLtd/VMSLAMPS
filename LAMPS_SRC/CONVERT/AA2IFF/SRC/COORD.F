	SUBROUTINE 	COORD( X,Y )
C
CDEC$	IDENT	'15NO89'
C
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created			9-Nov-1989			A.P.Brown
C
C Description:
C
C	Put coordinates into STBUF buffer
C
	IMPLICIT	NONE
C
C arguments
C
	REAL		X	! X coordinate
	REAL		Y	! Y coordinate
C
C common blocks
C
	INCLUDE	'CMN:IFF.CMN'	
C
C local variables
C
	REAL*4	XNEW, YNEW	! co-ords relative to new origin
C
C *********************************************************************
C do we have room for this point?
C
	IF ( STPTR.GE.200 ) CALL FLUSH
C
C subtract the origin offset
C
	XNEW = X - XOFF
	YNEW = Y - YOFF
C
C check if this point is the first, and if not if it is the same
C as the last one - we don't want to duplicate points
C
	IF (DONE_ST .OR. (STPTR.GT.0)) THEN
	   IF (XNEW.EQ.STBUF(1,STPTR).AND.YNEW.EQ.STBUF(2,STPTR)) 
     &		GO TO 999
	ENDIF
C
C so we can now add this new point to our output list
C
	STPTR = STPTR+1
	STBUF(1,STPTR) = XNEW
	STBUF(2,STPTR) = YNEW
C
C and check the range
C
	IF ( STBUF(1,STPTR).GT.RANGE(X_MAX) ) 
     &				RANGE(X_MAX) = STBUF(1,STPTR)
	IF ( STBUF(1,STPTR).LT.RANGE(X_MIN) ) 
     &				RANGE(X_MIN) = STBUF(1,STPTR)
	IF ( STBUF(2,STPTR).GT.RANGE(Y_MAX) ) 
     &				RANGE(Y_MAX) = STBUF(2,STPTR)
	IF ( STBUF(2,STPTR).LT.RANGE(Y_MIN) ) 
     &				RANGE(Y_MIN) = STBUF(2,STPTR)
C
C that's all
C
999	RETURN
	END
