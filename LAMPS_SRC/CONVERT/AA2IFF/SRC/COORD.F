	SUBROUTINE COORD( X, Y, Z )
CDEC$	IDENT	'11AP91'
C
C Copyright (C) Laser-Scan Ltd, Cambridge, England
C
C	Created					JMC	12-Jan-1990
C	Mod					JB	11-Apr-1991
C
C	CONVERT AA2IFF Utility
C
C Description 
C
C Add coordinate points to the output list 
C
	IMPLICIT NONE
C
C arguments
C
	REAL*8		X	! X coordinate
	REAL*8		Y	! Y coordinate
	REAL*8		Z	! Z coordinate
C
C common blocks
C
	INCLUDE	'CMN:IFF.CMN'	
C
C local variables
C
	REAL*4	XNEW, YNEW ,ZNEW	! co-ords relative to new origin
C
C *********************************************************************
C do we have room for this point?
C
	IF ( ZSPTR.GE.200 ) CALL FLUSH
C
C subtract the origin offset
C
	XNEW = X - XOFF
	YNEW = Y - YOFF
	ZNEW = Z - ZOFF
C
C Use first coordinate to start off the range
C
	IF (.NOT.HAD_RANGE_SET) THEN
	   RANGE(X_MIN) = XNEW
	   RANGE(X_MAX) = XNEW
	   RANGE(Y_MIN) = YNEW
	   RANGE(Y_MAX) = YNEW
C
	   HAD_RANGE_SET = .TRUE.
	ENDIF
C
C so we can now add this new point to our output list
C
	ZSPTR = ZSPTR+1
C
	ZSBUF(1,ZSPTR) = XNEW
	ZSBUF(2,ZSPTR) = YNEW
	ZSBUF(3,ZSPTR) = ZNEW
C
C and check the range
C
	IF (XNEW.GT.RANGE(X_MAX)) THEN
	   RANGE(X_MAX) = XNEW
	ELSEIF (XNEW.LT.RANGE(X_MIN)) THEN
	   RANGE(X_MIN) = XNEW
	ENDIF
C
	IF (YNEW.GT.RANGE(Y_MAX)) THEN
	   RANGE(Y_MAX) = YNEW
	ELSEIF (YNEW.LT.RANGE(Y_MIN)) THEN
	   RANGE(Y_MIN) = YNEW
	ENDIF
C
C that's all
C
999	RETURN
	END
C
