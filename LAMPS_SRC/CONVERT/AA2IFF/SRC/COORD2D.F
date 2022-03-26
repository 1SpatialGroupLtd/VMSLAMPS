	SUBROUTINE COORD2D(X,Y)
CDEC$	IDENT	'17AP91'
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
	REAL*8		X	! X coordinate
	REAL*8		Y	! Y coordinate
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
C subtract the origin offset
C
	XNEW = X - XOFF
	YNEW = Y - YOFF
C
C Set up range
C
	IF (.NOT.HAD_RANGE_SET) THEN
	   RANGE(X_MIN) = XNEW
	   RANGE(X_MAX) = XNEW
	   RANGE(Y_MIN) = YNEW
	   RANGE(Y_MAX) = YNEW
	   HAD_RANGE_SET = .TRUE.
	ENDIF
C
C so we can now add this new point to our output list
C
	STBUF(1) = XNEW
	STBUF(2) = YNEW
C
C and check the range
C
	IF (STBUF(1).GT.RANGE(X_MAX)) THEN
	   RANGE(X_MAX) = STBUF(1)
	ELSEIF (STBUF(1).LT.RANGE(X_MIN)) THEN
	   RANGE(X_MIN) = STBUF(1)
	ENDIF
C
	IF (STBUF(2).GT.RANGE(Y_MAX)) THEN
	   RANGE(Y_MAX) = STBUF(2)
	ELSEIF (STBUF(2).LT.RANGE(Y_MIN)) THEN
	   RANGE(Y_MIN) = STBUF(2)
	ENDIF
C
C that's all
C
999	RETURN
	END
C
